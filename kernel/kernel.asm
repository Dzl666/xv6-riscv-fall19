
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	80010113          	addi	sp,sp,-2048 # 80009800 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <junk>:
    8000001a:	a001                	j	8000001a <junk>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00009617          	auipc	a2,0x9
    8000004e:	fb660613          	addi	a2,a2,-74 # 80009000 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	b9478793          	addi	a5,a5,-1132 # 80005bf0 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000074:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <ticks+0xffffffff7ffd57d7>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	c8a78793          	addi	a5,a5,-886 # 80000d30 <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c0:	30379073          	csrw	mideleg,a5
  timerinit();
    800000c4:	00000097          	auipc	ra,0x0
    800000c8:	f58080e7          	jalr	-168(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000cc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000d0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000d2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000d4:	30200073          	mret
}
    800000d8:	60a2                	ld	ra,8(sp)
    800000da:	6402                	ld	s0,0(sp)
    800000dc:	0141                	addi	sp,sp,16
    800000de:	8082                	ret

00000000800000e0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800000e0:	7159                	addi	sp,sp,-112
    800000e2:	f486                	sd	ra,104(sp)
    800000e4:	f0a2                	sd	s0,96(sp)
    800000e6:	eca6                	sd	s1,88(sp)
    800000e8:	e8ca                	sd	s2,80(sp)
    800000ea:	e4ce                	sd	s3,72(sp)
    800000ec:	e0d2                	sd	s4,64(sp)
    800000ee:	fc56                	sd	s5,56(sp)
    800000f0:	f85a                	sd	s6,48(sp)
    800000f2:	f45e                	sd	s7,40(sp)
    800000f4:	f062                	sd	s8,32(sp)
    800000f6:	ec66                	sd	s9,24(sp)
    800000f8:	e86a                	sd	s10,16(sp)
    800000fa:	1880                	addi	s0,sp,112
    800000fc:	8aaa                	mv	s5,a0
    800000fe:	8a2e                	mv	s4,a1
    80000100:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000102:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000106:	00011517          	auipc	a0,0x11
    8000010a:	6fa50513          	addi	a0,a0,1786 # 80011800 <cons>
    8000010e:	00001097          	auipc	ra,0x1
    80000112:	9b0080e7          	jalr	-1616(ra) # 80000abe <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000116:	00011497          	auipc	s1,0x11
    8000011a:	6ea48493          	addi	s1,s1,1770 # 80011800 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000011e:	00011917          	auipc	s2,0x11
    80000122:	77a90913          	addi	s2,s2,1914 # 80011898 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80000126:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000128:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000012a:	4ca9                	li	s9,10
  while(n > 0){
    8000012c:	07305863          	blez	s3,8000019c <consoleread+0xbc>
    while(cons.r == cons.w){
    80000130:	0984a783          	lw	a5,152(s1)
    80000134:	09c4a703          	lw	a4,156(s1)
    80000138:	02f71463          	bne	a4,a5,80000160 <consoleread+0x80>
      if(myproc()->killed){
    8000013c:	00001097          	auipc	ra,0x1
    80000140:	6e2080e7          	jalr	1762(ra) # 8000181e <myproc>
    80000144:	591c                	lw	a5,48(a0)
    80000146:	e7b5                	bnez	a5,800001b2 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80000148:	85a6                	mv	a1,s1
    8000014a:	854a                	mv	a0,s2
    8000014c:	00002097          	auipc	ra,0x2
    80000150:	edc080e7          	jalr	-292(ra) # 80002028 <sleep>
    while(cons.r == cons.w){
    80000154:	0984a783          	lw	a5,152(s1)
    80000158:	09c4a703          	lw	a4,156(s1)
    8000015c:	fef700e3          	beq	a4,a5,8000013c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80000160:	0017871b          	addiw	a4,a5,1
    80000164:	08e4ac23          	sw	a4,152(s1)
    80000168:	07f7f713          	andi	a4,a5,127
    8000016c:	9726                	add	a4,a4,s1
    8000016e:	01874703          	lbu	a4,24(a4)
    80000172:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000176:	077d0563          	beq	s10,s7,800001e0 <consoleread+0x100>
    cbuf = c;
    8000017a:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000017e:	4685                	li	a3,1
    80000180:	f9f40613          	addi	a2,s0,-97
    80000184:	85d2                	mv	a1,s4
    80000186:	8556                	mv	a0,s5
    80000188:	00002097          	auipc	ra,0x2
    8000018c:	0c0080e7          	jalr	192(ra) # 80002248 <either_copyout>
    80000190:	01850663          	beq	a0,s8,8000019c <consoleread+0xbc>
    dst++;
    80000194:	0a05                	addi	s4,s4,1
    --n;
    80000196:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000198:	f99d1ae3          	bne	s10,s9,8000012c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000019c:	00011517          	auipc	a0,0x11
    800001a0:	66450513          	addi	a0,a0,1636 # 80011800 <cons>
    800001a4:	00001097          	auipc	ra,0x1
    800001a8:	982080e7          	jalr	-1662(ra) # 80000b26 <release>

  return target - n;
    800001ac:	413b053b          	subw	a0,s6,s3
    800001b0:	a811                	j	800001c4 <consoleread+0xe4>
        release(&cons.lock);
    800001b2:	00011517          	auipc	a0,0x11
    800001b6:	64e50513          	addi	a0,a0,1614 # 80011800 <cons>
    800001ba:	00001097          	auipc	ra,0x1
    800001be:	96c080e7          	jalr	-1684(ra) # 80000b26 <release>
        return -1;
    800001c2:	557d                	li	a0,-1
}
    800001c4:	70a6                	ld	ra,104(sp)
    800001c6:	7406                	ld	s0,96(sp)
    800001c8:	64e6                	ld	s1,88(sp)
    800001ca:	6946                	ld	s2,80(sp)
    800001cc:	69a6                	ld	s3,72(sp)
    800001ce:	6a06                	ld	s4,64(sp)
    800001d0:	7ae2                	ld	s5,56(sp)
    800001d2:	7b42                	ld	s6,48(sp)
    800001d4:	7ba2                	ld	s7,40(sp)
    800001d6:	7c02                	ld	s8,32(sp)
    800001d8:	6ce2                	ld	s9,24(sp)
    800001da:	6d42                	ld	s10,16(sp)
    800001dc:	6165                	addi	sp,sp,112
    800001de:	8082                	ret
      if(n < target){
    800001e0:	0009871b          	sext.w	a4,s3
    800001e4:	fb677ce3          	bgeu	a4,s6,8000019c <consoleread+0xbc>
        cons.r--;
    800001e8:	00011717          	auipc	a4,0x11
    800001ec:	6af72823          	sw	a5,1712(a4) # 80011898 <cons+0x98>
    800001f0:	b775                	j	8000019c <consoleread+0xbc>

00000000800001f2 <consputc>:
  if(panicked){
    800001f2:	00029797          	auipc	a5,0x29
    800001f6:	e0e7a783          	lw	a5,-498(a5) # 80029000 <panicked>
    800001fa:	c391                	beqz	a5,800001fe <consputc+0xc>
    for(;;)
    800001fc:	a001                	j	800001fc <consputc+0xa>
{
    800001fe:	1141                	addi	sp,sp,-16
    80000200:	e406                	sd	ra,8(sp)
    80000202:	e022                	sd	s0,0(sp)
    80000204:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000206:	10000793          	li	a5,256
    8000020a:	00f50a63          	beq	a0,a5,8000021e <consputc+0x2c>
    uartputc(c);
    8000020e:	00000097          	auipc	ra,0x0
    80000212:	5cc080e7          	jalr	1484(ra) # 800007da <uartputc>
}
    80000216:	60a2                	ld	ra,8(sp)
    80000218:	6402                	ld	s0,0(sp)
    8000021a:	0141                	addi	sp,sp,16
    8000021c:	8082                	ret
    uartputc('\b'); uartputc(' '); uartputc('\b');
    8000021e:	4521                	li	a0,8
    80000220:	00000097          	auipc	ra,0x0
    80000224:	5ba080e7          	jalr	1466(ra) # 800007da <uartputc>
    80000228:	02000513          	li	a0,32
    8000022c:	00000097          	auipc	ra,0x0
    80000230:	5ae080e7          	jalr	1454(ra) # 800007da <uartputc>
    80000234:	4521                	li	a0,8
    80000236:	00000097          	auipc	ra,0x0
    8000023a:	5a4080e7          	jalr	1444(ra) # 800007da <uartputc>
    8000023e:	bfe1                	j	80000216 <consputc+0x24>

0000000080000240 <consolewrite>:
{
    80000240:	715d                	addi	sp,sp,-80
    80000242:	e486                	sd	ra,72(sp)
    80000244:	e0a2                	sd	s0,64(sp)
    80000246:	fc26                	sd	s1,56(sp)
    80000248:	f84a                	sd	s2,48(sp)
    8000024a:	f44e                	sd	s3,40(sp)
    8000024c:	f052                	sd	s4,32(sp)
    8000024e:	ec56                	sd	s5,24(sp)
    80000250:	0880                	addi	s0,sp,80
    80000252:	89aa                	mv	s3,a0
    80000254:	84ae                	mv	s1,a1
    80000256:	8ab2                	mv	s5,a2
  acquire(&cons.lock);
    80000258:	00011517          	auipc	a0,0x11
    8000025c:	5a850513          	addi	a0,a0,1448 # 80011800 <cons>
    80000260:	00001097          	auipc	ra,0x1
    80000264:	85e080e7          	jalr	-1954(ra) # 80000abe <acquire>
  for(i = 0; i < n; i++){
    80000268:	03505e63          	blez	s5,800002a4 <consolewrite+0x64>
    8000026c:	00148913          	addi	s2,s1,1
    80000270:	fffa879b          	addiw	a5,s5,-1
    80000274:	1782                	slli	a5,a5,0x20
    80000276:	9381                	srli	a5,a5,0x20
    80000278:	993e                	add	s2,s2,a5
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000027a:	5a7d                	li	s4,-1
    8000027c:	4685                	li	a3,1
    8000027e:	8626                	mv	a2,s1
    80000280:	85ce                	mv	a1,s3
    80000282:	fbf40513          	addi	a0,s0,-65
    80000286:	00002097          	auipc	ra,0x2
    8000028a:	018080e7          	jalr	24(ra) # 8000229e <either_copyin>
    8000028e:	01450b63          	beq	a0,s4,800002a4 <consolewrite+0x64>
    consputc(c);
    80000292:	fbf44503          	lbu	a0,-65(s0)
    80000296:	00000097          	auipc	ra,0x0
    8000029a:	f5c080e7          	jalr	-164(ra) # 800001f2 <consputc>
  for(i = 0; i < n; i++){
    8000029e:	0485                	addi	s1,s1,1
    800002a0:	fd249ee3          	bne	s1,s2,8000027c <consolewrite+0x3c>
  release(&cons.lock);
    800002a4:	00011517          	auipc	a0,0x11
    800002a8:	55c50513          	addi	a0,a0,1372 # 80011800 <cons>
    800002ac:	00001097          	auipc	ra,0x1
    800002b0:	87a080e7          	jalr	-1926(ra) # 80000b26 <release>
}
    800002b4:	8556                	mv	a0,s5
    800002b6:	60a6                	ld	ra,72(sp)
    800002b8:	6406                	ld	s0,64(sp)
    800002ba:	74e2                	ld	s1,56(sp)
    800002bc:	7942                	ld	s2,48(sp)
    800002be:	79a2                	ld	s3,40(sp)
    800002c0:	7a02                	ld	s4,32(sp)
    800002c2:	6ae2                	ld	s5,24(sp)
    800002c4:	6161                	addi	sp,sp,80
    800002c6:	8082                	ret

00000000800002c8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c8:	1101                	addi	sp,sp,-32
    800002ca:	ec06                	sd	ra,24(sp)
    800002cc:	e822                	sd	s0,16(sp)
    800002ce:	e426                	sd	s1,8(sp)
    800002d0:	e04a                	sd	s2,0(sp)
    800002d2:	1000                	addi	s0,sp,32
    800002d4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002d6:	00011517          	auipc	a0,0x11
    800002da:	52a50513          	addi	a0,a0,1322 # 80011800 <cons>
    800002de:	00000097          	auipc	ra,0x0
    800002e2:	7e0080e7          	jalr	2016(ra) # 80000abe <acquire>

  switch(c){
    800002e6:	47d5                	li	a5,21
    800002e8:	0af48663          	beq	s1,a5,80000394 <consoleintr+0xcc>
    800002ec:	0297ca63          	blt	a5,s1,80000320 <consoleintr+0x58>
    800002f0:	47a1                	li	a5,8
    800002f2:	0ef48763          	beq	s1,a5,800003e0 <consoleintr+0x118>
    800002f6:	47c1                	li	a5,16
    800002f8:	10f49a63          	bne	s1,a5,8000040c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002fc:	00002097          	auipc	ra,0x2
    80000300:	ff8080e7          	jalr	-8(ra) # 800022f4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000304:	00011517          	auipc	a0,0x11
    80000308:	4fc50513          	addi	a0,a0,1276 # 80011800 <cons>
    8000030c:	00001097          	auipc	ra,0x1
    80000310:	81a080e7          	jalr	-2022(ra) # 80000b26 <release>
}
    80000314:	60e2                	ld	ra,24(sp)
    80000316:	6442                	ld	s0,16(sp)
    80000318:	64a2                	ld	s1,8(sp)
    8000031a:	6902                	ld	s2,0(sp)
    8000031c:	6105                	addi	sp,sp,32
    8000031e:	8082                	ret
  switch(c){
    80000320:	07f00793          	li	a5,127
    80000324:	0af48e63          	beq	s1,a5,800003e0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000328:	00011717          	auipc	a4,0x11
    8000032c:	4d870713          	addi	a4,a4,1240 # 80011800 <cons>
    80000330:	0a072783          	lw	a5,160(a4)
    80000334:	09872703          	lw	a4,152(a4)
    80000338:	9f99                	subw	a5,a5,a4
    8000033a:	07f00713          	li	a4,127
    8000033e:	fcf763e3          	bltu	a4,a5,80000304 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000342:	47b5                	li	a5,13
    80000344:	0cf48763          	beq	s1,a5,80000412 <consoleintr+0x14a>
      consputc(c);
    80000348:	8526                	mv	a0,s1
    8000034a:	00000097          	auipc	ra,0x0
    8000034e:	ea8080e7          	jalr	-344(ra) # 800001f2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000352:	00011797          	auipc	a5,0x11
    80000356:	4ae78793          	addi	a5,a5,1198 # 80011800 <cons>
    8000035a:	0a07a703          	lw	a4,160(a5)
    8000035e:	0017069b          	addiw	a3,a4,1
    80000362:	0006861b          	sext.w	a2,a3
    80000366:	0ad7a023          	sw	a3,160(a5)
    8000036a:	07f77713          	andi	a4,a4,127
    8000036e:	97ba                	add	a5,a5,a4
    80000370:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000374:	47a9                	li	a5,10
    80000376:	0cf48563          	beq	s1,a5,80000440 <consoleintr+0x178>
    8000037a:	4791                	li	a5,4
    8000037c:	0cf48263          	beq	s1,a5,80000440 <consoleintr+0x178>
    80000380:	00011797          	auipc	a5,0x11
    80000384:	5187a783          	lw	a5,1304(a5) # 80011898 <cons+0x98>
    80000388:	0807879b          	addiw	a5,a5,128
    8000038c:	f6f61ce3          	bne	a2,a5,80000304 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000390:	863e                	mv	a2,a5
    80000392:	a07d                	j	80000440 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000394:	00011717          	auipc	a4,0x11
    80000398:	46c70713          	addi	a4,a4,1132 # 80011800 <cons>
    8000039c:	0a072783          	lw	a5,160(a4)
    800003a0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003a4:	00011497          	auipc	s1,0x11
    800003a8:	45c48493          	addi	s1,s1,1116 # 80011800 <cons>
    while(cons.e != cons.w &&
    800003ac:	4929                	li	s2,10
    800003ae:	f4f70be3          	beq	a4,a5,80000304 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b2:	37fd                	addiw	a5,a5,-1
    800003b4:	07f7f713          	andi	a4,a5,127
    800003b8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003ba:	01874703          	lbu	a4,24(a4)
    800003be:	f52703e3          	beq	a4,s2,80000304 <consoleintr+0x3c>
      cons.e--;
    800003c2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003c6:	10000513          	li	a0,256
    800003ca:	00000097          	auipc	ra,0x0
    800003ce:	e28080e7          	jalr	-472(ra) # 800001f2 <consputc>
    while(cons.e != cons.w &&
    800003d2:	0a04a783          	lw	a5,160(s1)
    800003d6:	09c4a703          	lw	a4,156(s1)
    800003da:	fcf71ce3          	bne	a4,a5,800003b2 <consoleintr+0xea>
    800003de:	b71d                	j	80000304 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003e0:	00011717          	auipc	a4,0x11
    800003e4:	42070713          	addi	a4,a4,1056 # 80011800 <cons>
    800003e8:	0a072783          	lw	a5,160(a4)
    800003ec:	09c72703          	lw	a4,156(a4)
    800003f0:	f0f70ae3          	beq	a4,a5,80000304 <consoleintr+0x3c>
      cons.e--;
    800003f4:	37fd                	addiw	a5,a5,-1
    800003f6:	00011717          	auipc	a4,0x11
    800003fa:	4af72523          	sw	a5,1194(a4) # 800118a0 <cons+0xa0>
      consputc(BACKSPACE);
    800003fe:	10000513          	li	a0,256
    80000402:	00000097          	auipc	ra,0x0
    80000406:	df0080e7          	jalr	-528(ra) # 800001f2 <consputc>
    8000040a:	bded                	j	80000304 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000040c:	ee048ce3          	beqz	s1,80000304 <consoleintr+0x3c>
    80000410:	bf21                	j	80000328 <consoleintr+0x60>
      consputc(c);
    80000412:	4529                	li	a0,10
    80000414:	00000097          	auipc	ra,0x0
    80000418:	dde080e7          	jalr	-546(ra) # 800001f2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000041c:	00011797          	auipc	a5,0x11
    80000420:	3e478793          	addi	a5,a5,996 # 80011800 <cons>
    80000424:	0a07a703          	lw	a4,160(a5)
    80000428:	0017069b          	addiw	a3,a4,1
    8000042c:	0006861b          	sext.w	a2,a3
    80000430:	0ad7a023          	sw	a3,160(a5)
    80000434:	07f77713          	andi	a4,a4,127
    80000438:	97ba                	add	a5,a5,a4
    8000043a:	4729                	li	a4,10
    8000043c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000440:	00011797          	auipc	a5,0x11
    80000444:	44c7ae23          	sw	a2,1116(a5) # 8001189c <cons+0x9c>
        wakeup(&cons.r);
    80000448:	00011517          	auipc	a0,0x11
    8000044c:	45050513          	addi	a0,a0,1104 # 80011898 <cons+0x98>
    80000450:	00002097          	auipc	ra,0x2
    80000454:	d1e080e7          	jalr	-738(ra) # 8000216e <wakeup>
    80000458:	b575                	j	80000304 <consoleintr+0x3c>

000000008000045a <consoleinit>:

void
consoleinit(void)
{
    8000045a:	1141                	addi	sp,sp,-16
    8000045c:	e406                	sd	ra,8(sp)
    8000045e:	e022                	sd	s0,0(sp)
    80000460:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000462:	00007597          	auipc	a1,0x7
    80000466:	cb658593          	addi	a1,a1,-842 # 80007118 <userret+0x88>
    8000046a:	00011517          	auipc	a0,0x11
    8000046e:	39650513          	addi	a0,a0,918 # 80011800 <cons>
    80000472:	00000097          	auipc	ra,0x0
    80000476:	53e080e7          	jalr	1342(ra) # 800009b0 <initlock>

  uartinit();
    8000047a:	00000097          	auipc	ra,0x0
    8000047e:	32a080e7          	jalr	810(ra) # 800007a4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000482:	00021797          	auipc	a5,0x21
    80000486:	46678793          	addi	a5,a5,1126 # 800218e8 <devsw>
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c5670713          	addi	a4,a4,-938 # 800000e0 <consoleread>
    80000492:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000494:	00000717          	auipc	a4,0x0
    80000498:	dac70713          	addi	a4,a4,-596 # 80000240 <consolewrite>
    8000049c:	ef98                	sd	a4,24(a5)
}
    8000049e:	60a2                	ld	ra,8(sp)
    800004a0:	6402                	ld	s0,0(sp)
    800004a2:	0141                	addi	sp,sp,16
    800004a4:	8082                	ret

00000000800004a6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004a6:	7179                	addi	sp,sp,-48
    800004a8:	f406                	sd	ra,40(sp)
    800004aa:	f022                	sd	s0,32(sp)
    800004ac:	ec26                	sd	s1,24(sp)
    800004ae:	e84a                	sd	s2,16(sp)
    800004b0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004b2:	c219                	beqz	a2,800004b8 <printint+0x12>
    800004b4:	08054663          	bltz	a0,80000540 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004b8:	2501                	sext.w	a0,a0
    800004ba:	4881                	li	a7,0
    800004bc:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004c0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004c2:	2581                	sext.w	a1,a1
    800004c4:	00007617          	auipc	a2,0x7
    800004c8:	3ec60613          	addi	a2,a2,1004 # 800078b0 <digits>
    800004cc:	883a                	mv	a6,a4
    800004ce:	2705                	addiw	a4,a4,1
    800004d0:	02b577bb          	remuw	a5,a0,a1
    800004d4:	1782                	slli	a5,a5,0x20
    800004d6:	9381                	srli	a5,a5,0x20
    800004d8:	97b2                	add	a5,a5,a2
    800004da:	0007c783          	lbu	a5,0(a5)
    800004de:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004e2:	0005079b          	sext.w	a5,a0
    800004e6:	02b5553b          	divuw	a0,a0,a1
    800004ea:	0685                	addi	a3,a3,1
    800004ec:	feb7f0e3          	bgeu	a5,a1,800004cc <printint+0x26>

  if(sign)
    800004f0:	00088b63          	beqz	a7,80000506 <printint+0x60>
    buf[i++] = '-';
    800004f4:	fe040793          	addi	a5,s0,-32
    800004f8:	973e                	add	a4,a4,a5
    800004fa:	02d00793          	li	a5,45
    800004fe:	fef70823          	sb	a5,-16(a4)
    80000502:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000506:	02e05763          	blez	a4,80000534 <printint+0x8e>
    8000050a:	fd040793          	addi	a5,s0,-48
    8000050e:	00e784b3          	add	s1,a5,a4
    80000512:	fff78913          	addi	s2,a5,-1
    80000516:	993a                	add	s2,s2,a4
    80000518:	377d                	addiw	a4,a4,-1
    8000051a:	1702                	slli	a4,a4,0x20
    8000051c:	9301                	srli	a4,a4,0x20
    8000051e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000522:	fff4c503          	lbu	a0,-1(s1)
    80000526:	00000097          	auipc	ra,0x0
    8000052a:	ccc080e7          	jalr	-820(ra) # 800001f2 <consputc>
  while(--i >= 0)
    8000052e:	14fd                	addi	s1,s1,-1
    80000530:	ff2499e3          	bne	s1,s2,80000522 <printint+0x7c>
}
    80000534:	70a2                	ld	ra,40(sp)
    80000536:	7402                	ld	s0,32(sp)
    80000538:	64e2                	ld	s1,24(sp)
    8000053a:	6942                	ld	s2,16(sp)
    8000053c:	6145                	addi	sp,sp,48
    8000053e:	8082                	ret
    x = -xx;
    80000540:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000544:	4885                	li	a7,1
    x = -xx;
    80000546:	bf9d                	j	800004bc <printint+0x16>

0000000080000548 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000548:	1101                	addi	sp,sp,-32
    8000054a:	ec06                	sd	ra,24(sp)
    8000054c:	e822                	sd	s0,16(sp)
    8000054e:	e426                	sd	s1,8(sp)
    80000550:	1000                	addi	s0,sp,32
    80000552:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000554:	00011797          	auipc	a5,0x11
    80000558:	3607a623          	sw	zero,876(a5) # 800118c0 <pr+0x18>
  printf("panic: ");
    8000055c:	00007517          	auipc	a0,0x7
    80000560:	bc450513          	addi	a0,a0,-1084 # 80007120 <userret+0x90>
    80000564:	00000097          	auipc	ra,0x0
    80000568:	02e080e7          	jalr	46(ra) # 80000592 <printf>
  printf(s);
    8000056c:	8526                	mv	a0,s1
    8000056e:	00000097          	auipc	ra,0x0
    80000572:	024080e7          	jalr	36(ra) # 80000592 <printf>
  printf("\n");
    80000576:	00007517          	auipc	a0,0x7
    8000057a:	c3a50513          	addi	a0,a0,-966 # 800071b0 <userret+0x120>
    8000057e:	00000097          	auipc	ra,0x0
    80000582:	014080e7          	jalr	20(ra) # 80000592 <printf>
  panicked = 1; // freeze other CPUs
    80000586:	4785                	li	a5,1
    80000588:	00029717          	auipc	a4,0x29
    8000058c:	a6f72c23          	sw	a5,-1416(a4) # 80029000 <panicked>
  for(;;)
    80000590:	a001                	j	80000590 <panic+0x48>

0000000080000592 <printf>:
{
    80000592:	7131                	addi	sp,sp,-192
    80000594:	fc86                	sd	ra,120(sp)
    80000596:	f8a2                	sd	s0,112(sp)
    80000598:	f4a6                	sd	s1,104(sp)
    8000059a:	f0ca                	sd	s2,96(sp)
    8000059c:	ecce                	sd	s3,88(sp)
    8000059e:	e8d2                	sd	s4,80(sp)
    800005a0:	e4d6                	sd	s5,72(sp)
    800005a2:	e0da                	sd	s6,64(sp)
    800005a4:	fc5e                	sd	s7,56(sp)
    800005a6:	f862                	sd	s8,48(sp)
    800005a8:	f466                	sd	s9,40(sp)
    800005aa:	f06a                	sd	s10,32(sp)
    800005ac:	ec6e                	sd	s11,24(sp)
    800005ae:	0100                	addi	s0,sp,128
    800005b0:	8a2a                	mv	s4,a0
    800005b2:	e40c                	sd	a1,8(s0)
    800005b4:	e810                	sd	a2,16(s0)
    800005b6:	ec14                	sd	a3,24(s0)
    800005b8:	f018                	sd	a4,32(s0)
    800005ba:	f41c                	sd	a5,40(s0)
    800005bc:	03043823          	sd	a6,48(s0)
    800005c0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005c4:	00011d97          	auipc	s11,0x11
    800005c8:	2fcdad83          	lw	s11,764(s11) # 800118c0 <pr+0x18>
  if(locking)
    800005cc:	020d9b63          	bnez	s11,80000602 <printf+0x70>
  if (fmt == 0)
    800005d0:	040a0263          	beqz	s4,80000614 <printf+0x82>
  va_start(ap, fmt);
    800005d4:	00840793          	addi	a5,s0,8
    800005d8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005dc:	000a4503          	lbu	a0,0(s4)
    800005e0:	14050f63          	beqz	a0,8000073e <printf+0x1ac>
    800005e4:	4981                	li	s3,0
    if(c != '%'){
    800005e6:	02500a93          	li	s5,37
    switch(c){
    800005ea:	07000b93          	li	s7,112
  consputc('x');
    800005ee:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005f0:	00007b17          	auipc	s6,0x7
    800005f4:	2c0b0b13          	addi	s6,s6,704 # 800078b0 <digits>
    switch(c){
    800005f8:	07300c93          	li	s9,115
    800005fc:	06400c13          	li	s8,100
    80000600:	a82d                	j	8000063a <printf+0xa8>
    acquire(&pr.lock);
    80000602:	00011517          	auipc	a0,0x11
    80000606:	2a650513          	addi	a0,a0,678 # 800118a8 <pr>
    8000060a:	00000097          	auipc	ra,0x0
    8000060e:	4b4080e7          	jalr	1204(ra) # 80000abe <acquire>
    80000612:	bf7d                	j	800005d0 <printf+0x3e>
    panic("null fmt");
    80000614:	00007517          	auipc	a0,0x7
    80000618:	b1c50513          	addi	a0,a0,-1252 # 80007130 <userret+0xa0>
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	f2c080e7          	jalr	-212(ra) # 80000548 <panic>
      consputc(c);
    80000624:	00000097          	auipc	ra,0x0
    80000628:	bce080e7          	jalr	-1074(ra) # 800001f2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000062c:	2985                	addiw	s3,s3,1
    8000062e:	013a07b3          	add	a5,s4,s3
    80000632:	0007c503          	lbu	a0,0(a5)
    80000636:	10050463          	beqz	a0,8000073e <printf+0x1ac>
    if(c != '%'){
    8000063a:	ff5515e3          	bne	a0,s5,80000624 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000063e:	2985                	addiw	s3,s3,1
    80000640:	013a07b3          	add	a5,s4,s3
    80000644:	0007c783          	lbu	a5,0(a5)
    80000648:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000064c:	cbed                	beqz	a5,8000073e <printf+0x1ac>
    switch(c){
    8000064e:	05778a63          	beq	a5,s7,800006a2 <printf+0x110>
    80000652:	02fbf663          	bgeu	s7,a5,8000067e <printf+0xec>
    80000656:	09978863          	beq	a5,s9,800006e6 <printf+0x154>
    8000065a:	07800713          	li	a4,120
    8000065e:	0ce79563          	bne	a5,a4,80000728 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000662:	f8843783          	ld	a5,-120(s0)
    80000666:	00878713          	addi	a4,a5,8
    8000066a:	f8e43423          	sd	a4,-120(s0)
    8000066e:	4605                	li	a2,1
    80000670:	85ea                	mv	a1,s10
    80000672:	4388                	lw	a0,0(a5)
    80000674:	00000097          	auipc	ra,0x0
    80000678:	e32080e7          	jalr	-462(ra) # 800004a6 <printint>
      break;
    8000067c:	bf45                	j	8000062c <printf+0x9a>
    switch(c){
    8000067e:	09578f63          	beq	a5,s5,8000071c <printf+0x18a>
    80000682:	0b879363          	bne	a5,s8,80000728 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000686:	f8843783          	ld	a5,-120(s0)
    8000068a:	00878713          	addi	a4,a5,8
    8000068e:	f8e43423          	sd	a4,-120(s0)
    80000692:	4605                	li	a2,1
    80000694:	45a9                	li	a1,10
    80000696:	4388                	lw	a0,0(a5)
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	e0e080e7          	jalr	-498(ra) # 800004a6 <printint>
      break;
    800006a0:	b771                	j	8000062c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006b2:	03000513          	li	a0,48
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	b3c080e7          	jalr	-1220(ra) # 800001f2 <consputc>
  consputc('x');
    800006be:	07800513          	li	a0,120
    800006c2:	00000097          	auipc	ra,0x0
    800006c6:	b30080e7          	jalr	-1232(ra) # 800001f2 <consputc>
    800006ca:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006cc:	03c95793          	srli	a5,s2,0x3c
    800006d0:	97da                	add	a5,a5,s6
    800006d2:	0007c503          	lbu	a0,0(a5)
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	b1c080e7          	jalr	-1252(ra) # 800001f2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006de:	0912                	slli	s2,s2,0x4
    800006e0:	34fd                	addiw	s1,s1,-1
    800006e2:	f4ed                	bnez	s1,800006cc <printf+0x13a>
    800006e4:	b7a1                	j	8000062c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006e6:	f8843783          	ld	a5,-120(s0)
    800006ea:	00878713          	addi	a4,a5,8
    800006ee:	f8e43423          	sd	a4,-120(s0)
    800006f2:	6384                	ld	s1,0(a5)
    800006f4:	cc89                	beqz	s1,8000070e <printf+0x17c>
      for(; *s; s++)
    800006f6:	0004c503          	lbu	a0,0(s1)
    800006fa:	d90d                	beqz	a0,8000062c <printf+0x9a>
        consputc(*s);
    800006fc:	00000097          	auipc	ra,0x0
    80000700:	af6080e7          	jalr	-1290(ra) # 800001f2 <consputc>
      for(; *s; s++)
    80000704:	0485                	addi	s1,s1,1
    80000706:	0004c503          	lbu	a0,0(s1)
    8000070a:	f96d                	bnez	a0,800006fc <printf+0x16a>
    8000070c:	b705                	j	8000062c <printf+0x9a>
        s = "(null)";
    8000070e:	00007497          	auipc	s1,0x7
    80000712:	a1a48493          	addi	s1,s1,-1510 # 80007128 <userret+0x98>
      for(; *s; s++)
    80000716:	02800513          	li	a0,40
    8000071a:	b7cd                	j	800006fc <printf+0x16a>
      consputc('%');
    8000071c:	8556                	mv	a0,s5
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	ad4080e7          	jalr	-1324(ra) # 800001f2 <consputc>
      break;
    80000726:	b719                	j	8000062c <printf+0x9a>
      consputc('%');
    80000728:	8556                	mv	a0,s5
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	ac8080e7          	jalr	-1336(ra) # 800001f2 <consputc>
      consputc(c);
    80000732:	8526                	mv	a0,s1
    80000734:	00000097          	auipc	ra,0x0
    80000738:	abe080e7          	jalr	-1346(ra) # 800001f2 <consputc>
      break;
    8000073c:	bdc5                	j	8000062c <printf+0x9a>
  if(locking)
    8000073e:	020d9163          	bnez	s11,80000760 <printf+0x1ce>
}
    80000742:	70e6                	ld	ra,120(sp)
    80000744:	7446                	ld	s0,112(sp)
    80000746:	74a6                	ld	s1,104(sp)
    80000748:	7906                	ld	s2,96(sp)
    8000074a:	69e6                	ld	s3,88(sp)
    8000074c:	6a46                	ld	s4,80(sp)
    8000074e:	6aa6                	ld	s5,72(sp)
    80000750:	6b06                	ld	s6,64(sp)
    80000752:	7be2                	ld	s7,56(sp)
    80000754:	7c42                	ld	s8,48(sp)
    80000756:	7ca2                	ld	s9,40(sp)
    80000758:	7d02                	ld	s10,32(sp)
    8000075a:	6de2                	ld	s11,24(sp)
    8000075c:	6129                	addi	sp,sp,192
    8000075e:	8082                	ret
    release(&pr.lock);
    80000760:	00011517          	auipc	a0,0x11
    80000764:	14850513          	addi	a0,a0,328 # 800118a8 <pr>
    80000768:	00000097          	auipc	ra,0x0
    8000076c:	3be080e7          	jalr	958(ra) # 80000b26 <release>
}
    80000770:	bfc9                	j	80000742 <printf+0x1b0>

0000000080000772 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000772:	1101                	addi	sp,sp,-32
    80000774:	ec06                	sd	ra,24(sp)
    80000776:	e822                	sd	s0,16(sp)
    80000778:	e426                	sd	s1,8(sp)
    8000077a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000077c:	00011497          	auipc	s1,0x11
    80000780:	12c48493          	addi	s1,s1,300 # 800118a8 <pr>
    80000784:	00007597          	auipc	a1,0x7
    80000788:	9bc58593          	addi	a1,a1,-1604 # 80007140 <userret+0xb0>
    8000078c:	8526                	mv	a0,s1
    8000078e:	00000097          	auipc	ra,0x0
    80000792:	222080e7          	jalr	546(ra) # 800009b0 <initlock>
  pr.locking = 1;
    80000796:	4785                	li	a5,1
    80000798:	cc9c                	sw	a5,24(s1)
}
    8000079a:	60e2                	ld	ra,24(sp)
    8000079c:	6442                	ld	s0,16(sp)
    8000079e:	64a2                	ld	s1,8(sp)
    800007a0:	6105                	addi	sp,sp,32
    800007a2:	8082                	ret

00000000800007a4 <uartinit>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

void
uartinit(void)
{
    800007a4:	1141                	addi	sp,sp,-16
    800007a6:	e422                	sd	s0,8(sp)
    800007a8:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007aa:	100007b7          	lui	a5,0x10000
    800007ae:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, 0x80);
    800007b2:	f8000713          	li	a4,-128
    800007b6:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007ba:	470d                	li	a4,3
    800007bc:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007c0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, 0x03);
    800007c4:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, 0x07);
    800007c8:	471d                	li	a4,7
    800007ca:	00e78123          	sb	a4,2(a5)

  // enable receive interrupts.
  WriteReg(IER, 0x01);
    800007ce:	4705                	li	a4,1
    800007d0:	00e780a3          	sb	a4,1(a5)
}
    800007d4:	6422                	ld	s0,8(sp)
    800007d6:	0141                	addi	sp,sp,16
    800007d8:	8082                	ret

00000000800007da <uartputc>:

// write one output character to the UART.
void
uartputc(int c)
{
    800007da:	1141                	addi	sp,sp,-16
    800007dc:	e422                	sd	s0,8(sp)
    800007de:	0800                	addi	s0,sp,16
  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & (1 << 5)) == 0)
    800007e0:	10000737          	lui	a4,0x10000
    800007e4:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800007e8:	0207f793          	andi	a5,a5,32
    800007ec:	dfe5                	beqz	a5,800007e4 <uartputc+0xa>
    ;
  WriteReg(THR, c);
    800007ee:	0ff57513          	andi	a0,a0,255
    800007f2:	100007b7          	lui	a5,0x10000
    800007f6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    800007fa:	6422                	ld	s0,8(sp)
    800007fc:	0141                	addi	sp,sp,16
    800007fe:	8082                	ret

0000000080000800 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000800:	1141                	addi	sp,sp,-16
    80000802:	e422                	sd	s0,8(sp)
    80000804:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000806:	100007b7          	lui	a5,0x10000
    8000080a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000080e:	8b85                	andi	a5,a5,1
    80000810:	cb91                	beqz	a5,80000824 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000812:	100007b7          	lui	a5,0x10000
    80000816:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000081a:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000081e:	6422                	ld	s0,8(sp)
    80000820:	0141                	addi	sp,sp,16
    80000822:	8082                	ret
    return -1;
    80000824:	557d                	li	a0,-1
    80000826:	bfe5                	j	8000081e <uartgetc+0x1e>

0000000080000828 <uartintr>:

// trap.c calls here when the uart interrupts.
void
uartintr(void)
{
    80000828:	1101                	addi	sp,sp,-32
    8000082a:	ec06                	sd	ra,24(sp)
    8000082c:	e822                	sd	s0,16(sp)
    8000082e:	e426                	sd	s1,8(sp)
    80000830:	1000                	addi	s0,sp,32
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000832:	54fd                	li	s1,-1
    80000834:	a029                	j	8000083e <uartintr+0x16>
      break;
    consoleintr(c);
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	a92080e7          	jalr	-1390(ra) # 800002c8 <consoleintr>
    int c = uartgetc();
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	fc2080e7          	jalr	-62(ra) # 80000800 <uartgetc>
    if(c == -1)
    80000846:	fe9518e3          	bne	a0,s1,80000836 <uartintr+0xe>
  }
}
    8000084a:	60e2                	ld	ra,24(sp)
    8000084c:	6442                	ld	s0,16(sp)
    8000084e:	64a2                	ld	s1,8(sp)
    80000850:	6105                	addi	sp,sp,32
    80000852:	8082                	ret

0000000080000854 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	e04a                	sd	s2,0(sp)
    8000085e:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000860:	03451793          	slli	a5,a0,0x34
    80000864:	ebb9                	bnez	a5,800008ba <kfree+0x66>
    80000866:	84aa                	mv	s1,a0
    80000868:	00028797          	auipc	a5,0x28
    8000086c:	79878793          	addi	a5,a5,1944 # 80029000 <panicked>
    80000870:	04f56563          	bltu	a0,a5,800008ba <kfree+0x66>
    80000874:	47c5                	li	a5,17
    80000876:	07ee                	slli	a5,a5,0x1b
    80000878:	04f57163          	bgeu	a0,a5,800008ba <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000087c:	6605                	lui	a2,0x1
    8000087e:	4585                	li	a1,1
    80000880:	00000097          	auipc	ra,0x0
    80000884:	302080e7          	jalr	770(ra) # 80000b82 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000888:	00011917          	auipc	s2,0x11
    8000088c:	04090913          	addi	s2,s2,64 # 800118c8 <kmem>
    80000890:	854a                	mv	a0,s2
    80000892:	00000097          	auipc	ra,0x0
    80000896:	22c080e7          	jalr	556(ra) # 80000abe <acquire>
  r->next = kmem.freelist;
    8000089a:	01893783          	ld	a5,24(s2)
    8000089e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800008a0:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800008a4:	854a                	mv	a0,s2
    800008a6:	00000097          	auipc	ra,0x0
    800008aa:	280080e7          	jalr	640(ra) # 80000b26 <release>
}
    800008ae:	60e2                	ld	ra,24(sp)
    800008b0:	6442                	ld	s0,16(sp)
    800008b2:	64a2                	ld	s1,8(sp)
    800008b4:	6902                	ld	s2,0(sp)
    800008b6:	6105                	addi	sp,sp,32
    800008b8:	8082                	ret
    panic("kfree");
    800008ba:	00007517          	auipc	a0,0x7
    800008be:	88e50513          	addi	a0,a0,-1906 # 80007148 <userret+0xb8>
    800008c2:	00000097          	auipc	ra,0x0
    800008c6:	c86080e7          	jalr	-890(ra) # 80000548 <panic>

00000000800008ca <freerange>:
{
    800008ca:	7179                	addi	sp,sp,-48
    800008cc:	f406                	sd	ra,40(sp)
    800008ce:	f022                	sd	s0,32(sp)
    800008d0:	ec26                	sd	s1,24(sp)
    800008d2:	e84a                	sd	s2,16(sp)
    800008d4:	e44e                	sd	s3,8(sp)
    800008d6:	e052                	sd	s4,0(sp)
    800008d8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800008da:	6485                	lui	s1,0x1
    800008dc:	14fd                	addi	s1,s1,-1
    800008de:	94aa                	add	s1,s1,a0
    800008e0:	757d                	lui	a0,0xfffff
    800008e2:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800008e4:	6789                	lui	a5,0x2
    800008e6:	94be                	add	s1,s1,a5
    800008e8:	0095ee63          	bltu	a1,s1,80000904 <freerange+0x3a>
    800008ec:	892e                	mv	s2,a1
    kfree(p);
    800008ee:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800008f0:	6985                	lui	s3,0x1
    kfree(p);
    800008f2:	01448533          	add	a0,s1,s4
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	f5e080e7          	jalr	-162(ra) # 80000854 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800008fe:	94ce                	add	s1,s1,s3
    80000900:	fe9979e3          	bgeu	s2,s1,800008f2 <freerange+0x28>
}
    80000904:	70a2                	ld	ra,40(sp)
    80000906:	7402                	ld	s0,32(sp)
    80000908:	64e2                	ld	s1,24(sp)
    8000090a:	6942                	ld	s2,16(sp)
    8000090c:	69a2                	ld	s3,8(sp)
    8000090e:	6a02                	ld	s4,0(sp)
    80000910:	6145                	addi	sp,sp,48
    80000912:	8082                	ret

0000000080000914 <kinit>:
{
    80000914:	1141                	addi	sp,sp,-16
    80000916:	e406                	sd	ra,8(sp)
    80000918:	e022                	sd	s0,0(sp)
    8000091a:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000091c:	00007597          	auipc	a1,0x7
    80000920:	83458593          	addi	a1,a1,-1996 # 80007150 <userret+0xc0>
    80000924:	00011517          	auipc	a0,0x11
    80000928:	fa450513          	addi	a0,a0,-92 # 800118c8 <kmem>
    8000092c:	00000097          	auipc	ra,0x0
    80000930:	084080e7          	jalr	132(ra) # 800009b0 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000934:	45c5                	li	a1,17
    80000936:	05ee                	slli	a1,a1,0x1b
    80000938:	00028517          	auipc	a0,0x28
    8000093c:	6c850513          	addi	a0,a0,1736 # 80029000 <panicked>
    80000940:	00000097          	auipc	ra,0x0
    80000944:	f8a080e7          	jalr	-118(ra) # 800008ca <freerange>
}
    80000948:	60a2                	ld	ra,8(sp)
    8000094a:	6402                	ld	s0,0(sp)
    8000094c:	0141                	addi	sp,sp,16
    8000094e:	8082                	ret

0000000080000950 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000950:	1101                	addi	sp,sp,-32
    80000952:	ec06                	sd	ra,24(sp)
    80000954:	e822                	sd	s0,16(sp)
    80000956:	e426                	sd	s1,8(sp)
    80000958:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000095a:	00011497          	auipc	s1,0x11
    8000095e:	f6e48493          	addi	s1,s1,-146 # 800118c8 <kmem>
    80000962:	8526                	mv	a0,s1
    80000964:	00000097          	auipc	ra,0x0
    80000968:	15a080e7          	jalr	346(ra) # 80000abe <acquire>
  r = kmem.freelist;
    8000096c:	6c84                	ld	s1,24(s1)
  if(r)
    8000096e:	c885                	beqz	s1,8000099e <kalloc+0x4e>
    kmem.freelist = r->next;
    80000970:	609c                	ld	a5,0(s1)
    80000972:	00011517          	auipc	a0,0x11
    80000976:	f5650513          	addi	a0,a0,-170 # 800118c8 <kmem>
    8000097a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    8000097c:	00000097          	auipc	ra,0x0
    80000980:	1aa080e7          	jalr	426(ra) # 80000b26 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000984:	6605                	lui	a2,0x1
    80000986:	4595                	li	a1,5
    80000988:	8526                	mv	a0,s1
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	1f8080e7          	jalr	504(ra) # 80000b82 <memset>
  return (void*)r;
}
    80000992:	8526                	mv	a0,s1
    80000994:	60e2                	ld	ra,24(sp)
    80000996:	6442                	ld	s0,16(sp)
    80000998:	64a2                	ld	s1,8(sp)
    8000099a:	6105                	addi	sp,sp,32
    8000099c:	8082                	ret
  release(&kmem.lock);
    8000099e:	00011517          	auipc	a0,0x11
    800009a2:	f2a50513          	addi	a0,a0,-214 # 800118c8 <kmem>
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	180080e7          	jalr	384(ra) # 80000b26 <release>
  if(r)
    800009ae:	b7d5                	j	80000992 <kalloc+0x42>

00000000800009b0 <initlock>:

uint64 ntest_and_set;

void
initlock(struct spinlock *lk, char *name)
{
    800009b0:	1141                	addi	sp,sp,-16
    800009b2:	e422                	sd	s0,8(sp)
    800009b4:	0800                	addi	s0,sp,16
  lk->name = name;
    800009b6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800009b8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800009bc:	00053823          	sd	zero,16(a0)
}
    800009c0:	6422                	ld	s0,8(sp)
    800009c2:	0141                	addi	sp,sp,16
    800009c4:	8082                	ret

00000000800009c6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800009c6:	1101                	addi	sp,sp,-32
    800009c8:	ec06                	sd	ra,24(sp)
    800009ca:	e822                	sd	s0,16(sp)
    800009cc:	e426                	sd	s1,8(sp)
    800009ce:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800009d0:	100024f3          	csrr	s1,sstatus
    800009d4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800009d8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800009da:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800009de:	00001097          	auipc	ra,0x1
    800009e2:	e24080e7          	jalr	-476(ra) # 80001802 <mycpu>
    800009e6:	5d3c                	lw	a5,120(a0)
    800009e8:	cf89                	beqz	a5,80000a02 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800009ea:	00001097          	auipc	ra,0x1
    800009ee:	e18080e7          	jalr	-488(ra) # 80001802 <mycpu>
    800009f2:	5d3c                	lw	a5,120(a0)
    800009f4:	2785                	addiw	a5,a5,1
    800009f6:	dd3c                	sw	a5,120(a0)
}
    800009f8:	60e2                	ld	ra,24(sp)
    800009fa:	6442                	ld	s0,16(sp)
    800009fc:	64a2                	ld	s1,8(sp)
    800009fe:	6105                	addi	sp,sp,32
    80000a00:	8082                	ret
    mycpu()->intena = old;
    80000a02:	00001097          	auipc	ra,0x1
    80000a06:	e00080e7          	jalr	-512(ra) # 80001802 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000a0a:	8085                	srli	s1,s1,0x1
    80000a0c:	8885                	andi	s1,s1,1
    80000a0e:	dd64                	sw	s1,124(a0)
    80000a10:	bfe9                	j	800009ea <push_off+0x24>

0000000080000a12 <pop_off>:

void
pop_off(void)
{
    80000a12:	1141                	addi	sp,sp,-16
    80000a14:	e406                	sd	ra,8(sp)
    80000a16:	e022                	sd	s0,0(sp)
    80000a18:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000a1a:	00001097          	auipc	ra,0x1
    80000a1e:	de8080e7          	jalr	-536(ra) # 80001802 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a22:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000a26:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000a28:	eb9d                	bnez	a5,80000a5e <pop_off+0x4c>
    panic("pop_off - interruptible");
  c->noff -= 1;
    80000a2a:	5d3c                	lw	a5,120(a0)
    80000a2c:	37fd                	addiw	a5,a5,-1
    80000a2e:	0007871b          	sext.w	a4,a5
    80000a32:	dd3c                	sw	a5,120(a0)
  if(c->noff < 0)
    80000a34:	02074d63          	bltz	a4,80000a6e <pop_off+0x5c>
    panic("pop_off");
  if(c->noff == 0 && c->intena)
    80000a38:	ef19                	bnez	a4,80000a56 <pop_off+0x44>
    80000a3a:	5d7c                	lw	a5,124(a0)
    80000a3c:	cf89                	beqz	a5,80000a56 <pop_off+0x44>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80000a3e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000a42:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80000a46:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a4a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000a4e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000a52:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000a56:	60a2                	ld	ra,8(sp)
    80000a58:	6402                	ld	s0,0(sp)
    80000a5a:	0141                	addi	sp,sp,16
    80000a5c:	8082                	ret
    panic("pop_off - interruptible");
    80000a5e:	00006517          	auipc	a0,0x6
    80000a62:	6fa50513          	addi	a0,a0,1786 # 80007158 <userret+0xc8>
    80000a66:	00000097          	auipc	ra,0x0
    80000a6a:	ae2080e7          	jalr	-1310(ra) # 80000548 <panic>
    panic("pop_off");
    80000a6e:	00006517          	auipc	a0,0x6
    80000a72:	70250513          	addi	a0,a0,1794 # 80007170 <userret+0xe0>
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	ad2080e7          	jalr	-1326(ra) # 80000548 <panic>

0000000080000a7e <holding>:
{
    80000a7e:	1101                	addi	sp,sp,-32
    80000a80:	ec06                	sd	ra,24(sp)
    80000a82:	e822                	sd	s0,16(sp)
    80000a84:	e426                	sd	s1,8(sp)
    80000a86:	1000                	addi	s0,sp,32
    80000a88:	84aa                	mv	s1,a0
  push_off();
    80000a8a:	00000097          	auipc	ra,0x0
    80000a8e:	f3c080e7          	jalr	-196(ra) # 800009c6 <push_off>
  r = (lk->locked && lk->cpu == mycpu());
    80000a92:	409c                	lw	a5,0(s1)
    80000a94:	ef81                	bnez	a5,80000aac <holding+0x2e>
    80000a96:	4481                	li	s1,0
  pop_off();
    80000a98:	00000097          	auipc	ra,0x0
    80000a9c:	f7a080e7          	jalr	-134(ra) # 80000a12 <pop_off>
}
    80000aa0:	8526                	mv	a0,s1
    80000aa2:	60e2                	ld	ra,24(sp)
    80000aa4:	6442                	ld	s0,16(sp)
    80000aa6:	64a2                	ld	s1,8(sp)
    80000aa8:	6105                	addi	sp,sp,32
    80000aaa:	8082                	ret
  r = (lk->locked && lk->cpu == mycpu());
    80000aac:	6884                	ld	s1,16(s1)
    80000aae:	00001097          	auipc	ra,0x1
    80000ab2:	d54080e7          	jalr	-684(ra) # 80001802 <mycpu>
    80000ab6:	8c89                	sub	s1,s1,a0
    80000ab8:	0014b493          	seqz	s1,s1
    80000abc:	bff1                	j	80000a98 <holding+0x1a>

0000000080000abe <acquire>:
{
    80000abe:	1101                	addi	sp,sp,-32
    80000ac0:	ec06                	sd	ra,24(sp)
    80000ac2:	e822                	sd	s0,16(sp)
    80000ac4:	e426                	sd	s1,8(sp)
    80000ac6:	1000                	addi	s0,sp,32
    80000ac8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000aca:	00000097          	auipc	ra,0x0
    80000ace:	efc080e7          	jalr	-260(ra) # 800009c6 <push_off>
  if(holding(lk))
    80000ad2:	8526                	mv	a0,s1
    80000ad4:	00000097          	auipc	ra,0x0
    80000ad8:	faa080e7          	jalr	-86(ra) # 80000a7e <holding>
    80000adc:	e901                	bnez	a0,80000aec <acquire+0x2e>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000ade:	4685                	li	a3,1
     __sync_fetch_and_add(&ntest_and_set, 1);
    80000ae0:	00028717          	auipc	a4,0x28
    80000ae4:	52870713          	addi	a4,a4,1320 # 80029008 <ntest_and_set>
    80000ae8:	4605                	li	a2,1
    80000aea:	a829                	j	80000b04 <acquire+0x46>
    panic("acquire");
    80000aec:	00006517          	auipc	a0,0x6
    80000af0:	68c50513          	addi	a0,a0,1676 # 80007178 <userret+0xe8>
    80000af4:	00000097          	auipc	ra,0x0
    80000af8:	a54080e7          	jalr	-1452(ra) # 80000548 <panic>
     __sync_fetch_and_add(&ntest_and_set, 1);
    80000afc:	0f50000f          	fence	iorw,ow
    80000b00:	04c7302f          	amoadd.d.aq	zero,a2,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000b04:	87b6                	mv	a5,a3
    80000b06:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000b0a:	2781                	sext.w	a5,a5
    80000b0c:	fbe5                	bnez	a5,80000afc <acquire+0x3e>
  __sync_synchronize();
    80000b0e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000b12:	00001097          	auipc	ra,0x1
    80000b16:	cf0080e7          	jalr	-784(ra) # 80001802 <mycpu>
    80000b1a:	e888                	sd	a0,16(s1)
}
    80000b1c:	60e2                	ld	ra,24(sp)
    80000b1e:	6442                	ld	s0,16(sp)
    80000b20:	64a2                	ld	s1,8(sp)
    80000b22:	6105                	addi	sp,sp,32
    80000b24:	8082                	ret

0000000080000b26 <release>:
{
    80000b26:	1101                	addi	sp,sp,-32
    80000b28:	ec06                	sd	ra,24(sp)
    80000b2a:	e822                	sd	s0,16(sp)
    80000b2c:	e426                	sd	s1,8(sp)
    80000b2e:	1000                	addi	s0,sp,32
    80000b30:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000b32:	00000097          	auipc	ra,0x0
    80000b36:	f4c080e7          	jalr	-180(ra) # 80000a7e <holding>
    80000b3a:	c115                	beqz	a0,80000b5e <release+0x38>
  lk->cpu = 0;
    80000b3c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000b40:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000b44:	0f50000f          	fence	iorw,ow
    80000b48:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	ec6080e7          	jalr	-314(ra) # 80000a12 <pop_off>
}
    80000b54:	60e2                	ld	ra,24(sp)
    80000b56:	6442                	ld	s0,16(sp)
    80000b58:	64a2                	ld	s1,8(sp)
    80000b5a:	6105                	addi	sp,sp,32
    80000b5c:	8082                	ret
    panic("release");
    80000b5e:	00006517          	auipc	a0,0x6
    80000b62:	62250513          	addi	a0,a0,1570 # 80007180 <userret+0xf0>
    80000b66:	00000097          	auipc	ra,0x0
    80000b6a:	9e2080e7          	jalr	-1566(ra) # 80000548 <panic>

0000000080000b6e <sys_ntas>:

uint64
sys_ntas(void)
{
    80000b6e:	1141                	addi	sp,sp,-16
    80000b70:	e422                	sd	s0,8(sp)
    80000b72:	0800                	addi	s0,sp,16
  return ntest_and_set;
}
    80000b74:	00028517          	auipc	a0,0x28
    80000b78:	49453503          	ld	a0,1172(a0) # 80029008 <ntest_and_set>
    80000b7c:	6422                	ld	s0,8(sp)
    80000b7e:	0141                	addi	sp,sp,16
    80000b80:	8082                	ret

0000000080000b82 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000b82:	1141                	addi	sp,sp,-16
    80000b84:	e422                	sd	s0,8(sp)
    80000b86:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000b88:	ca19                	beqz	a2,80000b9e <memset+0x1c>
    80000b8a:	87aa                	mv	a5,a0
    80000b8c:	1602                	slli	a2,a2,0x20
    80000b8e:	9201                	srli	a2,a2,0x20
    80000b90:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000b94:	00b78023          	sb	a1,0(a5) # 2000 <_entry-0x7fffe000>
  for(i = 0; i < n; i++){
    80000b98:	0785                	addi	a5,a5,1
    80000b9a:	fee79de3          	bne	a5,a4,80000b94 <memset+0x12>
  }
  return dst;
}
    80000b9e:	6422                	ld	s0,8(sp)
    80000ba0:	0141                	addi	sp,sp,16
    80000ba2:	8082                	ret

0000000080000ba4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000ba4:	1141                	addi	sp,sp,-16
    80000ba6:	e422                	sd	s0,8(sp)
    80000ba8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000baa:	ca05                	beqz	a2,80000bda <memcmp+0x36>
    80000bac:	fff6069b          	addiw	a3,a2,-1
    80000bb0:	1682                	slli	a3,a3,0x20
    80000bb2:	9281                	srli	a3,a3,0x20
    80000bb4:	0685                	addi	a3,a3,1
    80000bb6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000bb8:	00054783          	lbu	a5,0(a0)
    80000bbc:	0005c703          	lbu	a4,0(a1)
    80000bc0:	00e79863          	bne	a5,a4,80000bd0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000bc4:	0505                	addi	a0,a0,1
    80000bc6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000bc8:	fed518e3          	bne	a0,a3,80000bb8 <memcmp+0x14>
  }

  return 0;
    80000bcc:	4501                	li	a0,0
    80000bce:	a019                	j	80000bd4 <memcmp+0x30>
      return *s1 - *s2;
    80000bd0:	40e7853b          	subw	a0,a5,a4
}
    80000bd4:	6422                	ld	s0,8(sp)
    80000bd6:	0141                	addi	sp,sp,16
    80000bd8:	8082                	ret
  return 0;
    80000bda:	4501                	li	a0,0
    80000bdc:	bfe5                	j	80000bd4 <memcmp+0x30>

0000000080000bde <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000bde:	1141                	addi	sp,sp,-16
    80000be0:	e422                	sd	s0,8(sp)
    80000be2:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000be4:	02a5e563          	bltu	a1,a0,80000c0e <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000be8:	fff6069b          	addiw	a3,a2,-1
    80000bec:	ce11                	beqz	a2,80000c08 <memmove+0x2a>
    80000bee:	1682                	slli	a3,a3,0x20
    80000bf0:	9281                	srli	a3,a3,0x20
    80000bf2:	0685                	addi	a3,a3,1
    80000bf4:	96ae                	add	a3,a3,a1
    80000bf6:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000bf8:	0585                	addi	a1,a1,1
    80000bfa:	0785                	addi	a5,a5,1
    80000bfc:	fff5c703          	lbu	a4,-1(a1)
    80000c00:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000c04:	fed59ae3          	bne	a1,a3,80000bf8 <memmove+0x1a>

  return dst;
}
    80000c08:	6422                	ld	s0,8(sp)
    80000c0a:	0141                	addi	sp,sp,16
    80000c0c:	8082                	ret
  if(s < d && s + n > d){
    80000c0e:	02061713          	slli	a4,a2,0x20
    80000c12:	9301                	srli	a4,a4,0x20
    80000c14:	00e587b3          	add	a5,a1,a4
    80000c18:	fcf578e3          	bgeu	a0,a5,80000be8 <memmove+0xa>
    d += n;
    80000c1c:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000c1e:	fff6069b          	addiw	a3,a2,-1
    80000c22:	d27d                	beqz	a2,80000c08 <memmove+0x2a>
    80000c24:	02069613          	slli	a2,a3,0x20
    80000c28:	9201                	srli	a2,a2,0x20
    80000c2a:	fff64613          	not	a2,a2
    80000c2e:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000c30:	17fd                	addi	a5,a5,-1
    80000c32:	177d                	addi	a4,a4,-1
    80000c34:	0007c683          	lbu	a3,0(a5)
    80000c38:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000c3c:	fef61ae3          	bne	a2,a5,80000c30 <memmove+0x52>
    80000c40:	b7e1                	j	80000c08 <memmove+0x2a>

0000000080000c42 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000c42:	1141                	addi	sp,sp,-16
    80000c44:	e406                	sd	ra,8(sp)
    80000c46:	e022                	sd	s0,0(sp)
    80000c48:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000c4a:	00000097          	auipc	ra,0x0
    80000c4e:	f94080e7          	jalr	-108(ra) # 80000bde <memmove>
}
    80000c52:	60a2                	ld	ra,8(sp)
    80000c54:	6402                	ld	s0,0(sp)
    80000c56:	0141                	addi	sp,sp,16
    80000c58:	8082                	ret

0000000080000c5a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000c5a:	1141                	addi	sp,sp,-16
    80000c5c:	e422                	sd	s0,8(sp)
    80000c5e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000c60:	ce11                	beqz	a2,80000c7c <strncmp+0x22>
    80000c62:	00054783          	lbu	a5,0(a0)
    80000c66:	cf89                	beqz	a5,80000c80 <strncmp+0x26>
    80000c68:	0005c703          	lbu	a4,0(a1)
    80000c6c:	00f71a63          	bne	a4,a5,80000c80 <strncmp+0x26>
    n--, p++, q++;
    80000c70:	367d                	addiw	a2,a2,-1
    80000c72:	0505                	addi	a0,a0,1
    80000c74:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000c76:	f675                	bnez	a2,80000c62 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000c78:	4501                	li	a0,0
    80000c7a:	a809                	j	80000c8c <strncmp+0x32>
    80000c7c:	4501                	li	a0,0
    80000c7e:	a039                	j	80000c8c <strncmp+0x32>
  if(n == 0)
    80000c80:	ca09                	beqz	a2,80000c92 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000c82:	00054503          	lbu	a0,0(a0)
    80000c86:	0005c783          	lbu	a5,0(a1)
    80000c8a:	9d1d                	subw	a0,a0,a5
}
    80000c8c:	6422                	ld	s0,8(sp)
    80000c8e:	0141                	addi	sp,sp,16
    80000c90:	8082                	ret
    return 0;
    80000c92:	4501                	li	a0,0
    80000c94:	bfe5                	j	80000c8c <strncmp+0x32>

0000000080000c96 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000c96:	1141                	addi	sp,sp,-16
    80000c98:	e422                	sd	s0,8(sp)
    80000c9a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000c9c:	872a                	mv	a4,a0
    80000c9e:	8832                	mv	a6,a2
    80000ca0:	367d                	addiw	a2,a2,-1
    80000ca2:	01005963          	blez	a6,80000cb4 <strncpy+0x1e>
    80000ca6:	0705                	addi	a4,a4,1
    80000ca8:	0005c783          	lbu	a5,0(a1)
    80000cac:	fef70fa3          	sb	a5,-1(a4)
    80000cb0:	0585                	addi	a1,a1,1
    80000cb2:	f7f5                	bnez	a5,80000c9e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000cb4:	86ba                	mv	a3,a4
    80000cb6:	00c05c63          	blez	a2,80000cce <strncpy+0x38>
    *s++ = 0;
    80000cba:	0685                	addi	a3,a3,1
    80000cbc:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000cc0:	fff6c793          	not	a5,a3
    80000cc4:	9fb9                	addw	a5,a5,a4
    80000cc6:	010787bb          	addw	a5,a5,a6
    80000cca:	fef048e3          	bgtz	a5,80000cba <strncpy+0x24>
  return os;
}
    80000cce:	6422                	ld	s0,8(sp)
    80000cd0:	0141                	addi	sp,sp,16
    80000cd2:	8082                	ret

0000000080000cd4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000cd4:	1141                	addi	sp,sp,-16
    80000cd6:	e422                	sd	s0,8(sp)
    80000cd8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000cda:	02c05363          	blez	a2,80000d00 <safestrcpy+0x2c>
    80000cde:	fff6069b          	addiw	a3,a2,-1
    80000ce2:	1682                	slli	a3,a3,0x20
    80000ce4:	9281                	srli	a3,a3,0x20
    80000ce6:	96ae                	add	a3,a3,a1
    80000ce8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000cea:	00d58963          	beq	a1,a3,80000cfc <safestrcpy+0x28>
    80000cee:	0585                	addi	a1,a1,1
    80000cf0:	0785                	addi	a5,a5,1
    80000cf2:	fff5c703          	lbu	a4,-1(a1)
    80000cf6:	fee78fa3          	sb	a4,-1(a5)
    80000cfa:	fb65                	bnez	a4,80000cea <safestrcpy+0x16>
    ;
  *s = 0;
    80000cfc:	00078023          	sb	zero,0(a5)
  return os;
}
    80000d00:	6422                	ld	s0,8(sp)
    80000d02:	0141                	addi	sp,sp,16
    80000d04:	8082                	ret

0000000080000d06 <strlen>:

int
strlen(const char *s)
{
    80000d06:	1141                	addi	sp,sp,-16
    80000d08:	e422                	sd	s0,8(sp)
    80000d0a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000d0c:	00054783          	lbu	a5,0(a0)
    80000d10:	cf91                	beqz	a5,80000d2c <strlen+0x26>
    80000d12:	0505                	addi	a0,a0,1
    80000d14:	87aa                	mv	a5,a0
    80000d16:	4685                	li	a3,1
    80000d18:	9e89                	subw	a3,a3,a0
    80000d1a:	00f6853b          	addw	a0,a3,a5
    80000d1e:	0785                	addi	a5,a5,1
    80000d20:	fff7c703          	lbu	a4,-1(a5)
    80000d24:	fb7d                	bnez	a4,80000d1a <strlen+0x14>
    ;
  return n;
}
    80000d26:	6422                	ld	s0,8(sp)
    80000d28:	0141                	addi	sp,sp,16
    80000d2a:	8082                	ret
  for(n = 0; s[n]; n++)
    80000d2c:	4501                	li	a0,0
    80000d2e:	bfe5                	j	80000d26 <strlen+0x20>

0000000080000d30 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000d30:	1141                	addi	sp,sp,-16
    80000d32:	e406                	sd	ra,8(sp)
    80000d34:	e022                	sd	s0,0(sp)
    80000d36:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000d38:	00001097          	auipc	ra,0x1
    80000d3c:	aba080e7          	jalr	-1350(ra) # 800017f2 <cpuid>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000d40:	00028717          	auipc	a4,0x28
    80000d44:	2d070713          	addi	a4,a4,720 # 80029010 <started>
  if(cpuid() == 0){
    80000d48:	c139                	beqz	a0,80000d8e <main+0x5e>
    while(started == 0)
    80000d4a:	431c                	lw	a5,0(a4)
    80000d4c:	2781                	sext.w	a5,a5
    80000d4e:	dff5                	beqz	a5,80000d4a <main+0x1a>
      ;
    __sync_synchronize();
    80000d50:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000d54:	00001097          	auipc	ra,0x1
    80000d58:	a9e080e7          	jalr	-1378(ra) # 800017f2 <cpuid>
    80000d5c:	85aa                	mv	a1,a0
    80000d5e:	00006517          	auipc	a0,0x6
    80000d62:	44250513          	addi	a0,a0,1090 # 800071a0 <userret+0x110>
    80000d66:	00000097          	auipc	ra,0x0
    80000d6a:	82c080e7          	jalr	-2004(ra) # 80000592 <printf>
    kvminithart();    // turn on paging
    80000d6e:	00000097          	auipc	ra,0x0
    80000d72:	1ea080e7          	jalr	490(ra) # 80000f58 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000d76:	00001097          	auipc	ra,0x1
    80000d7a:	6c0080e7          	jalr	1728(ra) # 80002436 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000d7e:	00005097          	auipc	ra,0x5
    80000d82:	eb2080e7          	jalr	-334(ra) # 80005c30 <plicinithart>
  }

  scheduler();        
    80000d86:	00001097          	auipc	ra,0x1
    80000d8a:	fda080e7          	jalr	-38(ra) # 80001d60 <scheduler>
    consoleinit();
    80000d8e:	fffff097          	auipc	ra,0xfffff
    80000d92:	6cc080e7          	jalr	1740(ra) # 8000045a <consoleinit>
    printfinit();
    80000d96:	00000097          	auipc	ra,0x0
    80000d9a:	9dc080e7          	jalr	-1572(ra) # 80000772 <printfinit>
    printf("\n");
    80000d9e:	00006517          	auipc	a0,0x6
    80000da2:	41250513          	addi	a0,a0,1042 # 800071b0 <userret+0x120>
    80000da6:	fffff097          	auipc	ra,0xfffff
    80000daa:	7ec080e7          	jalr	2028(ra) # 80000592 <printf>
    printf("xv6 kernel is booting\n");
    80000dae:	00006517          	auipc	a0,0x6
    80000db2:	3da50513          	addi	a0,a0,986 # 80007188 <userret+0xf8>
    80000db6:	fffff097          	auipc	ra,0xfffff
    80000dba:	7dc080e7          	jalr	2012(ra) # 80000592 <printf>
    printf("\n");
    80000dbe:	00006517          	auipc	a0,0x6
    80000dc2:	3f250513          	addi	a0,a0,1010 # 800071b0 <userret+0x120>
    80000dc6:	fffff097          	auipc	ra,0xfffff
    80000dca:	7cc080e7          	jalr	1996(ra) # 80000592 <printf>
    kinit();         // physical page allocator
    80000dce:	00000097          	auipc	ra,0x0
    80000dd2:	b46080e7          	jalr	-1210(ra) # 80000914 <kinit>
    kvminit();       // create kernel page table
    80000dd6:	00000097          	auipc	ra,0x0
    80000dda:	300080e7          	jalr	768(ra) # 800010d6 <kvminit>
    kvminithart();   // turn on paging
    80000dde:	00000097          	auipc	ra,0x0
    80000de2:	17a080e7          	jalr	378(ra) # 80000f58 <kvminithart>
    procinit();      // process table
    80000de6:	00001097          	auipc	ra,0x1
    80000dea:	93c080e7          	jalr	-1732(ra) # 80001722 <procinit>
    trapinit();      // trap vectors
    80000dee:	00001097          	auipc	ra,0x1
    80000df2:	620080e7          	jalr	1568(ra) # 8000240e <trapinit>
    trapinithart();  // install kernel trap vector
    80000df6:	00001097          	auipc	ra,0x1
    80000dfa:	640080e7          	jalr	1600(ra) # 80002436 <trapinithart>
    plicinit();      // set up interrupt controller
    80000dfe:	00005097          	auipc	ra,0x5
    80000e02:	e1c080e7          	jalr	-484(ra) # 80005c1a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000e06:	00005097          	auipc	ra,0x5
    80000e0a:	e2a080e7          	jalr	-470(ra) # 80005c30 <plicinithart>
    binit();         // buffer cache
    80000e0e:	00002097          	auipc	ra,0x2
    80000e12:	d2c080e7          	jalr	-724(ra) # 80002b3a <binit>
    iinit();         // inode cache
    80000e16:	00002097          	auipc	ra,0x2
    80000e1a:	3c2080e7          	jalr	962(ra) # 800031d8 <iinit>
    fileinit();      // file table
    80000e1e:	00003097          	auipc	ra,0x3
    80000e22:	5a0080e7          	jalr	1440(ra) # 800043be <fileinit>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    80000e26:	4501                	li	a0,0
    80000e28:	00005097          	auipc	ra,0x5
    80000e2c:	f3c080e7          	jalr	-196(ra) # 80005d64 <virtio_disk_init>
    userinit();      // first user process
    80000e30:	00001097          	auipc	ra,0x1
    80000e34:	c5e080e7          	jalr	-930(ra) # 80001a8e <userinit>
    __sync_synchronize();
    80000e38:	0ff0000f          	fence
    started = 1;
    80000e3c:	4785                	li	a5,1
    80000e3e:	00028717          	auipc	a4,0x28
    80000e42:	1cf72923          	sw	a5,466(a4) # 80029010 <started>
    80000e46:	b781                	j	80000d86 <main+0x56>

0000000080000e48 <walk>:
//   21..39 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..12 -- 12 bits of byte offset within the page.
static pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000e48:	7139                	addi	sp,sp,-64
    80000e4a:	fc06                	sd	ra,56(sp)
    80000e4c:	f822                	sd	s0,48(sp)
    80000e4e:	f426                	sd	s1,40(sp)
    80000e50:	f04a                	sd	s2,32(sp)
    80000e52:	ec4e                	sd	s3,24(sp)
    80000e54:	e852                	sd	s4,16(sp)
    80000e56:	e456                	sd	s5,8(sp)
    80000e58:	e05a                	sd	s6,0(sp)
    80000e5a:	0080                	addi	s0,sp,64
    80000e5c:	84aa                	mv	s1,a0
    80000e5e:	89ae                	mv	s3,a1
    80000e60:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000e62:	57fd                	li	a5,-1
    80000e64:	83e9                	srli	a5,a5,0x1a
    80000e66:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000e68:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000e6a:	04b7f263          	bgeu	a5,a1,80000eae <walk+0x66>
    panic("walk");
    80000e6e:	00006517          	auipc	a0,0x6
    80000e72:	34a50513          	addi	a0,a0,842 # 800071b8 <userret+0x128>
    80000e76:	fffff097          	auipc	ra,0xfffff
    80000e7a:	6d2080e7          	jalr	1746(ra) # 80000548 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000e7e:	060a8663          	beqz	s5,80000eea <walk+0xa2>
    80000e82:	00000097          	auipc	ra,0x0
    80000e86:	ace080e7          	jalr	-1330(ra) # 80000950 <kalloc>
    80000e8a:	84aa                	mv	s1,a0
    80000e8c:	c529                	beqz	a0,80000ed6 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000e8e:	6605                	lui	a2,0x1
    80000e90:	4581                	li	a1,0
    80000e92:	00000097          	auipc	ra,0x0
    80000e96:	cf0080e7          	jalr	-784(ra) # 80000b82 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000e9a:	00c4d793          	srli	a5,s1,0xc
    80000e9e:	07aa                	slli	a5,a5,0xa
    80000ea0:	0017e793          	ori	a5,a5,1
    80000ea4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000ea8:	3a5d                	addiw	s4,s4,-9
    80000eaa:	036a0063          	beq	s4,s6,80000eca <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000eae:	0149d933          	srl	s2,s3,s4
    80000eb2:	1ff97913          	andi	s2,s2,511
    80000eb6:	090e                	slli	s2,s2,0x3
    80000eb8:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000eba:	00093483          	ld	s1,0(s2)
    80000ebe:	0014f793          	andi	a5,s1,1
    80000ec2:	dfd5                	beqz	a5,80000e7e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000ec4:	80a9                	srli	s1,s1,0xa
    80000ec6:	04b2                	slli	s1,s1,0xc
    80000ec8:	b7c5                	j	80000ea8 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000eca:	00c9d513          	srli	a0,s3,0xc
    80000ece:	1ff57513          	andi	a0,a0,511
    80000ed2:	050e                	slli	a0,a0,0x3
    80000ed4:	9526                	add	a0,a0,s1
}
    80000ed6:	70e2                	ld	ra,56(sp)
    80000ed8:	7442                	ld	s0,48(sp)
    80000eda:	74a2                	ld	s1,40(sp)
    80000edc:	7902                	ld	s2,32(sp)
    80000ede:	69e2                	ld	s3,24(sp)
    80000ee0:	6a42                	ld	s4,16(sp)
    80000ee2:	6aa2                	ld	s5,8(sp)
    80000ee4:	6b02                	ld	s6,0(sp)
    80000ee6:	6121                	addi	sp,sp,64
    80000ee8:	8082                	ret
        return 0;
    80000eea:	4501                	li	a0,0
    80000eec:	b7ed                	j	80000ed6 <walk+0x8e>

0000000080000eee <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void
freewalk(pagetable_t pagetable)
{
    80000eee:	7179                	addi	sp,sp,-48
    80000ef0:	f406                	sd	ra,40(sp)
    80000ef2:	f022                	sd	s0,32(sp)
    80000ef4:	ec26                	sd	s1,24(sp)
    80000ef6:	e84a                	sd	s2,16(sp)
    80000ef8:	e44e                	sd	s3,8(sp)
    80000efa:	e052                	sd	s4,0(sp)
    80000efc:	1800                	addi	s0,sp,48
    80000efe:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000f00:	84aa                	mv	s1,a0
    80000f02:	6905                	lui	s2,0x1
    80000f04:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000f06:	4985                	li	s3,1
    80000f08:	a821                	j	80000f20 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000f0a:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000f0c:	0532                	slli	a0,a0,0xc
    80000f0e:	00000097          	auipc	ra,0x0
    80000f12:	fe0080e7          	jalr	-32(ra) # 80000eee <freewalk>
      pagetable[i] = 0;
    80000f16:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000f1a:	04a1                	addi	s1,s1,8
    80000f1c:	03248163          	beq	s1,s2,80000f3e <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000f20:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000f22:	00f57793          	andi	a5,a0,15
    80000f26:	ff3782e3          	beq	a5,s3,80000f0a <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000f2a:	8905                	andi	a0,a0,1
    80000f2c:	d57d                	beqz	a0,80000f1a <freewalk+0x2c>
      panic("freewalk: leaf");
    80000f2e:	00006517          	auipc	a0,0x6
    80000f32:	29250513          	addi	a0,a0,658 # 800071c0 <userret+0x130>
    80000f36:	fffff097          	auipc	ra,0xfffff
    80000f3a:	612080e7          	jalr	1554(ra) # 80000548 <panic>
    }
  }
  kfree((void*)pagetable);
    80000f3e:	8552                	mv	a0,s4
    80000f40:	00000097          	auipc	ra,0x0
    80000f44:	914080e7          	jalr	-1772(ra) # 80000854 <kfree>
}
    80000f48:	70a2                	ld	ra,40(sp)
    80000f4a:	7402                	ld	s0,32(sp)
    80000f4c:	64e2                	ld	s1,24(sp)
    80000f4e:	6942                	ld	s2,16(sp)
    80000f50:	69a2                	ld	s3,8(sp)
    80000f52:	6a02                	ld	s4,0(sp)
    80000f54:	6145                	addi	sp,sp,48
    80000f56:	8082                	ret

0000000080000f58 <kvminithart>:
{
    80000f58:	1141                	addi	sp,sp,-16
    80000f5a:	e422                	sd	s0,8(sp)
    80000f5c:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f5e:	00028797          	auipc	a5,0x28
    80000f62:	0ba7b783          	ld	a5,186(a5) # 80029018 <kernel_pagetable>
    80000f66:	83b1                	srli	a5,a5,0xc
    80000f68:	577d                	li	a4,-1
    80000f6a:	177e                	slli	a4,a4,0x3f
    80000f6c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f6e:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f72:	12000073          	sfence.vma
}
    80000f76:	6422                	ld	s0,8(sp)
    80000f78:	0141                	addi	sp,sp,16
    80000f7a:	8082                	ret

0000000080000f7c <walkaddr>:
{
    80000f7c:	1141                	addi	sp,sp,-16
    80000f7e:	e406                	sd	ra,8(sp)
    80000f80:	e022                	sd	s0,0(sp)
    80000f82:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000f84:	4601                	li	a2,0
    80000f86:	00000097          	auipc	ra,0x0
    80000f8a:	ec2080e7          	jalr	-318(ra) # 80000e48 <walk>
  if(pte == 0)
    80000f8e:	c105                	beqz	a0,80000fae <walkaddr+0x32>
  if((*pte & PTE_V) == 0)
    80000f90:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000f92:	0117f693          	andi	a3,a5,17
    80000f96:	4745                	li	a4,17
    return 0;
    80000f98:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000f9a:	00e68663          	beq	a3,a4,80000fa6 <walkaddr+0x2a>
}
    80000f9e:	60a2                	ld	ra,8(sp)
    80000fa0:	6402                	ld	s0,0(sp)
    80000fa2:	0141                	addi	sp,sp,16
    80000fa4:	8082                	ret
  pa = PTE2PA(*pte);
    80000fa6:	83a9                	srli	a5,a5,0xa
    80000fa8:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000fac:	bfcd                	j	80000f9e <walkaddr+0x22>
    return 0;
    80000fae:	4501                	li	a0,0
    80000fb0:	b7fd                	j	80000f9e <walkaddr+0x22>

0000000080000fb2 <kvmpa>:
{
    80000fb2:	1101                	addi	sp,sp,-32
    80000fb4:	ec06                	sd	ra,24(sp)
    80000fb6:	e822                	sd	s0,16(sp)
    80000fb8:	e426                	sd	s1,8(sp)
    80000fba:	1000                	addi	s0,sp,32
    80000fbc:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    80000fbe:	1552                	slli	a0,a0,0x34
    80000fc0:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    80000fc4:	4601                	li	a2,0
    80000fc6:	00028517          	auipc	a0,0x28
    80000fca:	05253503          	ld	a0,82(a0) # 80029018 <kernel_pagetable>
    80000fce:	00000097          	auipc	ra,0x0
    80000fd2:	e7a080e7          	jalr	-390(ra) # 80000e48 <walk>
  if(pte == 0)
    80000fd6:	cd09                	beqz	a0,80000ff0 <kvmpa+0x3e>
  if((*pte & PTE_V) == 0)
    80000fd8:	6108                	ld	a0,0(a0)
    80000fda:	00157793          	andi	a5,a0,1
    80000fde:	c38d                	beqz	a5,80001000 <kvmpa+0x4e>
  pa = PTE2PA(*pte);
    80000fe0:	8129                	srli	a0,a0,0xa
    80000fe2:	0532                	slli	a0,a0,0xc
}
    80000fe4:	9526                	add	a0,a0,s1
    80000fe6:	60e2                	ld	ra,24(sp)
    80000fe8:	6442                	ld	s0,16(sp)
    80000fea:	64a2                	ld	s1,8(sp)
    80000fec:	6105                	addi	sp,sp,32
    80000fee:	8082                	ret
    panic("kvmpa");
    80000ff0:	00006517          	auipc	a0,0x6
    80000ff4:	1e050513          	addi	a0,a0,480 # 800071d0 <userret+0x140>
    80000ff8:	fffff097          	auipc	ra,0xfffff
    80000ffc:	550080e7          	jalr	1360(ra) # 80000548 <panic>
    panic("kvmpa");
    80001000:	00006517          	auipc	a0,0x6
    80001004:	1d050513          	addi	a0,a0,464 # 800071d0 <userret+0x140>
    80001008:	fffff097          	auipc	ra,0xfffff
    8000100c:	540080e7          	jalr	1344(ra) # 80000548 <panic>

0000000080001010 <mappages>:
{
    80001010:	715d                	addi	sp,sp,-80
    80001012:	e486                	sd	ra,72(sp)
    80001014:	e0a2                	sd	s0,64(sp)
    80001016:	fc26                	sd	s1,56(sp)
    80001018:	f84a                	sd	s2,48(sp)
    8000101a:	f44e                	sd	s3,40(sp)
    8000101c:	f052                	sd	s4,32(sp)
    8000101e:	ec56                	sd	s5,24(sp)
    80001020:	e85a                	sd	s6,16(sp)
    80001022:	e45e                	sd	s7,8(sp)
    80001024:	0880                	addi	s0,sp,80
    80001026:	8aaa                	mv	s5,a0
    80001028:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    8000102a:	777d                	lui	a4,0xfffff
    8000102c:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001030:	167d                	addi	a2,a2,-1
    80001032:	00b609b3          	add	s3,a2,a1
    80001036:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000103a:	893e                	mv	s2,a5
    8000103c:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    80001040:	6b85                	lui	s7,0x1
    80001042:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001046:	4605                	li	a2,1
    80001048:	85ca                	mv	a1,s2
    8000104a:	8556                	mv	a0,s5
    8000104c:	00000097          	auipc	ra,0x0
    80001050:	dfc080e7          	jalr	-516(ra) # 80000e48 <walk>
    80001054:	c51d                	beqz	a0,80001082 <mappages+0x72>
    if(*pte & PTE_V)
    80001056:	611c                	ld	a5,0(a0)
    80001058:	8b85                	andi	a5,a5,1
    8000105a:	ef81                	bnez	a5,80001072 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000105c:	80b1                	srli	s1,s1,0xc
    8000105e:	04aa                	slli	s1,s1,0xa
    80001060:	0164e4b3          	or	s1,s1,s6
    80001064:	0014e493          	ori	s1,s1,1
    80001068:	e104                	sd	s1,0(a0)
    if(a == last)
    8000106a:	03390863          	beq	s2,s3,8000109a <mappages+0x8a>
    a += PGSIZE;
    8000106e:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001070:	bfc9                	j	80001042 <mappages+0x32>
      panic("remap");
    80001072:	00006517          	auipc	a0,0x6
    80001076:	16650513          	addi	a0,a0,358 # 800071d8 <userret+0x148>
    8000107a:	fffff097          	auipc	ra,0xfffff
    8000107e:	4ce080e7          	jalr	1230(ra) # 80000548 <panic>
      return -1;
    80001082:	557d                	li	a0,-1
}
    80001084:	60a6                	ld	ra,72(sp)
    80001086:	6406                	ld	s0,64(sp)
    80001088:	74e2                	ld	s1,56(sp)
    8000108a:	7942                	ld	s2,48(sp)
    8000108c:	79a2                	ld	s3,40(sp)
    8000108e:	7a02                	ld	s4,32(sp)
    80001090:	6ae2                	ld	s5,24(sp)
    80001092:	6b42                	ld	s6,16(sp)
    80001094:	6ba2                	ld	s7,8(sp)
    80001096:	6161                	addi	sp,sp,80
    80001098:	8082                	ret
  return 0;
    8000109a:	4501                	li	a0,0
    8000109c:	b7e5                	j	80001084 <mappages+0x74>

000000008000109e <kvmmap>:
{
    8000109e:	1141                	addi	sp,sp,-16
    800010a0:	e406                	sd	ra,8(sp)
    800010a2:	e022                	sd	s0,0(sp)
    800010a4:	0800                	addi	s0,sp,16
    800010a6:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800010a8:	86ae                	mv	a3,a1
    800010aa:	85aa                	mv	a1,a0
    800010ac:	00028517          	auipc	a0,0x28
    800010b0:	f6c53503          	ld	a0,-148(a0) # 80029018 <kernel_pagetable>
    800010b4:	00000097          	auipc	ra,0x0
    800010b8:	f5c080e7          	jalr	-164(ra) # 80001010 <mappages>
    800010bc:	e509                	bnez	a0,800010c6 <kvmmap+0x28>
}
    800010be:	60a2                	ld	ra,8(sp)
    800010c0:	6402                	ld	s0,0(sp)
    800010c2:	0141                	addi	sp,sp,16
    800010c4:	8082                	ret
    panic("kvmmap");
    800010c6:	00006517          	auipc	a0,0x6
    800010ca:	11a50513          	addi	a0,a0,282 # 800071e0 <userret+0x150>
    800010ce:	fffff097          	auipc	ra,0xfffff
    800010d2:	47a080e7          	jalr	1146(ra) # 80000548 <panic>

00000000800010d6 <kvminit>:
{
    800010d6:	1101                	addi	sp,sp,-32
    800010d8:	ec06                	sd	ra,24(sp)
    800010da:	e822                	sd	s0,16(sp)
    800010dc:	e426                	sd	s1,8(sp)
    800010de:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    800010e0:	00000097          	auipc	ra,0x0
    800010e4:	870080e7          	jalr	-1936(ra) # 80000950 <kalloc>
    800010e8:	00028797          	auipc	a5,0x28
    800010ec:	f2a7b823          	sd	a0,-208(a5) # 80029018 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    800010f0:	6605                	lui	a2,0x1
    800010f2:	4581                	li	a1,0
    800010f4:	00000097          	auipc	ra,0x0
    800010f8:	a8e080e7          	jalr	-1394(ra) # 80000b82 <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800010fc:	4699                	li	a3,6
    800010fe:	6605                	lui	a2,0x1
    80001100:	100005b7          	lui	a1,0x10000
    80001104:	10000537          	lui	a0,0x10000
    80001108:	00000097          	auipc	ra,0x0
    8000110c:	f96080e7          	jalr	-106(ra) # 8000109e <kvmmap>
  kvmmap(VIRTION(0), VIRTION(0), PGSIZE, PTE_R | PTE_W);
    80001110:	4699                	li	a3,6
    80001112:	6605                	lui	a2,0x1
    80001114:	100015b7          	lui	a1,0x10001
    80001118:	10001537          	lui	a0,0x10001
    8000111c:	00000097          	auipc	ra,0x0
    80001120:	f82080e7          	jalr	-126(ra) # 8000109e <kvmmap>
  kvmmap(VIRTION(1), VIRTION(1), PGSIZE, PTE_R | PTE_W);
    80001124:	4699                	li	a3,6
    80001126:	6605                	lui	a2,0x1
    80001128:	100025b7          	lui	a1,0x10002
    8000112c:	10002537          	lui	a0,0x10002
    80001130:	00000097          	auipc	ra,0x0
    80001134:	f6e080e7          	jalr	-146(ra) # 8000109e <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001138:	4699                	li	a3,6
    8000113a:	6641                	lui	a2,0x10
    8000113c:	020005b7          	lui	a1,0x2000
    80001140:	02000537          	lui	a0,0x2000
    80001144:	00000097          	auipc	ra,0x0
    80001148:	f5a080e7          	jalr	-166(ra) # 8000109e <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000114c:	4699                	li	a3,6
    8000114e:	00400637          	lui	a2,0x400
    80001152:	0c0005b7          	lui	a1,0xc000
    80001156:	0c000537          	lui	a0,0xc000
    8000115a:	00000097          	auipc	ra,0x0
    8000115e:	f44080e7          	jalr	-188(ra) # 8000109e <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001162:	00007497          	auipc	s1,0x7
    80001166:	e9e48493          	addi	s1,s1,-354 # 80008000 <initcode>
    8000116a:	46a9                	li	a3,10
    8000116c:	80007617          	auipc	a2,0x80007
    80001170:	e9460613          	addi	a2,a2,-364 # 8000 <_entry-0x7fff8000>
    80001174:	4585                	li	a1,1
    80001176:	05fe                	slli	a1,a1,0x1f
    80001178:	852e                	mv	a0,a1
    8000117a:	00000097          	auipc	ra,0x0
    8000117e:	f24080e7          	jalr	-220(ra) # 8000109e <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001182:	4699                	li	a3,6
    80001184:	4645                	li	a2,17
    80001186:	066e                	slli	a2,a2,0x1b
    80001188:	8e05                	sub	a2,a2,s1
    8000118a:	85a6                	mv	a1,s1
    8000118c:	8526                	mv	a0,s1
    8000118e:	00000097          	auipc	ra,0x0
    80001192:	f10080e7          	jalr	-240(ra) # 8000109e <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001196:	46a9                	li	a3,10
    80001198:	6605                	lui	a2,0x1
    8000119a:	00006597          	auipc	a1,0x6
    8000119e:	e6658593          	addi	a1,a1,-410 # 80007000 <trampoline>
    800011a2:	04000537          	lui	a0,0x4000
    800011a6:	157d                	addi	a0,a0,-1
    800011a8:	0532                	slli	a0,a0,0xc
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	ef4080e7          	jalr	-268(ra) # 8000109e <kvmmap>
}
    800011b2:	60e2                	ld	ra,24(sp)
    800011b4:	6442                	ld	s0,16(sp)
    800011b6:	64a2                	ld	s1,8(sp)
    800011b8:	6105                	addi	sp,sp,32
    800011ba:	8082                	ret

00000000800011bc <uvmunmap>:
{
    800011bc:	715d                	addi	sp,sp,-80
    800011be:	e486                	sd	ra,72(sp)
    800011c0:	e0a2                	sd	s0,64(sp)
    800011c2:	fc26                	sd	s1,56(sp)
    800011c4:	f84a                	sd	s2,48(sp)
    800011c6:	f44e                	sd	s3,40(sp)
    800011c8:	f052                	sd	s4,32(sp)
    800011ca:	ec56                	sd	s5,24(sp)
    800011cc:	e85a                	sd	s6,16(sp)
    800011ce:	e45e                	sd	s7,8(sp)
    800011d0:	0880                	addi	s0,sp,80
    800011d2:	8a2a                	mv	s4,a0
    800011d4:	8ab6                	mv	s5,a3
  a = PGROUNDDOWN(va);
    800011d6:	77fd                	lui	a5,0xfffff
    800011d8:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800011dc:	167d                	addi	a2,a2,-1
    800011de:	00b609b3          	add	s3,a2,a1
    800011e2:	00f9f9b3          	and	s3,s3,a5
    if(PTE_FLAGS(*pte) == PTE_V)
    800011e6:	4b05                	li	s6,1
    a += PGSIZE;
    800011e8:	6b85                	lui	s7,0x1
    800011ea:	a0b9                	j	80001238 <uvmunmap+0x7c>
      panic("uvmunmap: walk");
    800011ec:	00006517          	auipc	a0,0x6
    800011f0:	ffc50513          	addi	a0,a0,-4 # 800071e8 <userret+0x158>
    800011f4:	fffff097          	auipc	ra,0xfffff
    800011f8:	354080e7          	jalr	852(ra) # 80000548 <panic>
      printf("va=%p pte=%p\n", a, *pte);
    800011fc:	85ca                	mv	a1,s2
    800011fe:	00006517          	auipc	a0,0x6
    80001202:	ffa50513          	addi	a0,a0,-6 # 800071f8 <userret+0x168>
    80001206:	fffff097          	auipc	ra,0xfffff
    8000120a:	38c080e7          	jalr	908(ra) # 80000592 <printf>
      panic("uvmunmap: not mapped");
    8000120e:	00006517          	auipc	a0,0x6
    80001212:	ffa50513          	addi	a0,a0,-6 # 80007208 <userret+0x178>
    80001216:	fffff097          	auipc	ra,0xfffff
    8000121a:	332080e7          	jalr	818(ra) # 80000548 <panic>
      panic("uvmunmap: not a leaf");
    8000121e:	00006517          	auipc	a0,0x6
    80001222:	00250513          	addi	a0,a0,2 # 80007220 <userret+0x190>
    80001226:	fffff097          	auipc	ra,0xfffff
    8000122a:	322080e7          	jalr	802(ra) # 80000548 <panic>
    *pte = 0;
    8000122e:	0004b023          	sd	zero,0(s1)
    if(a == last)
    80001232:	03390e63          	beq	s2,s3,8000126e <uvmunmap+0xb2>
    a += PGSIZE;
    80001236:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 0)) == 0)
    80001238:	4601                	li	a2,0
    8000123a:	85ca                	mv	a1,s2
    8000123c:	8552                	mv	a0,s4
    8000123e:	00000097          	auipc	ra,0x0
    80001242:	c0a080e7          	jalr	-1014(ra) # 80000e48 <walk>
    80001246:	84aa                	mv	s1,a0
    80001248:	d155                	beqz	a0,800011ec <uvmunmap+0x30>
    if((*pte & PTE_V) == 0){
    8000124a:	6110                	ld	a2,0(a0)
    8000124c:	00167793          	andi	a5,a2,1
    80001250:	d7d5                	beqz	a5,800011fc <uvmunmap+0x40>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001252:	01f67793          	andi	a5,a2,31
    80001256:	fd6784e3          	beq	a5,s6,8000121e <uvmunmap+0x62>
    if(do_free){
    8000125a:	fc0a8ae3          	beqz	s5,8000122e <uvmunmap+0x72>
      pa = PTE2PA(*pte);
    8000125e:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    80001260:	00c61513          	slli	a0,a2,0xc
    80001264:	fffff097          	auipc	ra,0xfffff
    80001268:	5f0080e7          	jalr	1520(ra) # 80000854 <kfree>
    8000126c:	b7c9                	j	8000122e <uvmunmap+0x72>
}
    8000126e:	60a6                	ld	ra,72(sp)
    80001270:	6406                	ld	s0,64(sp)
    80001272:	74e2                	ld	s1,56(sp)
    80001274:	7942                	ld	s2,48(sp)
    80001276:	79a2                	ld	s3,40(sp)
    80001278:	7a02                	ld	s4,32(sp)
    8000127a:	6ae2                	ld	s5,24(sp)
    8000127c:	6b42                	ld	s6,16(sp)
    8000127e:	6ba2                	ld	s7,8(sp)
    80001280:	6161                	addi	sp,sp,80
    80001282:	8082                	ret

0000000080001284 <uvmcreate>:
{
    80001284:	1101                	addi	sp,sp,-32
    80001286:	ec06                	sd	ra,24(sp)
    80001288:	e822                	sd	s0,16(sp)
    8000128a:	e426                	sd	s1,8(sp)
    8000128c:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    8000128e:	fffff097          	auipc	ra,0xfffff
    80001292:	6c2080e7          	jalr	1730(ra) # 80000950 <kalloc>
  if(pagetable == 0)
    80001296:	cd11                	beqz	a0,800012b2 <uvmcreate+0x2e>
    80001298:	84aa                	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
    8000129a:	6605                	lui	a2,0x1
    8000129c:	4581                	li	a1,0
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	8e4080e7          	jalr	-1820(ra) # 80000b82 <memset>
}
    800012a6:	8526                	mv	a0,s1
    800012a8:	60e2                	ld	ra,24(sp)
    800012aa:	6442                	ld	s0,16(sp)
    800012ac:	64a2                	ld	s1,8(sp)
    800012ae:	6105                	addi	sp,sp,32
    800012b0:	8082                	ret
    panic("uvmcreate: out of memory");
    800012b2:	00006517          	auipc	a0,0x6
    800012b6:	f8650513          	addi	a0,a0,-122 # 80007238 <userret+0x1a8>
    800012ba:	fffff097          	auipc	ra,0xfffff
    800012be:	28e080e7          	jalr	654(ra) # 80000548 <panic>

00000000800012c2 <uvminit>:
{
    800012c2:	7179                	addi	sp,sp,-48
    800012c4:	f406                	sd	ra,40(sp)
    800012c6:	f022                	sd	s0,32(sp)
    800012c8:	ec26                	sd	s1,24(sp)
    800012ca:	e84a                	sd	s2,16(sp)
    800012cc:	e44e                	sd	s3,8(sp)
    800012ce:	e052                	sd	s4,0(sp)
    800012d0:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    800012d2:	6785                	lui	a5,0x1
    800012d4:	04f67863          	bgeu	a2,a5,80001324 <uvminit+0x62>
    800012d8:	8a2a                	mv	s4,a0
    800012da:	89ae                	mv	s3,a1
    800012dc:	84b2                	mv	s1,a2
  mem = kalloc();
    800012de:	fffff097          	auipc	ra,0xfffff
    800012e2:	672080e7          	jalr	1650(ra) # 80000950 <kalloc>
    800012e6:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012e8:	6605                	lui	a2,0x1
    800012ea:	4581                	li	a1,0
    800012ec:	00000097          	auipc	ra,0x0
    800012f0:	896080e7          	jalr	-1898(ra) # 80000b82 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012f4:	4779                	li	a4,30
    800012f6:	86ca                	mv	a3,s2
    800012f8:	6605                	lui	a2,0x1
    800012fa:	4581                	li	a1,0
    800012fc:	8552                	mv	a0,s4
    800012fe:	00000097          	auipc	ra,0x0
    80001302:	d12080e7          	jalr	-750(ra) # 80001010 <mappages>
  memmove(mem, src, sz);
    80001306:	8626                	mv	a2,s1
    80001308:	85ce                	mv	a1,s3
    8000130a:	854a                	mv	a0,s2
    8000130c:	00000097          	auipc	ra,0x0
    80001310:	8d2080e7          	jalr	-1838(ra) # 80000bde <memmove>
}
    80001314:	70a2                	ld	ra,40(sp)
    80001316:	7402                	ld	s0,32(sp)
    80001318:	64e2                	ld	s1,24(sp)
    8000131a:	6942                	ld	s2,16(sp)
    8000131c:	69a2                	ld	s3,8(sp)
    8000131e:	6a02                	ld	s4,0(sp)
    80001320:	6145                	addi	sp,sp,48
    80001322:	8082                	ret
    panic("inituvm: more than a page");
    80001324:	00006517          	auipc	a0,0x6
    80001328:	f3450513          	addi	a0,a0,-204 # 80007258 <userret+0x1c8>
    8000132c:	fffff097          	auipc	ra,0xfffff
    80001330:	21c080e7          	jalr	540(ra) # 80000548 <panic>

0000000080001334 <uvmdealloc>:
{
    80001334:	87aa                	mv	a5,a0
    80001336:	852e                	mv	a0,a1
  if(newsz >= oldsz)
    80001338:	00b66363          	bltu	a2,a1,8000133e <uvmdealloc+0xa>
}
    8000133c:	8082                	ret
{
    8000133e:	1101                	addi	sp,sp,-32
    80001340:	ec06                	sd	ra,24(sp)
    80001342:	e822                	sd	s0,16(sp)
    80001344:	e426                	sd	s1,8(sp)
    80001346:	1000                	addi	s0,sp,32
    80001348:	84b2                	mv	s1,a2
  uvmunmap(pagetable, newsz, oldsz - newsz, 1);
    8000134a:	4685                	li	a3,1
    8000134c:	40c58633          	sub	a2,a1,a2
    80001350:	85a6                	mv	a1,s1
    80001352:	853e                	mv	a0,a5
    80001354:	00000097          	auipc	ra,0x0
    80001358:	e68080e7          	jalr	-408(ra) # 800011bc <uvmunmap>
  return newsz;
    8000135c:	8526                	mv	a0,s1
}
    8000135e:	60e2                	ld	ra,24(sp)
    80001360:	6442                	ld	s0,16(sp)
    80001362:	64a2                	ld	s1,8(sp)
    80001364:	6105                	addi	sp,sp,32
    80001366:	8082                	ret

0000000080001368 <uvmalloc>:
  if(newsz < oldsz)
    80001368:	0ab66163          	bltu	a2,a1,8000140a <uvmalloc+0xa2>
{
    8000136c:	7139                	addi	sp,sp,-64
    8000136e:	fc06                	sd	ra,56(sp)
    80001370:	f822                	sd	s0,48(sp)
    80001372:	f426                	sd	s1,40(sp)
    80001374:	f04a                	sd	s2,32(sp)
    80001376:	ec4e                	sd	s3,24(sp)
    80001378:	e852                	sd	s4,16(sp)
    8000137a:	e456                	sd	s5,8(sp)
    8000137c:	0080                	addi	s0,sp,64
    8000137e:	8aaa                	mv	s5,a0
    80001380:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001382:	6985                	lui	s3,0x1
    80001384:	19fd                	addi	s3,s3,-1
    80001386:	95ce                	add	a1,a1,s3
    80001388:	79fd                	lui	s3,0xfffff
    8000138a:	0135f9b3          	and	s3,a1,s3
  for(; a < newsz; a += PGSIZE){
    8000138e:	08c9f063          	bgeu	s3,a2,8000140e <uvmalloc+0xa6>
  a = oldsz;
    80001392:	894e                	mv	s2,s3
    mem = kalloc();
    80001394:	fffff097          	auipc	ra,0xfffff
    80001398:	5bc080e7          	jalr	1468(ra) # 80000950 <kalloc>
    8000139c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000139e:	c51d                	beqz	a0,800013cc <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800013a0:	6605                	lui	a2,0x1
    800013a2:	4581                	li	a1,0
    800013a4:	fffff097          	auipc	ra,0xfffff
    800013a8:	7de080e7          	jalr	2014(ra) # 80000b82 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800013ac:	4779                	li	a4,30
    800013ae:	86a6                	mv	a3,s1
    800013b0:	6605                	lui	a2,0x1
    800013b2:	85ca                	mv	a1,s2
    800013b4:	8556                	mv	a0,s5
    800013b6:	00000097          	auipc	ra,0x0
    800013ba:	c5a080e7          	jalr	-934(ra) # 80001010 <mappages>
    800013be:	e905                	bnez	a0,800013ee <uvmalloc+0x86>
  for(; a < newsz; a += PGSIZE){
    800013c0:	6785                	lui	a5,0x1
    800013c2:	993e                	add	s2,s2,a5
    800013c4:	fd4968e3          	bltu	s2,s4,80001394 <uvmalloc+0x2c>
  return newsz;
    800013c8:	8552                	mv	a0,s4
    800013ca:	a809                	j	800013dc <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800013cc:	864e                	mv	a2,s3
    800013ce:	85ca                	mv	a1,s2
    800013d0:	8556                	mv	a0,s5
    800013d2:	00000097          	auipc	ra,0x0
    800013d6:	f62080e7          	jalr	-158(ra) # 80001334 <uvmdealloc>
      return 0;
    800013da:	4501                	li	a0,0
}
    800013dc:	70e2                	ld	ra,56(sp)
    800013de:	7442                	ld	s0,48(sp)
    800013e0:	74a2                	ld	s1,40(sp)
    800013e2:	7902                	ld	s2,32(sp)
    800013e4:	69e2                	ld	s3,24(sp)
    800013e6:	6a42                	ld	s4,16(sp)
    800013e8:	6aa2                	ld	s5,8(sp)
    800013ea:	6121                	addi	sp,sp,64
    800013ec:	8082                	ret
      kfree(mem);
    800013ee:	8526                	mv	a0,s1
    800013f0:	fffff097          	auipc	ra,0xfffff
    800013f4:	464080e7          	jalr	1124(ra) # 80000854 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013f8:	864e                	mv	a2,s3
    800013fa:	85ca                	mv	a1,s2
    800013fc:	8556                	mv	a0,s5
    800013fe:	00000097          	auipc	ra,0x0
    80001402:	f36080e7          	jalr	-202(ra) # 80001334 <uvmdealloc>
      return 0;
    80001406:	4501                	li	a0,0
    80001408:	bfd1                	j	800013dc <uvmalloc+0x74>
    return oldsz;
    8000140a:	852e                	mv	a0,a1
}
    8000140c:	8082                	ret
  return newsz;
    8000140e:	8532                	mv	a0,a2
    80001410:	b7f1                	j	800013dc <uvmalloc+0x74>

0000000080001412 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001412:	1101                	addi	sp,sp,-32
    80001414:	ec06                	sd	ra,24(sp)
    80001416:	e822                	sd	s0,16(sp)
    80001418:	e426                	sd	s1,8(sp)
    8000141a:	1000                	addi	s0,sp,32
    8000141c:	84aa                	mv	s1,a0
    8000141e:	862e                	mv	a2,a1
  uvmunmap(pagetable, 0, sz, 1);
    80001420:	4685                	li	a3,1
    80001422:	4581                	li	a1,0
    80001424:	00000097          	auipc	ra,0x0
    80001428:	d98080e7          	jalr	-616(ra) # 800011bc <uvmunmap>
  freewalk(pagetable);
    8000142c:	8526                	mv	a0,s1
    8000142e:	00000097          	auipc	ra,0x0
    80001432:	ac0080e7          	jalr	-1344(ra) # 80000eee <freewalk>
}
    80001436:	60e2                	ld	ra,24(sp)
    80001438:	6442                	ld	s0,16(sp)
    8000143a:	64a2                	ld	s1,8(sp)
    8000143c:	6105                	addi	sp,sp,32
    8000143e:	8082                	ret

0000000080001440 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001440:	c671                	beqz	a2,8000150c <uvmcopy+0xcc>
{
    80001442:	715d                	addi	sp,sp,-80
    80001444:	e486                	sd	ra,72(sp)
    80001446:	e0a2                	sd	s0,64(sp)
    80001448:	fc26                	sd	s1,56(sp)
    8000144a:	f84a                	sd	s2,48(sp)
    8000144c:	f44e                	sd	s3,40(sp)
    8000144e:	f052                	sd	s4,32(sp)
    80001450:	ec56                	sd	s5,24(sp)
    80001452:	e85a                	sd	s6,16(sp)
    80001454:	e45e                	sd	s7,8(sp)
    80001456:	0880                	addi	s0,sp,80
    80001458:	8b2a                	mv	s6,a0
    8000145a:	8aae                	mv	s5,a1
    8000145c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000145e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001460:	4601                	li	a2,0
    80001462:	85ce                	mv	a1,s3
    80001464:	855a                	mv	a0,s6
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	9e2080e7          	jalr	-1566(ra) # 80000e48 <walk>
    8000146e:	c531                	beqz	a0,800014ba <uvmcopy+0x7a>
      panic("copyuvm: pte should exist");
    if((*pte & PTE_V) == 0)
    80001470:	6118                	ld	a4,0(a0)
    80001472:	00177793          	andi	a5,a4,1
    80001476:	cbb1                	beqz	a5,800014ca <uvmcopy+0x8a>
      panic("copyuvm: page not present");
    pa = PTE2PA(*pte);
    80001478:	00a75593          	srli	a1,a4,0xa
    8000147c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001480:	01f77493          	andi	s1,a4,31
    if((mem = kalloc()) == 0)
    80001484:	fffff097          	auipc	ra,0xfffff
    80001488:	4cc080e7          	jalr	1228(ra) # 80000950 <kalloc>
    8000148c:	892a                	mv	s2,a0
    8000148e:	c939                	beqz	a0,800014e4 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001490:	6605                	lui	a2,0x1
    80001492:	85de                	mv	a1,s7
    80001494:	fffff097          	auipc	ra,0xfffff
    80001498:	74a080e7          	jalr	1866(ra) # 80000bde <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000149c:	8726                	mv	a4,s1
    8000149e:	86ca                	mv	a3,s2
    800014a0:	6605                	lui	a2,0x1
    800014a2:	85ce                	mv	a1,s3
    800014a4:	8556                	mv	a0,s5
    800014a6:	00000097          	auipc	ra,0x0
    800014aa:	b6a080e7          	jalr	-1174(ra) # 80001010 <mappages>
    800014ae:	e515                	bnez	a0,800014da <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800014b0:	6785                	lui	a5,0x1
    800014b2:	99be                	add	s3,s3,a5
    800014b4:	fb49e6e3          	bltu	s3,s4,80001460 <uvmcopy+0x20>
    800014b8:	a83d                	j	800014f6 <uvmcopy+0xb6>
      panic("copyuvm: pte should exist");
    800014ba:	00006517          	auipc	a0,0x6
    800014be:	dbe50513          	addi	a0,a0,-578 # 80007278 <userret+0x1e8>
    800014c2:	fffff097          	auipc	ra,0xfffff
    800014c6:	086080e7          	jalr	134(ra) # 80000548 <panic>
      panic("copyuvm: page not present");
    800014ca:	00006517          	auipc	a0,0x6
    800014ce:	dce50513          	addi	a0,a0,-562 # 80007298 <userret+0x208>
    800014d2:	fffff097          	auipc	ra,0xfffff
    800014d6:	076080e7          	jalr	118(ra) # 80000548 <panic>
      kfree(mem);
    800014da:	854a                	mv	a0,s2
    800014dc:	fffff097          	auipc	ra,0xfffff
    800014e0:	378080e7          	jalr	888(ra) # 80000854 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
    800014e4:	4685                	li	a3,1
    800014e6:	864e                	mv	a2,s3
    800014e8:	4581                	li	a1,0
    800014ea:	8556                	mv	a0,s5
    800014ec:	00000097          	auipc	ra,0x0
    800014f0:	cd0080e7          	jalr	-816(ra) # 800011bc <uvmunmap>
  return -1;
    800014f4:	557d                	li	a0,-1
}
    800014f6:	60a6                	ld	ra,72(sp)
    800014f8:	6406                	ld	s0,64(sp)
    800014fa:	74e2                	ld	s1,56(sp)
    800014fc:	7942                	ld	s2,48(sp)
    800014fe:	79a2                	ld	s3,40(sp)
    80001500:	7a02                	ld	s4,32(sp)
    80001502:	6ae2                	ld	s5,24(sp)
    80001504:	6b42                	ld	s6,16(sp)
    80001506:	6ba2                	ld	s7,8(sp)
    80001508:	6161                	addi	sp,sp,80
    8000150a:	8082                	ret
  return 0;
    8000150c:	4501                	li	a0,0
}
    8000150e:	8082                	ret

0000000080001510 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001510:	1141                	addi	sp,sp,-16
    80001512:	e406                	sd	ra,8(sp)
    80001514:	e022                	sd	s0,0(sp)
    80001516:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001518:	4601                	li	a2,0
    8000151a:	00000097          	auipc	ra,0x0
    8000151e:	92e080e7          	jalr	-1746(ra) # 80000e48 <walk>
  if(pte == 0)
    80001522:	c901                	beqz	a0,80001532 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001524:	611c                	ld	a5,0(a0)
    80001526:	9bbd                	andi	a5,a5,-17
    80001528:	e11c                	sd	a5,0(a0)
}
    8000152a:	60a2                	ld	ra,8(sp)
    8000152c:	6402                	ld	s0,0(sp)
    8000152e:	0141                	addi	sp,sp,16
    80001530:	8082                	ret
    panic("uvmclear");
    80001532:	00006517          	auipc	a0,0x6
    80001536:	d8650513          	addi	a0,a0,-634 # 800072b8 <userret+0x228>
    8000153a:	fffff097          	auipc	ra,0xfffff
    8000153e:	00e080e7          	jalr	14(ra) # 80000548 <panic>

0000000080001542 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001542:	cab5                	beqz	a3,800015b6 <copyout+0x74>
{
    80001544:	715d                	addi	sp,sp,-80
    80001546:	e486                	sd	ra,72(sp)
    80001548:	e0a2                	sd	s0,64(sp)
    8000154a:	fc26                	sd	s1,56(sp)
    8000154c:	f84a                	sd	s2,48(sp)
    8000154e:	f44e                	sd	s3,40(sp)
    80001550:	f052                	sd	s4,32(sp)
    80001552:	ec56                	sd	s5,24(sp)
    80001554:	e85a                	sd	s6,16(sp)
    80001556:	e45e                	sd	s7,8(sp)
    80001558:	e062                	sd	s8,0(sp)
    8000155a:	0880                	addi	s0,sp,80
    8000155c:	8baa                	mv	s7,a0
    8000155e:	8c2e                	mv	s8,a1
    80001560:	8a32                	mv	s4,a2
    80001562:	89b6                	mv	s3,a3
    va0 = (uint)PGROUNDDOWN(dstva);
    80001564:	00100b37          	lui	s6,0x100
    80001568:	1b7d                	addi	s6,s6,-1
    8000156a:	0b32                	slli	s6,s6,0xc
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000156c:	6a85                	lui	s5,0x1
    8000156e:	a015                	j	80001592 <copyout+0x50>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001570:	9562                	add	a0,a0,s8
    80001572:	0004861b          	sext.w	a2,s1
    80001576:	85d2                	mv	a1,s4
    80001578:	41250533          	sub	a0,a0,s2
    8000157c:	fffff097          	auipc	ra,0xfffff
    80001580:	662080e7          	jalr	1634(ra) # 80000bde <memmove>

    len -= n;
    80001584:	409989b3          	sub	s3,s3,s1
    src += n;
    80001588:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000158a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000158e:	02098263          	beqz	s3,800015b2 <copyout+0x70>
    va0 = (uint)PGROUNDDOWN(dstva);
    80001592:	016c7933          	and	s2,s8,s6
    pa0 = walkaddr(pagetable, va0);
    80001596:	85ca                	mv	a1,s2
    80001598:	855e                	mv	a0,s7
    8000159a:	00000097          	auipc	ra,0x0
    8000159e:	9e2080e7          	jalr	-1566(ra) # 80000f7c <walkaddr>
    if(pa0 == 0)
    800015a2:	cd01                	beqz	a0,800015ba <copyout+0x78>
    n = PGSIZE - (dstva - va0);
    800015a4:	418904b3          	sub	s1,s2,s8
    800015a8:	94d6                	add	s1,s1,s5
    if(n > len)
    800015aa:	fc99f3e3          	bgeu	s3,s1,80001570 <copyout+0x2e>
    800015ae:	84ce                	mv	s1,s3
    800015b0:	b7c1                	j	80001570 <copyout+0x2e>
  }
  return 0;
    800015b2:	4501                	li	a0,0
    800015b4:	a021                	j	800015bc <copyout+0x7a>
    800015b6:	4501                	li	a0,0
}
    800015b8:	8082                	ret
      return -1;
    800015ba:	557d                	li	a0,-1
}
    800015bc:	60a6                	ld	ra,72(sp)
    800015be:	6406                	ld	s0,64(sp)
    800015c0:	74e2                	ld	s1,56(sp)
    800015c2:	7942                	ld	s2,48(sp)
    800015c4:	79a2                	ld	s3,40(sp)
    800015c6:	7a02                	ld	s4,32(sp)
    800015c8:	6ae2                	ld	s5,24(sp)
    800015ca:	6b42                	ld	s6,16(sp)
    800015cc:	6ba2                	ld	s7,8(sp)
    800015ce:	6c02                	ld	s8,0(sp)
    800015d0:	6161                	addi	sp,sp,80
    800015d2:	8082                	ret

00000000800015d4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800015d4:	cabd                	beqz	a3,8000164a <copyin+0x76>
{
    800015d6:	715d                	addi	sp,sp,-80
    800015d8:	e486                	sd	ra,72(sp)
    800015da:	e0a2                	sd	s0,64(sp)
    800015dc:	fc26                	sd	s1,56(sp)
    800015de:	f84a                	sd	s2,48(sp)
    800015e0:	f44e                	sd	s3,40(sp)
    800015e2:	f052                	sd	s4,32(sp)
    800015e4:	ec56                	sd	s5,24(sp)
    800015e6:	e85a                	sd	s6,16(sp)
    800015e8:	e45e                	sd	s7,8(sp)
    800015ea:	e062                	sd	s8,0(sp)
    800015ec:	0880                	addi	s0,sp,80
    800015ee:	8baa                	mv	s7,a0
    800015f0:	8a2e                	mv	s4,a1
    800015f2:	8c32                	mv	s8,a2
    800015f4:	89b6                	mv	s3,a3
    va0 = (uint)PGROUNDDOWN(srcva);
    800015f6:	00100b37          	lui	s6,0x100
    800015fa:	1b7d                	addi	s6,s6,-1
    800015fc:	0b32                	slli	s6,s6,0xc
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800015fe:	6a85                	lui	s5,0x1
    80001600:	a01d                	j	80001626 <copyin+0x52>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001602:	018505b3          	add	a1,a0,s8
    80001606:	0004861b          	sext.w	a2,s1
    8000160a:	412585b3          	sub	a1,a1,s2
    8000160e:	8552                	mv	a0,s4
    80001610:	fffff097          	auipc	ra,0xfffff
    80001614:	5ce080e7          	jalr	1486(ra) # 80000bde <memmove>

    len -= n;
    80001618:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000161c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000161e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001622:	02098263          	beqz	s3,80001646 <copyin+0x72>
    va0 = (uint)PGROUNDDOWN(srcva);
    80001626:	016c7933          	and	s2,s8,s6
    pa0 = walkaddr(pagetable, va0);
    8000162a:	85ca                	mv	a1,s2
    8000162c:	855e                	mv	a0,s7
    8000162e:	00000097          	auipc	ra,0x0
    80001632:	94e080e7          	jalr	-1714(ra) # 80000f7c <walkaddr>
    if(pa0 == 0)
    80001636:	cd01                	beqz	a0,8000164e <copyin+0x7a>
    n = PGSIZE - (srcva - va0);
    80001638:	418904b3          	sub	s1,s2,s8
    8000163c:	94d6                	add	s1,s1,s5
    if(n > len)
    8000163e:	fc99f2e3          	bgeu	s3,s1,80001602 <copyin+0x2e>
    80001642:	84ce                	mv	s1,s3
    80001644:	bf7d                	j	80001602 <copyin+0x2e>
  }
  return 0;
    80001646:	4501                	li	a0,0
    80001648:	a021                	j	80001650 <copyin+0x7c>
    8000164a:	4501                	li	a0,0
}
    8000164c:	8082                	ret
      return -1;
    8000164e:	557d                	li	a0,-1
}
    80001650:	60a6                	ld	ra,72(sp)
    80001652:	6406                	ld	s0,64(sp)
    80001654:	74e2                	ld	s1,56(sp)
    80001656:	7942                	ld	s2,48(sp)
    80001658:	79a2                	ld	s3,40(sp)
    8000165a:	7a02                	ld	s4,32(sp)
    8000165c:	6ae2                	ld	s5,24(sp)
    8000165e:	6b42                	ld	s6,16(sp)
    80001660:	6ba2                	ld	s7,8(sp)
    80001662:	6c02                	ld	s8,0(sp)
    80001664:	6161                	addi	sp,sp,80
    80001666:	8082                	ret

0000000080001668 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001668:	c6dd                	beqz	a3,80001716 <copyinstr+0xae>
{
    8000166a:	715d                	addi	sp,sp,-80
    8000166c:	e486                	sd	ra,72(sp)
    8000166e:	e0a2                	sd	s0,64(sp)
    80001670:	fc26                	sd	s1,56(sp)
    80001672:	f84a                	sd	s2,48(sp)
    80001674:	f44e                	sd	s3,40(sp)
    80001676:	f052                	sd	s4,32(sp)
    80001678:	ec56                	sd	s5,24(sp)
    8000167a:	e85a                	sd	s6,16(sp)
    8000167c:	e45e                	sd	s7,8(sp)
    8000167e:	0880                	addi	s0,sp,80
    80001680:	8aaa                	mv	s5,a0
    80001682:	8b2e                	mv	s6,a1
    80001684:	8bb2                	mv	s7,a2
    80001686:	84b6                	mv	s1,a3
    va0 = (uint)PGROUNDDOWN(srcva);
    80001688:	00100a37          	lui	s4,0x100
    8000168c:	1a7d                	addi	s4,s4,-1
    8000168e:	0a32                	slli	s4,s4,0xc
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001690:	6985                	lui	s3,0x1
    80001692:	a035                	j	800016be <copyinstr+0x56>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001694:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001698:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000169a:	0017b793          	seqz	a5,a5
    8000169e:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016a2:	60a6                	ld	ra,72(sp)
    800016a4:	6406                	ld	s0,64(sp)
    800016a6:	74e2                	ld	s1,56(sp)
    800016a8:	7942                	ld	s2,48(sp)
    800016aa:	79a2                	ld	s3,40(sp)
    800016ac:	7a02                	ld	s4,32(sp)
    800016ae:	6ae2                	ld	s5,24(sp)
    800016b0:	6b42                	ld	s6,16(sp)
    800016b2:	6ba2                	ld	s7,8(sp)
    800016b4:	6161                	addi	sp,sp,80
    800016b6:	8082                	ret
    srcva = va0 + PGSIZE;
    800016b8:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800016bc:	c8a9                	beqz	s1,8000170e <copyinstr+0xa6>
    va0 = (uint)PGROUNDDOWN(srcva);
    800016be:	014bf933          	and	s2,s7,s4
    pa0 = walkaddr(pagetable, va0);
    800016c2:	85ca                	mv	a1,s2
    800016c4:	8556                	mv	a0,s5
    800016c6:	00000097          	auipc	ra,0x0
    800016ca:	8b6080e7          	jalr	-1866(ra) # 80000f7c <walkaddr>
    if(pa0 == 0)
    800016ce:	c131                	beqz	a0,80001712 <copyinstr+0xaa>
    n = PGSIZE - (srcva - va0);
    800016d0:	41790833          	sub	a6,s2,s7
    800016d4:	984e                	add	a6,a6,s3
    if(n > max)
    800016d6:	0104f363          	bgeu	s1,a6,800016dc <copyinstr+0x74>
    800016da:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800016dc:	955e                	add	a0,a0,s7
    800016de:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800016e2:	fc080be3          	beqz	a6,800016b8 <copyinstr+0x50>
    800016e6:	985a                	add	a6,a6,s6
    800016e8:	87da                	mv	a5,s6
      if(*p == '\0'){
    800016ea:	41650633          	sub	a2,a0,s6
    800016ee:	14fd                	addi	s1,s1,-1
    800016f0:	9b26                	add	s6,s6,s1
    800016f2:	00f60733          	add	a4,a2,a5
    800016f6:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <ticks+0xffffffff7ffd5fd8>
    800016fa:	df49                	beqz	a4,80001694 <copyinstr+0x2c>
        *dst = *p;
    800016fc:	00e78023          	sb	a4,0(a5)
      --max;
    80001700:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001704:	0785                	addi	a5,a5,1
    while(n > 0){
    80001706:	ff0796e3          	bne	a5,a6,800016f2 <copyinstr+0x8a>
      dst++;
    8000170a:	8b42                	mv	s6,a6
    8000170c:	b775                	j	800016b8 <copyinstr+0x50>
    8000170e:	4781                	li	a5,0
    80001710:	b769                	j	8000169a <copyinstr+0x32>
      return -1;
    80001712:	557d                	li	a0,-1
    80001714:	b779                	j	800016a2 <copyinstr+0x3a>
  int got_null = 0;
    80001716:	4781                	li	a5,0
  if(got_null){
    80001718:	0017b793          	seqz	a5,a5
    8000171c:	40f00533          	neg	a0,a5
}
    80001720:	8082                	ret

0000000080001722 <procinit>:

extern char trampoline[]; // trampoline.S

void
procinit(void)
{
    80001722:	715d                	addi	sp,sp,-80
    80001724:	e486                	sd	ra,72(sp)
    80001726:	e0a2                	sd	s0,64(sp)
    80001728:	fc26                	sd	s1,56(sp)
    8000172a:	f84a                	sd	s2,48(sp)
    8000172c:	f44e                	sd	s3,40(sp)
    8000172e:	f052                	sd	s4,32(sp)
    80001730:	ec56                	sd	s5,24(sp)
    80001732:	e85a                	sd	s6,16(sp)
    80001734:	e45e                	sd	s7,8(sp)
    80001736:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001738:	00006597          	auipc	a1,0x6
    8000173c:	b9058593          	addi	a1,a1,-1136 # 800072c8 <userret+0x238>
    80001740:	00010517          	auipc	a0,0x10
    80001744:	1a850513          	addi	a0,a0,424 # 800118e8 <pid_lock>
    80001748:	fffff097          	auipc	ra,0xfffff
    8000174c:	268080e7          	jalr	616(ra) # 800009b0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001750:	00010917          	auipc	s2,0x10
    80001754:	5b090913          	addi	s2,s2,1456 # 80011d00 <proc>
      initlock(&p->lock, "proc");
    80001758:	00006b97          	auipc	s7,0x6
    8000175c:	b78b8b93          	addi	s7,s7,-1160 # 800072d0 <userret+0x240>
      // Map it high in memory, followed by an invalid
      // guard page.
      char *pa = kalloc();
      if(pa == 0)
        panic("kalloc");
      uint64 va = KSTACK((int) (p - proc));
    80001760:	8b4a                	mv	s6,s2
    80001762:	00006a97          	auipc	s5,0x6
    80001766:	266a8a93          	addi	s5,s5,614 # 800079c8 <syscalls+0xc0>
    8000176a:	040009b7          	lui	s3,0x4000
    8000176e:	19fd                	addi	s3,s3,-1
    80001770:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001772:	00016a17          	auipc	s4,0x16
    80001776:	d8ea0a13          	addi	s4,s4,-626 # 80017500 <tickslock>
      initlock(&p->lock, "proc");
    8000177a:	85de                	mv	a1,s7
    8000177c:	854a                	mv	a0,s2
    8000177e:	fffff097          	auipc	ra,0xfffff
    80001782:	232080e7          	jalr	562(ra) # 800009b0 <initlock>
      char *pa = kalloc();
    80001786:	fffff097          	auipc	ra,0xfffff
    8000178a:	1ca080e7          	jalr	458(ra) # 80000950 <kalloc>
    8000178e:	85aa                	mv	a1,a0
      if(pa == 0)
    80001790:	c929                	beqz	a0,800017e2 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    80001792:	416904b3          	sub	s1,s2,s6
    80001796:	8495                	srai	s1,s1,0x5
    80001798:	000ab783          	ld	a5,0(s5)
    8000179c:	02f484b3          	mul	s1,s1,a5
    800017a0:	2485                	addiw	s1,s1,1
    800017a2:	00d4949b          	slliw	s1,s1,0xd
    800017a6:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017aa:	4699                	li	a3,6
    800017ac:	6605                	lui	a2,0x1
    800017ae:	8526                	mv	a0,s1
    800017b0:	00000097          	auipc	ra,0x0
    800017b4:	8ee080e7          	jalr	-1810(ra) # 8000109e <kvmmap>
      p->kstack = va;
    800017b8:	02993c23          	sd	s1,56(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017bc:	16090913          	addi	s2,s2,352
    800017c0:	fb491de3          	bne	s2,s4,8000177a <procinit+0x58>
  }
  kvminithart();
    800017c4:	fffff097          	auipc	ra,0xfffff
    800017c8:	794080e7          	jalr	1940(ra) # 80000f58 <kvminithart>
}
    800017cc:	60a6                	ld	ra,72(sp)
    800017ce:	6406                	ld	s0,64(sp)
    800017d0:	74e2                	ld	s1,56(sp)
    800017d2:	7942                	ld	s2,48(sp)
    800017d4:	79a2                	ld	s3,40(sp)
    800017d6:	7a02                	ld	s4,32(sp)
    800017d8:	6ae2                	ld	s5,24(sp)
    800017da:	6b42                	ld	s6,16(sp)
    800017dc:	6ba2                	ld	s7,8(sp)
    800017de:	6161                	addi	sp,sp,80
    800017e0:	8082                	ret
        panic("kalloc");
    800017e2:	00006517          	auipc	a0,0x6
    800017e6:	af650513          	addi	a0,a0,-1290 # 800072d8 <userret+0x248>
    800017ea:	fffff097          	auipc	ra,0xfffff
    800017ee:	d5e080e7          	jalr	-674(ra) # 80000548 <panic>

00000000800017f2 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800017f2:	1141                	addi	sp,sp,-16
    800017f4:	e422                	sd	s0,8(sp)
    800017f6:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800017f8:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800017fa:	2501                	sext.w	a0,a0
    800017fc:	6422                	ld	s0,8(sp)
    800017fe:	0141                	addi	sp,sp,16
    80001800:	8082                	ret

0000000080001802 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001802:	1141                	addi	sp,sp,-16
    80001804:	e422                	sd	s0,8(sp)
    80001806:	0800                	addi	s0,sp,16
    80001808:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000180a:	2781                	sext.w	a5,a5
    8000180c:	079e                	slli	a5,a5,0x7
  return c;
}
    8000180e:	00010517          	auipc	a0,0x10
    80001812:	0f250513          	addi	a0,a0,242 # 80011900 <cpus>
    80001816:	953e                	add	a0,a0,a5
    80001818:	6422                	ld	s0,8(sp)
    8000181a:	0141                	addi	sp,sp,16
    8000181c:	8082                	ret

000000008000181e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    8000181e:	1101                	addi	sp,sp,-32
    80001820:	ec06                	sd	ra,24(sp)
    80001822:	e822                	sd	s0,16(sp)
    80001824:	e426                	sd	s1,8(sp)
    80001826:	1000                	addi	s0,sp,32
  push_off();
    80001828:	fffff097          	auipc	ra,0xfffff
    8000182c:	19e080e7          	jalr	414(ra) # 800009c6 <push_off>
    80001830:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001832:	2781                	sext.w	a5,a5
    80001834:	079e                	slli	a5,a5,0x7
    80001836:	00010717          	auipc	a4,0x10
    8000183a:	0b270713          	addi	a4,a4,178 # 800118e8 <pid_lock>
    8000183e:	97ba                	add	a5,a5,a4
    80001840:	6f84                	ld	s1,24(a5)
  pop_off();
    80001842:	fffff097          	auipc	ra,0xfffff
    80001846:	1d0080e7          	jalr	464(ra) # 80000a12 <pop_off>
  return p;
}
    8000184a:	8526                	mv	a0,s1
    8000184c:	60e2                	ld	ra,24(sp)
    8000184e:	6442                	ld	s0,16(sp)
    80001850:	64a2                	ld	s1,8(sp)
    80001852:	6105                	addi	sp,sp,32
    80001854:	8082                	ret

0000000080001856 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001856:	1141                	addi	sp,sp,-16
    80001858:	e406                	sd	ra,8(sp)
    8000185a:	e022                	sd	s0,0(sp)
    8000185c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000185e:	00000097          	auipc	ra,0x0
    80001862:	fc0080e7          	jalr	-64(ra) # 8000181e <myproc>
    80001866:	fffff097          	auipc	ra,0xfffff
    8000186a:	2c0080e7          	jalr	704(ra) # 80000b26 <release>

  if (first) {
    8000186e:	00006797          	auipc	a5,0x6
    80001872:	7c67a783          	lw	a5,1990(a5) # 80008034 <first.1>
    80001876:	eb89                	bnez	a5,80001888 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(minor(ROOTDEV));
  }

  usertrapret();
    80001878:	00001097          	auipc	ra,0x1
    8000187c:	bd6080e7          	jalr	-1066(ra) # 8000244e <usertrapret>
}
    80001880:	60a2                	ld	ra,8(sp)
    80001882:	6402                	ld	s0,0(sp)
    80001884:	0141                	addi	sp,sp,16
    80001886:	8082                	ret
    first = 0;
    80001888:	00006797          	auipc	a5,0x6
    8000188c:	7a07a623          	sw	zero,1964(a5) # 80008034 <first.1>
    fsinit(minor(ROOTDEV));
    80001890:	4501                	li	a0,0
    80001892:	00002097          	auipc	ra,0x2
    80001896:	8c6080e7          	jalr	-1850(ra) # 80003158 <fsinit>
    8000189a:	bff9                	j	80001878 <forkret+0x22>

000000008000189c <allocpid>:
allocpid() {
    8000189c:	1101                	addi	sp,sp,-32
    8000189e:	ec06                	sd	ra,24(sp)
    800018a0:	e822                	sd	s0,16(sp)
    800018a2:	e426                	sd	s1,8(sp)
    800018a4:	e04a                	sd	s2,0(sp)
    800018a6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800018a8:	00010917          	auipc	s2,0x10
    800018ac:	04090913          	addi	s2,s2,64 # 800118e8 <pid_lock>
    800018b0:	854a                	mv	a0,s2
    800018b2:	fffff097          	auipc	ra,0xfffff
    800018b6:	20c080e7          	jalr	524(ra) # 80000abe <acquire>
  pid = nextpid;
    800018ba:	00006797          	auipc	a5,0x6
    800018be:	77e78793          	addi	a5,a5,1918 # 80008038 <nextpid>
    800018c2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018c4:	0014871b          	addiw	a4,s1,1
    800018c8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018ca:	854a                	mv	a0,s2
    800018cc:	fffff097          	auipc	ra,0xfffff
    800018d0:	25a080e7          	jalr	602(ra) # 80000b26 <release>
}
    800018d4:	8526                	mv	a0,s1
    800018d6:	60e2                	ld	ra,24(sp)
    800018d8:	6442                	ld	s0,16(sp)
    800018da:	64a2                	ld	s1,8(sp)
    800018dc:	6902                	ld	s2,0(sp)
    800018de:	6105                	addi	sp,sp,32
    800018e0:	8082                	ret

00000000800018e2 <proc_pagetable>:
{
    800018e2:	1101                	addi	sp,sp,-32
    800018e4:	ec06                	sd	ra,24(sp)
    800018e6:	e822                	sd	s0,16(sp)
    800018e8:	e426                	sd	s1,8(sp)
    800018ea:	e04a                	sd	s2,0(sp)
    800018ec:	1000                	addi	s0,sp,32
    800018ee:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800018f0:	00000097          	auipc	ra,0x0
    800018f4:	994080e7          	jalr	-1644(ra) # 80001284 <uvmcreate>
    800018f8:	84aa                	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
    800018fa:	4729                	li	a4,10
    800018fc:	00005697          	auipc	a3,0x5
    80001900:	70468693          	addi	a3,a3,1796 # 80007000 <trampoline>
    80001904:	6605                	lui	a2,0x1
    80001906:	040005b7          	lui	a1,0x4000
    8000190a:	15fd                	addi	a1,a1,-1
    8000190c:	05b2                	slli	a1,a1,0xc
    8000190e:	fffff097          	auipc	ra,0xfffff
    80001912:	702080e7          	jalr	1794(ra) # 80001010 <mappages>
  mappages(pagetable, TRAPFRAME, PGSIZE,
    80001916:	4719                	li	a4,6
    80001918:	05093683          	ld	a3,80(s2)
    8000191c:	6605                	lui	a2,0x1
    8000191e:	020005b7          	lui	a1,0x2000
    80001922:	15fd                	addi	a1,a1,-1
    80001924:	05b6                	slli	a1,a1,0xd
    80001926:	8526                	mv	a0,s1
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	6e8080e7          	jalr	1768(ra) # 80001010 <mappages>
}
    80001930:	8526                	mv	a0,s1
    80001932:	60e2                	ld	ra,24(sp)
    80001934:	6442                	ld	s0,16(sp)
    80001936:	64a2                	ld	s1,8(sp)
    80001938:	6902                	ld	s2,0(sp)
    8000193a:	6105                	addi	sp,sp,32
    8000193c:	8082                	ret

000000008000193e <allocproc>:
{
    8000193e:	1101                	addi	sp,sp,-32
    80001940:	ec06                	sd	ra,24(sp)
    80001942:	e822                	sd	s0,16(sp)
    80001944:	e426                	sd	s1,8(sp)
    80001946:	e04a                	sd	s2,0(sp)
    80001948:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000194a:	00010497          	auipc	s1,0x10
    8000194e:	3b648493          	addi	s1,s1,950 # 80011d00 <proc>
    80001952:	00016917          	auipc	s2,0x16
    80001956:	bae90913          	addi	s2,s2,-1106 # 80017500 <tickslock>
    acquire(&p->lock);
    8000195a:	8526                	mv	a0,s1
    8000195c:	fffff097          	auipc	ra,0xfffff
    80001960:	162080e7          	jalr	354(ra) # 80000abe <acquire>
    if(p->state == UNUSED) {
    80001964:	4c9c                	lw	a5,24(s1)
    80001966:	cf81                	beqz	a5,8000197e <allocproc+0x40>
      release(&p->lock);
    80001968:	8526                	mv	a0,s1
    8000196a:	fffff097          	auipc	ra,0xfffff
    8000196e:	1bc080e7          	jalr	444(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001972:	16048493          	addi	s1,s1,352
    80001976:	ff2492e3          	bne	s1,s2,8000195a <allocproc+0x1c>
  return 0;
    8000197a:	4481                	li	s1,0
    8000197c:	a0a9                	j	800019c6 <allocproc+0x88>
  p->pid = allocpid();
    8000197e:	00000097          	auipc	ra,0x0
    80001982:	f1e080e7          	jalr	-226(ra) # 8000189c <allocpid>
    80001986:	d8c8                	sw	a0,52(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    80001988:	fffff097          	auipc	ra,0xfffff
    8000198c:	fc8080e7          	jalr	-56(ra) # 80000950 <kalloc>
    80001990:	892a                	mv	s2,a0
    80001992:	e8a8                	sd	a0,80(s1)
    80001994:	c121                	beqz	a0,800019d4 <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    80001996:	8526                	mv	a0,s1
    80001998:	00000097          	auipc	ra,0x0
    8000199c:	f4a080e7          	jalr	-182(ra) # 800018e2 <proc_pagetable>
    800019a0:	e4a8                	sd	a0,72(s1)
  memset(&p->context, 0, sizeof p->context);
    800019a2:	07000613          	li	a2,112
    800019a6:	4581                	li	a1,0
    800019a8:	05848513          	addi	a0,s1,88
    800019ac:	fffff097          	auipc	ra,0xfffff
    800019b0:	1d6080e7          	jalr	470(ra) # 80000b82 <memset>
  p->context.ra = (uint64)forkret;
    800019b4:	00000797          	auipc	a5,0x0
    800019b8:	ea278793          	addi	a5,a5,-350 # 80001856 <forkret>
    800019bc:	ecbc                	sd	a5,88(s1)
  p->context.sp = p->kstack + PGSIZE;
    800019be:	7c9c                	ld	a5,56(s1)
    800019c0:	6705                	lui	a4,0x1
    800019c2:	97ba                	add	a5,a5,a4
    800019c4:	f0bc                	sd	a5,96(s1)
}
    800019c6:	8526                	mv	a0,s1
    800019c8:	60e2                	ld	ra,24(sp)
    800019ca:	6442                	ld	s0,16(sp)
    800019cc:	64a2                	ld	s1,8(sp)
    800019ce:	6902                	ld	s2,0(sp)
    800019d0:	6105                	addi	sp,sp,32
    800019d2:	8082                	ret
    release(&p->lock);
    800019d4:	8526                	mv	a0,s1
    800019d6:	fffff097          	auipc	ra,0xfffff
    800019da:	150080e7          	jalr	336(ra) # 80000b26 <release>
    return 0;
    800019de:	84ca                	mv	s1,s2
    800019e0:	b7dd                	j	800019c6 <allocproc+0x88>

00000000800019e2 <proc_freepagetable>:
{
    800019e2:	1101                	addi	sp,sp,-32
    800019e4:	ec06                	sd	ra,24(sp)
    800019e6:	e822                	sd	s0,16(sp)
    800019e8:	e426                	sd	s1,8(sp)
    800019ea:	e04a                	sd	s2,0(sp)
    800019ec:	1000                	addi	s0,sp,32
    800019ee:	84aa                	mv	s1,a0
    800019f0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    800019f2:	4681                	li	a3,0
    800019f4:	6605                	lui	a2,0x1
    800019f6:	040005b7          	lui	a1,0x4000
    800019fa:	15fd                	addi	a1,a1,-1
    800019fc:	05b2                	slli	a1,a1,0xc
    800019fe:	fffff097          	auipc	ra,0xfffff
    80001a02:	7be080e7          	jalr	1982(ra) # 800011bc <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, PGSIZE, 0);
    80001a06:	4681                	li	a3,0
    80001a08:	6605                	lui	a2,0x1
    80001a0a:	020005b7          	lui	a1,0x2000
    80001a0e:	15fd                	addi	a1,a1,-1
    80001a10:	05b6                	slli	a1,a1,0xd
    80001a12:	8526                	mv	a0,s1
    80001a14:	fffff097          	auipc	ra,0xfffff
    80001a18:	7a8080e7          	jalr	1960(ra) # 800011bc <uvmunmap>
  if(sz > 0)
    80001a1c:	00091863          	bnez	s2,80001a2c <proc_freepagetable+0x4a>
}
    80001a20:	60e2                	ld	ra,24(sp)
    80001a22:	6442                	ld	s0,16(sp)
    80001a24:	64a2                	ld	s1,8(sp)
    80001a26:	6902                	ld	s2,0(sp)
    80001a28:	6105                	addi	sp,sp,32
    80001a2a:	8082                	ret
    uvmfree(pagetable, sz);
    80001a2c:	85ca                	mv	a1,s2
    80001a2e:	8526                	mv	a0,s1
    80001a30:	00000097          	auipc	ra,0x0
    80001a34:	9e2080e7          	jalr	-1566(ra) # 80001412 <uvmfree>
}
    80001a38:	b7e5                	j	80001a20 <proc_freepagetable+0x3e>

0000000080001a3a <freeproc>:
{
    80001a3a:	1101                	addi	sp,sp,-32
    80001a3c:	ec06                	sd	ra,24(sp)
    80001a3e:	e822                	sd	s0,16(sp)
    80001a40:	e426                	sd	s1,8(sp)
    80001a42:	1000                	addi	s0,sp,32
    80001a44:	84aa                	mv	s1,a0
  if(p->tf)
    80001a46:	6928                	ld	a0,80(a0)
    80001a48:	c509                	beqz	a0,80001a52 <freeproc+0x18>
    kfree((void*)p->tf);
    80001a4a:	fffff097          	auipc	ra,0xfffff
    80001a4e:	e0a080e7          	jalr	-502(ra) # 80000854 <kfree>
  p->tf = 0;
    80001a52:	0404b823          	sd	zero,80(s1)
  if(p->pagetable)
    80001a56:	64a8                	ld	a0,72(s1)
    80001a58:	c511                	beqz	a0,80001a64 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001a5a:	60ac                	ld	a1,64(s1)
    80001a5c:	00000097          	auipc	ra,0x0
    80001a60:	f86080e7          	jalr	-122(ra) # 800019e2 <proc_freepagetable>
  p->pagetable = 0;
    80001a64:	0404b423          	sd	zero,72(s1)
  p->sz = 0;
    80001a68:	0404b023          	sd	zero,64(s1)
  p->pid = 0;
    80001a6c:	0204aa23          	sw	zero,52(s1)
  p->parent = 0;
    80001a70:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001a74:	14048823          	sb	zero,336(s1)
  p->chan = 0;
    80001a78:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001a7c:	0204a823          	sw	zero,48(s1)
  p->state = UNUSED;
    80001a80:	0004ac23          	sw	zero,24(s1)
}
    80001a84:	60e2                	ld	ra,24(sp)
    80001a86:	6442                	ld	s0,16(sp)
    80001a88:	64a2                	ld	s1,8(sp)
    80001a8a:	6105                	addi	sp,sp,32
    80001a8c:	8082                	ret

0000000080001a8e <userinit>:
{
    80001a8e:	1101                	addi	sp,sp,-32
    80001a90:	ec06                	sd	ra,24(sp)
    80001a92:	e822                	sd	s0,16(sp)
    80001a94:	e426                	sd	s1,8(sp)
    80001a96:	1000                	addi	s0,sp,32
  p = allocproc();
    80001a98:	00000097          	auipc	ra,0x0
    80001a9c:	ea6080e7          	jalr	-346(ra) # 8000193e <allocproc>
    80001aa0:	84aa                	mv	s1,a0
  initproc = p;
    80001aa2:	00027797          	auipc	a5,0x27
    80001aa6:	56a7bf23          	sd	a0,1406(a5) # 80029020 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001aaa:	03300613          	li	a2,51
    80001aae:	00006597          	auipc	a1,0x6
    80001ab2:	55258593          	addi	a1,a1,1362 # 80008000 <initcode>
    80001ab6:	6528                	ld	a0,72(a0)
    80001ab8:	00000097          	auipc	ra,0x0
    80001abc:	80a080e7          	jalr	-2038(ra) # 800012c2 <uvminit>
  p->sz = PGSIZE;
    80001ac0:	6785                	lui	a5,0x1
    80001ac2:	e0bc                	sd	a5,64(s1)
  p->tf->epc = 0;      // user program counter
    80001ac4:	68b8                	ld	a4,80(s1)
    80001ac6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->tf->sp = PGSIZE;  // user stack pointer
    80001aca:	68b8                	ld	a4,80(s1)
    80001acc:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ace:	4641                	li	a2,16
    80001ad0:	00006597          	auipc	a1,0x6
    80001ad4:	81058593          	addi	a1,a1,-2032 # 800072e0 <userret+0x250>
    80001ad8:	15048513          	addi	a0,s1,336
    80001adc:	fffff097          	auipc	ra,0xfffff
    80001ae0:	1f8080e7          	jalr	504(ra) # 80000cd4 <safestrcpy>
  p->cwd = namei("/");
    80001ae4:	00006517          	auipc	a0,0x6
    80001ae8:	80c50513          	addi	a0,a0,-2036 # 800072f0 <userret+0x260>
    80001aec:	00002097          	auipc	ra,0x2
    80001af0:	070080e7          	jalr	112(ra) # 80003b5c <namei>
    80001af4:	14a4b423          	sd	a0,328(s1)
  p->state = RUNNABLE;
    80001af8:	4789                	li	a5,2
    80001afa:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001afc:	8526                	mv	a0,s1
    80001afe:	fffff097          	auipc	ra,0xfffff
    80001b02:	028080e7          	jalr	40(ra) # 80000b26 <release>
}
    80001b06:	60e2                	ld	ra,24(sp)
    80001b08:	6442                	ld	s0,16(sp)
    80001b0a:	64a2                	ld	s1,8(sp)
    80001b0c:	6105                	addi	sp,sp,32
    80001b0e:	8082                	ret

0000000080001b10 <growproc>:
{
    80001b10:	1101                	addi	sp,sp,-32
    80001b12:	ec06                	sd	ra,24(sp)
    80001b14:	e822                	sd	s0,16(sp)
    80001b16:	e426                	sd	s1,8(sp)
    80001b18:	e04a                	sd	s2,0(sp)
    80001b1a:	1000                	addi	s0,sp,32
    80001b1c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b1e:	00000097          	auipc	ra,0x0
    80001b22:	d00080e7          	jalr	-768(ra) # 8000181e <myproc>
    80001b26:	892a                	mv	s2,a0
  sz = p->sz;
    80001b28:	612c                	ld	a1,64(a0)
    80001b2a:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001b2e:	00904f63          	bgtz	s1,80001b4c <growproc+0x3c>
  } else if(n < 0){
    80001b32:	0204cc63          	bltz	s1,80001b6a <growproc+0x5a>
  p->sz = sz;
    80001b36:	1602                	slli	a2,a2,0x20
    80001b38:	9201                	srli	a2,a2,0x20
    80001b3a:	04c93023          	sd	a2,64(s2)
  return 0;
    80001b3e:	4501                	li	a0,0
}
    80001b40:	60e2                	ld	ra,24(sp)
    80001b42:	6442                	ld	s0,16(sp)
    80001b44:	64a2                	ld	s1,8(sp)
    80001b46:	6902                	ld	s2,0(sp)
    80001b48:	6105                	addi	sp,sp,32
    80001b4a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001b4c:	9e25                	addw	a2,a2,s1
    80001b4e:	1602                	slli	a2,a2,0x20
    80001b50:	9201                	srli	a2,a2,0x20
    80001b52:	1582                	slli	a1,a1,0x20
    80001b54:	9181                	srli	a1,a1,0x20
    80001b56:	6528                	ld	a0,72(a0)
    80001b58:	00000097          	auipc	ra,0x0
    80001b5c:	810080e7          	jalr	-2032(ra) # 80001368 <uvmalloc>
    80001b60:	0005061b          	sext.w	a2,a0
    80001b64:	fa69                	bnez	a2,80001b36 <growproc+0x26>
      return -1;
    80001b66:	557d                	li	a0,-1
    80001b68:	bfe1                	j	80001b40 <growproc+0x30>
    if((sz = uvmdealloc(p->pagetable, sz, sz + n)) == 0) {
    80001b6a:	9e25                	addw	a2,a2,s1
    80001b6c:	1602                	slli	a2,a2,0x20
    80001b6e:	9201                	srli	a2,a2,0x20
    80001b70:	1582                	slli	a1,a1,0x20
    80001b72:	9181                	srli	a1,a1,0x20
    80001b74:	6528                	ld	a0,72(a0)
    80001b76:	fffff097          	auipc	ra,0xfffff
    80001b7a:	7be080e7          	jalr	1982(ra) # 80001334 <uvmdealloc>
    80001b7e:	0005061b          	sext.w	a2,a0
    80001b82:	fa55                	bnez	a2,80001b36 <growproc+0x26>
      return -1;
    80001b84:	557d                	li	a0,-1
    80001b86:	bf6d                	j	80001b40 <growproc+0x30>

0000000080001b88 <fork>:
{
    80001b88:	7139                	addi	sp,sp,-64
    80001b8a:	fc06                	sd	ra,56(sp)
    80001b8c:	f822                	sd	s0,48(sp)
    80001b8e:	f426                	sd	s1,40(sp)
    80001b90:	f04a                	sd	s2,32(sp)
    80001b92:	ec4e                	sd	s3,24(sp)
    80001b94:	e852                	sd	s4,16(sp)
    80001b96:	e456                	sd	s5,8(sp)
    80001b98:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001b9a:	00000097          	auipc	ra,0x0
    80001b9e:	c84080e7          	jalr	-892(ra) # 8000181e <myproc>
    80001ba2:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001ba4:	00000097          	auipc	ra,0x0
    80001ba8:	d9a080e7          	jalr	-614(ra) # 8000193e <allocproc>
    80001bac:	c17d                	beqz	a0,80001c92 <fork+0x10a>
    80001bae:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001bb0:	040ab603          	ld	a2,64(s5)
    80001bb4:	652c                	ld	a1,72(a0)
    80001bb6:	048ab503          	ld	a0,72(s5)
    80001bba:	00000097          	auipc	ra,0x0
    80001bbe:	886080e7          	jalr	-1914(ra) # 80001440 <uvmcopy>
    80001bc2:	04054a63          	bltz	a0,80001c16 <fork+0x8e>
  np->sz = p->sz;
    80001bc6:	040ab783          	ld	a5,64(s5)
    80001bca:	04fa3023          	sd	a5,64(s4)
  np->parent = p;
    80001bce:	035a3023          	sd	s5,32(s4)
  *(np->tf) = *(p->tf);
    80001bd2:	050ab683          	ld	a3,80(s5)
    80001bd6:	87b6                	mv	a5,a3
    80001bd8:	050a3703          	ld	a4,80(s4)
    80001bdc:	12068693          	addi	a3,a3,288
    80001be0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001be4:	6788                	ld	a0,8(a5)
    80001be6:	6b8c                	ld	a1,16(a5)
    80001be8:	6f90                	ld	a2,24(a5)
    80001bea:	01073023          	sd	a6,0(a4)
    80001bee:	e708                	sd	a0,8(a4)
    80001bf0:	eb0c                	sd	a1,16(a4)
    80001bf2:	ef10                	sd	a2,24(a4)
    80001bf4:	02078793          	addi	a5,a5,32
    80001bf8:	02070713          	addi	a4,a4,32
    80001bfc:	fed792e3          	bne	a5,a3,80001be0 <fork+0x58>
  np->tf->a0 = 0;
    80001c00:	050a3783          	ld	a5,80(s4)
    80001c04:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001c08:	0c8a8493          	addi	s1,s5,200
    80001c0c:	0c8a0913          	addi	s2,s4,200
    80001c10:	148a8993          	addi	s3,s5,328
    80001c14:	a00d                	j	80001c36 <fork+0xae>
    freeproc(np);
    80001c16:	8552                	mv	a0,s4
    80001c18:	00000097          	auipc	ra,0x0
    80001c1c:	e22080e7          	jalr	-478(ra) # 80001a3a <freeproc>
    release(&np->lock);
    80001c20:	8552                	mv	a0,s4
    80001c22:	fffff097          	auipc	ra,0xfffff
    80001c26:	f04080e7          	jalr	-252(ra) # 80000b26 <release>
    return -1;
    80001c2a:	54fd                	li	s1,-1
    80001c2c:	a889                	j	80001c7e <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    80001c2e:	04a1                	addi	s1,s1,8
    80001c30:	0921                	addi	s2,s2,8
    80001c32:	01348b63          	beq	s1,s3,80001c48 <fork+0xc0>
    if(p->ofile[i])
    80001c36:	6088                	ld	a0,0(s1)
    80001c38:	d97d                	beqz	a0,80001c2e <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001c3a:	00003097          	auipc	ra,0x3
    80001c3e:	816080e7          	jalr	-2026(ra) # 80004450 <filedup>
    80001c42:	00a93023          	sd	a0,0(s2)
    80001c46:	b7e5                	j	80001c2e <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001c48:	148ab503          	ld	a0,328(s5)
    80001c4c:	00001097          	auipc	ra,0x1
    80001c50:	746080e7          	jalr	1862(ra) # 80003392 <idup>
    80001c54:	14aa3423          	sd	a0,328(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c58:	4641                	li	a2,16
    80001c5a:	150a8593          	addi	a1,s5,336
    80001c5e:	150a0513          	addi	a0,s4,336
    80001c62:	fffff097          	auipc	ra,0xfffff
    80001c66:	072080e7          	jalr	114(ra) # 80000cd4 <safestrcpy>
  pid = np->pid;
    80001c6a:	034a2483          	lw	s1,52(s4)
  np->state = RUNNABLE;
    80001c6e:	4789                	li	a5,2
    80001c70:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001c74:	8552                	mv	a0,s4
    80001c76:	fffff097          	auipc	ra,0xfffff
    80001c7a:	eb0080e7          	jalr	-336(ra) # 80000b26 <release>
}
    80001c7e:	8526                	mv	a0,s1
    80001c80:	70e2                	ld	ra,56(sp)
    80001c82:	7442                	ld	s0,48(sp)
    80001c84:	74a2                	ld	s1,40(sp)
    80001c86:	7902                	ld	s2,32(sp)
    80001c88:	69e2                	ld	s3,24(sp)
    80001c8a:	6a42                	ld	s4,16(sp)
    80001c8c:	6aa2                	ld	s5,8(sp)
    80001c8e:	6121                	addi	sp,sp,64
    80001c90:	8082                	ret
    return -1;
    80001c92:	54fd                	li	s1,-1
    80001c94:	b7ed                	j	80001c7e <fork+0xf6>

0000000080001c96 <reparent>:
reparent(struct proc *p, struct proc *parent) {
    80001c96:	711d                	addi	sp,sp,-96
    80001c98:	ec86                	sd	ra,88(sp)
    80001c9a:	e8a2                	sd	s0,80(sp)
    80001c9c:	e4a6                	sd	s1,72(sp)
    80001c9e:	e0ca                	sd	s2,64(sp)
    80001ca0:	fc4e                	sd	s3,56(sp)
    80001ca2:	f852                	sd	s4,48(sp)
    80001ca4:	f456                	sd	s5,40(sp)
    80001ca6:	f05a                	sd	s6,32(sp)
    80001ca8:	ec5e                	sd	s7,24(sp)
    80001caa:	e862                	sd	s8,16(sp)
    80001cac:	e466                	sd	s9,8(sp)
    80001cae:	1080                	addi	s0,sp,96
    80001cb0:	892a                	mv	s2,a0
  int child_of_init = (p->parent == initproc);
    80001cb2:	02053b83          	ld	s7,32(a0)
    80001cb6:	00027b17          	auipc	s6,0x27
    80001cba:	36ab3b03          	ld	s6,874(s6) # 80029020 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001cbe:	00010497          	auipc	s1,0x10
    80001cc2:	04248493          	addi	s1,s1,66 # 80011d00 <proc>
      pp->parent = initproc;
    80001cc6:	00027a17          	auipc	s4,0x27
    80001cca:	35aa0a13          	addi	s4,s4,858 # 80029020 <initproc>
      if(pp->state == ZOMBIE) {
    80001cce:	4a91                	li	s5,4
// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
  if(p->chan == p && p->state == SLEEPING) {
    80001cd0:	4c05                	li	s8,1
    p->state = RUNNABLE;
    80001cd2:	4c89                	li	s9,2
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001cd4:	00016997          	auipc	s3,0x16
    80001cd8:	82c98993          	addi	s3,s3,-2004 # 80017500 <tickslock>
    80001cdc:	a805                	j	80001d0c <reparent+0x76>
  if(p->chan == p && p->state == SLEEPING) {
    80001cde:	751c                	ld	a5,40(a0)
    80001ce0:	00f51d63          	bne	a0,a5,80001cfa <reparent+0x64>
    80001ce4:	4d1c                	lw	a5,24(a0)
    80001ce6:	01879a63          	bne	a5,s8,80001cfa <reparent+0x64>
    p->state = RUNNABLE;
    80001cea:	01952c23          	sw	s9,24(a0)
        if(!child_of_init)
    80001cee:	016b8663          	beq	s7,s6,80001cfa <reparent+0x64>
          release(&initproc->lock);
    80001cf2:	fffff097          	auipc	ra,0xfffff
    80001cf6:	e34080e7          	jalr	-460(ra) # 80000b26 <release>
      release(&pp->lock);
    80001cfa:	8526                	mv	a0,s1
    80001cfc:	fffff097          	auipc	ra,0xfffff
    80001d00:	e2a080e7          	jalr	-470(ra) # 80000b26 <release>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001d04:	16048493          	addi	s1,s1,352
    80001d08:	03348f63          	beq	s1,s3,80001d46 <reparent+0xb0>
    if(pp->parent == p){
    80001d0c:	709c                	ld	a5,32(s1)
    80001d0e:	ff279be3          	bne	a5,s2,80001d04 <reparent+0x6e>
      acquire(&pp->lock);
    80001d12:	8526                	mv	a0,s1
    80001d14:	fffff097          	auipc	ra,0xfffff
    80001d18:	daa080e7          	jalr	-598(ra) # 80000abe <acquire>
      pp->parent = initproc;
    80001d1c:	000a3503          	ld	a0,0(s4)
    80001d20:	f088                	sd	a0,32(s1)
      if(pp->state == ZOMBIE) {
    80001d22:	4c9c                	lw	a5,24(s1)
    80001d24:	fd579be3          	bne	a5,s5,80001cfa <reparent+0x64>
        if(!child_of_init)
    80001d28:	fb6b8be3          	beq	s7,s6,80001cde <reparent+0x48>
          acquire(&initproc->lock);
    80001d2c:	fffff097          	auipc	ra,0xfffff
    80001d30:	d92080e7          	jalr	-622(ra) # 80000abe <acquire>
        wakeup1(initproc);
    80001d34:	000a3503          	ld	a0,0(s4)
  if(p->chan == p && p->state == SLEEPING) {
    80001d38:	751c                	ld	a5,40(a0)
    80001d3a:	faa79ce3          	bne	a5,a0,80001cf2 <reparent+0x5c>
    80001d3e:	4d1c                	lw	a5,24(a0)
    80001d40:	fb8799e3          	bne	a5,s8,80001cf2 <reparent+0x5c>
    80001d44:	b75d                	j	80001cea <reparent+0x54>
}
    80001d46:	60e6                	ld	ra,88(sp)
    80001d48:	6446                	ld	s0,80(sp)
    80001d4a:	64a6                	ld	s1,72(sp)
    80001d4c:	6906                	ld	s2,64(sp)
    80001d4e:	79e2                	ld	s3,56(sp)
    80001d50:	7a42                	ld	s4,48(sp)
    80001d52:	7aa2                	ld	s5,40(sp)
    80001d54:	7b02                	ld	s6,32(sp)
    80001d56:	6be2                	ld	s7,24(sp)
    80001d58:	6c42                	ld	s8,16(sp)
    80001d5a:	6ca2                	ld	s9,8(sp)
    80001d5c:	6125                	addi	sp,sp,96
    80001d5e:	8082                	ret

0000000080001d60 <scheduler>:
{
    80001d60:	715d                	addi	sp,sp,-80
    80001d62:	e486                	sd	ra,72(sp)
    80001d64:	e0a2                	sd	s0,64(sp)
    80001d66:	fc26                	sd	s1,56(sp)
    80001d68:	f84a                	sd	s2,48(sp)
    80001d6a:	f44e                	sd	s3,40(sp)
    80001d6c:	f052                	sd	s4,32(sp)
    80001d6e:	ec56                	sd	s5,24(sp)
    80001d70:	e85a                	sd	s6,16(sp)
    80001d72:	e45e                	sd	s7,8(sp)
    80001d74:	e062                	sd	s8,0(sp)
    80001d76:	0880                	addi	s0,sp,80
    80001d78:	8792                	mv	a5,tp
  int id = r_tp();
    80001d7a:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d7c:	00779b13          	slli	s6,a5,0x7
    80001d80:	00010717          	auipc	a4,0x10
    80001d84:	b6870713          	addi	a4,a4,-1176 # 800118e8 <pid_lock>
    80001d88:	975a                	add	a4,a4,s6
    80001d8a:	00073c23          	sd	zero,24(a4)
        swtch(&c->scheduler, &p->context);
    80001d8e:	00010717          	auipc	a4,0x10
    80001d92:	b7a70713          	addi	a4,a4,-1158 # 80011908 <cpus+0x8>
    80001d96:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001d98:	4c0d                	li	s8,3
        c->proc = p;
    80001d9a:	079e                	slli	a5,a5,0x7
    80001d9c:	00010a17          	auipc	s4,0x10
    80001da0:	b4ca0a13          	addi	s4,s4,-1204 # 800118e8 <pid_lock>
    80001da4:	9a3e                	add	s4,s4,a5
        found = 1;
    80001da6:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001da8:	00015997          	auipc	s3,0x15
    80001dac:	75898993          	addi	s3,s3,1880 # 80017500 <tickslock>
    80001db0:	a08d                	j	80001e12 <scheduler+0xb2>
      release(&p->lock);
    80001db2:	8526                	mv	a0,s1
    80001db4:	fffff097          	auipc	ra,0xfffff
    80001db8:	d72080e7          	jalr	-654(ra) # 80000b26 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dbc:	16048493          	addi	s1,s1,352
    80001dc0:	03348963          	beq	s1,s3,80001df2 <scheduler+0x92>
      acquire(&p->lock);
    80001dc4:	8526                	mv	a0,s1
    80001dc6:	fffff097          	auipc	ra,0xfffff
    80001dca:	cf8080e7          	jalr	-776(ra) # 80000abe <acquire>
      if(p->state == RUNNABLE) {
    80001dce:	4c9c                	lw	a5,24(s1)
    80001dd0:	ff2791e3          	bne	a5,s2,80001db2 <scheduler+0x52>
        p->state = RUNNING;
    80001dd4:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001dd8:	009a3c23          	sd	s1,24(s4)
        swtch(&c->scheduler, &p->context);
    80001ddc:	05848593          	addi	a1,s1,88
    80001de0:	855a                	mv	a0,s6
    80001de2:	00000097          	auipc	ra,0x0
    80001de6:	5c2080e7          	jalr	1474(ra) # 800023a4 <swtch>
        c->proc = 0;
    80001dea:	000a3c23          	sd	zero,24(s4)
        found = 1;
    80001dee:	8ade                	mv	s5,s7
    80001df0:	b7c9                	j	80001db2 <scheduler+0x52>
    if(found == 0){
    80001df2:	020a9063          	bnez	s5,80001e12 <scheduler+0xb2>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80001df6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80001dfa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80001dfe:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e02:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e06:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e0a:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001e0e:	10500073          	wfi
  asm volatile("csrr %0, sie" : "=r" (x) );
    80001e12:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80001e16:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80001e1a:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e1e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e22:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e26:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001e2a:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e2c:	00010497          	auipc	s1,0x10
    80001e30:	ed448493          	addi	s1,s1,-300 # 80011d00 <proc>
      if(p->state == RUNNABLE) {
    80001e34:	4909                	li	s2,2
    80001e36:	b779                	j	80001dc4 <scheduler+0x64>

0000000080001e38 <sched>:
{
    80001e38:	7179                	addi	sp,sp,-48
    80001e3a:	f406                	sd	ra,40(sp)
    80001e3c:	f022                	sd	s0,32(sp)
    80001e3e:	ec26                	sd	s1,24(sp)
    80001e40:	e84a                	sd	s2,16(sp)
    80001e42:	e44e                	sd	s3,8(sp)
    80001e44:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e46:	00000097          	auipc	ra,0x0
    80001e4a:	9d8080e7          	jalr	-1576(ra) # 8000181e <myproc>
    80001e4e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001e50:	fffff097          	auipc	ra,0xfffff
    80001e54:	c2e080e7          	jalr	-978(ra) # 80000a7e <holding>
    80001e58:	c93d                	beqz	a0,80001ece <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e5a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001e5c:	2781                	sext.w	a5,a5
    80001e5e:	079e                	slli	a5,a5,0x7
    80001e60:	00010717          	auipc	a4,0x10
    80001e64:	a8870713          	addi	a4,a4,-1400 # 800118e8 <pid_lock>
    80001e68:	97ba                	add	a5,a5,a4
    80001e6a:	0907a703          	lw	a4,144(a5)
    80001e6e:	4785                	li	a5,1
    80001e70:	06f71763          	bne	a4,a5,80001ede <sched+0xa6>
  if(p->state == RUNNING)
    80001e74:	4c98                	lw	a4,24(s1)
    80001e76:	478d                	li	a5,3
    80001e78:	06f70b63          	beq	a4,a5,80001eee <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e7c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e80:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e82:	efb5                	bnez	a5,80001efe <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e84:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e86:	00010917          	auipc	s2,0x10
    80001e8a:	a6290913          	addi	s2,s2,-1438 # 800118e8 <pid_lock>
    80001e8e:	2781                	sext.w	a5,a5
    80001e90:	079e                	slli	a5,a5,0x7
    80001e92:	97ca                	add	a5,a5,s2
    80001e94:	0947a983          	lw	s3,148(a5)
    80001e98:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->scheduler);
    80001e9a:	2781                	sext.w	a5,a5
    80001e9c:	079e                	slli	a5,a5,0x7
    80001e9e:	00010597          	auipc	a1,0x10
    80001ea2:	a6a58593          	addi	a1,a1,-1430 # 80011908 <cpus+0x8>
    80001ea6:	95be                	add	a1,a1,a5
    80001ea8:	05848513          	addi	a0,s1,88
    80001eac:	00000097          	auipc	ra,0x0
    80001eb0:	4f8080e7          	jalr	1272(ra) # 800023a4 <swtch>
    80001eb4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001eb6:	2781                	sext.w	a5,a5
    80001eb8:	079e                	slli	a5,a5,0x7
    80001eba:	97ca                	add	a5,a5,s2
    80001ebc:	0937aa23          	sw	s3,148(a5)
}
    80001ec0:	70a2                	ld	ra,40(sp)
    80001ec2:	7402                	ld	s0,32(sp)
    80001ec4:	64e2                	ld	s1,24(sp)
    80001ec6:	6942                	ld	s2,16(sp)
    80001ec8:	69a2                	ld	s3,8(sp)
    80001eca:	6145                	addi	sp,sp,48
    80001ecc:	8082                	ret
    panic("sched p->lock");
    80001ece:	00005517          	auipc	a0,0x5
    80001ed2:	42a50513          	addi	a0,a0,1066 # 800072f8 <userret+0x268>
    80001ed6:	ffffe097          	auipc	ra,0xffffe
    80001eda:	672080e7          	jalr	1650(ra) # 80000548 <panic>
    panic("sched locks");
    80001ede:	00005517          	auipc	a0,0x5
    80001ee2:	42a50513          	addi	a0,a0,1066 # 80007308 <userret+0x278>
    80001ee6:	ffffe097          	auipc	ra,0xffffe
    80001eea:	662080e7          	jalr	1634(ra) # 80000548 <panic>
    panic("sched running");
    80001eee:	00005517          	auipc	a0,0x5
    80001ef2:	42a50513          	addi	a0,a0,1066 # 80007318 <userret+0x288>
    80001ef6:	ffffe097          	auipc	ra,0xffffe
    80001efa:	652080e7          	jalr	1618(ra) # 80000548 <panic>
    panic("sched interruptible");
    80001efe:	00005517          	auipc	a0,0x5
    80001f02:	42a50513          	addi	a0,a0,1066 # 80007328 <userret+0x298>
    80001f06:	ffffe097          	auipc	ra,0xffffe
    80001f0a:	642080e7          	jalr	1602(ra) # 80000548 <panic>

0000000080001f0e <exit>:
{
    80001f0e:	7179                	addi	sp,sp,-48
    80001f10:	f406                	sd	ra,40(sp)
    80001f12:	f022                	sd	s0,32(sp)
    80001f14:	ec26                	sd	s1,24(sp)
    80001f16:	e84a                	sd	s2,16(sp)
    80001f18:	e44e                	sd	s3,8(sp)
    80001f1a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f1c:	00000097          	auipc	ra,0x0
    80001f20:	902080e7          	jalr	-1790(ra) # 8000181e <myproc>
    80001f24:	89aa                	mv	s3,a0
  if(p == initproc)
    80001f26:	00027797          	auipc	a5,0x27
    80001f2a:	0fa7b783          	ld	a5,250(a5) # 80029020 <initproc>
    80001f2e:	0c850493          	addi	s1,a0,200
    80001f32:	14850913          	addi	s2,a0,328
    80001f36:	02a79363          	bne	a5,a0,80001f5c <exit+0x4e>
    panic("init exiting");
    80001f3a:	00005517          	auipc	a0,0x5
    80001f3e:	40650513          	addi	a0,a0,1030 # 80007340 <userret+0x2b0>
    80001f42:	ffffe097          	auipc	ra,0xffffe
    80001f46:	606080e7          	jalr	1542(ra) # 80000548 <panic>
      fileclose(f);
    80001f4a:	00002097          	auipc	ra,0x2
    80001f4e:	558080e7          	jalr	1368(ra) # 800044a2 <fileclose>
      p->ofile[fd] = 0;
    80001f52:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001f56:	04a1                	addi	s1,s1,8
    80001f58:	01248563          	beq	s1,s2,80001f62 <exit+0x54>
    if(p->ofile[fd]){
    80001f5c:	6088                	ld	a0,0(s1)
    80001f5e:	f575                	bnez	a0,80001f4a <exit+0x3c>
    80001f60:	bfdd                	j	80001f56 <exit+0x48>
  begin_op(ROOTDEV);
    80001f62:	4501                	li	a0,0
    80001f64:	00002097          	auipc	ra,0x2
    80001f68:	f16080e7          	jalr	-234(ra) # 80003e7a <begin_op>
  iput(p->cwd);
    80001f6c:	1489b503          	ld	a0,328(s3)
    80001f70:	00001097          	auipc	ra,0x1
    80001f74:	56e080e7          	jalr	1390(ra) # 800034de <iput>
  end_op(ROOTDEV);
    80001f78:	4501                	li	a0,0
    80001f7a:	00002097          	auipc	ra,0x2
    80001f7e:	faa080e7          	jalr	-86(ra) # 80003f24 <end_op>
  p->cwd = 0;
    80001f82:	1409b423          	sd	zero,328(s3)
  acquire(&p->parent->lock);
    80001f86:	0209b503          	ld	a0,32(s3)
    80001f8a:	fffff097          	auipc	ra,0xfffff
    80001f8e:	b34080e7          	jalr	-1228(ra) # 80000abe <acquire>
  acquire(&p->lock);
    80001f92:	854e                	mv	a0,s3
    80001f94:	fffff097          	auipc	ra,0xfffff
    80001f98:	b2a080e7          	jalr	-1238(ra) # 80000abe <acquire>
  reparent(p, p->parent);
    80001f9c:	0209b583          	ld	a1,32(s3)
    80001fa0:	854e                	mv	a0,s3
    80001fa2:	00000097          	auipc	ra,0x0
    80001fa6:	cf4080e7          	jalr	-780(ra) # 80001c96 <reparent>
  wakeup1(p->parent);
    80001faa:	0209b783          	ld	a5,32(s3)
  if(p->chan == p && p->state == SLEEPING) {
    80001fae:	7798                	ld	a4,40(a5)
    80001fb0:	02e78763          	beq	a5,a4,80001fde <exit+0xd0>
  p->state = ZOMBIE;
    80001fb4:	4791                	li	a5,4
    80001fb6:	00f9ac23          	sw	a5,24(s3)
  release(&p->parent->lock);
    80001fba:	0209b503          	ld	a0,32(s3)
    80001fbe:	fffff097          	auipc	ra,0xfffff
    80001fc2:	b68080e7          	jalr	-1176(ra) # 80000b26 <release>
  sched();
    80001fc6:	00000097          	auipc	ra,0x0
    80001fca:	e72080e7          	jalr	-398(ra) # 80001e38 <sched>
  panic("zombie exit");
    80001fce:	00005517          	auipc	a0,0x5
    80001fd2:	38250513          	addi	a0,a0,898 # 80007350 <userret+0x2c0>
    80001fd6:	ffffe097          	auipc	ra,0xffffe
    80001fda:	572080e7          	jalr	1394(ra) # 80000548 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001fde:	4f94                	lw	a3,24(a5)
    80001fe0:	4705                	li	a4,1
    80001fe2:	fce699e3          	bne	a3,a4,80001fb4 <exit+0xa6>
    p->state = RUNNABLE;
    80001fe6:	4709                	li	a4,2
    80001fe8:	cf98                	sw	a4,24(a5)
    80001fea:	b7e9                	j	80001fb4 <exit+0xa6>

0000000080001fec <yield>:
{
    80001fec:	1101                	addi	sp,sp,-32
    80001fee:	ec06                	sd	ra,24(sp)
    80001ff0:	e822                	sd	s0,16(sp)
    80001ff2:	e426                	sd	s1,8(sp)
    80001ff4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001ff6:	00000097          	auipc	ra,0x0
    80001ffa:	828080e7          	jalr	-2008(ra) # 8000181e <myproc>
    80001ffe:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002000:	fffff097          	auipc	ra,0xfffff
    80002004:	abe080e7          	jalr	-1346(ra) # 80000abe <acquire>
  p->state = RUNNABLE;
    80002008:	4789                	li	a5,2
    8000200a:	cc9c                	sw	a5,24(s1)
  sched();
    8000200c:	00000097          	auipc	ra,0x0
    80002010:	e2c080e7          	jalr	-468(ra) # 80001e38 <sched>
  release(&p->lock);
    80002014:	8526                	mv	a0,s1
    80002016:	fffff097          	auipc	ra,0xfffff
    8000201a:	b10080e7          	jalr	-1264(ra) # 80000b26 <release>
}
    8000201e:	60e2                	ld	ra,24(sp)
    80002020:	6442                	ld	s0,16(sp)
    80002022:	64a2                	ld	s1,8(sp)
    80002024:	6105                	addi	sp,sp,32
    80002026:	8082                	ret

0000000080002028 <sleep>:
{
    80002028:	7179                	addi	sp,sp,-48
    8000202a:	f406                	sd	ra,40(sp)
    8000202c:	f022                	sd	s0,32(sp)
    8000202e:	ec26                	sd	s1,24(sp)
    80002030:	e84a                	sd	s2,16(sp)
    80002032:	e44e                	sd	s3,8(sp)
    80002034:	1800                	addi	s0,sp,48
    80002036:	89aa                	mv	s3,a0
    80002038:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000203a:	fffff097          	auipc	ra,0xfffff
    8000203e:	7e4080e7          	jalr	2020(ra) # 8000181e <myproc>
    80002042:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002044:	05250663          	beq	a0,s2,80002090 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    80002048:	fffff097          	auipc	ra,0xfffff
    8000204c:	a76080e7          	jalr	-1418(ra) # 80000abe <acquire>
    release(lk);
    80002050:	854a                	mv	a0,s2
    80002052:	fffff097          	auipc	ra,0xfffff
    80002056:	ad4080e7          	jalr	-1324(ra) # 80000b26 <release>
  p->chan = chan;
    8000205a:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000205e:	4785                	li	a5,1
    80002060:	cc9c                	sw	a5,24(s1)
  sched();
    80002062:	00000097          	auipc	ra,0x0
    80002066:	dd6080e7          	jalr	-554(ra) # 80001e38 <sched>
  p->chan = 0;
    8000206a:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    8000206e:	8526                	mv	a0,s1
    80002070:	fffff097          	auipc	ra,0xfffff
    80002074:	ab6080e7          	jalr	-1354(ra) # 80000b26 <release>
    acquire(lk);
    80002078:	854a                	mv	a0,s2
    8000207a:	fffff097          	auipc	ra,0xfffff
    8000207e:	a44080e7          	jalr	-1468(ra) # 80000abe <acquire>
}
    80002082:	70a2                	ld	ra,40(sp)
    80002084:	7402                	ld	s0,32(sp)
    80002086:	64e2                	ld	s1,24(sp)
    80002088:	6942                	ld	s2,16(sp)
    8000208a:	69a2                	ld	s3,8(sp)
    8000208c:	6145                	addi	sp,sp,48
    8000208e:	8082                	ret
  p->chan = chan;
    80002090:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    80002094:	4785                	li	a5,1
    80002096:	cd1c                	sw	a5,24(a0)
  sched();
    80002098:	00000097          	auipc	ra,0x0
    8000209c:	da0080e7          	jalr	-608(ra) # 80001e38 <sched>
  p->chan = 0;
    800020a0:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    800020a4:	bff9                	j	80002082 <sleep+0x5a>

00000000800020a6 <wait>:
{
    800020a6:	7139                	addi	sp,sp,-64
    800020a8:	fc06                	sd	ra,56(sp)
    800020aa:	f822                	sd	s0,48(sp)
    800020ac:	f426                	sd	s1,40(sp)
    800020ae:	f04a                	sd	s2,32(sp)
    800020b0:	ec4e                	sd	s3,24(sp)
    800020b2:	e852                	sd	s4,16(sp)
    800020b4:	e456                	sd	s5,8(sp)
    800020b6:	e05a                	sd	s6,0(sp)
    800020b8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800020ba:	fffff097          	auipc	ra,0xfffff
    800020be:	764080e7          	jalr	1892(ra) # 8000181e <myproc>
    800020c2:	892a                	mv	s2,a0
  acquire(&p->lock);
    800020c4:	fffff097          	auipc	ra,0xfffff
    800020c8:	9fa080e7          	jalr	-1542(ra) # 80000abe <acquire>
    havekids = 0;
    800020cc:	4b01                	li	s6,0
        if(np->state == ZOMBIE){
    800020ce:	4a11                	li	s4,4
        havekids = 1;
    800020d0:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800020d2:	00015997          	auipc	s3,0x15
    800020d6:	42e98993          	addi	s3,s3,1070 # 80017500 <tickslock>
    havekids = 0;
    800020da:	875a                	mv	a4,s6
    for(np = proc; np < &proc[NPROC]; np++){
    800020dc:	00010497          	auipc	s1,0x10
    800020e0:	c2448493          	addi	s1,s1,-988 # 80011d00 <proc>
    800020e4:	a03d                	j	80002112 <wait+0x6c>
          pid = np->pid;
    800020e6:	0344a983          	lw	s3,52(s1)
          freeproc(np);
    800020ea:	8526                	mv	a0,s1
    800020ec:	00000097          	auipc	ra,0x0
    800020f0:	94e080e7          	jalr	-1714(ra) # 80001a3a <freeproc>
          release(&np->lock);
    800020f4:	8526                	mv	a0,s1
    800020f6:	fffff097          	auipc	ra,0xfffff
    800020fa:	a30080e7          	jalr	-1488(ra) # 80000b26 <release>
          release(&p->lock);
    800020fe:	854a                	mv	a0,s2
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	a26080e7          	jalr	-1498(ra) # 80000b26 <release>
          return pid;
    80002108:	a089                	j	8000214a <wait+0xa4>
    for(np = proc; np < &proc[NPROC]; np++){
    8000210a:	16048493          	addi	s1,s1,352
    8000210e:	03348463          	beq	s1,s3,80002136 <wait+0x90>
      if(np->parent == p){
    80002112:	709c                	ld	a5,32(s1)
    80002114:	ff279be3          	bne	a5,s2,8000210a <wait+0x64>
        acquire(&np->lock);
    80002118:	8526                	mv	a0,s1
    8000211a:	fffff097          	auipc	ra,0xfffff
    8000211e:	9a4080e7          	jalr	-1628(ra) # 80000abe <acquire>
        if(np->state == ZOMBIE){
    80002122:	4c9c                	lw	a5,24(s1)
    80002124:	fd4781e3          	beq	a5,s4,800020e6 <wait+0x40>
        release(&np->lock);
    80002128:	8526                	mv	a0,s1
    8000212a:	fffff097          	auipc	ra,0xfffff
    8000212e:	9fc080e7          	jalr	-1540(ra) # 80000b26 <release>
        havekids = 1;
    80002132:	8756                	mv	a4,s5
    80002134:	bfd9                	j	8000210a <wait+0x64>
    if(!havekids || p->killed){
    80002136:	c701                	beqz	a4,8000213e <wait+0x98>
    80002138:	03092783          	lw	a5,48(s2)
    8000213c:	c395                	beqz	a5,80002160 <wait+0xba>
      release(&p->lock);
    8000213e:	854a                	mv	a0,s2
    80002140:	fffff097          	auipc	ra,0xfffff
    80002144:	9e6080e7          	jalr	-1562(ra) # 80000b26 <release>
      return -1;
    80002148:	59fd                	li	s3,-1
}
    8000214a:	854e                	mv	a0,s3
    8000214c:	70e2                	ld	ra,56(sp)
    8000214e:	7442                	ld	s0,48(sp)
    80002150:	74a2                	ld	s1,40(sp)
    80002152:	7902                	ld	s2,32(sp)
    80002154:	69e2                	ld	s3,24(sp)
    80002156:	6a42                	ld	s4,16(sp)
    80002158:	6aa2                	ld	s5,8(sp)
    8000215a:	6b02                	ld	s6,0(sp)
    8000215c:	6121                	addi	sp,sp,64
    8000215e:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    80002160:	85ca                	mv	a1,s2
    80002162:	854a                	mv	a0,s2
    80002164:	00000097          	auipc	ra,0x0
    80002168:	ec4080e7          	jalr	-316(ra) # 80002028 <sleep>
    havekids = 0;
    8000216c:	b7bd                	j	800020da <wait+0x34>

000000008000216e <wakeup>:
{
    8000216e:	7139                	addi	sp,sp,-64
    80002170:	fc06                	sd	ra,56(sp)
    80002172:	f822                	sd	s0,48(sp)
    80002174:	f426                	sd	s1,40(sp)
    80002176:	f04a                	sd	s2,32(sp)
    80002178:	ec4e                	sd	s3,24(sp)
    8000217a:	e852                	sd	s4,16(sp)
    8000217c:	e456                	sd	s5,8(sp)
    8000217e:	0080                	addi	s0,sp,64
    80002180:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002182:	00010497          	auipc	s1,0x10
    80002186:	b7e48493          	addi	s1,s1,-1154 # 80011d00 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    8000218a:	4985                	li	s3,1
      p->state = RUNNABLE;
    8000218c:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000218e:	00015917          	auipc	s2,0x15
    80002192:	37290913          	addi	s2,s2,882 # 80017500 <tickslock>
    80002196:	a811                	j	800021aa <wakeup+0x3c>
    release(&p->lock);
    80002198:	8526                	mv	a0,s1
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	98c080e7          	jalr	-1652(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800021a2:	16048493          	addi	s1,s1,352
    800021a6:	03248063          	beq	s1,s2,800021c6 <wakeup+0x58>
    acquire(&p->lock);
    800021aa:	8526                	mv	a0,s1
    800021ac:	fffff097          	auipc	ra,0xfffff
    800021b0:	912080e7          	jalr	-1774(ra) # 80000abe <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800021b4:	4c9c                	lw	a5,24(s1)
    800021b6:	ff3791e3          	bne	a5,s3,80002198 <wakeup+0x2a>
    800021ba:	749c                	ld	a5,40(s1)
    800021bc:	fd479ee3          	bne	a5,s4,80002198 <wakeup+0x2a>
      p->state = RUNNABLE;
    800021c0:	0154ac23          	sw	s5,24(s1)
    800021c4:	bfd1                	j	80002198 <wakeup+0x2a>
}
    800021c6:	70e2                	ld	ra,56(sp)
    800021c8:	7442                	ld	s0,48(sp)
    800021ca:	74a2                	ld	s1,40(sp)
    800021cc:	7902                	ld	s2,32(sp)
    800021ce:	69e2                	ld	s3,24(sp)
    800021d0:	6a42                	ld	s4,16(sp)
    800021d2:	6aa2                	ld	s5,8(sp)
    800021d4:	6121                	addi	sp,sp,64
    800021d6:	8082                	ret

00000000800021d8 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800021d8:	7179                	addi	sp,sp,-48
    800021da:	f406                	sd	ra,40(sp)
    800021dc:	f022                	sd	s0,32(sp)
    800021de:	ec26                	sd	s1,24(sp)
    800021e0:	e84a                	sd	s2,16(sp)
    800021e2:	e44e                	sd	s3,8(sp)
    800021e4:	1800                	addi	s0,sp,48
    800021e6:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800021e8:	00010497          	auipc	s1,0x10
    800021ec:	b1848493          	addi	s1,s1,-1256 # 80011d00 <proc>
    800021f0:	00015997          	auipc	s3,0x15
    800021f4:	31098993          	addi	s3,s3,784 # 80017500 <tickslock>
    acquire(&p->lock);
    800021f8:	8526                	mv	a0,s1
    800021fa:	fffff097          	auipc	ra,0xfffff
    800021fe:	8c4080e7          	jalr	-1852(ra) # 80000abe <acquire>
    if(p->pid == pid){
    80002202:	58dc                	lw	a5,52(s1)
    80002204:	01278d63          	beq	a5,s2,8000221e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002208:	8526                	mv	a0,s1
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	91c080e7          	jalr	-1764(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002212:	16048493          	addi	s1,s1,352
    80002216:	ff3491e3          	bne	s1,s3,800021f8 <kill+0x20>
  }
  return -1;
    8000221a:	557d                	li	a0,-1
    8000221c:	a821                	j	80002234 <kill+0x5c>
      p->killed = 1;
    8000221e:	4785                	li	a5,1
    80002220:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002222:	4c98                	lw	a4,24(s1)
    80002224:	00f70f63          	beq	a4,a5,80002242 <kill+0x6a>
      release(&p->lock);
    80002228:	8526                	mv	a0,s1
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	8fc080e7          	jalr	-1796(ra) # 80000b26 <release>
      return 0;
    80002232:	4501                	li	a0,0
}
    80002234:	70a2                	ld	ra,40(sp)
    80002236:	7402                	ld	s0,32(sp)
    80002238:	64e2                	ld	s1,24(sp)
    8000223a:	6942                	ld	s2,16(sp)
    8000223c:	69a2                	ld	s3,8(sp)
    8000223e:	6145                	addi	sp,sp,48
    80002240:	8082                	ret
        p->state = RUNNABLE;
    80002242:	4789                	li	a5,2
    80002244:	cc9c                	sw	a5,24(s1)
    80002246:	b7cd                	j	80002228 <kill+0x50>

0000000080002248 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002248:	7179                	addi	sp,sp,-48
    8000224a:	f406                	sd	ra,40(sp)
    8000224c:	f022                	sd	s0,32(sp)
    8000224e:	ec26                	sd	s1,24(sp)
    80002250:	e84a                	sd	s2,16(sp)
    80002252:	e44e                	sd	s3,8(sp)
    80002254:	e052                	sd	s4,0(sp)
    80002256:	1800                	addi	s0,sp,48
    80002258:	84aa                	mv	s1,a0
    8000225a:	892e                	mv	s2,a1
    8000225c:	89b2                	mv	s3,a2
    8000225e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002260:	fffff097          	auipc	ra,0xfffff
    80002264:	5be080e7          	jalr	1470(ra) # 8000181e <myproc>
  if(user_dst){
    80002268:	c08d                	beqz	s1,8000228a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000226a:	86d2                	mv	a3,s4
    8000226c:	864e                	mv	a2,s3
    8000226e:	85ca                	mv	a1,s2
    80002270:	6528                	ld	a0,72(a0)
    80002272:	fffff097          	auipc	ra,0xfffff
    80002276:	2d0080e7          	jalr	720(ra) # 80001542 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000227a:	70a2                	ld	ra,40(sp)
    8000227c:	7402                	ld	s0,32(sp)
    8000227e:	64e2                	ld	s1,24(sp)
    80002280:	6942                	ld	s2,16(sp)
    80002282:	69a2                	ld	s3,8(sp)
    80002284:	6a02                	ld	s4,0(sp)
    80002286:	6145                	addi	sp,sp,48
    80002288:	8082                	ret
    memmove((char *)dst, src, len);
    8000228a:	000a061b          	sext.w	a2,s4
    8000228e:	85ce                	mv	a1,s3
    80002290:	854a                	mv	a0,s2
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	94c080e7          	jalr	-1716(ra) # 80000bde <memmove>
    return 0;
    8000229a:	8526                	mv	a0,s1
    8000229c:	bff9                	j	8000227a <either_copyout+0x32>

000000008000229e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000229e:	7179                	addi	sp,sp,-48
    800022a0:	f406                	sd	ra,40(sp)
    800022a2:	f022                	sd	s0,32(sp)
    800022a4:	ec26                	sd	s1,24(sp)
    800022a6:	e84a                	sd	s2,16(sp)
    800022a8:	e44e                	sd	s3,8(sp)
    800022aa:	e052                	sd	s4,0(sp)
    800022ac:	1800                	addi	s0,sp,48
    800022ae:	892a                	mv	s2,a0
    800022b0:	84ae                	mv	s1,a1
    800022b2:	89b2                	mv	s3,a2
    800022b4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800022b6:	fffff097          	auipc	ra,0xfffff
    800022ba:	568080e7          	jalr	1384(ra) # 8000181e <myproc>
  if(user_src){
    800022be:	c08d                	beqz	s1,800022e0 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800022c0:	86d2                	mv	a3,s4
    800022c2:	864e                	mv	a2,s3
    800022c4:	85ca                	mv	a1,s2
    800022c6:	6528                	ld	a0,72(a0)
    800022c8:	fffff097          	auipc	ra,0xfffff
    800022cc:	30c080e7          	jalr	780(ra) # 800015d4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800022d0:	70a2                	ld	ra,40(sp)
    800022d2:	7402                	ld	s0,32(sp)
    800022d4:	64e2                	ld	s1,24(sp)
    800022d6:	6942                	ld	s2,16(sp)
    800022d8:	69a2                	ld	s3,8(sp)
    800022da:	6a02                	ld	s4,0(sp)
    800022dc:	6145                	addi	sp,sp,48
    800022de:	8082                	ret
    memmove(dst, (char*)src, len);
    800022e0:	000a061b          	sext.w	a2,s4
    800022e4:	85ce                	mv	a1,s3
    800022e6:	854a                	mv	a0,s2
    800022e8:	fffff097          	auipc	ra,0xfffff
    800022ec:	8f6080e7          	jalr	-1802(ra) # 80000bde <memmove>
    return 0;
    800022f0:	8526                	mv	a0,s1
    800022f2:	bff9                	j	800022d0 <either_copyin+0x32>

00000000800022f4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800022f4:	715d                	addi	sp,sp,-80
    800022f6:	e486                	sd	ra,72(sp)
    800022f8:	e0a2                	sd	s0,64(sp)
    800022fa:	fc26                	sd	s1,56(sp)
    800022fc:	f84a                	sd	s2,48(sp)
    800022fe:	f44e                	sd	s3,40(sp)
    80002300:	f052                	sd	s4,32(sp)
    80002302:	ec56                	sd	s5,24(sp)
    80002304:	e85a                	sd	s6,16(sp)
    80002306:	e45e                	sd	s7,8(sp)
    80002308:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000230a:	00005517          	auipc	a0,0x5
    8000230e:	ea650513          	addi	a0,a0,-346 # 800071b0 <userret+0x120>
    80002312:	ffffe097          	auipc	ra,0xffffe
    80002316:	280080e7          	jalr	640(ra) # 80000592 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000231a:	00010497          	auipc	s1,0x10
    8000231e:	b3648493          	addi	s1,s1,-1226 # 80011e50 <proc+0x150>
    80002322:	00015917          	auipc	s2,0x15
    80002326:	32e90913          	addi	s2,s2,814 # 80017650 <bcache+0x138>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000232a:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    8000232c:	00005997          	auipc	s3,0x5
    80002330:	03498993          	addi	s3,s3,52 # 80007360 <userret+0x2d0>
    printf("%d %s %s", p->pid, state, p->name);
    80002334:	00005a97          	auipc	s5,0x5
    80002338:	034a8a93          	addi	s5,s5,52 # 80007368 <userret+0x2d8>
    printf("\n");
    8000233c:	00005a17          	auipc	s4,0x5
    80002340:	e74a0a13          	addi	s4,s4,-396 # 800071b0 <userret+0x120>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002344:	00005b97          	auipc	s7,0x5
    80002348:	584b8b93          	addi	s7,s7,1412 # 800078c8 <states.0>
    8000234c:	a00d                	j	8000236e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000234e:	ee46a583          	lw	a1,-284(a3)
    80002352:	8556                	mv	a0,s5
    80002354:	ffffe097          	auipc	ra,0xffffe
    80002358:	23e080e7          	jalr	574(ra) # 80000592 <printf>
    printf("\n");
    8000235c:	8552                	mv	a0,s4
    8000235e:	ffffe097          	auipc	ra,0xffffe
    80002362:	234080e7          	jalr	564(ra) # 80000592 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002366:	16048493          	addi	s1,s1,352
    8000236a:	03248263          	beq	s1,s2,8000238e <procdump+0x9a>
    if(p->state == UNUSED)
    8000236e:	86a6                	mv	a3,s1
    80002370:	ec84a783          	lw	a5,-312(s1)
    80002374:	dbed                	beqz	a5,80002366 <procdump+0x72>
      state = "???";
    80002376:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002378:	fcfb6be3          	bltu	s6,a5,8000234e <procdump+0x5a>
    8000237c:	02079713          	slli	a4,a5,0x20
    80002380:	01d75793          	srli	a5,a4,0x1d
    80002384:	97de                	add	a5,a5,s7
    80002386:	6390                	ld	a2,0(a5)
    80002388:	f279                	bnez	a2,8000234e <procdump+0x5a>
      state = "???";
    8000238a:	864e                	mv	a2,s3
    8000238c:	b7c9                	j	8000234e <procdump+0x5a>
  }
}
    8000238e:	60a6                	ld	ra,72(sp)
    80002390:	6406                	ld	s0,64(sp)
    80002392:	74e2                	ld	s1,56(sp)
    80002394:	7942                	ld	s2,48(sp)
    80002396:	79a2                	ld	s3,40(sp)
    80002398:	7a02                	ld	s4,32(sp)
    8000239a:	6ae2                	ld	s5,24(sp)
    8000239c:	6b42                	ld	s6,16(sp)
    8000239e:	6ba2                	ld	s7,8(sp)
    800023a0:	6161                	addi	sp,sp,80
    800023a2:	8082                	ret

00000000800023a4 <swtch>:
    800023a4:	00153023          	sd	ra,0(a0)
    800023a8:	00253423          	sd	sp,8(a0)
    800023ac:	e900                	sd	s0,16(a0)
    800023ae:	ed04                	sd	s1,24(a0)
    800023b0:	03253023          	sd	s2,32(a0)
    800023b4:	03353423          	sd	s3,40(a0)
    800023b8:	03453823          	sd	s4,48(a0)
    800023bc:	03553c23          	sd	s5,56(a0)
    800023c0:	05653023          	sd	s6,64(a0)
    800023c4:	05753423          	sd	s7,72(a0)
    800023c8:	05853823          	sd	s8,80(a0)
    800023cc:	05953c23          	sd	s9,88(a0)
    800023d0:	07a53023          	sd	s10,96(a0)
    800023d4:	07b53423          	sd	s11,104(a0)
    800023d8:	0005b083          	ld	ra,0(a1)
    800023dc:	0085b103          	ld	sp,8(a1)
    800023e0:	6980                	ld	s0,16(a1)
    800023e2:	6d84                	ld	s1,24(a1)
    800023e4:	0205b903          	ld	s2,32(a1)
    800023e8:	0285b983          	ld	s3,40(a1)
    800023ec:	0305ba03          	ld	s4,48(a1)
    800023f0:	0385ba83          	ld	s5,56(a1)
    800023f4:	0405bb03          	ld	s6,64(a1)
    800023f8:	0485bb83          	ld	s7,72(a1)
    800023fc:	0505bc03          	ld	s8,80(a1)
    80002400:	0585bc83          	ld	s9,88(a1)
    80002404:	0605bd03          	ld	s10,96(a1)
    80002408:	0685bd83          	ld	s11,104(a1)
    8000240c:	8082                	ret

000000008000240e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000240e:	1141                	addi	sp,sp,-16
    80002410:	e406                	sd	ra,8(sp)
    80002412:	e022                	sd	s0,0(sp)
    80002414:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002416:	00005597          	auipc	a1,0x5
    8000241a:	f8a58593          	addi	a1,a1,-118 # 800073a0 <userret+0x310>
    8000241e:	00015517          	auipc	a0,0x15
    80002422:	0e250513          	addi	a0,a0,226 # 80017500 <tickslock>
    80002426:	ffffe097          	auipc	ra,0xffffe
    8000242a:	58a080e7          	jalr	1418(ra) # 800009b0 <initlock>
}
    8000242e:	60a2                	ld	ra,8(sp)
    80002430:	6402                	ld	s0,0(sp)
    80002432:	0141                	addi	sp,sp,16
    80002434:	8082                	ret

0000000080002436 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002436:	1141                	addi	sp,sp,-16
    80002438:	e422                	sd	s0,8(sp)
    8000243a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000243c:	00003797          	auipc	a5,0x3
    80002440:	72478793          	addi	a5,a5,1828 # 80005b60 <kernelvec>
    80002444:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002448:	6422                	ld	s0,8(sp)
    8000244a:	0141                	addi	sp,sp,16
    8000244c:	8082                	ret

000000008000244e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000244e:	1141                	addi	sp,sp,-16
    80002450:	e406                	sd	ra,8(sp)
    80002452:	e022                	sd	s0,0(sp)
    80002454:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002456:	fffff097          	auipc	ra,0xfffff
    8000245a:	3c8080e7          	jalr	968(ra) # 8000181e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000245e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002462:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002464:	10079073          	csrw	sstatus,a5
  // turn off interrupts, since we're switching
  // now from kerneltrap() to usertrap().
  intr_off();

  // send interrupts and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002468:	00005617          	auipc	a2,0x5
    8000246c:	b9860613          	addi	a2,a2,-1128 # 80007000 <trampoline>
    80002470:	00005697          	auipc	a3,0x5
    80002474:	b9068693          	addi	a3,a3,-1136 # 80007000 <trampoline>
    80002478:	8e91                	sub	a3,a3,a2
    8000247a:	040007b7          	lui	a5,0x4000
    8000247e:	17fd                	addi	a5,a5,-1
    80002480:	07b2                	slli	a5,a5,0xc
    80002482:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002484:	10569073          	csrw	stvec,a3

  // set up values that uservec will need when
  // the process next re-enters the kernel.
  p->tf->kernel_satp = r_satp();         // kernel page table
    80002488:	6938                	ld	a4,80(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000248a:	180026f3          	csrr	a3,satp
    8000248e:	e314                	sd	a3,0(a4)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002490:	6938                	ld	a4,80(a0)
    80002492:	7d14                	ld	a3,56(a0)
    80002494:	6585                	lui	a1,0x1
    80002496:	96ae                	add	a3,a3,a1
    80002498:	e714                	sd	a3,8(a4)
  p->tf->kernel_trap = (uint64)usertrap;
    8000249a:	6938                	ld	a4,80(a0)
    8000249c:	00000697          	auipc	a3,0x0
    800024a0:	12868693          	addi	a3,a3,296 # 800025c4 <usertrap>
    800024a4:	eb14                	sd	a3,16(a4)
  p->tf->kernel_hartid = r_tp();         // hartid for cpuid()
    800024a6:	6938                	ld	a4,80(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800024a8:	8692                	mv	a3,tp
    800024aa:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024ac:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024b0:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024b4:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024b8:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->tf->epc);
    800024bc:	6938                	ld	a4,80(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800024be:	6f18                	ld	a4,24(a4)
    800024c0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800024c4:	652c                	ld	a1,72(a0)
    800024c6:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800024c8:	00005717          	auipc	a4,0x5
    800024cc:	bc870713          	addi	a4,a4,-1080 # 80007090 <userret>
    800024d0:	8f11                	sub	a4,a4,a2
    800024d2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800024d4:	577d                	li	a4,-1
    800024d6:	177e                	slli	a4,a4,0x3f
    800024d8:	8dd9                	or	a1,a1,a4
    800024da:	02000537          	lui	a0,0x2000
    800024de:	157d                	addi	a0,a0,-1
    800024e0:	0536                	slli	a0,a0,0xd
    800024e2:	9782                	jalr	a5
}
    800024e4:	60a2                	ld	ra,8(sp)
    800024e6:	6402                	ld	s0,0(sp)
    800024e8:	0141                	addi	sp,sp,16
    800024ea:	8082                	ret

00000000800024ec <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024ec:	1101                	addi	sp,sp,-32
    800024ee:	ec06                	sd	ra,24(sp)
    800024f0:	e822                	sd	s0,16(sp)
    800024f2:	e426                	sd	s1,8(sp)
    800024f4:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800024f6:	00015497          	auipc	s1,0x15
    800024fa:	00a48493          	addi	s1,s1,10 # 80017500 <tickslock>
    800024fe:	8526                	mv	a0,s1
    80002500:	ffffe097          	auipc	ra,0xffffe
    80002504:	5be080e7          	jalr	1470(ra) # 80000abe <acquire>
  ticks++;
    80002508:	00027517          	auipc	a0,0x27
    8000250c:	b2050513          	addi	a0,a0,-1248 # 80029028 <ticks>
    80002510:	411c                	lw	a5,0(a0)
    80002512:	2785                	addiw	a5,a5,1
    80002514:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002516:	00000097          	auipc	ra,0x0
    8000251a:	c58080e7          	jalr	-936(ra) # 8000216e <wakeup>
  release(&tickslock);
    8000251e:	8526                	mv	a0,s1
    80002520:	ffffe097          	auipc	ra,0xffffe
    80002524:	606080e7          	jalr	1542(ra) # 80000b26 <release>
}
    80002528:	60e2                	ld	ra,24(sp)
    8000252a:	6442                	ld	s0,16(sp)
    8000252c:	64a2                	ld	s1,8(sp)
    8000252e:	6105                	addi	sp,sp,32
    80002530:	8082                	ret

0000000080002532 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002532:	1101                	addi	sp,sp,-32
    80002534:	ec06                	sd	ra,24(sp)
    80002536:	e822                	sd	s0,16(sp)
    80002538:	e426                	sd	s1,8(sp)
    8000253a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000253c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002540:	00074d63          	bltz	a4,8000255a <devintr+0x28>
      virtio_disk_intr(irq - VIRTIO0_IRQ);
    }

    plic_complete(irq);
    return 1;
  } else if(scause == 0x8000000000000001L){
    80002544:	57fd                	li	a5,-1
    80002546:	17fe                	slli	a5,a5,0x3f
    80002548:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    8000254a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000254c:	04f70b63          	beq	a4,a5,800025a2 <devintr+0x70>
  }
}
    80002550:	60e2                	ld	ra,24(sp)
    80002552:	6442                	ld	s0,16(sp)
    80002554:	64a2                	ld	s1,8(sp)
    80002556:	6105                	addi	sp,sp,32
    80002558:	8082                	ret
     (scause & 0xff) == 9){
    8000255a:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    8000255e:	46a5                	li	a3,9
    80002560:	fed792e3          	bne	a5,a3,80002544 <devintr+0x12>
    int irq = plic_claim();
    80002564:	00003097          	auipc	ra,0x3
    80002568:	716080e7          	jalr	1814(ra) # 80005c7a <plic_claim>
    8000256c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000256e:	47a9                	li	a5,10
    80002570:	00f50e63          	beq	a0,a5,8000258c <devintr+0x5a>
    } else if(irq == VIRTIO0_IRQ || irq == VIRTIO1_IRQ ){
    80002574:	fff5079b          	addiw	a5,a0,-1
    80002578:	4705                	li	a4,1
    8000257a:	00f77e63          	bgeu	a4,a5,80002596 <devintr+0x64>
    plic_complete(irq);
    8000257e:	8526                	mv	a0,s1
    80002580:	00003097          	auipc	ra,0x3
    80002584:	71e080e7          	jalr	1822(ra) # 80005c9e <plic_complete>
    return 1;
    80002588:	4505                	li	a0,1
    8000258a:	b7d9                	j	80002550 <devintr+0x1e>
      uartintr();
    8000258c:	ffffe097          	auipc	ra,0xffffe
    80002590:	29c080e7          	jalr	668(ra) # 80000828 <uartintr>
    80002594:	b7ed                	j	8000257e <devintr+0x4c>
      virtio_disk_intr(irq - VIRTIO0_IRQ);
    80002596:	853e                	mv	a0,a5
    80002598:	00004097          	auipc	ra,0x4
    8000259c:	cb0080e7          	jalr	-848(ra) # 80006248 <virtio_disk_intr>
    800025a0:	bff9                	j	8000257e <devintr+0x4c>
    if(cpuid() == 0){
    800025a2:	fffff097          	auipc	ra,0xfffff
    800025a6:	250080e7          	jalr	592(ra) # 800017f2 <cpuid>
    800025aa:	c901                	beqz	a0,800025ba <devintr+0x88>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800025ac:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800025b0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800025b2:	14479073          	csrw	sip,a5
    return 2;
    800025b6:	4509                	li	a0,2
    800025b8:	bf61                	j	80002550 <devintr+0x1e>
      clockintr();
    800025ba:	00000097          	auipc	ra,0x0
    800025be:	f32080e7          	jalr	-206(ra) # 800024ec <clockintr>
    800025c2:	b7ed                	j	800025ac <devintr+0x7a>

00000000800025c4 <usertrap>:
{
    800025c4:	1101                	addi	sp,sp,-32
    800025c6:	ec06                	sd	ra,24(sp)
    800025c8:	e822                	sd	s0,16(sp)
    800025ca:	e426                	sd	s1,8(sp)
    800025cc:	e04a                	sd	s2,0(sp)
    800025ce:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025d0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800025d4:	1007f793          	andi	a5,a5,256
    800025d8:	e7bd                	bnez	a5,80002646 <usertrap+0x82>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025da:	00003797          	auipc	a5,0x3
    800025de:	58678793          	addi	a5,a5,1414 # 80005b60 <kernelvec>
    800025e2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800025e6:	fffff097          	auipc	ra,0xfffff
    800025ea:	238080e7          	jalr	568(ra) # 8000181e <myproc>
    800025ee:	84aa                	mv	s1,a0
  p->tf->epc = r_sepc();
    800025f0:	693c                	ld	a5,80(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025f2:	14102773          	csrr	a4,sepc
    800025f6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025f8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800025fc:	47a1                	li	a5,8
    800025fe:	06f71163          	bne	a4,a5,80002660 <usertrap+0x9c>
    if(p->killed)
    80002602:	591c                	lw	a5,48(a0)
    80002604:	eba9                	bnez	a5,80002656 <usertrap+0x92>
    p->tf->epc += 4;
    80002606:	68b8                	ld	a4,80(s1)
    80002608:	6f1c                	ld	a5,24(a4)
    8000260a:	0791                	addi	a5,a5,4
    8000260c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000260e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80002612:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80002616:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000261a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000261e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002622:	10079073          	csrw	sstatus,a5
    syscall();
    80002626:	00000097          	auipc	ra,0x0
    8000262a:	2dc080e7          	jalr	732(ra) # 80002902 <syscall>
  if(p->killed)
    8000262e:	589c                	lw	a5,48(s1)
    80002630:	e7d1                	bnez	a5,800026bc <usertrap+0xf8>
  usertrapret();
    80002632:	00000097          	auipc	ra,0x0
    80002636:	e1c080e7          	jalr	-484(ra) # 8000244e <usertrapret>
}
    8000263a:	60e2                	ld	ra,24(sp)
    8000263c:	6442                	ld	s0,16(sp)
    8000263e:	64a2                	ld	s1,8(sp)
    80002640:	6902                	ld	s2,0(sp)
    80002642:	6105                	addi	sp,sp,32
    80002644:	8082                	ret
    panic("usertrap: not from user mode");
    80002646:	00005517          	auipc	a0,0x5
    8000264a:	d6250513          	addi	a0,a0,-670 # 800073a8 <userret+0x318>
    8000264e:	ffffe097          	auipc	ra,0xffffe
    80002652:	efa080e7          	jalr	-262(ra) # 80000548 <panic>
      exit();
    80002656:	00000097          	auipc	ra,0x0
    8000265a:	8b8080e7          	jalr	-1864(ra) # 80001f0e <exit>
    8000265e:	b765                	j	80002606 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002660:	00000097          	auipc	ra,0x0
    80002664:	ed2080e7          	jalr	-302(ra) # 80002532 <devintr>
    80002668:	892a                	mv	s2,a0
    8000266a:	c501                	beqz	a0,80002672 <usertrap+0xae>
  if(p->killed)
    8000266c:	589c                	lw	a5,48(s1)
    8000266e:	cf9d                	beqz	a5,800026ac <usertrap+0xe8>
    80002670:	a815                	j	800026a4 <usertrap+0xe0>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002672:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002676:	58d0                	lw	a2,52(s1)
    80002678:	00005517          	auipc	a0,0x5
    8000267c:	d5050513          	addi	a0,a0,-688 # 800073c8 <userret+0x338>
    80002680:	ffffe097          	auipc	ra,0xffffe
    80002684:	f12080e7          	jalr	-238(ra) # 80000592 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002688:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000268c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002690:	00005517          	auipc	a0,0x5
    80002694:	d6850513          	addi	a0,a0,-664 # 800073f8 <userret+0x368>
    80002698:	ffffe097          	auipc	ra,0xffffe
    8000269c:	efa080e7          	jalr	-262(ra) # 80000592 <printf>
    p->killed = 1;
    800026a0:	4785                	li	a5,1
    800026a2:	d89c                	sw	a5,48(s1)
    exit();
    800026a4:	00000097          	auipc	ra,0x0
    800026a8:	86a080e7          	jalr	-1942(ra) # 80001f0e <exit>
  if(which_dev == 2)
    800026ac:	4789                	li	a5,2
    800026ae:	f8f912e3          	bne	s2,a5,80002632 <usertrap+0x6e>
    yield();
    800026b2:	00000097          	auipc	ra,0x0
    800026b6:	93a080e7          	jalr	-1734(ra) # 80001fec <yield>
    800026ba:	bfa5                	j	80002632 <usertrap+0x6e>
  int which_dev = 0;
    800026bc:	4901                	li	s2,0
    800026be:	b7dd                	j	800026a4 <usertrap+0xe0>

00000000800026c0 <kerneltrap>:
{
    800026c0:	7179                	addi	sp,sp,-48
    800026c2:	f406                	sd	ra,40(sp)
    800026c4:	f022                	sd	s0,32(sp)
    800026c6:	ec26                	sd	s1,24(sp)
    800026c8:	e84a                	sd	s2,16(sp)
    800026ca:	e44e                	sd	s3,8(sp)
    800026cc:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026ce:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026d2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026d6:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800026da:	1004f793          	andi	a5,s1,256
    800026de:	cb85                	beqz	a5,8000270e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026e0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026e4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800026e6:	ef85                	bnez	a5,8000271e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800026e8:	00000097          	auipc	ra,0x0
    800026ec:	e4a080e7          	jalr	-438(ra) # 80002532 <devintr>
    800026f0:	cd1d                	beqz	a0,8000272e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800026f2:	4789                	li	a5,2
    800026f4:	06f50a63          	beq	a0,a5,80002768 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026f8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026fc:	10049073          	csrw	sstatus,s1
}
    80002700:	70a2                	ld	ra,40(sp)
    80002702:	7402                	ld	s0,32(sp)
    80002704:	64e2                	ld	s1,24(sp)
    80002706:	6942                	ld	s2,16(sp)
    80002708:	69a2                	ld	s3,8(sp)
    8000270a:	6145                	addi	sp,sp,48
    8000270c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000270e:	00005517          	auipc	a0,0x5
    80002712:	d0a50513          	addi	a0,a0,-758 # 80007418 <userret+0x388>
    80002716:	ffffe097          	auipc	ra,0xffffe
    8000271a:	e32080e7          	jalr	-462(ra) # 80000548 <panic>
    panic("kerneltrap: interrupts enabled");
    8000271e:	00005517          	auipc	a0,0x5
    80002722:	d2250513          	addi	a0,a0,-734 # 80007440 <userret+0x3b0>
    80002726:	ffffe097          	auipc	ra,0xffffe
    8000272a:	e22080e7          	jalr	-478(ra) # 80000548 <panic>
    printf("scause %p\n", scause);
    8000272e:	85ce                	mv	a1,s3
    80002730:	00005517          	auipc	a0,0x5
    80002734:	d3050513          	addi	a0,a0,-720 # 80007460 <userret+0x3d0>
    80002738:	ffffe097          	auipc	ra,0xffffe
    8000273c:	e5a080e7          	jalr	-422(ra) # 80000592 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002740:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002744:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002748:	00005517          	auipc	a0,0x5
    8000274c:	d2850513          	addi	a0,a0,-728 # 80007470 <userret+0x3e0>
    80002750:	ffffe097          	auipc	ra,0xffffe
    80002754:	e42080e7          	jalr	-446(ra) # 80000592 <printf>
    panic("kerneltrap");
    80002758:	00005517          	auipc	a0,0x5
    8000275c:	d3050513          	addi	a0,a0,-720 # 80007488 <userret+0x3f8>
    80002760:	ffffe097          	auipc	ra,0xffffe
    80002764:	de8080e7          	jalr	-536(ra) # 80000548 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002768:	fffff097          	auipc	ra,0xfffff
    8000276c:	0b6080e7          	jalr	182(ra) # 8000181e <myproc>
    80002770:	d541                	beqz	a0,800026f8 <kerneltrap+0x38>
    80002772:	fffff097          	auipc	ra,0xfffff
    80002776:	0ac080e7          	jalr	172(ra) # 8000181e <myproc>
    8000277a:	4d18                	lw	a4,24(a0)
    8000277c:	478d                	li	a5,3
    8000277e:	f6f71de3          	bne	a4,a5,800026f8 <kerneltrap+0x38>
    yield();
    80002782:	00000097          	auipc	ra,0x0
    80002786:	86a080e7          	jalr	-1942(ra) # 80001fec <yield>
    8000278a:	b7bd                	j	800026f8 <kerneltrap+0x38>

000000008000278c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000278c:	1101                	addi	sp,sp,-32
    8000278e:	ec06                	sd	ra,24(sp)
    80002790:	e822                	sd	s0,16(sp)
    80002792:	e426                	sd	s1,8(sp)
    80002794:	1000                	addi	s0,sp,32
    80002796:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002798:	fffff097          	auipc	ra,0xfffff
    8000279c:	086080e7          	jalr	134(ra) # 8000181e <myproc>
  switch (n) {
    800027a0:	4795                	li	a5,5
    800027a2:	0497e163          	bltu	a5,s1,800027e4 <argraw+0x58>
    800027a6:	048a                	slli	s1,s1,0x2
    800027a8:	00005717          	auipc	a4,0x5
    800027ac:	14870713          	addi	a4,a4,328 # 800078f0 <states.0+0x28>
    800027b0:	94ba                	add	s1,s1,a4
    800027b2:	409c                	lw	a5,0(s1)
    800027b4:	97ba                	add	a5,a5,a4
    800027b6:	8782                	jr	a5
  case 0:
    return p->tf->a0;
    800027b8:	693c                	ld	a5,80(a0)
    800027ba:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
    800027bc:	60e2                	ld	ra,24(sp)
    800027be:	6442                	ld	s0,16(sp)
    800027c0:	64a2                	ld	s1,8(sp)
    800027c2:	6105                	addi	sp,sp,32
    800027c4:	8082                	ret
    return p->tf->a1;
    800027c6:	693c                	ld	a5,80(a0)
    800027c8:	7fa8                	ld	a0,120(a5)
    800027ca:	bfcd                	j	800027bc <argraw+0x30>
    return p->tf->a2;
    800027cc:	693c                	ld	a5,80(a0)
    800027ce:	63c8                	ld	a0,128(a5)
    800027d0:	b7f5                	j	800027bc <argraw+0x30>
    return p->tf->a3;
    800027d2:	693c                	ld	a5,80(a0)
    800027d4:	67c8                	ld	a0,136(a5)
    800027d6:	b7dd                	j	800027bc <argraw+0x30>
    return p->tf->a4;
    800027d8:	693c                	ld	a5,80(a0)
    800027da:	6bc8                	ld	a0,144(a5)
    800027dc:	b7c5                	j	800027bc <argraw+0x30>
    return p->tf->a5;
    800027de:	693c                	ld	a5,80(a0)
    800027e0:	6fc8                	ld	a0,152(a5)
    800027e2:	bfe9                	j	800027bc <argraw+0x30>
  panic("argraw");
    800027e4:	00005517          	auipc	a0,0x5
    800027e8:	cb450513          	addi	a0,a0,-844 # 80007498 <userret+0x408>
    800027ec:	ffffe097          	auipc	ra,0xffffe
    800027f0:	d5c080e7          	jalr	-676(ra) # 80000548 <panic>

00000000800027f4 <fetchaddr>:
{
    800027f4:	1101                	addi	sp,sp,-32
    800027f6:	ec06                	sd	ra,24(sp)
    800027f8:	e822                	sd	s0,16(sp)
    800027fa:	e426                	sd	s1,8(sp)
    800027fc:	e04a                	sd	s2,0(sp)
    800027fe:	1000                	addi	s0,sp,32
    80002800:	84aa                	mv	s1,a0
    80002802:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002804:	fffff097          	auipc	ra,0xfffff
    80002808:	01a080e7          	jalr	26(ra) # 8000181e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000280c:	613c                	ld	a5,64(a0)
    8000280e:	02f4f863          	bgeu	s1,a5,8000283e <fetchaddr+0x4a>
    80002812:	00848713          	addi	a4,s1,8
    80002816:	02e7e663          	bltu	a5,a4,80002842 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000281a:	46a1                	li	a3,8
    8000281c:	8626                	mv	a2,s1
    8000281e:	85ca                	mv	a1,s2
    80002820:	6528                	ld	a0,72(a0)
    80002822:	fffff097          	auipc	ra,0xfffff
    80002826:	db2080e7          	jalr	-590(ra) # 800015d4 <copyin>
    8000282a:	00a03533          	snez	a0,a0
    8000282e:	40a00533          	neg	a0,a0
}
    80002832:	60e2                	ld	ra,24(sp)
    80002834:	6442                	ld	s0,16(sp)
    80002836:	64a2                	ld	s1,8(sp)
    80002838:	6902                	ld	s2,0(sp)
    8000283a:	6105                	addi	sp,sp,32
    8000283c:	8082                	ret
    return -1;
    8000283e:	557d                	li	a0,-1
    80002840:	bfcd                	j	80002832 <fetchaddr+0x3e>
    80002842:	557d                	li	a0,-1
    80002844:	b7fd                	j	80002832 <fetchaddr+0x3e>

0000000080002846 <fetchstr>:
{
    80002846:	7179                	addi	sp,sp,-48
    80002848:	f406                	sd	ra,40(sp)
    8000284a:	f022                	sd	s0,32(sp)
    8000284c:	ec26                	sd	s1,24(sp)
    8000284e:	e84a                	sd	s2,16(sp)
    80002850:	e44e                	sd	s3,8(sp)
    80002852:	1800                	addi	s0,sp,48
    80002854:	892a                	mv	s2,a0
    80002856:	84ae                	mv	s1,a1
    80002858:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000285a:	fffff097          	auipc	ra,0xfffff
    8000285e:	fc4080e7          	jalr	-60(ra) # 8000181e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002862:	86ce                	mv	a3,s3
    80002864:	864a                	mv	a2,s2
    80002866:	85a6                	mv	a1,s1
    80002868:	6528                	ld	a0,72(a0)
    8000286a:	fffff097          	auipc	ra,0xfffff
    8000286e:	dfe080e7          	jalr	-514(ra) # 80001668 <copyinstr>
  if(err < 0)
    80002872:	00054763          	bltz	a0,80002880 <fetchstr+0x3a>
  return strlen(buf);
    80002876:	8526                	mv	a0,s1
    80002878:	ffffe097          	auipc	ra,0xffffe
    8000287c:	48e080e7          	jalr	1166(ra) # 80000d06 <strlen>
}
    80002880:	70a2                	ld	ra,40(sp)
    80002882:	7402                	ld	s0,32(sp)
    80002884:	64e2                	ld	s1,24(sp)
    80002886:	6942                	ld	s2,16(sp)
    80002888:	69a2                	ld	s3,8(sp)
    8000288a:	6145                	addi	sp,sp,48
    8000288c:	8082                	ret

000000008000288e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000288e:	1101                	addi	sp,sp,-32
    80002890:	ec06                	sd	ra,24(sp)
    80002892:	e822                	sd	s0,16(sp)
    80002894:	e426                	sd	s1,8(sp)
    80002896:	1000                	addi	s0,sp,32
    80002898:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	ef2080e7          	jalr	-270(ra) # 8000278c <argraw>
    800028a2:	c088                	sw	a0,0(s1)
  return 0;
}
    800028a4:	4501                	li	a0,0
    800028a6:	60e2                	ld	ra,24(sp)
    800028a8:	6442                	ld	s0,16(sp)
    800028aa:	64a2                	ld	s1,8(sp)
    800028ac:	6105                	addi	sp,sp,32
    800028ae:	8082                	ret

00000000800028b0 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800028b0:	1101                	addi	sp,sp,-32
    800028b2:	ec06                	sd	ra,24(sp)
    800028b4:	e822                	sd	s0,16(sp)
    800028b6:	e426                	sd	s1,8(sp)
    800028b8:	1000                	addi	s0,sp,32
    800028ba:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800028bc:	00000097          	auipc	ra,0x0
    800028c0:	ed0080e7          	jalr	-304(ra) # 8000278c <argraw>
    800028c4:	e088                	sd	a0,0(s1)
  return 0;
}
    800028c6:	4501                	li	a0,0
    800028c8:	60e2                	ld	ra,24(sp)
    800028ca:	6442                	ld	s0,16(sp)
    800028cc:	64a2                	ld	s1,8(sp)
    800028ce:	6105                	addi	sp,sp,32
    800028d0:	8082                	ret

00000000800028d2 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800028d2:	1101                	addi	sp,sp,-32
    800028d4:	ec06                	sd	ra,24(sp)
    800028d6:	e822                	sd	s0,16(sp)
    800028d8:	e426                	sd	s1,8(sp)
    800028da:	e04a                	sd	s2,0(sp)
    800028dc:	1000                	addi	s0,sp,32
    800028de:	84ae                	mv	s1,a1
    800028e0:	8932                	mv	s2,a2
  *ip = argraw(n);
    800028e2:	00000097          	auipc	ra,0x0
    800028e6:	eaa080e7          	jalr	-342(ra) # 8000278c <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800028ea:	864a                	mv	a2,s2
    800028ec:	85a6                	mv	a1,s1
    800028ee:	00000097          	auipc	ra,0x0
    800028f2:	f58080e7          	jalr	-168(ra) # 80002846 <fetchstr>
}
    800028f6:	60e2                	ld	ra,24(sp)
    800028f8:	6442                	ld	s0,16(sp)
    800028fa:	64a2                	ld	s1,8(sp)
    800028fc:	6902                	ld	s2,0(sp)
    800028fe:	6105                	addi	sp,sp,32
    80002900:	8082                	ret

0000000080002902 <syscall>:
[SYS_crash]   sys_crash,
};

void
syscall(void)
{
    80002902:	1101                	addi	sp,sp,-32
    80002904:	ec06                	sd	ra,24(sp)
    80002906:	e822                	sd	s0,16(sp)
    80002908:	e426                	sd	s1,8(sp)
    8000290a:	e04a                	sd	s2,0(sp)
    8000290c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000290e:	fffff097          	auipc	ra,0xfffff
    80002912:	f10080e7          	jalr	-240(ra) # 8000181e <myproc>
    80002916:	84aa                	mv	s1,a0

  num = p->tf->a7;
    80002918:	05053903          	ld	s2,80(a0)
    8000291c:	0a893783          	ld	a5,168(s2)
    80002920:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002924:	37fd                	addiw	a5,a5,-1
    80002926:	4759                	li	a4,22
    80002928:	00f76f63          	bltu	a4,a5,80002946 <syscall+0x44>
    8000292c:	00369713          	slli	a4,a3,0x3
    80002930:	00005797          	auipc	a5,0x5
    80002934:	fd878793          	addi	a5,a5,-40 # 80007908 <syscalls>
    80002938:	97ba                	add	a5,a5,a4
    8000293a:	639c                	ld	a5,0(a5)
    8000293c:	c789                	beqz	a5,80002946 <syscall+0x44>
    p->tf->a0 = syscalls[num]();
    8000293e:	9782                	jalr	a5
    80002940:	06a93823          	sd	a0,112(s2)
    80002944:	a839                	j	80002962 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002946:	15048613          	addi	a2,s1,336
    8000294a:	58cc                	lw	a1,52(s1)
    8000294c:	00005517          	auipc	a0,0x5
    80002950:	b5450513          	addi	a0,a0,-1196 # 800074a0 <userret+0x410>
    80002954:	ffffe097          	auipc	ra,0xffffe
    80002958:	c3e080e7          	jalr	-962(ra) # 80000592 <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
    8000295c:	68bc                	ld	a5,80(s1)
    8000295e:	577d                	li	a4,-1
    80002960:	fbb8                	sd	a4,112(a5)
  }
}
    80002962:	60e2                	ld	ra,24(sp)
    80002964:	6442                	ld	s0,16(sp)
    80002966:	64a2                	ld	s1,8(sp)
    80002968:	6902                	ld	s2,0(sp)
    8000296a:	6105                	addi	sp,sp,32
    8000296c:	8082                	ret

000000008000296e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000296e:	1141                	addi	sp,sp,-16
    80002970:	e406                	sd	ra,8(sp)
    80002972:	e022                	sd	s0,0(sp)
    80002974:	0800                	addi	s0,sp,16
  exit();
    80002976:	fffff097          	auipc	ra,0xfffff
    8000297a:	598080e7          	jalr	1432(ra) # 80001f0e <exit>
  return 0;  // not reached
}
    8000297e:	4501                	li	a0,0
    80002980:	60a2                	ld	ra,8(sp)
    80002982:	6402                	ld	s0,0(sp)
    80002984:	0141                	addi	sp,sp,16
    80002986:	8082                	ret

0000000080002988 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002988:	1141                	addi	sp,sp,-16
    8000298a:	e406                	sd	ra,8(sp)
    8000298c:	e022                	sd	s0,0(sp)
    8000298e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002990:	fffff097          	auipc	ra,0xfffff
    80002994:	e8e080e7          	jalr	-370(ra) # 8000181e <myproc>
}
    80002998:	5948                	lw	a0,52(a0)
    8000299a:	60a2                	ld	ra,8(sp)
    8000299c:	6402                	ld	s0,0(sp)
    8000299e:	0141                	addi	sp,sp,16
    800029a0:	8082                	ret

00000000800029a2 <sys_fork>:

uint64
sys_fork(void)
{
    800029a2:	1141                	addi	sp,sp,-16
    800029a4:	e406                	sd	ra,8(sp)
    800029a6:	e022                	sd	s0,0(sp)
    800029a8:	0800                	addi	s0,sp,16
  return fork();
    800029aa:	fffff097          	auipc	ra,0xfffff
    800029ae:	1de080e7          	jalr	478(ra) # 80001b88 <fork>
}
    800029b2:	60a2                	ld	ra,8(sp)
    800029b4:	6402                	ld	s0,0(sp)
    800029b6:	0141                	addi	sp,sp,16
    800029b8:	8082                	ret

00000000800029ba <sys_wait>:

uint64
sys_wait(void)
{
    800029ba:	1141                	addi	sp,sp,-16
    800029bc:	e406                	sd	ra,8(sp)
    800029be:	e022                	sd	s0,0(sp)
    800029c0:	0800                	addi	s0,sp,16
  return wait();
    800029c2:	fffff097          	auipc	ra,0xfffff
    800029c6:	6e4080e7          	jalr	1764(ra) # 800020a6 <wait>
}
    800029ca:	60a2                	ld	ra,8(sp)
    800029cc:	6402                	ld	s0,0(sp)
    800029ce:	0141                	addi	sp,sp,16
    800029d0:	8082                	ret

00000000800029d2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800029d2:	7179                	addi	sp,sp,-48
    800029d4:	f406                	sd	ra,40(sp)
    800029d6:	f022                	sd	s0,32(sp)
    800029d8:	ec26                	sd	s1,24(sp)
    800029da:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800029dc:	fdc40593          	addi	a1,s0,-36
    800029e0:	4501                	li	a0,0
    800029e2:	00000097          	auipc	ra,0x0
    800029e6:	eac080e7          	jalr	-340(ra) # 8000288e <argint>
    return -1;
    800029ea:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    800029ec:	00054f63          	bltz	a0,80002a0a <sys_sbrk+0x38>
  addr = myproc()->sz;
    800029f0:	fffff097          	auipc	ra,0xfffff
    800029f4:	e2e080e7          	jalr	-466(ra) # 8000181e <myproc>
    800029f8:	4124                	lw	s1,64(a0)
  if(growproc(n) < 0)
    800029fa:	fdc42503          	lw	a0,-36(s0)
    800029fe:	fffff097          	auipc	ra,0xfffff
    80002a02:	112080e7          	jalr	274(ra) # 80001b10 <growproc>
    80002a06:	00054863          	bltz	a0,80002a16 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002a0a:	8526                	mv	a0,s1
    80002a0c:	70a2                	ld	ra,40(sp)
    80002a0e:	7402                	ld	s0,32(sp)
    80002a10:	64e2                	ld	s1,24(sp)
    80002a12:	6145                	addi	sp,sp,48
    80002a14:	8082                	ret
    return -1;
    80002a16:	54fd                	li	s1,-1
    80002a18:	bfcd                	j	80002a0a <sys_sbrk+0x38>

0000000080002a1a <sys_sleep>:

uint64
sys_sleep(void)
{
    80002a1a:	7139                	addi	sp,sp,-64
    80002a1c:	fc06                	sd	ra,56(sp)
    80002a1e:	f822                	sd	s0,48(sp)
    80002a20:	f426                	sd	s1,40(sp)
    80002a22:	f04a                	sd	s2,32(sp)
    80002a24:	ec4e                	sd	s3,24(sp)
    80002a26:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002a28:	fcc40593          	addi	a1,s0,-52
    80002a2c:	4501                	li	a0,0
    80002a2e:	00000097          	auipc	ra,0x0
    80002a32:	e60080e7          	jalr	-416(ra) # 8000288e <argint>
    return -1;
    80002a36:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002a38:	06054563          	bltz	a0,80002aa2 <sys_sleep+0x88>
  acquire(&tickslock);
    80002a3c:	00015517          	auipc	a0,0x15
    80002a40:	ac450513          	addi	a0,a0,-1340 # 80017500 <tickslock>
    80002a44:	ffffe097          	auipc	ra,0xffffe
    80002a48:	07a080e7          	jalr	122(ra) # 80000abe <acquire>
  ticks0 = ticks;
    80002a4c:	00026917          	auipc	s2,0x26
    80002a50:	5dc92903          	lw	s2,1500(s2) # 80029028 <ticks>
  while(ticks - ticks0 < n){
    80002a54:	fcc42783          	lw	a5,-52(s0)
    80002a58:	cf85                	beqz	a5,80002a90 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002a5a:	00015997          	auipc	s3,0x15
    80002a5e:	aa698993          	addi	s3,s3,-1370 # 80017500 <tickslock>
    80002a62:	00026497          	auipc	s1,0x26
    80002a66:	5c648493          	addi	s1,s1,1478 # 80029028 <ticks>
    if(myproc()->killed){
    80002a6a:	fffff097          	auipc	ra,0xfffff
    80002a6e:	db4080e7          	jalr	-588(ra) # 8000181e <myproc>
    80002a72:	591c                	lw	a5,48(a0)
    80002a74:	ef9d                	bnez	a5,80002ab2 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002a76:	85ce                	mv	a1,s3
    80002a78:	8526                	mv	a0,s1
    80002a7a:	fffff097          	auipc	ra,0xfffff
    80002a7e:	5ae080e7          	jalr	1454(ra) # 80002028 <sleep>
  while(ticks - ticks0 < n){
    80002a82:	409c                	lw	a5,0(s1)
    80002a84:	412787bb          	subw	a5,a5,s2
    80002a88:	fcc42703          	lw	a4,-52(s0)
    80002a8c:	fce7efe3          	bltu	a5,a4,80002a6a <sys_sleep+0x50>
  }
  release(&tickslock);
    80002a90:	00015517          	auipc	a0,0x15
    80002a94:	a7050513          	addi	a0,a0,-1424 # 80017500 <tickslock>
    80002a98:	ffffe097          	auipc	ra,0xffffe
    80002a9c:	08e080e7          	jalr	142(ra) # 80000b26 <release>
  return 0;
    80002aa0:	4781                	li	a5,0
}
    80002aa2:	853e                	mv	a0,a5
    80002aa4:	70e2                	ld	ra,56(sp)
    80002aa6:	7442                	ld	s0,48(sp)
    80002aa8:	74a2                	ld	s1,40(sp)
    80002aaa:	7902                	ld	s2,32(sp)
    80002aac:	69e2                	ld	s3,24(sp)
    80002aae:	6121                	addi	sp,sp,64
    80002ab0:	8082                	ret
      release(&tickslock);
    80002ab2:	00015517          	auipc	a0,0x15
    80002ab6:	a4e50513          	addi	a0,a0,-1458 # 80017500 <tickslock>
    80002aba:	ffffe097          	auipc	ra,0xffffe
    80002abe:	06c080e7          	jalr	108(ra) # 80000b26 <release>
      return -1;
    80002ac2:	57fd                	li	a5,-1
    80002ac4:	bff9                	j	80002aa2 <sys_sleep+0x88>

0000000080002ac6 <sys_kill>:

uint64
sys_kill(void)
{
    80002ac6:	1101                	addi	sp,sp,-32
    80002ac8:	ec06                	sd	ra,24(sp)
    80002aca:	e822                	sd	s0,16(sp)
    80002acc:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002ace:	fec40593          	addi	a1,s0,-20
    80002ad2:	4501                	li	a0,0
    80002ad4:	00000097          	auipc	ra,0x0
    80002ad8:	dba080e7          	jalr	-582(ra) # 8000288e <argint>
    80002adc:	87aa                	mv	a5,a0
    return -1;
    80002ade:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002ae0:	0007c863          	bltz	a5,80002af0 <sys_kill+0x2a>
  return kill(pid);
    80002ae4:	fec42503          	lw	a0,-20(s0)
    80002ae8:	fffff097          	auipc	ra,0xfffff
    80002aec:	6f0080e7          	jalr	1776(ra) # 800021d8 <kill>
}
    80002af0:	60e2                	ld	ra,24(sp)
    80002af2:	6442                	ld	s0,16(sp)
    80002af4:	6105                	addi	sp,sp,32
    80002af6:	8082                	ret

0000000080002af8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002af8:	1101                	addi	sp,sp,-32
    80002afa:	ec06                	sd	ra,24(sp)
    80002afc:	e822                	sd	s0,16(sp)
    80002afe:	e426                	sd	s1,8(sp)
    80002b00:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002b02:	00015517          	auipc	a0,0x15
    80002b06:	9fe50513          	addi	a0,a0,-1538 # 80017500 <tickslock>
    80002b0a:	ffffe097          	auipc	ra,0xffffe
    80002b0e:	fb4080e7          	jalr	-76(ra) # 80000abe <acquire>
  xticks = ticks;
    80002b12:	00026497          	auipc	s1,0x26
    80002b16:	5164a483          	lw	s1,1302(s1) # 80029028 <ticks>
  release(&tickslock);
    80002b1a:	00015517          	auipc	a0,0x15
    80002b1e:	9e650513          	addi	a0,a0,-1562 # 80017500 <tickslock>
    80002b22:	ffffe097          	auipc	ra,0xffffe
    80002b26:	004080e7          	jalr	4(ra) # 80000b26 <release>
  return xticks;
}
    80002b2a:	02049513          	slli	a0,s1,0x20
    80002b2e:	9101                	srli	a0,a0,0x20
    80002b30:	60e2                	ld	ra,24(sp)
    80002b32:	6442                	ld	s0,16(sp)
    80002b34:	64a2                	ld	s1,8(sp)
    80002b36:	6105                	addi	sp,sp,32
    80002b38:	8082                	ret

0000000080002b3a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002b3a:	7179                	addi	sp,sp,-48
    80002b3c:	f406                	sd	ra,40(sp)
    80002b3e:	f022                	sd	s0,32(sp)
    80002b40:	ec26                	sd	s1,24(sp)
    80002b42:	e84a                	sd	s2,16(sp)
    80002b44:	e44e                	sd	s3,8(sp)
    80002b46:	e052                	sd	s4,0(sp)
    80002b48:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002b4a:	00005597          	auipc	a1,0x5
    80002b4e:	97658593          	addi	a1,a1,-1674 # 800074c0 <userret+0x430>
    80002b52:	00015517          	auipc	a0,0x15
    80002b56:	9c650513          	addi	a0,a0,-1594 # 80017518 <bcache>
    80002b5a:	ffffe097          	auipc	ra,0xffffe
    80002b5e:	e56080e7          	jalr	-426(ra) # 800009b0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002b62:	0001d797          	auipc	a5,0x1d
    80002b66:	9b678793          	addi	a5,a5,-1610 # 8001f518 <bcache+0x8000>
    80002b6a:	0001d717          	auipc	a4,0x1d
    80002b6e:	d0670713          	addi	a4,a4,-762 # 8001f870 <bcache+0x8358>
    80002b72:	3ae7b023          	sd	a4,928(a5)
  bcache.head.next = &bcache.head;
    80002b76:	3ae7b423          	sd	a4,936(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b7a:	00015497          	auipc	s1,0x15
    80002b7e:	9b648493          	addi	s1,s1,-1610 # 80017530 <bcache+0x18>
    b->next = bcache.head.next;
    80002b82:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002b84:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002b86:	00005a17          	auipc	s4,0x5
    80002b8a:	942a0a13          	addi	s4,s4,-1726 # 800074c8 <userret+0x438>
    b->next = bcache.head.next;
    80002b8e:	3a893783          	ld	a5,936(s2)
    80002b92:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002b94:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002b98:	85d2                	mv	a1,s4
    80002b9a:	01048513          	addi	a0,s1,16
    80002b9e:	00001097          	auipc	ra,0x1
    80002ba2:	6f6080e7          	jalr	1782(ra) # 80004294 <initsleeplock>
    bcache.head.next->prev = b;
    80002ba6:	3a893783          	ld	a5,936(s2)
    80002baa:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002bac:	3a993423          	sd	s1,936(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002bb0:	46048493          	addi	s1,s1,1120
    80002bb4:	fd349de3          	bne	s1,s3,80002b8e <binit+0x54>
  }
}
    80002bb8:	70a2                	ld	ra,40(sp)
    80002bba:	7402                	ld	s0,32(sp)
    80002bbc:	64e2                	ld	s1,24(sp)
    80002bbe:	6942                	ld	s2,16(sp)
    80002bc0:	69a2                	ld	s3,8(sp)
    80002bc2:	6a02                	ld	s4,0(sp)
    80002bc4:	6145                	addi	sp,sp,48
    80002bc6:	8082                	ret

0000000080002bc8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002bc8:	7179                	addi	sp,sp,-48
    80002bca:	f406                	sd	ra,40(sp)
    80002bcc:	f022                	sd	s0,32(sp)
    80002bce:	ec26                	sd	s1,24(sp)
    80002bd0:	e84a                	sd	s2,16(sp)
    80002bd2:	e44e                	sd	s3,8(sp)
    80002bd4:	1800                	addi	s0,sp,48
    80002bd6:	892a                	mv	s2,a0
    80002bd8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002bda:	00015517          	auipc	a0,0x15
    80002bde:	93e50513          	addi	a0,a0,-1730 # 80017518 <bcache>
    80002be2:	ffffe097          	auipc	ra,0xffffe
    80002be6:	edc080e7          	jalr	-292(ra) # 80000abe <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002bea:	0001d497          	auipc	s1,0x1d
    80002bee:	cd64b483          	ld	s1,-810(s1) # 8001f8c0 <bcache+0x83a8>
    80002bf2:	0001d797          	auipc	a5,0x1d
    80002bf6:	c7e78793          	addi	a5,a5,-898 # 8001f870 <bcache+0x8358>
    80002bfa:	02f48f63          	beq	s1,a5,80002c38 <bread+0x70>
    80002bfe:	873e                	mv	a4,a5
    80002c00:	a021                	j	80002c08 <bread+0x40>
    80002c02:	68a4                	ld	s1,80(s1)
    80002c04:	02e48a63          	beq	s1,a4,80002c38 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002c08:	449c                	lw	a5,8(s1)
    80002c0a:	ff279ce3          	bne	a5,s2,80002c02 <bread+0x3a>
    80002c0e:	44dc                	lw	a5,12(s1)
    80002c10:	ff3799e3          	bne	a5,s3,80002c02 <bread+0x3a>
      b->refcnt++;
    80002c14:	40bc                	lw	a5,64(s1)
    80002c16:	2785                	addiw	a5,a5,1
    80002c18:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c1a:	00015517          	auipc	a0,0x15
    80002c1e:	8fe50513          	addi	a0,a0,-1794 # 80017518 <bcache>
    80002c22:	ffffe097          	auipc	ra,0xffffe
    80002c26:	f04080e7          	jalr	-252(ra) # 80000b26 <release>
      acquiresleep(&b->lock);
    80002c2a:	01048513          	addi	a0,s1,16
    80002c2e:	00001097          	auipc	ra,0x1
    80002c32:	6a0080e7          	jalr	1696(ra) # 800042ce <acquiresleep>
      return b;
    80002c36:	a8b9                	j	80002c94 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c38:	0001d497          	auipc	s1,0x1d
    80002c3c:	c804b483          	ld	s1,-896(s1) # 8001f8b8 <bcache+0x83a0>
    80002c40:	0001d797          	auipc	a5,0x1d
    80002c44:	c3078793          	addi	a5,a5,-976 # 8001f870 <bcache+0x8358>
    80002c48:	00f48863          	beq	s1,a5,80002c58 <bread+0x90>
    80002c4c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002c4e:	40bc                	lw	a5,64(s1)
    80002c50:	cf81                	beqz	a5,80002c68 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c52:	64a4                	ld	s1,72(s1)
    80002c54:	fee49de3          	bne	s1,a4,80002c4e <bread+0x86>
  panic("bget: no buffers");
    80002c58:	00005517          	auipc	a0,0x5
    80002c5c:	87850513          	addi	a0,a0,-1928 # 800074d0 <userret+0x440>
    80002c60:	ffffe097          	auipc	ra,0xffffe
    80002c64:	8e8080e7          	jalr	-1816(ra) # 80000548 <panic>
      b->dev = dev;
    80002c68:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002c6c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002c70:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002c74:	4785                	li	a5,1
    80002c76:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c78:	00015517          	auipc	a0,0x15
    80002c7c:	8a050513          	addi	a0,a0,-1888 # 80017518 <bcache>
    80002c80:	ffffe097          	auipc	ra,0xffffe
    80002c84:	ea6080e7          	jalr	-346(ra) # 80000b26 <release>
      acquiresleep(&b->lock);
    80002c88:	01048513          	addi	a0,s1,16
    80002c8c:	00001097          	auipc	ra,0x1
    80002c90:	642080e7          	jalr	1602(ra) # 800042ce <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002c94:	409c                	lw	a5,0(s1)
    80002c96:	cb89                	beqz	a5,80002ca8 <bread+0xe0>
    virtio_disk_rw(b->dev, b, 0);
    b->valid = 1;
  }
  return b;
}
    80002c98:	8526                	mv	a0,s1
    80002c9a:	70a2                	ld	ra,40(sp)
    80002c9c:	7402                	ld	s0,32(sp)
    80002c9e:	64e2                	ld	s1,24(sp)
    80002ca0:	6942                	ld	s2,16(sp)
    80002ca2:	69a2                	ld	s3,8(sp)
    80002ca4:	6145                	addi	sp,sp,48
    80002ca6:	8082                	ret
    virtio_disk_rw(b->dev, b, 0);
    80002ca8:	4601                	li	a2,0
    80002caa:	85a6                	mv	a1,s1
    80002cac:	4488                	lw	a0,8(s1)
    80002cae:	00003097          	auipc	ra,0x3
    80002cb2:	29e080e7          	jalr	670(ra) # 80005f4c <virtio_disk_rw>
    b->valid = 1;
    80002cb6:	4785                	li	a5,1
    80002cb8:	c09c                	sw	a5,0(s1)
  return b;
    80002cba:	bff9                	j	80002c98 <bread+0xd0>

0000000080002cbc <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002cbc:	1101                	addi	sp,sp,-32
    80002cbe:	ec06                	sd	ra,24(sp)
    80002cc0:	e822                	sd	s0,16(sp)
    80002cc2:	e426                	sd	s1,8(sp)
    80002cc4:	1000                	addi	s0,sp,32
    80002cc6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002cc8:	0541                	addi	a0,a0,16
    80002cca:	00001097          	auipc	ra,0x1
    80002cce:	69e080e7          	jalr	1694(ra) # 80004368 <holdingsleep>
    80002cd2:	cd09                	beqz	a0,80002cec <bwrite+0x30>
    panic("bwrite");
  virtio_disk_rw(b->dev, b, 1);
    80002cd4:	4605                	li	a2,1
    80002cd6:	85a6                	mv	a1,s1
    80002cd8:	4488                	lw	a0,8(s1)
    80002cda:	00003097          	auipc	ra,0x3
    80002cde:	272080e7          	jalr	626(ra) # 80005f4c <virtio_disk_rw>
}
    80002ce2:	60e2                	ld	ra,24(sp)
    80002ce4:	6442                	ld	s0,16(sp)
    80002ce6:	64a2                	ld	s1,8(sp)
    80002ce8:	6105                	addi	sp,sp,32
    80002cea:	8082                	ret
    panic("bwrite");
    80002cec:	00004517          	auipc	a0,0x4
    80002cf0:	7fc50513          	addi	a0,a0,2044 # 800074e8 <userret+0x458>
    80002cf4:	ffffe097          	auipc	ra,0xffffe
    80002cf8:	854080e7          	jalr	-1964(ra) # 80000548 <panic>

0000000080002cfc <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
    80002cfc:	1101                	addi	sp,sp,-32
    80002cfe:	ec06                	sd	ra,24(sp)
    80002d00:	e822                	sd	s0,16(sp)
    80002d02:	e426                	sd	s1,8(sp)
    80002d04:	e04a                	sd	s2,0(sp)
    80002d06:	1000                	addi	s0,sp,32
    80002d08:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d0a:	01050913          	addi	s2,a0,16
    80002d0e:	854a                	mv	a0,s2
    80002d10:	00001097          	auipc	ra,0x1
    80002d14:	658080e7          	jalr	1624(ra) # 80004368 <holdingsleep>
    80002d18:	c92d                	beqz	a0,80002d8a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002d1a:	854a                	mv	a0,s2
    80002d1c:	00001097          	auipc	ra,0x1
    80002d20:	608080e7          	jalr	1544(ra) # 80004324 <releasesleep>

  acquire(&bcache.lock);
    80002d24:	00014517          	auipc	a0,0x14
    80002d28:	7f450513          	addi	a0,a0,2036 # 80017518 <bcache>
    80002d2c:	ffffe097          	auipc	ra,0xffffe
    80002d30:	d92080e7          	jalr	-622(ra) # 80000abe <acquire>
  b->refcnt--;
    80002d34:	40bc                	lw	a5,64(s1)
    80002d36:	37fd                	addiw	a5,a5,-1
    80002d38:	0007871b          	sext.w	a4,a5
    80002d3c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002d3e:	eb05                	bnez	a4,80002d6e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002d40:	68bc                	ld	a5,80(s1)
    80002d42:	64b8                	ld	a4,72(s1)
    80002d44:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002d46:	64bc                	ld	a5,72(s1)
    80002d48:	68b8                	ld	a4,80(s1)
    80002d4a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002d4c:	0001c797          	auipc	a5,0x1c
    80002d50:	7cc78793          	addi	a5,a5,1996 # 8001f518 <bcache+0x8000>
    80002d54:	3a87b703          	ld	a4,936(a5)
    80002d58:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002d5a:	0001d717          	auipc	a4,0x1d
    80002d5e:	b1670713          	addi	a4,a4,-1258 # 8001f870 <bcache+0x8358>
    80002d62:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002d64:	3a87b703          	ld	a4,936(a5)
    80002d68:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002d6a:	3a97b423          	sd	s1,936(a5)
  }
  
  release(&bcache.lock);
    80002d6e:	00014517          	auipc	a0,0x14
    80002d72:	7aa50513          	addi	a0,a0,1962 # 80017518 <bcache>
    80002d76:	ffffe097          	auipc	ra,0xffffe
    80002d7a:	db0080e7          	jalr	-592(ra) # 80000b26 <release>
}
    80002d7e:	60e2                	ld	ra,24(sp)
    80002d80:	6442                	ld	s0,16(sp)
    80002d82:	64a2                	ld	s1,8(sp)
    80002d84:	6902                	ld	s2,0(sp)
    80002d86:	6105                	addi	sp,sp,32
    80002d88:	8082                	ret
    panic("brelse");
    80002d8a:	00004517          	auipc	a0,0x4
    80002d8e:	76650513          	addi	a0,a0,1894 # 800074f0 <userret+0x460>
    80002d92:	ffffd097          	auipc	ra,0xffffd
    80002d96:	7b6080e7          	jalr	1974(ra) # 80000548 <panic>

0000000080002d9a <bpin>:

void
bpin(struct buf *b) {
    80002d9a:	1101                	addi	sp,sp,-32
    80002d9c:	ec06                	sd	ra,24(sp)
    80002d9e:	e822                	sd	s0,16(sp)
    80002da0:	e426                	sd	s1,8(sp)
    80002da2:	1000                	addi	s0,sp,32
    80002da4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002da6:	00014517          	auipc	a0,0x14
    80002daa:	77250513          	addi	a0,a0,1906 # 80017518 <bcache>
    80002dae:	ffffe097          	auipc	ra,0xffffe
    80002db2:	d10080e7          	jalr	-752(ra) # 80000abe <acquire>
  b->refcnt++;
    80002db6:	40bc                	lw	a5,64(s1)
    80002db8:	2785                	addiw	a5,a5,1
    80002dba:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002dbc:	00014517          	auipc	a0,0x14
    80002dc0:	75c50513          	addi	a0,a0,1884 # 80017518 <bcache>
    80002dc4:	ffffe097          	auipc	ra,0xffffe
    80002dc8:	d62080e7          	jalr	-670(ra) # 80000b26 <release>
}
    80002dcc:	60e2                	ld	ra,24(sp)
    80002dce:	6442                	ld	s0,16(sp)
    80002dd0:	64a2                	ld	s1,8(sp)
    80002dd2:	6105                	addi	sp,sp,32
    80002dd4:	8082                	ret

0000000080002dd6 <bunpin>:

void
bunpin(struct buf *b) {
    80002dd6:	1101                	addi	sp,sp,-32
    80002dd8:	ec06                	sd	ra,24(sp)
    80002dda:	e822                	sd	s0,16(sp)
    80002ddc:	e426                	sd	s1,8(sp)
    80002dde:	1000                	addi	s0,sp,32
    80002de0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002de2:	00014517          	auipc	a0,0x14
    80002de6:	73650513          	addi	a0,a0,1846 # 80017518 <bcache>
    80002dea:	ffffe097          	auipc	ra,0xffffe
    80002dee:	cd4080e7          	jalr	-812(ra) # 80000abe <acquire>
  b->refcnt--;
    80002df2:	40bc                	lw	a5,64(s1)
    80002df4:	37fd                	addiw	a5,a5,-1
    80002df6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002df8:	00014517          	auipc	a0,0x14
    80002dfc:	72050513          	addi	a0,a0,1824 # 80017518 <bcache>
    80002e00:	ffffe097          	auipc	ra,0xffffe
    80002e04:	d26080e7          	jalr	-730(ra) # 80000b26 <release>
}
    80002e08:	60e2                	ld	ra,24(sp)
    80002e0a:	6442                	ld	s0,16(sp)
    80002e0c:	64a2                	ld	s1,8(sp)
    80002e0e:	6105                	addi	sp,sp,32
    80002e10:	8082                	ret

0000000080002e12 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002e12:	1101                	addi	sp,sp,-32
    80002e14:	ec06                	sd	ra,24(sp)
    80002e16:	e822                	sd	s0,16(sp)
    80002e18:	e426                	sd	s1,8(sp)
    80002e1a:	e04a                	sd	s2,0(sp)
    80002e1c:	1000                	addi	s0,sp,32
    80002e1e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002e20:	00d5d59b          	srliw	a1,a1,0xd
    80002e24:	0001d797          	auipc	a5,0x1d
    80002e28:	ec87a783          	lw	a5,-312(a5) # 8001fcec <sb+0x1c>
    80002e2c:	9dbd                	addw	a1,a1,a5
    80002e2e:	00000097          	auipc	ra,0x0
    80002e32:	d9a080e7          	jalr	-614(ra) # 80002bc8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002e36:	0074f713          	andi	a4,s1,7
    80002e3a:	4785                	li	a5,1
    80002e3c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002e40:	14ce                	slli	s1,s1,0x33
    80002e42:	90d9                	srli	s1,s1,0x36
    80002e44:	00950733          	add	a4,a0,s1
    80002e48:	06074703          	lbu	a4,96(a4)
    80002e4c:	00e7f6b3          	and	a3,a5,a4
    80002e50:	c69d                	beqz	a3,80002e7e <bfree+0x6c>
    80002e52:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002e54:	94aa                	add	s1,s1,a0
    80002e56:	fff7c793          	not	a5,a5
    80002e5a:	8ff9                	and	a5,a5,a4
    80002e5c:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    80002e60:	00001097          	auipc	ra,0x1
    80002e64:	1d6080e7          	jalr	470(ra) # 80004036 <log_write>
  brelse(bp);
    80002e68:	854a                	mv	a0,s2
    80002e6a:	00000097          	auipc	ra,0x0
    80002e6e:	e92080e7          	jalr	-366(ra) # 80002cfc <brelse>
}
    80002e72:	60e2                	ld	ra,24(sp)
    80002e74:	6442                	ld	s0,16(sp)
    80002e76:	64a2                	ld	s1,8(sp)
    80002e78:	6902                	ld	s2,0(sp)
    80002e7a:	6105                	addi	sp,sp,32
    80002e7c:	8082                	ret
    panic("freeing free block");
    80002e7e:	00004517          	auipc	a0,0x4
    80002e82:	67a50513          	addi	a0,a0,1658 # 800074f8 <userret+0x468>
    80002e86:	ffffd097          	auipc	ra,0xffffd
    80002e8a:	6c2080e7          	jalr	1730(ra) # 80000548 <panic>

0000000080002e8e <balloc>:
{
    80002e8e:	711d                	addi	sp,sp,-96
    80002e90:	ec86                	sd	ra,88(sp)
    80002e92:	e8a2                	sd	s0,80(sp)
    80002e94:	e4a6                	sd	s1,72(sp)
    80002e96:	e0ca                	sd	s2,64(sp)
    80002e98:	fc4e                	sd	s3,56(sp)
    80002e9a:	f852                	sd	s4,48(sp)
    80002e9c:	f456                	sd	s5,40(sp)
    80002e9e:	f05a                	sd	s6,32(sp)
    80002ea0:	ec5e                	sd	s7,24(sp)
    80002ea2:	e862                	sd	s8,16(sp)
    80002ea4:	e466                	sd	s9,8(sp)
    80002ea6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002ea8:	0001d797          	auipc	a5,0x1d
    80002eac:	e2c7a783          	lw	a5,-468(a5) # 8001fcd4 <sb+0x4>
    80002eb0:	cbd1                	beqz	a5,80002f44 <balloc+0xb6>
    80002eb2:	8baa                	mv	s7,a0
    80002eb4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002eb6:	0001db17          	auipc	s6,0x1d
    80002eba:	e1ab0b13          	addi	s6,s6,-486 # 8001fcd0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002ebe:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002ec0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002ec2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002ec4:	6c89                	lui	s9,0x2
    80002ec6:	a831                	j	80002ee2 <balloc+0x54>
    brelse(bp);
    80002ec8:	854a                	mv	a0,s2
    80002eca:	00000097          	auipc	ra,0x0
    80002ece:	e32080e7          	jalr	-462(ra) # 80002cfc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002ed2:	015c87bb          	addw	a5,s9,s5
    80002ed6:	00078a9b          	sext.w	s5,a5
    80002eda:	004b2703          	lw	a4,4(s6)
    80002ede:	06eaf363          	bgeu	s5,a4,80002f44 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002ee2:	41fad79b          	sraiw	a5,s5,0x1f
    80002ee6:	0137d79b          	srliw	a5,a5,0x13
    80002eea:	015787bb          	addw	a5,a5,s5
    80002eee:	40d7d79b          	sraiw	a5,a5,0xd
    80002ef2:	01cb2583          	lw	a1,28(s6)
    80002ef6:	9dbd                	addw	a1,a1,a5
    80002ef8:	855e                	mv	a0,s7
    80002efa:	00000097          	auipc	ra,0x0
    80002efe:	cce080e7          	jalr	-818(ra) # 80002bc8 <bread>
    80002f02:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f04:	004b2503          	lw	a0,4(s6)
    80002f08:	000a849b          	sext.w	s1,s5
    80002f0c:	8662                	mv	a2,s8
    80002f0e:	faa4fde3          	bgeu	s1,a0,80002ec8 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002f12:	41f6579b          	sraiw	a5,a2,0x1f
    80002f16:	01d7d69b          	srliw	a3,a5,0x1d
    80002f1a:	00c6873b          	addw	a4,a3,a2
    80002f1e:	00777793          	andi	a5,a4,7
    80002f22:	9f95                	subw	a5,a5,a3
    80002f24:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002f28:	4037571b          	sraiw	a4,a4,0x3
    80002f2c:	00e906b3          	add	a3,s2,a4
    80002f30:	0606c683          	lbu	a3,96(a3)
    80002f34:	00d7f5b3          	and	a1,a5,a3
    80002f38:	cd91                	beqz	a1,80002f54 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f3a:	2605                	addiw	a2,a2,1
    80002f3c:	2485                	addiw	s1,s1,1
    80002f3e:	fd4618e3          	bne	a2,s4,80002f0e <balloc+0x80>
    80002f42:	b759                	j	80002ec8 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002f44:	00004517          	auipc	a0,0x4
    80002f48:	5cc50513          	addi	a0,a0,1484 # 80007510 <userret+0x480>
    80002f4c:	ffffd097          	auipc	ra,0xffffd
    80002f50:	5fc080e7          	jalr	1532(ra) # 80000548 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002f54:	974a                	add	a4,a4,s2
    80002f56:	8fd5                	or	a5,a5,a3
    80002f58:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    80002f5c:	854a                	mv	a0,s2
    80002f5e:	00001097          	auipc	ra,0x1
    80002f62:	0d8080e7          	jalr	216(ra) # 80004036 <log_write>
        brelse(bp);
    80002f66:	854a                	mv	a0,s2
    80002f68:	00000097          	auipc	ra,0x0
    80002f6c:	d94080e7          	jalr	-620(ra) # 80002cfc <brelse>
  bp = bread(dev, bno);
    80002f70:	85a6                	mv	a1,s1
    80002f72:	855e                	mv	a0,s7
    80002f74:	00000097          	auipc	ra,0x0
    80002f78:	c54080e7          	jalr	-940(ra) # 80002bc8 <bread>
    80002f7c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002f7e:	40000613          	li	a2,1024
    80002f82:	4581                	li	a1,0
    80002f84:	06050513          	addi	a0,a0,96
    80002f88:	ffffe097          	auipc	ra,0xffffe
    80002f8c:	bfa080e7          	jalr	-1030(ra) # 80000b82 <memset>
  log_write(bp);
    80002f90:	854a                	mv	a0,s2
    80002f92:	00001097          	auipc	ra,0x1
    80002f96:	0a4080e7          	jalr	164(ra) # 80004036 <log_write>
  brelse(bp);
    80002f9a:	854a                	mv	a0,s2
    80002f9c:	00000097          	auipc	ra,0x0
    80002fa0:	d60080e7          	jalr	-672(ra) # 80002cfc <brelse>
}
    80002fa4:	8526                	mv	a0,s1
    80002fa6:	60e6                	ld	ra,88(sp)
    80002fa8:	6446                	ld	s0,80(sp)
    80002faa:	64a6                	ld	s1,72(sp)
    80002fac:	6906                	ld	s2,64(sp)
    80002fae:	79e2                	ld	s3,56(sp)
    80002fb0:	7a42                	ld	s4,48(sp)
    80002fb2:	7aa2                	ld	s5,40(sp)
    80002fb4:	7b02                	ld	s6,32(sp)
    80002fb6:	6be2                	ld	s7,24(sp)
    80002fb8:	6c42                	ld	s8,16(sp)
    80002fba:	6ca2                	ld	s9,8(sp)
    80002fbc:	6125                	addi	sp,sp,96
    80002fbe:	8082                	ret

0000000080002fc0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002fc0:	7179                	addi	sp,sp,-48
    80002fc2:	f406                	sd	ra,40(sp)
    80002fc4:	f022                	sd	s0,32(sp)
    80002fc6:	ec26                	sd	s1,24(sp)
    80002fc8:	e84a                	sd	s2,16(sp)
    80002fca:	e44e                	sd	s3,8(sp)
    80002fcc:	e052                	sd	s4,0(sp)
    80002fce:	1800                	addi	s0,sp,48
    80002fd0:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002fd2:	47ad                	li	a5,11
    80002fd4:	04b7fe63          	bgeu	a5,a1,80003030 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002fd8:	ff45849b          	addiw	s1,a1,-12
    80002fdc:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002fe0:	0ff00793          	li	a5,255
    80002fe4:	0ae7e463          	bltu	a5,a4,8000308c <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002fe8:	08052583          	lw	a1,128(a0)
    80002fec:	c5b5                	beqz	a1,80003058 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002fee:	00092503          	lw	a0,0(s2)
    80002ff2:	00000097          	auipc	ra,0x0
    80002ff6:	bd6080e7          	jalr	-1066(ra) # 80002bc8 <bread>
    80002ffa:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002ffc:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80003000:	02049713          	slli	a4,s1,0x20
    80003004:	01e75593          	srli	a1,a4,0x1e
    80003008:	00b784b3          	add	s1,a5,a1
    8000300c:	0004a983          	lw	s3,0(s1)
    80003010:	04098e63          	beqz	s3,8000306c <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003014:	8552                	mv	a0,s4
    80003016:	00000097          	auipc	ra,0x0
    8000301a:	ce6080e7          	jalr	-794(ra) # 80002cfc <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000301e:	854e                	mv	a0,s3
    80003020:	70a2                	ld	ra,40(sp)
    80003022:	7402                	ld	s0,32(sp)
    80003024:	64e2                	ld	s1,24(sp)
    80003026:	6942                	ld	s2,16(sp)
    80003028:	69a2                	ld	s3,8(sp)
    8000302a:	6a02                	ld	s4,0(sp)
    8000302c:	6145                	addi	sp,sp,48
    8000302e:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003030:	02059793          	slli	a5,a1,0x20
    80003034:	01e7d593          	srli	a1,a5,0x1e
    80003038:	00b504b3          	add	s1,a0,a1
    8000303c:	0504a983          	lw	s3,80(s1)
    80003040:	fc099fe3          	bnez	s3,8000301e <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003044:	4108                	lw	a0,0(a0)
    80003046:	00000097          	auipc	ra,0x0
    8000304a:	e48080e7          	jalr	-440(ra) # 80002e8e <balloc>
    8000304e:	0005099b          	sext.w	s3,a0
    80003052:	0534a823          	sw	s3,80(s1)
    80003056:	b7e1                	j	8000301e <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003058:	4108                	lw	a0,0(a0)
    8000305a:	00000097          	auipc	ra,0x0
    8000305e:	e34080e7          	jalr	-460(ra) # 80002e8e <balloc>
    80003062:	0005059b          	sext.w	a1,a0
    80003066:	08b92023          	sw	a1,128(s2)
    8000306a:	b751                	j	80002fee <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000306c:	00092503          	lw	a0,0(s2)
    80003070:	00000097          	auipc	ra,0x0
    80003074:	e1e080e7          	jalr	-482(ra) # 80002e8e <balloc>
    80003078:	0005099b          	sext.w	s3,a0
    8000307c:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003080:	8552                	mv	a0,s4
    80003082:	00001097          	auipc	ra,0x1
    80003086:	fb4080e7          	jalr	-76(ra) # 80004036 <log_write>
    8000308a:	b769                	j	80003014 <bmap+0x54>
  panic("bmap: out of range");
    8000308c:	00004517          	auipc	a0,0x4
    80003090:	49c50513          	addi	a0,a0,1180 # 80007528 <userret+0x498>
    80003094:	ffffd097          	auipc	ra,0xffffd
    80003098:	4b4080e7          	jalr	1204(ra) # 80000548 <panic>

000000008000309c <iget>:
{
    8000309c:	7179                	addi	sp,sp,-48
    8000309e:	f406                	sd	ra,40(sp)
    800030a0:	f022                	sd	s0,32(sp)
    800030a2:	ec26                	sd	s1,24(sp)
    800030a4:	e84a                	sd	s2,16(sp)
    800030a6:	e44e                	sd	s3,8(sp)
    800030a8:	e052                	sd	s4,0(sp)
    800030aa:	1800                	addi	s0,sp,48
    800030ac:	89aa                	mv	s3,a0
    800030ae:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800030b0:	0001d517          	auipc	a0,0x1d
    800030b4:	c4050513          	addi	a0,a0,-960 # 8001fcf0 <icache>
    800030b8:	ffffe097          	auipc	ra,0xffffe
    800030bc:	a06080e7          	jalr	-1530(ra) # 80000abe <acquire>
  empty = 0;
    800030c0:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800030c2:	0001d497          	auipc	s1,0x1d
    800030c6:	c4648493          	addi	s1,s1,-954 # 8001fd08 <icache+0x18>
    800030ca:	0001e697          	auipc	a3,0x1e
    800030ce:	6ce68693          	addi	a3,a3,1742 # 80021798 <log>
    800030d2:	a039                	j	800030e0 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800030d4:	02090b63          	beqz	s2,8000310a <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800030d8:	08848493          	addi	s1,s1,136
    800030dc:	02d48a63          	beq	s1,a3,80003110 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800030e0:	449c                	lw	a5,8(s1)
    800030e2:	fef059e3          	blez	a5,800030d4 <iget+0x38>
    800030e6:	4098                	lw	a4,0(s1)
    800030e8:	ff3716e3          	bne	a4,s3,800030d4 <iget+0x38>
    800030ec:	40d8                	lw	a4,4(s1)
    800030ee:	ff4713e3          	bne	a4,s4,800030d4 <iget+0x38>
      ip->ref++;
    800030f2:	2785                	addiw	a5,a5,1
    800030f4:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    800030f6:	0001d517          	auipc	a0,0x1d
    800030fa:	bfa50513          	addi	a0,a0,-1030 # 8001fcf0 <icache>
    800030fe:	ffffe097          	auipc	ra,0xffffe
    80003102:	a28080e7          	jalr	-1496(ra) # 80000b26 <release>
      return ip;
    80003106:	8926                	mv	s2,s1
    80003108:	a03d                	j	80003136 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000310a:	f7f9                	bnez	a5,800030d8 <iget+0x3c>
    8000310c:	8926                	mv	s2,s1
    8000310e:	b7e9                	j	800030d8 <iget+0x3c>
  if(empty == 0)
    80003110:	02090c63          	beqz	s2,80003148 <iget+0xac>
  ip->dev = dev;
    80003114:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003118:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000311c:	4785                	li	a5,1
    8000311e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003122:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003126:	0001d517          	auipc	a0,0x1d
    8000312a:	bca50513          	addi	a0,a0,-1078 # 8001fcf0 <icache>
    8000312e:	ffffe097          	auipc	ra,0xffffe
    80003132:	9f8080e7          	jalr	-1544(ra) # 80000b26 <release>
}
    80003136:	854a                	mv	a0,s2
    80003138:	70a2                	ld	ra,40(sp)
    8000313a:	7402                	ld	s0,32(sp)
    8000313c:	64e2                	ld	s1,24(sp)
    8000313e:	6942                	ld	s2,16(sp)
    80003140:	69a2                	ld	s3,8(sp)
    80003142:	6a02                	ld	s4,0(sp)
    80003144:	6145                	addi	sp,sp,48
    80003146:	8082                	ret
    panic("iget: no inodes");
    80003148:	00004517          	auipc	a0,0x4
    8000314c:	3f850513          	addi	a0,a0,1016 # 80007540 <userret+0x4b0>
    80003150:	ffffd097          	auipc	ra,0xffffd
    80003154:	3f8080e7          	jalr	1016(ra) # 80000548 <panic>

0000000080003158 <fsinit>:
fsinit(int dev) {
    80003158:	7179                	addi	sp,sp,-48
    8000315a:	f406                	sd	ra,40(sp)
    8000315c:	f022                	sd	s0,32(sp)
    8000315e:	ec26                	sd	s1,24(sp)
    80003160:	e84a                	sd	s2,16(sp)
    80003162:	e44e                	sd	s3,8(sp)
    80003164:	1800                	addi	s0,sp,48
    80003166:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003168:	4585                	li	a1,1
    8000316a:	00000097          	auipc	ra,0x0
    8000316e:	a5e080e7          	jalr	-1442(ra) # 80002bc8 <bread>
    80003172:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003174:	0001d997          	auipc	s3,0x1d
    80003178:	b5c98993          	addi	s3,s3,-1188 # 8001fcd0 <sb>
    8000317c:	02000613          	li	a2,32
    80003180:	06050593          	addi	a1,a0,96
    80003184:	854e                	mv	a0,s3
    80003186:	ffffe097          	auipc	ra,0xffffe
    8000318a:	a58080e7          	jalr	-1448(ra) # 80000bde <memmove>
  brelse(bp);
    8000318e:	8526                	mv	a0,s1
    80003190:	00000097          	auipc	ra,0x0
    80003194:	b6c080e7          	jalr	-1172(ra) # 80002cfc <brelse>
  if(sb.magic != FSMAGIC)
    80003198:	0009a703          	lw	a4,0(s3)
    8000319c:	102037b7          	lui	a5,0x10203
    800031a0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800031a4:	02f71263          	bne	a4,a5,800031c8 <fsinit+0x70>
  initlog(dev, &sb);
    800031a8:	0001d597          	auipc	a1,0x1d
    800031ac:	b2858593          	addi	a1,a1,-1240 # 8001fcd0 <sb>
    800031b0:	854a                	mv	a0,s2
    800031b2:	00001097          	auipc	ra,0x1
    800031b6:	bfc080e7          	jalr	-1028(ra) # 80003dae <initlog>
}
    800031ba:	70a2                	ld	ra,40(sp)
    800031bc:	7402                	ld	s0,32(sp)
    800031be:	64e2                	ld	s1,24(sp)
    800031c0:	6942                	ld	s2,16(sp)
    800031c2:	69a2                	ld	s3,8(sp)
    800031c4:	6145                	addi	sp,sp,48
    800031c6:	8082                	ret
    panic("invalid file system");
    800031c8:	00004517          	auipc	a0,0x4
    800031cc:	38850513          	addi	a0,a0,904 # 80007550 <userret+0x4c0>
    800031d0:	ffffd097          	auipc	ra,0xffffd
    800031d4:	378080e7          	jalr	888(ra) # 80000548 <panic>

00000000800031d8 <iinit>:
{
    800031d8:	7179                	addi	sp,sp,-48
    800031da:	f406                	sd	ra,40(sp)
    800031dc:	f022                	sd	s0,32(sp)
    800031de:	ec26                	sd	s1,24(sp)
    800031e0:	e84a                	sd	s2,16(sp)
    800031e2:	e44e                	sd	s3,8(sp)
    800031e4:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    800031e6:	00004597          	auipc	a1,0x4
    800031ea:	38258593          	addi	a1,a1,898 # 80007568 <userret+0x4d8>
    800031ee:	0001d517          	auipc	a0,0x1d
    800031f2:	b0250513          	addi	a0,a0,-1278 # 8001fcf0 <icache>
    800031f6:	ffffd097          	auipc	ra,0xffffd
    800031fa:	7ba080e7          	jalr	1978(ra) # 800009b0 <initlock>
  for(i = 0; i < NINODE; i++) {
    800031fe:	0001d497          	auipc	s1,0x1d
    80003202:	b1a48493          	addi	s1,s1,-1254 # 8001fd18 <icache+0x28>
    80003206:	0001e997          	auipc	s3,0x1e
    8000320a:	5a298993          	addi	s3,s3,1442 # 800217a8 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    8000320e:	00004917          	auipc	s2,0x4
    80003212:	36290913          	addi	s2,s2,866 # 80007570 <userret+0x4e0>
    80003216:	85ca                	mv	a1,s2
    80003218:	8526                	mv	a0,s1
    8000321a:	00001097          	auipc	ra,0x1
    8000321e:	07a080e7          	jalr	122(ra) # 80004294 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003222:	08848493          	addi	s1,s1,136
    80003226:	ff3498e3          	bne	s1,s3,80003216 <iinit+0x3e>
}
    8000322a:	70a2                	ld	ra,40(sp)
    8000322c:	7402                	ld	s0,32(sp)
    8000322e:	64e2                	ld	s1,24(sp)
    80003230:	6942                	ld	s2,16(sp)
    80003232:	69a2                	ld	s3,8(sp)
    80003234:	6145                	addi	sp,sp,48
    80003236:	8082                	ret

0000000080003238 <ialloc>:
{
    80003238:	715d                	addi	sp,sp,-80
    8000323a:	e486                	sd	ra,72(sp)
    8000323c:	e0a2                	sd	s0,64(sp)
    8000323e:	fc26                	sd	s1,56(sp)
    80003240:	f84a                	sd	s2,48(sp)
    80003242:	f44e                	sd	s3,40(sp)
    80003244:	f052                	sd	s4,32(sp)
    80003246:	ec56                	sd	s5,24(sp)
    80003248:	e85a                	sd	s6,16(sp)
    8000324a:	e45e                	sd	s7,8(sp)
    8000324c:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000324e:	0001d717          	auipc	a4,0x1d
    80003252:	a8e72703          	lw	a4,-1394(a4) # 8001fcdc <sb+0xc>
    80003256:	4785                	li	a5,1
    80003258:	04e7fa63          	bgeu	a5,a4,800032ac <ialloc+0x74>
    8000325c:	8aaa                	mv	s5,a0
    8000325e:	8bae                	mv	s7,a1
    80003260:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003262:	0001da17          	auipc	s4,0x1d
    80003266:	a6ea0a13          	addi	s4,s4,-1426 # 8001fcd0 <sb>
    8000326a:	00048b1b          	sext.w	s6,s1
    8000326e:	0044d793          	srli	a5,s1,0x4
    80003272:	018a2583          	lw	a1,24(s4)
    80003276:	9dbd                	addw	a1,a1,a5
    80003278:	8556                	mv	a0,s5
    8000327a:	00000097          	auipc	ra,0x0
    8000327e:	94e080e7          	jalr	-1714(ra) # 80002bc8 <bread>
    80003282:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003284:	06050993          	addi	s3,a0,96
    80003288:	00f4f793          	andi	a5,s1,15
    8000328c:	079a                	slli	a5,a5,0x6
    8000328e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003290:	00099783          	lh	a5,0(s3)
    80003294:	c785                	beqz	a5,800032bc <ialloc+0x84>
    brelse(bp);
    80003296:	00000097          	auipc	ra,0x0
    8000329a:	a66080e7          	jalr	-1434(ra) # 80002cfc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000329e:	0485                	addi	s1,s1,1
    800032a0:	00ca2703          	lw	a4,12(s4)
    800032a4:	0004879b          	sext.w	a5,s1
    800032a8:	fce7e1e3          	bltu	a5,a4,8000326a <ialloc+0x32>
  panic("ialloc: no inodes");
    800032ac:	00004517          	auipc	a0,0x4
    800032b0:	2cc50513          	addi	a0,a0,716 # 80007578 <userret+0x4e8>
    800032b4:	ffffd097          	auipc	ra,0xffffd
    800032b8:	294080e7          	jalr	660(ra) # 80000548 <panic>
      memset(dip, 0, sizeof(*dip));
    800032bc:	04000613          	li	a2,64
    800032c0:	4581                	li	a1,0
    800032c2:	854e                	mv	a0,s3
    800032c4:	ffffe097          	auipc	ra,0xffffe
    800032c8:	8be080e7          	jalr	-1858(ra) # 80000b82 <memset>
      dip->type = type;
    800032cc:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800032d0:	854a                	mv	a0,s2
    800032d2:	00001097          	auipc	ra,0x1
    800032d6:	d64080e7          	jalr	-668(ra) # 80004036 <log_write>
      brelse(bp);
    800032da:	854a                	mv	a0,s2
    800032dc:	00000097          	auipc	ra,0x0
    800032e0:	a20080e7          	jalr	-1504(ra) # 80002cfc <brelse>
      return iget(dev, inum);
    800032e4:	85da                	mv	a1,s6
    800032e6:	8556                	mv	a0,s5
    800032e8:	00000097          	auipc	ra,0x0
    800032ec:	db4080e7          	jalr	-588(ra) # 8000309c <iget>
}
    800032f0:	60a6                	ld	ra,72(sp)
    800032f2:	6406                	ld	s0,64(sp)
    800032f4:	74e2                	ld	s1,56(sp)
    800032f6:	7942                	ld	s2,48(sp)
    800032f8:	79a2                	ld	s3,40(sp)
    800032fa:	7a02                	ld	s4,32(sp)
    800032fc:	6ae2                	ld	s5,24(sp)
    800032fe:	6b42                	ld	s6,16(sp)
    80003300:	6ba2                	ld	s7,8(sp)
    80003302:	6161                	addi	sp,sp,80
    80003304:	8082                	ret

0000000080003306 <iupdate>:
{
    80003306:	1101                	addi	sp,sp,-32
    80003308:	ec06                	sd	ra,24(sp)
    8000330a:	e822                	sd	s0,16(sp)
    8000330c:	e426                	sd	s1,8(sp)
    8000330e:	e04a                	sd	s2,0(sp)
    80003310:	1000                	addi	s0,sp,32
    80003312:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003314:	415c                	lw	a5,4(a0)
    80003316:	0047d79b          	srliw	a5,a5,0x4
    8000331a:	0001d597          	auipc	a1,0x1d
    8000331e:	9ce5a583          	lw	a1,-1586(a1) # 8001fce8 <sb+0x18>
    80003322:	9dbd                	addw	a1,a1,a5
    80003324:	4108                	lw	a0,0(a0)
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	8a2080e7          	jalr	-1886(ra) # 80002bc8 <bread>
    8000332e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003330:	06050793          	addi	a5,a0,96
    80003334:	40c8                	lw	a0,4(s1)
    80003336:	893d                	andi	a0,a0,15
    80003338:	051a                	slli	a0,a0,0x6
    8000333a:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    8000333c:	04449703          	lh	a4,68(s1)
    80003340:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003344:	04649703          	lh	a4,70(s1)
    80003348:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    8000334c:	04849703          	lh	a4,72(s1)
    80003350:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003354:	04a49703          	lh	a4,74(s1)
    80003358:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    8000335c:	44f8                	lw	a4,76(s1)
    8000335e:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003360:	03400613          	li	a2,52
    80003364:	05048593          	addi	a1,s1,80
    80003368:	0531                	addi	a0,a0,12
    8000336a:	ffffe097          	auipc	ra,0xffffe
    8000336e:	874080e7          	jalr	-1932(ra) # 80000bde <memmove>
  log_write(bp);
    80003372:	854a                	mv	a0,s2
    80003374:	00001097          	auipc	ra,0x1
    80003378:	cc2080e7          	jalr	-830(ra) # 80004036 <log_write>
  brelse(bp);
    8000337c:	854a                	mv	a0,s2
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	97e080e7          	jalr	-1666(ra) # 80002cfc <brelse>
}
    80003386:	60e2                	ld	ra,24(sp)
    80003388:	6442                	ld	s0,16(sp)
    8000338a:	64a2                	ld	s1,8(sp)
    8000338c:	6902                	ld	s2,0(sp)
    8000338e:	6105                	addi	sp,sp,32
    80003390:	8082                	ret

0000000080003392 <idup>:
{
    80003392:	1101                	addi	sp,sp,-32
    80003394:	ec06                	sd	ra,24(sp)
    80003396:	e822                	sd	s0,16(sp)
    80003398:	e426                	sd	s1,8(sp)
    8000339a:	1000                	addi	s0,sp,32
    8000339c:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000339e:	0001d517          	auipc	a0,0x1d
    800033a2:	95250513          	addi	a0,a0,-1710 # 8001fcf0 <icache>
    800033a6:	ffffd097          	auipc	ra,0xffffd
    800033aa:	718080e7          	jalr	1816(ra) # 80000abe <acquire>
  ip->ref++;
    800033ae:	449c                	lw	a5,8(s1)
    800033b0:	2785                	addiw	a5,a5,1
    800033b2:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800033b4:	0001d517          	auipc	a0,0x1d
    800033b8:	93c50513          	addi	a0,a0,-1732 # 8001fcf0 <icache>
    800033bc:	ffffd097          	auipc	ra,0xffffd
    800033c0:	76a080e7          	jalr	1898(ra) # 80000b26 <release>
}
    800033c4:	8526                	mv	a0,s1
    800033c6:	60e2                	ld	ra,24(sp)
    800033c8:	6442                	ld	s0,16(sp)
    800033ca:	64a2                	ld	s1,8(sp)
    800033cc:	6105                	addi	sp,sp,32
    800033ce:	8082                	ret

00000000800033d0 <ilock>:
{
    800033d0:	1101                	addi	sp,sp,-32
    800033d2:	ec06                	sd	ra,24(sp)
    800033d4:	e822                	sd	s0,16(sp)
    800033d6:	e426                	sd	s1,8(sp)
    800033d8:	e04a                	sd	s2,0(sp)
    800033da:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800033dc:	c115                	beqz	a0,80003400 <ilock+0x30>
    800033de:	84aa                	mv	s1,a0
    800033e0:	451c                	lw	a5,8(a0)
    800033e2:	00f05f63          	blez	a5,80003400 <ilock+0x30>
  acquiresleep(&ip->lock);
    800033e6:	0541                	addi	a0,a0,16
    800033e8:	00001097          	auipc	ra,0x1
    800033ec:	ee6080e7          	jalr	-282(ra) # 800042ce <acquiresleep>
  if(ip->valid == 0){
    800033f0:	40bc                	lw	a5,64(s1)
    800033f2:	cf99                	beqz	a5,80003410 <ilock+0x40>
}
    800033f4:	60e2                	ld	ra,24(sp)
    800033f6:	6442                	ld	s0,16(sp)
    800033f8:	64a2                	ld	s1,8(sp)
    800033fa:	6902                	ld	s2,0(sp)
    800033fc:	6105                	addi	sp,sp,32
    800033fe:	8082                	ret
    panic("ilock");
    80003400:	00004517          	auipc	a0,0x4
    80003404:	19050513          	addi	a0,a0,400 # 80007590 <userret+0x500>
    80003408:	ffffd097          	auipc	ra,0xffffd
    8000340c:	140080e7          	jalr	320(ra) # 80000548 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003410:	40dc                	lw	a5,4(s1)
    80003412:	0047d79b          	srliw	a5,a5,0x4
    80003416:	0001d597          	auipc	a1,0x1d
    8000341a:	8d25a583          	lw	a1,-1838(a1) # 8001fce8 <sb+0x18>
    8000341e:	9dbd                	addw	a1,a1,a5
    80003420:	4088                	lw	a0,0(s1)
    80003422:	fffff097          	auipc	ra,0xfffff
    80003426:	7a6080e7          	jalr	1958(ra) # 80002bc8 <bread>
    8000342a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000342c:	06050593          	addi	a1,a0,96
    80003430:	40dc                	lw	a5,4(s1)
    80003432:	8bbd                	andi	a5,a5,15
    80003434:	079a                	slli	a5,a5,0x6
    80003436:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003438:	00059783          	lh	a5,0(a1)
    8000343c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003440:	00259783          	lh	a5,2(a1)
    80003444:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003448:	00459783          	lh	a5,4(a1)
    8000344c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003450:	00659783          	lh	a5,6(a1)
    80003454:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003458:	459c                	lw	a5,8(a1)
    8000345a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000345c:	03400613          	li	a2,52
    80003460:	05b1                	addi	a1,a1,12
    80003462:	05048513          	addi	a0,s1,80
    80003466:	ffffd097          	auipc	ra,0xffffd
    8000346a:	778080e7          	jalr	1912(ra) # 80000bde <memmove>
    brelse(bp);
    8000346e:	854a                	mv	a0,s2
    80003470:	00000097          	auipc	ra,0x0
    80003474:	88c080e7          	jalr	-1908(ra) # 80002cfc <brelse>
    ip->valid = 1;
    80003478:	4785                	li	a5,1
    8000347a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000347c:	04449783          	lh	a5,68(s1)
    80003480:	fbb5                	bnez	a5,800033f4 <ilock+0x24>
      panic("ilock: no type");
    80003482:	00004517          	auipc	a0,0x4
    80003486:	11650513          	addi	a0,a0,278 # 80007598 <userret+0x508>
    8000348a:	ffffd097          	auipc	ra,0xffffd
    8000348e:	0be080e7          	jalr	190(ra) # 80000548 <panic>

0000000080003492 <iunlock>:
{
    80003492:	1101                	addi	sp,sp,-32
    80003494:	ec06                	sd	ra,24(sp)
    80003496:	e822                	sd	s0,16(sp)
    80003498:	e426                	sd	s1,8(sp)
    8000349a:	e04a                	sd	s2,0(sp)
    8000349c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000349e:	c905                	beqz	a0,800034ce <iunlock+0x3c>
    800034a0:	84aa                	mv	s1,a0
    800034a2:	01050913          	addi	s2,a0,16
    800034a6:	854a                	mv	a0,s2
    800034a8:	00001097          	auipc	ra,0x1
    800034ac:	ec0080e7          	jalr	-320(ra) # 80004368 <holdingsleep>
    800034b0:	cd19                	beqz	a0,800034ce <iunlock+0x3c>
    800034b2:	449c                	lw	a5,8(s1)
    800034b4:	00f05d63          	blez	a5,800034ce <iunlock+0x3c>
  releasesleep(&ip->lock);
    800034b8:	854a                	mv	a0,s2
    800034ba:	00001097          	auipc	ra,0x1
    800034be:	e6a080e7          	jalr	-406(ra) # 80004324 <releasesleep>
}
    800034c2:	60e2                	ld	ra,24(sp)
    800034c4:	6442                	ld	s0,16(sp)
    800034c6:	64a2                	ld	s1,8(sp)
    800034c8:	6902                	ld	s2,0(sp)
    800034ca:	6105                	addi	sp,sp,32
    800034cc:	8082                	ret
    panic("iunlock");
    800034ce:	00004517          	auipc	a0,0x4
    800034d2:	0da50513          	addi	a0,a0,218 # 800075a8 <userret+0x518>
    800034d6:	ffffd097          	auipc	ra,0xffffd
    800034da:	072080e7          	jalr	114(ra) # 80000548 <panic>

00000000800034de <iput>:
{
    800034de:	7139                	addi	sp,sp,-64
    800034e0:	fc06                	sd	ra,56(sp)
    800034e2:	f822                	sd	s0,48(sp)
    800034e4:	f426                	sd	s1,40(sp)
    800034e6:	f04a                	sd	s2,32(sp)
    800034e8:	ec4e                	sd	s3,24(sp)
    800034ea:	e852                	sd	s4,16(sp)
    800034ec:	e456                	sd	s5,8(sp)
    800034ee:	0080                	addi	s0,sp,64
    800034f0:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800034f2:	0001c517          	auipc	a0,0x1c
    800034f6:	7fe50513          	addi	a0,a0,2046 # 8001fcf0 <icache>
    800034fa:	ffffd097          	auipc	ra,0xffffd
    800034fe:	5c4080e7          	jalr	1476(ra) # 80000abe <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003502:	4498                	lw	a4,8(s1)
    80003504:	4785                	li	a5,1
    80003506:	02f70663          	beq	a4,a5,80003532 <iput+0x54>
  ip->ref--;
    8000350a:	449c                	lw	a5,8(s1)
    8000350c:	37fd                	addiw	a5,a5,-1
    8000350e:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003510:	0001c517          	auipc	a0,0x1c
    80003514:	7e050513          	addi	a0,a0,2016 # 8001fcf0 <icache>
    80003518:	ffffd097          	auipc	ra,0xffffd
    8000351c:	60e080e7          	jalr	1550(ra) # 80000b26 <release>
}
    80003520:	70e2                	ld	ra,56(sp)
    80003522:	7442                	ld	s0,48(sp)
    80003524:	74a2                	ld	s1,40(sp)
    80003526:	7902                	ld	s2,32(sp)
    80003528:	69e2                	ld	s3,24(sp)
    8000352a:	6a42                	ld	s4,16(sp)
    8000352c:	6aa2                	ld	s5,8(sp)
    8000352e:	6121                	addi	sp,sp,64
    80003530:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003532:	40bc                	lw	a5,64(s1)
    80003534:	dbf9                	beqz	a5,8000350a <iput+0x2c>
    80003536:	04a49783          	lh	a5,74(s1)
    8000353a:	fbe1                	bnez	a5,8000350a <iput+0x2c>
    acquiresleep(&ip->lock);
    8000353c:	01048a13          	addi	s4,s1,16
    80003540:	8552                	mv	a0,s4
    80003542:	00001097          	auipc	ra,0x1
    80003546:	d8c080e7          	jalr	-628(ra) # 800042ce <acquiresleep>
    release(&icache.lock);
    8000354a:	0001c517          	auipc	a0,0x1c
    8000354e:	7a650513          	addi	a0,a0,1958 # 8001fcf0 <icache>
    80003552:	ffffd097          	auipc	ra,0xffffd
    80003556:	5d4080e7          	jalr	1492(ra) # 80000b26 <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000355a:	05048913          	addi	s2,s1,80
    8000355e:	08048993          	addi	s3,s1,128
    80003562:	a021                	j	8000356a <iput+0x8c>
    80003564:	0911                	addi	s2,s2,4
    80003566:	01390d63          	beq	s2,s3,80003580 <iput+0xa2>
    if(ip->addrs[i]){
    8000356a:	00092583          	lw	a1,0(s2)
    8000356e:	d9fd                	beqz	a1,80003564 <iput+0x86>
      bfree(ip->dev, ip->addrs[i]);
    80003570:	4088                	lw	a0,0(s1)
    80003572:	00000097          	auipc	ra,0x0
    80003576:	8a0080e7          	jalr	-1888(ra) # 80002e12 <bfree>
      ip->addrs[i] = 0;
    8000357a:	00092023          	sw	zero,0(s2)
    8000357e:	b7dd                	j	80003564 <iput+0x86>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003580:	0804a583          	lw	a1,128(s1)
    80003584:	ed9d                	bnez	a1,800035c2 <iput+0xe4>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003586:	0404a623          	sw	zero,76(s1)
  iupdate(ip);
    8000358a:	8526                	mv	a0,s1
    8000358c:	00000097          	auipc	ra,0x0
    80003590:	d7a080e7          	jalr	-646(ra) # 80003306 <iupdate>
    ip->type = 0;
    80003594:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003598:	8526                	mv	a0,s1
    8000359a:	00000097          	auipc	ra,0x0
    8000359e:	d6c080e7          	jalr	-660(ra) # 80003306 <iupdate>
    ip->valid = 0;
    800035a2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800035a6:	8552                	mv	a0,s4
    800035a8:	00001097          	auipc	ra,0x1
    800035ac:	d7c080e7          	jalr	-644(ra) # 80004324 <releasesleep>
    acquire(&icache.lock);
    800035b0:	0001c517          	auipc	a0,0x1c
    800035b4:	74050513          	addi	a0,a0,1856 # 8001fcf0 <icache>
    800035b8:	ffffd097          	auipc	ra,0xffffd
    800035bc:	506080e7          	jalr	1286(ra) # 80000abe <acquire>
    800035c0:	b7a9                	j	8000350a <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800035c2:	4088                	lw	a0,0(s1)
    800035c4:	fffff097          	auipc	ra,0xfffff
    800035c8:	604080e7          	jalr	1540(ra) # 80002bc8 <bread>
    800035cc:	8aaa                	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
    800035ce:	06050913          	addi	s2,a0,96
    800035d2:	46050993          	addi	s3,a0,1120
    800035d6:	a021                	j	800035de <iput+0x100>
    800035d8:	0911                	addi	s2,s2,4
    800035da:	01390b63          	beq	s2,s3,800035f0 <iput+0x112>
      if(a[j])
    800035de:	00092583          	lw	a1,0(s2)
    800035e2:	d9fd                	beqz	a1,800035d8 <iput+0xfa>
        bfree(ip->dev, a[j]);
    800035e4:	4088                	lw	a0,0(s1)
    800035e6:	00000097          	auipc	ra,0x0
    800035ea:	82c080e7          	jalr	-2004(ra) # 80002e12 <bfree>
    800035ee:	b7ed                	j	800035d8 <iput+0xfa>
    brelse(bp);
    800035f0:	8556                	mv	a0,s5
    800035f2:	fffff097          	auipc	ra,0xfffff
    800035f6:	70a080e7          	jalr	1802(ra) # 80002cfc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800035fa:	0804a583          	lw	a1,128(s1)
    800035fe:	4088                	lw	a0,0(s1)
    80003600:	00000097          	auipc	ra,0x0
    80003604:	812080e7          	jalr	-2030(ra) # 80002e12 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003608:	0804a023          	sw	zero,128(s1)
    8000360c:	bfad                	j	80003586 <iput+0xa8>

000000008000360e <iunlockput>:
{
    8000360e:	1101                	addi	sp,sp,-32
    80003610:	ec06                	sd	ra,24(sp)
    80003612:	e822                	sd	s0,16(sp)
    80003614:	e426                	sd	s1,8(sp)
    80003616:	1000                	addi	s0,sp,32
    80003618:	84aa                	mv	s1,a0
  iunlock(ip);
    8000361a:	00000097          	auipc	ra,0x0
    8000361e:	e78080e7          	jalr	-392(ra) # 80003492 <iunlock>
  iput(ip);
    80003622:	8526                	mv	a0,s1
    80003624:	00000097          	auipc	ra,0x0
    80003628:	eba080e7          	jalr	-326(ra) # 800034de <iput>
}
    8000362c:	60e2                	ld	ra,24(sp)
    8000362e:	6442                	ld	s0,16(sp)
    80003630:	64a2                	ld	s1,8(sp)
    80003632:	6105                	addi	sp,sp,32
    80003634:	8082                	ret

0000000080003636 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003636:	1141                	addi	sp,sp,-16
    80003638:	e422                	sd	s0,8(sp)
    8000363a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000363c:	411c                	lw	a5,0(a0)
    8000363e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003640:	415c                	lw	a5,4(a0)
    80003642:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003644:	04451783          	lh	a5,68(a0)
    80003648:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000364c:	04a51783          	lh	a5,74(a0)
    80003650:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003654:	04c56783          	lwu	a5,76(a0)
    80003658:	e99c                	sd	a5,16(a1)
}
    8000365a:	6422                	ld	s0,8(sp)
    8000365c:	0141                	addi	sp,sp,16
    8000365e:	8082                	ret

0000000080003660 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003660:	457c                	lw	a5,76(a0)
    80003662:	0ed7e563          	bltu	a5,a3,8000374c <readi+0xec>
{
    80003666:	7159                	addi	sp,sp,-112
    80003668:	f486                	sd	ra,104(sp)
    8000366a:	f0a2                	sd	s0,96(sp)
    8000366c:	eca6                	sd	s1,88(sp)
    8000366e:	e8ca                	sd	s2,80(sp)
    80003670:	e4ce                	sd	s3,72(sp)
    80003672:	e0d2                	sd	s4,64(sp)
    80003674:	fc56                	sd	s5,56(sp)
    80003676:	f85a                	sd	s6,48(sp)
    80003678:	f45e                	sd	s7,40(sp)
    8000367a:	f062                	sd	s8,32(sp)
    8000367c:	ec66                	sd	s9,24(sp)
    8000367e:	e86a                	sd	s10,16(sp)
    80003680:	e46e                	sd	s11,8(sp)
    80003682:	1880                	addi	s0,sp,112
    80003684:	8baa                	mv	s7,a0
    80003686:	8c2e                	mv	s8,a1
    80003688:	8ab2                	mv	s5,a2
    8000368a:	8936                	mv	s2,a3
    8000368c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000368e:	9f35                	addw	a4,a4,a3
    80003690:	0cd76063          	bltu	a4,a3,80003750 <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    80003694:	00e7f463          	bgeu	a5,a4,8000369c <readi+0x3c>
    n = ip->size - off;
    80003698:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000369c:	080b0763          	beqz	s6,8000372a <readi+0xca>
    800036a0:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800036a2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800036a6:	5cfd                	li	s9,-1
    800036a8:	a82d                	j	800036e2 <readi+0x82>
    800036aa:	02099d93          	slli	s11,s3,0x20
    800036ae:	020ddd93          	srli	s11,s11,0x20
    800036b2:	06048793          	addi	a5,s1,96
    800036b6:	86ee                	mv	a3,s11
    800036b8:	963e                	add	a2,a2,a5
    800036ba:	85d6                	mv	a1,s5
    800036bc:	8562                	mv	a0,s8
    800036be:	fffff097          	auipc	ra,0xfffff
    800036c2:	b8a080e7          	jalr	-1142(ra) # 80002248 <either_copyout>
    800036c6:	05950d63          	beq	a0,s9,80003720 <readi+0xc0>
      brelse(bp);
      break;
    }
    brelse(bp);
    800036ca:	8526                	mv	a0,s1
    800036cc:	fffff097          	auipc	ra,0xfffff
    800036d0:	630080e7          	jalr	1584(ra) # 80002cfc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800036d4:	01498a3b          	addw	s4,s3,s4
    800036d8:	0129893b          	addw	s2,s3,s2
    800036dc:	9aee                	add	s5,s5,s11
    800036de:	056a7663          	bgeu	s4,s6,8000372a <readi+0xca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800036e2:	000ba483          	lw	s1,0(s7)
    800036e6:	00a9559b          	srliw	a1,s2,0xa
    800036ea:	855e                	mv	a0,s7
    800036ec:	00000097          	auipc	ra,0x0
    800036f0:	8d4080e7          	jalr	-1836(ra) # 80002fc0 <bmap>
    800036f4:	0005059b          	sext.w	a1,a0
    800036f8:	8526                	mv	a0,s1
    800036fa:	fffff097          	auipc	ra,0xfffff
    800036fe:	4ce080e7          	jalr	1230(ra) # 80002bc8 <bread>
    80003702:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003704:	3ff97613          	andi	a2,s2,1023
    80003708:	40cd07bb          	subw	a5,s10,a2
    8000370c:	414b073b          	subw	a4,s6,s4
    80003710:	89be                	mv	s3,a5
    80003712:	2781                	sext.w	a5,a5
    80003714:	0007069b          	sext.w	a3,a4
    80003718:	f8f6f9e3          	bgeu	a3,a5,800036aa <readi+0x4a>
    8000371c:	89ba                	mv	s3,a4
    8000371e:	b771                	j	800036aa <readi+0x4a>
      brelse(bp);
    80003720:	8526                	mv	a0,s1
    80003722:	fffff097          	auipc	ra,0xfffff
    80003726:	5da080e7          	jalr	1498(ra) # 80002cfc <brelse>
  }
  return n;
    8000372a:	000b051b          	sext.w	a0,s6
}
    8000372e:	70a6                	ld	ra,104(sp)
    80003730:	7406                	ld	s0,96(sp)
    80003732:	64e6                	ld	s1,88(sp)
    80003734:	6946                	ld	s2,80(sp)
    80003736:	69a6                	ld	s3,72(sp)
    80003738:	6a06                	ld	s4,64(sp)
    8000373a:	7ae2                	ld	s5,56(sp)
    8000373c:	7b42                	ld	s6,48(sp)
    8000373e:	7ba2                	ld	s7,40(sp)
    80003740:	7c02                	ld	s8,32(sp)
    80003742:	6ce2                	ld	s9,24(sp)
    80003744:	6d42                	ld	s10,16(sp)
    80003746:	6da2                	ld	s11,8(sp)
    80003748:	6165                	addi	sp,sp,112
    8000374a:	8082                	ret
    return -1;
    8000374c:	557d                	li	a0,-1
}
    8000374e:	8082                	ret
    return -1;
    80003750:	557d                	li	a0,-1
    80003752:	bff1                	j	8000372e <readi+0xce>

0000000080003754 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003754:	457c                	lw	a5,76(a0)
    80003756:	10d7e763          	bltu	a5,a3,80003864 <writei+0x110>
{
    8000375a:	7159                	addi	sp,sp,-112
    8000375c:	f486                	sd	ra,104(sp)
    8000375e:	f0a2                	sd	s0,96(sp)
    80003760:	eca6                	sd	s1,88(sp)
    80003762:	e8ca                	sd	s2,80(sp)
    80003764:	e4ce                	sd	s3,72(sp)
    80003766:	e0d2                	sd	s4,64(sp)
    80003768:	fc56                	sd	s5,56(sp)
    8000376a:	f85a                	sd	s6,48(sp)
    8000376c:	f45e                	sd	s7,40(sp)
    8000376e:	f062                	sd	s8,32(sp)
    80003770:	ec66                	sd	s9,24(sp)
    80003772:	e86a                	sd	s10,16(sp)
    80003774:	e46e                	sd	s11,8(sp)
    80003776:	1880                	addi	s0,sp,112
    80003778:	8baa                	mv	s7,a0
    8000377a:	8c2e                	mv	s8,a1
    8000377c:	8ab2                	mv	s5,a2
    8000377e:	8936                	mv	s2,a3
    80003780:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003782:	00e687bb          	addw	a5,a3,a4
    80003786:	0ed7e163          	bltu	a5,a3,80003868 <writei+0x114>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000378a:	00043737          	lui	a4,0x43
    8000378e:	0cf76f63          	bltu	a4,a5,8000386c <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003792:	0a0b0063          	beqz	s6,80003832 <writei+0xde>
    80003796:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003798:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000379c:	5cfd                	li	s9,-1
    8000379e:	a091                	j	800037e2 <writei+0x8e>
    800037a0:	02099d93          	slli	s11,s3,0x20
    800037a4:	020ddd93          	srli	s11,s11,0x20
    800037a8:	06048793          	addi	a5,s1,96
    800037ac:	86ee                	mv	a3,s11
    800037ae:	8656                	mv	a2,s5
    800037b0:	85e2                	mv	a1,s8
    800037b2:	953e                	add	a0,a0,a5
    800037b4:	fffff097          	auipc	ra,0xfffff
    800037b8:	aea080e7          	jalr	-1302(ra) # 8000229e <either_copyin>
    800037bc:	07950263          	beq	a0,s9,80003820 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800037c0:	8526                	mv	a0,s1
    800037c2:	00001097          	auipc	ra,0x1
    800037c6:	874080e7          	jalr	-1932(ra) # 80004036 <log_write>
    brelse(bp);
    800037ca:	8526                	mv	a0,s1
    800037cc:	fffff097          	auipc	ra,0xfffff
    800037d0:	530080e7          	jalr	1328(ra) # 80002cfc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800037d4:	01498a3b          	addw	s4,s3,s4
    800037d8:	0129893b          	addw	s2,s3,s2
    800037dc:	9aee                	add	s5,s5,s11
    800037de:	056a7663          	bgeu	s4,s6,8000382a <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800037e2:	000ba483          	lw	s1,0(s7)
    800037e6:	00a9559b          	srliw	a1,s2,0xa
    800037ea:	855e                	mv	a0,s7
    800037ec:	fffff097          	auipc	ra,0xfffff
    800037f0:	7d4080e7          	jalr	2004(ra) # 80002fc0 <bmap>
    800037f4:	0005059b          	sext.w	a1,a0
    800037f8:	8526                	mv	a0,s1
    800037fa:	fffff097          	auipc	ra,0xfffff
    800037fe:	3ce080e7          	jalr	974(ra) # 80002bc8 <bread>
    80003802:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003804:	3ff97513          	andi	a0,s2,1023
    80003808:	40ad07bb          	subw	a5,s10,a0
    8000380c:	414b073b          	subw	a4,s6,s4
    80003810:	89be                	mv	s3,a5
    80003812:	2781                	sext.w	a5,a5
    80003814:	0007069b          	sext.w	a3,a4
    80003818:	f8f6f4e3          	bgeu	a3,a5,800037a0 <writei+0x4c>
    8000381c:	89ba                	mv	s3,a4
    8000381e:	b749                	j	800037a0 <writei+0x4c>
      brelse(bp);
    80003820:	8526                	mv	a0,s1
    80003822:	fffff097          	auipc	ra,0xfffff
    80003826:	4da080e7          	jalr	1242(ra) # 80002cfc <brelse>
  }

  if(n > 0 && off > ip->size){
    8000382a:	04cba783          	lw	a5,76(s7)
    8000382e:	0327e363          	bltu	a5,s2,80003854 <writei+0x100>
    ip->size = off;
    iupdate(ip);
  }
  return n;
    80003832:	000b051b          	sext.w	a0,s6
}
    80003836:	70a6                	ld	ra,104(sp)
    80003838:	7406                	ld	s0,96(sp)
    8000383a:	64e6                	ld	s1,88(sp)
    8000383c:	6946                	ld	s2,80(sp)
    8000383e:	69a6                	ld	s3,72(sp)
    80003840:	6a06                	ld	s4,64(sp)
    80003842:	7ae2                	ld	s5,56(sp)
    80003844:	7b42                	ld	s6,48(sp)
    80003846:	7ba2                	ld	s7,40(sp)
    80003848:	7c02                	ld	s8,32(sp)
    8000384a:	6ce2                	ld	s9,24(sp)
    8000384c:	6d42                	ld	s10,16(sp)
    8000384e:	6da2                	ld	s11,8(sp)
    80003850:	6165                	addi	sp,sp,112
    80003852:	8082                	ret
    ip->size = off;
    80003854:	052ba623          	sw	s2,76(s7)
    iupdate(ip);
    80003858:	855e                	mv	a0,s7
    8000385a:	00000097          	auipc	ra,0x0
    8000385e:	aac080e7          	jalr	-1364(ra) # 80003306 <iupdate>
    80003862:	bfc1                	j	80003832 <writei+0xde>
    return -1;
    80003864:	557d                	li	a0,-1
}
    80003866:	8082                	ret
    return -1;
    80003868:	557d                	li	a0,-1
    8000386a:	b7f1                	j	80003836 <writei+0xe2>
    return -1;
    8000386c:	557d                	li	a0,-1
    8000386e:	b7e1                	j	80003836 <writei+0xe2>

0000000080003870 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003870:	1141                	addi	sp,sp,-16
    80003872:	e406                	sd	ra,8(sp)
    80003874:	e022                	sd	s0,0(sp)
    80003876:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003878:	4639                	li	a2,14
    8000387a:	ffffd097          	auipc	ra,0xffffd
    8000387e:	3e0080e7          	jalr	992(ra) # 80000c5a <strncmp>
}
    80003882:	60a2                	ld	ra,8(sp)
    80003884:	6402                	ld	s0,0(sp)
    80003886:	0141                	addi	sp,sp,16
    80003888:	8082                	ret

000000008000388a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000388a:	7139                	addi	sp,sp,-64
    8000388c:	fc06                	sd	ra,56(sp)
    8000388e:	f822                	sd	s0,48(sp)
    80003890:	f426                	sd	s1,40(sp)
    80003892:	f04a                	sd	s2,32(sp)
    80003894:	ec4e                	sd	s3,24(sp)
    80003896:	e852                	sd	s4,16(sp)
    80003898:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000389a:	04451703          	lh	a4,68(a0)
    8000389e:	4785                	li	a5,1
    800038a0:	00f71a63          	bne	a4,a5,800038b4 <dirlookup+0x2a>
    800038a4:	892a                	mv	s2,a0
    800038a6:	89ae                	mv	s3,a1
    800038a8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800038aa:	457c                	lw	a5,76(a0)
    800038ac:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800038ae:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038b0:	e79d                	bnez	a5,800038de <dirlookup+0x54>
    800038b2:	a8a5                	j	8000392a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800038b4:	00004517          	auipc	a0,0x4
    800038b8:	cfc50513          	addi	a0,a0,-772 # 800075b0 <userret+0x520>
    800038bc:	ffffd097          	auipc	ra,0xffffd
    800038c0:	c8c080e7          	jalr	-884(ra) # 80000548 <panic>
      panic("dirlookup read");
    800038c4:	00004517          	auipc	a0,0x4
    800038c8:	d0450513          	addi	a0,a0,-764 # 800075c8 <userret+0x538>
    800038cc:	ffffd097          	auipc	ra,0xffffd
    800038d0:	c7c080e7          	jalr	-900(ra) # 80000548 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038d4:	24c1                	addiw	s1,s1,16
    800038d6:	04c92783          	lw	a5,76(s2)
    800038da:	04f4f763          	bgeu	s1,a5,80003928 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800038de:	4741                	li	a4,16
    800038e0:	86a6                	mv	a3,s1
    800038e2:	fc040613          	addi	a2,s0,-64
    800038e6:	4581                	li	a1,0
    800038e8:	854a                	mv	a0,s2
    800038ea:	00000097          	auipc	ra,0x0
    800038ee:	d76080e7          	jalr	-650(ra) # 80003660 <readi>
    800038f2:	47c1                	li	a5,16
    800038f4:	fcf518e3          	bne	a0,a5,800038c4 <dirlookup+0x3a>
    if(de.inum == 0)
    800038f8:	fc045783          	lhu	a5,-64(s0)
    800038fc:	dfe1                	beqz	a5,800038d4 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800038fe:	fc240593          	addi	a1,s0,-62
    80003902:	854e                	mv	a0,s3
    80003904:	00000097          	auipc	ra,0x0
    80003908:	f6c080e7          	jalr	-148(ra) # 80003870 <namecmp>
    8000390c:	f561                	bnez	a0,800038d4 <dirlookup+0x4a>
      if(poff)
    8000390e:	000a0463          	beqz	s4,80003916 <dirlookup+0x8c>
        *poff = off;
    80003912:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003916:	fc045583          	lhu	a1,-64(s0)
    8000391a:	00092503          	lw	a0,0(s2)
    8000391e:	fffff097          	auipc	ra,0xfffff
    80003922:	77e080e7          	jalr	1918(ra) # 8000309c <iget>
    80003926:	a011                	j	8000392a <dirlookup+0xa0>
  return 0;
    80003928:	4501                	li	a0,0
}
    8000392a:	70e2                	ld	ra,56(sp)
    8000392c:	7442                	ld	s0,48(sp)
    8000392e:	74a2                	ld	s1,40(sp)
    80003930:	7902                	ld	s2,32(sp)
    80003932:	69e2                	ld	s3,24(sp)
    80003934:	6a42                	ld	s4,16(sp)
    80003936:	6121                	addi	sp,sp,64
    80003938:	8082                	ret

000000008000393a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000393a:	711d                	addi	sp,sp,-96
    8000393c:	ec86                	sd	ra,88(sp)
    8000393e:	e8a2                	sd	s0,80(sp)
    80003940:	e4a6                	sd	s1,72(sp)
    80003942:	e0ca                	sd	s2,64(sp)
    80003944:	fc4e                	sd	s3,56(sp)
    80003946:	f852                	sd	s4,48(sp)
    80003948:	f456                	sd	s5,40(sp)
    8000394a:	f05a                	sd	s6,32(sp)
    8000394c:	ec5e                	sd	s7,24(sp)
    8000394e:	e862                	sd	s8,16(sp)
    80003950:	e466                	sd	s9,8(sp)
    80003952:	1080                	addi	s0,sp,96
    80003954:	84aa                	mv	s1,a0
    80003956:	8aae                	mv	s5,a1
    80003958:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000395a:	00054703          	lbu	a4,0(a0)
    8000395e:	02f00793          	li	a5,47
    80003962:	02f70363          	beq	a4,a5,80003988 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003966:	ffffe097          	auipc	ra,0xffffe
    8000396a:	eb8080e7          	jalr	-328(ra) # 8000181e <myproc>
    8000396e:	14853503          	ld	a0,328(a0)
    80003972:	00000097          	auipc	ra,0x0
    80003976:	a20080e7          	jalr	-1504(ra) # 80003392 <idup>
    8000397a:	89aa                	mv	s3,a0
  while(*path == '/')
    8000397c:	02f00913          	li	s2,47
  len = path - s;
    80003980:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003982:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003984:	4b85                	li	s7,1
    80003986:	a865                	j	80003a3e <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003988:	4585                	li	a1,1
    8000398a:	4501                	li	a0,0
    8000398c:	fffff097          	auipc	ra,0xfffff
    80003990:	710080e7          	jalr	1808(ra) # 8000309c <iget>
    80003994:	89aa                	mv	s3,a0
    80003996:	b7dd                	j	8000397c <namex+0x42>
      iunlockput(ip);
    80003998:	854e                	mv	a0,s3
    8000399a:	00000097          	auipc	ra,0x0
    8000399e:	c74080e7          	jalr	-908(ra) # 8000360e <iunlockput>
      return 0;
    800039a2:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800039a4:	854e                	mv	a0,s3
    800039a6:	60e6                	ld	ra,88(sp)
    800039a8:	6446                	ld	s0,80(sp)
    800039aa:	64a6                	ld	s1,72(sp)
    800039ac:	6906                	ld	s2,64(sp)
    800039ae:	79e2                	ld	s3,56(sp)
    800039b0:	7a42                	ld	s4,48(sp)
    800039b2:	7aa2                	ld	s5,40(sp)
    800039b4:	7b02                	ld	s6,32(sp)
    800039b6:	6be2                	ld	s7,24(sp)
    800039b8:	6c42                	ld	s8,16(sp)
    800039ba:	6ca2                	ld	s9,8(sp)
    800039bc:	6125                	addi	sp,sp,96
    800039be:	8082                	ret
      iunlock(ip);
    800039c0:	854e                	mv	a0,s3
    800039c2:	00000097          	auipc	ra,0x0
    800039c6:	ad0080e7          	jalr	-1328(ra) # 80003492 <iunlock>
      return ip;
    800039ca:	bfe9                	j	800039a4 <namex+0x6a>
      iunlockput(ip);
    800039cc:	854e                	mv	a0,s3
    800039ce:	00000097          	auipc	ra,0x0
    800039d2:	c40080e7          	jalr	-960(ra) # 8000360e <iunlockput>
      return 0;
    800039d6:	89e6                	mv	s3,s9
    800039d8:	b7f1                	j	800039a4 <namex+0x6a>
  len = path - s;
    800039da:	40b48633          	sub	a2,s1,a1
    800039de:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800039e2:	099c5463          	bge	s8,s9,80003a6a <namex+0x130>
    memmove(name, s, DIRSIZ);
    800039e6:	4639                	li	a2,14
    800039e8:	8552                	mv	a0,s4
    800039ea:	ffffd097          	auipc	ra,0xffffd
    800039ee:	1f4080e7          	jalr	500(ra) # 80000bde <memmove>
  while(*path == '/')
    800039f2:	0004c783          	lbu	a5,0(s1)
    800039f6:	01279763          	bne	a5,s2,80003a04 <namex+0xca>
    path++;
    800039fa:	0485                	addi	s1,s1,1
  while(*path == '/')
    800039fc:	0004c783          	lbu	a5,0(s1)
    80003a00:	ff278de3          	beq	a5,s2,800039fa <namex+0xc0>
    ilock(ip);
    80003a04:	854e                	mv	a0,s3
    80003a06:	00000097          	auipc	ra,0x0
    80003a0a:	9ca080e7          	jalr	-1590(ra) # 800033d0 <ilock>
    if(ip->type != T_DIR){
    80003a0e:	04499783          	lh	a5,68(s3)
    80003a12:	f97793e3          	bne	a5,s7,80003998 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003a16:	000a8563          	beqz	s5,80003a20 <namex+0xe6>
    80003a1a:	0004c783          	lbu	a5,0(s1)
    80003a1e:	d3cd                	beqz	a5,800039c0 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003a20:	865a                	mv	a2,s6
    80003a22:	85d2                	mv	a1,s4
    80003a24:	854e                	mv	a0,s3
    80003a26:	00000097          	auipc	ra,0x0
    80003a2a:	e64080e7          	jalr	-412(ra) # 8000388a <dirlookup>
    80003a2e:	8caa                	mv	s9,a0
    80003a30:	dd51                	beqz	a0,800039cc <namex+0x92>
    iunlockput(ip);
    80003a32:	854e                	mv	a0,s3
    80003a34:	00000097          	auipc	ra,0x0
    80003a38:	bda080e7          	jalr	-1062(ra) # 8000360e <iunlockput>
    ip = next;
    80003a3c:	89e6                	mv	s3,s9
  while(*path == '/')
    80003a3e:	0004c783          	lbu	a5,0(s1)
    80003a42:	05279763          	bne	a5,s2,80003a90 <namex+0x156>
    path++;
    80003a46:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a48:	0004c783          	lbu	a5,0(s1)
    80003a4c:	ff278de3          	beq	a5,s2,80003a46 <namex+0x10c>
  if(*path == 0)
    80003a50:	c79d                	beqz	a5,80003a7e <namex+0x144>
    path++;
    80003a52:	85a6                	mv	a1,s1
  len = path - s;
    80003a54:	8cda                	mv	s9,s6
    80003a56:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003a58:	01278963          	beq	a5,s2,80003a6a <namex+0x130>
    80003a5c:	dfbd                	beqz	a5,800039da <namex+0xa0>
    path++;
    80003a5e:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003a60:	0004c783          	lbu	a5,0(s1)
    80003a64:	ff279ce3          	bne	a5,s2,80003a5c <namex+0x122>
    80003a68:	bf8d                	j	800039da <namex+0xa0>
    memmove(name, s, len);
    80003a6a:	2601                	sext.w	a2,a2
    80003a6c:	8552                	mv	a0,s4
    80003a6e:	ffffd097          	auipc	ra,0xffffd
    80003a72:	170080e7          	jalr	368(ra) # 80000bde <memmove>
    name[len] = 0;
    80003a76:	9cd2                	add	s9,s9,s4
    80003a78:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003a7c:	bf9d                	j	800039f2 <namex+0xb8>
  if(nameiparent){
    80003a7e:	f20a83e3          	beqz	s5,800039a4 <namex+0x6a>
    iput(ip);
    80003a82:	854e                	mv	a0,s3
    80003a84:	00000097          	auipc	ra,0x0
    80003a88:	a5a080e7          	jalr	-1446(ra) # 800034de <iput>
    return 0;
    80003a8c:	4981                	li	s3,0
    80003a8e:	bf19                	j	800039a4 <namex+0x6a>
  if(*path == 0)
    80003a90:	d7fd                	beqz	a5,80003a7e <namex+0x144>
  while(*path != '/' && *path != 0)
    80003a92:	0004c783          	lbu	a5,0(s1)
    80003a96:	85a6                	mv	a1,s1
    80003a98:	b7d1                	j	80003a5c <namex+0x122>

0000000080003a9a <dirlink>:
{
    80003a9a:	7139                	addi	sp,sp,-64
    80003a9c:	fc06                	sd	ra,56(sp)
    80003a9e:	f822                	sd	s0,48(sp)
    80003aa0:	f426                	sd	s1,40(sp)
    80003aa2:	f04a                	sd	s2,32(sp)
    80003aa4:	ec4e                	sd	s3,24(sp)
    80003aa6:	e852                	sd	s4,16(sp)
    80003aa8:	0080                	addi	s0,sp,64
    80003aaa:	892a                	mv	s2,a0
    80003aac:	8a2e                	mv	s4,a1
    80003aae:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003ab0:	4601                	li	a2,0
    80003ab2:	00000097          	auipc	ra,0x0
    80003ab6:	dd8080e7          	jalr	-552(ra) # 8000388a <dirlookup>
    80003aba:	e93d                	bnez	a0,80003b30 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003abc:	04c92483          	lw	s1,76(s2)
    80003ac0:	c49d                	beqz	s1,80003aee <dirlink+0x54>
    80003ac2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ac4:	4741                	li	a4,16
    80003ac6:	86a6                	mv	a3,s1
    80003ac8:	fc040613          	addi	a2,s0,-64
    80003acc:	4581                	li	a1,0
    80003ace:	854a                	mv	a0,s2
    80003ad0:	00000097          	auipc	ra,0x0
    80003ad4:	b90080e7          	jalr	-1136(ra) # 80003660 <readi>
    80003ad8:	47c1                	li	a5,16
    80003ada:	06f51163          	bne	a0,a5,80003b3c <dirlink+0xa2>
    if(de.inum == 0)
    80003ade:	fc045783          	lhu	a5,-64(s0)
    80003ae2:	c791                	beqz	a5,80003aee <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ae4:	24c1                	addiw	s1,s1,16
    80003ae6:	04c92783          	lw	a5,76(s2)
    80003aea:	fcf4ede3          	bltu	s1,a5,80003ac4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003aee:	4639                	li	a2,14
    80003af0:	85d2                	mv	a1,s4
    80003af2:	fc240513          	addi	a0,s0,-62
    80003af6:	ffffd097          	auipc	ra,0xffffd
    80003afa:	1a0080e7          	jalr	416(ra) # 80000c96 <strncpy>
  de.inum = inum;
    80003afe:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b02:	4741                	li	a4,16
    80003b04:	86a6                	mv	a3,s1
    80003b06:	fc040613          	addi	a2,s0,-64
    80003b0a:	4581                	li	a1,0
    80003b0c:	854a                	mv	a0,s2
    80003b0e:	00000097          	auipc	ra,0x0
    80003b12:	c46080e7          	jalr	-954(ra) # 80003754 <writei>
    80003b16:	872a                	mv	a4,a0
    80003b18:	47c1                	li	a5,16
  return 0;
    80003b1a:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b1c:	02f71863          	bne	a4,a5,80003b4c <dirlink+0xb2>
}
    80003b20:	70e2                	ld	ra,56(sp)
    80003b22:	7442                	ld	s0,48(sp)
    80003b24:	74a2                	ld	s1,40(sp)
    80003b26:	7902                	ld	s2,32(sp)
    80003b28:	69e2                	ld	s3,24(sp)
    80003b2a:	6a42                	ld	s4,16(sp)
    80003b2c:	6121                	addi	sp,sp,64
    80003b2e:	8082                	ret
    iput(ip);
    80003b30:	00000097          	auipc	ra,0x0
    80003b34:	9ae080e7          	jalr	-1618(ra) # 800034de <iput>
    return -1;
    80003b38:	557d                	li	a0,-1
    80003b3a:	b7dd                	j	80003b20 <dirlink+0x86>
      panic("dirlink read");
    80003b3c:	00004517          	auipc	a0,0x4
    80003b40:	a9c50513          	addi	a0,a0,-1380 # 800075d8 <userret+0x548>
    80003b44:	ffffd097          	auipc	ra,0xffffd
    80003b48:	a04080e7          	jalr	-1532(ra) # 80000548 <panic>
    panic("dirlink");
    80003b4c:	00004517          	auipc	a0,0x4
    80003b50:	c3c50513          	addi	a0,a0,-964 # 80007788 <userret+0x6f8>
    80003b54:	ffffd097          	auipc	ra,0xffffd
    80003b58:	9f4080e7          	jalr	-1548(ra) # 80000548 <panic>

0000000080003b5c <namei>:

struct inode*
namei(char *path)
{
    80003b5c:	1101                	addi	sp,sp,-32
    80003b5e:	ec06                	sd	ra,24(sp)
    80003b60:	e822                	sd	s0,16(sp)
    80003b62:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003b64:	fe040613          	addi	a2,s0,-32
    80003b68:	4581                	li	a1,0
    80003b6a:	00000097          	auipc	ra,0x0
    80003b6e:	dd0080e7          	jalr	-560(ra) # 8000393a <namex>
}
    80003b72:	60e2                	ld	ra,24(sp)
    80003b74:	6442                	ld	s0,16(sp)
    80003b76:	6105                	addi	sp,sp,32
    80003b78:	8082                	ret

0000000080003b7a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003b7a:	1141                	addi	sp,sp,-16
    80003b7c:	e406                	sd	ra,8(sp)
    80003b7e:	e022                	sd	s0,0(sp)
    80003b80:	0800                	addi	s0,sp,16
    80003b82:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003b84:	4585                	li	a1,1
    80003b86:	00000097          	auipc	ra,0x0
    80003b8a:	db4080e7          	jalr	-588(ra) # 8000393a <namex>
}
    80003b8e:	60a2                	ld	ra,8(sp)
    80003b90:	6402                	ld	s0,0(sp)
    80003b92:	0141                	addi	sp,sp,16
    80003b94:	8082                	ret

0000000080003b96 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(int dev)
{
    80003b96:	7179                	addi	sp,sp,-48
    80003b98:	f406                	sd	ra,40(sp)
    80003b9a:	f022                	sd	s0,32(sp)
    80003b9c:	ec26                	sd	s1,24(sp)
    80003b9e:	e84a                	sd	s2,16(sp)
    80003ba0:	e44e                	sd	s3,8(sp)
    80003ba2:	1800                	addi	s0,sp,48
    80003ba4:	84aa                	mv	s1,a0
  struct buf *buf = bread(dev, log[dev].start);
    80003ba6:	0a800993          	li	s3,168
    80003baa:	033507b3          	mul	a5,a0,s3
    80003bae:	0001e997          	auipc	s3,0x1e
    80003bb2:	bea98993          	addi	s3,s3,-1046 # 80021798 <log>
    80003bb6:	99be                	add	s3,s3,a5
    80003bb8:	0189a583          	lw	a1,24(s3)
    80003bbc:	fffff097          	auipc	ra,0xfffff
    80003bc0:	00c080e7          	jalr	12(ra) # 80002bc8 <bread>
    80003bc4:	892a                	mv	s2,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log[dev].lh.n;
    80003bc6:	02c9a783          	lw	a5,44(s3)
    80003bca:	d13c                	sw	a5,96(a0)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003bcc:	02c9a783          	lw	a5,44(s3)
    80003bd0:	02f05763          	blez	a5,80003bfe <write_head+0x68>
    80003bd4:	0a800793          	li	a5,168
    80003bd8:	02f487b3          	mul	a5,s1,a5
    80003bdc:	0001e717          	auipc	a4,0x1e
    80003be0:	bec70713          	addi	a4,a4,-1044 # 800217c8 <log+0x30>
    80003be4:	97ba                	add	a5,a5,a4
    80003be6:	06450693          	addi	a3,a0,100
    80003bea:	4701                	li	a4,0
    80003bec:	85ce                	mv	a1,s3
    hb->block[i] = log[dev].lh.block[i];
    80003bee:	4390                	lw	a2,0(a5)
    80003bf0:	c290                	sw	a2,0(a3)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003bf2:	2705                	addiw	a4,a4,1
    80003bf4:	0791                	addi	a5,a5,4
    80003bf6:	0691                	addi	a3,a3,4
    80003bf8:	55d0                	lw	a2,44(a1)
    80003bfa:	fec74ae3          	blt	a4,a2,80003bee <write_head+0x58>
  }
  bwrite(buf);
    80003bfe:	854a                	mv	a0,s2
    80003c00:	fffff097          	auipc	ra,0xfffff
    80003c04:	0bc080e7          	jalr	188(ra) # 80002cbc <bwrite>
  brelse(buf);
    80003c08:	854a                	mv	a0,s2
    80003c0a:	fffff097          	auipc	ra,0xfffff
    80003c0e:	0f2080e7          	jalr	242(ra) # 80002cfc <brelse>
}
    80003c12:	70a2                	ld	ra,40(sp)
    80003c14:	7402                	ld	s0,32(sp)
    80003c16:	64e2                	ld	s1,24(sp)
    80003c18:	6942                	ld	s2,16(sp)
    80003c1a:	69a2                	ld	s3,8(sp)
    80003c1c:	6145                	addi	sp,sp,48
    80003c1e:	8082                	ret

0000000080003c20 <write_log>:
static void
write_log(int dev)
{
  int tail;

  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003c20:	0a800793          	li	a5,168
    80003c24:	02f50733          	mul	a4,a0,a5
    80003c28:	0001e797          	auipc	a5,0x1e
    80003c2c:	b7078793          	addi	a5,a5,-1168 # 80021798 <log>
    80003c30:	97ba                	add	a5,a5,a4
    80003c32:	57dc                	lw	a5,44(a5)
    80003c34:	0af05663          	blez	a5,80003ce0 <write_log+0xc0>
{
    80003c38:	7139                	addi	sp,sp,-64
    80003c3a:	fc06                	sd	ra,56(sp)
    80003c3c:	f822                	sd	s0,48(sp)
    80003c3e:	f426                	sd	s1,40(sp)
    80003c40:	f04a                	sd	s2,32(sp)
    80003c42:	ec4e                	sd	s3,24(sp)
    80003c44:	e852                	sd	s4,16(sp)
    80003c46:	e456                	sd	s5,8(sp)
    80003c48:	e05a                	sd	s6,0(sp)
    80003c4a:	0080                	addi	s0,sp,64
    80003c4c:	0001e797          	auipc	a5,0x1e
    80003c50:	b7c78793          	addi	a5,a5,-1156 # 800217c8 <log+0x30>
    80003c54:	00f70a33          	add	s4,a4,a5
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003c58:	4981                	li	s3,0
    struct buf *to = bread(dev, log[dev].start+tail+1); // log block
    80003c5a:	00050b1b          	sext.w	s6,a0
    80003c5e:	0001ea97          	auipc	s5,0x1e
    80003c62:	b3aa8a93          	addi	s5,s5,-1222 # 80021798 <log>
    80003c66:	9aba                	add	s5,s5,a4
    80003c68:	018aa583          	lw	a1,24(s5)
    80003c6c:	013585bb          	addw	a1,a1,s3
    80003c70:	2585                	addiw	a1,a1,1
    80003c72:	855a                	mv	a0,s6
    80003c74:	fffff097          	auipc	ra,0xfffff
    80003c78:	f54080e7          	jalr	-172(ra) # 80002bc8 <bread>
    80003c7c:	84aa                	mv	s1,a0
    struct buf *from = bread(dev, log[dev].lh.block[tail]); // cache block
    80003c7e:	000a2583          	lw	a1,0(s4)
    80003c82:	855a                	mv	a0,s6
    80003c84:	fffff097          	auipc	ra,0xfffff
    80003c88:	f44080e7          	jalr	-188(ra) # 80002bc8 <bread>
    80003c8c:	892a                	mv	s2,a0
    memmove(to->data, from->data, BSIZE);
    80003c8e:	40000613          	li	a2,1024
    80003c92:	06050593          	addi	a1,a0,96
    80003c96:	06048513          	addi	a0,s1,96
    80003c9a:	ffffd097          	auipc	ra,0xffffd
    80003c9e:	f44080e7          	jalr	-188(ra) # 80000bde <memmove>
    bwrite(to);  // write the log
    80003ca2:	8526                	mv	a0,s1
    80003ca4:	fffff097          	auipc	ra,0xfffff
    80003ca8:	018080e7          	jalr	24(ra) # 80002cbc <bwrite>
    brelse(from);
    80003cac:	854a                	mv	a0,s2
    80003cae:	fffff097          	auipc	ra,0xfffff
    80003cb2:	04e080e7          	jalr	78(ra) # 80002cfc <brelse>
    brelse(to);
    80003cb6:	8526                	mv	a0,s1
    80003cb8:	fffff097          	auipc	ra,0xfffff
    80003cbc:	044080e7          	jalr	68(ra) # 80002cfc <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003cc0:	2985                	addiw	s3,s3,1
    80003cc2:	0a11                	addi	s4,s4,4
    80003cc4:	02caa783          	lw	a5,44(s5)
    80003cc8:	faf9c0e3          	blt	s3,a5,80003c68 <write_log+0x48>
  }
}
    80003ccc:	70e2                	ld	ra,56(sp)
    80003cce:	7442                	ld	s0,48(sp)
    80003cd0:	74a2                	ld	s1,40(sp)
    80003cd2:	7902                	ld	s2,32(sp)
    80003cd4:	69e2                	ld	s3,24(sp)
    80003cd6:	6a42                	ld	s4,16(sp)
    80003cd8:	6aa2                	ld	s5,8(sp)
    80003cda:	6b02                	ld	s6,0(sp)
    80003cdc:	6121                	addi	sp,sp,64
    80003cde:	8082                	ret
    80003ce0:	8082                	ret

0000000080003ce2 <install_trans>:
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003ce2:	0a800793          	li	a5,168
    80003ce6:	02f50733          	mul	a4,a0,a5
    80003cea:	0001e797          	auipc	a5,0x1e
    80003cee:	aae78793          	addi	a5,a5,-1362 # 80021798 <log>
    80003cf2:	97ba                	add	a5,a5,a4
    80003cf4:	57dc                	lw	a5,44(a5)
    80003cf6:	0af05b63          	blez	a5,80003dac <install_trans+0xca>
{
    80003cfa:	7139                	addi	sp,sp,-64
    80003cfc:	fc06                	sd	ra,56(sp)
    80003cfe:	f822                	sd	s0,48(sp)
    80003d00:	f426                	sd	s1,40(sp)
    80003d02:	f04a                	sd	s2,32(sp)
    80003d04:	ec4e                	sd	s3,24(sp)
    80003d06:	e852                	sd	s4,16(sp)
    80003d08:	e456                	sd	s5,8(sp)
    80003d0a:	e05a                	sd	s6,0(sp)
    80003d0c:	0080                	addi	s0,sp,64
    80003d0e:	0001e797          	auipc	a5,0x1e
    80003d12:	aba78793          	addi	a5,a5,-1350 # 800217c8 <log+0x30>
    80003d16:	00f70a33          	add	s4,a4,a5
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003d1a:	4981                	li	s3,0
    struct buf *lbuf = bread(dev, log[dev].start+tail+1); // read log block
    80003d1c:	00050b1b          	sext.w	s6,a0
    80003d20:	0001ea97          	auipc	s5,0x1e
    80003d24:	a78a8a93          	addi	s5,s5,-1416 # 80021798 <log>
    80003d28:	9aba                	add	s5,s5,a4
    80003d2a:	018aa583          	lw	a1,24(s5)
    80003d2e:	013585bb          	addw	a1,a1,s3
    80003d32:	2585                	addiw	a1,a1,1
    80003d34:	855a                	mv	a0,s6
    80003d36:	fffff097          	auipc	ra,0xfffff
    80003d3a:	e92080e7          	jalr	-366(ra) # 80002bc8 <bread>
    80003d3e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(dev, log[dev].lh.block[tail]); // read dst
    80003d40:	000a2583          	lw	a1,0(s4)
    80003d44:	855a                	mv	a0,s6
    80003d46:	fffff097          	auipc	ra,0xfffff
    80003d4a:	e82080e7          	jalr	-382(ra) # 80002bc8 <bread>
    80003d4e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003d50:	40000613          	li	a2,1024
    80003d54:	06090593          	addi	a1,s2,96
    80003d58:	06050513          	addi	a0,a0,96
    80003d5c:	ffffd097          	auipc	ra,0xffffd
    80003d60:	e82080e7          	jalr	-382(ra) # 80000bde <memmove>
    bwrite(dbuf);  // write dst to disk
    80003d64:	8526                	mv	a0,s1
    80003d66:	fffff097          	auipc	ra,0xfffff
    80003d6a:	f56080e7          	jalr	-170(ra) # 80002cbc <bwrite>
    bunpin(dbuf);
    80003d6e:	8526                	mv	a0,s1
    80003d70:	fffff097          	auipc	ra,0xfffff
    80003d74:	066080e7          	jalr	102(ra) # 80002dd6 <bunpin>
    brelse(lbuf);
    80003d78:	854a                	mv	a0,s2
    80003d7a:	fffff097          	auipc	ra,0xfffff
    80003d7e:	f82080e7          	jalr	-126(ra) # 80002cfc <brelse>
    brelse(dbuf);
    80003d82:	8526                	mv	a0,s1
    80003d84:	fffff097          	auipc	ra,0xfffff
    80003d88:	f78080e7          	jalr	-136(ra) # 80002cfc <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003d8c:	2985                	addiw	s3,s3,1
    80003d8e:	0a11                	addi	s4,s4,4
    80003d90:	02caa783          	lw	a5,44(s5)
    80003d94:	f8f9cbe3          	blt	s3,a5,80003d2a <install_trans+0x48>
}
    80003d98:	70e2                	ld	ra,56(sp)
    80003d9a:	7442                	ld	s0,48(sp)
    80003d9c:	74a2                	ld	s1,40(sp)
    80003d9e:	7902                	ld	s2,32(sp)
    80003da0:	69e2                	ld	s3,24(sp)
    80003da2:	6a42                	ld	s4,16(sp)
    80003da4:	6aa2                	ld	s5,8(sp)
    80003da6:	6b02                	ld	s6,0(sp)
    80003da8:	6121                	addi	sp,sp,64
    80003daa:	8082                	ret
    80003dac:	8082                	ret

0000000080003dae <initlog>:
{
    80003dae:	7179                	addi	sp,sp,-48
    80003db0:	f406                	sd	ra,40(sp)
    80003db2:	f022                	sd	s0,32(sp)
    80003db4:	ec26                	sd	s1,24(sp)
    80003db6:	e84a                	sd	s2,16(sp)
    80003db8:	e44e                	sd	s3,8(sp)
    80003dba:	e052                	sd	s4,0(sp)
    80003dbc:	1800                	addi	s0,sp,48
    80003dbe:	892a                	mv	s2,a0
    80003dc0:	8a2e                	mv	s4,a1
  initlock(&log[dev].lock, "log");
    80003dc2:	0a800713          	li	a4,168
    80003dc6:	02e504b3          	mul	s1,a0,a4
    80003dca:	0001e997          	auipc	s3,0x1e
    80003dce:	9ce98993          	addi	s3,s3,-1586 # 80021798 <log>
    80003dd2:	99a6                	add	s3,s3,s1
    80003dd4:	00004597          	auipc	a1,0x4
    80003dd8:	81458593          	addi	a1,a1,-2028 # 800075e8 <userret+0x558>
    80003ddc:	854e                	mv	a0,s3
    80003dde:	ffffd097          	auipc	ra,0xffffd
    80003de2:	bd2080e7          	jalr	-1070(ra) # 800009b0 <initlock>
  log[dev].start = sb->logstart;
    80003de6:	014a2583          	lw	a1,20(s4)
    80003dea:	00b9ac23          	sw	a1,24(s3)
  log[dev].size = sb->nlog;
    80003dee:	010a2783          	lw	a5,16(s4)
    80003df2:	00f9ae23          	sw	a5,28(s3)
  log[dev].dev = dev;
    80003df6:	0329a423          	sw	s2,40(s3)
  struct buf *buf = bread(dev, log[dev].start);
    80003dfa:	854a                	mv	a0,s2
    80003dfc:	fffff097          	auipc	ra,0xfffff
    80003e00:	dcc080e7          	jalr	-564(ra) # 80002bc8 <bread>
  log[dev].lh.n = lh->n;
    80003e04:	5134                	lw	a3,96(a0)
    80003e06:	02d9a623          	sw	a3,44(s3)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003e0a:	02d05763          	blez	a3,80003e38 <initlog+0x8a>
    80003e0e:	06450793          	addi	a5,a0,100
    80003e12:	0001e717          	auipc	a4,0x1e
    80003e16:	9b670713          	addi	a4,a4,-1610 # 800217c8 <log+0x30>
    80003e1a:	9726                	add	a4,a4,s1
    80003e1c:	36fd                	addiw	a3,a3,-1
    80003e1e:	02069613          	slli	a2,a3,0x20
    80003e22:	01e65693          	srli	a3,a2,0x1e
    80003e26:	06850613          	addi	a2,a0,104
    80003e2a:	96b2                	add	a3,a3,a2
    log[dev].lh.block[i] = lh->block[i];
    80003e2c:	4390                	lw	a2,0(a5)
    80003e2e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003e30:	0791                	addi	a5,a5,4
    80003e32:	0711                	addi	a4,a4,4
    80003e34:	fed79ce3          	bne	a5,a3,80003e2c <initlog+0x7e>
  brelse(buf);
    80003e38:	fffff097          	auipc	ra,0xfffff
    80003e3c:	ec4080e7          	jalr	-316(ra) # 80002cfc <brelse>
  install_trans(dev); // if committed, copy from log to disk
    80003e40:	854a                	mv	a0,s2
    80003e42:	00000097          	auipc	ra,0x0
    80003e46:	ea0080e7          	jalr	-352(ra) # 80003ce2 <install_trans>
  log[dev].lh.n = 0;
    80003e4a:	0a800793          	li	a5,168
    80003e4e:	02f90733          	mul	a4,s2,a5
    80003e52:	0001e797          	auipc	a5,0x1e
    80003e56:	94678793          	addi	a5,a5,-1722 # 80021798 <log>
    80003e5a:	97ba                	add	a5,a5,a4
    80003e5c:	0207a623          	sw	zero,44(a5)
  write_head(dev); // clear the log
    80003e60:	854a                	mv	a0,s2
    80003e62:	00000097          	auipc	ra,0x0
    80003e66:	d34080e7          	jalr	-716(ra) # 80003b96 <write_head>
}
    80003e6a:	70a2                	ld	ra,40(sp)
    80003e6c:	7402                	ld	s0,32(sp)
    80003e6e:	64e2                	ld	s1,24(sp)
    80003e70:	6942                	ld	s2,16(sp)
    80003e72:	69a2                	ld	s3,8(sp)
    80003e74:	6a02                	ld	s4,0(sp)
    80003e76:	6145                	addi	sp,sp,48
    80003e78:	8082                	ret

0000000080003e7a <begin_op>:
{
    80003e7a:	7139                	addi	sp,sp,-64
    80003e7c:	fc06                	sd	ra,56(sp)
    80003e7e:	f822                	sd	s0,48(sp)
    80003e80:	f426                	sd	s1,40(sp)
    80003e82:	f04a                	sd	s2,32(sp)
    80003e84:	ec4e                	sd	s3,24(sp)
    80003e86:	e852                	sd	s4,16(sp)
    80003e88:	e456                	sd	s5,8(sp)
    80003e8a:	0080                	addi	s0,sp,64
    80003e8c:	8aaa                	mv	s5,a0
  acquire(&log[dev].lock);
    80003e8e:	0a800913          	li	s2,168
    80003e92:	032507b3          	mul	a5,a0,s2
    80003e96:	0001e917          	auipc	s2,0x1e
    80003e9a:	90290913          	addi	s2,s2,-1790 # 80021798 <log>
    80003e9e:	993e                	add	s2,s2,a5
    80003ea0:	854a                	mv	a0,s2
    80003ea2:	ffffd097          	auipc	ra,0xffffd
    80003ea6:	c1c080e7          	jalr	-996(ra) # 80000abe <acquire>
    if(log[dev].committing){
    80003eaa:	0001e997          	auipc	s3,0x1e
    80003eae:	8ee98993          	addi	s3,s3,-1810 # 80021798 <log>
    80003eb2:	84ca                	mv	s1,s2
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003eb4:	4a79                	li	s4,30
    80003eb6:	a039                	j	80003ec4 <begin_op+0x4a>
      sleep(&log, &log[dev].lock);
    80003eb8:	85ca                	mv	a1,s2
    80003eba:	854e                	mv	a0,s3
    80003ebc:	ffffe097          	auipc	ra,0xffffe
    80003ec0:	16c080e7          	jalr	364(ra) # 80002028 <sleep>
    if(log[dev].committing){
    80003ec4:	50dc                	lw	a5,36(s1)
    80003ec6:	fbed                	bnez	a5,80003eb8 <begin_op+0x3e>
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ec8:	509c                	lw	a5,32(s1)
    80003eca:	0017871b          	addiw	a4,a5,1
    80003ece:	0007069b          	sext.w	a3,a4
    80003ed2:	0027179b          	slliw	a5,a4,0x2
    80003ed6:	9fb9                	addw	a5,a5,a4
    80003ed8:	0017979b          	slliw	a5,a5,0x1
    80003edc:	54d8                	lw	a4,44(s1)
    80003ede:	9fb9                	addw	a5,a5,a4
    80003ee0:	00fa5963          	bge	s4,a5,80003ef2 <begin_op+0x78>
      sleep(&log, &log[dev].lock);
    80003ee4:	85ca                	mv	a1,s2
    80003ee6:	854e                	mv	a0,s3
    80003ee8:	ffffe097          	auipc	ra,0xffffe
    80003eec:	140080e7          	jalr	320(ra) # 80002028 <sleep>
    80003ef0:	bfd1                	j	80003ec4 <begin_op+0x4a>
      log[dev].outstanding += 1;
    80003ef2:	0a800513          	li	a0,168
    80003ef6:	02aa8ab3          	mul	s5,s5,a0
    80003efa:	0001e797          	auipc	a5,0x1e
    80003efe:	89e78793          	addi	a5,a5,-1890 # 80021798 <log>
    80003f02:	9abe                	add	s5,s5,a5
    80003f04:	02daa023          	sw	a3,32(s5)
      release(&log[dev].lock);
    80003f08:	854a                	mv	a0,s2
    80003f0a:	ffffd097          	auipc	ra,0xffffd
    80003f0e:	c1c080e7          	jalr	-996(ra) # 80000b26 <release>
}
    80003f12:	70e2                	ld	ra,56(sp)
    80003f14:	7442                	ld	s0,48(sp)
    80003f16:	74a2                	ld	s1,40(sp)
    80003f18:	7902                	ld	s2,32(sp)
    80003f1a:	69e2                	ld	s3,24(sp)
    80003f1c:	6a42                	ld	s4,16(sp)
    80003f1e:	6aa2                	ld	s5,8(sp)
    80003f20:	6121                	addi	sp,sp,64
    80003f22:	8082                	ret

0000000080003f24 <end_op>:
{
    80003f24:	7179                	addi	sp,sp,-48
    80003f26:	f406                	sd	ra,40(sp)
    80003f28:	f022                	sd	s0,32(sp)
    80003f2a:	ec26                	sd	s1,24(sp)
    80003f2c:	e84a                	sd	s2,16(sp)
    80003f2e:	e44e                	sd	s3,8(sp)
    80003f30:	1800                	addi	s0,sp,48
    80003f32:	892a                	mv	s2,a0
  acquire(&log[dev].lock);
    80003f34:	0a800493          	li	s1,168
    80003f38:	029507b3          	mul	a5,a0,s1
    80003f3c:	0001e497          	auipc	s1,0x1e
    80003f40:	85c48493          	addi	s1,s1,-1956 # 80021798 <log>
    80003f44:	94be                	add	s1,s1,a5
    80003f46:	8526                	mv	a0,s1
    80003f48:	ffffd097          	auipc	ra,0xffffd
    80003f4c:	b76080e7          	jalr	-1162(ra) # 80000abe <acquire>
  log[dev].outstanding -= 1;
    80003f50:	509c                	lw	a5,32(s1)
    80003f52:	37fd                	addiw	a5,a5,-1
    80003f54:	0007871b          	sext.w	a4,a5
    80003f58:	d09c                	sw	a5,32(s1)
  if(log[dev].committing)
    80003f5a:	50dc                	lw	a5,36(s1)
    80003f5c:	e3ad                	bnez	a5,80003fbe <end_op+0x9a>
  if(log[dev].outstanding == 0){
    80003f5e:	eb25                	bnez	a4,80003fce <end_op+0xaa>
    log[dev].committing = 1;
    80003f60:	0a800993          	li	s3,168
    80003f64:	033907b3          	mul	a5,s2,s3
    80003f68:	0001e997          	auipc	s3,0x1e
    80003f6c:	83098993          	addi	s3,s3,-2000 # 80021798 <log>
    80003f70:	99be                	add	s3,s3,a5
    80003f72:	4785                	li	a5,1
    80003f74:	02f9a223          	sw	a5,36(s3)
  release(&log[dev].lock);
    80003f78:	8526                	mv	a0,s1
    80003f7a:	ffffd097          	auipc	ra,0xffffd
    80003f7e:	bac080e7          	jalr	-1108(ra) # 80000b26 <release>

static void
commit(int dev)
{
  if (log[dev].lh.n > 0) {
    80003f82:	02c9a783          	lw	a5,44(s3)
    80003f86:	06f04863          	bgtz	a5,80003ff6 <end_op+0xd2>
    acquire(&log[dev].lock);
    80003f8a:	8526                	mv	a0,s1
    80003f8c:	ffffd097          	auipc	ra,0xffffd
    80003f90:	b32080e7          	jalr	-1230(ra) # 80000abe <acquire>
    log[dev].committing = 0;
    80003f94:	0001e517          	auipc	a0,0x1e
    80003f98:	80450513          	addi	a0,a0,-2044 # 80021798 <log>
    80003f9c:	0a800793          	li	a5,168
    80003fa0:	02f90933          	mul	s2,s2,a5
    80003fa4:	992a                	add	s2,s2,a0
    80003fa6:	02092223          	sw	zero,36(s2)
    wakeup(&log);
    80003faa:	ffffe097          	auipc	ra,0xffffe
    80003fae:	1c4080e7          	jalr	452(ra) # 8000216e <wakeup>
    release(&log[dev].lock);
    80003fb2:	8526                	mv	a0,s1
    80003fb4:	ffffd097          	auipc	ra,0xffffd
    80003fb8:	b72080e7          	jalr	-1166(ra) # 80000b26 <release>
}
    80003fbc:	a035                	j	80003fe8 <end_op+0xc4>
    panic("log[dev].committing");
    80003fbe:	00003517          	auipc	a0,0x3
    80003fc2:	63250513          	addi	a0,a0,1586 # 800075f0 <userret+0x560>
    80003fc6:	ffffc097          	auipc	ra,0xffffc
    80003fca:	582080e7          	jalr	1410(ra) # 80000548 <panic>
    wakeup(&log);
    80003fce:	0001d517          	auipc	a0,0x1d
    80003fd2:	7ca50513          	addi	a0,a0,1994 # 80021798 <log>
    80003fd6:	ffffe097          	auipc	ra,0xffffe
    80003fda:	198080e7          	jalr	408(ra) # 8000216e <wakeup>
  release(&log[dev].lock);
    80003fde:	8526                	mv	a0,s1
    80003fe0:	ffffd097          	auipc	ra,0xffffd
    80003fe4:	b46080e7          	jalr	-1210(ra) # 80000b26 <release>
}
    80003fe8:	70a2                	ld	ra,40(sp)
    80003fea:	7402                	ld	s0,32(sp)
    80003fec:	64e2                	ld	s1,24(sp)
    80003fee:	6942                	ld	s2,16(sp)
    80003ff0:	69a2                	ld	s3,8(sp)
    80003ff2:	6145                	addi	sp,sp,48
    80003ff4:	8082                	ret
    write_log(dev);     // Write modified blocks from cache to log
    80003ff6:	854a                	mv	a0,s2
    80003ff8:	00000097          	auipc	ra,0x0
    80003ffc:	c28080e7          	jalr	-984(ra) # 80003c20 <write_log>
    write_head(dev);    // Write header to disk -- the real commit
    80004000:	854a                	mv	a0,s2
    80004002:	00000097          	auipc	ra,0x0
    80004006:	b94080e7          	jalr	-1132(ra) # 80003b96 <write_head>
    install_trans(dev); // Now install writes to home locations
    8000400a:	854a                	mv	a0,s2
    8000400c:	00000097          	auipc	ra,0x0
    80004010:	cd6080e7          	jalr	-810(ra) # 80003ce2 <install_trans>
    log[dev].lh.n = 0;
    80004014:	0a800793          	li	a5,168
    80004018:	02f90733          	mul	a4,s2,a5
    8000401c:	0001d797          	auipc	a5,0x1d
    80004020:	77c78793          	addi	a5,a5,1916 # 80021798 <log>
    80004024:	97ba                	add	a5,a5,a4
    80004026:	0207a623          	sw	zero,44(a5)
    write_head(dev);    // Erase the transaction from the log
    8000402a:	854a                	mv	a0,s2
    8000402c:	00000097          	auipc	ra,0x0
    80004030:	b6a080e7          	jalr	-1174(ra) # 80003b96 <write_head>
    80004034:	bf99                	j	80003f8a <end_op+0x66>

0000000080004036 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004036:	7179                	addi	sp,sp,-48
    80004038:	f406                	sd	ra,40(sp)
    8000403a:	f022                	sd	s0,32(sp)
    8000403c:	ec26                	sd	s1,24(sp)
    8000403e:	e84a                	sd	s2,16(sp)
    80004040:	e44e                	sd	s3,8(sp)
    80004042:	e052                	sd	s4,0(sp)
    80004044:	1800                	addi	s0,sp,48
  int i;

  int dev = b->dev;
    80004046:	00852903          	lw	s2,8(a0)
  if (log[dev].lh.n >= LOGSIZE || log[dev].lh.n >= log[dev].size - 1)
    8000404a:	0a800793          	li	a5,168
    8000404e:	02f90733          	mul	a4,s2,a5
    80004052:	0001d797          	auipc	a5,0x1d
    80004056:	74678793          	addi	a5,a5,1862 # 80021798 <log>
    8000405a:	97ba                	add	a5,a5,a4
    8000405c:	57d4                	lw	a3,44(a5)
    8000405e:	47f5                	li	a5,29
    80004060:	0ad7cc63          	blt	a5,a3,80004118 <log_write+0xe2>
    80004064:	89aa                	mv	s3,a0
    80004066:	0001d797          	auipc	a5,0x1d
    8000406a:	73278793          	addi	a5,a5,1842 # 80021798 <log>
    8000406e:	97ba                	add	a5,a5,a4
    80004070:	4fdc                	lw	a5,28(a5)
    80004072:	37fd                	addiw	a5,a5,-1
    80004074:	0af6d263          	bge	a3,a5,80004118 <log_write+0xe2>
    panic("too big a transaction");
  if (log[dev].outstanding < 1)
    80004078:	0a800793          	li	a5,168
    8000407c:	02f90733          	mul	a4,s2,a5
    80004080:	0001d797          	auipc	a5,0x1d
    80004084:	71878793          	addi	a5,a5,1816 # 80021798 <log>
    80004088:	97ba                	add	a5,a5,a4
    8000408a:	539c                	lw	a5,32(a5)
    8000408c:	08f05e63          	blez	a5,80004128 <log_write+0xf2>
    panic("log_write outside of trans");

  acquire(&log[dev].lock);
    80004090:	0a800793          	li	a5,168
    80004094:	02f904b3          	mul	s1,s2,a5
    80004098:	0001da17          	auipc	s4,0x1d
    8000409c:	700a0a13          	addi	s4,s4,1792 # 80021798 <log>
    800040a0:	9a26                	add	s4,s4,s1
    800040a2:	8552                	mv	a0,s4
    800040a4:	ffffd097          	auipc	ra,0xffffd
    800040a8:	a1a080e7          	jalr	-1510(ra) # 80000abe <acquire>
  for (i = 0; i < log[dev].lh.n; i++) {
    800040ac:	02ca2603          	lw	a2,44(s4)
    800040b0:	08c05463          	blez	a2,80004138 <log_write+0x102>
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    800040b4:	00c9a583          	lw	a1,12(s3)
    800040b8:	0001d797          	auipc	a5,0x1d
    800040bc:	71078793          	addi	a5,a5,1808 # 800217c8 <log+0x30>
    800040c0:	97a6                	add	a5,a5,s1
  for (i = 0; i < log[dev].lh.n; i++) {
    800040c2:	4701                	li	a4,0
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    800040c4:	4394                	lw	a3,0(a5)
    800040c6:	06b68a63          	beq	a3,a1,8000413a <log_write+0x104>
  for (i = 0; i < log[dev].lh.n; i++) {
    800040ca:	2705                	addiw	a4,a4,1
    800040cc:	0791                	addi	a5,a5,4
    800040ce:	fec71be3          	bne	a4,a2,800040c4 <log_write+0x8e>
      break;
  }
  log[dev].lh.block[i] = b->blockno;
    800040d2:	02a00793          	li	a5,42
    800040d6:	02f907b3          	mul	a5,s2,a5
    800040da:	97b2                	add	a5,a5,a2
    800040dc:	07a1                	addi	a5,a5,8
    800040de:	078a                	slli	a5,a5,0x2
    800040e0:	0001d717          	auipc	a4,0x1d
    800040e4:	6b870713          	addi	a4,a4,1720 # 80021798 <log>
    800040e8:	97ba                	add	a5,a5,a4
    800040ea:	00c9a703          	lw	a4,12(s3)
    800040ee:	cb98                	sw	a4,16(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    bpin(b);
    800040f0:	854e                	mv	a0,s3
    800040f2:	fffff097          	auipc	ra,0xfffff
    800040f6:	ca8080e7          	jalr	-856(ra) # 80002d9a <bpin>
    log[dev].lh.n++;
    800040fa:	0a800793          	li	a5,168
    800040fe:	02f90933          	mul	s2,s2,a5
    80004102:	0001d797          	auipc	a5,0x1d
    80004106:	69678793          	addi	a5,a5,1686 # 80021798 <log>
    8000410a:	993e                	add	s2,s2,a5
    8000410c:	02c92783          	lw	a5,44(s2)
    80004110:	2785                	addiw	a5,a5,1
    80004112:	02f92623          	sw	a5,44(s2)
    80004116:	a099                	j	8000415c <log_write+0x126>
    panic("too big a transaction");
    80004118:	00003517          	auipc	a0,0x3
    8000411c:	4f050513          	addi	a0,a0,1264 # 80007608 <userret+0x578>
    80004120:	ffffc097          	auipc	ra,0xffffc
    80004124:	428080e7          	jalr	1064(ra) # 80000548 <panic>
    panic("log_write outside of trans");
    80004128:	00003517          	auipc	a0,0x3
    8000412c:	4f850513          	addi	a0,a0,1272 # 80007620 <userret+0x590>
    80004130:	ffffc097          	auipc	ra,0xffffc
    80004134:	418080e7          	jalr	1048(ra) # 80000548 <panic>
  for (i = 0; i < log[dev].lh.n; i++) {
    80004138:	4701                	li	a4,0
  log[dev].lh.block[i] = b->blockno;
    8000413a:	02a00793          	li	a5,42
    8000413e:	02f907b3          	mul	a5,s2,a5
    80004142:	97ba                	add	a5,a5,a4
    80004144:	07a1                	addi	a5,a5,8
    80004146:	078a                	slli	a5,a5,0x2
    80004148:	0001d697          	auipc	a3,0x1d
    8000414c:	65068693          	addi	a3,a3,1616 # 80021798 <log>
    80004150:	97b6                	add	a5,a5,a3
    80004152:	00c9a683          	lw	a3,12(s3)
    80004156:	cb94                	sw	a3,16(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    80004158:	f8e60ce3          	beq	a2,a4,800040f0 <log_write+0xba>
  }
  release(&log[dev].lock);
    8000415c:	8552                	mv	a0,s4
    8000415e:	ffffd097          	auipc	ra,0xffffd
    80004162:	9c8080e7          	jalr	-1592(ra) # 80000b26 <release>
}
    80004166:	70a2                	ld	ra,40(sp)
    80004168:	7402                	ld	s0,32(sp)
    8000416a:	64e2                	ld	s1,24(sp)
    8000416c:	6942                	ld	s2,16(sp)
    8000416e:	69a2                	ld	s3,8(sp)
    80004170:	6a02                	ld	s4,0(sp)
    80004172:	6145                	addi	sp,sp,48
    80004174:	8082                	ret

0000000080004176 <crash_op>:

// crash before commit or after commit
void
crash_op(int dev, int docommit)
{
    80004176:	7179                	addi	sp,sp,-48
    80004178:	f406                	sd	ra,40(sp)
    8000417a:	f022                	sd	s0,32(sp)
    8000417c:	ec26                	sd	s1,24(sp)
    8000417e:	e84a                	sd	s2,16(sp)
    80004180:	e44e                	sd	s3,8(sp)
    80004182:	1800                	addi	s0,sp,48
    80004184:	84aa                	mv	s1,a0
    80004186:	89ae                	mv	s3,a1
  int do_commit = 0;
    
  acquire(&log[dev].lock);
    80004188:	0a800913          	li	s2,168
    8000418c:	032507b3          	mul	a5,a0,s2
    80004190:	0001d917          	auipc	s2,0x1d
    80004194:	60890913          	addi	s2,s2,1544 # 80021798 <log>
    80004198:	993e                	add	s2,s2,a5
    8000419a:	854a                	mv	a0,s2
    8000419c:	ffffd097          	auipc	ra,0xffffd
    800041a0:	922080e7          	jalr	-1758(ra) # 80000abe <acquire>

  if (dev < 0 || dev >= NDISK)
    800041a4:	0004871b          	sext.w	a4,s1
    800041a8:	4785                	li	a5,1
    800041aa:	0ae7e063          	bltu	a5,a4,8000424a <crash_op+0xd4>
    panic("end_op: invalid disk");
  if(log[dev].outstanding == 0)
    800041ae:	0a800793          	li	a5,168
    800041b2:	02f48733          	mul	a4,s1,a5
    800041b6:	0001d797          	auipc	a5,0x1d
    800041ba:	5e278793          	addi	a5,a5,1506 # 80021798 <log>
    800041be:	97ba                	add	a5,a5,a4
    800041c0:	539c                	lw	a5,32(a5)
    800041c2:	cfc1                	beqz	a5,8000425a <crash_op+0xe4>
    panic("end_op: already closed");
  log[dev].outstanding -= 1;
    800041c4:	37fd                	addiw	a5,a5,-1
    800041c6:	0007861b          	sext.w	a2,a5
    800041ca:	0a800713          	li	a4,168
    800041ce:	02e486b3          	mul	a3,s1,a4
    800041d2:	0001d717          	auipc	a4,0x1d
    800041d6:	5c670713          	addi	a4,a4,1478 # 80021798 <log>
    800041da:	9736                	add	a4,a4,a3
    800041dc:	d31c                	sw	a5,32(a4)
  if(log[dev].committing)
    800041de:	535c                	lw	a5,36(a4)
    800041e0:	e7c9                	bnez	a5,8000426a <crash_op+0xf4>
    panic("log[dev].committing");
  if(log[dev].outstanding == 0){
    800041e2:	ee41                	bnez	a2,8000427a <crash_op+0x104>
    do_commit = 1;
    log[dev].committing = 1;
    800041e4:	0a800793          	li	a5,168
    800041e8:	02f48733          	mul	a4,s1,a5
    800041ec:	0001d797          	auipc	a5,0x1d
    800041f0:	5ac78793          	addi	a5,a5,1452 # 80021798 <log>
    800041f4:	97ba                	add	a5,a5,a4
    800041f6:	4705                	li	a4,1
    800041f8:	d3d8                	sw	a4,36(a5)
  }
  
  release(&log[dev].lock);
    800041fa:	854a                	mv	a0,s2
    800041fc:	ffffd097          	auipc	ra,0xffffd
    80004200:	92a080e7          	jalr	-1750(ra) # 80000b26 <release>

  if(docommit & do_commit){
    80004204:	0019f993          	andi	s3,s3,1
    80004208:	06098e63          	beqz	s3,80004284 <crash_op+0x10e>
    printf("crash_op: commit\n");
    8000420c:	00003517          	auipc	a0,0x3
    80004210:	46450513          	addi	a0,a0,1124 # 80007670 <userret+0x5e0>
    80004214:	ffffc097          	auipc	ra,0xffffc
    80004218:	37e080e7          	jalr	894(ra) # 80000592 <printf>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.

    if (log[dev].lh.n > 0) {
    8000421c:	0a800793          	li	a5,168
    80004220:	02f48733          	mul	a4,s1,a5
    80004224:	0001d797          	auipc	a5,0x1d
    80004228:	57478793          	addi	a5,a5,1396 # 80021798 <log>
    8000422c:	97ba                	add	a5,a5,a4
    8000422e:	57dc                	lw	a5,44(a5)
    80004230:	04f05a63          	blez	a5,80004284 <crash_op+0x10e>
      write_log(dev);     // Write modified blocks from cache to log
    80004234:	8526                	mv	a0,s1
    80004236:	00000097          	auipc	ra,0x0
    8000423a:	9ea080e7          	jalr	-1558(ra) # 80003c20 <write_log>
      write_head(dev);    // Write header to disk -- the real commit
    8000423e:	8526                	mv	a0,s1
    80004240:	00000097          	auipc	ra,0x0
    80004244:	956080e7          	jalr	-1706(ra) # 80003b96 <write_head>
    80004248:	a835                	j	80004284 <crash_op+0x10e>
    panic("end_op: invalid disk");
    8000424a:	00003517          	auipc	a0,0x3
    8000424e:	3f650513          	addi	a0,a0,1014 # 80007640 <userret+0x5b0>
    80004252:	ffffc097          	auipc	ra,0xffffc
    80004256:	2f6080e7          	jalr	758(ra) # 80000548 <panic>
    panic("end_op: already closed");
    8000425a:	00003517          	auipc	a0,0x3
    8000425e:	3fe50513          	addi	a0,a0,1022 # 80007658 <userret+0x5c8>
    80004262:	ffffc097          	auipc	ra,0xffffc
    80004266:	2e6080e7          	jalr	742(ra) # 80000548 <panic>
    panic("log[dev].committing");
    8000426a:	00003517          	auipc	a0,0x3
    8000426e:	38650513          	addi	a0,a0,902 # 800075f0 <userret+0x560>
    80004272:	ffffc097          	auipc	ra,0xffffc
    80004276:	2d6080e7          	jalr	726(ra) # 80000548 <panic>
  release(&log[dev].lock);
    8000427a:	854a                	mv	a0,s2
    8000427c:	ffffd097          	auipc	ra,0xffffd
    80004280:	8aa080e7          	jalr	-1878(ra) # 80000b26 <release>
    }
  }
  panic("crashed file system; please restart xv6 and run crashtest\n");
    80004284:	00003517          	auipc	a0,0x3
    80004288:	40450513          	addi	a0,a0,1028 # 80007688 <userret+0x5f8>
    8000428c:	ffffc097          	auipc	ra,0xffffc
    80004290:	2bc080e7          	jalr	700(ra) # 80000548 <panic>

0000000080004294 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004294:	1101                	addi	sp,sp,-32
    80004296:	ec06                	sd	ra,24(sp)
    80004298:	e822                	sd	s0,16(sp)
    8000429a:	e426                	sd	s1,8(sp)
    8000429c:	e04a                	sd	s2,0(sp)
    8000429e:	1000                	addi	s0,sp,32
    800042a0:	84aa                	mv	s1,a0
    800042a2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800042a4:	00003597          	auipc	a1,0x3
    800042a8:	42458593          	addi	a1,a1,1060 # 800076c8 <userret+0x638>
    800042ac:	0521                	addi	a0,a0,8
    800042ae:	ffffc097          	auipc	ra,0xffffc
    800042b2:	702080e7          	jalr	1794(ra) # 800009b0 <initlock>
  lk->name = name;
    800042b6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800042ba:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800042be:	0204a423          	sw	zero,40(s1)
}
    800042c2:	60e2                	ld	ra,24(sp)
    800042c4:	6442                	ld	s0,16(sp)
    800042c6:	64a2                	ld	s1,8(sp)
    800042c8:	6902                	ld	s2,0(sp)
    800042ca:	6105                	addi	sp,sp,32
    800042cc:	8082                	ret

00000000800042ce <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800042ce:	1101                	addi	sp,sp,-32
    800042d0:	ec06                	sd	ra,24(sp)
    800042d2:	e822                	sd	s0,16(sp)
    800042d4:	e426                	sd	s1,8(sp)
    800042d6:	e04a                	sd	s2,0(sp)
    800042d8:	1000                	addi	s0,sp,32
    800042da:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800042dc:	00850913          	addi	s2,a0,8
    800042e0:	854a                	mv	a0,s2
    800042e2:	ffffc097          	auipc	ra,0xffffc
    800042e6:	7dc080e7          	jalr	2012(ra) # 80000abe <acquire>
  while (lk->locked) {
    800042ea:	409c                	lw	a5,0(s1)
    800042ec:	cb89                	beqz	a5,800042fe <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800042ee:	85ca                	mv	a1,s2
    800042f0:	8526                	mv	a0,s1
    800042f2:	ffffe097          	auipc	ra,0xffffe
    800042f6:	d36080e7          	jalr	-714(ra) # 80002028 <sleep>
  while (lk->locked) {
    800042fa:	409c                	lw	a5,0(s1)
    800042fc:	fbed                	bnez	a5,800042ee <acquiresleep+0x20>
  }
  lk->locked = 1;
    800042fe:	4785                	li	a5,1
    80004300:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004302:	ffffd097          	auipc	ra,0xffffd
    80004306:	51c080e7          	jalr	1308(ra) # 8000181e <myproc>
    8000430a:	595c                	lw	a5,52(a0)
    8000430c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000430e:	854a                	mv	a0,s2
    80004310:	ffffd097          	auipc	ra,0xffffd
    80004314:	816080e7          	jalr	-2026(ra) # 80000b26 <release>
}
    80004318:	60e2                	ld	ra,24(sp)
    8000431a:	6442                	ld	s0,16(sp)
    8000431c:	64a2                	ld	s1,8(sp)
    8000431e:	6902                	ld	s2,0(sp)
    80004320:	6105                	addi	sp,sp,32
    80004322:	8082                	ret

0000000080004324 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004324:	1101                	addi	sp,sp,-32
    80004326:	ec06                	sd	ra,24(sp)
    80004328:	e822                	sd	s0,16(sp)
    8000432a:	e426                	sd	s1,8(sp)
    8000432c:	e04a                	sd	s2,0(sp)
    8000432e:	1000                	addi	s0,sp,32
    80004330:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004332:	00850913          	addi	s2,a0,8
    80004336:	854a                	mv	a0,s2
    80004338:	ffffc097          	auipc	ra,0xffffc
    8000433c:	786080e7          	jalr	1926(ra) # 80000abe <acquire>
  lk->locked = 0;
    80004340:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004344:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004348:	8526                	mv	a0,s1
    8000434a:	ffffe097          	auipc	ra,0xffffe
    8000434e:	e24080e7          	jalr	-476(ra) # 8000216e <wakeup>
  release(&lk->lk);
    80004352:	854a                	mv	a0,s2
    80004354:	ffffc097          	auipc	ra,0xffffc
    80004358:	7d2080e7          	jalr	2002(ra) # 80000b26 <release>
}
    8000435c:	60e2                	ld	ra,24(sp)
    8000435e:	6442                	ld	s0,16(sp)
    80004360:	64a2                	ld	s1,8(sp)
    80004362:	6902                	ld	s2,0(sp)
    80004364:	6105                	addi	sp,sp,32
    80004366:	8082                	ret

0000000080004368 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004368:	7179                	addi	sp,sp,-48
    8000436a:	f406                	sd	ra,40(sp)
    8000436c:	f022                	sd	s0,32(sp)
    8000436e:	ec26                	sd	s1,24(sp)
    80004370:	e84a                	sd	s2,16(sp)
    80004372:	e44e                	sd	s3,8(sp)
    80004374:	1800                	addi	s0,sp,48
    80004376:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004378:	00850913          	addi	s2,a0,8
    8000437c:	854a                	mv	a0,s2
    8000437e:	ffffc097          	auipc	ra,0xffffc
    80004382:	740080e7          	jalr	1856(ra) # 80000abe <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004386:	409c                	lw	a5,0(s1)
    80004388:	ef99                	bnez	a5,800043a6 <holdingsleep+0x3e>
    8000438a:	4481                	li	s1,0
  release(&lk->lk);
    8000438c:	854a                	mv	a0,s2
    8000438e:	ffffc097          	auipc	ra,0xffffc
    80004392:	798080e7          	jalr	1944(ra) # 80000b26 <release>
  return r;
}
    80004396:	8526                	mv	a0,s1
    80004398:	70a2                	ld	ra,40(sp)
    8000439a:	7402                	ld	s0,32(sp)
    8000439c:	64e2                	ld	s1,24(sp)
    8000439e:	6942                	ld	s2,16(sp)
    800043a0:	69a2                	ld	s3,8(sp)
    800043a2:	6145                	addi	sp,sp,48
    800043a4:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800043a6:	0284a983          	lw	s3,40(s1)
    800043aa:	ffffd097          	auipc	ra,0xffffd
    800043ae:	474080e7          	jalr	1140(ra) # 8000181e <myproc>
    800043b2:	5944                	lw	s1,52(a0)
    800043b4:	413484b3          	sub	s1,s1,s3
    800043b8:	0014b493          	seqz	s1,s1
    800043bc:	bfc1                	j	8000438c <holdingsleep+0x24>

00000000800043be <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800043be:	1141                	addi	sp,sp,-16
    800043c0:	e406                	sd	ra,8(sp)
    800043c2:	e022                	sd	s0,0(sp)
    800043c4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800043c6:	00003597          	auipc	a1,0x3
    800043ca:	31258593          	addi	a1,a1,786 # 800076d8 <userret+0x648>
    800043ce:	0001d517          	auipc	a0,0x1d
    800043d2:	5ba50513          	addi	a0,a0,1466 # 80021988 <ftable>
    800043d6:	ffffc097          	auipc	ra,0xffffc
    800043da:	5da080e7          	jalr	1498(ra) # 800009b0 <initlock>
}
    800043de:	60a2                	ld	ra,8(sp)
    800043e0:	6402                	ld	s0,0(sp)
    800043e2:	0141                	addi	sp,sp,16
    800043e4:	8082                	ret

00000000800043e6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800043e6:	1101                	addi	sp,sp,-32
    800043e8:	ec06                	sd	ra,24(sp)
    800043ea:	e822                	sd	s0,16(sp)
    800043ec:	e426                	sd	s1,8(sp)
    800043ee:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800043f0:	0001d517          	auipc	a0,0x1d
    800043f4:	59850513          	addi	a0,a0,1432 # 80021988 <ftable>
    800043f8:	ffffc097          	auipc	ra,0xffffc
    800043fc:	6c6080e7          	jalr	1734(ra) # 80000abe <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004400:	0001d497          	auipc	s1,0x1d
    80004404:	5a048493          	addi	s1,s1,1440 # 800219a0 <ftable+0x18>
    80004408:	0001e717          	auipc	a4,0x1e
    8000440c:	53870713          	addi	a4,a4,1336 # 80022940 <ftable+0xfb8>
    if(f->ref == 0){
    80004410:	40dc                	lw	a5,4(s1)
    80004412:	cf99                	beqz	a5,80004430 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004414:	02848493          	addi	s1,s1,40
    80004418:	fee49ce3          	bne	s1,a4,80004410 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000441c:	0001d517          	auipc	a0,0x1d
    80004420:	56c50513          	addi	a0,a0,1388 # 80021988 <ftable>
    80004424:	ffffc097          	auipc	ra,0xffffc
    80004428:	702080e7          	jalr	1794(ra) # 80000b26 <release>
  return 0;
    8000442c:	4481                	li	s1,0
    8000442e:	a819                	j	80004444 <filealloc+0x5e>
      f->ref = 1;
    80004430:	4785                	li	a5,1
    80004432:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004434:	0001d517          	auipc	a0,0x1d
    80004438:	55450513          	addi	a0,a0,1364 # 80021988 <ftable>
    8000443c:	ffffc097          	auipc	ra,0xffffc
    80004440:	6ea080e7          	jalr	1770(ra) # 80000b26 <release>
}
    80004444:	8526                	mv	a0,s1
    80004446:	60e2                	ld	ra,24(sp)
    80004448:	6442                	ld	s0,16(sp)
    8000444a:	64a2                	ld	s1,8(sp)
    8000444c:	6105                	addi	sp,sp,32
    8000444e:	8082                	ret

0000000080004450 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004450:	1101                	addi	sp,sp,-32
    80004452:	ec06                	sd	ra,24(sp)
    80004454:	e822                	sd	s0,16(sp)
    80004456:	e426                	sd	s1,8(sp)
    80004458:	1000                	addi	s0,sp,32
    8000445a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000445c:	0001d517          	auipc	a0,0x1d
    80004460:	52c50513          	addi	a0,a0,1324 # 80021988 <ftable>
    80004464:	ffffc097          	auipc	ra,0xffffc
    80004468:	65a080e7          	jalr	1626(ra) # 80000abe <acquire>
  if(f->ref < 1)
    8000446c:	40dc                	lw	a5,4(s1)
    8000446e:	02f05263          	blez	a5,80004492 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004472:	2785                	addiw	a5,a5,1
    80004474:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004476:	0001d517          	auipc	a0,0x1d
    8000447a:	51250513          	addi	a0,a0,1298 # 80021988 <ftable>
    8000447e:	ffffc097          	auipc	ra,0xffffc
    80004482:	6a8080e7          	jalr	1704(ra) # 80000b26 <release>
  return f;
}
    80004486:	8526                	mv	a0,s1
    80004488:	60e2                	ld	ra,24(sp)
    8000448a:	6442                	ld	s0,16(sp)
    8000448c:	64a2                	ld	s1,8(sp)
    8000448e:	6105                	addi	sp,sp,32
    80004490:	8082                	ret
    panic("filedup");
    80004492:	00003517          	auipc	a0,0x3
    80004496:	24e50513          	addi	a0,a0,590 # 800076e0 <userret+0x650>
    8000449a:	ffffc097          	auipc	ra,0xffffc
    8000449e:	0ae080e7          	jalr	174(ra) # 80000548 <panic>

00000000800044a2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800044a2:	7139                	addi	sp,sp,-64
    800044a4:	fc06                	sd	ra,56(sp)
    800044a6:	f822                	sd	s0,48(sp)
    800044a8:	f426                	sd	s1,40(sp)
    800044aa:	f04a                	sd	s2,32(sp)
    800044ac:	ec4e                	sd	s3,24(sp)
    800044ae:	e852                	sd	s4,16(sp)
    800044b0:	e456                	sd	s5,8(sp)
    800044b2:	0080                	addi	s0,sp,64
    800044b4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800044b6:	0001d517          	auipc	a0,0x1d
    800044ba:	4d250513          	addi	a0,a0,1234 # 80021988 <ftable>
    800044be:	ffffc097          	auipc	ra,0xffffc
    800044c2:	600080e7          	jalr	1536(ra) # 80000abe <acquire>
  if(f->ref < 1)
    800044c6:	40dc                	lw	a5,4(s1)
    800044c8:	06f05563          	blez	a5,80004532 <fileclose+0x90>
    panic("fileclose");
  if(--f->ref > 0){
    800044cc:	37fd                	addiw	a5,a5,-1
    800044ce:	0007871b          	sext.w	a4,a5
    800044d2:	c0dc                	sw	a5,4(s1)
    800044d4:	06e04763          	bgtz	a4,80004542 <fileclose+0xa0>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800044d8:	0004a903          	lw	s2,0(s1)
    800044dc:	0094ca83          	lbu	s5,9(s1)
    800044e0:	0104ba03          	ld	s4,16(s1)
    800044e4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800044e8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800044ec:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800044f0:	0001d517          	auipc	a0,0x1d
    800044f4:	49850513          	addi	a0,a0,1176 # 80021988 <ftable>
    800044f8:	ffffc097          	auipc	ra,0xffffc
    800044fc:	62e080e7          	jalr	1582(ra) # 80000b26 <release>

  if(ff.type == FD_PIPE){
    80004500:	4785                	li	a5,1
    80004502:	06f90163          	beq	s2,a5,80004564 <fileclose+0xc2>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004506:	3979                	addiw	s2,s2,-2
    80004508:	4785                	li	a5,1
    8000450a:	0527e463          	bltu	a5,s2,80004552 <fileclose+0xb0>
    begin_op(ff.ip->dev);
    8000450e:	0009a503          	lw	a0,0(s3)
    80004512:	00000097          	auipc	ra,0x0
    80004516:	968080e7          	jalr	-1688(ra) # 80003e7a <begin_op>
    iput(ff.ip);
    8000451a:	854e                	mv	a0,s3
    8000451c:	fffff097          	auipc	ra,0xfffff
    80004520:	fc2080e7          	jalr	-62(ra) # 800034de <iput>
    end_op(ff.ip->dev);
    80004524:	0009a503          	lw	a0,0(s3)
    80004528:	00000097          	auipc	ra,0x0
    8000452c:	9fc080e7          	jalr	-1540(ra) # 80003f24 <end_op>
    80004530:	a00d                	j	80004552 <fileclose+0xb0>
    panic("fileclose");
    80004532:	00003517          	auipc	a0,0x3
    80004536:	1b650513          	addi	a0,a0,438 # 800076e8 <userret+0x658>
    8000453a:	ffffc097          	auipc	ra,0xffffc
    8000453e:	00e080e7          	jalr	14(ra) # 80000548 <panic>
    release(&ftable.lock);
    80004542:	0001d517          	auipc	a0,0x1d
    80004546:	44650513          	addi	a0,a0,1094 # 80021988 <ftable>
    8000454a:	ffffc097          	auipc	ra,0xffffc
    8000454e:	5dc080e7          	jalr	1500(ra) # 80000b26 <release>
  }
}
    80004552:	70e2                	ld	ra,56(sp)
    80004554:	7442                	ld	s0,48(sp)
    80004556:	74a2                	ld	s1,40(sp)
    80004558:	7902                	ld	s2,32(sp)
    8000455a:	69e2                	ld	s3,24(sp)
    8000455c:	6a42                	ld	s4,16(sp)
    8000455e:	6aa2                	ld	s5,8(sp)
    80004560:	6121                	addi	sp,sp,64
    80004562:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004564:	85d6                	mv	a1,s5
    80004566:	8552                	mv	a0,s4
    80004568:	00000097          	auipc	ra,0x0
    8000456c:	348080e7          	jalr	840(ra) # 800048b0 <pipeclose>
    80004570:	b7cd                	j	80004552 <fileclose+0xb0>

0000000080004572 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004572:	715d                	addi	sp,sp,-80
    80004574:	e486                	sd	ra,72(sp)
    80004576:	e0a2                	sd	s0,64(sp)
    80004578:	fc26                	sd	s1,56(sp)
    8000457a:	f84a                	sd	s2,48(sp)
    8000457c:	f44e                	sd	s3,40(sp)
    8000457e:	0880                	addi	s0,sp,80
    80004580:	84aa                	mv	s1,a0
    80004582:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004584:	ffffd097          	auipc	ra,0xffffd
    80004588:	29a080e7          	jalr	666(ra) # 8000181e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000458c:	409c                	lw	a5,0(s1)
    8000458e:	37f9                	addiw	a5,a5,-2
    80004590:	4705                	li	a4,1
    80004592:	04f76763          	bltu	a4,a5,800045e0 <filestat+0x6e>
    80004596:	892a                	mv	s2,a0
    ilock(f->ip);
    80004598:	6c88                	ld	a0,24(s1)
    8000459a:	fffff097          	auipc	ra,0xfffff
    8000459e:	e36080e7          	jalr	-458(ra) # 800033d0 <ilock>
    stati(f->ip, &st);
    800045a2:	fb840593          	addi	a1,s0,-72
    800045a6:	6c88                	ld	a0,24(s1)
    800045a8:	fffff097          	auipc	ra,0xfffff
    800045ac:	08e080e7          	jalr	142(ra) # 80003636 <stati>
    iunlock(f->ip);
    800045b0:	6c88                	ld	a0,24(s1)
    800045b2:	fffff097          	auipc	ra,0xfffff
    800045b6:	ee0080e7          	jalr	-288(ra) # 80003492 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800045ba:	46e1                	li	a3,24
    800045bc:	fb840613          	addi	a2,s0,-72
    800045c0:	85ce                	mv	a1,s3
    800045c2:	04893503          	ld	a0,72(s2)
    800045c6:	ffffd097          	auipc	ra,0xffffd
    800045ca:	f7c080e7          	jalr	-132(ra) # 80001542 <copyout>
    800045ce:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800045d2:	60a6                	ld	ra,72(sp)
    800045d4:	6406                	ld	s0,64(sp)
    800045d6:	74e2                	ld	s1,56(sp)
    800045d8:	7942                	ld	s2,48(sp)
    800045da:	79a2                	ld	s3,40(sp)
    800045dc:	6161                	addi	sp,sp,80
    800045de:	8082                	ret
  return -1;
    800045e0:	557d                	li	a0,-1
    800045e2:	bfc5                	j	800045d2 <filestat+0x60>

00000000800045e4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800045e4:	7179                	addi	sp,sp,-48
    800045e6:	f406                	sd	ra,40(sp)
    800045e8:	f022                	sd	s0,32(sp)
    800045ea:	ec26                	sd	s1,24(sp)
    800045ec:	e84a                	sd	s2,16(sp)
    800045ee:	e44e                	sd	s3,8(sp)
    800045f0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800045f2:	00854783          	lbu	a5,8(a0)
    800045f6:	cfc1                	beqz	a5,8000468e <fileread+0xaa>
    800045f8:	84aa                	mv	s1,a0
    800045fa:	89ae                	mv	s3,a1
    800045fc:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800045fe:	411c                	lw	a5,0(a0)
    80004600:	4705                	li	a4,1
    80004602:	04e78963          	beq	a5,a4,80004654 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004606:	470d                	li	a4,3
    80004608:	04e78d63          	beq	a5,a4,80004662 <fileread+0x7e>
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000460c:	4709                	li	a4,2
    8000460e:	06e79863          	bne	a5,a4,8000467e <fileread+0x9a>
    ilock(f->ip);
    80004612:	6d08                	ld	a0,24(a0)
    80004614:	fffff097          	auipc	ra,0xfffff
    80004618:	dbc080e7          	jalr	-580(ra) # 800033d0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000461c:	874a                	mv	a4,s2
    8000461e:	5094                	lw	a3,32(s1)
    80004620:	864e                	mv	a2,s3
    80004622:	4585                	li	a1,1
    80004624:	6c88                	ld	a0,24(s1)
    80004626:	fffff097          	auipc	ra,0xfffff
    8000462a:	03a080e7          	jalr	58(ra) # 80003660 <readi>
    8000462e:	892a                	mv	s2,a0
    80004630:	00a05563          	blez	a0,8000463a <fileread+0x56>
      f->off += r;
    80004634:	509c                	lw	a5,32(s1)
    80004636:	9fa9                	addw	a5,a5,a0
    80004638:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000463a:	6c88                	ld	a0,24(s1)
    8000463c:	fffff097          	auipc	ra,0xfffff
    80004640:	e56080e7          	jalr	-426(ra) # 80003492 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004644:	854a                	mv	a0,s2
    80004646:	70a2                	ld	ra,40(sp)
    80004648:	7402                	ld	s0,32(sp)
    8000464a:	64e2                	ld	s1,24(sp)
    8000464c:	6942                	ld	s2,16(sp)
    8000464e:	69a2                	ld	s3,8(sp)
    80004650:	6145                	addi	sp,sp,48
    80004652:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004654:	6908                	ld	a0,16(a0)
    80004656:	00000097          	auipc	ra,0x0
    8000465a:	3d8080e7          	jalr	984(ra) # 80004a2e <piperead>
    8000465e:	892a                	mv	s2,a0
    80004660:	b7d5                	j	80004644 <fileread+0x60>
    r = devsw[f->major].read(1, addr, n);
    80004662:	02451783          	lh	a5,36(a0)
    80004666:	00479713          	slli	a4,a5,0x4
    8000466a:	0001d797          	auipc	a5,0x1d
    8000466e:	27e78793          	addi	a5,a5,638 # 800218e8 <devsw>
    80004672:	97ba                	add	a5,a5,a4
    80004674:	639c                	ld	a5,0(a5)
    80004676:	4505                	li	a0,1
    80004678:	9782                	jalr	a5
    8000467a:	892a                	mv	s2,a0
    8000467c:	b7e1                	j	80004644 <fileread+0x60>
    panic("fileread");
    8000467e:	00003517          	auipc	a0,0x3
    80004682:	07a50513          	addi	a0,a0,122 # 800076f8 <userret+0x668>
    80004686:	ffffc097          	auipc	ra,0xffffc
    8000468a:	ec2080e7          	jalr	-318(ra) # 80000548 <panic>
    return -1;
    8000468e:	597d                	li	s2,-1
    80004690:	bf55                	j	80004644 <fileread+0x60>

0000000080004692 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004692:	00954783          	lbu	a5,9(a0)
    80004696:	12078e63          	beqz	a5,800047d2 <filewrite+0x140>
{
    8000469a:	715d                	addi	sp,sp,-80
    8000469c:	e486                	sd	ra,72(sp)
    8000469e:	e0a2                	sd	s0,64(sp)
    800046a0:	fc26                	sd	s1,56(sp)
    800046a2:	f84a                	sd	s2,48(sp)
    800046a4:	f44e                	sd	s3,40(sp)
    800046a6:	f052                	sd	s4,32(sp)
    800046a8:	ec56                	sd	s5,24(sp)
    800046aa:	e85a                	sd	s6,16(sp)
    800046ac:	e45e                	sd	s7,8(sp)
    800046ae:	e062                	sd	s8,0(sp)
    800046b0:	0880                	addi	s0,sp,80
    800046b2:	84aa                	mv	s1,a0
    800046b4:	8aae                	mv	s5,a1
    800046b6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800046b8:	411c                	lw	a5,0(a0)
    800046ba:	4705                	li	a4,1
    800046bc:	02e78263          	beq	a5,a4,800046e0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046c0:	470d                	li	a4,3
    800046c2:	02e78563          	beq	a5,a4,800046ec <filewrite+0x5a>
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800046c6:	4709                	li	a4,2
    800046c8:	0ee79d63          	bne	a5,a4,800047c2 <filewrite+0x130>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800046cc:	0ec05763          	blez	a2,800047ba <filewrite+0x128>
    int i = 0;
    800046d0:	4981                	li	s3,0
    800046d2:	6b05                	lui	s6,0x1
    800046d4:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800046d8:	6b85                	lui	s7,0x1
    800046da:	c00b8b9b          	addiw	s7,s7,-1024
    800046de:	a051                	j	80004762 <filewrite+0xd0>
    ret = pipewrite(f->pipe, addr, n);
    800046e0:	6908                	ld	a0,16(a0)
    800046e2:	00000097          	auipc	ra,0x0
    800046e6:	23e080e7          	jalr	574(ra) # 80004920 <pipewrite>
    800046ea:	a065                	j	80004792 <filewrite+0x100>
    ret = devsw[f->major].write(1, addr, n);
    800046ec:	02451783          	lh	a5,36(a0)
    800046f0:	00479713          	slli	a4,a5,0x4
    800046f4:	0001d797          	auipc	a5,0x1d
    800046f8:	1f478793          	addi	a5,a5,500 # 800218e8 <devsw>
    800046fc:	97ba                	add	a5,a5,a4
    800046fe:	679c                	ld	a5,8(a5)
    80004700:	4505                	li	a0,1
    80004702:	9782                	jalr	a5
    80004704:	a079                	j	80004792 <filewrite+0x100>
    80004706:	00090c1b          	sext.w	s8,s2
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op(f->ip->dev);
    8000470a:	6c9c                	ld	a5,24(s1)
    8000470c:	4388                	lw	a0,0(a5)
    8000470e:	fffff097          	auipc	ra,0xfffff
    80004712:	76c080e7          	jalr	1900(ra) # 80003e7a <begin_op>
      ilock(f->ip);
    80004716:	6c88                	ld	a0,24(s1)
    80004718:	fffff097          	auipc	ra,0xfffff
    8000471c:	cb8080e7          	jalr	-840(ra) # 800033d0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004720:	8762                	mv	a4,s8
    80004722:	5094                	lw	a3,32(s1)
    80004724:	01598633          	add	a2,s3,s5
    80004728:	4585                	li	a1,1
    8000472a:	6c88                	ld	a0,24(s1)
    8000472c:	fffff097          	auipc	ra,0xfffff
    80004730:	028080e7          	jalr	40(ra) # 80003754 <writei>
    80004734:	892a                	mv	s2,a0
    80004736:	02a05e63          	blez	a0,80004772 <filewrite+0xe0>
        f->off += r;
    8000473a:	509c                	lw	a5,32(s1)
    8000473c:	9fa9                	addw	a5,a5,a0
    8000473e:	d09c                	sw	a5,32(s1)
      iunlock(f->ip);
    80004740:	6c88                	ld	a0,24(s1)
    80004742:	fffff097          	auipc	ra,0xfffff
    80004746:	d50080e7          	jalr	-688(ra) # 80003492 <iunlock>
      end_op(f->ip->dev);
    8000474a:	6c9c                	ld	a5,24(s1)
    8000474c:	4388                	lw	a0,0(a5)
    8000474e:	fffff097          	auipc	ra,0xfffff
    80004752:	7d6080e7          	jalr	2006(ra) # 80003f24 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004756:	052c1a63          	bne	s8,s2,800047aa <filewrite+0x118>
        panic("short filewrite");
      i += r;
    8000475a:	013909bb          	addw	s3,s2,s3
    while(i < n){
    8000475e:	0349d763          	bge	s3,s4,8000478c <filewrite+0xfa>
      int n1 = n - i;
    80004762:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004766:	893e                	mv	s2,a5
    80004768:	2781                	sext.w	a5,a5
    8000476a:	f8fb5ee3          	bge	s6,a5,80004706 <filewrite+0x74>
    8000476e:	895e                	mv	s2,s7
    80004770:	bf59                	j	80004706 <filewrite+0x74>
      iunlock(f->ip);
    80004772:	6c88                	ld	a0,24(s1)
    80004774:	fffff097          	auipc	ra,0xfffff
    80004778:	d1e080e7          	jalr	-738(ra) # 80003492 <iunlock>
      end_op(f->ip->dev);
    8000477c:	6c9c                	ld	a5,24(s1)
    8000477e:	4388                	lw	a0,0(a5)
    80004780:	fffff097          	auipc	ra,0xfffff
    80004784:	7a4080e7          	jalr	1956(ra) # 80003f24 <end_op>
      if(r < 0)
    80004788:	fc0957e3          	bgez	s2,80004756 <filewrite+0xc4>
    }
    ret = (i == n ? n : -1);
    8000478c:	8552                	mv	a0,s4
    8000478e:	033a1863          	bne	s4,s3,800047be <filewrite+0x12c>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004792:	60a6                	ld	ra,72(sp)
    80004794:	6406                	ld	s0,64(sp)
    80004796:	74e2                	ld	s1,56(sp)
    80004798:	7942                	ld	s2,48(sp)
    8000479a:	79a2                	ld	s3,40(sp)
    8000479c:	7a02                	ld	s4,32(sp)
    8000479e:	6ae2                	ld	s5,24(sp)
    800047a0:	6b42                	ld	s6,16(sp)
    800047a2:	6ba2                	ld	s7,8(sp)
    800047a4:	6c02                	ld	s8,0(sp)
    800047a6:	6161                	addi	sp,sp,80
    800047a8:	8082                	ret
        panic("short filewrite");
    800047aa:	00003517          	auipc	a0,0x3
    800047ae:	f5e50513          	addi	a0,a0,-162 # 80007708 <userret+0x678>
    800047b2:	ffffc097          	auipc	ra,0xffffc
    800047b6:	d96080e7          	jalr	-618(ra) # 80000548 <panic>
    int i = 0;
    800047ba:	4981                	li	s3,0
    800047bc:	bfc1                	j	8000478c <filewrite+0xfa>
    ret = (i == n ? n : -1);
    800047be:	557d                	li	a0,-1
    800047c0:	bfc9                	j	80004792 <filewrite+0x100>
    panic("filewrite");
    800047c2:	00003517          	auipc	a0,0x3
    800047c6:	f5650513          	addi	a0,a0,-170 # 80007718 <userret+0x688>
    800047ca:	ffffc097          	auipc	ra,0xffffc
    800047ce:	d7e080e7          	jalr	-642(ra) # 80000548 <panic>
    return -1;
    800047d2:	557d                	li	a0,-1
}
    800047d4:	8082                	ret

00000000800047d6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800047d6:	7179                	addi	sp,sp,-48
    800047d8:	f406                	sd	ra,40(sp)
    800047da:	f022                	sd	s0,32(sp)
    800047dc:	ec26                	sd	s1,24(sp)
    800047de:	e84a                	sd	s2,16(sp)
    800047e0:	e44e                	sd	s3,8(sp)
    800047e2:	e052                	sd	s4,0(sp)
    800047e4:	1800                	addi	s0,sp,48
    800047e6:	84aa                	mv	s1,a0
    800047e8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800047ea:	0005b023          	sd	zero,0(a1)
    800047ee:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800047f2:	00000097          	auipc	ra,0x0
    800047f6:	bf4080e7          	jalr	-1036(ra) # 800043e6 <filealloc>
    800047fa:	e088                	sd	a0,0(s1)
    800047fc:	c551                	beqz	a0,80004888 <pipealloc+0xb2>
    800047fe:	00000097          	auipc	ra,0x0
    80004802:	be8080e7          	jalr	-1048(ra) # 800043e6 <filealloc>
    80004806:	00aa3023          	sd	a0,0(s4)
    8000480a:	c92d                	beqz	a0,8000487c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000480c:	ffffc097          	auipc	ra,0xffffc
    80004810:	144080e7          	jalr	324(ra) # 80000950 <kalloc>
    80004814:	892a                	mv	s2,a0
    80004816:	c125                	beqz	a0,80004876 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004818:	4985                	li	s3,1
    8000481a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000481e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004822:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004826:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000482a:	00003597          	auipc	a1,0x3
    8000482e:	efe58593          	addi	a1,a1,-258 # 80007728 <userret+0x698>
    80004832:	ffffc097          	auipc	ra,0xffffc
    80004836:	17e080e7          	jalr	382(ra) # 800009b0 <initlock>
  (*f0)->type = FD_PIPE;
    8000483a:	609c                	ld	a5,0(s1)
    8000483c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004840:	609c                	ld	a5,0(s1)
    80004842:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004846:	609c                	ld	a5,0(s1)
    80004848:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000484c:	609c                	ld	a5,0(s1)
    8000484e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004852:	000a3783          	ld	a5,0(s4)
    80004856:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000485a:	000a3783          	ld	a5,0(s4)
    8000485e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004862:	000a3783          	ld	a5,0(s4)
    80004866:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000486a:	000a3783          	ld	a5,0(s4)
    8000486e:	0127b823          	sd	s2,16(a5)
  return 0;
    80004872:	4501                	li	a0,0
    80004874:	a025                	j	8000489c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004876:	6088                	ld	a0,0(s1)
    80004878:	e501                	bnez	a0,80004880 <pipealloc+0xaa>
    8000487a:	a039                	j	80004888 <pipealloc+0xb2>
    8000487c:	6088                	ld	a0,0(s1)
    8000487e:	c51d                	beqz	a0,800048ac <pipealloc+0xd6>
    fileclose(*f0);
    80004880:	00000097          	auipc	ra,0x0
    80004884:	c22080e7          	jalr	-990(ra) # 800044a2 <fileclose>
  if(*f1)
    80004888:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000488c:	557d                	li	a0,-1
  if(*f1)
    8000488e:	c799                	beqz	a5,8000489c <pipealloc+0xc6>
    fileclose(*f1);
    80004890:	853e                	mv	a0,a5
    80004892:	00000097          	auipc	ra,0x0
    80004896:	c10080e7          	jalr	-1008(ra) # 800044a2 <fileclose>
  return -1;
    8000489a:	557d                	li	a0,-1
}
    8000489c:	70a2                	ld	ra,40(sp)
    8000489e:	7402                	ld	s0,32(sp)
    800048a0:	64e2                	ld	s1,24(sp)
    800048a2:	6942                	ld	s2,16(sp)
    800048a4:	69a2                	ld	s3,8(sp)
    800048a6:	6a02                	ld	s4,0(sp)
    800048a8:	6145                	addi	sp,sp,48
    800048aa:	8082                	ret
  return -1;
    800048ac:	557d                	li	a0,-1
    800048ae:	b7fd                	j	8000489c <pipealloc+0xc6>

00000000800048b0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800048b0:	1101                	addi	sp,sp,-32
    800048b2:	ec06                	sd	ra,24(sp)
    800048b4:	e822                	sd	s0,16(sp)
    800048b6:	e426                	sd	s1,8(sp)
    800048b8:	e04a                	sd	s2,0(sp)
    800048ba:	1000                	addi	s0,sp,32
    800048bc:	84aa                	mv	s1,a0
    800048be:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800048c0:	ffffc097          	auipc	ra,0xffffc
    800048c4:	1fe080e7          	jalr	510(ra) # 80000abe <acquire>
  if(writable){
    800048c8:	02090d63          	beqz	s2,80004902 <pipeclose+0x52>
    pi->writeopen = 0;
    800048cc:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800048d0:	21848513          	addi	a0,s1,536
    800048d4:	ffffe097          	auipc	ra,0xffffe
    800048d8:	89a080e7          	jalr	-1894(ra) # 8000216e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800048dc:	2204b783          	ld	a5,544(s1)
    800048e0:	eb95                	bnez	a5,80004914 <pipeclose+0x64>
    release(&pi->lock);
    800048e2:	8526                	mv	a0,s1
    800048e4:	ffffc097          	auipc	ra,0xffffc
    800048e8:	242080e7          	jalr	578(ra) # 80000b26 <release>
    kfree((char*)pi);
    800048ec:	8526                	mv	a0,s1
    800048ee:	ffffc097          	auipc	ra,0xffffc
    800048f2:	f66080e7          	jalr	-154(ra) # 80000854 <kfree>
  } else
    release(&pi->lock);
}
    800048f6:	60e2                	ld	ra,24(sp)
    800048f8:	6442                	ld	s0,16(sp)
    800048fa:	64a2                	ld	s1,8(sp)
    800048fc:	6902                	ld	s2,0(sp)
    800048fe:	6105                	addi	sp,sp,32
    80004900:	8082                	ret
    pi->readopen = 0;
    80004902:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004906:	21c48513          	addi	a0,s1,540
    8000490a:	ffffe097          	auipc	ra,0xffffe
    8000490e:	864080e7          	jalr	-1948(ra) # 8000216e <wakeup>
    80004912:	b7e9                	j	800048dc <pipeclose+0x2c>
    release(&pi->lock);
    80004914:	8526                	mv	a0,s1
    80004916:	ffffc097          	auipc	ra,0xffffc
    8000491a:	210080e7          	jalr	528(ra) # 80000b26 <release>
}
    8000491e:	bfe1                	j	800048f6 <pipeclose+0x46>

0000000080004920 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004920:	711d                	addi	sp,sp,-96
    80004922:	ec86                	sd	ra,88(sp)
    80004924:	e8a2                	sd	s0,80(sp)
    80004926:	e4a6                	sd	s1,72(sp)
    80004928:	e0ca                	sd	s2,64(sp)
    8000492a:	fc4e                	sd	s3,56(sp)
    8000492c:	f852                	sd	s4,48(sp)
    8000492e:	f456                	sd	s5,40(sp)
    80004930:	f05a                	sd	s6,32(sp)
    80004932:	ec5e                	sd	s7,24(sp)
    80004934:	e862                	sd	s8,16(sp)
    80004936:	1080                	addi	s0,sp,96
    80004938:	84aa                	mv	s1,a0
    8000493a:	8aae                	mv	s5,a1
    8000493c:	8a32                	mv	s4,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    8000493e:	ffffd097          	auipc	ra,0xffffd
    80004942:	ee0080e7          	jalr	-288(ra) # 8000181e <myproc>
    80004946:	8baa                	mv	s7,a0

  acquire(&pi->lock);
    80004948:	8526                	mv	a0,s1
    8000494a:	ffffc097          	auipc	ra,0xffffc
    8000494e:	174080e7          	jalr	372(ra) # 80000abe <acquire>
  for(i = 0; i < n; i++){
    80004952:	09405f63          	blez	s4,800049f0 <pipewrite+0xd0>
    80004956:	fffa0b1b          	addiw	s6,s4,-1
    8000495a:	1b02                	slli	s6,s6,0x20
    8000495c:	020b5b13          	srli	s6,s6,0x20
    80004960:	001a8793          	addi	a5,s5,1
    80004964:	9b3e                	add	s6,s6,a5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004966:	21848993          	addi	s3,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000496a:	21c48913          	addi	s2,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000496e:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004970:	2184a783          	lw	a5,536(s1)
    80004974:	21c4a703          	lw	a4,540(s1)
    80004978:	2007879b          	addiw	a5,a5,512
    8000497c:	02f71e63          	bne	a4,a5,800049b8 <pipewrite+0x98>
      if(pi->readopen == 0 || myproc()->killed){
    80004980:	2204a783          	lw	a5,544(s1)
    80004984:	c3d9                	beqz	a5,80004a0a <pipewrite+0xea>
    80004986:	ffffd097          	auipc	ra,0xffffd
    8000498a:	e98080e7          	jalr	-360(ra) # 8000181e <myproc>
    8000498e:	591c                	lw	a5,48(a0)
    80004990:	efad                	bnez	a5,80004a0a <pipewrite+0xea>
      wakeup(&pi->nread);
    80004992:	854e                	mv	a0,s3
    80004994:	ffffd097          	auipc	ra,0xffffd
    80004998:	7da080e7          	jalr	2010(ra) # 8000216e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000499c:	85a6                	mv	a1,s1
    8000499e:	854a                	mv	a0,s2
    800049a0:	ffffd097          	auipc	ra,0xffffd
    800049a4:	688080e7          	jalr	1672(ra) # 80002028 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    800049a8:	2184a783          	lw	a5,536(s1)
    800049ac:	21c4a703          	lw	a4,540(s1)
    800049b0:	2007879b          	addiw	a5,a5,512
    800049b4:	fcf706e3          	beq	a4,a5,80004980 <pipewrite+0x60>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800049b8:	4685                	li	a3,1
    800049ba:	8656                	mv	a2,s5
    800049bc:	faf40593          	addi	a1,s0,-81
    800049c0:	048bb503          	ld	a0,72(s7) # 1048 <_entry-0x7fffefb8>
    800049c4:	ffffd097          	auipc	ra,0xffffd
    800049c8:	c10080e7          	jalr	-1008(ra) # 800015d4 <copyin>
    800049cc:	03850263          	beq	a0,s8,800049f0 <pipewrite+0xd0>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800049d0:	21c4a783          	lw	a5,540(s1)
    800049d4:	0017871b          	addiw	a4,a5,1
    800049d8:	20e4ae23          	sw	a4,540(s1)
    800049dc:	1ff7f793          	andi	a5,a5,511
    800049e0:	97a6                	add	a5,a5,s1
    800049e2:	faf44703          	lbu	a4,-81(s0)
    800049e6:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    800049ea:	0a85                	addi	s5,s5,1
    800049ec:	f96a92e3          	bne	s5,s6,80004970 <pipewrite+0x50>
  }
  wakeup(&pi->nread);
    800049f0:	21848513          	addi	a0,s1,536
    800049f4:	ffffd097          	auipc	ra,0xffffd
    800049f8:	77a080e7          	jalr	1914(ra) # 8000216e <wakeup>
  release(&pi->lock);
    800049fc:	8526                	mv	a0,s1
    800049fe:	ffffc097          	auipc	ra,0xffffc
    80004a02:	128080e7          	jalr	296(ra) # 80000b26 <release>
  return n;
    80004a06:	8552                	mv	a0,s4
    80004a08:	a039                	j	80004a16 <pipewrite+0xf6>
        release(&pi->lock);
    80004a0a:	8526                	mv	a0,s1
    80004a0c:	ffffc097          	auipc	ra,0xffffc
    80004a10:	11a080e7          	jalr	282(ra) # 80000b26 <release>
        return -1;
    80004a14:	557d                	li	a0,-1
}
    80004a16:	60e6                	ld	ra,88(sp)
    80004a18:	6446                	ld	s0,80(sp)
    80004a1a:	64a6                	ld	s1,72(sp)
    80004a1c:	6906                	ld	s2,64(sp)
    80004a1e:	79e2                	ld	s3,56(sp)
    80004a20:	7a42                	ld	s4,48(sp)
    80004a22:	7aa2                	ld	s5,40(sp)
    80004a24:	7b02                	ld	s6,32(sp)
    80004a26:	6be2                	ld	s7,24(sp)
    80004a28:	6c42                	ld	s8,16(sp)
    80004a2a:	6125                	addi	sp,sp,96
    80004a2c:	8082                	ret

0000000080004a2e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004a2e:	715d                	addi	sp,sp,-80
    80004a30:	e486                	sd	ra,72(sp)
    80004a32:	e0a2                	sd	s0,64(sp)
    80004a34:	fc26                	sd	s1,56(sp)
    80004a36:	f84a                	sd	s2,48(sp)
    80004a38:	f44e                	sd	s3,40(sp)
    80004a3a:	f052                	sd	s4,32(sp)
    80004a3c:	ec56                	sd	s5,24(sp)
    80004a3e:	e85a                	sd	s6,16(sp)
    80004a40:	0880                	addi	s0,sp,80
    80004a42:	84aa                	mv	s1,a0
    80004a44:	892e                	mv	s2,a1
    80004a46:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80004a48:	ffffd097          	auipc	ra,0xffffd
    80004a4c:	dd6080e7          	jalr	-554(ra) # 8000181e <myproc>
    80004a50:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80004a52:	8526                	mv	a0,s1
    80004a54:	ffffc097          	auipc	ra,0xffffc
    80004a58:	06a080e7          	jalr	106(ra) # 80000abe <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a5c:	2184a703          	lw	a4,536(s1)
    80004a60:	21c4a783          	lw	a5,540(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a64:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a68:	02f71763          	bne	a4,a5,80004a96 <piperead+0x68>
    80004a6c:	2244a783          	lw	a5,548(s1)
    80004a70:	c39d                	beqz	a5,80004a96 <piperead+0x68>
    if(myproc()->killed){
    80004a72:	ffffd097          	auipc	ra,0xffffd
    80004a76:	dac080e7          	jalr	-596(ra) # 8000181e <myproc>
    80004a7a:	591c                	lw	a5,48(a0)
    80004a7c:	ebc1                	bnez	a5,80004b0c <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a7e:	85a6                	mv	a1,s1
    80004a80:	854e                	mv	a0,s3
    80004a82:	ffffd097          	auipc	ra,0xffffd
    80004a86:	5a6080e7          	jalr	1446(ra) # 80002028 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a8a:	2184a703          	lw	a4,536(s1)
    80004a8e:	21c4a783          	lw	a5,540(s1)
    80004a92:	fcf70de3          	beq	a4,a5,80004a6c <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a96:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a98:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a9a:	05405363          	blez	s4,80004ae0 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004a9e:	2184a783          	lw	a5,536(s1)
    80004aa2:	21c4a703          	lw	a4,540(s1)
    80004aa6:	02f70d63          	beq	a4,a5,80004ae0 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004aaa:	0017871b          	addiw	a4,a5,1
    80004aae:	20e4ac23          	sw	a4,536(s1)
    80004ab2:	1ff7f793          	andi	a5,a5,511
    80004ab6:	97a6                	add	a5,a5,s1
    80004ab8:	0187c783          	lbu	a5,24(a5)
    80004abc:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ac0:	4685                	li	a3,1
    80004ac2:	fbf40613          	addi	a2,s0,-65
    80004ac6:	85ca                	mv	a1,s2
    80004ac8:	048ab503          	ld	a0,72(s5)
    80004acc:	ffffd097          	auipc	ra,0xffffd
    80004ad0:	a76080e7          	jalr	-1418(ra) # 80001542 <copyout>
    80004ad4:	01650663          	beq	a0,s6,80004ae0 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ad8:	2985                	addiw	s3,s3,1
    80004ada:	0905                	addi	s2,s2,1
    80004adc:	fd3a11e3          	bne	s4,s3,80004a9e <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004ae0:	21c48513          	addi	a0,s1,540
    80004ae4:	ffffd097          	auipc	ra,0xffffd
    80004ae8:	68a080e7          	jalr	1674(ra) # 8000216e <wakeup>
  release(&pi->lock);
    80004aec:	8526                	mv	a0,s1
    80004aee:	ffffc097          	auipc	ra,0xffffc
    80004af2:	038080e7          	jalr	56(ra) # 80000b26 <release>
  return i;
}
    80004af6:	854e                	mv	a0,s3
    80004af8:	60a6                	ld	ra,72(sp)
    80004afa:	6406                	ld	s0,64(sp)
    80004afc:	74e2                	ld	s1,56(sp)
    80004afe:	7942                	ld	s2,48(sp)
    80004b00:	79a2                	ld	s3,40(sp)
    80004b02:	7a02                	ld	s4,32(sp)
    80004b04:	6ae2                	ld	s5,24(sp)
    80004b06:	6b42                	ld	s6,16(sp)
    80004b08:	6161                	addi	sp,sp,80
    80004b0a:	8082                	ret
      release(&pi->lock);
    80004b0c:	8526                	mv	a0,s1
    80004b0e:	ffffc097          	auipc	ra,0xffffc
    80004b12:	018080e7          	jalr	24(ra) # 80000b26 <release>
      return -1;
    80004b16:	59fd                	li	s3,-1
    80004b18:	bff9                	j	80004af6 <piperead+0xc8>

0000000080004b1a <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004b1a:	de010113          	addi	sp,sp,-544
    80004b1e:	20113c23          	sd	ra,536(sp)
    80004b22:	20813823          	sd	s0,528(sp)
    80004b26:	20913423          	sd	s1,520(sp)
    80004b2a:	21213023          	sd	s2,512(sp)
    80004b2e:	ffce                	sd	s3,504(sp)
    80004b30:	fbd2                	sd	s4,496(sp)
    80004b32:	f7d6                	sd	s5,488(sp)
    80004b34:	f3da                	sd	s6,480(sp)
    80004b36:	efde                	sd	s7,472(sp)
    80004b38:	ebe2                	sd	s8,464(sp)
    80004b3a:	e7e6                	sd	s9,456(sp)
    80004b3c:	e3ea                	sd	s10,448(sp)
    80004b3e:	ff6e                	sd	s11,440(sp)
    80004b40:	1400                	addi	s0,sp,544
    80004b42:	892a                	mv	s2,a0
    80004b44:	dea43423          	sd	a0,-536(s0)
    80004b48:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004b4c:	ffffd097          	auipc	ra,0xffffd
    80004b50:	cd2080e7          	jalr	-814(ra) # 8000181e <myproc>
    80004b54:	84aa                	mv	s1,a0

  begin_op(ROOTDEV);
    80004b56:	4501                	li	a0,0
    80004b58:	fffff097          	auipc	ra,0xfffff
    80004b5c:	322080e7          	jalr	802(ra) # 80003e7a <begin_op>

  if((ip = namei(path)) == 0){
    80004b60:	854a                	mv	a0,s2
    80004b62:	fffff097          	auipc	ra,0xfffff
    80004b66:	ffa080e7          	jalr	-6(ra) # 80003b5c <namei>
    80004b6a:	cd25                	beqz	a0,80004be2 <exec+0xc8>
    80004b6c:	8aaa                	mv	s5,a0
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    80004b6e:	fffff097          	auipc	ra,0xfffff
    80004b72:	862080e7          	jalr	-1950(ra) # 800033d0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004b76:	04000713          	li	a4,64
    80004b7a:	4681                	li	a3,0
    80004b7c:	e4840613          	addi	a2,s0,-440
    80004b80:	4581                	li	a1,0
    80004b82:	8556                	mv	a0,s5
    80004b84:	fffff097          	auipc	ra,0xfffff
    80004b88:	adc080e7          	jalr	-1316(ra) # 80003660 <readi>
    80004b8c:	04000793          	li	a5,64
    80004b90:	00f51a63          	bne	a0,a5,80004ba4 <exec+0x8a>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004b94:	e4842703          	lw	a4,-440(s0)
    80004b98:	464c47b7          	lui	a5,0x464c4
    80004b9c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004ba0:	04f70863          	beq	a4,a5,80004bf0 <exec+0xd6>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004ba4:	8556                	mv	a0,s5
    80004ba6:	fffff097          	auipc	ra,0xfffff
    80004baa:	a68080e7          	jalr	-1432(ra) # 8000360e <iunlockput>
    end_op(ROOTDEV);
    80004bae:	4501                	li	a0,0
    80004bb0:	fffff097          	auipc	ra,0xfffff
    80004bb4:	374080e7          	jalr	884(ra) # 80003f24 <end_op>
  }
  return -1;
    80004bb8:	557d                	li	a0,-1
}
    80004bba:	21813083          	ld	ra,536(sp)
    80004bbe:	21013403          	ld	s0,528(sp)
    80004bc2:	20813483          	ld	s1,520(sp)
    80004bc6:	20013903          	ld	s2,512(sp)
    80004bca:	79fe                	ld	s3,504(sp)
    80004bcc:	7a5e                	ld	s4,496(sp)
    80004bce:	7abe                	ld	s5,488(sp)
    80004bd0:	7b1e                	ld	s6,480(sp)
    80004bd2:	6bfe                	ld	s7,472(sp)
    80004bd4:	6c5e                	ld	s8,464(sp)
    80004bd6:	6cbe                	ld	s9,456(sp)
    80004bd8:	6d1e                	ld	s10,448(sp)
    80004bda:	7dfa                	ld	s11,440(sp)
    80004bdc:	22010113          	addi	sp,sp,544
    80004be0:	8082                	ret
    end_op(ROOTDEV);
    80004be2:	4501                	li	a0,0
    80004be4:	fffff097          	auipc	ra,0xfffff
    80004be8:	340080e7          	jalr	832(ra) # 80003f24 <end_op>
    return -1;
    80004bec:	557d                	li	a0,-1
    80004bee:	b7f1                	j	80004bba <exec+0xa0>
  if((pagetable = proc_pagetable(p)) == 0)
    80004bf0:	8526                	mv	a0,s1
    80004bf2:	ffffd097          	auipc	ra,0xffffd
    80004bf6:	cf0080e7          	jalr	-784(ra) # 800018e2 <proc_pagetable>
    80004bfa:	8b2a                	mv	s6,a0
    80004bfc:	d545                	beqz	a0,80004ba4 <exec+0x8a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004bfe:	e6842783          	lw	a5,-408(s0)
    80004c02:	e8045703          	lhu	a4,-384(s0)
    80004c06:	10070263          	beqz	a4,80004d0a <exec+0x1f0>
  sz = 0;
    80004c0a:	de043c23          	sd	zero,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c0e:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004c12:	6a05                	lui	s4,0x1
    80004c14:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004c18:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80004c1c:	6d85                	lui	s11,0x1
    80004c1e:	7d7d                	lui	s10,0xfffff
    80004c20:	a88d                	j	80004c92 <exec+0x178>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004c22:	00003517          	auipc	a0,0x3
    80004c26:	b0e50513          	addi	a0,a0,-1266 # 80007730 <userret+0x6a0>
    80004c2a:	ffffc097          	auipc	ra,0xffffc
    80004c2e:	91e080e7          	jalr	-1762(ra) # 80000548 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004c32:	874a                	mv	a4,s2
    80004c34:	009c86bb          	addw	a3,s9,s1
    80004c38:	4581                	li	a1,0
    80004c3a:	8556                	mv	a0,s5
    80004c3c:	fffff097          	auipc	ra,0xfffff
    80004c40:	a24080e7          	jalr	-1500(ra) # 80003660 <readi>
    80004c44:	2501                	sext.w	a0,a0
    80004c46:	10a91863          	bne	s2,a0,80004d56 <exec+0x23c>
  for(i = 0; i < sz; i += PGSIZE){
    80004c4a:	009d84bb          	addw	s1,s11,s1
    80004c4e:	013d09bb          	addw	s3,s10,s3
    80004c52:	0374f263          	bgeu	s1,s7,80004c76 <exec+0x15c>
    pa = walkaddr(pagetable, va + i);
    80004c56:	02049593          	slli	a1,s1,0x20
    80004c5a:	9181                	srli	a1,a1,0x20
    80004c5c:	95e2                	add	a1,a1,s8
    80004c5e:	855a                	mv	a0,s6
    80004c60:	ffffc097          	auipc	ra,0xffffc
    80004c64:	31c080e7          	jalr	796(ra) # 80000f7c <walkaddr>
    80004c68:	862a                	mv	a2,a0
    if(pa == 0)
    80004c6a:	dd45                	beqz	a0,80004c22 <exec+0x108>
      n = PGSIZE;
    80004c6c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004c6e:	fd49f2e3          	bgeu	s3,s4,80004c32 <exec+0x118>
      n = sz - i;
    80004c72:	894e                	mv	s2,s3
    80004c74:	bf7d                	j	80004c32 <exec+0x118>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c76:	e0843783          	ld	a5,-504(s0)
    80004c7a:	0017869b          	addiw	a3,a5,1
    80004c7e:	e0d43423          	sd	a3,-504(s0)
    80004c82:	e0043783          	ld	a5,-512(s0)
    80004c86:	0387879b          	addiw	a5,a5,56
    80004c8a:	e8045703          	lhu	a4,-384(s0)
    80004c8e:	08e6d063          	bge	a3,a4,80004d0e <exec+0x1f4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004c92:	2781                	sext.w	a5,a5
    80004c94:	e0f43023          	sd	a5,-512(s0)
    80004c98:	03800713          	li	a4,56
    80004c9c:	86be                	mv	a3,a5
    80004c9e:	e1040613          	addi	a2,s0,-496
    80004ca2:	4581                	li	a1,0
    80004ca4:	8556                	mv	a0,s5
    80004ca6:	fffff097          	auipc	ra,0xfffff
    80004caa:	9ba080e7          	jalr	-1606(ra) # 80003660 <readi>
    80004cae:	03800793          	li	a5,56
    80004cb2:	0af51263          	bne	a0,a5,80004d56 <exec+0x23c>
    if(ph.type != ELF_PROG_LOAD)
    80004cb6:	e1042783          	lw	a5,-496(s0)
    80004cba:	4705                	li	a4,1
    80004cbc:	fae79de3          	bne	a5,a4,80004c76 <exec+0x15c>
    if(ph.memsz < ph.filesz)
    80004cc0:	e3843603          	ld	a2,-456(s0)
    80004cc4:	e3043783          	ld	a5,-464(s0)
    80004cc8:	08f66763          	bltu	a2,a5,80004d56 <exec+0x23c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004ccc:	e2043783          	ld	a5,-480(s0)
    80004cd0:	963e                	add	a2,a2,a5
    80004cd2:	08f66263          	bltu	a2,a5,80004d56 <exec+0x23c>
    if((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004cd6:	df843583          	ld	a1,-520(s0)
    80004cda:	855a                	mv	a0,s6
    80004cdc:	ffffc097          	auipc	ra,0xffffc
    80004ce0:	68c080e7          	jalr	1676(ra) # 80001368 <uvmalloc>
    80004ce4:	dea43c23          	sd	a0,-520(s0)
    80004ce8:	c53d                	beqz	a0,80004d56 <exec+0x23c>
    if(ph.vaddr % PGSIZE != 0)
    80004cea:	e2043c03          	ld	s8,-480(s0)
    80004cee:	de043783          	ld	a5,-544(s0)
    80004cf2:	00fc77b3          	and	a5,s8,a5
    80004cf6:	e3a5                	bnez	a5,80004d56 <exec+0x23c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004cf8:	e1842c83          	lw	s9,-488(s0)
    80004cfc:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004d00:	f60b8be3          	beqz	s7,80004c76 <exec+0x15c>
    80004d04:	89de                	mv	s3,s7
    80004d06:	4481                	li	s1,0
    80004d08:	b7b9                	j	80004c56 <exec+0x13c>
  sz = 0;
    80004d0a:	de043c23          	sd	zero,-520(s0)
  iunlockput(ip);
    80004d0e:	8556                	mv	a0,s5
    80004d10:	fffff097          	auipc	ra,0xfffff
    80004d14:	8fe080e7          	jalr	-1794(ra) # 8000360e <iunlockput>
  end_op(ROOTDEV);
    80004d18:	4501                	li	a0,0
    80004d1a:	fffff097          	auipc	ra,0xfffff
    80004d1e:	20a080e7          	jalr	522(ra) # 80003f24 <end_op>
  p = myproc();
    80004d22:	ffffd097          	auipc	ra,0xffffd
    80004d26:	afc080e7          	jalr	-1284(ra) # 8000181e <myproc>
    80004d2a:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004d2c:	04053c83          	ld	s9,64(a0)
  sz = PGROUNDUP(sz);
    80004d30:	6585                	lui	a1,0x1
    80004d32:	15fd                	addi	a1,a1,-1
    80004d34:	df843783          	ld	a5,-520(s0)
    80004d38:	95be                	add	a1,a1,a5
    80004d3a:	77fd                	lui	a5,0xfffff
    80004d3c:	8dfd                	and	a1,a1,a5
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004d3e:	6609                	lui	a2,0x2
    80004d40:	962e                	add	a2,a2,a1
    80004d42:	855a                	mv	a0,s6
    80004d44:	ffffc097          	auipc	ra,0xffffc
    80004d48:	624080e7          	jalr	1572(ra) # 80001368 <uvmalloc>
    80004d4c:	892a                	mv	s2,a0
    80004d4e:	dea43c23          	sd	a0,-520(s0)
  ip = 0;
    80004d52:	4a81                	li	s5,0
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004d54:	ed01                	bnez	a0,80004d6c <exec+0x252>
    proc_freepagetable(pagetable, sz);
    80004d56:	df843583          	ld	a1,-520(s0)
    80004d5a:	855a                	mv	a0,s6
    80004d5c:	ffffd097          	auipc	ra,0xffffd
    80004d60:	c86080e7          	jalr	-890(ra) # 800019e2 <proc_freepagetable>
  if(ip){
    80004d64:	e40a90e3          	bnez	s5,80004ba4 <exec+0x8a>
  return -1;
    80004d68:	557d                	li	a0,-1
    80004d6a:	bd81                	j	80004bba <exec+0xa0>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004d6c:	75f9                	lui	a1,0xffffe
    80004d6e:	95aa                	add	a1,a1,a0
    80004d70:	855a                	mv	a0,s6
    80004d72:	ffffc097          	auipc	ra,0xffffc
    80004d76:	79e080e7          	jalr	1950(ra) # 80001510 <uvmclear>
  stackbase = sp - PGSIZE;
    80004d7a:	7c7d                	lui	s8,0xfffff
    80004d7c:	9c4a                	add	s8,s8,s2
  for(argc = 0; argv[argc]; argc++) {
    80004d7e:	df043783          	ld	a5,-528(s0)
    80004d82:	6388                	ld	a0,0(a5)
    80004d84:	c52d                	beqz	a0,80004dee <exec+0x2d4>
    80004d86:	e8840993          	addi	s3,s0,-376
    80004d8a:	f8840a93          	addi	s5,s0,-120
    80004d8e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004d90:	ffffc097          	auipc	ra,0xffffc
    80004d94:	f76080e7          	jalr	-138(ra) # 80000d06 <strlen>
    80004d98:	0015079b          	addiw	a5,a0,1
    80004d9c:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004da0:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004da4:	0f896b63          	bltu	s2,s8,80004e9a <exec+0x380>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004da8:	df043d03          	ld	s10,-528(s0)
    80004dac:	000d3a03          	ld	s4,0(s10) # fffffffffffff000 <ticks+0xffffffff7ffd5fd8>
    80004db0:	8552                	mv	a0,s4
    80004db2:	ffffc097          	auipc	ra,0xffffc
    80004db6:	f54080e7          	jalr	-172(ra) # 80000d06 <strlen>
    80004dba:	0015069b          	addiw	a3,a0,1
    80004dbe:	8652                	mv	a2,s4
    80004dc0:	85ca                	mv	a1,s2
    80004dc2:	855a                	mv	a0,s6
    80004dc4:	ffffc097          	auipc	ra,0xffffc
    80004dc8:	77e080e7          	jalr	1918(ra) # 80001542 <copyout>
    80004dcc:	0c054963          	bltz	a0,80004e9e <exec+0x384>
    ustack[argc] = sp;
    80004dd0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004dd4:	0485                	addi	s1,s1,1
    80004dd6:	008d0793          	addi	a5,s10,8
    80004dda:	def43823          	sd	a5,-528(s0)
    80004dde:	008d3503          	ld	a0,8(s10)
    80004de2:	c909                	beqz	a0,80004df4 <exec+0x2da>
    if(argc >= MAXARG)
    80004de4:	09a1                	addi	s3,s3,8
    80004de6:	fb3a95e3          	bne	s5,s3,80004d90 <exec+0x276>
  ip = 0;
    80004dea:	4a81                	li	s5,0
    80004dec:	b7ad                	j	80004d56 <exec+0x23c>
  sp = sz;
    80004dee:	df843903          	ld	s2,-520(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004df2:	4481                	li	s1,0
  ustack[argc] = 0;
    80004df4:	00349793          	slli	a5,s1,0x3
    80004df8:	f9040713          	addi	a4,s0,-112
    80004dfc:	97ba                	add	a5,a5,a4
    80004dfe:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <ticks+0xffffffff7ffd5ed0>
  sp -= (argc+1) * sizeof(uint64);
    80004e02:	00148693          	addi	a3,s1,1
    80004e06:	068e                	slli	a3,a3,0x3
    80004e08:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004e0c:	ff097913          	andi	s2,s2,-16
  ip = 0;
    80004e10:	4a81                	li	s5,0
  if(sp < stackbase)
    80004e12:	f58962e3          	bltu	s2,s8,80004d56 <exec+0x23c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004e16:	e8840613          	addi	a2,s0,-376
    80004e1a:	85ca                	mv	a1,s2
    80004e1c:	855a                	mv	a0,s6
    80004e1e:	ffffc097          	auipc	ra,0xffffc
    80004e22:	724080e7          	jalr	1828(ra) # 80001542 <copyout>
    80004e26:	06054e63          	bltz	a0,80004ea2 <exec+0x388>
  p->tf->a1 = sp;
    80004e2a:	050bb783          	ld	a5,80(s7)
    80004e2e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004e32:	de843783          	ld	a5,-536(s0)
    80004e36:	0007c703          	lbu	a4,0(a5)
    80004e3a:	cf11                	beqz	a4,80004e56 <exec+0x33c>
    80004e3c:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004e3e:	02f00693          	li	a3,47
    80004e42:	a039                	j	80004e50 <exec+0x336>
      last = s+1;
    80004e44:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004e48:	0785                	addi	a5,a5,1
    80004e4a:	fff7c703          	lbu	a4,-1(a5)
    80004e4e:	c701                	beqz	a4,80004e56 <exec+0x33c>
    if(*s == '/')
    80004e50:	fed71ce3          	bne	a4,a3,80004e48 <exec+0x32e>
    80004e54:	bfc5                	j	80004e44 <exec+0x32a>
  safestrcpy(p->name, last, sizeof(p->name));
    80004e56:	4641                	li	a2,16
    80004e58:	de843583          	ld	a1,-536(s0)
    80004e5c:	150b8513          	addi	a0,s7,336
    80004e60:	ffffc097          	auipc	ra,0xffffc
    80004e64:	e74080e7          	jalr	-396(ra) # 80000cd4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004e68:	048bb503          	ld	a0,72(s7)
  p->pagetable = pagetable;
    80004e6c:	056bb423          	sd	s6,72(s7)
  p->sz = sz;
    80004e70:	df843783          	ld	a5,-520(s0)
    80004e74:	04fbb023          	sd	a5,64(s7)
  p->tf->epc = elf.entry;  // initial program counter = main
    80004e78:	050bb783          	ld	a5,80(s7)
    80004e7c:	e6043703          	ld	a4,-416(s0)
    80004e80:	ef98                	sd	a4,24(a5)
  p->tf->sp = sp; // initial stack pointer
    80004e82:	050bb783          	ld	a5,80(s7)
    80004e86:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004e8a:	85e6                	mv	a1,s9
    80004e8c:	ffffd097          	auipc	ra,0xffffd
    80004e90:	b56080e7          	jalr	-1194(ra) # 800019e2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004e94:	0004851b          	sext.w	a0,s1
    80004e98:	b30d                	j	80004bba <exec+0xa0>
  ip = 0;
    80004e9a:	4a81                	li	s5,0
    80004e9c:	bd6d                	j	80004d56 <exec+0x23c>
    80004e9e:	4a81                	li	s5,0
    80004ea0:	bd5d                	j	80004d56 <exec+0x23c>
    80004ea2:	4a81                	li	s5,0
    80004ea4:	bd4d                	j	80004d56 <exec+0x23c>

0000000080004ea6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004ea6:	7179                	addi	sp,sp,-48
    80004ea8:	f406                	sd	ra,40(sp)
    80004eaa:	f022                	sd	s0,32(sp)
    80004eac:	ec26                	sd	s1,24(sp)
    80004eae:	e84a                	sd	s2,16(sp)
    80004eb0:	1800                	addi	s0,sp,48
    80004eb2:	892e                	mv	s2,a1
    80004eb4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004eb6:	fdc40593          	addi	a1,s0,-36
    80004eba:	ffffe097          	auipc	ra,0xffffe
    80004ebe:	9d4080e7          	jalr	-1580(ra) # 8000288e <argint>
    80004ec2:	04054063          	bltz	a0,80004f02 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004ec6:	fdc42703          	lw	a4,-36(s0)
    80004eca:	47bd                	li	a5,15
    80004ecc:	02e7ed63          	bltu	a5,a4,80004f06 <argfd+0x60>
    80004ed0:	ffffd097          	auipc	ra,0xffffd
    80004ed4:	94e080e7          	jalr	-1714(ra) # 8000181e <myproc>
    80004ed8:	fdc42703          	lw	a4,-36(s0)
    80004edc:	01870793          	addi	a5,a4,24
    80004ee0:	078e                	slli	a5,a5,0x3
    80004ee2:	953e                	add	a0,a0,a5
    80004ee4:	651c                	ld	a5,8(a0)
    80004ee6:	c395                	beqz	a5,80004f0a <argfd+0x64>
    return -1;
  if(pfd)
    80004ee8:	00090463          	beqz	s2,80004ef0 <argfd+0x4a>
    *pfd = fd;
    80004eec:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004ef0:	4501                	li	a0,0
  if(pf)
    80004ef2:	c091                	beqz	s1,80004ef6 <argfd+0x50>
    *pf = f;
    80004ef4:	e09c                	sd	a5,0(s1)
}
    80004ef6:	70a2                	ld	ra,40(sp)
    80004ef8:	7402                	ld	s0,32(sp)
    80004efa:	64e2                	ld	s1,24(sp)
    80004efc:	6942                	ld	s2,16(sp)
    80004efe:	6145                	addi	sp,sp,48
    80004f00:	8082                	ret
    return -1;
    80004f02:	557d                	li	a0,-1
    80004f04:	bfcd                	j	80004ef6 <argfd+0x50>
    return -1;
    80004f06:	557d                	li	a0,-1
    80004f08:	b7fd                	j	80004ef6 <argfd+0x50>
    80004f0a:	557d                	li	a0,-1
    80004f0c:	b7ed                	j	80004ef6 <argfd+0x50>

0000000080004f0e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004f0e:	1101                	addi	sp,sp,-32
    80004f10:	ec06                	sd	ra,24(sp)
    80004f12:	e822                	sd	s0,16(sp)
    80004f14:	e426                	sd	s1,8(sp)
    80004f16:	1000                	addi	s0,sp,32
    80004f18:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004f1a:	ffffd097          	auipc	ra,0xffffd
    80004f1e:	904080e7          	jalr	-1788(ra) # 8000181e <myproc>
    80004f22:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004f24:	0c850793          	addi	a5,a0,200
    80004f28:	4501                	li	a0,0
    80004f2a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004f2c:	6398                	ld	a4,0(a5)
    80004f2e:	cb19                	beqz	a4,80004f44 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004f30:	2505                	addiw	a0,a0,1
    80004f32:	07a1                	addi	a5,a5,8
    80004f34:	fed51ce3          	bne	a0,a3,80004f2c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004f38:	557d                	li	a0,-1
}
    80004f3a:	60e2                	ld	ra,24(sp)
    80004f3c:	6442                	ld	s0,16(sp)
    80004f3e:	64a2                	ld	s1,8(sp)
    80004f40:	6105                	addi	sp,sp,32
    80004f42:	8082                	ret
      p->ofile[fd] = f;
    80004f44:	01850793          	addi	a5,a0,24
    80004f48:	078e                	slli	a5,a5,0x3
    80004f4a:	963e                	add	a2,a2,a5
    80004f4c:	e604                	sd	s1,8(a2)
      return fd;
    80004f4e:	b7f5                	j	80004f3a <fdalloc+0x2c>

0000000080004f50 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004f50:	715d                	addi	sp,sp,-80
    80004f52:	e486                	sd	ra,72(sp)
    80004f54:	e0a2                	sd	s0,64(sp)
    80004f56:	fc26                	sd	s1,56(sp)
    80004f58:	f84a                	sd	s2,48(sp)
    80004f5a:	f44e                	sd	s3,40(sp)
    80004f5c:	f052                	sd	s4,32(sp)
    80004f5e:	ec56                	sd	s5,24(sp)
    80004f60:	0880                	addi	s0,sp,80
    80004f62:	89ae                	mv	s3,a1
    80004f64:	8ab2                	mv	s5,a2
    80004f66:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004f68:	fb040593          	addi	a1,s0,-80
    80004f6c:	fffff097          	auipc	ra,0xfffff
    80004f70:	c0e080e7          	jalr	-1010(ra) # 80003b7a <nameiparent>
    80004f74:	892a                	mv	s2,a0
    80004f76:	12050e63          	beqz	a0,800050b2 <create+0x162>
    return 0;
  ilock(dp);
    80004f7a:	ffffe097          	auipc	ra,0xffffe
    80004f7e:	456080e7          	jalr	1110(ra) # 800033d0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004f82:	4601                	li	a2,0
    80004f84:	fb040593          	addi	a1,s0,-80
    80004f88:	854a                	mv	a0,s2
    80004f8a:	fffff097          	auipc	ra,0xfffff
    80004f8e:	900080e7          	jalr	-1792(ra) # 8000388a <dirlookup>
    80004f92:	84aa                	mv	s1,a0
    80004f94:	c921                	beqz	a0,80004fe4 <create+0x94>
    iunlockput(dp);
    80004f96:	854a                	mv	a0,s2
    80004f98:	ffffe097          	auipc	ra,0xffffe
    80004f9c:	676080e7          	jalr	1654(ra) # 8000360e <iunlockput>
    ilock(ip);
    80004fa0:	8526                	mv	a0,s1
    80004fa2:	ffffe097          	auipc	ra,0xffffe
    80004fa6:	42e080e7          	jalr	1070(ra) # 800033d0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004faa:	2981                	sext.w	s3,s3
    80004fac:	4789                	li	a5,2
    80004fae:	02f99463          	bne	s3,a5,80004fd6 <create+0x86>
    80004fb2:	0444d783          	lhu	a5,68(s1)
    80004fb6:	37f9                	addiw	a5,a5,-2
    80004fb8:	17c2                	slli	a5,a5,0x30
    80004fba:	93c1                	srli	a5,a5,0x30
    80004fbc:	4705                	li	a4,1
    80004fbe:	00f76c63          	bltu	a4,a5,80004fd6 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004fc2:	8526                	mv	a0,s1
    80004fc4:	60a6                	ld	ra,72(sp)
    80004fc6:	6406                	ld	s0,64(sp)
    80004fc8:	74e2                	ld	s1,56(sp)
    80004fca:	7942                	ld	s2,48(sp)
    80004fcc:	79a2                	ld	s3,40(sp)
    80004fce:	7a02                	ld	s4,32(sp)
    80004fd0:	6ae2                	ld	s5,24(sp)
    80004fd2:	6161                	addi	sp,sp,80
    80004fd4:	8082                	ret
    iunlockput(ip);
    80004fd6:	8526                	mv	a0,s1
    80004fd8:	ffffe097          	auipc	ra,0xffffe
    80004fdc:	636080e7          	jalr	1590(ra) # 8000360e <iunlockput>
    return 0;
    80004fe0:	4481                	li	s1,0
    80004fe2:	b7c5                	j	80004fc2 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004fe4:	85ce                	mv	a1,s3
    80004fe6:	00092503          	lw	a0,0(s2)
    80004fea:	ffffe097          	auipc	ra,0xffffe
    80004fee:	24e080e7          	jalr	590(ra) # 80003238 <ialloc>
    80004ff2:	84aa                	mv	s1,a0
    80004ff4:	c521                	beqz	a0,8000503c <create+0xec>
  ilock(ip);
    80004ff6:	ffffe097          	auipc	ra,0xffffe
    80004ffa:	3da080e7          	jalr	986(ra) # 800033d0 <ilock>
  ip->major = major;
    80004ffe:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005002:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005006:	4a05                	li	s4,1
    80005008:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000500c:	8526                	mv	a0,s1
    8000500e:	ffffe097          	auipc	ra,0xffffe
    80005012:	2f8080e7          	jalr	760(ra) # 80003306 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005016:	2981                	sext.w	s3,s3
    80005018:	03498a63          	beq	s3,s4,8000504c <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000501c:	40d0                	lw	a2,4(s1)
    8000501e:	fb040593          	addi	a1,s0,-80
    80005022:	854a                	mv	a0,s2
    80005024:	fffff097          	auipc	ra,0xfffff
    80005028:	a76080e7          	jalr	-1418(ra) # 80003a9a <dirlink>
    8000502c:	06054b63          	bltz	a0,800050a2 <create+0x152>
  iunlockput(dp);
    80005030:	854a                	mv	a0,s2
    80005032:	ffffe097          	auipc	ra,0xffffe
    80005036:	5dc080e7          	jalr	1500(ra) # 8000360e <iunlockput>
  return ip;
    8000503a:	b761                	j	80004fc2 <create+0x72>
    panic("create: ialloc");
    8000503c:	00002517          	auipc	a0,0x2
    80005040:	71450513          	addi	a0,a0,1812 # 80007750 <userret+0x6c0>
    80005044:	ffffb097          	auipc	ra,0xffffb
    80005048:	504080e7          	jalr	1284(ra) # 80000548 <panic>
    dp->nlink++;  // for ".."
    8000504c:	04a95783          	lhu	a5,74(s2)
    80005050:	2785                	addiw	a5,a5,1
    80005052:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005056:	854a                	mv	a0,s2
    80005058:	ffffe097          	auipc	ra,0xffffe
    8000505c:	2ae080e7          	jalr	686(ra) # 80003306 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005060:	40d0                	lw	a2,4(s1)
    80005062:	00002597          	auipc	a1,0x2
    80005066:	6fe58593          	addi	a1,a1,1790 # 80007760 <userret+0x6d0>
    8000506a:	8526                	mv	a0,s1
    8000506c:	fffff097          	auipc	ra,0xfffff
    80005070:	a2e080e7          	jalr	-1490(ra) # 80003a9a <dirlink>
    80005074:	00054f63          	bltz	a0,80005092 <create+0x142>
    80005078:	00492603          	lw	a2,4(s2)
    8000507c:	00002597          	auipc	a1,0x2
    80005080:	6ec58593          	addi	a1,a1,1772 # 80007768 <userret+0x6d8>
    80005084:	8526                	mv	a0,s1
    80005086:	fffff097          	auipc	ra,0xfffff
    8000508a:	a14080e7          	jalr	-1516(ra) # 80003a9a <dirlink>
    8000508e:	f80557e3          	bgez	a0,8000501c <create+0xcc>
      panic("create dots");
    80005092:	00002517          	auipc	a0,0x2
    80005096:	6de50513          	addi	a0,a0,1758 # 80007770 <userret+0x6e0>
    8000509a:	ffffb097          	auipc	ra,0xffffb
    8000509e:	4ae080e7          	jalr	1198(ra) # 80000548 <panic>
    panic("create: dirlink");
    800050a2:	00002517          	auipc	a0,0x2
    800050a6:	6de50513          	addi	a0,a0,1758 # 80007780 <userret+0x6f0>
    800050aa:	ffffb097          	auipc	ra,0xffffb
    800050ae:	49e080e7          	jalr	1182(ra) # 80000548 <panic>
    return 0;
    800050b2:	84aa                	mv	s1,a0
    800050b4:	b739                	j	80004fc2 <create+0x72>

00000000800050b6 <sys_dup>:
{
    800050b6:	7179                	addi	sp,sp,-48
    800050b8:	f406                	sd	ra,40(sp)
    800050ba:	f022                	sd	s0,32(sp)
    800050bc:	ec26                	sd	s1,24(sp)
    800050be:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800050c0:	fd840613          	addi	a2,s0,-40
    800050c4:	4581                	li	a1,0
    800050c6:	4501                	li	a0,0
    800050c8:	00000097          	auipc	ra,0x0
    800050cc:	dde080e7          	jalr	-546(ra) # 80004ea6 <argfd>
    return -1;
    800050d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800050d2:	02054363          	bltz	a0,800050f8 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800050d6:	fd843503          	ld	a0,-40(s0)
    800050da:	00000097          	auipc	ra,0x0
    800050de:	e34080e7          	jalr	-460(ra) # 80004f0e <fdalloc>
    800050e2:	84aa                	mv	s1,a0
    return -1;
    800050e4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800050e6:	00054963          	bltz	a0,800050f8 <sys_dup+0x42>
  filedup(f);
    800050ea:	fd843503          	ld	a0,-40(s0)
    800050ee:	fffff097          	auipc	ra,0xfffff
    800050f2:	362080e7          	jalr	866(ra) # 80004450 <filedup>
  return fd;
    800050f6:	87a6                	mv	a5,s1
}
    800050f8:	853e                	mv	a0,a5
    800050fa:	70a2                	ld	ra,40(sp)
    800050fc:	7402                	ld	s0,32(sp)
    800050fe:	64e2                	ld	s1,24(sp)
    80005100:	6145                	addi	sp,sp,48
    80005102:	8082                	ret

0000000080005104 <sys_read>:
{
    80005104:	7179                	addi	sp,sp,-48
    80005106:	f406                	sd	ra,40(sp)
    80005108:	f022                	sd	s0,32(sp)
    8000510a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000510c:	fe840613          	addi	a2,s0,-24
    80005110:	4581                	li	a1,0
    80005112:	4501                	li	a0,0
    80005114:	00000097          	auipc	ra,0x0
    80005118:	d92080e7          	jalr	-622(ra) # 80004ea6 <argfd>
    return -1;
    8000511c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000511e:	04054163          	bltz	a0,80005160 <sys_read+0x5c>
    80005122:	fe440593          	addi	a1,s0,-28
    80005126:	4509                	li	a0,2
    80005128:	ffffd097          	auipc	ra,0xffffd
    8000512c:	766080e7          	jalr	1894(ra) # 8000288e <argint>
    return -1;
    80005130:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005132:	02054763          	bltz	a0,80005160 <sys_read+0x5c>
    80005136:	fd840593          	addi	a1,s0,-40
    8000513a:	4505                	li	a0,1
    8000513c:	ffffd097          	auipc	ra,0xffffd
    80005140:	774080e7          	jalr	1908(ra) # 800028b0 <argaddr>
    return -1;
    80005144:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005146:	00054d63          	bltz	a0,80005160 <sys_read+0x5c>
  return fileread(f, p, n);
    8000514a:	fe442603          	lw	a2,-28(s0)
    8000514e:	fd843583          	ld	a1,-40(s0)
    80005152:	fe843503          	ld	a0,-24(s0)
    80005156:	fffff097          	auipc	ra,0xfffff
    8000515a:	48e080e7          	jalr	1166(ra) # 800045e4 <fileread>
    8000515e:	87aa                	mv	a5,a0
}
    80005160:	853e                	mv	a0,a5
    80005162:	70a2                	ld	ra,40(sp)
    80005164:	7402                	ld	s0,32(sp)
    80005166:	6145                	addi	sp,sp,48
    80005168:	8082                	ret

000000008000516a <sys_write>:
{
    8000516a:	7179                	addi	sp,sp,-48
    8000516c:	f406                	sd	ra,40(sp)
    8000516e:	f022                	sd	s0,32(sp)
    80005170:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005172:	fe840613          	addi	a2,s0,-24
    80005176:	4581                	li	a1,0
    80005178:	4501                	li	a0,0
    8000517a:	00000097          	auipc	ra,0x0
    8000517e:	d2c080e7          	jalr	-724(ra) # 80004ea6 <argfd>
    return -1;
    80005182:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005184:	04054163          	bltz	a0,800051c6 <sys_write+0x5c>
    80005188:	fe440593          	addi	a1,s0,-28
    8000518c:	4509                	li	a0,2
    8000518e:	ffffd097          	auipc	ra,0xffffd
    80005192:	700080e7          	jalr	1792(ra) # 8000288e <argint>
    return -1;
    80005196:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005198:	02054763          	bltz	a0,800051c6 <sys_write+0x5c>
    8000519c:	fd840593          	addi	a1,s0,-40
    800051a0:	4505                	li	a0,1
    800051a2:	ffffd097          	auipc	ra,0xffffd
    800051a6:	70e080e7          	jalr	1806(ra) # 800028b0 <argaddr>
    return -1;
    800051aa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051ac:	00054d63          	bltz	a0,800051c6 <sys_write+0x5c>
  return filewrite(f, p, n);
    800051b0:	fe442603          	lw	a2,-28(s0)
    800051b4:	fd843583          	ld	a1,-40(s0)
    800051b8:	fe843503          	ld	a0,-24(s0)
    800051bc:	fffff097          	auipc	ra,0xfffff
    800051c0:	4d6080e7          	jalr	1238(ra) # 80004692 <filewrite>
    800051c4:	87aa                	mv	a5,a0
}
    800051c6:	853e                	mv	a0,a5
    800051c8:	70a2                	ld	ra,40(sp)
    800051ca:	7402                	ld	s0,32(sp)
    800051cc:	6145                	addi	sp,sp,48
    800051ce:	8082                	ret

00000000800051d0 <sys_close>:
{
    800051d0:	1101                	addi	sp,sp,-32
    800051d2:	ec06                	sd	ra,24(sp)
    800051d4:	e822                	sd	s0,16(sp)
    800051d6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800051d8:	fe040613          	addi	a2,s0,-32
    800051dc:	fec40593          	addi	a1,s0,-20
    800051e0:	4501                	li	a0,0
    800051e2:	00000097          	auipc	ra,0x0
    800051e6:	cc4080e7          	jalr	-828(ra) # 80004ea6 <argfd>
    return -1;
    800051ea:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800051ec:	02054463          	bltz	a0,80005214 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800051f0:	ffffc097          	auipc	ra,0xffffc
    800051f4:	62e080e7          	jalr	1582(ra) # 8000181e <myproc>
    800051f8:	fec42783          	lw	a5,-20(s0)
    800051fc:	07e1                	addi	a5,a5,24
    800051fe:	078e                	slli	a5,a5,0x3
    80005200:	97aa                	add	a5,a5,a0
    80005202:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    80005206:	fe043503          	ld	a0,-32(s0)
    8000520a:	fffff097          	auipc	ra,0xfffff
    8000520e:	298080e7          	jalr	664(ra) # 800044a2 <fileclose>
  return 0;
    80005212:	4781                	li	a5,0
}
    80005214:	853e                	mv	a0,a5
    80005216:	60e2                	ld	ra,24(sp)
    80005218:	6442                	ld	s0,16(sp)
    8000521a:	6105                	addi	sp,sp,32
    8000521c:	8082                	ret

000000008000521e <sys_fstat>:
{
    8000521e:	1101                	addi	sp,sp,-32
    80005220:	ec06                	sd	ra,24(sp)
    80005222:	e822                	sd	s0,16(sp)
    80005224:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005226:	fe840613          	addi	a2,s0,-24
    8000522a:	4581                	li	a1,0
    8000522c:	4501                	li	a0,0
    8000522e:	00000097          	auipc	ra,0x0
    80005232:	c78080e7          	jalr	-904(ra) # 80004ea6 <argfd>
    return -1;
    80005236:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005238:	02054563          	bltz	a0,80005262 <sys_fstat+0x44>
    8000523c:	fe040593          	addi	a1,s0,-32
    80005240:	4505                	li	a0,1
    80005242:	ffffd097          	auipc	ra,0xffffd
    80005246:	66e080e7          	jalr	1646(ra) # 800028b0 <argaddr>
    return -1;
    8000524a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000524c:	00054b63          	bltz	a0,80005262 <sys_fstat+0x44>
  return filestat(f, st);
    80005250:	fe043583          	ld	a1,-32(s0)
    80005254:	fe843503          	ld	a0,-24(s0)
    80005258:	fffff097          	auipc	ra,0xfffff
    8000525c:	31a080e7          	jalr	794(ra) # 80004572 <filestat>
    80005260:	87aa                	mv	a5,a0
}
    80005262:	853e                	mv	a0,a5
    80005264:	60e2                	ld	ra,24(sp)
    80005266:	6442                	ld	s0,16(sp)
    80005268:	6105                	addi	sp,sp,32
    8000526a:	8082                	ret

000000008000526c <sys_link>:
{
    8000526c:	7169                	addi	sp,sp,-304
    8000526e:	f606                	sd	ra,296(sp)
    80005270:	f222                	sd	s0,288(sp)
    80005272:	ee26                	sd	s1,280(sp)
    80005274:	ea4a                	sd	s2,272(sp)
    80005276:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005278:	08000613          	li	a2,128
    8000527c:	ed040593          	addi	a1,s0,-304
    80005280:	4501                	li	a0,0
    80005282:	ffffd097          	auipc	ra,0xffffd
    80005286:	650080e7          	jalr	1616(ra) # 800028d2 <argstr>
    return -1;
    8000528a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000528c:	12054363          	bltz	a0,800053b2 <sys_link+0x146>
    80005290:	08000613          	li	a2,128
    80005294:	f5040593          	addi	a1,s0,-176
    80005298:	4505                	li	a0,1
    8000529a:	ffffd097          	auipc	ra,0xffffd
    8000529e:	638080e7          	jalr	1592(ra) # 800028d2 <argstr>
    return -1;
    800052a2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800052a4:	10054763          	bltz	a0,800053b2 <sys_link+0x146>
  begin_op(ROOTDEV);
    800052a8:	4501                	li	a0,0
    800052aa:	fffff097          	auipc	ra,0xfffff
    800052ae:	bd0080e7          	jalr	-1072(ra) # 80003e7a <begin_op>
  if((ip = namei(old)) == 0){
    800052b2:	ed040513          	addi	a0,s0,-304
    800052b6:	fffff097          	auipc	ra,0xfffff
    800052ba:	8a6080e7          	jalr	-1882(ra) # 80003b5c <namei>
    800052be:	84aa                	mv	s1,a0
    800052c0:	c559                	beqz	a0,8000534e <sys_link+0xe2>
  ilock(ip);
    800052c2:	ffffe097          	auipc	ra,0xffffe
    800052c6:	10e080e7          	jalr	270(ra) # 800033d0 <ilock>
  if(ip->type == T_DIR){
    800052ca:	04449703          	lh	a4,68(s1)
    800052ce:	4785                	li	a5,1
    800052d0:	08f70663          	beq	a4,a5,8000535c <sys_link+0xf0>
  ip->nlink++;
    800052d4:	04a4d783          	lhu	a5,74(s1)
    800052d8:	2785                	addiw	a5,a5,1
    800052da:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800052de:	8526                	mv	a0,s1
    800052e0:	ffffe097          	auipc	ra,0xffffe
    800052e4:	026080e7          	jalr	38(ra) # 80003306 <iupdate>
  iunlock(ip);
    800052e8:	8526                	mv	a0,s1
    800052ea:	ffffe097          	auipc	ra,0xffffe
    800052ee:	1a8080e7          	jalr	424(ra) # 80003492 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800052f2:	fd040593          	addi	a1,s0,-48
    800052f6:	f5040513          	addi	a0,s0,-176
    800052fa:	fffff097          	auipc	ra,0xfffff
    800052fe:	880080e7          	jalr	-1920(ra) # 80003b7a <nameiparent>
    80005302:	892a                	mv	s2,a0
    80005304:	cd2d                	beqz	a0,8000537e <sys_link+0x112>
  ilock(dp);
    80005306:	ffffe097          	auipc	ra,0xffffe
    8000530a:	0ca080e7          	jalr	202(ra) # 800033d0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000530e:	00092703          	lw	a4,0(s2)
    80005312:	409c                	lw	a5,0(s1)
    80005314:	06f71063          	bne	a4,a5,80005374 <sys_link+0x108>
    80005318:	40d0                	lw	a2,4(s1)
    8000531a:	fd040593          	addi	a1,s0,-48
    8000531e:	854a                	mv	a0,s2
    80005320:	ffffe097          	auipc	ra,0xffffe
    80005324:	77a080e7          	jalr	1914(ra) # 80003a9a <dirlink>
    80005328:	04054663          	bltz	a0,80005374 <sys_link+0x108>
  iunlockput(dp);
    8000532c:	854a                	mv	a0,s2
    8000532e:	ffffe097          	auipc	ra,0xffffe
    80005332:	2e0080e7          	jalr	736(ra) # 8000360e <iunlockput>
  iput(ip);
    80005336:	8526                	mv	a0,s1
    80005338:	ffffe097          	auipc	ra,0xffffe
    8000533c:	1a6080e7          	jalr	422(ra) # 800034de <iput>
  end_op(ROOTDEV);
    80005340:	4501                	li	a0,0
    80005342:	fffff097          	auipc	ra,0xfffff
    80005346:	be2080e7          	jalr	-1054(ra) # 80003f24 <end_op>
  return 0;
    8000534a:	4781                	li	a5,0
    8000534c:	a09d                	j	800053b2 <sys_link+0x146>
    end_op(ROOTDEV);
    8000534e:	4501                	li	a0,0
    80005350:	fffff097          	auipc	ra,0xfffff
    80005354:	bd4080e7          	jalr	-1068(ra) # 80003f24 <end_op>
    return -1;
    80005358:	57fd                	li	a5,-1
    8000535a:	a8a1                	j	800053b2 <sys_link+0x146>
    iunlockput(ip);
    8000535c:	8526                	mv	a0,s1
    8000535e:	ffffe097          	auipc	ra,0xffffe
    80005362:	2b0080e7          	jalr	688(ra) # 8000360e <iunlockput>
    end_op(ROOTDEV);
    80005366:	4501                	li	a0,0
    80005368:	fffff097          	auipc	ra,0xfffff
    8000536c:	bbc080e7          	jalr	-1092(ra) # 80003f24 <end_op>
    return -1;
    80005370:	57fd                	li	a5,-1
    80005372:	a081                	j	800053b2 <sys_link+0x146>
    iunlockput(dp);
    80005374:	854a                	mv	a0,s2
    80005376:	ffffe097          	auipc	ra,0xffffe
    8000537a:	298080e7          	jalr	664(ra) # 8000360e <iunlockput>
  ilock(ip);
    8000537e:	8526                	mv	a0,s1
    80005380:	ffffe097          	auipc	ra,0xffffe
    80005384:	050080e7          	jalr	80(ra) # 800033d0 <ilock>
  ip->nlink--;
    80005388:	04a4d783          	lhu	a5,74(s1)
    8000538c:	37fd                	addiw	a5,a5,-1
    8000538e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005392:	8526                	mv	a0,s1
    80005394:	ffffe097          	auipc	ra,0xffffe
    80005398:	f72080e7          	jalr	-142(ra) # 80003306 <iupdate>
  iunlockput(ip);
    8000539c:	8526                	mv	a0,s1
    8000539e:	ffffe097          	auipc	ra,0xffffe
    800053a2:	270080e7          	jalr	624(ra) # 8000360e <iunlockput>
  end_op(ROOTDEV);
    800053a6:	4501                	li	a0,0
    800053a8:	fffff097          	auipc	ra,0xfffff
    800053ac:	b7c080e7          	jalr	-1156(ra) # 80003f24 <end_op>
  return -1;
    800053b0:	57fd                	li	a5,-1
}
    800053b2:	853e                	mv	a0,a5
    800053b4:	70b2                	ld	ra,296(sp)
    800053b6:	7412                	ld	s0,288(sp)
    800053b8:	64f2                	ld	s1,280(sp)
    800053ba:	6952                	ld	s2,272(sp)
    800053bc:	6155                	addi	sp,sp,304
    800053be:	8082                	ret

00000000800053c0 <sys_unlink>:
{
    800053c0:	7151                	addi	sp,sp,-240
    800053c2:	f586                	sd	ra,232(sp)
    800053c4:	f1a2                	sd	s0,224(sp)
    800053c6:	eda6                	sd	s1,216(sp)
    800053c8:	e9ca                	sd	s2,208(sp)
    800053ca:	e5ce                	sd	s3,200(sp)
    800053cc:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800053ce:	08000613          	li	a2,128
    800053d2:	f3040593          	addi	a1,s0,-208
    800053d6:	4501                	li	a0,0
    800053d8:	ffffd097          	auipc	ra,0xffffd
    800053dc:	4fa080e7          	jalr	1274(ra) # 800028d2 <argstr>
    800053e0:	18054463          	bltz	a0,80005568 <sys_unlink+0x1a8>
  begin_op(ROOTDEV);
    800053e4:	4501                	li	a0,0
    800053e6:	fffff097          	auipc	ra,0xfffff
    800053ea:	a94080e7          	jalr	-1388(ra) # 80003e7a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800053ee:	fb040593          	addi	a1,s0,-80
    800053f2:	f3040513          	addi	a0,s0,-208
    800053f6:	ffffe097          	auipc	ra,0xffffe
    800053fa:	784080e7          	jalr	1924(ra) # 80003b7a <nameiparent>
    800053fe:	84aa                	mv	s1,a0
    80005400:	cd61                	beqz	a0,800054d8 <sys_unlink+0x118>
  ilock(dp);
    80005402:	ffffe097          	auipc	ra,0xffffe
    80005406:	fce080e7          	jalr	-50(ra) # 800033d0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000540a:	00002597          	auipc	a1,0x2
    8000540e:	35658593          	addi	a1,a1,854 # 80007760 <userret+0x6d0>
    80005412:	fb040513          	addi	a0,s0,-80
    80005416:	ffffe097          	auipc	ra,0xffffe
    8000541a:	45a080e7          	jalr	1114(ra) # 80003870 <namecmp>
    8000541e:	14050c63          	beqz	a0,80005576 <sys_unlink+0x1b6>
    80005422:	00002597          	auipc	a1,0x2
    80005426:	34658593          	addi	a1,a1,838 # 80007768 <userret+0x6d8>
    8000542a:	fb040513          	addi	a0,s0,-80
    8000542e:	ffffe097          	auipc	ra,0xffffe
    80005432:	442080e7          	jalr	1090(ra) # 80003870 <namecmp>
    80005436:	14050063          	beqz	a0,80005576 <sys_unlink+0x1b6>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000543a:	f2c40613          	addi	a2,s0,-212
    8000543e:	fb040593          	addi	a1,s0,-80
    80005442:	8526                	mv	a0,s1
    80005444:	ffffe097          	auipc	ra,0xffffe
    80005448:	446080e7          	jalr	1094(ra) # 8000388a <dirlookup>
    8000544c:	892a                	mv	s2,a0
    8000544e:	12050463          	beqz	a0,80005576 <sys_unlink+0x1b6>
  ilock(ip);
    80005452:	ffffe097          	auipc	ra,0xffffe
    80005456:	f7e080e7          	jalr	-130(ra) # 800033d0 <ilock>
  if(ip->nlink < 1)
    8000545a:	04a91783          	lh	a5,74(s2)
    8000545e:	08f05463          	blez	a5,800054e6 <sys_unlink+0x126>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005462:	04491703          	lh	a4,68(s2)
    80005466:	4785                	li	a5,1
    80005468:	08f70763          	beq	a4,a5,800054f6 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    8000546c:	4641                	li	a2,16
    8000546e:	4581                	li	a1,0
    80005470:	fc040513          	addi	a0,s0,-64
    80005474:	ffffb097          	auipc	ra,0xffffb
    80005478:	70e080e7          	jalr	1806(ra) # 80000b82 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000547c:	4741                	li	a4,16
    8000547e:	f2c42683          	lw	a3,-212(s0)
    80005482:	fc040613          	addi	a2,s0,-64
    80005486:	4581                	li	a1,0
    80005488:	8526                	mv	a0,s1
    8000548a:	ffffe097          	auipc	ra,0xffffe
    8000548e:	2ca080e7          	jalr	714(ra) # 80003754 <writei>
    80005492:	47c1                	li	a5,16
    80005494:	0af51763          	bne	a0,a5,80005542 <sys_unlink+0x182>
  if(ip->type == T_DIR){
    80005498:	04491703          	lh	a4,68(s2)
    8000549c:	4785                	li	a5,1
    8000549e:	0af70a63          	beq	a4,a5,80005552 <sys_unlink+0x192>
  iunlockput(dp);
    800054a2:	8526                	mv	a0,s1
    800054a4:	ffffe097          	auipc	ra,0xffffe
    800054a8:	16a080e7          	jalr	362(ra) # 8000360e <iunlockput>
  ip->nlink--;
    800054ac:	04a95783          	lhu	a5,74(s2)
    800054b0:	37fd                	addiw	a5,a5,-1
    800054b2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800054b6:	854a                	mv	a0,s2
    800054b8:	ffffe097          	auipc	ra,0xffffe
    800054bc:	e4e080e7          	jalr	-434(ra) # 80003306 <iupdate>
  iunlockput(ip);
    800054c0:	854a                	mv	a0,s2
    800054c2:	ffffe097          	auipc	ra,0xffffe
    800054c6:	14c080e7          	jalr	332(ra) # 8000360e <iunlockput>
  end_op(ROOTDEV);
    800054ca:	4501                	li	a0,0
    800054cc:	fffff097          	auipc	ra,0xfffff
    800054d0:	a58080e7          	jalr	-1448(ra) # 80003f24 <end_op>
  return 0;
    800054d4:	4501                	li	a0,0
    800054d6:	a85d                	j	8000558c <sys_unlink+0x1cc>
    end_op(ROOTDEV);
    800054d8:	4501                	li	a0,0
    800054da:	fffff097          	auipc	ra,0xfffff
    800054de:	a4a080e7          	jalr	-1462(ra) # 80003f24 <end_op>
    return -1;
    800054e2:	557d                	li	a0,-1
    800054e4:	a065                	j	8000558c <sys_unlink+0x1cc>
    panic("unlink: nlink < 1");
    800054e6:	00002517          	auipc	a0,0x2
    800054ea:	2aa50513          	addi	a0,a0,682 # 80007790 <userret+0x700>
    800054ee:	ffffb097          	auipc	ra,0xffffb
    800054f2:	05a080e7          	jalr	90(ra) # 80000548 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800054f6:	04c92703          	lw	a4,76(s2)
    800054fa:	02000793          	li	a5,32
    800054fe:	f6e7f7e3          	bgeu	a5,a4,8000546c <sys_unlink+0xac>
    80005502:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005506:	4741                	li	a4,16
    80005508:	86ce                	mv	a3,s3
    8000550a:	f1840613          	addi	a2,s0,-232
    8000550e:	4581                	li	a1,0
    80005510:	854a                	mv	a0,s2
    80005512:	ffffe097          	auipc	ra,0xffffe
    80005516:	14e080e7          	jalr	334(ra) # 80003660 <readi>
    8000551a:	47c1                	li	a5,16
    8000551c:	00f51b63          	bne	a0,a5,80005532 <sys_unlink+0x172>
    if(de.inum != 0)
    80005520:	f1845783          	lhu	a5,-232(s0)
    80005524:	e7a1                	bnez	a5,8000556c <sys_unlink+0x1ac>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005526:	29c1                	addiw	s3,s3,16
    80005528:	04c92783          	lw	a5,76(s2)
    8000552c:	fcf9ede3          	bltu	s3,a5,80005506 <sys_unlink+0x146>
    80005530:	bf35                	j	8000546c <sys_unlink+0xac>
      panic("isdirempty: readi");
    80005532:	00002517          	auipc	a0,0x2
    80005536:	27650513          	addi	a0,a0,630 # 800077a8 <userret+0x718>
    8000553a:	ffffb097          	auipc	ra,0xffffb
    8000553e:	00e080e7          	jalr	14(ra) # 80000548 <panic>
    panic("unlink: writei");
    80005542:	00002517          	auipc	a0,0x2
    80005546:	27e50513          	addi	a0,a0,638 # 800077c0 <userret+0x730>
    8000554a:	ffffb097          	auipc	ra,0xffffb
    8000554e:	ffe080e7          	jalr	-2(ra) # 80000548 <panic>
    dp->nlink--;
    80005552:	04a4d783          	lhu	a5,74(s1)
    80005556:	37fd                	addiw	a5,a5,-1
    80005558:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000555c:	8526                	mv	a0,s1
    8000555e:	ffffe097          	auipc	ra,0xffffe
    80005562:	da8080e7          	jalr	-600(ra) # 80003306 <iupdate>
    80005566:	bf35                	j	800054a2 <sys_unlink+0xe2>
    return -1;
    80005568:	557d                	li	a0,-1
    8000556a:	a00d                	j	8000558c <sys_unlink+0x1cc>
    iunlockput(ip);
    8000556c:	854a                	mv	a0,s2
    8000556e:	ffffe097          	auipc	ra,0xffffe
    80005572:	0a0080e7          	jalr	160(ra) # 8000360e <iunlockput>
  iunlockput(dp);
    80005576:	8526                	mv	a0,s1
    80005578:	ffffe097          	auipc	ra,0xffffe
    8000557c:	096080e7          	jalr	150(ra) # 8000360e <iunlockput>
  end_op(ROOTDEV);
    80005580:	4501                	li	a0,0
    80005582:	fffff097          	auipc	ra,0xfffff
    80005586:	9a2080e7          	jalr	-1630(ra) # 80003f24 <end_op>
  return -1;
    8000558a:	557d                	li	a0,-1
}
    8000558c:	70ae                	ld	ra,232(sp)
    8000558e:	740e                	ld	s0,224(sp)
    80005590:	64ee                	ld	s1,216(sp)
    80005592:	694e                	ld	s2,208(sp)
    80005594:	69ae                	ld	s3,200(sp)
    80005596:	616d                	addi	sp,sp,240
    80005598:	8082                	ret

000000008000559a <sys_open>:

uint64
sys_open(void)
{
    8000559a:	7131                	addi	sp,sp,-192
    8000559c:	fd06                	sd	ra,184(sp)
    8000559e:	f922                	sd	s0,176(sp)
    800055a0:	f526                	sd	s1,168(sp)
    800055a2:	f14a                	sd	s2,160(sp)
    800055a4:	ed4e                	sd	s3,152(sp)
    800055a6:	0180                	addi	s0,sp,192
  char path[MAXPATH];
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, path, MAXPATH) < 0 || argint(1, &omode) < 0)
    800055a8:	08000613          	li	a2,128
    800055ac:	f5040593          	addi	a1,s0,-176
    800055b0:	4501                	li	a0,0
    800055b2:	ffffd097          	auipc	ra,0xffffd
    800055b6:	320080e7          	jalr	800(ra) # 800028d2 <argstr>
    return -1;
    800055ba:	54fd                	li	s1,-1
  if(argstr(0, path, MAXPATH) < 0 || argint(1, &omode) < 0)
    800055bc:	0a054963          	bltz	a0,8000566e <sys_open+0xd4>
    800055c0:	f4c40593          	addi	a1,s0,-180
    800055c4:	4505                	li	a0,1
    800055c6:	ffffd097          	auipc	ra,0xffffd
    800055ca:	2c8080e7          	jalr	712(ra) # 8000288e <argint>
    800055ce:	0a054063          	bltz	a0,8000566e <sys_open+0xd4>

  begin_op(ROOTDEV);
    800055d2:	4501                	li	a0,0
    800055d4:	fffff097          	auipc	ra,0xfffff
    800055d8:	8a6080e7          	jalr	-1882(ra) # 80003e7a <begin_op>

  if(omode & O_CREATE){
    800055dc:	f4c42783          	lw	a5,-180(s0)
    800055e0:	2007f793          	andi	a5,a5,512
    800055e4:	c3dd                	beqz	a5,8000568a <sys_open+0xf0>
    ip = create(path, T_FILE, 0, 0);
    800055e6:	4681                	li	a3,0
    800055e8:	4601                	li	a2,0
    800055ea:	4589                	li	a1,2
    800055ec:	f5040513          	addi	a0,s0,-176
    800055f0:	00000097          	auipc	ra,0x0
    800055f4:	960080e7          	jalr	-1696(ra) # 80004f50 <create>
    800055f8:	892a                	mv	s2,a0
    if(ip == 0){
    800055fa:	c151                	beqz	a0,8000567e <sys_open+0xe4>
      end_op(ROOTDEV);
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800055fc:	04491703          	lh	a4,68(s2)
    80005600:	478d                	li	a5,3
    80005602:	00f71763          	bne	a4,a5,80005610 <sys_open+0x76>
    80005606:	04695703          	lhu	a4,70(s2)
    8000560a:	47a5                	li	a5,9
    8000560c:	0ce7e663          	bltu	a5,a4,800056d8 <sys_open+0x13e>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005610:	fffff097          	auipc	ra,0xfffff
    80005614:	dd6080e7          	jalr	-554(ra) # 800043e6 <filealloc>
    80005618:	89aa                	mv	s3,a0
    8000561a:	c57d                	beqz	a0,80005708 <sys_open+0x16e>
    8000561c:	00000097          	auipc	ra,0x0
    80005620:	8f2080e7          	jalr	-1806(ra) # 80004f0e <fdalloc>
    80005624:	84aa                	mv	s1,a0
    80005626:	0c054c63          	bltz	a0,800056fe <sys_open+0x164>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000562a:	04491703          	lh	a4,68(s2)
    8000562e:	478d                	li	a5,3
    80005630:	0cf70063          	beq	a4,a5,800056f0 <sys_open+0x156>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005634:	4789                	li	a5,2
    80005636:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000563a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    8000563e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005642:	f4c42783          	lw	a5,-180(s0)
    80005646:	0017c713          	xori	a4,a5,1
    8000564a:	8b05                	andi	a4,a4,1
    8000564c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005650:	8b8d                	andi	a5,a5,3
    80005652:	00f037b3          	snez	a5,a5
    80005656:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
    8000565a:	854a                	mv	a0,s2
    8000565c:	ffffe097          	auipc	ra,0xffffe
    80005660:	e36080e7          	jalr	-458(ra) # 80003492 <iunlock>
  end_op(ROOTDEV);
    80005664:	4501                	li	a0,0
    80005666:	fffff097          	auipc	ra,0xfffff
    8000566a:	8be080e7          	jalr	-1858(ra) # 80003f24 <end_op>

  return fd;
}
    8000566e:	8526                	mv	a0,s1
    80005670:	70ea                	ld	ra,184(sp)
    80005672:	744a                	ld	s0,176(sp)
    80005674:	74aa                	ld	s1,168(sp)
    80005676:	790a                	ld	s2,160(sp)
    80005678:	69ea                	ld	s3,152(sp)
    8000567a:	6129                	addi	sp,sp,192
    8000567c:	8082                	ret
      end_op(ROOTDEV);
    8000567e:	4501                	li	a0,0
    80005680:	fffff097          	auipc	ra,0xfffff
    80005684:	8a4080e7          	jalr	-1884(ra) # 80003f24 <end_op>
      return -1;
    80005688:	b7dd                	j	8000566e <sys_open+0xd4>
    if((ip = namei(path)) == 0){
    8000568a:	f5040513          	addi	a0,s0,-176
    8000568e:	ffffe097          	auipc	ra,0xffffe
    80005692:	4ce080e7          	jalr	1230(ra) # 80003b5c <namei>
    80005696:	892a                	mv	s2,a0
    80005698:	c90d                	beqz	a0,800056ca <sys_open+0x130>
    ilock(ip);
    8000569a:	ffffe097          	auipc	ra,0xffffe
    8000569e:	d36080e7          	jalr	-714(ra) # 800033d0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800056a2:	04491703          	lh	a4,68(s2)
    800056a6:	4785                	li	a5,1
    800056a8:	f4f71ae3          	bne	a4,a5,800055fc <sys_open+0x62>
    800056ac:	f4c42783          	lw	a5,-180(s0)
    800056b0:	d3a5                	beqz	a5,80005610 <sys_open+0x76>
      iunlockput(ip);
    800056b2:	854a                	mv	a0,s2
    800056b4:	ffffe097          	auipc	ra,0xffffe
    800056b8:	f5a080e7          	jalr	-166(ra) # 8000360e <iunlockput>
      end_op(ROOTDEV);
    800056bc:	4501                	li	a0,0
    800056be:	fffff097          	auipc	ra,0xfffff
    800056c2:	866080e7          	jalr	-1946(ra) # 80003f24 <end_op>
      return -1;
    800056c6:	54fd                	li	s1,-1
    800056c8:	b75d                	j	8000566e <sys_open+0xd4>
      end_op(ROOTDEV);
    800056ca:	4501                	li	a0,0
    800056cc:	fffff097          	auipc	ra,0xfffff
    800056d0:	858080e7          	jalr	-1960(ra) # 80003f24 <end_op>
      return -1;
    800056d4:	54fd                	li	s1,-1
    800056d6:	bf61                	j	8000566e <sys_open+0xd4>
    iunlockput(ip);
    800056d8:	854a                	mv	a0,s2
    800056da:	ffffe097          	auipc	ra,0xffffe
    800056de:	f34080e7          	jalr	-204(ra) # 8000360e <iunlockput>
    end_op(ROOTDEV);
    800056e2:	4501                	li	a0,0
    800056e4:	fffff097          	auipc	ra,0xfffff
    800056e8:	840080e7          	jalr	-1984(ra) # 80003f24 <end_op>
    return -1;
    800056ec:	54fd                	li	s1,-1
    800056ee:	b741                	j	8000566e <sys_open+0xd4>
    f->type = FD_DEVICE;
    800056f0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800056f4:	04691783          	lh	a5,70(s2)
    800056f8:	02f99223          	sh	a5,36(s3)
    800056fc:	b789                	j	8000563e <sys_open+0xa4>
      fileclose(f);
    800056fe:	854e                	mv	a0,s3
    80005700:	fffff097          	auipc	ra,0xfffff
    80005704:	da2080e7          	jalr	-606(ra) # 800044a2 <fileclose>
    iunlockput(ip);
    80005708:	854a                	mv	a0,s2
    8000570a:	ffffe097          	auipc	ra,0xffffe
    8000570e:	f04080e7          	jalr	-252(ra) # 8000360e <iunlockput>
    end_op(ROOTDEV);
    80005712:	4501                	li	a0,0
    80005714:	fffff097          	auipc	ra,0xfffff
    80005718:	810080e7          	jalr	-2032(ra) # 80003f24 <end_op>
    return -1;
    8000571c:	54fd                	li	s1,-1
    8000571e:	bf81                	j	8000566e <sys_open+0xd4>

0000000080005720 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005720:	7175                	addi	sp,sp,-144
    80005722:	e506                	sd	ra,136(sp)
    80005724:	e122                	sd	s0,128(sp)
    80005726:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op(ROOTDEV);
    80005728:	4501                	li	a0,0
    8000572a:	ffffe097          	auipc	ra,0xffffe
    8000572e:	750080e7          	jalr	1872(ra) # 80003e7a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005732:	08000613          	li	a2,128
    80005736:	f7040593          	addi	a1,s0,-144
    8000573a:	4501                	li	a0,0
    8000573c:	ffffd097          	auipc	ra,0xffffd
    80005740:	196080e7          	jalr	406(ra) # 800028d2 <argstr>
    80005744:	02054a63          	bltz	a0,80005778 <sys_mkdir+0x58>
    80005748:	4681                	li	a3,0
    8000574a:	4601                	li	a2,0
    8000574c:	4585                	li	a1,1
    8000574e:	f7040513          	addi	a0,s0,-144
    80005752:	fffff097          	auipc	ra,0xfffff
    80005756:	7fe080e7          	jalr	2046(ra) # 80004f50 <create>
    8000575a:	cd19                	beqz	a0,80005778 <sys_mkdir+0x58>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    8000575c:	ffffe097          	auipc	ra,0xffffe
    80005760:	eb2080e7          	jalr	-334(ra) # 8000360e <iunlockput>
  end_op(ROOTDEV);
    80005764:	4501                	li	a0,0
    80005766:	ffffe097          	auipc	ra,0xffffe
    8000576a:	7be080e7          	jalr	1982(ra) # 80003f24 <end_op>
  return 0;
    8000576e:	4501                	li	a0,0
}
    80005770:	60aa                	ld	ra,136(sp)
    80005772:	640a                	ld	s0,128(sp)
    80005774:	6149                	addi	sp,sp,144
    80005776:	8082                	ret
    end_op(ROOTDEV);
    80005778:	4501                	li	a0,0
    8000577a:	ffffe097          	auipc	ra,0xffffe
    8000577e:	7aa080e7          	jalr	1962(ra) # 80003f24 <end_op>
    return -1;
    80005782:	557d                	li	a0,-1
    80005784:	b7f5                	j	80005770 <sys_mkdir+0x50>

0000000080005786 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005786:	7135                	addi	sp,sp,-160
    80005788:	ed06                	sd	ra,152(sp)
    8000578a:	e922                	sd	s0,144(sp)
    8000578c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op(ROOTDEV);
    8000578e:	4501                	li	a0,0
    80005790:	ffffe097          	auipc	ra,0xffffe
    80005794:	6ea080e7          	jalr	1770(ra) # 80003e7a <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005798:	08000613          	li	a2,128
    8000579c:	f7040593          	addi	a1,s0,-144
    800057a0:	4501                	li	a0,0
    800057a2:	ffffd097          	auipc	ra,0xffffd
    800057a6:	130080e7          	jalr	304(ra) # 800028d2 <argstr>
    800057aa:	04054b63          	bltz	a0,80005800 <sys_mknod+0x7a>
     argint(1, &major) < 0 ||
    800057ae:	f6c40593          	addi	a1,s0,-148
    800057b2:	4505                	li	a0,1
    800057b4:	ffffd097          	auipc	ra,0xffffd
    800057b8:	0da080e7          	jalr	218(ra) # 8000288e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800057bc:	04054263          	bltz	a0,80005800 <sys_mknod+0x7a>
     argint(2, &minor) < 0 ||
    800057c0:	f6840593          	addi	a1,s0,-152
    800057c4:	4509                	li	a0,2
    800057c6:	ffffd097          	auipc	ra,0xffffd
    800057ca:	0c8080e7          	jalr	200(ra) # 8000288e <argint>
     argint(1, &major) < 0 ||
    800057ce:	02054963          	bltz	a0,80005800 <sys_mknod+0x7a>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800057d2:	f6841683          	lh	a3,-152(s0)
    800057d6:	f6c41603          	lh	a2,-148(s0)
    800057da:	458d                	li	a1,3
    800057dc:	f7040513          	addi	a0,s0,-144
    800057e0:	fffff097          	auipc	ra,0xfffff
    800057e4:	770080e7          	jalr	1904(ra) # 80004f50 <create>
     argint(2, &minor) < 0 ||
    800057e8:	cd01                	beqz	a0,80005800 <sys_mknod+0x7a>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    800057ea:	ffffe097          	auipc	ra,0xffffe
    800057ee:	e24080e7          	jalr	-476(ra) # 8000360e <iunlockput>
  end_op(ROOTDEV);
    800057f2:	4501                	li	a0,0
    800057f4:	ffffe097          	auipc	ra,0xffffe
    800057f8:	730080e7          	jalr	1840(ra) # 80003f24 <end_op>
  return 0;
    800057fc:	4501                	li	a0,0
    800057fe:	a039                	j	8000580c <sys_mknod+0x86>
    end_op(ROOTDEV);
    80005800:	4501                	li	a0,0
    80005802:	ffffe097          	auipc	ra,0xffffe
    80005806:	722080e7          	jalr	1826(ra) # 80003f24 <end_op>
    return -1;
    8000580a:	557d                	li	a0,-1
}
    8000580c:	60ea                	ld	ra,152(sp)
    8000580e:	644a                	ld	s0,144(sp)
    80005810:	610d                	addi	sp,sp,160
    80005812:	8082                	ret

0000000080005814 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005814:	7135                	addi	sp,sp,-160
    80005816:	ed06                	sd	ra,152(sp)
    80005818:	e922                	sd	s0,144(sp)
    8000581a:	e526                	sd	s1,136(sp)
    8000581c:	e14a                	sd	s2,128(sp)
    8000581e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005820:	ffffc097          	auipc	ra,0xffffc
    80005824:	ffe080e7          	jalr	-2(ra) # 8000181e <myproc>
    80005828:	892a                	mv	s2,a0
  
  begin_op(ROOTDEV);
    8000582a:	4501                	li	a0,0
    8000582c:	ffffe097          	auipc	ra,0xffffe
    80005830:	64e080e7          	jalr	1614(ra) # 80003e7a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005834:	08000613          	li	a2,128
    80005838:	f6040593          	addi	a1,s0,-160
    8000583c:	4501                	li	a0,0
    8000583e:	ffffd097          	auipc	ra,0xffffd
    80005842:	094080e7          	jalr	148(ra) # 800028d2 <argstr>
    80005846:	04054c63          	bltz	a0,8000589e <sys_chdir+0x8a>
    8000584a:	f6040513          	addi	a0,s0,-160
    8000584e:	ffffe097          	auipc	ra,0xffffe
    80005852:	30e080e7          	jalr	782(ra) # 80003b5c <namei>
    80005856:	84aa                	mv	s1,a0
    80005858:	c139                	beqz	a0,8000589e <sys_chdir+0x8a>
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    8000585a:	ffffe097          	auipc	ra,0xffffe
    8000585e:	b76080e7          	jalr	-1162(ra) # 800033d0 <ilock>
  if(ip->type != T_DIR){
    80005862:	04449703          	lh	a4,68(s1)
    80005866:	4785                	li	a5,1
    80005868:	04f71263          	bne	a4,a5,800058ac <sys_chdir+0x98>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }
  iunlock(ip);
    8000586c:	8526                	mv	a0,s1
    8000586e:	ffffe097          	auipc	ra,0xffffe
    80005872:	c24080e7          	jalr	-988(ra) # 80003492 <iunlock>
  iput(p->cwd);
    80005876:	14893503          	ld	a0,328(s2)
    8000587a:	ffffe097          	auipc	ra,0xffffe
    8000587e:	c64080e7          	jalr	-924(ra) # 800034de <iput>
  end_op(ROOTDEV);
    80005882:	4501                	li	a0,0
    80005884:	ffffe097          	auipc	ra,0xffffe
    80005888:	6a0080e7          	jalr	1696(ra) # 80003f24 <end_op>
  p->cwd = ip;
    8000588c:	14993423          	sd	s1,328(s2)
  return 0;
    80005890:	4501                	li	a0,0
}
    80005892:	60ea                	ld	ra,152(sp)
    80005894:	644a                	ld	s0,144(sp)
    80005896:	64aa                	ld	s1,136(sp)
    80005898:	690a                	ld	s2,128(sp)
    8000589a:	610d                	addi	sp,sp,160
    8000589c:	8082                	ret
    end_op(ROOTDEV);
    8000589e:	4501                	li	a0,0
    800058a0:	ffffe097          	auipc	ra,0xffffe
    800058a4:	684080e7          	jalr	1668(ra) # 80003f24 <end_op>
    return -1;
    800058a8:	557d                	li	a0,-1
    800058aa:	b7e5                	j	80005892 <sys_chdir+0x7e>
    iunlockput(ip);
    800058ac:	8526                	mv	a0,s1
    800058ae:	ffffe097          	auipc	ra,0xffffe
    800058b2:	d60080e7          	jalr	-672(ra) # 8000360e <iunlockput>
    end_op(ROOTDEV);
    800058b6:	4501                	li	a0,0
    800058b8:	ffffe097          	auipc	ra,0xffffe
    800058bc:	66c080e7          	jalr	1644(ra) # 80003f24 <end_op>
    return -1;
    800058c0:	557d                	li	a0,-1
    800058c2:	bfc1                	j	80005892 <sys_chdir+0x7e>

00000000800058c4 <sys_exec>:

uint64
sys_exec(void)
{
    800058c4:	7145                	addi	sp,sp,-464
    800058c6:	e786                	sd	ra,456(sp)
    800058c8:	e3a2                	sd	s0,448(sp)
    800058ca:	ff26                	sd	s1,440(sp)
    800058cc:	fb4a                	sd	s2,432(sp)
    800058ce:	f74e                	sd	s3,424(sp)
    800058d0:	f352                	sd	s4,416(sp)
    800058d2:	ef56                	sd	s5,408(sp)
    800058d4:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800058d6:	08000613          	li	a2,128
    800058da:	f4040593          	addi	a1,s0,-192
    800058de:	4501                	li	a0,0
    800058e0:	ffffd097          	auipc	ra,0xffffd
    800058e4:	ff2080e7          	jalr	-14(ra) # 800028d2 <argstr>
    800058e8:	0c054863          	bltz	a0,800059b8 <sys_exec+0xf4>
    800058ec:	e3840593          	addi	a1,s0,-456
    800058f0:	4505                	li	a0,1
    800058f2:	ffffd097          	auipc	ra,0xffffd
    800058f6:	fbe080e7          	jalr	-66(ra) # 800028b0 <argaddr>
    800058fa:	0c054963          	bltz	a0,800059cc <sys_exec+0x108>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    800058fe:	10000613          	li	a2,256
    80005902:	4581                	li	a1,0
    80005904:	e4040513          	addi	a0,s0,-448
    80005908:	ffffb097          	auipc	ra,0xffffb
    8000590c:	27a080e7          	jalr	634(ra) # 80000b82 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005910:	e4040993          	addi	s3,s0,-448
  memset(argv, 0, sizeof(argv));
    80005914:	894e                	mv	s2,s3
    80005916:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    80005918:	02000a13          	li	s4,32
    8000591c:	00048a9b          	sext.w	s5,s1
      return -1;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005920:	00349793          	slli	a5,s1,0x3
    80005924:	e3040593          	addi	a1,s0,-464
    80005928:	e3843503          	ld	a0,-456(s0)
    8000592c:	953e                	add	a0,a0,a5
    8000592e:	ffffd097          	auipc	ra,0xffffd
    80005932:	ec6080e7          	jalr	-314(ra) # 800027f4 <fetchaddr>
    80005936:	08054d63          	bltz	a0,800059d0 <sys_exec+0x10c>
      return -1;
    }
    if(uarg == 0){
    8000593a:	e3043783          	ld	a5,-464(s0)
    8000593e:	cb85                	beqz	a5,8000596e <sys_exec+0xaa>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005940:	ffffb097          	auipc	ra,0xffffb
    80005944:	010080e7          	jalr	16(ra) # 80000950 <kalloc>
    80005948:	85aa                	mv	a1,a0
    8000594a:	00a93023          	sd	a0,0(s2)
    if(argv[i] == 0)
    8000594e:	cd29                	beqz	a0,800059a8 <sys_exec+0xe4>
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
    80005950:	6605                	lui	a2,0x1
    80005952:	e3043503          	ld	a0,-464(s0)
    80005956:	ffffd097          	auipc	ra,0xffffd
    8000595a:	ef0080e7          	jalr	-272(ra) # 80002846 <fetchstr>
    8000595e:	06054b63          	bltz	a0,800059d4 <sys_exec+0x110>
    if(i >= NELEM(argv)){
    80005962:	0485                	addi	s1,s1,1
    80005964:	0921                	addi	s2,s2,8
    80005966:	fb449be3          	bne	s1,s4,8000591c <sys_exec+0x58>
      return -1;
    8000596a:	557d                	li	a0,-1
    8000596c:	a0b9                	j	800059ba <sys_exec+0xf6>
      argv[i] = 0;
    8000596e:	0a8e                	slli	s5,s5,0x3
    80005970:	fc040793          	addi	a5,s0,-64
    80005974:	9abe                	add	s5,s5,a5
    80005976:	e80ab023          	sd	zero,-384(s5)
      return -1;
    }
  }

  int ret = exec(path, argv);
    8000597a:	e4040593          	addi	a1,s0,-448
    8000597e:	f4040513          	addi	a0,s0,-192
    80005982:	fffff097          	auipc	ra,0xfffff
    80005986:	198080e7          	jalr	408(ra) # 80004b1a <exec>
    8000598a:	84aa                	mv	s1,a0

  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000598c:	10098913          	addi	s2,s3,256
    80005990:	0009b503          	ld	a0,0(s3)
    80005994:	c901                	beqz	a0,800059a4 <sys_exec+0xe0>
    kfree(argv[i]);
    80005996:	ffffb097          	auipc	ra,0xffffb
    8000599a:	ebe080e7          	jalr	-322(ra) # 80000854 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000599e:	09a1                	addi	s3,s3,8
    800059a0:	ff2998e3          	bne	s3,s2,80005990 <sys_exec+0xcc>

  return ret;
    800059a4:	8526                	mv	a0,s1
    800059a6:	a811                	j	800059ba <sys_exec+0xf6>
      panic("sys_exec kalloc");
    800059a8:	00002517          	auipc	a0,0x2
    800059ac:	e2850513          	addi	a0,a0,-472 # 800077d0 <userret+0x740>
    800059b0:	ffffb097          	auipc	ra,0xffffb
    800059b4:	b98080e7          	jalr	-1128(ra) # 80000548 <panic>
    return -1;
    800059b8:	557d                	li	a0,-1
}
    800059ba:	60be                	ld	ra,456(sp)
    800059bc:	641e                	ld	s0,448(sp)
    800059be:	74fa                	ld	s1,440(sp)
    800059c0:	795a                	ld	s2,432(sp)
    800059c2:	79ba                	ld	s3,424(sp)
    800059c4:	7a1a                	ld	s4,416(sp)
    800059c6:	6afa                	ld	s5,408(sp)
    800059c8:	6179                	addi	sp,sp,464
    800059ca:	8082                	ret
    return -1;
    800059cc:	557d                	li	a0,-1
    800059ce:	b7f5                	j	800059ba <sys_exec+0xf6>
      return -1;
    800059d0:	557d                	li	a0,-1
    800059d2:	b7e5                	j	800059ba <sys_exec+0xf6>
      return -1;
    800059d4:	557d                	li	a0,-1
    800059d6:	b7d5                	j	800059ba <sys_exec+0xf6>

00000000800059d8 <sys_pipe>:

uint64
sys_pipe(void)
{
    800059d8:	7139                	addi	sp,sp,-64
    800059da:	fc06                	sd	ra,56(sp)
    800059dc:	f822                	sd	s0,48(sp)
    800059de:	f426                	sd	s1,40(sp)
    800059e0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800059e2:	ffffc097          	auipc	ra,0xffffc
    800059e6:	e3c080e7          	jalr	-452(ra) # 8000181e <myproc>
    800059ea:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800059ec:	fd840593          	addi	a1,s0,-40
    800059f0:	4501                	li	a0,0
    800059f2:	ffffd097          	auipc	ra,0xffffd
    800059f6:	ebe080e7          	jalr	-322(ra) # 800028b0 <argaddr>
    return -1;
    800059fa:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800059fc:	0e054063          	bltz	a0,80005adc <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005a00:	fc840593          	addi	a1,s0,-56
    80005a04:	fd040513          	addi	a0,s0,-48
    80005a08:	fffff097          	auipc	ra,0xfffff
    80005a0c:	dce080e7          	jalr	-562(ra) # 800047d6 <pipealloc>
    return -1;
    80005a10:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005a12:	0c054563          	bltz	a0,80005adc <sys_pipe+0x104>
  fd0 = -1;
    80005a16:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005a1a:	fd043503          	ld	a0,-48(s0)
    80005a1e:	fffff097          	auipc	ra,0xfffff
    80005a22:	4f0080e7          	jalr	1264(ra) # 80004f0e <fdalloc>
    80005a26:	fca42223          	sw	a0,-60(s0)
    80005a2a:	08054c63          	bltz	a0,80005ac2 <sys_pipe+0xea>
    80005a2e:	fc843503          	ld	a0,-56(s0)
    80005a32:	fffff097          	auipc	ra,0xfffff
    80005a36:	4dc080e7          	jalr	1244(ra) # 80004f0e <fdalloc>
    80005a3a:	fca42023          	sw	a0,-64(s0)
    80005a3e:	06054863          	bltz	a0,80005aae <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005a42:	4691                	li	a3,4
    80005a44:	fc440613          	addi	a2,s0,-60
    80005a48:	fd843583          	ld	a1,-40(s0)
    80005a4c:	64a8                	ld	a0,72(s1)
    80005a4e:	ffffc097          	auipc	ra,0xffffc
    80005a52:	af4080e7          	jalr	-1292(ra) # 80001542 <copyout>
    80005a56:	02054063          	bltz	a0,80005a76 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005a5a:	4691                	li	a3,4
    80005a5c:	fc040613          	addi	a2,s0,-64
    80005a60:	fd843583          	ld	a1,-40(s0)
    80005a64:	0591                	addi	a1,a1,4
    80005a66:	64a8                	ld	a0,72(s1)
    80005a68:	ffffc097          	auipc	ra,0xffffc
    80005a6c:	ada080e7          	jalr	-1318(ra) # 80001542 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005a70:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005a72:	06055563          	bgez	a0,80005adc <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005a76:	fc442783          	lw	a5,-60(s0)
    80005a7a:	07e1                	addi	a5,a5,24
    80005a7c:	078e                	slli	a5,a5,0x3
    80005a7e:	97a6                	add	a5,a5,s1
    80005a80:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005a84:	fc042503          	lw	a0,-64(s0)
    80005a88:	0561                	addi	a0,a0,24
    80005a8a:	050e                	slli	a0,a0,0x3
    80005a8c:	9526                	add	a0,a0,s1
    80005a8e:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005a92:	fd043503          	ld	a0,-48(s0)
    80005a96:	fffff097          	auipc	ra,0xfffff
    80005a9a:	a0c080e7          	jalr	-1524(ra) # 800044a2 <fileclose>
    fileclose(wf);
    80005a9e:	fc843503          	ld	a0,-56(s0)
    80005aa2:	fffff097          	auipc	ra,0xfffff
    80005aa6:	a00080e7          	jalr	-1536(ra) # 800044a2 <fileclose>
    return -1;
    80005aaa:	57fd                	li	a5,-1
    80005aac:	a805                	j	80005adc <sys_pipe+0x104>
    if(fd0 >= 0)
    80005aae:	fc442783          	lw	a5,-60(s0)
    80005ab2:	0007c863          	bltz	a5,80005ac2 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005ab6:	01878513          	addi	a0,a5,24
    80005aba:	050e                	slli	a0,a0,0x3
    80005abc:	9526                	add	a0,a0,s1
    80005abe:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005ac2:	fd043503          	ld	a0,-48(s0)
    80005ac6:	fffff097          	auipc	ra,0xfffff
    80005aca:	9dc080e7          	jalr	-1572(ra) # 800044a2 <fileclose>
    fileclose(wf);
    80005ace:	fc843503          	ld	a0,-56(s0)
    80005ad2:	fffff097          	auipc	ra,0xfffff
    80005ad6:	9d0080e7          	jalr	-1584(ra) # 800044a2 <fileclose>
    return -1;
    80005ada:	57fd                	li	a5,-1
}
    80005adc:	853e                	mv	a0,a5
    80005ade:	70e2                	ld	ra,56(sp)
    80005ae0:	7442                	ld	s0,48(sp)
    80005ae2:	74a2                	ld	s1,40(sp)
    80005ae4:	6121                	addi	sp,sp,64
    80005ae6:	8082                	ret

0000000080005ae8 <sys_crash>:

// system call to test crashes
uint64
sys_crash(void)
{
    80005ae8:	7171                	addi	sp,sp,-176
    80005aea:	f506                	sd	ra,168(sp)
    80005aec:	f122                	sd	s0,160(sp)
    80005aee:	ed26                	sd	s1,152(sp)
    80005af0:	1900                	addi	s0,sp,176
  char path[MAXPATH];
  struct inode *ip;
  int crash;
  
  if(argstr(0, path, MAXPATH) < 0 || argint(1, &crash) < 0)
    80005af2:	08000613          	li	a2,128
    80005af6:	f6040593          	addi	a1,s0,-160
    80005afa:	4501                	li	a0,0
    80005afc:	ffffd097          	auipc	ra,0xffffd
    80005b00:	dd6080e7          	jalr	-554(ra) # 800028d2 <argstr>
    return -1;
    80005b04:	57fd                	li	a5,-1
  if(argstr(0, path, MAXPATH) < 0 || argint(1, &crash) < 0)
    80005b06:	04054363          	bltz	a0,80005b4c <sys_crash+0x64>
    80005b0a:	f5c40593          	addi	a1,s0,-164
    80005b0e:	4505                	li	a0,1
    80005b10:	ffffd097          	auipc	ra,0xffffd
    80005b14:	d7e080e7          	jalr	-642(ra) # 8000288e <argint>
    return -1;
    80005b18:	57fd                	li	a5,-1
  if(argstr(0, path, MAXPATH) < 0 || argint(1, &crash) < 0)
    80005b1a:	02054963          	bltz	a0,80005b4c <sys_crash+0x64>
  ip = create(path, T_FILE, 0, 0);
    80005b1e:	4681                	li	a3,0
    80005b20:	4601                	li	a2,0
    80005b22:	4589                	li	a1,2
    80005b24:	f6040513          	addi	a0,s0,-160
    80005b28:	fffff097          	auipc	ra,0xfffff
    80005b2c:	428080e7          	jalr	1064(ra) # 80004f50 <create>
    80005b30:	84aa                	mv	s1,a0
  if(ip == 0){
    80005b32:	c11d                	beqz	a0,80005b58 <sys_crash+0x70>
    return -1;
  }
  iunlockput(ip);
    80005b34:	ffffe097          	auipc	ra,0xffffe
    80005b38:	ada080e7          	jalr	-1318(ra) # 8000360e <iunlockput>
  crash_op(ip->dev, crash);
    80005b3c:	f5c42583          	lw	a1,-164(s0)
    80005b40:	4088                	lw	a0,0(s1)
    80005b42:	ffffe097          	auipc	ra,0xffffe
    80005b46:	634080e7          	jalr	1588(ra) # 80004176 <crash_op>
  return 0;
    80005b4a:	4781                	li	a5,0
}
    80005b4c:	853e                	mv	a0,a5
    80005b4e:	70aa                	ld	ra,168(sp)
    80005b50:	740a                	ld	s0,160(sp)
    80005b52:	64ea                	ld	s1,152(sp)
    80005b54:	614d                	addi	sp,sp,176
    80005b56:	8082                	ret
    return -1;
    80005b58:	57fd                	li	a5,-1
    80005b5a:	bfcd                	j	80005b4c <sys_crash+0x64>
    80005b5c:	0000                	unimp
	...

0000000080005b60 <kernelvec>:
    80005b60:	7111                	addi	sp,sp,-256
    80005b62:	e006                	sd	ra,0(sp)
    80005b64:	e40a                	sd	sp,8(sp)
    80005b66:	e80e                	sd	gp,16(sp)
    80005b68:	ec12                	sd	tp,24(sp)
    80005b6a:	f016                	sd	t0,32(sp)
    80005b6c:	f41a                	sd	t1,40(sp)
    80005b6e:	f81e                	sd	t2,48(sp)
    80005b70:	fc22                	sd	s0,56(sp)
    80005b72:	e0a6                	sd	s1,64(sp)
    80005b74:	e4aa                	sd	a0,72(sp)
    80005b76:	e8ae                	sd	a1,80(sp)
    80005b78:	ecb2                	sd	a2,88(sp)
    80005b7a:	f0b6                	sd	a3,96(sp)
    80005b7c:	f4ba                	sd	a4,104(sp)
    80005b7e:	f8be                	sd	a5,112(sp)
    80005b80:	fcc2                	sd	a6,120(sp)
    80005b82:	e146                	sd	a7,128(sp)
    80005b84:	e54a                	sd	s2,136(sp)
    80005b86:	e94e                	sd	s3,144(sp)
    80005b88:	ed52                	sd	s4,152(sp)
    80005b8a:	f156                	sd	s5,160(sp)
    80005b8c:	f55a                	sd	s6,168(sp)
    80005b8e:	f95e                	sd	s7,176(sp)
    80005b90:	fd62                	sd	s8,184(sp)
    80005b92:	e1e6                	sd	s9,192(sp)
    80005b94:	e5ea                	sd	s10,200(sp)
    80005b96:	e9ee                	sd	s11,208(sp)
    80005b98:	edf2                	sd	t3,216(sp)
    80005b9a:	f1f6                	sd	t4,224(sp)
    80005b9c:	f5fa                	sd	t5,232(sp)
    80005b9e:	f9fe                	sd	t6,240(sp)
    80005ba0:	b21fc0ef          	jal	ra,800026c0 <kerneltrap>
    80005ba4:	6082                	ld	ra,0(sp)
    80005ba6:	6122                	ld	sp,8(sp)
    80005ba8:	61c2                	ld	gp,16(sp)
    80005baa:	7282                	ld	t0,32(sp)
    80005bac:	7322                	ld	t1,40(sp)
    80005bae:	73c2                	ld	t2,48(sp)
    80005bb0:	7462                	ld	s0,56(sp)
    80005bb2:	6486                	ld	s1,64(sp)
    80005bb4:	6526                	ld	a0,72(sp)
    80005bb6:	65c6                	ld	a1,80(sp)
    80005bb8:	6666                	ld	a2,88(sp)
    80005bba:	7686                	ld	a3,96(sp)
    80005bbc:	7726                	ld	a4,104(sp)
    80005bbe:	77c6                	ld	a5,112(sp)
    80005bc0:	7866                	ld	a6,120(sp)
    80005bc2:	688a                	ld	a7,128(sp)
    80005bc4:	692a                	ld	s2,136(sp)
    80005bc6:	69ca                	ld	s3,144(sp)
    80005bc8:	6a6a                	ld	s4,152(sp)
    80005bca:	7a8a                	ld	s5,160(sp)
    80005bcc:	7b2a                	ld	s6,168(sp)
    80005bce:	7bca                	ld	s7,176(sp)
    80005bd0:	7c6a                	ld	s8,184(sp)
    80005bd2:	6c8e                	ld	s9,192(sp)
    80005bd4:	6d2e                	ld	s10,200(sp)
    80005bd6:	6dce                	ld	s11,208(sp)
    80005bd8:	6e6e                	ld	t3,216(sp)
    80005bda:	7e8e                	ld	t4,224(sp)
    80005bdc:	7f2e                	ld	t5,232(sp)
    80005bde:	7fce                	ld	t6,240(sp)
    80005be0:	6111                	addi	sp,sp,256
    80005be2:	10200073          	sret
    80005be6:	00000013          	nop
    80005bea:	00000013          	nop
    80005bee:	0001                	nop

0000000080005bf0 <timervec>:
    80005bf0:	34051573          	csrrw	a0,mscratch,a0
    80005bf4:	e10c                	sd	a1,0(a0)
    80005bf6:	e510                	sd	a2,8(a0)
    80005bf8:	e914                	sd	a3,16(a0)
    80005bfa:	710c                	ld	a1,32(a0)
    80005bfc:	7510                	ld	a2,40(a0)
    80005bfe:	6194                	ld	a3,0(a1)
    80005c00:	96b2                	add	a3,a3,a2
    80005c02:	e194                	sd	a3,0(a1)
    80005c04:	4589                	li	a1,2
    80005c06:	14459073          	csrw	sip,a1
    80005c0a:	6914                	ld	a3,16(a0)
    80005c0c:	6510                	ld	a2,8(a0)
    80005c0e:	610c                	ld	a1,0(a0)
    80005c10:	34051573          	csrrw	a0,mscratch,a0
    80005c14:	30200073          	mret
	...

0000000080005c1a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005c1a:	1141                	addi	sp,sp,-16
    80005c1c:	e422                	sd	s0,8(sp)
    80005c1e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005c20:	0c0007b7          	lui	a5,0xc000
    80005c24:	4705                	li	a4,1
    80005c26:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005c28:	c3d8                	sw	a4,4(a5)
}
    80005c2a:	6422                	ld	s0,8(sp)
    80005c2c:	0141                	addi	sp,sp,16
    80005c2e:	8082                	ret

0000000080005c30 <plicinithart>:

void
plicinithart(void)
{
    80005c30:	1141                	addi	sp,sp,-16
    80005c32:	e406                	sd	ra,8(sp)
    80005c34:	e022                	sd	s0,0(sp)
    80005c36:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005c38:	ffffc097          	auipc	ra,0xffffc
    80005c3c:	bba080e7          	jalr	-1094(ra) # 800017f2 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005c40:	0085171b          	slliw	a4,a0,0x8
    80005c44:	0c0027b7          	lui	a5,0xc002
    80005c48:	97ba                	add	a5,a5,a4
    80005c4a:	40200713          	li	a4,1026
    80005c4e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005c52:	00d5151b          	slliw	a0,a0,0xd
    80005c56:	0c2017b7          	lui	a5,0xc201
    80005c5a:	953e                	add	a0,a0,a5
    80005c5c:	00052023          	sw	zero,0(a0)
}
    80005c60:	60a2                	ld	ra,8(sp)
    80005c62:	6402                	ld	s0,0(sp)
    80005c64:	0141                	addi	sp,sp,16
    80005c66:	8082                	ret

0000000080005c68 <plic_pending>:

// return a bitmap of which IRQs are waiting
// to be served.
uint64
plic_pending(void)
{
    80005c68:	1141                	addi	sp,sp,-16
    80005c6a:	e422                	sd	s0,8(sp)
    80005c6c:	0800                	addi	s0,sp,16
  //mask = *(uint32*)(PLIC + 0x1000);
  //mask |= (uint64)*(uint32*)(PLIC + 0x1004) << 32;
  mask = *(uint64*)PLIC_PENDING;

  return mask;
}
    80005c6e:	0c0017b7          	lui	a5,0xc001
    80005c72:	6388                	ld	a0,0(a5)
    80005c74:	6422                	ld	s0,8(sp)
    80005c76:	0141                	addi	sp,sp,16
    80005c78:	8082                	ret

0000000080005c7a <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005c7a:	1141                	addi	sp,sp,-16
    80005c7c:	e406                	sd	ra,8(sp)
    80005c7e:	e022                	sd	s0,0(sp)
    80005c80:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005c82:	ffffc097          	auipc	ra,0xffffc
    80005c86:	b70080e7          	jalr	-1168(ra) # 800017f2 <cpuid>
  //int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005c8a:	00d5179b          	slliw	a5,a0,0xd
    80005c8e:	0c201537          	lui	a0,0xc201
    80005c92:	953e                	add	a0,a0,a5
  return irq;
}
    80005c94:	4148                	lw	a0,4(a0)
    80005c96:	60a2                	ld	ra,8(sp)
    80005c98:	6402                	ld	s0,0(sp)
    80005c9a:	0141                	addi	sp,sp,16
    80005c9c:	8082                	ret

0000000080005c9e <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005c9e:	1101                	addi	sp,sp,-32
    80005ca0:	ec06                	sd	ra,24(sp)
    80005ca2:	e822                	sd	s0,16(sp)
    80005ca4:	e426                	sd	s1,8(sp)
    80005ca6:	1000                	addi	s0,sp,32
    80005ca8:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005caa:	ffffc097          	auipc	ra,0xffffc
    80005cae:	b48080e7          	jalr	-1208(ra) # 800017f2 <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005cb2:	00d5151b          	slliw	a0,a0,0xd
    80005cb6:	0c2017b7          	lui	a5,0xc201
    80005cba:	97aa                	add	a5,a5,a0
    80005cbc:	c3c4                	sw	s1,4(a5)
}
    80005cbe:	60e2                	ld	ra,24(sp)
    80005cc0:	6442                	ld	s0,16(sp)
    80005cc2:	64a2                	ld	s1,8(sp)
    80005cc4:	6105                	addi	sp,sp,32
    80005cc6:	8082                	ret

0000000080005cc8 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int n, int i)
{
    80005cc8:	1141                	addi	sp,sp,-16
    80005cca:	e406                	sd	ra,8(sp)
    80005ccc:	e022                	sd	s0,0(sp)
    80005cce:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005cd0:	479d                	li	a5,7
    80005cd2:	06b7c963          	blt	a5,a1,80005d44 <free_desc+0x7c>
    panic("virtio_disk_intr 1");
  if(disk[n].free[i])
    80005cd6:	00151793          	slli	a5,a0,0x1
    80005cda:	97aa                	add	a5,a5,a0
    80005cdc:	00c79713          	slli	a4,a5,0xc
    80005ce0:	0001d797          	auipc	a5,0x1d
    80005ce4:	32078793          	addi	a5,a5,800 # 80023000 <disk>
    80005ce8:	97ba                	add	a5,a5,a4
    80005cea:	97ae                	add	a5,a5,a1
    80005cec:	6709                	lui	a4,0x2
    80005cee:	97ba                	add	a5,a5,a4
    80005cf0:	0187c783          	lbu	a5,24(a5)
    80005cf4:	e3a5                	bnez	a5,80005d54 <free_desc+0x8c>
    panic("virtio_disk_intr 2");
  disk[n].desc[i].addr = 0;
    80005cf6:	0001d817          	auipc	a6,0x1d
    80005cfa:	30a80813          	addi	a6,a6,778 # 80023000 <disk>
    80005cfe:	00151693          	slli	a3,a0,0x1
    80005d02:	00a68733          	add	a4,a3,a0
    80005d06:	0732                	slli	a4,a4,0xc
    80005d08:	00e807b3          	add	a5,a6,a4
    80005d0c:	6709                	lui	a4,0x2
    80005d0e:	00f70633          	add	a2,a4,a5
    80005d12:	6210                	ld	a2,0(a2)
    80005d14:	00459893          	slli	a7,a1,0x4
    80005d18:	9646                	add	a2,a2,a7
    80005d1a:	00063023          	sd	zero,0(a2) # 1000 <_entry-0x7ffff000>
  disk[n].free[i] = 1;
    80005d1e:	97ae                	add	a5,a5,a1
    80005d20:	97ba                	add	a5,a5,a4
    80005d22:	4605                	li	a2,1
    80005d24:	00c78c23          	sb	a2,24(a5)
  wakeup(&disk[n].free[0]);
    80005d28:	96aa                	add	a3,a3,a0
    80005d2a:	06b2                	slli	a3,a3,0xc
    80005d2c:	0761                	addi	a4,a4,24
    80005d2e:	96ba                	add	a3,a3,a4
    80005d30:	00d80533          	add	a0,a6,a3
    80005d34:	ffffc097          	auipc	ra,0xffffc
    80005d38:	43a080e7          	jalr	1082(ra) # 8000216e <wakeup>
}
    80005d3c:	60a2                	ld	ra,8(sp)
    80005d3e:	6402                	ld	s0,0(sp)
    80005d40:	0141                	addi	sp,sp,16
    80005d42:	8082                	ret
    panic("virtio_disk_intr 1");
    80005d44:	00002517          	auipc	a0,0x2
    80005d48:	a9c50513          	addi	a0,a0,-1380 # 800077e0 <userret+0x750>
    80005d4c:	ffffa097          	auipc	ra,0xffffa
    80005d50:	7fc080e7          	jalr	2044(ra) # 80000548 <panic>
    panic("virtio_disk_intr 2");
    80005d54:	00002517          	auipc	a0,0x2
    80005d58:	aa450513          	addi	a0,a0,-1372 # 800077f8 <userret+0x768>
    80005d5c:	ffffa097          	auipc	ra,0xffffa
    80005d60:	7ec080e7          	jalr	2028(ra) # 80000548 <panic>

0000000080005d64 <virtio_disk_init>:
  __sync_synchronize();
    80005d64:	0ff0000f          	fence
  if(disk[n].init)
    80005d68:	00151793          	slli	a5,a0,0x1
    80005d6c:	97aa                	add	a5,a5,a0
    80005d6e:	07b2                	slli	a5,a5,0xc
    80005d70:	0001d717          	auipc	a4,0x1d
    80005d74:	29070713          	addi	a4,a4,656 # 80023000 <disk>
    80005d78:	973e                	add	a4,a4,a5
    80005d7a:	6789                	lui	a5,0x2
    80005d7c:	97ba                	add	a5,a5,a4
    80005d7e:	0a87a783          	lw	a5,168(a5) # 20a8 <_entry-0x7fffdf58>
    80005d82:	c391                	beqz	a5,80005d86 <virtio_disk_init+0x22>
    80005d84:	8082                	ret
{
    80005d86:	7139                	addi	sp,sp,-64
    80005d88:	fc06                	sd	ra,56(sp)
    80005d8a:	f822                	sd	s0,48(sp)
    80005d8c:	f426                	sd	s1,40(sp)
    80005d8e:	f04a                	sd	s2,32(sp)
    80005d90:	ec4e                	sd	s3,24(sp)
    80005d92:	e852                	sd	s4,16(sp)
    80005d94:	e456                	sd	s5,8(sp)
    80005d96:	0080                	addi	s0,sp,64
    80005d98:	84aa                	mv	s1,a0
  printf("virtio disk init %d\n", n);
    80005d9a:	85aa                	mv	a1,a0
    80005d9c:	00002517          	auipc	a0,0x2
    80005da0:	a7450513          	addi	a0,a0,-1420 # 80007810 <userret+0x780>
    80005da4:	ffffa097          	auipc	ra,0xffffa
    80005da8:	7ee080e7          	jalr	2030(ra) # 80000592 <printf>
  initlock(&disk[n].vdisk_lock, "virtio_disk");
    80005dac:	00149993          	slli	s3,s1,0x1
    80005db0:	99a6                	add	s3,s3,s1
    80005db2:	09b2                	slli	s3,s3,0xc
    80005db4:	6789                	lui	a5,0x2
    80005db6:	0b078793          	addi	a5,a5,176 # 20b0 <_entry-0x7fffdf50>
    80005dba:	97ce                	add	a5,a5,s3
    80005dbc:	00002597          	auipc	a1,0x2
    80005dc0:	a6c58593          	addi	a1,a1,-1428 # 80007828 <userret+0x798>
    80005dc4:	0001d517          	auipc	a0,0x1d
    80005dc8:	23c50513          	addi	a0,a0,572 # 80023000 <disk>
    80005dcc:	953e                	add	a0,a0,a5
    80005dce:	ffffb097          	auipc	ra,0xffffb
    80005dd2:	be2080e7          	jalr	-1054(ra) # 800009b0 <initlock>
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005dd6:	0014891b          	addiw	s2,s1,1
    80005dda:	00c9191b          	slliw	s2,s2,0xc
    80005dde:	100007b7          	lui	a5,0x10000
    80005de2:	97ca                	add	a5,a5,s2
    80005de4:	4398                	lw	a4,0(a5)
    80005de6:	2701                	sext.w	a4,a4
    80005de8:	747277b7          	lui	a5,0x74727
    80005dec:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005df0:	12f71663          	bne	a4,a5,80005f1c <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80005df4:	100007b7          	lui	a5,0x10000
    80005df8:	0791                	addi	a5,a5,4
    80005dfa:	97ca                	add	a5,a5,s2
    80005dfc:	439c                	lw	a5,0(a5)
    80005dfe:	2781                	sext.w	a5,a5
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e00:	4705                	li	a4,1
    80005e02:	10e79d63          	bne	a5,a4,80005f1c <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e06:	100007b7          	lui	a5,0x10000
    80005e0a:	07a1                	addi	a5,a5,8
    80005e0c:	97ca                	add	a5,a5,s2
    80005e0e:	439c                	lw	a5,0(a5)
    80005e10:	2781                	sext.w	a5,a5
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80005e12:	4709                	li	a4,2
    80005e14:	10e79463          	bne	a5,a4,80005f1c <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005e18:	100007b7          	lui	a5,0x10000
    80005e1c:	07b1                	addi	a5,a5,12
    80005e1e:	97ca                	add	a5,a5,s2
    80005e20:	4398                	lw	a4,0(a5)
    80005e22:	2701                	sext.w	a4,a4
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e24:	554d47b7          	lui	a5,0x554d4
    80005e28:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005e2c:	0ef71863          	bne	a4,a5,80005f1c <virtio_disk_init+0x1b8>
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005e30:	100007b7          	lui	a5,0x10000
    80005e34:	07078693          	addi	a3,a5,112 # 10000070 <_entry-0x6fffff90>
    80005e38:	96ca                	add	a3,a3,s2
    80005e3a:	4705                	li	a4,1
    80005e3c:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005e3e:	470d                	li	a4,3
    80005e40:	c298                	sw	a4,0(a3)
  uint64 features = *R(n, VIRTIO_MMIO_DEVICE_FEATURES);
    80005e42:	01078713          	addi	a4,a5,16
    80005e46:	974a                	add	a4,a4,s2
    80005e48:	430c                	lw	a1,0(a4)
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005e4a:	02078613          	addi	a2,a5,32
    80005e4e:	964a                	add	a2,a2,s2
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005e50:	c7ffe737          	lui	a4,0xc7ffe
    80005e54:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <ticks+0xffffffff47fd5737>
    80005e58:	8f6d                	and	a4,a4,a1
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005e5a:	2701                	sext.w	a4,a4
    80005e5c:	c218                	sw	a4,0(a2)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005e5e:	472d                	li	a4,11
    80005e60:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005e62:	473d                	li	a4,15
    80005e64:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005e66:	02878713          	addi	a4,a5,40
    80005e6a:	974a                	add	a4,a4,s2
    80005e6c:	6685                	lui	a3,0x1
    80005e6e:	c314                	sw	a3,0(a4)
  *R(n, VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005e70:	03078713          	addi	a4,a5,48
    80005e74:	974a                	add	a4,a4,s2
    80005e76:	00072023          	sw	zero,0(a4)
  uint32 max = *R(n, VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005e7a:	03478793          	addi	a5,a5,52
    80005e7e:	97ca                	add	a5,a5,s2
    80005e80:	439c                	lw	a5,0(a5)
    80005e82:	2781                	sext.w	a5,a5
  if(max == 0)
    80005e84:	c7c5                	beqz	a5,80005f2c <virtio_disk_init+0x1c8>
  if(max < NUM)
    80005e86:	471d                	li	a4,7
    80005e88:	0af77a63          	bgeu	a4,a5,80005f3c <virtio_disk_init+0x1d8>
  *R(n, VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005e8c:	10000ab7          	lui	s5,0x10000
    80005e90:	038a8793          	addi	a5,s5,56 # 10000038 <_entry-0x6fffffc8>
    80005e94:	97ca                	add	a5,a5,s2
    80005e96:	4721                	li	a4,8
    80005e98:	c398                	sw	a4,0(a5)
  memset(disk[n].pages, 0, sizeof(disk[n].pages));
    80005e9a:	0001da17          	auipc	s4,0x1d
    80005e9e:	166a0a13          	addi	s4,s4,358 # 80023000 <disk>
    80005ea2:	99d2                	add	s3,s3,s4
    80005ea4:	6609                	lui	a2,0x2
    80005ea6:	4581                	li	a1,0
    80005ea8:	854e                	mv	a0,s3
    80005eaa:	ffffb097          	auipc	ra,0xffffb
    80005eae:	cd8080e7          	jalr	-808(ra) # 80000b82 <memset>
  *R(n, VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk[n].pages) >> PGSHIFT;
    80005eb2:	040a8a93          	addi	s5,s5,64
    80005eb6:	9956                	add	s2,s2,s5
    80005eb8:	00c9d793          	srli	a5,s3,0xc
    80005ebc:	2781                	sext.w	a5,a5
    80005ebe:	00f92023          	sw	a5,0(s2)
  disk[n].desc = (struct VRingDesc *) disk[n].pages;
    80005ec2:	00149693          	slli	a3,s1,0x1
    80005ec6:	009687b3          	add	a5,a3,s1
    80005eca:	07b2                	slli	a5,a5,0xc
    80005ecc:	97d2                	add	a5,a5,s4
    80005ece:	6609                	lui	a2,0x2
    80005ed0:	97b2                	add	a5,a5,a2
    80005ed2:	0137b023          	sd	s3,0(a5)
  disk[n].avail = (uint16*)(((char*)disk[n].desc) + NUM*sizeof(struct VRingDesc));
    80005ed6:	08098713          	addi	a4,s3,128
    80005eda:	e798                	sd	a4,8(a5)
  disk[n].used = (struct UsedArea *) (disk[n].pages + PGSIZE);
    80005edc:	6705                	lui	a4,0x1
    80005ede:	99ba                	add	s3,s3,a4
    80005ee0:	0137b823          	sd	s3,16(a5)
    disk[n].free[i] = 1;
    80005ee4:	4705                	li	a4,1
    80005ee6:	00e78c23          	sb	a4,24(a5)
    80005eea:	00e78ca3          	sb	a4,25(a5)
    80005eee:	00e78d23          	sb	a4,26(a5)
    80005ef2:	00e78da3          	sb	a4,27(a5)
    80005ef6:	00e78e23          	sb	a4,28(a5)
    80005efa:	00e78ea3          	sb	a4,29(a5)
    80005efe:	00e78f23          	sb	a4,30(a5)
    80005f02:	00e78fa3          	sb	a4,31(a5)
  disk[n].init = 1;
    80005f06:	0ae7a423          	sw	a4,168(a5)
}
    80005f0a:	70e2                	ld	ra,56(sp)
    80005f0c:	7442                	ld	s0,48(sp)
    80005f0e:	74a2                	ld	s1,40(sp)
    80005f10:	7902                	ld	s2,32(sp)
    80005f12:	69e2                	ld	s3,24(sp)
    80005f14:	6a42                	ld	s4,16(sp)
    80005f16:	6aa2                	ld	s5,8(sp)
    80005f18:	6121                	addi	sp,sp,64
    80005f1a:	8082                	ret
    panic("could not find virtio disk");
    80005f1c:	00002517          	auipc	a0,0x2
    80005f20:	91c50513          	addi	a0,a0,-1764 # 80007838 <userret+0x7a8>
    80005f24:	ffffa097          	auipc	ra,0xffffa
    80005f28:	624080e7          	jalr	1572(ra) # 80000548 <panic>
    panic("virtio disk has no queue 0");
    80005f2c:	00002517          	auipc	a0,0x2
    80005f30:	92c50513          	addi	a0,a0,-1748 # 80007858 <userret+0x7c8>
    80005f34:	ffffa097          	auipc	ra,0xffffa
    80005f38:	614080e7          	jalr	1556(ra) # 80000548 <panic>
    panic("virtio disk max queue too short");
    80005f3c:	00002517          	auipc	a0,0x2
    80005f40:	93c50513          	addi	a0,a0,-1732 # 80007878 <userret+0x7e8>
    80005f44:	ffffa097          	auipc	ra,0xffffa
    80005f48:	604080e7          	jalr	1540(ra) # 80000548 <panic>

0000000080005f4c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(int n, struct buf *b, int write)
{
    80005f4c:	7135                	addi	sp,sp,-160
    80005f4e:	ed06                	sd	ra,152(sp)
    80005f50:	e922                	sd	s0,144(sp)
    80005f52:	e526                	sd	s1,136(sp)
    80005f54:	e14a                	sd	s2,128(sp)
    80005f56:	fcce                	sd	s3,120(sp)
    80005f58:	f8d2                	sd	s4,112(sp)
    80005f5a:	f4d6                	sd	s5,104(sp)
    80005f5c:	f0da                	sd	s6,96(sp)
    80005f5e:	ecde                	sd	s7,88(sp)
    80005f60:	e8e2                	sd	s8,80(sp)
    80005f62:	e4e6                	sd	s9,72(sp)
    80005f64:	e0ea                	sd	s10,64(sp)
    80005f66:	fc6e                	sd	s11,56(sp)
    80005f68:	1100                	addi	s0,sp,160
    80005f6a:	8aaa                	mv	s5,a0
    80005f6c:	8c2e                	mv	s8,a1
    80005f6e:	8db2                	mv	s11,a2
  uint64 sector = b->blockno * (BSIZE / 512);
    80005f70:	45dc                	lw	a5,12(a1)
    80005f72:	0017979b          	slliw	a5,a5,0x1
    80005f76:	1782                	slli	a5,a5,0x20
    80005f78:	9381                	srli	a5,a5,0x20
    80005f7a:	f6f43423          	sd	a5,-152(s0)

  acquire(&disk[n].vdisk_lock);
    80005f7e:	00151493          	slli	s1,a0,0x1
    80005f82:	94aa                	add	s1,s1,a0
    80005f84:	04b2                	slli	s1,s1,0xc
    80005f86:	6909                	lui	s2,0x2
    80005f88:	0b090c93          	addi	s9,s2,176 # 20b0 <_entry-0x7fffdf50>
    80005f8c:	9ca6                	add	s9,s9,s1
    80005f8e:	0001d997          	auipc	s3,0x1d
    80005f92:	07298993          	addi	s3,s3,114 # 80023000 <disk>
    80005f96:	9cce                	add	s9,s9,s3
    80005f98:	8566                	mv	a0,s9
    80005f9a:	ffffb097          	auipc	ra,0xffffb
    80005f9e:	b24080e7          	jalr	-1244(ra) # 80000abe <acquire>
  int idx[3];
  while(1){
    if(alloc3_desc(n, idx) == 0) {
      break;
    }
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    80005fa2:	0961                	addi	s2,s2,24
    80005fa4:	94ca                	add	s1,s1,s2
    80005fa6:	99a6                	add	s3,s3,s1
  for(int i = 0; i < 3; i++){
    80005fa8:	4a01                	li	s4,0
  for(int i = 0; i < NUM; i++){
    80005faa:	44a1                	li	s1,8
      disk[n].free[i] = 0;
    80005fac:	001a9793          	slli	a5,s5,0x1
    80005fb0:	97d6                	add	a5,a5,s5
    80005fb2:	07b2                	slli	a5,a5,0xc
    80005fb4:	0001db97          	auipc	s7,0x1d
    80005fb8:	04cb8b93          	addi	s7,s7,76 # 80023000 <disk>
    80005fbc:	9bbe                	add	s7,s7,a5
    80005fbe:	a8a9                	j	80006018 <virtio_disk_rw+0xcc>
    80005fc0:	00fb8733          	add	a4,s7,a5
    80005fc4:	9742                	add	a4,a4,a6
    80005fc6:	00070c23          	sb	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    idx[i] = alloc_desc(n);
    80005fca:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005fcc:	0207c263          	bltz	a5,80005ff0 <virtio_disk_rw+0xa4>
  for(int i = 0; i < 3; i++){
    80005fd0:	2905                	addiw	s2,s2,1
    80005fd2:	0611                	addi	a2,a2,4
    80005fd4:	1ca90463          	beq	s2,a0,8000619c <virtio_disk_rw+0x250>
    idx[i] = alloc_desc(n);
    80005fd8:	85b2                	mv	a1,a2
    80005fda:	874e                	mv	a4,s3
  for(int i = 0; i < NUM; i++){
    80005fdc:	87d2                	mv	a5,s4
    if(disk[n].free[i]){
    80005fde:	00074683          	lbu	a3,0(a4)
    80005fe2:	fef9                	bnez	a3,80005fc0 <virtio_disk_rw+0x74>
  for(int i = 0; i < NUM; i++){
    80005fe4:	2785                	addiw	a5,a5,1
    80005fe6:	0705                	addi	a4,a4,1
    80005fe8:	fe979be3          	bne	a5,s1,80005fde <virtio_disk_rw+0x92>
    idx[i] = alloc_desc(n);
    80005fec:	57fd                	li	a5,-1
    80005fee:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005ff0:	01205e63          	blez	s2,8000600c <virtio_disk_rw+0xc0>
    80005ff4:	8d52                	mv	s10,s4
        free_desc(n, idx[j]);
    80005ff6:	000b2583          	lw	a1,0(s6)
    80005ffa:	8556                	mv	a0,s5
    80005ffc:	00000097          	auipc	ra,0x0
    80006000:	ccc080e7          	jalr	-820(ra) # 80005cc8 <free_desc>
      for(int j = 0; j < i; j++)
    80006004:	2d05                	addiw	s10,s10,1
    80006006:	0b11                	addi	s6,s6,4
    80006008:	ffa917e3          	bne	s2,s10,80005ff6 <virtio_disk_rw+0xaa>
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    8000600c:	85e6                	mv	a1,s9
    8000600e:	854e                	mv	a0,s3
    80006010:	ffffc097          	auipc	ra,0xffffc
    80006014:	018080e7          	jalr	24(ra) # 80002028 <sleep>
  for(int i = 0; i < 3; i++){
    80006018:	f8040b13          	addi	s6,s0,-128
{
    8000601c:	865a                	mv	a2,s6
  for(int i = 0; i < 3; i++){
    8000601e:	8952                	mv	s2,s4
      disk[n].free[i] = 0;
    80006020:	6809                	lui	a6,0x2
  for(int i = 0; i < 3; i++){
    80006022:	450d                	li	a0,3
    80006024:	bf55                	j	80005fd8 <virtio_disk_rw+0x8c>
  disk[n].desc[idx[0]].next = idx[1];

  disk[n].desc[idx[1]].addr = (uint64) b->data;
  disk[n].desc[idx[1]].len = BSIZE;
  if(write)
    disk[n].desc[idx[1]].flags = 0; // device reads b->data
    80006026:	001a9793          	slli	a5,s5,0x1
    8000602a:	97d6                	add	a5,a5,s5
    8000602c:	07b2                	slli	a5,a5,0xc
    8000602e:	0001d717          	auipc	a4,0x1d
    80006032:	fd270713          	addi	a4,a4,-46 # 80023000 <disk>
    80006036:	973e                	add	a4,a4,a5
    80006038:	6789                	lui	a5,0x2
    8000603a:	97ba                	add	a5,a5,a4
    8000603c:	639c                	ld	a5,0(a5)
    8000603e:	97b6                	add	a5,a5,a3
    80006040:	00079623          	sh	zero,12(a5) # 200c <_entry-0x7fffdff4>
  else
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk[n].desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006044:	0001d517          	auipc	a0,0x1d
    80006048:	fbc50513          	addi	a0,a0,-68 # 80023000 <disk>
    8000604c:	001a9793          	slli	a5,s5,0x1
    80006050:	01578733          	add	a4,a5,s5
    80006054:	0732                	slli	a4,a4,0xc
    80006056:	972a                	add	a4,a4,a0
    80006058:	6609                	lui	a2,0x2
    8000605a:	9732                	add	a4,a4,a2
    8000605c:	6310                	ld	a2,0(a4)
    8000605e:	9636                	add	a2,a2,a3
    80006060:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006064:	0015e593          	ori	a1,a1,1
    80006068:	00b61623          	sh	a1,12(a2)
  disk[n].desc[idx[1]].next = idx[2];
    8000606c:	f8842603          	lw	a2,-120(s0)
    80006070:	630c                	ld	a1,0(a4)
    80006072:	96ae                	add	a3,a3,a1
    80006074:	00c69723          	sh	a2,14(a3) # 100e <_entry-0x7fffeff2>

  disk[n].info[idx[0]].status = 0;
    80006078:	97d6                	add	a5,a5,s5
    8000607a:	07a2                	slli	a5,a5,0x8
    8000607c:	97a6                	add	a5,a5,s1
    8000607e:	20078793          	addi	a5,a5,512
    80006082:	0792                	slli	a5,a5,0x4
    80006084:	97aa                	add	a5,a5,a0
    80006086:	02078823          	sb	zero,48(a5)
  disk[n].desc[idx[2]].addr = (uint64) &disk[n].info[idx[0]].status;
    8000608a:	00461693          	slli	a3,a2,0x4
    8000608e:	00073803          	ld	a6,0(a4)
    80006092:	9836                	add	a6,a6,a3
    80006094:	20348613          	addi	a2,s1,515
    80006098:	001a9593          	slli	a1,s5,0x1
    8000609c:	95d6                	add	a1,a1,s5
    8000609e:	05a2                	slli	a1,a1,0x8
    800060a0:	962e                	add	a2,a2,a1
    800060a2:	0612                	slli	a2,a2,0x4
    800060a4:	962a                	add	a2,a2,a0
    800060a6:	00c83023          	sd	a2,0(a6) # 2000 <_entry-0x7fffe000>
  disk[n].desc[idx[2]].len = 1;
    800060aa:	630c                	ld	a1,0(a4)
    800060ac:	95b6                	add	a1,a1,a3
    800060ae:	4605                	li	a2,1
    800060b0:	c590                	sw	a2,8(a1)
  disk[n].desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800060b2:	630c                	ld	a1,0(a4)
    800060b4:	95b6                	add	a1,a1,a3
    800060b6:	4509                	li	a0,2
    800060b8:	00a59623          	sh	a0,12(a1)
  disk[n].desc[idx[2]].next = 0;
    800060bc:	630c                	ld	a1,0(a4)
    800060be:	96ae                	add	a3,a3,a1
    800060c0:	00069723          	sh	zero,14(a3)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800060c4:	00cc2223          	sw	a2,4(s8) # fffffffffffff004 <ticks+0xffffffff7ffd5fdc>
  disk[n].info[idx[0]].b = b;
    800060c8:	0387b423          	sd	s8,40(a5)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk[n].avail[2 + (disk[n].avail[1] % NUM)] = idx[0];
    800060cc:	6714                	ld	a3,8(a4)
    800060ce:	0026d783          	lhu	a5,2(a3)
    800060d2:	8b9d                	andi	a5,a5,7
    800060d4:	0789                	addi	a5,a5,2
    800060d6:	0786                	slli	a5,a5,0x1
    800060d8:	97b6                	add	a5,a5,a3
    800060da:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    800060de:	0ff0000f          	fence
  disk[n].avail[1] = disk[n].avail[1] + 1;
    800060e2:	6718                	ld	a4,8(a4)
    800060e4:	00275783          	lhu	a5,2(a4)
    800060e8:	2785                	addiw	a5,a5,1
    800060ea:	00f71123          	sh	a5,2(a4)

  *R(n, VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800060ee:	001a879b          	addiw	a5,s5,1
    800060f2:	00c7979b          	slliw	a5,a5,0xc
    800060f6:	10000737          	lui	a4,0x10000
    800060fa:	05070713          	addi	a4,a4,80 # 10000050 <_entry-0x6fffffb0>
    800060fe:	97ba                	add	a5,a5,a4
    80006100:	0007a023          	sw	zero,0(a5)

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006104:	004c2783          	lw	a5,4(s8)
    80006108:	00c79d63          	bne	a5,a2,80006122 <virtio_disk_rw+0x1d6>
    8000610c:	4485                	li	s1,1
    sleep(b, &disk[n].vdisk_lock);
    8000610e:	85e6                	mv	a1,s9
    80006110:	8562                	mv	a0,s8
    80006112:	ffffc097          	auipc	ra,0xffffc
    80006116:	f16080e7          	jalr	-234(ra) # 80002028 <sleep>
  while(b->disk == 1) {
    8000611a:	004c2783          	lw	a5,4(s8)
    8000611e:	fe9788e3          	beq	a5,s1,8000610e <virtio_disk_rw+0x1c2>
  }

  disk[n].info[idx[0]].b = 0;
    80006122:	f8042483          	lw	s1,-128(s0)
    80006126:	001a9793          	slli	a5,s5,0x1
    8000612a:	97d6                	add	a5,a5,s5
    8000612c:	07a2                	slli	a5,a5,0x8
    8000612e:	97a6                	add	a5,a5,s1
    80006130:	20078793          	addi	a5,a5,512
    80006134:	0792                	slli	a5,a5,0x4
    80006136:	0001d717          	auipc	a4,0x1d
    8000613a:	eca70713          	addi	a4,a4,-310 # 80023000 <disk>
    8000613e:	97ba                	add	a5,a5,a4
    80006140:	0207b423          	sd	zero,40(a5)
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    80006144:	001a9793          	slli	a5,s5,0x1
    80006148:	97d6                	add	a5,a5,s5
    8000614a:	07b2                	slli	a5,a5,0xc
    8000614c:	97ba                	add	a5,a5,a4
    8000614e:	6909                	lui	s2,0x2
    80006150:	993e                	add	s2,s2,a5
    80006152:	a019                	j	80006158 <virtio_disk_rw+0x20c>
      i = disk[n].desc[i].next;
    80006154:	00e4d483          	lhu	s1,14(s1)
    free_desc(n, i);
    80006158:	85a6                	mv	a1,s1
    8000615a:	8556                	mv	a0,s5
    8000615c:	00000097          	auipc	ra,0x0
    80006160:	b6c080e7          	jalr	-1172(ra) # 80005cc8 <free_desc>
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    80006164:	0492                	slli	s1,s1,0x4
    80006166:	00093783          	ld	a5,0(s2) # 2000 <_entry-0x7fffe000>
    8000616a:	94be                	add	s1,s1,a5
    8000616c:	00c4d783          	lhu	a5,12(s1)
    80006170:	8b85                	andi	a5,a5,1
    80006172:	f3ed                	bnez	a5,80006154 <virtio_disk_rw+0x208>
  free_chain(n, idx[0]);

  release(&disk[n].vdisk_lock);
    80006174:	8566                	mv	a0,s9
    80006176:	ffffb097          	auipc	ra,0xffffb
    8000617a:	9b0080e7          	jalr	-1616(ra) # 80000b26 <release>
}
    8000617e:	60ea                	ld	ra,152(sp)
    80006180:	644a                	ld	s0,144(sp)
    80006182:	64aa                	ld	s1,136(sp)
    80006184:	690a                	ld	s2,128(sp)
    80006186:	79e6                	ld	s3,120(sp)
    80006188:	7a46                	ld	s4,112(sp)
    8000618a:	7aa6                	ld	s5,104(sp)
    8000618c:	7b06                	ld	s6,96(sp)
    8000618e:	6be6                	ld	s7,88(sp)
    80006190:	6c46                	ld	s8,80(sp)
    80006192:	6ca6                	ld	s9,72(sp)
    80006194:	6d06                	ld	s10,64(sp)
    80006196:	7de2                	ld	s11,56(sp)
    80006198:	610d                	addi	sp,sp,160
    8000619a:	8082                	ret
  if(write)
    8000619c:	01b037b3          	snez	a5,s11
    800061a0:	f6f42823          	sw	a5,-144(s0)
  buf0.reserved = 0;
    800061a4:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    800061a8:	f6843783          	ld	a5,-152(s0)
    800061ac:	f6f43c23          	sd	a5,-136(s0)
  disk[n].desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    800061b0:	f8042483          	lw	s1,-128(s0)
    800061b4:	00449993          	slli	s3,s1,0x4
    800061b8:	001a9793          	slli	a5,s5,0x1
    800061bc:	97d6                	add	a5,a5,s5
    800061be:	07b2                	slli	a5,a5,0xc
    800061c0:	0001d917          	auipc	s2,0x1d
    800061c4:	e4090913          	addi	s2,s2,-448 # 80023000 <disk>
    800061c8:	97ca                	add	a5,a5,s2
    800061ca:	6909                	lui	s2,0x2
    800061cc:	993e                	add	s2,s2,a5
    800061ce:	00093a03          	ld	s4,0(s2) # 2000 <_entry-0x7fffe000>
    800061d2:	9a4e                	add	s4,s4,s3
    800061d4:	f7040513          	addi	a0,s0,-144
    800061d8:	ffffb097          	auipc	ra,0xffffb
    800061dc:	dda080e7          	jalr	-550(ra) # 80000fb2 <kvmpa>
    800061e0:	00aa3023          	sd	a0,0(s4)
  disk[n].desc[idx[0]].len = sizeof(buf0);
    800061e4:	00093783          	ld	a5,0(s2)
    800061e8:	97ce                	add	a5,a5,s3
    800061ea:	4741                	li	a4,16
    800061ec:	c798                	sw	a4,8(a5)
  disk[n].desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800061ee:	00093783          	ld	a5,0(s2)
    800061f2:	97ce                	add	a5,a5,s3
    800061f4:	4705                	li	a4,1
    800061f6:	00e79623          	sh	a4,12(a5)
  disk[n].desc[idx[0]].next = idx[1];
    800061fa:	f8442683          	lw	a3,-124(s0)
    800061fe:	00093783          	ld	a5,0(s2)
    80006202:	99be                	add	s3,s3,a5
    80006204:	00d99723          	sh	a3,14(s3)
  disk[n].desc[idx[1]].addr = (uint64) b->data;
    80006208:	0692                	slli	a3,a3,0x4
    8000620a:	00093783          	ld	a5,0(s2)
    8000620e:	97b6                	add	a5,a5,a3
    80006210:	060c0713          	addi	a4,s8,96
    80006214:	e398                	sd	a4,0(a5)
  disk[n].desc[idx[1]].len = BSIZE;
    80006216:	00093783          	ld	a5,0(s2)
    8000621a:	97b6                	add	a5,a5,a3
    8000621c:	40000713          	li	a4,1024
    80006220:	c798                	sw	a4,8(a5)
  if(write)
    80006222:	e00d92e3          	bnez	s11,80006026 <virtio_disk_rw+0xda>
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006226:	001a9793          	slli	a5,s5,0x1
    8000622a:	97d6                	add	a5,a5,s5
    8000622c:	07b2                	slli	a5,a5,0xc
    8000622e:	0001d717          	auipc	a4,0x1d
    80006232:	dd270713          	addi	a4,a4,-558 # 80023000 <disk>
    80006236:	973e                	add	a4,a4,a5
    80006238:	6789                	lui	a5,0x2
    8000623a:	97ba                	add	a5,a5,a4
    8000623c:	639c                	ld	a5,0(a5)
    8000623e:	97b6                	add	a5,a5,a3
    80006240:	4709                	li	a4,2
    80006242:	00e79623          	sh	a4,12(a5) # 200c <_entry-0x7fffdff4>
    80006246:	bbfd                	j	80006044 <virtio_disk_rw+0xf8>

0000000080006248 <virtio_disk_intr>:

void
virtio_disk_intr(int n)
{
    80006248:	7139                	addi	sp,sp,-64
    8000624a:	fc06                	sd	ra,56(sp)
    8000624c:	f822                	sd	s0,48(sp)
    8000624e:	f426                	sd	s1,40(sp)
    80006250:	f04a                	sd	s2,32(sp)
    80006252:	ec4e                	sd	s3,24(sp)
    80006254:	e852                	sd	s4,16(sp)
    80006256:	e456                	sd	s5,8(sp)
    80006258:	0080                	addi	s0,sp,64
    8000625a:	84aa                	mv	s1,a0
  acquire(&disk[n].vdisk_lock);
    8000625c:	00151913          	slli	s2,a0,0x1
    80006260:	00a90a33          	add	s4,s2,a0
    80006264:	0a32                	slli	s4,s4,0xc
    80006266:	6989                	lui	s3,0x2
    80006268:	0b098793          	addi	a5,s3,176 # 20b0 <_entry-0x7fffdf50>
    8000626c:	9a3e                	add	s4,s4,a5
    8000626e:	0001da97          	auipc	s5,0x1d
    80006272:	d92a8a93          	addi	s5,s5,-622 # 80023000 <disk>
    80006276:	9a56                	add	s4,s4,s5
    80006278:	8552                	mv	a0,s4
    8000627a:	ffffb097          	auipc	ra,0xffffb
    8000627e:	844080e7          	jalr	-1980(ra) # 80000abe <acquire>

  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    80006282:	9926                	add	s2,s2,s1
    80006284:	0932                	slli	s2,s2,0xc
    80006286:	9956                	add	s2,s2,s5
    80006288:	99ca                	add	s3,s3,s2
    8000628a:	0209d783          	lhu	a5,32(s3)
    8000628e:	0109b703          	ld	a4,16(s3)
    80006292:	00275683          	lhu	a3,2(a4)
    80006296:	8ebd                	xor	a3,a3,a5
    80006298:	8a9d                	andi	a3,a3,7
    8000629a:	c2a5                	beqz	a3,800062fa <virtio_disk_intr+0xb2>
    int id = disk[n].used->elems[disk[n].used_idx].id;

    if(disk[n].info[id].status != 0)
    8000629c:	8956                	mv	s2,s5
    8000629e:	00149693          	slli	a3,s1,0x1
    800062a2:	96a6                	add	a3,a3,s1
    800062a4:	00869993          	slli	s3,a3,0x8
      panic("virtio_disk_intr status");
    
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk[n].info[id].b);

    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    800062a8:	06b2                	slli	a3,a3,0xc
    800062aa:	96d6                	add	a3,a3,s5
    800062ac:	6489                	lui	s1,0x2
    800062ae:	94b6                	add	s1,s1,a3
    int id = disk[n].used->elems[disk[n].used_idx].id;
    800062b0:	078e                	slli	a5,a5,0x3
    800062b2:	97ba                	add	a5,a5,a4
    800062b4:	43dc                	lw	a5,4(a5)
    if(disk[n].info[id].status != 0)
    800062b6:	00f98733          	add	a4,s3,a5
    800062ba:	20070713          	addi	a4,a4,512
    800062be:	0712                	slli	a4,a4,0x4
    800062c0:	974a                	add	a4,a4,s2
    800062c2:	03074703          	lbu	a4,48(a4)
    800062c6:	eb21                	bnez	a4,80006316 <virtio_disk_intr+0xce>
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    800062c8:	97ce                	add	a5,a5,s3
    800062ca:	20078793          	addi	a5,a5,512
    800062ce:	0792                	slli	a5,a5,0x4
    800062d0:	97ca                	add	a5,a5,s2
    800062d2:	7798                	ld	a4,40(a5)
    800062d4:	00072223          	sw	zero,4(a4)
    wakeup(disk[n].info[id].b);
    800062d8:	7788                	ld	a0,40(a5)
    800062da:	ffffc097          	auipc	ra,0xffffc
    800062de:	e94080e7          	jalr	-364(ra) # 8000216e <wakeup>
    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    800062e2:	0204d783          	lhu	a5,32(s1) # 2020 <_entry-0x7fffdfe0>
    800062e6:	2785                	addiw	a5,a5,1
    800062e8:	8b9d                	andi	a5,a5,7
    800062ea:	02f49023          	sh	a5,32(s1)
  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    800062ee:	6898                	ld	a4,16(s1)
    800062f0:	00275683          	lhu	a3,2(a4)
    800062f4:	8a9d                	andi	a3,a3,7
    800062f6:	faf69de3          	bne	a3,a5,800062b0 <virtio_disk_intr+0x68>
  }

  release(&disk[n].vdisk_lock);
    800062fa:	8552                	mv	a0,s4
    800062fc:	ffffb097          	auipc	ra,0xffffb
    80006300:	82a080e7          	jalr	-2006(ra) # 80000b26 <release>
}
    80006304:	70e2                	ld	ra,56(sp)
    80006306:	7442                	ld	s0,48(sp)
    80006308:	74a2                	ld	s1,40(sp)
    8000630a:	7902                	ld	s2,32(sp)
    8000630c:	69e2                	ld	s3,24(sp)
    8000630e:	6a42                	ld	s4,16(sp)
    80006310:	6aa2                	ld	s5,8(sp)
    80006312:	6121                	addi	sp,sp,64
    80006314:	8082                	ret
      panic("virtio_disk_intr status");
    80006316:	00001517          	auipc	a0,0x1
    8000631a:	58250513          	addi	a0,a0,1410 # 80007898 <userret+0x808>
    8000631e:	ffffa097          	auipc	ra,0xffffa
    80006322:	22a080e7          	jalr	554(ra) # 80000548 <panic>
	...

0000000080007000 <trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
