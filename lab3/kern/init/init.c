#include <clock.h>
#include <console.h>
#include <defs.h>
#include <intr.h>
#include <kdebug.h>
#include <kmonitor.h>
#include <pmm.h>
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <dtb.h>

int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);

// ===== challenge 3 测试 =====
void test_illegal_instruction(void) {
    cprintf("=== 触发非法指令异常 ===\n");
    // 用.word定义一条未定义的指令（0x0000000b是RISC-V中无效的操作码）
    // 汇编器会接受这条指令（仅视为32位数据），但CPU运行时会识别为非法指令
    __asm__ __volatile__(".word 0x0000000b");
}
void test_breakpoint(void) {
    cprintf("=== 触发断点异常 ===\n");
    __asm__ __volatile__(
        "ebreak\n"    // 断点指令
        //"nop"         // 空操作，确保 epc+4 指向有效指令
    );
}
// ============================


int kern_init(void) {
    extern char edata[], end[];
    // 先清零 BSS，再读取并保存 DTB 的内存信息，避免被清零覆盖（为了解释变化 正式上传时我觉得应该删去这句话）
    memset(edata, 0, end - edata);
    dtb_init();
    cons_init();  // init the console
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);

    print_kerninfo();

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table

    pmm_init();  // init physical memory management

    idt_init();  // init interrupt descriptor table

    clock_init();   // init clock interrupt
    intr_enable();  // enable irq interrupt

    // ===== challenge 3 测试 =====
    test_illegal_instruction();
    test_breakpoint();
    // ============================

    /* do nothing */
    while (1)
        ;
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
    mon_backtrace(0, NULL, NULL);
}

void __attribute__((noinline)) grade_backtrace1(int arg0, int arg1) {
    grade_backtrace2(arg0, (uintptr_t)&arg0, arg1, (uintptr_t)&arg1);
}

void __attribute__((noinline)) grade_backtrace0(int arg0, int arg1, int arg2) {
    grade_backtrace1(arg0, arg2);
}

void grade_backtrace(void) { grade_backtrace0(0, (uintptr_t)kern_init, 0xffff0000); }

