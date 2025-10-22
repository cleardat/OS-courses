#ifndef __KERN_MM_PMM_H__
#define __KERN_MM_PMM_H__

#include <assert.h>
#include <defs.h>
#include <memlayout.h>
#include <mmu.h>
#include <riscv.h>

/* ---------------------------------------------------------------------------
 * 物理内存管理器接口
 * --------------------------------------------------------------------------- */
struct pmm_manager {
    const char *name;
    void (*init)(void);
    void (*init_memmap)(struct Page *base, size_t n);
    struct Page *(*alloc_pages)(size_t n);
    void (*free_pages)(struct Page *base, size_t n);
    size_t (*nr_free_pages)(void);
    void (*check)(void);
};

extern const struct pmm_manager *pmm_manager;

void pmm_init(void);

struct Page *alloc_pages(size_t n);
void free_pages(struct Page *base, size_t n);
size_t nr_free_pages(void);

#define alloc_page()  alloc_pages(1)
#define free_page(p)  free_pages((p), 1)

/* ---------------------------------------------------------------------------
 * 物理<->内核虚拟 地址转换
 * 说明：
 *  - va_pa_offset 为 “内核直接映射区” 的 VA-PA 偏移（内核线性映射）。
 *  - 用 uintptr_t 做指针宽度的算术，避免 int-to-pointer 的告警。
 * --------------------------------------------------------------------------- */
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;

/* 重要：用 uintptr_t（而非 uint64_t）匹配目标平台指针宽度 */
extern uintptr_t va_pa_offset;

/* 将 KVA 映射回 PA。仅允许 KVA>=KERNBASE 的内核直映地址。 */
#define PADDR(kva)                                                     \
    ({                                                                 \
        uintptr_t __m_kva = (uintptr_t)(kva);                          \
        if (__m_kva < KERNBASE) {                                      \
            panic("PADDR called with invalid kva %08lx", __m_kva);     \
        }                                                              \
        (uintptr_t)(__m_kva - va_pa_offset);                           \
    })

/* 将 PA 映射为 KVA。检查 PPN 合法性，防止越界。 */
#define KADDR(pa)                                                      \
    ({                                                                 \
        uintptr_t __m_pa = (uintptr_t)(pa);                            \
        size_t __m_ppn = PPN(__m_pa);                                  \
        if (__m_ppn >= npage) {                                        \
            panic("KADDR called with invalid pa %08lx", __m_pa);       \
        }                                                              \
        (void *)(__m_pa + va_pa_offset);                               \
    })

/* 可选的便捷函数（需要时可用，不用也不影响）： */
static inline void *pa2kva(uintptr_t pa) { return (void *)(pa + va_pa_offset); }
static inline uintptr_t kva2pa(const void *kva) { return PADDR(kva); }

/* ---------------------------------------------------------------------------
 * Page/PPN/PA 工具
 * --------------------------------------------------------------------------- */
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }

static inline uintptr_t page2pa(struct Page *page) {
    return ((uintptr_t)page2ppn(page)) << PGSHIFT;
}

static inline int page_ref(struct Page *page) { return page->ref; }
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
static inline int page_ref_inc(struct Page *page) { return ++page->ref; }
static inline int page_ref_dec(struct Page *page) { return --page->ref; }

static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
}

static inline void flush_tlb(void) { asm volatile ("sfence.vm"); }

extern char bootstack[], bootstacktop[]; // defined in entry.S
// 在pmm.h末尾添加
extern const struct pmm_manager slub_simple_manager;

#endif /* !__KERN_MM_PMM_H__ */
