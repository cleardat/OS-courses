/***********************************************************************************
 * 任意大小内存单元slub分配算法设计文档
 * 适用场景：ucore 操作系统实验 lab2 物理内存管理模块
 ***********************************************************************************
一、设计目标
本实现是一个极简版的 SLUB（Slab Allocator），旨在在现有 buddy system 的基础上，提供高效的小对象分配机制。
目标：
1、减少频繁向 buddy 申请页的开销；
2、在页内进行固定大小对象分配；
3、保持实现简单，便于测试与教学；
4、大对象仍走 buddy system。

二、总体结构
系统中共有两层分配机制：
层级	|说明	|分配粒度	|对应函数
SLUB 层 |管理小对象（≤ SLUB_OBJ_SIZE）	|固定槽位（如 256B）	|slub_alloc / slub_free
Buddy 层|管理页级及以上的内存           |页（4KB）	            |alloc_pages / free_pages

当用户通过 kmalloc(size) 申请内存时：
1、若 size ≤ SLUB_OBJ_SIZE，走 SLUB；
2、若 size > SLUB_OBJ_SIZE，走 Buddy；
3、kfree() 自动识别来源（SLUB 或 Buddy）。

三、主要数据结构
1. Slab
每个 slab 对应一页内存，包含若干固定大小对象槽位。
typedef struct Slab {
    list_entry_t link;    // 链入全局 slab_list
    struct Page *page;    // 对应页
    size_t free_cnt;      // 当前空闲对象数量
    size_t objs;          // 总对象数量
    unsigned magic;       // 用于检测 slab 有效性
} slab_t;

页内布局：
| slab_t头(结构体) | 对象区(Object[]) | 位图(bitmap[]) |
                    
2. BigAllocHeader
用于标识超过 SLUB 阈值的大块分配（页路径）。
typedef struct BigAllocHeader {
    uint32_t magic;       // 用于识别
    uint32_t npages;      // 占用页数
    struct Page *first;   // 首页指针
} BigAllocHeader;

四、关键参数
1、SLUB_OBJ_SIZE：SLUB 管理的对象大小
2、SLUB_ALIGN：对齐粒度（16B）
3、SLUB_MAGIC：slab校验
4、BIG_MAGIC：大块页分配

五、内存布局与对齐
1、页首放slab_t
2、对象区起始于sizeof(slab_t)之后
3、位图放在页末
4、对象区按SLUB_ALIGN对齐
5、每个对象大小固定为SLUB_OBJ_SIZE
6、页内对象数由 compute_objs_per_slab()自动计算

六、分配与回收流程
1. kmalloc(size)
if (size <= SLUB_OBJ_SIZE)
    return slub_alloc(size);
else
    return buddy 分配 (多页)；
超过 SLUB 阈值的对象由 buddy system 提供整页分配。

2. slub_alloc(size)
遍历 slab_list；找到 free_cnt > 0 的 slab；使用位图分配一个空槽；若找不到，则通过 new_slab() 新建 slab；返回对象指针。

3. slub_free(obj)
根据对象地址找到所在页（页对齐运算）；验证页首 slab_t.magic；清除对应位图 bit；若 slab 全空，则回收整页给 buddy。

4. kfree(ptr)
判断指针是否带有 BigAllocHeader.magic == BIG_MAGIC；若是 → 释放整页；否则 → 调用 slub_free()。

七、自检机制
1、slub_selftest() 自动验证
2、小对象分配（≤ SLUB_OBJ_SIZE）
3、多对象在同一页的分布
4、超过 SLUB 阈值的对象走页路径
5、页对齐校验
6、SLUB 与 buddy 地址区分验证
7、全部通过后打印
*/

// slub.c
#include <pmm.h>
#include <list.h>
#include <string.h>
#include <stdio.h>
#include <slub.h>

// ------- 可调参数（保持极简） -------
#define SLUB_OBJ_SIZE  256u      // 仅一个尺寸类：64B
#define SLUB_ALIGN     16u      // 接口对齐：向上取 16B
#define SLUB_MAGIC     0x51ab51ab

typedef struct BigAllocHeader {
    uint32_t magic;
    uint32_t npages;
    struct Page *first;
} __attribute__((packed)) BigAllocHeader;

typedef struct Slab {
    list_entry_t link;          // 链到全局 slab_list
    struct Page *page;          // 后端页（来自 buddy）
    size_t       free_cnt;      // slab 内空闲对象个数
    size_t       objs;          // slab 内总对象个数
    unsigned     magic;         // 简单校验
    // 页内布局： [Slab 头][对象区][位图]
} slab_t;

// 全局：一个链表管理所有 slab（不区分 partial/full，够用了）
static list_entry_t slab_list;

#ifndef le2slab
#define le2slab(le) to_struct((le), slab_t, link)
#endif

static inline void *page_kva(struct Page *p) { return KADDR(page2pa(p)); }
static inline size_t align_up(size_t x, size_t a) { return (x + a - 1) & ~(a - 1); }
#define BIG_MAGIC 0xB16B00B5u
static inline size_t ceil_div(size_t x, size_t y) { return (x + y - 1) / y; }

void *kmalloc(size_t size) {
    if (size == 0) return NULL;

    // 1) 小于等于 SLUB 的单位：交给 SLUB
    if (size <= SLUB_OBJ_SIZE) {
        return slub_alloc(size);
    }

    // 2) 超过 SLUB：按页（buddy），可能是多页
    size_t need   = size + sizeof(BigAllocHeader);
    size_t npages = ceil_div(need, PGSIZE);

    struct Page *pg = alloc_pages(npages);
    if (!pg) return NULL;

    void *kva = KADDR(page2pa(pg));
    BigAllocHeader *h = (BigAllocHeader *)kva;
    h->magic  = BIG_MAGIC;
    h->npages = (uint32_t)npages;
    h->first  = pg;

    return (void *)(h + 1);        // 用户区从头部后面开始
}

void *kzmalloc(size_t size) {
    void *p = kmalloc(size);
    if (p) memset(p, 0, size);
    return p;
}

void kfree(void *ptr) {
    if (!ptr) return;

    // 先尝试按“页分配”路径释放
    BigAllocHeader *h = (BigAllocHeader *)((char *)ptr - sizeof(BigAllocHeader));
    if (h->magic == BIG_MAGIC && h->first && h->npages > 0) {
        free_pages(h->first, h->npages);
        return;
    }
    // 否则当作 SLUB 小对象
    slub_free(ptr);
}
// 计算一个 slab（1页）最多容纳多少个对象（考虑位图和头部开销）
static size_t compute_objs_per_slab(void) {
    size_t max_objs = (PGSIZE - sizeof(slab_t)) / SLUB_OBJ_SIZE;
    while (max_objs) {
        size_t bitmap_bytes = (max_objs + 7) / 8;
        size_t need = sizeof(slab_t) + SLUB_OBJ_SIZE * max_objs + bitmap_bytes;
        if (need <= PGSIZE) return max_objs;
        max_objs--;
    }
    return 0;
}

static inline char *slab_objs_base(slab_t *s) {
    return (char *)s + sizeof(slab_t);
}

static inline unsigned char *slab_bitmap(slab_t *s) {
    return (unsigned char *)(slab_objs_base(s) + s->objs * SLUB_OBJ_SIZE);
}

static slab_t *new_slab(void) {
    struct Page *pg = alloc_pages(1);          // 用 buddy 分一页
    if (!pg) return NULL;
    void *kva = page_kva(pg);
    memset(kva, 0, PGSIZE);

    slab_t *s = (slab_t *)kva;
    list_init(&s->link);
    s->page     = pg;
    s->objs     = compute_objs_per_slab();
    s->free_cnt = s->objs;
    s->magic    = SLUB_MAGIC;

    memset(slab_bitmap(s), 0, (s->objs + 7) / 8);
    list_add(&slab_list, &s->link);
    return s;
}

static void *slab_alloc_from(slab_t *s) {
    unsigned char *bm = slab_bitmap(s);
    for (size_t i = 0; i < s->objs; i++) {
        size_t byte = i >> 3, bit = (size_t)1 << (i & 7);
        if ((bm[byte] & bit) == 0) {
            bm[byte] |= bit;
            s->free_cnt--;
            return slab_objs_base(s) + i * SLUB_OBJ_SIZE;
        }
    }
    return NULL;
}

static void slab_free_to(slab_t *s, void *obj) {
    size_t off = (size_t)((char *)obj - slab_objs_base(s));
    size_t idx = off / SLUB_OBJ_SIZE;
    unsigned char *bm = slab_bitmap(s);
    size_t byte = idx >> 3, bit = (size_t)1 << (idx & 7);
    bm[byte] &= (unsigned char)~bit;
    s->free_cnt++;
}

void slub_init(void) {
    list_init(&slab_list);
    cprintf("SLUB(mini): obj=%uB, align=%uB\n", SLUB_OBJ_SIZE, SLUB_ALIGN);
}

void *slub_alloc(size_t size) {
    if (size == 0 || size > SLUB_OBJ_SIZE) return NULL;
    (void)align_up(size, SLUB_ALIGN);          // 目前只有 64B 类，按 16B 对齐检查即可

    // 1) 在现有 slab 中找空闲
    list_entry_t *le = &slab_list;
    while ((le = list_next(le)) != &slab_list) {
        slab_t *s = le2slab(le);
        if (s->free_cnt == 0) continue;
        void *p = slab_alloc_from(s);
        if (p != NULL) return p;
    }
    // 2) 新建 slab
    slab_t *s = new_slab();
    if (!s) return NULL;
    return slab_alloc_from(s);                  // 新 slab 第一次分配一定成功
}

void slub_free(void *obj) {
    if (!obj) return;
    // 通过“页对齐”直接定位 slab 头，避免全表扫描
    void *kva_base = (void *)((uintptr_t)obj & ~(PGSIZE - 1));
    slab_t *s = (slab_t *)kva_base;

    // 简单健壮性检查
    if (s->magic != SLUB_MAGIC) {
        cprintf("slub_free: bad obj %p (magic)\n", obj);
        return;
    }
    // 边界检查（保证 obj 落在对象区内、且是 64B 对齐）
    char *base = slab_objs_base(s);
    size_t off = (size_t)((char *)obj - base);
    if (off >= s->objs * SLUB_OBJ_SIZE || (off % SLUB_OBJ_SIZE) != 0) {
        cprintf("slub_free: bad obj %p (range/alignment)\n", obj);
        return;
    }

    slab_free_to(s, obj);

    // slab 全空时直接归还整页
    if (s->free_cnt == s->objs) {
        list_del(&s->link);
        free_pages(s->page, 1);                // 归还给 buddy
    }
}

// 极简自检（只做非常小的申请）
void slub_selftest(void) {
    cprintf("\n[slub_selftest] begin\n");

    // A. ≤ SLUB 阈值：应走 SLUB，一个页内对象 1 个槽位
    void *a = slub_alloc(8);
    void *b = slub_alloc(SLUB_OBJ_SIZE / 4);
    void *c = slub_alloc(SLUB_OBJ_SIZE / 2);

    
    void *d = slub_alloc(SLUB_OBJ_SIZE);
    assert(a && b && c && d);
    cprintf("SLUB: a=%p b=%p c=%p d=%p\n", a,b,c,d);

   size_t over = SLUB_OBJ_SIZE + 1;
void *x = kmalloc(over);
assert(x != NULL);

// 2) 还原页起始（KVA）并做“页对齐”断言
uintptr_t page_kva = (uintptr_t)x - sizeof(struct BigAllocHeader);
assert((page_kva & (PGSIZE - 1)) == 0);

// 3) 明确它不是 SLUB 的那一页（比较页号）
uintptr_t slab_page = (uintptr_t)a & ~(PGSIZE - 1);   // a 来自 SLUB 的 slab
assert(page_kva != slab_page);

// 4) 读取头部，验证“确实是页路径”以及“页数>=1”
struct BigAllocHeader *h = (struct BigAllocHeader *)page_kva;
assert(h->magic == 0xB16B00B5u && h->first && h->npages >= 1);

// 可选：打印确认
cprintf("[proof] kmalloc>SLUB: user=%p page_kva=%p npages=%u (slab_page=%p)\n",
        x, (void*)page_kva, h->npages, (void*)slab_page);

kfree(x);
    // 收尾
    slub_free(a); slub_free(c); slub_free(d);

    cprintf("[slub_selftest] ok\n\n");
}


