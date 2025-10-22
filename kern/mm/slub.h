// slub.h
#ifndef __KERN_MM_SLUB_H__
#define __KERN_MM_SLUB_H__

#include <defs.h>

void  slub_init(void);
void *slub_alloc(size_t size);  // 仅支持 size ∈ (0, 64]
void  slub_free(void *obj);

// 可选：极简自检（只做很小的申请）
void  slub_selftest(void);

#endif /* __KERN_MM_SLUB_H__ */
