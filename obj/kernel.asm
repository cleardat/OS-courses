
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00007297          	auipc	t0,0x7
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0207000 <boot_hartid>
ffffffffc020000c:	00007297          	auipc	t0,0x7
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0207008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02062b7          	lui	t0,0xc0206
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0206137          	lui	sp,0xc0206
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
ffffffffc0200044:	0d828293          	addi	t0,t0,216 # ffffffffc02000d8 <kern_init>
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <print_kerninfo>:
ffffffffc020004a:	1141                	addi	sp,sp,-16
ffffffffc020004c:	00002517          	auipc	a0,0x2
ffffffffc0200050:	08c50513          	addi	a0,a0,140 # ffffffffc02020d8 <etext+0x6>
ffffffffc0200054:	e406                	sd	ra,8(sp)
ffffffffc0200056:	0f6000ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc020005a:	00000597          	auipc	a1,0x0
ffffffffc020005e:	07e58593          	addi	a1,a1,126 # ffffffffc02000d8 <kern_init>
ffffffffc0200062:	00002517          	auipc	a0,0x2
ffffffffc0200066:	09650513          	addi	a0,a0,150 # ffffffffc02020f8 <etext+0x26>
ffffffffc020006a:	0e2000ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc020006e:	00002597          	auipc	a1,0x2
ffffffffc0200072:	06458593          	addi	a1,a1,100 # ffffffffc02020d2 <etext>
ffffffffc0200076:	00002517          	auipc	a0,0x2
ffffffffc020007a:	0a250513          	addi	a0,a0,162 # ffffffffc0202118 <etext+0x46>
ffffffffc020007e:	0ce000ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200082:	00007597          	auipc	a1,0x7
ffffffffc0200086:	f9658593          	addi	a1,a1,-106 # ffffffffc0207018 <buddy_mgr>
ffffffffc020008a:	00002517          	auipc	a0,0x2
ffffffffc020008e:	0ae50513          	addi	a0,a0,174 # ffffffffc0202138 <etext+0x66>
ffffffffc0200092:	0ba000ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200096:	00027597          	auipc	a1,0x27
ffffffffc020009a:	01258593          	addi	a1,a1,18 # ffffffffc02270a8 <end>
ffffffffc020009e:	00002517          	auipc	a0,0x2
ffffffffc02000a2:	0ba50513          	addi	a0,a0,186 # ffffffffc0202158 <etext+0x86>
ffffffffc02000a6:	0a6000ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc02000aa:	00027597          	auipc	a1,0x27
ffffffffc02000ae:	3fd58593          	addi	a1,a1,1021 # ffffffffc02274a7 <end+0x3ff>
ffffffffc02000b2:	00000797          	auipc	a5,0x0
ffffffffc02000b6:	02678793          	addi	a5,a5,38 # ffffffffc02000d8 <kern_init>
ffffffffc02000ba:	40f587b3          	sub	a5,a1,a5
ffffffffc02000be:	43f7d593          	srai	a1,a5,0x3f
ffffffffc02000c2:	60a2                	ld	ra,8(sp)
ffffffffc02000c4:	3ff5f593          	andi	a1,a1,1023
ffffffffc02000c8:	95be                	add	a1,a1,a5
ffffffffc02000ca:	85a9                	srai	a1,a1,0xa
ffffffffc02000cc:	00002517          	auipc	a0,0x2
ffffffffc02000d0:	0ac50513          	addi	a0,a0,172 # ffffffffc0202178 <etext+0xa6>
ffffffffc02000d4:	0141                	addi	sp,sp,16
ffffffffc02000d6:	a89d                	j	ffffffffc020014c <cprintf>

ffffffffc02000d8 <kern_init>:
ffffffffc02000d8:	00007517          	auipc	a0,0x7
ffffffffc02000dc:	f4050513          	addi	a0,a0,-192 # ffffffffc0207018 <buddy_mgr>
ffffffffc02000e0:	00027617          	auipc	a2,0x27
ffffffffc02000e4:	fc860613          	addi	a2,a2,-56 # ffffffffc02270a8 <end>
ffffffffc02000e8:	1141                	addi	sp,sp,-16
ffffffffc02000ea:	8e09                	sub	a2,a2,a0
ffffffffc02000ec:	4581                	li	a1,0
ffffffffc02000ee:	e406                	sd	ra,8(sp)
ffffffffc02000f0:	7d1010ef          	jal	ra,ffffffffc02020c0 <memset>
ffffffffc02000f4:	12c000ef          	jal	ra,ffffffffc0200220 <dtb_init>
ffffffffc02000f8:	11e000ef          	jal	ra,ffffffffc0200216 <cons_init>
ffffffffc02000fc:	00002517          	auipc	a0,0x2
ffffffffc0200100:	0ac50513          	addi	a0,a0,172 # ffffffffc02021a8 <etext+0xd6>
ffffffffc0200104:	07e000ef          	jal	ra,ffffffffc0200182 <cputs>
ffffffffc0200108:	f43ff0ef          	jal	ra,ffffffffc020004a <print_kerninfo>
ffffffffc020010c:	17e010ef          	jal	ra,ffffffffc020128a <pmm_init>
ffffffffc0200110:	a001                	j	ffffffffc0200110 <kern_init+0x38>

ffffffffc0200112 <cputch>:
ffffffffc0200112:	1141                	addi	sp,sp,-16
ffffffffc0200114:	e022                	sd	s0,0(sp)
ffffffffc0200116:	e406                	sd	ra,8(sp)
ffffffffc0200118:	842e                	mv	s0,a1
ffffffffc020011a:	0fe000ef          	jal	ra,ffffffffc0200218 <cons_putc>
ffffffffc020011e:	401c                	lw	a5,0(s0)
ffffffffc0200120:	60a2                	ld	ra,8(sp)
ffffffffc0200122:	2785                	addiw	a5,a5,1
ffffffffc0200124:	c01c                	sw	a5,0(s0)
ffffffffc0200126:	6402                	ld	s0,0(sp)
ffffffffc0200128:	0141                	addi	sp,sp,16
ffffffffc020012a:	8082                	ret

ffffffffc020012c <vcprintf>:
ffffffffc020012c:	1101                	addi	sp,sp,-32
ffffffffc020012e:	862a                	mv	a2,a0
ffffffffc0200130:	86ae                	mv	a3,a1
ffffffffc0200132:	00000517          	auipc	a0,0x0
ffffffffc0200136:	fe050513          	addi	a0,a0,-32 # ffffffffc0200112 <cputch>
ffffffffc020013a:	006c                	addi	a1,sp,12
ffffffffc020013c:	ec06                	sd	ra,24(sp)
ffffffffc020013e:	c602                	sw	zero,12(sp)
ffffffffc0200140:	36b010ef          	jal	ra,ffffffffc0201caa <vprintfmt>
ffffffffc0200144:	60e2                	ld	ra,24(sp)
ffffffffc0200146:	4532                	lw	a0,12(sp)
ffffffffc0200148:	6105                	addi	sp,sp,32
ffffffffc020014a:	8082                	ret

ffffffffc020014c <cprintf>:
ffffffffc020014c:	711d                	addi	sp,sp,-96
ffffffffc020014e:	02810313          	addi	t1,sp,40 # ffffffffc0206028 <boot_page_table_sv39+0x28>
ffffffffc0200152:	8e2a                	mv	t3,a0
ffffffffc0200154:	f42e                	sd	a1,40(sp)
ffffffffc0200156:	f832                	sd	a2,48(sp)
ffffffffc0200158:	fc36                	sd	a3,56(sp)
ffffffffc020015a:	00000517          	auipc	a0,0x0
ffffffffc020015e:	fb850513          	addi	a0,a0,-72 # ffffffffc0200112 <cputch>
ffffffffc0200162:	004c                	addi	a1,sp,4
ffffffffc0200164:	869a                	mv	a3,t1
ffffffffc0200166:	8672                	mv	a2,t3
ffffffffc0200168:	ec06                	sd	ra,24(sp)
ffffffffc020016a:	e0ba                	sd	a4,64(sp)
ffffffffc020016c:	e4be                	sd	a5,72(sp)
ffffffffc020016e:	e8c2                	sd	a6,80(sp)
ffffffffc0200170:	ecc6                	sd	a7,88(sp)
ffffffffc0200172:	e41a                	sd	t1,8(sp)
ffffffffc0200174:	c202                	sw	zero,4(sp)
ffffffffc0200176:	335010ef          	jal	ra,ffffffffc0201caa <vprintfmt>
ffffffffc020017a:	60e2                	ld	ra,24(sp)
ffffffffc020017c:	4512                	lw	a0,4(sp)
ffffffffc020017e:	6125                	addi	sp,sp,96
ffffffffc0200180:	8082                	ret

ffffffffc0200182 <cputs>:
ffffffffc0200182:	1101                	addi	sp,sp,-32
ffffffffc0200184:	e822                	sd	s0,16(sp)
ffffffffc0200186:	ec06                	sd	ra,24(sp)
ffffffffc0200188:	e426                	sd	s1,8(sp)
ffffffffc020018a:	842a                	mv	s0,a0
ffffffffc020018c:	00054503          	lbu	a0,0(a0)
ffffffffc0200190:	c51d                	beqz	a0,ffffffffc02001be <cputs+0x3c>
ffffffffc0200192:	0405                	addi	s0,s0,1
ffffffffc0200194:	4485                	li	s1,1
ffffffffc0200196:	9c81                	subw	s1,s1,s0
ffffffffc0200198:	080000ef          	jal	ra,ffffffffc0200218 <cons_putc>
ffffffffc020019c:	00044503          	lbu	a0,0(s0)
ffffffffc02001a0:	008487bb          	addw	a5,s1,s0
ffffffffc02001a4:	0405                	addi	s0,s0,1
ffffffffc02001a6:	f96d                	bnez	a0,ffffffffc0200198 <cputs+0x16>
ffffffffc02001a8:	0017841b          	addiw	s0,a5,1
ffffffffc02001ac:	4529                	li	a0,10
ffffffffc02001ae:	06a000ef          	jal	ra,ffffffffc0200218 <cons_putc>
ffffffffc02001b2:	60e2                	ld	ra,24(sp)
ffffffffc02001b4:	8522                	mv	a0,s0
ffffffffc02001b6:	6442                	ld	s0,16(sp)
ffffffffc02001b8:	64a2                	ld	s1,8(sp)
ffffffffc02001ba:	6105                	addi	sp,sp,32
ffffffffc02001bc:	8082                	ret
ffffffffc02001be:	4405                	li	s0,1
ffffffffc02001c0:	b7f5                	j	ffffffffc02001ac <cputs+0x2a>

ffffffffc02001c2 <__panic>:
ffffffffc02001c2:	00027317          	auipc	t1,0x27
ffffffffc02001c6:	e9e30313          	addi	t1,t1,-354 # ffffffffc0227060 <is_panic>
ffffffffc02001ca:	00032e03          	lw	t3,0(t1)
ffffffffc02001ce:	715d                	addi	sp,sp,-80
ffffffffc02001d0:	ec06                	sd	ra,24(sp)
ffffffffc02001d2:	e822                	sd	s0,16(sp)
ffffffffc02001d4:	f436                	sd	a3,40(sp)
ffffffffc02001d6:	f83a                	sd	a4,48(sp)
ffffffffc02001d8:	fc3e                	sd	a5,56(sp)
ffffffffc02001da:	e0c2                	sd	a6,64(sp)
ffffffffc02001dc:	e4c6                	sd	a7,72(sp)
ffffffffc02001de:	000e0363          	beqz	t3,ffffffffc02001e4 <__panic+0x22>
ffffffffc02001e2:	a001                	j	ffffffffc02001e2 <__panic+0x20>
ffffffffc02001e4:	4785                	li	a5,1
ffffffffc02001e6:	00f32023          	sw	a5,0(t1)
ffffffffc02001ea:	8432                	mv	s0,a2
ffffffffc02001ec:	103c                	addi	a5,sp,40
ffffffffc02001ee:	862e                	mv	a2,a1
ffffffffc02001f0:	85aa                	mv	a1,a0
ffffffffc02001f2:	00002517          	auipc	a0,0x2
ffffffffc02001f6:	fd650513          	addi	a0,a0,-42 # ffffffffc02021c8 <etext+0xf6>
ffffffffc02001fa:	e43e                	sd	a5,8(sp)
ffffffffc02001fc:	f51ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200200:	65a2                	ld	a1,8(sp)
ffffffffc0200202:	8522                	mv	a0,s0
ffffffffc0200204:	f29ff0ef          	jal	ra,ffffffffc020012c <vcprintf>
ffffffffc0200208:	00003517          	auipc	a0,0x3
ffffffffc020020c:	83850513          	addi	a0,a0,-1992 # ffffffffc0202a40 <etext+0x96e>
ffffffffc0200210:	f3dff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200214:	b7f9                	j	ffffffffc02001e2 <__panic+0x20>

ffffffffc0200216 <cons_init>:
ffffffffc0200216:	8082                	ret

ffffffffc0200218 <cons_putc>:
ffffffffc0200218:	0ff57513          	zext.b	a0,a0
ffffffffc020021c:	6110106f          	j	ffffffffc020202c <sbi_console_putchar>

ffffffffc0200220 <dtb_init>:
ffffffffc0200220:	7119                	addi	sp,sp,-128
ffffffffc0200222:	00002517          	auipc	a0,0x2
ffffffffc0200226:	fc650513          	addi	a0,a0,-58 # ffffffffc02021e8 <etext+0x116>
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
ffffffffc0200244:	f09ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200248:	00007597          	auipc	a1,0x7
ffffffffc020024c:	db85b583          	ld	a1,-584(a1) # ffffffffc0207000 <boot_hartid>
ffffffffc0200250:	00002517          	auipc	a0,0x2
ffffffffc0200254:	fa850513          	addi	a0,a0,-88 # ffffffffc02021f8 <etext+0x126>
ffffffffc0200258:	ef5ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc020025c:	00007417          	auipc	s0,0x7
ffffffffc0200260:	dac40413          	addi	s0,s0,-596 # ffffffffc0207008 <boot_dtb>
ffffffffc0200264:	600c                	ld	a1,0(s0)
ffffffffc0200266:	00002517          	auipc	a0,0x2
ffffffffc020026a:	fa250513          	addi	a0,a0,-94 # ffffffffc0202208 <etext+0x136>
ffffffffc020026e:	edfff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200272:	00043a03          	ld	s4,0(s0)
ffffffffc0200276:	00002517          	auipc	a0,0x2
ffffffffc020027a:	faa50513          	addi	a0,a0,-86 # ffffffffc0202220 <etext+0x14e>
ffffffffc020027e:	120a0463          	beqz	s4,ffffffffc02003a6 <dtb_init+0x186>
ffffffffc0200282:	57f5                	li	a5,-3
ffffffffc0200284:	07fa                	slli	a5,a5,0x1e
ffffffffc0200286:	00fa0733          	add	a4,s4,a5
ffffffffc020028a:	431c                	lw	a5,0(a4)
ffffffffc020028c:	00ff0637          	lui	a2,0xff0
ffffffffc0200290:	6b41                	lui	s6,0x10
ffffffffc0200292:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200296:	0187969b          	slliw	a3,a5,0x18
ffffffffc020029a:	0187d51b          	srliw	a0,a5,0x18
ffffffffc020029e:	0105959b          	slliw	a1,a1,0x10
ffffffffc02002a2:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02002a6:	8df1                	and	a1,a1,a2
ffffffffc02002a8:	8ec9                	or	a3,a3,a0
ffffffffc02002aa:	0087979b          	slliw	a5,a5,0x8
ffffffffc02002ae:	1b7d                	addi	s6,s6,-1
ffffffffc02002b0:	0167f7b3          	and	a5,a5,s6
ffffffffc02002b4:	8dd5                	or	a1,a1,a3
ffffffffc02002b6:	8ddd                	or	a1,a1,a5
ffffffffc02002b8:	d00e07b7          	lui	a5,0xd00e0
ffffffffc02002bc:	2581                	sext.w	a1,a1
ffffffffc02002be:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfeb8e45>
ffffffffc02002c2:	10f59163          	bne	a1,a5,ffffffffc02003c4 <dtb_init+0x1a4>
ffffffffc02002c6:	471c                	lw	a5,8(a4)
ffffffffc02002c8:	4754                	lw	a3,12(a4)
ffffffffc02002ca:	4c81                	li	s9,0
ffffffffc02002cc:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02002d0:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02002d4:	0186941b          	slliw	s0,a3,0x18
ffffffffc02002d8:	0186d89b          	srliw	a7,a3,0x18
ffffffffc02002dc:	01879a1b          	slliw	s4,a5,0x18
ffffffffc02002e0:	0187d81b          	srliw	a6,a5,0x18
ffffffffc02002e4:	0105151b          	slliw	a0,a0,0x10
ffffffffc02002e8:	0106d69b          	srliw	a3,a3,0x10
ffffffffc02002ec:	0105959b          	slliw	a1,a1,0x10
ffffffffc02002f0:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02002f4:	8d71                	and	a0,a0,a2
ffffffffc02002f6:	01146433          	or	s0,s0,a7
ffffffffc02002fa:	0086969b          	slliw	a3,a3,0x8
ffffffffc02002fe:	010a6a33          	or	s4,s4,a6
ffffffffc0200302:	8e6d                	and	a2,a2,a1
ffffffffc0200304:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200308:	8c49                	or	s0,s0,a0
ffffffffc020030a:	0166f6b3          	and	a3,a3,s6
ffffffffc020030e:	00ca6a33          	or	s4,s4,a2
ffffffffc0200312:	0167f7b3          	and	a5,a5,s6
ffffffffc0200316:	8c55                	or	s0,s0,a3
ffffffffc0200318:	00fa6a33          	or	s4,s4,a5
ffffffffc020031c:	1402                	slli	s0,s0,0x20
ffffffffc020031e:	1a02                	slli	s4,s4,0x20
ffffffffc0200320:	9001                	srli	s0,s0,0x20
ffffffffc0200322:	020a5a13          	srli	s4,s4,0x20
ffffffffc0200326:	943a                	add	s0,s0,a4
ffffffffc0200328:	9a3a                	add	s4,s4,a4
ffffffffc020032a:	00ff0c37          	lui	s8,0xff0
ffffffffc020032e:	4b8d                	li	s7,3
ffffffffc0200330:	00002917          	auipc	s2,0x2
ffffffffc0200334:	f4090913          	addi	s2,s2,-192 # ffffffffc0202270 <etext+0x19e>
ffffffffc0200338:	49bd                	li	s3,15
ffffffffc020033a:	4d91                	li	s11,4
ffffffffc020033c:	4d05                	li	s10,1
ffffffffc020033e:	00002497          	auipc	s1,0x2
ffffffffc0200342:	f2a48493          	addi	s1,s1,-214 # ffffffffc0202268 <etext+0x196>
ffffffffc0200346:	000a2703          	lw	a4,0(s4)
ffffffffc020034a:	004a0a93          	addi	s5,s4,4
ffffffffc020034e:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200352:	0187179b          	slliw	a5,a4,0x18
ffffffffc0200356:	0187561b          	srliw	a2,a4,0x18
ffffffffc020035a:	0106969b          	slliw	a3,a3,0x10
ffffffffc020035e:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200362:	8fd1                	or	a5,a5,a2
ffffffffc0200364:	0186f6b3          	and	a3,a3,s8
ffffffffc0200368:	0087171b          	slliw	a4,a4,0x8
ffffffffc020036c:	8fd5                	or	a5,a5,a3
ffffffffc020036e:	00eb7733          	and	a4,s6,a4
ffffffffc0200372:	8fd9                	or	a5,a5,a4
ffffffffc0200374:	2781                	sext.w	a5,a5
ffffffffc0200376:	09778c63          	beq	a5,s7,ffffffffc020040e <dtb_init+0x1ee>
ffffffffc020037a:	00fbea63          	bltu	s7,a5,ffffffffc020038e <dtb_init+0x16e>
ffffffffc020037e:	07a78663          	beq	a5,s10,ffffffffc02003ea <dtb_init+0x1ca>
ffffffffc0200382:	4709                	li	a4,2
ffffffffc0200384:	00e79763          	bne	a5,a4,ffffffffc0200392 <dtb_init+0x172>
ffffffffc0200388:	4c81                	li	s9,0
ffffffffc020038a:	8a56                	mv	s4,s5
ffffffffc020038c:	bf6d                	j	ffffffffc0200346 <dtb_init+0x126>
ffffffffc020038e:	ffb78ee3          	beq	a5,s11,ffffffffc020038a <dtb_init+0x16a>
ffffffffc0200392:	00002517          	auipc	a0,0x2
ffffffffc0200396:	f5650513          	addi	a0,a0,-170 # ffffffffc02022e8 <etext+0x216>
ffffffffc020039a:	db3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc020039e:	00002517          	auipc	a0,0x2
ffffffffc02003a2:	f8250513          	addi	a0,a0,-126 # ffffffffc0202320 <etext+0x24e>
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
ffffffffc02003c2:	b369                	j	ffffffffc020014c <cprintf>
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
ffffffffc02003de:	00002517          	auipc	a0,0x2
ffffffffc02003e2:	e6250513          	addi	a0,a0,-414 # ffffffffc0202240 <etext+0x16e>
ffffffffc02003e6:	6109                	addi	sp,sp,128
ffffffffc02003e8:	b395                	j	ffffffffc020014c <cprintf>
ffffffffc02003ea:	8556                	mv	a0,s5
ffffffffc02003ec:	45b010ef          	jal	ra,ffffffffc0202046 <strlen>
ffffffffc02003f0:	8a2a                	mv	s4,a0
ffffffffc02003f2:	4619                	li	a2,6
ffffffffc02003f4:	85a6                	mv	a1,s1
ffffffffc02003f6:	8556                	mv	a0,s5
ffffffffc02003f8:	2a01                	sext.w	s4,s4
ffffffffc02003fa:	4a1010ef          	jal	ra,ffffffffc020209a <strncmp>
ffffffffc02003fe:	e111                	bnez	a0,ffffffffc0200402 <dtb_init+0x1e2>
ffffffffc0200400:	4c85                	li	s9,1
ffffffffc0200402:	0a91                	addi	s5,s5,4
ffffffffc0200404:	9ad2                	add	s5,s5,s4
ffffffffc0200406:	ffcafa93          	andi	s5,s5,-4
ffffffffc020040a:	8a56                	mv	s4,s5
ffffffffc020040c:	bf2d                	j	ffffffffc0200346 <dtb_init+0x126>
ffffffffc020040e:	004a2783          	lw	a5,4(s4)
ffffffffc0200412:	00ca0693          	addi	a3,s4,12
ffffffffc0200416:	0087d71b          	srliw	a4,a5,0x8
ffffffffc020041a:	01879a9b          	slliw	s5,a5,0x18
ffffffffc020041e:	0187d61b          	srliw	a2,a5,0x18
ffffffffc0200422:	0107171b          	slliw	a4,a4,0x10
ffffffffc0200426:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020042a:	00caeab3          	or	s5,s5,a2
ffffffffc020042e:	01877733          	and	a4,a4,s8
ffffffffc0200432:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200436:	00eaeab3          	or	s5,s5,a4
ffffffffc020043a:	00fb77b3          	and	a5,s6,a5
ffffffffc020043e:	00faeab3          	or	s5,s5,a5
ffffffffc0200442:	2a81                	sext.w	s5,s5
ffffffffc0200444:	000c9c63          	bnez	s9,ffffffffc020045c <dtb_init+0x23c>
ffffffffc0200448:	1a82                	slli	s5,s5,0x20
ffffffffc020044a:	00368793          	addi	a5,a3,3
ffffffffc020044e:	020ada93          	srli	s5,s5,0x20
ffffffffc0200452:	9abe                	add	s5,s5,a5
ffffffffc0200454:	ffcafa93          	andi	s5,s5,-4
ffffffffc0200458:	8a56                	mv	s4,s5
ffffffffc020045a:	b5f5                	j	ffffffffc0200346 <dtb_init+0x126>
ffffffffc020045c:	008a2783          	lw	a5,8(s4)
ffffffffc0200460:	85ca                	mv	a1,s2
ffffffffc0200462:	e436                	sd	a3,8(sp)
ffffffffc0200464:	0087d51b          	srliw	a0,a5,0x8
ffffffffc0200468:	0187d61b          	srliw	a2,a5,0x18
ffffffffc020046c:	0187971b          	slliw	a4,a5,0x18
ffffffffc0200470:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200474:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200478:	8f51                	or	a4,a4,a2
ffffffffc020047a:	01857533          	and	a0,a0,s8
ffffffffc020047e:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200482:	8d59                	or	a0,a0,a4
ffffffffc0200484:	00fb77b3          	and	a5,s6,a5
ffffffffc0200488:	8d5d                	or	a0,a0,a5
ffffffffc020048a:	1502                	slli	a0,a0,0x20
ffffffffc020048c:	9101                	srli	a0,a0,0x20
ffffffffc020048e:	9522                	add	a0,a0,s0
ffffffffc0200490:	3ed010ef          	jal	ra,ffffffffc020207c <strcmp>
ffffffffc0200494:	66a2                	ld	a3,8(sp)
ffffffffc0200496:	f94d                	bnez	a0,ffffffffc0200448 <dtb_init+0x228>
ffffffffc0200498:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200448 <dtb_init+0x228>
ffffffffc020049c:	00ca3783          	ld	a5,12(s4)
ffffffffc02004a0:	014a3703          	ld	a4,20(s4)
ffffffffc02004a4:	00002517          	auipc	a0,0x2
ffffffffc02004a8:	dd450513          	addi	a0,a0,-556 # ffffffffc0202278 <etext+0x1a6>
ffffffffc02004ac:	4207d613          	srai	a2,a5,0x20
ffffffffc02004b0:	0087d31b          	srliw	t1,a5,0x8
ffffffffc02004b4:	42075593          	srai	a1,a4,0x20
ffffffffc02004b8:	0187de1b          	srliw	t3,a5,0x18
ffffffffc02004bc:	0186581b          	srliw	a6,a2,0x18
ffffffffc02004c0:	0187941b          	slliw	s0,a5,0x18
ffffffffc02004c4:	0107d89b          	srliw	a7,a5,0x10
ffffffffc02004c8:	0187d693          	srli	a3,a5,0x18
ffffffffc02004cc:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02004d0:	0087579b          	srliw	a5,a4,0x8
ffffffffc02004d4:	0103131b          	slliw	t1,t1,0x10
ffffffffc02004d8:	0106561b          	srliw	a2,a2,0x10
ffffffffc02004dc:	010f6f33          	or	t5,t5,a6
ffffffffc02004e0:	0187529b          	srliw	t0,a4,0x18
ffffffffc02004e4:	0185df9b          	srliw	t6,a1,0x18
ffffffffc02004e8:	01837333          	and	t1,t1,s8
ffffffffc02004ec:	01c46433          	or	s0,s0,t3
ffffffffc02004f0:	0186f6b3          	and	a3,a3,s8
ffffffffc02004f4:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02004f8:	01871e9b          	slliw	t4,a4,0x18
ffffffffc02004fc:	0107581b          	srliw	a6,a4,0x10
ffffffffc0200500:	0086161b          	slliw	a2,a2,0x8
ffffffffc0200504:	8361                	srli	a4,a4,0x18
ffffffffc0200506:	0107979b          	slliw	a5,a5,0x10
ffffffffc020050a:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020050e:	01e6e6b3          	or	a3,a3,t5
ffffffffc0200512:	00cb7633          	and	a2,s6,a2
ffffffffc0200516:	0088181b          	slliw	a6,a6,0x8
ffffffffc020051a:	0085959b          	slliw	a1,a1,0x8
ffffffffc020051e:	00646433          	or	s0,s0,t1
ffffffffc0200522:	0187f7b3          	and	a5,a5,s8
ffffffffc0200526:	01fe6333          	or	t1,t3,t6
ffffffffc020052a:	01877c33          	and	s8,a4,s8
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
ffffffffc0200558:	1702                	slli	a4,a4,0x20
ffffffffc020055a:	1b02                	slli	s6,s6,0x20
ffffffffc020055c:	1782                	slli	a5,a5,0x20
ffffffffc020055e:	9301                	srli	a4,a4,0x20
ffffffffc0200560:	1402                	slli	s0,s0,0x20
ffffffffc0200562:	020b5b13          	srli	s6,s6,0x20
ffffffffc0200566:	0167eb33          	or	s6,a5,s6
ffffffffc020056a:	8c59                	or	s0,s0,a4
ffffffffc020056c:	be1ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200570:	85a2                	mv	a1,s0
ffffffffc0200572:	00002517          	auipc	a0,0x2
ffffffffc0200576:	d2650513          	addi	a0,a0,-730 # ffffffffc0202298 <etext+0x1c6>
ffffffffc020057a:	bd3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc020057e:	014b5613          	srli	a2,s6,0x14
ffffffffc0200582:	85da                	mv	a1,s6
ffffffffc0200584:	00002517          	auipc	a0,0x2
ffffffffc0200588:	d2c50513          	addi	a0,a0,-724 # ffffffffc02022b0 <etext+0x1de>
ffffffffc020058c:	bc1ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200590:	008b05b3          	add	a1,s6,s0
ffffffffc0200594:	15fd                	addi	a1,a1,-1
ffffffffc0200596:	00002517          	auipc	a0,0x2
ffffffffc020059a:	d3a50513          	addi	a0,a0,-710 # ffffffffc02022d0 <etext+0x1fe>
ffffffffc020059e:	bafff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc02005a2:	00002517          	auipc	a0,0x2
ffffffffc02005a6:	d7e50513          	addi	a0,a0,-642 # ffffffffc0202320 <etext+0x24e>
ffffffffc02005aa:	00027797          	auipc	a5,0x27
ffffffffc02005ae:	aa87bf23          	sd	s0,-1346(a5) # ffffffffc0227068 <memory_base>
ffffffffc02005b2:	00027797          	auipc	a5,0x27
ffffffffc02005b6:	ab67bf23          	sd	s6,-1346(a5) # ffffffffc0227070 <memory_size>
ffffffffc02005ba:	b3f5                	j	ffffffffc02003a6 <dtb_init+0x186>

ffffffffc02005bc <get_memory_base>:
ffffffffc02005bc:	00027517          	auipc	a0,0x27
ffffffffc02005c0:	aac53503          	ld	a0,-1364(a0) # ffffffffc0227068 <memory_base>
ffffffffc02005c4:	8082                	ret

ffffffffc02005c6 <get_memory_size>:
ffffffffc02005c6:	00027517          	auipc	a0,0x27
ffffffffc02005ca:	aaa53503          	ld	a0,-1366(a0) # ffffffffc0227070 <memory_size>
ffffffffc02005ce:	8082                	ret

ffffffffc02005d0 <buddy_nr_free_pages>:
ffffffffc02005d0:	00027517          	auipc	a0,0x27
ffffffffc02005d4:	a5853503          	ld	a0,-1448(a0) # ffffffffc0227028 <buddy_mgr+0x20010>
ffffffffc02005d8:	8082                	ret

ffffffffc02005da <buddy_free_pages>:
ffffffffc02005da:	7139                	addi	sp,sp,-64
ffffffffc02005dc:	fc06                	sd	ra,56(sp)
ffffffffc02005de:	f822                	sd	s0,48(sp)
ffffffffc02005e0:	f426                	sd	s1,40(sp)
ffffffffc02005e2:	f04a                	sd	s2,32(sp)
ffffffffc02005e4:	ec4e                	sd	s3,24(sp)
ffffffffc02005e6:	e852                	sd	s4,16(sp)
ffffffffc02005e8:	e456                	sd	s5,8(sp)
ffffffffc02005ea:	18050e63          	beqz	a0,ffffffffc0200786 <buddy_free_pages+0x1ac>
ffffffffc02005ee:	18058c63          	beqz	a1,ffffffffc0200786 <buddy_free_pages+0x1ac>
ffffffffc02005f2:	00007497          	auipc	s1,0x7
ffffffffc02005f6:	a2648493          	addi	s1,s1,-1498 # ffffffffc0207018 <buddy_mgr>
ffffffffc02005fa:	409c                	lw	a5,0(s1)
ffffffffc02005fc:	18078563          	beqz	a5,ffffffffc0200786 <buddy_free_pages+0x1ac>
ffffffffc0200600:	01052a03          	lw	s4,16(a0)
ffffffffc0200604:	842a                	mv	s0,a0
ffffffffc0200606:	fffa079b          	addiw	a5,s4,-1
ffffffffc020060a:	00fa77b3          	and	a5,s4,a5
ffffffffc020060e:	2781                	sext.w	a5,a5
ffffffffc0200610:	14079b63          	bnez	a5,ffffffffc0200766 <buddy_free_pages+0x18c>
ffffffffc0200614:	00027997          	auipc	s3,0x27
ffffffffc0200618:	a0498993          	addi	s3,s3,-1532 # ffffffffc0227018 <buddy_mgr+0x20000>
ffffffffc020061c:	0089b783          	ld	a5,8(s3)
ffffffffc0200620:	00003a97          	auipc	s5,0x3
ffffffffc0200624:	340aba83          	ld	s5,832(s5) # ffffffffc0203960 <error_string+0x38>
ffffffffc0200628:	020a1913          	slli	s2,s4,0x20
ffffffffc020062c:	40f507b3          	sub	a5,a0,a5
ffffffffc0200630:	878d                	srai	a5,a5,0x3
ffffffffc0200632:	035787b3          	mul	a5,a5,s5
ffffffffc0200636:	02095913          	srli	s2,s2,0x20
ffffffffc020063a:	0327f7b3          	remu	a5,a5,s2
ffffffffc020063e:	1a079263          	bnez	a5,ffffffffc02007e2 <buddy_free_pages+0x208>
ffffffffc0200642:	10b91963          	bne	s2,a1,ffffffffc0200754 <buddy_free_pages+0x17a>
ffffffffc0200646:	00027597          	auipc	a1,0x27
ffffffffc020064a:	a3a5b583          	ld	a1,-1478(a1) # ffffffffc0227080 <pages>
ffffffffc020064e:	40b405b3          	sub	a1,s0,a1
ffffffffc0200652:	858d                	srai	a1,a1,0x3
ffffffffc0200654:	035585b3          	mul	a1,a1,s5
ffffffffc0200658:	00003797          	auipc	a5,0x3
ffffffffc020065c:	3107b783          	ld	a5,784(a5) # ffffffffc0203968 <nbase>
ffffffffc0200660:	0009b683          	ld	a3,0(s3)
ffffffffc0200664:	95be                	add	a1,a1,a5
ffffffffc0200666:	05b2                	slli	a1,a1,0xc
ffffffffc0200668:	18d5ed63          	bltu	a1,a3,ffffffffc0200802 <buddy_free_pages+0x228>
ffffffffc020066c:	8d95                	sub	a1,a1,a3
ffffffffc020066e:	81b1                	srli	a1,a1,0xc
ffffffffc0200670:	2581                	sext.w	a1,a1
ffffffffc0200672:	1405ca63          	bltz	a1,ffffffffc02007c6 <buddy_free_pages+0x1ec>
ffffffffc0200676:	409c                	lw	a5,0(s1)
ffffffffc0200678:	0145873b          	addw	a4,a1,s4
ffffffffc020067c:	14e7e563          	bltu	a5,a4,ffffffffc02007c6 <buddy_free_pages+0x1ec>
ffffffffc0200680:	02090063          	beqz	s2,ffffffffc02006a0 <buddy_free_pages+0xc6>
ffffffffc0200684:	00291713          	slli	a4,s2,0x2
ffffffffc0200688:	974a                	add	a4,a4,s2
ffffffffc020068a:	070e                	slli	a4,a4,0x3
ffffffffc020068c:	8522                	mv	a0,s0
ffffffffc020068e:	9722                	add	a4,a4,s0
ffffffffc0200690:	00052023          	sw	zero,0(a0)
ffffffffc0200694:	00052823          	sw	zero,16(a0)
ffffffffc0200698:	02850513          	addi	a0,a0,40
ffffffffc020069c:	fee51ae3          	bne	a0,a4,ffffffffc0200690 <buddy_free_pages+0xb6>
ffffffffc02006a0:	10f5f363          	bgeu	a1,a5,ffffffffc02007a6 <buddy_free_pages+0x1cc>
ffffffffc02006a4:	fff7869b          	addiw	a3,a5,-1
ffffffffc02006a8:	9ead                	addw	a3,a3,a1
ffffffffc02006aa:	02069713          	slli	a4,a3,0x20
ffffffffc02006ae:	01e75793          	srli	a5,a4,0x1e
ffffffffc02006b2:	97a6                	add	a5,a5,s1
ffffffffc02006b4:	43dc                	lw	a5,4(a5)
ffffffffc02006b6:	c7f1                	beqz	a5,ffffffffc0200782 <buddy_free_pages+0x1a8>
ffffffffc02006b8:	c2c1                	beqz	a3,ffffffffc0200738 <buddy_free_pages+0x15e>
ffffffffc02006ba:	4789                	li	a5,2
ffffffffc02006bc:	a021                	j	ffffffffc02006c4 <buddy_free_pages+0xea>
ffffffffc02006be:	0017979b          	slliw	a5,a5,0x1
ffffffffc02006c2:	cabd                	beqz	a3,ffffffffc0200738 <buddy_free_pages+0x15e>
ffffffffc02006c4:	2685                	addiw	a3,a3,1
ffffffffc02006c6:	0016d69b          	srliw	a3,a3,0x1
ffffffffc02006ca:	36fd                	addiw	a3,a3,-1
ffffffffc02006cc:	02069613          	slli	a2,a3,0x20
ffffffffc02006d0:	01e65713          	srli	a4,a2,0x1e
ffffffffc02006d4:	9726                	add	a4,a4,s1
ffffffffc02006d6:	4358                	lw	a4,4(a4)
ffffffffc02006d8:	f37d                	bnez	a4,ffffffffc02006be <buddy_free_pages+0xe4>
ffffffffc02006da:	02069613          	slli	a2,a3,0x20
ffffffffc02006de:	01e65713          	srli	a4,a2,0x1e
ffffffffc02006e2:	9726                	add	a4,a4,s1
ffffffffc02006e4:	c35c                	sw	a5,4(a4)
ffffffffc02006e6:	caa9                	beqz	a3,ffffffffc0200738 <buddy_free_pages+0x15e>
ffffffffc02006e8:	2685                	addiw	a3,a3,1
ffffffffc02006ea:	0016d71b          	srliw	a4,a3,0x1
ffffffffc02006ee:	377d                	addiw	a4,a4,-1
ffffffffc02006f0:	0017161b          	slliw	a2,a4,0x1
ffffffffc02006f4:	9af9                	andi	a3,a3,-2
ffffffffc02006f6:	2605                	addiw	a2,a2,1
ffffffffc02006f8:	1682                	slli	a3,a3,0x20
ffffffffc02006fa:	02061593          	slli	a1,a2,0x20
ffffffffc02006fe:	9281                	srli	a3,a3,0x20
ffffffffc0200700:	01e5d613          	srli	a2,a1,0x1e
ffffffffc0200704:	068a                	slli	a3,a3,0x2
ffffffffc0200706:	9626                	add	a2,a2,s1
ffffffffc0200708:	96a6                	add	a3,a3,s1
ffffffffc020070a:	42c8                	lw	a0,4(a3)
ffffffffc020070c:	424c                	lw	a1,4(a2)
ffffffffc020070e:	0017979b          	slliw	a5,a5,0x1
ffffffffc0200712:	0007069b          	sext.w	a3,a4
ffffffffc0200716:	00a5863b          	addw	a2,a1,a0
ffffffffc020071a:	00c78863          	beq	a5,a2,ffffffffc020072a <buddy_free_pages+0x150>
ffffffffc020071e:	0005861b          	sext.w	a2,a1
ffffffffc0200722:	00a5f463          	bgeu	a1,a0,ffffffffc020072a <buddy_free_pages+0x150>
ffffffffc0200726:	0005061b          	sext.w	a2,a0
ffffffffc020072a:	02071593          	slli	a1,a4,0x20
ffffffffc020072e:	01e5d713          	srli	a4,a1,0x1e
ffffffffc0200732:	9726                	add	a4,a4,s1
ffffffffc0200734:	c350                	sw	a2,4(a4)
ffffffffc0200736:	facd                	bnez	a3,ffffffffc02006e8 <buddy_free_pages+0x10e>
ffffffffc0200738:	0109b783          	ld	a5,16(s3)
ffffffffc020073c:	70e2                	ld	ra,56(sp)
ffffffffc020073e:	7442                	ld	s0,48(sp)
ffffffffc0200740:	993e                	add	s2,s2,a5
ffffffffc0200742:	0129b823          	sd	s2,16(s3)
ffffffffc0200746:	74a2                	ld	s1,40(sp)
ffffffffc0200748:	7902                	ld	s2,32(sp)
ffffffffc020074a:	69e2                	ld	s3,24(sp)
ffffffffc020074c:	6a42                	ld	s4,16(sp)
ffffffffc020074e:	6aa2                	ld	s5,8(sp)
ffffffffc0200750:	6121                	addi	sp,sp,64
ffffffffc0200752:	8082                	ret
ffffffffc0200754:	86d2                	mv	a3,s4
ffffffffc0200756:	8652                	mv	a2,s4
ffffffffc0200758:	00002517          	auipc	a0,0x2
ffffffffc020075c:	ca850513          	addi	a0,a0,-856 # ffffffffc0202400 <etext+0x32e>
ffffffffc0200760:	9edff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200764:	b5cd                	j	ffffffffc0200646 <buddy_free_pages+0x6c>
ffffffffc0200766:	7442                	ld	s0,48(sp)
ffffffffc0200768:	70e2                	ld	ra,56(sp)
ffffffffc020076a:	74a2                	ld	s1,40(sp)
ffffffffc020076c:	7902                	ld	s2,32(sp)
ffffffffc020076e:	69e2                	ld	s3,24(sp)
ffffffffc0200770:	6aa2                	ld	s5,8(sp)
ffffffffc0200772:	85d2                	mv	a1,s4
ffffffffc0200774:	6a42                	ld	s4,16(sp)
ffffffffc0200776:	00002517          	auipc	a0,0x2
ffffffffc020077a:	c1a50513          	addi	a0,a0,-998 # ffffffffc0202390 <etext+0x2be>
ffffffffc020077e:	6121                	addi	sp,sp,64
ffffffffc0200780:	b2f1                	j	ffffffffc020014c <cprintf>
ffffffffc0200782:	4785                	li	a5,1
ffffffffc0200784:	bf99                	j	ffffffffc02006da <buddy_free_pages+0x100>
ffffffffc0200786:	00002697          	auipc	a3,0x2
ffffffffc020078a:	bb268693          	addi	a3,a3,-1102 # ffffffffc0202338 <etext+0x266>
ffffffffc020078e:	00002617          	auipc	a2,0x2
ffffffffc0200792:	bd260613          	addi	a2,a2,-1070 # ffffffffc0202360 <etext+0x28e>
ffffffffc0200796:	14c00593          	li	a1,332
ffffffffc020079a:	00002517          	auipc	a0,0x2
ffffffffc020079e:	bde50513          	addi	a0,a0,-1058 # ffffffffc0202378 <etext+0x2a6>
ffffffffc02007a2:	a21ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc02007a6:	00002697          	auipc	a3,0x2
ffffffffc02007aa:	d4268693          	addi	a3,a3,-702 # ffffffffc02024e8 <etext+0x416>
ffffffffc02007ae:	00002617          	auipc	a2,0x2
ffffffffc02007b2:	bb260613          	addi	a2,a2,-1102 # ffffffffc0202360 <etext+0x28e>
ffffffffc02007b6:	0d500593          	li	a1,213
ffffffffc02007ba:	00002517          	auipc	a0,0x2
ffffffffc02007be:	bbe50513          	addi	a0,a0,-1090 # ffffffffc0202378 <etext+0x2a6>
ffffffffc02007c2:	a01ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc02007c6:	86ae                	mv	a3,a1
ffffffffc02007c8:	8752                	mv	a4,s4
ffffffffc02007ca:	00002617          	auipc	a2,0x2
ffffffffc02007ce:	cde60613          	addi	a2,a2,-802 # ffffffffc02024a8 <etext+0x3d6>
ffffffffc02007d2:	16800593          	li	a1,360
ffffffffc02007d6:	00002517          	auipc	a0,0x2
ffffffffc02007da:	ba250513          	addi	a0,a0,-1118 # ffffffffc0202378 <etext+0x2a6>
ffffffffc02007de:	9e5ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc02007e2:	00002697          	auipc	a3,0x2
ffffffffc02007e6:	bde68693          	addi	a3,a3,-1058 # ffffffffc02023c0 <etext+0x2ee>
ffffffffc02007ea:	00002617          	auipc	a2,0x2
ffffffffc02007ee:	b7660613          	addi	a2,a2,-1162 # ffffffffc0202360 <etext+0x28e>
ffffffffc02007f2:	15700593          	li	a1,343
ffffffffc02007f6:	00002517          	auipc	a0,0x2
ffffffffc02007fa:	b8250513          	addi	a0,a0,-1150 # ffffffffc0202378 <etext+0x2a6>
ffffffffc02007fe:	9c5ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc0200802:	86ae                	mv	a3,a1
ffffffffc0200804:	00002617          	auipc	a2,0x2
ffffffffc0200808:	c5460613          	addi	a2,a2,-940 # ffffffffc0202458 <etext+0x386>
ffffffffc020080c:	16200593          	li	a1,354
ffffffffc0200810:	00002517          	auipc	a0,0x2
ffffffffc0200814:	b6850513          	addi	a0,a0,-1176 # ffffffffc0202378 <etext+0x2a6>
ffffffffc0200818:	9abff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc020081c <buddy_init>:
ffffffffc020081c:	00020637          	lui	a2,0x20
ffffffffc0200820:	1141                	addi	sp,sp,-16
ffffffffc0200822:	0661                	addi	a2,a2,24
ffffffffc0200824:	4581                	li	a1,0
ffffffffc0200826:	00006517          	auipc	a0,0x6
ffffffffc020082a:	7f250513          	addi	a0,a0,2034 # ffffffffc0207018 <buddy_mgr>
ffffffffc020082e:	e406                	sd	ra,8(sp)
ffffffffc0200830:	091010ef          	jal	ra,ffffffffc02020c0 <memset>
ffffffffc0200834:	60a2                	ld	ra,8(sp)
ffffffffc0200836:	00002517          	auipc	a0,0x2
ffffffffc020083a:	cfa50513          	addi	a0,a0,-774 # ffffffffc0202530 <etext+0x45e>
ffffffffc020083e:	0141                	addi	sp,sp,16
ffffffffc0200840:	b231                	j	ffffffffc020014c <cprintf>

ffffffffc0200842 <buddy_init_memmap>:
ffffffffc0200842:	1101                	addi	sp,sp,-32
ffffffffc0200844:	ec06                	sd	ra,24(sp)
ffffffffc0200846:	e822                	sd	s0,16(sp)
ffffffffc0200848:	e426                	sd	s1,8(sp)
ffffffffc020084a:	e04a                	sd	s2,0(sp)
ffffffffc020084c:	c5e9                	beqz	a1,ffffffffc0200916 <buddy_init_memmap+0xd4>
ffffffffc020084e:	892a                	mv	s2,a0
ffffffffc0200850:	473d                	li	a4,15
ffffffffc0200852:	4785                	li	a5,1
ffffffffc0200854:	843e                	mv	s0,a5
ffffffffc0200856:	0786                	slli	a5,a5,0x1
ffffffffc0200858:	00f5e463          	bltu	a1,a5,ffffffffc0200860 <buddy_init_memmap+0x1e>
ffffffffc020085c:	377d                	addiw	a4,a4,-1
ffffffffc020085e:	fb7d                	bnez	a4,ffffffffc0200854 <buddy_init_memmap+0x12>
ffffffffc0200860:	00027497          	auipc	s1,0x27
ffffffffc0200864:	8204b483          	ld	s1,-2016(s1) # ffffffffc0227080 <pages>
ffffffffc0200868:	409904b3          	sub	s1,s2,s1
ffffffffc020086c:	00003617          	auipc	a2,0x3
ffffffffc0200870:	0f463603          	ld	a2,244(a2) # ffffffffc0203960 <error_string+0x38>
ffffffffc0200874:	848d                	srai	s1,s1,0x3
ffffffffc0200876:	02c484b3          	mul	s1,s1,a2
ffffffffc020087a:	00003617          	auipc	a2,0x3
ffffffffc020087e:	0ee63603          	ld	a2,238(a2) # ffffffffc0203968 <nbase>
ffffffffc0200882:	00c41593          	slli	a1,s0,0xc
ffffffffc0200886:	00002517          	auipc	a0,0x2
ffffffffc020088a:	d1250513          	addi	a0,a0,-750 # ffffffffc0202598 <etext+0x4c6>
ffffffffc020088e:	94b2                	add	s1,s1,a2
ffffffffc0200890:	04b2                	slli	s1,s1,0xc
ffffffffc0200892:	fff48693          	addi	a3,s1,-1
ffffffffc0200896:	96ae                	add	a3,a3,a1
ffffffffc0200898:	8626                	mv	a2,s1
ffffffffc020089a:	8b3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc020089e:	00241713          	slli	a4,s0,0x2
ffffffffc02008a2:	9722                	add	a4,a4,s0
ffffffffc02008a4:	070e                	slli	a4,a4,0x3
ffffffffc02008a6:	87ca                	mv	a5,s2
ffffffffc02008a8:	974a                	add	a4,a4,s2
ffffffffc02008aa:	0007a023          	sw	zero,0(a5)
ffffffffc02008ae:	0007b423          	sd	zero,8(a5)
ffffffffc02008b2:	02878793          	addi	a5,a5,40
ffffffffc02008b6:	fee79ae3          	bne	a5,a4,ffffffffc02008aa <buddy_init_memmap+0x68>
ffffffffc02008ba:	0014181b          	slliw	a6,s0,0x1
ffffffffc02008be:	00006797          	auipc	a5,0x6
ffffffffc02008c2:	7487ad23          	sw	s0,1882(a5) # ffffffffc0207018 <buddy_mgr>
ffffffffc02008c6:	0004059b          	sext.w	a1,s0
ffffffffc02008ca:	00006697          	auipc	a3,0x6
ffffffffc02008ce:	75268693          	addi	a3,a3,1874 # ffffffffc020701c <buddy_mgr+0x4>
ffffffffc02008d2:	fff8089b          	addiw	a7,a6,-1
ffffffffc02008d6:	4781                	li	a5,0
ffffffffc02008d8:	873e                	mv	a4,a5
ffffffffc02008da:	2785                	addiw	a5,a5,1
ffffffffc02008dc:	8f7d                	and	a4,a4,a5
ffffffffc02008de:	e319                	bnez	a4,ffffffffc02008e4 <buddy_init_memmap+0xa2>
ffffffffc02008e0:	0018581b          	srliw	a6,a6,0x1
ffffffffc02008e4:	0106a023          	sw	a6,0(a3)
ffffffffc02008e8:	0691                	addi	a3,a3,4
ffffffffc02008ea:	ff1797e3          	bne	a5,a7,ffffffffc02008d8 <buddy_init_memmap+0x96>
ffffffffc02008ee:	00026797          	auipc	a5,0x26
ffffffffc02008f2:	72a78793          	addi	a5,a5,1834 # ffffffffc0227018 <buddy_mgr+0x20000>
ffffffffc02008f6:	eb80                	sd	s0,16(a5)
ffffffffc02008f8:	6442                	ld	s0,16(sp)
ffffffffc02008fa:	60e2                	ld	ra,24(sp)
ffffffffc02008fc:	e384                	sd	s1,0(a5)
ffffffffc02008fe:	0127b423          	sd	s2,8(a5)
ffffffffc0200902:	8626                	mv	a2,s1
ffffffffc0200904:	6902                	ld	s2,0(sp)
ffffffffc0200906:	64a2                	ld	s1,8(sp)
ffffffffc0200908:	00002517          	auipc	a0,0x2
ffffffffc020090c:	c5050513          	addi	a0,a0,-944 # ffffffffc0202558 <etext+0x486>
ffffffffc0200910:	6105                	addi	sp,sp,32
ffffffffc0200912:	83bff06f          	j	ffffffffc020014c <cprintf>
ffffffffc0200916:	00002697          	auipc	a3,0x2
ffffffffc020091a:	c3a68693          	addi	a3,a3,-966 # ffffffffc0202550 <etext+0x47e>
ffffffffc020091e:	00002617          	auipc	a2,0x2
ffffffffc0200922:	a4260613          	addi	a2,a2,-1470 # ffffffffc0202360 <etext+0x28e>
ffffffffc0200926:	10300593          	li	a1,259
ffffffffc020092a:	00002517          	auipc	a0,0x2
ffffffffc020092e:	a4e50513          	addi	a0,a0,-1458 # ffffffffc0202378 <etext+0x2a6>
ffffffffc0200932:	891ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200936 <buddy_alloc_pages>:
ffffffffc0200936:	18050063          	beqz	a0,ffffffffc0200ab6 <buddy_alloc_pages+0x180>
ffffffffc020093a:	00006617          	auipc	a2,0x6
ffffffffc020093e:	6de60613          	addi	a2,a2,1758 # ffffffffc0207018 <buddy_mgr>
ffffffffc0200942:	00062803          	lw	a6,0(a2)
ffffffffc0200946:	16080863          	beqz	a6,ffffffffc0200ab6 <buddy_alloc_pages+0x180>
ffffffffc020094a:	2501                	sext.w	a0,a0
ffffffffc020094c:	16050263          	beqz	a0,ffffffffc0200ab0 <buddy_alloc_pages+0x17a>
ffffffffc0200950:	357d                	addiw	a0,a0,-1
ffffffffc0200952:	0015579b          	srliw	a5,a0,0x1
ffffffffc0200956:	8fc9                	or	a5,a5,a0
ffffffffc0200958:	0027d51b          	srliw	a0,a5,0x2
ffffffffc020095c:	8fc9                	or	a5,a5,a0
ffffffffc020095e:	0047d71b          	srliw	a4,a5,0x4
ffffffffc0200962:	8fd9                	or	a5,a5,a4
ffffffffc0200964:	0087d71b          	srliw	a4,a5,0x8
ffffffffc0200968:	8fd9                	or	a5,a5,a4
ffffffffc020096a:	0107d71b          	srliw	a4,a5,0x10
ffffffffc020096e:	8fd9                	or	a5,a5,a4
ffffffffc0200970:	0017871b          	addiw	a4,a5,1
ffffffffc0200974:	0007059b          	sext.w	a1,a4
ffffffffc0200978:	2781                	sext.w	a5,a5
ffffffffc020097a:	12b86e63          	bltu	a6,a1,ffffffffc0200ab6 <buddy_alloc_pages+0x180>
ffffffffc020097e:	4685                	li	a3,1
ffffffffc0200980:	12059d63          	bnez	a1,ffffffffc0200aba <buddy_alloc_pages+0x184>
ffffffffc0200984:	425c                	lw	a5,4(a2)
ffffffffc0200986:	1141                	addi	sp,sp,-16
ffffffffc0200988:	e406                	sd	ra,8(sp)
ffffffffc020098a:	14d7ed63          	bltu	a5,a3,ffffffffc0200ae4 <buddy_alloc_pages+0x1ae>
ffffffffc020098e:	16d80363          	beq	a6,a3,ffffffffc0200af4 <buddy_alloc_pages+0x1be>
ffffffffc0200992:	8542                	mv	a0,a6
ffffffffc0200994:	4781                	li	a5,0
ffffffffc0200996:	0017989b          	slliw	a7,a5,0x1
ffffffffc020099a:	0018879b          	addiw	a5,a7,1
ffffffffc020099e:	02079313          	slli	t1,a5,0x20
ffffffffc02009a2:	01e35713          	srli	a4,t1,0x1e
ffffffffc02009a6:	9732                	add	a4,a4,a2
ffffffffc02009a8:	4358                	lw	a4,4(a4)
ffffffffc02009aa:	00d77463          	bgeu	a4,a3,ffffffffc02009b2 <buddy_alloc_pages+0x7c>
ffffffffc02009ae:	0028879b          	addiw	a5,a7,2
ffffffffc02009b2:	0015551b          	srliw	a0,a0,0x1
ffffffffc02009b6:	fea690e3          	bne	a3,a0,ffffffffc0200996 <buddy_alloc_pages+0x60>
ffffffffc02009ba:	0017871b          	addiw	a4,a5,1
ffffffffc02009be:	02d706bb          	mulw	a3,a4,a3
ffffffffc02009c2:	02079893          	slli	a7,a5,0x20
ffffffffc02009c6:	01e8d513          	srli	a0,a7,0x1e
ffffffffc02009ca:	9532                	add	a0,a0,a2
ffffffffc02009cc:	00052223          	sw	zero,4(a0)
ffffffffc02009d0:	4106853b          	subw	a0,a3,a6
ffffffffc02009d4:	e781                	bnez	a5,ffffffffc02009dc <buddy_alloc_pages+0xa6>
ffffffffc02009d6:	a0a1                	j	ffffffffc0200a1e <buddy_alloc_pages+0xe8>
ffffffffc02009d8:	0017871b          	addiw	a4,a5,1
ffffffffc02009dc:	0017579b          	srliw	a5,a4,0x1
ffffffffc02009e0:	37fd                	addiw	a5,a5,-1
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
ffffffffc0200a1c:	ffd5                	bnez	a5,ffffffffc02009d8 <buddy_alloc_pages+0xa2>
ffffffffc0200a1e:	0005079b          	sext.w	a5,a0
ffffffffc0200a22:	0c07c163          	bltz	a5,ffffffffc0200ae4 <buddy_alloc_pages+0x1ae>
ffffffffc0200a26:	00c5179b          	slliw	a5,a0,0xc
ffffffffc0200a2a:	00026617          	auipc	a2,0x26
ffffffffc0200a2e:	5ee60613          	addi	a2,a2,1518 # ffffffffc0227018 <buddy_mgr+0x20000>
ffffffffc0200a32:	6208                	ld	a0,0(a2)
ffffffffc0200a34:	00026717          	auipc	a4,0x26
ffffffffc0200a38:	64473703          	ld	a4,1604(a4) # ffffffffc0227078 <npage>
ffffffffc0200a3c:	97aa                	add	a5,a5,a0
ffffffffc0200a3e:	83b1                	srli	a5,a5,0xc
ffffffffc0200a40:	0ee7f263          	bgeu	a5,a4,ffffffffc0200b24 <buddy_alloc_pages+0x1ee>
ffffffffc0200a44:	00003717          	auipc	a4,0x3
ffffffffc0200a48:	f2473703          	ld	a4,-220(a4) # ffffffffc0203968 <nbase>
ffffffffc0200a4c:	8f99                	sub	a5,a5,a4
ffffffffc0200a4e:	00279513          	slli	a0,a5,0x2
ffffffffc0200a52:	97aa                	add	a5,a5,a0
ffffffffc0200a54:	6614                	ld	a3,8(a2)
ffffffffc0200a56:	078e                	slli	a5,a5,0x3
ffffffffc0200a58:	00026517          	auipc	a0,0x26
ffffffffc0200a5c:	62853503          	ld	a0,1576(a0) # ffffffffc0227080 <pages>
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
ffffffffc0200a8c:	87aa                	mv	a5,a0
ffffffffc0200a8e:	4685                	li	a3,1
ffffffffc0200a90:	00088863          	beqz	a7,ffffffffc0200aa0 <buddy_alloc_pages+0x16a>
ffffffffc0200a94:	c394                	sw	a3,0(a5)
ffffffffc0200a96:	cb8c                	sw	a1,16(a5)
ffffffffc0200a98:	02878793          	addi	a5,a5,40
ffffffffc0200a9c:	fee79ce3          	bne	a5,a4,ffffffffc0200a94 <buddy_alloc_pages+0x15e>
ffffffffc0200aa0:	6a1c                	ld	a5,16(a2)
ffffffffc0200aa2:	411788b3          	sub	a7,a5,a7
ffffffffc0200aa6:	01163823          	sd	a7,16(a2)
ffffffffc0200aaa:	60a2                	ld	ra,8(sp)
ffffffffc0200aac:	0141                	addi	sp,sp,16
ffffffffc0200aae:	8082                	ret
ffffffffc0200ab0:	4585                	li	a1,1
ffffffffc0200ab2:	4685                	li	a3,1
ffffffffc0200ab4:	bdc1                	j	ffffffffc0200984 <buddy_alloc_pages+0x4e>
ffffffffc0200ab6:	4501                	li	a0,0
ffffffffc0200ab8:	8082                	ret
ffffffffc0200aba:	8f7d                	and	a4,a4,a5
ffffffffc0200abc:	2701                	sext.w	a4,a4
ffffffffc0200abe:	c32d                	beqz	a4,ffffffffc0200b20 <buddy_alloc_pages+0x1ea>
ffffffffc0200ac0:	0017d71b          	srliw	a4,a5,0x1
ffffffffc0200ac4:	8fd9                	or	a5,a5,a4
ffffffffc0200ac6:	0027d71b          	srliw	a4,a5,0x2
ffffffffc0200aca:	8fd9                	or	a5,a5,a4
ffffffffc0200acc:	0047d71b          	srliw	a4,a5,0x4
ffffffffc0200ad0:	8fd9                	or	a5,a5,a4
ffffffffc0200ad2:	0087d71b          	srliw	a4,a5,0x8
ffffffffc0200ad6:	8fd9                	or	a5,a5,a4
ffffffffc0200ad8:	0107d71b          	srliw	a4,a5,0x10
ffffffffc0200adc:	8fd9                	or	a5,a5,a4
ffffffffc0200ade:	0017869b          	addiw	a3,a5,1
ffffffffc0200ae2:	b54d                	j	ffffffffc0200984 <buddy_alloc_pages+0x4e>
ffffffffc0200ae4:	00002517          	auipc	a0,0x2
ffffffffc0200ae8:	ae450513          	addi	a0,a0,-1308 # ffffffffc02025c8 <etext+0x4f6>
ffffffffc0200aec:	e60ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200af0:	4501                	li	a0,0
ffffffffc0200af2:	bf65                	j	ffffffffc0200aaa <buddy_alloc_pages+0x174>
ffffffffc0200af4:	00006797          	auipc	a5,0x6
ffffffffc0200af8:	5207a423          	sw	zero,1320(a5) # ffffffffc020701c <buddy_mgr+0x4>
ffffffffc0200afc:	4781                	li	a5,0
ffffffffc0200afe:	b735                	j	ffffffffc0200a2a <buddy_alloc_pages+0xf4>
ffffffffc0200b00:	00002697          	auipc	a3,0x2
ffffffffc0200b04:	b2868693          	addi	a3,a3,-1240 # ffffffffc0202628 <etext+0x556>
ffffffffc0200b08:	00002617          	auipc	a2,0x2
ffffffffc0200b0c:	85860613          	addi	a2,a2,-1960 # ffffffffc0202360 <etext+0x28e>
ffffffffc0200b10:	13c00593          	li	a1,316
ffffffffc0200b14:	00002517          	auipc	a0,0x2
ffffffffc0200b18:	86450513          	addi	a0,a0,-1948 # ffffffffc0202378 <etext+0x2a6>
ffffffffc0200b1c:	ea6ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc0200b20:	86ae                	mv	a3,a1
ffffffffc0200b22:	b58d                	j	ffffffffc0200984 <buddy_alloc_pages+0x4e>
ffffffffc0200b24:	00002617          	auipc	a2,0x2
ffffffffc0200b28:	ad460613          	addi	a2,a2,-1324 # ffffffffc02025f8 <etext+0x526>
ffffffffc0200b2c:	05800593          	li	a1,88
ffffffffc0200b30:	00002517          	auipc	a0,0x2
ffffffffc0200b34:	ae850513          	addi	a0,a0,-1304 # ffffffffc0202618 <etext+0x546>
ffffffffc0200b38:	e8aff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200b3c <buddy_check>:
ffffffffc0200b3c:	711d                	addi	sp,sp,-96
ffffffffc0200b3e:	e8a2                	sd	s0,80(sp)
ffffffffc0200b40:	00006417          	auipc	s0,0x6
ffffffffc0200b44:	4d840413          	addi	s0,s0,1240 # ffffffffc0207018 <buddy_mgr>
ffffffffc0200b48:	401c                	lw	a5,0(s0)
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
ffffffffc0200b5e:	00002517          	auipc	a0,0x2
ffffffffc0200b62:	b2250513          	addi	a0,a0,-1246 # ffffffffc0202680 <etext+0x5ae>
ffffffffc0200b66:	42078e63          	beqz	a5,ffffffffc0200fa2 <buddy_check+0x466>
ffffffffc0200b6a:	00002517          	auipc	a0,0x2
ffffffffc0200b6e:	b3650513          	addi	a0,a0,-1226 # ffffffffc02026a0 <etext+0x5ce>
ffffffffc0200b72:	ddaff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200b76:	00026497          	auipc	s1,0x26
ffffffffc0200b7a:	4a248493          	addi	s1,s1,1186 # ffffffffc0227018 <buddy_mgr+0x20000>
ffffffffc0200b7e:	6090                	ld	a2,0(s1)
ffffffffc0200b80:	400c                	lw	a1,0(s0)
ffffffffc0200b82:	00002517          	auipc	a0,0x2
ffffffffc0200b86:	b3650513          	addi	a0,a0,-1226 # ffffffffc02026b8 <etext+0x5e6>
ffffffffc0200b8a:	dc2ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200b8e:	00002517          	auipc	a0,0x2
ffffffffc0200b92:	b6250513          	addi	a0,a0,-1182 # ffffffffc02026f0 <etext+0x61e>
ffffffffc0200b96:	db6ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200b9a:	0104bb03          	ld	s6,16(s1)
ffffffffc0200b9e:	4054                	lw	a3,4(s0)
ffffffffc0200ba0:	00002597          	auipc	a1,0x2
ffffffffc0200ba4:	b9858593          	addi	a1,a1,-1128 # ffffffffc0202738 <etext+0x666>
ffffffffc0200ba8:	865a                	mv	a2,s6
ffffffffc0200baa:	00002517          	auipc	a0,0x2
ffffffffc0200bae:	b9e50513          	addi	a0,a0,-1122 # ffffffffc0202748 <etext+0x676>
ffffffffc0200bb2:	d9aff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200bb6:	4505                	li	a0,1
ffffffffc0200bb8:	d7fff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200bbc:	8c2a                	mv	s8,a0
ffffffffc0200bbe:	4a050763          	beqz	a0,ffffffffc020106c <buddy_check+0x530>
ffffffffc0200bc2:	00026a17          	auipc	s4,0x26
ffffffffc0200bc6:	4bea0a13          	addi	s4,s4,1214 # ffffffffc0227080 <pages>
ffffffffc0200bca:	000a3903          	ld	s2,0(s4)
ffffffffc0200bce:	00003997          	auipc	s3,0x3
ffffffffc0200bd2:	d929b983          	ld	s3,-622(s3) # ffffffffc0203960 <error_string+0x38>
ffffffffc0200bd6:	00003a97          	auipc	s5,0x3
ffffffffc0200bda:	d92aba83          	ld	s5,-622(s5) # ffffffffc0203968 <nbase>
ffffffffc0200bde:	41250933          	sub	s2,a0,s2
ffffffffc0200be2:	40395913          	srai	s2,s2,0x3
ffffffffc0200be6:	03390933          	mul	s2,s2,s3
ffffffffc0200bea:	00002517          	auipc	a0,0x2
ffffffffc0200bee:	bbe50513          	addi	a0,a0,-1090 # ffffffffc02027a8 <etext+0x6d6>
ffffffffc0200bf2:	9956                	add	s2,s2,s5
ffffffffc0200bf4:	0932                	slli	s2,s2,0xc
ffffffffc0200bf6:	85ca                	mv	a1,s2
ffffffffc0200bf8:	d54ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200bfc:	4054                	lw	a3,4(s0)
ffffffffc0200bfe:	6890                	ld	a2,16(s1)
ffffffffc0200c00:	00002597          	auipc	a1,0x2
ffffffffc0200c04:	bd058593          	addi	a1,a1,-1072 # ffffffffc02027d0 <etext+0x6fe>
ffffffffc0200c08:	00002517          	auipc	a0,0x2
ffffffffc0200c0c:	b4050513          	addi	a0,a0,-1216 # ffffffffc0202748 <etext+0x676>
ffffffffc0200c10:	d3cff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200c14:	450d                	li	a0,3
ffffffffc0200c16:	d21ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200c1a:	8caa                	mv	s9,a0
ffffffffc0200c1c:	42050863          	beqz	a0,ffffffffc020104c <buddy_check+0x510>
ffffffffc0200c20:	000a3b83          	ld	s7,0(s4)
ffffffffc0200c24:	00002517          	auipc	a0,0x2
ffffffffc0200c28:	be450513          	addi	a0,a0,-1052 # ffffffffc0202808 <etext+0x736>
ffffffffc0200c2c:	417c8bb3          	sub	s7,s9,s7
ffffffffc0200c30:	403bdb93          	srai	s7,s7,0x3
ffffffffc0200c34:	033b8bb3          	mul	s7,s7,s3
ffffffffc0200c38:	9bd6                	add	s7,s7,s5
ffffffffc0200c3a:	0bb2                	slli	s7,s7,0xc
ffffffffc0200c3c:	85de                	mv	a1,s7
ffffffffc0200c3e:	d0eff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200c42:	4054                	lw	a3,4(s0)
ffffffffc0200c44:	6890                	ld	a2,16(s1)
ffffffffc0200c46:	00002597          	auipc	a1,0x2
ffffffffc0200c4a:	bfa58593          	addi	a1,a1,-1030 # ffffffffc0202840 <etext+0x76e>
ffffffffc0200c4e:	00002517          	auipc	a0,0x2
ffffffffc0200c52:	afa50513          	addi	a0,a0,-1286 # ffffffffc0202748 <etext+0x676>
ffffffffc0200c56:	cf6ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200c5a:	8562                	mv	a0,s8
ffffffffc0200c5c:	4585                	li	a1,1
ffffffffc0200c5e:	97dff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
ffffffffc0200c62:	85ca                	mv	a1,s2
ffffffffc0200c64:	00002517          	auipc	a0,0x2
ffffffffc0200c68:	bfc50513          	addi	a0,a0,-1028 # ffffffffc0202860 <etext+0x78e>
ffffffffc0200c6c:	ce0ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200c70:	4054                	lw	a3,4(s0)
ffffffffc0200c72:	6890                	ld	a2,16(s1)
ffffffffc0200c74:	00002597          	auipc	a1,0x2
ffffffffc0200c78:	c1458593          	addi	a1,a1,-1004 # ffffffffc0202888 <etext+0x7b6>
ffffffffc0200c7c:	00002517          	auipc	a0,0x2
ffffffffc0200c80:	acc50513          	addi	a0,a0,-1332 # ffffffffc0202748 <etext+0x676>
ffffffffc0200c84:	cc8ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200c88:	4511                	li	a0,4
ffffffffc0200c8a:	cadff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200c8e:	8c2a                	mv	s8,a0
ffffffffc0200c90:	3e050e63          	beqz	a0,ffffffffc020108c <buddy_check+0x550>
ffffffffc0200c94:	000a3903          	ld	s2,0(s4)
ffffffffc0200c98:	00002517          	auipc	a0,0x2
ffffffffc0200c9c:	c2850513          	addi	a0,a0,-984 # ffffffffc02028c0 <etext+0x7ee>
ffffffffc0200ca0:	412c0933          	sub	s2,s8,s2
ffffffffc0200ca4:	40395913          	srai	s2,s2,0x3
ffffffffc0200ca8:	03390933          	mul	s2,s2,s3
ffffffffc0200cac:	9956                	add	s2,s2,s5
ffffffffc0200cae:	0932                	slli	s2,s2,0xc
ffffffffc0200cb0:	85ca                	mv	a1,s2
ffffffffc0200cb2:	c9aff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200cb6:	4054                	lw	a3,4(s0)
ffffffffc0200cb8:	6890                	ld	a2,16(s1)
ffffffffc0200cba:	00002597          	auipc	a1,0x2
ffffffffc0200cbe:	c2e58593          	addi	a1,a1,-978 # ffffffffc02028e8 <etext+0x816>
ffffffffc0200cc2:	00002517          	auipc	a0,0x2
ffffffffc0200cc6:	a8650513          	addi	a0,a0,-1402 # ffffffffc0202748 <etext+0x676>
ffffffffc0200cca:	c82ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200cce:	8566                	mv	a0,s9
ffffffffc0200cd0:	458d                	li	a1,3
ffffffffc0200cd2:	909ff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
ffffffffc0200cd6:	85de                	mv	a1,s7
ffffffffc0200cd8:	00002517          	auipc	a0,0x2
ffffffffc0200cdc:	c2050513          	addi	a0,a0,-992 # ffffffffc02028f8 <etext+0x826>
ffffffffc0200ce0:	c6cff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200ce4:	4054                	lw	a3,4(s0)
ffffffffc0200ce6:	6890                	ld	a2,16(s1)
ffffffffc0200ce8:	00002597          	auipc	a1,0x2
ffffffffc0200cec:	c4858593          	addi	a1,a1,-952 # ffffffffc0202930 <etext+0x85e>
ffffffffc0200cf0:	00002517          	auipc	a0,0x2
ffffffffc0200cf4:	a5850513          	addi	a0,a0,-1448 # ffffffffc0202748 <etext+0x676>
ffffffffc0200cf8:	c54ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200cfc:	8562                	mv	a0,s8
ffffffffc0200cfe:	4591                	li	a1,4
ffffffffc0200d00:	8dbff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
ffffffffc0200d04:	85ca                	mv	a1,s2
ffffffffc0200d06:	00002517          	auipc	a0,0x2
ffffffffc0200d0a:	c3a50513          	addi	a0,a0,-966 # ffffffffc0202940 <etext+0x86e>
ffffffffc0200d0e:	c3eff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200d12:	4054                	lw	a3,4(s0)
ffffffffc0200d14:	6890                	ld	a2,16(s1)
ffffffffc0200d16:	00002597          	auipc	a1,0x2
ffffffffc0200d1a:	c5258593          	addi	a1,a1,-942 # ffffffffc0202968 <etext+0x896>
ffffffffc0200d1e:	00002517          	auipc	a0,0x2
ffffffffc0200d22:	a2a50513          	addi	a0,a0,-1494 # ffffffffc0202748 <etext+0x676>
ffffffffc0200d26:	c26ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200d2a:	689c                	ld	a5,16(s1)
ffffffffc0200d2c:	3afb1063          	bne	s6,a5,ffffffffc02010cc <buddy_check+0x590>
ffffffffc0200d30:	4058                	lw	a4,4(s0)
ffffffffc0200d32:	401c                	lw	a5,0(s0)
ffffffffc0200d34:	50f71f63          	bne	a4,a5,ffffffffc0201252 <buddy_check+0x716>
ffffffffc0200d38:	00002517          	auipc	a0,0x2
ffffffffc0200d3c:	c9050513          	addi	a0,a0,-880 # ffffffffc02029c8 <etext+0x8f6>
ffffffffc0200d40:	c0cff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200d44:	00002517          	auipc	a0,0x2
ffffffffc0200d48:	cc450513          	addi	a0,a0,-828 # ffffffffc0202a08 <etext+0x936>
ffffffffc0200d4c:	c00ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200d50:	00042903          	lw	s2,0(s0)
ffffffffc0200d54:	0104bb83          	ld	s7,16(s1)
ffffffffc0200d58:	02091b13          	slli	s6,s2,0x20
ffffffffc0200d5c:	020b5b13          	srli	s6,s6,0x20
ffffffffc0200d60:	855a                	mv	a0,s6
ffffffffc0200d62:	bd5ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200d66:	8c2a                	mv	s8,a0
ffffffffc0200d68:	4c050563          	beqz	a0,ffffffffc0201232 <buddy_check+0x6f6>
ffffffffc0200d6c:	689c                	ld	a5,16(s1)
ffffffffc0200d6e:	2a079f63          	bnez	a5,ffffffffc020102c <buddy_check+0x4f0>
ffffffffc0200d72:	405c                	lw	a5,4(s0)
ffffffffc0200d74:	2a079c63          	bnez	a5,ffffffffc020102c <buddy_check+0x4f0>
ffffffffc0200d78:	000a3603          	ld	a2,0(s4)
ffffffffc0200d7c:	85da                	mv	a1,s6
ffffffffc0200d7e:	00002517          	auipc	a0,0x2
ffffffffc0200d82:	d3a50513          	addi	a0,a0,-710 # ffffffffc0202ab8 <etext+0x9e6>
ffffffffc0200d86:	40cc0633          	sub	a2,s8,a2
ffffffffc0200d8a:	860d                	srai	a2,a2,0x3
ffffffffc0200d8c:	03360633          	mul	a2,a2,s3
ffffffffc0200d90:	9656                	add	a2,a2,s5
ffffffffc0200d92:	0632                	slli	a2,a2,0xc
ffffffffc0200d94:	bb8ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200d98:	4054                	lw	a3,4(s0)
ffffffffc0200d9a:	6890                	ld	a2,16(s1)
ffffffffc0200d9c:	00002597          	auipc	a1,0x2
ffffffffc0200da0:	d6458593          	addi	a1,a1,-668 # ffffffffc0202b00 <etext+0xa2e>
ffffffffc0200da4:	00002517          	auipc	a0,0x2
ffffffffc0200da8:	9a450513          	addi	a0,a0,-1628 # ffffffffc0202748 <etext+0x676>
ffffffffc0200dac:	ba0ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200db0:	4505                	li	a0,1
ffffffffc0200db2:	b85ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200db6:	8caa                	mv	s9,a0
ffffffffc0200db8:	42051a63          	bnez	a0,ffffffffc02011ec <buddy_check+0x6b0>
ffffffffc0200dbc:	00002517          	auipc	a0,0x2
ffffffffc0200dc0:	d5c50513          	addi	a0,a0,-676 # ffffffffc0202b18 <etext+0xa46>
ffffffffc0200dc4:	b88ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200dc8:	85da                	mv	a1,s6
ffffffffc0200dca:	8562                	mv	a0,s8
ffffffffc0200dcc:	80fff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
ffffffffc0200dd0:	689c                	ld	a5,16(s1)
ffffffffc0200dd2:	22fb9d63          	bne	s7,a5,ffffffffc020100c <buddy_check+0x4d0>
ffffffffc0200dd6:	405c                	lw	a5,4(s0)
ffffffffc0200dd8:	22f91a63          	bne	s2,a5,ffffffffc020100c <buddy_check+0x4d0>
ffffffffc0200ddc:	86ca                	mv	a3,s2
ffffffffc0200dde:	865e                	mv	a2,s7
ffffffffc0200de0:	00002597          	auipc	a1,0x2
ffffffffc0200de4:	e6858593          	addi	a1,a1,-408 # ffffffffc0202c48 <etext+0xb76>
ffffffffc0200de8:	00002517          	auipc	a0,0x2
ffffffffc0200dec:	96050513          	addi	a0,a0,-1696 # ffffffffc0202748 <etext+0x676>
ffffffffc0200df0:	b5cff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200df4:	00002517          	auipc	a0,0x2
ffffffffc0200df8:	e6c50513          	addi	a0,a0,-404 # ffffffffc0202c60 <etext+0xb8e>
ffffffffc0200dfc:	b50ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200e00:	00002517          	auipc	a0,0x2
ffffffffc0200e04:	eb050513          	addi	a0,a0,-336 # ffffffffc0202cb0 <etext+0xbde>
ffffffffc0200e08:	b44ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200e0c:	00002517          	auipc	a0,0x2
ffffffffc0200e10:	ee450513          	addi	a0,a0,-284 # ffffffffc0202cf0 <etext+0xc1e>
ffffffffc0200e14:	00046b03          	lwu	s6,0(s0)
ffffffffc0200e18:	0104b903          	ld	s2,16(s1)
ffffffffc0200e1c:	00442a83          	lw	s5,4(s0)
ffffffffc0200e20:	b2cff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200e24:	4509                	li	a0,2
ffffffffc0200e26:	b11ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200e2a:	8baa                	mv	s7,a0
ffffffffc0200e2c:	4509                	li	a0,2
ffffffffc0200e2e:	b09ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200e32:	8c2a                	mv	s8,a0
ffffffffc0200e34:	1a0b8c63          	beqz	s7,ffffffffc0200fec <buddy_check+0x4b0>
ffffffffc0200e38:	1a050a63          	beqz	a0,ffffffffc0200fec <buddy_check+0x4b0>
ffffffffc0200e3c:	000a3703          	ld	a4,0(s4)
ffffffffc0200e40:	6689                	lui	a3,0x2
ffffffffc0200e42:	40e507b3          	sub	a5,a0,a4
ffffffffc0200e46:	40eb8733          	sub	a4,s7,a4
ffffffffc0200e4a:	878d                	srai	a5,a5,0x3
ffffffffc0200e4c:	870d                	srai	a4,a4,0x3
ffffffffc0200e4e:	8f99                	sub	a5,a5,a4
ffffffffc0200e50:	033787b3          	mul	a5,a5,s3
ffffffffc0200e54:	07b2                	slli	a5,a5,0xc
ffffffffc0200e56:	34d79b63          	bne	a5,a3,ffffffffc02011ac <buddy_check+0x670>
ffffffffc0200e5a:	4589                	li	a1,2
ffffffffc0200e5c:	855e                	mv	a0,s7
ffffffffc0200e5e:	f7cff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
ffffffffc0200e62:	4589                	li	a1,2
ffffffffc0200e64:	8562                	mv	a0,s8
ffffffffc0200e66:	f74ff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
ffffffffc0200e6a:	405c                	lw	a5,4(s0)
ffffffffc0200e6c:	32fa9063          	bne	s5,a5,ffffffffc020118c <buddy_check+0x650>
ffffffffc0200e70:	689c                	ld	a5,16(s1)
ffffffffc0200e72:	2ef91d63          	bne	s2,a5,ffffffffc020116c <buddy_check+0x630>
ffffffffc0200e76:	86d6                	mv	a3,s5
ffffffffc0200e78:	864a                	mv	a2,s2
ffffffffc0200e7a:	00002597          	auipc	a1,0x2
ffffffffc0200e7e:	fce58593          	addi	a1,a1,-50 # ffffffffc0202e48 <etext+0xd76>
ffffffffc0200e82:	00002517          	auipc	a0,0x2
ffffffffc0200e86:	8c650513          	addi	a0,a0,-1850 # ffffffffc0202748 <etext+0x676>
ffffffffc0200e8a:	ac2ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200e8e:	00002517          	auipc	a0,0x2
ffffffffc0200e92:	fe250513          	addi	a0,a0,-30 # ffffffffc0202e70 <etext+0xd9e>
ffffffffc0200e96:	ab6ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200e9a:	001b5b13          	srli	s6,s6,0x1
ffffffffc0200e9e:	855a                	mv	a0,s6
ffffffffc0200ea0:	a97ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200ea4:	8baa                	mv	s7,a0
ffffffffc0200ea6:	2a050363          	beqz	a0,ffffffffc020114c <buddy_check+0x610>
ffffffffc0200eaa:	4509                	li	a0,2
ffffffffc0200eac:	a8bff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200eb0:	8caa                	mv	s9,a0
ffffffffc0200eb2:	4509                	li	a0,2
ffffffffc0200eb4:	a83ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200eb8:	8c2a                	mv	s8,a0
ffffffffc0200eba:	100c8963          	beqz	s9,ffffffffc0200fcc <buddy_check+0x490>
ffffffffc0200ebe:	10050763          	beqz	a0,ffffffffc0200fcc <buddy_check+0x490>
ffffffffc0200ec2:	000a3703          	ld	a4,0(s4)
ffffffffc0200ec6:	6689                	lui	a3,0x2
ffffffffc0200ec8:	40e507b3          	sub	a5,a0,a4
ffffffffc0200ecc:	40ec8733          	sub	a4,s9,a4
ffffffffc0200ed0:	878d                	srai	a5,a5,0x3
ffffffffc0200ed2:	870d                	srai	a4,a4,0x3
ffffffffc0200ed4:	8f99                	sub	a5,a5,a4
ffffffffc0200ed6:	033787b3          	mul	a5,a5,s3
ffffffffc0200eda:	07b2                	slli	a5,a5,0xc
ffffffffc0200edc:	20d79863          	bne	a5,a3,ffffffffc02010ec <buddy_check+0x5b0>
ffffffffc0200ee0:	4589                	li	a1,2
ffffffffc0200ee2:	8566                	mv	a0,s9
ffffffffc0200ee4:	ef6ff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
ffffffffc0200ee8:	4589                	li	a1,2
ffffffffc0200eea:	8562                	mv	a0,s8
ffffffffc0200eec:	eeeff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
ffffffffc0200ef0:	4054                	lw	a3,4(s0)
ffffffffc0200ef2:	02069793          	slli	a5,a3,0x20
ffffffffc0200ef6:	9381                	srli	a5,a5,0x20
ffffffffc0200ef8:	20fb1a63          	bne	s6,a5,ffffffffc020110c <buddy_check+0x5d0>
ffffffffc0200efc:	6890                	ld	a2,16(s1)
ffffffffc0200efe:	41690933          	sub	s2,s2,s6
ffffffffc0200f02:	1b261563          	bne	a2,s2,ffffffffc02010ac <buddy_check+0x570>
ffffffffc0200f06:	00002597          	auipc	a1,0x2
ffffffffc0200f0a:	10a58593          	addi	a1,a1,266 # ffffffffc0203010 <etext+0xf3e>
ffffffffc0200f0e:	00002517          	auipc	a0,0x2
ffffffffc0200f12:	83a50513          	addi	a0,a0,-1990 # ffffffffc0202748 <etext+0x676>
ffffffffc0200f16:	a36ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200f1a:	85da                	mv	a1,s6
ffffffffc0200f1c:	855e                	mv	a0,s7
ffffffffc0200f1e:	ebcff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
ffffffffc0200f22:	405c                	lw	a5,4(s0)
ffffffffc0200f24:	21579463          	bne	a5,s5,ffffffffc020112c <buddy_check+0x5f0>
ffffffffc0200f28:	00002517          	auipc	a0,0x2
ffffffffc0200f2c:	18050513          	addi	a0,a0,384 # ffffffffc02030a8 <etext+0xfd6>
ffffffffc0200f30:	a1cff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200f34:	00002517          	auipc	a0,0x2
ffffffffc0200f38:	19450513          	addi	a0,a0,404 # ffffffffc02030c8 <etext+0xff6>
ffffffffc0200f3c:	a10ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200f40:	00046503          	lwu	a0,0(s0)
ffffffffc0200f44:	0505                	addi	a0,a0,1
ffffffffc0200f46:	9f1ff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200f4a:	28051163          	bnez	a0,ffffffffc02011cc <buddy_check+0x690>
ffffffffc0200f4e:	00002517          	auipc	a0,0x2
ffffffffc0200f52:	1d250513          	addi	a0,a0,466 # ffffffffc0203120 <etext+0x104e>
ffffffffc0200f56:	9f6ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200f5a:	4511                	li	a0,4
ffffffffc0200f5c:	9dbff0ef          	jal	ra,ffffffffc0200936 <buddy_alloc_pages>
ffffffffc0200f60:	649c                	ld	a5,8(s1)
ffffffffc0200f62:	05050593          	addi	a1,a0,80
ffffffffc0200f66:	06056603          	lwu	a2,96(a0)
ffffffffc0200f6a:	8d9d                	sub	a1,a1,a5
ffffffffc0200f6c:	858d                	srai	a1,a1,0x3
ffffffffc0200f6e:	033585b3          	mul	a1,a1,s3
ffffffffc0200f72:	842a                	mv	s0,a0
ffffffffc0200f74:	02c5f7b3          	remu	a5,a1,a2
ffffffffc0200f78:	e3b9                	bnez	a5,ffffffffc0200fbe <buddy_check+0x482>
ffffffffc0200f7a:	00002517          	auipc	a0,0x2
ffffffffc0200f7e:	21e50513          	addi	a0,a0,542 # ffffffffc0203198 <etext+0x10c6>
ffffffffc0200f82:	9caff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200f86:	4591                	li	a1,4
ffffffffc0200f88:	8522                	mv	a0,s0
ffffffffc0200f8a:	e50ff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
ffffffffc0200f8e:	00002517          	auipc	a0,0x2
ffffffffc0200f92:	23a50513          	addi	a0,a0,570 # ffffffffc02031c8 <etext+0x10f6>
ffffffffc0200f96:	9b6ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200f9a:	00002517          	auipc	a0,0x2
ffffffffc0200f9e:	24e50513          	addi	a0,a0,590 # ffffffffc02031e8 <etext+0x1116>
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
ffffffffc0200fba:	992ff06f          	j	ffffffffc020014c <cprintf>
ffffffffc0200fbe:	00002517          	auipc	a0,0x2
ffffffffc0200fc2:	18a50513          	addi	a0,a0,394 # ffffffffc0203148 <etext+0x1076>
ffffffffc0200fc6:	986ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200fca:	bf75                	j	ffffffffc0200f86 <buddy_check+0x44a>
ffffffffc0200fcc:	00002697          	auipc	a3,0x2
ffffffffc0200fd0:	f1468693          	addi	a3,a3,-236 # ffffffffc0202ee0 <etext+0xe0e>
ffffffffc0200fd4:	00001617          	auipc	a2,0x1
ffffffffc0200fd8:	38c60613          	addi	a2,a2,908 # ffffffffc0202360 <etext+0x28e>
ffffffffc0200fdc:	1f800593          	li	a1,504
ffffffffc0200fe0:	00001517          	auipc	a0,0x1
ffffffffc0200fe4:	39850513          	addi	a0,a0,920 # ffffffffc0202378 <etext+0x2a6>
ffffffffc0200fe8:	9daff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc0200fec:	00002697          	auipc	a3,0x2
ffffffffc0200ff0:	d3c68693          	addi	a3,a3,-708 # ffffffffc0202d28 <etext+0xc56>
ffffffffc0200ff4:	00001617          	auipc	a2,0x1
ffffffffc0200ff8:	36c60613          	addi	a2,a2,876 # ffffffffc0202360 <etext+0x28e>
ffffffffc0200ffc:	1e100593          	li	a1,481
ffffffffc0201000:	00001517          	auipc	a0,0x1
ffffffffc0201004:	37850513          	addi	a0,a0,888 # ffffffffc0202378 <etext+0x2a6>
ffffffffc0201008:	9baff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc020100c:	00002697          	auipc	a3,0x2
ffffffffc0201010:	bec68693          	addi	a3,a3,-1044 # ffffffffc0202bf8 <etext+0xb26>
ffffffffc0201014:	00001617          	auipc	a2,0x1
ffffffffc0201018:	34c60613          	addi	a2,a2,844 # ffffffffc0202360 <etext+0x28e>
ffffffffc020101c:	1d000593          	li	a1,464
ffffffffc0201020:	00001517          	auipc	a0,0x1
ffffffffc0201024:	35850513          	addi	a0,a0,856 # ffffffffc0202378 <etext+0x2a6>
ffffffffc0201028:	99aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc020102c:	00002697          	auipc	a3,0x2
ffffffffc0201030:	a5468693          	addi	a3,a3,-1452 # ffffffffc0202a80 <etext+0x9ae>
ffffffffc0201034:	00001617          	auipc	a2,0x1
ffffffffc0201038:	32c60613          	addi	a2,a2,812 # ffffffffc0202360 <etext+0x28e>
ffffffffc020103c:	1bd00593          	li	a1,445
ffffffffc0201040:	00001517          	auipc	a0,0x1
ffffffffc0201044:	33850513          	addi	a0,a0,824 # ffffffffc0202378 <etext+0x2a6>
ffffffffc0201048:	97aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc020104c:	00001697          	auipc	a3,0x1
ffffffffc0201050:	79468693          	addi	a3,a3,1940 # ffffffffc02027e0 <etext+0x70e>
ffffffffc0201054:	00001617          	auipc	a2,0x1
ffffffffc0201058:	30c60613          	addi	a2,a2,780 # ffffffffc0202360 <etext+0x28e>
ffffffffc020105c:	19100593          	li	a1,401
ffffffffc0201060:	00001517          	auipc	a0,0x1
ffffffffc0201064:	31850513          	addi	a0,a0,792 # ffffffffc0202378 <etext+0x2a6>
ffffffffc0201068:	95aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc020106c:	00001697          	auipc	a3,0x1
ffffffffc0201070:	71468693          	addi	a3,a3,1812 # ffffffffc0202780 <etext+0x6ae>
ffffffffc0201074:	00001617          	auipc	a2,0x1
ffffffffc0201078:	2ec60613          	addi	a2,a2,748 # ffffffffc0202360 <etext+0x28e>
ffffffffc020107c:	18a00593          	li	a1,394
ffffffffc0201080:	00001517          	auipc	a0,0x1
ffffffffc0201084:	2f850513          	addi	a0,a0,760 # ffffffffc0202378 <etext+0x2a6>
ffffffffc0201088:	93aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc020108c:	00002697          	auipc	a3,0x2
ffffffffc0201090:	80c68693          	addi	a3,a3,-2036 # ffffffffc0202898 <etext+0x7c6>
ffffffffc0201094:	00001617          	auipc	a2,0x1
ffffffffc0201098:	2cc60613          	addi	a2,a2,716 # ffffffffc0202360 <etext+0x28e>
ffffffffc020109c:	19d00593          	li	a1,413
ffffffffc02010a0:	00001517          	auipc	a0,0x1
ffffffffc02010a4:	2d850513          	addi	a0,a0,728 # ffffffffc0202378 <etext+0x2a6>
ffffffffc02010a8:	91aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc02010ac:	00002697          	auipc	a3,0x2
ffffffffc02010b0:	f0468693          	addi	a3,a3,-252 # ffffffffc0202fb0 <etext+0xede>
ffffffffc02010b4:	00001617          	auipc	a2,0x1
ffffffffc02010b8:	2ac60613          	addi	a2,a2,684 # ffffffffc0202360 <etext+0x28e>
ffffffffc02010bc:	20200593          	li	a1,514
ffffffffc02010c0:	00001517          	auipc	a0,0x1
ffffffffc02010c4:	2b850513          	addi	a0,a0,696 # ffffffffc0202378 <etext+0x2a6>
ffffffffc02010c8:	8faff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc02010cc:	00002697          	auipc	a3,0x2
ffffffffc02010d0:	8ac68693          	addi	a3,a3,-1876 # ffffffffc0202978 <etext+0x8a6>
ffffffffc02010d4:	00001617          	auipc	a2,0x1
ffffffffc02010d8:	28c60613          	addi	a2,a2,652 # ffffffffc0202360 <etext+0x28e>
ffffffffc02010dc:	1ac00593          	li	a1,428
ffffffffc02010e0:	00001517          	auipc	a0,0x1
ffffffffc02010e4:	29850513          	addi	a0,a0,664 # ffffffffc0202378 <etext+0x2a6>
ffffffffc02010e8:	8daff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc02010ec:	00002697          	auipc	a3,0x2
ffffffffc02010f0:	e2c68693          	addi	a3,a3,-468 # ffffffffc0202f18 <etext+0xe46>
ffffffffc02010f4:	00001617          	auipc	a2,0x1
ffffffffc02010f8:	26c60613          	addi	a2,a2,620 # ffffffffc0202360 <etext+0x28e>
ffffffffc02010fc:	1fb00593          	li	a1,507
ffffffffc0201100:	00001517          	auipc	a0,0x1
ffffffffc0201104:	27850513          	addi	a0,a0,632 # ffffffffc0202378 <etext+0x2a6>
ffffffffc0201108:	8baff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc020110c:	00002697          	auipc	a3,0x2
ffffffffc0201110:	e4c68693          	addi	a3,a3,-436 # ffffffffc0202f58 <etext+0xe86>
ffffffffc0201114:	00001617          	auipc	a2,0x1
ffffffffc0201118:	24c60613          	addi	a2,a2,588 # ffffffffc0202360 <etext+0x28e>
ffffffffc020111c:	20100593          	li	a1,513
ffffffffc0201120:	00001517          	auipc	a0,0x1
ffffffffc0201124:	25850513          	addi	a0,a0,600 # ffffffffc0202378 <etext+0x2a6>
ffffffffc0201128:	89aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc020112c:	00002697          	auipc	a3,0x2
ffffffffc0201130:	f1468693          	addi	a3,a3,-236 # ffffffffc0203040 <etext+0xf6e>
ffffffffc0201134:	00001617          	auipc	a2,0x1
ffffffffc0201138:	22c60613          	addi	a2,a2,556 # ffffffffc0202360 <etext+0x28e>
ffffffffc020113c:	20700593          	li	a1,519
ffffffffc0201140:	00001517          	auipc	a0,0x1
ffffffffc0201144:	23850513          	addi	a0,a0,568 # ffffffffc0202378 <etext+0x2a6>
ffffffffc0201148:	87aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc020114c:	00002697          	auipc	a3,0x2
ffffffffc0201150:	d5c68693          	addi	a3,a3,-676 # ffffffffc0202ea8 <etext+0xdd6>
ffffffffc0201154:	00001617          	auipc	a2,0x1
ffffffffc0201158:	20c60613          	addi	a2,a2,524 # ffffffffc0202360 <etext+0x28e>
ffffffffc020115c:	1f200593          	li	a1,498
ffffffffc0201160:	00001517          	auipc	a0,0x1
ffffffffc0201164:	21850513          	addi	a0,a0,536 # ffffffffc0202378 <etext+0x2a6>
ffffffffc0201168:	85aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc020116c:	00002697          	auipc	a3,0x2
ffffffffc0201170:	c8c68693          	addi	a3,a3,-884 # ffffffffc0202df8 <etext+0xd26>
ffffffffc0201174:	00001617          	auipc	a2,0x1
ffffffffc0201178:	1ec60613          	addi	a2,a2,492 # ffffffffc0202360 <etext+0x28e>
ffffffffc020117c:	1ea00593          	li	a1,490
ffffffffc0201180:	00001517          	auipc	a0,0x1
ffffffffc0201184:	1f850513          	addi	a0,a0,504 # ffffffffc0202378 <etext+0x2a6>
ffffffffc0201188:	83aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc020118c:	00002697          	auipc	a3,0x2
ffffffffc0201190:	c1468693          	addi	a3,a3,-1004 # ffffffffc0202da0 <etext+0xcce>
ffffffffc0201194:	00001617          	auipc	a2,0x1
ffffffffc0201198:	1cc60613          	addi	a2,a2,460 # ffffffffc0202360 <etext+0x28e>
ffffffffc020119c:	1e900593          	li	a1,489
ffffffffc02011a0:	00001517          	auipc	a0,0x1
ffffffffc02011a4:	1d850513          	addi	a0,a0,472 # ffffffffc0202378 <etext+0x2a6>
ffffffffc02011a8:	81aff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc02011ac:	00002697          	auipc	a3,0x2
ffffffffc02011b0:	bb468693          	addi	a3,a3,-1100 # ffffffffc0202d60 <etext+0xc8e>
ffffffffc02011b4:	00001617          	auipc	a2,0x1
ffffffffc02011b8:	1ac60613          	addi	a2,a2,428 # ffffffffc0202360 <etext+0x28e>
ffffffffc02011bc:	1e400593          	li	a1,484
ffffffffc02011c0:	00001517          	auipc	a0,0x1
ffffffffc02011c4:	1b850513          	addi	a0,a0,440 # ffffffffc0202378 <etext+0x2a6>
ffffffffc02011c8:	ffbfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc02011cc:	00002697          	auipc	a3,0x2
ffffffffc02011d0:	f2468693          	addi	a3,a3,-220 # ffffffffc02030f0 <etext+0x101e>
ffffffffc02011d4:	00001617          	auipc	a2,0x1
ffffffffc02011d8:	18c60613          	addi	a2,a2,396 # ffffffffc0202360 <etext+0x28e>
ffffffffc02011dc:	21200593          	li	a1,530
ffffffffc02011e0:	00001517          	auipc	a0,0x1
ffffffffc02011e4:	19850513          	addi	a0,a0,408 # ffffffffc0202378 <etext+0x2a6>
ffffffffc02011e8:	fdbfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc02011ec:	000a3583          	ld	a1,0(s4)
ffffffffc02011f0:	00002517          	auipc	a0,0x2
ffffffffc02011f4:	97050513          	addi	a0,a0,-1680 # ffffffffc0202b60 <etext+0xa8e>
ffffffffc02011f8:	40bc85b3          	sub	a1,s9,a1
ffffffffc02011fc:	858d                	srai	a1,a1,0x3
ffffffffc02011fe:	033585b3          	mul	a1,a1,s3
ffffffffc0201202:	95d6                	add	a1,a1,s5
ffffffffc0201204:	05b2                	slli	a1,a1,0xc
ffffffffc0201206:	f47fe0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc020120a:	4585                	li	a1,1
ffffffffc020120c:	8566                	mv	a0,s9
ffffffffc020120e:	bccff0ef          	jal	ra,ffffffffc02005da <buddy_free_pages>
ffffffffc0201212:	00002697          	auipc	a3,0x2
ffffffffc0201216:	99668693          	addi	a3,a3,-1642 # ffffffffc0202ba8 <etext+0xad6>
ffffffffc020121a:	00001617          	auipc	a2,0x1
ffffffffc020121e:	14660613          	addi	a2,a2,326 # ffffffffc0202360 <etext+0x28e>
ffffffffc0201222:	1cb00593          	li	a1,459
ffffffffc0201226:	00001517          	auipc	a0,0x1
ffffffffc020122a:	15250513          	addi	a0,a0,338 # ffffffffc0202378 <etext+0x2a6>
ffffffffc020122e:	f95fe0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc0201232:	00002697          	auipc	a3,0x2
ffffffffc0201236:	81668693          	addi	a3,a3,-2026 # ffffffffc0202a48 <etext+0x976>
ffffffffc020123a:	00001617          	auipc	a2,0x1
ffffffffc020123e:	12660613          	addi	a2,a2,294 # ffffffffc0202360 <etext+0x28e>
ffffffffc0201242:	1bc00593          	li	a1,444
ffffffffc0201246:	00001517          	auipc	a0,0x1
ffffffffc020124a:	13250513          	addi	a0,a0,306 # ffffffffc0202378 <etext+0x2a6>
ffffffffc020124e:	f75fe0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc0201252:	00001697          	auipc	a3,0x1
ffffffffc0201256:	74e68693          	addi	a3,a3,1870 # ffffffffc02029a0 <etext+0x8ce>
ffffffffc020125a:	00001617          	auipc	a2,0x1
ffffffffc020125e:	10660613          	addi	a2,a2,262 # ffffffffc0202360 <etext+0x28e>
ffffffffc0201262:	1ad00593          	li	a1,429
ffffffffc0201266:	00001517          	auipc	a0,0x1
ffffffffc020126a:	11250513          	addi	a0,a0,274 # ffffffffc0202378 <etext+0x2a6>
ffffffffc020126e:	f55fe0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0201272 <alloc_pages>:
ffffffffc0201272:	00026797          	auipc	a5,0x26
ffffffffc0201276:	e167b783          	ld	a5,-490(a5) # ffffffffc0227088 <pmm_manager>
ffffffffc020127a:	6f9c                	ld	a5,24(a5)
ffffffffc020127c:	8782                	jr	a5

ffffffffc020127e <free_pages>:
ffffffffc020127e:	00026797          	auipc	a5,0x26
ffffffffc0201282:	e0a7b783          	ld	a5,-502(a5) # ffffffffc0227088 <pmm_manager>
ffffffffc0201286:	739c                	ld	a5,32(a5)
ffffffffc0201288:	8782                	jr	a5

ffffffffc020128a <pmm_init>:
ffffffffc020128a:	00002797          	auipc	a5,0x2
ffffffffc020128e:	f8e78793          	addi	a5,a5,-114 # ffffffffc0203218 <buddy_pmm_manager>
ffffffffc0201292:	638c                	ld	a1,0(a5)
ffffffffc0201294:	7179                	addi	sp,sp,-48
ffffffffc0201296:	f022                	sd	s0,32(sp)
ffffffffc0201298:	00002517          	auipc	a0,0x2
ffffffffc020129c:	fb850513          	addi	a0,a0,-72 # ffffffffc0203250 <buddy_pmm_manager+0x38>
ffffffffc02012a0:	00026417          	auipc	s0,0x26
ffffffffc02012a4:	de840413          	addi	s0,s0,-536 # ffffffffc0227088 <pmm_manager>
ffffffffc02012a8:	f406                	sd	ra,40(sp)
ffffffffc02012aa:	ec26                	sd	s1,24(sp)
ffffffffc02012ac:	e44e                	sd	s3,8(sp)
ffffffffc02012ae:	e84a                	sd	s2,16(sp)
ffffffffc02012b0:	e052                	sd	s4,0(sp)
ffffffffc02012b2:	e01c                	sd	a5,0(s0)
ffffffffc02012b4:	e99fe0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc02012b8:	601c                	ld	a5,0(s0)
ffffffffc02012ba:	00026497          	auipc	s1,0x26
ffffffffc02012be:	de648493          	addi	s1,s1,-538 # ffffffffc02270a0 <va_pa_offset>
ffffffffc02012c2:	679c                	ld	a5,8(a5)
ffffffffc02012c4:	9782                	jalr	a5
ffffffffc02012c6:	57f5                	li	a5,-3
ffffffffc02012c8:	07fa                	slli	a5,a5,0x1e
ffffffffc02012ca:	e09c                	sd	a5,0(s1)
ffffffffc02012cc:	af0ff0ef          	jal	ra,ffffffffc02005bc <get_memory_base>
ffffffffc02012d0:	89aa                	mv	s3,a0
ffffffffc02012d2:	af4ff0ef          	jal	ra,ffffffffc02005c6 <get_memory_size>
ffffffffc02012d6:	16050163          	beqz	a0,ffffffffc0201438 <pmm_init+0x1ae>
ffffffffc02012da:	892a                	mv	s2,a0
ffffffffc02012dc:	00002517          	auipc	a0,0x2
ffffffffc02012e0:	fbc50513          	addi	a0,a0,-68 # ffffffffc0203298 <buddy_pmm_manager+0x80>
ffffffffc02012e4:	e69fe0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc02012e8:	01298a33          	add	s4,s3,s2
ffffffffc02012ec:	864e                	mv	a2,s3
ffffffffc02012ee:	fffa0693          	addi	a3,s4,-1
ffffffffc02012f2:	85ca                	mv	a1,s2
ffffffffc02012f4:	00001517          	auipc	a0,0x1
ffffffffc02012f8:	2a450513          	addi	a0,a0,676 # ffffffffc0202598 <etext+0x4c6>
ffffffffc02012fc:	e51fe0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0201300:	c80007b7          	lui	a5,0xc8000
ffffffffc0201304:	8652                	mv	a2,s4
ffffffffc0201306:	0d47e863          	bltu	a5,s4,ffffffffc02013d6 <pmm_init+0x14c>
ffffffffc020130a:	00027797          	auipc	a5,0x27
ffffffffc020130e:	d9d78793          	addi	a5,a5,-611 # ffffffffc02280a7 <end+0xfff>
ffffffffc0201312:	757d                	lui	a0,0xfffff
ffffffffc0201314:	8d7d                	and	a0,a0,a5
ffffffffc0201316:	8231                	srli	a2,a2,0xc
ffffffffc0201318:	00026797          	auipc	a5,0x26
ffffffffc020131c:	d6c7b023          	sd	a2,-672(a5) # ffffffffc0227078 <npage>
ffffffffc0201320:	00026797          	auipc	a5,0x26
ffffffffc0201324:	d6a7b023          	sd	a0,-672(a5) # ffffffffc0227080 <pages>
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
ffffffffc0201348:	6798                	ld	a4,8(a5)
ffffffffc020134a:	02878793          	addi	a5,a5,40 # fffffffffec00028 <end+0x3e9d8f80>
ffffffffc020134e:	00176713          	ori	a4,a4,1
ffffffffc0201352:	fee7b023          	sd	a4,-32(a5)
ffffffffc0201356:	fef699e3          	bne	a3,a5,ffffffffc0201348 <pmm_init+0xbe>
ffffffffc020135a:	95b2                	add	a1,a1,a2
ffffffffc020135c:	fec006b7          	lui	a3,0xfec00
ffffffffc0201360:	96aa                	add	a3,a3,a0
ffffffffc0201362:	058e                	slli	a1,a1,0x3
ffffffffc0201364:	96ae                	add	a3,a3,a1
ffffffffc0201366:	c02007b7          	lui	a5,0xc0200
ffffffffc020136a:	0af6eb63          	bltu	a3,a5,ffffffffc0201420 <pmm_init+0x196>
ffffffffc020136e:	6098                	ld	a4,0(s1)
ffffffffc0201370:	77fd                	lui	a5,0xfffff
ffffffffc0201372:	00fa75b3          	and	a1,s4,a5
ffffffffc0201376:	8e99                	sub	a3,a3,a4
ffffffffc0201378:	06b6e263          	bltu	a3,a1,ffffffffc02013dc <pmm_init+0x152>
ffffffffc020137c:	601c                	ld	a5,0(s0)
ffffffffc020137e:	7b9c                	ld	a5,48(a5)
ffffffffc0201380:	9782                	jalr	a5
ffffffffc0201382:	00002517          	auipc	a0,0x2
ffffffffc0201386:	f5650513          	addi	a0,a0,-170 # ffffffffc02032d8 <buddy_pmm_manager+0xc0>
ffffffffc020138a:	dc3fe0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc020138e:	16a000ef          	jal	ra,ffffffffc02014f8 <slub_init>
ffffffffc0201392:	570000ef          	jal	ra,ffffffffc0201902 <slub_selftest>
ffffffffc0201396:	00005597          	auipc	a1,0x5
ffffffffc020139a:	c6a58593          	addi	a1,a1,-918 # ffffffffc0206000 <boot_page_table_sv39>
ffffffffc020139e:	00026797          	auipc	a5,0x26
ffffffffc02013a2:	ceb7bd23          	sd	a1,-774(a5) # ffffffffc0227098 <satp_virtual>
ffffffffc02013a6:	c02007b7          	lui	a5,0xc0200
ffffffffc02013aa:	0af5e363          	bltu	a1,a5,ffffffffc0201450 <pmm_init+0x1c6>
ffffffffc02013ae:	6090                	ld	a2,0(s1)
ffffffffc02013b0:	7402                	ld	s0,32(sp)
ffffffffc02013b2:	70a2                	ld	ra,40(sp)
ffffffffc02013b4:	64e2                	ld	s1,24(sp)
ffffffffc02013b6:	6942                	ld	s2,16(sp)
ffffffffc02013b8:	69a2                	ld	s3,8(sp)
ffffffffc02013ba:	6a02                	ld	s4,0(sp)
ffffffffc02013bc:	40c58633          	sub	a2,a1,a2
ffffffffc02013c0:	00026797          	auipc	a5,0x26
ffffffffc02013c4:	ccc7b823          	sd	a2,-816(a5) # ffffffffc0227090 <satp_physical>
ffffffffc02013c8:	00002517          	auipc	a0,0x2
ffffffffc02013cc:	f3050513          	addi	a0,a0,-208 # ffffffffc02032f8 <buddy_pmm_manager+0xe0>
ffffffffc02013d0:	6145                	addi	sp,sp,48
ffffffffc02013d2:	d7bfe06f          	j	ffffffffc020014c <cprintf>
ffffffffc02013d6:	c8000637          	lui	a2,0xc8000
ffffffffc02013da:	bf05                	j	ffffffffc020130a <pmm_init+0x80>
ffffffffc02013dc:	6705                	lui	a4,0x1
ffffffffc02013de:	177d                	addi	a4,a4,-1
ffffffffc02013e0:	96ba                	add	a3,a3,a4
ffffffffc02013e2:	8efd                	and	a3,a3,a5
ffffffffc02013e4:	00c6d793          	srli	a5,a3,0xc
ffffffffc02013e8:	02c7f063          	bgeu	a5,a2,ffffffffc0201408 <pmm_init+0x17e>
ffffffffc02013ec:	6010                	ld	a2,0(s0)
ffffffffc02013ee:	fff80737          	lui	a4,0xfff80
ffffffffc02013f2:	973e                	add	a4,a4,a5
ffffffffc02013f4:	00271793          	slli	a5,a4,0x2
ffffffffc02013f8:	97ba                	add	a5,a5,a4
ffffffffc02013fa:	6a18                	ld	a4,16(a2)
ffffffffc02013fc:	8d95                	sub	a1,a1,a3
ffffffffc02013fe:	078e                	slli	a5,a5,0x3
ffffffffc0201400:	81b1                	srli	a1,a1,0xc
ffffffffc0201402:	953e                	add	a0,a0,a5
ffffffffc0201404:	9702                	jalr	a4
ffffffffc0201406:	bf9d                	j	ffffffffc020137c <pmm_init+0xf2>
ffffffffc0201408:	00001617          	auipc	a2,0x1
ffffffffc020140c:	1f060613          	addi	a2,a2,496 # ffffffffc02025f8 <etext+0x526>
ffffffffc0201410:	05800593          	li	a1,88
ffffffffc0201414:	00001517          	auipc	a0,0x1
ffffffffc0201418:	20450513          	addi	a0,a0,516 # ffffffffc0202618 <etext+0x546>
ffffffffc020141c:	da7fe0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc0201420:	00002617          	auipc	a2,0x2
ffffffffc0201424:	e9060613          	addi	a2,a2,-368 # ffffffffc02032b0 <buddy_pmm_manager+0x98>
ffffffffc0201428:	06100593          	li	a1,97
ffffffffc020142c:	00002517          	auipc	a0,0x2
ffffffffc0201430:	e5c50513          	addi	a0,a0,-420 # ffffffffc0203288 <buddy_pmm_manager+0x70>
ffffffffc0201434:	d8ffe0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc0201438:	00002617          	auipc	a2,0x2
ffffffffc020143c:	e3060613          	addi	a2,a2,-464 # ffffffffc0203268 <buddy_pmm_manager+0x50>
ffffffffc0201440:	04900593          	li	a1,73
ffffffffc0201444:	00002517          	auipc	a0,0x2
ffffffffc0201448:	e4450513          	addi	a0,a0,-444 # ffffffffc0203288 <buddy_pmm_manager+0x70>
ffffffffc020144c:	d77fe0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc0201450:	86ae                	mv	a3,a1
ffffffffc0201452:	00002617          	auipc	a2,0x2
ffffffffc0201456:	e5e60613          	addi	a2,a2,-418 # ffffffffc02032b0 <buddy_pmm_manager+0x98>
ffffffffc020145a:	07e00593          	li	a1,126
ffffffffc020145e:	00002517          	auipc	a0,0x2
ffffffffc0201462:	e2a50513          	addi	a0,a0,-470 # ffffffffc0203288 <buddy_pmm_manager+0x70>
ffffffffc0201466:	d5dfe0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc020146a <slab_alloc_from>:
    return s;
}

// 从指定slab分配一个对象（修改位图，返回对象地址）
static void *slab_alloc_from(slab_t *s) {
    if (s->free_cnt == 0) return NULL;
ffffffffc020146a:	6d1c                	ld	a5,24(a0)
static void *slab_alloc_from(slab_t *s) {
ffffffffc020146c:	85aa                	mv	a1,a0
    if (s->free_cnt == 0) return NULL;
ffffffffc020146e:	cfa1                	beqz	a5,ffffffffc02014c6 <slab_alloc_from+0x5c>
    size_t obj_size = SLUB_OBJ_SIZES[s->level];
ffffffffc0201470:	02c56783          	lwu	a5,44(a0)
    return (unsigned char *)(slab_objs_base(s) + s->objs * obj_size);
ffffffffc0201474:	02053883          	ld	a7,32(a0)
    size_t obj_size = SLUB_OBJ_SIZES[s->level];
ffffffffc0201478:	00379713          	slli	a4,a5,0x3
ffffffffc020147c:	00002797          	auipc	a5,0x2
ffffffffc0201480:	28478793          	addi	a5,a5,644 # ffffffffc0203700 <SLUB_OBJ_SIZES>
ffffffffc0201484:	97ba                	add	a5,a5,a4
ffffffffc0201486:	0007b303          	ld	t1,0(a5)
    return (unsigned char *)(slab_objs_base(s) + s->objs * obj_size);
ffffffffc020148a:	03130833          	mul	a6,t1,a7
ffffffffc020148e:	03080813          	addi	a6,a6,48

    unsigned char *bm = slab_bitmap(s);
    size_t obj_size = SLUB_OBJ_SIZES[s->level];

    // 遍历位图找第一个空闲对象（0表示空闲）
    for (size_t i = 0; i < s->objs; i++) {
ffffffffc0201492:	02088a63          	beqz	a7,ffffffffc02014c6 <slab_alloc_from+0x5c>
        size_t byte_idx = i / 8;  // 位图字节索引
        size_t bit_idx = i % 8;   // 字节内bit索引
        if (!(bm[byte_idx] & (1 << bit_idx))) {
ffffffffc0201496:	010507b3          	add	a5,a0,a6
ffffffffc020149a:	0007c603          	lbu	a2,0(a5)
ffffffffc020149e:	00167713          	andi	a4,a2,1
ffffffffc02014a2:	c739                	beqz	a4,ffffffffc02014f0 <slab_alloc_from+0x86>
    for (size_t i = 0; i < s->objs; i++) {
ffffffffc02014a4:	4701                	li	a4,0
ffffffffc02014a6:	a039                	j	ffffffffc02014b4 <slab_alloc_from+0x4a>
        if (!(bm[byte_idx] & (1 << bit_idx))) {
ffffffffc02014a8:	0007c603          	lbu	a2,0(a5)
ffffffffc02014ac:	40a656bb          	sraw	a3,a2,a0
ffffffffc02014b0:	8a85                	andi	a3,a3,1
ffffffffc02014b2:	ce81                	beqz	a3,ffffffffc02014ca <slab_alloc_from+0x60>
    for (size_t i = 0; i < s->objs; i++) {
ffffffffc02014b4:	0705                	addi	a4,a4,1
        size_t byte_idx = i / 8;  // 位图字节索引
ffffffffc02014b6:	00375793          	srli	a5,a4,0x3
        if (!(bm[byte_idx] & (1 << bit_idx))) {
ffffffffc02014ba:	97c2                	add	a5,a5,a6
ffffffffc02014bc:	97ae                	add	a5,a5,a1
ffffffffc02014be:	00777513          	andi	a0,a4,7
    for (size_t i = 0; i < s->objs; i++) {
ffffffffc02014c2:	ff1713e3          	bne	a4,a7,ffffffffc02014a8 <slab_alloc_from+0x3e>
    if (s->free_cnt == 0) return NULL;
ffffffffc02014c6:	4501                	li	a0,0
            // 计算对象地址（对象区起始 + 索引*尺寸）
            return slab_objs_base(s) + (i * obj_size);
        }
    }
    return NULL; // 理论上不会到这（free_cnt>0但无空闲，位图异常）
}
ffffffffc02014c8:	8082                	ret
            return slab_objs_base(s) + (i * obj_size);
ffffffffc02014ca:	02e30733          	mul	a4,t1,a4
            bm[byte_idx] |= (1 << bit_idx); // 标记为占用
ffffffffc02014ce:	4685                	li	a3,1
ffffffffc02014d0:	00a6953b          	sllw	a0,a3,a0
ffffffffc02014d4:	0185169b          	slliw	a3,a0,0x18
ffffffffc02014d8:	4186d69b          	sraiw	a3,a3,0x18
ffffffffc02014dc:	03070513          	addi	a0,a4,48 # fffffffffff80030 <end+0x3fd58f88>
ffffffffc02014e0:	8e55                	or	a2,a2,a3
ffffffffc02014e2:	00c78023          	sb	a2,0(a5)
            s->free_cnt--;
ffffffffc02014e6:	6d9c                	ld	a5,24(a1)
            return slab_objs_base(s) + (i * obj_size);
ffffffffc02014e8:	952e                	add	a0,a0,a1
            s->free_cnt--;
ffffffffc02014ea:	17fd                	addi	a5,a5,-1
ffffffffc02014ec:	ed9c                	sd	a5,24(a1)
            return slab_objs_base(s) + (i * obj_size);
ffffffffc02014ee:	8082                	ret
        if (!(bm[byte_idx] & (1 << bit_idx))) {
ffffffffc02014f0:	03000513          	li	a0,48
ffffffffc02014f4:	4685                	li	a3,1
ffffffffc02014f6:	b7ed                	j	ffffffffc02014e0 <slab_alloc_from+0x76>

ffffffffc02014f8 <slub_init>:
    s->free_cnt++; // 空闲数+1
}

// ------- SLUB核心接口（多级尺寸适配） -------
// SLUB初始化：初始化所有尺寸类的slab链表
void slub_init(void) {
ffffffffc02014f8:	1141                	addi	sp,sp,-16
ffffffffc02014fa:	e022                	sd	s0,0(sp)
    for (int i = 0; i < SLUB_LEVEL_CNT; i++) {
        list_init(&slab_lists[i]);
        cprintf("SLUB(level %d): obj=%luB, align=%luB\n", 
ffffffffc02014fc:	04000693          	li	a3,64
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0201500:	00026417          	auipc	s0,0x26
ffffffffc0201504:	b3040413          	addi	s0,s0,-1232 # ffffffffc0227030 <slab_lists>
ffffffffc0201508:	04000613          	li	a2,64
ffffffffc020150c:	4581                	li	a1,0
ffffffffc020150e:	00002517          	auipc	a0,0x2
ffffffffc0201512:	e2a50513          	addi	a0,a0,-470 # ffffffffc0203338 <buddy_pmm_manager+0x120>
void slub_init(void) {
ffffffffc0201516:	e406                	sd	ra,8(sp)
ffffffffc0201518:	e400                	sd	s0,8(s0)
ffffffffc020151a:	e000                	sd	s0,0(s0)
        cprintf("SLUB(level %d): obj=%luB, align=%luB\n", 
ffffffffc020151c:	c31fe0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0201520:	00026797          	auipc	a5,0x26
ffffffffc0201524:	b2078793          	addi	a5,a5,-1248 # ffffffffc0227040 <slab_lists+0x10>
ffffffffc0201528:	08000693          	li	a3,128
ffffffffc020152c:	08000613          	li	a2,128
ffffffffc0201530:	4585                	li	a1,1
ffffffffc0201532:	00002517          	auipc	a0,0x2
ffffffffc0201536:	e0650513          	addi	a0,a0,-506 # ffffffffc0203338 <buddy_pmm_manager+0x120>
ffffffffc020153a:	ec1c                	sd	a5,24(s0)
ffffffffc020153c:	e81c                	sd	a5,16(s0)
ffffffffc020153e:	c0ffe0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0201542:	00026797          	auipc	a5,0x26
ffffffffc0201546:	b0e78793          	addi	a5,a5,-1266 # ffffffffc0227050 <slab_lists+0x20>
ffffffffc020154a:	f41c                	sd	a5,40(s0)
ffffffffc020154c:	f01c                	sd	a5,32(s0)
                i, SLUB_OBJ_SIZES[i], SLUB_ALIGNS[i]);
    }
}
ffffffffc020154e:	6402                	ld	s0,0(sp)
ffffffffc0201550:	60a2                	ld	ra,8(sp)
        cprintf("SLUB(level %d): obj=%luB, align=%luB\n", 
ffffffffc0201552:	10000693          	li	a3,256
ffffffffc0201556:	10000613          	li	a2,256
ffffffffc020155a:	4589                	li	a1,2
ffffffffc020155c:	00002517          	auipc	a0,0x2
ffffffffc0201560:	ddc50513          	addi	a0,a0,-548 # ffffffffc0203338 <buddy_pmm_manager+0x120>
}
ffffffffc0201564:	0141                	addi	sp,sp,16
        cprintf("SLUB(level %d): obj=%luB, align=%luB\n", 
ffffffffc0201566:	be7fe06f          	j	ffffffffc020014c <cprintf>

ffffffffc020156a <slub_alloc>:
    if (size == 0) return SLUB_LEVEL_CNT;
ffffffffc020156a:	cd1d                	beqz	a0,ffffffffc02015a8 <slub_alloc+0x3e>

// SLUB分配：按尺寸匹配级别，从对应链表分配
void *slub_alloc(size_t size) {
ffffffffc020156c:	7139                	addi	sp,sp,-64
ffffffffc020156e:	fc06                	sd	ra,56(sp)
ffffffffc0201570:	f822                	sd	s0,48(sp)
ffffffffc0201572:	f426                	sd	s1,40(sp)
ffffffffc0201574:	f04a                	sd	s2,32(sp)
ffffffffc0201576:	ec4e                	sd	s3,24(sp)
ffffffffc0201578:	e852                	sd	s4,16(sp)
ffffffffc020157a:	e456                	sd	s5,8(sp)
        if (size <= SLUB_OBJ_SIZES[i]) {
ffffffffc020157c:	04000793          	li	a5,64
ffffffffc0201580:	16a7f263          	bgeu	a5,a0,ffffffffc02016e4 <slub_alloc+0x17a>
ffffffffc0201584:	08000793          	li	a5,128
ffffffffc0201588:	16a7f563          	bgeu	a5,a0,ffffffffc02016f2 <slub_alloc+0x188>
ffffffffc020158c:	10000793          	li	a5,256
ffffffffc0201590:	00a7fe63          	bgeu	a5,a0,ffffffffc02015ac <slub_alloc+0x42>
    // 1. 匹配尺寸类（无匹配返回NULL）
    SlubLevel level = size_to_level(size);
    if (level >= SLUB_LEVEL_CNT) {
        return NULL;
ffffffffc0201594:	4501                	li	a0,0

    // 3. 无空闲slab，新建一个（新slab全空闲，首次分配必成功）
    slab_t *new_s = new_slab(level);
    if (!new_s) return NULL;
    return slab_alloc_from(new_s);
}
ffffffffc0201596:	70e2                	ld	ra,56(sp)
ffffffffc0201598:	7442                	ld	s0,48(sp)
ffffffffc020159a:	74a2                	ld	s1,40(sp)
ffffffffc020159c:	7902                	ld	s2,32(sp)
ffffffffc020159e:	69e2                	ld	s3,24(sp)
ffffffffc02015a0:	6a42                	ld	s4,16(sp)
ffffffffc02015a2:	6aa2                	ld	s5,8(sp)
ffffffffc02015a4:	6121                	addi	sp,sp,64
ffffffffc02015a6:	8082                	ret
        return NULL;
ffffffffc02015a8:	4501                	li	a0,0
}
ffffffffc02015aa:	8082                	ret
        if (size <= SLUB_OBJ_SIZES[i]) {
ffffffffc02015ac:	4989                	li	s3,2
ffffffffc02015ae:	00026497          	auipc	s1,0x26
ffffffffc02015b2:	aa248493          	addi	s1,s1,-1374 # ffffffffc0227050 <slab_lists+0x20>
ffffffffc02015b6:	00026a17          	auipc	s4,0x26
ffffffffc02015ba:	a7aa0a13          	addi	s4,s4,-1414 # ffffffffc0227030 <slab_lists>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc02015be:	00499793          	slli	a5,s3,0x4
ffffffffc02015c2:	97d2                	add	a5,a5,s4
ffffffffc02015c4:	6780                	ld	s0,8(a5)
ffffffffc02015c6:	02099913          	slli	s2,s3,0x20
ffffffffc02015ca:	02095913          	srli	s2,s2,0x20
    while ((le = list_next(le)) != &slab_lists[level]) {
ffffffffc02015ce:	00848b63          	beq	s1,s0,ffffffffc02015e4 <slub_alloc+0x7a>
        if (s->free_cnt == 0) continue;
ffffffffc02015d2:	6c1c                	ld	a5,24(s0)
ffffffffc02015d4:	c789                	beqz	a5,ffffffffc02015de <slub_alloc+0x74>
        void *obj = slab_alloc_from(s);
ffffffffc02015d6:	8522                	mv	a0,s0
ffffffffc02015d8:	e93ff0ef          	jal	ra,ffffffffc020146a <slab_alloc_from>
        if (obj != NULL) {
ffffffffc02015dc:	fd4d                	bnez	a0,ffffffffc0201596 <slub_alloc+0x2c>
ffffffffc02015de:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != &slab_lists[level]) {
ffffffffc02015e0:	fe8499e3          	bne	s1,s0,ffffffffc02015d2 <slub_alloc+0x68>
    struct Page *pg = alloc_pages(1); // 向伙伴系统申请1页
ffffffffc02015e4:	4505                	li	a0,1
ffffffffc02015e6:	c8dff0ef          	jal	ra,ffffffffc0201272 <alloc_pages>
ffffffffc02015ea:	8aaa                	mv	s5,a0
    if (!pg) return NULL;
ffffffffc02015ec:	d545                	beqz	a0,ffffffffc0201594 <slub_alloc+0x2a>
static inline uintptr_t kva2pa(const void *kva) { return PADDR(kva); }

/* ---------------------------------------------------------------------------
 * Page/PPN/PA 工具
 * --------------------------------------------------------------------------- */
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02015ee:	00026697          	auipc	a3,0x26
ffffffffc02015f2:	a926b683          	ld	a3,-1390(a3) # ffffffffc0227080 <pages>
ffffffffc02015f6:	40d506b3          	sub	a3,a0,a3
ffffffffc02015fa:	00002797          	auipc	a5,0x2
ffffffffc02015fe:	3667b783          	ld	a5,870(a5) # ffffffffc0203960 <error_string+0x38>
ffffffffc0201602:	868d                	srai	a3,a3,0x3
ffffffffc0201604:	02f686b3          	mul	a3,a3,a5
ffffffffc0201608:	00002417          	auipc	s0,0x2
ffffffffc020160c:	36043403          	ld	s0,864(s0) # ffffffffc0203968 <nbase>
    return KADDR(page2pa(p));
ffffffffc0201610:	00026717          	auipc	a4,0x26
ffffffffc0201614:	a6873703          	ld	a4,-1432(a4) # ffffffffc0227078 <npage>
ffffffffc0201618:	96a2                	add	a3,a3,s0
ffffffffc020161a:	00c69793          	slli	a5,a3,0xc
ffffffffc020161e:	83b1                	srli	a5,a5,0xc

static inline uintptr_t page2pa(struct Page *page) {
    return ((uintptr_t)page2ppn(page)) << PGSHIFT;
ffffffffc0201620:	06b2                	slli	a3,a3,0xc
ffffffffc0201622:	0ee7ff63          	bgeu	a5,a4,ffffffffc0201720 <slub_alloc+0x1b6>
ffffffffc0201626:	00026417          	auipc	s0,0x26
ffffffffc020162a:	a7a43403          	ld	s0,-1414(s0) # ffffffffc02270a0 <va_pa_offset>
ffffffffc020162e:	9436                	add	s0,s0,a3
    memset(kva, 0, PGSIZE); // 清空整页（避免残留数据）
ffffffffc0201630:	6605                	lui	a2,0x1
ffffffffc0201632:	4581                	li	a1,0
ffffffffc0201634:	8522                	mv	a0,s0
ffffffffc0201636:	28b000ef          	jal	ra,ffffffffc02020c0 <memset>
    size_t obj_size = SLUB_OBJ_SIZES[level];
ffffffffc020163a:	00391713          	slli	a4,s2,0x3
ffffffffc020163e:	00002797          	auipc	a5,0x2
ffffffffc0201642:	0c278793          	addi	a5,a5,194 # ffffffffc0203700 <SLUB_OBJ_SIZES>
ffffffffc0201646:	97ba                	add	a5,a5,a4
ffffffffc0201648:	0007b803          	ld	a6,0(a5)
    size_t max_objs = (PGSIZE - sizeof(slab_t)) / obj_size; // 初始估算（未扣位图）
ffffffffc020164c:	6785                	lui	a5,0x1
ffffffffc020164e:	fd078693          	addi	a3,a5,-48 # fd0 <kern_entry-0xffffffffc01ff030>
    elm->prev = elm->next = elm;
ffffffffc0201652:	e400                	sd	s0,8(s0)
ffffffffc0201654:	e000                	sd	s0,0(s0)
    s->page = pg;
ffffffffc0201656:	01543823          	sd	s5,16(s0)
    s->level = level;
ffffffffc020165a:	03342623          	sw	s3,44(s0)
    size_t max_objs = (PGSIZE - sizeof(slab_t)) / obj_size; // 初始估算（未扣位图）
ffffffffc020165e:	0306d733          	divu	a4,a3,a6
    while (max_objs > 0) {
ffffffffc0201662:	0b06e263          	bltu	a3,a6,ffffffffc0201706 <slub_alloc+0x19c>
    return (x + y - 1) / y;
ffffffffc0201666:	00770613          	addi	a2,a4,7
ffffffffc020166a:	820d                	srli	a2,a2,0x3
        size_t total_used = sizeof(slab_t) + (max_objs * obj_size) + bitmap_bytes;
ffffffffc020166c:	02e80533          	mul	a0,a6,a4
ffffffffc0201670:	03050513          	addi	a0,a0,48
ffffffffc0201674:	00a606b3          	add	a3,a2,a0
        if (total_used <= PGSIZE) {
ffffffffc0201678:	02d7f863          	bgeu	a5,a3,ffffffffc02016a8 <slub_alloc+0x13e>
ffffffffc020167c:	fff70693          	addi	a3,a4,-1
ffffffffc0201680:	03068533          	mul	a0,a3,a6
ffffffffc0201684:	6885                	lui	a7,0x1
ffffffffc0201686:	a019                	j	ffffffffc020168c <slub_alloc+0x122>
ffffffffc0201688:	852e                	mv	a0,a1
ffffffffc020168a:	16fd                	addi	a3,a3,-1
        max_objs--; // 超出页大小，减少对象数重试
ffffffffc020168c:	863a                	mv	a2,a4
ffffffffc020168e:	8736                	mv	a4,a3
    while (max_objs > 0) {
ffffffffc0201690:	cabd                	beqz	a3,ffffffffc0201706 <slub_alloc+0x19c>
    return (x + y - 1) / y;
ffffffffc0201692:	0619                	addi	a2,a2,6
ffffffffc0201694:	820d                	srli	a2,a2,0x3
        size_t total_used = sizeof(slab_t) + (max_objs * obj_size) + bitmap_bytes;
ffffffffc0201696:	03060793          	addi	a5,a2,48 # 1030 <kern_entry-0xffffffffc01fefd0>
ffffffffc020169a:	97aa                	add	a5,a5,a0
        if (total_used <= PGSIZE) {
ffffffffc020169c:	410505b3          	sub	a1,a0,a6
ffffffffc02016a0:	fef8e4e3          	bltu	a7,a5,ffffffffc0201688 <slub_alloc+0x11e>
ffffffffc02016a4:	03050513          	addi	a0,a0,48
    s->magic = SLUB_MAGIC;
ffffffffc02016a8:	51ab57b7          	lui	a5,0x51ab5
ffffffffc02016ac:	1ab78793          	addi	a5,a5,427 # 51ab51ab <kern_entry-0xffffffff6e74ae55>
ffffffffc02016b0:	d41c                	sw	a5,40(s0)
    s->objs = compute_objs_per_slab(level);
ffffffffc02016b2:	f018                	sd	a4,32(s0)
    s->free_cnt = s->objs; // 新建slab全为空闲
ffffffffc02016b4:	ec18                	sd	a4,24(s0)
    memset(slab_bitmap(s), 0, bitmap_bytes);
ffffffffc02016b6:	9522                	add	a0,a0,s0
    __list_add(elm, listelm, listelm->next);
ffffffffc02016b8:	0912                	slli	s2,s2,0x4
ffffffffc02016ba:	4581                	li	a1,0
ffffffffc02016bc:	205000ef          	jal	ra,ffffffffc02020c0 <memset>
ffffffffc02016c0:	9a4a                	add	s4,s4,s2
ffffffffc02016c2:	008a3783          	ld	a5,8(s4)
    return slab_alloc_from(new_s);
ffffffffc02016c6:	8522                	mv	a0,s0
}
ffffffffc02016c8:	70e2                	ld	ra,56(sp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02016ca:	e380                	sd	s0,0(a5)
ffffffffc02016cc:	008a3423          	sd	s0,8(s4)
    elm->next = next;
    elm->prev = prev;
ffffffffc02016d0:	e004                	sd	s1,0(s0)
    elm->next = next;
ffffffffc02016d2:	e41c                	sd	a5,8(s0)
ffffffffc02016d4:	7442                	ld	s0,48(sp)
ffffffffc02016d6:	74a2                	ld	s1,40(sp)
ffffffffc02016d8:	7902                	ld	s2,32(sp)
ffffffffc02016da:	69e2                	ld	s3,24(sp)
ffffffffc02016dc:	6a42                	ld	s4,16(sp)
ffffffffc02016de:	6aa2                	ld	s5,8(sp)
ffffffffc02016e0:	6121                	addi	sp,sp,64
    return slab_alloc_from(new_s);
ffffffffc02016e2:	b361                	j	ffffffffc020146a <slab_alloc_from>
        if (size <= SLUB_OBJ_SIZES[i]) {
ffffffffc02016e4:	00026a17          	auipc	s4,0x26
ffffffffc02016e8:	94ca0a13          	addi	s4,s4,-1716 # ffffffffc0227030 <slab_lists>
ffffffffc02016ec:	4981                	li	s3,0
ffffffffc02016ee:	84d2                	mv	s1,s4
ffffffffc02016f0:	b5f9                	j	ffffffffc02015be <slub_alloc+0x54>
ffffffffc02016f2:	4985                	li	s3,1
ffffffffc02016f4:	00026497          	auipc	s1,0x26
ffffffffc02016f8:	94c48493          	addi	s1,s1,-1716 # ffffffffc0227040 <slab_lists+0x10>
ffffffffc02016fc:	00026a17          	auipc	s4,0x26
ffffffffc0201700:	934a0a13          	addi	s4,s4,-1740 # ffffffffc0227030 <slab_lists>
ffffffffc0201704:	bd6d                	j	ffffffffc02015be <slub_alloc+0x54>
    panic("compute_objs_per_slab: no space for level %d", level);
ffffffffc0201706:	86ce                	mv	a3,s3
ffffffffc0201708:	00002617          	auipc	a2,0x2
ffffffffc020170c:	c9060613          	addi	a2,a2,-880 # ffffffffc0203398 <buddy_pmm_manager+0x180>
ffffffffc0201710:	05800593          	li	a1,88
ffffffffc0201714:	00002517          	auipc	a0,0x2
ffffffffc0201718:	c7450513          	addi	a0,a0,-908 # ffffffffc0203388 <buddy_pmm_manager+0x170>
ffffffffc020171c:	aa7fe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    return KADDR(page2pa(p));
ffffffffc0201720:	00002617          	auipc	a2,0x2
ffffffffc0201724:	c4060613          	addi	a2,a2,-960 # ffffffffc0203360 <buddy_pmm_manager+0x148>
ffffffffc0201728:	03200593          	li	a1,50
ffffffffc020172c:	00002517          	auipc	a0,0x2
ffffffffc0201730:	c5c50513          	addi	a0,a0,-932 # ffffffffc0203388 <buddy_pmm_manager+0x170>
ffffffffc0201734:	a8ffe0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0201738 <slub_free>:

// SLUB释放：定位slab和级别，释放对象，全空时归还页
void slub_free(void *obj) {
ffffffffc0201738:	85aa                	mv	a1,a0
    if (!obj) return;
ffffffffc020173a:	cd2d                	beqz	a0,ffffffffc02017b4 <slub_free+0x7c>

    // 1. 按页对齐定位slab头（4096字节对齐）
    uintptr_t slab_kva = (uintptr_t)obj & ~(PGSIZE - 1);
ffffffffc020173c:	77fd                	lui	a5,0xfffff
ffffffffc020173e:	8fe9                	and	a5,a5,a0
    slab_t *s = (slab_t *)slab_kva;

    // 2. 基础合法性校验
    if (s->magic != SLUB_MAGIC) {
ffffffffc0201740:	5794                	lw	a3,40(a5)
ffffffffc0201742:	51ab5737          	lui	a4,0x51ab5
ffffffffc0201746:	1ab70713          	addi	a4,a4,427 # 51ab51ab <kern_entry-0xffffffff6e74ae55>
ffffffffc020174a:	06e69663          	bne	a3,a4,ffffffffc02017b6 <slub_free+0x7e>
        cprintf("slub_free: bad obj %p (invalid magic)\n", obj);
        return;
    }
    if (s->level >= SLUB_LEVEL_CNT) {
ffffffffc020174e:	57d8                	lw	a4,44(a5)
ffffffffc0201750:	4689                	li	a3,2
ffffffffc0201752:	06e6e863          	bltu	a3,a4,ffffffffc02017c2 <slub_free+0x8a>
        cprintf("slub_free: bad obj %p (invalid level)\n", obj);
        return;
    }

    // 3. 对象边界与对齐校验（确保在对象区内且按级别尺寸对齐）
    size_t obj_size = SLUB_OBJ_SIZES[s->level];
ffffffffc0201756:	02071693          	slli	a3,a4,0x20
ffffffffc020175a:	01d6d713          	srli	a4,a3,0x1d
ffffffffc020175e:	00002697          	auipc	a3,0x2
ffffffffc0201762:	fa268693          	addi	a3,a3,-94 # ffffffffc0203700 <SLUB_OBJ_SIZES>
ffffffffc0201766:	9736                	add	a4,a4,a3
ffffffffc0201768:	6310                	ld	a2,0(a4)
    char *obj_base = slab_objs_base(s);
    size_t obj_offset = (size_t)((char *)obj - obj_base);
    if (obj_offset >= (s->objs * obj_size)) {
ffffffffc020176a:	7398                	ld	a4,32(a5)
    return (char *)s + sizeof(slab_t);
ffffffffc020176c:	03078693          	addi	a3,a5,48 # fffffffffffff030 <end+0x3fdd7f88>
    size_t obj_offset = (size_t)((char *)obj - obj_base);
ffffffffc0201770:	40d506b3          	sub	a3,a0,a3
    if (obj_offset >= (s->objs * obj_size)) {
ffffffffc0201774:	02e60733          	mul	a4,a2,a4
ffffffffc0201778:	06e6f163          	bgeu	a3,a4,ffffffffc02017da <slub_free+0xa2>
        cprintf("slub_free: bad obj %p (out of slab range)\n", obj);
        return;
    }
    if ((obj_offset % obj_size) != 0) {
ffffffffc020177c:	02c6f533          	remu	a0,a3,a2
ffffffffc0201780:	e539                	bnez	a0,ffffffffc02017ce <slub_free+0x96>
    size_t obj_idx = obj_offset / obj_size;
ffffffffc0201782:	02c6d6b3          	divu	a3,a3,a2
    bm[byte_idx] &= ~(1 << bit_idx);
ffffffffc0201786:	03070713          	addi	a4,a4,48
    size_t byte_idx = obj_idx / 8;
ffffffffc020178a:	0036d613          	srli	a2,a3,0x3
    bm[byte_idx] &= ~(1 << bit_idx);
ffffffffc020178e:	9732                	add	a4,a4,a2
ffffffffc0201790:	973e                	add	a4,a4,a5
ffffffffc0201792:	00074583          	lbu	a1,0(a4)
    size_t bit_idx = obj_idx % 8;
ffffffffc0201796:	8a9d                	andi	a3,a3,7
    bm[byte_idx] &= ~(1 << bit_idx);
ffffffffc0201798:	4605                	li	a2,1
ffffffffc020179a:	00d616bb          	sllw	a3,a2,a3
ffffffffc020179e:	fff6c693          	not	a3,a3
ffffffffc02017a2:	8eed                	and	a3,a3,a1
ffffffffc02017a4:	00d70023          	sb	a3,0(a4)
    s->free_cnt++; // 空闲数+1
ffffffffc02017a8:	6f98                	ld	a4,24(a5)

    // 4. 释放对象到slab
    slab_free_to(s, obj);

    // 5. 若slab全空闲，从链表删除并归还页给伙伴系统
    if (s->free_cnt == s->objs) {
ffffffffc02017aa:	7394                	ld	a3,32(a5)
    s->free_cnt++; // 空闲数+1
ffffffffc02017ac:	0705                	addi	a4,a4,1
ffffffffc02017ae:	ef98                	sd	a4,24(a5)
    if (s->free_cnt == s->objs) {
ffffffffc02017b0:	02e68b63          	beq	a3,a4,ffffffffc02017e6 <slub_free+0xae>
        list_del(&s->link);
        free_pages(s->page, 1);
    }
}
ffffffffc02017b4:	8082                	ret
        cprintf("slub_free: bad obj %p (invalid magic)\n", obj);
ffffffffc02017b6:	00002517          	auipc	a0,0x2
ffffffffc02017ba:	c1250513          	addi	a0,a0,-1006 # ffffffffc02033c8 <buddy_pmm_manager+0x1b0>
ffffffffc02017be:	98ffe06f          	j	ffffffffc020014c <cprintf>
        cprintf("slub_free: bad obj %p (invalid level)\n", obj);
ffffffffc02017c2:	00002517          	auipc	a0,0x2
ffffffffc02017c6:	c2e50513          	addi	a0,a0,-978 # ffffffffc02033f0 <buddy_pmm_manager+0x1d8>
ffffffffc02017ca:	983fe06f          	j	ffffffffc020014c <cprintf>
        cprintf("slub_free: bad obj %p (misaligned)\n", obj);
ffffffffc02017ce:	00002517          	auipc	a0,0x2
ffffffffc02017d2:	c7a50513          	addi	a0,a0,-902 # ffffffffc0203448 <buddy_pmm_manager+0x230>
ffffffffc02017d6:	977fe06f          	j	ffffffffc020014c <cprintf>
        cprintf("slub_free: bad obj %p (out of slab range)\n", obj);
ffffffffc02017da:	00002517          	auipc	a0,0x2
ffffffffc02017de:	c3e50513          	addi	a0,a0,-962 # ffffffffc0203418 <buddy_pmm_manager+0x200>
ffffffffc02017e2:	96bfe06f          	j	ffffffffc020014c <cprintf>
    __list_del(listelm->prev, listelm->next);
ffffffffc02017e6:	6394                	ld	a3,0(a5)
ffffffffc02017e8:	6798                	ld	a4,8(a5)
        free_pages(s->page, 1);
ffffffffc02017ea:	6b88                	ld	a0,16(a5)
ffffffffc02017ec:	4585                	li	a1,1
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02017ee:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc02017f0:	e314                	sd	a3,0(a4)
ffffffffc02017f2:	b471                	j	ffffffffc020127e <free_pages>

ffffffffc02017f4 <kmalloc>:

// ------- 对外内存分配接口（整合SLUB与伙伴系统） -------
// kmalloc：小对象走SLUB，大对象（>256B）走伙伴系统多页分配
void *kmalloc(size_t size) {
    if (size == 0) return NULL;
ffffffffc02017f4:	c96d                	beqz	a0,ffffffffc02018e6 <kmalloc+0xf2>
        if (size <= SLUB_OBJ_SIZES[i]) {
ffffffffc02017f6:	10000713          	li	a4,256
ffffffffc02017fa:	0ea77563          	bgeu	a4,a0,ffffffffc02018e4 <kmalloc+0xf0>
void *kmalloc(size_t size) {
ffffffffc02017fe:	1141                	addi	sp,sp,-16
ffffffffc0201800:	e022                	sd	s0,0(sp)
    return (x + y - 1) / y;
ffffffffc0201802:	6405                	lui	s0,0x1
ffffffffc0201804:	043d                	addi	s0,s0,15
ffffffffc0201806:	008507b3          	add	a5,a0,s0
ffffffffc020180a:	00c7d413          	srli	s0,a5,0xc

    // 2. 大对象：按页分配（需加头部记录页信息）
    size_t total_need = size + sizeof(BigAllocHeader); // 总需求=用户大小+头部
    size_t npages = ceil_div(total_need, PGSIZE);     // 计算需要的页数

    struct Page *pg = alloc_pages(npages);
ffffffffc020180e:	8522                	mv	a0,s0
void *kmalloc(size_t size) {
ffffffffc0201810:	e406                	sd	ra,8(sp)
    struct Page *pg = alloc_pages(npages);
ffffffffc0201812:	a61ff0ef          	jal	ra,ffffffffc0201272 <alloc_pages>
    if (!pg) return NULL;
ffffffffc0201816:	c171                	beqz	a0,ffffffffc02018da <kmalloc+0xe6>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201818:	00026697          	auipc	a3,0x26
ffffffffc020181c:	8686b683          	ld	a3,-1944(a3) # ffffffffc0227080 <pages>
ffffffffc0201820:	40d506b3          	sub	a3,a0,a3
ffffffffc0201824:	00002797          	auipc	a5,0x2
ffffffffc0201828:	13c7b783          	ld	a5,316(a5) # ffffffffc0203960 <error_string+0x38>
ffffffffc020182c:	868d                	srai	a3,a3,0x3
ffffffffc020182e:	02f686b3          	mul	a3,a3,a5
ffffffffc0201832:	00002797          	auipc	a5,0x2
ffffffffc0201836:	1367b783          	ld	a5,310(a5) # ffffffffc0203968 <nbase>
    return KADDR(page2pa(p));
ffffffffc020183a:	00026717          	auipc	a4,0x26
ffffffffc020183e:	83e73703          	ld	a4,-1986(a4) # ffffffffc0227078 <npage>
ffffffffc0201842:	96be                	add	a3,a3,a5
ffffffffc0201844:	00c69793          	slli	a5,a3,0xc
ffffffffc0201848:	83b1                	srli	a5,a5,0xc
    return ((uintptr_t)page2ppn(page)) << PGSHIFT;
ffffffffc020184a:	06b2                	slli	a3,a3,0xc
ffffffffc020184c:	08e7ff63          	bgeu	a5,a4,ffffffffc02018ea <kmalloc+0xf6>
ffffffffc0201850:	00026797          	auipc	a5,0x26
ffffffffc0201854:	8507b783          	ld	a5,-1968(a5) # ffffffffc02270a0 <va_pa_offset>
ffffffffc0201858:	96be                	add	a3,a3,a5

    // 初始化头部，用户地址从头部后开始
    void *kva = page_kva(pg);
    BigAllocHeader *h = (BigAllocHeader *)kva;
    h->magic = BIG_MAGIC;
ffffffffc020185a:	fb500f93          	li	t6,-75
    h->npages = (uint32_t)npages;
    h->first = pg;

    return (void *)(h + 1); // 返回用户可用地址
}
ffffffffc020185e:	60a2                	ld	ra,8(sp)
    h->npages = (uint32_t)npages;
ffffffffc0201860:	00845f1b          	srliw	t5,s0,0x8
ffffffffc0201864:	01045e9b          	srliw	t4,s0,0x10
ffffffffc0201868:	01845e1b          	srliw	t3,s0,0x18
    h->magic = BIG_MAGIC;
ffffffffc020186c:	01f68023          	sb	t6,0(a3)
    h->npages = (uint32_t)npages;
ffffffffc0201870:	00868223          	sb	s0,4(a3)
    h->magic = BIG_MAGIC;
ffffffffc0201874:	06b00f93          	li	t6,107
}
ffffffffc0201878:	6402                	ld	s0,0(sp)
    h->first = pg;
ffffffffc020187a:	00855313          	srli	t1,a0,0x8
ffffffffc020187e:	01055893          	srli	a7,a0,0x10
ffffffffc0201882:	0185581b          	srliw	a6,a0,0x18
ffffffffc0201886:	02055593          	srli	a1,a0,0x20
ffffffffc020188a:	02855613          	srli	a2,a0,0x28
ffffffffc020188e:	03055713          	srli	a4,a0,0x30
ffffffffc0201892:	03855793          	srli	a5,a0,0x38
    h->magic = BIG_MAGIC;
ffffffffc0201896:	01f68123          	sb	t6,2(a3)
ffffffffc020189a:	fb100f93          	li	t6,-79
    h->first = pg;
ffffffffc020189e:	00a68423          	sb	a0,8(a3)
    h->magic = BIG_MAGIC;
ffffffffc02018a2:	000680a3          	sb	zero,1(a3)
ffffffffc02018a6:	01f681a3          	sb	t6,3(a3)
    h->npages = (uint32_t)npages;
ffffffffc02018aa:	01e682a3          	sb	t5,5(a3)
ffffffffc02018ae:	01d68323          	sb	t4,6(a3)
ffffffffc02018b2:	01c683a3          	sb	t3,7(a3)
    h->first = pg;
ffffffffc02018b6:	006684a3          	sb	t1,9(a3)
ffffffffc02018ba:	01168523          	sb	a7,10(a3)
ffffffffc02018be:	010685a3          	sb	a6,11(a3)
ffffffffc02018c2:	00b68623          	sb	a1,12(a3)
ffffffffc02018c6:	00c686a3          	sb	a2,13(a3)
ffffffffc02018ca:	00e68723          	sb	a4,14(a3)
ffffffffc02018ce:	00f687a3          	sb	a5,15(a3)
    return (void *)(h + 1); // 返回用户可用地址
ffffffffc02018d2:	01068513          	addi	a0,a3,16
}
ffffffffc02018d6:	0141                	addi	sp,sp,16
ffffffffc02018d8:	8082                	ret
ffffffffc02018da:	60a2                	ld	ra,8(sp)
ffffffffc02018dc:	6402                	ld	s0,0(sp)
    if (size == 0) return NULL;
ffffffffc02018de:	4501                	li	a0,0
}
ffffffffc02018e0:	0141                	addi	sp,sp,16
ffffffffc02018e2:	8082                	ret
        return slub_alloc(size);
ffffffffc02018e4:	b159                	j	ffffffffc020156a <slub_alloc>
    if (size == 0) return NULL;
ffffffffc02018e6:	4501                	li	a0,0
}
ffffffffc02018e8:	8082                	ret
    return KADDR(page2pa(p));
ffffffffc02018ea:	00002617          	auipc	a2,0x2
ffffffffc02018ee:	a7660613          	addi	a2,a2,-1418 # ffffffffc0203360 <buddy_pmm_manager+0x148>
ffffffffc02018f2:	03200593          	li	a1,50
ffffffffc02018f6:	00002517          	auipc	a0,0x2
ffffffffc02018fa:	a9250513          	addi	a0,a0,-1390 # ffffffffc0203388 <buddy_pmm_manager+0x170>
ffffffffc02018fe:	8c5fe0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0201902 <slub_selftest>:
    // 2. 按SLUB小对象释放
    slub_free(ptr);
}

// ------- 自检函数：验证三级分配与释放正确性 -------
void slub_selftest(void) {
ffffffffc0201902:	715d                	addi	sp,sp,-80
    cprintf("\n[slub_selftest] begin\n");
ffffffffc0201904:	00002517          	auipc	a0,0x2
ffffffffc0201908:	b6c50513          	addi	a0,a0,-1172 # ffffffffc0203470 <buddy_pmm_manager+0x258>
void slub_selftest(void) {
ffffffffc020190c:	e486                	sd	ra,72(sp)
ffffffffc020190e:	f84a                	sd	s2,48(sp)
ffffffffc0201910:	f44e                	sd	s3,40(sp)
ffffffffc0201912:	ec56                	sd	s5,24(sp)
ffffffffc0201914:	e85a                	sd	s6,16(sp)
ffffffffc0201916:	e45e                	sd	s7,8(sp)
ffffffffc0201918:	e0a2                	sd	s0,64(sp)
ffffffffc020191a:	fc26                	sd	s1,56(sp)
ffffffffc020191c:	f052                	sd	s4,32(sp)
    cprintf("\n[slub_selftest] begin\n");
ffffffffc020191e:	82ffe0ef          	jal	ra,ffffffffc020014c <cprintf>

    // 1. 测试三级小对象分配（L1=64B, L2=128B, L3=256B）
    void *l1_obj1 = slub_alloc(32);  // 对齐到64B（L1）
ffffffffc0201922:	02000513          	li	a0,32
ffffffffc0201926:	c45ff0ef          	jal	ra,ffffffffc020156a <slub_alloc>
ffffffffc020192a:	8aaa                	mv	s5,a0
    void *l1_obj2 = slub_alloc(64);  // 正好64B（L1）
ffffffffc020192c:	04000513          	li	a0,64
ffffffffc0201930:	c3bff0ef          	jal	ra,ffffffffc020156a <slub_alloc>
ffffffffc0201934:	89aa                	mv	s3,a0
    void *l2_obj1 = slub_alloc(80);  // 对齐到128B（L2）
ffffffffc0201936:	05000513          	li	a0,80
ffffffffc020193a:	c31ff0ef          	jal	ra,ffffffffc020156a <slub_alloc>
ffffffffc020193e:	892a                	mv	s2,a0
    void *l2_obj2 = slub_alloc(128); // 正好128B（L2）
ffffffffc0201940:	08000513          	li	a0,128
ffffffffc0201944:	c27ff0ef          	jal	ra,ffffffffc020156a <slub_alloc>
ffffffffc0201948:	8baa                	mv	s7,a0
    void *l3_obj1 = slub_alloc(160); // 对齐到256B（L3）
ffffffffc020194a:	0a000513          	li	a0,160
ffffffffc020194e:	c1dff0ef          	jal	ra,ffffffffc020156a <slub_alloc>
ffffffffc0201952:	8b2a                	mv	s6,a0
    void *l3_obj2 = slub_alloc(256); // 正好256B（L3）
ffffffffc0201954:	10000513          	li	a0,256
ffffffffc0201958:	c13ff0ef          	jal	ra,ffffffffc020156a <slub_alloc>

    // 校验分配成功
    assert(l1_obj1 && l1_obj2 && l2_obj1 && l2_obj2 && l3_obj1 && l3_obj2);
ffffffffc020195c:	260a8163          	beqz	s5,ffffffffc0201bbe <slub_selftest+0x2bc>
ffffffffc0201960:	24098f63          	beqz	s3,ffffffffc0201bbe <slub_selftest+0x2bc>
ffffffffc0201964:	24090d63          	beqz	s2,ffffffffc0201bbe <slub_selftest+0x2bc>
ffffffffc0201968:	240b8b63          	beqz	s7,ffffffffc0201bbe <slub_selftest+0x2bc>
ffffffffc020196c:	240b0963          	beqz	s6,ffffffffc0201bbe <slub_selftest+0x2bc>
ffffffffc0201970:	8a2a                	mv	s4,a0
ffffffffc0201972:	24050663          	beqz	a0,ffffffffc0201bbe <slub_selftest+0x2bc>
    cprintf("L1 objs: %p (32B→64B), %p (64B)\n", l1_obj1, l1_obj2);
ffffffffc0201976:	864e                	mv	a2,s3
ffffffffc0201978:	85d6                	mv	a1,s5
ffffffffc020197a:	00002517          	auipc	a0,0x2
ffffffffc020197e:	b4e50513          	addi	a0,a0,-1202 # ffffffffc02034c8 <buddy_pmm_manager+0x2b0>
ffffffffc0201982:	fcafe0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("L2 objs: %p (80B→128B), %p (128B)\n", l2_obj1, l2_obj2);
ffffffffc0201986:	865e                	mv	a2,s7
ffffffffc0201988:	85ca                	mv	a1,s2
ffffffffc020198a:	00002517          	auipc	a0,0x2
ffffffffc020198e:	b6650513          	addi	a0,a0,-1178 # ffffffffc02034f0 <buddy_pmm_manager+0x2d8>
ffffffffc0201992:	fbafe0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("L3 objs: %p (160B→256B), %p (256B)\n", l3_obj1, l3_obj2);
ffffffffc0201996:	8652                	mv	a2,s4
ffffffffc0201998:	85da                	mv	a1,s6
ffffffffc020199a:	00002517          	auipc	a0,0x2
ffffffffc020199e:	b7e50513          	addi	a0,a0,-1154 # ffffffffc0203518 <buddy_pmm_manager+0x300>
ffffffffc02019a2:	faafe0ef          	jal	ra,ffffffffc020014c <cprintf>

    // 2. 测试大对象分配（>256B，走伙伴系统）
    size_t big_size = 512; // 超过256B，按页分配（1页足够）
    void *big_obj = kmalloc(big_size);
ffffffffc02019a6:	20000513          	li	a0,512
ffffffffc02019aa:	e4bff0ef          	jal	ra,ffffffffc02017f4 <kmalloc>
ffffffffc02019ae:	842a                	mv	s0,a0
    assert(big_obj != NULL);
ffffffffc02019b0:	26050763          	beqz	a0,ffffffffc0201c1e <slub_selftest+0x31c>
    BigAllocHeader *big_h = (BigAllocHeader *)((char *)big_obj - sizeof(BigAllocHeader));
    assert(big_h->magic == BIG_MAGIC && big_h->npages == 1);
ffffffffc02019b4:	ff154703          	lbu	a4,-15(a0)
ffffffffc02019b8:	ff054683          	lbu	a3,-16(a0)
ffffffffc02019bc:	ff254783          	lbu	a5,-14(a0)
ffffffffc02019c0:	ff354483          	lbu	s1,-13(a0)
ffffffffc02019c4:	0722                	slli	a4,a4,0x8
ffffffffc02019c6:	8f55                	or	a4,a4,a3
ffffffffc02019c8:	07c2                	slli	a5,a5,0x10
ffffffffc02019ca:	8fd9                	or	a5,a5,a4
ffffffffc02019cc:	04e2                	slli	s1,s1,0x18
ffffffffc02019ce:	8cdd                	or	s1,s1,a5
ffffffffc02019d0:	b16b07b7          	lui	a5,0xb16b0
ffffffffc02019d4:	2481                	sext.w	s1,s1
ffffffffc02019d6:	0b578793          	addi	a5,a5,181 # ffffffffb16b00b5 <kern_entry-0xeb4ff4b>
ffffffffc02019da:	20f49263          	bne	s1,a5,ffffffffc0201bde <slub_selftest+0x2dc>
ffffffffc02019de:	ff554683          	lbu	a3,-11(a0)
ffffffffc02019e2:	ff454603          	lbu	a2,-12(a0)
ffffffffc02019e6:	ff654703          	lbu	a4,-10(a0)
ffffffffc02019ea:	ff754783          	lbu	a5,-9(a0)
ffffffffc02019ee:	06a2                	slli	a3,a3,0x8
ffffffffc02019f0:	8ed1                	or	a3,a3,a2
ffffffffc02019f2:	0742                	slli	a4,a4,0x10
ffffffffc02019f4:	8f55                	or	a4,a4,a3
ffffffffc02019f6:	07e2                	slli	a5,a5,0x18
ffffffffc02019f8:	8fd9                	or	a5,a5,a4
ffffffffc02019fa:	2781                	sext.w	a5,a5
ffffffffc02019fc:	4705                	li	a4,1
ffffffffc02019fe:	1ee79063          	bne	a5,a4,ffffffffc0201bde <slub_selftest+0x2dc>
    cprintf("Big obj: %p (512B), pages=%u\n", big_obj, big_h->npages);
ffffffffc0201a02:	4605                	li	a2,1
ffffffffc0201a04:	85aa                	mv	a1,a0
ffffffffc0201a06:	00002517          	auipc	a0,0x2
ffffffffc0201a0a:	b7a50513          	addi	a0,a0,-1158 # ffffffffc0203580 <buddy_pmm_manager+0x368>
ffffffffc0201a0e:	f3efe0ef          	jal	ra,ffffffffc020014c <cprintf>

    // 3. 测试释放（顺序无关，校验slab回收）
    slub_free(l1_obj1);
ffffffffc0201a12:	8556                	mv	a0,s5
ffffffffc0201a14:	d25ff0ef          	jal	ra,ffffffffc0201738 <slub_free>
    slub_free(l2_obj2);
ffffffffc0201a18:	855e                	mv	a0,s7
ffffffffc0201a1a:	d1fff0ef          	jal	ra,ffffffffc0201738 <slub_free>
    slub_free(l3_obj1);
ffffffffc0201a1e:	855a                	mv	a0,s6
ffffffffc0201a20:	d19ff0ef          	jal	ra,ffffffffc0201738 <slub_free>
    if (h->magic == BIG_MAGIC && h->first != NULL && h->npages > 0) {
ffffffffc0201a24:	ff144683          	lbu	a3,-15(s0) # ff1 <kern_entry-0xffffffffc01ff00f>
ffffffffc0201a28:	ff044603          	lbu	a2,-16(s0)
ffffffffc0201a2c:	ff244703          	lbu	a4,-14(s0)
ffffffffc0201a30:	ff344783          	lbu	a5,-13(s0)
ffffffffc0201a34:	06a2                	slli	a3,a3,0x8
ffffffffc0201a36:	8ed1                	or	a3,a3,a2
ffffffffc0201a38:	0742                	slli	a4,a4,0x10
ffffffffc0201a3a:	8f55                	or	a4,a4,a3
ffffffffc0201a3c:	07e2                	slli	a5,a5,0x18
ffffffffc0201a3e:	8fd9                	or	a5,a5,a4
ffffffffc0201a40:	2781                	sext.w	a5,a5
ffffffffc0201a42:	06979363          	bne	a5,s1,ffffffffc0201aa8 <slub_selftest+0x1a6>
ffffffffc0201a46:	ff944503          	lbu	a0,-7(s0)
ffffffffc0201a4a:	ff844783          	lbu	a5,-8(s0)
ffffffffc0201a4e:	ffa44583          	lbu	a1,-6(s0)
ffffffffc0201a52:	ffb44603          	lbu	a2,-5(s0)
ffffffffc0201a56:	ffc44683          	lbu	a3,-4(s0)
ffffffffc0201a5a:	0522                	slli	a0,a0,0x8
ffffffffc0201a5c:	8d5d                	or	a0,a0,a5
ffffffffc0201a5e:	ffd44703          	lbu	a4,-3(s0)
ffffffffc0201a62:	05c2                	slli	a1,a1,0x10
ffffffffc0201a64:	8dc9                	or	a1,a1,a0
ffffffffc0201a66:	ffe44783          	lbu	a5,-2(s0)
ffffffffc0201a6a:	0662                	slli	a2,a2,0x18
ffffffffc0201a6c:	fff44503          	lbu	a0,-1(s0)
ffffffffc0201a70:	8e4d                	or	a2,a2,a1
ffffffffc0201a72:	1682                	slli	a3,a3,0x20
ffffffffc0201a74:	8ed1                	or	a3,a3,a2
ffffffffc0201a76:	1722                	slli	a4,a4,0x28
ffffffffc0201a78:	8f55                	or	a4,a4,a3
ffffffffc0201a7a:	17c2                	slli	a5,a5,0x30
ffffffffc0201a7c:	8fd9                	or	a5,a5,a4
ffffffffc0201a7e:	1562                	slli	a0,a0,0x38
ffffffffc0201a80:	8d5d                	or	a0,a0,a5
ffffffffc0201a82:	c11d                	beqz	a0,ffffffffc0201aa8 <slub_selftest+0x1a6>
ffffffffc0201a84:	ff544683          	lbu	a3,-11(s0)
ffffffffc0201a88:	ff444603          	lbu	a2,-12(s0)
ffffffffc0201a8c:	ff644703          	lbu	a4,-10(s0)
ffffffffc0201a90:	ff744783          	lbu	a5,-9(s0)
ffffffffc0201a94:	06a2                	slli	a3,a3,0x8
ffffffffc0201a96:	8ed1                	or	a3,a3,a2
ffffffffc0201a98:	0742                	slli	a4,a4,0x10
ffffffffc0201a9a:	8f55                	or	a4,a4,a3
ffffffffc0201a9c:	07e2                	slli	a5,a5,0x18
ffffffffc0201a9e:	8fd9                	or	a5,a5,a4
ffffffffc0201aa0:	0007859b          	sext.w	a1,a5
ffffffffc0201aa4:	10079863          	bnez	a5,ffffffffc0201bb4 <slub_selftest+0x2b2>
    slub_free(ptr);
ffffffffc0201aa8:	8522                	mv	a0,s0
ffffffffc0201aaa:	c8fff0ef          	jal	ra,ffffffffc0201738 <slub_free>
    kfree(big_obj); // 大对象释放
    slub_free(l1_obj2);
ffffffffc0201aae:	854e                	mv	a0,s3
ffffffffc0201ab0:	c89ff0ef          	jal	ra,ffffffffc0201738 <slub_free>
    slub_free(l2_obj1);
ffffffffc0201ab4:	854a                	mv	a0,s2
ffffffffc0201ab6:	c83ff0ef          	jal	ra,ffffffffc0201738 <slub_free>
    slub_free(l3_obj2);
ffffffffc0201aba:	8552                	mv	a0,s4
ffffffffc0201abc:	c7dff0ef          	jal	ra,ffffffffc0201738 <slub_free>
    cprintf("已释放所有对象\n");
ffffffffc0201ac0:	00002517          	auipc	a0,0x2
ffffffffc0201ac4:	ae050513          	addi	a0,a0,-1312 # ffffffffc02035a0 <buddy_pmm_manager+0x388>
ffffffffc0201ac8:	e84fe0ef          	jal	ra,ffffffffc020014c <cprintf>

    // 4. 验证相同大小的块地址在一起
    void *a1 = kmalloc(64);   // 走 L1 (64B slab)
ffffffffc0201acc:	04000513          	li	a0,64
ffffffffc0201ad0:	d25ff0ef          	jal	ra,ffffffffc02017f4 <kmalloc>
ffffffffc0201ad4:	8aaa                	mv	s5,a0
    void *b1 = kmalloc(256);  // 走 L3 (256B slab)
ffffffffc0201ad6:	10000513          	li	a0,256
ffffffffc0201ada:	d1bff0ef          	jal	ra,ffffffffc02017f4 <kmalloc>
ffffffffc0201ade:	8a2a                	mv	s4,a0
    void *a2 = kmalloc(32);   // 走 L1 (还是 64B slab，因为 32 向上取到64B)
ffffffffc0201ae0:	02000513          	li	a0,32
ffffffffc0201ae4:	d11ff0ef          	jal	ra,ffffffffc02017f4 <kmalloc>
ffffffffc0201ae8:	89aa                	mv	s3,a0
    void *c1 = kmalloc(128);
ffffffffc0201aea:	08000513          	li	a0,128
ffffffffc0201aee:	d07ff0ef          	jal	ra,ffffffffc02017f4 <kmalloc>
ffffffffc0201af2:	892a                	mv	s2,a0
    void *b2 = kmalloc(130);
ffffffffc0201af4:	08200513          	li	a0,130
ffffffffc0201af8:	cfdff0ef          	jal	ra,ffffffffc02017f4 <kmalloc>
ffffffffc0201afc:	84aa                	mv	s1,a0
    void *c2 = kmalloc(100);
ffffffffc0201afe:	06400513          	li	a0,100
ffffffffc0201b02:	cf3ff0ef          	jal	ra,ffffffffc02017f4 <kmalloc>
ffffffffc0201b06:	842a                	mv	s0,a0
    cprintf("\n验证相同大小的块地址在一起：\n");
ffffffffc0201b08:	00002517          	auipc	a0,0x2
ffffffffc0201b0c:	ab050513          	addi	a0,a0,-1360 # ffffffffc02035b8 <buddy_pmm_manager+0x3a0>
ffffffffc0201b10:	e3cfe0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("分配顺序：a1(64B), b1(256B), a2(32B), c1(128B), b2(130B), c2(100B)\n");
ffffffffc0201b14:	00002517          	auipc	a0,0x2
ffffffffc0201b18:	ad450513          	addi	a0,a0,-1324 # ffffffffc02035e8 <buddy_pmm_manager+0x3d0>
ffffffffc0201b1c:	e30fe0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("a1 = %p (64B)\n", a1);
ffffffffc0201b20:	85d6                	mv	a1,s5
ffffffffc0201b22:	00002517          	auipc	a0,0x2
ffffffffc0201b26:	b1650513          	addi	a0,a0,-1258 # ffffffffc0203638 <buddy_pmm_manager+0x420>
ffffffffc0201b2a:	e22fe0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("b1 = %p (256B)\n", b1);
ffffffffc0201b2e:	85d2                	mv	a1,s4
ffffffffc0201b30:	00002517          	auipc	a0,0x2
ffffffffc0201b34:	b1850513          	addi	a0,a0,-1256 # ffffffffc0203648 <buddy_pmm_manager+0x430>
ffffffffc0201b38:	e14fe0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("a2 = %p (64B again)\n", a2);
ffffffffc0201b3c:	85ce                	mv	a1,s3
ffffffffc0201b3e:	00002517          	auipc	a0,0x2
ffffffffc0201b42:	b1a50513          	addi	a0,a0,-1254 # ffffffffc0203658 <buddy_pmm_manager+0x440>
ffffffffc0201b46:	e06fe0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("c1 = %p (128B)\n", c1);
ffffffffc0201b4a:	85ca                	mv	a1,s2
ffffffffc0201b4c:	00002517          	auipc	a0,0x2
ffffffffc0201b50:	b2450513          	addi	a0,a0,-1244 # ffffffffc0203670 <buddy_pmm_manager+0x458>
ffffffffc0201b54:	df8fe0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("b2 = %p (256B again)\n", b2);
ffffffffc0201b58:	85a6                	mv	a1,s1
ffffffffc0201b5a:	00002517          	auipc	a0,0x2
ffffffffc0201b5e:	b2650513          	addi	a0,a0,-1242 # ffffffffc0203680 <buddy_pmm_manager+0x468>
ffffffffc0201b62:	deafe0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("c2 = %p (128B again)\n", c2);
ffffffffc0201b66:	85a2                	mv	a1,s0
ffffffffc0201b68:	00002517          	auipc	a0,0x2
ffffffffc0201b6c:	b3050513          	addi	a0,a0,-1232 # ffffffffc0203698 <buddy_pmm_manager+0x480>
ffffffffc0201b70:	ddcfe0ef          	jal	ra,ffffffffc020014c <cprintf>


    // 5. 重复分配测试（验证slab复用）
    void *reuse_obj = slub_alloc(64); // 复用之前释放的L1 slab
ffffffffc0201b74:	04000513          	li	a0,64
ffffffffc0201b78:	9f3ff0ef          	jal	ra,ffffffffc020156a <slub_alloc>
ffffffffc0201b7c:	842a                	mv	s0,a0
    assert(reuse_obj != NULL);
ffffffffc0201b7e:	c141                	beqz	a0,ffffffffc0201bfe <slub_selftest+0x2fc>
    cprintf("Reuse L1 obj: %p (64B)\n", reuse_obj);
ffffffffc0201b80:	85aa                	mv	a1,a0
ffffffffc0201b82:	00002517          	auipc	a0,0x2
ffffffffc0201b86:	b4650513          	addi	a0,a0,-1210 # ffffffffc02036c8 <buddy_pmm_manager+0x4b0>
ffffffffc0201b8a:	dc2fe0ef          	jal	ra,ffffffffc020014c <cprintf>
    slub_free(reuse_obj);
ffffffffc0201b8e:	8522                	mv	a0,s0
ffffffffc0201b90:	ba9ff0ef          	jal	ra,ffffffffc0201738 <slub_free>

    cprintf("[slub_selftest] all ok\n\n");
ffffffffc0201b94:	6406                	ld	s0,64(sp)
ffffffffc0201b96:	60a6                	ld	ra,72(sp)
ffffffffc0201b98:	74e2                	ld	s1,56(sp)
ffffffffc0201b9a:	7942                	ld	s2,48(sp)
ffffffffc0201b9c:	79a2                	ld	s3,40(sp)
ffffffffc0201b9e:	7a02                	ld	s4,32(sp)
ffffffffc0201ba0:	6ae2                	ld	s5,24(sp)
ffffffffc0201ba2:	6b42                	ld	s6,16(sp)
ffffffffc0201ba4:	6ba2                	ld	s7,8(sp)
    cprintf("[slub_selftest] all ok\n\n");
ffffffffc0201ba6:	00002517          	auipc	a0,0x2
ffffffffc0201baa:	b3a50513          	addi	a0,a0,-1222 # ffffffffc02036e0 <buddy_pmm_manager+0x4c8>
ffffffffc0201bae:	6161                	addi	sp,sp,80
    cprintf("[slub_selftest] all ok\n\n");
ffffffffc0201bb0:	d9cfe06f          	j	ffffffffc020014c <cprintf>
        free_pages(h->first, h->npages);
ffffffffc0201bb4:	1582                	slli	a1,a1,0x20
ffffffffc0201bb6:	9181                	srli	a1,a1,0x20
ffffffffc0201bb8:	ec6ff0ef          	jal	ra,ffffffffc020127e <free_pages>
        return;
ffffffffc0201bbc:	bdcd                	j	ffffffffc0201aae <slub_selftest+0x1ac>
    assert(l1_obj1 && l1_obj2 && l2_obj1 && l2_obj2 && l3_obj1 && l3_obj2);
ffffffffc0201bbe:	00002697          	auipc	a3,0x2
ffffffffc0201bc2:	8ca68693          	addi	a3,a3,-1846 # ffffffffc0203488 <buddy_pmm_manager+0x270>
ffffffffc0201bc6:	00000617          	auipc	a2,0x0
ffffffffc0201bca:	79a60613          	addi	a2,a2,1946 # ffffffffc0202360 <etext+0x28e>
ffffffffc0201bce:	13600593          	li	a1,310
ffffffffc0201bd2:	00001517          	auipc	a0,0x1
ffffffffc0201bd6:	7b650513          	addi	a0,a0,1974 # ffffffffc0203388 <buddy_pmm_manager+0x170>
ffffffffc0201bda:	de8fe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(big_h->magic == BIG_MAGIC && big_h->npages == 1);
ffffffffc0201bde:	00002697          	auipc	a3,0x2
ffffffffc0201be2:	97268693          	addi	a3,a3,-1678 # ffffffffc0203550 <buddy_pmm_manager+0x338>
ffffffffc0201be6:	00000617          	auipc	a2,0x0
ffffffffc0201bea:	77a60613          	addi	a2,a2,1914 # ffffffffc0202360 <etext+0x28e>
ffffffffc0201bee:	14000593          	li	a1,320
ffffffffc0201bf2:	00001517          	auipc	a0,0x1
ffffffffc0201bf6:	79650513          	addi	a0,a0,1942 # ffffffffc0203388 <buddy_pmm_manager+0x170>
ffffffffc0201bfa:	dc8fe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(reuse_obj != NULL);
ffffffffc0201bfe:	00002697          	auipc	a3,0x2
ffffffffc0201c02:	ab268693          	addi	a3,a3,-1358 # ffffffffc02036b0 <buddy_pmm_manager+0x498>
ffffffffc0201c06:	00000617          	auipc	a2,0x0
ffffffffc0201c0a:	75a60613          	addi	a2,a2,1882 # ffffffffc0202360 <etext+0x28e>
ffffffffc0201c0e:	16000593          	li	a1,352
ffffffffc0201c12:	00001517          	auipc	a0,0x1
ffffffffc0201c16:	77650513          	addi	a0,a0,1910 # ffffffffc0203388 <buddy_pmm_manager+0x170>
ffffffffc0201c1a:	da8fe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(big_obj != NULL);
ffffffffc0201c1e:	00002697          	auipc	a3,0x2
ffffffffc0201c22:	92268693          	addi	a3,a3,-1758 # ffffffffc0203540 <buddy_pmm_manager+0x328>
ffffffffc0201c26:	00000617          	auipc	a2,0x0
ffffffffc0201c2a:	73a60613          	addi	a2,a2,1850 # ffffffffc0202360 <etext+0x28e>
ffffffffc0201c2e:	13e00593          	li	a1,318
ffffffffc0201c32:	00001517          	auipc	a0,0x1
ffffffffc0201c36:	75650513          	addi	a0,a0,1878 # ffffffffc0203388 <buddy_pmm_manager+0x170>
ffffffffc0201c3a:	d88fe0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0201c3e <printnum>:
ffffffffc0201c3e:	02069813          	slli	a6,a3,0x20
ffffffffc0201c42:	7179                	addi	sp,sp,-48
ffffffffc0201c44:	02085813          	srli	a6,a6,0x20
ffffffffc0201c48:	e052                	sd	s4,0(sp)
ffffffffc0201c4a:	03067a33          	remu	s4,a2,a6
ffffffffc0201c4e:	f022                	sd	s0,32(sp)
ffffffffc0201c50:	ec26                	sd	s1,24(sp)
ffffffffc0201c52:	e84a                	sd	s2,16(sp)
ffffffffc0201c54:	f406                	sd	ra,40(sp)
ffffffffc0201c56:	e44e                	sd	s3,8(sp)
ffffffffc0201c58:	84aa                	mv	s1,a0
ffffffffc0201c5a:	892e                	mv	s2,a1
ffffffffc0201c5c:	fff7041b          	addiw	s0,a4,-1
ffffffffc0201c60:	2a01                	sext.w	s4,s4
ffffffffc0201c62:	03067e63          	bgeu	a2,a6,ffffffffc0201c9e <printnum+0x60>
ffffffffc0201c66:	89be                	mv	s3,a5
ffffffffc0201c68:	00805763          	blez	s0,ffffffffc0201c76 <printnum+0x38>
ffffffffc0201c6c:	347d                	addiw	s0,s0,-1
ffffffffc0201c6e:	85ca                	mv	a1,s2
ffffffffc0201c70:	854e                	mv	a0,s3
ffffffffc0201c72:	9482                	jalr	s1
ffffffffc0201c74:	fc65                	bnez	s0,ffffffffc0201c6c <printnum+0x2e>
ffffffffc0201c76:	1a02                	slli	s4,s4,0x20
ffffffffc0201c78:	00002797          	auipc	a5,0x2
ffffffffc0201c7c:	aa078793          	addi	a5,a5,-1376 # ffffffffc0203718 <SLUB_OBJ_SIZES+0x18>
ffffffffc0201c80:	020a5a13          	srli	s4,s4,0x20
ffffffffc0201c84:	9a3e                	add	s4,s4,a5
ffffffffc0201c86:	7402                	ld	s0,32(sp)
ffffffffc0201c88:	000a4503          	lbu	a0,0(s4)
ffffffffc0201c8c:	70a2                	ld	ra,40(sp)
ffffffffc0201c8e:	69a2                	ld	s3,8(sp)
ffffffffc0201c90:	6a02                	ld	s4,0(sp)
ffffffffc0201c92:	85ca                	mv	a1,s2
ffffffffc0201c94:	87a6                	mv	a5,s1
ffffffffc0201c96:	6942                	ld	s2,16(sp)
ffffffffc0201c98:	64e2                	ld	s1,24(sp)
ffffffffc0201c9a:	6145                	addi	sp,sp,48
ffffffffc0201c9c:	8782                	jr	a5
ffffffffc0201c9e:	03065633          	divu	a2,a2,a6
ffffffffc0201ca2:	8722                	mv	a4,s0
ffffffffc0201ca4:	f9bff0ef          	jal	ra,ffffffffc0201c3e <printnum>
ffffffffc0201ca8:	b7f9                	j	ffffffffc0201c76 <printnum+0x38>

ffffffffc0201caa <vprintfmt>:
ffffffffc0201caa:	7119                	addi	sp,sp,-128
ffffffffc0201cac:	f4a6                	sd	s1,104(sp)
ffffffffc0201cae:	f0ca                	sd	s2,96(sp)
ffffffffc0201cb0:	ecce                	sd	s3,88(sp)
ffffffffc0201cb2:	e8d2                	sd	s4,80(sp)
ffffffffc0201cb4:	e4d6                	sd	s5,72(sp)
ffffffffc0201cb6:	e0da                	sd	s6,64(sp)
ffffffffc0201cb8:	fc5e                	sd	s7,56(sp)
ffffffffc0201cba:	f06a                	sd	s10,32(sp)
ffffffffc0201cbc:	fc86                	sd	ra,120(sp)
ffffffffc0201cbe:	f8a2                	sd	s0,112(sp)
ffffffffc0201cc0:	f862                	sd	s8,48(sp)
ffffffffc0201cc2:	f466                	sd	s9,40(sp)
ffffffffc0201cc4:	ec6e                	sd	s11,24(sp)
ffffffffc0201cc6:	892a                	mv	s2,a0
ffffffffc0201cc8:	84ae                	mv	s1,a1
ffffffffc0201cca:	8d32                	mv	s10,a2
ffffffffc0201ccc:	8a36                	mv	s4,a3
ffffffffc0201cce:	02500993          	li	s3,37
ffffffffc0201cd2:	5b7d                	li	s6,-1
ffffffffc0201cd4:	00002a97          	auipc	s5,0x2
ffffffffc0201cd8:	a78a8a93          	addi	s5,s5,-1416 # ffffffffc020374c <SLUB_OBJ_SIZES+0x4c>
ffffffffc0201cdc:	00002b97          	auipc	s7,0x2
ffffffffc0201ce0:	c4cb8b93          	addi	s7,s7,-948 # ffffffffc0203928 <error_string>
ffffffffc0201ce4:	000d4503          	lbu	a0,0(s10)
ffffffffc0201ce8:	001d0413          	addi	s0,s10,1
ffffffffc0201cec:	01350a63          	beq	a0,s3,ffffffffc0201d00 <vprintfmt+0x56>
ffffffffc0201cf0:	c121                	beqz	a0,ffffffffc0201d30 <vprintfmt+0x86>
ffffffffc0201cf2:	85a6                	mv	a1,s1
ffffffffc0201cf4:	0405                	addi	s0,s0,1
ffffffffc0201cf6:	9902                	jalr	s2
ffffffffc0201cf8:	fff44503          	lbu	a0,-1(s0)
ffffffffc0201cfc:	ff351ae3          	bne	a0,s3,ffffffffc0201cf0 <vprintfmt+0x46>
ffffffffc0201d00:	00044603          	lbu	a2,0(s0)
ffffffffc0201d04:	02000793          	li	a5,32
ffffffffc0201d08:	4c81                	li	s9,0
ffffffffc0201d0a:	4881                	li	a7,0
ffffffffc0201d0c:	5c7d                	li	s8,-1
ffffffffc0201d0e:	5dfd                	li	s11,-1
ffffffffc0201d10:	05500513          	li	a0,85
ffffffffc0201d14:	4825                	li	a6,9
ffffffffc0201d16:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201d1a:	0ff5f593          	zext.b	a1,a1
ffffffffc0201d1e:	00140d13          	addi	s10,s0,1
ffffffffc0201d22:	04b56263          	bltu	a0,a1,ffffffffc0201d66 <vprintfmt+0xbc>
ffffffffc0201d26:	058a                	slli	a1,a1,0x2
ffffffffc0201d28:	95d6                	add	a1,a1,s5
ffffffffc0201d2a:	4194                	lw	a3,0(a1)
ffffffffc0201d2c:	96d6                	add	a3,a3,s5
ffffffffc0201d2e:	8682                	jr	a3
ffffffffc0201d30:	70e6                	ld	ra,120(sp)
ffffffffc0201d32:	7446                	ld	s0,112(sp)
ffffffffc0201d34:	74a6                	ld	s1,104(sp)
ffffffffc0201d36:	7906                	ld	s2,96(sp)
ffffffffc0201d38:	69e6                	ld	s3,88(sp)
ffffffffc0201d3a:	6a46                	ld	s4,80(sp)
ffffffffc0201d3c:	6aa6                	ld	s5,72(sp)
ffffffffc0201d3e:	6b06                	ld	s6,64(sp)
ffffffffc0201d40:	7be2                	ld	s7,56(sp)
ffffffffc0201d42:	7c42                	ld	s8,48(sp)
ffffffffc0201d44:	7ca2                	ld	s9,40(sp)
ffffffffc0201d46:	7d02                	ld	s10,32(sp)
ffffffffc0201d48:	6de2                	ld	s11,24(sp)
ffffffffc0201d4a:	6109                	addi	sp,sp,128
ffffffffc0201d4c:	8082                	ret
ffffffffc0201d4e:	87b2                	mv	a5,a2
ffffffffc0201d50:	00144603          	lbu	a2,1(s0)
ffffffffc0201d54:	846a                	mv	s0,s10
ffffffffc0201d56:	00140d13          	addi	s10,s0,1
ffffffffc0201d5a:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201d5e:	0ff5f593          	zext.b	a1,a1
ffffffffc0201d62:	fcb572e3          	bgeu	a0,a1,ffffffffc0201d26 <vprintfmt+0x7c>
ffffffffc0201d66:	85a6                	mv	a1,s1
ffffffffc0201d68:	02500513          	li	a0,37
ffffffffc0201d6c:	9902                	jalr	s2
ffffffffc0201d6e:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201d72:	8d22                	mv	s10,s0
ffffffffc0201d74:	f73788e3          	beq	a5,s3,ffffffffc0201ce4 <vprintfmt+0x3a>
ffffffffc0201d78:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0201d7c:	1d7d                	addi	s10,s10,-1
ffffffffc0201d7e:	ff379de3          	bne	a5,s3,ffffffffc0201d78 <vprintfmt+0xce>
ffffffffc0201d82:	b78d                	j	ffffffffc0201ce4 <vprintfmt+0x3a>
ffffffffc0201d84:	fd060c1b          	addiw	s8,a2,-48
ffffffffc0201d88:	00144603          	lbu	a2,1(s0)
ffffffffc0201d8c:	846a                	mv	s0,s10
ffffffffc0201d8e:	fd06069b          	addiw	a3,a2,-48
ffffffffc0201d92:	0006059b          	sext.w	a1,a2
ffffffffc0201d96:	02d86463          	bltu	a6,a3,ffffffffc0201dbe <vprintfmt+0x114>
ffffffffc0201d9a:	00144603          	lbu	a2,1(s0)
ffffffffc0201d9e:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201da2:	0186873b          	addw	a4,a3,s8
ffffffffc0201da6:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201daa:	9f2d                	addw	a4,a4,a1
ffffffffc0201dac:	fd06069b          	addiw	a3,a2,-48
ffffffffc0201db0:	0405                	addi	s0,s0,1
ffffffffc0201db2:	fd070c1b          	addiw	s8,a4,-48
ffffffffc0201db6:	0006059b          	sext.w	a1,a2
ffffffffc0201dba:	fed870e3          	bgeu	a6,a3,ffffffffc0201d9a <vprintfmt+0xf0>
ffffffffc0201dbe:	f40ddce3          	bgez	s11,ffffffffc0201d16 <vprintfmt+0x6c>
ffffffffc0201dc2:	8de2                	mv	s11,s8
ffffffffc0201dc4:	5c7d                	li	s8,-1
ffffffffc0201dc6:	bf81                	j	ffffffffc0201d16 <vprintfmt+0x6c>
ffffffffc0201dc8:	fffdc693          	not	a3,s11
ffffffffc0201dcc:	96fd                	srai	a3,a3,0x3f
ffffffffc0201dce:	00ddfdb3          	and	s11,s11,a3
ffffffffc0201dd2:	00144603          	lbu	a2,1(s0)
ffffffffc0201dd6:	2d81                	sext.w	s11,s11
ffffffffc0201dd8:	846a                	mv	s0,s10
ffffffffc0201dda:	bf35                	j	ffffffffc0201d16 <vprintfmt+0x6c>
ffffffffc0201ddc:	000a2c03          	lw	s8,0(s4)
ffffffffc0201de0:	00144603          	lbu	a2,1(s0)
ffffffffc0201de4:	0a21                	addi	s4,s4,8
ffffffffc0201de6:	846a                	mv	s0,s10
ffffffffc0201de8:	bfd9                	j	ffffffffc0201dbe <vprintfmt+0x114>
ffffffffc0201dea:	4705                	li	a4,1
ffffffffc0201dec:	008a0593          	addi	a1,s4,8
ffffffffc0201df0:	01174463          	blt	a4,a7,ffffffffc0201df8 <vprintfmt+0x14e>
ffffffffc0201df4:	1a088e63          	beqz	a7,ffffffffc0201fb0 <vprintfmt+0x306>
ffffffffc0201df8:	000a3603          	ld	a2,0(s4)
ffffffffc0201dfc:	46c1                	li	a3,16
ffffffffc0201dfe:	8a2e                	mv	s4,a1
ffffffffc0201e00:	2781                	sext.w	a5,a5
ffffffffc0201e02:	876e                	mv	a4,s11
ffffffffc0201e04:	85a6                	mv	a1,s1
ffffffffc0201e06:	854a                	mv	a0,s2
ffffffffc0201e08:	e37ff0ef          	jal	ra,ffffffffc0201c3e <printnum>
ffffffffc0201e0c:	bde1                	j	ffffffffc0201ce4 <vprintfmt+0x3a>
ffffffffc0201e0e:	000a2503          	lw	a0,0(s4)
ffffffffc0201e12:	85a6                	mv	a1,s1
ffffffffc0201e14:	0a21                	addi	s4,s4,8
ffffffffc0201e16:	9902                	jalr	s2
ffffffffc0201e18:	b5f1                	j	ffffffffc0201ce4 <vprintfmt+0x3a>
ffffffffc0201e1a:	4705                	li	a4,1
ffffffffc0201e1c:	008a0593          	addi	a1,s4,8
ffffffffc0201e20:	01174463          	blt	a4,a7,ffffffffc0201e28 <vprintfmt+0x17e>
ffffffffc0201e24:	18088163          	beqz	a7,ffffffffc0201fa6 <vprintfmt+0x2fc>
ffffffffc0201e28:	000a3603          	ld	a2,0(s4)
ffffffffc0201e2c:	46a9                	li	a3,10
ffffffffc0201e2e:	8a2e                	mv	s4,a1
ffffffffc0201e30:	bfc1                	j	ffffffffc0201e00 <vprintfmt+0x156>
ffffffffc0201e32:	00144603          	lbu	a2,1(s0)
ffffffffc0201e36:	4c85                	li	s9,1
ffffffffc0201e38:	846a                	mv	s0,s10
ffffffffc0201e3a:	bdf1                	j	ffffffffc0201d16 <vprintfmt+0x6c>
ffffffffc0201e3c:	85a6                	mv	a1,s1
ffffffffc0201e3e:	02500513          	li	a0,37
ffffffffc0201e42:	9902                	jalr	s2
ffffffffc0201e44:	b545                	j	ffffffffc0201ce4 <vprintfmt+0x3a>
ffffffffc0201e46:	00144603          	lbu	a2,1(s0)
ffffffffc0201e4a:	2885                	addiw	a7,a7,1
ffffffffc0201e4c:	846a                	mv	s0,s10
ffffffffc0201e4e:	b5e1                	j	ffffffffc0201d16 <vprintfmt+0x6c>
ffffffffc0201e50:	4705                	li	a4,1
ffffffffc0201e52:	008a0593          	addi	a1,s4,8
ffffffffc0201e56:	01174463          	blt	a4,a7,ffffffffc0201e5e <vprintfmt+0x1b4>
ffffffffc0201e5a:	14088163          	beqz	a7,ffffffffc0201f9c <vprintfmt+0x2f2>
ffffffffc0201e5e:	000a3603          	ld	a2,0(s4)
ffffffffc0201e62:	46a1                	li	a3,8
ffffffffc0201e64:	8a2e                	mv	s4,a1
ffffffffc0201e66:	bf69                	j	ffffffffc0201e00 <vprintfmt+0x156>
ffffffffc0201e68:	03000513          	li	a0,48
ffffffffc0201e6c:	85a6                	mv	a1,s1
ffffffffc0201e6e:	e03e                	sd	a5,0(sp)
ffffffffc0201e70:	9902                	jalr	s2
ffffffffc0201e72:	85a6                	mv	a1,s1
ffffffffc0201e74:	07800513          	li	a0,120
ffffffffc0201e78:	9902                	jalr	s2
ffffffffc0201e7a:	0a21                	addi	s4,s4,8
ffffffffc0201e7c:	6782                	ld	a5,0(sp)
ffffffffc0201e7e:	46c1                	li	a3,16
ffffffffc0201e80:	ff8a3603          	ld	a2,-8(s4)
ffffffffc0201e84:	bfb5                	j	ffffffffc0201e00 <vprintfmt+0x156>
ffffffffc0201e86:	000a3403          	ld	s0,0(s4)
ffffffffc0201e8a:	008a0713          	addi	a4,s4,8
ffffffffc0201e8e:	e03a                	sd	a4,0(sp)
ffffffffc0201e90:	14040263          	beqz	s0,ffffffffc0201fd4 <vprintfmt+0x32a>
ffffffffc0201e94:	0fb05763          	blez	s11,ffffffffc0201f82 <vprintfmt+0x2d8>
ffffffffc0201e98:	02d00693          	li	a3,45
ffffffffc0201e9c:	0cd79163          	bne	a5,a3,ffffffffc0201f5e <vprintfmt+0x2b4>
ffffffffc0201ea0:	00044783          	lbu	a5,0(s0)
ffffffffc0201ea4:	0007851b          	sext.w	a0,a5
ffffffffc0201ea8:	cf85                	beqz	a5,ffffffffc0201ee0 <vprintfmt+0x236>
ffffffffc0201eaa:	00140a13          	addi	s4,s0,1
ffffffffc0201eae:	05e00413          	li	s0,94
ffffffffc0201eb2:	000c4563          	bltz	s8,ffffffffc0201ebc <vprintfmt+0x212>
ffffffffc0201eb6:	3c7d                	addiw	s8,s8,-1
ffffffffc0201eb8:	036c0263          	beq	s8,s6,ffffffffc0201edc <vprintfmt+0x232>
ffffffffc0201ebc:	85a6                	mv	a1,s1
ffffffffc0201ebe:	0e0c8e63          	beqz	s9,ffffffffc0201fba <vprintfmt+0x310>
ffffffffc0201ec2:	3781                	addiw	a5,a5,-32
ffffffffc0201ec4:	0ef47b63          	bgeu	s0,a5,ffffffffc0201fba <vprintfmt+0x310>
ffffffffc0201ec8:	03f00513          	li	a0,63
ffffffffc0201ecc:	9902                	jalr	s2
ffffffffc0201ece:	000a4783          	lbu	a5,0(s4)
ffffffffc0201ed2:	3dfd                	addiw	s11,s11,-1
ffffffffc0201ed4:	0a05                	addi	s4,s4,1
ffffffffc0201ed6:	0007851b          	sext.w	a0,a5
ffffffffc0201eda:	ffe1                	bnez	a5,ffffffffc0201eb2 <vprintfmt+0x208>
ffffffffc0201edc:	01b05963          	blez	s11,ffffffffc0201eee <vprintfmt+0x244>
ffffffffc0201ee0:	3dfd                	addiw	s11,s11,-1
ffffffffc0201ee2:	85a6                	mv	a1,s1
ffffffffc0201ee4:	02000513          	li	a0,32
ffffffffc0201ee8:	9902                	jalr	s2
ffffffffc0201eea:	fe0d9be3          	bnez	s11,ffffffffc0201ee0 <vprintfmt+0x236>
ffffffffc0201eee:	6a02                	ld	s4,0(sp)
ffffffffc0201ef0:	bbd5                	j	ffffffffc0201ce4 <vprintfmt+0x3a>
ffffffffc0201ef2:	4705                	li	a4,1
ffffffffc0201ef4:	008a0c93          	addi	s9,s4,8
ffffffffc0201ef8:	01174463          	blt	a4,a7,ffffffffc0201f00 <vprintfmt+0x256>
ffffffffc0201efc:	08088d63          	beqz	a7,ffffffffc0201f96 <vprintfmt+0x2ec>
ffffffffc0201f00:	000a3403          	ld	s0,0(s4)
ffffffffc0201f04:	0a044d63          	bltz	s0,ffffffffc0201fbe <vprintfmt+0x314>
ffffffffc0201f08:	8622                	mv	a2,s0
ffffffffc0201f0a:	8a66                	mv	s4,s9
ffffffffc0201f0c:	46a9                	li	a3,10
ffffffffc0201f0e:	bdcd                	j	ffffffffc0201e00 <vprintfmt+0x156>
ffffffffc0201f10:	000a2783          	lw	a5,0(s4)
ffffffffc0201f14:	4719                	li	a4,6
ffffffffc0201f16:	0a21                	addi	s4,s4,8
ffffffffc0201f18:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0201f1c:	8fb5                	xor	a5,a5,a3
ffffffffc0201f1e:	40d786bb          	subw	a3,a5,a3
ffffffffc0201f22:	02d74163          	blt	a4,a3,ffffffffc0201f44 <vprintfmt+0x29a>
ffffffffc0201f26:	00369793          	slli	a5,a3,0x3
ffffffffc0201f2a:	97de                	add	a5,a5,s7
ffffffffc0201f2c:	639c                	ld	a5,0(a5)
ffffffffc0201f2e:	cb99                	beqz	a5,ffffffffc0201f44 <vprintfmt+0x29a>
ffffffffc0201f30:	86be                	mv	a3,a5
ffffffffc0201f32:	00002617          	auipc	a2,0x2
ffffffffc0201f36:	81660613          	addi	a2,a2,-2026 # ffffffffc0203748 <SLUB_OBJ_SIZES+0x48>
ffffffffc0201f3a:	85a6                	mv	a1,s1
ffffffffc0201f3c:	854a                	mv	a0,s2
ffffffffc0201f3e:	0ce000ef          	jal	ra,ffffffffc020200c <printfmt>
ffffffffc0201f42:	b34d                	j	ffffffffc0201ce4 <vprintfmt+0x3a>
ffffffffc0201f44:	00001617          	auipc	a2,0x1
ffffffffc0201f48:	7f460613          	addi	a2,a2,2036 # ffffffffc0203738 <SLUB_OBJ_SIZES+0x38>
ffffffffc0201f4c:	85a6                	mv	a1,s1
ffffffffc0201f4e:	854a                	mv	a0,s2
ffffffffc0201f50:	0bc000ef          	jal	ra,ffffffffc020200c <printfmt>
ffffffffc0201f54:	bb41                	j	ffffffffc0201ce4 <vprintfmt+0x3a>
ffffffffc0201f56:	00001417          	auipc	s0,0x1
ffffffffc0201f5a:	7da40413          	addi	s0,s0,2010 # ffffffffc0203730 <SLUB_OBJ_SIZES+0x30>
ffffffffc0201f5e:	85e2                	mv	a1,s8
ffffffffc0201f60:	8522                	mv	a0,s0
ffffffffc0201f62:	e43e                	sd	a5,8(sp)
ffffffffc0201f64:	0fc000ef          	jal	ra,ffffffffc0202060 <strnlen>
ffffffffc0201f68:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201f6c:	01b05b63          	blez	s11,ffffffffc0201f82 <vprintfmt+0x2d8>
ffffffffc0201f70:	67a2                	ld	a5,8(sp)
ffffffffc0201f72:	00078a1b          	sext.w	s4,a5
ffffffffc0201f76:	3dfd                	addiw	s11,s11,-1
ffffffffc0201f78:	85a6                	mv	a1,s1
ffffffffc0201f7a:	8552                	mv	a0,s4
ffffffffc0201f7c:	9902                	jalr	s2
ffffffffc0201f7e:	fe0d9ce3          	bnez	s11,ffffffffc0201f76 <vprintfmt+0x2cc>
ffffffffc0201f82:	00044783          	lbu	a5,0(s0)
ffffffffc0201f86:	00140a13          	addi	s4,s0,1
ffffffffc0201f8a:	0007851b          	sext.w	a0,a5
ffffffffc0201f8e:	d3a5                	beqz	a5,ffffffffc0201eee <vprintfmt+0x244>
ffffffffc0201f90:	05e00413          	li	s0,94
ffffffffc0201f94:	bf39                	j	ffffffffc0201eb2 <vprintfmt+0x208>
ffffffffc0201f96:	000a2403          	lw	s0,0(s4)
ffffffffc0201f9a:	b7ad                	j	ffffffffc0201f04 <vprintfmt+0x25a>
ffffffffc0201f9c:	000a6603          	lwu	a2,0(s4)
ffffffffc0201fa0:	46a1                	li	a3,8
ffffffffc0201fa2:	8a2e                	mv	s4,a1
ffffffffc0201fa4:	bdb1                	j	ffffffffc0201e00 <vprintfmt+0x156>
ffffffffc0201fa6:	000a6603          	lwu	a2,0(s4)
ffffffffc0201faa:	46a9                	li	a3,10
ffffffffc0201fac:	8a2e                	mv	s4,a1
ffffffffc0201fae:	bd89                	j	ffffffffc0201e00 <vprintfmt+0x156>
ffffffffc0201fb0:	000a6603          	lwu	a2,0(s4)
ffffffffc0201fb4:	46c1                	li	a3,16
ffffffffc0201fb6:	8a2e                	mv	s4,a1
ffffffffc0201fb8:	b5a1                	j	ffffffffc0201e00 <vprintfmt+0x156>
ffffffffc0201fba:	9902                	jalr	s2
ffffffffc0201fbc:	bf09                	j	ffffffffc0201ece <vprintfmt+0x224>
ffffffffc0201fbe:	85a6                	mv	a1,s1
ffffffffc0201fc0:	02d00513          	li	a0,45
ffffffffc0201fc4:	e03e                	sd	a5,0(sp)
ffffffffc0201fc6:	9902                	jalr	s2
ffffffffc0201fc8:	6782                	ld	a5,0(sp)
ffffffffc0201fca:	8a66                	mv	s4,s9
ffffffffc0201fcc:	40800633          	neg	a2,s0
ffffffffc0201fd0:	46a9                	li	a3,10
ffffffffc0201fd2:	b53d                	j	ffffffffc0201e00 <vprintfmt+0x156>
ffffffffc0201fd4:	03b05163          	blez	s11,ffffffffc0201ff6 <vprintfmt+0x34c>
ffffffffc0201fd8:	02d00693          	li	a3,45
ffffffffc0201fdc:	f6d79de3          	bne	a5,a3,ffffffffc0201f56 <vprintfmt+0x2ac>
ffffffffc0201fe0:	00001417          	auipc	s0,0x1
ffffffffc0201fe4:	75040413          	addi	s0,s0,1872 # ffffffffc0203730 <SLUB_OBJ_SIZES+0x30>
ffffffffc0201fe8:	02800793          	li	a5,40
ffffffffc0201fec:	02800513          	li	a0,40
ffffffffc0201ff0:	00140a13          	addi	s4,s0,1
ffffffffc0201ff4:	bd6d                	j	ffffffffc0201eae <vprintfmt+0x204>
ffffffffc0201ff6:	00001a17          	auipc	s4,0x1
ffffffffc0201ffa:	73ba0a13          	addi	s4,s4,1851 # ffffffffc0203731 <SLUB_OBJ_SIZES+0x31>
ffffffffc0201ffe:	02800513          	li	a0,40
ffffffffc0202002:	02800793          	li	a5,40
ffffffffc0202006:	05e00413          	li	s0,94
ffffffffc020200a:	b565                	j	ffffffffc0201eb2 <vprintfmt+0x208>

ffffffffc020200c <printfmt>:
ffffffffc020200c:	715d                	addi	sp,sp,-80
ffffffffc020200e:	02810313          	addi	t1,sp,40
ffffffffc0202012:	f436                	sd	a3,40(sp)
ffffffffc0202014:	869a                	mv	a3,t1
ffffffffc0202016:	ec06                	sd	ra,24(sp)
ffffffffc0202018:	f83a                	sd	a4,48(sp)
ffffffffc020201a:	fc3e                	sd	a5,56(sp)
ffffffffc020201c:	e0c2                	sd	a6,64(sp)
ffffffffc020201e:	e4c6                	sd	a7,72(sp)
ffffffffc0202020:	e41a                	sd	t1,8(sp)
ffffffffc0202022:	c89ff0ef          	jal	ra,ffffffffc0201caa <vprintfmt>
ffffffffc0202026:	60e2                	ld	ra,24(sp)
ffffffffc0202028:	6161                	addi	sp,sp,80
ffffffffc020202a:	8082                	ret

ffffffffc020202c <sbi_console_putchar>:
ffffffffc020202c:	4781                	li	a5,0
ffffffffc020202e:	00005717          	auipc	a4,0x5
ffffffffc0202032:	fe273703          	ld	a4,-30(a4) # ffffffffc0207010 <SBI_CONSOLE_PUTCHAR>
ffffffffc0202036:	88ba                	mv	a7,a4
ffffffffc0202038:	852a                	mv	a0,a0
ffffffffc020203a:	85be                	mv	a1,a5
ffffffffc020203c:	863e                	mv	a2,a5
ffffffffc020203e:	00000073          	ecall
ffffffffc0202042:	87aa                	mv	a5,a0
ffffffffc0202044:	8082                	ret

ffffffffc0202046 <strlen>:
ffffffffc0202046:	00054783          	lbu	a5,0(a0)
ffffffffc020204a:	872a                	mv	a4,a0
ffffffffc020204c:	4501                	li	a0,0
ffffffffc020204e:	cb81                	beqz	a5,ffffffffc020205e <strlen+0x18>
ffffffffc0202050:	0505                	addi	a0,a0,1
ffffffffc0202052:	00a707b3          	add	a5,a4,a0
ffffffffc0202056:	0007c783          	lbu	a5,0(a5)
ffffffffc020205a:	fbfd                	bnez	a5,ffffffffc0202050 <strlen+0xa>
ffffffffc020205c:	8082                	ret
ffffffffc020205e:	8082                	ret

ffffffffc0202060 <strnlen>:
ffffffffc0202060:	4781                	li	a5,0
ffffffffc0202062:	e589                	bnez	a1,ffffffffc020206c <strnlen+0xc>
ffffffffc0202064:	a811                	j	ffffffffc0202078 <strnlen+0x18>
ffffffffc0202066:	0785                	addi	a5,a5,1
ffffffffc0202068:	00f58863          	beq	a1,a5,ffffffffc0202078 <strnlen+0x18>
ffffffffc020206c:	00f50733          	add	a4,a0,a5
ffffffffc0202070:	00074703          	lbu	a4,0(a4)
ffffffffc0202074:	fb6d                	bnez	a4,ffffffffc0202066 <strnlen+0x6>
ffffffffc0202076:	85be                	mv	a1,a5
ffffffffc0202078:	852e                	mv	a0,a1
ffffffffc020207a:	8082                	ret

ffffffffc020207c <strcmp>:
ffffffffc020207c:	00054783          	lbu	a5,0(a0)
ffffffffc0202080:	0005c703          	lbu	a4,0(a1)
ffffffffc0202084:	cb89                	beqz	a5,ffffffffc0202096 <strcmp+0x1a>
ffffffffc0202086:	0505                	addi	a0,a0,1
ffffffffc0202088:	0585                	addi	a1,a1,1
ffffffffc020208a:	fee789e3          	beq	a5,a4,ffffffffc020207c <strcmp>
ffffffffc020208e:	0007851b          	sext.w	a0,a5
ffffffffc0202092:	9d19                	subw	a0,a0,a4
ffffffffc0202094:	8082                	ret
ffffffffc0202096:	4501                	li	a0,0
ffffffffc0202098:	bfed                	j	ffffffffc0202092 <strcmp+0x16>

ffffffffc020209a <strncmp>:
ffffffffc020209a:	c20d                	beqz	a2,ffffffffc02020bc <strncmp+0x22>
ffffffffc020209c:	962e                	add	a2,a2,a1
ffffffffc020209e:	a031                	j	ffffffffc02020aa <strncmp+0x10>
ffffffffc02020a0:	0505                	addi	a0,a0,1
ffffffffc02020a2:	00e79a63          	bne	a5,a4,ffffffffc02020b6 <strncmp+0x1c>
ffffffffc02020a6:	00b60b63          	beq	a2,a1,ffffffffc02020bc <strncmp+0x22>
ffffffffc02020aa:	00054783          	lbu	a5,0(a0)
ffffffffc02020ae:	0585                	addi	a1,a1,1
ffffffffc02020b0:	fff5c703          	lbu	a4,-1(a1)
ffffffffc02020b4:	f7f5                	bnez	a5,ffffffffc02020a0 <strncmp+0x6>
ffffffffc02020b6:	40e7853b          	subw	a0,a5,a4
ffffffffc02020ba:	8082                	ret
ffffffffc02020bc:	4501                	li	a0,0
ffffffffc02020be:	8082                	ret

ffffffffc02020c0 <memset>:
ffffffffc02020c0:	ca01                	beqz	a2,ffffffffc02020d0 <memset+0x10>
ffffffffc02020c2:	962a                	add	a2,a2,a0
ffffffffc02020c4:	87aa                	mv	a5,a0
ffffffffc02020c6:	0785                	addi	a5,a5,1
ffffffffc02020c8:	feb78fa3          	sb	a1,-1(a5)
ffffffffc02020cc:	fec79de3          	bne	a5,a2,ffffffffc02020c6 <memset+0x6>
ffffffffc02020d0:	8082                	ret
