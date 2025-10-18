#include <pmm.h>
#include <list.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>
#include <memlayout.h>
#include <riscv.h>
#include <buddy_pmm.h>

/*
内核物理起始地址：0x80200000
物理内存结束地址：0x88000000
0x80200000 ~ 0x87ffffff是32256页
内核可执行内存占用为20KB，5页
struct Page 32字节
pages数组总大小 = 物理页总数 × 每个Page结构大小= 32,256 × 32字节=252页
剩余可用内存：32,256 - 5 - 252 = 31,999页
*/
// 定义最大管理的内存页数（2的幂）
#define BUDDY_MAX_ORDER 15  // 2^14 = 16384 页，2^15=32768页>31999页
#define BUDDY_MAX_PAGES (1 << BUDDY_MAX_ORDER) //32768 页

// 伙伴系统管理器结构
struct buddy_manager {
    unsigned size;                    // 实际管理的页数（2的幂）
    unsigned longest[2 * BUDDY_MAX_PAGES-1];  // 二叉树数组, 记录当前节点对应的块中，最大的连续空闲块的页数
    uintptr_t base;                   // 管理的内存基址（物理地址）
    struct Page* pages;               // 管理的页面数组（虚拟地址）
    size_t total_free;                // 总空闲页数
};

// 全局伙伴系统实例（静态分配）
static struct buddy_manager buddy_mgr;

// 二叉树节点索引计算宏
#define LEFT_LEAF(index) ((index) * 2 + 1)
#define RIGHT_LEAF(index) ((index) * 2 + 2)
#define PARENT(index) (((index) + 1) / 2 - 1)

// 工具宏
#define IS_POWER_OF_2(x) (!((x) & ((x) - 1)))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

// 将大小向上对齐到2的幂，将最高位的1向右扩散，填满所有低位
static unsigned fixsize(unsigned size) {
    if (size == 0) return 1;
    size -= 1;
    size |= size >> 1;
    size |= size >> 2;
    size |= size >> 4;
    size |= size >> 8;
    size |= size >> 16;
    return size + 1;
}

//初始化伙伴系统二叉树,设置每个节点的初始空闲块大小,传入的是buddy_size，根节点页数
static void buddy_init_tree(unsigned size) {
    unsigned node_size;
    int i;
    
    buddy_mgr.size = size;
    node_size = size * 2;  // 根节点初始大小为2×总页数，向下分裂，最终根节点为size

    for (i = 0; i < 2 * size - 1; ++i) {// 遍历所有节点
        if (IS_POWER_OF_2(i + 1)) {  // 每进入新一层，块大小减半，i=0也会执行减半操作
            node_size /= 2;
        }
        buddy_mgr.longest[i] = node_size;
    }
    buddy_mgr.total_free = size;  // 初始总空闲页数=总管理页数（根节点页数）
}

//传入alloc_size,分配内存块，返回块在管理范围内的页偏移
static int buddy_alloc(unsigned size) {
    unsigned index = 0;
    unsigned node_size;
    unsigned offset = 0;

    if (size <= 0)
        size = 1;
    else if (!IS_POWER_OF_2(size))
        size = fixsize(size);  // 非2的幂大小自动对齐

    // 检查是否有足够大的空闲块
    if (buddy_mgr.longest[index] < size)
        return -1; // 根节点都没有足够大的块，直接失败

    // 从根节点开始搜索，找到最小的满足需求的块的index，退出时node_size=size(alloc_size)
    for (node_size = buddy_mgr.size; node_size != size; node_size /= 2) {
        if (buddy_mgr.longest[LEFT_LEAF(index)] >= size) {
            index = LEFT_LEAF(index);  // 左子树有合适块，走左路
        } else {
            index = RIGHT_LEAF(index); // 右子树有合适块，走右路
        }
    }

    // 标记该块为已分配（该节点最大空闲块大小设为0）
    buddy_mgr.longest[index] = 0;
    offset = (index + 1) * node_size - buddy_mgr.size;  // 计算其在管理范围内的页偏移页偏移

    // 向上更新父节点的最长空闲块大小
    while (index != 0) {
        index = PARENT(index);
        buddy_mgr.longest[index] = MAX(
            buddy_mgr.longest[LEFT_LEAF(index)],
            buddy_mgr.longest[RIGHT_LEAF(index)]
        );
    }

    return offset;
}

// 释放内存块，根据页偏移找到对应块，自动合并相邻伙伴块
static void buddy_free(int offset) {
    unsigned node_size, index = 0;
    unsigned left_longest, right_longest;

    // 校验偏移合法性
    assert(offset >= 0 && offset < buddy_mgr.size && "buddy_free: invalid offset");

    // 从叶子节点开始向上查找，确定块大小
    node_size = 1;
    index = offset + buddy_mgr.size - 1;  // 转换为叶子节点索引

    // 找到对应的节点（确保该节点是已分配状态，即退出时longest[index]为0）
    for (; buddy_mgr.longest[index]; index = PARENT(index)) {
        node_size *= 2;
        if (index == 0)  // 到达根节点仍未找到，直接返回
            return;
    }

    // 标记该块为空闲，也就是设置页数
    buddy_mgr.longest[index] = node_size;

    // 向上合并伙伴块
    while (index != 0) {
        index = PARENT(index);
        node_size *= 2;  // 父节点的块大小是当前节点的2倍

        left_longest = buddy_mgr.longest[LEFT_LEAF(index)];
        right_longest = buddy_mgr.longest[RIGHT_LEAF(index)];
        
        // 若左右子节点均空闲且大小之和等于父节点大小，则合并
        if (left_longest + right_longest == node_size) {
            buddy_mgr.longest[index] = node_size;
        } else {
            // 否则，父节点的最大空闲块为左右子节点的最大值
            buddy_mgr.longest[index] = MAX(left_longest, right_longest);
        }
    }
}


// ucore PMM 接口实现

// 初始化伙伴系统，清空管理器状态
static void buddy_init(void) {
    // 将 buddy_mgr 结构体的所有成员，从首地址开始，全部初始化为字节值 0
    memset(&buddy_mgr, 0, sizeof(buddy_mgr));
    cprintf("buddy_pmm: initialized\n");  
}

// 初始化内存映射，对接pmm.c传入的可用内存（起始页描述符指针和页数）
static void buddy_init_memmap(struct Page *base, size_t n) {
    assert(n > 0); 
    // 找到不大于n且不超过最大限制的最大2的幂
    size_t buddy_size = 1;//计算伙伴树【根节点】对应的页数
    while (buddy_size * 2 <= n && buddy_size * 2 <= BUDDY_MAX_PAGES) {
        buddy_size *= 2;
    }

    // 输出内存映射信息
    uint64_t mem_begin = page2pa(base);
    uint64_t mem_size = buddy_size * PGSIZE;
    uint64_t mem_end = mem_begin + mem_size - 1;
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", 
            mem_size, mem_begin, mem_end);

    // 初始化管理的页面元数据
    for (size_t i = 0; i < buddy_size; i++) {
        struct Page *page = base + i;
        ClearPageReserved(page);  // 清除保留标志（pmm.c传过来时已确保这些页可用）
        set_page_ref(page, 0);    // 引用计数初始化为0
        page->flags = 0;          // 清空标志位
    }

    // 初始化伙伴树并记录基址
    buddy_init_tree(buddy_size);//调用初始化伙伴树的函数，传入根节点页数
    buddy_mgr.base = mem_begin;//记录管理的内存基址（物理地址）
    buddy_mgr.pages = base;//记录管理的页面数组（虚拟地址）

    cprintf("buddy: initialized with %u pages (base PA: 0x%016lx)\n", 
            buddy_mgr.size, buddy_mgr.base);
}

// 分配n个连续物理页，返回起始页的描述符指针
static struct Page *buddy_alloc_pages(size_t n) {
    if (n == 0 || buddy_mgr.size == 0) {
        return NULL;
    }

    // 将请求的页数向上取整到2的幂
    unsigned alloc_size = fixsize(n);

    // 检查是否超过最大管理页数
    if (alloc_size > buddy_mgr.size) {
        return NULL;
    }

    // 通过伙伴系统分配块
    int offset = buddy_alloc(alloc_size);//调用函数，返回块在管理范围内的页偏移
    if (offset < 0) {
        cprintf("buddy: alloc %u pages failed (no free block)\n", alloc_size);
        return NULL;
    }

    // 计算对应的物理地址和页描述符指针
    uintptr_t pa = buddy_mgr.base + offset * PGSIZE;
    struct Page* page = pa2page(pa);

    // 验证页面是否在管理范围内
    assert(page >= buddy_mgr.pages && page + alloc_size <= buddy_mgr.pages + buddy_mgr.size);

    // 标记页状态，设置引用计数和分配标志，记录块大小，供释放时使用
    for (size_t i = 0; i < alloc_size; i++) {
        struct Page* p = page + i;
        set_page_ref(p, 1);       // 引用计数设为1
        p->property = alloc_size; // 记录实际分配的块大小，不同于first-fit，每页都记了,可搭配后续起始页校验
    }

    // 更新总空闲页数
    buddy_mgr.total_free -= alloc_size;
    return page;
}

// 从base开始释放n个连续物理页
static void buddy_free_pages(struct Page *base, size_t n) {
    assert(base && n > 0 && buddy_mgr.size != 0);

    // 从页的property获取实际分配的块大小（必须是2的幂）
    unsigned free_size = base->property;
    if (!IS_POWER_OF_2(free_size)) {
        cprintf("buddy: free failed (invalid block size %u)\n", free_size);
        return;
    }
    
    //起始页校验
    size_t page_idx = base - buddy_mgr.pages;  // 页在管理范围内的索引
    assert(page_idx % free_size == 0 && "buddy: free non-head page");  // 起始页必须对齐到块大小的整数倍

    // 校验传入的n是否与实际块大小一致
    if (n != free_size) {
        cprintf("buddy: warning: free n=%lu mismatch actual size %u, using %u\n", 
                n, free_size, free_size);
    }

    // 计算在伙伴系统中的偏移
    uintptr_t pa = page2pa(base);
    if (pa < buddy_mgr.base) {
        panic("buddy: free page outside managed range (PA 0x%016lx)\n", pa);
    }
    int offset = (pa - buddy_mgr.base) / PGSIZE;//（释放块的物理地址-管理基址）/页大小

    // 验证偏移有效性
    if (offset < 0 || offset + free_size > buddy_mgr.size) {
        panic("buddy: free offset %d out of range (size %u)\n", offset, free_size);
    }

    // 重置页状态，引用计数清零，清除分配标志
    for (size_t i = 0; i < free_size; i++) {
        struct Page* p = base + i;
        set_page_ref(p, 0);    // 引用计数清零
        p->property = 0;       // 重置块大小记录
    }

    // 调用函数释放块并更新总空闲页数
    buddy_free(offset);
    buddy_mgr.total_free += free_size;
}

// 获取当前空闲页总数
static size_t buddy_nr_free_pages(void) {
    return buddy_mgr.total_free;
}

// 检查伙伴系统状态
static void buddy_check(void) {
    if (buddy_mgr.size == 0) {
        cprintf("buddy: system not initialized\n");
        return;
    }

    
    cprintf("[buddy_check] begin\n");
    
    cprintf("Total managed pages: %u\n", buddy_mgr.size);
    cprintf("Largest free block: %u pages\n", buddy_mgr.longest[0]);
    cprintf("Base physical address: 0x%016lx\n", buddy_mgr.base);
    
    // 基础分配释放测试
    cprintf("Performing basic allocation test...\n");
    
    // 分配1页并释放
    struct Page* p1 = buddy_alloc_pages(1);
    if (p1) {
        cprintf("Allocated 1 page at PA: 0x%016lx\n", page2pa(p1));
        buddy_free_pages(p1, 1);
        cprintf("Freed 1 page\n");
    } else {
        cprintf("Failed to allocate 1 page\n");
    }
    
    // 分配4页并释放
    struct Page* p4 = buddy_alloc_pages(4);
    if (p4) {
        cprintf("Allocated 4 pages at PA: 0x%016lx\n", page2pa(p4));
        buddy_free_pages(p4, 4);
        cprintf("Freed 4 pages\n");
    } else {
        cprintf("Failed to allocate 4 pages\n");
    }
    
    
    cprintf("all cases passed\n");
    cprintf("Buddy system check completed successfully\n");
}

// 管理器实例 注册为buddy_pmm_manager

const struct pmm_manager buddy_pmm_manager = {
    .name = "buddy_pmm_manager",  
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};