
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00007297          	auipc	t0,0x7
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0207000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00007297          	auipc	t0,0x7
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0207008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02062b7          	lui	t0,0xc0206
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc0200034:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200038:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc020003c:	c0206137          	lui	sp,0xc0206

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	0d828293          	addi	t0,t0,216 # ffffffffc02000d8 <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020004a:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[];
    cprintf("Special kernel symbols:\n");
ffffffffc020004c:	00002517          	auipc	a0,0x2
ffffffffc0200050:	e3450513          	addi	a0,a0,-460 # ffffffffc0201e80 <etext>
void print_kerninfo(void) {
ffffffffc0200054:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200056:	0f6000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", (uintptr_t)kern_init);
ffffffffc020005a:	00000597          	auipc	a1,0x0
ffffffffc020005e:	07e58593          	addi	a1,a1,126 # ffffffffc02000d8 <kern_init>
ffffffffc0200062:	00002517          	auipc	a0,0x2
ffffffffc0200066:	e3e50513          	addi	a0,a0,-450 # ffffffffc0201ea0 <etext+0x20>
ffffffffc020006a:	0e2000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc020006e:	00002597          	auipc	a1,0x2
ffffffffc0200072:	e1258593          	addi	a1,a1,-494 # ffffffffc0201e80 <etext>
ffffffffc0200076:	00002517          	auipc	a0,0x2
ffffffffc020007a:	e4a50513          	addi	a0,a0,-438 # ffffffffc0201ec0 <etext+0x40>
ffffffffc020007e:	0ce000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc0200082:	00007597          	auipc	a1,0x7
ffffffffc0200086:	f9658593          	addi	a1,a1,-106 # ffffffffc0207018 <buddy_mgr>
ffffffffc020008a:	00002517          	auipc	a0,0x2
ffffffffc020008e:	e5650513          	addi	a0,a0,-426 # ffffffffc0201ee0 <etext+0x60>
ffffffffc0200092:	0ba000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc0200096:	00027597          	auipc	a1,0x27
ffffffffc020009a:	ff258593          	addi	a1,a1,-14 # ffffffffc0227088 <end>
ffffffffc020009e:	00002517          	auipc	a0,0x2
ffffffffc02000a2:	e6250513          	addi	a0,a0,-414 # ffffffffc0201f00 <etext+0x80>
ffffffffc02000a6:	0a6000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - (char*)kern_init + 1023) / 1024);
ffffffffc02000aa:	00027597          	auipc	a1,0x27
ffffffffc02000ae:	3dd58593          	addi	a1,a1,989 # ffffffffc0227487 <end+0x3ff>
ffffffffc02000b2:	00000797          	auipc	a5,0x0
ffffffffc02000b6:	02678793          	addi	a5,a5,38 # ffffffffc02000d8 <kern_init>
ffffffffc02000ba:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000be:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02000c2:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000c4:	3ff5f593          	andi	a1,a1,1023
ffffffffc02000c8:	95be                	add	a1,a1,a5
ffffffffc02000ca:	85a9                	srai	a1,a1,0xa
ffffffffc02000cc:	00002517          	auipc	a0,0x2
ffffffffc02000d0:	e5450513          	addi	a0,a0,-428 # ffffffffc0201f20 <etext+0xa0>
}
ffffffffc02000d4:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000d6:	a89d                	j	ffffffffc020014c <cprintf>

ffffffffc02000d8 <kern_init>:

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc02000d8:	00007517          	auipc	a0,0x7
ffffffffc02000dc:	f4050513          	addi	a0,a0,-192 # ffffffffc0207018 <buddy_mgr>
ffffffffc02000e0:	00027617          	auipc	a2,0x27
ffffffffc02000e4:	fa860613          	addi	a2,a2,-88 # ffffffffc0227088 <end>
int kern_init(void) {
ffffffffc02000e8:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc02000ea:	8e09                	sub	a2,a2,a0
ffffffffc02000ec:	4581                	li	a1,0
int kern_init(void) {
ffffffffc02000ee:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc02000f0:	57f010ef          	jal	ra,ffffffffc0201e6e <memset>
    dtb_init();
ffffffffc02000f4:	12c000ef          	jal	ra,ffffffffc0200220 <dtb_init>
    cons_init();  // init the console
ffffffffc02000f8:	11e000ef          	jal	ra,ffffffffc0200216 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc02000fc:	00002517          	auipc	a0,0x2
ffffffffc0200100:	e5450513          	addi	a0,a0,-428 # ffffffffc0201f50 <etext+0xd0>
ffffffffc0200104:	07e000ef          	jal	ra,ffffffffc0200182 <cputs>

    print_kerninfo();
ffffffffc0200108:	f43ff0ef          	jal	ra,ffffffffc020004a <print_kerninfo>

    // grade_backtrace();
    pmm_init();  // init physical memory management
ffffffffc020010c:	17e010ef          	jal	ra,ffffffffc020128a <pmm_init>

    /* do nothing */
    while (1)
ffffffffc0200110:	a001                	j	ffffffffc0200110 <kern_init+0x38>

ffffffffc0200112 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200112:	1141                	addi	sp,sp,-16
ffffffffc0200114:	e022                	sd	s0,0(sp)
ffffffffc0200116:	e406                	sd	ra,8(sp)
ffffffffc0200118:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc020011a:	0fe000ef          	jal	ra,ffffffffc0200218 <cons_putc>
    (*cnt) ++;
ffffffffc020011e:	401c                	lw	a5,0(s0)
}
ffffffffc0200120:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200122:	2785                	addiw	a5,a5,1
ffffffffc0200124:	c01c                	sw	a5,0(s0)
}
ffffffffc0200126:	6402                	ld	s0,0(sp)
ffffffffc0200128:	0141                	addi	sp,sp,16
ffffffffc020012a:	8082                	ret

ffffffffc020012c <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc020012c:	1101                	addi	sp,sp,-32
ffffffffc020012e:	862a                	mv	a2,a0
ffffffffc0200130:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200132:	00000517          	auipc	a0,0x0
ffffffffc0200136:	fe050513          	addi	a0,a0,-32 # ffffffffc0200112 <cputch>
ffffffffc020013a:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc020013c:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020013e:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200140:	119010ef          	jal	ra,ffffffffc0201a58 <vprintfmt>
    return cnt;
}
ffffffffc0200144:	60e2                	ld	ra,24(sp)
ffffffffc0200146:	4532                	lw	a0,12(sp)
ffffffffc0200148:	6105                	addi	sp,sp,32
ffffffffc020014a:	8082                	ret

ffffffffc020014c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc020014c:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020014e:	02810313          	addi	t1,sp,40 # ffffffffc0206028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc0200152:	8e2a                	mv	t3,a0
ffffffffc0200154:	f42e                	sd	a1,40(sp)
ffffffffc0200156:	f832                	sd	a2,48(sp)
ffffffffc0200158:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020015a:	00000517          	auipc	a0,0x0
ffffffffc020015e:	fb850513          	addi	a0,a0,-72 # ffffffffc0200112 <cputch>
ffffffffc0200162:	004c                	addi	a1,sp,4
ffffffffc0200164:	869a                	mv	a3,t1
ffffffffc0200166:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc0200168:	ec06                	sd	ra,24(sp)
ffffffffc020016a:	e0ba                	sd	a4,64(sp)
ffffffffc020016c:	e4be                	sd	a5,72(sp)
ffffffffc020016e:	e8c2                	sd	a6,80(sp)
ffffffffc0200170:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc0200172:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc0200174:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200176:	0e3010ef          	jal	ra,ffffffffc0201a58 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc020017a:	60e2                	ld	ra,24(sp)
ffffffffc020017c:	4512                	lw	a0,4(sp)
ffffffffc020017e:	6125                	addi	sp,sp,96
ffffffffc0200180:	8082                	ret

ffffffffc0200182 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc0200182:	1101                	addi	sp,sp,-32
ffffffffc0200184:	e822                	sd	s0,16(sp)
ffffffffc0200186:	ec06                	sd	ra,24(sp)
ffffffffc0200188:	e426                	sd	s1,8(sp)
ffffffffc020018a:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc020018c:	00054503          	lbu	a0,0(a0)
ffffffffc0200190:	c51d                	beqz	a0,ffffffffc02001be <cputs+0x3c>
ffffffffc0200192:	0405                	addi	s0,s0,1
ffffffffc0200194:	4485                	li	s1,1
ffffffffc0200196:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc0200198:	080000ef          	jal	ra,ffffffffc0200218 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc020019c:	00044503          	lbu	a0,0(s0)
ffffffffc02001a0:	008487bb          	addw	a5,s1,s0
ffffffffc02001a4:	0405                	addi	s0,s0,1
ffffffffc02001a6:	f96d                	bnez	a0,ffffffffc0200198 <cputs+0x16>
    (*cnt) ++;
ffffffffc02001a8:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001ac:	4529                	li	a0,10
ffffffffc02001ae:	06a000ef          	jal	ra,ffffffffc0200218 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001b2:	60e2                	ld	ra,24(sp)
ffffffffc02001b4:	8522                	mv	a0,s0
ffffffffc02001b6:	6442                	ld	s0,16(sp)
ffffffffc02001b8:	64a2                	ld	s1,8(sp)
ffffffffc02001ba:	6105                	addi	sp,sp,32
ffffffffc02001bc:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc02001be:	4405                	li	s0,1
ffffffffc02001c0:	b7f5                	j	ffffffffc02001ac <cputs+0x2a>

ffffffffc02001c2 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02001c2:	00027317          	auipc	t1,0x27
ffffffffc02001c6:	e7e30313          	addi	t1,t1,-386 # ffffffffc0227040 <is_panic>
ffffffffc02001ca:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02001ce:	715d                	addi	sp,sp,-80
ffffffffc02001d0:	ec06                	sd	ra,24(sp)
ffffffffc02001d2:	e822                	sd	s0,16(sp)
ffffffffc02001d4:	f436                	sd	a3,40(sp)
ffffffffc02001d6:	f83a                	sd	a4,48(sp)
ffffffffc02001d8:	fc3e                	sd	a5,56(sp)
ffffffffc02001da:	e0c2                	sd	a6,64(sp)
ffffffffc02001dc:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02001de:	000e0363          	beqz	t3,ffffffffc02001e4 <__panic+0x22>
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    while (1) {
ffffffffc02001e2:	a001                	j	ffffffffc02001e2 <__panic+0x20>
    is_panic = 1;
ffffffffc02001e4:	4785                	li	a5,1
ffffffffc02001e6:	00f32023          	sw	a5,0(t1)
    va_start(ap, fmt);
ffffffffc02001ea:	8432                	mv	s0,a2
ffffffffc02001ec:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02001ee:	862e                	mv	a2,a1
ffffffffc02001f0:	85aa                	mv	a1,a0
ffffffffc02001f2:	00002517          	auipc	a0,0x2
ffffffffc02001f6:	d7e50513          	addi	a0,a0,-642 # ffffffffc0201f70 <etext+0xf0>
    va_start(ap, fmt);
ffffffffc02001fa:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02001fc:	f51ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200200:	65a2                	ld	a1,8(sp)
ffffffffc0200202:	8522                	mv	a0,s0
ffffffffc0200204:	f29ff0ef          	jal	ra,ffffffffc020012c <vcprintf>
    cprintf("\n");
ffffffffc0200208:	00002517          	auipc	a0,0x2
ffffffffc020020c:	5e050513          	addi	a0,a0,1504 # ffffffffc02027e8 <etext+0x968>
ffffffffc0200210:	f3dff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200214:	b7f9                	j	ffffffffc02001e2 <__panic+0x20>

ffffffffc0200216 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200216:	8082                	ret

ffffffffc0200218 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc0200218:	0ff57513          	zext.b	a0,a0
ffffffffc020021c:	3bf0106f          	j	ffffffffc0201dda <sbi_console_putchar>

ffffffffc0200220 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200220:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200222:	00002517          	auipc	a0,0x2
ffffffffc0200226:	d6e50513          	addi	a0,a0,-658 # ffffffffc0201f90 <etext+0x110>
void dtb_init(void) {
ffffffffc020022a:	fc86                	sd	ra,120(sp)
ffffffffc020022c:	f8a2                	sd	s0,112(sp)
ffffffffc020022e:	e8d2                	sd	s4,80(sp)
ffffffffc0200230:	f4a6                	sd	s1,104(sp)
ffffffffc0200232:	f0ca                	sd	s2,96(sp)
ffffffffc0200234:	ecce                	sd	s3,88(sp)
ffffffffc0200236:	e4d6                	sd	s5,72(sp)
ffffffffc0200238:	e0da                	sd	s6,64(sp)
ffffffffc020023a:	fc5e                	sd	s7,56(sp)
ffffffffc020023c:	f862                	sd	s8,48(sp)
ffffffffc020023e:	f466                	sd	s9,40(sp)
ffffffffc0200240:	f06a                	sd	s10,32(sp)
ffffffffc0200242:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200244:	f09ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200248:	00007597          	auipc	a1,0x7
ffffffffc020024c:	db85b583          	ld	a1,-584(a1) # ffffffffc0207000 <boot_hartid>
ffffffffc0200250:	00002517          	auipc	a0,0x2
ffffffffc0200254:	d5050513          	addi	a0,a0,-688 # ffffffffc0201fa0 <etext+0x120>
ffffffffc0200258:	ef5ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020025c:	00007417          	auipc	s0,0x7
ffffffffc0200260:	dac40413          	addi	s0,s0,-596 # ffffffffc0207008 <boot_dtb>
ffffffffc0200264:	600c                	ld	a1,0(s0)
ffffffffc0200266:	00002517          	auipc	a0,0x2
ffffffffc020026a:	d4a50513          	addi	a0,a0,-694 # ffffffffc0201fb0 <etext+0x130>
ffffffffc020026e:	edfff0ef          	jal	ra,ffffffffc020014c <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200272:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200276:	00002517          	auipc	a0,0x2
ffffffffc020027a:	d5250513          	addi	a0,a0,-686 # ffffffffc0201fc8 <etext+0x148>
    if (boot_dtb == 0) {
ffffffffc020027e:	120a0463          	beqz	s4,ffffffffc02003a6 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200282:	57f5                	li	a5,-3
ffffffffc0200284:	07fa                	slli	a5,a5,0x1e
ffffffffc0200286:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc020028a:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020028c:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200290:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200292:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200296:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020029a:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020029e:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002a2:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002a6:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002a8:	8ec9                	or	a3,a3,a0
ffffffffc02002aa:	0087979b          	slliw	a5,a5,0x8
ffffffffc02002ae:	1b7d                	addi	s6,s6,-1
ffffffffc02002b0:	0167f7b3          	and	a5,a5,s6
ffffffffc02002b4:	8dd5                	or	a1,a1,a3
ffffffffc02002b6:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc02002b8:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002bc:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc02002be:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfeb8e65>
ffffffffc02002c2:	10f59163          	bne	a1,a5,ffffffffc02003c4 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02002c6:	471c                	lw	a5,8(a4)
ffffffffc02002c8:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02002ca:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002cc:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02002d0:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02002d4:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002d8:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002dc:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002e0:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002e4:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002e8:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002ec:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002f0:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002f4:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002f6:	01146433          	or	s0,s0,a7
ffffffffc02002fa:	0086969b          	slliw	a3,a3,0x8
ffffffffc02002fe:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200302:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200304:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200308:	8c49                	or	s0,s0,a0
ffffffffc020030a:	0166f6b3          	and	a3,a3,s6
ffffffffc020030e:	00ca6a33          	or	s4,s4,a2
ffffffffc0200312:	0167f7b3          	and	a5,a5,s6
ffffffffc0200316:	8c55                	or	s0,s0,a3
ffffffffc0200318:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020031c:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020031e:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200320:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200322:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200326:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200328:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020032a:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020032e:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200330:	00002917          	auipc	s2,0x2
ffffffffc0200334:	ce890913          	addi	s2,s2,-792 # ffffffffc0202018 <etext+0x198>
ffffffffc0200338:	49bd                	li	s3,15
        switch (token) {
ffffffffc020033a:	4d91                	li	s11,4
ffffffffc020033c:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020033e:	00002497          	auipc	s1,0x2
ffffffffc0200342:	cd248493          	addi	s1,s1,-814 # ffffffffc0202010 <etext+0x190>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200346:	000a2703          	lw	a4,0(s4)
ffffffffc020034a:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020034e:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200352:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200356:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020035a:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020035e:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200362:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200364:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200368:	0087171b          	slliw	a4,a4,0x8
ffffffffc020036c:	8fd5                	or	a5,a5,a3
ffffffffc020036e:	00eb7733          	and	a4,s6,a4
ffffffffc0200372:	8fd9                	or	a5,a5,a4
ffffffffc0200374:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200376:	09778c63          	beq	a5,s7,ffffffffc020040e <dtb_init+0x1ee>
ffffffffc020037a:	00fbea63          	bltu	s7,a5,ffffffffc020038e <dtb_init+0x16e>
ffffffffc020037e:	07a78663          	beq	a5,s10,ffffffffc02003ea <dtb_init+0x1ca>
ffffffffc0200382:	4709                	li	a4,2
ffffffffc0200384:	00e79763          	bne	a5,a4,ffffffffc0200392 <dtb_init+0x172>
ffffffffc0200388:	4c81                	li	s9,0
ffffffffc020038a:	8a56                	mv	s4,s5
ffffffffc020038c:	bf6d                	j	ffffffffc0200346 <dtb_init+0x126>
ffffffffc020038e:	ffb78ee3          	beq	a5,s11,ffffffffc020038a <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200392:	00002517          	auipc	a0,0x2
ffffffffc0200396:	cfe50513          	addi	a0,a0,-770 # ffffffffc0202090 <etext+0x210>
ffffffffc020039a:	db3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020039e:	00002517          	auipc	a0,0x2
ffffffffc02003a2:	d2a50513          	addi	a0,a0,-726 # ffffffffc02020c8 <etext+0x248>
}
ffffffffc02003a6:	7446                	ld	s0,112(sp)
ffffffffc02003a8:	70e6                	ld	ra,120(sp)
ffffffffc02003aa:	74a6                	ld	s1,104(sp)
ffffffffc02003ac:	7906                	ld	s2,96(sp)
ffffffffc02003ae:	69e6                	ld	s3,88(sp)
ffffffffc02003b0:	6a46                	ld	s4,80(sp)
ffffffffc02003b2:	6aa6                	ld	s5,72(sp)
ffffffffc02003b4:	6b06                	ld	s6,64(sp)
ffffffffc02003b6:	7be2                	ld	s7,56(sp)
ffffffffc02003b8:	7c42                	ld	s8,48(sp)
ffffffffc02003ba:	7ca2                	ld	s9,40(sp)
ffffffffc02003bc:	7d02                	ld	s10,32(sp)
ffffffffc02003be:	6de2                	ld	s11,24(sp)
ffffffffc02003c0:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02003c2:	b369                	j	ffffffffc020014c <cprintf>
}
ffffffffc02003c4:	7446                	ld	s0,112(sp)
ffffffffc02003c6:	70e6                	ld	ra,120(sp)
ffffffffc02003c8:	74a6                	ld	s1,104(sp)
ffffffffc02003ca:	7906                	ld	s2,96(sp)
ffffffffc02003cc:	69e6                	ld	s3,88(sp)
ffffffffc02003ce:	6a46                	ld	s4,80(sp)
ffffffffc02003d0:	6aa6                	ld	s5,72(sp)
ffffffffc02003d2:	6b06                	ld	s6,64(sp)
ffffffffc02003d4:	7be2                	ld	s7,56(sp)
ffffffffc02003d6:	7c42                	ld	s8,48(sp)
ffffffffc02003d8:	7ca2                	ld	s9,40(sp)
ffffffffc02003da:	7d02                	ld	s10,32(sp)
ffffffffc02003dc:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02003de:	00002517          	auipc	a0,0x2
ffffffffc02003e2:	c0a50513          	addi	a0,a0,-1014 # ffffffffc0201fe8 <etext+0x168>
}
ffffffffc02003e6:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02003e8:	b395                	j	ffffffffc020014c <cprintf>
                int name_len = strlen(name);
ffffffffc02003ea:	8556                	mv	a0,s5
ffffffffc02003ec:	209010ef          	jal	ra,ffffffffc0201df4 <strlen>
ffffffffc02003f0:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003f2:	4619                	li	a2,6
ffffffffc02003f4:	85a6                	mv	a1,s1
ffffffffc02003f6:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02003f8:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003fa:	24f010ef          	jal	ra,ffffffffc0201e48 <strncmp>
ffffffffc02003fe:	e111                	bnez	a0,ffffffffc0200402 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc0200400:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200402:	0a91                	addi	s5,s5,4
ffffffffc0200404:	9ad2                	add	s5,s5,s4
ffffffffc0200406:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc020040a:	8a56                	mv	s4,s5
ffffffffc020040c:	bf2d                	j	ffffffffc0200346 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc020040e:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200412:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200416:	0087d71b          	srliw	a4,a5,0x8
ffffffffc020041a:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020041e:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200422:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200426:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020042a:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020042e:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200432:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200436:	00eaeab3          	or	s5,s5,a4
ffffffffc020043a:	00fb77b3          	and	a5,s6,a5
ffffffffc020043e:	00faeab3          	or	s5,s5,a5
ffffffffc0200442:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200444:	000c9c63          	bnez	s9,ffffffffc020045c <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200448:	1a82                	slli	s5,s5,0x20
ffffffffc020044a:	00368793          	addi	a5,a3,3
ffffffffc020044e:	020ada93          	srli	s5,s5,0x20
ffffffffc0200452:	9abe                	add	s5,s5,a5
ffffffffc0200454:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200458:	8a56                	mv	s4,s5
ffffffffc020045a:	b5f5                	j	ffffffffc0200346 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020045c:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200460:	85ca                	mv	a1,s2
ffffffffc0200462:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200464:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200468:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020046c:	0187971b          	slliw	a4,a5,0x18
ffffffffc0200470:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200474:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200478:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020047a:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020047e:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200482:	8d59                	or	a0,a0,a4
ffffffffc0200484:	00fb77b3          	and	a5,s6,a5
ffffffffc0200488:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc020048a:	1502                	slli	a0,a0,0x20
ffffffffc020048c:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020048e:	9522                	add	a0,a0,s0
ffffffffc0200490:	19b010ef          	jal	ra,ffffffffc0201e2a <strcmp>
ffffffffc0200494:	66a2                	ld	a3,8(sp)
ffffffffc0200496:	f94d                	bnez	a0,ffffffffc0200448 <dtb_init+0x228>
ffffffffc0200498:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200448 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020049c:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02004a0:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02004a4:	00002517          	auipc	a0,0x2
ffffffffc02004a8:	b7c50513          	addi	a0,a0,-1156 # ffffffffc0202020 <etext+0x1a0>
           fdt32_to_cpu(x >> 32);
ffffffffc02004ac:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004b0:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02004b4:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004b8:	0187de1b          	srliw	t3,a5,0x18
ffffffffc02004bc:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c0:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004c4:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c8:	0187d693          	srli	a3,a5,0x18
ffffffffc02004cc:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02004d0:	0087579b          	srliw	a5,a4,0x8
ffffffffc02004d4:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004d8:	0106561b          	srliw	a2,a2,0x10
ffffffffc02004dc:	010f6f33          	or	t5,t5,a6
ffffffffc02004e0:	0187529b          	srliw	t0,a4,0x18
ffffffffc02004e4:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004e8:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004ec:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004f0:	0186f6b3          	and	a3,a3,s8
ffffffffc02004f4:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02004f8:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004fc:	0107581b          	srliw	a6,a4,0x10
ffffffffc0200500:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200504:	8361                	srli	a4,a4,0x18
ffffffffc0200506:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020050a:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020050e:	01e6e6b3          	or	a3,a3,t5
ffffffffc0200512:	00cb7633          	and	a2,s6,a2
ffffffffc0200516:	0088181b          	slliw	a6,a6,0x8
ffffffffc020051a:	0085959b          	slliw	a1,a1,0x8
ffffffffc020051e:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200522:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200526:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020052a:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020052e:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200532:	011b78b3          	and	a7,s6,a7
ffffffffc0200536:	005eeeb3          	or	t4,t4,t0
ffffffffc020053a:	00c6e733          	or	a4,a3,a2
ffffffffc020053e:	006c6c33          	or	s8,s8,t1
ffffffffc0200542:	010b76b3          	and	a3,s6,a6
ffffffffc0200546:	00bb7b33          	and	s6,s6,a1
ffffffffc020054a:	01d7e7b3          	or	a5,a5,t4
ffffffffc020054e:	016c6b33          	or	s6,s8,s6
ffffffffc0200552:	01146433          	or	s0,s0,a7
ffffffffc0200556:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200558:	1702                	slli	a4,a4,0x20
ffffffffc020055a:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020055c:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020055e:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200560:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200562:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200566:	0167eb33          	or	s6,a5,s6
ffffffffc020056a:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc020056c:	be1ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200570:	85a2                	mv	a1,s0
ffffffffc0200572:	00002517          	auipc	a0,0x2
ffffffffc0200576:	ace50513          	addi	a0,a0,-1330 # ffffffffc0202040 <etext+0x1c0>
ffffffffc020057a:	bd3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020057e:	014b5613          	srli	a2,s6,0x14
ffffffffc0200582:	85da                	mv	a1,s6
ffffffffc0200584:	00002517          	auipc	a0,0x2
ffffffffc0200588:	ad450513          	addi	a0,a0,-1324 # ffffffffc0202058 <etext+0x1d8>
ffffffffc020058c:	bc1ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200590:	008b05b3          	add	a1,s6,s0
ffffffffc0200594:	15fd                	addi	a1,a1,-1
ffffffffc0200596:	00002517          	auipc	a0,0x2
ffffffffc020059a:	ae250513          	addi	a0,a0,-1310 # ffffffffc0202078 <etext+0x1f8>
ffffffffc020059e:	bafff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("DTB init completed\n");
ffffffffc02005a2:	00002517          	auipc	a0,0x2
ffffffffc02005a6:	b2650513          	addi	a0,a0,-1242 # ffffffffc02020c8 <etext+0x248>
        memory_base = mem_base;
ffffffffc02005aa:	00027797          	auipc	a5,0x27
ffffffffc02005ae:	a887bf23          	sd	s0,-1378(a5) # ffffffffc0227048 <memory_base>
        memory_size = mem_size;
ffffffffc02005b2:	00027797          	auipc	a5,0x27
ffffffffc02005b6:	a967bf23          	sd	s6,-1378(a5) # ffffffffc0227050 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc02005ba:	b3f5                	j	ffffffffc02003a6 <dtb_init+0x186>

ffffffffc02005bc <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02005bc:	00027517          	auipc	a0,0x27
ffffffffc02005c0:	a8c53503          	ld	a0,-1396(a0) # ffffffffc0227048 <memory_base>
ffffffffc02005c4:	8082                	ret

ffffffffc02005c6 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc02005c6:	00027517          	auipc	a0,0x27
ffffffffc02005ca:	a8a53503          	ld	a0,-1398(a0) # ffffffffc0227050 <memory_size>
ffffffffc02005ce:	8082                	ret

ffffffffc02005d0 <buddy_nr_free_pages>:
}

// 获取当前空闲页总数
static size_t buddy_nr_free_pages(void) {
    return buddy_mgr.total_free;
}
ffffffffc02005d0:	00027517          	auipc	a0,0x27
ffffffffc02005d4:	a5853503          	ld	a0,-1448(a0) # ffffffffc0227028 <buddy_mgr+0x20010>
ffffffffc02005d8:	8082                	ret

ffffffffc02005da <buddy_free_pages>:
static void buddy_free_pages(struct Page *base, size_t n) {
ffffffffc02005da:	7139                	addi	sp,sp,-64
ffffffffc02005dc:	fc06                	sd	ra,56(sp)
ffffffffc02005de:	f822                	sd	s0,48(sp)
ffffffffc02005e0:	f426                	sd	s1,40(sp)
ffffffffc02005e2:	f04a                	sd	s2,32(sp)
ffffffffc02005e4:	ec4e                	sd	s3,24(sp)
ffffffffc02005e6:	e852                	sd	s4,16(sp)
ffffffffc02005e8:	e456                	sd	s5,8(sp)
    assert(base && n > 0 && buddy_mgr.size != 0);
ffffffffc02005ea:	18050e63          	beqz	a0,ffffffffc0200786 <buddy_free_pages+0x1ac>
ffffffffc02005ee:	18058c63          	beqz	a1,ffffffffc0200786 <buddy_free_pages+0x1ac>
ffffffffc02005f2:	00007497          	auipc	s1,0x7
ffffffffc02005f6:	a2648493          	addi	s1,s1,-1498 # ffffffffc0207018 <buddy_mgr>
ffffffffc02005fa:	409c                	lw	a5,0(s1)
ffffffffc02005fc:	18078563          	beqz	a5,ffffffffc0200786 <buddy_free_pages+0x1ac>
    unsigned free_size = base->property;
ffffffffc0200600:	01052a03          	lw	s4,16(a0)
ffffffffc0200604:	842a                	mv	s0,a0
    if (!IS_POWER_OF_2(free_size)) {
ffffffffc0200606:	fffa079b          	addiw	a5,s4,-1
ffffffffc020060a:	00fa77b3          	and	a5,s4,a5
ffffffffc020060e:	2781                	sext.w	a5,a5
ffffffffc0200610:	14079b63          	bnez	a5,ffffffffc0200766 <buddy_free_pages+0x18c>
    size_t page_idx = base - buddy_mgr.pages;  // 页在管理范围内的索引
ffffffffc0200614:	00027997          	auipc	s3,0x27
ffffffffc0200618:	a0498993          	addi	s3,s3,-1532 # ffffffffc0227018 <buddy_mgr+0x20000>
ffffffffc020061c:	0089b783          	ld	a5,8(s3)
ffffffffc0200620:	00003a97          	auipc	s5,0x3
ffffffffc0200624:	ee0aba83          	ld	s5,-288(s5) # ffffffffc0203500 <error_string+0x38>
    assert(page_idx % free_size == 0 && "buddy: 释放非起始页");  // 起始页必须对齐到块大小的整数倍
ffffffffc0200628:	020a1913          	slli	s2,s4,0x20
    size_t page_idx = base - buddy_mgr.pages;  // 页在管理范围内的索引
ffffffffc020062c:	40f507b3          	sub	a5,a0,a5
ffffffffc0200630:	878d                	srai	a5,a5,0x3
ffffffffc0200632:	035787b3          	mul	a5,a5,s5
    assert(page_idx % free_size == 0 && "buddy: 释放非起始页");  // 起始页必须对齐到块大小的整数倍
ffffffffc0200636:	02095913          	srli	s2,s2,0x20
ffffffffc020063a:	0327f7b3          	remu	a5,a5,s2
ffffffffc020063e:	1a079263          	bnez	a5,ffffffffc02007e2 <buddy_free_pages+0x208>
    if (n != free_size) {
ffffffffc0200642:	10b91963          	bne	s2,a1,ffffffffc0200754 <buddy_free_pages+0x17a>
static inline uintptr_t kva2pa(const void *kva) { return PADDR(kva); }

/* ---------------------------------------------------------------------------
 * Page/PPN/PA 工具
 * --------------------------------------------------------------------------- */
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200646:	00027597          	auipc	a1,0x27
ffffffffc020064a:	a1a5b583          	ld	a1,-1510(a1) # ffffffffc0227060 <pages>
ffffffffc020064e:	40b405b3          	sub	a1,s0,a1
ffffffffc0200652:	858d                	srai	a1,a1,0x3
ffffffffc0200654:	035585b3          	mul	a1,a1,s5
ffffffffc0200658:	00003797          	auipc	a5,0x3
ffffffffc020065c:	eb07b783          	ld	a5,-336(a5) # ffffffffc0203508 <nbase>
    if (pa < buddy_mgr.base) {
ffffffffc0200660:	0009b683          	ld	a3,0(s3)
ffffffffc0200664:	95be                	add	a1,a1,a5

static inline uintptr_t page2pa(struct Page *page) {
    return ((uintptr_t)page2ppn(page)) << PGSHIFT;
ffffffffc0200666:	05b2                	slli	a1,a1,0xc
ffffffffc0200668:	18d5ed63          	bltu	a1,a3,ffffffffc0200802 <buddy_free_pages+0x228>
    int offset = (pa - buddy_mgr.base) / PGSIZE;//（释放块的物理地址-管理基址）/页大小
ffffffffc020066c:	8d95                	sub	a1,a1,a3
ffffffffc020066e:	81b1                	srli	a1,a1,0xc
ffffffffc0200670:	2581                	sext.w	a1,a1
    if (offset < 0 || offset + free_size > buddy_mgr.size) {
ffffffffc0200672:	1405ca63          	bltz	a1,ffffffffc02007c6 <buddy_free_pages+0x1ec>
ffffffffc0200676:	409c                	lw	a5,0(s1)
ffffffffc0200678:	0145873b          	addw	a4,a1,s4
ffffffffc020067c:	14e7e563          	bltu	a5,a4,ffffffffc02007c6 <buddy_free_pages+0x1ec>
    for (size_t i = 0; i < free_size; i++) {
ffffffffc0200680:	02090063          	beqz	s2,ffffffffc02006a0 <buddy_free_pages+0xc6>
ffffffffc0200684:	00291713          	slli	a4,s2,0x2
ffffffffc0200688:	974a                	add	a4,a4,s2
ffffffffc020068a:	070e                	slli	a4,a4,0x3
ffffffffc020068c:	8522                	mv	a0,s0
ffffffffc020068e:	9722                	add	a4,a4,s0
}

static inline int page_ref(struct Page *page) { return page->ref; }
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200690:	00052023          	sw	zero,0(a0)
        p->property = 0;       // 重置块大小记录
ffffffffc0200694:	00052823          	sw	zero,16(a0)
    for (size_t i = 0; i < free_size; i++) {
ffffffffc0200698:	02850513          	addi	a0,a0,40
ffffffffc020069c:	fee51ae3          	bne	a0,a4,ffffffffc0200690 <buddy_free_pages+0xb6>
    assert(offset >= 0 && offset < buddy_mgr.size && "buddy_free: 无效偏移");
ffffffffc02006a0:	10f5f363          	bgeu	a1,a5,ffffffffc02007a6 <buddy_free_pages+0x1cc>
    index = offset + buddy_mgr.size - 1;  // 转换为叶子节点索引
ffffffffc02006a4:	fff7869b          	addiw	a3,a5,-1
ffffffffc02006a8:	9ead                	addw	a3,a3,a1
    for (; buddy_mgr.longest[index]; index = PARENT(index)) {
ffffffffc02006aa:	02069713          	slli	a4,a3,0x20
ffffffffc02006ae:	01e75793          	srli	a5,a4,0x1e
ffffffffc02006b2:	97a6                	add	a5,a5,s1
ffffffffc02006b4:	43dc                	lw	a5,4(a5)
ffffffffc02006b6:	c7f1                	beqz	a5,ffffffffc0200782 <buddy_free_pages+0x1a8>
        if (index == 0)  // 到达根节点仍未找到，直接返回
ffffffffc02006b8:	c2c1                	beqz	a3,ffffffffc0200738 <buddy_free_pages+0x15e>
        node_size *= 2;
ffffffffc02006ba:	4789                	li	a5,2
ffffffffc02006bc:	a021                	j	ffffffffc02006c4 <buddy_free_pages+0xea>
ffffffffc02006be:	0017979b          	slliw	a5,a5,0x1
        if (index == 0)  // 到达根节点仍未找到，直接返回
ffffffffc02006c2:	cabd                	beqz	a3,ffffffffc0200738 <buddy_free_pages+0x15e>
    for (; buddy_mgr.longest[index]; index = PARENT(index)) {
ffffffffc02006c4:	2685                	addiw	a3,a3,1
ffffffffc02006c6:	0016d69b          	srliw	a3,a3,0x1
ffffffffc02006ca:	36fd                	addiw	a3,a3,-1
ffffffffc02006cc:	02069613          	slli	a2,a3,0x20
ffffffffc02006d0:	01e65713          	srli	a4,a2,0x1e
ffffffffc02006d4:	9726                	add	a4,a4,s1
ffffffffc02006d6:	4358                	lw	a4,4(a4)
ffffffffc02006d8:	f37d                	bnez	a4,ffffffffc02006be <buddy_free_pages+0xe4>
    buddy_mgr.longest[index] = node_size;
ffffffffc02006da:	02069613          	slli	a2,a3,0x20
ffffffffc02006de:	01e65713          	srli	a4,a2,0x1e
ffffffffc02006e2:	9726                	add	a4,a4,s1
ffffffffc02006e4:	c35c                	sw	a5,4(a4)
    while (index != 0) {
ffffffffc02006e6:	caa9                	beqz	a3,ffffffffc0200738 <buddy_free_pages+0x15e>
        index = PARENT(index);
ffffffffc02006e8:	2685                	addiw	a3,a3,1
ffffffffc02006ea:	0016d71b          	srliw	a4,a3,0x1
ffffffffc02006ee:	377d                	addiw	a4,a4,-1
        left_longest = buddy_mgr.longest[LEFT_LEAF(index)];
ffffffffc02006f0:	0017161b          	slliw	a2,a4,0x1
        right_longest = buddy_mgr.longest[RIGHT_LEAF(index)];
ffffffffc02006f4:	9af9                	andi	a3,a3,-2
        left_longest = buddy_mgr.longest[LEFT_LEAF(index)];
ffffffffc02006f6:	2605                	addiw	a2,a2,1
        right_longest = buddy_mgr.longest[RIGHT_LEAF(index)];
ffffffffc02006f8:	1682                	slli	a3,a3,0x20
        left_longest = buddy_mgr.longest[LEFT_LEAF(index)];
ffffffffc02006fa:	02061593          	slli	a1,a2,0x20
        right_longest = buddy_mgr.longest[RIGHT_LEAF(index)];
ffffffffc02006fe:	9281                	srli	a3,a3,0x20
        left_longest = buddy_mgr.longest[LEFT_LEAF(index)];
ffffffffc0200700:	01e5d613          	srli	a2,a1,0x1e
        right_longest = buddy_mgr.longest[RIGHT_LEAF(index)];
ffffffffc0200704:	068a                	slli	a3,a3,0x2
        left_longest = buddy_mgr.longest[LEFT_LEAF(index)];
ffffffffc0200706:	9626                	add	a2,a2,s1
        right_longest = buddy_mgr.longest[RIGHT_LEAF(index)];
ffffffffc0200708:	96a6                	add	a3,a3,s1
ffffffffc020070a:	42c8                	lw	a0,4(a3)
        left_longest = buddy_mgr.longest[LEFT_LEAF(index)];
ffffffffc020070c:	424c                	lw	a1,4(a2)
        node_size *= 2;  // 父节点的块大小是当前节点的2倍
ffffffffc020070e:	0017979b          	slliw	a5,a5,0x1
        index = PARENT(index);
ffffffffc0200712:	0007069b          	sext.w	a3,a4
        if (left_longest + right_longest == node_size) {
ffffffffc0200716:	00a5863b          	addw	a2,a1,a0
ffffffffc020071a:	00c78863          	beq	a5,a2,ffffffffc020072a <buddy_free_pages+0x150>
            buddy_mgr.longest[index] = MAX(left_longest, right_longest);
ffffffffc020071e:	0005861b          	sext.w	a2,a1
ffffffffc0200722:	00a5f463          	bgeu	a1,a0,ffffffffc020072a <buddy_free_pages+0x150>
ffffffffc0200726:	0005061b          	sext.w	a2,a0
ffffffffc020072a:	02071593          	slli	a1,a4,0x20
ffffffffc020072e:	01e5d713          	srli	a4,a1,0x1e
ffffffffc0200732:	9726                	add	a4,a4,s1
ffffffffc0200734:	c350                	sw	a2,4(a4)
    while (index != 0) {
ffffffffc0200736:	facd                	bnez	a3,ffffffffc02006e8 <buddy_free_pages+0x10e>
    buddy_mgr.total_free += free_size;
ffffffffc0200738:	0109b783          	ld	a5,16(s3)
}
ffffffffc020073c:	70e2                	ld	ra,56(sp)
ffffffffc020073e:	7442                	ld	s0,48(sp)
    buddy_mgr.total_free += free_size;
ffffffffc0200740:	993e                	add	s2,s2,a5
ffffffffc0200742:	0129b823          	sd	s2,16(s3)
}
ffffffffc0200746:	74a2                	ld	s1,40(sp)
ffffffffc0200748:	7902                	ld	s2,32(sp)
ffffffffc020074a:	69e2                	ld	s3,24(sp)
ffffffffc020074c:	6a42                	ld	s4,16(sp)
ffffffffc020074e:	6aa2                	ld	s5,8(sp)
ffffffffc0200750:	6121                	addi	sp,sp,64
ffffffffc0200752:	8082                	ret
        cprintf("buddy: warning: 释放参数n=%lu与实际块大小%u不匹配，使用实际大小%u\n", 
ffffffffc0200754:	86d2                	mv	a3,s4
ffffffffc0200756:	8652                	mv	a2,s4
ffffffffc0200758:	00002517          	auipc	a0,0x2
ffffffffc020075c:	a5050513          	addi	a0,a0,-1456 # ffffffffc02021a8 <etext+0x328>
ffffffffc0200760:	9edff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200764:	b5cd                	j	ffffffffc0200646 <buddy_free_pages+0x6c>
}
ffffffffc0200766:	7442                	ld	s0,48(sp)
ffffffffc0200768:	70e2                	ld	ra,56(sp)
ffffffffc020076a:	74a2                	ld	s1,40(sp)
ffffffffc020076c:	7902                	ld	s2,32(sp)
ffffffffc020076e:	69e2                	ld	s3,24(sp)
ffffffffc0200770:	6aa2                	ld	s5,8(sp)
        cprintf("buddy: 释放失败 (无效的块大小 %u)\n", free_size);
ffffffffc0200772:	85d2                	mv	a1,s4
}
ffffffffc0200774:	6a42                	ld	s4,16(sp)
        cprintf("buddy: 释放失败 (无效的块大小 %u)\n", free_size);
ffffffffc0200776:	00002517          	auipc	a0,0x2
ffffffffc020077a:	9c250513          	addi	a0,a0,-1598 # ffffffffc0202138 <etext+0x2b8>
}
ffffffffc020077e:	6121                	addi	sp,sp,64
        cprintf("buddy: 释放失败 (无效的块大小 %u)\n", free_size);
ffffffffc0200780:	b2f1                	j	ffffffffc020014c <cprintf>
    node_size = 1;
ffffffffc0200782:	4785                	li	a5,1
ffffffffc0200784:	bf99                	j	ffffffffc02006da <buddy_free_pages+0x100>
    assert(base && n > 0 && buddy_mgr.size != 0);
ffffffffc0200786:	00002697          	auipc	a3,0x2
ffffffffc020078a:	95a68693          	addi	a3,a3,-1702 # ffffffffc02020e0 <etext+0x260>
ffffffffc020078e:	00002617          	auipc	a2,0x2
ffffffffc0200792:	97a60613          	addi	a2,a2,-1670 # ffffffffc0202108 <etext+0x288>
ffffffffc0200796:	14c00593          	li	a1,332
ffffffffc020079a:	00002517          	auipc	a0,0x2
ffffffffc020079e:	98650513          	addi	a0,a0,-1658 # ffffffffc0202120 <etext+0x2a0>
ffffffffc02007a2:	a21ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(offset >= 0 && offset < buddy_mgr.size && "buddy_free: 无效偏移");
ffffffffc02007a6:	00002697          	auipc	a3,0x2
ffffffffc02007aa:	aea68693          	addi	a3,a3,-1302 # ffffffffc0202290 <etext+0x410>
ffffffffc02007ae:	00002617          	auipc	a2,0x2
ffffffffc02007b2:	95a60613          	addi	a2,a2,-1702 # ffffffffc0202108 <etext+0x288>
ffffffffc02007b6:	0d500593          	li	a1,213
ffffffffc02007ba:	00002517          	auipc	a0,0x2
ffffffffc02007be:	96650513          	addi	a0,a0,-1690 # ffffffffc0202120 <etext+0x2a0>
ffffffffc02007c2:	a01ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
        panic("buddy: 释放偏移量 %d 超出有效范围 (块大小 %u)\n", offset, free_size);
ffffffffc02007c6:	86ae                	mv	a3,a1
ffffffffc02007c8:	8752                	mv	a4,s4
ffffffffc02007ca:	00002617          	auipc	a2,0x2
ffffffffc02007ce:	a8660613          	addi	a2,a2,-1402 # ffffffffc0202250 <etext+0x3d0>
ffffffffc02007d2:	16800593          	li	a1,360
ffffffffc02007d6:	00002517          	auipc	a0,0x2
ffffffffc02007da:	94a50513          	addi	a0,a0,-1718 # ffffffffc0202120 <etext+0x2a0>
ffffffffc02007de:	9e5ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(page_idx % free_size == 0 && "buddy: 释放非起始页");  // 起始页必须对齐到块大小的整数倍
ffffffffc02007e2:	00002697          	auipc	a3,0x2
ffffffffc02007e6:	98668693          	addi	a3,a3,-1658 # ffffffffc0202168 <etext+0x2e8>
ffffffffc02007ea:	00002617          	auipc	a2,0x2
ffffffffc02007ee:	91e60613          	addi	a2,a2,-1762 # ffffffffc0202108 <etext+0x288>
ffffffffc02007f2:	15700593          	li	a1,343
ffffffffc02007f6:	00002517          	auipc	a0,0x2
ffffffffc02007fa:	92a50513          	addi	a0,a0,-1750 # ffffffffc0202120 <etext+0x2a0>
ffffffffc02007fe:	9c5ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
        panic("buddy: 尝试释放不在管理范围内的页面 (物理地址 0x%016lx)\n", pa);
ffffffffc0200802:	86ae                	mv	a3,a1
ffffffffc0200804:	00002617          	auipc	a2,0x2
ffffffffc0200808:	9fc60613          	addi	a2,a2,-1540 # ffffffffc0202200 <etext+0x380>
ffffffffc020080c:	16200593          	li	a1,354
ffffffffc0200810:	00002517          	auipc	a0,0x2
ffffffffc0200814:	91050513          	addi	a0,a0,-1776 # ffffffffc0202120 <etext+0x2a0>
ffffffffc0200818:	9abff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc020081c <buddy_init>:
    memset(&buddy_mgr, 0, sizeof(buddy_mgr));
ffffffffc020081c:	00020637          	lui	a2,0x20
static void buddy_init(void) {
ffffffffc0200820:	1141                	addi	sp,sp,-16
    memset(&buddy_mgr, 0, sizeof(buddy_mgr));
ffffffffc0200822:	0661                	addi	a2,a2,24
ffffffffc0200824:	4581                	li	a1,0
ffffffffc0200826:	00006517          	auipc	a0,0x6
ffffffffc020082a:	7f250513          	addi	a0,a0,2034 # ffffffffc0207018 <buddy_mgr>
static void buddy_init(void) {
ffffffffc020082e:	e406                	sd	ra,8(sp)
    memset(&buddy_mgr, 0, sizeof(buddy_mgr));
ffffffffc0200830:	63e010ef          	jal	ra,ffffffffc0201e6e <memset>
}
ffffffffc0200834:	60a2                	ld	ra,8(sp)
    cprintf("buddy_pmm: 初始化完成\n");  
ffffffffc0200836:	00002517          	auipc	a0,0x2
ffffffffc020083a:	aa250513          	addi	a0,a0,-1374 # ffffffffc02022d8 <etext+0x458>
}
ffffffffc020083e:	0141                	addi	sp,sp,16
    cprintf("buddy_pmm: 初始化完成\n");  
ffffffffc0200840:	b231                	j	ffffffffc020014c <cprintf>

ffffffffc0200842 <buddy_init_memmap>:
static void buddy_init_memmap(struct Page *base, size_t n) {
ffffffffc0200842:	1101                	addi	sp,sp,-32
ffffffffc0200844:	ec06                	sd	ra,24(sp)
ffffffffc0200846:	e822                	sd	s0,16(sp)
ffffffffc0200848:	e426                	sd	s1,8(sp)
ffffffffc020084a:	e04a                	sd	s2,0(sp)
    assert(n > 0); 
ffffffffc020084c:	c5e9                	beqz	a1,ffffffffc0200916 <buddy_init_memmap+0xd4>
ffffffffc020084e:	892a                	mv	s2,a0
ffffffffc0200850:	473d                	li	a4,15
ffffffffc0200852:	4785                	li	a5,1
    while (buddy_size * 2 <= n && buddy_size * 2 <= BUDDY_MAX_PAGES) {
ffffffffc0200854:	843e                	mv	s0,a5
ffffffffc0200856:	0786                	slli	a5,a5,0x1
ffffffffc0200858:	00f5e463          	bltu	a1,a5,ffffffffc0200860 <buddy_init_memmap+0x1e>
ffffffffc020085c:	377d                	addiw	a4,a4,-1
ffffffffc020085e:	fb7d                	bnez	a4,ffffffffc0200854 <buddy_init_memmap+0x12>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200860:	00027497          	auipc	s1,0x27
ffffffffc0200864:	8004b483          	ld	s1,-2048(s1) # ffffffffc0227060 <pages>
ffffffffc0200868:	409904b3          	sub	s1,s2,s1
ffffffffc020086c:	00003617          	auipc	a2,0x3
ffffffffc0200870:	c9463603          	ld	a2,-876(a2) # ffffffffc0203500 <error_string+0x38>
ffffffffc0200874:	848d                	srai	s1,s1,0x3
ffffffffc0200876:	02c484b3          	mul	s1,s1,a2
ffffffffc020087a:	00003617          	auipc	a2,0x3
ffffffffc020087e:	c8e63603          	ld	a2,-882(a2) # ffffffffc0203508 <nbase>
    uint64_t mem_size = buddy_size * PGSIZE;
ffffffffc0200882:	00c41593          	slli	a1,s0,0xc
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", 
ffffffffc0200886:	00002517          	auipc	a0,0x2
ffffffffc020088a:	aba50513          	addi	a0,a0,-1350 # ffffffffc0202340 <etext+0x4c0>
ffffffffc020088e:	94b2                	add	s1,s1,a2
    return ((uintptr_t)page2ppn(page)) << PGSHIFT;
ffffffffc0200890:	04b2                	slli	s1,s1,0xc
    uint64_t mem_end = mem_begin + mem_size - 1;
ffffffffc0200892:	fff48693          	addi	a3,s1,-1
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", 
ffffffffc0200896:	96ae                	add	a3,a3,a1
ffffffffc0200898:	8626                	mv	a2,s1
ffffffffc020089a:	8b3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    for (size_t i = 0; i < buddy_size; i++) {
ffffffffc020089e:	00241713          	slli	a4,s0,0x2
ffffffffc02008a2:	9722                	add	a4,a4,s0
ffffffffc02008a4:	070e                	slli	a4,a4,0x3
ffffffffc02008a6:	87ca                	mv	a5,s2
ffffffffc02008a8:	974a                	add	a4,a4,s2
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc02008aa:	0007a023          	sw	zero,0(a5)
        page->flags = 0;          // 清空标志位
ffffffffc02008ae:	0007b423          	sd	zero,8(a5)
    for (size_t i = 0; i < buddy_size; i++) {
ffffffffc02008b2:	02878793          	addi	a5,a5,40
ffffffffc02008b6:	fee79ae3          	bne	a5,a4,ffffffffc02008aa <buddy_init_memmap+0x68>
    node_size = size * 2;  // 根节点初始大小为2×总页数，向下分裂，最终根节点为size
ffffffffc02008ba:	0014181b          	slliw	a6,s0,0x1
    buddy_mgr.size = size;
ffffffffc02008be:	00006797          	auipc	a5,0x6
ffffffffc02008c2:	7487ad23          	sw	s0,1882(a5) # ffffffffc0207018 <buddy_mgr>
    buddy_init_tree(buddy_size);//调用初始化伙伴树的函数，传入根节点页数
ffffffffc02008c6:	0004059b          	sext.w	a1,s0
    for (i = 0; i < 2 * size - 1; ++i) {// 遍历所有节点
ffffffffc02008ca:	00006697          	auipc	a3,0x6
ffffffffc02008ce:	75268693          	addi	a3,a3,1874 # ffffffffc020701c <buddy_mgr+0x4>
ffffffffc02008d2:	fff8089b          	addiw	a7,a6,-1
ffffffffc02008d6:	4781                	li	a5,0
        if (IS_POWER_OF_2(i + 1)) {  // 每进入新一层，块大小减半，i=0也会执行减半操作
ffffffffc02008d8:	873e                	mv	a4,a5
ffffffffc02008da:	2785                	addiw	a5,a5,1
ffffffffc02008dc:	8f7d                	and	a4,a4,a5
ffffffffc02008de:	e319                	bnez	a4,ffffffffc02008e4 <buddy_init_memmap+0xa2>
            node_size /= 2;
ffffffffc02008e0:	0018581b          	srliw	a6,a6,0x1
        buddy_mgr.longest[i] = node_size;
ffffffffc02008e4:	0106a023          	sw	a6,0(a3)
    for (i = 0; i < 2 * size - 1; ++i) {// 遍历所有节点
ffffffffc02008e8:	0691                	addi	a3,a3,4
ffffffffc02008ea:	ff1797e3          	bne	a5,a7,ffffffffc02008d8 <buddy_init_memmap+0x96>
    buddy_mgr.total_free = size;  // 初始总空闲页数=总管理页数（根节点页数）
ffffffffc02008ee:	00026797          	auipc	a5,0x26
ffffffffc02008f2:	72a78793          	addi	a5,a5,1834 # ffffffffc0227018 <buddy_mgr+0x20000>
ffffffffc02008f6:	eb80                	sd	s0,16(a5)
}
ffffffffc02008f8:	6442                	ld	s0,16(sp)
ffffffffc02008fa:	60e2                	ld	ra,24(sp)
    buddy_mgr.base = mem_begin;//记录管理的内存基址（物理地址）
ffffffffc02008fc:	e384                	sd	s1,0(a5)
    buddy_mgr.pages = base;//记录管理的页面数组（虚拟地址）
ffffffffc02008fe:	0127b423          	sd	s2,8(a5)
    cprintf("buddy: 已初始化 %u 页 (基地址物理地址: 0x%016lx)\n", 
ffffffffc0200902:	8626                	mv	a2,s1
}
ffffffffc0200904:	6902                	ld	s2,0(sp)
ffffffffc0200906:	64a2                	ld	s1,8(sp)
    cprintf("buddy: 已初始化 %u 页 (基地址物理地址: 0x%016lx)\n", 
ffffffffc0200908:	00002517          	auipc	a0,0x2
ffffffffc020090c:	9f850513          	addi	a0,a0,-1544 # ffffffffc0202300 <etext+0x480>
}
ffffffffc0200910:	6105                	addi	sp,sp,32
    cprintf("buddy: 已初始化 %u 页 (基地址物理地址: 0x%016lx)\n", 
ffffffffc0200912:	83bff06f          	j	ffffffffc020014c <cprintf>
    assert(n > 0); 
ffffffffc0200916:	00002697          	auipc	a3,0x2
ffffffffc020091a:	9e268693          	addi	a3,a3,-1566 # ffffffffc02022f8 <etext+0x478>
ffffffffc020091e:	00001617          	auipc	a2,0x1
ffffffffc0200922:	7ea60613          	addi	a2,a2,2026 # ffffffffc0202108 <etext+0x288>
ffffffffc0200926:	10300593          	li	a1,259
ffffffffc020092a:	00001517          	auipc	a0,0x1
ffffffffc020092e:	7f650513          	addi	a0,a0,2038 # ffffffffc0202120 <etext+0x2a0>
ffffffffc0200932:	891ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200936 <buddy_alloc_pages>:
    if (n == 0 || buddy_mgr.size == 0) {
ffffffffc0200936:	18050063          	beqz	a0,ffffffffc0200ab6 <buddy_alloc_pages+0x180>
ffffffffc020093a:	00006617          	auipc	a2,0x6
ffffffffc020093e:	6de60613          	addi	a2,a2,1758 # ffffffffc0207018 <buddy_mgr>
ffffffffc0200942:	00062803          	lw	a6,0(a2)
ffffffffc0200946:	16080863          	beqz	a6,ffffffffc0200ab6 <buddy_alloc_pages+0x180>
    unsigned alloc_size = fixsize(n);
ffffffffc020094a:	2501                	sext.w	a0,a0
    if (size == 0) return 1;
ffffffffc020094c:	16050263          	beqz	a0,ffffffffc0200ab0 <buddy_alloc_pages+0x17a>
    size -= 1;
ffffffffc0200950:	357d                	addiw	a0,a0,-1
    size |= size >> 1;
ffffffffc0200952:	0015579b          	srliw	a5,a0,0x1
ffffffffc0200956:	8fc9                	or	a5,a5,a0
    size |= size >> 2;
ffffffffc0200958:	0027d51b          	srliw	a0,a5,0x2
ffffffffc020095c:	8fc9                	or	a5,a5,a0
    size |= size >> 4;
ffffffffc020095e:	0047d71b          	srliw	a4,a5,0x4
ffffffffc0200962:	8fd9                	or	a5,a5,a4
    size |= size >> 8;
ffffffffc0200964:	0087d71b          	srliw	a4,a5,0x8
ffffffffc0200968:	8fd9                	or	a5,a5,a4
    size |= size >> 16;
ffffffffc020096a:	0107d71b          	srliw	a4,a5,0x10
ffffffffc020096e:	8fd9                	or	a5,a5,a4
    return size + 1;
ffffffffc0200970:	0017871b          	addiw	a4,a5,1
ffffffffc0200974:	0007059b          	sext.w	a1,a4
    size |= size >> 16;
ffffffffc0200978:	2781                	sext.w	a5,a5
    if (alloc_size > buddy_mgr.size) {
ffffffffc020097a:	12b86e63          	bltu	a6,a1,ffffffffc0200ab6 <buddy_alloc_pages+0x180>
        size = 1;
ffffffffc020097e:	4685                	li	a3,1
    if (size <= 0)
ffffffffc0200980:	12059d63          	bnez	a1,ffffffffc0200aba <buddy_alloc_pages+0x184>
    if (buddy_mgr.longest[index] < size)
ffffffffc0200984:	425c                	lw	a5,4(a2)
static struct Page *buddy_alloc_pages(size_t n) {
ffffffffc0200986:	1141                	addi	sp,sp,-16
ffffffffc0200988:	e406                	sd	ra,8(sp)
    if (buddy_mgr.longest[index] < size)
ffffffffc020098a:	14d7ed63          	bltu	a5,a3,ffffffffc0200ae4 <buddy_alloc_pages+0x1ae>
    for (node_size = buddy_mgr.size; node_size != size; node_size /= 2) {
ffffffffc020098e:	16d80363          	beq	a6,a3,ffffffffc0200af4 <buddy_alloc_pages+0x1be>
ffffffffc0200992:	8542                	mv	a0,a6
    unsigned index = 0;
ffffffffc0200994:	4781                	li	a5,0
        if (buddy_mgr.longest[LEFT_LEAF(index)] >= size) {
ffffffffc0200996:	0017989b          	slliw	a7,a5,0x1
ffffffffc020099a:	0018879b          	addiw	a5,a7,1
ffffffffc020099e:	02079313          	slli	t1,a5,0x20
ffffffffc02009a2:	01e35713          	srli	a4,t1,0x1e
ffffffffc02009a6:	9732                	add	a4,a4,a2
ffffffffc02009a8:	4358                	lw	a4,4(a4)
ffffffffc02009aa:	00d77463          	bgeu	a4,a3,ffffffffc02009b2 <buddy_alloc_pages+0x7c>
            index = RIGHT_LEAF(index); // 右子树有合适块，走右路
ffffffffc02009ae:	0028879b          	addiw	a5,a7,2
    for (node_size = buddy_mgr.size; node_size != size; node_size /= 2) {
ffffffffc02009b2:	0015551b          	srliw	a0,a0,0x1
ffffffffc02009b6:	fea690e3          	bne	a3,a0,ffffffffc0200996 <buddy_alloc_pages+0x60>
    offset = (index + 1) * node_size - buddy_mgr.size;  // 计算其在管理范围内的页偏移页偏移
ffffffffc02009ba:	0017871b          	addiw	a4,a5,1
ffffffffc02009be:	02d706bb          	mulw	a3,a4,a3
    buddy_mgr.longest[index] = 0;
ffffffffc02009c2:	02079893          	slli	a7,a5,0x20
ffffffffc02009c6:	01e8d513          	srli	a0,a7,0x1e
ffffffffc02009ca:	9532                	add	a0,a0,a2
ffffffffc02009cc:	00052223          	sw	zero,4(a0)
    offset = (index + 1) * node_size - buddy_mgr.size;  // 计算其在管理范围内的页偏移页偏移
ffffffffc02009d0:	4106853b          	subw	a0,a3,a6
    while (index != 0) {
ffffffffc02009d4:	e781                	bnez	a5,ffffffffc02009dc <buddy_alloc_pages+0xa6>
ffffffffc02009d6:	a0a1                	j	ffffffffc0200a1e <buddy_alloc_pages+0xe8>
ffffffffc02009d8:	0017871b          	addiw	a4,a5,1
        index = PARENT(index);
ffffffffc02009dc:	0017579b          	srliw	a5,a4,0x1
ffffffffc02009e0:	37fd                	addiw	a5,a5,-1
        buddy_mgr.longest[index] = MAX(
ffffffffc02009e2:	0017969b          	slliw	a3,a5,0x1
ffffffffc02009e6:	9b79                	andi	a4,a4,-2
ffffffffc02009e8:	2685                	addiw	a3,a3,1
ffffffffc02009ea:	1702                	slli	a4,a4,0x20
ffffffffc02009ec:	02069893          	slli	a7,a3,0x20
ffffffffc02009f0:	9301                	srli	a4,a4,0x20
ffffffffc02009f2:	01e8d693          	srli	a3,a7,0x1e
ffffffffc02009f6:	070a                	slli	a4,a4,0x2
ffffffffc02009f8:	9732                	add	a4,a4,a2
ffffffffc02009fa:	96b2                	add	a3,a3,a2
ffffffffc02009fc:	00472883          	lw	a7,4(a4)
ffffffffc0200a00:	42d4                	lw	a3,4(a3)
ffffffffc0200a02:	02079313          	slli	t1,a5,0x20
ffffffffc0200a06:	01e35713          	srli	a4,t1,0x1e
ffffffffc0200a0a:	00068e1b          	sext.w	t3,a3
ffffffffc0200a0e:	0008831b          	sext.w	t1,a7
ffffffffc0200a12:	9732                	add	a4,a4,a2
ffffffffc0200a14:	006e7363          	bgeu	t3,t1,ffffffffc0200a1a <buddy_alloc_pages+0xe4>
ffffffffc0200a18:	86c6                	mv	a3,a7
ffffffffc0200a1a:	c354                	sw	a3,4(a4)
    while (index != 0) {
ffffffffc0200a1c:	ffd5                	bnez	a5,ffffffffc02009d8 <buddy_alloc_pages+0xa2>
    return offset;
ffffffffc0200a1e:	0005079b          	sext.w	a5,a0
    if (offset < 0) {
ffffffffc0200a22:	0c07c163          	bltz	a5,ffffffffc0200ae4 <buddy_alloc_pages+0x1ae>
    uintptr_t pa = buddy_mgr.base + offset * PGSIZE;
ffffffffc0200a26:	00c5179b          	slliw	a5,a0,0xc
ffffffffc0200a2a:	00026617          	auipc	a2,0x26
ffffffffc0200a2e:	5ee60613          	addi	a2,a2,1518 # ffffffffc0227018 <buddy_mgr+0x20000>
ffffffffc0200a32:	6208                	ld	a0,0(a2)
static inline int page_ref_inc(struct Page *page) { return ++page->ref; }
static inline int page_ref_dec(struct Page *page) { return --page->ref; }

static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0200a34:	00026717          	auipc	a4,0x26
ffffffffc0200a38:	62473703          	ld	a4,1572(a4) # ffffffffc0227058 <npage>
ffffffffc0200a3c:	97aa                	add	a5,a5,a0
ffffffffc0200a3e:	83b1                	srli	a5,a5,0xc
ffffffffc0200a40:	0ee7f263          	bgeu	a5,a4,ffffffffc0200b24 <buddy_alloc_pages+0x1ee>
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0200a44:	00003717          	auipc	a4,0x3
ffffffffc0200a48:	ac473703          	ld	a4,-1340(a4) # ffffffffc0203508 <nbase>
ffffffffc0200a4c:	8f99                	sub	a5,a5,a4
ffffffffc0200a4e:	00279513          	slli	a0,a5,0x2
ffffffffc0200a52:	97aa                	add	a5,a5,a0
    assert(page >= buddy_mgr.pages && page + alloc_size <= buddy_mgr.pages + buddy_mgr.size);
ffffffffc0200a54:	6614                	ld	a3,8(a2)
ffffffffc0200a56:	078e                	slli	a5,a5,0x3
ffffffffc0200a58:	00026517          	auipc	a0,0x26
ffffffffc0200a5c:	60853503          	ld	a0,1544(a0) # ffffffffc0227060 <pages>
ffffffffc0200a60:	953e                	add	a0,a0,a5
ffffffffc0200a62:	08d56f63          	bltu	a0,a3,ffffffffc0200b00 <buddy_alloc_pages+0x1ca>
ffffffffc0200a66:	02059893          	slli	a7,a1,0x20
ffffffffc0200a6a:	1802                	slli	a6,a6,0x20
ffffffffc0200a6c:	0208d893          	srli	a7,a7,0x20
ffffffffc0200a70:	02085813          	srli	a6,a6,0x20
ffffffffc0200a74:	00289713          	slli	a4,a7,0x2
ffffffffc0200a78:	00281793          	slli	a5,a6,0x2
ffffffffc0200a7c:	9746                	add	a4,a4,a7
ffffffffc0200a7e:	983e                	add	a6,a6,a5
ffffffffc0200a80:	070e                	slli	a4,a4,0x3
ffffffffc0200a82:	080e                	slli	a6,a6,0x3
ffffffffc0200a84:	972a                	add	a4,a4,a0
ffffffffc0200a86:	9836                	add	a6,a6,a3
ffffffffc0200a88:	06e86c63          	bltu	a6,a4,ffffffffc0200b00 <buddy_alloc_pages+0x1ca>
    for (size_t i = 0; i < alloc_size; i++) {
ffffffffc0200a8c:	87aa                	mv	a5,a0
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200a8e:	4685                	li	a3,1
ffffffffc0200a90:	00088863          	beqz	a7,ffffffffc0200aa0 <buddy_alloc_pages+0x16a>
ffffffffc0200a94:	c394                	sw	a3,0(a5)
        p->property = alloc_size; // 记录实际分配的块大小，不同于first-fit，每页都记了,可搭配后续起始页校验
ffffffffc0200a96:	cb8c                	sw	a1,16(a5)
    for (size_t i = 0; i < alloc_size; i++) {
ffffffffc0200a98:	02878793          	addi	a5,a5,40
ffffffffc0200a9c:	fee79ce3          	bne	a5,a4,ffffffffc0200a94 <buddy_alloc_pages+0x15e>
    buddy_mgr.total_free -= alloc_size;
ffffffffc0200aa0:	6a1c                	ld	a5,16(a2)
ffffffffc0200aa2:	411788b3          	sub	a7,a5,a7
ffffffffc0200aa6:	01163823          	sd	a7,16(a2)
}
ffffffffc0200aaa:	60a2                	ld	ra,8(sp)
ffffffffc0200aac:	0141                	addi	sp,sp,16
ffffffffc0200aae:	8082                	ret
ffffffffc0200ab0:	4585                	li	a1,1
ffffffffc0200ab2:	4685                	li	a3,1
ffffffffc0200ab4:	bdc1                	j	ffffffffc0200984 <buddy_alloc_pages+0x4e>
        return NULL;
ffffffffc0200ab6:	4501                	li	a0,0
}
ffffffffc0200ab8:	8082                	ret
    else if (!IS_POWER_OF_2(size))
ffffffffc0200aba:	8f7d                	and	a4,a4,a5
ffffffffc0200abc:	2701                	sext.w	a4,a4
ffffffffc0200abe:	c32d                	beqz	a4,ffffffffc0200b20 <buddy_alloc_pages+0x1ea>
    size |= size >> 1;
ffffffffc0200ac0:	0017d71b          	srliw	a4,a5,0x1
ffffffffc0200ac4:	8fd9                	or	a5,a5,a4
    size |= size >> 2;
ffffffffc0200ac6:	0027d71b          	srliw	a4,a5,0x2
ffffffffc0200aca:	8fd9                	or	a5,a5,a4
    size |= size >> 4;
ffffffffc0200acc:	0047d71b          	srliw	a4,a5,0x4
ffffffffc0200ad0:	8fd9                	or	a5,a5,a4
    size |= size >> 8;
ffffffffc0200ad2:	0087d71b          	srliw	a4,a5,0x8
ffffffffc0200ad6:	8fd9                	or	a5,a5,a4
    size |= size >> 16;
ffffffffc0200ad8:	0107d71b          	srliw	a4,a5,0x10
ffffffffc0200adc:	8fd9                	or	a5,a5,a4
    return size + 1;
ffffffffc0200ade:	0017869b          	addiw	a3,a5,1
ffffffffc0200ae2:	b54d                	j	ffffffffc0200984 <buddy_alloc_pages+0x4e>
        cprintf("buddy: 分配 %u 页失败 (无空闲块)\n", alloc_size);
ffffffffc0200ae4:	00002517          	auipc	a0,0x2
ffffffffc0200ae8:	88c50513          	addi	a0,a0,-1908 # ffffffffc0202370 <etext+0x4f0>
ffffffffc0200aec:	e60ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        return NULL;
ffffffffc0200af0:	4501                	li	a0,0
ffffffffc0200af2:	bf65                	j	ffffffffc0200aaa <buddy_alloc_pages+0x174>
    buddy_mgr.longest[index] = 0;
ffffffffc0200af4:	00006797          	auipc	a5,0x6
ffffffffc0200af8:	5207a423          	sw	zero,1320(a5) # ffffffffc020701c <buddy_mgr+0x4>
ffffffffc0200afc:	4781                	li	a5,0
ffffffffc0200afe:	b735                	j	ffffffffc0200a2a <buddy_alloc_pages+0xf4>
    assert(page >= buddy_mgr.pages && page + alloc_size <= buddy_mgr.pages + buddy_mgr.size);
ffffffffc0200b00:	00002697          	auipc	a3,0x2
ffffffffc0200b04:	8d068693          	addi	a3,a3,-1840 # ffffffffc02023d0 <etext+0x550>
ffffffffc0200b08:	00001617          	auipc	a2,0x1
ffffffffc0200b0c:	60060613          	addi	a2,a2,1536 # ffffffffc0202108 <etext+0x288>
ffffffffc0200b10:	13c00593          	li	a1,316
ffffffffc0200b14:	00001517          	auipc	a0,0x1
ffffffffc0200b18:	60c50513          	addi	a0,a0,1548 # ffffffffc0202120 <etext+0x2a0>
ffffffffc0200b1c:	ea6ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc0200b20:	86ae                	mv	a3,a1
ffffffffc0200b22:	b58d                	j	ffffffffc0200984 <buddy_alloc_pages+0x4e>
        panic("pa2page called with invalid pa");
ffffffffc0200b24:	00002617          	auipc	a2,0x2
ffffffffc0200b28:	87c60613          	addi	a2,a2,-1924 # ffffffffc02023a0 <etext+0x520>
ffffffffc0200b2c:	05800593          	li	a1,88
ffffffffc0200b30:	00002517          	auipc	a0,0x2
ffffffffc0200b34:	89050513          	addi	a0,a0,-1904 # ffffffffc02023c0 <etext+0x540>
ffffffffc0200b38:	e8aff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200b3c <buddy_check>:

    cprintf("  异常场景测试通过\n");
}

// 主校验函数
void buddy_check(void) {
ffffffffc0200b3c:	711d                	addi	sp,sp,-96
ffffffffc0200b3e:	e8a2                	sd	s0,80(sp)
    if (buddy_mgr.size == 0) {
ffffffffc0200b40:	00006417          	auipc	s0,0x6
ffffffffc0200b44:	4d840413          	addi	s0,s0,1240 # ffffffffc0207018 <buddy_mgr>
ffffffffc0200b48:	401c                	lw	a5,0(s0)
void buddy_check(void) {
ffffffffc0200b4a:	ec86                	sd	ra,88(sp)
ffffffffc0200b4c:	e4a6                	sd	s1,72(sp)
ffffffffc0200b4e:	e0ca                	sd	s2,64(sp)
ffffffffc0200b50:	fc4e                	sd	s3,56(sp)
ffffffffc0200b52:	f852                	sd	s4,48(sp)
ffffffffc0200b54:	f456                	sd	s5,40(sp)
ffffffffc0200b56:	f05a                	sd	s6,32(sp)
ffffffffc0200b58:	ec5e                	sd	s7,24(sp)
ffffffffc0200b5a:	e862                	sd	s8,16(sp)
ffffffffc0200b5c:	e466                	sd	s9,8(sp)
        cprintf("buddy_check: 未初始化！\n");
ffffffffc0200b5e:	00002517          	auipc	a0,0x2
ffffffffc0200b62:	8ca50513          	addi	a0,a0,-1846 # ffffffffc0202428 <etext+0x5a8>
    if (buddy_mgr.size == 0) {
ffffffffc0200b66:	42078e63          	beqz	a5,ffffffffc0200fa2 <buddy_check+0x466>
        return;
    }

    cprintf("[buddy_check] begin\n");
ffffffffc0200b6a:	00002517          	auipc	a0,0x2
ffffffffc0200b6e:	8de50513          	addi	a0,a0,-1826 # ffffffffc0202448 <etext+0x5c8>
ffffffffc0200b72:	ddaff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("管理页数：%u 页，物理基地址：0x%016lx\n", buddy_mgr.size, buddy_mgr.base);
ffffffffc0200b76:	00026497          	auipc	s1,0x26
ffffffffc0200b7a:	4a248493          	addi	s1,s1,1186 # ffffffffc0227018 <buddy_mgr+0x20000>
ffffffffc0200b7e:	6090                	ld	a2,0(s1)
ffffffffc0200b80:	400c                	lw	a1,0(s0)
ffffffffc0200b82:	00002517          	auipc	a0,0x2
ffffffffc0200b86:	8de50513          	addi	a0,a0,-1826 # ffffffffc0202460 <etext+0x5e0>
ffffffffc0200b8a:	dc2ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("\n=== [1] 基础功能测试：1页 + 3页 + 4页 分配释放 ===\n");
ffffffffc0200b8e:	00002517          	auipc	a0,0x2
ffffffffc0200b92:	90a50513          	addi	a0,a0,-1782 # ffffffffc0202498 <etext+0x618>
ffffffffc0200b96:	db6ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    size_t initial_free = buddy_mgr.total_free;
ffffffffc0200b9a:	0104bb03          	ld	s6,16(s1)
    cprintf("  [Step] %s: 空闲页数=%lu, 根节点最大块=%u\n", 
ffffffffc0200b9e:	4054                	lw	a3,4(s0)
ffffffffc0200ba0:	00002597          	auipc	a1,0x2
ffffffffc0200ba4:	94058593          	addi	a1,a1,-1728 # ffffffffc02024e0 <etext+0x660>
ffffffffc0200ba8:	865a                	mv	a2,s6
ffffffffc0200baa:	00002517          	auipc	a0,0x2
ffffffffc0200bae:	94650513          	addi	a0,a0,-1722 # ffffffffc02024f0 <etext+0x670>
ffffffffc0200bb2:	d9aff0ef          	jal	ra,ffffffffc020014c <cprintf>
    struct Page* p1 = buddy_alloc_pages(1);
ffffffffc0200bb6:	4505                	li	a0,1
ffffffffc0200bb8:	d7fff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200bbc:	8c2a                	mv	s8,a0
    assert(p1 && "Step1: 分配 1 页失败");
ffffffffc0200bbe:	4a050763          	beqz	a0,ffffffffc020106c <buddy_check+0x530>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200bc2:	00026a17          	auipc	s4,0x26
ffffffffc0200bc6:	49ea0a13          	addi	s4,s4,1182 # ffffffffc0227060 <pages>
ffffffffc0200bca:	000a3903          	ld	s2,0(s4)
ffffffffc0200bce:	00003997          	auipc	s3,0x3
ffffffffc0200bd2:	9329b983          	ld	s3,-1742(s3) # ffffffffc0203500 <error_string+0x38>
ffffffffc0200bd6:	00003a97          	auipc	s5,0x3
ffffffffc0200bda:	932aba83          	ld	s5,-1742(s5) # ffffffffc0203508 <nbase>
ffffffffc0200bde:	41250933          	sub	s2,a0,s2
ffffffffc0200be2:	40395913          	srai	s2,s2,0x3
ffffffffc0200be6:	03390933          	mul	s2,s2,s3
    cprintf("Step1: Alloc 1 page at 0x%016lx\n", pa1);
ffffffffc0200bea:	00002517          	auipc	a0,0x2
ffffffffc0200bee:	96650513          	addi	a0,a0,-1690 # ffffffffc0202550 <etext+0x6d0>
ffffffffc0200bf2:	9956                	add	s2,s2,s5
    return ((uintptr_t)page2ppn(page)) << PGSHIFT;
ffffffffc0200bf4:	0932                	slli	s2,s2,0xc
ffffffffc0200bf6:	85ca                	mv	a1,s2
ffffffffc0200bf8:	d54ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  [Step] %s: 空闲页数=%lu, 根节点最大块=%u\n", 
ffffffffc0200bfc:	4054                	lw	a3,4(s0)
ffffffffc0200bfe:	6890                	ld	a2,16(s1)
ffffffffc0200c00:	00002597          	auipc	a1,0x2
ffffffffc0200c04:	97858593          	addi	a1,a1,-1672 # ffffffffc0202578 <etext+0x6f8>
ffffffffc0200c08:	00002517          	auipc	a0,0x2
ffffffffc0200c0c:	8e850513          	addi	a0,a0,-1816 # ffffffffc02024f0 <etext+0x670>
ffffffffc0200c10:	d3cff0ef          	jal	ra,ffffffffc020014c <cprintf>
    struct Page* p3 = buddy_alloc_pages(3);
ffffffffc0200c14:	450d                	li	a0,3
ffffffffc0200c16:	d21ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200c1a:	8caa                	mv	s9,a0
    assert(p3 && "Step2: 分配 3 页失败");
ffffffffc0200c1c:	42050863          	beqz	a0,ffffffffc020104c <buddy_check+0x510>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200c20:	000a3b83          	ld	s7,0(s4)
    cprintf("Step2: Alloc 3 pages (aligned to 4) at 0x%016lx\n", pa3);
ffffffffc0200c24:	00002517          	auipc	a0,0x2
ffffffffc0200c28:	98c50513          	addi	a0,a0,-1652 # ffffffffc02025b0 <etext+0x730>
ffffffffc0200c2c:	417c8bb3          	sub	s7,s9,s7
ffffffffc0200c30:	403bdb93          	srai	s7,s7,0x3
ffffffffc0200c34:	033b8bb3          	mul	s7,s7,s3
ffffffffc0200c38:	9bd6                	add	s7,s7,s5
    return ((uintptr_t)page2ppn(page)) << PGSHIFT;
ffffffffc0200c3a:	0bb2                	slli	s7,s7,0xc
ffffffffc0200c3c:	85de                	mv	a1,s7
ffffffffc0200c3e:	d0eff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  [Step] %s: 空闲页数=%lu, 根节点最大块=%u\n", 
ffffffffc0200c42:	4054                	lw	a3,4(s0)
ffffffffc0200c44:	6890                	ld	a2,16(s1)
ffffffffc0200c46:	00002597          	auipc	a1,0x2
ffffffffc0200c4a:	9a258593          	addi	a1,a1,-1630 # ffffffffc02025e8 <etext+0x768>
ffffffffc0200c4e:	00002517          	auipc	a0,0x2
ffffffffc0200c52:	8a250513          	addi	a0,a0,-1886 # ffffffffc02024f0 <etext+0x670>
ffffffffc0200c56:	cf6ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    buddy_free_pages(p1, 1);
ffffffffc0200c5a:	8562                	mv	a0,s8
ffffffffc0200c5c:	4585                	li	a1,1
ffffffffc0200c5e:	97dff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
    cprintf("Step3: Freed 1 page at 0x%016lx\n", pa1);
ffffffffc0200c62:	85ca                	mv	a1,s2
ffffffffc0200c64:	00002517          	auipc	a0,0x2
ffffffffc0200c68:	9a450513          	addi	a0,a0,-1628 # ffffffffc0202608 <etext+0x788>
ffffffffc0200c6c:	ce0ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  [Step] %s: 空闲页数=%lu, 根节点最大块=%u\n", 
ffffffffc0200c70:	4054                	lw	a3,4(s0)
ffffffffc0200c72:	6890                	ld	a2,16(s1)
ffffffffc0200c74:	00002597          	auipc	a1,0x2
ffffffffc0200c78:	9bc58593          	addi	a1,a1,-1604 # ffffffffc0202630 <etext+0x7b0>
ffffffffc0200c7c:	00002517          	auipc	a0,0x2
ffffffffc0200c80:	87450513          	addi	a0,a0,-1932 # ffffffffc02024f0 <etext+0x670>
ffffffffc0200c84:	cc8ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    struct Page* p4 = buddy_alloc_pages(4);
ffffffffc0200c88:	4511                	li	a0,4
ffffffffc0200c8a:	cadff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200c8e:	8c2a                	mv	s8,a0
    assert(p4 && "Step4: 分配 4 页失败");
ffffffffc0200c90:	3e050e63          	beqz	a0,ffffffffc020108c <buddy_check+0x550>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200c94:	000a3903          	ld	s2,0(s4)
    cprintf("Step4: Alloc 4 pages at 0x%016lx\n", pa4);
ffffffffc0200c98:	00002517          	auipc	a0,0x2
ffffffffc0200c9c:	9d050513          	addi	a0,a0,-1584 # ffffffffc0202668 <etext+0x7e8>
ffffffffc0200ca0:	412c0933          	sub	s2,s8,s2
ffffffffc0200ca4:	40395913          	srai	s2,s2,0x3
ffffffffc0200ca8:	03390933          	mul	s2,s2,s3
ffffffffc0200cac:	9956                	add	s2,s2,s5
    return ((uintptr_t)page2ppn(page)) << PGSHIFT;
ffffffffc0200cae:	0932                	slli	s2,s2,0xc
ffffffffc0200cb0:	85ca                	mv	a1,s2
ffffffffc0200cb2:	c9aff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  [Step] %s: 空闲页数=%lu, 根节点最大块=%u\n", 
ffffffffc0200cb6:	4054                	lw	a3,4(s0)
ffffffffc0200cb8:	6890                	ld	a2,16(s1)
ffffffffc0200cba:	00002597          	auipc	a1,0x2
ffffffffc0200cbe:	9d658593          	addi	a1,a1,-1578 # ffffffffc0202690 <etext+0x810>
ffffffffc0200cc2:	00002517          	auipc	a0,0x2
ffffffffc0200cc6:	82e50513          	addi	a0,a0,-2002 # ffffffffc02024f0 <etext+0x670>
ffffffffc0200cca:	c82ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    buddy_free_pages(p3, 3);
ffffffffc0200cce:	8566                	mv	a0,s9
ffffffffc0200cd0:	458d                	li	a1,3
ffffffffc0200cd2:	909ff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
    cprintf("Step5: Freed 3-page block (4 aligned) at 0x%016lx\n", pa3);
ffffffffc0200cd6:	85de                	mv	a1,s7
ffffffffc0200cd8:	00002517          	auipc	a0,0x2
ffffffffc0200cdc:	9c850513          	addi	a0,a0,-1592 # ffffffffc02026a0 <etext+0x820>
ffffffffc0200ce0:	c6cff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  [Step] %s: 空闲页数=%lu, 根节点最大块=%u\n", 
ffffffffc0200ce4:	4054                	lw	a3,4(s0)
ffffffffc0200ce6:	6890                	ld	a2,16(s1)
ffffffffc0200ce8:	00002597          	auipc	a1,0x2
ffffffffc0200cec:	9f058593          	addi	a1,a1,-1552 # ffffffffc02026d8 <etext+0x858>
ffffffffc0200cf0:	00002517          	auipc	a0,0x2
ffffffffc0200cf4:	80050513          	addi	a0,a0,-2048 # ffffffffc02024f0 <etext+0x670>
ffffffffc0200cf8:	c54ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    buddy_free_pages(p4, 4);
ffffffffc0200cfc:	8562                	mv	a0,s8
ffffffffc0200cfe:	4591                	li	a1,4
ffffffffc0200d00:	8dbff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
    cprintf("Step6: Freed 4-page block at 0x%016lx\n", pa4);
ffffffffc0200d04:	85ca                	mv	a1,s2
ffffffffc0200d06:	00002517          	auipc	a0,0x2
ffffffffc0200d0a:	9e250513          	addi	a0,a0,-1566 # ffffffffc02026e8 <etext+0x868>
ffffffffc0200d0e:	c3eff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  [Step] %s: 空闲页数=%lu, 根节点最大块=%u\n", 
ffffffffc0200d12:	4054                	lw	a3,4(s0)
ffffffffc0200d14:	6890                	ld	a2,16(s1)
ffffffffc0200d16:	00002597          	auipc	a1,0x2
ffffffffc0200d1a:	9fa58593          	addi	a1,a1,-1542 # ffffffffc0202710 <etext+0x890>
ffffffffc0200d1e:	00001517          	auipc	a0,0x1
ffffffffc0200d22:	7d250513          	addi	a0,a0,2002 # ffffffffc02024f0 <etext+0x670>
ffffffffc0200d26:	c26ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    assert(buddy_mgr.total_free == initial_free);
ffffffffc0200d2a:	689c                	ld	a5,16(s1)
ffffffffc0200d2c:	3afb1063          	bne	s6,a5,ffffffffc02010cc <buddy_check+0x590>
    assert(buddy_mgr.longest[0] == buddy_mgr.size);
ffffffffc0200d30:	4058                	lw	a4,4(s0)
ffffffffc0200d32:	401c                	lw	a5,0(s0)
ffffffffc0200d34:	50f71f63          	bne	a4,a5,ffffffffc0201252 <buddy_check+0x716>
    cprintf(" 基础功能测试通过：1页+3页+4页 测试完成\n");
ffffffffc0200d38:	00002517          	auipc	a0,0x2
ffffffffc0200d3c:	a3850513          	addi	a0,a0,-1480 # ffffffffc0202770 <etext+0x8f0>
ffffffffc0200d40:	c0cff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("\n=== [2] 边界场景测试：分配满后再试1页 ===\n");
ffffffffc0200d44:	00002517          	auipc	a0,0x2
ffffffffc0200d48:	a6c50513          	addi	a0,a0,-1428 # ffffffffc02027b0 <etext+0x930>
ffffffffc0200d4c:	c00ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    size_t max_pages    = buddy_mgr.size;
ffffffffc0200d50:	00042903          	lw	s2,0(s0)
    size_t initial_free = buddy_mgr.total_free;
ffffffffc0200d54:	0104bb83          	ld	s7,16(s1)
    size_t max_pages    = buddy_mgr.size;
ffffffffc0200d58:	02091b13          	slli	s6,s2,0x20
ffffffffc0200d5c:	020b5b13          	srli	s6,s6,0x20
    struct Page* p_max = buddy_alloc_pages(max_pages);
ffffffffc0200d60:	855a                	mv	a0,s6
ffffffffc0200d62:	bd5ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200d66:	8c2a                	mv	s8,a0
    assert(p_max && "分配最大页数失败（p_max == NULL）");
ffffffffc0200d68:	4c050563          	beqz	a0,ffffffffc0201232 <buddy_check+0x6f6>
    assert(buddy_mgr.total_free == 0 && buddy_mgr.longest[0] == 0);
ffffffffc0200d6c:	689c                	ld	a5,16(s1)
ffffffffc0200d6e:	2a079f63          	bnez	a5,ffffffffc020102c <buddy_check+0x4f0>
ffffffffc0200d72:	405c                	lw	a5,4(s0)
ffffffffc0200d74:	2a079c63          	bnez	a5,ffffffffc020102c <buddy_check+0x4f0>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d78:	000a3603          	ld	a2,0(s4)
    cprintf("  已分配最大页数：%lu 页，起始物理地址：0x%016lx\n",
ffffffffc0200d7c:	85da                	mv	a1,s6
ffffffffc0200d7e:	00002517          	auipc	a0,0x2
ffffffffc0200d82:	ae250513          	addi	a0,a0,-1310 # ffffffffc0202860 <etext+0x9e0>
ffffffffc0200d86:	40cc0633          	sub	a2,s8,a2
ffffffffc0200d8a:	860d                	srai	a2,a2,0x3
ffffffffc0200d8c:	03360633          	mul	a2,a2,s3
ffffffffc0200d90:	9656                	add	a2,a2,s5
ffffffffc0200d92:	0632                	slli	a2,a2,0xc
ffffffffc0200d94:	bb8ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  [Step] %s: 空闲页数=%lu, 根节点最大块=%u\n", 
ffffffffc0200d98:	4054                	lw	a3,4(s0)
ffffffffc0200d9a:	6890                	ld	a2,16(s1)
ffffffffc0200d9c:	00002597          	auipc	a1,0x2
ffffffffc0200da0:	b0c58593          	addi	a1,a1,-1268 # ffffffffc02028a8 <etext+0xa28>
ffffffffc0200da4:	00001517          	auipc	a0,0x1
ffffffffc0200da8:	74c50513          	addi	a0,a0,1868 # ffffffffc02024f0 <etext+0x670>
ffffffffc0200dac:	ba0ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    struct Page* p_extra = buddy_alloc_pages(1);
ffffffffc0200db0:	4505                	li	a0,1
ffffffffc0200db2:	b85ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200db6:	8caa                	mv	s9,a0
    if (p_extra == NULL) {
ffffffffc0200db8:	42051a63          	bnez	a0,ffffffffc02011ec <buddy_check+0x6b0>
        cprintf("  在满内存情况下再分配 1 页：返回 NULL（正确）\n");
ffffffffc0200dbc:	00002517          	auipc	a0,0x2
ffffffffc0200dc0:	b0450513          	addi	a0,a0,-1276 # ffffffffc02028c0 <etext+0xa40>
ffffffffc0200dc4:	b88ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    buddy_free_pages(p_max, max_pages);
ffffffffc0200dc8:	85da                	mv	a1,s6
ffffffffc0200dca:	8562                	mv	a0,s8
ffffffffc0200dcc:	80fff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
    assert(buddy_mgr.total_free == initial_free && buddy_mgr.longest[0] == max_pages);
ffffffffc0200dd0:	689c                	ld	a5,16(s1)
ffffffffc0200dd2:	22fb9d63          	bne	s7,a5,ffffffffc020100c <buddy_check+0x4d0>
ffffffffc0200dd6:	405c                	lw	a5,4(s0)
ffffffffc0200dd8:	22f91a63          	bne	s2,a5,ffffffffc020100c <buddy_check+0x4d0>
    cprintf("  [Step] %s: 空闲页数=%lu, 根节点最大块=%u\n", 
ffffffffc0200ddc:	86ca                	mv	a3,s2
ffffffffc0200dde:	865e                	mv	a2,s7
ffffffffc0200de0:	00002597          	auipc	a1,0x2
ffffffffc0200de4:	c1058593          	addi	a1,a1,-1008 # ffffffffc02029f0 <etext+0xb70>
ffffffffc0200de8:	00001517          	auipc	a0,0x1
ffffffffc0200dec:	70850513          	addi	a0,a0,1800 # ffffffffc02024f0 <etext+0x670>
ffffffffc0200df0:	b5cff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  边界场景测试通过：分配满→再分配失败→释放后恢复\n");
ffffffffc0200df4:	00002517          	auipc	a0,0x2
ffffffffc0200df8:	c1450513          	addi	a0,a0,-1004 # ffffffffc0202a08 <etext+0xb88>
ffffffffc0200dfc:	b50ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("\n=== [3] 合并逻辑测试：完整合并+部分合并 ===\n");
ffffffffc0200e00:	00002517          	auipc	a0,0x2
ffffffffc0200e04:	c5850513          	addi	a0,a0,-936 # ffffffffc0202a58 <etext+0xbd8>
ffffffffc0200e08:	b44ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  [子测试1] 无阻碍合并（合并至根节点）\n");
ffffffffc0200e0c:	00002517          	auipc	a0,0x2
ffffffffc0200e10:	c8c50513          	addi	a0,a0,-884 # ffffffffc0202a98 <etext+0xc18>
    size_t total_pages = buddy_mgr.size;//根节点页数
ffffffffc0200e14:	00046b03          	lwu	s6,0(s0)
    size_t initial_free = buddy_mgr.total_free;//初始空闲页数
ffffffffc0200e18:	0104b903          	ld	s2,16(s1)
    size_t root_initial_size = buddy_mgr.longest[0];//根节点初始大小
ffffffffc0200e1c:	00442a83          	lw	s5,4(s0)
    cprintf("  [子测试1] 无阻碍合并（合并至根节点）\n");
ffffffffc0200e20:	b2cff0ef          	jal	ra,ffffffffc020014c <cprintf>
    struct Page* p2_a = buddy_alloc_pages(2);
ffffffffc0200e24:	4509                	li	a0,2
ffffffffc0200e26:	b11ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200e2a:	8baa                	mv	s7,a0
    struct Page* p2_b = buddy_alloc_pages(2);
ffffffffc0200e2c:	4509                	li	a0,2
ffffffffc0200e2e:	b09ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200e32:	8c2a                	mv	s8,a0
    assert(p2_a && p2_b && "子测试1：分配2页块失败");
ffffffffc0200e34:	1a0b8c63          	beqz	s7,ffffffffc0200fec <buddy_check+0x4b0>
ffffffffc0200e38:	1a050a63          	beqz	a0,ffffffffc0200fec <buddy_check+0x4b0>
ffffffffc0200e3c:	000a3703          	ld	a4,0(s4)
    assert(pa_b - pa_a == 2 * PGSIZE && "子测试1：非2页伙伴块");
ffffffffc0200e40:	6689                	lui	a3,0x2
ffffffffc0200e42:	40e507b3          	sub	a5,a0,a4
ffffffffc0200e46:	40eb8733          	sub	a4,s7,a4
ffffffffc0200e4a:	878d                	srai	a5,a5,0x3
ffffffffc0200e4c:	870d                	srai	a4,a4,0x3
ffffffffc0200e4e:	8f99                	sub	a5,a5,a4
    return ((uintptr_t)page2ppn(page)) << PGSHIFT;
ffffffffc0200e50:	033787b3          	mul	a5,a5,s3
ffffffffc0200e54:	07b2                	slli	a5,a5,0xc
ffffffffc0200e56:	34d79b63          	bne	a5,a3,ffffffffc02011ac <buddy_check+0x670>
    buddy_free_pages(p2_a, 2);
ffffffffc0200e5a:	4589                	li	a1,2
ffffffffc0200e5c:	855e                	mv	a0,s7
ffffffffc0200e5e:	f7cff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
    buddy_free_pages(p2_b, 2);
ffffffffc0200e62:	4589                	li	a1,2
ffffffffc0200e64:	8562                	mv	a0,s8
ffffffffc0200e66:	f74ff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
    assert(buddy_mgr.longest[0] == root_initial_size && "子测试1：合并至根节点失败");
ffffffffc0200e6a:	405c                	lw	a5,4(s0)
ffffffffc0200e6c:	32fa9063          	bne	s5,a5,ffffffffc020118c <buddy_check+0x650>
    assert(buddy_mgr.total_free == initial_free && "子测试1：空闲页数不匹配");
ffffffffc0200e70:	689c                	ld	a5,16(s1)
ffffffffc0200e72:	2ef91d63          	bne	s2,a5,ffffffffc020116c <buddy_check+0x630>
    cprintf("  [Step] %s: 空闲页数=%lu, 根节点最大块=%u\n", 
ffffffffc0200e76:	86d6                	mv	a3,s5
ffffffffc0200e78:	864a                	mv	a2,s2
ffffffffc0200e7a:	00002597          	auipc	a1,0x2
ffffffffc0200e7e:	d7658593          	addi	a1,a1,-650 # ffffffffc0202bf0 <etext+0xd70>
ffffffffc0200e82:	00001517          	auipc	a0,0x1
ffffffffc0200e86:	66e50513          	addi	a0,a0,1646 # ffffffffc02024f0 <etext+0x670>
ffffffffc0200e8a:	ac2ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  [子测试2] 有阻碍合并（受阻层级停止）\n");
ffffffffc0200e8e:	00002517          	auipc	a0,0x2
ffffffffc0200e92:	d8a50513          	addi	a0,a0,-630 # ffffffffc0202c18 <etext+0xd98>
ffffffffc0200e96:	ab6ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    size_t obstacle_size = total_pages / 2; 
ffffffffc0200e9a:	001b5b13          	srli	s6,s6,0x1
    struct Page* obstacle = buddy_alloc_pages(obstacle_size);
ffffffffc0200e9e:	855a                	mv	a0,s6
ffffffffc0200ea0:	a97ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200ea4:	8baa                	mv	s7,a0
    assert(obstacle && "子测试2：分配阻碍块失败");
ffffffffc0200ea6:	2a050363          	beqz	a0,ffffffffc020114c <buddy_check+0x610>
    struct Page* p2_c = buddy_alloc_pages(2);
ffffffffc0200eaa:	4509                	li	a0,2
ffffffffc0200eac:	a8bff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200eb0:	8caa                	mv	s9,a0
    struct Page* p2_d = buddy_alloc_pages(2);
ffffffffc0200eb2:	4509                	li	a0,2
ffffffffc0200eb4:	a83ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200eb8:	8c2a                	mv	s8,a0
    assert(p2_c && p2_d && "子测试2：分配2页块失败");
ffffffffc0200eba:	100c8963          	beqz	s9,ffffffffc0200fcc <buddy_check+0x490>
ffffffffc0200ebe:	10050763          	beqz	a0,ffffffffc0200fcc <buddy_check+0x490>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200ec2:	000a3703          	ld	a4,0(s4)
    assert(pa_d - pa_c == 2 * PGSIZE && "子测试2：非2页伙伴块");
ffffffffc0200ec6:	6689                	lui	a3,0x2
ffffffffc0200ec8:	40e507b3          	sub	a5,a0,a4
ffffffffc0200ecc:	40ec8733          	sub	a4,s9,a4
ffffffffc0200ed0:	878d                	srai	a5,a5,0x3
ffffffffc0200ed2:	870d                	srai	a4,a4,0x3
ffffffffc0200ed4:	8f99                	sub	a5,a5,a4
    return ((uintptr_t)page2ppn(page)) << PGSHIFT;
ffffffffc0200ed6:	033787b3          	mul	a5,a5,s3
ffffffffc0200eda:	07b2                	slli	a5,a5,0xc
ffffffffc0200edc:	20d79863          	bne	a5,a3,ffffffffc02010ec <buddy_check+0x5b0>
    buddy_free_pages(p2_c, 2);
ffffffffc0200ee0:	4589                	li	a1,2
ffffffffc0200ee2:	8566                	mv	a0,s9
ffffffffc0200ee4:	ef6ff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
    buddy_free_pages(p2_d, 2);
ffffffffc0200ee8:	4589                	li	a1,2
ffffffffc0200eea:	8562                	mv	a0,s8
ffffffffc0200eec:	eeeff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
    assert(buddy_mgr.longest[0] == obstacle_size && "子测试2：错误跨越阻碍块合并");
ffffffffc0200ef0:	4054                	lw	a3,4(s0)
ffffffffc0200ef2:	02069793          	slli	a5,a3,0x20
ffffffffc0200ef6:	9381                	srli	a5,a5,0x20
ffffffffc0200ef8:	20fb1a63          	bne	s6,a5,ffffffffc020110c <buddy_check+0x5d0>
    assert(buddy_mgr.total_free == initial_free - obstacle_size && "子测试2：空闲页数不匹配");
ffffffffc0200efc:	6890                	ld	a2,16(s1)
ffffffffc0200efe:	41690933          	sub	s2,s2,s6
ffffffffc0200f02:	1b261563          	bne	a2,s2,ffffffffc02010ac <buddy_check+0x570>
    cprintf("  [Step] %s: 空闲页数=%lu, 根节点最大块=%u\n", 
ffffffffc0200f06:	00002597          	auipc	a1,0x2
ffffffffc0200f0a:	eb258593          	addi	a1,a1,-334 # ffffffffc0202db8 <etext+0xf38>
ffffffffc0200f0e:	00001517          	auipc	a0,0x1
ffffffffc0200f12:	5e250513          	addi	a0,a0,1506 # ffffffffc02024f0 <etext+0x670>
ffffffffc0200f16:	a36ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    buddy_free_pages(obstacle, obstacle_size);
ffffffffc0200f1a:	85da                	mv	a1,s6
ffffffffc0200f1c:	855e                	mv	a0,s7
ffffffffc0200f1e:	ebcff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
    assert(buddy_mgr.longest[0] == root_initial_size && "子测试2：清理失败（阻碍块未释放）");
ffffffffc0200f22:	405c                	lw	a5,4(s0)
ffffffffc0200f24:	21579463          	bne	a5,s5,ffffffffc020112c <buddy_check+0x5f0>
    cprintf("  合并逻辑测试通过\n");
ffffffffc0200f28:	00002517          	auipc	a0,0x2
ffffffffc0200f2c:	f2850513          	addi	a0,a0,-216 # ffffffffc0202e50 <etext+0xfd0>
ffffffffc0200f30:	a1cff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("\n=== [4] 异常场景测试 ===\n");
ffffffffc0200f34:	00002517          	auipc	a0,0x2
ffffffffc0200f38:	f3c50513          	addi	a0,a0,-196 # ffffffffc0202e70 <etext+0xff0>
ffffffffc0200f3c:	a10ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    size_t max_pages = buddy_mgr.size;
ffffffffc0200f40:	00046503          	lwu	a0,0(s0)
    assert(buddy_alloc_pages(max_pages + 1) == NULL);
ffffffffc0200f44:	0505                	addi	a0,a0,1
ffffffffc0200f46:	9f1ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200f4a:	28051163          	bnez	a0,ffffffffc02011cc <buddy_check+0x690>
    cprintf("  超量分配：正确返回NULL\n");
ffffffffc0200f4e:	00002517          	auipc	a0,0x2
ffffffffc0200f52:	f7a50513          	addi	a0,a0,-134 # ffffffffc0202ec8 <etext+0x1048>
ffffffffc0200f56:	9f6ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    struct Page* p4 = buddy_alloc_pages(4);
ffffffffc0200f5a:	4511                	li	a0,4
ffffffffc0200f5c:	9dbff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
    size_t page_idx_mid = p_mid - buddy_mgr.pages;
ffffffffc0200f60:	649c                	ld	a5,8(s1)
    struct Page* p_mid = p4 + 2; // 中间页（非起始页）
ffffffffc0200f62:	05050593          	addi	a1,a0,80
    size_t free_size_mid = p_mid->property; // 块大小4
ffffffffc0200f66:	06056603          	lwu	a2,96(a0)
    size_t page_idx_mid = p_mid - buddy_mgr.pages;
ffffffffc0200f6a:	8d9d                	sub	a1,a1,a5
ffffffffc0200f6c:	858d                	srai	a1,a1,0x3
ffffffffc0200f6e:	033585b3          	mul	a1,a1,s3
    struct Page* p4 = buddy_alloc_pages(4);
ffffffffc0200f72:	842a                	mv	s0,a0
    if (page_idx_mid % free_size_mid != 0) {
ffffffffc0200f74:	02c5f7b3          	remu	a5,a1,a2
ffffffffc0200f78:	e3b9                	bnez	a5,ffffffffc0200fbe <buddy_check+0x482>
        cprintf("  释放非起始页：未识别 → 错误\n");
ffffffffc0200f7a:	00002517          	auipc	a0,0x2
ffffffffc0200f7e:	fc650513          	addi	a0,a0,-58 # ffffffffc0202f40 <etext+0x10c0>
ffffffffc0200f82:	9caff0ef          	jal	ra,ffffffffc020014c <cprintf>
    buddy_free_pages(p4, 4); 
ffffffffc0200f86:	4591                	li	a1,4
ffffffffc0200f88:	8522                	mv	a0,s0
ffffffffc0200f8a:	e50ff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
    cprintf("  异常场景测试通过\n");
ffffffffc0200f8e:	00002517          	auipc	a0,0x2
ffffffffc0200f92:	fe250513          	addi	a0,a0,-30 # ffffffffc0202f70 <etext+0x10f0>
ffffffffc0200f96:	9b6ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    buddy_check_basic();
    buddy_check_boundary();
    buddy_check_merge();
    buddy_check_abnormal();

    cprintf("all cases passed\n");
ffffffffc0200f9a:	00002517          	auipc	a0,0x2
ffffffffc0200f9e:	ff650513          	addi	a0,a0,-10 # ffffffffc0202f90 <etext+0x1110>
}
ffffffffc0200fa2:	6446                	ld	s0,80(sp)
ffffffffc0200fa4:	60e6                	ld	ra,88(sp)
ffffffffc0200fa6:	64a6                	ld	s1,72(sp)
ffffffffc0200fa8:	6906                	ld	s2,64(sp)
ffffffffc0200faa:	79e2                	ld	s3,56(sp)
ffffffffc0200fac:	7a42                	ld	s4,48(sp)
ffffffffc0200fae:	7aa2                	ld	s5,40(sp)
ffffffffc0200fb0:	7b02                	ld	s6,32(sp)
ffffffffc0200fb2:	6be2                	ld	s7,24(sp)
ffffffffc0200fb4:	6c42                	ld	s8,16(sp)
ffffffffc0200fb6:	6ca2                	ld	s9,8(sp)
ffffffffc0200fb8:	6125                	addi	sp,sp,96
    cprintf("all cases passed\n");
ffffffffc0200fba:	992ff06f          	j	ffffffffc020014c <cprintf>
        cprintf("  释放非起始页：已识别（页偏移=%lu，块大小=%lu）→ 正确\n",
ffffffffc0200fbe:	00002517          	auipc	a0,0x2
ffffffffc0200fc2:	f3250513          	addi	a0,a0,-206 # ffffffffc0202ef0 <etext+0x1070>
ffffffffc0200fc6:	986ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200fca:	bf75                	j	ffffffffc0200f86 <buddy_check+0x44a>
    assert(p2_c && p2_d && "子测试2：分配2页块失败");
ffffffffc0200fcc:	00002697          	auipc	a3,0x2
ffffffffc0200fd0:	cbc68693          	addi	a3,a3,-836 # ffffffffc0202c88 <etext+0xe08>
ffffffffc0200fd4:	00001617          	auipc	a2,0x1
ffffffffc0200fd8:	13460613          	addi	a2,a2,308 # ffffffffc0202108 <etext+0x288>
ffffffffc0200fdc:	1f800593          	li	a1,504
ffffffffc0200fe0:	00001517          	auipc	a0,0x1
ffffffffc0200fe4:	14050513          	addi	a0,a0,320 # ffffffffc0202120 <etext+0x2a0>
ffffffffc0200fe8:	9daff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p2_a && p2_b && "子测试1：分配2页块失败");
ffffffffc0200fec:	00002697          	auipc	a3,0x2
ffffffffc0200ff0:	ae468693          	addi	a3,a3,-1308 # ffffffffc0202ad0 <etext+0xc50>
ffffffffc0200ff4:	00001617          	auipc	a2,0x1
ffffffffc0200ff8:	11460613          	addi	a2,a2,276 # ffffffffc0202108 <etext+0x288>
ffffffffc0200ffc:	1e100593          	li	a1,481
ffffffffc0201000:	00001517          	auipc	a0,0x1
ffffffffc0201004:	12050513          	addi	a0,a0,288 # ffffffffc0202120 <etext+0x2a0>
ffffffffc0201008:	9baff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(buddy_mgr.total_free == initial_free && buddy_mgr.longest[0] == max_pages);
ffffffffc020100c:	00002697          	auipc	a3,0x2
ffffffffc0201010:	99468693          	addi	a3,a3,-1644 # ffffffffc02029a0 <etext+0xb20>
ffffffffc0201014:	00001617          	auipc	a2,0x1
ffffffffc0201018:	0f460613          	addi	a2,a2,244 # ffffffffc0202108 <etext+0x288>
ffffffffc020101c:	1d000593          	li	a1,464
ffffffffc0201020:	00001517          	auipc	a0,0x1
ffffffffc0201024:	10050513          	addi	a0,a0,256 # ffffffffc0202120 <etext+0x2a0>
ffffffffc0201028:	99aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(buddy_mgr.total_free == 0 && buddy_mgr.longest[0] == 0);
ffffffffc020102c:	00001697          	auipc	a3,0x1
ffffffffc0201030:	7fc68693          	addi	a3,a3,2044 # ffffffffc0202828 <etext+0x9a8>
ffffffffc0201034:	00001617          	auipc	a2,0x1
ffffffffc0201038:	0d460613          	addi	a2,a2,212 # ffffffffc0202108 <etext+0x288>
ffffffffc020103c:	1bd00593          	li	a1,445
ffffffffc0201040:	00001517          	auipc	a0,0x1
ffffffffc0201044:	0e050513          	addi	a0,a0,224 # ffffffffc0202120 <etext+0x2a0>
ffffffffc0201048:	97aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p3 && "Step2: 分配 3 页失败");
ffffffffc020104c:	00001697          	auipc	a3,0x1
ffffffffc0201050:	53c68693          	addi	a3,a3,1340 # ffffffffc0202588 <etext+0x708>
ffffffffc0201054:	00001617          	auipc	a2,0x1
ffffffffc0201058:	0b460613          	addi	a2,a2,180 # ffffffffc0202108 <etext+0x288>
ffffffffc020105c:	19100593          	li	a1,401
ffffffffc0201060:	00001517          	auipc	a0,0x1
ffffffffc0201064:	0c050513          	addi	a0,a0,192 # ffffffffc0202120 <etext+0x2a0>
ffffffffc0201068:	95aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p1 && "Step1: 分配 1 页失败");
ffffffffc020106c:	00001697          	auipc	a3,0x1
ffffffffc0201070:	4bc68693          	addi	a3,a3,1212 # ffffffffc0202528 <etext+0x6a8>
ffffffffc0201074:	00001617          	auipc	a2,0x1
ffffffffc0201078:	09460613          	addi	a2,a2,148 # ffffffffc0202108 <etext+0x288>
ffffffffc020107c:	18a00593          	li	a1,394
ffffffffc0201080:	00001517          	auipc	a0,0x1
ffffffffc0201084:	0a050513          	addi	a0,a0,160 # ffffffffc0202120 <etext+0x2a0>
ffffffffc0201088:	93aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p4 && "Step4: 分配 4 页失败");
ffffffffc020108c:	00001697          	auipc	a3,0x1
ffffffffc0201090:	5b468693          	addi	a3,a3,1460 # ffffffffc0202640 <etext+0x7c0>
ffffffffc0201094:	00001617          	auipc	a2,0x1
ffffffffc0201098:	07460613          	addi	a2,a2,116 # ffffffffc0202108 <etext+0x288>
ffffffffc020109c:	19d00593          	li	a1,413
ffffffffc02010a0:	00001517          	auipc	a0,0x1
ffffffffc02010a4:	08050513          	addi	a0,a0,128 # ffffffffc0202120 <etext+0x2a0>
ffffffffc02010a8:	91aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(buddy_mgr.total_free == initial_free - obstacle_size && "子测试2：空闲页数不匹配");
ffffffffc02010ac:	00002697          	auipc	a3,0x2
ffffffffc02010b0:	cac68693          	addi	a3,a3,-852 # ffffffffc0202d58 <etext+0xed8>
ffffffffc02010b4:	00001617          	auipc	a2,0x1
ffffffffc02010b8:	05460613          	addi	a2,a2,84 # ffffffffc0202108 <etext+0x288>
ffffffffc02010bc:	20200593          	li	a1,514
ffffffffc02010c0:	00001517          	auipc	a0,0x1
ffffffffc02010c4:	06050513          	addi	a0,a0,96 # ffffffffc0202120 <etext+0x2a0>
ffffffffc02010c8:	8faff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(buddy_mgr.total_free == initial_free);
ffffffffc02010cc:	00001697          	auipc	a3,0x1
ffffffffc02010d0:	65468693          	addi	a3,a3,1620 # ffffffffc0202720 <etext+0x8a0>
ffffffffc02010d4:	00001617          	auipc	a2,0x1
ffffffffc02010d8:	03460613          	addi	a2,a2,52 # ffffffffc0202108 <etext+0x288>
ffffffffc02010dc:	1ac00593          	li	a1,428
ffffffffc02010e0:	00001517          	auipc	a0,0x1
ffffffffc02010e4:	04050513          	addi	a0,a0,64 # ffffffffc0202120 <etext+0x2a0>
ffffffffc02010e8:	8daff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(pa_d - pa_c == 2 * PGSIZE && "子测试2：非2页伙伴块");
ffffffffc02010ec:	00002697          	auipc	a3,0x2
ffffffffc02010f0:	bd468693          	addi	a3,a3,-1068 # ffffffffc0202cc0 <etext+0xe40>
ffffffffc02010f4:	00001617          	auipc	a2,0x1
ffffffffc02010f8:	01460613          	addi	a2,a2,20 # ffffffffc0202108 <etext+0x288>
ffffffffc02010fc:	1fb00593          	li	a1,507
ffffffffc0201100:	00001517          	auipc	a0,0x1
ffffffffc0201104:	02050513          	addi	a0,a0,32 # ffffffffc0202120 <etext+0x2a0>
ffffffffc0201108:	8baff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(buddy_mgr.longest[0] == obstacle_size && "子测试2：错误跨越阻碍块合并");
ffffffffc020110c:	00002697          	auipc	a3,0x2
ffffffffc0201110:	bf468693          	addi	a3,a3,-1036 # ffffffffc0202d00 <etext+0xe80>
ffffffffc0201114:	00001617          	auipc	a2,0x1
ffffffffc0201118:	ff460613          	addi	a2,a2,-12 # ffffffffc0202108 <etext+0x288>
ffffffffc020111c:	20100593          	li	a1,513
ffffffffc0201120:	00001517          	auipc	a0,0x1
ffffffffc0201124:	00050513          	mv	a0,a0
ffffffffc0201128:	89aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(buddy_mgr.longest[0] == root_initial_size && "子测试2：清理失败（阻碍块未释放）");
ffffffffc020112c:	00002697          	auipc	a3,0x2
ffffffffc0201130:	cbc68693          	addi	a3,a3,-836 # ffffffffc0202de8 <etext+0xf68>
ffffffffc0201134:	00001617          	auipc	a2,0x1
ffffffffc0201138:	fd460613          	addi	a2,a2,-44 # ffffffffc0202108 <etext+0x288>
ffffffffc020113c:	20700593          	li	a1,519
ffffffffc0201140:	00001517          	auipc	a0,0x1
ffffffffc0201144:	fe050513          	addi	a0,a0,-32 # ffffffffc0202120 <etext+0x2a0>
ffffffffc0201148:	87aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(obstacle && "子测试2：分配阻碍块失败");
ffffffffc020114c:	00002697          	auipc	a3,0x2
ffffffffc0201150:	b0468693          	addi	a3,a3,-1276 # ffffffffc0202c50 <etext+0xdd0>
ffffffffc0201154:	00001617          	auipc	a2,0x1
ffffffffc0201158:	fb460613          	addi	a2,a2,-76 # ffffffffc0202108 <etext+0x288>
ffffffffc020115c:	1f200593          	li	a1,498
ffffffffc0201160:	00001517          	auipc	a0,0x1
ffffffffc0201164:	fc050513          	addi	a0,a0,-64 # ffffffffc0202120 <etext+0x2a0>
ffffffffc0201168:	85aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(buddy_mgr.total_free == initial_free && "子测试1：空闲页数不匹配");
ffffffffc020116c:	00002697          	auipc	a3,0x2
ffffffffc0201170:	a3468693          	addi	a3,a3,-1484 # ffffffffc0202ba0 <etext+0xd20>
ffffffffc0201174:	00001617          	auipc	a2,0x1
ffffffffc0201178:	f9460613          	addi	a2,a2,-108 # ffffffffc0202108 <etext+0x288>
ffffffffc020117c:	1ea00593          	li	a1,490
ffffffffc0201180:	00001517          	auipc	a0,0x1
ffffffffc0201184:	fa050513          	addi	a0,a0,-96 # ffffffffc0202120 <etext+0x2a0>
ffffffffc0201188:	83aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(buddy_mgr.longest[0] == root_initial_size && "子测试1：合并至根节点失败");
ffffffffc020118c:	00002697          	auipc	a3,0x2
ffffffffc0201190:	9bc68693          	addi	a3,a3,-1604 # ffffffffc0202b48 <etext+0xcc8>
ffffffffc0201194:	00001617          	auipc	a2,0x1
ffffffffc0201198:	f7460613          	addi	a2,a2,-140 # ffffffffc0202108 <etext+0x288>
ffffffffc020119c:	1e900593          	li	a1,489
ffffffffc02011a0:	00001517          	auipc	a0,0x1
ffffffffc02011a4:	f8050513          	addi	a0,a0,-128 # ffffffffc0202120 <etext+0x2a0>
ffffffffc02011a8:	81aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(pa_b - pa_a == 2 * PGSIZE && "子测试1：非2页伙伴块");
ffffffffc02011ac:	00002697          	auipc	a3,0x2
ffffffffc02011b0:	95c68693          	addi	a3,a3,-1700 # ffffffffc0202b08 <etext+0xc88>
ffffffffc02011b4:	00001617          	auipc	a2,0x1
ffffffffc02011b8:	f5460613          	addi	a2,a2,-172 # ffffffffc0202108 <etext+0x288>
ffffffffc02011bc:	1e400593          	li	a1,484
ffffffffc02011c0:	00001517          	auipc	a0,0x1
ffffffffc02011c4:	f6050513          	addi	a0,a0,-160 # ffffffffc0202120 <etext+0x2a0>
ffffffffc02011c8:	ffbfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(buddy_alloc_pages(max_pages + 1) == NULL);
ffffffffc02011cc:	00002697          	auipc	a3,0x2
ffffffffc02011d0:	ccc68693          	addi	a3,a3,-820 # ffffffffc0202e98 <etext+0x1018>
ffffffffc02011d4:	00001617          	auipc	a2,0x1
ffffffffc02011d8:	f3460613          	addi	a2,a2,-204 # ffffffffc0202108 <etext+0x288>
ffffffffc02011dc:	21200593          	li	a1,530
ffffffffc02011e0:	00001517          	auipc	a0,0x1
ffffffffc02011e4:	f4050513          	addi	a0,a0,-192 # ffffffffc0202120 <etext+0x2a0>
ffffffffc02011e8:	fdbfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02011ec:	000a3583          	ld	a1,0(s4)
        cprintf("  [错误] 在满内存情况下仍然分配到 1 页：PA=0x%016lx\n", pa_extra);
ffffffffc02011f0:	00001517          	auipc	a0,0x1
ffffffffc02011f4:	71850513          	addi	a0,a0,1816 # ffffffffc0202908 <etext+0xa88>
ffffffffc02011f8:	40bc85b3          	sub	a1,s9,a1
ffffffffc02011fc:	858d                	srai	a1,a1,0x3
ffffffffc02011fe:	033585b3          	mul	a1,a1,s3
ffffffffc0201202:	95d6                	add	a1,a1,s5
ffffffffc0201204:	05b2                	slli	a1,a1,0xc
ffffffffc0201206:	f47fe0ef          	jal	ra,ffffffffc020014c <cprintf>
        buddy_free_pages(p_extra, 1);
ffffffffc020120a:	4585                	li	a1,1
ffffffffc020120c:	8566                	mv	a0,s9
ffffffffc020120e:	bccff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
        assert(0 && "分配器在 total_free==0 时仍能分配出页面，逻辑错误");
ffffffffc0201212:	00001697          	auipc	a3,0x1
ffffffffc0201216:	73e68693          	addi	a3,a3,1854 # ffffffffc0202950 <etext+0xad0>
ffffffffc020121a:	00001617          	auipc	a2,0x1
ffffffffc020121e:	eee60613          	addi	a2,a2,-274 # ffffffffc0202108 <etext+0x288>
ffffffffc0201222:	1cb00593          	li	a1,459
ffffffffc0201226:	00001517          	auipc	a0,0x1
ffffffffc020122a:	efa50513          	addi	a0,a0,-262 # ffffffffc0202120 <etext+0x2a0>
ffffffffc020122e:	f95fe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p_max && "分配最大页数失败（p_max == NULL）");
ffffffffc0201232:	00001697          	auipc	a3,0x1
ffffffffc0201236:	5be68693          	addi	a3,a3,1470 # ffffffffc02027f0 <etext+0x970>
ffffffffc020123a:	00001617          	auipc	a2,0x1
ffffffffc020123e:	ece60613          	addi	a2,a2,-306 # ffffffffc0202108 <etext+0x288>
ffffffffc0201242:	1bc00593          	li	a1,444
ffffffffc0201246:	00001517          	auipc	a0,0x1
ffffffffc020124a:	eda50513          	addi	a0,a0,-294 # ffffffffc0202120 <etext+0x2a0>
ffffffffc020124e:	f75fe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(buddy_mgr.longest[0] == buddy_mgr.size);
ffffffffc0201252:	00001697          	auipc	a3,0x1
ffffffffc0201256:	4f668693          	addi	a3,a3,1270 # ffffffffc0202748 <etext+0x8c8>
ffffffffc020125a:	00001617          	auipc	a2,0x1
ffffffffc020125e:	eae60613          	addi	a2,a2,-338 # ffffffffc0202108 <etext+0x288>
ffffffffc0201262:	1ad00593          	li	a1,429
ffffffffc0201266:	00001517          	auipc	a0,0x1
ffffffffc020126a:	eba50513          	addi	a0,a0,-326 # ffffffffc0202120 <etext+0x2a0>
ffffffffc020126e:	f55fe0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0201272 <alloc_pages>:
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
    return pmm_manager->alloc_pages(n);
ffffffffc0201272:	00026797          	auipc	a5,0x26
ffffffffc0201276:	df67b783          	ld	a5,-522(a5) # ffffffffc0227068 <pmm_manager>
ffffffffc020127a:	6f9c                	ld	a5,24(a5)
ffffffffc020127c:	8782                	jr	a5

ffffffffc020127e <free_pages>:
}

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    pmm_manager->free_pages(base, n);
ffffffffc020127e:	00026797          	auipc	a5,0x26
ffffffffc0201282:	dea7b783          	ld	a5,-534(a5) # ffffffffc0227068 <pmm_manager>
ffffffffc0201286:	739c                	ld	a5,32(a5)
ffffffffc0201288:	8782                	jr	a5

ffffffffc020128a <pmm_init>:
   pmm_manager = &buddy_pmm_manager;
ffffffffc020128a:	00002797          	auipc	a5,0x2
ffffffffc020128e:	d3678793          	addi	a5,a5,-714 # ffffffffc0202fc0 <buddy_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201292:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc0201294:	7179                	addi	sp,sp,-48
ffffffffc0201296:	f022                	sd	s0,32(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201298:	00002517          	auipc	a0,0x2
ffffffffc020129c:	d6050513          	addi	a0,a0,-672 # ffffffffc0202ff8 <buddy_pmm_manager+0x38>
   pmm_manager = &buddy_pmm_manager;
ffffffffc02012a0:	00026417          	auipc	s0,0x26
ffffffffc02012a4:	dc840413          	addi	s0,s0,-568 # ffffffffc0227068 <pmm_manager>
void pmm_init(void) {
ffffffffc02012a8:	f406                	sd	ra,40(sp)
ffffffffc02012aa:	ec26                	sd	s1,24(sp)
ffffffffc02012ac:	e44e                	sd	s3,8(sp)
ffffffffc02012ae:	e84a                	sd	s2,16(sp)
ffffffffc02012b0:	e052                	sd	s4,0(sp)
   pmm_manager = &buddy_pmm_manager;
ffffffffc02012b2:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02012b4:	e99fe0ef          	jal	ra,ffffffffc020014c <cprintf>
    pmm_manager->init();
ffffffffc02012b8:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02012ba:	00026497          	auipc	s1,0x26
ffffffffc02012be:	dc648493          	addi	s1,s1,-570 # ffffffffc0227080 <va_pa_offset>
    pmm_manager->init();
ffffffffc02012c2:	679c                	ld	a5,8(a5)
ffffffffc02012c4:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02012c6:	57f5                	li	a5,-3
ffffffffc02012c8:	07fa                	slli	a5,a5,0x1e
ffffffffc02012ca:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc02012cc:	af0ff0ef          	jal	ra,ffffffffc02005bc <get_memory_base>
ffffffffc02012d0:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc02012d2:	af4ff0ef          	jal	ra,ffffffffc02005c6 <get_memory_size>
    if (mem_size == 0) {
ffffffffc02012d6:	16050163          	beqz	a0,ffffffffc0201438 <pmm_init+0x1ae>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02012da:	892a                	mv	s2,a0
    cprintf("physcial memory map:\n");
ffffffffc02012dc:	00002517          	auipc	a0,0x2
ffffffffc02012e0:	d6450513          	addi	a0,a0,-668 # ffffffffc0203040 <buddy_pmm_manager+0x80>
ffffffffc02012e4:	e69fe0ef          	jal	ra,ffffffffc020014c <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02012e8:	01298a33          	add	s4,s3,s2
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc02012ec:	864e                	mv	a2,s3
ffffffffc02012ee:	fffa0693          	addi	a3,s4,-1
ffffffffc02012f2:	85ca                	mv	a1,s2
ffffffffc02012f4:	00001517          	auipc	a0,0x1
ffffffffc02012f8:	04c50513          	addi	a0,a0,76 # ffffffffc0202340 <etext+0x4c0>
ffffffffc02012fc:	e51fe0ef          	jal	ra,ffffffffc020014c <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0201300:	c80007b7          	lui	a5,0xc8000
ffffffffc0201304:	8652                	mv	a2,s4
ffffffffc0201306:	0d47e863          	bltu	a5,s4,ffffffffc02013d6 <pmm_init+0x14c>
ffffffffc020130a:	00027797          	auipc	a5,0x27
ffffffffc020130e:	d7d78793          	addi	a5,a5,-643 # ffffffffc0228087 <end+0xfff>
ffffffffc0201312:	757d                	lui	a0,0xfffff
ffffffffc0201314:	8d7d                	and	a0,a0,a5
ffffffffc0201316:	8231                	srli	a2,a2,0xc
ffffffffc0201318:	00026797          	auipc	a5,0x26
ffffffffc020131c:	d4c7b023          	sd	a2,-704(a5) # ffffffffc0227058 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201320:	00026797          	auipc	a5,0x26
ffffffffc0201324:	d4a7b023          	sd	a0,-704(a5) # ffffffffc0227060 <pages>
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201328:	000807b7          	lui	a5,0x80
ffffffffc020132c:	002005b7          	lui	a1,0x200
ffffffffc0201330:	02f60563          	beq	a2,a5,ffffffffc020135a <pmm_init+0xd0>
ffffffffc0201334:	00261593          	slli	a1,a2,0x2
ffffffffc0201338:	00c586b3          	add	a3,a1,a2
ffffffffc020133c:	fec007b7          	lui	a5,0xfec00
ffffffffc0201340:	97aa                	add	a5,a5,a0
ffffffffc0201342:	068e                	slli	a3,a3,0x3
ffffffffc0201344:	96be                	add	a3,a3,a5
ffffffffc0201346:	87aa                	mv	a5,a0
        SetPageReserved(pages + i);
ffffffffc0201348:	6798                	ld	a4,8(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020134a:	02878793          	addi	a5,a5,40 # fffffffffec00028 <end+0x3e9d8fa0>
        SetPageReserved(pages + i);
ffffffffc020134e:	00176713          	ori	a4,a4,1
ffffffffc0201352:	fee7b023          	sd	a4,-32(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201356:	fef699e3          	bne	a3,a5,ffffffffc0201348 <pmm_init+0xbe>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020135a:	95b2                	add	a1,a1,a2
ffffffffc020135c:	fec006b7          	lui	a3,0xfec00
ffffffffc0201360:	96aa                	add	a3,a3,a0
ffffffffc0201362:	058e                	slli	a1,a1,0x3
ffffffffc0201364:	96ae                	add	a3,a3,a1
ffffffffc0201366:	c02007b7          	lui	a5,0xc0200
ffffffffc020136a:	0af6eb63          	bltu	a3,a5,ffffffffc0201420 <pmm_init+0x196>
ffffffffc020136e:	6098                	ld	a4,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0201370:	77fd                	lui	a5,0xfffff
ffffffffc0201372:	00fa75b3          	and	a1,s4,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201376:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0201378:	06b6e263          	bltu	a3,a1,ffffffffc02013dc <pmm_init+0x152>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc020137c:	601c                	ld	a5,0(s0)
ffffffffc020137e:	7b9c                	ld	a5,48(a5)
ffffffffc0201380:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0201382:	00002517          	auipc	a0,0x2
ffffffffc0201386:	cfe50513          	addi	a0,a0,-770 # ffffffffc0203080 <buddy_pmm_manager+0xc0>
ffffffffc020138a:	dc3fe0ef          	jal	ra,ffffffffc020014c <cprintf>
    slub_init();
ffffffffc020138e:	23e000ef          	jal	ra,ffffffffc02015cc <slub_init>
    slub_selftest();
ffffffffc0201392:	3d0000ef          	jal	ra,ffffffffc0201762 <slub_selftest>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0201396:	00005597          	auipc	a1,0x5
ffffffffc020139a:	c6a58593          	addi	a1,a1,-918 # ffffffffc0206000 <boot_page_table_sv39>
ffffffffc020139e:	00026797          	auipc	a5,0x26
ffffffffc02013a2:	ccb7bd23          	sd	a1,-806(a5) # ffffffffc0227078 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc02013a6:	c02007b7          	lui	a5,0xc0200
ffffffffc02013aa:	0af5e363          	bltu	a1,a5,ffffffffc0201450 <pmm_init+0x1c6>
ffffffffc02013ae:	6090                	ld	a2,0(s1)
}
ffffffffc02013b0:	7402                	ld	s0,32(sp)
ffffffffc02013b2:	70a2                	ld	ra,40(sp)
ffffffffc02013b4:	64e2                	ld	s1,24(sp)
ffffffffc02013b6:	6942                	ld	s2,16(sp)
ffffffffc02013b8:	69a2                	ld	s3,8(sp)
ffffffffc02013ba:	6a02                	ld	s4,0(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc02013bc:	40c58633          	sub	a2,a1,a2
ffffffffc02013c0:	00026797          	auipc	a5,0x26
ffffffffc02013c4:	cac7b823          	sd	a2,-848(a5) # ffffffffc0227070 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02013c8:	00002517          	auipc	a0,0x2
ffffffffc02013cc:	cd850513          	addi	a0,a0,-808 # ffffffffc02030a0 <buddy_pmm_manager+0xe0>
}
ffffffffc02013d0:	6145                	addi	sp,sp,48
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02013d2:	d7bfe06f          	j	ffffffffc020014c <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc02013d6:	c8000637          	lui	a2,0xc8000
ffffffffc02013da:	bf05                	j	ffffffffc020130a <pmm_init+0x80>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02013dc:	6705                	lui	a4,0x1
ffffffffc02013de:	177d                	addi	a4,a4,-1
ffffffffc02013e0:	96ba                	add	a3,a3,a4
ffffffffc02013e2:	8efd                	and	a3,a3,a5
    if (PPN(pa) >= npage) {
ffffffffc02013e4:	00c6d793          	srli	a5,a3,0xc
ffffffffc02013e8:	02c7f063          	bgeu	a5,a2,ffffffffc0201408 <pmm_init+0x17e>
    pmm_manager->init_memmap(base, n);
ffffffffc02013ec:	6010                	ld	a2,0(s0)
    return &pages[PPN(pa) - nbase];
ffffffffc02013ee:	fff80737          	lui	a4,0xfff80
ffffffffc02013f2:	973e                	add	a4,a4,a5
ffffffffc02013f4:	00271793          	slli	a5,a4,0x2
ffffffffc02013f8:	97ba                	add	a5,a5,a4
ffffffffc02013fa:	6a18                	ld	a4,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02013fc:	8d95                	sub	a1,a1,a3
ffffffffc02013fe:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0201400:	81b1                	srli	a1,a1,0xc
ffffffffc0201402:	953e                	add	a0,a0,a5
ffffffffc0201404:	9702                	jalr	a4
}
ffffffffc0201406:	bf9d                	j	ffffffffc020137c <pmm_init+0xf2>
        panic("pa2page called with invalid pa");
ffffffffc0201408:	00001617          	auipc	a2,0x1
ffffffffc020140c:	f9860613          	addi	a2,a2,-104 # ffffffffc02023a0 <etext+0x520>
ffffffffc0201410:	05800593          	li	a1,88
ffffffffc0201414:	00001517          	auipc	a0,0x1
ffffffffc0201418:	fac50513          	addi	a0,a0,-84 # ffffffffc02023c0 <etext+0x540>
ffffffffc020141c:	da7fe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201420:	00002617          	auipc	a2,0x2
ffffffffc0201424:	c3860613          	addi	a2,a2,-968 # ffffffffc0203058 <buddy_pmm_manager+0x98>
ffffffffc0201428:	06100593          	li	a1,97
ffffffffc020142c:	00002517          	auipc	a0,0x2
ffffffffc0201430:	c0450513          	addi	a0,a0,-1020 # ffffffffc0203030 <buddy_pmm_manager+0x70>
ffffffffc0201434:	d8ffe0ef          	jal	ra,ffffffffc02001c2 <__panic>
        panic("DTB memory info not available");
ffffffffc0201438:	00002617          	auipc	a2,0x2
ffffffffc020143c:	bd860613          	addi	a2,a2,-1064 # ffffffffc0203010 <buddy_pmm_manager+0x50>
ffffffffc0201440:	04900593          	li	a1,73
ffffffffc0201444:	00002517          	auipc	a0,0x2
ffffffffc0201448:	bec50513          	addi	a0,a0,-1044 # ffffffffc0203030 <buddy_pmm_manager+0x70>
ffffffffc020144c:	d77fe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201450:	86ae                	mv	a3,a1
ffffffffc0201452:	00002617          	auipc	a2,0x2
ffffffffc0201456:	c0660613          	addi	a2,a2,-1018 # ffffffffc0203058 <buddy_pmm_manager+0x98>
ffffffffc020145a:	07e00593          	li	a1,126
ffffffffc020145e:	00002517          	auipc	a0,0x2
ffffffffc0201462:	bd250513          	addi	a0,a0,-1070 # ffffffffc0203030 <buddy_pmm_manager+0x70>
ffffffffc0201466:	d5dfe0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc020146a <slab_alloc_from>:
static inline char *slab_objs_base(slab_t *s) {
    return (char *)s + sizeof(slab_t);
}

static inline unsigned char *slab_bitmap(slab_t *s) {
    return (unsigned char *)(slab_objs_base(s) + s->objs * SLUB_OBJ_SIZE);
ffffffffc020146a:	02053883          	ld	a7,32(a0)
    memset(slab_bitmap(s), 0, (s->objs + 7) / 8);
    list_add(&slab_list, &s->link);
    return s;
}

static void *slab_alloc_from(slab_t *s) {
ffffffffc020146e:	882a                	mv	a6,a0
    return (unsigned char *)(slab_objs_base(s) + s->objs * SLUB_OBJ_SIZE);
ffffffffc0201470:	00889513          	slli	a0,a7,0x8
ffffffffc0201474:	03050513          	addi	a0,a0,48
    unsigned char *bm = slab_bitmap(s);
    for (size_t i = 0; i < s->objs; i++) {
ffffffffc0201478:	02088c63          	beqz	a7,ffffffffc02014b0 <slab_alloc_from+0x46>
        size_t byte = i >> 3, bit = (size_t)1 << (i & 7);
        if ((bm[byte] & bit) == 0) {
ffffffffc020147c:	00a807b3          	add	a5,a6,a0
ffffffffc0201480:	0007c603          	lbu	a2,0(a5)
ffffffffc0201484:	00167713          	andi	a4,a2,1
ffffffffc0201488:	c731                	beqz	a4,ffffffffc02014d4 <slab_alloc_from+0x6a>
    for (size_t i = 0; i < s->objs; i++) {
ffffffffc020148a:	4701                	li	a4,0
        size_t byte = i >> 3, bit = (size_t)1 << (i & 7);
ffffffffc020148c:	4305                	li	t1,1
ffffffffc020148e:	a031                	j	ffffffffc020149a <slab_alloc_from+0x30>
        if ((bm[byte] & bit) == 0) {
ffffffffc0201490:	0007c603          	lbu	a2,0(a5)
ffffffffc0201494:	00d675b3          	and	a1,a2,a3
ffffffffc0201498:	cd91                	beqz	a1,ffffffffc02014b4 <slab_alloc_from+0x4a>
    for (size_t i = 0; i < s->objs; i++) {
ffffffffc020149a:	0705                	addi	a4,a4,1
        size_t byte = i >> 3, bit = (size_t)1 << (i & 7);
ffffffffc020149c:	00375793          	srli	a5,a4,0x3
        if ((bm[byte] & bit) == 0) {
ffffffffc02014a0:	97aa                	add	a5,a5,a0
        size_t byte = i >> 3, bit = (size_t)1 << (i & 7);
ffffffffc02014a2:	00777693          	andi	a3,a4,7
        if ((bm[byte] & bit) == 0) {
ffffffffc02014a6:	97c2                	add	a5,a5,a6
        size_t byte = i >> 3, bit = (size_t)1 << (i & 7);
ffffffffc02014a8:	00d316b3          	sll	a3,t1,a3
    for (size_t i = 0; i < s->objs; i++) {
ffffffffc02014ac:	ff1712e3          	bne	a4,a7,ffffffffc0201490 <slab_alloc_from+0x26>
            bm[byte] |= bit;
            s->free_cnt--;
            return slab_objs_base(s) + i * SLUB_OBJ_SIZE;
        }
    }
    return NULL;
ffffffffc02014b0:	4501                	li	a0,0
}
ffffffffc02014b2:	8082                	ret
            return slab_objs_base(s) + i * SLUB_OBJ_SIZE;
ffffffffc02014b4:	0722                	slli	a4,a4,0x8
            bm[byte] |= bit;
ffffffffc02014b6:	0ff6f693          	zext.b	a3,a3
ffffffffc02014ba:	03070713          	addi	a4,a4,48 # fffffffffff80030 <end+0x3fd58fa8>
ffffffffc02014be:	8ed1                	or	a3,a3,a2
ffffffffc02014c0:	00d78023          	sb	a3,0(a5)
            s->free_cnt--;
ffffffffc02014c4:	01883783          	ld	a5,24(a6)
            return slab_objs_base(s) + i * SLUB_OBJ_SIZE;
ffffffffc02014c8:	00e80533          	add	a0,a6,a4
            s->free_cnt--;
ffffffffc02014cc:	17fd                	addi	a5,a5,-1
ffffffffc02014ce:	00f83c23          	sd	a5,24(a6)
            return slab_objs_base(s) + i * SLUB_OBJ_SIZE;
ffffffffc02014d2:	8082                	ret
        if ((bm[byte] & bit) == 0) {
ffffffffc02014d4:	03000713          	li	a4,48
ffffffffc02014d8:	4685                	li	a3,1
ffffffffc02014da:	b7d5                	j	ffffffffc02014be <slab_alloc_from+0x54>

ffffffffc02014dc <kmalloc.part.0>:
void *kmalloc(size_t size) {
ffffffffc02014dc:	1141                	addi	sp,sp,-16
ffffffffc02014de:	e022                	sd	s0,0(sp)
static inline size_t ceil_div(size_t x, size_t y) { return (x + y - 1) / y; }
ffffffffc02014e0:	6405                	lui	s0,0x1
ffffffffc02014e2:	043d                	addi	s0,s0,15
ffffffffc02014e4:	942a                	add	s0,s0,a0
ffffffffc02014e6:	8031                	srli	s0,s0,0xc
    struct Page *pg = alloc_pages(npages);
ffffffffc02014e8:	8522                	mv	a0,s0
void *kmalloc(size_t size) {
ffffffffc02014ea:	e406                	sd	ra,8(sp)
    struct Page *pg = alloc_pages(npages);
ffffffffc02014ec:	d87ff0ef          	jal	ra,ffffffffc0201272 <alloc_pages>
    if (!pg) return NULL;
ffffffffc02014f0:	cd55                	beqz	a0,ffffffffc02015ac <kmalloc.part.0+0xd0>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02014f2:	00026697          	auipc	a3,0x26
ffffffffc02014f6:	b6e6b683          	ld	a3,-1170(a3) # ffffffffc0227060 <pages>
ffffffffc02014fa:	40d506b3          	sub	a3,a0,a3
ffffffffc02014fe:	00002797          	auipc	a5,0x2
ffffffffc0201502:	0027b783          	ld	a5,2(a5) # ffffffffc0203500 <error_string+0x38>
ffffffffc0201506:	868d                	srai	a3,a3,0x3
ffffffffc0201508:	02f686b3          	mul	a3,a3,a5
ffffffffc020150c:	00002797          	auipc	a5,0x2
ffffffffc0201510:	ffc7b783          	ld	a5,-4(a5) # ffffffffc0203508 <nbase>
    void *kva = KADDR(page2pa(pg));
ffffffffc0201514:	00026717          	auipc	a4,0x26
ffffffffc0201518:	b4473703          	ld	a4,-1212(a4) # ffffffffc0227058 <npage>
ffffffffc020151c:	96be                	add	a3,a3,a5
ffffffffc020151e:	00c69793          	slli	a5,a3,0xc
ffffffffc0201522:	83b1                	srli	a5,a5,0xc
    return ((uintptr_t)page2ppn(page)) << PGSHIFT;
ffffffffc0201524:	06b2                	slli	a3,a3,0xc
ffffffffc0201526:	08e7f763          	bgeu	a5,a4,ffffffffc02015b4 <kmalloc.part.0+0xd8>
ffffffffc020152a:	00026797          	auipc	a5,0x26
ffffffffc020152e:	b567b783          	ld	a5,-1194(a5) # ffffffffc0227080 <va_pa_offset>
ffffffffc0201532:	96be                	add	a3,a3,a5
    h->first  = pg;
ffffffffc0201534:	00855313          	srli	t1,a0,0x8
ffffffffc0201538:	01055893          	srli	a7,a0,0x10
ffffffffc020153c:	0185581b          	srliw	a6,a0,0x18
ffffffffc0201540:	02055593          	srli	a1,a0,0x20
ffffffffc0201544:	02855613          	srli	a2,a0,0x28
ffffffffc0201548:	03055713          	srli	a4,a0,0x30
ffffffffc020154c:	03855793          	srli	a5,a0,0x38
ffffffffc0201550:	00a68423          	sb	a0,8(a3)
    h->magic  = BIG_MAGIC;
ffffffffc0201554:	fb500513          	li	a0,-75
ffffffffc0201558:	00a68023          	sb	a0,0(a3)
ffffffffc020155c:	06b00513          	li	a0,107
    h->npages = (uint32_t)npages;
ffffffffc0201560:	00845f1b          	srliw	t5,s0,0x8
ffffffffc0201564:	01045e9b          	srliw	t4,s0,0x10
ffffffffc0201568:	01845e1b          	srliw	t3,s0,0x18
    h->magic  = BIG_MAGIC;
ffffffffc020156c:	00a68123          	sb	a0,2(a3)
ffffffffc0201570:	fb100513          	li	a0,-79
ffffffffc0201574:	00a681a3          	sb	a0,3(a3)
ffffffffc0201578:	000680a3          	sb	zero,1(a3)
    h->npages = (uint32_t)npages;
ffffffffc020157c:	00868223          	sb	s0,4(a3)
ffffffffc0201580:	01e682a3          	sb	t5,5(a3)
ffffffffc0201584:	01d68323          	sb	t4,6(a3)
ffffffffc0201588:	01c683a3          	sb	t3,7(a3)
    h->first  = pg;
ffffffffc020158c:	006684a3          	sb	t1,9(a3)
ffffffffc0201590:	01168523          	sb	a7,10(a3)
ffffffffc0201594:	010685a3          	sb	a6,11(a3)
ffffffffc0201598:	00b68623          	sb	a1,12(a3)
ffffffffc020159c:	00c686a3          	sb	a2,13(a3)
ffffffffc02015a0:	00e68723          	sb	a4,14(a3)
ffffffffc02015a4:	00f687a3          	sb	a5,15(a3)
    return (void *)(h + 1);        // 用户区从头部后面开始
ffffffffc02015a8:	01068513          	addi	a0,a3,16
}
ffffffffc02015ac:	60a2                	ld	ra,8(sp)
ffffffffc02015ae:	6402                	ld	s0,0(sp)
ffffffffc02015b0:	0141                	addi	sp,sp,16
ffffffffc02015b2:	8082                	ret
    void *kva = KADDR(page2pa(pg));
ffffffffc02015b4:	00002617          	auipc	a2,0x2
ffffffffc02015b8:	b2c60613          	addi	a2,a2,-1236 # ffffffffc02030e0 <buddy_pmm_manager+0x120>
ffffffffc02015bc:	08d00593          	li	a1,141
ffffffffc02015c0:	00002517          	auipc	a0,0x2
ffffffffc02015c4:	b4850513          	addi	a0,a0,-1208 # ffffffffc0203108 <buddy_pmm_manager+0x148>
ffffffffc02015c8:	bfbfe0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc02015cc <slub_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc02015cc:	00026797          	auipc	a5,0x26
ffffffffc02015d0:	a6478793          	addi	a5,a5,-1436 # ffffffffc0227030 <slab_list>
    s->free_cnt++;
}

void slub_init(void) {
    list_init(&slab_list);
    cprintf("SLUB(mini): obj=%uB, align=%uB\n", SLUB_OBJ_SIZE, SLUB_ALIGN);
ffffffffc02015d4:	4641                	li	a2,16
ffffffffc02015d6:	10000593          	li	a1,256
ffffffffc02015da:	00002517          	auipc	a0,0x2
ffffffffc02015de:	b3e50513          	addi	a0,a0,-1218 # ffffffffc0203118 <buddy_pmm_manager+0x158>
ffffffffc02015e2:	e79c                	sd	a5,8(a5)
ffffffffc02015e4:	e39c                	sd	a5,0(a5)
ffffffffc02015e6:	b67fe06f          	j	ffffffffc020014c <cprintf>

ffffffffc02015ea <slub_alloc>:
}

void *slub_alloc(size_t size) {
    if (size == 0 || size > SLUB_OBJ_SIZE) return NULL;
ffffffffc02015ea:	157d                	addi	a0,a0,-1
ffffffffc02015ec:	0ff00793          	li	a5,255
ffffffffc02015f0:	0ca7e963          	bltu	a5,a0,ffffffffc02016c2 <slub_alloc+0xd8>
void *slub_alloc(size_t size) {
ffffffffc02015f4:	1101                	addi	sp,sp,-32
ffffffffc02015f6:	e426                	sd	s1,8(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc02015f8:	00026497          	auipc	s1,0x26
ffffffffc02015fc:	a3848493          	addi	s1,s1,-1480 # ffffffffc0227030 <slab_list>
ffffffffc0201600:	e822                	sd	s0,16(sp)
ffffffffc0201602:	6480                	ld	s0,8(s1)
ffffffffc0201604:	ec06                	sd	ra,24(sp)
ffffffffc0201606:	e04a                	sd	s2,0(sp)
    (void)align_up(size, SLUB_ALIGN);          // 目前只有 64B 类，按 16B 对齐检查即可

    // 1) 在现有 slab 中找空闲
    list_entry_t *le = &slab_list;
    while ((le = list_next(le)) != &slab_list) {
ffffffffc0201608:	00940b63          	beq	s0,s1,ffffffffc020161e <slub_alloc+0x34>
        slab_t *s = le2slab(le);
        if (s->free_cnt == 0) continue;
ffffffffc020160c:	6c1c                	ld	a5,24(s0)
ffffffffc020160e:	c789                	beqz	a5,ffffffffc0201618 <slub_alloc+0x2e>
        void *p = slab_alloc_from(s);
ffffffffc0201610:	8522                	mv	a0,s0
ffffffffc0201612:	e59ff0ef          	jal	ra,ffffffffc020146a <slab_alloc_from>
        if (p != NULL) return p;
ffffffffc0201616:	e145                	bnez	a0,ffffffffc02016b6 <slub_alloc+0xcc>
ffffffffc0201618:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != &slab_list) {
ffffffffc020161a:	fe9419e3          	bne	s0,s1,ffffffffc020160c <slub_alloc+0x22>
    struct Page *pg = alloc_pages(1);          // 用 buddy 分一页
ffffffffc020161e:	4505                	li	a0,1
ffffffffc0201620:	c53ff0ef          	jal	ra,ffffffffc0201272 <alloc_pages>
ffffffffc0201624:	892a                	mv	s2,a0
    if (!pg) return NULL;
ffffffffc0201626:	c559                	beqz	a0,ffffffffc02016b4 <slub_alloc+0xca>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201628:	00026697          	auipc	a3,0x26
ffffffffc020162c:	a386b683          	ld	a3,-1480(a3) # ffffffffc0227060 <pages>
ffffffffc0201630:	40d506b3          	sub	a3,a0,a3
ffffffffc0201634:	00002797          	auipc	a5,0x2
ffffffffc0201638:	ecc7b783          	ld	a5,-308(a5) # ffffffffc0203500 <error_string+0x38>
ffffffffc020163c:	868d                	srai	a3,a3,0x3
ffffffffc020163e:	02f686b3          	mul	a3,a3,a5
ffffffffc0201642:	00002417          	auipc	s0,0x2
ffffffffc0201646:	ec643403          	ld	s0,-314(s0) # ffffffffc0203508 <nbase>
static inline void *page_kva(struct Page *p) { return KADDR(page2pa(p)); }
ffffffffc020164a:	00026717          	auipc	a4,0x26
ffffffffc020164e:	a0e73703          	ld	a4,-1522(a4) # ffffffffc0227058 <npage>
ffffffffc0201652:	96a2                	add	a3,a3,s0
ffffffffc0201654:	00c69793          	slli	a5,a3,0xc
ffffffffc0201658:	83b1                	srli	a5,a5,0xc
    return ((uintptr_t)page2ppn(page)) << PGSHIFT;
ffffffffc020165a:	06b2                	slli	a3,a3,0xc
ffffffffc020165c:	06e7f563          	bgeu	a5,a4,ffffffffc02016c6 <slub_alloc+0xdc>
ffffffffc0201660:	00026417          	auipc	s0,0x26
ffffffffc0201664:	a2043403          	ld	s0,-1504(s0) # ffffffffc0227080 <va_pa_offset>
ffffffffc0201668:	9436                	add	s0,s0,a3
    memset(kva, 0, PGSIZE);
ffffffffc020166a:	6605                	lui	a2,0x1
ffffffffc020166c:	4581                	li	a1,0
ffffffffc020166e:	8522                	mv	a0,s0
ffffffffc0201670:	7fe000ef          	jal	ra,ffffffffc0201e6e <memset>
    s->objs     = compute_objs_per_slab();
ffffffffc0201674:	47bd                	li	a5,15
ffffffffc0201676:	f01c                	sd	a5,32(s0)
    s->free_cnt = s->objs;
ffffffffc0201678:	ec1c                	sd	a5,24(s0)
    memset(slab_bitmap(s), 0, (s->objs + 7) / 8);
ffffffffc020167a:	6505                	lui	a0,0x1
    s->magic    = SLUB_MAGIC;
ffffffffc020167c:	51ab57b7          	lui	a5,0x51ab5
ffffffffc0201680:	1ab78793          	addi	a5,a5,427 # 51ab51ab <kern_entry-0xffffffff6e74ae55>
    memset(slab_bitmap(s), 0, (s->objs + 7) / 8);
ffffffffc0201684:	f3050513          	addi	a0,a0,-208 # f30 <kern_entry-0xffffffffc01ff0d0>
    s->page     = pg;
ffffffffc0201688:	01243823          	sd	s2,16(s0)
    s->magic    = SLUB_MAGIC;
ffffffffc020168c:	d41c                	sw	a5,40(s0)
    elm->prev = elm->next = elm;
ffffffffc020168e:	e400                	sd	s0,8(s0)
ffffffffc0201690:	e000                	sd	s0,0(s0)
    memset(slab_bitmap(s), 0, (s->objs + 7) / 8);
ffffffffc0201692:	9522                	add	a0,a0,s0
ffffffffc0201694:	4609                	li	a2,2
ffffffffc0201696:	4581                	li	a1,0
ffffffffc0201698:	7d6000ef          	jal	ra,ffffffffc0201e6e <memset>
    __list_add(elm, listelm, listelm->next);
ffffffffc020169c:	649c                	ld	a5,8(s1)
    }
    // 2) 新建 slab
    slab_t *s = new_slab();
    if (!s) return NULL;
    return slab_alloc_from(s);                  // 新 slab 第一次分配一定成功
ffffffffc020169e:	8522                	mv	a0,s0
}
ffffffffc02016a0:	60e2                	ld	ra,24(sp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02016a2:	e380                	sd	s0,0(a5)
ffffffffc02016a4:	e480                	sd	s0,8(s1)
    elm->next = next;
    elm->prev = prev;
ffffffffc02016a6:	e004                	sd	s1,0(s0)
    elm->next = next;
ffffffffc02016a8:	e41c                	sd	a5,8(s0)
ffffffffc02016aa:	6442                	ld	s0,16(sp)
ffffffffc02016ac:	64a2                	ld	s1,8(sp)
ffffffffc02016ae:	6902                	ld	s2,0(sp)
ffffffffc02016b0:	6105                	addi	sp,sp,32
    return slab_alloc_from(s);                  // 新 slab 第一次分配一定成功
ffffffffc02016b2:	bb65                	j	ffffffffc020146a <slab_alloc_from>
    if (size == 0 || size > SLUB_OBJ_SIZE) return NULL;
ffffffffc02016b4:	4501                	li	a0,0
}
ffffffffc02016b6:	60e2                	ld	ra,24(sp)
ffffffffc02016b8:	6442                	ld	s0,16(sp)
ffffffffc02016ba:	64a2                	ld	s1,8(sp)
ffffffffc02016bc:	6902                	ld	s2,0(sp)
ffffffffc02016be:	6105                	addi	sp,sp,32
ffffffffc02016c0:	8082                	ret
    if (size == 0 || size > SLUB_OBJ_SIZE) return NULL;
ffffffffc02016c2:	4501                	li	a0,0
}
ffffffffc02016c4:	8082                	ret
static inline void *page_kva(struct Page *p) { return KADDR(page2pa(p)); }
ffffffffc02016c6:	00002617          	auipc	a2,0x2
ffffffffc02016ca:	a1a60613          	addi	a2,a2,-1510 # ffffffffc02030e0 <buddy_pmm_manager+0x120>
ffffffffc02016ce:	07900593          	li	a1,121
ffffffffc02016d2:	00002517          	auipc	a0,0x2
ffffffffc02016d6:	a3650513          	addi	a0,a0,-1482 # ffffffffc0203108 <buddy_pmm_manager+0x148>
ffffffffc02016da:	ae9fe0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc02016de <slub_free>:

void slub_free(void *obj) {
ffffffffc02016de:	85aa                	mv	a1,a0
    if (!obj) return;
ffffffffc02016e0:	cd29                	beqz	a0,ffffffffc020173a <slub_free+0x5c>
    // 通过“页对齐”直接定位 slab 头，避免全表扫描
    void *kva_base = (void *)((uintptr_t)obj & ~(PGSIZE - 1));
ffffffffc02016e2:	77fd                	lui	a5,0xfffff
ffffffffc02016e4:	8fe9                	and	a5,a5,a0
    slab_t *s = (slab_t *)kva_base;

    // 简单健壮性检查
    if (s->magic != SLUB_MAGIC) {
ffffffffc02016e6:	5794                	lw	a3,40(a5)
ffffffffc02016e8:	51ab5737          	lui	a4,0x51ab5
ffffffffc02016ec:	1ab70713          	addi	a4,a4,427 # 51ab51ab <kern_entry-0xffffffff6e74ae55>
ffffffffc02016f0:	04e69c63          	bne	a3,a4,ffffffffc0201748 <slub_free+0x6a>
        return;
    }
    // 边界检查（保证 obj 落在对象区内、且是 64B 对齐）
    char *base = slab_objs_base(s);
    size_t off = (size_t)((char *)obj - base);
    if (off >= s->objs * SLUB_OBJ_SIZE || (off % SLUB_OBJ_SIZE) != 0) {
ffffffffc02016f4:	7394                	ld	a3,32(a5)
    return (char *)s + sizeof(slab_t);
ffffffffc02016f6:	03078713          	addi	a4,a5,48 # fffffffffffff030 <end+0x3fdd7fa8>
    size_t off = (size_t)((char *)obj - base);
ffffffffc02016fa:	40e50733          	sub	a4,a0,a4
    if (off >= s->objs * SLUB_OBJ_SIZE || (off % SLUB_OBJ_SIZE) != 0) {
ffffffffc02016fe:	06a2                	slli	a3,a3,0x8
ffffffffc0201700:	02d77e63          	bgeu	a4,a3,ffffffffc020173c <slub_free+0x5e>
ffffffffc0201704:	0ff77613          	zext.b	a2,a4
ffffffffc0201708:	ea15                	bnez	a2,ffffffffc020173c <slub_free+0x5e>
    size_t byte = idx >> 3, bit = (size_t)1 << (idx & 7);
ffffffffc020170a:	00b75613          	srli	a2,a4,0xb
    bm[byte] &= (unsigned char)~bit;
ffffffffc020170e:	03068693          	addi	a3,a3,48
ffffffffc0201712:	96b2                	add	a3,a3,a2
ffffffffc0201714:	96be                	add	a3,a3,a5
    size_t idx = off / SLUB_OBJ_SIZE;
ffffffffc0201716:	8321                	srli	a4,a4,0x8
    bm[byte] &= (unsigned char)~bit;
ffffffffc0201718:	0006c583          	lbu	a1,0(a3)
    size_t byte = idx >> 3, bit = (size_t)1 << (idx & 7);
ffffffffc020171c:	8b1d                	andi	a4,a4,7
ffffffffc020171e:	4605                	li	a2,1
ffffffffc0201720:	00e61733          	sll	a4,a2,a4
    bm[byte] &= (unsigned char)~bit;
ffffffffc0201724:	fff74713          	not	a4,a4
ffffffffc0201728:	8f6d                	and	a4,a4,a1
ffffffffc020172a:	00e68023          	sb	a4,0(a3)
    s->free_cnt++;
ffffffffc020172e:	6f98                	ld	a4,24(a5)
    }

    slab_free_to(s, obj);

    // slab 全空时直接归还整页
    if (s->free_cnt == s->objs) {
ffffffffc0201730:	7394                	ld	a3,32(a5)
    s->free_cnt++;
ffffffffc0201732:	0705                	addi	a4,a4,1
ffffffffc0201734:	ef98                	sd	a4,24(a5)
    if (s->free_cnt == s->objs) {
ffffffffc0201736:	00e68f63          	beq	a3,a4,ffffffffc0201754 <slub_free+0x76>
        list_del(&s->link);
        free_pages(s->page, 1);                // 归还给 buddy
    }
}
ffffffffc020173a:	8082                	ret
        cprintf("slub_free: bad obj %p (range/alignment)\n", obj);
ffffffffc020173c:	00002517          	auipc	a0,0x2
ffffffffc0201740:	a1c50513          	addi	a0,a0,-1508 # ffffffffc0203158 <buddy_pmm_manager+0x198>
ffffffffc0201744:	a09fe06f          	j	ffffffffc020014c <cprintf>
        cprintf("slub_free: bad obj %p (magic)\n", obj);
ffffffffc0201748:	00002517          	auipc	a0,0x2
ffffffffc020174c:	9f050513          	addi	a0,a0,-1552 # ffffffffc0203138 <buddy_pmm_manager+0x178>
ffffffffc0201750:	9fdfe06f          	j	ffffffffc020014c <cprintf>
    __list_del(listelm->prev, listelm->next);
ffffffffc0201754:	6394                	ld	a3,0(a5)
ffffffffc0201756:	6798                	ld	a4,8(a5)
        free_pages(s->page, 1);                // 归还给 buddy
ffffffffc0201758:	6b88                	ld	a0,16(a5)
ffffffffc020175a:	4585                	li	a1,1
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc020175c:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc020175e:	e314                	sd	a3,0(a4)
ffffffffc0201760:	be39                	j	ffffffffc020127e <free_pages>

ffffffffc0201762 <slub_selftest>:

// 极简自检（只做非常小的申请）
void slub_selftest(void) {
ffffffffc0201762:	7179                	addi	sp,sp,-48
    cprintf("\n[slub_selftest] begin\n");
ffffffffc0201764:	00002517          	auipc	a0,0x2
ffffffffc0201768:	a2450513          	addi	a0,a0,-1500 # ffffffffc0203188 <buddy_pmm_manager+0x1c8>
void slub_selftest(void) {
ffffffffc020176c:	f406                	sd	ra,40(sp)
ffffffffc020176e:	f022                	sd	s0,32(sp)
ffffffffc0201770:	ec26                	sd	s1,24(sp)
ffffffffc0201772:	e84a                	sd	s2,16(sp)
ffffffffc0201774:	e44e                	sd	s3,8(sp)
    cprintf("\n[slub_selftest] begin\n");
ffffffffc0201776:	9d7fe0ef          	jal	ra,ffffffffc020014c <cprintf>

    // A. ≤ SLUB 阈值：应走 SLUB，一个页内对象 1 个槽位
    void *a = slub_alloc(8);
ffffffffc020177a:	4521                	li	a0,8
ffffffffc020177c:	e6fff0ef          	jal	ra,ffffffffc02015ea <slub_alloc>
ffffffffc0201780:	84aa                	mv	s1,a0
    void *b = slub_alloc(SLUB_OBJ_SIZE / 4);
ffffffffc0201782:	04000513          	li	a0,64
ffffffffc0201786:	e65ff0ef          	jal	ra,ffffffffc02015ea <slub_alloc>
ffffffffc020178a:	842a                	mv	s0,a0
    void *c = slub_alloc(SLUB_OBJ_SIZE / 2);
ffffffffc020178c:	08000513          	li	a0,128
ffffffffc0201790:	e5bff0ef          	jal	ra,ffffffffc02015ea <slub_alloc>
ffffffffc0201794:	892a                	mv	s2,a0

    
    void *d = slub_alloc(SLUB_OBJ_SIZE);
ffffffffc0201796:	10000513          	li	a0,256
ffffffffc020179a:	e51ff0ef          	jal	ra,ffffffffc02015ea <slub_alloc>
    assert(a && b && c && d);
ffffffffc020179e:	1a048763          	beqz	s1,ffffffffc020194c <slub_selftest+0x1ea>
ffffffffc02017a2:	1a040563          	beqz	s0,ffffffffc020194c <slub_selftest+0x1ea>
ffffffffc02017a6:	1a090363          	beqz	s2,ffffffffc020194c <slub_selftest+0x1ea>
ffffffffc02017aa:	89aa                	mv	s3,a0
ffffffffc02017ac:	1a050063          	beqz	a0,ffffffffc020194c <slub_selftest+0x1ea>
    cprintf("SLUB: a=%p b=%p c=%p d=%p\n", a,b,c,d);
ffffffffc02017b0:	872a                	mv	a4,a0
ffffffffc02017b2:	8622                	mv	a2,s0
ffffffffc02017b4:	86ca                	mv	a3,s2
ffffffffc02017b6:	85a6                	mv	a1,s1
ffffffffc02017b8:	00002517          	auipc	a0,0x2
ffffffffc02017bc:	a0050513          	addi	a0,a0,-1536 # ffffffffc02031b8 <buddy_pmm_manager+0x1f8>
ffffffffc02017c0:	98dfe0ef          	jal	ra,ffffffffc020014c <cprintf>
    if (size <= SLUB_OBJ_SIZE) {
ffffffffc02017c4:	10100513          	li	a0,257
ffffffffc02017c8:	d15ff0ef          	jal	ra,ffffffffc02014dc <kmalloc.part.0>
ffffffffc02017cc:	842a                	mv	s0,a0

   size_t over = SLUB_OBJ_SIZE + 1;
void *x = kmalloc(over);
assert(x != NULL);
ffffffffc02017ce:	1c050f63          	beqz	a0,ffffffffc02019ac <slub_selftest+0x24a>

// 2) 还原页起始（KVA）并做“页对齐”断言
uintptr_t page_kva = (uintptr_t)x - sizeof(struct BigAllocHeader);
ffffffffc02017d2:	ff050613          	addi	a2,a0,-16
assert((page_kva & (PGSIZE - 1)) == 0);
ffffffffc02017d6:	03461793          	slli	a5,a2,0x34
ffffffffc02017da:	1a079963          	bnez	a5,ffffffffc020198c <slub_selftest+0x22a>

// 3) 明确它不是 SLUB 的那一页（比较页号）
uintptr_t slab_page = (uintptr_t)a & ~(PGSIZE - 1);   // a 来自 SLUB 的 slab
ffffffffc02017de:	777d                	lui	a4,0xfffff
ffffffffc02017e0:	8f65                	and	a4,a4,s1
assert(page_kva != slab_page);
ffffffffc02017e2:	1ee60563          	beq	a2,a4,ffffffffc02019cc <slub_selftest+0x26a>

// 4) 读取头部，验证“确实是页路径”以及“页数>=1”
struct BigAllocHeader *h = (struct BigAllocHeader *)page_kva;
assert(h->magic == 0xB16B00B5u && h->first && h->npages >= 1);
ffffffffc02017e6:	00164583          	lbu	a1,1(a2)
ffffffffc02017ea:	ff054503          	lbu	a0,-16(a0)
ffffffffc02017ee:	00264683          	lbu	a3,2(a2)
ffffffffc02017f2:	00364783          	lbu	a5,3(a2)
ffffffffc02017f6:	05a2                	slli	a1,a1,0x8
ffffffffc02017f8:	8dc9                	or	a1,a1,a0
ffffffffc02017fa:	06c2                	slli	a3,a3,0x10
ffffffffc02017fc:	8ecd                	or	a3,a3,a1
ffffffffc02017fe:	07e2                	slli	a5,a5,0x18
ffffffffc0201800:	8fd5                	or	a5,a5,a3
ffffffffc0201802:	b16b06b7          	lui	a3,0xb16b0
ffffffffc0201806:	2781                	sext.w	a5,a5
ffffffffc0201808:	0b568693          	addi	a3,a3,181 # ffffffffb16b00b5 <kern_entry-0xeb4ff4b>
ffffffffc020180c:	16d79063          	bne	a5,a3,ffffffffc020196c <slub_selftest+0x20a>
ffffffffc0201810:	00964783          	lbu	a5,9(a2)
ffffffffc0201814:	00864683          	lbu	a3,8(a2)
ffffffffc0201818:	00a64883          	lbu	a7,10(a2)
ffffffffc020181c:	00b64803          	lbu	a6,11(a2)
ffffffffc0201820:	00c64503          	lbu	a0,12(a2)
ffffffffc0201824:	07a2                	slli	a5,a5,0x8
ffffffffc0201826:	8fd5                	or	a5,a5,a3
ffffffffc0201828:	00d64583          	lbu	a1,13(a2)
ffffffffc020182c:	08c2                	slli	a7,a7,0x10
ffffffffc020182e:	00f8e8b3          	or	a7,a7,a5
ffffffffc0201832:	00e64683          	lbu	a3,14(a2)
ffffffffc0201836:	0862                	slli	a6,a6,0x18
ffffffffc0201838:	00f64783          	lbu	a5,15(a2)
ffffffffc020183c:	01186833          	or	a6,a6,a7
ffffffffc0201840:	1502                	slli	a0,a0,0x20
ffffffffc0201842:	01056533          	or	a0,a0,a6
ffffffffc0201846:	15a2                	slli	a1,a1,0x28
ffffffffc0201848:	8dc9                	or	a1,a1,a0
ffffffffc020184a:	16c2                	slli	a3,a3,0x30
ffffffffc020184c:	8ecd                	or	a3,a3,a1
ffffffffc020184e:	17e2                	slli	a5,a5,0x38
ffffffffc0201850:	8fd5                	or	a5,a5,a3
ffffffffc0201852:	10078d63          	beqz	a5,ffffffffc020196c <slub_selftest+0x20a>
ffffffffc0201856:	00564583          	lbu	a1,5(a2)
ffffffffc020185a:	00464503          	lbu	a0,4(a2)
ffffffffc020185e:	00664683          	lbu	a3,6(a2)
ffffffffc0201862:	00764783          	lbu	a5,7(a2)
ffffffffc0201866:	05a2                	slli	a1,a1,0x8
ffffffffc0201868:	8dc9                	or	a1,a1,a0
ffffffffc020186a:	06c2                	slli	a3,a3,0x10
ffffffffc020186c:	8ecd                	or	a3,a3,a1
ffffffffc020186e:	07e2                	slli	a5,a5,0x18
ffffffffc0201870:	8fd5                	or	a5,a5,a3
ffffffffc0201872:	0007869b          	sext.w	a3,a5
ffffffffc0201876:	0e078b63          	beqz	a5,ffffffffc020196c <slub_selftest+0x20a>

// 可选：打印确认
cprintf("[proof] kmalloc>SLUB: user=%p page_kva=%p npages=%u (slab_page=%p)\n",
ffffffffc020187a:	85a2                	mv	a1,s0
ffffffffc020187c:	00002517          	auipc	a0,0x2
ffffffffc0201880:	9dc50513          	addi	a0,a0,-1572 # ffffffffc0203258 <buddy_pmm_manager+0x298>
ffffffffc0201884:	8c9fe0ef          	jal	ra,ffffffffc020014c <cprintf>
    if (h->magic == BIG_MAGIC && h->first && h->npages > 0) {
ffffffffc0201888:	ff144683          	lbu	a3,-15(s0)
ffffffffc020188c:	ff044603          	lbu	a2,-16(s0)
ffffffffc0201890:	ff244703          	lbu	a4,-14(s0)
ffffffffc0201894:	ff344783          	lbu	a5,-13(s0)
ffffffffc0201898:	06a2                	slli	a3,a3,0x8
ffffffffc020189a:	8ed1                	or	a3,a3,a2
ffffffffc020189c:	0742                	slli	a4,a4,0x10
ffffffffc020189e:	8f55                	or	a4,a4,a3
ffffffffc02018a0:	07e2                	slli	a5,a5,0x18
ffffffffc02018a2:	8fd9                	or	a5,a5,a4
ffffffffc02018a4:	b16b0737          	lui	a4,0xb16b0
ffffffffc02018a8:	2781                	sext.w	a5,a5
ffffffffc02018aa:	0b570713          	addi	a4,a4,181 # ffffffffb16b00b5 <kern_entry-0xeb4ff4b>
ffffffffc02018ae:	06e79263          	bne	a5,a4,ffffffffc0201912 <slub_selftest+0x1b0>
ffffffffc02018b2:	ff944503          	lbu	a0,-7(s0)
ffffffffc02018b6:	ff844783          	lbu	a5,-8(s0)
ffffffffc02018ba:	ffa44583          	lbu	a1,-6(s0)
ffffffffc02018be:	ffb44603          	lbu	a2,-5(s0)
ffffffffc02018c2:	ffc44683          	lbu	a3,-4(s0)
ffffffffc02018c6:	0522                	slli	a0,a0,0x8
ffffffffc02018c8:	8d5d                	or	a0,a0,a5
ffffffffc02018ca:	ffd44703          	lbu	a4,-3(s0)
ffffffffc02018ce:	05c2                	slli	a1,a1,0x10
ffffffffc02018d0:	8dc9                	or	a1,a1,a0
ffffffffc02018d2:	ffe44783          	lbu	a5,-2(s0)
ffffffffc02018d6:	0662                	slli	a2,a2,0x18
ffffffffc02018d8:	fff44503          	lbu	a0,-1(s0)
ffffffffc02018dc:	8e4d                	or	a2,a2,a1
ffffffffc02018de:	1682                	slli	a3,a3,0x20
ffffffffc02018e0:	8ed1                	or	a3,a3,a2
ffffffffc02018e2:	1722                	slli	a4,a4,0x28
ffffffffc02018e4:	8f55                	or	a4,a4,a3
ffffffffc02018e6:	17c2                	slli	a5,a5,0x30
ffffffffc02018e8:	8fd9                	or	a5,a5,a4
ffffffffc02018ea:	1562                	slli	a0,a0,0x38
ffffffffc02018ec:	8d5d                	or	a0,a0,a5
ffffffffc02018ee:	c115                	beqz	a0,ffffffffc0201912 <slub_selftest+0x1b0>
ffffffffc02018f0:	ff544683          	lbu	a3,-11(s0)
ffffffffc02018f4:	ff444603          	lbu	a2,-12(s0)
ffffffffc02018f8:	ff644703          	lbu	a4,-10(s0)
ffffffffc02018fc:	ff744783          	lbu	a5,-9(s0)
ffffffffc0201900:	06a2                	slli	a3,a3,0x8
ffffffffc0201902:	8ed1                	or	a3,a3,a2
ffffffffc0201904:	0742                	slli	a4,a4,0x10
ffffffffc0201906:	8f55                	or	a4,a4,a3
ffffffffc0201908:	07e2                	slli	a5,a5,0x18
ffffffffc020190a:	8fd9                	or	a5,a5,a4
ffffffffc020190c:	0007859b          	sext.w	a1,a5
ffffffffc0201910:	eb8d                	bnez	a5,ffffffffc0201942 <slub_selftest+0x1e0>
    slub_free(ptr);
ffffffffc0201912:	8522                	mv	a0,s0
ffffffffc0201914:	dcbff0ef          	jal	ra,ffffffffc02016de <slub_free>
        x, (void*)page_kva, h->npages, (void*)slab_page);

kfree(x);
    // 收尾
    slub_free(a); slub_free(c); slub_free(d);
ffffffffc0201918:	8526                	mv	a0,s1
ffffffffc020191a:	dc5ff0ef          	jal	ra,ffffffffc02016de <slub_free>
ffffffffc020191e:	854a                	mv	a0,s2
ffffffffc0201920:	dbfff0ef          	jal	ra,ffffffffc02016de <slub_free>
ffffffffc0201924:	854e                	mv	a0,s3
ffffffffc0201926:	db9ff0ef          	jal	ra,ffffffffc02016de <slub_free>

    cprintf("[slub_selftest] ok\n\n");
}
ffffffffc020192a:	7402                	ld	s0,32(sp)
ffffffffc020192c:	70a2                	ld	ra,40(sp)
ffffffffc020192e:	64e2                	ld	s1,24(sp)
ffffffffc0201930:	6942                	ld	s2,16(sp)
ffffffffc0201932:	69a2                	ld	s3,8(sp)
    cprintf("[slub_selftest] ok\n\n");
ffffffffc0201934:	00002517          	auipc	a0,0x2
ffffffffc0201938:	96c50513          	addi	a0,a0,-1684 # ffffffffc02032a0 <buddy_pmm_manager+0x2e0>
}
ffffffffc020193c:	6145                	addi	sp,sp,48
    cprintf("[slub_selftest] ok\n\n");
ffffffffc020193e:	80ffe06f          	j	ffffffffc020014c <cprintf>
        free_pages(h->first, h->npages);
ffffffffc0201942:	1582                	slli	a1,a1,0x20
ffffffffc0201944:	9181                	srli	a1,a1,0x20
ffffffffc0201946:	939ff0ef          	jal	ra,ffffffffc020127e <free_pages>
        return;
ffffffffc020194a:	b7f9                	j	ffffffffc0201918 <slub_selftest+0x1b6>
    assert(a && b && c && d);
ffffffffc020194c:	00002697          	auipc	a3,0x2
ffffffffc0201950:	85468693          	addi	a3,a3,-1964 # ffffffffc02031a0 <buddy_pmm_manager+0x1e0>
ffffffffc0201954:	00000617          	auipc	a2,0x0
ffffffffc0201958:	7b460613          	addi	a2,a2,1972 # ffffffffc0202108 <etext+0x288>
ffffffffc020195c:	12200593          	li	a1,290
ffffffffc0201960:	00001517          	auipc	a0,0x1
ffffffffc0201964:	7a850513          	addi	a0,a0,1960 # ffffffffc0203108 <buddy_pmm_manager+0x148>
ffffffffc0201968:	85bfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
assert(h->magic == 0xB16B00B5u && h->first && h->npages >= 1);
ffffffffc020196c:	00002697          	auipc	a3,0x2
ffffffffc0201970:	8b468693          	addi	a3,a3,-1868 # ffffffffc0203220 <buddy_pmm_manager+0x260>
ffffffffc0201974:	00000617          	auipc	a2,0x0
ffffffffc0201978:	79460613          	addi	a2,a2,1940 # ffffffffc0202108 <etext+0x288>
ffffffffc020197c:	13300593          	li	a1,307
ffffffffc0201980:	00001517          	auipc	a0,0x1
ffffffffc0201984:	78850513          	addi	a0,a0,1928 # ffffffffc0203108 <buddy_pmm_manager+0x148>
ffffffffc0201988:	83bfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
assert((page_kva & (PGSIZE - 1)) == 0);
ffffffffc020198c:	00002697          	auipc	a3,0x2
ffffffffc0201990:	85c68693          	addi	a3,a3,-1956 # ffffffffc02031e8 <buddy_pmm_manager+0x228>
ffffffffc0201994:	00000617          	auipc	a2,0x0
ffffffffc0201998:	77460613          	addi	a2,a2,1908 # ffffffffc0202108 <etext+0x288>
ffffffffc020199c:	12b00593          	li	a1,299
ffffffffc02019a0:	00001517          	auipc	a0,0x1
ffffffffc02019a4:	76850513          	addi	a0,a0,1896 # ffffffffc0203108 <buddy_pmm_manager+0x148>
ffffffffc02019a8:	81bfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
assert(x != NULL);
ffffffffc02019ac:	00002697          	auipc	a3,0x2
ffffffffc02019b0:	82c68693          	addi	a3,a3,-2004 # ffffffffc02031d8 <buddy_pmm_manager+0x218>
ffffffffc02019b4:	00000617          	auipc	a2,0x0
ffffffffc02019b8:	75460613          	addi	a2,a2,1876 # ffffffffc0202108 <etext+0x288>
ffffffffc02019bc:	12700593          	li	a1,295
ffffffffc02019c0:	00001517          	auipc	a0,0x1
ffffffffc02019c4:	74850513          	addi	a0,a0,1864 # ffffffffc0203108 <buddy_pmm_manager+0x148>
ffffffffc02019c8:	ffafe0ef          	jal	ra,ffffffffc02001c2 <__panic>
assert(page_kva != slab_page);
ffffffffc02019cc:	00002697          	auipc	a3,0x2
ffffffffc02019d0:	83c68693          	addi	a3,a3,-1988 # ffffffffc0203208 <buddy_pmm_manager+0x248>
ffffffffc02019d4:	00000617          	auipc	a2,0x0
ffffffffc02019d8:	73460613          	addi	a2,a2,1844 # ffffffffc0202108 <etext+0x288>
ffffffffc02019dc:	12f00593          	li	a1,303
ffffffffc02019e0:	00001517          	auipc	a0,0x1
ffffffffc02019e4:	72850513          	addi	a0,a0,1832 # ffffffffc0203108 <buddy_pmm_manager+0x148>
ffffffffc02019e8:	fdafe0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc02019ec <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02019ec:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02019f0:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc02019f2:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02019f6:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02019f8:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02019fc:	f022                	sd	s0,32(sp)
ffffffffc02019fe:	ec26                	sd	s1,24(sp)
ffffffffc0201a00:	e84a                	sd	s2,16(sp)
ffffffffc0201a02:	f406                	sd	ra,40(sp)
ffffffffc0201a04:	e44e                	sd	s3,8(sp)
ffffffffc0201a06:	84aa                	mv	s1,a0
ffffffffc0201a08:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0201a0a:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0201a0e:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0201a10:	03067e63          	bgeu	a2,a6,ffffffffc0201a4c <printnum+0x60>
ffffffffc0201a14:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0201a16:	00805763          	blez	s0,ffffffffc0201a24 <printnum+0x38>
ffffffffc0201a1a:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201a1c:	85ca                	mv	a1,s2
ffffffffc0201a1e:	854e                	mv	a0,s3
ffffffffc0201a20:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0201a22:	fc65                	bnez	s0,ffffffffc0201a1a <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a24:	1a02                	slli	s4,s4,0x20
ffffffffc0201a26:	00002797          	auipc	a5,0x2
ffffffffc0201a2a:	89278793          	addi	a5,a5,-1902 # ffffffffc02032b8 <buddy_pmm_manager+0x2f8>
ffffffffc0201a2e:	020a5a13          	srli	s4,s4,0x20
ffffffffc0201a32:	9a3e                	add	s4,s4,a5
}
ffffffffc0201a34:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a36:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0201a3a:	70a2                	ld	ra,40(sp)
ffffffffc0201a3c:	69a2                	ld	s3,8(sp)
ffffffffc0201a3e:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a40:	85ca                	mv	a1,s2
ffffffffc0201a42:	87a6                	mv	a5,s1
}
ffffffffc0201a44:	6942                	ld	s2,16(sp)
ffffffffc0201a46:	64e2                	ld	s1,24(sp)
ffffffffc0201a48:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a4a:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0201a4c:	03065633          	divu	a2,a2,a6
ffffffffc0201a50:	8722                	mv	a4,s0
ffffffffc0201a52:	f9bff0ef          	jal	ra,ffffffffc02019ec <printnum>
ffffffffc0201a56:	b7f9                	j	ffffffffc0201a24 <printnum+0x38>

ffffffffc0201a58 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201a58:	7119                	addi	sp,sp,-128
ffffffffc0201a5a:	f4a6                	sd	s1,104(sp)
ffffffffc0201a5c:	f0ca                	sd	s2,96(sp)
ffffffffc0201a5e:	ecce                	sd	s3,88(sp)
ffffffffc0201a60:	e8d2                	sd	s4,80(sp)
ffffffffc0201a62:	e4d6                	sd	s5,72(sp)
ffffffffc0201a64:	e0da                	sd	s6,64(sp)
ffffffffc0201a66:	fc5e                	sd	s7,56(sp)
ffffffffc0201a68:	f06a                	sd	s10,32(sp)
ffffffffc0201a6a:	fc86                	sd	ra,120(sp)
ffffffffc0201a6c:	f8a2                	sd	s0,112(sp)
ffffffffc0201a6e:	f862                	sd	s8,48(sp)
ffffffffc0201a70:	f466                	sd	s9,40(sp)
ffffffffc0201a72:	ec6e                	sd	s11,24(sp)
ffffffffc0201a74:	892a                	mv	s2,a0
ffffffffc0201a76:	84ae                	mv	s1,a1
ffffffffc0201a78:	8d32                	mv	s10,a2
ffffffffc0201a7a:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201a7c:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0201a80:	5b7d                	li	s6,-1
ffffffffc0201a82:	00002a97          	auipc	s5,0x2
ffffffffc0201a86:	86aa8a93          	addi	s5,s5,-1942 # ffffffffc02032ec <buddy_pmm_manager+0x32c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201a8a:	00002b97          	auipc	s7,0x2
ffffffffc0201a8e:	a3eb8b93          	addi	s7,s7,-1474 # ffffffffc02034c8 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201a92:	000d4503          	lbu	a0,0(s10)
ffffffffc0201a96:	001d0413          	addi	s0,s10,1
ffffffffc0201a9a:	01350a63          	beq	a0,s3,ffffffffc0201aae <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0201a9e:	c121                	beqz	a0,ffffffffc0201ade <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0201aa0:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201aa2:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0201aa4:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201aa6:	fff44503          	lbu	a0,-1(s0)
ffffffffc0201aaa:	ff351ae3          	bne	a0,s3,ffffffffc0201a9e <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201aae:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0201ab2:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0201ab6:	4c81                	li	s9,0
ffffffffc0201ab8:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0201aba:	5c7d                	li	s8,-1
ffffffffc0201abc:	5dfd                	li	s11,-1
ffffffffc0201abe:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0201ac2:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201ac4:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201ac8:	0ff5f593          	zext.b	a1,a1
ffffffffc0201acc:	00140d13          	addi	s10,s0,1
ffffffffc0201ad0:	04b56263          	bltu	a0,a1,ffffffffc0201b14 <vprintfmt+0xbc>
ffffffffc0201ad4:	058a                	slli	a1,a1,0x2
ffffffffc0201ad6:	95d6                	add	a1,a1,s5
ffffffffc0201ad8:	4194                	lw	a3,0(a1)
ffffffffc0201ada:	96d6                	add	a3,a3,s5
ffffffffc0201adc:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0201ade:	70e6                	ld	ra,120(sp)
ffffffffc0201ae0:	7446                	ld	s0,112(sp)
ffffffffc0201ae2:	74a6                	ld	s1,104(sp)
ffffffffc0201ae4:	7906                	ld	s2,96(sp)
ffffffffc0201ae6:	69e6                	ld	s3,88(sp)
ffffffffc0201ae8:	6a46                	ld	s4,80(sp)
ffffffffc0201aea:	6aa6                	ld	s5,72(sp)
ffffffffc0201aec:	6b06                	ld	s6,64(sp)
ffffffffc0201aee:	7be2                	ld	s7,56(sp)
ffffffffc0201af0:	7c42                	ld	s8,48(sp)
ffffffffc0201af2:	7ca2                	ld	s9,40(sp)
ffffffffc0201af4:	7d02                	ld	s10,32(sp)
ffffffffc0201af6:	6de2                	ld	s11,24(sp)
ffffffffc0201af8:	6109                	addi	sp,sp,128
ffffffffc0201afa:	8082                	ret
            padc = '0';
ffffffffc0201afc:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0201afe:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b02:	846a                	mv	s0,s10
ffffffffc0201b04:	00140d13          	addi	s10,s0,1
ffffffffc0201b08:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201b0c:	0ff5f593          	zext.b	a1,a1
ffffffffc0201b10:	fcb572e3          	bgeu	a0,a1,ffffffffc0201ad4 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0201b14:	85a6                	mv	a1,s1
ffffffffc0201b16:	02500513          	li	a0,37
ffffffffc0201b1a:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201b1c:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201b20:	8d22                	mv	s10,s0
ffffffffc0201b22:	f73788e3          	beq	a5,s3,ffffffffc0201a92 <vprintfmt+0x3a>
ffffffffc0201b26:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0201b2a:	1d7d                	addi	s10,s10,-1
ffffffffc0201b2c:	ff379de3          	bne	a5,s3,ffffffffc0201b26 <vprintfmt+0xce>
ffffffffc0201b30:	b78d                	j	ffffffffc0201a92 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0201b32:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0201b36:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b3a:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0201b3c:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0201b40:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201b44:	02d86463          	bltu	a6,a3,ffffffffc0201b6c <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0201b48:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201b4c:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201b50:	0186873b          	addw	a4,a3,s8
ffffffffc0201b54:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201b58:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0201b5a:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201b5e:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201b60:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0201b64:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201b68:	fed870e3          	bgeu	a6,a3,ffffffffc0201b48 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0201b6c:	f40ddce3          	bgez	s11,ffffffffc0201ac4 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0201b70:	8de2                	mv	s11,s8
ffffffffc0201b72:	5c7d                	li	s8,-1
ffffffffc0201b74:	bf81                	j	ffffffffc0201ac4 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0201b76:	fffdc693          	not	a3,s11
ffffffffc0201b7a:	96fd                	srai	a3,a3,0x3f
ffffffffc0201b7c:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b80:	00144603          	lbu	a2,1(s0)
ffffffffc0201b84:	2d81                	sext.w	s11,s11
ffffffffc0201b86:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201b88:	bf35                	j	ffffffffc0201ac4 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0201b8a:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b8e:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0201b92:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b94:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0201b96:	bfd9                	j	ffffffffc0201b6c <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0201b98:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201b9a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201b9e:	01174463          	blt	a4,a7,ffffffffc0201ba6 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0201ba2:	1a088e63          	beqz	a7,ffffffffc0201d5e <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0201ba6:	000a3603          	ld	a2,0(s4)
ffffffffc0201baa:	46c1                	li	a3,16
ffffffffc0201bac:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201bae:	2781                	sext.w	a5,a5
ffffffffc0201bb0:	876e                	mv	a4,s11
ffffffffc0201bb2:	85a6                	mv	a1,s1
ffffffffc0201bb4:	854a                	mv	a0,s2
ffffffffc0201bb6:	e37ff0ef          	jal	ra,ffffffffc02019ec <printnum>
            break;
ffffffffc0201bba:	bde1                	j	ffffffffc0201a92 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0201bbc:	000a2503          	lw	a0,0(s4)
ffffffffc0201bc0:	85a6                	mv	a1,s1
ffffffffc0201bc2:	0a21                	addi	s4,s4,8
ffffffffc0201bc4:	9902                	jalr	s2
            break;
ffffffffc0201bc6:	b5f1                	j	ffffffffc0201a92 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201bc8:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201bca:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201bce:	01174463          	blt	a4,a7,ffffffffc0201bd6 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0201bd2:	18088163          	beqz	a7,ffffffffc0201d54 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0201bd6:	000a3603          	ld	a2,0(s4)
ffffffffc0201bda:	46a9                	li	a3,10
ffffffffc0201bdc:	8a2e                	mv	s4,a1
ffffffffc0201bde:	bfc1                	j	ffffffffc0201bae <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201be0:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0201be4:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201be6:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201be8:	bdf1                	j	ffffffffc0201ac4 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0201bea:	85a6                	mv	a1,s1
ffffffffc0201bec:	02500513          	li	a0,37
ffffffffc0201bf0:	9902                	jalr	s2
            break;
ffffffffc0201bf2:	b545                	j	ffffffffc0201a92 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201bf4:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0201bf8:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201bfa:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201bfc:	b5e1                	j	ffffffffc0201ac4 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0201bfe:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201c00:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201c04:	01174463          	blt	a4,a7,ffffffffc0201c0c <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0201c08:	14088163          	beqz	a7,ffffffffc0201d4a <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0201c0c:	000a3603          	ld	a2,0(s4)
ffffffffc0201c10:	46a1                	li	a3,8
ffffffffc0201c12:	8a2e                	mv	s4,a1
ffffffffc0201c14:	bf69                	j	ffffffffc0201bae <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0201c16:	03000513          	li	a0,48
ffffffffc0201c1a:	85a6                	mv	a1,s1
ffffffffc0201c1c:	e03e                	sd	a5,0(sp)
ffffffffc0201c1e:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0201c20:	85a6                	mv	a1,s1
ffffffffc0201c22:	07800513          	li	a0,120
ffffffffc0201c26:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201c28:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0201c2a:	6782                	ld	a5,0(sp)
ffffffffc0201c2c:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201c2e:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0201c32:	bfb5                	j	ffffffffc0201bae <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201c34:	000a3403          	ld	s0,0(s4)
ffffffffc0201c38:	008a0713          	addi	a4,s4,8
ffffffffc0201c3c:	e03a                	sd	a4,0(sp)
ffffffffc0201c3e:	14040263          	beqz	s0,ffffffffc0201d82 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0201c42:	0fb05763          	blez	s11,ffffffffc0201d30 <vprintfmt+0x2d8>
ffffffffc0201c46:	02d00693          	li	a3,45
ffffffffc0201c4a:	0cd79163          	bne	a5,a3,ffffffffc0201d0c <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c4e:	00044783          	lbu	a5,0(s0)
ffffffffc0201c52:	0007851b          	sext.w	a0,a5
ffffffffc0201c56:	cf85                	beqz	a5,ffffffffc0201c8e <vprintfmt+0x236>
ffffffffc0201c58:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201c5c:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c60:	000c4563          	bltz	s8,ffffffffc0201c6a <vprintfmt+0x212>
ffffffffc0201c64:	3c7d                	addiw	s8,s8,-1
ffffffffc0201c66:	036c0263          	beq	s8,s6,ffffffffc0201c8a <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0201c6a:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201c6c:	0e0c8e63          	beqz	s9,ffffffffc0201d68 <vprintfmt+0x310>
ffffffffc0201c70:	3781                	addiw	a5,a5,-32
ffffffffc0201c72:	0ef47b63          	bgeu	s0,a5,ffffffffc0201d68 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0201c76:	03f00513          	li	a0,63
ffffffffc0201c7a:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c7c:	000a4783          	lbu	a5,0(s4)
ffffffffc0201c80:	3dfd                	addiw	s11,s11,-1
ffffffffc0201c82:	0a05                	addi	s4,s4,1
ffffffffc0201c84:	0007851b          	sext.w	a0,a5
ffffffffc0201c88:	ffe1                	bnez	a5,ffffffffc0201c60 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0201c8a:	01b05963          	blez	s11,ffffffffc0201c9c <vprintfmt+0x244>
ffffffffc0201c8e:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0201c90:	85a6                	mv	a1,s1
ffffffffc0201c92:	02000513          	li	a0,32
ffffffffc0201c96:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0201c98:	fe0d9be3          	bnez	s11,ffffffffc0201c8e <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201c9c:	6a02                	ld	s4,0(sp)
ffffffffc0201c9e:	bbd5                	j	ffffffffc0201a92 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201ca0:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201ca2:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0201ca6:	01174463          	blt	a4,a7,ffffffffc0201cae <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0201caa:	08088d63          	beqz	a7,ffffffffc0201d44 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0201cae:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201cb2:	0a044d63          	bltz	s0,ffffffffc0201d6c <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0201cb6:	8622                	mv	a2,s0
ffffffffc0201cb8:	8a66                	mv	s4,s9
ffffffffc0201cba:	46a9                	li	a3,10
ffffffffc0201cbc:	bdcd                	j	ffffffffc0201bae <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0201cbe:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201cc2:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0201cc4:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0201cc6:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0201cca:	8fb5                	xor	a5,a5,a3
ffffffffc0201ccc:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201cd0:	02d74163          	blt	a4,a3,ffffffffc0201cf2 <vprintfmt+0x29a>
ffffffffc0201cd4:	00369793          	slli	a5,a3,0x3
ffffffffc0201cd8:	97de                	add	a5,a5,s7
ffffffffc0201cda:	639c                	ld	a5,0(a5)
ffffffffc0201cdc:	cb99                	beqz	a5,ffffffffc0201cf2 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0201cde:	86be                	mv	a3,a5
ffffffffc0201ce0:	00001617          	auipc	a2,0x1
ffffffffc0201ce4:	60860613          	addi	a2,a2,1544 # ffffffffc02032e8 <buddy_pmm_manager+0x328>
ffffffffc0201ce8:	85a6                	mv	a1,s1
ffffffffc0201cea:	854a                	mv	a0,s2
ffffffffc0201cec:	0ce000ef          	jal	ra,ffffffffc0201dba <printfmt>
ffffffffc0201cf0:	b34d                	j	ffffffffc0201a92 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201cf2:	00001617          	auipc	a2,0x1
ffffffffc0201cf6:	5e660613          	addi	a2,a2,1510 # ffffffffc02032d8 <buddy_pmm_manager+0x318>
ffffffffc0201cfa:	85a6                	mv	a1,s1
ffffffffc0201cfc:	854a                	mv	a0,s2
ffffffffc0201cfe:	0bc000ef          	jal	ra,ffffffffc0201dba <printfmt>
ffffffffc0201d02:	bb41                	j	ffffffffc0201a92 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0201d04:	00001417          	auipc	s0,0x1
ffffffffc0201d08:	5cc40413          	addi	s0,s0,1484 # ffffffffc02032d0 <buddy_pmm_manager+0x310>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d0c:	85e2                	mv	a1,s8
ffffffffc0201d0e:	8522                	mv	a0,s0
ffffffffc0201d10:	e43e                	sd	a5,8(sp)
ffffffffc0201d12:	0fc000ef          	jal	ra,ffffffffc0201e0e <strnlen>
ffffffffc0201d16:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201d1a:	01b05b63          	blez	s11,ffffffffc0201d30 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0201d1e:	67a2                	ld	a5,8(sp)
ffffffffc0201d20:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d24:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0201d26:	85a6                	mv	a1,s1
ffffffffc0201d28:	8552                	mv	a0,s4
ffffffffc0201d2a:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d2c:	fe0d9ce3          	bnez	s11,ffffffffc0201d24 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d30:	00044783          	lbu	a5,0(s0)
ffffffffc0201d34:	00140a13          	addi	s4,s0,1
ffffffffc0201d38:	0007851b          	sext.w	a0,a5
ffffffffc0201d3c:	d3a5                	beqz	a5,ffffffffc0201c9c <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201d3e:	05e00413          	li	s0,94
ffffffffc0201d42:	bf39                	j	ffffffffc0201c60 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0201d44:	000a2403          	lw	s0,0(s4)
ffffffffc0201d48:	b7ad                	j	ffffffffc0201cb2 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0201d4a:	000a6603          	lwu	a2,0(s4)
ffffffffc0201d4e:	46a1                	li	a3,8
ffffffffc0201d50:	8a2e                	mv	s4,a1
ffffffffc0201d52:	bdb1                	j	ffffffffc0201bae <vprintfmt+0x156>
ffffffffc0201d54:	000a6603          	lwu	a2,0(s4)
ffffffffc0201d58:	46a9                	li	a3,10
ffffffffc0201d5a:	8a2e                	mv	s4,a1
ffffffffc0201d5c:	bd89                	j	ffffffffc0201bae <vprintfmt+0x156>
ffffffffc0201d5e:	000a6603          	lwu	a2,0(s4)
ffffffffc0201d62:	46c1                	li	a3,16
ffffffffc0201d64:	8a2e                	mv	s4,a1
ffffffffc0201d66:	b5a1                	j	ffffffffc0201bae <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0201d68:	9902                	jalr	s2
ffffffffc0201d6a:	bf09                	j	ffffffffc0201c7c <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0201d6c:	85a6                	mv	a1,s1
ffffffffc0201d6e:	02d00513          	li	a0,45
ffffffffc0201d72:	e03e                	sd	a5,0(sp)
ffffffffc0201d74:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0201d76:	6782                	ld	a5,0(sp)
ffffffffc0201d78:	8a66                	mv	s4,s9
ffffffffc0201d7a:	40800633          	neg	a2,s0
ffffffffc0201d7e:	46a9                	li	a3,10
ffffffffc0201d80:	b53d                	j	ffffffffc0201bae <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0201d82:	03b05163          	blez	s11,ffffffffc0201da4 <vprintfmt+0x34c>
ffffffffc0201d86:	02d00693          	li	a3,45
ffffffffc0201d8a:	f6d79de3          	bne	a5,a3,ffffffffc0201d04 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0201d8e:	00001417          	auipc	s0,0x1
ffffffffc0201d92:	54240413          	addi	s0,s0,1346 # ffffffffc02032d0 <buddy_pmm_manager+0x310>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d96:	02800793          	li	a5,40
ffffffffc0201d9a:	02800513          	li	a0,40
ffffffffc0201d9e:	00140a13          	addi	s4,s0,1
ffffffffc0201da2:	bd6d                	j	ffffffffc0201c5c <vprintfmt+0x204>
ffffffffc0201da4:	00001a17          	auipc	s4,0x1
ffffffffc0201da8:	52da0a13          	addi	s4,s4,1325 # ffffffffc02032d1 <buddy_pmm_manager+0x311>
ffffffffc0201dac:	02800513          	li	a0,40
ffffffffc0201db0:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201db4:	05e00413          	li	s0,94
ffffffffc0201db8:	b565                	j	ffffffffc0201c60 <vprintfmt+0x208>

ffffffffc0201dba <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201dba:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201dbc:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201dc0:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201dc2:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201dc4:	ec06                	sd	ra,24(sp)
ffffffffc0201dc6:	f83a                	sd	a4,48(sp)
ffffffffc0201dc8:	fc3e                	sd	a5,56(sp)
ffffffffc0201dca:	e0c2                	sd	a6,64(sp)
ffffffffc0201dcc:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0201dce:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201dd0:	c89ff0ef          	jal	ra,ffffffffc0201a58 <vprintfmt>
}
ffffffffc0201dd4:	60e2                	ld	ra,24(sp)
ffffffffc0201dd6:	6161                	addi	sp,sp,80
ffffffffc0201dd8:	8082                	ret

ffffffffc0201dda <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201dda:	4781                	li	a5,0
ffffffffc0201ddc:	00005717          	auipc	a4,0x5
ffffffffc0201de0:	23473703          	ld	a4,564(a4) # ffffffffc0207010 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201de4:	88ba                	mv	a7,a4
ffffffffc0201de6:	852a                	mv	a0,a0
ffffffffc0201de8:	85be                	mv	a1,a5
ffffffffc0201dea:	863e                	mv	a2,a5
ffffffffc0201dec:	00000073          	ecall
ffffffffc0201df0:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc0201df2:	8082                	ret

ffffffffc0201df4 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0201df4:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0201df8:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0201dfa:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0201dfc:	cb81                	beqz	a5,ffffffffc0201e0c <strlen+0x18>
        cnt ++;
ffffffffc0201dfe:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0201e00:	00a707b3          	add	a5,a4,a0
ffffffffc0201e04:	0007c783          	lbu	a5,0(a5)
ffffffffc0201e08:	fbfd                	bnez	a5,ffffffffc0201dfe <strlen+0xa>
ffffffffc0201e0a:	8082                	ret
    }
    return cnt;
}
ffffffffc0201e0c:	8082                	ret

ffffffffc0201e0e <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201e0e:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201e10:	e589                	bnez	a1,ffffffffc0201e1a <strnlen+0xc>
ffffffffc0201e12:	a811                	j	ffffffffc0201e26 <strnlen+0x18>
        cnt ++;
ffffffffc0201e14:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201e16:	00f58863          	beq	a1,a5,ffffffffc0201e26 <strnlen+0x18>
ffffffffc0201e1a:	00f50733          	add	a4,a0,a5
ffffffffc0201e1e:	00074703          	lbu	a4,0(a4)
ffffffffc0201e22:	fb6d                	bnez	a4,ffffffffc0201e14 <strnlen+0x6>
ffffffffc0201e24:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201e26:	852e                	mv	a0,a1
ffffffffc0201e28:	8082                	ret

ffffffffc0201e2a <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201e2a:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201e2e:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201e32:	cb89                	beqz	a5,ffffffffc0201e44 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0201e34:	0505                	addi	a0,a0,1
ffffffffc0201e36:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201e38:	fee789e3          	beq	a5,a4,ffffffffc0201e2a <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201e3c:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0201e40:	9d19                	subw	a0,a0,a4
ffffffffc0201e42:	8082                	ret
ffffffffc0201e44:	4501                	li	a0,0
ffffffffc0201e46:	bfed                	j	ffffffffc0201e40 <strcmp+0x16>

ffffffffc0201e48 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201e48:	c20d                	beqz	a2,ffffffffc0201e6a <strncmp+0x22>
ffffffffc0201e4a:	962e                	add	a2,a2,a1
ffffffffc0201e4c:	a031                	j	ffffffffc0201e58 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0201e4e:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201e50:	00e79a63          	bne	a5,a4,ffffffffc0201e64 <strncmp+0x1c>
ffffffffc0201e54:	00b60b63          	beq	a2,a1,ffffffffc0201e6a <strncmp+0x22>
ffffffffc0201e58:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201e5c:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201e5e:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0201e62:	f7f5                	bnez	a5,ffffffffc0201e4e <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201e64:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0201e68:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201e6a:	4501                	li	a0,0
ffffffffc0201e6c:	8082                	ret

ffffffffc0201e6e <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201e6e:	ca01                	beqz	a2,ffffffffc0201e7e <memset+0x10>
ffffffffc0201e70:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0201e72:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0201e74:	0785                	addi	a5,a5,1
ffffffffc0201e76:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201e7a:	fec79de3          	bne	a5,a2,ffffffffc0201e74 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201e7e:	8082                	ret
