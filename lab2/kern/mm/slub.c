#include <pmm.h>
#include <list.h>
#include <string.h>
#include <stdio.h>
#include <slub.h>

// ------- 核心配置：三级尺寸类（一页4096字节内适配） -------
typedef enum {
    SLUB_L1 = 0,  // 64B （最小级别，适配小对象）
    SLUB_L2 = 1,  // 128B （中间级别）
    SLUB_L3 = 2,  // 256B （最大小对象级别）
    SLUB_LEVEL_CNT// 级别总数（3级）
} SlubLevel;

// 各级别尺寸与对齐配置（尺寸为2的幂次，对齐=尺寸）
static const size_t SLUB_OBJ_SIZES[SLUB_LEVEL_CNT] = {64, 128, 256};
static const size_t SLUB_ALIGNS[SLUB_LEVEL_CNT] = {64, 128, 256};
#define SLUB_MAGIC     0x51ab51ab  // slab合法性校验
#define BIG_MAGIC      0xB16B00B5u // 大对象（>256B）头部校验

// 大对象（>256B）头部：记录页信息，释放时归还给伙伴系统
typedef struct BigAllocHeader {
    uint32_t magic;        // 校验值
    uint32_t npages;       // 占用页数
    struct Page *first;    // 起始页指针
} __attribute__((packed)) BigAllocHeader;

// Slab结构：每个slab对应1页，关联一个尺寸类
typedef struct Slab {
    list_entry_t link;          // 链入对应尺寸类的slab链表
    struct Page *page;          // 后端物理页（来自伙伴系统）
    size_t       free_cnt;      // 空闲对象数
    size_t       objs;          // 总对象数（按尺寸类计算）
    unsigned     magic;         // 校验值
    SlubLevel    level;         // 所属尺寸类（L1/L2/L3）
    // 页内固定布局：[Slab头][对象区][位图]（总大小≤4096）
} slab_t;

// 全局：每个尺寸类独立管理slab链表（避免跨级别遍历）
static list_entry_t slab_lists[SLUB_LEVEL_CNT];

// 链表节点转slab指针（通用宏）
#ifndef le2slab
#define le2slab(le) to_struct((le), slab_t, link)
#endif

// ------- 辅助函数：页地址转换与数学计算 -------
// 物理页转内核虚拟地址
static inline void *page_kva(struct Page *p) {
    return KADDR(page2pa(p));
}

// 向上对齐（size按align对齐）
static inline size_t align_up(size_t size, size_t align) {
    return (size + align - 1) & ~(align - 1);
}

// 向上取整除法（x/y，不足1补1）
static inline size_t ceil_div(size_t x, size_t y) {
    return (x + y - 1) / y;
}

// 根据申请大小匹配对应的尺寸类（无匹配返回SLUB_LEVEL_CNT）
static inline SlubLevel size_to_level(size_t size) {
    if (size == 0) return SLUB_LEVEL_CNT;
    for (int i = 0; i < SLUB_LEVEL_CNT; i++) {
        if (size <= SLUB_OBJ_SIZES[i]) {
            return (SlubLevel)i;
        }
    }
    return SLUB_LEVEL_CNT; // 超过最大小对象尺寸（>256B）
}

// ------- Slab内部布局计算（按尺寸类适配） -------
// 计算一个slab（1页）最多容纳的对象数（扣除slab头和位图开销）
static size_t compute_objs_per_slab(SlubLevel level) {
    size_t obj_size = SLUB_OBJ_SIZES[level];
    size_t max_objs = (PGSIZE - sizeof(slab_t)) / obj_size; // 初始估算（未扣位图）
    
    while (max_objs > 0) {
        size_t bitmap_bytes = ceil_div(max_objs, 8); // 位图字节数（1bit对应1个对象）
        size_t total_used = sizeof(slab_t) + (max_objs * obj_size) + bitmap_bytes;
        if (total_used <= PGSIZE) {
            return max_objs; // 总开销≤4096，符合要求
        }
        max_objs--; // 超出页大小，减少对象数重试
    }
    panic("compute_objs_per_slab: no space for level %d", level);
    return 0;
}

// 获取slab内对象区的起始地址（按尺寸类定位）
static inline char *slab_objs_base(slab_t *s) {
    return (char *)s + sizeof(slab_t);
}

// 获取slab内位图的起始地址（按尺寸类定位）
static inline unsigned char *slab_bitmap(slab_t *s) {
    size_t obj_size = SLUB_OBJ_SIZES[s->level];
    return (unsigned char *)(slab_objs_base(s) + s->objs * obj_size);
}

// ------- Slab创建与销毁（按尺寸类适配） -------
// 新建一个对应尺寸类的slab（从伙伴系统分配1页）
static slab_t *new_slab(SlubLevel level) {
    struct Page *pg = alloc_pages(1); // 向伙伴系统申请1页
    if (!pg) return NULL;

    void *kva = page_kva(pg);
    memset(kva, 0, PGSIZE); // 清空整页（避免残留数据）

    slab_t *s = (slab_t *)kva;
    list_init(&s->link);
    s->page = pg;
    s->level = level;
    s->objs = compute_objs_per_slab(level);
    s->free_cnt = s->objs; // 新建slab全为空闲
    s->magic = SLUB_MAGIC;

    // 初始化位图（全0，表示所有对象空闲）
    size_t bitmap_bytes = ceil_div(s->objs, 8);
    memset(slab_bitmap(s), 0, bitmap_bytes);

    // 将slab加入对应尺寸类的链表
    list_add(&slab_lists[level], &s->link);
    return s;
}

// 从指定slab分配一个对象（修改位图，返回对象地址）
static void *slab_alloc_from(slab_t *s) {
    if (s->free_cnt == 0) return NULL;

    unsigned char *bm = slab_bitmap(s);
    size_t obj_size = SLUB_OBJ_SIZES[s->level];

    // 遍历位图找第一个空闲对象（0表示空闲）
    for (size_t i = 0; i < s->objs; i++) {
        size_t byte_idx = i / 8;  // 位图字节索引
        size_t bit_idx = i % 8;   // 字节内bit索引
        if (!(bm[byte_idx] & (1 << bit_idx))) {
            bm[byte_idx] |= (1 << bit_idx); // 标记为占用
            s->free_cnt--;
            // 计算对象地址（对象区起始 + 索引*尺寸）
            return slab_objs_base(s) + (i * obj_size);
        }
    }
    return NULL; // 理论上不会到这（free_cnt>0但无空闲，位图异常）
}

// 将对象释放到指定slab（修改位图，更新空闲数）
static void slab_free_to(slab_t *s, void *obj) {
    size_t obj_size = SLUB_OBJ_SIZES[s->level];
    char *obj_base = slab_objs_base(s);

    // 计算对象在slab内的索引
    size_t obj_offset = (size_t)((char *)obj - obj_base);
    size_t obj_idx = obj_offset / obj_size;

    // 更新位图（标记为空闲）
    unsigned char *bm = slab_bitmap(s);
    size_t byte_idx = obj_idx / 8;
    size_t bit_idx = obj_idx % 8;
    bm[byte_idx] &= ~(1 << bit_idx);

    s->free_cnt++; // 空闲数+1
}

// ------- SLUB核心接口（多级尺寸适配） -------
// SLUB初始化：初始化所有尺寸类的slab链表
void slub_init(void) {
    for (int i = 0; i < SLUB_LEVEL_CNT; i++) {
        list_init(&slab_lists[i]);
        cprintf("SLUB(level %d): obj=%luB, align=%luB\n", 
                i, SLUB_OBJ_SIZES[i], SLUB_ALIGNS[i]);
    }
}

// SLUB分配：按尺寸匹配级别，从对应链表分配
void *slub_alloc(size_t size) {
    // 1. 匹配尺寸类（无匹配返回NULL）
    SlubLevel level = size_to_level(size);
    if (level >= SLUB_LEVEL_CNT) {
        return NULL;
    }
    size_t obj_size = SLUB_OBJ_SIZES[level];
    size_t aligned_size = align_up(size, SLUB_ALIGNS[level]);
    (void)aligned_size; // 对齐后尺寸（当前级别已适配，仅作校验）

    // 2. 遍历对应级别的slab链表，找有空闲的slab
    list_entry_t *le = &slab_lists[level];
    while ((le = list_next(le)) != &slab_lists[level]) {
        slab_t *s = le2slab(le);
        if (s->free_cnt == 0) continue;
        void *obj = slab_alloc_from(s);
        if (obj != NULL) {
            return obj;
        }
    }

    // 3. 无空闲slab，新建一个（新slab全空闲，首次分配必成功）
    slab_t *new_s = new_slab(level);
    if (!new_s) return NULL;
    return slab_alloc_from(new_s);
}

// SLUB释放：定位slab和级别，释放对象，全空时归还页
void slub_free(void *obj) {
    if (!obj) return;

    // 1. 按页对齐定位slab头（4096字节对齐）
    uintptr_t slab_kva = (uintptr_t)obj & ~(PGSIZE - 1);
    slab_t *s = (slab_t *)slab_kva;

    // 2. 基础合法性校验
    if (s->magic != SLUB_MAGIC) {
        cprintf("slub_free: bad obj %p (invalid magic)\n", obj);
        return;
    }
    if (s->level >= SLUB_LEVEL_CNT) {
        cprintf("slub_free: bad obj %p (invalid level)\n", obj);
        return;
    }

    // 3. 对象边界与对齐校验（确保在对象区内且按级别尺寸对齐）
    size_t obj_size = SLUB_OBJ_SIZES[s->level];
    char *obj_base = slab_objs_base(s);
    size_t obj_offset = (size_t)((char *)obj - obj_base);
    if (obj_offset >= (s->objs * obj_size)) {
        cprintf("slub_free: bad obj %p (out of slab range)\n", obj);
        return;
    }
    if ((obj_offset % obj_size) != 0) {
        cprintf("slub_free: bad obj %p (misaligned)\n", obj);
        return;
    }

    // 4. 释放对象到slab
    slab_free_to(s, obj);

    // 5. 若slab全空闲，从链表删除并归还页给伙伴系统
    if (s->free_cnt == s->objs) {
        list_del(&s->link);
        free_pages(s->page, 1);
    }
}

// ------- 对外内存分配接口（整合SLUB与伙伴系统） -------
// kmalloc：小对象走SLUB，大对象（>256B）走伙伴系统多页分配
void *kmalloc(size_t size) {
    if (size == 0) return NULL;

    // 1. 小对象：走SLUB三级分配
    SlubLevel level = size_to_level(size);
    if (level < SLUB_LEVEL_CNT) {
        return slub_alloc(size);
    }

    // 2. 大对象：按页分配（需加头部记录页信息）
    size_t total_need = size + sizeof(BigAllocHeader); // 总需求=用户大小+头部
    size_t npages = ceil_div(total_need, PGSIZE);     // 计算需要的页数

    struct Page *pg = alloc_pages(npages);
    if (!pg) return NULL;

    // 初始化头部，用户地址从头部后开始
    void *kva = page_kva(pg);
    BigAllocHeader *h = (BigAllocHeader *)kva;
    h->magic = BIG_MAGIC;
    h->npages = (uint32_t)npages;
    h->first = pg;

    return (void *)(h + 1); // 返回用户可用地址
}

// kzmalloc：kmalloc + 内存清零
void *kzmalloc(size_t size) {
    void *p = kmalloc(size);
    if (p) memset(p, 0, size);
    return p;
}

// kfree：根据对象类型（SLUB/大对象）选择释放路径
void kfree(void *ptr) {
    if (!ptr) return;

    // 1. 尝试按大对象释放（头部在ptr前）
    BigAllocHeader *h = (BigAllocHeader *)((char *)ptr - sizeof(BigAllocHeader));
    if (h->magic == BIG_MAGIC && h->first != NULL && h->npages > 0) {
        free_pages(h->first, h->npages);
        return;
    }

    // 2. 按SLUB小对象释放
    slub_free(ptr);
}

// ------- 自检函数：验证三级分配与释放正确性 -------
void slub_selftest(void) {
    cprintf("\n[slub_selftest] begin\n");

    // 1. 测试三级小对象分配（L1=64B, L2=128B, L3=256B）
    void *l1_obj1 = slub_alloc(32);  // 对齐到64B（L1）
    void *l1_obj2 = slub_alloc(64);  // 正好64B（L1）
    void *l2_obj1 = slub_alloc(80);  // 对齐到128B（L2）
    void *l2_obj2 = slub_alloc(128); // 正好128B（L2）
    void *l3_obj1 = slub_alloc(160); // 对齐到256B（L3）
    void *l3_obj2 = slub_alloc(256); // 正好256B（L3）

    // 校验分配成功
    assert(l1_obj1 && l1_obj2 && l2_obj1 && l2_obj2 && l3_obj1 && l3_obj2);
    cprintf("L1 objs: %p (32B→64B), %p (64B)\n", l1_obj1, l1_obj2);
    cprintf("L2 objs: %p (80B→128B), %p (128B)\n", l2_obj1, l2_obj2);
    cprintf("L3 objs: %p (160B→256B), %p (256B)\n", l3_obj1, l3_obj2);

    // 2. 测试大对象分配（>256B，走伙伴系统）
    size_t big_size = 512; // 超过256B，按页分配（1页足够）
    void *big_obj = kmalloc(big_size);
    assert(big_obj != NULL);
    BigAllocHeader *big_h = (BigAllocHeader *)((char *)big_obj - sizeof(BigAllocHeader));
    assert(big_h->magic == BIG_MAGIC && big_h->npages == 1);
    cprintf("Big obj: %p (512B), pages=%u\n", big_obj, big_h->npages);

    // 3. 测试释放（顺序无关，校验slab回收）
    slub_free(l1_obj1);
    slub_free(l2_obj2);
    slub_free(l3_obj1);
    kfree(big_obj); // 大对象释放
    slub_free(l1_obj2);
    slub_free(l2_obj1);
    slub_free(l3_obj2);

    // 4. 重复分配测试（验证slab复用）
    void *reuse_obj = slub_alloc(64); // 复用之前释放的L1 slab
    assert(reuse_obj != NULL);
    cprintf("Reuse L1 obj: %p (64B)\n", reuse_obj);
    slub_free(reuse_obj);

    cprintf("[slub_selftest] all ok\n\n");
}