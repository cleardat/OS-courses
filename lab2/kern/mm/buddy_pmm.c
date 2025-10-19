/***********************************************************************************
 * 伙伴系统内存分配器（Buddy System）设计文档
 * 适用场景：ucore 操作系统实验 lab2 物理内存管理模块
 ***********************************************************************************

一、项目概述
1. 内存范围定义
   - 内核物理内存起始地址：0x80200000
   - 内核物理内存结束地址：0x88000000
   - 总物理页数计算：(0x88000000 - 0x80200000) / PGSIZE = 32256 页（PGSIZE=4096字节）
2. 资源占用说明
   - 内核可执行内存占用：152KB（ 38 页）
   - struct Page 32字节
     pages数组总大小 = 物理页总数 × 每个Page结构大小= 32,768 × 32字节=256页
   - 实际可管理空闲页数 = 32256 - 38 - 256 = 31962 页
3. 核心指标
   - 最大管理页数：16384 页（2^14，因 2^14=16384 < 31962 < 2^15）
     注：实际上，验证过当把最大页数设成32768时，也会因为 n（pmm.c 传入的可用页数）
     的限制被截断为 16384 页，所以这里直接把最大管理页数定位 16384 页，是比较合理且节省空间的
   - 分配对齐规则：自动将请求页数向上对齐为 2 的幂（如请求3页对齐为4页）
   - 仅支持连续内存块分配，释放时需指定块的起始页（通过 page_idx % 块大小 == 0 校验）

二、核心设计原则
1. 所有内存块大小均为 2 的幂
2. 使用【数组】模拟二叉树（longest数组），记录每个节点对应块的最大空闲页数
3. 释放块时，自动检查相邻的伙伴块（同大小、地址相邻），若均空闲则合并为更大块，直至无法合并

三、关键数据结构
1. 伙伴系统管理器结构体（struct buddy_manager）
   - unsigned size：实际管理的总页数（2的幂，最大不超过最大管理页数和pmm.c传入的可用页数）
   - unsigned longest[2*BUDDY_MAX_PAGES-1]：二叉树数组，每个元素记录对应节点的“最大连续空闲页数”
     - 叶子节点：对应最小内存块（1页）
     - 非叶子节点：
        - 初始化时，记录自身对应块的总页数，逐层减半
        - 分配/释放操作后：若左右子树未完全空闲（存在已分配块），则记录左右子树中最大的空闲块页数
          若左右子树均完全空闲（无已分配块），则恢复为自身对应块的总页数（即合并状态）
   - buddy_mgr.base：管理的物理内存基地址
   - buddy_mgr.pages：管理的页面数组的起始指针（虚拟地址）
   - size_t total_free：当前总空闲页数，用于快速判断是否有足够内存分配

2. 辅助宏定义
   - 二叉树节点索引计算：
     LEFT_LEAF(index) ：计算左子节点索引（index×2+1）
     RIGHT_LEAF(index)：计算右子节点索引（index×2+2）
     PARENT(index)    ：计算父节点索引（(index+1)/2 -1）
   - 工具宏：
     IS_POWER_OF_2(x) ：判断 x 是否为 2 的幂（通过位运算 x & (x-1) 实现）
     MAX(a,b)         ：取两数最大值，用于更新父节点空闲块大小
     fixsize(x)       ：将 x 向上对齐为最接近的 2 的幂（通过位运算填充低位实现）

四、核心逻辑实现
1. 初始化流程
   - 1.1 管理器初始化（buddy_init）：通过 memset 清空 buddy_mgr 结构体，初始化状态
   - 1.2 内存映射初始化（buddy_init_memmap）：
         ① 接收 pmm.c 传入的可用页基地址（base）和页数（n）
         ② 计算最大可管理页数（不超过 n 和最大管理页数的最大 2 的幂）
         ③ 初始化页描述符元数据，清除保留标志、重置引用计数
         ④ 调用 buddy_init_tree 初始化二叉树
   - 1.3 二叉树初始化（buddy_init_tree）：
         ① 遍历二叉树所有节点，按层级设置初始空闲块大小（根节点=总页数，每下一层减半）
         ② 初始化 total_free 为总管理页数，初始所有内存均空闲

2. 内存分配流程
   - 2.1 分配入口（buddy_alloc_pages）：
         ① 参数校验：请求页数 n=0 或管理器未初始化则返回 NULL
         ② 页数对齐：通过 fixsize 将 n 向上对齐为 2 的幂
         ③ 调用 buddy_alloc 获取分配块的页偏移，即相对于管理基址的页数
         ④ 页描述符更新：设置分配块的引用计数（1）、块大小（property），更新 total_free
   - 2.2 二叉树分配（buddy_alloc）：
         ① 根节点检查：若根节点最大空闲块 < 对齐后页数则分配失败（返回 -1）
         ② 二叉树遍历：从根节点向下查找最小满足需求的块（优先左子树，再右子树）
         ③ 标记已分配：找到目标块后，将目标节点的 longest 值设为 0
         ④ 父节点更新：从目标块向上遍历父节点，更新其 longest 值为左右子节点最大值

3. 内存释放流程
   - 3.1 释放入口（buddy_free_pages）：
         ① 参数校验：释放页基址无效、块大小非 2 的幂则报错或 panic
         ② 起始页校验：通过页索引（page_idx = base - buddy_mgr.pages）判断是否为块起始页（page_idx % 块大小 == 0）
         ③ 页描述符重置：清除引用计数（0）、块大小（property=0），更新 total_free
         ④ 调用 buddy_free 传入页偏移，执行实际释放逻辑
   - 3.2 二叉树释放与合并（buddy_free）：
         ① 通过页偏移计算对应的叶子节点索引
         ② 从叶子节点向上遍历父节点，直到找到第一个已分配状态的节点，
         这个节点就是当初分配时标记的节点，其对应的块大小（node_size）就是待释放的块大小
           - 遍历过程中，每上一层级，块大小翻倍（node_size *= 2）。
           - 若遍历到根节点仍未找到已分配节点，说明该块已空闲，无需重复释放。
         ③ 将找到的已分配节点的longest值设为其对应的块大小
         ④ 从该节点开始遍历父节点，检查左右子节点是否均为空闲状态，即左右子节点的longest值之和等于父节点的块大小：
           - 若满足，合并为父节点大小，更新父节点longest值。
           - 若不满足，父节点longest值设为左右子节点的最大值。
           - 直至遍历到根节点，合并结束。

五、测试方案设计
1. 测试覆盖场景
   - 基础功能测试（buddy_check_basic）：验证单页/多页分配释放、非2的幂对齐（如3页→4页）
   - 边界场景测试（buddy_check_boundary）：验证最小页（1页）、最大页（全量内存）的分配释放
   - 合并逻辑测试（buddy_check_merge）：验证无阻碍合并（至根节点）和有阻碍合并（受阻层级停止）
   - 异常场景测试（buddy_check_abnormal）：验证超量分配（返回NULL）、非起始页释放（识别错误）
2. 核心断言设计
   - 分配后：空闲页数 = 初始空闲页数 - 分配页数，页描述符 property 与分配大小一致
   - 释放后：空闲页数 = 初始空闲页数 + 释放页数，二叉树根节点 longest 值恢复预期大小
   - 合并后：有阻碍时根节点大小 = 阻碍块大小，无阻碍时根节点大小 = 总管理页数
*********************************************************************************************************/
#include <pmm.h>
#include <list.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>
#include <memlayout.h>
#include <riscv.h>
#include <buddy_pmm.h>

// 定义最大管理的内存页数（2的幂）
#define BUDDY_MAX_ORDER 14  // 2^14 = 16384 页，2^15=32768页>31999页
#define BUDDY_MAX_PAGES (1 << BUDDY_MAX_ORDER) //16384 页

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
    assert(offset >= 0 && offset < buddy_mgr.size && "buddy_free: 无效偏移");

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
    cprintf("buddy_pmm: 初始化完成\n");  
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

    cprintf("buddy: 已初始化 %u 页 (基地址物理地址: 0x%016lx)\n", 
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
        cprintf("buddy: 分配 %u 页失败 (无空闲块)\n", alloc_size);
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
        cprintf("buddy: 释放失败 (无效的块大小 %u)\n", free_size);
        return;
    }
    
    //起始页校验
    size_t page_idx = base - buddy_mgr.pages;  // 页在管理范围内的索引
    assert(page_idx % free_size == 0 && "buddy: 释放非起始页");  // 起始页必须对齐到块大小的整数倍

    // 校验传入的n是否与实际块大小一致
    if (n != free_size) {
        cprintf("buddy: warning: 释放参数n=%lu与实际块大小%u不匹配，使用实际大小%u\n", 
                n, free_size, free_size);
    }

    // 计算在伙伴系统中的偏移
    uintptr_t pa = page2pa(base);
    if (pa < buddy_mgr.base) {
        panic("buddy: 尝试释放不在管理范围内的页面 (物理地址 0x%016lx)\n", pa);
    }
    int offset = (pa - buddy_mgr.base) / PGSIZE;//（释放块的物理地址-管理基址）/页大小

    // 验证偏移有效性
    if (offset < 0 || offset + free_size > buddy_mgr.size) {
        panic("buddy: 释放偏移量 %d 超出有效范围 (块大小 %u)\n", offset, free_size);
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

// 打印关键状态的辅助函数
static void show_key_status(const char* step) {
    cprintf("  [Step] %s: 空闲页数=%lu, 根节点最大块=%u\n", 
            step, buddy_mgr.total_free, buddy_mgr.longest[0]);
}

// 1. 基础功能测试：1页 + 3页 + 4页 分配释放
static void buddy_check_basic(void) {
    cprintf("\n=== [1] 基础功能测试：1页 + 3页 + 4页 分配释放 ===\n");
    size_t initial_free = buddy_mgr.total_free;
    show_key_status("初始化状态");

    // Step 1: 分配 1 页
    struct Page* p1 = buddy_alloc_pages(1);
    assert(p1 && "Step1: 分配 1 页失败");
    uintptr_t pa1 = page2pa(p1);
    cprintf("Step1: Alloc 1 page at 0x%016lx\n", pa1);
    show_key_status("分配1页");

    // Step 2: 分配 3 页（应对齐为 4 页）
    struct Page* p3 = buddy_alloc_pages(3);
    assert(p3 && "Step2: 分配 3 页失败");
    uintptr_t pa3 = page2pa(p3);
    cprintf("Step2: Alloc 3 pages (aligned to 4) at 0x%016lx\n", pa3);
    show_key_status("分配3页（对齐4页）");

    // Step 3: 释放第一个 1 页
    buddy_free_pages(p1, 1);
    cprintf("Step3: Freed 1 page at 0x%016lx\n", pa1);
    show_key_status("释放1页");

    // Step 4: 再分配 4 页，看是否复用前面释放的块
    struct Page* p4 = buddy_alloc_pages(4);
    assert(p4 && "Step4: 分配 4 页失败");
    uintptr_t pa4 = page2pa(p4);
    cprintf("Step4: Alloc 4 pages at 0x%016lx\n", pa4);
    show_key_status("分配4页");

    // Step 5: 全部释放
    buddy_free_pages(p3, 3);
    cprintf("Step5: Freed 3-page block (4 aligned) at 0x%016lx\n", pa3);
    show_key_status("释放3页块");

    buddy_free_pages(p4, 4);
    cprintf("Step6: Freed 4-page block at 0x%016lx\n", pa4);
    show_key_status("释放4页块");

    // Step 6: 验证最终状态是否恢复
    assert(buddy_mgr.total_free == initial_free);
    assert(buddy_mgr.longest[0] == buddy_mgr.size);

    cprintf(" 基础功能测试通过：1页+3页+4页 测试完成\n");
}



// 2. 边界场景测试：最大页与超限制
static void buddy_check_boundary(void) {
    cprintf("\n=== [2] 边界场景测试：分配满后再试1页 ===\n");
    size_t max_pages    = buddy_mgr.size;
    size_t initial_free = buddy_mgr.total_free;

    // 先把可管理内存一次性分配满
    struct Page* p_max = buddy_alloc_pages(max_pages);
    assert(p_max && "分配最大页数失败（p_max == NULL）");
    assert(buddy_mgr.total_free == 0 && buddy_mgr.longest[0] == 0);
    cprintf("  已分配最大页数：%lu 页，起始物理地址：0x%016lx\n",
            (unsigned long)max_pages, page2pa(p_max));
    show_key_status("分配最大页数");

    // 在已经分配满的情况下，再尝试分配 1 页，应该失败（返回 NULL）
    struct Page* p_extra = buddy_alloc_pages(1);
    if (p_extra == NULL) {
        cprintf("  在满内存情况下再分配 1 页：返回 NULL（正确）\n");
    } else {
        // 若出现非空，说明分配器状态有问题：先释放以免泄漏，再报错
        uintptr_t pa_extra = page2pa(p_extra);
        cprintf("  [错误] 在满内存情况下仍然分配到 1 页：PA=0x%016lx\n", pa_extra);
        buddy_free_pages(p_extra, 1);
        assert(0 && "分配器在 total_free==0 时仍能分配出页面，逻辑错误");
    }

    // 释放最大块，状态应完全恢复
    buddy_free_pages(p_max, max_pages);
    assert(buddy_mgr.total_free == initial_free && buddy_mgr.longest[0] == max_pages);
    show_key_status("释放最大页数");

    cprintf("  边界场景测试通过：分配满→再分配失败→释放后恢复\n");
}

// 3. 合并逻辑测试：连续释放合并，即伙伴系统核心能力
static void buddy_check_merge(void) {
    cprintf("\n=== [3] 合并逻辑测试：完整合并+部分合并 ===\n");
    size_t total_pages = buddy_mgr.size;//根节点页数
    size_t initial_free = buddy_mgr.total_free;//初始空闲页数
    size_t root_initial_size = buddy_mgr.longest[0];//根节点初始大小

    // 场景1：无阻碍，验证合并到根节点
    cprintf("  [子测试1] 无阻碍合并（合并至根节点）\n");
    struct Page* p2_a = buddy_alloc_pages(2);
    struct Page* p2_b = buddy_alloc_pages(2);
    assert(p2_a && p2_b && "子测试1：分配2页块失败");
    uintptr_t pa_a = page2pa(p2_a);
    uintptr_t pa_b = page2pa(p2_b);
    assert(pa_b - pa_a == 2 * PGSIZE && "子测试1：非2页伙伴块");

    buddy_free_pages(p2_a, 2);
    buddy_free_pages(p2_b, 2);
    // 验证合并到根节点
    assert(buddy_mgr.longest[0] == root_initial_size && "子测试1：合并至根节点失败");
    assert(buddy_mgr.total_free == initial_free && "子测试1：空闲页数不匹配");
    show_key_status("已合并至根节点（无阻碍）");

    // 场景2：有阻碍，验证合并到受阻层级
    cprintf("  [子测试2] 有阻碍合并（受阻层级停止）\n");
          // 步骤1：分配一个大块（占据根节点的一半，作为阻碍）
    size_t obstacle_size = total_pages / 2; 
    struct Page* obstacle = buddy_alloc_pages(obstacle_size);
    assert(obstacle && "子测试2：分配阻碍块失败");
          // 此时根节点剩余另一半空闲

          // 步骤2：从剩余空闲块中分配两个2页伙伴块
    struct Page* p2_c = buddy_alloc_pages(2);
    struct Page* p2_d = buddy_alloc_pages(2);
    assert(p2_c && p2_d && "子测试2：分配2页块失败");
    uintptr_t pa_c = page2pa(p2_c);
    uintptr_t pa_d = page2pa(p2_d);
    assert(pa_d - pa_c == 2 * PGSIZE && "子测试2：非2页伙伴块");

          // 步骤3：释放两个2页块，验证合并到根节点下一层
    buddy_free_pages(p2_c, 2);
    buddy_free_pages(p2_d, 2);

    assert(buddy_mgr.longest[0] == obstacle_size && "子测试2：错误跨越阻碍块合并");
    assert(buddy_mgr.total_free == initial_free - obstacle_size && "子测试2：空闲页数不匹配");
    show_key_status("已合并至8192页（被阻碍块拦截）");

    // 清理，释放阻碍块，恢复初始状态
    buddy_free_pages(obstacle, obstacle_size);
    assert(buddy_mgr.longest[0] == root_initial_size && "子测试2：清理失败（阻碍块未释放）");

    cprintf("  合并逻辑测试通过\n");
}

// 4. 异常场景测试：关键错误拦截
static void buddy_check_abnormal(void) {
    cprintf("\n=== [4] 异常场景测试 ===\n");
    size_t max_pages = buddy_mgr.size;

    // 测试1：超量分配（应返回NULL）
    assert(buddy_alloc_pages(max_pages + 1) == NULL);
    cprintf("  超量分配：正确返回NULL\n");

    // 测试2：释放非起始页（验证能识别，不实际执行释放，避免panic）
    struct Page* p4 = buddy_alloc_pages(4);
    struct Page* p_mid = p4 + 2; // 中间页（非起始页）
    // 计算p_mid的page_idx，验证是否为非起始页
    size_t page_idx_mid = p_mid - buddy_mgr.pages;
    size_t free_size_mid = p_mid->property; // 块大小4
    if (page_idx_mid % free_size_mid != 0) {
        cprintf("  释放非起始页：已识别（页偏移=%lu，块大小=%lu）→ 正确\n",
                page_idx_mid, free_size_mid);
    } else {
        cprintf("  释放非起始页：未识别 → 错误\n");
    }
    // 只释放正确的起始页p4，不释放p_mid，避免触发panic
    buddy_free_pages(p4, 4); 

    cprintf("  异常场景测试通过\n");
}

// 主校验函数
void buddy_check(void) {
    if (buddy_mgr.size == 0) {
        cprintf("buddy_check: 未初始化！\n");
        return;
    }

    cprintf("[buddy_check] begin\n");
    cprintf("管理页数：%u 页，物理基地址：0x%016lx\n", buddy_mgr.size, buddy_mgr.base);

    buddy_check_basic();
    buddy_check_boundary();
    buddy_check_merge();
    buddy_check_abnormal();

    cprintf("all cases passed\n");
}

const struct pmm_manager buddy_pmm_manager = {
    .name = "buddy_pmm_manager",  
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};