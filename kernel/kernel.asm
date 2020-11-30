
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	80010113          	addi	sp,sp,-2048 # 8000a800 <stack0>
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
    8000004a:	0000a617          	auipc	a2,0xa
    8000004e:	fb660613          	addi	a2,a2,-74 # 8000a000 <mscratch0>
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
    80000060:	ed478793          	addi	a5,a5,-300 # 80005f30 <timervec>
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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffce7a3>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	fa078793          	addi	a5,a5,-96 # 80001046 <main>
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
consoleread(struct file *f, int user_dst, uint64 dst, int n)
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
    800000fc:	8aae                	mv	s5,a1
    800000fe:	8a32                	mv	s4,a2
    80000100:	89b6                	mv	s3,a3
  uint target;
  int c;
  char cbuf;

  target = n;
    80000102:	00068b1b          	sext.w	s6,a3
  acquire(&cons.lock);
    80000106:	00012517          	auipc	a0,0x12
    8000010a:	6fa50513          	addi	a0,a0,1786 # 80012800 <cons>
    8000010e:	00001097          	auipc	ra,0x1
    80000112:	b1c080e7          	jalr	-1252(ra) # 80000c2a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000116:	00012497          	auipc	s1,0x12
    8000011a:	6ea48493          	addi	s1,s1,1770 # 80012800 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000011e:	00012917          	auipc	s2,0x12
    80000122:	78290913          	addi	s2,s2,1922 # 800128a0 <cons+0xa0>
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
    80000130:	0a04a783          	lw	a5,160(s1)
    80000134:	0a44a703          	lw	a4,164(s1)
    80000138:	02f71463          	bne	a4,a5,80000160 <consoleread+0x80>
      if(myproc()->killed){
    8000013c:	00002097          	auipc	ra,0x2
    80000140:	a46080e7          	jalr	-1466(ra) # 80001b82 <myproc>
    80000144:	5d1c                	lw	a5,56(a0)
    80000146:	e7b5                	bnez	a5,800001b2 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80000148:	85a6                	mv	a1,s1
    8000014a:	854a                	mv	a0,s2
    8000014c:	00002097          	auipc	ra,0x2
    80000150:	20c080e7          	jalr	524(ra) # 80002358 <sleep>
    while(cons.r == cons.w){
    80000154:	0a04a783          	lw	a5,160(s1)
    80000158:	0a44a703          	lw	a4,164(s1)
    8000015c:	fef700e3          	beq	a4,a5,8000013c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80000160:	0017871b          	addiw	a4,a5,1
    80000164:	0ae4a023          	sw	a4,160(s1)
    80000168:	07f7f713          	andi	a4,a5,127
    8000016c:	9726                	add	a4,a4,s1
    8000016e:	02074703          	lbu	a4,32(a4)
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
    8000018c:	42a080e7          	jalr	1066(ra) # 800025b2 <either_copyout>
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
    8000019c:	00012517          	auipc	a0,0x12
    800001a0:	66450513          	addi	a0,a0,1636 # 80012800 <cons>
    800001a4:	00001097          	auipc	ra,0x1
    800001a8:	af6080e7          	jalr	-1290(ra) # 80000c9a <release>

  return target - n;
    800001ac:	413b053b          	subw	a0,s6,s3
    800001b0:	a811                	j	800001c4 <consoleread+0xe4>
        release(&cons.lock);
    800001b2:	00012517          	auipc	a0,0x12
    800001b6:	64e50513          	addi	a0,a0,1614 # 80012800 <cons>
    800001ba:	00001097          	auipc	ra,0x1
    800001be:	ae0080e7          	jalr	-1312(ra) # 80000c9a <release>
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
    800001e8:	00012717          	auipc	a4,0x12
    800001ec:	6af72c23          	sw	a5,1720(a4) # 800128a0 <cons+0xa0>
    800001f0:	b775                	j	8000019c <consoleread+0xbc>

00000000800001f2 <consputc>:
  if(panicked){
    800001f2:	00030797          	auipc	a5,0x30
    800001f6:	e2e7a783          	lw	a5,-466(a5) # 80030020 <panicked>
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
    80000212:	5dc080e7          	jalr	1500(ra) # 800007ea <uartputc>
}
    80000216:	60a2                	ld	ra,8(sp)
    80000218:	6402                	ld	s0,0(sp)
    8000021a:	0141                	addi	sp,sp,16
    8000021c:	8082                	ret
    uartputc('\b'); uartputc(' '); uartputc('\b');
    8000021e:	4521                	li	a0,8
    80000220:	00000097          	auipc	ra,0x0
    80000224:	5ca080e7          	jalr	1482(ra) # 800007ea <uartputc>
    80000228:	02000513          	li	a0,32
    8000022c:	00000097          	auipc	ra,0x0
    80000230:	5be080e7          	jalr	1470(ra) # 800007ea <uartputc>
    80000234:	4521                	li	a0,8
    80000236:	00000097          	auipc	ra,0x0
    8000023a:	5b4080e7          	jalr	1460(ra) # 800007ea <uartputc>
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
    80000252:	89ae                	mv	s3,a1
    80000254:	84b2                	mv	s1,a2
    80000256:	8ab6                	mv	s5,a3
  acquire(&cons.lock);
    80000258:	00012517          	auipc	a0,0x12
    8000025c:	5a850513          	addi	a0,a0,1448 # 80012800 <cons>
    80000260:	00001097          	auipc	ra,0x1
    80000264:	9ca080e7          	jalr	-1590(ra) # 80000c2a <acquire>
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
    8000028a:	382080e7          	jalr	898(ra) # 80002608 <either_copyin>
    8000028e:	01450b63          	beq	a0,s4,800002a4 <consolewrite+0x64>
    consputc(c);
    80000292:	fbf44503          	lbu	a0,-65(s0)
    80000296:	00000097          	auipc	ra,0x0
    8000029a:	f5c080e7          	jalr	-164(ra) # 800001f2 <consputc>
  for(i = 0; i < n; i++){
    8000029e:	0485                	addi	s1,s1,1
    800002a0:	fd249ee3          	bne	s1,s2,8000027c <consolewrite+0x3c>
  release(&cons.lock);
    800002a4:	00012517          	auipc	a0,0x12
    800002a8:	55c50513          	addi	a0,a0,1372 # 80012800 <cons>
    800002ac:	00001097          	auipc	ra,0x1
    800002b0:	9ee080e7          	jalr	-1554(ra) # 80000c9a <release>
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
    800002d6:	00012517          	auipc	a0,0x12
    800002da:	52a50513          	addi	a0,a0,1322 # 80012800 <cons>
    800002de:	00001097          	auipc	ra,0x1
    800002e2:	94c080e7          	jalr	-1716(ra) # 80000c2a <acquire>

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
    80000300:	362080e7          	jalr	866(ra) # 8000265e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000304:	00012517          	auipc	a0,0x12
    80000308:	4fc50513          	addi	a0,a0,1276 # 80012800 <cons>
    8000030c:	00001097          	auipc	ra,0x1
    80000310:	98e080e7          	jalr	-1650(ra) # 80000c9a <release>
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
    80000328:	00012717          	auipc	a4,0x12
    8000032c:	4d870713          	addi	a4,a4,1240 # 80012800 <cons>
    80000330:	0a872783          	lw	a5,168(a4)
    80000334:	0a072703          	lw	a4,160(a4)
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
    80000352:	00012797          	auipc	a5,0x12
    80000356:	4ae78793          	addi	a5,a5,1198 # 80012800 <cons>
    8000035a:	0a87a703          	lw	a4,168(a5)
    8000035e:	0017069b          	addiw	a3,a4,1
    80000362:	0006861b          	sext.w	a2,a3
    80000366:	0ad7a423          	sw	a3,168(a5)
    8000036a:	07f77713          	andi	a4,a4,127
    8000036e:	97ba                	add	a5,a5,a4
    80000370:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000374:	47a9                	li	a5,10
    80000376:	0cf48563          	beq	s1,a5,80000440 <consoleintr+0x178>
    8000037a:	4791                	li	a5,4
    8000037c:	0cf48263          	beq	s1,a5,80000440 <consoleintr+0x178>
    80000380:	00012797          	auipc	a5,0x12
    80000384:	5207a783          	lw	a5,1312(a5) # 800128a0 <cons+0xa0>
    80000388:	0807879b          	addiw	a5,a5,128
    8000038c:	f6f61ce3          	bne	a2,a5,80000304 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000390:	863e                	mv	a2,a5
    80000392:	a07d                	j	80000440 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000394:	00012717          	auipc	a4,0x12
    80000398:	46c70713          	addi	a4,a4,1132 # 80012800 <cons>
    8000039c:	0a872783          	lw	a5,168(a4)
    800003a0:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003a4:	00012497          	auipc	s1,0x12
    800003a8:	45c48493          	addi	s1,s1,1116 # 80012800 <cons>
    while(cons.e != cons.w &&
    800003ac:	4929                	li	s2,10
    800003ae:	f4f70be3          	beq	a4,a5,80000304 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b2:	37fd                	addiw	a5,a5,-1
    800003b4:	07f7f713          	andi	a4,a5,127
    800003b8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003ba:	02074703          	lbu	a4,32(a4)
    800003be:	f52703e3          	beq	a4,s2,80000304 <consoleintr+0x3c>
      cons.e--;
    800003c2:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    800003c6:	10000513          	li	a0,256
    800003ca:	00000097          	auipc	ra,0x0
    800003ce:	e28080e7          	jalr	-472(ra) # 800001f2 <consputc>
    while(cons.e != cons.w &&
    800003d2:	0a84a783          	lw	a5,168(s1)
    800003d6:	0a44a703          	lw	a4,164(s1)
    800003da:	fcf71ce3          	bne	a4,a5,800003b2 <consoleintr+0xea>
    800003de:	b71d                	j	80000304 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003e0:	00012717          	auipc	a4,0x12
    800003e4:	42070713          	addi	a4,a4,1056 # 80012800 <cons>
    800003e8:	0a872783          	lw	a5,168(a4)
    800003ec:	0a472703          	lw	a4,164(a4)
    800003f0:	f0f70ae3          	beq	a4,a5,80000304 <consoleintr+0x3c>
      cons.e--;
    800003f4:	37fd                	addiw	a5,a5,-1
    800003f6:	00012717          	auipc	a4,0x12
    800003fa:	4af72923          	sw	a5,1202(a4) # 800128a8 <cons+0xa8>
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
    8000041c:	00012797          	auipc	a5,0x12
    80000420:	3e478793          	addi	a5,a5,996 # 80012800 <cons>
    80000424:	0a87a703          	lw	a4,168(a5)
    80000428:	0017069b          	addiw	a3,a4,1
    8000042c:	0006861b          	sext.w	a2,a3
    80000430:	0ad7a423          	sw	a3,168(a5)
    80000434:	07f77713          	andi	a4,a4,127
    80000438:	97ba                	add	a5,a5,a4
    8000043a:	4729                	li	a4,10
    8000043c:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    80000440:	00012797          	auipc	a5,0x12
    80000444:	46c7a223          	sw	a2,1124(a5) # 800128a4 <cons+0xa4>
        wakeup(&cons.r);
    80000448:	00012517          	auipc	a0,0x12
    8000044c:	45850513          	addi	a0,a0,1112 # 800128a0 <cons+0xa0>
    80000450:	00002097          	auipc	ra,0x2
    80000454:	088080e7          	jalr	136(ra) # 800024d8 <wakeup>
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
    80000462:	00008597          	auipc	a1,0x8
    80000466:	cb658593          	addi	a1,a1,-842 # 80008118 <userret+0x88>
    8000046a:	00012517          	auipc	a0,0x12
    8000046e:	39650513          	addi	a0,a0,918 # 80012800 <cons>
    80000472:	00000097          	auipc	ra,0x0
    80000476:	66a080e7          	jalr	1642(ra) # 80000adc <initlock>

  uartinit();
    8000047a:	00000097          	auipc	ra,0x0
    8000047e:	33a080e7          	jalr	826(ra) # 800007b4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000482:	00028797          	auipc	a5,0x28
    80000486:	09678793          	addi	a5,a5,150 # 80028518 <devsw>
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
    800004c4:	00008617          	auipc	a2,0x8
    800004c8:	5ec60613          	addi	a2,a2,1516 # 80008ab0 <digits>
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
    80000554:	00012797          	auipc	a5,0x12
    80000558:	3607ae23          	sw	zero,892(a5) # 800128d0 <pr+0x20>
  printf("PANIC: ");
    8000055c:	00008517          	auipc	a0,0x8
    80000560:	bc450513          	addi	a0,a0,-1084 # 80008120 <userret+0x90>
    80000564:	00000097          	auipc	ra,0x0
    80000568:	03e080e7          	jalr	62(ra) # 800005a2 <printf>
  printf(s);
    8000056c:	8526                	mv	a0,s1
    8000056e:	00000097          	auipc	ra,0x0
    80000572:	034080e7          	jalr	52(ra) # 800005a2 <printf>
  printf("\n");
    80000576:	00008517          	auipc	a0,0x8
    8000057a:	d1a50513          	addi	a0,a0,-742 # 80008290 <userret+0x200>
    8000057e:	00000097          	auipc	ra,0x0
    80000582:	024080e7          	jalr	36(ra) # 800005a2 <printf>
  printf("HINT: restart xv6 using 'make qemu-gdb', type 'b panic' (to set breakpoint in panic) in the gdb window, followed by 'c' (continue), and when the kernel hits the breakpoint, type 'bt' to get a backtrace\n");
    80000586:	00008517          	auipc	a0,0x8
    8000058a:	ba250513          	addi	a0,a0,-1118 # 80008128 <userret+0x98>
    8000058e:	00000097          	auipc	ra,0x0
    80000592:	014080e7          	jalr	20(ra) # 800005a2 <printf>
  panicked = 1; // freeze other CPUs
    80000596:	4785                	li	a5,1
    80000598:	00030717          	auipc	a4,0x30
    8000059c:	a8f72423          	sw	a5,-1400(a4) # 80030020 <panicked>
  for(;;)
    800005a0:	a001                	j	800005a0 <panic+0x58>

00000000800005a2 <printf>:
{
    800005a2:	7131                	addi	sp,sp,-192
    800005a4:	fc86                	sd	ra,120(sp)
    800005a6:	f8a2                	sd	s0,112(sp)
    800005a8:	f4a6                	sd	s1,104(sp)
    800005aa:	f0ca                	sd	s2,96(sp)
    800005ac:	ecce                	sd	s3,88(sp)
    800005ae:	e8d2                	sd	s4,80(sp)
    800005b0:	e4d6                	sd	s5,72(sp)
    800005b2:	e0da                	sd	s6,64(sp)
    800005b4:	fc5e                	sd	s7,56(sp)
    800005b6:	f862                	sd	s8,48(sp)
    800005b8:	f466                	sd	s9,40(sp)
    800005ba:	f06a                	sd	s10,32(sp)
    800005bc:	ec6e                	sd	s11,24(sp)
    800005be:	0100                	addi	s0,sp,128
    800005c0:	8a2a                	mv	s4,a0
    800005c2:	e40c                	sd	a1,8(s0)
    800005c4:	e810                	sd	a2,16(s0)
    800005c6:	ec14                	sd	a3,24(s0)
    800005c8:	f018                	sd	a4,32(s0)
    800005ca:	f41c                	sd	a5,40(s0)
    800005cc:	03043823          	sd	a6,48(s0)
    800005d0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005d4:	00012d97          	auipc	s11,0x12
    800005d8:	2fcdad83          	lw	s11,764(s11) # 800128d0 <pr+0x20>
  if(locking)
    800005dc:	020d9b63          	bnez	s11,80000612 <printf+0x70>
  if (fmt == 0)
    800005e0:	040a0263          	beqz	s4,80000624 <printf+0x82>
  va_start(ap, fmt);
    800005e4:	00840793          	addi	a5,s0,8
    800005e8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005ec:	000a4503          	lbu	a0,0(s4)
    800005f0:	14050f63          	beqz	a0,8000074e <printf+0x1ac>
    800005f4:	4981                	li	s3,0
    if(c != '%'){
    800005f6:	02500a93          	li	s5,37
    switch(c){
    800005fa:	07000b93          	li	s7,112
  consputc('x');
    800005fe:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000600:	00008b17          	auipc	s6,0x8
    80000604:	4b0b0b13          	addi	s6,s6,1200 # 80008ab0 <digits>
    switch(c){
    80000608:	07300c93          	li	s9,115
    8000060c:	06400c13          	li	s8,100
    80000610:	a82d                	j	8000064a <printf+0xa8>
    acquire(&pr.lock);
    80000612:	00012517          	auipc	a0,0x12
    80000616:	29e50513          	addi	a0,a0,670 # 800128b0 <pr>
    8000061a:	00000097          	auipc	ra,0x0
    8000061e:	610080e7          	jalr	1552(ra) # 80000c2a <acquire>
    80000622:	bf7d                	j	800005e0 <printf+0x3e>
    panic("null fmt");
    80000624:	00008517          	auipc	a0,0x8
    80000628:	bdc50513          	addi	a0,a0,-1060 # 80008200 <userret+0x170>
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	f1c080e7          	jalr	-228(ra) # 80000548 <panic>
      consputc(c);
    80000634:	00000097          	auipc	ra,0x0
    80000638:	bbe080e7          	jalr	-1090(ra) # 800001f2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000063c:	2985                	addiw	s3,s3,1
    8000063e:	013a07b3          	add	a5,s4,s3
    80000642:	0007c503          	lbu	a0,0(a5)
    80000646:	10050463          	beqz	a0,8000074e <printf+0x1ac>
    if(c != '%'){
    8000064a:	ff5515e3          	bne	a0,s5,80000634 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000064e:	2985                	addiw	s3,s3,1
    80000650:	013a07b3          	add	a5,s4,s3
    80000654:	0007c783          	lbu	a5,0(a5)
    80000658:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000065c:	cbed                	beqz	a5,8000074e <printf+0x1ac>
    switch(c){
    8000065e:	05778a63          	beq	a5,s7,800006b2 <printf+0x110>
    80000662:	02fbf663          	bgeu	s7,a5,8000068e <printf+0xec>
    80000666:	09978863          	beq	a5,s9,800006f6 <printf+0x154>
    8000066a:	07800713          	li	a4,120
    8000066e:	0ce79563          	bne	a5,a4,80000738 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000672:	f8843783          	ld	a5,-120(s0)
    80000676:	00878713          	addi	a4,a5,8
    8000067a:	f8e43423          	sd	a4,-120(s0)
    8000067e:	4605                	li	a2,1
    80000680:	85ea                	mv	a1,s10
    80000682:	4388                	lw	a0,0(a5)
    80000684:	00000097          	auipc	ra,0x0
    80000688:	e22080e7          	jalr	-478(ra) # 800004a6 <printint>
      break;
    8000068c:	bf45                	j	8000063c <printf+0x9a>
    switch(c){
    8000068e:	09578f63          	beq	a5,s5,8000072c <printf+0x18a>
    80000692:	0b879363          	bne	a5,s8,80000738 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000696:	f8843783          	ld	a5,-120(s0)
    8000069a:	00878713          	addi	a4,a5,8
    8000069e:	f8e43423          	sd	a4,-120(s0)
    800006a2:	4605                	li	a2,1
    800006a4:	45a9                	li	a1,10
    800006a6:	4388                	lw	a0,0(a5)
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	dfe080e7          	jalr	-514(ra) # 800004a6 <printint>
      break;
    800006b0:	b771                	j	8000063c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	addi	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006c2:	03000513          	li	a0,48
    800006c6:	00000097          	auipc	ra,0x0
    800006ca:	b2c080e7          	jalr	-1236(ra) # 800001f2 <consputc>
  consputc('x');
    800006ce:	07800513          	li	a0,120
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	b20080e7          	jalr	-1248(ra) # 800001f2 <consputc>
    800006da:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006dc:	03c95793          	srli	a5,s2,0x3c
    800006e0:	97da                	add	a5,a5,s6
    800006e2:	0007c503          	lbu	a0,0(a5)
    800006e6:	00000097          	auipc	ra,0x0
    800006ea:	b0c080e7          	jalr	-1268(ra) # 800001f2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006ee:	0912                	slli	s2,s2,0x4
    800006f0:	34fd                	addiw	s1,s1,-1
    800006f2:	f4ed                	bnez	s1,800006dc <printf+0x13a>
    800006f4:	b7a1                	j	8000063c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006f6:	f8843783          	ld	a5,-120(s0)
    800006fa:	00878713          	addi	a4,a5,8
    800006fe:	f8e43423          	sd	a4,-120(s0)
    80000702:	6384                	ld	s1,0(a5)
    80000704:	cc89                	beqz	s1,8000071e <printf+0x17c>
      for(; *s; s++)
    80000706:	0004c503          	lbu	a0,0(s1)
    8000070a:	d90d                	beqz	a0,8000063c <printf+0x9a>
        consputc(*s);
    8000070c:	00000097          	auipc	ra,0x0
    80000710:	ae6080e7          	jalr	-1306(ra) # 800001f2 <consputc>
      for(; *s; s++)
    80000714:	0485                	addi	s1,s1,1
    80000716:	0004c503          	lbu	a0,0(s1)
    8000071a:	f96d                	bnez	a0,8000070c <printf+0x16a>
    8000071c:	b705                	j	8000063c <printf+0x9a>
        s = "(null)";
    8000071e:	00008497          	auipc	s1,0x8
    80000722:	ada48493          	addi	s1,s1,-1318 # 800081f8 <userret+0x168>
      for(; *s; s++)
    80000726:	02800513          	li	a0,40
    8000072a:	b7cd                	j	8000070c <printf+0x16a>
      consputc('%');
    8000072c:	8556                	mv	a0,s5
    8000072e:	00000097          	auipc	ra,0x0
    80000732:	ac4080e7          	jalr	-1340(ra) # 800001f2 <consputc>
      break;
    80000736:	b719                	j	8000063c <printf+0x9a>
      consputc('%');
    80000738:	8556                	mv	a0,s5
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	ab8080e7          	jalr	-1352(ra) # 800001f2 <consputc>
      consputc(c);
    80000742:	8526                	mv	a0,s1
    80000744:	00000097          	auipc	ra,0x0
    80000748:	aae080e7          	jalr	-1362(ra) # 800001f2 <consputc>
      break;
    8000074c:	bdc5                	j	8000063c <printf+0x9a>
  if(locking)
    8000074e:	020d9163          	bnez	s11,80000770 <printf+0x1ce>
}
    80000752:	70e6                	ld	ra,120(sp)
    80000754:	7446                	ld	s0,112(sp)
    80000756:	74a6                	ld	s1,104(sp)
    80000758:	7906                	ld	s2,96(sp)
    8000075a:	69e6                	ld	s3,88(sp)
    8000075c:	6a46                	ld	s4,80(sp)
    8000075e:	6aa6                	ld	s5,72(sp)
    80000760:	6b06                	ld	s6,64(sp)
    80000762:	7be2                	ld	s7,56(sp)
    80000764:	7c42                	ld	s8,48(sp)
    80000766:	7ca2                	ld	s9,40(sp)
    80000768:	7d02                	ld	s10,32(sp)
    8000076a:	6de2                	ld	s11,24(sp)
    8000076c:	6129                	addi	sp,sp,192
    8000076e:	8082                	ret
    release(&pr.lock);
    80000770:	00012517          	auipc	a0,0x12
    80000774:	14050513          	addi	a0,a0,320 # 800128b0 <pr>
    80000778:	00000097          	auipc	ra,0x0
    8000077c:	522080e7          	jalr	1314(ra) # 80000c9a <release>
}
    80000780:	bfc9                	j	80000752 <printf+0x1b0>

0000000080000782 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000782:	1101                	addi	sp,sp,-32
    80000784:	ec06                	sd	ra,24(sp)
    80000786:	e822                	sd	s0,16(sp)
    80000788:	e426                	sd	s1,8(sp)
    8000078a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000078c:	00012497          	auipc	s1,0x12
    80000790:	12448493          	addi	s1,s1,292 # 800128b0 <pr>
    80000794:	00008597          	auipc	a1,0x8
    80000798:	a7c58593          	addi	a1,a1,-1412 # 80008210 <userret+0x180>
    8000079c:	8526                	mv	a0,s1
    8000079e:	00000097          	auipc	ra,0x0
    800007a2:	33e080e7          	jalr	830(ra) # 80000adc <initlock>
  pr.locking = 1;
    800007a6:	4785                	li	a5,1
    800007a8:	d09c                	sw	a5,32(s1)
}
    800007aa:	60e2                	ld	ra,24(sp)
    800007ac:	6442                	ld	s0,16(sp)
    800007ae:	64a2                	ld	s1,8(sp)
    800007b0:	6105                	addi	sp,sp,32
    800007b2:	8082                	ret

00000000800007b4 <uartinit>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

void
uartinit(void)
{
    800007b4:	1141                	addi	sp,sp,-16
    800007b6:	e422                	sd	s0,8(sp)
    800007b8:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ba:	100007b7          	lui	a5,0x10000
    800007be:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, 0x80);
    800007c2:	f8000713          	li	a4,-128
    800007c6:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007ca:	470d                	li	a4,3
    800007cc:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007d0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, 0x03);
    800007d4:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, 0x07);
    800007d8:	471d                	li	a4,7
    800007da:	00e78123          	sb	a4,2(a5)

  // enable receive interrupts.
  WriteReg(IER, 0x01);
    800007de:	4705                	li	a4,1
    800007e0:	00e780a3          	sb	a4,1(a5)
}
    800007e4:	6422                	ld	s0,8(sp)
    800007e6:	0141                	addi	sp,sp,16
    800007e8:	8082                	ret

00000000800007ea <uartputc>:

// write one output character to the UART.
void
uartputc(int c)
{
    800007ea:	1141                	addi	sp,sp,-16
    800007ec:	e422                	sd	s0,8(sp)
    800007ee:	0800                	addi	s0,sp,16
  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & (1 << 5)) == 0)
    800007f0:	10000737          	lui	a4,0x10000
    800007f4:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800007f8:	0207f793          	andi	a5,a5,32
    800007fc:	dfe5                	beqz	a5,800007f4 <uartputc+0xa>
    ;
  WriteReg(THR, c);
    800007fe:	0ff57513          	andi	a0,a0,255
    80000802:	100007b7          	lui	a5,0x10000
    80000806:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    8000080a:	6422                	ld	s0,8(sp)
    8000080c:	0141                	addi	sp,sp,16
    8000080e:	8082                	ret

0000000080000810 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000810:	1141                	addi	sp,sp,-16
    80000812:	e422                	sd	s0,8(sp)
    80000814:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000816:	100007b7          	lui	a5,0x10000
    8000081a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000081e:	8b85                	andi	a5,a5,1
    80000820:	cb91                	beqz	a5,80000834 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000822:	100007b7          	lui	a5,0x10000
    80000826:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000082a:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000082e:	6422                	ld	s0,8(sp)
    80000830:	0141                	addi	sp,sp,16
    80000832:	8082                	ret
    return -1;
    80000834:	557d                	li	a0,-1
    80000836:	bfe5                	j	8000082e <uartgetc+0x1e>

0000000080000838 <uartintr>:

// trap.c calls here when the uart interrupts.
void
uartintr(void)
{
    80000838:	1101                	addi	sp,sp,-32
    8000083a:	ec06                	sd	ra,24(sp)
    8000083c:	e822                	sd	s0,16(sp)
    8000083e:	e426                	sd	s1,8(sp)
    80000840:	1000                	addi	s0,sp,32
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000842:	54fd                	li	s1,-1
    80000844:	a029                	j	8000084e <uartintr+0x16>
      break;
    consoleintr(c);
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	a82080e7          	jalr	-1406(ra) # 800002c8 <consoleintr>
    int c = uartgetc();
    8000084e:	00000097          	auipc	ra,0x0
    80000852:	fc2080e7          	jalr	-62(ra) # 80000810 <uartgetc>
    if(c == -1)
    80000856:	fe9518e3          	bne	a0,s1,80000846 <uartintr+0xe>
  }
}
    8000085a:	60e2                	ld	ra,24(sp)
    8000085c:	6442                	ld	s0,16(sp)
    8000085e:	64a2                	ld	s1,8(sp)
    80000860:	6105                	addi	sp,sp,32
    80000862:	8082                	ret

0000000080000864 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000864:	7139                	addi	sp,sp,-64
    80000866:	fc06                	sd	ra,56(sp)
    80000868:	f822                	sd	s0,48(sp)
    8000086a:	f426                	sd	s1,40(sp)
    8000086c:	f04a                	sd	s2,32(sp)
    8000086e:	ec4e                	sd	s3,24(sp)
    80000870:	e852                	sd	s4,16(sp)
    80000872:	e456                	sd	s5,8(sp)
    80000874:	0080                	addi	s0,sp,64
    80000876:	84aa                	mv	s1,a0
  //int id;
  int cpu_id;
  struct run *r;

  push_off();
    80000878:	00000097          	auipc	ra,0x0
    8000087c:	2ba080e7          	jalr	698(ra) # 80000b32 <push_off>
  cpu_id = cpuid();
    80000880:	00001097          	auipc	ra,0x1
    80000884:	2d6080e7          	jalr	726(ra) # 80001b56 <cpuid>
    80000888:	8a2a                	mv	s4,a0
  pop_off();
    8000088a:	00000097          	auipc	ra,0x0
    8000088e:	2f4080e7          	jalr	756(ra) # 80000b7e <pop_off>

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000892:	03449793          	slli	a5,s1,0x34
    80000896:	e7a5                	bnez	a5,800008fe <kfree+0x9a>
    80000898:	0002f797          	auipc	a5,0x2f
    8000089c:	7c478793          	addi	a5,a5,1988 # 8003005c <end>
    800008a0:	04f4ef63          	bltu	s1,a5,800008fe <kfree+0x9a>
    800008a4:	47c5                	li	a5,17
    800008a6:	07ee                	slli	a5,a5,0x1b
    800008a8:	04f4fb63          	bgeu	s1,a5,800008fe <kfree+0x9a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800008ac:	6605                	lui	a2,0x1
    800008ae:	4585                	li	a1,1
    800008b0:	8526                	mv	a0,s1
    800008b2:	00000097          	auipc	ra,0x0
    800008b6:	5e6080e7          	jalr	1510(ra) # 80000e98 <memset>

  r = (struct run*)pa;

  //id = (uint64)pa / ((PHYSTOP - (uint64)end) / NCPU);
  acquire(&kmems[cpu_id].lock);
    800008ba:	00012a97          	auipc	s5,0x12
    800008be:	01ea8a93          	addi	s5,s5,30 # 800128d8 <kmems>
    800008c2:	002a1993          	slli	s3,s4,0x2
    800008c6:	01498933          	add	s2,s3,s4
    800008ca:	090e                	slli	s2,s2,0x3
    800008cc:	9956                	add	s2,s2,s5
    800008ce:	854a                	mv	a0,s2
    800008d0:	00000097          	auipc	ra,0x0
    800008d4:	35a080e7          	jalr	858(ra) # 80000c2a <acquire>
  r->next = kmems[cpu_id].freelist;
    800008d8:	02093783          	ld	a5,32(s2)
    800008dc:	e09c                	sd	a5,0(s1)
  kmems[cpu_id].freelist = r;
    800008de:	02993023          	sd	s1,32(s2)
  release(&kmems[cpu_id].lock);
    800008e2:	854a                	mv	a0,s2
    800008e4:	00000097          	auipc	ra,0x0
    800008e8:	3b6080e7          	jalr	950(ra) # 80000c9a <release>
}
    800008ec:	70e2                	ld	ra,56(sp)
    800008ee:	7442                	ld	s0,48(sp)
    800008f0:	74a2                	ld	s1,40(sp)
    800008f2:	7902                	ld	s2,32(sp)
    800008f4:	69e2                	ld	s3,24(sp)
    800008f6:	6a42                	ld	s4,16(sp)
    800008f8:	6aa2                	ld	s5,8(sp)
    800008fa:	6121                	addi	sp,sp,64
    800008fc:	8082                	ret
    panic("kfree");
    800008fe:	00008517          	auipc	a0,0x8
    80000902:	91a50513          	addi	a0,a0,-1766 # 80008218 <userret+0x188>
    80000906:	00000097          	auipc	ra,0x0
    8000090a:	c42080e7          	jalr	-958(ra) # 80000548 <panic>

000000008000090e <freerange>:
{
    8000090e:	7179                	addi	sp,sp,-48
    80000910:	f406                	sd	ra,40(sp)
    80000912:	f022                	sd	s0,32(sp)
    80000914:	ec26                	sd	s1,24(sp)
    80000916:	e84a                	sd	s2,16(sp)
    80000918:	e44e                	sd	s3,8(sp)
    8000091a:	e052                	sd	s4,0(sp)
    8000091c:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000091e:	6785                	lui	a5,0x1
    80000920:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000924:	94aa                	add	s1,s1,a0
    80000926:	757d                	lui	a0,0xfffff
    80000928:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000092a:	94be                	add	s1,s1,a5
    8000092c:	0095ee63          	bltu	a1,s1,80000948 <freerange+0x3a>
    80000930:	892e                	mv	s2,a1
    kfree(p);
    80000932:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000934:	6985                	lui	s3,0x1
    kfree(p);
    80000936:	01448533          	add	a0,s1,s4
    8000093a:	00000097          	auipc	ra,0x0
    8000093e:	f2a080e7          	jalr	-214(ra) # 80000864 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000942:	94ce                	add	s1,s1,s3
    80000944:	fe9979e3          	bgeu	s2,s1,80000936 <freerange+0x28>
}
    80000948:	70a2                	ld	ra,40(sp)
    8000094a:	7402                	ld	s0,32(sp)
    8000094c:	64e2                	ld	s1,24(sp)
    8000094e:	6942                	ld	s2,16(sp)
    80000950:	69a2                	ld	s3,8(sp)
    80000952:	6a02                	ld	s4,0(sp)
    80000954:	6145                	addi	sp,sp,48
    80000956:	8082                	ret

0000000080000958 <kinit>:
{
    80000958:	7179                	addi	sp,sp,-48
    8000095a:	f406                	sd	ra,40(sp)
    8000095c:	f022                	sd	s0,32(sp)
    8000095e:	ec26                	sd	s1,24(sp)
    80000960:	e84a                	sd	s2,16(sp)
    80000962:	e44e                	sd	s3,8(sp)
    80000964:	1800                	addi	s0,sp,48
  for(i = 0;i < NCPU;i++)
    80000966:	00012497          	auipc	s1,0x12
    8000096a:	f7248493          	addi	s1,s1,-142 # 800128d8 <kmems>
    8000096e:	00012997          	auipc	s3,0x12
    80000972:	0aa98993          	addi	s3,s3,170 # 80012a18 <locks>
    initlock(&kmems[i].lock, "kmem");
    80000976:	00008917          	auipc	s2,0x8
    8000097a:	8aa90913          	addi	s2,s2,-1878 # 80008220 <userret+0x190>
    8000097e:	85ca                	mv	a1,s2
    80000980:	8526                	mv	a0,s1
    80000982:	00000097          	auipc	ra,0x0
    80000986:	15a080e7          	jalr	346(ra) # 80000adc <initlock>
  for(i = 0;i < NCPU;i++)
    8000098a:	02848493          	addi	s1,s1,40
    8000098e:	ff3498e3          	bne	s1,s3,8000097e <kinit+0x26>
  freerange(end, (void*)PHYSTOP);   //把空闲内存加到链表里
    80000992:	45c5                	li	a1,17
    80000994:	05ee                	slli	a1,a1,0x1b
    80000996:	0002f517          	auipc	a0,0x2f
    8000099a:	6c650513          	addi	a0,a0,1734 # 8003005c <end>
    8000099e:	00000097          	auipc	ra,0x0
    800009a2:	f70080e7          	jalr	-144(ra) # 8000090e <freerange>
}
    800009a6:	70a2                	ld	ra,40(sp)
    800009a8:	7402                	ld	s0,32(sp)
    800009aa:	64e2                	ld	s1,24(sp)
    800009ac:	6942                	ld	s2,16(sp)
    800009ae:	69a2                	ld	s3,8(sp)
    800009b0:	6145                	addi	sp,sp,48
    800009b2:	8082                	ret

00000000800009b4 <ksteal>:

void *
ksteal(int cpu_id)
{
    800009b4:	7139                	addi	sp,sp,-64
    800009b6:	fc06                	sd	ra,56(sp)
    800009b8:	f822                	sd	s0,48(sp)
    800009ba:	f426                	sd	s1,40(sp)
    800009bc:	f04a                	sd	s2,32(sp)
    800009be:	ec4e                	sd	s3,24(sp)
    800009c0:	e852                	sd	s4,16(sp)
    800009c2:	e456                	sd	s5,8(sp)
    800009c4:	0080                	addi	s0,sp,64
  int id;
  struct run *r = 0;

  for(id = 0;id < NCPU;id++){
    800009c6:	00012497          	auipc	s1,0x12
    800009ca:	f1248493          	addi	s1,s1,-238 # 800128d8 <kmems>
    800009ce:	4901                	li	s2,0
    800009d0:	4aa1                	li	s5,8
    800009d2:	a80d                	j	80000a04 <ksteal+0x50>
      continue;
    
    acquire(&kmems[id].lock);
    if(kmems[id].freelist){       //list还有剩余空间
      r = kmems[id].freelist;
      kmems[id].freelist = r->next;
    800009d4:	000a3703          	ld	a4,0(s4) # fffffffffffff000 <end+0xffffffff7ffcefa4>
    800009d8:	00291793          	slli	a5,s2,0x2
    800009dc:	993e                	add	s2,s2,a5
    800009de:	090e                	slli	s2,s2,0x3
    800009e0:	00012797          	auipc	a5,0x12
    800009e4:	ef878793          	addi	a5,a5,-264 # 800128d8 <kmems>
    800009e8:	993e                	add	s2,s2,a5
    800009ea:	02e93023          	sd	a4,32(s2)
      release(&kmems[id].lock);
    800009ee:	8526                	mv	a0,s1
    800009f0:	00000097          	auipc	ra,0x0
    800009f4:	2aa080e7          	jalr	682(ra) # 80000c9a <release>
      return (void*)r;
    800009f8:	a825                	j	80000a30 <ksteal+0x7c>
  for(id = 0;id < NCPU;id++){
    800009fa:	2905                	addiw	s2,s2,1
    800009fc:	02848493          	addi	s1,s1,40
    80000a00:	03590763          	beq	s2,s5,80000a2e <ksteal+0x7a>
    if(holding(&kmems[id].lock))    //找到未锁上的list
    80000a04:	8526                	mv	a0,s1
    80000a06:	00000097          	auipc	ra,0x0
    80000a0a:	1e4080e7          	jalr	484(ra) # 80000bea <holding>
    80000a0e:	f575                	bnez	a0,800009fa <ksteal+0x46>
    acquire(&kmems[id].lock);
    80000a10:	8526                	mv	a0,s1
    80000a12:	00000097          	auipc	ra,0x0
    80000a16:	218080e7          	jalr	536(ra) # 80000c2a <acquire>
    if(kmems[id].freelist){       //list还有剩余空间
    80000a1a:	0204ba03          	ld	s4,32(s1)
    80000a1e:	fa0a1be3          	bnez	s4,800009d4 <ksteal+0x20>
    }
    release(&kmems[id].lock);
    80000a22:	8526                	mv	a0,s1
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	276080e7          	jalr	630(ra) # 80000c9a <release>
    80000a2c:	b7f9                	j	800009fa <ksteal+0x46>
  }
  return (void*)r;
    80000a2e:	4a01                	li	s4,0
}
    80000a30:	8552                	mv	a0,s4
    80000a32:	70e2                	ld	ra,56(sp)
    80000a34:	7442                	ld	s0,48(sp)
    80000a36:	74a2                	ld	s1,40(sp)
    80000a38:	7902                	ld	s2,32(sp)
    80000a3a:	69e2                	ld	s3,24(sp)
    80000a3c:	6a42                	ld	s4,16(sp)
    80000a3e:	6aa2                	ld	s5,8(sp)
    80000a40:	6121                	addi	sp,sp,64
    80000a42:	8082                	ret

0000000080000a44 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000a44:	7179                	addi	sp,sp,-48
    80000a46:	f406                	sd	ra,40(sp)
    80000a48:	f022                	sd	s0,32(sp)
    80000a4a:	ec26                	sd	s1,24(sp)
    80000a4c:	e84a                	sd	s2,16(sp)
    80000a4e:	e44e                	sd	s3,8(sp)
    80000a50:	1800                	addi	s0,sp,48
  int cpu_id;
  struct run *r;

  push_off();
    80000a52:	00000097          	auipc	ra,0x0
    80000a56:	0e0080e7          	jalr	224(ra) # 80000b32 <push_off>
  cpu_id = cpuid();
    80000a5a:	00001097          	auipc	ra,0x1
    80000a5e:	0fc080e7          	jalr	252(ra) # 80001b56 <cpuid>
    80000a62:	84aa                	mv	s1,a0
  pop_off();
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	11a080e7          	jalr	282(ra) # 80000b7e <pop_off>

  acquire(&kmems[cpu_id].lock);
    80000a6c:	00249913          	slli	s2,s1,0x2
    80000a70:	9926                	add	s2,s2,s1
    80000a72:	00391793          	slli	a5,s2,0x3
    80000a76:	00012917          	auipc	s2,0x12
    80000a7a:	e6290913          	addi	s2,s2,-414 # 800128d8 <kmems>
    80000a7e:	993e                	add	s2,s2,a5
    80000a80:	854a                	mv	a0,s2
    80000a82:	00000097          	auipc	ra,0x0
    80000a86:	1a8080e7          	jalr	424(ra) # 80000c2a <acquire>
  r = kmems[cpu_id].freelist;
    80000a8a:	02093983          	ld	s3,32(s2)
  if(r)       //当前list仍有空间
    80000a8e:	02098a63          	beqz	s3,80000ac2 <kalloc+0x7e>
    kmems[cpu_id].freelist = r->next;
    80000a92:	0009b703          	ld	a4,0(s3)
    80000a96:	02e93023          	sd	a4,32(s2)
  release(&kmems[cpu_id].lock);
    80000a9a:	854a                	mv	a0,s2
    80000a9c:	00000097          	auipc	ra,0x0
    80000aa0:	1fe080e7          	jalr	510(ra) # 80000c9a <release>

  if(!r)      //当前list已满，要窃取空间
    r = ksteal(cpu_id);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000aa4:	6605                	lui	a2,0x1
    80000aa6:	4595                	li	a1,5
    80000aa8:	854e                	mv	a0,s3
    80000aaa:	00000097          	auipc	ra,0x0
    80000aae:	3ee080e7          	jalr	1006(ra) # 80000e98 <memset>
  return (void*)r;
}
    80000ab2:	854e                	mv	a0,s3
    80000ab4:	70a2                	ld	ra,40(sp)
    80000ab6:	7402                	ld	s0,32(sp)
    80000ab8:	64e2                	ld	s1,24(sp)
    80000aba:	6942                	ld	s2,16(sp)
    80000abc:	69a2                	ld	s3,8(sp)
    80000abe:	6145                	addi	sp,sp,48
    80000ac0:	8082                	ret
  release(&kmems[cpu_id].lock);
    80000ac2:	854a                	mv	a0,s2
    80000ac4:	00000097          	auipc	ra,0x0
    80000ac8:	1d6080e7          	jalr	470(ra) # 80000c9a <release>
    r = ksteal(cpu_id);
    80000acc:	8526                	mv	a0,s1
    80000ace:	00000097          	auipc	ra,0x0
    80000ad2:	ee6080e7          	jalr	-282(ra) # 800009b4 <ksteal>
    80000ad6:	89aa                	mv	s3,a0
  if(r)
    80000ad8:	dd69                	beqz	a0,80000ab2 <kalloc+0x6e>
    80000ada:	b7e9                	j	80000aa4 <kalloc+0x60>

0000000080000adc <initlock>:

// assumes locks are not freed
void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
    80000adc:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000ade:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000ae2:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    80000ae6:	00052e23          	sw	zero,28(a0)
  lk->n = 0;
    80000aea:	00052c23          	sw	zero,24(a0)
  if(nlock >= NLOCK)
    80000aee:	0002f797          	auipc	a5,0x2f
    80000af2:	5367a783          	lw	a5,1334(a5) # 80030024 <nlock>
    80000af6:	3e700713          	li	a4,999
    80000afa:	02f74063          	blt	a4,a5,80000b1a <initlock+0x3e>
    panic("initlock");
  locks[nlock] = lk;
    80000afe:	00379693          	slli	a3,a5,0x3
    80000b02:	00012717          	auipc	a4,0x12
    80000b06:	f1670713          	addi	a4,a4,-234 # 80012a18 <locks>
    80000b0a:	9736                	add	a4,a4,a3
    80000b0c:	e308                	sd	a0,0(a4)
  nlock++;
    80000b0e:	2785                	addiw	a5,a5,1
    80000b10:	0002f717          	auipc	a4,0x2f
    80000b14:	50f72a23          	sw	a5,1300(a4) # 80030024 <nlock>
    80000b18:	8082                	ret
{
    80000b1a:	1141                	addi	sp,sp,-16
    80000b1c:	e406                	sd	ra,8(sp)
    80000b1e:	e022                	sd	s0,0(sp)
    80000b20:	0800                	addi	s0,sp,16
    panic("initlock");
    80000b22:	00007517          	auipc	a0,0x7
    80000b26:	70650513          	addi	a0,a0,1798 # 80008228 <userret+0x198>
    80000b2a:	00000097          	auipc	ra,0x0
    80000b2e:	a1e080e7          	jalr	-1506(ra) # 80000548 <panic>

0000000080000b32 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b32:	1101                	addi	sp,sp,-32
    80000b34:	ec06                	sd	ra,24(sp)
    80000b36:	e822                	sd	s0,16(sp)
    80000b38:	e426                	sd	s1,8(sp)
    80000b3a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b3c:	100024f3          	csrr	s1,sstatus
    80000b40:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b44:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b46:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b4a:	00001097          	auipc	ra,0x1
    80000b4e:	01c080e7          	jalr	28(ra) # 80001b66 <mycpu>
    80000b52:	5d3c                	lw	a5,120(a0)
    80000b54:	cf89                	beqz	a5,80000b6e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b56:	00001097          	auipc	ra,0x1
    80000b5a:	010080e7          	jalr	16(ra) # 80001b66 <mycpu>
    80000b5e:	5d3c                	lw	a5,120(a0)
    80000b60:	2785                	addiw	a5,a5,1
    80000b62:	dd3c                	sw	a5,120(a0)
}
    80000b64:	60e2                	ld	ra,24(sp)
    80000b66:	6442                	ld	s0,16(sp)
    80000b68:	64a2                	ld	s1,8(sp)
    80000b6a:	6105                	addi	sp,sp,32
    80000b6c:	8082                	ret
    mycpu()->intena = old;
    80000b6e:	00001097          	auipc	ra,0x1
    80000b72:	ff8080e7          	jalr	-8(ra) # 80001b66 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000b76:	8085                	srli	s1,s1,0x1
    80000b78:	8885                	andi	s1,s1,1
    80000b7a:	dd64                	sw	s1,124(a0)
    80000b7c:	bfe9                	j	80000b56 <push_off+0x24>

0000000080000b7e <pop_off>:

void
pop_off(void)
{
    80000b7e:	1141                	addi	sp,sp,-16
    80000b80:	e406                	sd	ra,8(sp)
    80000b82:	e022                	sd	s0,0(sp)
    80000b84:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000b86:	00001097          	auipc	ra,0x1
    80000b8a:	fe0080e7          	jalr	-32(ra) # 80001b66 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b8e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000b92:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000b94:	eb9d                	bnez	a5,80000bca <pop_off+0x4c>
    panic("pop_off - interruptible");
  c->noff -= 1;
    80000b96:	5d3c                	lw	a5,120(a0)
    80000b98:	37fd                	addiw	a5,a5,-1
    80000b9a:	0007871b          	sext.w	a4,a5
    80000b9e:	dd3c                	sw	a5,120(a0)
  if(c->noff < 0)
    80000ba0:	02074d63          	bltz	a4,80000bda <pop_off+0x5c>
    panic("pop_off");
  if(c->noff == 0 && c->intena)
    80000ba4:	ef19                	bnez	a4,80000bc2 <pop_off+0x44>
    80000ba6:	5d7c                	lw	a5,124(a0)
    80000ba8:	cf89                	beqz	a5,80000bc2 <pop_off+0x44>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80000baa:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000bae:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80000bb2:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bb6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000bba:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bbe:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000bc2:	60a2                	ld	ra,8(sp)
    80000bc4:	6402                	ld	s0,0(sp)
    80000bc6:	0141                	addi	sp,sp,16
    80000bc8:	8082                	ret
    panic("pop_off - interruptible");
    80000bca:	00007517          	auipc	a0,0x7
    80000bce:	66e50513          	addi	a0,a0,1646 # 80008238 <userret+0x1a8>
    80000bd2:	00000097          	auipc	ra,0x0
    80000bd6:	976080e7          	jalr	-1674(ra) # 80000548 <panic>
    panic("pop_off");
    80000bda:	00007517          	auipc	a0,0x7
    80000bde:	67650513          	addi	a0,a0,1654 # 80008250 <userret+0x1c0>
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	966080e7          	jalr	-1690(ra) # 80000548 <panic>

0000000080000bea <holding>:
{
    80000bea:	1101                	addi	sp,sp,-32
    80000bec:	ec06                	sd	ra,24(sp)
    80000bee:	e822                	sd	s0,16(sp)
    80000bf0:	e426                	sd	s1,8(sp)
    80000bf2:	1000                	addi	s0,sp,32
    80000bf4:	84aa                	mv	s1,a0
  push_off();
    80000bf6:	00000097          	auipc	ra,0x0
    80000bfa:	f3c080e7          	jalr	-196(ra) # 80000b32 <push_off>
  r = (lk->locked && lk->cpu == mycpu());
    80000bfe:	409c                	lw	a5,0(s1)
    80000c00:	ef81                	bnez	a5,80000c18 <holding+0x2e>
    80000c02:	4481                	li	s1,0
  pop_off();
    80000c04:	00000097          	auipc	ra,0x0
    80000c08:	f7a080e7          	jalr	-134(ra) # 80000b7e <pop_off>
}
    80000c0c:	8526                	mv	a0,s1
    80000c0e:	60e2                	ld	ra,24(sp)
    80000c10:	6442                	ld	s0,16(sp)
    80000c12:	64a2                	ld	s1,8(sp)
    80000c14:	6105                	addi	sp,sp,32
    80000c16:	8082                	ret
  r = (lk->locked && lk->cpu == mycpu());
    80000c18:	6884                	ld	s1,16(s1)
    80000c1a:	00001097          	auipc	ra,0x1
    80000c1e:	f4c080e7          	jalr	-180(ra) # 80001b66 <mycpu>
    80000c22:	8c89                	sub	s1,s1,a0
    80000c24:	0014b493          	seqz	s1,s1
    80000c28:	bff1                	j	80000c04 <holding+0x1a>

0000000080000c2a <acquire>:
{
    80000c2a:	1101                	addi	sp,sp,-32
    80000c2c:	ec06                	sd	ra,24(sp)
    80000c2e:	e822                	sd	s0,16(sp)
    80000c30:	e426                	sd	s1,8(sp)
    80000c32:	1000                	addi	s0,sp,32
    80000c34:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c36:	00000097          	auipc	ra,0x0
    80000c3a:	efc080e7          	jalr	-260(ra) # 80000b32 <push_off>
  if(holding(lk))
    80000c3e:	8526                	mv	a0,s1
    80000c40:	00000097          	auipc	ra,0x0
    80000c44:	faa080e7          	jalr	-86(ra) # 80000bea <holding>
    80000c48:	e911                	bnez	a0,80000c5c <acquire+0x32>
  __sync_fetch_and_add(&(lk->n), 1);
    80000c4a:	4785                	li	a5,1
    80000c4c:	01848713          	addi	a4,s1,24
    80000c50:	0f50000f          	fence	iorw,ow
    80000c54:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000c58:	4705                	li	a4,1
    80000c5a:	a839                	j	80000c78 <acquire+0x4e>
    panic("acquire");
    80000c5c:	00007517          	auipc	a0,0x7
    80000c60:	5fc50513          	addi	a0,a0,1532 # 80008258 <userret+0x1c8>
    80000c64:	00000097          	auipc	ra,0x0
    80000c68:	8e4080e7          	jalr	-1820(ra) # 80000548 <panic>
     __sync_fetch_and_add(&lk->nts, 1);
    80000c6c:	01c48793          	addi	a5,s1,28
    80000c70:	0f50000f          	fence	iorw,ow
    80000c74:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000c78:	87ba                	mv	a5,a4
    80000c7a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c7e:	2781                	sext.w	a5,a5
    80000c80:	f7f5                	bnez	a5,80000c6c <acquire+0x42>
  __sync_synchronize();
    80000c82:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c86:	00001097          	auipc	ra,0x1
    80000c8a:	ee0080e7          	jalr	-288(ra) # 80001b66 <mycpu>
    80000c8e:	e888                	sd	a0,16(s1)
}
    80000c90:	60e2                	ld	ra,24(sp)
    80000c92:	6442                	ld	s0,16(sp)
    80000c94:	64a2                	ld	s1,8(sp)
    80000c96:	6105                	addi	sp,sp,32
    80000c98:	8082                	ret

0000000080000c9a <release>:
{
    80000c9a:	1101                	addi	sp,sp,-32
    80000c9c:	ec06                	sd	ra,24(sp)
    80000c9e:	e822                	sd	s0,16(sp)
    80000ca0:	e426                	sd	s1,8(sp)
    80000ca2:	1000                	addi	s0,sp,32
    80000ca4:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000ca6:	00000097          	auipc	ra,0x0
    80000caa:	f44080e7          	jalr	-188(ra) # 80000bea <holding>
    80000cae:	c115                	beqz	a0,80000cd2 <release+0x38>
  lk->cpu = 0;
    80000cb0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cb4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000cb8:	0f50000f          	fence	iorw,ow
    80000cbc:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cc0:	00000097          	auipc	ra,0x0
    80000cc4:	ebe080e7          	jalr	-322(ra) # 80000b7e <pop_off>
}
    80000cc8:	60e2                	ld	ra,24(sp)
    80000cca:	6442                	ld	s0,16(sp)
    80000ccc:	64a2                	ld	s1,8(sp)
    80000cce:	6105                	addi	sp,sp,32
    80000cd0:	8082                	ret
    panic("release");
    80000cd2:	00007517          	auipc	a0,0x7
    80000cd6:	58e50513          	addi	a0,a0,1422 # 80008260 <userret+0x1d0>
    80000cda:	00000097          	auipc	ra,0x0
    80000cde:	86e080e7          	jalr	-1938(ra) # 80000548 <panic>

0000000080000ce2 <print_lock>:

void
print_lock(struct spinlock *lk)
{
  if(lk->n > 0) 
    80000ce2:	4d14                	lw	a3,24(a0)
    80000ce4:	e291                	bnez	a3,80000ce8 <print_lock+0x6>
    80000ce6:	8082                	ret
{
    80000ce8:	1141                	addi	sp,sp,-16
    80000cea:	e406                	sd	ra,8(sp)
    80000cec:	e022                	sd	s0,0(sp)
    80000cee:	0800                	addi	s0,sp,16
    printf("lock: %s: #test-and-set %d #acquire() %d\n", lk->name, lk->nts, lk->n);
    80000cf0:	4d50                	lw	a2,28(a0)
    80000cf2:	650c                	ld	a1,8(a0)
    80000cf4:	00007517          	auipc	a0,0x7
    80000cf8:	57450513          	addi	a0,a0,1396 # 80008268 <userret+0x1d8>
    80000cfc:	00000097          	auipc	ra,0x0
    80000d00:	8a6080e7          	jalr	-1882(ra) # 800005a2 <printf>
}
    80000d04:	60a2                	ld	ra,8(sp)
    80000d06:	6402                	ld	s0,0(sp)
    80000d08:	0141                	addi	sp,sp,16
    80000d0a:	8082                	ret

0000000080000d0c <sys_ntas>:

uint64
sys_ntas(void)
{
    80000d0c:	711d                	addi	sp,sp,-96
    80000d0e:	ec86                	sd	ra,88(sp)
    80000d10:	e8a2                	sd	s0,80(sp)
    80000d12:	e4a6                	sd	s1,72(sp)
    80000d14:	e0ca                	sd	s2,64(sp)
    80000d16:	fc4e                	sd	s3,56(sp)
    80000d18:	f852                	sd	s4,48(sp)
    80000d1a:	f456                	sd	s5,40(sp)
    80000d1c:	f05a                	sd	s6,32(sp)
    80000d1e:	ec5e                	sd	s7,24(sp)
    80000d20:	e862                	sd	s8,16(sp)
    80000d22:	1080                	addi	s0,sp,96
  int zero = 0;
    80000d24:	fa042623          	sw	zero,-84(s0)
  int tot = 0;
  
  if (argint(0, &zero) < 0) {
    80000d28:	fac40593          	addi	a1,s0,-84
    80000d2c:	4501                	li	a0,0
    80000d2e:	00002097          	auipc	ra,0x2
    80000d32:	ece080e7          	jalr	-306(ra) # 80002bfc <argint>
    80000d36:	14054d63          	bltz	a0,80000e90 <sys_ntas+0x184>
    return -1;
  }
  if(zero == 0) {
    80000d3a:	fac42783          	lw	a5,-84(s0)
    80000d3e:	e78d                	bnez	a5,80000d68 <sys_ntas+0x5c>
    80000d40:	00012797          	auipc	a5,0x12
    80000d44:	cd878793          	addi	a5,a5,-808 # 80012a18 <locks>
    80000d48:	00014697          	auipc	a3,0x14
    80000d4c:	c1068693          	addi	a3,a3,-1008 # 80014958 <pid_lock>
    for(int i = 0; i < NLOCK; i++) {
      if(locks[i] == 0)
    80000d50:	6398                	ld	a4,0(a5)
    80000d52:	14070163          	beqz	a4,80000e94 <sys_ntas+0x188>
        break;
      locks[i]->nts = 0;
    80000d56:	00072e23          	sw	zero,28(a4)
      locks[i]->n = 0;
    80000d5a:	00072c23          	sw	zero,24(a4)
    for(int i = 0; i < NLOCK; i++) {
    80000d5e:	07a1                	addi	a5,a5,8
    80000d60:	fed798e3          	bne	a5,a3,80000d50 <sys_ntas+0x44>
    }
    return 0;
    80000d64:	4501                	li	a0,0
    80000d66:	aa09                	j	80000e78 <sys_ntas+0x16c>
  }

  printf("=== lock kmem/bcache stats\n");
    80000d68:	00007517          	auipc	a0,0x7
    80000d6c:	53050513          	addi	a0,a0,1328 # 80008298 <userret+0x208>
    80000d70:	00000097          	auipc	ra,0x0
    80000d74:	832080e7          	jalr	-1998(ra) # 800005a2 <printf>
  for(int i = 0; i < NLOCK; i++) {
    80000d78:	00012b17          	auipc	s6,0x12
    80000d7c:	ca0b0b13          	addi	s6,s6,-864 # 80012a18 <locks>
    80000d80:	00014b97          	auipc	s7,0x14
    80000d84:	bd8b8b93          	addi	s7,s7,-1064 # 80014958 <pid_lock>
  printf("=== lock kmem/bcache stats\n");
    80000d88:	84da                	mv	s1,s6
  int tot = 0;
    80000d8a:	4981                	li	s3,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80000d8c:	00007a17          	auipc	s4,0x7
    80000d90:	52ca0a13          	addi	s4,s4,1324 # 800082b8 <userret+0x228>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80000d94:	00007c17          	auipc	s8,0x7
    80000d98:	48cc0c13          	addi	s8,s8,1164 # 80008220 <userret+0x190>
    80000d9c:	a829                	j	80000db6 <sys_ntas+0xaa>
      tot += locks[i]->nts;
    80000d9e:	00093503          	ld	a0,0(s2)
    80000da2:	4d5c                	lw	a5,28(a0)
    80000da4:	013789bb          	addw	s3,a5,s3
      print_lock(locks[i]);
    80000da8:	00000097          	auipc	ra,0x0
    80000dac:	f3a080e7          	jalr	-198(ra) # 80000ce2 <print_lock>
  for(int i = 0; i < NLOCK; i++) {
    80000db0:	04a1                	addi	s1,s1,8
    80000db2:	05748763          	beq	s1,s7,80000e00 <sys_ntas+0xf4>
    if(locks[i] == 0)
    80000db6:	8926                	mv	s2,s1
    80000db8:	609c                	ld	a5,0(s1)
    80000dba:	c3b9                	beqz	a5,80000e00 <sys_ntas+0xf4>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80000dbc:	0087ba83          	ld	s5,8(a5)
    80000dc0:	8552                	mv	a0,s4
    80000dc2:	00000097          	auipc	ra,0x0
    80000dc6:	25a080e7          	jalr	602(ra) # 8000101c <strlen>
    80000dca:	0005061b          	sext.w	a2,a0
    80000dce:	85d2                	mv	a1,s4
    80000dd0:	8556                	mv	a0,s5
    80000dd2:	00000097          	auipc	ra,0x0
    80000dd6:	19e080e7          	jalr	414(ra) # 80000f70 <strncmp>
    80000dda:	d171                	beqz	a0,80000d9e <sys_ntas+0x92>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80000ddc:	609c                	ld	a5,0(s1)
    80000dde:	0087ba83          	ld	s5,8(a5)
    80000de2:	8562                	mv	a0,s8
    80000de4:	00000097          	auipc	ra,0x0
    80000de8:	238080e7          	jalr	568(ra) # 8000101c <strlen>
    80000dec:	0005061b          	sext.w	a2,a0
    80000df0:	85e2                	mv	a1,s8
    80000df2:	8556                	mv	a0,s5
    80000df4:	00000097          	auipc	ra,0x0
    80000df8:	17c080e7          	jalr	380(ra) # 80000f70 <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80000dfc:	f955                	bnez	a0,80000db0 <sys_ntas+0xa4>
    80000dfe:	b745                	j	80000d9e <sys_ntas+0x92>
    }
  }

  printf("=== top 5 contended locks:\n");
    80000e00:	00007517          	auipc	a0,0x7
    80000e04:	4c050513          	addi	a0,a0,1216 # 800082c0 <userret+0x230>
    80000e08:	fffff097          	auipc	ra,0xfffff
    80000e0c:	79a080e7          	jalr	1946(ra) # 800005a2 <printf>
    80000e10:	4a15                	li	s4,5
  int last = 100000000;
    80000e12:	05f5e537          	lui	a0,0x5f5e
    80000e16:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t= 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    80000e1a:	4a81                	li	s5,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80000e1c:	00012497          	auipc	s1,0x12
    80000e20:	bfc48493          	addi	s1,s1,-1028 # 80012a18 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80000e24:	3e800913          	li	s2,1000
    80000e28:	a091                	j	80000e6c <sys_ntas+0x160>
    80000e2a:	2705                	addiw	a4,a4,1
    80000e2c:	06a1                	addi	a3,a3,8
    80000e2e:	03270063          	beq	a4,s2,80000e4e <sys_ntas+0x142>
      if(locks[i] == 0)
    80000e32:	629c                	ld	a5,0(a3)
    80000e34:	cf89                	beqz	a5,80000e4e <sys_ntas+0x142>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80000e36:	4fd0                	lw	a2,28(a5)
    80000e38:	00359793          	slli	a5,a1,0x3
    80000e3c:	97a6                	add	a5,a5,s1
    80000e3e:	639c                	ld	a5,0(a5)
    80000e40:	4fdc                	lw	a5,28(a5)
    80000e42:	fec7f4e3          	bgeu	a5,a2,80000e2a <sys_ntas+0x11e>
    80000e46:	fea672e3          	bgeu	a2,a0,80000e2a <sys_ntas+0x11e>
    80000e4a:	85ba                	mv	a1,a4
    80000e4c:	bff9                	j	80000e2a <sys_ntas+0x11e>
        top = i;
      }
    }
    print_lock(locks[top]);
    80000e4e:	058e                	slli	a1,a1,0x3
    80000e50:	00b48bb3          	add	s7,s1,a1
    80000e54:	000bb503          	ld	a0,0(s7)
    80000e58:	00000097          	auipc	ra,0x0
    80000e5c:	e8a080e7          	jalr	-374(ra) # 80000ce2 <print_lock>
    last = locks[top]->nts;
    80000e60:	000bb783          	ld	a5,0(s7)
    80000e64:	4fc8                	lw	a0,28(a5)
  for(int t= 0; t < 5; t++) {
    80000e66:	3a7d                	addiw	s4,s4,-1
    80000e68:	000a0763          	beqz	s4,80000e76 <sys_ntas+0x16a>
  int tot = 0;
    80000e6c:	86da                	mv	a3,s6
    for(int i = 0; i < NLOCK; i++) {
    80000e6e:	8756                	mv	a4,s5
    int top = 0;
    80000e70:	85d6                	mv	a1,s5
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80000e72:	2501                	sext.w	a0,a0
    80000e74:	bf7d                	j	80000e32 <sys_ntas+0x126>
  }
  return tot;
    80000e76:	854e                	mv	a0,s3
}
    80000e78:	60e6                	ld	ra,88(sp)
    80000e7a:	6446                	ld	s0,80(sp)
    80000e7c:	64a6                	ld	s1,72(sp)
    80000e7e:	6906                	ld	s2,64(sp)
    80000e80:	79e2                	ld	s3,56(sp)
    80000e82:	7a42                	ld	s4,48(sp)
    80000e84:	7aa2                	ld	s5,40(sp)
    80000e86:	7b02                	ld	s6,32(sp)
    80000e88:	6be2                	ld	s7,24(sp)
    80000e8a:	6c42                	ld	s8,16(sp)
    80000e8c:	6125                	addi	sp,sp,96
    80000e8e:	8082                	ret
    return -1;
    80000e90:	557d                	li	a0,-1
    80000e92:	b7dd                	j	80000e78 <sys_ntas+0x16c>
    return 0;
    80000e94:	4501                	li	a0,0
    80000e96:	b7cd                	j	80000e78 <sys_ntas+0x16c>

0000000080000e98 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000e98:	1141                	addi	sp,sp,-16
    80000e9a:	e422                	sd	s0,8(sp)
    80000e9c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000e9e:	ca19                	beqz	a2,80000eb4 <memset+0x1c>
    80000ea0:	87aa                	mv	a5,a0
    80000ea2:	1602                	slli	a2,a2,0x20
    80000ea4:	9201                	srli	a2,a2,0x20
    80000ea6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000eaa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000eae:	0785                	addi	a5,a5,1
    80000eb0:	fee79de3          	bne	a5,a4,80000eaa <memset+0x12>
  }
  return dst;
}
    80000eb4:	6422                	ld	s0,8(sp)
    80000eb6:	0141                	addi	sp,sp,16
    80000eb8:	8082                	ret

0000000080000eba <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000eba:	1141                	addi	sp,sp,-16
    80000ebc:	e422                	sd	s0,8(sp)
    80000ebe:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000ec0:	ca05                	beqz	a2,80000ef0 <memcmp+0x36>
    80000ec2:	fff6069b          	addiw	a3,a2,-1
    80000ec6:	1682                	slli	a3,a3,0x20
    80000ec8:	9281                	srli	a3,a3,0x20
    80000eca:	0685                	addi	a3,a3,1
    80000ecc:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000ece:	00054783          	lbu	a5,0(a0)
    80000ed2:	0005c703          	lbu	a4,0(a1)
    80000ed6:	00e79863          	bne	a5,a4,80000ee6 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000eda:	0505                	addi	a0,a0,1
    80000edc:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000ede:	fed518e3          	bne	a0,a3,80000ece <memcmp+0x14>
  }

  return 0;
    80000ee2:	4501                	li	a0,0
    80000ee4:	a019                	j	80000eea <memcmp+0x30>
      return *s1 - *s2;
    80000ee6:	40e7853b          	subw	a0,a5,a4
}
    80000eea:	6422                	ld	s0,8(sp)
    80000eec:	0141                	addi	sp,sp,16
    80000eee:	8082                	ret
  return 0;
    80000ef0:	4501                	li	a0,0
    80000ef2:	bfe5                	j	80000eea <memcmp+0x30>

0000000080000ef4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000ef4:	1141                	addi	sp,sp,-16
    80000ef6:	e422                	sd	s0,8(sp)
    80000ef8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000efa:	02a5e563          	bltu	a1,a0,80000f24 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000efe:	fff6069b          	addiw	a3,a2,-1
    80000f02:	ce11                	beqz	a2,80000f1e <memmove+0x2a>
    80000f04:	1682                	slli	a3,a3,0x20
    80000f06:	9281                	srli	a3,a3,0x20
    80000f08:	0685                	addi	a3,a3,1
    80000f0a:	96ae                	add	a3,a3,a1
    80000f0c:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000f0e:	0585                	addi	a1,a1,1
    80000f10:	0785                	addi	a5,a5,1
    80000f12:	fff5c703          	lbu	a4,-1(a1)
    80000f16:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000f1a:	fed59ae3          	bne	a1,a3,80000f0e <memmove+0x1a>

  return dst;
}
    80000f1e:	6422                	ld	s0,8(sp)
    80000f20:	0141                	addi	sp,sp,16
    80000f22:	8082                	ret
  if(s < d && s + n > d){
    80000f24:	02061713          	slli	a4,a2,0x20
    80000f28:	9301                	srli	a4,a4,0x20
    80000f2a:	00e587b3          	add	a5,a1,a4
    80000f2e:	fcf578e3          	bgeu	a0,a5,80000efe <memmove+0xa>
    d += n;
    80000f32:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000f34:	fff6069b          	addiw	a3,a2,-1
    80000f38:	d27d                	beqz	a2,80000f1e <memmove+0x2a>
    80000f3a:	02069613          	slli	a2,a3,0x20
    80000f3e:	9201                	srli	a2,a2,0x20
    80000f40:	fff64613          	not	a2,a2
    80000f44:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000f46:	17fd                	addi	a5,a5,-1
    80000f48:	177d                	addi	a4,a4,-1
    80000f4a:	0007c683          	lbu	a3,0(a5)
    80000f4e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000f52:	fef61ae3          	bne	a2,a5,80000f46 <memmove+0x52>
    80000f56:	b7e1                	j	80000f1e <memmove+0x2a>

0000000080000f58 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000f58:	1141                	addi	sp,sp,-16
    80000f5a:	e406                	sd	ra,8(sp)
    80000f5c:	e022                	sd	s0,0(sp)
    80000f5e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000f60:	00000097          	auipc	ra,0x0
    80000f64:	f94080e7          	jalr	-108(ra) # 80000ef4 <memmove>
}
    80000f68:	60a2                	ld	ra,8(sp)
    80000f6a:	6402                	ld	s0,0(sp)
    80000f6c:	0141                	addi	sp,sp,16
    80000f6e:	8082                	ret

0000000080000f70 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000f70:	1141                	addi	sp,sp,-16
    80000f72:	e422                	sd	s0,8(sp)
    80000f74:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000f76:	ce11                	beqz	a2,80000f92 <strncmp+0x22>
    80000f78:	00054783          	lbu	a5,0(a0)
    80000f7c:	cf89                	beqz	a5,80000f96 <strncmp+0x26>
    80000f7e:	0005c703          	lbu	a4,0(a1)
    80000f82:	00f71a63          	bne	a4,a5,80000f96 <strncmp+0x26>
    n--, p++, q++;
    80000f86:	367d                	addiw	a2,a2,-1
    80000f88:	0505                	addi	a0,a0,1
    80000f8a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000f8c:	f675                	bnez	a2,80000f78 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000f8e:	4501                	li	a0,0
    80000f90:	a809                	j	80000fa2 <strncmp+0x32>
    80000f92:	4501                	li	a0,0
    80000f94:	a039                	j	80000fa2 <strncmp+0x32>
  if(n == 0)
    80000f96:	ca09                	beqz	a2,80000fa8 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000f98:	00054503          	lbu	a0,0(a0)
    80000f9c:	0005c783          	lbu	a5,0(a1)
    80000fa0:	9d1d                	subw	a0,a0,a5
}
    80000fa2:	6422                	ld	s0,8(sp)
    80000fa4:	0141                	addi	sp,sp,16
    80000fa6:	8082                	ret
    return 0;
    80000fa8:	4501                	li	a0,0
    80000faa:	bfe5                	j	80000fa2 <strncmp+0x32>

0000000080000fac <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000fac:	1141                	addi	sp,sp,-16
    80000fae:	e422                	sd	s0,8(sp)
    80000fb0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000fb2:	872a                	mv	a4,a0
    80000fb4:	8832                	mv	a6,a2
    80000fb6:	367d                	addiw	a2,a2,-1
    80000fb8:	01005963          	blez	a6,80000fca <strncpy+0x1e>
    80000fbc:	0705                	addi	a4,a4,1
    80000fbe:	0005c783          	lbu	a5,0(a1)
    80000fc2:	fef70fa3          	sb	a5,-1(a4)
    80000fc6:	0585                	addi	a1,a1,1
    80000fc8:	f7f5                	bnez	a5,80000fb4 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000fca:	86ba                	mv	a3,a4
    80000fcc:	00c05c63          	blez	a2,80000fe4 <strncpy+0x38>
    *s++ = 0;
    80000fd0:	0685                	addi	a3,a3,1
    80000fd2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000fd6:	fff6c793          	not	a5,a3
    80000fda:	9fb9                	addw	a5,a5,a4
    80000fdc:	010787bb          	addw	a5,a5,a6
    80000fe0:	fef048e3          	bgtz	a5,80000fd0 <strncpy+0x24>
  return os;
}
    80000fe4:	6422                	ld	s0,8(sp)
    80000fe6:	0141                	addi	sp,sp,16
    80000fe8:	8082                	ret

0000000080000fea <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000fea:	1141                	addi	sp,sp,-16
    80000fec:	e422                	sd	s0,8(sp)
    80000fee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000ff0:	02c05363          	blez	a2,80001016 <safestrcpy+0x2c>
    80000ff4:	fff6069b          	addiw	a3,a2,-1
    80000ff8:	1682                	slli	a3,a3,0x20
    80000ffa:	9281                	srli	a3,a3,0x20
    80000ffc:	96ae                	add	a3,a3,a1
    80000ffe:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80001000:	00d58963          	beq	a1,a3,80001012 <safestrcpy+0x28>
    80001004:	0585                	addi	a1,a1,1
    80001006:	0785                	addi	a5,a5,1
    80001008:	fff5c703          	lbu	a4,-1(a1)
    8000100c:	fee78fa3          	sb	a4,-1(a5)
    80001010:	fb65                	bnez	a4,80001000 <safestrcpy+0x16>
    ;
  *s = 0;
    80001012:	00078023          	sb	zero,0(a5)
  return os;
}
    80001016:	6422                	ld	s0,8(sp)
    80001018:	0141                	addi	sp,sp,16
    8000101a:	8082                	ret

000000008000101c <strlen>:

int
strlen(const char *s)
{
    8000101c:	1141                	addi	sp,sp,-16
    8000101e:	e422                	sd	s0,8(sp)
    80001020:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80001022:	00054783          	lbu	a5,0(a0)
    80001026:	cf91                	beqz	a5,80001042 <strlen+0x26>
    80001028:	0505                	addi	a0,a0,1
    8000102a:	87aa                	mv	a5,a0
    8000102c:	4685                	li	a3,1
    8000102e:	9e89                	subw	a3,a3,a0
    80001030:	00f6853b          	addw	a0,a3,a5
    80001034:	0785                	addi	a5,a5,1
    80001036:	fff7c703          	lbu	a4,-1(a5)
    8000103a:	fb7d                	bnez	a4,80001030 <strlen+0x14>
    ;
  return n;
}
    8000103c:	6422                	ld	s0,8(sp)
    8000103e:	0141                	addi	sp,sp,16
    80001040:	8082                	ret
  for(n = 0; s[n]; n++)
    80001042:	4501                	li	a0,0
    80001044:	bfe5                	j	8000103c <strlen+0x20>

0000000080001046 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80001046:	1141                	addi	sp,sp,-16
    80001048:	e406                	sd	ra,8(sp)
    8000104a:	e022                	sd	s0,0(sp)
    8000104c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000104e:	00001097          	auipc	ra,0x1
    80001052:	b08080e7          	jalr	-1272(ra) # 80001b56 <cpuid>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80001056:	0002f717          	auipc	a4,0x2f
    8000105a:	fd270713          	addi	a4,a4,-46 # 80030028 <started>
  if(cpuid() == 0){
    8000105e:	c139                	beqz	a0,800010a4 <main+0x5e>
    while(started == 0)
    80001060:	431c                	lw	a5,0(a4)
    80001062:	2781                	sext.w	a5,a5
    80001064:	dff5                	beqz	a5,80001060 <main+0x1a>
      ;
    __sync_synchronize();
    80001066:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000106a:	00001097          	auipc	ra,0x1
    8000106e:	aec080e7          	jalr	-1300(ra) # 80001b56 <cpuid>
    80001072:	85aa                	mv	a1,a0
    80001074:	00007517          	auipc	a0,0x7
    80001078:	28450513          	addi	a0,a0,644 # 800082f8 <userret+0x268>
    8000107c:	fffff097          	auipc	ra,0xfffff
    80001080:	526080e7          	jalr	1318(ra) # 800005a2 <printf>
    kvminithart();    // turn on paging
    80001084:	00000097          	auipc	ra,0x0
    80001088:	1ea080e7          	jalr	490(ra) # 8000126e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000108c:	00001097          	auipc	ra,0x1
    80001090:	714080e7          	jalr	1812(ra) # 800027a0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80001094:	00005097          	auipc	ra,0x5
    80001098:	edc080e7          	jalr	-292(ra) # 80005f70 <plicinithart>
  }

  scheduler();        
    8000109c:	00001097          	auipc	ra,0x1
    800010a0:	fc4080e7          	jalr	-60(ra) # 80002060 <scheduler>
    consoleinit();
    800010a4:	fffff097          	auipc	ra,0xfffff
    800010a8:	3b6080e7          	jalr	950(ra) # 8000045a <consoleinit>
    printfinit();
    800010ac:	fffff097          	auipc	ra,0xfffff
    800010b0:	6d6080e7          	jalr	1750(ra) # 80000782 <printfinit>
    printf("\n");
    800010b4:	00007517          	auipc	a0,0x7
    800010b8:	1dc50513          	addi	a0,a0,476 # 80008290 <userret+0x200>
    800010bc:	fffff097          	auipc	ra,0xfffff
    800010c0:	4e6080e7          	jalr	1254(ra) # 800005a2 <printf>
    printf("xv6 kernel is booting\n");
    800010c4:	00007517          	auipc	a0,0x7
    800010c8:	21c50513          	addi	a0,a0,540 # 800082e0 <userret+0x250>
    800010cc:	fffff097          	auipc	ra,0xfffff
    800010d0:	4d6080e7          	jalr	1238(ra) # 800005a2 <printf>
    printf("\n");
    800010d4:	00007517          	auipc	a0,0x7
    800010d8:	1bc50513          	addi	a0,a0,444 # 80008290 <userret+0x200>
    800010dc:	fffff097          	auipc	ra,0xfffff
    800010e0:	4c6080e7          	jalr	1222(ra) # 800005a2 <printf>
    kinit();         // physical page allocator
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	874080e7          	jalr	-1932(ra) # 80000958 <kinit>
    kvminit();       // create kernel page table
    800010ec:	00000097          	auipc	ra,0x0
    800010f0:	30c080e7          	jalr	780(ra) # 800013f8 <kvminit>
    kvminithart();   // turn on paging
    800010f4:	00000097          	auipc	ra,0x0
    800010f8:	17a080e7          	jalr	378(ra) # 8000126e <kvminithart>
    procinit();      // process table
    800010fc:	00001097          	auipc	ra,0x1
    80001100:	98a080e7          	jalr	-1654(ra) # 80001a86 <procinit>
    trapinit();      // trap vectors
    80001104:	00001097          	auipc	ra,0x1
    80001108:	674080e7          	jalr	1652(ra) # 80002778 <trapinit>
    trapinithart();  // install kernel trap vector
    8000110c:	00001097          	auipc	ra,0x1
    80001110:	694080e7          	jalr	1684(ra) # 800027a0 <trapinithart>
    plicinit();      // set up interrupt controller
    80001114:	00005097          	auipc	ra,0x5
    80001118:	e46080e7          	jalr	-442(ra) # 80005f5a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000111c:	00005097          	auipc	ra,0x5
    80001120:	e54080e7          	jalr	-428(ra) # 80005f70 <plicinithart>
    binit();         // buffer cache
    80001124:	00002097          	auipc	ra,0x2
    80001128:	db8080e7          	jalr	-584(ra) # 80002edc <binit>
    iinit();         // inode cache
    8000112c:	00002097          	auipc	ra,0x2
    80001130:	56a080e7          	jalr	1386(ra) # 80003696 <iinit>
    fileinit();      // file table
    80001134:	00003097          	auipc	ra,0x3
    80001138:	5f6080e7          	jalr	1526(ra) # 8000472a <fileinit>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    8000113c:	4501                	li	a0,0
    8000113e:	00005097          	auipc	ra,0x5
    80001142:	f54080e7          	jalr	-172(ra) # 80006092 <virtio_disk_init>
    userinit();      // first user process
    80001146:	00001097          	auipc	ra,0x1
    8000114a:	cb0080e7          	jalr	-848(ra) # 80001df6 <userinit>
    __sync_synchronize();
    8000114e:	0ff0000f          	fence
    started = 1;
    80001152:	4785                	li	a5,1
    80001154:	0002f717          	auipc	a4,0x2f
    80001158:	ecf72a23          	sw	a5,-300(a4) # 80030028 <started>
    8000115c:	b781                	j	8000109c <main+0x56>

000000008000115e <walk>:
//   21..39 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..12 -- 12 bits of byte offset within the page.
static pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000115e:	7139                	addi	sp,sp,-64
    80001160:	fc06                	sd	ra,56(sp)
    80001162:	f822                	sd	s0,48(sp)
    80001164:	f426                	sd	s1,40(sp)
    80001166:	f04a                	sd	s2,32(sp)
    80001168:	ec4e                	sd	s3,24(sp)
    8000116a:	e852                	sd	s4,16(sp)
    8000116c:	e456                	sd	s5,8(sp)
    8000116e:	e05a                	sd	s6,0(sp)
    80001170:	0080                	addi	s0,sp,64
    80001172:	84aa                	mv	s1,a0
    80001174:	89ae                	mv	s3,a1
    80001176:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001178:	57fd                	li	a5,-1
    8000117a:	83e9                	srli	a5,a5,0x1a
    8000117c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000117e:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001180:	04b7f263          	bgeu	a5,a1,800011c4 <walk+0x66>
    panic("walk");
    80001184:	00007517          	auipc	a0,0x7
    80001188:	18c50513          	addi	a0,a0,396 # 80008310 <userret+0x280>
    8000118c:	fffff097          	auipc	ra,0xfffff
    80001190:	3bc080e7          	jalr	956(ra) # 80000548 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001194:	060a8663          	beqz	s5,80001200 <walk+0xa2>
    80001198:	00000097          	auipc	ra,0x0
    8000119c:	8ac080e7          	jalr	-1876(ra) # 80000a44 <kalloc>
    800011a0:	84aa                	mv	s1,a0
    800011a2:	c529                	beqz	a0,800011ec <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800011a4:	6605                	lui	a2,0x1
    800011a6:	4581                	li	a1,0
    800011a8:	00000097          	auipc	ra,0x0
    800011ac:	cf0080e7          	jalr	-784(ra) # 80000e98 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800011b0:	00c4d793          	srli	a5,s1,0xc
    800011b4:	07aa                	slli	a5,a5,0xa
    800011b6:	0017e793          	ori	a5,a5,1
    800011ba:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800011be:	3a5d                	addiw	s4,s4,-9
    800011c0:	036a0063          	beq	s4,s6,800011e0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800011c4:	0149d933          	srl	s2,s3,s4
    800011c8:	1ff97913          	andi	s2,s2,511
    800011cc:	090e                	slli	s2,s2,0x3
    800011ce:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800011d0:	00093483          	ld	s1,0(s2)
    800011d4:	0014f793          	andi	a5,s1,1
    800011d8:	dfd5                	beqz	a5,80001194 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800011da:	80a9                	srli	s1,s1,0xa
    800011dc:	04b2                	slli	s1,s1,0xc
    800011de:	b7c5                	j	800011be <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800011e0:	00c9d513          	srli	a0,s3,0xc
    800011e4:	1ff57513          	andi	a0,a0,511
    800011e8:	050e                	slli	a0,a0,0x3
    800011ea:	9526                	add	a0,a0,s1
}
    800011ec:	70e2                	ld	ra,56(sp)
    800011ee:	7442                	ld	s0,48(sp)
    800011f0:	74a2                	ld	s1,40(sp)
    800011f2:	7902                	ld	s2,32(sp)
    800011f4:	69e2                	ld	s3,24(sp)
    800011f6:	6a42                	ld	s4,16(sp)
    800011f8:	6aa2                	ld	s5,8(sp)
    800011fa:	6b02                	ld	s6,0(sp)
    800011fc:	6121                	addi	sp,sp,64
    800011fe:	8082                	ret
        return 0;
    80001200:	4501                	li	a0,0
    80001202:	b7ed                	j	800011ec <walk+0x8e>

0000000080001204 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void
freewalk(pagetable_t pagetable)
{
    80001204:	7179                	addi	sp,sp,-48
    80001206:	f406                	sd	ra,40(sp)
    80001208:	f022                	sd	s0,32(sp)
    8000120a:	ec26                	sd	s1,24(sp)
    8000120c:	e84a                	sd	s2,16(sp)
    8000120e:	e44e                	sd	s3,8(sp)
    80001210:	e052                	sd	s4,0(sp)
    80001212:	1800                	addi	s0,sp,48
    80001214:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001216:	84aa                	mv	s1,a0
    80001218:	6905                	lui	s2,0x1
    8000121a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000121c:	4985                	li	s3,1
    8000121e:	a821                	j	80001236 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001220:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80001222:	0532                	slli	a0,a0,0xc
    80001224:	00000097          	auipc	ra,0x0
    80001228:	fe0080e7          	jalr	-32(ra) # 80001204 <freewalk>
      pagetable[i] = 0;
    8000122c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001230:	04a1                	addi	s1,s1,8
    80001232:	03248163          	beq	s1,s2,80001254 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80001236:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001238:	00f57793          	andi	a5,a0,15
    8000123c:	ff3782e3          	beq	a5,s3,80001220 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001240:	8905                	andi	a0,a0,1
    80001242:	d57d                	beqz	a0,80001230 <freewalk+0x2c>
      panic("freewalk: leaf");
    80001244:	00007517          	auipc	a0,0x7
    80001248:	0d450513          	addi	a0,a0,212 # 80008318 <userret+0x288>
    8000124c:	fffff097          	auipc	ra,0xfffff
    80001250:	2fc080e7          	jalr	764(ra) # 80000548 <panic>
    }
  }
  kfree((void*)pagetable);
    80001254:	8552                	mv	a0,s4
    80001256:	fffff097          	auipc	ra,0xfffff
    8000125a:	60e080e7          	jalr	1550(ra) # 80000864 <kfree>
}
    8000125e:	70a2                	ld	ra,40(sp)
    80001260:	7402                	ld	s0,32(sp)
    80001262:	64e2                	ld	s1,24(sp)
    80001264:	6942                	ld	s2,16(sp)
    80001266:	69a2                	ld	s3,8(sp)
    80001268:	6a02                	ld	s4,0(sp)
    8000126a:	6145                	addi	sp,sp,48
    8000126c:	8082                	ret

000000008000126e <kvminithart>:
{
    8000126e:	1141                	addi	sp,sp,-16
    80001270:	e422                	sd	s0,8(sp)
    80001272:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80001274:	0002f797          	auipc	a5,0x2f
    80001278:	dbc7b783          	ld	a5,-580(a5) # 80030030 <kernel_pagetable>
    8000127c:	83b1                	srli	a5,a5,0xc
    8000127e:	577d                	li	a4,-1
    80001280:	177e                	slli	a4,a4,0x3f
    80001282:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001284:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001288:	12000073          	sfence.vma
}
    8000128c:	6422                	ld	s0,8(sp)
    8000128e:	0141                	addi	sp,sp,16
    80001290:	8082                	ret

0000000080001292 <walkaddr>:
  if(va >= MAXVA)
    80001292:	57fd                	li	a5,-1
    80001294:	83e9                	srli	a5,a5,0x1a
    80001296:	00b7f463          	bgeu	a5,a1,8000129e <walkaddr+0xc>
    return 0;
    8000129a:	4501                	li	a0,0
}
    8000129c:	8082                	ret
{
    8000129e:	1141                	addi	sp,sp,-16
    800012a0:	e406                	sd	ra,8(sp)
    800012a2:	e022                	sd	s0,0(sp)
    800012a4:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800012a6:	4601                	li	a2,0
    800012a8:	00000097          	auipc	ra,0x0
    800012ac:	eb6080e7          	jalr	-330(ra) # 8000115e <walk>
  if(pte == 0)
    800012b0:	c105                	beqz	a0,800012d0 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800012b2:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800012b4:	0117f693          	andi	a3,a5,17
    800012b8:	4745                	li	a4,17
    return 0;
    800012ba:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800012bc:	00e68663          	beq	a3,a4,800012c8 <walkaddr+0x36>
}
    800012c0:	60a2                	ld	ra,8(sp)
    800012c2:	6402                	ld	s0,0(sp)
    800012c4:	0141                	addi	sp,sp,16
    800012c6:	8082                	ret
  pa = PTE2PA(*pte);
    800012c8:	00a7d513          	srli	a0,a5,0xa
    800012cc:	0532                	slli	a0,a0,0xc
  return pa;
    800012ce:	bfcd                	j	800012c0 <walkaddr+0x2e>
    return 0;
    800012d0:	4501                	li	a0,0
    800012d2:	b7fd                	j	800012c0 <walkaddr+0x2e>

00000000800012d4 <kvmpa>:
{
    800012d4:	1101                	addi	sp,sp,-32
    800012d6:	ec06                	sd	ra,24(sp)
    800012d8:	e822                	sd	s0,16(sp)
    800012da:	e426                	sd	s1,8(sp)
    800012dc:	1000                	addi	s0,sp,32
    800012de:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    800012e0:	1552                	slli	a0,a0,0x34
    800012e2:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    800012e6:	4601                	li	a2,0
    800012e8:	0002f517          	auipc	a0,0x2f
    800012ec:	d4853503          	ld	a0,-696(a0) # 80030030 <kernel_pagetable>
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	e6e080e7          	jalr	-402(ra) # 8000115e <walk>
  if(pte == 0)
    800012f8:	cd09                	beqz	a0,80001312 <kvmpa+0x3e>
  if((*pte & PTE_V) == 0)
    800012fa:	6108                	ld	a0,0(a0)
    800012fc:	00157793          	andi	a5,a0,1
    80001300:	c38d                	beqz	a5,80001322 <kvmpa+0x4e>
  pa = PTE2PA(*pte);
    80001302:	8129                	srli	a0,a0,0xa
    80001304:	0532                	slli	a0,a0,0xc
}
    80001306:	9526                	add	a0,a0,s1
    80001308:	60e2                	ld	ra,24(sp)
    8000130a:	6442                	ld	s0,16(sp)
    8000130c:	64a2                	ld	s1,8(sp)
    8000130e:	6105                	addi	sp,sp,32
    80001310:	8082                	ret
    panic("kvmpa");
    80001312:	00007517          	auipc	a0,0x7
    80001316:	01650513          	addi	a0,a0,22 # 80008328 <userret+0x298>
    8000131a:	fffff097          	auipc	ra,0xfffff
    8000131e:	22e080e7          	jalr	558(ra) # 80000548 <panic>
    panic("kvmpa");
    80001322:	00007517          	auipc	a0,0x7
    80001326:	00650513          	addi	a0,a0,6 # 80008328 <userret+0x298>
    8000132a:	fffff097          	auipc	ra,0xfffff
    8000132e:	21e080e7          	jalr	542(ra) # 80000548 <panic>

0000000080001332 <mappages>:
{
    80001332:	715d                	addi	sp,sp,-80
    80001334:	e486                	sd	ra,72(sp)
    80001336:	e0a2                	sd	s0,64(sp)
    80001338:	fc26                	sd	s1,56(sp)
    8000133a:	f84a                	sd	s2,48(sp)
    8000133c:	f44e                	sd	s3,40(sp)
    8000133e:	f052                	sd	s4,32(sp)
    80001340:	ec56                	sd	s5,24(sp)
    80001342:	e85a                	sd	s6,16(sp)
    80001344:	e45e                	sd	s7,8(sp)
    80001346:	0880                	addi	s0,sp,80
    80001348:	8aaa                	mv	s5,a0
    8000134a:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    8000134c:	777d                	lui	a4,0xfffff
    8000134e:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001352:	167d                	addi	a2,a2,-1
    80001354:	00b609b3          	add	s3,a2,a1
    80001358:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000135c:	893e                	mv	s2,a5
    8000135e:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    80001362:	6b85                	lui	s7,0x1
    80001364:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001368:	4605                	li	a2,1
    8000136a:	85ca                	mv	a1,s2
    8000136c:	8556                	mv	a0,s5
    8000136e:	00000097          	auipc	ra,0x0
    80001372:	df0080e7          	jalr	-528(ra) # 8000115e <walk>
    80001376:	c51d                	beqz	a0,800013a4 <mappages+0x72>
    if(*pte & PTE_V)
    80001378:	611c                	ld	a5,0(a0)
    8000137a:	8b85                	andi	a5,a5,1
    8000137c:	ef81                	bnez	a5,80001394 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000137e:	80b1                	srli	s1,s1,0xc
    80001380:	04aa                	slli	s1,s1,0xa
    80001382:	0164e4b3          	or	s1,s1,s6
    80001386:	0014e493          	ori	s1,s1,1
    8000138a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000138c:	03390863          	beq	s2,s3,800013bc <mappages+0x8a>
    a += PGSIZE;
    80001390:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001392:	bfc9                	j	80001364 <mappages+0x32>
      panic("remap");
    80001394:	00007517          	auipc	a0,0x7
    80001398:	f9c50513          	addi	a0,a0,-100 # 80008330 <userret+0x2a0>
    8000139c:	fffff097          	auipc	ra,0xfffff
    800013a0:	1ac080e7          	jalr	428(ra) # 80000548 <panic>
      return -1;
    800013a4:	557d                	li	a0,-1
}
    800013a6:	60a6                	ld	ra,72(sp)
    800013a8:	6406                	ld	s0,64(sp)
    800013aa:	74e2                	ld	s1,56(sp)
    800013ac:	7942                	ld	s2,48(sp)
    800013ae:	79a2                	ld	s3,40(sp)
    800013b0:	7a02                	ld	s4,32(sp)
    800013b2:	6ae2                	ld	s5,24(sp)
    800013b4:	6b42                	ld	s6,16(sp)
    800013b6:	6ba2                	ld	s7,8(sp)
    800013b8:	6161                	addi	sp,sp,80
    800013ba:	8082                	ret
  return 0;
    800013bc:	4501                	li	a0,0
    800013be:	b7e5                	j	800013a6 <mappages+0x74>

00000000800013c0 <kvmmap>:
{
    800013c0:	1141                	addi	sp,sp,-16
    800013c2:	e406                	sd	ra,8(sp)
    800013c4:	e022                	sd	s0,0(sp)
    800013c6:	0800                	addi	s0,sp,16
    800013c8:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800013ca:	86ae                	mv	a3,a1
    800013cc:	85aa                	mv	a1,a0
    800013ce:	0002f517          	auipc	a0,0x2f
    800013d2:	c6253503          	ld	a0,-926(a0) # 80030030 <kernel_pagetable>
    800013d6:	00000097          	auipc	ra,0x0
    800013da:	f5c080e7          	jalr	-164(ra) # 80001332 <mappages>
    800013de:	e509                	bnez	a0,800013e8 <kvmmap+0x28>
}
    800013e0:	60a2                	ld	ra,8(sp)
    800013e2:	6402                	ld	s0,0(sp)
    800013e4:	0141                	addi	sp,sp,16
    800013e6:	8082                	ret
    panic("kvmmap");
    800013e8:	00007517          	auipc	a0,0x7
    800013ec:	f5050513          	addi	a0,a0,-176 # 80008338 <userret+0x2a8>
    800013f0:	fffff097          	auipc	ra,0xfffff
    800013f4:	158080e7          	jalr	344(ra) # 80000548 <panic>

00000000800013f8 <kvminit>:
{
    800013f8:	1101                	addi	sp,sp,-32
    800013fa:	ec06                	sd	ra,24(sp)
    800013fc:	e822                	sd	s0,16(sp)
    800013fe:	e426                	sd	s1,8(sp)
    80001400:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    80001402:	fffff097          	auipc	ra,0xfffff
    80001406:	642080e7          	jalr	1602(ra) # 80000a44 <kalloc>
    8000140a:	0002f797          	auipc	a5,0x2f
    8000140e:	c2a7b323          	sd	a0,-986(a5) # 80030030 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    80001412:	6605                	lui	a2,0x1
    80001414:	4581                	li	a1,0
    80001416:	00000097          	auipc	ra,0x0
    8000141a:	a82080e7          	jalr	-1406(ra) # 80000e98 <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000141e:	4699                	li	a3,6
    80001420:	6605                	lui	a2,0x1
    80001422:	100005b7          	lui	a1,0x10000
    80001426:	10000537          	lui	a0,0x10000
    8000142a:	00000097          	auipc	ra,0x0
    8000142e:	f96080e7          	jalr	-106(ra) # 800013c0 <kvmmap>
  kvmmap(VIRTION(0), VIRTION(0), PGSIZE, PTE_R | PTE_W);
    80001432:	4699                	li	a3,6
    80001434:	6605                	lui	a2,0x1
    80001436:	100015b7          	lui	a1,0x10001
    8000143a:	10001537          	lui	a0,0x10001
    8000143e:	00000097          	auipc	ra,0x0
    80001442:	f82080e7          	jalr	-126(ra) # 800013c0 <kvmmap>
  kvmmap(VIRTION(1), VIRTION(1), PGSIZE, PTE_R | PTE_W);
    80001446:	4699                	li	a3,6
    80001448:	6605                	lui	a2,0x1
    8000144a:	100025b7          	lui	a1,0x10002
    8000144e:	10002537          	lui	a0,0x10002
    80001452:	00000097          	auipc	ra,0x0
    80001456:	f6e080e7          	jalr	-146(ra) # 800013c0 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    8000145a:	4699                	li	a3,6
    8000145c:	6641                	lui	a2,0x10
    8000145e:	020005b7          	lui	a1,0x2000
    80001462:	02000537          	lui	a0,0x2000
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	f5a080e7          	jalr	-166(ra) # 800013c0 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000146e:	4699                	li	a3,6
    80001470:	00400637          	lui	a2,0x400
    80001474:	0c0005b7          	lui	a1,0xc000
    80001478:	0c000537          	lui	a0,0xc000
    8000147c:	00000097          	auipc	ra,0x0
    80001480:	f44080e7          	jalr	-188(ra) # 800013c0 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001484:	00008497          	auipc	s1,0x8
    80001488:	b7c48493          	addi	s1,s1,-1156 # 80009000 <initcode>
    8000148c:	46a9                	li	a3,10
    8000148e:	80008617          	auipc	a2,0x80008
    80001492:	b7260613          	addi	a2,a2,-1166 # 9000 <_entry-0x7fff7000>
    80001496:	4585                	li	a1,1
    80001498:	05fe                	slli	a1,a1,0x1f
    8000149a:	852e                	mv	a0,a1
    8000149c:	00000097          	auipc	ra,0x0
    800014a0:	f24080e7          	jalr	-220(ra) # 800013c0 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800014a4:	4699                	li	a3,6
    800014a6:	4645                	li	a2,17
    800014a8:	066e                	slli	a2,a2,0x1b
    800014aa:	8e05                	sub	a2,a2,s1
    800014ac:	85a6                	mv	a1,s1
    800014ae:	8526                	mv	a0,s1
    800014b0:	00000097          	auipc	ra,0x0
    800014b4:	f10080e7          	jalr	-240(ra) # 800013c0 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800014b8:	46a9                	li	a3,10
    800014ba:	6605                	lui	a2,0x1
    800014bc:	00007597          	auipc	a1,0x7
    800014c0:	b4458593          	addi	a1,a1,-1212 # 80008000 <trampoline>
    800014c4:	04000537          	lui	a0,0x4000
    800014c8:	157d                	addi	a0,a0,-1
    800014ca:	0532                	slli	a0,a0,0xc
    800014cc:	00000097          	auipc	ra,0x0
    800014d0:	ef4080e7          	jalr	-268(ra) # 800013c0 <kvmmap>
}
    800014d4:	60e2                	ld	ra,24(sp)
    800014d6:	6442                	ld	s0,16(sp)
    800014d8:	64a2                	ld	s1,8(sp)
    800014da:	6105                	addi	sp,sp,32
    800014dc:	8082                	ret

00000000800014de <uvmunmap>:
{
    800014de:	715d                	addi	sp,sp,-80
    800014e0:	e486                	sd	ra,72(sp)
    800014e2:	e0a2                	sd	s0,64(sp)
    800014e4:	fc26                	sd	s1,56(sp)
    800014e6:	f84a                	sd	s2,48(sp)
    800014e8:	f44e                	sd	s3,40(sp)
    800014ea:	f052                	sd	s4,32(sp)
    800014ec:	ec56                	sd	s5,24(sp)
    800014ee:	e85a                	sd	s6,16(sp)
    800014f0:	e45e                	sd	s7,8(sp)
    800014f2:	0880                	addi	s0,sp,80
    800014f4:	8a2a                	mv	s4,a0
    800014f6:	8ab6                	mv	s5,a3
  a = PGROUNDDOWN(va);
    800014f8:	77fd                	lui	a5,0xfffff
    800014fa:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800014fe:	167d                	addi	a2,a2,-1
    80001500:	00b609b3          	add	s3,a2,a1
    80001504:	00f9f9b3          	and	s3,s3,a5
    if(PTE_FLAGS(*pte) == PTE_V)
    80001508:	4b05                	li	s6,1
    a += PGSIZE;
    8000150a:	6b85                	lui	s7,0x1
    8000150c:	a0b9                	j	8000155a <uvmunmap+0x7c>
      panic("uvmunmap: walk");
    8000150e:	00007517          	auipc	a0,0x7
    80001512:	e3250513          	addi	a0,a0,-462 # 80008340 <userret+0x2b0>
    80001516:	fffff097          	auipc	ra,0xfffff
    8000151a:	032080e7          	jalr	50(ra) # 80000548 <panic>
      printf("va=%p pte=%p\n", a, *pte);
    8000151e:	85ca                	mv	a1,s2
    80001520:	00007517          	auipc	a0,0x7
    80001524:	e3050513          	addi	a0,a0,-464 # 80008350 <userret+0x2c0>
    80001528:	fffff097          	auipc	ra,0xfffff
    8000152c:	07a080e7          	jalr	122(ra) # 800005a2 <printf>
      panic("uvmunmap: not mapped");
    80001530:	00007517          	auipc	a0,0x7
    80001534:	e3050513          	addi	a0,a0,-464 # 80008360 <userret+0x2d0>
    80001538:	fffff097          	auipc	ra,0xfffff
    8000153c:	010080e7          	jalr	16(ra) # 80000548 <panic>
      panic("uvmunmap: not a leaf");
    80001540:	00007517          	auipc	a0,0x7
    80001544:	e3850513          	addi	a0,a0,-456 # 80008378 <userret+0x2e8>
    80001548:	fffff097          	auipc	ra,0xfffff
    8000154c:	000080e7          	jalr	ra # 80000548 <panic>
    *pte = 0;
    80001550:	0004b023          	sd	zero,0(s1)
    if(a == last)
    80001554:	03390e63          	beq	s2,s3,80001590 <uvmunmap+0xb2>
    a += PGSIZE;
    80001558:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 0)) == 0)
    8000155a:	4601                	li	a2,0
    8000155c:	85ca                	mv	a1,s2
    8000155e:	8552                	mv	a0,s4
    80001560:	00000097          	auipc	ra,0x0
    80001564:	bfe080e7          	jalr	-1026(ra) # 8000115e <walk>
    80001568:	84aa                	mv	s1,a0
    8000156a:	d155                	beqz	a0,8000150e <uvmunmap+0x30>
    if((*pte & PTE_V) == 0){
    8000156c:	6110                	ld	a2,0(a0)
    8000156e:	00167793          	andi	a5,a2,1
    80001572:	d7d5                	beqz	a5,8000151e <uvmunmap+0x40>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001574:	3ff67793          	andi	a5,a2,1023
    80001578:	fd6784e3          	beq	a5,s6,80001540 <uvmunmap+0x62>
    if(do_free){
    8000157c:	fc0a8ae3          	beqz	s5,80001550 <uvmunmap+0x72>
      pa = PTE2PA(*pte);
    80001580:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    80001582:	00c61513          	slli	a0,a2,0xc
    80001586:	fffff097          	auipc	ra,0xfffff
    8000158a:	2de080e7          	jalr	734(ra) # 80000864 <kfree>
    8000158e:	b7c9                	j	80001550 <uvmunmap+0x72>
}
    80001590:	60a6                	ld	ra,72(sp)
    80001592:	6406                	ld	s0,64(sp)
    80001594:	74e2                	ld	s1,56(sp)
    80001596:	7942                	ld	s2,48(sp)
    80001598:	79a2                	ld	s3,40(sp)
    8000159a:	7a02                	ld	s4,32(sp)
    8000159c:	6ae2                	ld	s5,24(sp)
    8000159e:	6b42                	ld	s6,16(sp)
    800015a0:	6ba2                	ld	s7,8(sp)
    800015a2:	6161                	addi	sp,sp,80
    800015a4:	8082                	ret

00000000800015a6 <uvmcreate>:
{
    800015a6:	1101                	addi	sp,sp,-32
    800015a8:	ec06                	sd	ra,24(sp)
    800015aa:	e822                	sd	s0,16(sp)
    800015ac:	e426                	sd	s1,8(sp)
    800015ae:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    800015b0:	fffff097          	auipc	ra,0xfffff
    800015b4:	494080e7          	jalr	1172(ra) # 80000a44 <kalloc>
  if(pagetable == 0)
    800015b8:	cd11                	beqz	a0,800015d4 <uvmcreate+0x2e>
    800015ba:	84aa                	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
    800015bc:	6605                	lui	a2,0x1
    800015be:	4581                	li	a1,0
    800015c0:	00000097          	auipc	ra,0x0
    800015c4:	8d8080e7          	jalr	-1832(ra) # 80000e98 <memset>
}
    800015c8:	8526                	mv	a0,s1
    800015ca:	60e2                	ld	ra,24(sp)
    800015cc:	6442                	ld	s0,16(sp)
    800015ce:	64a2                	ld	s1,8(sp)
    800015d0:	6105                	addi	sp,sp,32
    800015d2:	8082                	ret
    panic("uvmcreate: out of memory");
    800015d4:	00007517          	auipc	a0,0x7
    800015d8:	dbc50513          	addi	a0,a0,-580 # 80008390 <userret+0x300>
    800015dc:	fffff097          	auipc	ra,0xfffff
    800015e0:	f6c080e7          	jalr	-148(ra) # 80000548 <panic>

00000000800015e4 <uvminit>:
{
    800015e4:	7179                	addi	sp,sp,-48
    800015e6:	f406                	sd	ra,40(sp)
    800015e8:	f022                	sd	s0,32(sp)
    800015ea:	ec26                	sd	s1,24(sp)
    800015ec:	e84a                	sd	s2,16(sp)
    800015ee:	e44e                	sd	s3,8(sp)
    800015f0:	e052                	sd	s4,0(sp)
    800015f2:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    800015f4:	6785                	lui	a5,0x1
    800015f6:	04f67863          	bgeu	a2,a5,80001646 <uvminit+0x62>
    800015fa:	8a2a                	mv	s4,a0
    800015fc:	89ae                	mv	s3,a1
    800015fe:	84b2                	mv	s1,a2
  mem = kalloc();
    80001600:	fffff097          	auipc	ra,0xfffff
    80001604:	444080e7          	jalr	1092(ra) # 80000a44 <kalloc>
    80001608:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000160a:	6605                	lui	a2,0x1
    8000160c:	4581                	li	a1,0
    8000160e:	00000097          	auipc	ra,0x0
    80001612:	88a080e7          	jalr	-1910(ra) # 80000e98 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001616:	4779                	li	a4,30
    80001618:	86ca                	mv	a3,s2
    8000161a:	6605                	lui	a2,0x1
    8000161c:	4581                	li	a1,0
    8000161e:	8552                	mv	a0,s4
    80001620:	00000097          	auipc	ra,0x0
    80001624:	d12080e7          	jalr	-750(ra) # 80001332 <mappages>
  memmove(mem, src, sz);
    80001628:	8626                	mv	a2,s1
    8000162a:	85ce                	mv	a1,s3
    8000162c:	854a                	mv	a0,s2
    8000162e:	00000097          	auipc	ra,0x0
    80001632:	8c6080e7          	jalr	-1850(ra) # 80000ef4 <memmove>
}
    80001636:	70a2                	ld	ra,40(sp)
    80001638:	7402                	ld	s0,32(sp)
    8000163a:	64e2                	ld	s1,24(sp)
    8000163c:	6942                	ld	s2,16(sp)
    8000163e:	69a2                	ld	s3,8(sp)
    80001640:	6a02                	ld	s4,0(sp)
    80001642:	6145                	addi	sp,sp,48
    80001644:	8082                	ret
    panic("inituvm: more than a page");
    80001646:	00007517          	auipc	a0,0x7
    8000164a:	d6a50513          	addi	a0,a0,-662 # 800083b0 <userret+0x320>
    8000164e:	fffff097          	auipc	ra,0xfffff
    80001652:	efa080e7          	jalr	-262(ra) # 80000548 <panic>

0000000080001656 <uvmdealloc>:
{
    80001656:	1101                	addi	sp,sp,-32
    80001658:	ec06                	sd	ra,24(sp)
    8000165a:	e822                	sd	s0,16(sp)
    8000165c:	e426                	sd	s1,8(sp)
    8000165e:	1000                	addi	s0,sp,32
    return oldsz;
    80001660:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001662:	00b67d63          	bgeu	a2,a1,8000167c <uvmdealloc+0x26>
    80001666:	84b2                	mv	s1,a2
  uint64 newup = PGROUNDUP(newsz);
    80001668:	6785                	lui	a5,0x1
    8000166a:	17fd                	addi	a5,a5,-1
    8000166c:	00f60733          	add	a4,a2,a5
    80001670:	76fd                	lui	a3,0xfffff
    80001672:	8f75                	and	a4,a4,a3
  if(newup < PGROUNDUP(oldsz))
    80001674:	97ae                	add	a5,a5,a1
    80001676:	8ff5                	and	a5,a5,a3
    80001678:	00f76863          	bltu	a4,a5,80001688 <uvmdealloc+0x32>
}
    8000167c:	8526                	mv	a0,s1
    8000167e:	60e2                	ld	ra,24(sp)
    80001680:	6442                	ld	s0,16(sp)
    80001682:	64a2                	ld	s1,8(sp)
    80001684:	6105                	addi	sp,sp,32
    80001686:	8082                	ret
    uvmunmap(pagetable, newup, oldsz - newup, 1);
    80001688:	4685                	li	a3,1
    8000168a:	40e58633          	sub	a2,a1,a4
    8000168e:	85ba                	mv	a1,a4
    80001690:	00000097          	auipc	ra,0x0
    80001694:	e4e080e7          	jalr	-434(ra) # 800014de <uvmunmap>
    80001698:	b7d5                	j	8000167c <uvmdealloc+0x26>

000000008000169a <uvmalloc>:
  if(newsz < oldsz)
    8000169a:	0ab66163          	bltu	a2,a1,8000173c <uvmalloc+0xa2>
{
    8000169e:	7139                	addi	sp,sp,-64
    800016a0:	fc06                	sd	ra,56(sp)
    800016a2:	f822                	sd	s0,48(sp)
    800016a4:	f426                	sd	s1,40(sp)
    800016a6:	f04a                	sd	s2,32(sp)
    800016a8:	ec4e                	sd	s3,24(sp)
    800016aa:	e852                	sd	s4,16(sp)
    800016ac:	e456                	sd	s5,8(sp)
    800016ae:	0080                	addi	s0,sp,64
    800016b0:	8aaa                	mv	s5,a0
    800016b2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800016b4:	6985                	lui	s3,0x1
    800016b6:	19fd                	addi	s3,s3,-1
    800016b8:	95ce                	add	a1,a1,s3
    800016ba:	79fd                	lui	s3,0xfffff
    800016bc:	0135f9b3          	and	s3,a1,s3
  for(; a < newsz; a += PGSIZE){
    800016c0:	08c9f063          	bgeu	s3,a2,80001740 <uvmalloc+0xa6>
  a = oldsz;
    800016c4:	894e                	mv	s2,s3
    mem = kalloc();
    800016c6:	fffff097          	auipc	ra,0xfffff
    800016ca:	37e080e7          	jalr	894(ra) # 80000a44 <kalloc>
    800016ce:	84aa                	mv	s1,a0
    if(mem == 0){
    800016d0:	c51d                	beqz	a0,800016fe <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800016d2:	6605                	lui	a2,0x1
    800016d4:	4581                	li	a1,0
    800016d6:	fffff097          	auipc	ra,0xfffff
    800016da:	7c2080e7          	jalr	1986(ra) # 80000e98 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800016de:	4779                	li	a4,30
    800016e0:	86a6                	mv	a3,s1
    800016e2:	6605                	lui	a2,0x1
    800016e4:	85ca                	mv	a1,s2
    800016e6:	8556                	mv	a0,s5
    800016e8:	00000097          	auipc	ra,0x0
    800016ec:	c4a080e7          	jalr	-950(ra) # 80001332 <mappages>
    800016f0:	e905                	bnez	a0,80001720 <uvmalloc+0x86>
  for(; a < newsz; a += PGSIZE){
    800016f2:	6785                	lui	a5,0x1
    800016f4:	993e                	add	s2,s2,a5
    800016f6:	fd4968e3          	bltu	s2,s4,800016c6 <uvmalloc+0x2c>
  return newsz;
    800016fa:	8552                	mv	a0,s4
    800016fc:	a809                	j	8000170e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800016fe:	864e                	mv	a2,s3
    80001700:	85ca                	mv	a1,s2
    80001702:	8556                	mv	a0,s5
    80001704:	00000097          	auipc	ra,0x0
    80001708:	f52080e7          	jalr	-174(ra) # 80001656 <uvmdealloc>
      return 0;
    8000170c:	4501                	li	a0,0
}
    8000170e:	70e2                	ld	ra,56(sp)
    80001710:	7442                	ld	s0,48(sp)
    80001712:	74a2                	ld	s1,40(sp)
    80001714:	7902                	ld	s2,32(sp)
    80001716:	69e2                	ld	s3,24(sp)
    80001718:	6a42                	ld	s4,16(sp)
    8000171a:	6aa2                	ld	s5,8(sp)
    8000171c:	6121                	addi	sp,sp,64
    8000171e:	8082                	ret
      kfree(mem);
    80001720:	8526                	mv	a0,s1
    80001722:	fffff097          	auipc	ra,0xfffff
    80001726:	142080e7          	jalr	322(ra) # 80000864 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000172a:	864e                	mv	a2,s3
    8000172c:	85ca                	mv	a1,s2
    8000172e:	8556                	mv	a0,s5
    80001730:	00000097          	auipc	ra,0x0
    80001734:	f26080e7          	jalr	-218(ra) # 80001656 <uvmdealloc>
      return 0;
    80001738:	4501                	li	a0,0
    8000173a:	bfd1                	j	8000170e <uvmalloc+0x74>
    return oldsz;
    8000173c:	852e                	mv	a0,a1
}
    8000173e:	8082                	ret
  return newsz;
    80001740:	8532                	mv	a0,a2
    80001742:	b7f1                	j	8000170e <uvmalloc+0x74>

0000000080001744 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001744:	1101                	addi	sp,sp,-32
    80001746:	ec06                	sd	ra,24(sp)
    80001748:	e822                	sd	s0,16(sp)
    8000174a:	e426                	sd	s1,8(sp)
    8000174c:	1000                	addi	s0,sp,32
    8000174e:	84aa                	mv	s1,a0
    80001750:	862e                	mv	a2,a1
  uvmunmap(pagetable, 0, sz, 1);
    80001752:	4685                	li	a3,1
    80001754:	4581                	li	a1,0
    80001756:	00000097          	auipc	ra,0x0
    8000175a:	d88080e7          	jalr	-632(ra) # 800014de <uvmunmap>
  freewalk(pagetable);
    8000175e:	8526                	mv	a0,s1
    80001760:	00000097          	auipc	ra,0x0
    80001764:	aa4080e7          	jalr	-1372(ra) # 80001204 <freewalk>
}
    80001768:	60e2                	ld	ra,24(sp)
    8000176a:	6442                	ld	s0,16(sp)
    8000176c:	64a2                	ld	s1,8(sp)
    8000176e:	6105                	addi	sp,sp,32
    80001770:	8082                	ret

0000000080001772 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001772:	c671                	beqz	a2,8000183e <uvmcopy+0xcc>
{
    80001774:	715d                	addi	sp,sp,-80
    80001776:	e486                	sd	ra,72(sp)
    80001778:	e0a2                	sd	s0,64(sp)
    8000177a:	fc26                	sd	s1,56(sp)
    8000177c:	f84a                	sd	s2,48(sp)
    8000177e:	f44e                	sd	s3,40(sp)
    80001780:	f052                	sd	s4,32(sp)
    80001782:	ec56                	sd	s5,24(sp)
    80001784:	e85a                	sd	s6,16(sp)
    80001786:	e45e                	sd	s7,8(sp)
    80001788:	0880                	addi	s0,sp,80
    8000178a:	8b2a                	mv	s6,a0
    8000178c:	8aae                	mv	s5,a1
    8000178e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001790:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001792:	4601                	li	a2,0
    80001794:	85ce                	mv	a1,s3
    80001796:	855a                	mv	a0,s6
    80001798:	00000097          	auipc	ra,0x0
    8000179c:	9c6080e7          	jalr	-1594(ra) # 8000115e <walk>
    800017a0:	c531                	beqz	a0,800017ec <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800017a2:	6118                	ld	a4,0(a0)
    800017a4:	00177793          	andi	a5,a4,1
    800017a8:	cbb1                	beqz	a5,800017fc <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800017aa:	00a75593          	srli	a1,a4,0xa
    800017ae:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800017b2:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800017b6:	fffff097          	auipc	ra,0xfffff
    800017ba:	28e080e7          	jalr	654(ra) # 80000a44 <kalloc>
    800017be:	892a                	mv	s2,a0
    800017c0:	c939                	beqz	a0,80001816 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800017c2:	6605                	lui	a2,0x1
    800017c4:	85de                	mv	a1,s7
    800017c6:	fffff097          	auipc	ra,0xfffff
    800017ca:	72e080e7          	jalr	1838(ra) # 80000ef4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800017ce:	8726                	mv	a4,s1
    800017d0:	86ca                	mv	a3,s2
    800017d2:	6605                	lui	a2,0x1
    800017d4:	85ce                	mv	a1,s3
    800017d6:	8556                	mv	a0,s5
    800017d8:	00000097          	auipc	ra,0x0
    800017dc:	b5a080e7          	jalr	-1190(ra) # 80001332 <mappages>
    800017e0:	e515                	bnez	a0,8000180c <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800017e2:	6785                	lui	a5,0x1
    800017e4:	99be                	add	s3,s3,a5
    800017e6:	fb49e6e3          	bltu	s3,s4,80001792 <uvmcopy+0x20>
    800017ea:	a83d                	j	80001828 <uvmcopy+0xb6>
      panic("uvmcopy: pte should exist");
    800017ec:	00007517          	auipc	a0,0x7
    800017f0:	be450513          	addi	a0,a0,-1052 # 800083d0 <userret+0x340>
    800017f4:	fffff097          	auipc	ra,0xfffff
    800017f8:	d54080e7          	jalr	-684(ra) # 80000548 <panic>
      panic("uvmcopy: page not present");
    800017fc:	00007517          	auipc	a0,0x7
    80001800:	bf450513          	addi	a0,a0,-1036 # 800083f0 <userret+0x360>
    80001804:	fffff097          	auipc	ra,0xfffff
    80001808:	d44080e7          	jalr	-700(ra) # 80000548 <panic>
      kfree(mem);
    8000180c:	854a                	mv	a0,s2
    8000180e:	fffff097          	auipc	ra,0xfffff
    80001812:	056080e7          	jalr	86(ra) # 80000864 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
    80001816:	4685                	li	a3,1
    80001818:	864e                	mv	a2,s3
    8000181a:	4581                	li	a1,0
    8000181c:	8556                	mv	a0,s5
    8000181e:	00000097          	auipc	ra,0x0
    80001822:	cc0080e7          	jalr	-832(ra) # 800014de <uvmunmap>
  return -1;
    80001826:	557d                	li	a0,-1
}
    80001828:	60a6                	ld	ra,72(sp)
    8000182a:	6406                	ld	s0,64(sp)
    8000182c:	74e2                	ld	s1,56(sp)
    8000182e:	7942                	ld	s2,48(sp)
    80001830:	79a2                	ld	s3,40(sp)
    80001832:	7a02                	ld	s4,32(sp)
    80001834:	6ae2                	ld	s5,24(sp)
    80001836:	6b42                	ld	s6,16(sp)
    80001838:	6ba2                	ld	s7,8(sp)
    8000183a:	6161                	addi	sp,sp,80
    8000183c:	8082                	ret
  return 0;
    8000183e:	4501                	li	a0,0
}
    80001840:	8082                	ret

0000000080001842 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001842:	1141                	addi	sp,sp,-16
    80001844:	e406                	sd	ra,8(sp)
    80001846:	e022                	sd	s0,0(sp)
    80001848:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000184a:	4601                	li	a2,0
    8000184c:	00000097          	auipc	ra,0x0
    80001850:	912080e7          	jalr	-1774(ra) # 8000115e <walk>
  if(pte == 0)
    80001854:	c901                	beqz	a0,80001864 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001856:	611c                	ld	a5,0(a0)
    80001858:	9bbd                	andi	a5,a5,-17
    8000185a:	e11c                	sd	a5,0(a0)
}
    8000185c:	60a2                	ld	ra,8(sp)
    8000185e:	6402                	ld	s0,0(sp)
    80001860:	0141                	addi	sp,sp,16
    80001862:	8082                	ret
    panic("uvmclear");
    80001864:	00007517          	auipc	a0,0x7
    80001868:	bac50513          	addi	a0,a0,-1108 # 80008410 <userret+0x380>
    8000186c:	fffff097          	auipc	ra,0xfffff
    80001870:	cdc080e7          	jalr	-804(ra) # 80000548 <panic>

0000000080001874 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001874:	c6bd                	beqz	a3,800018e2 <copyout+0x6e>
{
    80001876:	715d                	addi	sp,sp,-80
    80001878:	e486                	sd	ra,72(sp)
    8000187a:	e0a2                	sd	s0,64(sp)
    8000187c:	fc26                	sd	s1,56(sp)
    8000187e:	f84a                	sd	s2,48(sp)
    80001880:	f44e                	sd	s3,40(sp)
    80001882:	f052                	sd	s4,32(sp)
    80001884:	ec56                	sd	s5,24(sp)
    80001886:	e85a                	sd	s6,16(sp)
    80001888:	e45e                	sd	s7,8(sp)
    8000188a:	e062                	sd	s8,0(sp)
    8000188c:	0880                	addi	s0,sp,80
    8000188e:	8b2a                	mv	s6,a0
    80001890:	8c2e                	mv	s8,a1
    80001892:	8a32                	mv	s4,a2
    80001894:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001896:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001898:	6a85                	lui	s5,0x1
    8000189a:	a015                	j	800018be <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000189c:	9562                	add	a0,a0,s8
    8000189e:	0004861b          	sext.w	a2,s1
    800018a2:	85d2                	mv	a1,s4
    800018a4:	41250533          	sub	a0,a0,s2
    800018a8:	fffff097          	auipc	ra,0xfffff
    800018ac:	64c080e7          	jalr	1612(ra) # 80000ef4 <memmove>

    len -= n;
    800018b0:	409989b3          	sub	s3,s3,s1
    src += n;
    800018b4:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800018b6:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800018ba:	02098263          	beqz	s3,800018de <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800018be:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800018c2:	85ca                	mv	a1,s2
    800018c4:	855a                	mv	a0,s6
    800018c6:	00000097          	auipc	ra,0x0
    800018ca:	9cc080e7          	jalr	-1588(ra) # 80001292 <walkaddr>
    if(pa0 == 0)
    800018ce:	cd01                	beqz	a0,800018e6 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800018d0:	418904b3          	sub	s1,s2,s8
    800018d4:	94d6                	add	s1,s1,s5
    if(n > len)
    800018d6:	fc99f3e3          	bgeu	s3,s1,8000189c <copyout+0x28>
    800018da:	84ce                	mv	s1,s3
    800018dc:	b7c1                	j	8000189c <copyout+0x28>
  }
  return 0;
    800018de:	4501                	li	a0,0
    800018e0:	a021                	j	800018e8 <copyout+0x74>
    800018e2:	4501                	li	a0,0
}
    800018e4:	8082                	ret
      return -1;
    800018e6:	557d                	li	a0,-1
}
    800018e8:	60a6                	ld	ra,72(sp)
    800018ea:	6406                	ld	s0,64(sp)
    800018ec:	74e2                	ld	s1,56(sp)
    800018ee:	7942                	ld	s2,48(sp)
    800018f0:	79a2                	ld	s3,40(sp)
    800018f2:	7a02                	ld	s4,32(sp)
    800018f4:	6ae2                	ld	s5,24(sp)
    800018f6:	6b42                	ld	s6,16(sp)
    800018f8:	6ba2                	ld	s7,8(sp)
    800018fa:	6c02                	ld	s8,0(sp)
    800018fc:	6161                	addi	sp,sp,80
    800018fe:	8082                	ret

0000000080001900 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001900:	caa5                	beqz	a3,80001970 <copyin+0x70>
{
    80001902:	715d                	addi	sp,sp,-80
    80001904:	e486                	sd	ra,72(sp)
    80001906:	e0a2                	sd	s0,64(sp)
    80001908:	fc26                	sd	s1,56(sp)
    8000190a:	f84a                	sd	s2,48(sp)
    8000190c:	f44e                	sd	s3,40(sp)
    8000190e:	f052                	sd	s4,32(sp)
    80001910:	ec56                	sd	s5,24(sp)
    80001912:	e85a                	sd	s6,16(sp)
    80001914:	e45e                	sd	s7,8(sp)
    80001916:	e062                	sd	s8,0(sp)
    80001918:	0880                	addi	s0,sp,80
    8000191a:	8b2a                	mv	s6,a0
    8000191c:	8a2e                	mv	s4,a1
    8000191e:	8c32                	mv	s8,a2
    80001920:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001922:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001924:	6a85                	lui	s5,0x1
    80001926:	a01d                	j	8000194c <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001928:	018505b3          	add	a1,a0,s8
    8000192c:	0004861b          	sext.w	a2,s1
    80001930:	412585b3          	sub	a1,a1,s2
    80001934:	8552                	mv	a0,s4
    80001936:	fffff097          	auipc	ra,0xfffff
    8000193a:	5be080e7          	jalr	1470(ra) # 80000ef4 <memmove>

    len -= n;
    8000193e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001942:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001944:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001948:	02098263          	beqz	s3,8000196c <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    8000194c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001950:	85ca                	mv	a1,s2
    80001952:	855a                	mv	a0,s6
    80001954:	00000097          	auipc	ra,0x0
    80001958:	93e080e7          	jalr	-1730(ra) # 80001292 <walkaddr>
    if(pa0 == 0)
    8000195c:	cd01                	beqz	a0,80001974 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    8000195e:	418904b3          	sub	s1,s2,s8
    80001962:	94d6                	add	s1,s1,s5
    if(n > len)
    80001964:	fc99f2e3          	bgeu	s3,s1,80001928 <copyin+0x28>
    80001968:	84ce                	mv	s1,s3
    8000196a:	bf7d                	j	80001928 <copyin+0x28>
  }
  return 0;
    8000196c:	4501                	li	a0,0
    8000196e:	a021                	j	80001976 <copyin+0x76>
    80001970:	4501                	li	a0,0
}
    80001972:	8082                	ret
      return -1;
    80001974:	557d                	li	a0,-1
}
    80001976:	60a6                	ld	ra,72(sp)
    80001978:	6406                	ld	s0,64(sp)
    8000197a:	74e2                	ld	s1,56(sp)
    8000197c:	7942                	ld	s2,48(sp)
    8000197e:	79a2                	ld	s3,40(sp)
    80001980:	7a02                	ld	s4,32(sp)
    80001982:	6ae2                	ld	s5,24(sp)
    80001984:	6b42                	ld	s6,16(sp)
    80001986:	6ba2                	ld	s7,8(sp)
    80001988:	6c02                	ld	s8,0(sp)
    8000198a:	6161                	addi	sp,sp,80
    8000198c:	8082                	ret

000000008000198e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000198e:	c6c5                	beqz	a3,80001a36 <copyinstr+0xa8>
{
    80001990:	715d                	addi	sp,sp,-80
    80001992:	e486                	sd	ra,72(sp)
    80001994:	e0a2                	sd	s0,64(sp)
    80001996:	fc26                	sd	s1,56(sp)
    80001998:	f84a                	sd	s2,48(sp)
    8000199a:	f44e                	sd	s3,40(sp)
    8000199c:	f052                	sd	s4,32(sp)
    8000199e:	ec56                	sd	s5,24(sp)
    800019a0:	e85a                	sd	s6,16(sp)
    800019a2:	e45e                	sd	s7,8(sp)
    800019a4:	0880                	addi	s0,sp,80
    800019a6:	8a2a                	mv	s4,a0
    800019a8:	8b2e                	mv	s6,a1
    800019aa:	8bb2                	mv	s7,a2
    800019ac:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800019ae:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800019b0:	6985                	lui	s3,0x1
    800019b2:	a035                	j	800019de <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800019b4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800019b8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800019ba:	0017b793          	seqz	a5,a5
    800019be:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800019c2:	60a6                	ld	ra,72(sp)
    800019c4:	6406                	ld	s0,64(sp)
    800019c6:	74e2                	ld	s1,56(sp)
    800019c8:	7942                	ld	s2,48(sp)
    800019ca:	79a2                	ld	s3,40(sp)
    800019cc:	7a02                	ld	s4,32(sp)
    800019ce:	6ae2                	ld	s5,24(sp)
    800019d0:	6b42                	ld	s6,16(sp)
    800019d2:	6ba2                	ld	s7,8(sp)
    800019d4:	6161                	addi	sp,sp,80
    800019d6:	8082                	ret
    srcva = va0 + PGSIZE;
    800019d8:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800019dc:	c8a9                	beqz	s1,80001a2e <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800019de:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800019e2:	85ca                	mv	a1,s2
    800019e4:	8552                	mv	a0,s4
    800019e6:	00000097          	auipc	ra,0x0
    800019ea:	8ac080e7          	jalr	-1876(ra) # 80001292 <walkaddr>
    if(pa0 == 0)
    800019ee:	c131                	beqz	a0,80001a32 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800019f0:	41790833          	sub	a6,s2,s7
    800019f4:	984e                	add	a6,a6,s3
    if(n > max)
    800019f6:	0104f363          	bgeu	s1,a6,800019fc <copyinstr+0x6e>
    800019fa:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800019fc:	955e                	add	a0,a0,s7
    800019fe:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001a02:	fc080be3          	beqz	a6,800019d8 <copyinstr+0x4a>
    80001a06:	985a                	add	a6,a6,s6
    80001a08:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001a0a:	41650633          	sub	a2,a0,s6
    80001a0e:	14fd                	addi	s1,s1,-1
    80001a10:	9b26                	add	s6,s6,s1
    80001a12:	00f60733          	add	a4,a2,a5
    80001a16:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffcefa4>
    80001a1a:	df49                	beqz	a4,800019b4 <copyinstr+0x26>
        *dst = *p;
    80001a1c:	00e78023          	sb	a4,0(a5)
      --max;
    80001a20:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001a24:	0785                	addi	a5,a5,1
    while(n > 0){
    80001a26:	ff0796e3          	bne	a5,a6,80001a12 <copyinstr+0x84>
      dst++;
    80001a2a:	8b42                	mv	s6,a6
    80001a2c:	b775                	j	800019d8 <copyinstr+0x4a>
    80001a2e:	4781                	li	a5,0
    80001a30:	b769                	j	800019ba <copyinstr+0x2c>
      return -1;
    80001a32:	557d                	li	a0,-1
    80001a34:	b779                	j	800019c2 <copyinstr+0x34>
  int got_null = 0;
    80001a36:	4781                	li	a5,0
  if(got_null){
    80001a38:	0017b793          	seqz	a5,a5
    80001a3c:	40f00533          	neg	a0,a5
}
    80001a40:	8082                	ret

0000000080001a42 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    80001a42:	1101                	addi	sp,sp,-32
    80001a44:	ec06                	sd	ra,24(sp)
    80001a46:	e822                	sd	s0,16(sp)
    80001a48:	e426                	sd	s1,8(sp)
    80001a4a:	1000                	addi	s0,sp,32
    80001a4c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001a4e:	fffff097          	auipc	ra,0xfffff
    80001a52:	19c080e7          	jalr	412(ra) # 80000bea <holding>
    80001a56:	c909                	beqz	a0,80001a68 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001a58:	789c                	ld	a5,48(s1)
    80001a5a:	00978f63          	beq	a5,s1,80001a78 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001a5e:	60e2                	ld	ra,24(sp)
    80001a60:	6442                	ld	s0,16(sp)
    80001a62:	64a2                	ld	s1,8(sp)
    80001a64:	6105                	addi	sp,sp,32
    80001a66:	8082                	ret
    panic("wakeup1");
    80001a68:	00007517          	auipc	a0,0x7
    80001a6c:	9b850513          	addi	a0,a0,-1608 # 80008420 <userret+0x390>
    80001a70:	fffff097          	auipc	ra,0xfffff
    80001a74:	ad8080e7          	jalr	-1320(ra) # 80000548 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001a78:	5098                	lw	a4,32(s1)
    80001a7a:	4785                	li	a5,1
    80001a7c:	fef711e3          	bne	a4,a5,80001a5e <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001a80:	4789                	li	a5,2
    80001a82:	d09c                	sw	a5,32(s1)
}
    80001a84:	bfe9                	j	80001a5e <wakeup1+0x1c>

0000000080001a86 <procinit>:
{
    80001a86:	715d                	addi	sp,sp,-80
    80001a88:	e486                	sd	ra,72(sp)
    80001a8a:	e0a2                	sd	s0,64(sp)
    80001a8c:	fc26                	sd	s1,56(sp)
    80001a8e:	f84a                	sd	s2,48(sp)
    80001a90:	f44e                	sd	s3,40(sp)
    80001a92:	f052                	sd	s4,32(sp)
    80001a94:	ec56                	sd	s5,24(sp)
    80001a96:	e85a                	sd	s6,16(sp)
    80001a98:	e45e                	sd	s7,8(sp)
    80001a9a:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001a9c:	00007597          	auipc	a1,0x7
    80001aa0:	98c58593          	addi	a1,a1,-1652 # 80008428 <userret+0x398>
    80001aa4:	00013517          	auipc	a0,0x13
    80001aa8:	eb450513          	addi	a0,a0,-332 # 80014958 <pid_lock>
    80001aac:	fffff097          	auipc	ra,0xfffff
    80001ab0:	030080e7          	jalr	48(ra) # 80000adc <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ab4:	00013917          	auipc	s2,0x13
    80001ab8:	2c490913          	addi	s2,s2,708 # 80014d78 <proc>
      initlock(&p->lock, "proc");
    80001abc:	00007b97          	auipc	s7,0x7
    80001ac0:	974b8b93          	addi	s7,s7,-1676 # 80008430 <userret+0x3a0>
      uint64 va = KSTACK((int) (p - proc));
    80001ac4:	8b4a                	mv	s6,s2
    80001ac6:	00007a97          	auipc	s5,0x7
    80001aca:	0faa8a93          	addi	s5,s5,250 # 80008bc0 <syscalls+0xb8>
    80001ace:	040009b7          	lui	s3,0x4000
    80001ad2:	19fd                	addi	s3,s3,-1
    80001ad4:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ad6:	00019a17          	auipc	s4,0x19
    80001ada:	ea2a0a13          	addi	s4,s4,-350 # 8001a978 <tickslock>
      initlock(&p->lock, "proc");
    80001ade:	85de                	mv	a1,s7
    80001ae0:	854a                	mv	a0,s2
    80001ae2:	fffff097          	auipc	ra,0xfffff
    80001ae6:	ffa080e7          	jalr	-6(ra) # 80000adc <initlock>
      char *pa = kalloc();
    80001aea:	fffff097          	auipc	ra,0xfffff
    80001aee:	f5a080e7          	jalr	-166(ra) # 80000a44 <kalloc>
    80001af2:	85aa                	mv	a1,a0
      if(pa == 0)
    80001af4:	c929                	beqz	a0,80001b46 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    80001af6:	416904b3          	sub	s1,s2,s6
    80001afa:	8491                	srai	s1,s1,0x4
    80001afc:	000ab783          	ld	a5,0(s5)
    80001b00:	02f484b3          	mul	s1,s1,a5
    80001b04:	2485                	addiw	s1,s1,1
    80001b06:	00d4949b          	slliw	s1,s1,0xd
    80001b0a:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001b0e:	4699                	li	a3,6
    80001b10:	6605                	lui	a2,0x1
    80001b12:	8526                	mv	a0,s1
    80001b14:	00000097          	auipc	ra,0x0
    80001b18:	8ac080e7          	jalr	-1876(ra) # 800013c0 <kvmmap>
      p->kstack = va;
    80001b1c:	04993423          	sd	s1,72(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b20:	17090913          	addi	s2,s2,368
    80001b24:	fb491de3          	bne	s2,s4,80001ade <procinit+0x58>
  kvminithart();
    80001b28:	fffff097          	auipc	ra,0xfffff
    80001b2c:	746080e7          	jalr	1862(ra) # 8000126e <kvminithart>
}
    80001b30:	60a6                	ld	ra,72(sp)
    80001b32:	6406                	ld	s0,64(sp)
    80001b34:	74e2                	ld	s1,56(sp)
    80001b36:	7942                	ld	s2,48(sp)
    80001b38:	79a2                	ld	s3,40(sp)
    80001b3a:	7a02                	ld	s4,32(sp)
    80001b3c:	6ae2                	ld	s5,24(sp)
    80001b3e:	6b42                	ld	s6,16(sp)
    80001b40:	6ba2                	ld	s7,8(sp)
    80001b42:	6161                	addi	sp,sp,80
    80001b44:	8082                	ret
        panic("kalloc");
    80001b46:	00007517          	auipc	a0,0x7
    80001b4a:	8f250513          	addi	a0,a0,-1806 # 80008438 <userret+0x3a8>
    80001b4e:	fffff097          	auipc	ra,0xfffff
    80001b52:	9fa080e7          	jalr	-1542(ra) # 80000548 <panic>

0000000080001b56 <cpuid>:
{
    80001b56:	1141                	addi	sp,sp,-16
    80001b58:	e422                	sd	s0,8(sp)
    80001b5a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b5c:	8512                	mv	a0,tp
}
    80001b5e:	2501                	sext.w	a0,a0
    80001b60:	6422                	ld	s0,8(sp)
    80001b62:	0141                	addi	sp,sp,16
    80001b64:	8082                	ret

0000000080001b66 <mycpu>:
mycpu(void) {
    80001b66:	1141                	addi	sp,sp,-16
    80001b68:	e422                	sd	s0,8(sp)
    80001b6a:	0800                	addi	s0,sp,16
    80001b6c:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001b6e:	2781                	sext.w	a5,a5
    80001b70:	079e                	slli	a5,a5,0x7
}
    80001b72:	00013517          	auipc	a0,0x13
    80001b76:	e0650513          	addi	a0,a0,-506 # 80014978 <cpus>
    80001b7a:	953e                	add	a0,a0,a5
    80001b7c:	6422                	ld	s0,8(sp)
    80001b7e:	0141                	addi	sp,sp,16
    80001b80:	8082                	ret

0000000080001b82 <myproc>:
myproc(void) {
    80001b82:	1101                	addi	sp,sp,-32
    80001b84:	ec06                	sd	ra,24(sp)
    80001b86:	e822                	sd	s0,16(sp)
    80001b88:	e426                	sd	s1,8(sp)
    80001b8a:	1000                	addi	s0,sp,32
  push_off();
    80001b8c:	fffff097          	auipc	ra,0xfffff
    80001b90:	fa6080e7          	jalr	-90(ra) # 80000b32 <push_off>
    80001b94:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001b96:	2781                	sext.w	a5,a5
    80001b98:	079e                	slli	a5,a5,0x7
    80001b9a:	00013717          	auipc	a4,0x13
    80001b9e:	dbe70713          	addi	a4,a4,-578 # 80014958 <pid_lock>
    80001ba2:	97ba                	add	a5,a5,a4
    80001ba4:	7384                	ld	s1,32(a5)
  pop_off();
    80001ba6:	fffff097          	auipc	ra,0xfffff
    80001baa:	fd8080e7          	jalr	-40(ra) # 80000b7e <pop_off>
}
    80001bae:	8526                	mv	a0,s1
    80001bb0:	60e2                	ld	ra,24(sp)
    80001bb2:	6442                	ld	s0,16(sp)
    80001bb4:	64a2                	ld	s1,8(sp)
    80001bb6:	6105                	addi	sp,sp,32
    80001bb8:	8082                	ret

0000000080001bba <forkret>:
{
    80001bba:	1141                	addi	sp,sp,-16
    80001bbc:	e406                	sd	ra,8(sp)
    80001bbe:	e022                	sd	s0,0(sp)
    80001bc0:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001bc2:	00000097          	auipc	ra,0x0
    80001bc6:	fc0080e7          	jalr	-64(ra) # 80001b82 <myproc>
    80001bca:	fffff097          	auipc	ra,0xfffff
    80001bce:	0d0080e7          	jalr	208(ra) # 80000c9a <release>
  if (first) {
    80001bd2:	00007797          	auipc	a5,0x7
    80001bd6:	4627a783          	lw	a5,1122(a5) # 80009034 <first.1>
    80001bda:	eb89                	bnez	a5,80001bec <forkret+0x32>
  usertrapret();
    80001bdc:	00001097          	auipc	ra,0x1
    80001be0:	bdc080e7          	jalr	-1060(ra) # 800027b8 <usertrapret>
}
    80001be4:	60a2                	ld	ra,8(sp)
    80001be6:	6402                	ld	s0,0(sp)
    80001be8:	0141                	addi	sp,sp,16
    80001bea:	8082                	ret
    first = 0;
    80001bec:	00007797          	auipc	a5,0x7
    80001bf0:	4407a423          	sw	zero,1096(a5) # 80009034 <first.1>
    fsinit(minor(ROOTDEV));
    80001bf4:	4501                	li	a0,0
    80001bf6:	00002097          	auipc	ra,0x2
    80001bfa:	a20080e7          	jalr	-1504(ra) # 80003616 <fsinit>
    80001bfe:	bff9                	j	80001bdc <forkret+0x22>

0000000080001c00 <allocpid>:
allocpid() {
    80001c00:	1101                	addi	sp,sp,-32
    80001c02:	ec06                	sd	ra,24(sp)
    80001c04:	e822                	sd	s0,16(sp)
    80001c06:	e426                	sd	s1,8(sp)
    80001c08:	e04a                	sd	s2,0(sp)
    80001c0a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001c0c:	00013917          	auipc	s2,0x13
    80001c10:	d4c90913          	addi	s2,s2,-692 # 80014958 <pid_lock>
    80001c14:	854a                	mv	a0,s2
    80001c16:	fffff097          	auipc	ra,0xfffff
    80001c1a:	014080e7          	jalr	20(ra) # 80000c2a <acquire>
  pid = nextpid;
    80001c1e:	00007797          	auipc	a5,0x7
    80001c22:	41a78793          	addi	a5,a5,1050 # 80009038 <nextpid>
    80001c26:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001c28:	0014871b          	addiw	a4,s1,1
    80001c2c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001c2e:	854a                	mv	a0,s2
    80001c30:	fffff097          	auipc	ra,0xfffff
    80001c34:	06a080e7          	jalr	106(ra) # 80000c9a <release>
}
    80001c38:	8526                	mv	a0,s1
    80001c3a:	60e2                	ld	ra,24(sp)
    80001c3c:	6442                	ld	s0,16(sp)
    80001c3e:	64a2                	ld	s1,8(sp)
    80001c40:	6902                	ld	s2,0(sp)
    80001c42:	6105                	addi	sp,sp,32
    80001c44:	8082                	ret

0000000080001c46 <proc_pagetable>:
{
    80001c46:	1101                	addi	sp,sp,-32
    80001c48:	ec06                	sd	ra,24(sp)
    80001c4a:	e822                	sd	s0,16(sp)
    80001c4c:	e426                	sd	s1,8(sp)
    80001c4e:	e04a                	sd	s2,0(sp)
    80001c50:	1000                	addi	s0,sp,32
    80001c52:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001c54:	00000097          	auipc	ra,0x0
    80001c58:	952080e7          	jalr	-1710(ra) # 800015a6 <uvmcreate>
    80001c5c:	84aa                	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001c5e:	4729                	li	a4,10
    80001c60:	00006697          	auipc	a3,0x6
    80001c64:	3a068693          	addi	a3,a3,928 # 80008000 <trampoline>
    80001c68:	6605                	lui	a2,0x1
    80001c6a:	040005b7          	lui	a1,0x4000
    80001c6e:	15fd                	addi	a1,a1,-1
    80001c70:	05b2                	slli	a1,a1,0xc
    80001c72:	fffff097          	auipc	ra,0xfffff
    80001c76:	6c0080e7          	jalr	1728(ra) # 80001332 <mappages>
  mappages(pagetable, TRAPFRAME, PGSIZE,
    80001c7a:	4719                	li	a4,6
    80001c7c:	06093683          	ld	a3,96(s2)
    80001c80:	6605                	lui	a2,0x1
    80001c82:	020005b7          	lui	a1,0x2000
    80001c86:	15fd                	addi	a1,a1,-1
    80001c88:	05b6                	slli	a1,a1,0xd
    80001c8a:	8526                	mv	a0,s1
    80001c8c:	fffff097          	auipc	ra,0xfffff
    80001c90:	6a6080e7          	jalr	1702(ra) # 80001332 <mappages>
}
    80001c94:	8526                	mv	a0,s1
    80001c96:	60e2                	ld	ra,24(sp)
    80001c98:	6442                	ld	s0,16(sp)
    80001c9a:	64a2                	ld	s1,8(sp)
    80001c9c:	6902                	ld	s2,0(sp)
    80001c9e:	6105                	addi	sp,sp,32
    80001ca0:	8082                	ret

0000000080001ca2 <allocproc>:
{
    80001ca2:	1101                	addi	sp,sp,-32
    80001ca4:	ec06                	sd	ra,24(sp)
    80001ca6:	e822                	sd	s0,16(sp)
    80001ca8:	e426                	sd	s1,8(sp)
    80001caa:	e04a                	sd	s2,0(sp)
    80001cac:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cae:	00013497          	auipc	s1,0x13
    80001cb2:	0ca48493          	addi	s1,s1,202 # 80014d78 <proc>
    80001cb6:	00019917          	auipc	s2,0x19
    80001cba:	cc290913          	addi	s2,s2,-830 # 8001a978 <tickslock>
    acquire(&p->lock);
    80001cbe:	8526                	mv	a0,s1
    80001cc0:	fffff097          	auipc	ra,0xfffff
    80001cc4:	f6a080e7          	jalr	-150(ra) # 80000c2a <acquire>
    if(p->state == UNUSED) {
    80001cc8:	509c                	lw	a5,32(s1)
    80001cca:	cf81                	beqz	a5,80001ce2 <allocproc+0x40>
      release(&p->lock);
    80001ccc:	8526                	mv	a0,s1
    80001cce:	fffff097          	auipc	ra,0xfffff
    80001cd2:	fcc080e7          	jalr	-52(ra) # 80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cd6:	17048493          	addi	s1,s1,368
    80001cda:	ff2492e3          	bne	s1,s2,80001cbe <allocproc+0x1c>
  return 0;
    80001cde:	4481                	li	s1,0
    80001ce0:	a0a9                	j	80001d2a <allocproc+0x88>
  p->pid = allocpid();
    80001ce2:	00000097          	auipc	ra,0x0
    80001ce6:	f1e080e7          	jalr	-226(ra) # 80001c00 <allocpid>
    80001cea:	c0a8                	sw	a0,64(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    80001cec:	fffff097          	auipc	ra,0xfffff
    80001cf0:	d58080e7          	jalr	-680(ra) # 80000a44 <kalloc>
    80001cf4:	892a                	mv	s2,a0
    80001cf6:	f0a8                	sd	a0,96(s1)
    80001cf8:	c121                	beqz	a0,80001d38 <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    80001cfa:	8526                	mv	a0,s1
    80001cfc:	00000097          	auipc	ra,0x0
    80001d00:	f4a080e7          	jalr	-182(ra) # 80001c46 <proc_pagetable>
    80001d04:	eca8                	sd	a0,88(s1)
  memset(&p->context, 0, sizeof p->context);
    80001d06:	07000613          	li	a2,112
    80001d0a:	4581                	li	a1,0
    80001d0c:	06848513          	addi	a0,s1,104
    80001d10:	fffff097          	auipc	ra,0xfffff
    80001d14:	188080e7          	jalr	392(ra) # 80000e98 <memset>
  p->context.ra = (uint64)forkret;
    80001d18:	00000797          	auipc	a5,0x0
    80001d1c:	ea278793          	addi	a5,a5,-350 # 80001bba <forkret>
    80001d20:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001d22:	64bc                	ld	a5,72(s1)
    80001d24:	6705                	lui	a4,0x1
    80001d26:	97ba                	add	a5,a5,a4
    80001d28:	f8bc                	sd	a5,112(s1)
}
    80001d2a:	8526                	mv	a0,s1
    80001d2c:	60e2                	ld	ra,24(sp)
    80001d2e:	6442                	ld	s0,16(sp)
    80001d30:	64a2                	ld	s1,8(sp)
    80001d32:	6902                	ld	s2,0(sp)
    80001d34:	6105                	addi	sp,sp,32
    80001d36:	8082                	ret
    release(&p->lock);
    80001d38:	8526                	mv	a0,s1
    80001d3a:	fffff097          	auipc	ra,0xfffff
    80001d3e:	f60080e7          	jalr	-160(ra) # 80000c9a <release>
    return 0;
    80001d42:	84ca                	mv	s1,s2
    80001d44:	b7dd                	j	80001d2a <allocproc+0x88>

0000000080001d46 <proc_freepagetable>:
{
    80001d46:	1101                	addi	sp,sp,-32
    80001d48:	ec06                	sd	ra,24(sp)
    80001d4a:	e822                	sd	s0,16(sp)
    80001d4c:	e426                	sd	s1,8(sp)
    80001d4e:	e04a                	sd	s2,0(sp)
    80001d50:	1000                	addi	s0,sp,32
    80001d52:	84aa                	mv	s1,a0
    80001d54:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    80001d56:	4681                	li	a3,0
    80001d58:	6605                	lui	a2,0x1
    80001d5a:	040005b7          	lui	a1,0x4000
    80001d5e:	15fd                	addi	a1,a1,-1
    80001d60:	05b2                	slli	a1,a1,0xc
    80001d62:	fffff097          	auipc	ra,0xfffff
    80001d66:	77c080e7          	jalr	1916(ra) # 800014de <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, PGSIZE, 0);
    80001d6a:	4681                	li	a3,0
    80001d6c:	6605                	lui	a2,0x1
    80001d6e:	020005b7          	lui	a1,0x2000
    80001d72:	15fd                	addi	a1,a1,-1
    80001d74:	05b6                	slli	a1,a1,0xd
    80001d76:	8526                	mv	a0,s1
    80001d78:	fffff097          	auipc	ra,0xfffff
    80001d7c:	766080e7          	jalr	1894(ra) # 800014de <uvmunmap>
  if(sz > 0)
    80001d80:	00091863          	bnez	s2,80001d90 <proc_freepagetable+0x4a>
}
    80001d84:	60e2                	ld	ra,24(sp)
    80001d86:	6442                	ld	s0,16(sp)
    80001d88:	64a2                	ld	s1,8(sp)
    80001d8a:	6902                	ld	s2,0(sp)
    80001d8c:	6105                	addi	sp,sp,32
    80001d8e:	8082                	ret
    uvmfree(pagetable, sz);
    80001d90:	85ca                	mv	a1,s2
    80001d92:	8526                	mv	a0,s1
    80001d94:	00000097          	auipc	ra,0x0
    80001d98:	9b0080e7          	jalr	-1616(ra) # 80001744 <uvmfree>
}
    80001d9c:	b7e5                	j	80001d84 <proc_freepagetable+0x3e>

0000000080001d9e <freeproc>:
{
    80001d9e:	1101                	addi	sp,sp,-32
    80001da0:	ec06                	sd	ra,24(sp)
    80001da2:	e822                	sd	s0,16(sp)
    80001da4:	e426                	sd	s1,8(sp)
    80001da6:	1000                	addi	s0,sp,32
    80001da8:	84aa                	mv	s1,a0
  if(p->tf)
    80001daa:	7128                	ld	a0,96(a0)
    80001dac:	c509                	beqz	a0,80001db6 <freeproc+0x18>
    kfree((void*)p->tf);
    80001dae:	fffff097          	auipc	ra,0xfffff
    80001db2:	ab6080e7          	jalr	-1354(ra) # 80000864 <kfree>
  p->tf = 0;
    80001db6:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001dba:	6ca8                	ld	a0,88(s1)
    80001dbc:	c511                	beqz	a0,80001dc8 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001dbe:	68ac                	ld	a1,80(s1)
    80001dc0:	00000097          	auipc	ra,0x0
    80001dc4:	f86080e7          	jalr	-122(ra) # 80001d46 <proc_freepagetable>
  p->pagetable = 0;
    80001dc8:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001dcc:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001dd0:	0404a023          	sw	zero,64(s1)
  p->parent = 0;
    80001dd4:	0204b423          	sd	zero,40(s1)
  p->name[0] = 0;
    80001dd8:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001ddc:	0204b823          	sd	zero,48(s1)
  p->killed = 0;
    80001de0:	0204ac23          	sw	zero,56(s1)
  p->xstate = 0;
    80001de4:	0204ae23          	sw	zero,60(s1)
  p->state = UNUSED;
    80001de8:	0204a023          	sw	zero,32(s1)
}
    80001dec:	60e2                	ld	ra,24(sp)
    80001dee:	6442                	ld	s0,16(sp)
    80001df0:	64a2                	ld	s1,8(sp)
    80001df2:	6105                	addi	sp,sp,32
    80001df4:	8082                	ret

0000000080001df6 <userinit>:
{
    80001df6:	1101                	addi	sp,sp,-32
    80001df8:	ec06                	sd	ra,24(sp)
    80001dfa:	e822                	sd	s0,16(sp)
    80001dfc:	e426                	sd	s1,8(sp)
    80001dfe:	1000                	addi	s0,sp,32
  p = allocproc();
    80001e00:	00000097          	auipc	ra,0x0
    80001e04:	ea2080e7          	jalr	-350(ra) # 80001ca2 <allocproc>
    80001e08:	84aa                	mv	s1,a0
  initproc = p;
    80001e0a:	0002e797          	auipc	a5,0x2e
    80001e0e:	22a7b723          	sd	a0,558(a5) # 80030038 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001e12:	03300613          	li	a2,51
    80001e16:	00007597          	auipc	a1,0x7
    80001e1a:	1ea58593          	addi	a1,a1,490 # 80009000 <initcode>
    80001e1e:	6d28                	ld	a0,88(a0)
    80001e20:	fffff097          	auipc	ra,0xfffff
    80001e24:	7c4080e7          	jalr	1988(ra) # 800015e4 <uvminit>
  p->sz = PGSIZE;
    80001e28:	6785                	lui	a5,0x1
    80001e2a:	e8bc                	sd	a5,80(s1)
  p->tf->epc = 0;      // user program counter
    80001e2c:	70b8                	ld	a4,96(s1)
    80001e2e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->tf->sp = PGSIZE;  // user stack pointer
    80001e32:	70b8                	ld	a4,96(s1)
    80001e34:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001e36:	4641                	li	a2,16
    80001e38:	00006597          	auipc	a1,0x6
    80001e3c:	60858593          	addi	a1,a1,1544 # 80008440 <userret+0x3b0>
    80001e40:	16048513          	addi	a0,s1,352
    80001e44:	fffff097          	auipc	ra,0xfffff
    80001e48:	1a6080e7          	jalr	422(ra) # 80000fea <safestrcpy>
  p->cwd = namei("/");
    80001e4c:	00006517          	auipc	a0,0x6
    80001e50:	60450513          	addi	a0,a0,1540 # 80008450 <userret+0x3c0>
    80001e54:	00002097          	auipc	ra,0x2
    80001e58:	1c4080e7          	jalr	452(ra) # 80004018 <namei>
    80001e5c:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001e60:	4789                	li	a5,2
    80001e62:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    80001e64:	8526                	mv	a0,s1
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	e34080e7          	jalr	-460(ra) # 80000c9a <release>
}
    80001e6e:	60e2                	ld	ra,24(sp)
    80001e70:	6442                	ld	s0,16(sp)
    80001e72:	64a2                	ld	s1,8(sp)
    80001e74:	6105                	addi	sp,sp,32
    80001e76:	8082                	ret

0000000080001e78 <growproc>:
{
    80001e78:	1101                	addi	sp,sp,-32
    80001e7a:	ec06                	sd	ra,24(sp)
    80001e7c:	e822                	sd	s0,16(sp)
    80001e7e:	e426                	sd	s1,8(sp)
    80001e80:	e04a                	sd	s2,0(sp)
    80001e82:	1000                	addi	s0,sp,32
    80001e84:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e86:	00000097          	auipc	ra,0x0
    80001e8a:	cfc080e7          	jalr	-772(ra) # 80001b82 <myproc>
    80001e8e:	892a                	mv	s2,a0
  sz = p->sz;
    80001e90:	692c                	ld	a1,80(a0)
    80001e92:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001e96:	00904f63          	bgtz	s1,80001eb4 <growproc+0x3c>
  } else if(n < 0){
    80001e9a:	0204cc63          	bltz	s1,80001ed2 <growproc+0x5a>
  p->sz = sz;
    80001e9e:	1602                	slli	a2,a2,0x20
    80001ea0:	9201                	srli	a2,a2,0x20
    80001ea2:	04c93823          	sd	a2,80(s2)
  return 0;
    80001ea6:	4501                	li	a0,0
}
    80001ea8:	60e2                	ld	ra,24(sp)
    80001eaa:	6442                	ld	s0,16(sp)
    80001eac:	64a2                	ld	s1,8(sp)
    80001eae:	6902                	ld	s2,0(sp)
    80001eb0:	6105                	addi	sp,sp,32
    80001eb2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001eb4:	9e25                	addw	a2,a2,s1
    80001eb6:	1602                	slli	a2,a2,0x20
    80001eb8:	9201                	srli	a2,a2,0x20
    80001eba:	1582                	slli	a1,a1,0x20
    80001ebc:	9181                	srli	a1,a1,0x20
    80001ebe:	6d28                	ld	a0,88(a0)
    80001ec0:	fffff097          	auipc	ra,0xfffff
    80001ec4:	7da080e7          	jalr	2010(ra) # 8000169a <uvmalloc>
    80001ec8:	0005061b          	sext.w	a2,a0
    80001ecc:	fa69                	bnez	a2,80001e9e <growproc+0x26>
      return -1;
    80001ece:	557d                	li	a0,-1
    80001ed0:	bfe1                	j	80001ea8 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001ed2:	9e25                	addw	a2,a2,s1
    80001ed4:	1602                	slli	a2,a2,0x20
    80001ed6:	9201                	srli	a2,a2,0x20
    80001ed8:	1582                	slli	a1,a1,0x20
    80001eda:	9181                	srli	a1,a1,0x20
    80001edc:	6d28                	ld	a0,88(a0)
    80001ede:	fffff097          	auipc	ra,0xfffff
    80001ee2:	778080e7          	jalr	1912(ra) # 80001656 <uvmdealloc>
    80001ee6:	0005061b          	sext.w	a2,a0
    80001eea:	bf55                	j	80001e9e <growproc+0x26>

0000000080001eec <fork>:
{
    80001eec:	7139                	addi	sp,sp,-64
    80001eee:	fc06                	sd	ra,56(sp)
    80001ef0:	f822                	sd	s0,48(sp)
    80001ef2:	f426                	sd	s1,40(sp)
    80001ef4:	f04a                	sd	s2,32(sp)
    80001ef6:	ec4e                	sd	s3,24(sp)
    80001ef8:	e852                	sd	s4,16(sp)
    80001efa:	e456                	sd	s5,8(sp)
    80001efc:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001efe:	00000097          	auipc	ra,0x0
    80001f02:	c84080e7          	jalr	-892(ra) # 80001b82 <myproc>
    80001f06:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001f08:	00000097          	auipc	ra,0x0
    80001f0c:	d9a080e7          	jalr	-614(ra) # 80001ca2 <allocproc>
    80001f10:	c17d                	beqz	a0,80001ff6 <fork+0x10a>
    80001f12:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001f14:	050ab603          	ld	a2,80(s5)
    80001f18:	6d2c                	ld	a1,88(a0)
    80001f1a:	058ab503          	ld	a0,88(s5)
    80001f1e:	00000097          	auipc	ra,0x0
    80001f22:	854080e7          	jalr	-1964(ra) # 80001772 <uvmcopy>
    80001f26:	04054a63          	bltz	a0,80001f7a <fork+0x8e>
  np->sz = p->sz;
    80001f2a:	050ab783          	ld	a5,80(s5)
    80001f2e:	04fa3823          	sd	a5,80(s4)
  np->parent = p;
    80001f32:	035a3423          	sd	s5,40(s4)
  *(np->tf) = *(p->tf);
    80001f36:	060ab683          	ld	a3,96(s5)
    80001f3a:	87b6                	mv	a5,a3
    80001f3c:	060a3703          	ld	a4,96(s4)
    80001f40:	12068693          	addi	a3,a3,288
    80001f44:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001f48:	6788                	ld	a0,8(a5)
    80001f4a:	6b8c                	ld	a1,16(a5)
    80001f4c:	6f90                	ld	a2,24(a5)
    80001f4e:	01073023          	sd	a6,0(a4)
    80001f52:	e708                	sd	a0,8(a4)
    80001f54:	eb0c                	sd	a1,16(a4)
    80001f56:	ef10                	sd	a2,24(a4)
    80001f58:	02078793          	addi	a5,a5,32
    80001f5c:	02070713          	addi	a4,a4,32
    80001f60:	fed792e3          	bne	a5,a3,80001f44 <fork+0x58>
  np->tf->a0 = 0;
    80001f64:	060a3783          	ld	a5,96(s4)
    80001f68:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001f6c:	0d8a8493          	addi	s1,s5,216
    80001f70:	0d8a0913          	addi	s2,s4,216
    80001f74:	158a8993          	addi	s3,s5,344
    80001f78:	a00d                	j	80001f9a <fork+0xae>
    freeproc(np);
    80001f7a:	8552                	mv	a0,s4
    80001f7c:	00000097          	auipc	ra,0x0
    80001f80:	e22080e7          	jalr	-478(ra) # 80001d9e <freeproc>
    release(&np->lock);
    80001f84:	8552                	mv	a0,s4
    80001f86:	fffff097          	auipc	ra,0xfffff
    80001f8a:	d14080e7          	jalr	-748(ra) # 80000c9a <release>
    return -1;
    80001f8e:	54fd                	li	s1,-1
    80001f90:	a889                	j	80001fe2 <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    80001f92:	04a1                	addi	s1,s1,8
    80001f94:	0921                	addi	s2,s2,8
    80001f96:	01348b63          	beq	s1,s3,80001fac <fork+0xc0>
    if(p->ofile[i])
    80001f9a:	6088                	ld	a0,0(s1)
    80001f9c:	d97d                	beqz	a0,80001f92 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001f9e:	00003097          	auipc	ra,0x3
    80001fa2:	81e080e7          	jalr	-2018(ra) # 800047bc <filedup>
    80001fa6:	00a93023          	sd	a0,0(s2)
    80001faa:	b7e5                	j	80001f92 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001fac:	158ab503          	ld	a0,344(s5)
    80001fb0:	00002097          	auipc	ra,0x2
    80001fb4:	8a0080e7          	jalr	-1888(ra) # 80003850 <idup>
    80001fb8:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001fbc:	4641                	li	a2,16
    80001fbe:	160a8593          	addi	a1,s5,352
    80001fc2:	160a0513          	addi	a0,s4,352
    80001fc6:	fffff097          	auipc	ra,0xfffff
    80001fca:	024080e7          	jalr	36(ra) # 80000fea <safestrcpy>
  pid = np->pid;
    80001fce:	040a2483          	lw	s1,64(s4)
  np->state = RUNNABLE;
    80001fd2:	4789                	li	a5,2
    80001fd4:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    80001fd8:	8552                	mv	a0,s4
    80001fda:	fffff097          	auipc	ra,0xfffff
    80001fde:	cc0080e7          	jalr	-832(ra) # 80000c9a <release>
}
    80001fe2:	8526                	mv	a0,s1
    80001fe4:	70e2                	ld	ra,56(sp)
    80001fe6:	7442                	ld	s0,48(sp)
    80001fe8:	74a2                	ld	s1,40(sp)
    80001fea:	7902                	ld	s2,32(sp)
    80001fec:	69e2                	ld	s3,24(sp)
    80001fee:	6a42                	ld	s4,16(sp)
    80001ff0:	6aa2                	ld	s5,8(sp)
    80001ff2:	6121                	addi	sp,sp,64
    80001ff4:	8082                	ret
    return -1;
    80001ff6:	54fd                	li	s1,-1
    80001ff8:	b7ed                	j	80001fe2 <fork+0xf6>

0000000080001ffa <reparent>:
{
    80001ffa:	7179                	addi	sp,sp,-48
    80001ffc:	f406                	sd	ra,40(sp)
    80001ffe:	f022                	sd	s0,32(sp)
    80002000:	ec26                	sd	s1,24(sp)
    80002002:	e84a                	sd	s2,16(sp)
    80002004:	e44e                	sd	s3,8(sp)
    80002006:	e052                	sd	s4,0(sp)
    80002008:	1800                	addi	s0,sp,48
    8000200a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000200c:	00013497          	auipc	s1,0x13
    80002010:	d6c48493          	addi	s1,s1,-660 # 80014d78 <proc>
      pp->parent = initproc;
    80002014:	0002ea17          	auipc	s4,0x2e
    80002018:	024a0a13          	addi	s4,s4,36 # 80030038 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000201c:	00019997          	auipc	s3,0x19
    80002020:	95c98993          	addi	s3,s3,-1700 # 8001a978 <tickslock>
    80002024:	a029                	j	8000202e <reparent+0x34>
    80002026:	17048493          	addi	s1,s1,368
    8000202a:	03348363          	beq	s1,s3,80002050 <reparent+0x56>
    if(pp->parent == p){
    8000202e:	749c                	ld	a5,40(s1)
    80002030:	ff279be3          	bne	a5,s2,80002026 <reparent+0x2c>
      acquire(&pp->lock);
    80002034:	8526                	mv	a0,s1
    80002036:	fffff097          	auipc	ra,0xfffff
    8000203a:	bf4080e7          	jalr	-1036(ra) # 80000c2a <acquire>
      pp->parent = initproc;
    8000203e:	000a3783          	ld	a5,0(s4)
    80002042:	f49c                	sd	a5,40(s1)
      release(&pp->lock);
    80002044:	8526                	mv	a0,s1
    80002046:	fffff097          	auipc	ra,0xfffff
    8000204a:	c54080e7          	jalr	-940(ra) # 80000c9a <release>
    8000204e:	bfe1                	j	80002026 <reparent+0x2c>
}
    80002050:	70a2                	ld	ra,40(sp)
    80002052:	7402                	ld	s0,32(sp)
    80002054:	64e2                	ld	s1,24(sp)
    80002056:	6942                	ld	s2,16(sp)
    80002058:	69a2                	ld	s3,8(sp)
    8000205a:	6a02                	ld	s4,0(sp)
    8000205c:	6145                	addi	sp,sp,48
    8000205e:	8082                	ret

0000000080002060 <scheduler>:
{
    80002060:	715d                	addi	sp,sp,-80
    80002062:	e486                	sd	ra,72(sp)
    80002064:	e0a2                	sd	s0,64(sp)
    80002066:	fc26                	sd	s1,56(sp)
    80002068:	f84a                	sd	s2,48(sp)
    8000206a:	f44e                	sd	s3,40(sp)
    8000206c:	f052                	sd	s4,32(sp)
    8000206e:	ec56                	sd	s5,24(sp)
    80002070:	e85a                	sd	s6,16(sp)
    80002072:	e45e                	sd	s7,8(sp)
    80002074:	e062                	sd	s8,0(sp)
    80002076:	0880                	addi	s0,sp,80
    80002078:	8792                	mv	a5,tp
  int id = r_tp();
    8000207a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000207c:	00779b13          	slli	s6,a5,0x7
    80002080:	00013717          	auipc	a4,0x13
    80002084:	8d870713          	addi	a4,a4,-1832 # 80014958 <pid_lock>
    80002088:	975a                	add	a4,a4,s6
    8000208a:	02073023          	sd	zero,32(a4)
        swtch(&c->scheduler, &p->context);
    8000208e:	00013717          	auipc	a4,0x13
    80002092:	8f270713          	addi	a4,a4,-1806 # 80014980 <cpus+0x8>
    80002096:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80002098:	4c0d                	li	s8,3
        c->proc = p;
    8000209a:	079e                	slli	a5,a5,0x7
    8000209c:	00013a17          	auipc	s4,0x13
    800020a0:	8bca0a13          	addi	s4,s4,-1860 # 80014958 <pid_lock>
    800020a4:	9a3e                	add	s4,s4,a5
        found = 1;
    800020a6:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    800020a8:	00019997          	auipc	s3,0x19
    800020ac:	8d098993          	addi	s3,s3,-1840 # 8001a978 <tickslock>
    800020b0:	a08d                	j	80002112 <scheduler+0xb2>
      release(&p->lock);
    800020b2:	8526                	mv	a0,s1
    800020b4:	fffff097          	auipc	ra,0xfffff
    800020b8:	be6080e7          	jalr	-1050(ra) # 80000c9a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800020bc:	17048493          	addi	s1,s1,368
    800020c0:	03348963          	beq	s1,s3,800020f2 <scheduler+0x92>
      acquire(&p->lock);
    800020c4:	8526                	mv	a0,s1
    800020c6:	fffff097          	auipc	ra,0xfffff
    800020ca:	b64080e7          	jalr	-1180(ra) # 80000c2a <acquire>
      if(p->state == RUNNABLE) {
    800020ce:	509c                	lw	a5,32(s1)
    800020d0:	ff2791e3          	bne	a5,s2,800020b2 <scheduler+0x52>
        p->state = RUNNING;
    800020d4:	0384a023          	sw	s8,32(s1)
        c->proc = p;
    800020d8:	029a3023          	sd	s1,32(s4)
        swtch(&c->scheduler, &p->context);
    800020dc:	06848593          	addi	a1,s1,104
    800020e0:	855a                	mv	a0,s6
    800020e2:	00000097          	auipc	ra,0x0
    800020e6:	62c080e7          	jalr	1580(ra) # 8000270e <swtch>
        c->proc = 0;
    800020ea:	020a3023          	sd	zero,32(s4)
        found = 1;
    800020ee:	8ade                	mv	s5,s7
    800020f0:	b7c9                	j	800020b2 <scheduler+0x52>
    if(found == 0){
    800020f2:	020a9063          	bnez	s5,80002112 <scheduler+0xb2>
  asm volatile("csrr %0, sie" : "=r" (x) );
    800020f6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800020fa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800020fe:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002102:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002106:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000210a:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000210e:	10500073          	wfi
  asm volatile("csrr %0, sie" : "=r" (x) );
    80002112:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80002116:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000211a:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000211e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002122:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002126:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000212a:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000212c:	00013497          	auipc	s1,0x13
    80002130:	c4c48493          	addi	s1,s1,-948 # 80014d78 <proc>
      if(p->state == RUNNABLE) {
    80002134:	4909                	li	s2,2
    80002136:	b779                	j	800020c4 <scheduler+0x64>

0000000080002138 <sched>:
{
    80002138:	7179                	addi	sp,sp,-48
    8000213a:	f406                	sd	ra,40(sp)
    8000213c:	f022                	sd	s0,32(sp)
    8000213e:	ec26                	sd	s1,24(sp)
    80002140:	e84a                	sd	s2,16(sp)
    80002142:	e44e                	sd	s3,8(sp)
    80002144:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002146:	00000097          	auipc	ra,0x0
    8000214a:	a3c080e7          	jalr	-1476(ra) # 80001b82 <myproc>
    8000214e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002150:	fffff097          	auipc	ra,0xfffff
    80002154:	a9a080e7          	jalr	-1382(ra) # 80000bea <holding>
    80002158:	c93d                	beqz	a0,800021ce <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000215a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000215c:	2781                	sext.w	a5,a5
    8000215e:	079e                	slli	a5,a5,0x7
    80002160:	00012717          	auipc	a4,0x12
    80002164:	7f870713          	addi	a4,a4,2040 # 80014958 <pid_lock>
    80002168:	97ba                	add	a5,a5,a4
    8000216a:	0987a703          	lw	a4,152(a5)
    8000216e:	4785                	li	a5,1
    80002170:	06f71763          	bne	a4,a5,800021de <sched+0xa6>
  if(p->state == RUNNING)
    80002174:	5098                	lw	a4,32(s1)
    80002176:	478d                	li	a5,3
    80002178:	06f70b63          	beq	a4,a5,800021ee <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000217c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002180:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002182:	efb5                	bnez	a5,800021fe <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002184:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002186:	00012917          	auipc	s2,0x12
    8000218a:	7d290913          	addi	s2,s2,2002 # 80014958 <pid_lock>
    8000218e:	2781                	sext.w	a5,a5
    80002190:	079e                	slli	a5,a5,0x7
    80002192:	97ca                	add	a5,a5,s2
    80002194:	09c7a983          	lw	s3,156(a5)
    80002198:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->scheduler);
    8000219a:	2781                	sext.w	a5,a5
    8000219c:	079e                	slli	a5,a5,0x7
    8000219e:	00012597          	auipc	a1,0x12
    800021a2:	7e258593          	addi	a1,a1,2018 # 80014980 <cpus+0x8>
    800021a6:	95be                	add	a1,a1,a5
    800021a8:	06848513          	addi	a0,s1,104
    800021ac:	00000097          	auipc	ra,0x0
    800021b0:	562080e7          	jalr	1378(ra) # 8000270e <swtch>
    800021b4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800021b6:	2781                	sext.w	a5,a5
    800021b8:	079e                	slli	a5,a5,0x7
    800021ba:	97ca                	add	a5,a5,s2
    800021bc:	0937ae23          	sw	s3,156(a5)
}
    800021c0:	70a2                	ld	ra,40(sp)
    800021c2:	7402                	ld	s0,32(sp)
    800021c4:	64e2                	ld	s1,24(sp)
    800021c6:	6942                	ld	s2,16(sp)
    800021c8:	69a2                	ld	s3,8(sp)
    800021ca:	6145                	addi	sp,sp,48
    800021cc:	8082                	ret
    panic("sched p->lock");
    800021ce:	00006517          	auipc	a0,0x6
    800021d2:	28a50513          	addi	a0,a0,650 # 80008458 <userret+0x3c8>
    800021d6:	ffffe097          	auipc	ra,0xffffe
    800021da:	372080e7          	jalr	882(ra) # 80000548 <panic>
    panic("sched locks");
    800021de:	00006517          	auipc	a0,0x6
    800021e2:	28a50513          	addi	a0,a0,650 # 80008468 <userret+0x3d8>
    800021e6:	ffffe097          	auipc	ra,0xffffe
    800021ea:	362080e7          	jalr	866(ra) # 80000548 <panic>
    panic("sched running");
    800021ee:	00006517          	auipc	a0,0x6
    800021f2:	28a50513          	addi	a0,a0,650 # 80008478 <userret+0x3e8>
    800021f6:	ffffe097          	auipc	ra,0xffffe
    800021fa:	352080e7          	jalr	850(ra) # 80000548 <panic>
    panic("sched interruptible");
    800021fe:	00006517          	auipc	a0,0x6
    80002202:	28a50513          	addi	a0,a0,650 # 80008488 <userret+0x3f8>
    80002206:	ffffe097          	auipc	ra,0xffffe
    8000220a:	342080e7          	jalr	834(ra) # 80000548 <panic>

000000008000220e <exit>:
{
    8000220e:	7179                	addi	sp,sp,-48
    80002210:	f406                	sd	ra,40(sp)
    80002212:	f022                	sd	s0,32(sp)
    80002214:	ec26                	sd	s1,24(sp)
    80002216:	e84a                	sd	s2,16(sp)
    80002218:	e44e                	sd	s3,8(sp)
    8000221a:	e052                	sd	s4,0(sp)
    8000221c:	1800                	addi	s0,sp,48
    8000221e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002220:	00000097          	auipc	ra,0x0
    80002224:	962080e7          	jalr	-1694(ra) # 80001b82 <myproc>
    80002228:	89aa                	mv	s3,a0
  if(p == initproc)
    8000222a:	0002e797          	auipc	a5,0x2e
    8000222e:	e0e7b783          	ld	a5,-498(a5) # 80030038 <initproc>
    80002232:	0d850493          	addi	s1,a0,216
    80002236:	15850913          	addi	s2,a0,344
    8000223a:	02a79363          	bne	a5,a0,80002260 <exit+0x52>
    panic("init exiting");
    8000223e:	00006517          	auipc	a0,0x6
    80002242:	26250513          	addi	a0,a0,610 # 800084a0 <userret+0x410>
    80002246:	ffffe097          	auipc	ra,0xffffe
    8000224a:	302080e7          	jalr	770(ra) # 80000548 <panic>
      fileclose(f);
    8000224e:	00002097          	auipc	ra,0x2
    80002252:	5c0080e7          	jalr	1472(ra) # 8000480e <fileclose>
      p->ofile[fd] = 0;
    80002256:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000225a:	04a1                	addi	s1,s1,8
    8000225c:	01248563          	beq	s1,s2,80002266 <exit+0x58>
    if(p->ofile[fd]){
    80002260:	6088                	ld	a0,0(s1)
    80002262:	f575                	bnez	a0,8000224e <exit+0x40>
    80002264:	bfdd                	j	8000225a <exit+0x4c>
  begin_op(ROOTDEV);
    80002266:	4501                	li	a0,0
    80002268:	00002097          	auipc	ra,0x2
    8000226c:	00c080e7          	jalr	12(ra) # 80004274 <begin_op>
  iput(p->cwd);
    80002270:	1589b503          	ld	a0,344(s3)
    80002274:	00001097          	auipc	ra,0x1
    80002278:	728080e7          	jalr	1832(ra) # 8000399c <iput>
  end_op(ROOTDEV);
    8000227c:	4501                	li	a0,0
    8000227e:	00002097          	auipc	ra,0x2
    80002282:	0a0080e7          	jalr	160(ra) # 8000431e <end_op>
  p->cwd = 0;
    80002286:	1409bc23          	sd	zero,344(s3)
  acquire(&initproc->lock);
    8000228a:	0002e497          	auipc	s1,0x2e
    8000228e:	dae48493          	addi	s1,s1,-594 # 80030038 <initproc>
    80002292:	6088                	ld	a0,0(s1)
    80002294:	fffff097          	auipc	ra,0xfffff
    80002298:	996080e7          	jalr	-1642(ra) # 80000c2a <acquire>
  wakeup1(initproc);
    8000229c:	6088                	ld	a0,0(s1)
    8000229e:	fffff097          	auipc	ra,0xfffff
    800022a2:	7a4080e7          	jalr	1956(ra) # 80001a42 <wakeup1>
  release(&initproc->lock);
    800022a6:	6088                	ld	a0,0(s1)
    800022a8:	fffff097          	auipc	ra,0xfffff
    800022ac:	9f2080e7          	jalr	-1550(ra) # 80000c9a <release>
  acquire(&p->lock);
    800022b0:	854e                	mv	a0,s3
    800022b2:	fffff097          	auipc	ra,0xfffff
    800022b6:	978080e7          	jalr	-1672(ra) # 80000c2a <acquire>
  struct proc *original_parent = p->parent;
    800022ba:	0289b483          	ld	s1,40(s3)
  release(&p->lock);
    800022be:	854e                	mv	a0,s3
    800022c0:	fffff097          	auipc	ra,0xfffff
    800022c4:	9da080e7          	jalr	-1574(ra) # 80000c9a <release>
  acquire(&original_parent->lock);
    800022c8:	8526                	mv	a0,s1
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	960080e7          	jalr	-1696(ra) # 80000c2a <acquire>
  acquire(&p->lock);
    800022d2:	854e                	mv	a0,s3
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	956080e7          	jalr	-1706(ra) # 80000c2a <acquire>
  reparent(p);
    800022dc:	854e                	mv	a0,s3
    800022de:	00000097          	auipc	ra,0x0
    800022e2:	d1c080e7          	jalr	-740(ra) # 80001ffa <reparent>
  wakeup1(original_parent);
    800022e6:	8526                	mv	a0,s1
    800022e8:	fffff097          	auipc	ra,0xfffff
    800022ec:	75a080e7          	jalr	1882(ra) # 80001a42 <wakeup1>
  p->xstate = status;
    800022f0:	0349ae23          	sw	s4,60(s3)
  p->state = ZOMBIE;
    800022f4:	4791                	li	a5,4
    800022f6:	02f9a023          	sw	a5,32(s3)
  release(&original_parent->lock);
    800022fa:	8526                	mv	a0,s1
    800022fc:	fffff097          	auipc	ra,0xfffff
    80002300:	99e080e7          	jalr	-1634(ra) # 80000c9a <release>
  sched();
    80002304:	00000097          	auipc	ra,0x0
    80002308:	e34080e7          	jalr	-460(ra) # 80002138 <sched>
  panic("zombie exit");
    8000230c:	00006517          	auipc	a0,0x6
    80002310:	1a450513          	addi	a0,a0,420 # 800084b0 <userret+0x420>
    80002314:	ffffe097          	auipc	ra,0xffffe
    80002318:	234080e7          	jalr	564(ra) # 80000548 <panic>

000000008000231c <yield>:
{
    8000231c:	1101                	addi	sp,sp,-32
    8000231e:	ec06                	sd	ra,24(sp)
    80002320:	e822                	sd	s0,16(sp)
    80002322:	e426                	sd	s1,8(sp)
    80002324:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002326:	00000097          	auipc	ra,0x0
    8000232a:	85c080e7          	jalr	-1956(ra) # 80001b82 <myproc>
    8000232e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002330:	fffff097          	auipc	ra,0xfffff
    80002334:	8fa080e7          	jalr	-1798(ra) # 80000c2a <acquire>
  p->state = RUNNABLE;
    80002338:	4789                	li	a5,2
    8000233a:	d09c                	sw	a5,32(s1)
  sched();
    8000233c:	00000097          	auipc	ra,0x0
    80002340:	dfc080e7          	jalr	-516(ra) # 80002138 <sched>
  release(&p->lock);
    80002344:	8526                	mv	a0,s1
    80002346:	fffff097          	auipc	ra,0xfffff
    8000234a:	954080e7          	jalr	-1708(ra) # 80000c9a <release>
}
    8000234e:	60e2                	ld	ra,24(sp)
    80002350:	6442                	ld	s0,16(sp)
    80002352:	64a2                	ld	s1,8(sp)
    80002354:	6105                	addi	sp,sp,32
    80002356:	8082                	ret

0000000080002358 <sleep>:
{
    80002358:	7179                	addi	sp,sp,-48
    8000235a:	f406                	sd	ra,40(sp)
    8000235c:	f022                	sd	s0,32(sp)
    8000235e:	ec26                	sd	s1,24(sp)
    80002360:	e84a                	sd	s2,16(sp)
    80002362:	e44e                	sd	s3,8(sp)
    80002364:	1800                	addi	s0,sp,48
    80002366:	89aa                	mv	s3,a0
    80002368:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000236a:	00000097          	auipc	ra,0x0
    8000236e:	818080e7          	jalr	-2024(ra) # 80001b82 <myproc>
    80002372:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002374:	05250663          	beq	a0,s2,800023c0 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	8b2080e7          	jalr	-1870(ra) # 80000c2a <acquire>
    release(lk);
    80002380:	854a                	mv	a0,s2
    80002382:	fffff097          	auipc	ra,0xfffff
    80002386:	918080e7          	jalr	-1768(ra) # 80000c9a <release>
  p->chan = chan;
    8000238a:	0334b823          	sd	s3,48(s1)
  p->state = SLEEPING;
    8000238e:	4785                	li	a5,1
    80002390:	d09c                	sw	a5,32(s1)
  sched();
    80002392:	00000097          	auipc	ra,0x0
    80002396:	da6080e7          	jalr	-602(ra) # 80002138 <sched>
  p->chan = 0;
    8000239a:	0204b823          	sd	zero,48(s1)
    release(&p->lock);
    8000239e:	8526                	mv	a0,s1
    800023a0:	fffff097          	auipc	ra,0xfffff
    800023a4:	8fa080e7          	jalr	-1798(ra) # 80000c9a <release>
    acquire(lk);
    800023a8:	854a                	mv	a0,s2
    800023aa:	fffff097          	auipc	ra,0xfffff
    800023ae:	880080e7          	jalr	-1920(ra) # 80000c2a <acquire>
}
    800023b2:	70a2                	ld	ra,40(sp)
    800023b4:	7402                	ld	s0,32(sp)
    800023b6:	64e2                	ld	s1,24(sp)
    800023b8:	6942                	ld	s2,16(sp)
    800023ba:	69a2                	ld	s3,8(sp)
    800023bc:	6145                	addi	sp,sp,48
    800023be:	8082                	ret
  p->chan = chan;
    800023c0:	03353823          	sd	s3,48(a0)
  p->state = SLEEPING;
    800023c4:	4785                	li	a5,1
    800023c6:	d11c                	sw	a5,32(a0)
  sched();
    800023c8:	00000097          	auipc	ra,0x0
    800023cc:	d70080e7          	jalr	-656(ra) # 80002138 <sched>
  p->chan = 0;
    800023d0:	0204b823          	sd	zero,48(s1)
  if(lk != &p->lock){
    800023d4:	bff9                	j	800023b2 <sleep+0x5a>

00000000800023d6 <wait>:
{
    800023d6:	715d                	addi	sp,sp,-80
    800023d8:	e486                	sd	ra,72(sp)
    800023da:	e0a2                	sd	s0,64(sp)
    800023dc:	fc26                	sd	s1,56(sp)
    800023de:	f84a                	sd	s2,48(sp)
    800023e0:	f44e                	sd	s3,40(sp)
    800023e2:	f052                	sd	s4,32(sp)
    800023e4:	ec56                	sd	s5,24(sp)
    800023e6:	e85a                	sd	s6,16(sp)
    800023e8:	e45e                	sd	s7,8(sp)
    800023ea:	0880                	addi	s0,sp,80
    800023ec:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800023ee:	fffff097          	auipc	ra,0xfffff
    800023f2:	794080e7          	jalr	1940(ra) # 80001b82 <myproc>
    800023f6:	892a                	mv	s2,a0
  acquire(&p->lock);
    800023f8:	fffff097          	auipc	ra,0xfffff
    800023fc:	832080e7          	jalr	-1998(ra) # 80000c2a <acquire>
    havekids = 0;
    80002400:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002402:	4a11                	li	s4,4
        havekids = 1;
    80002404:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002406:	00018997          	auipc	s3,0x18
    8000240a:	57298993          	addi	s3,s3,1394 # 8001a978 <tickslock>
    havekids = 0;
    8000240e:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002410:	00013497          	auipc	s1,0x13
    80002414:	96848493          	addi	s1,s1,-1688 # 80014d78 <proc>
    80002418:	a08d                	j	8000247a <wait+0xa4>
          pid = np->pid;
    8000241a:	0404a983          	lw	s3,64(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000241e:	000b0e63          	beqz	s6,8000243a <wait+0x64>
    80002422:	4691                	li	a3,4
    80002424:	03c48613          	addi	a2,s1,60
    80002428:	85da                	mv	a1,s6
    8000242a:	05893503          	ld	a0,88(s2)
    8000242e:	fffff097          	auipc	ra,0xfffff
    80002432:	446080e7          	jalr	1094(ra) # 80001874 <copyout>
    80002436:	02054263          	bltz	a0,8000245a <wait+0x84>
          freeproc(np);
    8000243a:	8526                	mv	a0,s1
    8000243c:	00000097          	auipc	ra,0x0
    80002440:	962080e7          	jalr	-1694(ra) # 80001d9e <freeproc>
          release(&np->lock);
    80002444:	8526                	mv	a0,s1
    80002446:	fffff097          	auipc	ra,0xfffff
    8000244a:	854080e7          	jalr	-1964(ra) # 80000c9a <release>
          release(&p->lock);
    8000244e:	854a                	mv	a0,s2
    80002450:	fffff097          	auipc	ra,0xfffff
    80002454:	84a080e7          	jalr	-1974(ra) # 80000c9a <release>
          return pid;
    80002458:	a8a9                	j	800024b2 <wait+0xdc>
            release(&np->lock);
    8000245a:	8526                	mv	a0,s1
    8000245c:	fffff097          	auipc	ra,0xfffff
    80002460:	83e080e7          	jalr	-1986(ra) # 80000c9a <release>
            release(&p->lock);
    80002464:	854a                	mv	a0,s2
    80002466:	fffff097          	auipc	ra,0xfffff
    8000246a:	834080e7          	jalr	-1996(ra) # 80000c9a <release>
            return -1;
    8000246e:	59fd                	li	s3,-1
    80002470:	a089                	j	800024b2 <wait+0xdc>
    for(np = proc; np < &proc[NPROC]; np++){
    80002472:	17048493          	addi	s1,s1,368
    80002476:	03348463          	beq	s1,s3,8000249e <wait+0xc8>
      if(np->parent == p){
    8000247a:	749c                	ld	a5,40(s1)
    8000247c:	ff279be3          	bne	a5,s2,80002472 <wait+0x9c>
        acquire(&np->lock);
    80002480:	8526                	mv	a0,s1
    80002482:	ffffe097          	auipc	ra,0xffffe
    80002486:	7a8080e7          	jalr	1960(ra) # 80000c2a <acquire>
        if(np->state == ZOMBIE){
    8000248a:	509c                	lw	a5,32(s1)
    8000248c:	f94787e3          	beq	a5,s4,8000241a <wait+0x44>
        release(&np->lock);
    80002490:	8526                	mv	a0,s1
    80002492:	fffff097          	auipc	ra,0xfffff
    80002496:	808080e7          	jalr	-2040(ra) # 80000c9a <release>
        havekids = 1;
    8000249a:	8756                	mv	a4,s5
    8000249c:	bfd9                	j	80002472 <wait+0x9c>
    if(!havekids || p->killed){
    8000249e:	c701                	beqz	a4,800024a6 <wait+0xd0>
    800024a0:	03892783          	lw	a5,56(s2)
    800024a4:	c39d                	beqz	a5,800024ca <wait+0xf4>
      release(&p->lock);
    800024a6:	854a                	mv	a0,s2
    800024a8:	ffffe097          	auipc	ra,0xffffe
    800024ac:	7f2080e7          	jalr	2034(ra) # 80000c9a <release>
      return -1;
    800024b0:	59fd                	li	s3,-1
}
    800024b2:	854e                	mv	a0,s3
    800024b4:	60a6                	ld	ra,72(sp)
    800024b6:	6406                	ld	s0,64(sp)
    800024b8:	74e2                	ld	s1,56(sp)
    800024ba:	7942                	ld	s2,48(sp)
    800024bc:	79a2                	ld	s3,40(sp)
    800024be:	7a02                	ld	s4,32(sp)
    800024c0:	6ae2                	ld	s5,24(sp)
    800024c2:	6b42                	ld	s6,16(sp)
    800024c4:	6ba2                	ld	s7,8(sp)
    800024c6:	6161                	addi	sp,sp,80
    800024c8:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    800024ca:	85ca                	mv	a1,s2
    800024cc:	854a                	mv	a0,s2
    800024ce:	00000097          	auipc	ra,0x0
    800024d2:	e8a080e7          	jalr	-374(ra) # 80002358 <sleep>
    havekids = 0;
    800024d6:	bf25                	j	8000240e <wait+0x38>

00000000800024d8 <wakeup>:
{
    800024d8:	7139                	addi	sp,sp,-64
    800024da:	fc06                	sd	ra,56(sp)
    800024dc:	f822                	sd	s0,48(sp)
    800024de:	f426                	sd	s1,40(sp)
    800024e0:	f04a                	sd	s2,32(sp)
    800024e2:	ec4e                	sd	s3,24(sp)
    800024e4:	e852                	sd	s4,16(sp)
    800024e6:	e456                	sd	s5,8(sp)
    800024e8:	0080                	addi	s0,sp,64
    800024ea:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800024ec:	00013497          	auipc	s1,0x13
    800024f0:	88c48493          	addi	s1,s1,-1908 # 80014d78 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    800024f4:	4985                	li	s3,1
      p->state = RUNNABLE;
    800024f6:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    800024f8:	00018917          	auipc	s2,0x18
    800024fc:	48090913          	addi	s2,s2,1152 # 8001a978 <tickslock>
    80002500:	a811                	j	80002514 <wakeup+0x3c>
    release(&p->lock);
    80002502:	8526                	mv	a0,s1
    80002504:	ffffe097          	auipc	ra,0xffffe
    80002508:	796080e7          	jalr	1942(ra) # 80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000250c:	17048493          	addi	s1,s1,368
    80002510:	03248063          	beq	s1,s2,80002530 <wakeup+0x58>
    acquire(&p->lock);
    80002514:	8526                	mv	a0,s1
    80002516:	ffffe097          	auipc	ra,0xffffe
    8000251a:	714080e7          	jalr	1812(ra) # 80000c2a <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    8000251e:	509c                	lw	a5,32(s1)
    80002520:	ff3791e3          	bne	a5,s3,80002502 <wakeup+0x2a>
    80002524:	789c                	ld	a5,48(s1)
    80002526:	fd479ee3          	bne	a5,s4,80002502 <wakeup+0x2a>
      p->state = RUNNABLE;
    8000252a:	0354a023          	sw	s5,32(s1)
    8000252e:	bfd1                	j	80002502 <wakeup+0x2a>
}
    80002530:	70e2                	ld	ra,56(sp)
    80002532:	7442                	ld	s0,48(sp)
    80002534:	74a2                	ld	s1,40(sp)
    80002536:	7902                	ld	s2,32(sp)
    80002538:	69e2                	ld	s3,24(sp)
    8000253a:	6a42                	ld	s4,16(sp)
    8000253c:	6aa2                	ld	s5,8(sp)
    8000253e:	6121                	addi	sp,sp,64
    80002540:	8082                	ret

0000000080002542 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002542:	7179                	addi	sp,sp,-48
    80002544:	f406                	sd	ra,40(sp)
    80002546:	f022                	sd	s0,32(sp)
    80002548:	ec26                	sd	s1,24(sp)
    8000254a:	e84a                	sd	s2,16(sp)
    8000254c:	e44e                	sd	s3,8(sp)
    8000254e:	1800                	addi	s0,sp,48
    80002550:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002552:	00013497          	auipc	s1,0x13
    80002556:	82648493          	addi	s1,s1,-2010 # 80014d78 <proc>
    8000255a:	00018997          	auipc	s3,0x18
    8000255e:	41e98993          	addi	s3,s3,1054 # 8001a978 <tickslock>
    acquire(&p->lock);
    80002562:	8526                	mv	a0,s1
    80002564:	ffffe097          	auipc	ra,0xffffe
    80002568:	6c6080e7          	jalr	1734(ra) # 80000c2a <acquire>
    if(p->pid == pid){
    8000256c:	40bc                	lw	a5,64(s1)
    8000256e:	01278d63          	beq	a5,s2,80002588 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002572:	8526                	mv	a0,s1
    80002574:	ffffe097          	auipc	ra,0xffffe
    80002578:	726080e7          	jalr	1830(ra) # 80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000257c:	17048493          	addi	s1,s1,368
    80002580:	ff3491e3          	bne	s1,s3,80002562 <kill+0x20>
  }
  return -1;
    80002584:	557d                	li	a0,-1
    80002586:	a821                	j	8000259e <kill+0x5c>
      p->killed = 1;
    80002588:	4785                	li	a5,1
    8000258a:	dc9c                	sw	a5,56(s1)
      if(p->state == SLEEPING){
    8000258c:	5098                	lw	a4,32(s1)
    8000258e:	00f70f63          	beq	a4,a5,800025ac <kill+0x6a>
      release(&p->lock);
    80002592:	8526                	mv	a0,s1
    80002594:	ffffe097          	auipc	ra,0xffffe
    80002598:	706080e7          	jalr	1798(ra) # 80000c9a <release>
      return 0;
    8000259c:	4501                	li	a0,0
}
    8000259e:	70a2                	ld	ra,40(sp)
    800025a0:	7402                	ld	s0,32(sp)
    800025a2:	64e2                	ld	s1,24(sp)
    800025a4:	6942                	ld	s2,16(sp)
    800025a6:	69a2                	ld	s3,8(sp)
    800025a8:	6145                	addi	sp,sp,48
    800025aa:	8082                	ret
        p->state = RUNNABLE;
    800025ac:	4789                	li	a5,2
    800025ae:	d09c                	sw	a5,32(s1)
    800025b0:	b7cd                	j	80002592 <kill+0x50>

00000000800025b2 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800025b2:	7179                	addi	sp,sp,-48
    800025b4:	f406                	sd	ra,40(sp)
    800025b6:	f022                	sd	s0,32(sp)
    800025b8:	ec26                	sd	s1,24(sp)
    800025ba:	e84a                	sd	s2,16(sp)
    800025bc:	e44e                	sd	s3,8(sp)
    800025be:	e052                	sd	s4,0(sp)
    800025c0:	1800                	addi	s0,sp,48
    800025c2:	84aa                	mv	s1,a0
    800025c4:	892e                	mv	s2,a1
    800025c6:	89b2                	mv	s3,a2
    800025c8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800025ca:	fffff097          	auipc	ra,0xfffff
    800025ce:	5b8080e7          	jalr	1464(ra) # 80001b82 <myproc>
  if(user_dst){
    800025d2:	c08d                	beqz	s1,800025f4 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800025d4:	86d2                	mv	a3,s4
    800025d6:	864e                	mv	a2,s3
    800025d8:	85ca                	mv	a1,s2
    800025da:	6d28                	ld	a0,88(a0)
    800025dc:	fffff097          	auipc	ra,0xfffff
    800025e0:	298080e7          	jalr	664(ra) # 80001874 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800025e4:	70a2                	ld	ra,40(sp)
    800025e6:	7402                	ld	s0,32(sp)
    800025e8:	64e2                	ld	s1,24(sp)
    800025ea:	6942                	ld	s2,16(sp)
    800025ec:	69a2                	ld	s3,8(sp)
    800025ee:	6a02                	ld	s4,0(sp)
    800025f0:	6145                	addi	sp,sp,48
    800025f2:	8082                	ret
    memmove((char *)dst, src, len);
    800025f4:	000a061b          	sext.w	a2,s4
    800025f8:	85ce                	mv	a1,s3
    800025fa:	854a                	mv	a0,s2
    800025fc:	fffff097          	auipc	ra,0xfffff
    80002600:	8f8080e7          	jalr	-1800(ra) # 80000ef4 <memmove>
    return 0;
    80002604:	8526                	mv	a0,s1
    80002606:	bff9                	j	800025e4 <either_copyout+0x32>

0000000080002608 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002608:	7179                	addi	sp,sp,-48
    8000260a:	f406                	sd	ra,40(sp)
    8000260c:	f022                	sd	s0,32(sp)
    8000260e:	ec26                	sd	s1,24(sp)
    80002610:	e84a                	sd	s2,16(sp)
    80002612:	e44e                	sd	s3,8(sp)
    80002614:	e052                	sd	s4,0(sp)
    80002616:	1800                	addi	s0,sp,48
    80002618:	892a                	mv	s2,a0
    8000261a:	84ae                	mv	s1,a1
    8000261c:	89b2                	mv	s3,a2
    8000261e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002620:	fffff097          	auipc	ra,0xfffff
    80002624:	562080e7          	jalr	1378(ra) # 80001b82 <myproc>
  if(user_src){
    80002628:	c08d                	beqz	s1,8000264a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000262a:	86d2                	mv	a3,s4
    8000262c:	864e                	mv	a2,s3
    8000262e:	85ca                	mv	a1,s2
    80002630:	6d28                	ld	a0,88(a0)
    80002632:	fffff097          	auipc	ra,0xfffff
    80002636:	2ce080e7          	jalr	718(ra) # 80001900 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000263a:	70a2                	ld	ra,40(sp)
    8000263c:	7402                	ld	s0,32(sp)
    8000263e:	64e2                	ld	s1,24(sp)
    80002640:	6942                	ld	s2,16(sp)
    80002642:	69a2                	ld	s3,8(sp)
    80002644:	6a02                	ld	s4,0(sp)
    80002646:	6145                	addi	sp,sp,48
    80002648:	8082                	ret
    memmove(dst, (char*)src, len);
    8000264a:	000a061b          	sext.w	a2,s4
    8000264e:	85ce                	mv	a1,s3
    80002650:	854a                	mv	a0,s2
    80002652:	fffff097          	auipc	ra,0xfffff
    80002656:	8a2080e7          	jalr	-1886(ra) # 80000ef4 <memmove>
    return 0;
    8000265a:	8526                	mv	a0,s1
    8000265c:	bff9                	j	8000263a <either_copyin+0x32>

000000008000265e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000265e:	715d                	addi	sp,sp,-80
    80002660:	e486                	sd	ra,72(sp)
    80002662:	e0a2                	sd	s0,64(sp)
    80002664:	fc26                	sd	s1,56(sp)
    80002666:	f84a                	sd	s2,48(sp)
    80002668:	f44e                	sd	s3,40(sp)
    8000266a:	f052                	sd	s4,32(sp)
    8000266c:	ec56                	sd	s5,24(sp)
    8000266e:	e85a                	sd	s6,16(sp)
    80002670:	e45e                	sd	s7,8(sp)
    80002672:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002674:	00006517          	auipc	a0,0x6
    80002678:	c1c50513          	addi	a0,a0,-996 # 80008290 <userret+0x200>
    8000267c:	ffffe097          	auipc	ra,0xffffe
    80002680:	f26080e7          	jalr	-218(ra) # 800005a2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002684:	00013497          	auipc	s1,0x13
    80002688:	85448493          	addi	s1,s1,-1964 # 80014ed8 <proc+0x160>
    8000268c:	00018917          	auipc	s2,0x18
    80002690:	44c90913          	addi	s2,s2,1100 # 8001aad8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002694:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    80002696:	00006997          	auipc	s3,0x6
    8000269a:	e2a98993          	addi	s3,s3,-470 # 800084c0 <userret+0x430>
    printf("%d %s %s", p->pid, state, p->name);
    8000269e:	00006a97          	auipc	s5,0x6
    800026a2:	e2aa8a93          	addi	s5,s5,-470 # 800084c8 <userret+0x438>
    printf("\n");
    800026a6:	00006a17          	auipc	s4,0x6
    800026aa:	beaa0a13          	addi	s4,s4,-1046 # 80008290 <userret+0x200>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026ae:	00006b97          	auipc	s7,0x6
    800026b2:	41ab8b93          	addi	s7,s7,1050 # 80008ac8 <states.0>
    800026b6:	a00d                	j	800026d8 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800026b8:	ee06a583          	lw	a1,-288(a3)
    800026bc:	8556                	mv	a0,s5
    800026be:	ffffe097          	auipc	ra,0xffffe
    800026c2:	ee4080e7          	jalr	-284(ra) # 800005a2 <printf>
    printf("\n");
    800026c6:	8552                	mv	a0,s4
    800026c8:	ffffe097          	auipc	ra,0xffffe
    800026cc:	eda080e7          	jalr	-294(ra) # 800005a2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800026d0:	17048493          	addi	s1,s1,368
    800026d4:	03248263          	beq	s1,s2,800026f8 <procdump+0x9a>
    if(p->state == UNUSED)
    800026d8:	86a6                	mv	a3,s1
    800026da:	ec04a783          	lw	a5,-320(s1)
    800026de:	dbed                	beqz	a5,800026d0 <procdump+0x72>
      state = "???";
    800026e0:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026e2:	fcfb6be3          	bltu	s6,a5,800026b8 <procdump+0x5a>
    800026e6:	02079713          	slli	a4,a5,0x20
    800026ea:	01d75793          	srli	a5,a4,0x1d
    800026ee:	97de                	add	a5,a5,s7
    800026f0:	6390                	ld	a2,0(a5)
    800026f2:	f279                	bnez	a2,800026b8 <procdump+0x5a>
      state = "???";
    800026f4:	864e                	mv	a2,s3
    800026f6:	b7c9                	j	800026b8 <procdump+0x5a>
  }
}
    800026f8:	60a6                	ld	ra,72(sp)
    800026fa:	6406                	ld	s0,64(sp)
    800026fc:	74e2                	ld	s1,56(sp)
    800026fe:	7942                	ld	s2,48(sp)
    80002700:	79a2                	ld	s3,40(sp)
    80002702:	7a02                	ld	s4,32(sp)
    80002704:	6ae2                	ld	s5,24(sp)
    80002706:	6b42                	ld	s6,16(sp)
    80002708:	6ba2                	ld	s7,8(sp)
    8000270a:	6161                	addi	sp,sp,80
    8000270c:	8082                	ret

000000008000270e <swtch>:
    8000270e:	00153023          	sd	ra,0(a0)
    80002712:	00253423          	sd	sp,8(a0)
    80002716:	e900                	sd	s0,16(a0)
    80002718:	ed04                	sd	s1,24(a0)
    8000271a:	03253023          	sd	s2,32(a0)
    8000271e:	03353423          	sd	s3,40(a0)
    80002722:	03453823          	sd	s4,48(a0)
    80002726:	03553c23          	sd	s5,56(a0)
    8000272a:	05653023          	sd	s6,64(a0)
    8000272e:	05753423          	sd	s7,72(a0)
    80002732:	05853823          	sd	s8,80(a0)
    80002736:	05953c23          	sd	s9,88(a0)
    8000273a:	07a53023          	sd	s10,96(a0)
    8000273e:	07b53423          	sd	s11,104(a0)
    80002742:	0005b083          	ld	ra,0(a1)
    80002746:	0085b103          	ld	sp,8(a1)
    8000274a:	6980                	ld	s0,16(a1)
    8000274c:	6d84                	ld	s1,24(a1)
    8000274e:	0205b903          	ld	s2,32(a1)
    80002752:	0285b983          	ld	s3,40(a1)
    80002756:	0305ba03          	ld	s4,48(a1)
    8000275a:	0385ba83          	ld	s5,56(a1)
    8000275e:	0405bb03          	ld	s6,64(a1)
    80002762:	0485bb83          	ld	s7,72(a1)
    80002766:	0505bc03          	ld	s8,80(a1)
    8000276a:	0585bc83          	ld	s9,88(a1)
    8000276e:	0605bd03          	ld	s10,96(a1)
    80002772:	0685bd83          	ld	s11,104(a1)
    80002776:	8082                	ret

0000000080002778 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002778:	1141                	addi	sp,sp,-16
    8000277a:	e406                	sd	ra,8(sp)
    8000277c:	e022                	sd	s0,0(sp)
    8000277e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002780:	00006597          	auipc	a1,0x6
    80002784:	d8058593          	addi	a1,a1,-640 # 80008500 <userret+0x470>
    80002788:	00018517          	auipc	a0,0x18
    8000278c:	1f050513          	addi	a0,a0,496 # 8001a978 <tickslock>
    80002790:	ffffe097          	auipc	ra,0xffffe
    80002794:	34c080e7          	jalr	844(ra) # 80000adc <initlock>
}
    80002798:	60a2                	ld	ra,8(sp)
    8000279a:	6402                	ld	s0,0(sp)
    8000279c:	0141                	addi	sp,sp,16
    8000279e:	8082                	ret

00000000800027a0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800027a0:	1141                	addi	sp,sp,-16
    800027a2:	e422                	sd	s0,8(sp)
    800027a4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027a6:	00003797          	auipc	a5,0x3
    800027aa:	6fa78793          	addi	a5,a5,1786 # 80005ea0 <kernelvec>
    800027ae:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800027b2:	6422                	ld	s0,8(sp)
    800027b4:	0141                	addi	sp,sp,16
    800027b6:	8082                	ret

00000000800027b8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800027b8:	1141                	addi	sp,sp,-16
    800027ba:	e406                	sd	ra,8(sp)
    800027bc:	e022                	sd	s0,0(sp)
    800027be:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800027c0:	fffff097          	auipc	ra,0xfffff
    800027c4:	3c2080e7          	jalr	962(ra) # 80001b82 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800027cc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027ce:	10079073          	csrw	sstatus,a5
  // turn off interrupts, since we're switching
  // now from kerneltrap() to usertrap().
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    800027d2:	00006617          	auipc	a2,0x6
    800027d6:	82e60613          	addi	a2,a2,-2002 # 80008000 <trampoline>
    800027da:	00006697          	auipc	a3,0x6
    800027de:	82668693          	addi	a3,a3,-2010 # 80008000 <trampoline>
    800027e2:	8e91                	sub	a3,a3,a2
    800027e4:	040007b7          	lui	a5,0x4000
    800027e8:	17fd                	addi	a5,a5,-1
    800027ea:	07b2                	slli	a5,a5,0xc
    800027ec:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027ee:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->tf->kernel_satp = r_satp();         // kernel page table
    800027f2:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800027f4:	180026f3          	csrr	a3,satp
    800027f8:	e314                	sd	a3,0(a4)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800027fa:	7138                	ld	a4,96(a0)
    800027fc:	6534                	ld	a3,72(a0)
    800027fe:	6585                	lui	a1,0x1
    80002800:	96ae                	add	a3,a3,a1
    80002802:	e714                	sd	a3,8(a4)
  p->tf->kernel_trap = (uint64)usertrap;
    80002804:	7138                	ld	a4,96(a0)
    80002806:	00000697          	auipc	a3,0x0
    8000280a:	12868693          	addi	a3,a3,296 # 8000292e <usertrap>
    8000280e:	eb14                	sd	a3,16(a4)
  p->tf->kernel_hartid = r_tp();         // hartid for cpuid()
    80002810:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002812:	8692                	mv	a3,tp
    80002814:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002816:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000281a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000281e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002822:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->tf->epc);
    80002826:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002828:	6f18                	ld	a4,24(a4)
    8000282a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000282e:	6d2c                	ld	a1,88(a0)
    80002830:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002832:	00006717          	auipc	a4,0x6
    80002836:	85e70713          	addi	a4,a4,-1954 # 80008090 <userret>
    8000283a:	8f11                	sub	a4,a4,a2
    8000283c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    8000283e:	577d                	li	a4,-1
    80002840:	177e                	slli	a4,a4,0x3f
    80002842:	8dd9                	or	a1,a1,a4
    80002844:	02000537          	lui	a0,0x2000
    80002848:	157d                	addi	a0,a0,-1
    8000284a:	0536                	slli	a0,a0,0xd
    8000284c:	9782                	jalr	a5
}
    8000284e:	60a2                	ld	ra,8(sp)
    80002850:	6402                	ld	s0,0(sp)
    80002852:	0141                	addi	sp,sp,16
    80002854:	8082                	ret

0000000080002856 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002856:	1101                	addi	sp,sp,-32
    80002858:	ec06                	sd	ra,24(sp)
    8000285a:	e822                	sd	s0,16(sp)
    8000285c:	e426                	sd	s1,8(sp)
    8000285e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002860:	00018497          	auipc	s1,0x18
    80002864:	11848493          	addi	s1,s1,280 # 8001a978 <tickslock>
    80002868:	8526                	mv	a0,s1
    8000286a:	ffffe097          	auipc	ra,0xffffe
    8000286e:	3c0080e7          	jalr	960(ra) # 80000c2a <acquire>
  ticks++;
    80002872:	0002d517          	auipc	a0,0x2d
    80002876:	7ce50513          	addi	a0,a0,1998 # 80030040 <ticks>
    8000287a:	411c                	lw	a5,0(a0)
    8000287c:	2785                	addiw	a5,a5,1
    8000287e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002880:	00000097          	auipc	ra,0x0
    80002884:	c58080e7          	jalr	-936(ra) # 800024d8 <wakeup>
  release(&tickslock);
    80002888:	8526                	mv	a0,s1
    8000288a:	ffffe097          	auipc	ra,0xffffe
    8000288e:	410080e7          	jalr	1040(ra) # 80000c9a <release>
}
    80002892:	60e2                	ld	ra,24(sp)
    80002894:	6442                	ld	s0,16(sp)
    80002896:	64a2                	ld	s1,8(sp)
    80002898:	6105                	addi	sp,sp,32
    8000289a:	8082                	ret

000000008000289c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000289c:	1101                	addi	sp,sp,-32
    8000289e:	ec06                	sd	ra,24(sp)
    800028a0:	e822                	sd	s0,16(sp)
    800028a2:	e426                	sd	s1,8(sp)
    800028a4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028a6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800028aa:	00074d63          	bltz	a4,800028c4 <devintr+0x28>
      virtio_disk_intr(irq - VIRTIO0_IRQ);
    }

    plic_complete(irq);
    return 1;
  } else if(scause == 0x8000000000000001L){
    800028ae:	57fd                	li	a5,-1
    800028b0:	17fe                	slli	a5,a5,0x3f
    800028b2:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800028b4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800028b6:	04f70b63          	beq	a4,a5,8000290c <devintr+0x70>
  }
}
    800028ba:	60e2                	ld	ra,24(sp)
    800028bc:	6442                	ld	s0,16(sp)
    800028be:	64a2                	ld	s1,8(sp)
    800028c0:	6105                	addi	sp,sp,32
    800028c2:	8082                	ret
     (scause & 0xff) == 9){
    800028c4:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    800028c8:	46a5                	li	a3,9
    800028ca:	fed792e3          	bne	a5,a3,800028ae <devintr+0x12>
    int irq = plic_claim();
    800028ce:	00003097          	auipc	ra,0x3
    800028d2:	6da080e7          	jalr	1754(ra) # 80005fa8 <plic_claim>
    800028d6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800028d8:	47a9                	li	a5,10
    800028da:	00f50e63          	beq	a0,a5,800028f6 <devintr+0x5a>
    } else if(irq == VIRTIO0_IRQ || irq == VIRTIO1_IRQ ){
    800028de:	fff5079b          	addiw	a5,a0,-1
    800028e2:	4705                	li	a4,1
    800028e4:	00f77e63          	bgeu	a4,a5,80002900 <devintr+0x64>
    plic_complete(irq);
    800028e8:	8526                	mv	a0,s1
    800028ea:	00003097          	auipc	ra,0x3
    800028ee:	6e2080e7          	jalr	1762(ra) # 80005fcc <plic_complete>
    return 1;
    800028f2:	4505                	li	a0,1
    800028f4:	b7d9                	j	800028ba <devintr+0x1e>
      uartintr();
    800028f6:	ffffe097          	auipc	ra,0xffffe
    800028fa:	f42080e7          	jalr	-190(ra) # 80000838 <uartintr>
    800028fe:	b7ed                	j	800028e8 <devintr+0x4c>
      virtio_disk_intr(irq - VIRTIO0_IRQ);
    80002900:	853e                	mv	a0,a5
    80002902:	00004097          	auipc	ra,0x4
    80002906:	c74080e7          	jalr	-908(ra) # 80006576 <virtio_disk_intr>
    8000290a:	bff9                	j	800028e8 <devintr+0x4c>
    if(cpuid() == 0){
    8000290c:	fffff097          	auipc	ra,0xfffff
    80002910:	24a080e7          	jalr	586(ra) # 80001b56 <cpuid>
    80002914:	c901                	beqz	a0,80002924 <devintr+0x88>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002916:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000291a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000291c:	14479073          	csrw	sip,a5
    return 2;
    80002920:	4509                	li	a0,2
    80002922:	bf61                	j	800028ba <devintr+0x1e>
      clockintr();
    80002924:	00000097          	auipc	ra,0x0
    80002928:	f32080e7          	jalr	-206(ra) # 80002856 <clockintr>
    8000292c:	b7ed                	j	80002916 <devintr+0x7a>

000000008000292e <usertrap>:
{
    8000292e:	1101                	addi	sp,sp,-32
    80002930:	ec06                	sd	ra,24(sp)
    80002932:	e822                	sd	s0,16(sp)
    80002934:	e426                	sd	s1,8(sp)
    80002936:	e04a                	sd	s2,0(sp)
    80002938:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000293a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000293e:	1007f793          	andi	a5,a5,256
    80002942:	e7bd                	bnez	a5,800029b0 <usertrap+0x82>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002944:	00003797          	auipc	a5,0x3
    80002948:	55c78793          	addi	a5,a5,1372 # 80005ea0 <kernelvec>
    8000294c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002950:	fffff097          	auipc	ra,0xfffff
    80002954:	232080e7          	jalr	562(ra) # 80001b82 <myproc>
    80002958:	84aa                	mv	s1,a0
  p->tf->epc = r_sepc();
    8000295a:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000295c:	14102773          	csrr	a4,sepc
    80002960:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002962:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002966:	47a1                	li	a5,8
    80002968:	06f71263          	bne	a4,a5,800029cc <usertrap+0x9e>
    if(p->killed)
    8000296c:	5d1c                	lw	a5,56(a0)
    8000296e:	eba9                	bnez	a5,800029c0 <usertrap+0x92>
    p->tf->epc += 4;
    80002970:	70b8                	ld	a4,96(s1)
    80002972:	6f1c                	ld	a5,24(a4)
    80002974:	0791                	addi	a5,a5,4
    80002976:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sie" : "=r" (x) );
    80002978:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000297c:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80002980:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002984:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002988:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000298c:	10079073          	csrw	sstatus,a5
    syscall();
    80002990:	00000097          	auipc	ra,0x0
    80002994:	2e0080e7          	jalr	736(ra) # 80002c70 <syscall>
  if(p->killed)
    80002998:	5c9c                	lw	a5,56(s1)
    8000299a:	ebc1                	bnez	a5,80002a2a <usertrap+0xfc>
  usertrapret();
    8000299c:	00000097          	auipc	ra,0x0
    800029a0:	e1c080e7          	jalr	-484(ra) # 800027b8 <usertrapret>
}
    800029a4:	60e2                	ld	ra,24(sp)
    800029a6:	6442                	ld	s0,16(sp)
    800029a8:	64a2                	ld	s1,8(sp)
    800029aa:	6902                	ld	s2,0(sp)
    800029ac:	6105                	addi	sp,sp,32
    800029ae:	8082                	ret
    panic("usertrap: not from user mode");
    800029b0:	00006517          	auipc	a0,0x6
    800029b4:	b5850513          	addi	a0,a0,-1192 # 80008508 <userret+0x478>
    800029b8:	ffffe097          	auipc	ra,0xffffe
    800029bc:	b90080e7          	jalr	-1136(ra) # 80000548 <panic>
      exit(-1);
    800029c0:	557d                	li	a0,-1
    800029c2:	00000097          	auipc	ra,0x0
    800029c6:	84c080e7          	jalr	-1972(ra) # 8000220e <exit>
    800029ca:	b75d                	j	80002970 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    800029cc:	00000097          	auipc	ra,0x0
    800029d0:	ed0080e7          	jalr	-304(ra) # 8000289c <devintr>
    800029d4:	892a                	mv	s2,a0
    800029d6:	c501                	beqz	a0,800029de <usertrap+0xb0>
  if(p->killed)
    800029d8:	5c9c                	lw	a5,56(s1)
    800029da:	c3a1                	beqz	a5,80002a1a <usertrap+0xec>
    800029dc:	a815                	j	80002a10 <usertrap+0xe2>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029de:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800029e2:	40b0                	lw	a2,64(s1)
    800029e4:	00006517          	auipc	a0,0x6
    800029e8:	b4450513          	addi	a0,a0,-1212 # 80008528 <userret+0x498>
    800029ec:	ffffe097          	auipc	ra,0xffffe
    800029f0:	bb6080e7          	jalr	-1098(ra) # 800005a2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029f4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029f8:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800029fc:	00006517          	auipc	a0,0x6
    80002a00:	b5c50513          	addi	a0,a0,-1188 # 80008558 <userret+0x4c8>
    80002a04:	ffffe097          	auipc	ra,0xffffe
    80002a08:	b9e080e7          	jalr	-1122(ra) # 800005a2 <printf>
    p->killed = 1;
    80002a0c:	4785                	li	a5,1
    80002a0e:	dc9c                	sw	a5,56(s1)
    exit(-1);
    80002a10:	557d                	li	a0,-1
    80002a12:	fffff097          	auipc	ra,0xfffff
    80002a16:	7fc080e7          	jalr	2044(ra) # 8000220e <exit>
  if(which_dev == 2)
    80002a1a:	4789                	li	a5,2
    80002a1c:	f8f910e3          	bne	s2,a5,8000299c <usertrap+0x6e>
    yield();
    80002a20:	00000097          	auipc	ra,0x0
    80002a24:	8fc080e7          	jalr	-1796(ra) # 8000231c <yield>
    80002a28:	bf95                	j	8000299c <usertrap+0x6e>
  int which_dev = 0;
    80002a2a:	4901                	li	s2,0
    80002a2c:	b7d5                	j	80002a10 <usertrap+0xe2>

0000000080002a2e <kerneltrap>:
{
    80002a2e:	7179                	addi	sp,sp,-48
    80002a30:	f406                	sd	ra,40(sp)
    80002a32:	f022                	sd	s0,32(sp)
    80002a34:	ec26                	sd	s1,24(sp)
    80002a36:	e84a                	sd	s2,16(sp)
    80002a38:	e44e                	sd	s3,8(sp)
    80002a3a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a3c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a40:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a44:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002a48:	1004f793          	andi	a5,s1,256
    80002a4c:	cb85                	beqz	a5,80002a7c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a4e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002a52:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002a54:	ef85                	bnez	a5,80002a8c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002a56:	00000097          	auipc	ra,0x0
    80002a5a:	e46080e7          	jalr	-442(ra) # 8000289c <devintr>
    80002a5e:	cd1d                	beqz	a0,80002a9c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a60:	4789                	li	a5,2
    80002a62:	06f50a63          	beq	a0,a5,80002ad6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a66:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a6a:	10049073          	csrw	sstatus,s1
}
    80002a6e:	70a2                	ld	ra,40(sp)
    80002a70:	7402                	ld	s0,32(sp)
    80002a72:	64e2                	ld	s1,24(sp)
    80002a74:	6942                	ld	s2,16(sp)
    80002a76:	69a2                	ld	s3,8(sp)
    80002a78:	6145                	addi	sp,sp,48
    80002a7a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002a7c:	00006517          	auipc	a0,0x6
    80002a80:	afc50513          	addi	a0,a0,-1284 # 80008578 <userret+0x4e8>
    80002a84:	ffffe097          	auipc	ra,0xffffe
    80002a88:	ac4080e7          	jalr	-1340(ra) # 80000548 <panic>
    panic("kerneltrap: interrupts enabled");
    80002a8c:	00006517          	auipc	a0,0x6
    80002a90:	b1450513          	addi	a0,a0,-1260 # 800085a0 <userret+0x510>
    80002a94:	ffffe097          	auipc	ra,0xffffe
    80002a98:	ab4080e7          	jalr	-1356(ra) # 80000548 <panic>
    printf("scause %p\n", scause);
    80002a9c:	85ce                	mv	a1,s3
    80002a9e:	00006517          	auipc	a0,0x6
    80002aa2:	b2250513          	addi	a0,a0,-1246 # 800085c0 <userret+0x530>
    80002aa6:	ffffe097          	auipc	ra,0xffffe
    80002aaa:	afc080e7          	jalr	-1284(ra) # 800005a2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002aae:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ab2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002ab6:	00006517          	auipc	a0,0x6
    80002aba:	b1a50513          	addi	a0,a0,-1254 # 800085d0 <userret+0x540>
    80002abe:	ffffe097          	auipc	ra,0xffffe
    80002ac2:	ae4080e7          	jalr	-1308(ra) # 800005a2 <printf>
    panic("kerneltrap");
    80002ac6:	00006517          	auipc	a0,0x6
    80002aca:	b2250513          	addi	a0,a0,-1246 # 800085e8 <userret+0x558>
    80002ace:	ffffe097          	auipc	ra,0xffffe
    80002ad2:	a7a080e7          	jalr	-1414(ra) # 80000548 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002ad6:	fffff097          	auipc	ra,0xfffff
    80002ada:	0ac080e7          	jalr	172(ra) # 80001b82 <myproc>
    80002ade:	d541                	beqz	a0,80002a66 <kerneltrap+0x38>
    80002ae0:	fffff097          	auipc	ra,0xfffff
    80002ae4:	0a2080e7          	jalr	162(ra) # 80001b82 <myproc>
    80002ae8:	5118                	lw	a4,32(a0)
    80002aea:	478d                	li	a5,3
    80002aec:	f6f71de3          	bne	a4,a5,80002a66 <kerneltrap+0x38>
    yield();
    80002af0:	00000097          	auipc	ra,0x0
    80002af4:	82c080e7          	jalr	-2004(ra) # 8000231c <yield>
    80002af8:	b7bd                	j	80002a66 <kerneltrap+0x38>

0000000080002afa <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002afa:	1101                	addi	sp,sp,-32
    80002afc:	ec06                	sd	ra,24(sp)
    80002afe:	e822                	sd	s0,16(sp)
    80002b00:	e426                	sd	s1,8(sp)
    80002b02:	1000                	addi	s0,sp,32
    80002b04:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002b06:	fffff097          	auipc	ra,0xfffff
    80002b0a:	07c080e7          	jalr	124(ra) # 80001b82 <myproc>
  switch (n) {
    80002b0e:	4795                	li	a5,5
    80002b10:	0497e163          	bltu	a5,s1,80002b52 <argraw+0x58>
    80002b14:	048a                	slli	s1,s1,0x2
    80002b16:	00006717          	auipc	a4,0x6
    80002b1a:	fda70713          	addi	a4,a4,-38 # 80008af0 <states.0+0x28>
    80002b1e:	94ba                	add	s1,s1,a4
    80002b20:	409c                	lw	a5,0(s1)
    80002b22:	97ba                	add	a5,a5,a4
    80002b24:	8782                	jr	a5
  case 0:
    return p->tf->a0;
    80002b26:	713c                	ld	a5,96(a0)
    80002b28:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
    80002b2a:	60e2                	ld	ra,24(sp)
    80002b2c:	6442                	ld	s0,16(sp)
    80002b2e:	64a2                	ld	s1,8(sp)
    80002b30:	6105                	addi	sp,sp,32
    80002b32:	8082                	ret
    return p->tf->a1;
    80002b34:	713c                	ld	a5,96(a0)
    80002b36:	7fa8                	ld	a0,120(a5)
    80002b38:	bfcd                	j	80002b2a <argraw+0x30>
    return p->tf->a2;
    80002b3a:	713c                	ld	a5,96(a0)
    80002b3c:	63c8                	ld	a0,128(a5)
    80002b3e:	b7f5                	j	80002b2a <argraw+0x30>
    return p->tf->a3;
    80002b40:	713c                	ld	a5,96(a0)
    80002b42:	67c8                	ld	a0,136(a5)
    80002b44:	b7dd                	j	80002b2a <argraw+0x30>
    return p->tf->a4;
    80002b46:	713c                	ld	a5,96(a0)
    80002b48:	6bc8                	ld	a0,144(a5)
    80002b4a:	b7c5                	j	80002b2a <argraw+0x30>
    return p->tf->a5;
    80002b4c:	713c                	ld	a5,96(a0)
    80002b4e:	6fc8                	ld	a0,152(a5)
    80002b50:	bfe9                	j	80002b2a <argraw+0x30>
  panic("argraw");
    80002b52:	00006517          	auipc	a0,0x6
    80002b56:	aa650513          	addi	a0,a0,-1370 # 800085f8 <userret+0x568>
    80002b5a:	ffffe097          	auipc	ra,0xffffe
    80002b5e:	9ee080e7          	jalr	-1554(ra) # 80000548 <panic>

0000000080002b62 <fetchaddr>:
{
    80002b62:	1101                	addi	sp,sp,-32
    80002b64:	ec06                	sd	ra,24(sp)
    80002b66:	e822                	sd	s0,16(sp)
    80002b68:	e426                	sd	s1,8(sp)
    80002b6a:	e04a                	sd	s2,0(sp)
    80002b6c:	1000                	addi	s0,sp,32
    80002b6e:	84aa                	mv	s1,a0
    80002b70:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002b72:	fffff097          	auipc	ra,0xfffff
    80002b76:	010080e7          	jalr	16(ra) # 80001b82 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002b7a:	693c                	ld	a5,80(a0)
    80002b7c:	02f4f863          	bgeu	s1,a5,80002bac <fetchaddr+0x4a>
    80002b80:	00848713          	addi	a4,s1,8
    80002b84:	02e7e663          	bltu	a5,a4,80002bb0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002b88:	46a1                	li	a3,8
    80002b8a:	8626                	mv	a2,s1
    80002b8c:	85ca                	mv	a1,s2
    80002b8e:	6d28                	ld	a0,88(a0)
    80002b90:	fffff097          	auipc	ra,0xfffff
    80002b94:	d70080e7          	jalr	-656(ra) # 80001900 <copyin>
    80002b98:	00a03533          	snez	a0,a0
    80002b9c:	40a00533          	neg	a0,a0
}
    80002ba0:	60e2                	ld	ra,24(sp)
    80002ba2:	6442                	ld	s0,16(sp)
    80002ba4:	64a2                	ld	s1,8(sp)
    80002ba6:	6902                	ld	s2,0(sp)
    80002ba8:	6105                	addi	sp,sp,32
    80002baa:	8082                	ret
    return -1;
    80002bac:	557d                	li	a0,-1
    80002bae:	bfcd                	j	80002ba0 <fetchaddr+0x3e>
    80002bb0:	557d                	li	a0,-1
    80002bb2:	b7fd                	j	80002ba0 <fetchaddr+0x3e>

0000000080002bb4 <fetchstr>:
{
    80002bb4:	7179                	addi	sp,sp,-48
    80002bb6:	f406                	sd	ra,40(sp)
    80002bb8:	f022                	sd	s0,32(sp)
    80002bba:	ec26                	sd	s1,24(sp)
    80002bbc:	e84a                	sd	s2,16(sp)
    80002bbe:	e44e                	sd	s3,8(sp)
    80002bc0:	1800                	addi	s0,sp,48
    80002bc2:	892a                	mv	s2,a0
    80002bc4:	84ae                	mv	s1,a1
    80002bc6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002bc8:	fffff097          	auipc	ra,0xfffff
    80002bcc:	fba080e7          	jalr	-70(ra) # 80001b82 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002bd0:	86ce                	mv	a3,s3
    80002bd2:	864a                	mv	a2,s2
    80002bd4:	85a6                	mv	a1,s1
    80002bd6:	6d28                	ld	a0,88(a0)
    80002bd8:	fffff097          	auipc	ra,0xfffff
    80002bdc:	db6080e7          	jalr	-586(ra) # 8000198e <copyinstr>
  if(err < 0)
    80002be0:	00054763          	bltz	a0,80002bee <fetchstr+0x3a>
  return strlen(buf);
    80002be4:	8526                	mv	a0,s1
    80002be6:	ffffe097          	auipc	ra,0xffffe
    80002bea:	436080e7          	jalr	1078(ra) # 8000101c <strlen>
}
    80002bee:	70a2                	ld	ra,40(sp)
    80002bf0:	7402                	ld	s0,32(sp)
    80002bf2:	64e2                	ld	s1,24(sp)
    80002bf4:	6942                	ld	s2,16(sp)
    80002bf6:	69a2                	ld	s3,8(sp)
    80002bf8:	6145                	addi	sp,sp,48
    80002bfa:	8082                	ret

0000000080002bfc <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002bfc:	1101                	addi	sp,sp,-32
    80002bfe:	ec06                	sd	ra,24(sp)
    80002c00:	e822                	sd	s0,16(sp)
    80002c02:	e426                	sd	s1,8(sp)
    80002c04:	1000                	addi	s0,sp,32
    80002c06:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c08:	00000097          	auipc	ra,0x0
    80002c0c:	ef2080e7          	jalr	-270(ra) # 80002afa <argraw>
    80002c10:	c088                	sw	a0,0(s1)
  return 0;
}
    80002c12:	4501                	li	a0,0
    80002c14:	60e2                	ld	ra,24(sp)
    80002c16:	6442                	ld	s0,16(sp)
    80002c18:	64a2                	ld	s1,8(sp)
    80002c1a:	6105                	addi	sp,sp,32
    80002c1c:	8082                	ret

0000000080002c1e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002c1e:	1101                	addi	sp,sp,-32
    80002c20:	ec06                	sd	ra,24(sp)
    80002c22:	e822                	sd	s0,16(sp)
    80002c24:	e426                	sd	s1,8(sp)
    80002c26:	1000                	addi	s0,sp,32
    80002c28:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c2a:	00000097          	auipc	ra,0x0
    80002c2e:	ed0080e7          	jalr	-304(ra) # 80002afa <argraw>
    80002c32:	e088                	sd	a0,0(s1)
  return 0;
}
    80002c34:	4501                	li	a0,0
    80002c36:	60e2                	ld	ra,24(sp)
    80002c38:	6442                	ld	s0,16(sp)
    80002c3a:	64a2                	ld	s1,8(sp)
    80002c3c:	6105                	addi	sp,sp,32
    80002c3e:	8082                	ret

0000000080002c40 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002c40:	1101                	addi	sp,sp,-32
    80002c42:	ec06                	sd	ra,24(sp)
    80002c44:	e822                	sd	s0,16(sp)
    80002c46:	e426                	sd	s1,8(sp)
    80002c48:	e04a                	sd	s2,0(sp)
    80002c4a:	1000                	addi	s0,sp,32
    80002c4c:	84ae                	mv	s1,a1
    80002c4e:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002c50:	00000097          	auipc	ra,0x0
    80002c54:	eaa080e7          	jalr	-342(ra) # 80002afa <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002c58:	864a                	mv	a2,s2
    80002c5a:	85a6                	mv	a1,s1
    80002c5c:	00000097          	auipc	ra,0x0
    80002c60:	f58080e7          	jalr	-168(ra) # 80002bb4 <fetchstr>
}
    80002c64:	60e2                	ld	ra,24(sp)
    80002c66:	6442                	ld	s0,16(sp)
    80002c68:	64a2                	ld	s1,8(sp)
    80002c6a:	6902                	ld	s2,0(sp)
    80002c6c:	6105                	addi	sp,sp,32
    80002c6e:	8082                	ret

0000000080002c70 <syscall>:
[SYS_ntas]    sys_ntas,
};

void
syscall(void)
{
    80002c70:	1101                	addi	sp,sp,-32
    80002c72:	ec06                	sd	ra,24(sp)
    80002c74:	e822                	sd	s0,16(sp)
    80002c76:	e426                	sd	s1,8(sp)
    80002c78:	e04a                	sd	s2,0(sp)
    80002c7a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002c7c:	fffff097          	auipc	ra,0xfffff
    80002c80:	f06080e7          	jalr	-250(ra) # 80001b82 <myproc>
    80002c84:	84aa                	mv	s1,a0

  num = p->tf->a7;
    80002c86:	06053903          	ld	s2,96(a0)
    80002c8a:	0a893783          	ld	a5,168(s2)
    80002c8e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002c92:	37fd                	addiw	a5,a5,-1
    80002c94:	4755                	li	a4,21
    80002c96:	00f76f63          	bltu	a4,a5,80002cb4 <syscall+0x44>
    80002c9a:	00369713          	slli	a4,a3,0x3
    80002c9e:	00006797          	auipc	a5,0x6
    80002ca2:	e6a78793          	addi	a5,a5,-406 # 80008b08 <syscalls>
    80002ca6:	97ba                	add	a5,a5,a4
    80002ca8:	639c                	ld	a5,0(a5)
    80002caa:	c789                	beqz	a5,80002cb4 <syscall+0x44>
    p->tf->a0 = syscalls[num]();
    80002cac:	9782                	jalr	a5
    80002cae:	06a93823          	sd	a0,112(s2)
    80002cb2:	a839                	j	80002cd0 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002cb4:	16048613          	addi	a2,s1,352
    80002cb8:	40ac                	lw	a1,64(s1)
    80002cba:	00006517          	auipc	a0,0x6
    80002cbe:	94650513          	addi	a0,a0,-1722 # 80008600 <userret+0x570>
    80002cc2:	ffffe097          	auipc	ra,0xffffe
    80002cc6:	8e0080e7          	jalr	-1824(ra) # 800005a2 <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
    80002cca:	70bc                	ld	a5,96(s1)
    80002ccc:	577d                	li	a4,-1
    80002cce:	fbb8                	sd	a4,112(a5)
  }
}
    80002cd0:	60e2                	ld	ra,24(sp)
    80002cd2:	6442                	ld	s0,16(sp)
    80002cd4:	64a2                	ld	s1,8(sp)
    80002cd6:	6902                	ld	s2,0(sp)
    80002cd8:	6105                	addi	sp,sp,32
    80002cda:	8082                	ret

0000000080002cdc <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002cdc:	1101                	addi	sp,sp,-32
    80002cde:	ec06                	sd	ra,24(sp)
    80002ce0:	e822                	sd	s0,16(sp)
    80002ce2:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002ce4:	fec40593          	addi	a1,s0,-20
    80002ce8:	4501                	li	a0,0
    80002cea:	00000097          	auipc	ra,0x0
    80002cee:	f12080e7          	jalr	-238(ra) # 80002bfc <argint>
    return -1;
    80002cf2:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002cf4:	00054963          	bltz	a0,80002d06 <sys_exit+0x2a>
  exit(n);
    80002cf8:	fec42503          	lw	a0,-20(s0)
    80002cfc:	fffff097          	auipc	ra,0xfffff
    80002d00:	512080e7          	jalr	1298(ra) # 8000220e <exit>
  return 0;  // not reached
    80002d04:	4781                	li	a5,0
}
    80002d06:	853e                	mv	a0,a5
    80002d08:	60e2                	ld	ra,24(sp)
    80002d0a:	6442                	ld	s0,16(sp)
    80002d0c:	6105                	addi	sp,sp,32
    80002d0e:	8082                	ret

0000000080002d10 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002d10:	1141                	addi	sp,sp,-16
    80002d12:	e406                	sd	ra,8(sp)
    80002d14:	e022                	sd	s0,0(sp)
    80002d16:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002d18:	fffff097          	auipc	ra,0xfffff
    80002d1c:	e6a080e7          	jalr	-406(ra) # 80001b82 <myproc>
}
    80002d20:	4128                	lw	a0,64(a0)
    80002d22:	60a2                	ld	ra,8(sp)
    80002d24:	6402                	ld	s0,0(sp)
    80002d26:	0141                	addi	sp,sp,16
    80002d28:	8082                	ret

0000000080002d2a <sys_fork>:

uint64
sys_fork(void)
{
    80002d2a:	1141                	addi	sp,sp,-16
    80002d2c:	e406                	sd	ra,8(sp)
    80002d2e:	e022                	sd	s0,0(sp)
    80002d30:	0800                	addi	s0,sp,16
  return fork();
    80002d32:	fffff097          	auipc	ra,0xfffff
    80002d36:	1ba080e7          	jalr	442(ra) # 80001eec <fork>
}
    80002d3a:	60a2                	ld	ra,8(sp)
    80002d3c:	6402                	ld	s0,0(sp)
    80002d3e:	0141                	addi	sp,sp,16
    80002d40:	8082                	ret

0000000080002d42 <sys_wait>:

uint64
sys_wait(void)
{
    80002d42:	1101                	addi	sp,sp,-32
    80002d44:	ec06                	sd	ra,24(sp)
    80002d46:	e822                	sd	s0,16(sp)
    80002d48:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002d4a:	fe840593          	addi	a1,s0,-24
    80002d4e:	4501                	li	a0,0
    80002d50:	00000097          	auipc	ra,0x0
    80002d54:	ece080e7          	jalr	-306(ra) # 80002c1e <argaddr>
    80002d58:	87aa                	mv	a5,a0
    return -1;
    80002d5a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002d5c:	0007c863          	bltz	a5,80002d6c <sys_wait+0x2a>
  return wait(p);
    80002d60:	fe843503          	ld	a0,-24(s0)
    80002d64:	fffff097          	auipc	ra,0xfffff
    80002d68:	672080e7          	jalr	1650(ra) # 800023d6 <wait>
}
    80002d6c:	60e2                	ld	ra,24(sp)
    80002d6e:	6442                	ld	s0,16(sp)
    80002d70:	6105                	addi	sp,sp,32
    80002d72:	8082                	ret

0000000080002d74 <sys_sbrk>:
 *uvmalloc首先使用kalloc来分配物理内存,然后再用mappages把PTE加到用户的页表里。
 *uvmdealloc调用uvmunmap,首先用walk来找到对应的PTE,然后使用kfree来释放相应的物理内存。
 */
uint64
sys_sbrk(void)
{
    80002d74:	7179                	addi	sp,sp,-48
    80002d76:	f406                	sd	ra,40(sp)
    80002d78:	f022                	sd	s0,32(sp)
    80002d7a:	ec26                	sd	s1,24(sp)
    80002d7c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002d7e:	fdc40593          	addi	a1,s0,-36
    80002d82:	4501                	li	a0,0
    80002d84:	00000097          	auipc	ra,0x0
    80002d88:	e78080e7          	jalr	-392(ra) # 80002bfc <argint>
    return -1;
    80002d8c:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80002d8e:	00054f63          	bltz	a0,80002dac <sys_sbrk+0x38>
  addr = myproc()->sz;
    80002d92:	fffff097          	auipc	ra,0xfffff
    80002d96:	df0080e7          	jalr	-528(ra) # 80001b82 <myproc>
    80002d9a:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    80002d9c:	fdc42503          	lw	a0,-36(s0)
    80002da0:	fffff097          	auipc	ra,0xfffff
    80002da4:	0d8080e7          	jalr	216(ra) # 80001e78 <growproc>
    80002da8:	00054863          	bltz	a0,80002db8 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002dac:	8526                	mv	a0,s1
    80002dae:	70a2                	ld	ra,40(sp)
    80002db0:	7402                	ld	s0,32(sp)
    80002db2:	64e2                	ld	s1,24(sp)
    80002db4:	6145                	addi	sp,sp,48
    80002db6:	8082                	ret
    return -1;
    80002db8:	54fd                	li	s1,-1
    80002dba:	bfcd                	j	80002dac <sys_sbrk+0x38>

0000000080002dbc <sys_sleep>:

uint64
sys_sleep(void)
{
    80002dbc:	7139                	addi	sp,sp,-64
    80002dbe:	fc06                	sd	ra,56(sp)
    80002dc0:	f822                	sd	s0,48(sp)
    80002dc2:	f426                	sd	s1,40(sp)
    80002dc4:	f04a                	sd	s2,32(sp)
    80002dc6:	ec4e                	sd	s3,24(sp)
    80002dc8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002dca:	fcc40593          	addi	a1,s0,-52
    80002dce:	4501                	li	a0,0
    80002dd0:	00000097          	auipc	ra,0x0
    80002dd4:	e2c080e7          	jalr	-468(ra) # 80002bfc <argint>
    return -1;
    80002dd8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002dda:	06054563          	bltz	a0,80002e44 <sys_sleep+0x88>
  acquire(&tickslock);
    80002dde:	00018517          	auipc	a0,0x18
    80002de2:	b9a50513          	addi	a0,a0,-1126 # 8001a978 <tickslock>
    80002de6:	ffffe097          	auipc	ra,0xffffe
    80002dea:	e44080e7          	jalr	-444(ra) # 80000c2a <acquire>
  ticks0 = ticks;
    80002dee:	0002d917          	auipc	s2,0x2d
    80002df2:	25292903          	lw	s2,594(s2) # 80030040 <ticks>
  while(ticks - ticks0 < n){
    80002df6:	fcc42783          	lw	a5,-52(s0)
    80002dfa:	cf85                	beqz	a5,80002e32 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002dfc:	00018997          	auipc	s3,0x18
    80002e00:	b7c98993          	addi	s3,s3,-1156 # 8001a978 <tickslock>
    80002e04:	0002d497          	auipc	s1,0x2d
    80002e08:	23c48493          	addi	s1,s1,572 # 80030040 <ticks>
    if(myproc()->killed){
    80002e0c:	fffff097          	auipc	ra,0xfffff
    80002e10:	d76080e7          	jalr	-650(ra) # 80001b82 <myproc>
    80002e14:	5d1c                	lw	a5,56(a0)
    80002e16:	ef9d                	bnez	a5,80002e54 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002e18:	85ce                	mv	a1,s3
    80002e1a:	8526                	mv	a0,s1
    80002e1c:	fffff097          	auipc	ra,0xfffff
    80002e20:	53c080e7          	jalr	1340(ra) # 80002358 <sleep>
  while(ticks - ticks0 < n){
    80002e24:	409c                	lw	a5,0(s1)
    80002e26:	412787bb          	subw	a5,a5,s2
    80002e2a:	fcc42703          	lw	a4,-52(s0)
    80002e2e:	fce7efe3          	bltu	a5,a4,80002e0c <sys_sleep+0x50>
  }
  release(&tickslock);
    80002e32:	00018517          	auipc	a0,0x18
    80002e36:	b4650513          	addi	a0,a0,-1210 # 8001a978 <tickslock>
    80002e3a:	ffffe097          	auipc	ra,0xffffe
    80002e3e:	e60080e7          	jalr	-416(ra) # 80000c9a <release>
  return 0;
    80002e42:	4781                	li	a5,0
}
    80002e44:	853e                	mv	a0,a5
    80002e46:	70e2                	ld	ra,56(sp)
    80002e48:	7442                	ld	s0,48(sp)
    80002e4a:	74a2                	ld	s1,40(sp)
    80002e4c:	7902                	ld	s2,32(sp)
    80002e4e:	69e2                	ld	s3,24(sp)
    80002e50:	6121                	addi	sp,sp,64
    80002e52:	8082                	ret
      release(&tickslock);
    80002e54:	00018517          	auipc	a0,0x18
    80002e58:	b2450513          	addi	a0,a0,-1244 # 8001a978 <tickslock>
    80002e5c:	ffffe097          	auipc	ra,0xffffe
    80002e60:	e3e080e7          	jalr	-450(ra) # 80000c9a <release>
      return -1;
    80002e64:	57fd                	li	a5,-1
    80002e66:	bff9                	j	80002e44 <sys_sleep+0x88>

0000000080002e68 <sys_kill>:

uint64
sys_kill(void)
{
    80002e68:	1101                	addi	sp,sp,-32
    80002e6a:	ec06                	sd	ra,24(sp)
    80002e6c:	e822                	sd	s0,16(sp)
    80002e6e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002e70:	fec40593          	addi	a1,s0,-20
    80002e74:	4501                	li	a0,0
    80002e76:	00000097          	auipc	ra,0x0
    80002e7a:	d86080e7          	jalr	-634(ra) # 80002bfc <argint>
    80002e7e:	87aa                	mv	a5,a0
    return -1;
    80002e80:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002e82:	0007c863          	bltz	a5,80002e92 <sys_kill+0x2a>
  return kill(pid);
    80002e86:	fec42503          	lw	a0,-20(s0)
    80002e8a:	fffff097          	auipc	ra,0xfffff
    80002e8e:	6b8080e7          	jalr	1720(ra) # 80002542 <kill>
}
    80002e92:	60e2                	ld	ra,24(sp)
    80002e94:	6442                	ld	s0,16(sp)
    80002e96:	6105                	addi	sp,sp,32
    80002e98:	8082                	ret

0000000080002e9a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002e9a:	1101                	addi	sp,sp,-32
    80002e9c:	ec06                	sd	ra,24(sp)
    80002e9e:	e822                	sd	s0,16(sp)
    80002ea0:	e426                	sd	s1,8(sp)
    80002ea2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002ea4:	00018517          	auipc	a0,0x18
    80002ea8:	ad450513          	addi	a0,a0,-1324 # 8001a978 <tickslock>
    80002eac:	ffffe097          	auipc	ra,0xffffe
    80002eb0:	d7e080e7          	jalr	-642(ra) # 80000c2a <acquire>
  xticks = ticks;
    80002eb4:	0002d497          	auipc	s1,0x2d
    80002eb8:	18c4a483          	lw	s1,396(s1) # 80030040 <ticks>
  release(&tickslock);
    80002ebc:	00018517          	auipc	a0,0x18
    80002ec0:	abc50513          	addi	a0,a0,-1348 # 8001a978 <tickslock>
    80002ec4:	ffffe097          	auipc	ra,0xffffe
    80002ec8:	dd6080e7          	jalr	-554(ra) # 80000c9a <release>
  return xticks;
}
    80002ecc:	02049513          	slli	a0,s1,0x20
    80002ed0:	9101                	srli	a0,a0,0x20
    80002ed2:	60e2                	ld	ra,24(sp)
    80002ed4:	6442                	ld	s0,16(sp)
    80002ed6:	64a2                	ld	s1,8(sp)
    80002ed8:	6105                	addi	sp,sp,32
    80002eda:	8082                	ret

0000000080002edc <binit>:
  struct buf hashbucket[NBUCKETS];  //按块号分为13组
} bcache;

void
binit(void)
{
    80002edc:	7179                	addi	sp,sp,-48
    80002ede:	f406                	sd	ra,40(sp)
    80002ee0:	f022                	sd	s0,32(sp)
    80002ee2:	ec26                	sd	s1,24(sp)
    80002ee4:	e84a                	sd	s2,16(sp)
    80002ee6:	e44e                	sd	s3,8(sp)
    80002ee8:	e052                	sd	s4,0(sp)
    80002eea:	1800                	addi	s0,sp,48
  int i;
  struct buf *b;

  for(i = 0;i < NBUCKETS;i++){
    80002eec:	00018917          	auipc	s2,0x18
    80002ef0:	aac90913          	addi	s2,s2,-1364 # 8001a998 <bcache>
    80002ef4:	00020497          	auipc	s1,0x20
    80002ef8:	f8448493          	addi	s1,s1,-124 # 80022e78 <bcache+0x84e0>
    80002efc:	00024a17          	auipc	s4,0x24
    80002f00:	85ca0a13          	addi	s4,s4,-1956 # 80026758 <sb>
    initlock(&bcache.lock[i], "bcache");
    80002f04:	00005997          	auipc	s3,0x5
    80002f08:	3b498993          	addi	s3,s3,948 # 800082b8 <userret+0x228>
    80002f0c:	85ce                	mv	a1,s3
    80002f0e:	854a                	mv	a0,s2
    80002f10:	ffffe097          	auipc	ra,0xffffe
    80002f14:	bcc080e7          	jalr	-1076(ra) # 80000adc <initlock>
    // Create linked list of buffers
    bcache.hashbucket[i].prev = &bcache.hashbucket[i];
    80002f18:	e8a4                	sd	s1,80(s1)
    bcache.hashbucket[i].next = &bcache.hashbucket[i];
    80002f1a:	eca4                	sd	s1,88(s1)
  for(i = 0;i < NBUCKETS;i++){
    80002f1c:	02090913          	addi	s2,s2,32
    80002f20:	46048493          	addi	s1,s1,1120
    80002f24:	ff4494e3          	bne	s1,s4,80002f0c <binit+0x30>
  }
  //构建双向链表,init时blockno全为0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f28:	00018497          	auipc	s1,0x18
    80002f2c:	c1048493          	addi	s1,s1,-1008 # 8001ab38 <bcache+0x1a0>
    b->next = bcache.hashbucket[0].next;
    80002f30:	00020917          	auipc	s2,0x20
    80002f34:	a6890913          	addi	s2,s2,-1432 # 80022998 <bcache+0x8000>
    b->prev = &bcache.hashbucket[0];
    80002f38:	00020997          	auipc	s3,0x20
    80002f3c:	f4098993          	addi	s3,s3,-192 # 80022e78 <bcache+0x84e0>
    initsleeplock(&b->lock, "buffer");
    80002f40:	00005a17          	auipc	s4,0x5
    80002f44:	6e0a0a13          	addi	s4,s4,1760 # 80008620 <userret+0x590>
    b->next = bcache.hashbucket[0].next;
    80002f48:	53893783          	ld	a5,1336(s2)
    80002f4c:	ecbc                	sd	a5,88(s1)
    b->prev = &bcache.hashbucket[0];
    80002f4e:	0534b823          	sd	s3,80(s1)
    initsleeplock(&b->lock, "buffer");
    80002f52:	85d2                	mv	a1,s4
    80002f54:	01048513          	addi	a0,s1,16
    80002f58:	00001097          	auipc	ra,0x1
    80002f5c:	6a8080e7          	jalr	1704(ra) # 80004600 <initsleeplock>
    bcache.hashbucket[0].next->prev = b;
    80002f60:	53893783          	ld	a5,1336(s2)
    80002f64:	eba4                	sd	s1,80(a5)
    bcache.hashbucket[0].next = b;
    80002f66:	52993c23          	sd	s1,1336(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f6a:	46048493          	addi	s1,s1,1120
    80002f6e:	fd349de3          	bne	s1,s3,80002f48 <binit+0x6c>
  }
}
    80002f72:	70a2                	ld	ra,40(sp)
    80002f74:	7402                	ld	s0,32(sp)
    80002f76:	64e2                	ld	s1,24(sp)
    80002f78:	6942                	ld	s2,16(sp)
    80002f7a:	69a2                	ld	s3,8(sp)
    80002f7c:	6a02                	ld	s4,0(sp)
    80002f7e:	6145                	addi	sp,sp,48
    80002f80:	8082                	ret

0000000080002f82 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002f82:	7119                	addi	sp,sp,-128
    80002f84:	fc86                	sd	ra,120(sp)
    80002f86:	f8a2                	sd	s0,112(sp)
    80002f88:	f4a6                	sd	s1,104(sp)
    80002f8a:	f0ca                	sd	s2,96(sp)
    80002f8c:	ecce                	sd	s3,88(sp)
    80002f8e:	e8d2                	sd	s4,80(sp)
    80002f90:	e4d6                	sd	s5,72(sp)
    80002f92:	e0da                	sd	s6,64(sp)
    80002f94:	fc5e                	sd	s7,56(sp)
    80002f96:	f862                	sd	s8,48(sp)
    80002f98:	f466                	sd	s9,40(sp)
    80002f9a:	f06a                	sd	s10,32(sp)
    80002f9c:	ec6e                	sd	s11,24(sp)
    80002f9e:	0100                	addi	s0,sp,128
    80002fa0:	89aa                	mv	s3,a0
    80002fa2:	8aae                	mv	s5,a1
  int hash = blockno%NBUCKETS,hash1;
    80002fa4:	4a35                	li	s4,13
    80002fa6:	0345fa3b          	remuw	s4,a1,s4
    80002faa:	000a0b9b          	sext.w	s7,s4
  acquire(&bcache.lock[hash]);
    80002fae:	005b9c93          	slli	s9,s7,0x5
    80002fb2:	00018917          	auipc	s2,0x18
    80002fb6:	9e690913          	addi	s2,s2,-1562 # 8001a998 <bcache>
    80002fba:	012c87b3          	add	a5,s9,s2
    80002fbe:	f8f43423          	sd	a5,-120(s0)
    80002fc2:	853e                	mv	a0,a5
    80002fc4:	ffffe097          	auipc	ra,0xffffe
    80002fc8:	c66080e7          	jalr	-922(ra) # 80000c2a <acquire>
  for(b = bcache.hashbucket[hash].next; b != &bcache.hashbucket[hash]; b = b->next){
    80002fcc:	46000793          	li	a5,1120
    80002fd0:	02fb87b3          	mul	a5,s7,a5
    80002fd4:	00f906b3          	add	a3,s2,a5
    80002fd8:	6721                	lui	a4,0x8
    80002fda:	96ba                	add	a3,a3,a4
    80002fdc:	5386b483          	ld	s1,1336(a3)
    80002fe0:	4e070713          	addi	a4,a4,1248 # 84e0 <_entry-0x7fff7b20>
    80002fe4:	97ba                	add	a5,a5,a4
    80002fe6:	993e                	add	s2,s2,a5
    80002fe8:	03249563          	bne	s1,s2,80003012 <bread+0x90>
  hash1 = (hash + 1)%NBUCKETS;
    80002fec:	2a05                	addiw	s4,s4,1
    80002fee:	47b5                	li	a5,13
    80002ff0:	02fa6a3b          	remw	s4,s4,a5
  while(hash1 != hash){
    80002ff4:	114b8f63          	beq	s7,s4,80003112 <bread+0x190>
    acquire(&bcache.lock[hash1]);     //对当前backet上锁
    80002ff8:	00018c17          	auipc	s8,0x18
    80002ffc:	9a0c0c13          	addi	s8,s8,-1632 # 8001a998 <bcache>
    for(b = bcache.hashbucket[hash1].prev; b != &bcache.hashbucket[hash1]; b = b->prev){
    80003000:	46000d93          	li	s11,1120
    80003004:	6d21                	lui	s10,0x8
    80003006:	4e0d0c93          	addi	s9,s10,1248 # 84e0 <_entry-0x7fff7b20>
    8000300a:	a8d9                	j	800030e0 <bread+0x15e>
  for(b = bcache.hashbucket[hash].next; b != &bcache.hashbucket[hash]; b = b->next){
    8000300c:	6ca4                	ld	s1,88(s1)
    8000300e:	fd248fe3          	beq	s1,s2,80002fec <bread+0x6a>
    if(b->dev == dev && b->blockno == blockno){
    80003012:	449c                	lw	a5,8(s1)
    80003014:	ff379ce3          	bne	a5,s3,8000300c <bread+0x8a>
    80003018:	44dc                	lw	a5,12(s1)
    8000301a:	ff5799e3          	bne	a5,s5,8000300c <bread+0x8a>
      b->refcnt++;
    8000301e:	44bc                	lw	a5,72(s1)
    80003020:	2785                	addiw	a5,a5,1
    80003022:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock[hash]);
    80003024:	f8843503          	ld	a0,-120(s0)
    80003028:	ffffe097          	auipc	ra,0xffffe
    8000302c:	c72080e7          	jalr	-910(ra) # 80000c9a <release>
      acquiresleep(&b->lock);
    80003030:	01048513          	addi	a0,s1,16
    80003034:	00001097          	auipc	ra,0x1
    80003038:	606080e7          	jalr	1542(ra) # 8000463a <acquiresleep>
      return b;
    8000303c:	a0ad                	j	800030a6 <bread+0x124>
        b->dev = dev;
    8000303e:	0134a423          	sw	s3,8(s1)
        b->blockno = blockno;
    80003042:	0154a623          	sw	s5,12(s1)
        b->valid = 0;
    80003046:	0004a023          	sw	zero,0(s1)
        b->refcnt = 1;
    8000304a:	4785                	li	a5,1
    8000304c:	c4bc                	sw	a5,72(s1)
        b->next->prev = b->prev;
    8000304e:	6cbc                	ld	a5,88(s1)
    80003050:	68b8                	ld	a4,80(s1)
    80003052:	ebb8                	sd	a4,80(a5)
        b->prev->next = b->next;
    80003054:	68bc                	ld	a5,80(s1)
    80003056:	6cb8                	ld	a4,88(s1)
    80003058:	efb8                	sd	a4,88(a5)
        release(&bcache.lock[hash1]);
    8000305a:	855a                	mv	a0,s6
    8000305c:	ffffe097          	auipc	ra,0xffffe
    80003060:	c3e080e7          	jalr	-962(ra) # 80000c9a <release>
        b->next = bcache.hashbucket[hash].next;
    80003064:	46000793          	li	a5,1120
    80003068:	02fb8bb3          	mul	s7,s7,a5
    8000306c:	00018797          	auipc	a5,0x18
    80003070:	92c78793          	addi	a5,a5,-1748 # 8001a998 <bcache>
    80003074:	97de                	add	a5,a5,s7
    80003076:	6ba1                	lui	s7,0x8
    80003078:	9bbe                	add	s7,s7,a5
    8000307a:	538bb783          	ld	a5,1336(s7) # 8538 <_entry-0x7fff7ac8>
    8000307e:	ecbc                	sd	a5,88(s1)
        b->prev = &bcache.hashbucket[hash];
    80003080:	0524b823          	sd	s2,80(s1)
        bcache.hashbucket[hash].next->prev = b;
    80003084:	538bb783          	ld	a5,1336(s7)
    80003088:	eba4                	sd	s1,80(a5)
        bcache.hashbucket[hash].next = b;
    8000308a:	529bbc23          	sd	s1,1336(s7)
        release(&bcache.lock[hash]);
    8000308e:	f8843503          	ld	a0,-120(s0)
    80003092:	ffffe097          	auipc	ra,0xffffe
    80003096:	c08080e7          	jalr	-1016(ra) # 80000c9a <release>
        acquiresleep(&b->lock);
    8000309a:	01048513          	addi	a0,s1,16
    8000309e:	00001097          	auipc	ra,0x1
    800030a2:	59c080e7          	jalr	1436(ra) # 8000463a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);   //检查磁盘块是否在buf中
  if(!b->valid) {
    800030a6:	409c                	lw	a5,0(s1)
    800030a8:	cfad                	beqz	a5,80003122 <bread+0x1a0>
    virtio_disk_rw(b->dev, b, 0); //加载磁盘块
    b->valid = 1;
  }
  return b;
}
    800030aa:	8526                	mv	a0,s1
    800030ac:	70e6                	ld	ra,120(sp)
    800030ae:	7446                	ld	s0,112(sp)
    800030b0:	74a6                	ld	s1,104(sp)
    800030b2:	7906                	ld	s2,96(sp)
    800030b4:	69e6                	ld	s3,88(sp)
    800030b6:	6a46                	ld	s4,80(sp)
    800030b8:	6aa6                	ld	s5,72(sp)
    800030ba:	6b06                	ld	s6,64(sp)
    800030bc:	7be2                	ld	s7,56(sp)
    800030be:	7c42                	ld	s8,48(sp)
    800030c0:	7ca2                	ld	s9,40(sp)
    800030c2:	7d02                	ld	s10,32(sp)
    800030c4:	6de2                	ld	s11,24(sp)
    800030c6:	6109                	addi	sp,sp,128
    800030c8:	8082                	ret
    release(&bcache.lock[hash1]);
    800030ca:	855a                	mv	a0,s6
    800030cc:	ffffe097          	auipc	ra,0xffffe
    800030d0:	bce080e7          	jalr	-1074(ra) # 80000c9a <release>
    hash1 = (hash1 + 1)%NBUCKETS;
    800030d4:	2a05                	addiw	s4,s4,1
    800030d6:	47b5                	li	a5,13
    800030d8:	02fa6a3b          	remw	s4,s4,a5
  while(hash1 != hash){
    800030dc:	034b8b63          	beq	s7,s4,80003112 <bread+0x190>
    acquire(&bcache.lock[hash1]);     //对当前backet上锁
    800030e0:	005a1b13          	slli	s6,s4,0x5
    800030e4:	9b62                	add	s6,s6,s8
    800030e6:	855a                	mv	a0,s6
    800030e8:	ffffe097          	auipc	ra,0xffffe
    800030ec:	b42080e7          	jalr	-1214(ra) # 80000c2a <acquire>
    for(b = bcache.hashbucket[hash1].prev; b != &bcache.hashbucket[hash1]; b = b->prev){
    800030f0:	03ba0733          	mul	a4,s4,s11
    800030f4:	00ec07b3          	add	a5,s8,a4
    800030f8:	97ea                	add	a5,a5,s10
    800030fa:	5307b483          	ld	s1,1328(a5)
    800030fe:	9766                	add	a4,a4,s9
    80003100:	9762                	add	a4,a4,s8
    80003102:	fce484e3          	beq	s1,a4,800030ca <bread+0x148>
      if(b->refcnt == 0){    //找到未被使用的缓存块
    80003106:	44bc                	lw	a5,72(s1)
    80003108:	db9d                	beqz	a5,8000303e <bread+0xbc>
    for(b = bcache.hashbucket[hash1].prev; b != &bcache.hashbucket[hash1]; b = b->prev){
    8000310a:	68a4                	ld	s1,80(s1)
    8000310c:	fee49de3          	bne	s1,a4,80003106 <bread+0x184>
    80003110:	bf6d                	j	800030ca <bread+0x148>
  panic("bget: no buffers");
    80003112:	00005517          	auipc	a0,0x5
    80003116:	51650513          	addi	a0,a0,1302 # 80008628 <userret+0x598>
    8000311a:	ffffd097          	auipc	ra,0xffffd
    8000311e:	42e080e7          	jalr	1070(ra) # 80000548 <panic>
    virtio_disk_rw(b->dev, b, 0); //加载磁盘块
    80003122:	4601                	li	a2,0
    80003124:	85a6                	mv	a1,s1
    80003126:	4488                	lw	a0,8(s1)
    80003128:	00003097          	auipc	ra,0x3
    8000312c:	152080e7          	jalr	338(ra) # 8000627a <virtio_disk_rw>
    b->valid = 1;
    80003130:	4785                	li	a5,1
    80003132:	c09c                	sw	a5,0(s1)
  return b;
    80003134:	bf9d                	j	800030aa <bread+0x128>

0000000080003136 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003136:	1101                	addi	sp,sp,-32
    80003138:	ec06                	sd	ra,24(sp)
    8000313a:	e822                	sd	s0,16(sp)
    8000313c:	e426                	sd	s1,8(sp)
    8000313e:	1000                	addi	s0,sp,32
    80003140:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003142:	0541                	addi	a0,a0,16
    80003144:	00001097          	auipc	ra,0x1
    80003148:	590080e7          	jalr	1424(ra) # 800046d4 <holdingsleep>
    8000314c:	cd09                	beqz	a0,80003166 <bwrite+0x30>
    panic("bwrite");
  virtio_disk_rw(b->dev, b, 1);
    8000314e:	4605                	li	a2,1
    80003150:	85a6                	mv	a1,s1
    80003152:	4488                	lw	a0,8(s1)
    80003154:	00003097          	auipc	ra,0x3
    80003158:	126080e7          	jalr	294(ra) # 8000627a <virtio_disk_rw>
}
    8000315c:	60e2                	ld	ra,24(sp)
    8000315e:	6442                	ld	s0,16(sp)
    80003160:	64a2                	ld	s1,8(sp)
    80003162:	6105                	addi	sp,sp,32
    80003164:	8082                	ret
    panic("bwrite");
    80003166:	00005517          	auipc	a0,0x5
    8000316a:	4da50513          	addi	a0,a0,1242 # 80008640 <userret+0x5b0>
    8000316e:	ffffd097          	auipc	ra,0xffffd
    80003172:	3da080e7          	jalr	986(ra) # 80000548 <panic>

0000000080003176 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
    80003176:	7179                	addi	sp,sp,-48
    80003178:	f406                	sd	ra,40(sp)
    8000317a:	f022                	sd	s0,32(sp)
    8000317c:	ec26                	sd	s1,24(sp)
    8000317e:	e84a                	sd	s2,16(sp)
    80003180:	e44e                	sd	s3,8(sp)
    80003182:	1800                	addi	s0,sp,48
    80003184:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003186:	01050913          	addi	s2,a0,16
    8000318a:	854a                	mv	a0,s2
    8000318c:	00001097          	auipc	ra,0x1
    80003190:	548080e7          	jalr	1352(ra) # 800046d4 <holdingsleep>
    80003194:	c951                	beqz	a0,80003228 <brelse+0xb2>
    panic("brelse");

  releasesleep(&b->lock);
    80003196:	854a                	mv	a0,s2
    80003198:	00001097          	auipc	ra,0x1
    8000319c:	4f8080e7          	jalr	1272(ra) # 80004690 <releasesleep>

  int hash = (b->blockno)%NBUCKETS;
    800031a0:	00c4a903          	lw	s2,12(s1)
    800031a4:	47b5                	li	a5,13
    800031a6:	02f9793b          	remuw	s2,s2,a5

  acquire(&bcache.lock[hash]);
    800031aa:	00591993          	slli	s3,s2,0x5
    800031ae:	00017797          	auipc	a5,0x17
    800031b2:	7ea78793          	addi	a5,a5,2026 # 8001a998 <bcache>
    800031b6:	99be                	add	s3,s3,a5
    800031b8:	854e                	mv	a0,s3
    800031ba:	ffffe097          	auipc	ra,0xffffe
    800031be:	a70080e7          	jalr	-1424(ra) # 80000c2a <acquire>
  b->refcnt--;
    800031c2:	44bc                	lw	a5,72(s1)
    800031c4:	37fd                	addiw	a5,a5,-1
    800031c6:	0007871b          	sext.w	a4,a5
    800031ca:	c4bc                	sw	a5,72(s1)
  if (b->refcnt == 0) {
    800031cc:	e331                	bnez	a4,80003210 <brelse+0x9a>
    //从双向链表中取下b并放在链表头
    b->next->prev = b->prev;
    800031ce:	6cbc                	ld	a5,88(s1)
    800031d0:	68b8                	ld	a4,80(s1)
    800031d2:	ebb8                	sd	a4,80(a5)
    b->prev->next = b->next;
    800031d4:	68bc                	ld	a5,80(s1)
    800031d6:	6cb8                	ld	a4,88(s1)
    800031d8:	efb8                	sd	a4,88(a5)
    b->next = bcache.hashbucket[hash].next;
    800031da:	00017697          	auipc	a3,0x17
    800031de:	7be68693          	addi	a3,a3,1982 # 8001a998 <bcache>
    800031e2:	46000613          	li	a2,1120
    800031e6:	02c907b3          	mul	a5,s2,a2
    800031ea:	97b6                	add	a5,a5,a3
    800031ec:	6721                	lui	a4,0x8
    800031ee:	97ba                	add	a5,a5,a4
    800031f0:	5387b583          	ld	a1,1336(a5)
    800031f4:	ecac                	sd	a1,88(s1)
    b->prev = &bcache.hashbucket[hash];
    800031f6:	02c90933          	mul	s2,s2,a2
    800031fa:	4e070713          	addi	a4,a4,1248 # 84e0 <_entry-0x7fff7b20>
    800031fe:	993a                	add	s2,s2,a4
    80003200:	9936                	add	s2,s2,a3
    80003202:	0524b823          	sd	s2,80(s1)
    bcache.hashbucket[hash].next->prev = b;
    80003206:	5387b703          	ld	a4,1336(a5)
    8000320a:	eb24                	sd	s1,80(a4)
    bcache.hashbucket[hash].next = b;
    8000320c:	5297bc23          	sd	s1,1336(a5)
  }
  release(&bcache.lock[hash]);
    80003210:	854e                	mv	a0,s3
    80003212:	ffffe097          	auipc	ra,0xffffe
    80003216:	a88080e7          	jalr	-1400(ra) # 80000c9a <release>
}
    8000321a:	70a2                	ld	ra,40(sp)
    8000321c:	7402                	ld	s0,32(sp)
    8000321e:	64e2                	ld	s1,24(sp)
    80003220:	6942                	ld	s2,16(sp)
    80003222:	69a2                	ld	s3,8(sp)
    80003224:	6145                	addi	sp,sp,48
    80003226:	8082                	ret
    panic("brelse");
    80003228:	00005517          	auipc	a0,0x5
    8000322c:	42050513          	addi	a0,a0,1056 # 80008648 <userret+0x5b8>
    80003230:	ffffd097          	auipc	ra,0xffffd
    80003234:	318080e7          	jalr	792(ra) # 80000548 <panic>

0000000080003238 <bpin>:

void
bpin(struct buf *b) {
    80003238:	1101                	addi	sp,sp,-32
    8000323a:	ec06                	sd	ra,24(sp)
    8000323c:	e822                	sd	s0,16(sp)
    8000323e:	e426                	sd	s1,8(sp)
    80003240:	e04a                	sd	s2,0(sp)
    80003242:	1000                	addi	s0,sp,32
    80003244:	892a                	mv	s2,a0
  int hash = (b->blockno)%NBUCKETS;
    80003246:	4544                	lw	s1,12(a0)
  acquire(&bcache.lock[hash]);
    80003248:	47b5                	li	a5,13
    8000324a:	02f4f4bb          	remuw	s1,s1,a5
    8000324e:	0496                	slli	s1,s1,0x5
    80003250:	00017797          	auipc	a5,0x17
    80003254:	74878793          	addi	a5,a5,1864 # 8001a998 <bcache>
    80003258:	94be                	add	s1,s1,a5
    8000325a:	8526                	mv	a0,s1
    8000325c:	ffffe097          	auipc	ra,0xffffe
    80003260:	9ce080e7          	jalr	-1586(ra) # 80000c2a <acquire>
  b->refcnt++;
    80003264:	04892783          	lw	a5,72(s2)
    80003268:	2785                	addiw	a5,a5,1
    8000326a:	04f92423          	sw	a5,72(s2)
  release(&bcache.lock[hash]);
    8000326e:	8526                	mv	a0,s1
    80003270:	ffffe097          	auipc	ra,0xffffe
    80003274:	a2a080e7          	jalr	-1494(ra) # 80000c9a <release>
}
    80003278:	60e2                	ld	ra,24(sp)
    8000327a:	6442                	ld	s0,16(sp)
    8000327c:	64a2                	ld	s1,8(sp)
    8000327e:	6902                	ld	s2,0(sp)
    80003280:	6105                	addi	sp,sp,32
    80003282:	8082                	ret

0000000080003284 <bunpin>:

void
bunpin(struct buf *b) {
    80003284:	1101                	addi	sp,sp,-32
    80003286:	ec06                	sd	ra,24(sp)
    80003288:	e822                	sd	s0,16(sp)
    8000328a:	e426                	sd	s1,8(sp)
    8000328c:	e04a                	sd	s2,0(sp)
    8000328e:	1000                	addi	s0,sp,32
    80003290:	892a                	mv	s2,a0
  int hash = (b->blockno)%NBUCKETS;
    80003292:	4544                	lw	s1,12(a0)
  acquire(&bcache.lock[hash]);
    80003294:	47b5                	li	a5,13
    80003296:	02f4f4bb          	remuw	s1,s1,a5
    8000329a:	0496                	slli	s1,s1,0x5
    8000329c:	00017797          	auipc	a5,0x17
    800032a0:	6fc78793          	addi	a5,a5,1788 # 8001a998 <bcache>
    800032a4:	94be                	add	s1,s1,a5
    800032a6:	8526                	mv	a0,s1
    800032a8:	ffffe097          	auipc	ra,0xffffe
    800032ac:	982080e7          	jalr	-1662(ra) # 80000c2a <acquire>
  b->refcnt--;
    800032b0:	04892783          	lw	a5,72(s2)
    800032b4:	37fd                	addiw	a5,a5,-1
    800032b6:	04f92423          	sw	a5,72(s2)
  release(&bcache.lock[hash]);
    800032ba:	8526                	mv	a0,s1
    800032bc:	ffffe097          	auipc	ra,0xffffe
    800032c0:	9de080e7          	jalr	-1570(ra) # 80000c9a <release>
}
    800032c4:	60e2                	ld	ra,24(sp)
    800032c6:	6442                	ld	s0,16(sp)
    800032c8:	64a2                	ld	s1,8(sp)
    800032ca:	6902                	ld	s2,0(sp)
    800032cc:	6105                	addi	sp,sp,32
    800032ce:	8082                	ret

00000000800032d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800032d0:	1101                	addi	sp,sp,-32
    800032d2:	ec06                	sd	ra,24(sp)
    800032d4:	e822                	sd	s0,16(sp)
    800032d6:	e426                	sd	s1,8(sp)
    800032d8:	e04a                	sd	s2,0(sp)
    800032da:	1000                	addi	s0,sp,32
    800032dc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800032de:	00d5d59b          	srliw	a1,a1,0xd
    800032e2:	00023797          	auipc	a5,0x23
    800032e6:	4927a783          	lw	a5,1170(a5) # 80026774 <sb+0x1c>
    800032ea:	9dbd                	addw	a1,a1,a5
    800032ec:	00000097          	auipc	ra,0x0
    800032f0:	c96080e7          	jalr	-874(ra) # 80002f82 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800032f4:	0074f713          	andi	a4,s1,7
    800032f8:	4785                	li	a5,1
    800032fa:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800032fe:	14ce                	slli	s1,s1,0x33
    80003300:	90d9                	srli	s1,s1,0x36
    80003302:	00950733          	add	a4,a0,s1
    80003306:	06074703          	lbu	a4,96(a4)
    8000330a:	00e7f6b3          	and	a3,a5,a4
    8000330e:	c69d                	beqz	a3,8000333c <bfree+0x6c>
    80003310:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003312:	94aa                	add	s1,s1,a0
    80003314:	fff7c793          	not	a5,a5
    80003318:	8ff9                	and	a5,a5,a4
    8000331a:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    8000331e:	00001097          	auipc	ra,0x1
    80003322:	1a2080e7          	jalr	418(ra) # 800044c0 <log_write>
  brelse(bp);
    80003326:	854a                	mv	a0,s2
    80003328:	00000097          	auipc	ra,0x0
    8000332c:	e4e080e7          	jalr	-434(ra) # 80003176 <brelse>
}
    80003330:	60e2                	ld	ra,24(sp)
    80003332:	6442                	ld	s0,16(sp)
    80003334:	64a2                	ld	s1,8(sp)
    80003336:	6902                	ld	s2,0(sp)
    80003338:	6105                	addi	sp,sp,32
    8000333a:	8082                	ret
    panic("freeing free block");
    8000333c:	00005517          	auipc	a0,0x5
    80003340:	31450513          	addi	a0,a0,788 # 80008650 <userret+0x5c0>
    80003344:	ffffd097          	auipc	ra,0xffffd
    80003348:	204080e7          	jalr	516(ra) # 80000548 <panic>

000000008000334c <balloc>:
{
    8000334c:	711d                	addi	sp,sp,-96
    8000334e:	ec86                	sd	ra,88(sp)
    80003350:	e8a2                	sd	s0,80(sp)
    80003352:	e4a6                	sd	s1,72(sp)
    80003354:	e0ca                	sd	s2,64(sp)
    80003356:	fc4e                	sd	s3,56(sp)
    80003358:	f852                	sd	s4,48(sp)
    8000335a:	f456                	sd	s5,40(sp)
    8000335c:	f05a                	sd	s6,32(sp)
    8000335e:	ec5e                	sd	s7,24(sp)
    80003360:	e862                	sd	s8,16(sp)
    80003362:	e466                	sd	s9,8(sp)
    80003364:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003366:	00023797          	auipc	a5,0x23
    8000336a:	3f67a783          	lw	a5,1014(a5) # 8002675c <sb+0x4>
    8000336e:	cbd1                	beqz	a5,80003402 <balloc+0xb6>
    80003370:	8baa                	mv	s7,a0
    80003372:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003374:	00023b17          	auipc	s6,0x23
    80003378:	3e4b0b13          	addi	s6,s6,996 # 80026758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000337c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000337e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003380:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003382:	6c89                	lui	s9,0x2
    80003384:	a831                	j	800033a0 <balloc+0x54>
    brelse(bp);
    80003386:	854a                	mv	a0,s2
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	dee080e7          	jalr	-530(ra) # 80003176 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003390:	015c87bb          	addw	a5,s9,s5
    80003394:	00078a9b          	sext.w	s5,a5
    80003398:	004b2703          	lw	a4,4(s6)
    8000339c:	06eaf363          	bgeu	s5,a4,80003402 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800033a0:	41fad79b          	sraiw	a5,s5,0x1f
    800033a4:	0137d79b          	srliw	a5,a5,0x13
    800033a8:	015787bb          	addw	a5,a5,s5
    800033ac:	40d7d79b          	sraiw	a5,a5,0xd
    800033b0:	01cb2583          	lw	a1,28(s6)
    800033b4:	9dbd                	addw	a1,a1,a5
    800033b6:	855e                	mv	a0,s7
    800033b8:	00000097          	auipc	ra,0x0
    800033bc:	bca080e7          	jalr	-1078(ra) # 80002f82 <bread>
    800033c0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033c2:	004b2503          	lw	a0,4(s6)
    800033c6:	000a849b          	sext.w	s1,s5
    800033ca:	8662                	mv	a2,s8
    800033cc:	faa4fde3          	bgeu	s1,a0,80003386 <balloc+0x3a>
      m = 1 << (bi % 8);
    800033d0:	41f6579b          	sraiw	a5,a2,0x1f
    800033d4:	01d7d69b          	srliw	a3,a5,0x1d
    800033d8:	00c6873b          	addw	a4,a3,a2
    800033dc:	00777793          	andi	a5,a4,7
    800033e0:	9f95                	subw	a5,a5,a3
    800033e2:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800033e6:	4037571b          	sraiw	a4,a4,0x3
    800033ea:	00e906b3          	add	a3,s2,a4
    800033ee:	0606c683          	lbu	a3,96(a3)
    800033f2:	00d7f5b3          	and	a1,a5,a3
    800033f6:	cd91                	beqz	a1,80003412 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033f8:	2605                	addiw	a2,a2,1
    800033fa:	2485                	addiw	s1,s1,1
    800033fc:	fd4618e3          	bne	a2,s4,800033cc <balloc+0x80>
    80003400:	b759                	j	80003386 <balloc+0x3a>
  panic("balloc: out of blocks");
    80003402:	00005517          	auipc	a0,0x5
    80003406:	26650513          	addi	a0,a0,614 # 80008668 <userret+0x5d8>
    8000340a:	ffffd097          	auipc	ra,0xffffd
    8000340e:	13e080e7          	jalr	318(ra) # 80000548 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003412:	974a                	add	a4,a4,s2
    80003414:	8fd5                	or	a5,a5,a3
    80003416:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    8000341a:	854a                	mv	a0,s2
    8000341c:	00001097          	auipc	ra,0x1
    80003420:	0a4080e7          	jalr	164(ra) # 800044c0 <log_write>
        brelse(bp);
    80003424:	854a                	mv	a0,s2
    80003426:	00000097          	auipc	ra,0x0
    8000342a:	d50080e7          	jalr	-688(ra) # 80003176 <brelse>
  bp = bread(dev, bno);
    8000342e:	85a6                	mv	a1,s1
    80003430:	855e                	mv	a0,s7
    80003432:	00000097          	auipc	ra,0x0
    80003436:	b50080e7          	jalr	-1200(ra) # 80002f82 <bread>
    8000343a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000343c:	40000613          	li	a2,1024
    80003440:	4581                	li	a1,0
    80003442:	06050513          	addi	a0,a0,96
    80003446:	ffffe097          	auipc	ra,0xffffe
    8000344a:	a52080e7          	jalr	-1454(ra) # 80000e98 <memset>
  log_write(bp);
    8000344e:	854a                	mv	a0,s2
    80003450:	00001097          	auipc	ra,0x1
    80003454:	070080e7          	jalr	112(ra) # 800044c0 <log_write>
  brelse(bp);
    80003458:	854a                	mv	a0,s2
    8000345a:	00000097          	auipc	ra,0x0
    8000345e:	d1c080e7          	jalr	-740(ra) # 80003176 <brelse>
}
    80003462:	8526                	mv	a0,s1
    80003464:	60e6                	ld	ra,88(sp)
    80003466:	6446                	ld	s0,80(sp)
    80003468:	64a6                	ld	s1,72(sp)
    8000346a:	6906                	ld	s2,64(sp)
    8000346c:	79e2                	ld	s3,56(sp)
    8000346e:	7a42                	ld	s4,48(sp)
    80003470:	7aa2                	ld	s5,40(sp)
    80003472:	7b02                	ld	s6,32(sp)
    80003474:	6be2                	ld	s7,24(sp)
    80003476:	6c42                	ld	s8,16(sp)
    80003478:	6ca2                	ld	s9,8(sp)
    8000347a:	6125                	addi	sp,sp,96
    8000347c:	8082                	ret

000000008000347e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000347e:	7179                	addi	sp,sp,-48
    80003480:	f406                	sd	ra,40(sp)
    80003482:	f022                	sd	s0,32(sp)
    80003484:	ec26                	sd	s1,24(sp)
    80003486:	e84a                	sd	s2,16(sp)
    80003488:	e44e                	sd	s3,8(sp)
    8000348a:	e052                	sd	s4,0(sp)
    8000348c:	1800                	addi	s0,sp,48
    8000348e:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003490:	47ad                	li	a5,11
    80003492:	04b7fe63          	bgeu	a5,a1,800034ee <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003496:	ff45849b          	addiw	s1,a1,-12
    8000349a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000349e:	0ff00793          	li	a5,255
    800034a2:	0ae7e463          	bltu	a5,a4,8000354a <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800034a6:	08852583          	lw	a1,136(a0)
    800034aa:	c5b5                	beqz	a1,80003516 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800034ac:	00092503          	lw	a0,0(s2)
    800034b0:	00000097          	auipc	ra,0x0
    800034b4:	ad2080e7          	jalr	-1326(ra) # 80002f82 <bread>
    800034b8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800034ba:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    800034be:	02049713          	slli	a4,s1,0x20
    800034c2:	01e75593          	srli	a1,a4,0x1e
    800034c6:	00b784b3          	add	s1,a5,a1
    800034ca:	0004a983          	lw	s3,0(s1)
    800034ce:	04098e63          	beqz	s3,8000352a <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800034d2:	8552                	mv	a0,s4
    800034d4:	00000097          	auipc	ra,0x0
    800034d8:	ca2080e7          	jalr	-862(ra) # 80003176 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800034dc:	854e                	mv	a0,s3
    800034de:	70a2                	ld	ra,40(sp)
    800034e0:	7402                	ld	s0,32(sp)
    800034e2:	64e2                	ld	s1,24(sp)
    800034e4:	6942                	ld	s2,16(sp)
    800034e6:	69a2                	ld	s3,8(sp)
    800034e8:	6a02                	ld	s4,0(sp)
    800034ea:	6145                	addi	sp,sp,48
    800034ec:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800034ee:	02059793          	slli	a5,a1,0x20
    800034f2:	01e7d593          	srli	a1,a5,0x1e
    800034f6:	00b504b3          	add	s1,a0,a1
    800034fa:	0584a983          	lw	s3,88(s1)
    800034fe:	fc099fe3          	bnez	s3,800034dc <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003502:	4108                	lw	a0,0(a0)
    80003504:	00000097          	auipc	ra,0x0
    80003508:	e48080e7          	jalr	-440(ra) # 8000334c <balloc>
    8000350c:	0005099b          	sext.w	s3,a0
    80003510:	0534ac23          	sw	s3,88(s1)
    80003514:	b7e1                	j	800034dc <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003516:	4108                	lw	a0,0(a0)
    80003518:	00000097          	auipc	ra,0x0
    8000351c:	e34080e7          	jalr	-460(ra) # 8000334c <balloc>
    80003520:	0005059b          	sext.w	a1,a0
    80003524:	08b92423          	sw	a1,136(s2)
    80003528:	b751                	j	800034ac <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000352a:	00092503          	lw	a0,0(s2)
    8000352e:	00000097          	auipc	ra,0x0
    80003532:	e1e080e7          	jalr	-482(ra) # 8000334c <balloc>
    80003536:	0005099b          	sext.w	s3,a0
    8000353a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000353e:	8552                	mv	a0,s4
    80003540:	00001097          	auipc	ra,0x1
    80003544:	f80080e7          	jalr	-128(ra) # 800044c0 <log_write>
    80003548:	b769                	j	800034d2 <bmap+0x54>
  panic("bmap: out of range");
    8000354a:	00005517          	auipc	a0,0x5
    8000354e:	13650513          	addi	a0,a0,310 # 80008680 <userret+0x5f0>
    80003552:	ffffd097          	auipc	ra,0xffffd
    80003556:	ff6080e7          	jalr	-10(ra) # 80000548 <panic>

000000008000355a <iget>:
{
    8000355a:	7179                	addi	sp,sp,-48
    8000355c:	f406                	sd	ra,40(sp)
    8000355e:	f022                	sd	s0,32(sp)
    80003560:	ec26                	sd	s1,24(sp)
    80003562:	e84a                	sd	s2,16(sp)
    80003564:	e44e                	sd	s3,8(sp)
    80003566:	e052                	sd	s4,0(sp)
    80003568:	1800                	addi	s0,sp,48
    8000356a:	89aa                	mv	s3,a0
    8000356c:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    8000356e:	00023517          	auipc	a0,0x23
    80003572:	20a50513          	addi	a0,a0,522 # 80026778 <icache>
    80003576:	ffffd097          	auipc	ra,0xffffd
    8000357a:	6b4080e7          	jalr	1716(ra) # 80000c2a <acquire>
  empty = 0;
    8000357e:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003580:	00023497          	auipc	s1,0x23
    80003584:	21848493          	addi	s1,s1,536 # 80026798 <icache+0x20>
    80003588:	00025697          	auipc	a3,0x25
    8000358c:	e3068693          	addi	a3,a3,-464 # 800283b8 <log>
    80003590:	a039                	j	8000359e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003592:	02090b63          	beqz	s2,800035c8 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003596:	09048493          	addi	s1,s1,144
    8000359a:	02d48a63          	beq	s1,a3,800035ce <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000359e:	449c                	lw	a5,8(s1)
    800035a0:	fef059e3          	blez	a5,80003592 <iget+0x38>
    800035a4:	4098                	lw	a4,0(s1)
    800035a6:	ff3716e3          	bne	a4,s3,80003592 <iget+0x38>
    800035aa:	40d8                	lw	a4,4(s1)
    800035ac:	ff4713e3          	bne	a4,s4,80003592 <iget+0x38>
      ip->ref++;
    800035b0:	2785                	addiw	a5,a5,1
    800035b2:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    800035b4:	00023517          	auipc	a0,0x23
    800035b8:	1c450513          	addi	a0,a0,452 # 80026778 <icache>
    800035bc:	ffffd097          	auipc	ra,0xffffd
    800035c0:	6de080e7          	jalr	1758(ra) # 80000c9a <release>
      return ip;
    800035c4:	8926                	mv	s2,s1
    800035c6:	a03d                	j	800035f4 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800035c8:	f7f9                	bnez	a5,80003596 <iget+0x3c>
    800035ca:	8926                	mv	s2,s1
    800035cc:	b7e9                	j	80003596 <iget+0x3c>
  if(empty == 0)
    800035ce:	02090c63          	beqz	s2,80003606 <iget+0xac>
  ip->dev = dev;
    800035d2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800035d6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800035da:	4785                	li	a5,1
    800035dc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800035e0:	04092423          	sw	zero,72(s2)
  release(&icache.lock);
    800035e4:	00023517          	auipc	a0,0x23
    800035e8:	19450513          	addi	a0,a0,404 # 80026778 <icache>
    800035ec:	ffffd097          	auipc	ra,0xffffd
    800035f0:	6ae080e7          	jalr	1710(ra) # 80000c9a <release>
}
    800035f4:	854a                	mv	a0,s2
    800035f6:	70a2                	ld	ra,40(sp)
    800035f8:	7402                	ld	s0,32(sp)
    800035fa:	64e2                	ld	s1,24(sp)
    800035fc:	6942                	ld	s2,16(sp)
    800035fe:	69a2                	ld	s3,8(sp)
    80003600:	6a02                	ld	s4,0(sp)
    80003602:	6145                	addi	sp,sp,48
    80003604:	8082                	ret
    panic("iget: no inodes");
    80003606:	00005517          	auipc	a0,0x5
    8000360a:	09250513          	addi	a0,a0,146 # 80008698 <userret+0x608>
    8000360e:	ffffd097          	auipc	ra,0xffffd
    80003612:	f3a080e7          	jalr	-198(ra) # 80000548 <panic>

0000000080003616 <fsinit>:
fsinit(int dev) {
    80003616:	7179                	addi	sp,sp,-48
    80003618:	f406                	sd	ra,40(sp)
    8000361a:	f022                	sd	s0,32(sp)
    8000361c:	ec26                	sd	s1,24(sp)
    8000361e:	e84a                	sd	s2,16(sp)
    80003620:	e44e                	sd	s3,8(sp)
    80003622:	1800                	addi	s0,sp,48
    80003624:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003626:	4585                	li	a1,1
    80003628:	00000097          	auipc	ra,0x0
    8000362c:	95a080e7          	jalr	-1702(ra) # 80002f82 <bread>
    80003630:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003632:	00023997          	auipc	s3,0x23
    80003636:	12698993          	addi	s3,s3,294 # 80026758 <sb>
    8000363a:	02000613          	li	a2,32
    8000363e:	06050593          	addi	a1,a0,96
    80003642:	854e                	mv	a0,s3
    80003644:	ffffe097          	auipc	ra,0xffffe
    80003648:	8b0080e7          	jalr	-1872(ra) # 80000ef4 <memmove>
  brelse(bp);
    8000364c:	8526                	mv	a0,s1
    8000364e:	00000097          	auipc	ra,0x0
    80003652:	b28080e7          	jalr	-1240(ra) # 80003176 <brelse>
  if(sb.magic != FSMAGIC)
    80003656:	0009a703          	lw	a4,0(s3)
    8000365a:	102037b7          	lui	a5,0x10203
    8000365e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003662:	02f71263          	bne	a4,a5,80003686 <fsinit+0x70>
  initlog(dev, &sb);
    80003666:	00023597          	auipc	a1,0x23
    8000366a:	0f258593          	addi	a1,a1,242 # 80026758 <sb>
    8000366e:	854a                	mv	a0,s2
    80003670:	00001097          	auipc	ra,0x1
    80003674:	b38080e7          	jalr	-1224(ra) # 800041a8 <initlog>
}
    80003678:	70a2                	ld	ra,40(sp)
    8000367a:	7402                	ld	s0,32(sp)
    8000367c:	64e2                	ld	s1,24(sp)
    8000367e:	6942                	ld	s2,16(sp)
    80003680:	69a2                	ld	s3,8(sp)
    80003682:	6145                	addi	sp,sp,48
    80003684:	8082                	ret
    panic("invalid file system");
    80003686:	00005517          	auipc	a0,0x5
    8000368a:	02250513          	addi	a0,a0,34 # 800086a8 <userret+0x618>
    8000368e:	ffffd097          	auipc	ra,0xffffd
    80003692:	eba080e7          	jalr	-326(ra) # 80000548 <panic>

0000000080003696 <iinit>:
{
    80003696:	7179                	addi	sp,sp,-48
    80003698:	f406                	sd	ra,40(sp)
    8000369a:	f022                	sd	s0,32(sp)
    8000369c:	ec26                	sd	s1,24(sp)
    8000369e:	e84a                	sd	s2,16(sp)
    800036a0:	e44e                	sd	s3,8(sp)
    800036a2:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    800036a4:	00005597          	auipc	a1,0x5
    800036a8:	01c58593          	addi	a1,a1,28 # 800086c0 <userret+0x630>
    800036ac:	00023517          	auipc	a0,0x23
    800036b0:	0cc50513          	addi	a0,a0,204 # 80026778 <icache>
    800036b4:	ffffd097          	auipc	ra,0xffffd
    800036b8:	428080e7          	jalr	1064(ra) # 80000adc <initlock>
  for(i = 0; i < NINODE; i++) {
    800036bc:	00023497          	auipc	s1,0x23
    800036c0:	0ec48493          	addi	s1,s1,236 # 800267a8 <icache+0x30>
    800036c4:	00025997          	auipc	s3,0x25
    800036c8:	d0498993          	addi	s3,s3,-764 # 800283c8 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    800036cc:	00005917          	auipc	s2,0x5
    800036d0:	ffc90913          	addi	s2,s2,-4 # 800086c8 <userret+0x638>
    800036d4:	85ca                	mv	a1,s2
    800036d6:	8526                	mv	a0,s1
    800036d8:	00001097          	auipc	ra,0x1
    800036dc:	f28080e7          	jalr	-216(ra) # 80004600 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800036e0:	09048493          	addi	s1,s1,144
    800036e4:	ff3498e3          	bne	s1,s3,800036d4 <iinit+0x3e>
}
    800036e8:	70a2                	ld	ra,40(sp)
    800036ea:	7402                	ld	s0,32(sp)
    800036ec:	64e2                	ld	s1,24(sp)
    800036ee:	6942                	ld	s2,16(sp)
    800036f0:	69a2                	ld	s3,8(sp)
    800036f2:	6145                	addi	sp,sp,48
    800036f4:	8082                	ret

00000000800036f6 <ialloc>:
{
    800036f6:	715d                	addi	sp,sp,-80
    800036f8:	e486                	sd	ra,72(sp)
    800036fa:	e0a2                	sd	s0,64(sp)
    800036fc:	fc26                	sd	s1,56(sp)
    800036fe:	f84a                	sd	s2,48(sp)
    80003700:	f44e                	sd	s3,40(sp)
    80003702:	f052                	sd	s4,32(sp)
    80003704:	ec56                	sd	s5,24(sp)
    80003706:	e85a                	sd	s6,16(sp)
    80003708:	e45e                	sd	s7,8(sp)
    8000370a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000370c:	00023717          	auipc	a4,0x23
    80003710:	05872703          	lw	a4,88(a4) # 80026764 <sb+0xc>
    80003714:	4785                	li	a5,1
    80003716:	04e7fa63          	bgeu	a5,a4,8000376a <ialloc+0x74>
    8000371a:	8aaa                	mv	s5,a0
    8000371c:	8bae                	mv	s7,a1
    8000371e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003720:	00023a17          	auipc	s4,0x23
    80003724:	038a0a13          	addi	s4,s4,56 # 80026758 <sb>
    80003728:	00048b1b          	sext.w	s6,s1
    8000372c:	0044d793          	srli	a5,s1,0x4
    80003730:	018a2583          	lw	a1,24(s4)
    80003734:	9dbd                	addw	a1,a1,a5
    80003736:	8556                	mv	a0,s5
    80003738:	00000097          	auipc	ra,0x0
    8000373c:	84a080e7          	jalr	-1974(ra) # 80002f82 <bread>
    80003740:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003742:	06050993          	addi	s3,a0,96
    80003746:	00f4f793          	andi	a5,s1,15
    8000374a:	079a                	slli	a5,a5,0x6
    8000374c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000374e:	00099783          	lh	a5,0(s3)
    80003752:	c785                	beqz	a5,8000377a <ialloc+0x84>
    brelse(bp);
    80003754:	00000097          	auipc	ra,0x0
    80003758:	a22080e7          	jalr	-1502(ra) # 80003176 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000375c:	0485                	addi	s1,s1,1
    8000375e:	00ca2703          	lw	a4,12(s4)
    80003762:	0004879b          	sext.w	a5,s1
    80003766:	fce7e1e3          	bltu	a5,a4,80003728 <ialloc+0x32>
  panic("ialloc: no inodes");
    8000376a:	00005517          	auipc	a0,0x5
    8000376e:	f6650513          	addi	a0,a0,-154 # 800086d0 <userret+0x640>
    80003772:	ffffd097          	auipc	ra,0xffffd
    80003776:	dd6080e7          	jalr	-554(ra) # 80000548 <panic>
      memset(dip, 0, sizeof(*dip));
    8000377a:	04000613          	li	a2,64
    8000377e:	4581                	li	a1,0
    80003780:	854e                	mv	a0,s3
    80003782:	ffffd097          	auipc	ra,0xffffd
    80003786:	716080e7          	jalr	1814(ra) # 80000e98 <memset>
      dip->type = type;
    8000378a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000378e:	854a                	mv	a0,s2
    80003790:	00001097          	auipc	ra,0x1
    80003794:	d30080e7          	jalr	-720(ra) # 800044c0 <log_write>
      brelse(bp);
    80003798:	854a                	mv	a0,s2
    8000379a:	00000097          	auipc	ra,0x0
    8000379e:	9dc080e7          	jalr	-1572(ra) # 80003176 <brelse>
      return iget(dev, inum);
    800037a2:	85da                	mv	a1,s6
    800037a4:	8556                	mv	a0,s5
    800037a6:	00000097          	auipc	ra,0x0
    800037aa:	db4080e7          	jalr	-588(ra) # 8000355a <iget>
}
    800037ae:	60a6                	ld	ra,72(sp)
    800037b0:	6406                	ld	s0,64(sp)
    800037b2:	74e2                	ld	s1,56(sp)
    800037b4:	7942                	ld	s2,48(sp)
    800037b6:	79a2                	ld	s3,40(sp)
    800037b8:	7a02                	ld	s4,32(sp)
    800037ba:	6ae2                	ld	s5,24(sp)
    800037bc:	6b42                	ld	s6,16(sp)
    800037be:	6ba2                	ld	s7,8(sp)
    800037c0:	6161                	addi	sp,sp,80
    800037c2:	8082                	ret

00000000800037c4 <iupdate>:
{
    800037c4:	1101                	addi	sp,sp,-32
    800037c6:	ec06                	sd	ra,24(sp)
    800037c8:	e822                	sd	s0,16(sp)
    800037ca:	e426                	sd	s1,8(sp)
    800037cc:	e04a                	sd	s2,0(sp)
    800037ce:	1000                	addi	s0,sp,32
    800037d0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037d2:	415c                	lw	a5,4(a0)
    800037d4:	0047d79b          	srliw	a5,a5,0x4
    800037d8:	00023597          	auipc	a1,0x23
    800037dc:	f985a583          	lw	a1,-104(a1) # 80026770 <sb+0x18>
    800037e0:	9dbd                	addw	a1,a1,a5
    800037e2:	4108                	lw	a0,0(a0)
    800037e4:	fffff097          	auipc	ra,0xfffff
    800037e8:	79e080e7          	jalr	1950(ra) # 80002f82 <bread>
    800037ec:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800037ee:	06050793          	addi	a5,a0,96
    800037f2:	40c8                	lw	a0,4(s1)
    800037f4:	893d                	andi	a0,a0,15
    800037f6:	051a                	slli	a0,a0,0x6
    800037f8:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800037fa:	04c49703          	lh	a4,76(s1)
    800037fe:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003802:	04e49703          	lh	a4,78(s1)
    80003806:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    8000380a:	05049703          	lh	a4,80(s1)
    8000380e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003812:	05249703          	lh	a4,82(s1)
    80003816:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    8000381a:	48f8                	lw	a4,84(s1)
    8000381c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000381e:	03400613          	li	a2,52
    80003822:	05848593          	addi	a1,s1,88
    80003826:	0531                	addi	a0,a0,12
    80003828:	ffffd097          	auipc	ra,0xffffd
    8000382c:	6cc080e7          	jalr	1740(ra) # 80000ef4 <memmove>
  log_write(bp);
    80003830:	854a                	mv	a0,s2
    80003832:	00001097          	auipc	ra,0x1
    80003836:	c8e080e7          	jalr	-882(ra) # 800044c0 <log_write>
  brelse(bp);
    8000383a:	854a                	mv	a0,s2
    8000383c:	00000097          	auipc	ra,0x0
    80003840:	93a080e7          	jalr	-1734(ra) # 80003176 <brelse>
}
    80003844:	60e2                	ld	ra,24(sp)
    80003846:	6442                	ld	s0,16(sp)
    80003848:	64a2                	ld	s1,8(sp)
    8000384a:	6902                	ld	s2,0(sp)
    8000384c:	6105                	addi	sp,sp,32
    8000384e:	8082                	ret

0000000080003850 <idup>:
{
    80003850:	1101                	addi	sp,sp,-32
    80003852:	ec06                	sd	ra,24(sp)
    80003854:	e822                	sd	s0,16(sp)
    80003856:	e426                	sd	s1,8(sp)
    80003858:	1000                	addi	s0,sp,32
    8000385a:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000385c:	00023517          	auipc	a0,0x23
    80003860:	f1c50513          	addi	a0,a0,-228 # 80026778 <icache>
    80003864:	ffffd097          	auipc	ra,0xffffd
    80003868:	3c6080e7          	jalr	966(ra) # 80000c2a <acquire>
  ip->ref++;
    8000386c:	449c                	lw	a5,8(s1)
    8000386e:	2785                	addiw	a5,a5,1
    80003870:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003872:	00023517          	auipc	a0,0x23
    80003876:	f0650513          	addi	a0,a0,-250 # 80026778 <icache>
    8000387a:	ffffd097          	auipc	ra,0xffffd
    8000387e:	420080e7          	jalr	1056(ra) # 80000c9a <release>
}
    80003882:	8526                	mv	a0,s1
    80003884:	60e2                	ld	ra,24(sp)
    80003886:	6442                	ld	s0,16(sp)
    80003888:	64a2                	ld	s1,8(sp)
    8000388a:	6105                	addi	sp,sp,32
    8000388c:	8082                	ret

000000008000388e <ilock>:
{
    8000388e:	1101                	addi	sp,sp,-32
    80003890:	ec06                	sd	ra,24(sp)
    80003892:	e822                	sd	s0,16(sp)
    80003894:	e426                	sd	s1,8(sp)
    80003896:	e04a                	sd	s2,0(sp)
    80003898:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000389a:	c115                	beqz	a0,800038be <ilock+0x30>
    8000389c:	84aa                	mv	s1,a0
    8000389e:	451c                	lw	a5,8(a0)
    800038a0:	00f05f63          	blez	a5,800038be <ilock+0x30>
  acquiresleep(&ip->lock);
    800038a4:	0541                	addi	a0,a0,16
    800038a6:	00001097          	auipc	ra,0x1
    800038aa:	d94080e7          	jalr	-620(ra) # 8000463a <acquiresleep>
  if(ip->valid == 0){
    800038ae:	44bc                	lw	a5,72(s1)
    800038b0:	cf99                	beqz	a5,800038ce <ilock+0x40>
}
    800038b2:	60e2                	ld	ra,24(sp)
    800038b4:	6442                	ld	s0,16(sp)
    800038b6:	64a2                	ld	s1,8(sp)
    800038b8:	6902                	ld	s2,0(sp)
    800038ba:	6105                	addi	sp,sp,32
    800038bc:	8082                	ret
    panic("ilock");
    800038be:	00005517          	auipc	a0,0x5
    800038c2:	e2a50513          	addi	a0,a0,-470 # 800086e8 <userret+0x658>
    800038c6:	ffffd097          	auipc	ra,0xffffd
    800038ca:	c82080e7          	jalr	-894(ra) # 80000548 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800038ce:	40dc                	lw	a5,4(s1)
    800038d0:	0047d79b          	srliw	a5,a5,0x4
    800038d4:	00023597          	auipc	a1,0x23
    800038d8:	e9c5a583          	lw	a1,-356(a1) # 80026770 <sb+0x18>
    800038dc:	9dbd                	addw	a1,a1,a5
    800038de:	4088                	lw	a0,0(s1)
    800038e0:	fffff097          	auipc	ra,0xfffff
    800038e4:	6a2080e7          	jalr	1698(ra) # 80002f82 <bread>
    800038e8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800038ea:	06050593          	addi	a1,a0,96
    800038ee:	40dc                	lw	a5,4(s1)
    800038f0:	8bbd                	andi	a5,a5,15
    800038f2:	079a                	slli	a5,a5,0x6
    800038f4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800038f6:	00059783          	lh	a5,0(a1)
    800038fa:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    800038fe:	00259783          	lh	a5,2(a1)
    80003902:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80003906:	00459783          	lh	a5,4(a1)
    8000390a:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    8000390e:	00659783          	lh	a5,6(a1)
    80003912:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80003916:	459c                	lw	a5,8(a1)
    80003918:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000391a:	03400613          	li	a2,52
    8000391e:	05b1                	addi	a1,a1,12
    80003920:	05848513          	addi	a0,s1,88
    80003924:	ffffd097          	auipc	ra,0xffffd
    80003928:	5d0080e7          	jalr	1488(ra) # 80000ef4 <memmove>
    brelse(bp);
    8000392c:	854a                	mv	a0,s2
    8000392e:	00000097          	auipc	ra,0x0
    80003932:	848080e7          	jalr	-1976(ra) # 80003176 <brelse>
    ip->valid = 1;
    80003936:	4785                	li	a5,1
    80003938:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    8000393a:	04c49783          	lh	a5,76(s1)
    8000393e:	fbb5                	bnez	a5,800038b2 <ilock+0x24>
      panic("ilock: no type");
    80003940:	00005517          	auipc	a0,0x5
    80003944:	db050513          	addi	a0,a0,-592 # 800086f0 <userret+0x660>
    80003948:	ffffd097          	auipc	ra,0xffffd
    8000394c:	c00080e7          	jalr	-1024(ra) # 80000548 <panic>

0000000080003950 <iunlock>:
{
    80003950:	1101                	addi	sp,sp,-32
    80003952:	ec06                	sd	ra,24(sp)
    80003954:	e822                	sd	s0,16(sp)
    80003956:	e426                	sd	s1,8(sp)
    80003958:	e04a                	sd	s2,0(sp)
    8000395a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000395c:	c905                	beqz	a0,8000398c <iunlock+0x3c>
    8000395e:	84aa                	mv	s1,a0
    80003960:	01050913          	addi	s2,a0,16
    80003964:	854a                	mv	a0,s2
    80003966:	00001097          	auipc	ra,0x1
    8000396a:	d6e080e7          	jalr	-658(ra) # 800046d4 <holdingsleep>
    8000396e:	cd19                	beqz	a0,8000398c <iunlock+0x3c>
    80003970:	449c                	lw	a5,8(s1)
    80003972:	00f05d63          	blez	a5,8000398c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003976:	854a                	mv	a0,s2
    80003978:	00001097          	auipc	ra,0x1
    8000397c:	d18080e7          	jalr	-744(ra) # 80004690 <releasesleep>
}
    80003980:	60e2                	ld	ra,24(sp)
    80003982:	6442                	ld	s0,16(sp)
    80003984:	64a2                	ld	s1,8(sp)
    80003986:	6902                	ld	s2,0(sp)
    80003988:	6105                	addi	sp,sp,32
    8000398a:	8082                	ret
    panic("iunlock");
    8000398c:	00005517          	auipc	a0,0x5
    80003990:	d7450513          	addi	a0,a0,-652 # 80008700 <userret+0x670>
    80003994:	ffffd097          	auipc	ra,0xffffd
    80003998:	bb4080e7          	jalr	-1100(ra) # 80000548 <panic>

000000008000399c <iput>:
{
    8000399c:	7139                	addi	sp,sp,-64
    8000399e:	fc06                	sd	ra,56(sp)
    800039a0:	f822                	sd	s0,48(sp)
    800039a2:	f426                	sd	s1,40(sp)
    800039a4:	f04a                	sd	s2,32(sp)
    800039a6:	ec4e                	sd	s3,24(sp)
    800039a8:	e852                	sd	s4,16(sp)
    800039aa:	e456                	sd	s5,8(sp)
    800039ac:	0080                	addi	s0,sp,64
    800039ae:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800039b0:	00023517          	auipc	a0,0x23
    800039b4:	dc850513          	addi	a0,a0,-568 # 80026778 <icache>
    800039b8:	ffffd097          	auipc	ra,0xffffd
    800039bc:	272080e7          	jalr	626(ra) # 80000c2a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039c0:	4498                	lw	a4,8(s1)
    800039c2:	4785                	li	a5,1
    800039c4:	02f70663          	beq	a4,a5,800039f0 <iput+0x54>
  ip->ref--;
    800039c8:	449c                	lw	a5,8(s1)
    800039ca:	37fd                	addiw	a5,a5,-1
    800039cc:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800039ce:	00023517          	auipc	a0,0x23
    800039d2:	daa50513          	addi	a0,a0,-598 # 80026778 <icache>
    800039d6:	ffffd097          	auipc	ra,0xffffd
    800039da:	2c4080e7          	jalr	708(ra) # 80000c9a <release>
}
    800039de:	70e2                	ld	ra,56(sp)
    800039e0:	7442                	ld	s0,48(sp)
    800039e2:	74a2                	ld	s1,40(sp)
    800039e4:	7902                	ld	s2,32(sp)
    800039e6:	69e2                	ld	s3,24(sp)
    800039e8:	6a42                	ld	s4,16(sp)
    800039ea:	6aa2                	ld	s5,8(sp)
    800039ec:	6121                	addi	sp,sp,64
    800039ee:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039f0:	44bc                	lw	a5,72(s1)
    800039f2:	dbf9                	beqz	a5,800039c8 <iput+0x2c>
    800039f4:	05249783          	lh	a5,82(s1)
    800039f8:	fbe1                	bnez	a5,800039c8 <iput+0x2c>
    acquiresleep(&ip->lock);
    800039fa:	01048a13          	addi	s4,s1,16
    800039fe:	8552                	mv	a0,s4
    80003a00:	00001097          	auipc	ra,0x1
    80003a04:	c3a080e7          	jalr	-966(ra) # 8000463a <acquiresleep>
    release(&icache.lock);
    80003a08:	00023517          	auipc	a0,0x23
    80003a0c:	d7050513          	addi	a0,a0,-656 # 80026778 <icache>
    80003a10:	ffffd097          	auipc	ra,0xffffd
    80003a14:	28a080e7          	jalr	650(ra) # 80000c9a <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003a18:	05848913          	addi	s2,s1,88
    80003a1c:	08848993          	addi	s3,s1,136
    80003a20:	a021                	j	80003a28 <iput+0x8c>
    80003a22:	0911                	addi	s2,s2,4
    80003a24:	01390d63          	beq	s2,s3,80003a3e <iput+0xa2>
    if(ip->addrs[i]){
    80003a28:	00092583          	lw	a1,0(s2)
    80003a2c:	d9fd                	beqz	a1,80003a22 <iput+0x86>
      bfree(ip->dev, ip->addrs[i]);
    80003a2e:	4088                	lw	a0,0(s1)
    80003a30:	00000097          	auipc	ra,0x0
    80003a34:	8a0080e7          	jalr	-1888(ra) # 800032d0 <bfree>
      ip->addrs[i] = 0;
    80003a38:	00092023          	sw	zero,0(s2)
    80003a3c:	b7dd                	j	80003a22 <iput+0x86>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003a3e:	0884a583          	lw	a1,136(s1)
    80003a42:	ed9d                	bnez	a1,80003a80 <iput+0xe4>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003a44:	0404aa23          	sw	zero,84(s1)
  iupdate(ip);
    80003a48:	8526                	mv	a0,s1
    80003a4a:	00000097          	auipc	ra,0x0
    80003a4e:	d7a080e7          	jalr	-646(ra) # 800037c4 <iupdate>
    ip->type = 0;
    80003a52:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80003a56:	8526                	mv	a0,s1
    80003a58:	00000097          	auipc	ra,0x0
    80003a5c:	d6c080e7          	jalr	-660(ra) # 800037c4 <iupdate>
    ip->valid = 0;
    80003a60:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    80003a64:	8552                	mv	a0,s4
    80003a66:	00001097          	auipc	ra,0x1
    80003a6a:	c2a080e7          	jalr	-982(ra) # 80004690 <releasesleep>
    acquire(&icache.lock);
    80003a6e:	00023517          	auipc	a0,0x23
    80003a72:	d0a50513          	addi	a0,a0,-758 # 80026778 <icache>
    80003a76:	ffffd097          	auipc	ra,0xffffd
    80003a7a:	1b4080e7          	jalr	436(ra) # 80000c2a <acquire>
    80003a7e:	b7a9                	j	800039c8 <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003a80:	4088                	lw	a0,0(s1)
    80003a82:	fffff097          	auipc	ra,0xfffff
    80003a86:	500080e7          	jalr	1280(ra) # 80002f82 <bread>
    80003a8a:	8aaa                	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
    80003a8c:	06050913          	addi	s2,a0,96
    80003a90:	46050993          	addi	s3,a0,1120
    80003a94:	a021                	j	80003a9c <iput+0x100>
    80003a96:	0911                	addi	s2,s2,4
    80003a98:	01390b63          	beq	s2,s3,80003aae <iput+0x112>
      if(a[j])
    80003a9c:	00092583          	lw	a1,0(s2)
    80003aa0:	d9fd                	beqz	a1,80003a96 <iput+0xfa>
        bfree(ip->dev, a[j]);
    80003aa2:	4088                	lw	a0,0(s1)
    80003aa4:	00000097          	auipc	ra,0x0
    80003aa8:	82c080e7          	jalr	-2004(ra) # 800032d0 <bfree>
    80003aac:	b7ed                	j	80003a96 <iput+0xfa>
    brelse(bp);
    80003aae:	8556                	mv	a0,s5
    80003ab0:	fffff097          	auipc	ra,0xfffff
    80003ab4:	6c6080e7          	jalr	1734(ra) # 80003176 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003ab8:	0884a583          	lw	a1,136(s1)
    80003abc:	4088                	lw	a0,0(s1)
    80003abe:	00000097          	auipc	ra,0x0
    80003ac2:	812080e7          	jalr	-2030(ra) # 800032d0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003ac6:	0804a423          	sw	zero,136(s1)
    80003aca:	bfad                	j	80003a44 <iput+0xa8>

0000000080003acc <iunlockput>:
{
    80003acc:	1101                	addi	sp,sp,-32
    80003ace:	ec06                	sd	ra,24(sp)
    80003ad0:	e822                	sd	s0,16(sp)
    80003ad2:	e426                	sd	s1,8(sp)
    80003ad4:	1000                	addi	s0,sp,32
    80003ad6:	84aa                	mv	s1,a0
  iunlock(ip);
    80003ad8:	00000097          	auipc	ra,0x0
    80003adc:	e78080e7          	jalr	-392(ra) # 80003950 <iunlock>
  iput(ip);
    80003ae0:	8526                	mv	a0,s1
    80003ae2:	00000097          	auipc	ra,0x0
    80003ae6:	eba080e7          	jalr	-326(ra) # 8000399c <iput>
}
    80003aea:	60e2                	ld	ra,24(sp)
    80003aec:	6442                	ld	s0,16(sp)
    80003aee:	64a2                	ld	s1,8(sp)
    80003af0:	6105                	addi	sp,sp,32
    80003af2:	8082                	ret

0000000080003af4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003af4:	1141                	addi	sp,sp,-16
    80003af6:	e422                	sd	s0,8(sp)
    80003af8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003afa:	411c                	lw	a5,0(a0)
    80003afc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003afe:	415c                	lw	a5,4(a0)
    80003b00:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003b02:	04c51783          	lh	a5,76(a0)
    80003b06:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003b0a:	05251783          	lh	a5,82(a0)
    80003b0e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003b12:	05456783          	lwu	a5,84(a0)
    80003b16:	e99c                	sd	a5,16(a1)
}
    80003b18:	6422                	ld	s0,8(sp)
    80003b1a:	0141                	addi	sp,sp,16
    80003b1c:	8082                	ret

0000000080003b1e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b1e:	497c                	lw	a5,84(a0)
    80003b20:	0ed7e563          	bltu	a5,a3,80003c0a <readi+0xec>
{
    80003b24:	7159                	addi	sp,sp,-112
    80003b26:	f486                	sd	ra,104(sp)
    80003b28:	f0a2                	sd	s0,96(sp)
    80003b2a:	eca6                	sd	s1,88(sp)
    80003b2c:	e8ca                	sd	s2,80(sp)
    80003b2e:	e4ce                	sd	s3,72(sp)
    80003b30:	e0d2                	sd	s4,64(sp)
    80003b32:	fc56                	sd	s5,56(sp)
    80003b34:	f85a                	sd	s6,48(sp)
    80003b36:	f45e                	sd	s7,40(sp)
    80003b38:	f062                	sd	s8,32(sp)
    80003b3a:	ec66                	sd	s9,24(sp)
    80003b3c:	e86a                	sd	s10,16(sp)
    80003b3e:	e46e                	sd	s11,8(sp)
    80003b40:	1880                	addi	s0,sp,112
    80003b42:	8baa                	mv	s7,a0
    80003b44:	8c2e                	mv	s8,a1
    80003b46:	8ab2                	mv	s5,a2
    80003b48:	8936                	mv	s2,a3
    80003b4a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b4c:	9f35                	addw	a4,a4,a3
    80003b4e:	0cd76063          	bltu	a4,a3,80003c0e <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    80003b52:	00e7f463          	bgeu	a5,a4,80003b5a <readi+0x3c>
    n = ip->size - off;
    80003b56:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b5a:	080b0763          	beqz	s6,80003be8 <readi+0xca>
    80003b5e:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b60:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003b64:	5cfd                	li	s9,-1
    80003b66:	a82d                	j	80003ba0 <readi+0x82>
    80003b68:	02099d93          	slli	s11,s3,0x20
    80003b6c:	020ddd93          	srli	s11,s11,0x20
    80003b70:	06048793          	addi	a5,s1,96
    80003b74:	86ee                	mv	a3,s11
    80003b76:	963e                	add	a2,a2,a5
    80003b78:	85d6                	mv	a1,s5
    80003b7a:	8562                	mv	a0,s8
    80003b7c:	fffff097          	auipc	ra,0xfffff
    80003b80:	a36080e7          	jalr	-1482(ra) # 800025b2 <either_copyout>
    80003b84:	05950d63          	beq	a0,s9,80003bde <readi+0xc0>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003b88:	8526                	mv	a0,s1
    80003b8a:	fffff097          	auipc	ra,0xfffff
    80003b8e:	5ec080e7          	jalr	1516(ra) # 80003176 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b92:	01498a3b          	addw	s4,s3,s4
    80003b96:	0129893b          	addw	s2,s3,s2
    80003b9a:	9aee                	add	s5,s5,s11
    80003b9c:	056a7663          	bgeu	s4,s6,80003be8 <readi+0xca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003ba0:	000ba483          	lw	s1,0(s7)
    80003ba4:	00a9559b          	srliw	a1,s2,0xa
    80003ba8:	855e                	mv	a0,s7
    80003baa:	00000097          	auipc	ra,0x0
    80003bae:	8d4080e7          	jalr	-1836(ra) # 8000347e <bmap>
    80003bb2:	0005059b          	sext.w	a1,a0
    80003bb6:	8526                	mv	a0,s1
    80003bb8:	fffff097          	auipc	ra,0xfffff
    80003bbc:	3ca080e7          	jalr	970(ra) # 80002f82 <bread>
    80003bc0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bc2:	3ff97613          	andi	a2,s2,1023
    80003bc6:	40cd07bb          	subw	a5,s10,a2
    80003bca:	414b073b          	subw	a4,s6,s4
    80003bce:	89be                	mv	s3,a5
    80003bd0:	2781                	sext.w	a5,a5
    80003bd2:	0007069b          	sext.w	a3,a4
    80003bd6:	f8f6f9e3          	bgeu	a3,a5,80003b68 <readi+0x4a>
    80003bda:	89ba                	mv	s3,a4
    80003bdc:	b771                	j	80003b68 <readi+0x4a>
      brelse(bp);
    80003bde:	8526                	mv	a0,s1
    80003be0:	fffff097          	auipc	ra,0xfffff
    80003be4:	596080e7          	jalr	1430(ra) # 80003176 <brelse>
  }
  return n;
    80003be8:	000b051b          	sext.w	a0,s6
}
    80003bec:	70a6                	ld	ra,104(sp)
    80003bee:	7406                	ld	s0,96(sp)
    80003bf0:	64e6                	ld	s1,88(sp)
    80003bf2:	6946                	ld	s2,80(sp)
    80003bf4:	69a6                	ld	s3,72(sp)
    80003bf6:	6a06                	ld	s4,64(sp)
    80003bf8:	7ae2                	ld	s5,56(sp)
    80003bfa:	7b42                	ld	s6,48(sp)
    80003bfc:	7ba2                	ld	s7,40(sp)
    80003bfe:	7c02                	ld	s8,32(sp)
    80003c00:	6ce2                	ld	s9,24(sp)
    80003c02:	6d42                	ld	s10,16(sp)
    80003c04:	6da2                	ld	s11,8(sp)
    80003c06:	6165                	addi	sp,sp,112
    80003c08:	8082                	ret
    return -1;
    80003c0a:	557d                	li	a0,-1
}
    80003c0c:	8082                	ret
    return -1;
    80003c0e:	557d                	li	a0,-1
    80003c10:	bff1                	j	80003bec <readi+0xce>

0000000080003c12 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003c12:	497c                	lw	a5,84(a0)
    80003c14:	10d7e663          	bltu	a5,a3,80003d20 <writei+0x10e>
{
    80003c18:	7159                	addi	sp,sp,-112
    80003c1a:	f486                	sd	ra,104(sp)
    80003c1c:	f0a2                	sd	s0,96(sp)
    80003c1e:	eca6                	sd	s1,88(sp)
    80003c20:	e8ca                	sd	s2,80(sp)
    80003c22:	e4ce                	sd	s3,72(sp)
    80003c24:	e0d2                	sd	s4,64(sp)
    80003c26:	fc56                	sd	s5,56(sp)
    80003c28:	f85a                	sd	s6,48(sp)
    80003c2a:	f45e                	sd	s7,40(sp)
    80003c2c:	f062                	sd	s8,32(sp)
    80003c2e:	ec66                	sd	s9,24(sp)
    80003c30:	e86a                	sd	s10,16(sp)
    80003c32:	e46e                	sd	s11,8(sp)
    80003c34:	1880                	addi	s0,sp,112
    80003c36:	8baa                	mv	s7,a0
    80003c38:	8c2e                	mv	s8,a1
    80003c3a:	8ab2                	mv	s5,a2
    80003c3c:	8936                	mv	s2,a3
    80003c3e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003c40:	00e687bb          	addw	a5,a3,a4
    80003c44:	0ed7e063          	bltu	a5,a3,80003d24 <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003c48:	00043737          	lui	a4,0x43
    80003c4c:	0cf76e63          	bltu	a4,a5,80003d28 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c50:	0a0b0763          	beqz	s6,80003cfe <writei+0xec>
    80003c54:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c56:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003c5a:	5cfd                	li	s9,-1
    80003c5c:	a091                	j	80003ca0 <writei+0x8e>
    80003c5e:	02099d93          	slli	s11,s3,0x20
    80003c62:	020ddd93          	srli	s11,s11,0x20
    80003c66:	06048793          	addi	a5,s1,96
    80003c6a:	86ee                	mv	a3,s11
    80003c6c:	8656                	mv	a2,s5
    80003c6e:	85e2                	mv	a1,s8
    80003c70:	953e                	add	a0,a0,a5
    80003c72:	fffff097          	auipc	ra,0xfffff
    80003c76:	996080e7          	jalr	-1642(ra) # 80002608 <either_copyin>
    80003c7a:	07950263          	beq	a0,s9,80003cde <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003c7e:	8526                	mv	a0,s1
    80003c80:	00001097          	auipc	ra,0x1
    80003c84:	840080e7          	jalr	-1984(ra) # 800044c0 <log_write>
    brelse(bp);
    80003c88:	8526                	mv	a0,s1
    80003c8a:	fffff097          	auipc	ra,0xfffff
    80003c8e:	4ec080e7          	jalr	1260(ra) # 80003176 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c92:	01498a3b          	addw	s4,s3,s4
    80003c96:	0129893b          	addw	s2,s3,s2
    80003c9a:	9aee                	add	s5,s5,s11
    80003c9c:	056a7663          	bgeu	s4,s6,80003ce8 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003ca0:	000ba483          	lw	s1,0(s7)
    80003ca4:	00a9559b          	srliw	a1,s2,0xa
    80003ca8:	855e                	mv	a0,s7
    80003caa:	fffff097          	auipc	ra,0xfffff
    80003cae:	7d4080e7          	jalr	2004(ra) # 8000347e <bmap>
    80003cb2:	0005059b          	sext.w	a1,a0
    80003cb6:	8526                	mv	a0,s1
    80003cb8:	fffff097          	auipc	ra,0xfffff
    80003cbc:	2ca080e7          	jalr	714(ra) # 80002f82 <bread>
    80003cc0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003cc2:	3ff97513          	andi	a0,s2,1023
    80003cc6:	40ad07bb          	subw	a5,s10,a0
    80003cca:	414b073b          	subw	a4,s6,s4
    80003cce:	89be                	mv	s3,a5
    80003cd0:	2781                	sext.w	a5,a5
    80003cd2:	0007069b          	sext.w	a3,a4
    80003cd6:	f8f6f4e3          	bgeu	a3,a5,80003c5e <writei+0x4c>
    80003cda:	89ba                	mv	s3,a4
    80003cdc:	b749                	j	80003c5e <writei+0x4c>
      brelse(bp);
    80003cde:	8526                	mv	a0,s1
    80003ce0:	fffff097          	auipc	ra,0xfffff
    80003ce4:	496080e7          	jalr	1174(ra) # 80003176 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003ce8:	054ba783          	lw	a5,84(s7)
    80003cec:	0127f463          	bgeu	a5,s2,80003cf4 <writei+0xe2>
      ip->size = off;
    80003cf0:	052baa23          	sw	s2,84(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003cf4:	855e                	mv	a0,s7
    80003cf6:	00000097          	auipc	ra,0x0
    80003cfa:	ace080e7          	jalr	-1330(ra) # 800037c4 <iupdate>
  }

  return n;
    80003cfe:	000b051b          	sext.w	a0,s6
}
    80003d02:	70a6                	ld	ra,104(sp)
    80003d04:	7406                	ld	s0,96(sp)
    80003d06:	64e6                	ld	s1,88(sp)
    80003d08:	6946                	ld	s2,80(sp)
    80003d0a:	69a6                	ld	s3,72(sp)
    80003d0c:	6a06                	ld	s4,64(sp)
    80003d0e:	7ae2                	ld	s5,56(sp)
    80003d10:	7b42                	ld	s6,48(sp)
    80003d12:	7ba2                	ld	s7,40(sp)
    80003d14:	7c02                	ld	s8,32(sp)
    80003d16:	6ce2                	ld	s9,24(sp)
    80003d18:	6d42                	ld	s10,16(sp)
    80003d1a:	6da2                	ld	s11,8(sp)
    80003d1c:	6165                	addi	sp,sp,112
    80003d1e:	8082                	ret
    return -1;
    80003d20:	557d                	li	a0,-1
}
    80003d22:	8082                	ret
    return -1;
    80003d24:	557d                	li	a0,-1
    80003d26:	bff1                	j	80003d02 <writei+0xf0>
    return -1;
    80003d28:	557d                	li	a0,-1
    80003d2a:	bfe1                	j	80003d02 <writei+0xf0>

0000000080003d2c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003d2c:	1141                	addi	sp,sp,-16
    80003d2e:	e406                	sd	ra,8(sp)
    80003d30:	e022                	sd	s0,0(sp)
    80003d32:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003d34:	4639                	li	a2,14
    80003d36:	ffffd097          	auipc	ra,0xffffd
    80003d3a:	23a080e7          	jalr	570(ra) # 80000f70 <strncmp>
}
    80003d3e:	60a2                	ld	ra,8(sp)
    80003d40:	6402                	ld	s0,0(sp)
    80003d42:	0141                	addi	sp,sp,16
    80003d44:	8082                	ret

0000000080003d46 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003d46:	7139                	addi	sp,sp,-64
    80003d48:	fc06                	sd	ra,56(sp)
    80003d4a:	f822                	sd	s0,48(sp)
    80003d4c:	f426                	sd	s1,40(sp)
    80003d4e:	f04a                	sd	s2,32(sp)
    80003d50:	ec4e                	sd	s3,24(sp)
    80003d52:	e852                	sd	s4,16(sp)
    80003d54:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003d56:	04c51703          	lh	a4,76(a0)
    80003d5a:	4785                	li	a5,1
    80003d5c:	00f71a63          	bne	a4,a5,80003d70 <dirlookup+0x2a>
    80003d60:	892a                	mv	s2,a0
    80003d62:	89ae                	mv	s3,a1
    80003d64:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d66:	497c                	lw	a5,84(a0)
    80003d68:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003d6a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d6c:	e79d                	bnez	a5,80003d9a <dirlookup+0x54>
    80003d6e:	a8a5                	j	80003de6 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003d70:	00005517          	auipc	a0,0x5
    80003d74:	99850513          	addi	a0,a0,-1640 # 80008708 <userret+0x678>
    80003d78:	ffffc097          	auipc	ra,0xffffc
    80003d7c:	7d0080e7          	jalr	2000(ra) # 80000548 <panic>
      panic("dirlookup read");
    80003d80:	00005517          	auipc	a0,0x5
    80003d84:	9a050513          	addi	a0,a0,-1632 # 80008720 <userret+0x690>
    80003d88:	ffffc097          	auipc	ra,0xffffc
    80003d8c:	7c0080e7          	jalr	1984(ra) # 80000548 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d90:	24c1                	addiw	s1,s1,16
    80003d92:	05492783          	lw	a5,84(s2)
    80003d96:	04f4f763          	bgeu	s1,a5,80003de4 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d9a:	4741                	li	a4,16
    80003d9c:	86a6                	mv	a3,s1
    80003d9e:	fc040613          	addi	a2,s0,-64
    80003da2:	4581                	li	a1,0
    80003da4:	854a                	mv	a0,s2
    80003da6:	00000097          	auipc	ra,0x0
    80003daa:	d78080e7          	jalr	-648(ra) # 80003b1e <readi>
    80003dae:	47c1                	li	a5,16
    80003db0:	fcf518e3          	bne	a0,a5,80003d80 <dirlookup+0x3a>
    if(de.inum == 0)
    80003db4:	fc045783          	lhu	a5,-64(s0)
    80003db8:	dfe1                	beqz	a5,80003d90 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003dba:	fc240593          	addi	a1,s0,-62
    80003dbe:	854e                	mv	a0,s3
    80003dc0:	00000097          	auipc	ra,0x0
    80003dc4:	f6c080e7          	jalr	-148(ra) # 80003d2c <namecmp>
    80003dc8:	f561                	bnez	a0,80003d90 <dirlookup+0x4a>
      if(poff)
    80003dca:	000a0463          	beqz	s4,80003dd2 <dirlookup+0x8c>
        *poff = off;
    80003dce:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003dd2:	fc045583          	lhu	a1,-64(s0)
    80003dd6:	00092503          	lw	a0,0(s2)
    80003dda:	fffff097          	auipc	ra,0xfffff
    80003dde:	780080e7          	jalr	1920(ra) # 8000355a <iget>
    80003de2:	a011                	j	80003de6 <dirlookup+0xa0>
  return 0;
    80003de4:	4501                	li	a0,0
}
    80003de6:	70e2                	ld	ra,56(sp)
    80003de8:	7442                	ld	s0,48(sp)
    80003dea:	74a2                	ld	s1,40(sp)
    80003dec:	7902                	ld	s2,32(sp)
    80003dee:	69e2                	ld	s3,24(sp)
    80003df0:	6a42                	ld	s4,16(sp)
    80003df2:	6121                	addi	sp,sp,64
    80003df4:	8082                	ret

0000000080003df6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003df6:	711d                	addi	sp,sp,-96
    80003df8:	ec86                	sd	ra,88(sp)
    80003dfa:	e8a2                	sd	s0,80(sp)
    80003dfc:	e4a6                	sd	s1,72(sp)
    80003dfe:	e0ca                	sd	s2,64(sp)
    80003e00:	fc4e                	sd	s3,56(sp)
    80003e02:	f852                	sd	s4,48(sp)
    80003e04:	f456                	sd	s5,40(sp)
    80003e06:	f05a                	sd	s6,32(sp)
    80003e08:	ec5e                	sd	s7,24(sp)
    80003e0a:	e862                	sd	s8,16(sp)
    80003e0c:	e466                	sd	s9,8(sp)
    80003e0e:	1080                	addi	s0,sp,96
    80003e10:	84aa                	mv	s1,a0
    80003e12:	8aae                	mv	s5,a1
    80003e14:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003e16:	00054703          	lbu	a4,0(a0)
    80003e1a:	02f00793          	li	a5,47
    80003e1e:	02f70363          	beq	a4,a5,80003e44 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003e22:	ffffe097          	auipc	ra,0xffffe
    80003e26:	d60080e7          	jalr	-672(ra) # 80001b82 <myproc>
    80003e2a:	15853503          	ld	a0,344(a0)
    80003e2e:	00000097          	auipc	ra,0x0
    80003e32:	a22080e7          	jalr	-1502(ra) # 80003850 <idup>
    80003e36:	89aa                	mv	s3,a0
  while(*path == '/')
    80003e38:	02f00913          	li	s2,47
  len = path - s;
    80003e3c:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003e3e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003e40:	4b85                	li	s7,1
    80003e42:	a865                	j	80003efa <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003e44:	4585                	li	a1,1
    80003e46:	4501                	li	a0,0
    80003e48:	fffff097          	auipc	ra,0xfffff
    80003e4c:	712080e7          	jalr	1810(ra) # 8000355a <iget>
    80003e50:	89aa                	mv	s3,a0
    80003e52:	b7dd                	j	80003e38 <namex+0x42>
      iunlockput(ip);
    80003e54:	854e                	mv	a0,s3
    80003e56:	00000097          	auipc	ra,0x0
    80003e5a:	c76080e7          	jalr	-906(ra) # 80003acc <iunlockput>
      return 0;
    80003e5e:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003e60:	854e                	mv	a0,s3
    80003e62:	60e6                	ld	ra,88(sp)
    80003e64:	6446                	ld	s0,80(sp)
    80003e66:	64a6                	ld	s1,72(sp)
    80003e68:	6906                	ld	s2,64(sp)
    80003e6a:	79e2                	ld	s3,56(sp)
    80003e6c:	7a42                	ld	s4,48(sp)
    80003e6e:	7aa2                	ld	s5,40(sp)
    80003e70:	7b02                	ld	s6,32(sp)
    80003e72:	6be2                	ld	s7,24(sp)
    80003e74:	6c42                	ld	s8,16(sp)
    80003e76:	6ca2                	ld	s9,8(sp)
    80003e78:	6125                	addi	sp,sp,96
    80003e7a:	8082                	ret
      iunlock(ip);
    80003e7c:	854e                	mv	a0,s3
    80003e7e:	00000097          	auipc	ra,0x0
    80003e82:	ad2080e7          	jalr	-1326(ra) # 80003950 <iunlock>
      return ip;
    80003e86:	bfe9                	j	80003e60 <namex+0x6a>
      iunlockput(ip);
    80003e88:	854e                	mv	a0,s3
    80003e8a:	00000097          	auipc	ra,0x0
    80003e8e:	c42080e7          	jalr	-958(ra) # 80003acc <iunlockput>
      return 0;
    80003e92:	89e6                	mv	s3,s9
    80003e94:	b7f1                	j	80003e60 <namex+0x6a>
  len = path - s;
    80003e96:	40b48633          	sub	a2,s1,a1
    80003e9a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003e9e:	099c5463          	bge	s8,s9,80003f26 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003ea2:	4639                	li	a2,14
    80003ea4:	8552                	mv	a0,s4
    80003ea6:	ffffd097          	auipc	ra,0xffffd
    80003eaa:	04e080e7          	jalr	78(ra) # 80000ef4 <memmove>
  while(*path == '/')
    80003eae:	0004c783          	lbu	a5,0(s1)
    80003eb2:	01279763          	bne	a5,s2,80003ec0 <namex+0xca>
    path++;
    80003eb6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003eb8:	0004c783          	lbu	a5,0(s1)
    80003ebc:	ff278de3          	beq	a5,s2,80003eb6 <namex+0xc0>
    ilock(ip);
    80003ec0:	854e                	mv	a0,s3
    80003ec2:	00000097          	auipc	ra,0x0
    80003ec6:	9cc080e7          	jalr	-1588(ra) # 8000388e <ilock>
    if(ip->type != T_DIR){
    80003eca:	04c99783          	lh	a5,76(s3)
    80003ece:	f97793e3          	bne	a5,s7,80003e54 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003ed2:	000a8563          	beqz	s5,80003edc <namex+0xe6>
    80003ed6:	0004c783          	lbu	a5,0(s1)
    80003eda:	d3cd                	beqz	a5,80003e7c <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003edc:	865a                	mv	a2,s6
    80003ede:	85d2                	mv	a1,s4
    80003ee0:	854e                	mv	a0,s3
    80003ee2:	00000097          	auipc	ra,0x0
    80003ee6:	e64080e7          	jalr	-412(ra) # 80003d46 <dirlookup>
    80003eea:	8caa                	mv	s9,a0
    80003eec:	dd51                	beqz	a0,80003e88 <namex+0x92>
    iunlockput(ip);
    80003eee:	854e                	mv	a0,s3
    80003ef0:	00000097          	auipc	ra,0x0
    80003ef4:	bdc080e7          	jalr	-1060(ra) # 80003acc <iunlockput>
    ip = next;
    80003ef8:	89e6                	mv	s3,s9
  while(*path == '/')
    80003efa:	0004c783          	lbu	a5,0(s1)
    80003efe:	05279763          	bne	a5,s2,80003f4c <namex+0x156>
    path++;
    80003f02:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003f04:	0004c783          	lbu	a5,0(s1)
    80003f08:	ff278de3          	beq	a5,s2,80003f02 <namex+0x10c>
  if(*path == 0)
    80003f0c:	c79d                	beqz	a5,80003f3a <namex+0x144>
    path++;
    80003f0e:	85a6                	mv	a1,s1
  len = path - s;
    80003f10:	8cda                	mv	s9,s6
    80003f12:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003f14:	01278963          	beq	a5,s2,80003f26 <namex+0x130>
    80003f18:	dfbd                	beqz	a5,80003e96 <namex+0xa0>
    path++;
    80003f1a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003f1c:	0004c783          	lbu	a5,0(s1)
    80003f20:	ff279ce3          	bne	a5,s2,80003f18 <namex+0x122>
    80003f24:	bf8d                	j	80003e96 <namex+0xa0>
    memmove(name, s, len);
    80003f26:	2601                	sext.w	a2,a2
    80003f28:	8552                	mv	a0,s4
    80003f2a:	ffffd097          	auipc	ra,0xffffd
    80003f2e:	fca080e7          	jalr	-54(ra) # 80000ef4 <memmove>
    name[len] = 0;
    80003f32:	9cd2                	add	s9,s9,s4
    80003f34:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003f38:	bf9d                	j	80003eae <namex+0xb8>
  if(nameiparent){
    80003f3a:	f20a83e3          	beqz	s5,80003e60 <namex+0x6a>
    iput(ip);
    80003f3e:	854e                	mv	a0,s3
    80003f40:	00000097          	auipc	ra,0x0
    80003f44:	a5c080e7          	jalr	-1444(ra) # 8000399c <iput>
    return 0;
    80003f48:	4981                	li	s3,0
    80003f4a:	bf19                	j	80003e60 <namex+0x6a>
  if(*path == 0)
    80003f4c:	d7fd                	beqz	a5,80003f3a <namex+0x144>
  while(*path != '/' && *path != 0)
    80003f4e:	0004c783          	lbu	a5,0(s1)
    80003f52:	85a6                	mv	a1,s1
    80003f54:	b7d1                	j	80003f18 <namex+0x122>

0000000080003f56 <dirlink>:
{
    80003f56:	7139                	addi	sp,sp,-64
    80003f58:	fc06                	sd	ra,56(sp)
    80003f5a:	f822                	sd	s0,48(sp)
    80003f5c:	f426                	sd	s1,40(sp)
    80003f5e:	f04a                	sd	s2,32(sp)
    80003f60:	ec4e                	sd	s3,24(sp)
    80003f62:	e852                	sd	s4,16(sp)
    80003f64:	0080                	addi	s0,sp,64
    80003f66:	892a                	mv	s2,a0
    80003f68:	8a2e                	mv	s4,a1
    80003f6a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003f6c:	4601                	li	a2,0
    80003f6e:	00000097          	auipc	ra,0x0
    80003f72:	dd8080e7          	jalr	-552(ra) # 80003d46 <dirlookup>
    80003f76:	e93d                	bnez	a0,80003fec <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f78:	05492483          	lw	s1,84(s2)
    80003f7c:	c49d                	beqz	s1,80003faa <dirlink+0x54>
    80003f7e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f80:	4741                	li	a4,16
    80003f82:	86a6                	mv	a3,s1
    80003f84:	fc040613          	addi	a2,s0,-64
    80003f88:	4581                	li	a1,0
    80003f8a:	854a                	mv	a0,s2
    80003f8c:	00000097          	auipc	ra,0x0
    80003f90:	b92080e7          	jalr	-1134(ra) # 80003b1e <readi>
    80003f94:	47c1                	li	a5,16
    80003f96:	06f51163          	bne	a0,a5,80003ff8 <dirlink+0xa2>
    if(de.inum == 0)
    80003f9a:	fc045783          	lhu	a5,-64(s0)
    80003f9e:	c791                	beqz	a5,80003faa <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fa0:	24c1                	addiw	s1,s1,16
    80003fa2:	05492783          	lw	a5,84(s2)
    80003fa6:	fcf4ede3          	bltu	s1,a5,80003f80 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003faa:	4639                	li	a2,14
    80003fac:	85d2                	mv	a1,s4
    80003fae:	fc240513          	addi	a0,s0,-62
    80003fb2:	ffffd097          	auipc	ra,0xffffd
    80003fb6:	ffa080e7          	jalr	-6(ra) # 80000fac <strncpy>
  de.inum = inum;
    80003fba:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003fbe:	4741                	li	a4,16
    80003fc0:	86a6                	mv	a3,s1
    80003fc2:	fc040613          	addi	a2,s0,-64
    80003fc6:	4581                	li	a1,0
    80003fc8:	854a                	mv	a0,s2
    80003fca:	00000097          	auipc	ra,0x0
    80003fce:	c48080e7          	jalr	-952(ra) # 80003c12 <writei>
    80003fd2:	872a                	mv	a4,a0
    80003fd4:	47c1                	li	a5,16
  return 0;
    80003fd6:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003fd8:	02f71863          	bne	a4,a5,80004008 <dirlink+0xb2>
}
    80003fdc:	70e2                	ld	ra,56(sp)
    80003fde:	7442                	ld	s0,48(sp)
    80003fe0:	74a2                	ld	s1,40(sp)
    80003fe2:	7902                	ld	s2,32(sp)
    80003fe4:	69e2                	ld	s3,24(sp)
    80003fe6:	6a42                	ld	s4,16(sp)
    80003fe8:	6121                	addi	sp,sp,64
    80003fea:	8082                	ret
    iput(ip);
    80003fec:	00000097          	auipc	ra,0x0
    80003ff0:	9b0080e7          	jalr	-1616(ra) # 8000399c <iput>
    return -1;
    80003ff4:	557d                	li	a0,-1
    80003ff6:	b7dd                	j	80003fdc <dirlink+0x86>
      panic("dirlink read");
    80003ff8:	00004517          	auipc	a0,0x4
    80003ffc:	73850513          	addi	a0,a0,1848 # 80008730 <userret+0x6a0>
    80004000:	ffffc097          	auipc	ra,0xffffc
    80004004:	548080e7          	jalr	1352(ra) # 80000548 <panic>
    panic("dirlink");
    80004008:	00005517          	auipc	a0,0x5
    8000400c:	84850513          	addi	a0,a0,-1976 # 80008850 <userret+0x7c0>
    80004010:	ffffc097          	auipc	ra,0xffffc
    80004014:	538080e7          	jalr	1336(ra) # 80000548 <panic>

0000000080004018 <namei>:

struct inode*
namei(char *path)
{
    80004018:	1101                	addi	sp,sp,-32
    8000401a:	ec06                	sd	ra,24(sp)
    8000401c:	e822                	sd	s0,16(sp)
    8000401e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004020:	fe040613          	addi	a2,s0,-32
    80004024:	4581                	li	a1,0
    80004026:	00000097          	auipc	ra,0x0
    8000402a:	dd0080e7          	jalr	-560(ra) # 80003df6 <namex>
}
    8000402e:	60e2                	ld	ra,24(sp)
    80004030:	6442                	ld	s0,16(sp)
    80004032:	6105                	addi	sp,sp,32
    80004034:	8082                	ret

0000000080004036 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004036:	1141                	addi	sp,sp,-16
    80004038:	e406                	sd	ra,8(sp)
    8000403a:	e022                	sd	s0,0(sp)
    8000403c:	0800                	addi	s0,sp,16
    8000403e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004040:	4585                	li	a1,1
    80004042:	00000097          	auipc	ra,0x0
    80004046:	db4080e7          	jalr	-588(ra) # 80003df6 <namex>
}
    8000404a:	60a2                	ld	ra,8(sp)
    8000404c:	6402                	ld	s0,0(sp)
    8000404e:	0141                	addi	sp,sp,16
    80004050:	8082                	ret

0000000080004052 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(int dev)
{
    80004052:	7179                	addi	sp,sp,-48
    80004054:	f406                	sd	ra,40(sp)
    80004056:	f022                	sd	s0,32(sp)
    80004058:	ec26                	sd	s1,24(sp)
    8000405a:	e84a                	sd	s2,16(sp)
    8000405c:	e44e                	sd	s3,8(sp)
    8000405e:	1800                	addi	s0,sp,48
    80004060:	84aa                	mv	s1,a0
  struct buf *buf = bread(dev, log[dev].start);
    80004062:	0b000993          	li	s3,176
    80004066:	033507b3          	mul	a5,a0,s3
    8000406a:	00024997          	auipc	s3,0x24
    8000406e:	34e98993          	addi	s3,s3,846 # 800283b8 <log>
    80004072:	99be                	add	s3,s3,a5
    80004074:	0209a583          	lw	a1,32(s3)
    80004078:	fffff097          	auipc	ra,0xfffff
    8000407c:	f0a080e7          	jalr	-246(ra) # 80002f82 <bread>
    80004080:	892a                	mv	s2,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log[dev].lh.n;
    80004082:	0349a783          	lw	a5,52(s3)
    80004086:	d13c                	sw	a5,96(a0)
  for (i = 0; i < log[dev].lh.n; i++) {
    80004088:	0349a783          	lw	a5,52(s3)
    8000408c:	02f05763          	blez	a5,800040ba <write_head+0x68>
    80004090:	0b000793          	li	a5,176
    80004094:	02f487b3          	mul	a5,s1,a5
    80004098:	00024717          	auipc	a4,0x24
    8000409c:	35870713          	addi	a4,a4,856 # 800283f0 <log+0x38>
    800040a0:	97ba                	add	a5,a5,a4
    800040a2:	06450693          	addi	a3,a0,100
    800040a6:	4701                	li	a4,0
    800040a8:	85ce                	mv	a1,s3
    hb->block[i] = log[dev].lh.block[i];
    800040aa:	4390                	lw	a2,0(a5)
    800040ac:	c290                	sw	a2,0(a3)
  for (i = 0; i < log[dev].lh.n; i++) {
    800040ae:	2705                	addiw	a4,a4,1
    800040b0:	0791                	addi	a5,a5,4
    800040b2:	0691                	addi	a3,a3,4
    800040b4:	59d0                	lw	a2,52(a1)
    800040b6:	fec74ae3          	blt	a4,a2,800040aa <write_head+0x58>
  }
  bwrite(buf);
    800040ba:	854a                	mv	a0,s2
    800040bc:	fffff097          	auipc	ra,0xfffff
    800040c0:	07a080e7          	jalr	122(ra) # 80003136 <bwrite>
  brelse(buf);
    800040c4:	854a                	mv	a0,s2
    800040c6:	fffff097          	auipc	ra,0xfffff
    800040ca:	0b0080e7          	jalr	176(ra) # 80003176 <brelse>
}
    800040ce:	70a2                	ld	ra,40(sp)
    800040d0:	7402                	ld	s0,32(sp)
    800040d2:	64e2                	ld	s1,24(sp)
    800040d4:	6942                	ld	s2,16(sp)
    800040d6:	69a2                	ld	s3,8(sp)
    800040d8:	6145                	addi	sp,sp,48
    800040da:	8082                	ret

00000000800040dc <install_trans>:
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    800040dc:	0b000793          	li	a5,176
    800040e0:	02f50733          	mul	a4,a0,a5
    800040e4:	00024797          	auipc	a5,0x24
    800040e8:	2d478793          	addi	a5,a5,724 # 800283b8 <log>
    800040ec:	97ba                	add	a5,a5,a4
    800040ee:	5bdc                	lw	a5,52(a5)
    800040f0:	0af05b63          	blez	a5,800041a6 <install_trans+0xca>
{
    800040f4:	7139                	addi	sp,sp,-64
    800040f6:	fc06                	sd	ra,56(sp)
    800040f8:	f822                	sd	s0,48(sp)
    800040fa:	f426                	sd	s1,40(sp)
    800040fc:	f04a                	sd	s2,32(sp)
    800040fe:	ec4e                	sd	s3,24(sp)
    80004100:	e852                	sd	s4,16(sp)
    80004102:	e456                	sd	s5,8(sp)
    80004104:	e05a                	sd	s6,0(sp)
    80004106:	0080                	addi	s0,sp,64
    80004108:	00024797          	auipc	a5,0x24
    8000410c:	2e878793          	addi	a5,a5,744 # 800283f0 <log+0x38>
    80004110:	00f70a33          	add	s4,a4,a5
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80004114:	4981                	li	s3,0
    struct buf *lbuf = bread(dev, log[dev].start+tail+1); // read log block
    80004116:	00050b1b          	sext.w	s6,a0
    8000411a:	00024a97          	auipc	s5,0x24
    8000411e:	29ea8a93          	addi	s5,s5,670 # 800283b8 <log>
    80004122:	9aba                	add	s5,s5,a4
    80004124:	020aa583          	lw	a1,32(s5)
    80004128:	013585bb          	addw	a1,a1,s3
    8000412c:	2585                	addiw	a1,a1,1
    8000412e:	855a                	mv	a0,s6
    80004130:	fffff097          	auipc	ra,0xfffff
    80004134:	e52080e7          	jalr	-430(ra) # 80002f82 <bread>
    80004138:	892a                	mv	s2,a0
    struct buf *dbuf = bread(dev, log[dev].lh.block[tail]); // read dst
    8000413a:	000a2583          	lw	a1,0(s4)
    8000413e:	855a                	mv	a0,s6
    80004140:	fffff097          	auipc	ra,0xfffff
    80004144:	e42080e7          	jalr	-446(ra) # 80002f82 <bread>
    80004148:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000414a:	40000613          	li	a2,1024
    8000414e:	06090593          	addi	a1,s2,96
    80004152:	06050513          	addi	a0,a0,96
    80004156:	ffffd097          	auipc	ra,0xffffd
    8000415a:	d9e080e7          	jalr	-610(ra) # 80000ef4 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000415e:	8526                	mv	a0,s1
    80004160:	fffff097          	auipc	ra,0xfffff
    80004164:	fd6080e7          	jalr	-42(ra) # 80003136 <bwrite>
    bunpin(dbuf);
    80004168:	8526                	mv	a0,s1
    8000416a:	fffff097          	auipc	ra,0xfffff
    8000416e:	11a080e7          	jalr	282(ra) # 80003284 <bunpin>
    brelse(lbuf);
    80004172:	854a                	mv	a0,s2
    80004174:	fffff097          	auipc	ra,0xfffff
    80004178:	002080e7          	jalr	2(ra) # 80003176 <brelse>
    brelse(dbuf);
    8000417c:	8526                	mv	a0,s1
    8000417e:	fffff097          	auipc	ra,0xfffff
    80004182:	ff8080e7          	jalr	-8(ra) # 80003176 <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80004186:	2985                	addiw	s3,s3,1
    80004188:	0a11                	addi	s4,s4,4
    8000418a:	034aa783          	lw	a5,52(s5)
    8000418e:	f8f9cbe3          	blt	s3,a5,80004124 <install_trans+0x48>
}
    80004192:	70e2                	ld	ra,56(sp)
    80004194:	7442                	ld	s0,48(sp)
    80004196:	74a2                	ld	s1,40(sp)
    80004198:	7902                	ld	s2,32(sp)
    8000419a:	69e2                	ld	s3,24(sp)
    8000419c:	6a42                	ld	s4,16(sp)
    8000419e:	6aa2                	ld	s5,8(sp)
    800041a0:	6b02                	ld	s6,0(sp)
    800041a2:	6121                	addi	sp,sp,64
    800041a4:	8082                	ret
    800041a6:	8082                	ret

00000000800041a8 <initlog>:
{
    800041a8:	7179                	addi	sp,sp,-48
    800041aa:	f406                	sd	ra,40(sp)
    800041ac:	f022                	sd	s0,32(sp)
    800041ae:	ec26                	sd	s1,24(sp)
    800041b0:	e84a                	sd	s2,16(sp)
    800041b2:	e44e                	sd	s3,8(sp)
    800041b4:	e052                	sd	s4,0(sp)
    800041b6:	1800                	addi	s0,sp,48
    800041b8:	892a                	mv	s2,a0
    800041ba:	8a2e                	mv	s4,a1
  initlock(&log[dev].lock, "log");
    800041bc:	0b000713          	li	a4,176
    800041c0:	02e504b3          	mul	s1,a0,a4
    800041c4:	00024997          	auipc	s3,0x24
    800041c8:	1f498993          	addi	s3,s3,500 # 800283b8 <log>
    800041cc:	99a6                	add	s3,s3,s1
    800041ce:	00004597          	auipc	a1,0x4
    800041d2:	57258593          	addi	a1,a1,1394 # 80008740 <userret+0x6b0>
    800041d6:	854e                	mv	a0,s3
    800041d8:	ffffd097          	auipc	ra,0xffffd
    800041dc:	904080e7          	jalr	-1788(ra) # 80000adc <initlock>
  log[dev].start = sb->logstart;
    800041e0:	014a2583          	lw	a1,20(s4)
    800041e4:	02b9a023          	sw	a1,32(s3)
  log[dev].size = sb->nlog;
    800041e8:	010a2783          	lw	a5,16(s4)
    800041ec:	02f9a223          	sw	a5,36(s3)
  log[dev].dev = dev;
    800041f0:	0329a823          	sw	s2,48(s3)
  struct buf *buf = bread(dev, log[dev].start);
    800041f4:	854a                	mv	a0,s2
    800041f6:	fffff097          	auipc	ra,0xfffff
    800041fa:	d8c080e7          	jalr	-628(ra) # 80002f82 <bread>
  log[dev].lh.n = lh->n;
    800041fe:	5134                	lw	a3,96(a0)
    80004200:	02d9aa23          	sw	a3,52(s3)
  for (i = 0; i < log[dev].lh.n; i++) {
    80004204:	02d05763          	blez	a3,80004232 <initlog+0x8a>
    80004208:	06450793          	addi	a5,a0,100
    8000420c:	00024717          	auipc	a4,0x24
    80004210:	1e470713          	addi	a4,a4,484 # 800283f0 <log+0x38>
    80004214:	9726                	add	a4,a4,s1
    80004216:	36fd                	addiw	a3,a3,-1
    80004218:	02069613          	slli	a2,a3,0x20
    8000421c:	01e65693          	srli	a3,a2,0x1e
    80004220:	06850613          	addi	a2,a0,104
    80004224:	96b2                	add	a3,a3,a2
    log[dev].lh.block[i] = lh->block[i];
    80004226:	4390                	lw	a2,0(a5)
    80004228:	c310                	sw	a2,0(a4)
  for (i = 0; i < log[dev].lh.n; i++) {
    8000422a:	0791                	addi	a5,a5,4
    8000422c:	0711                	addi	a4,a4,4
    8000422e:	fed79ce3          	bne	a5,a3,80004226 <initlog+0x7e>
  brelse(buf);
    80004232:	fffff097          	auipc	ra,0xfffff
    80004236:	f44080e7          	jalr	-188(ra) # 80003176 <brelse>

static void
recover_from_log(int dev)
{
  read_head(dev);
  install_trans(dev); // if committed, copy from log to disk
    8000423a:	854a                	mv	a0,s2
    8000423c:	00000097          	auipc	ra,0x0
    80004240:	ea0080e7          	jalr	-352(ra) # 800040dc <install_trans>
  log[dev].lh.n = 0;
    80004244:	0b000793          	li	a5,176
    80004248:	02f90733          	mul	a4,s2,a5
    8000424c:	00024797          	auipc	a5,0x24
    80004250:	16c78793          	addi	a5,a5,364 # 800283b8 <log>
    80004254:	97ba                	add	a5,a5,a4
    80004256:	0207aa23          	sw	zero,52(a5)
  write_head(dev); // clear the log
    8000425a:	854a                	mv	a0,s2
    8000425c:	00000097          	auipc	ra,0x0
    80004260:	df6080e7          	jalr	-522(ra) # 80004052 <write_head>
}
    80004264:	70a2                	ld	ra,40(sp)
    80004266:	7402                	ld	s0,32(sp)
    80004268:	64e2                	ld	s1,24(sp)
    8000426a:	6942                	ld	s2,16(sp)
    8000426c:	69a2                	ld	s3,8(sp)
    8000426e:	6a02                	ld	s4,0(sp)
    80004270:	6145                	addi	sp,sp,48
    80004272:	8082                	ret

0000000080004274 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(int dev)
{
    80004274:	7139                	addi	sp,sp,-64
    80004276:	fc06                	sd	ra,56(sp)
    80004278:	f822                	sd	s0,48(sp)
    8000427a:	f426                	sd	s1,40(sp)
    8000427c:	f04a                	sd	s2,32(sp)
    8000427e:	ec4e                	sd	s3,24(sp)
    80004280:	e852                	sd	s4,16(sp)
    80004282:	e456                	sd	s5,8(sp)
    80004284:	0080                	addi	s0,sp,64
    80004286:	8aaa                	mv	s5,a0
  acquire(&log[dev].lock);
    80004288:	0b000913          	li	s2,176
    8000428c:	032507b3          	mul	a5,a0,s2
    80004290:	00024917          	auipc	s2,0x24
    80004294:	12890913          	addi	s2,s2,296 # 800283b8 <log>
    80004298:	993e                	add	s2,s2,a5
    8000429a:	854a                	mv	a0,s2
    8000429c:	ffffd097          	auipc	ra,0xffffd
    800042a0:	98e080e7          	jalr	-1650(ra) # 80000c2a <acquire>
  while(1){
    if(log[dev].committing){
    800042a4:	00024997          	auipc	s3,0x24
    800042a8:	11498993          	addi	s3,s3,276 # 800283b8 <log>
    800042ac:	84ca                	mv	s1,s2
      sleep(&log, &log[dev].lock);
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800042ae:	4a79                	li	s4,30
    800042b0:	a039                	j	800042be <begin_op+0x4a>
      sleep(&log, &log[dev].lock);
    800042b2:	85ca                	mv	a1,s2
    800042b4:	854e                	mv	a0,s3
    800042b6:	ffffe097          	auipc	ra,0xffffe
    800042ba:	0a2080e7          	jalr	162(ra) # 80002358 <sleep>
    if(log[dev].committing){
    800042be:	54dc                	lw	a5,44(s1)
    800042c0:	fbed                	bnez	a5,800042b2 <begin_op+0x3e>
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800042c2:	549c                	lw	a5,40(s1)
    800042c4:	0017871b          	addiw	a4,a5,1
    800042c8:	0007069b          	sext.w	a3,a4
    800042cc:	0027179b          	slliw	a5,a4,0x2
    800042d0:	9fb9                	addw	a5,a5,a4
    800042d2:	0017979b          	slliw	a5,a5,0x1
    800042d6:	58d8                	lw	a4,52(s1)
    800042d8:	9fb9                	addw	a5,a5,a4
    800042da:	00fa5963          	bge	s4,a5,800042ec <begin_op+0x78>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log[dev].lock);
    800042de:	85ca                	mv	a1,s2
    800042e0:	854e                	mv	a0,s3
    800042e2:	ffffe097          	auipc	ra,0xffffe
    800042e6:	076080e7          	jalr	118(ra) # 80002358 <sleep>
    800042ea:	bfd1                	j	800042be <begin_op+0x4a>
    } else {
      log[dev].outstanding += 1;
    800042ec:	0b000513          	li	a0,176
    800042f0:	02aa8ab3          	mul	s5,s5,a0
    800042f4:	00024797          	auipc	a5,0x24
    800042f8:	0c478793          	addi	a5,a5,196 # 800283b8 <log>
    800042fc:	9abe                	add	s5,s5,a5
    800042fe:	02daa423          	sw	a3,40(s5)
      release(&log[dev].lock);
    80004302:	854a                	mv	a0,s2
    80004304:	ffffd097          	auipc	ra,0xffffd
    80004308:	996080e7          	jalr	-1642(ra) # 80000c9a <release>
      break;
    }
  }
}
    8000430c:	70e2                	ld	ra,56(sp)
    8000430e:	7442                	ld	s0,48(sp)
    80004310:	74a2                	ld	s1,40(sp)
    80004312:	7902                	ld	s2,32(sp)
    80004314:	69e2                	ld	s3,24(sp)
    80004316:	6a42                	ld	s4,16(sp)
    80004318:	6aa2                	ld	s5,8(sp)
    8000431a:	6121                	addi	sp,sp,64
    8000431c:	8082                	ret

000000008000431e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(int dev)
{
    8000431e:	715d                	addi	sp,sp,-80
    80004320:	e486                	sd	ra,72(sp)
    80004322:	e0a2                	sd	s0,64(sp)
    80004324:	fc26                	sd	s1,56(sp)
    80004326:	f84a                	sd	s2,48(sp)
    80004328:	f44e                	sd	s3,40(sp)
    8000432a:	f052                	sd	s4,32(sp)
    8000432c:	ec56                	sd	s5,24(sp)
    8000432e:	e85a                	sd	s6,16(sp)
    80004330:	e45e                	sd	s7,8(sp)
    80004332:	e062                	sd	s8,0(sp)
    80004334:	0880                	addi	s0,sp,80
    80004336:	89aa                	mv	s3,a0
  int do_commit = 0;

  acquire(&log[dev].lock);
    80004338:	0b000913          	li	s2,176
    8000433c:	03250933          	mul	s2,a0,s2
    80004340:	00024497          	auipc	s1,0x24
    80004344:	07848493          	addi	s1,s1,120 # 800283b8 <log>
    80004348:	94ca                	add	s1,s1,s2
    8000434a:	8526                	mv	a0,s1
    8000434c:	ffffd097          	auipc	ra,0xffffd
    80004350:	8de080e7          	jalr	-1826(ra) # 80000c2a <acquire>
  log[dev].outstanding -= 1;
    80004354:	549c                	lw	a5,40(s1)
    80004356:	37fd                	addiw	a5,a5,-1
    80004358:	00078a9b          	sext.w	s5,a5
    8000435c:	d49c                	sw	a5,40(s1)
  if(log[dev].committing)
    8000435e:	54dc                	lw	a5,44(s1)
    80004360:	e3b5                	bnez	a5,800043c4 <end_op+0xa6>
    panic("log[dev].committing");
  if(log[dev].outstanding == 0){
    80004362:	060a9963          	bnez	s5,800043d4 <end_op+0xb6>
    do_commit = 1;
    log[dev].committing = 1;
    80004366:	0b000a13          	li	s4,176
    8000436a:	034987b3          	mul	a5,s3,s4
    8000436e:	00024a17          	auipc	s4,0x24
    80004372:	04aa0a13          	addi	s4,s4,74 # 800283b8 <log>
    80004376:	9a3e                	add	s4,s4,a5
    80004378:	4785                	li	a5,1
    8000437a:	02fa2623          	sw	a5,44(s4)
    // begin_op() may be waiting for log space,
    // and decrementing log[dev].outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log[dev].lock);
    8000437e:	8526                	mv	a0,s1
    80004380:	ffffd097          	auipc	ra,0xffffd
    80004384:	91a080e7          	jalr	-1766(ra) # 80000c9a <release>
}

static void
commit(int dev)
{
  if (log[dev].lh.n > 0) {
    80004388:	034a2783          	lw	a5,52(s4)
    8000438c:	06f04d63          	bgtz	a5,80004406 <end_op+0xe8>
    acquire(&log[dev].lock);
    80004390:	8526                	mv	a0,s1
    80004392:	ffffd097          	auipc	ra,0xffffd
    80004396:	898080e7          	jalr	-1896(ra) # 80000c2a <acquire>
    log[dev].committing = 0;
    8000439a:	00024517          	auipc	a0,0x24
    8000439e:	01e50513          	addi	a0,a0,30 # 800283b8 <log>
    800043a2:	0b000793          	li	a5,176
    800043a6:	02f989b3          	mul	s3,s3,a5
    800043aa:	99aa                	add	s3,s3,a0
    800043ac:	0209a623          	sw	zero,44(s3)
    wakeup(&log);
    800043b0:	ffffe097          	auipc	ra,0xffffe
    800043b4:	128080e7          	jalr	296(ra) # 800024d8 <wakeup>
    release(&log[dev].lock);
    800043b8:	8526                	mv	a0,s1
    800043ba:	ffffd097          	auipc	ra,0xffffd
    800043be:	8e0080e7          	jalr	-1824(ra) # 80000c9a <release>
}
    800043c2:	a035                	j	800043ee <end_op+0xd0>
    panic("log[dev].committing");
    800043c4:	00004517          	auipc	a0,0x4
    800043c8:	38450513          	addi	a0,a0,900 # 80008748 <userret+0x6b8>
    800043cc:	ffffc097          	auipc	ra,0xffffc
    800043d0:	17c080e7          	jalr	380(ra) # 80000548 <panic>
    wakeup(&log);
    800043d4:	00024517          	auipc	a0,0x24
    800043d8:	fe450513          	addi	a0,a0,-28 # 800283b8 <log>
    800043dc:	ffffe097          	auipc	ra,0xffffe
    800043e0:	0fc080e7          	jalr	252(ra) # 800024d8 <wakeup>
  release(&log[dev].lock);
    800043e4:	8526                	mv	a0,s1
    800043e6:	ffffd097          	auipc	ra,0xffffd
    800043ea:	8b4080e7          	jalr	-1868(ra) # 80000c9a <release>
}
    800043ee:	60a6                	ld	ra,72(sp)
    800043f0:	6406                	ld	s0,64(sp)
    800043f2:	74e2                	ld	s1,56(sp)
    800043f4:	7942                	ld	s2,48(sp)
    800043f6:	79a2                	ld	s3,40(sp)
    800043f8:	7a02                	ld	s4,32(sp)
    800043fa:	6ae2                	ld	s5,24(sp)
    800043fc:	6b42                	ld	s6,16(sp)
    800043fe:	6ba2                	ld	s7,8(sp)
    80004400:	6c02                	ld	s8,0(sp)
    80004402:	6161                	addi	sp,sp,80
    80004404:	8082                	ret
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80004406:	00024797          	auipc	a5,0x24
    8000440a:	fea78793          	addi	a5,a5,-22 # 800283f0 <log+0x38>
    8000440e:	993e                	add	s2,s2,a5
    struct buf *to = bread(dev, log[dev].start+tail+1); // log block
    80004410:	00098c1b          	sext.w	s8,s3
    80004414:	0b000b93          	li	s7,176
    80004418:	037987b3          	mul	a5,s3,s7
    8000441c:	00024b97          	auipc	s7,0x24
    80004420:	f9cb8b93          	addi	s7,s7,-100 # 800283b8 <log>
    80004424:	9bbe                	add	s7,s7,a5
    80004426:	020ba583          	lw	a1,32(s7)
    8000442a:	015585bb          	addw	a1,a1,s5
    8000442e:	2585                	addiw	a1,a1,1
    80004430:	8562                	mv	a0,s8
    80004432:	fffff097          	auipc	ra,0xfffff
    80004436:	b50080e7          	jalr	-1200(ra) # 80002f82 <bread>
    8000443a:	8a2a                	mv	s4,a0
    struct buf *from = bread(dev, log[dev].lh.block[tail]); // cache block
    8000443c:	00092583          	lw	a1,0(s2)
    80004440:	8562                	mv	a0,s8
    80004442:	fffff097          	auipc	ra,0xfffff
    80004446:	b40080e7          	jalr	-1216(ra) # 80002f82 <bread>
    8000444a:	8b2a                	mv	s6,a0
    memmove(to->data, from->data, BSIZE);
    8000444c:	40000613          	li	a2,1024
    80004450:	06050593          	addi	a1,a0,96
    80004454:	060a0513          	addi	a0,s4,96
    80004458:	ffffd097          	auipc	ra,0xffffd
    8000445c:	a9c080e7          	jalr	-1380(ra) # 80000ef4 <memmove>
    bwrite(to);  // write the log
    80004460:	8552                	mv	a0,s4
    80004462:	fffff097          	auipc	ra,0xfffff
    80004466:	cd4080e7          	jalr	-812(ra) # 80003136 <bwrite>
    brelse(from);
    8000446a:	855a                	mv	a0,s6
    8000446c:	fffff097          	auipc	ra,0xfffff
    80004470:	d0a080e7          	jalr	-758(ra) # 80003176 <brelse>
    brelse(to);
    80004474:	8552                	mv	a0,s4
    80004476:	fffff097          	auipc	ra,0xfffff
    8000447a:	d00080e7          	jalr	-768(ra) # 80003176 <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    8000447e:	2a85                	addiw	s5,s5,1
    80004480:	0911                	addi	s2,s2,4
    80004482:	034ba783          	lw	a5,52(s7)
    80004486:	fafac0e3          	blt	s5,a5,80004426 <end_op+0x108>
    write_log(dev);     // Write modified blocks from cache to log
    write_head(dev);    // Write header to disk -- the real commit
    8000448a:	854e                	mv	a0,s3
    8000448c:	00000097          	auipc	ra,0x0
    80004490:	bc6080e7          	jalr	-1082(ra) # 80004052 <write_head>
    install_trans(dev); // Now install writes to home locations
    80004494:	854e                	mv	a0,s3
    80004496:	00000097          	auipc	ra,0x0
    8000449a:	c46080e7          	jalr	-954(ra) # 800040dc <install_trans>
    log[dev].lh.n = 0;
    8000449e:	0b000793          	li	a5,176
    800044a2:	02f98733          	mul	a4,s3,a5
    800044a6:	00024797          	auipc	a5,0x24
    800044aa:	f1278793          	addi	a5,a5,-238 # 800283b8 <log>
    800044ae:	97ba                	add	a5,a5,a4
    800044b0:	0207aa23          	sw	zero,52(a5)
    write_head(dev);    // Erase the transaction from the log
    800044b4:	854e                	mv	a0,s3
    800044b6:	00000097          	auipc	ra,0x0
    800044ba:	b9c080e7          	jalr	-1124(ra) # 80004052 <write_head>
    800044be:	bdc9                	j	80004390 <end_op+0x72>

00000000800044c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800044c0:	7179                	addi	sp,sp,-48
    800044c2:	f406                	sd	ra,40(sp)
    800044c4:	f022                	sd	s0,32(sp)
    800044c6:	ec26                	sd	s1,24(sp)
    800044c8:	e84a                	sd	s2,16(sp)
    800044ca:	e44e                	sd	s3,8(sp)
    800044cc:	e052                	sd	s4,0(sp)
    800044ce:	1800                	addi	s0,sp,48
  int i;

  int dev = b->dev;
    800044d0:	00852903          	lw	s2,8(a0)
  if (log[dev].lh.n >= LOGSIZE || log[dev].lh.n >= log[dev].size - 1)
    800044d4:	0b000793          	li	a5,176
    800044d8:	02f90733          	mul	a4,s2,a5
    800044dc:	00024797          	auipc	a5,0x24
    800044e0:	edc78793          	addi	a5,a5,-292 # 800283b8 <log>
    800044e4:	97ba                	add	a5,a5,a4
    800044e6:	5bd4                	lw	a3,52(a5)
    800044e8:	47f5                	li	a5,29
    800044ea:	0ad7cc63          	blt	a5,a3,800045a2 <log_write+0xe2>
    800044ee:	89aa                	mv	s3,a0
    800044f0:	00024797          	auipc	a5,0x24
    800044f4:	ec878793          	addi	a5,a5,-312 # 800283b8 <log>
    800044f8:	97ba                	add	a5,a5,a4
    800044fa:	53dc                	lw	a5,36(a5)
    800044fc:	37fd                	addiw	a5,a5,-1
    800044fe:	0af6d263          	bge	a3,a5,800045a2 <log_write+0xe2>
    panic("too big a transaction");
  if (log[dev].outstanding < 1)
    80004502:	0b000793          	li	a5,176
    80004506:	02f90733          	mul	a4,s2,a5
    8000450a:	00024797          	auipc	a5,0x24
    8000450e:	eae78793          	addi	a5,a5,-338 # 800283b8 <log>
    80004512:	97ba                	add	a5,a5,a4
    80004514:	579c                	lw	a5,40(a5)
    80004516:	08f05e63          	blez	a5,800045b2 <log_write+0xf2>
    panic("log_write outside of trans");

  acquire(&log[dev].lock);
    8000451a:	0b000793          	li	a5,176
    8000451e:	02f904b3          	mul	s1,s2,a5
    80004522:	00024a17          	auipc	s4,0x24
    80004526:	e96a0a13          	addi	s4,s4,-362 # 800283b8 <log>
    8000452a:	9a26                	add	s4,s4,s1
    8000452c:	8552                	mv	a0,s4
    8000452e:	ffffc097          	auipc	ra,0xffffc
    80004532:	6fc080e7          	jalr	1788(ra) # 80000c2a <acquire>
  for (i = 0; i < log[dev].lh.n; i++) {
    80004536:	034a2603          	lw	a2,52(s4)
    8000453a:	08c05463          	blez	a2,800045c2 <log_write+0x102>
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    8000453e:	00c9a583          	lw	a1,12(s3)
    80004542:	00024797          	auipc	a5,0x24
    80004546:	eae78793          	addi	a5,a5,-338 # 800283f0 <log+0x38>
    8000454a:	97a6                	add	a5,a5,s1
  for (i = 0; i < log[dev].lh.n; i++) {
    8000454c:	4701                	li	a4,0
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    8000454e:	4394                	lw	a3,0(a5)
    80004550:	06b68a63          	beq	a3,a1,800045c4 <log_write+0x104>
  for (i = 0; i < log[dev].lh.n; i++) {
    80004554:	2705                	addiw	a4,a4,1
    80004556:	0791                	addi	a5,a5,4
    80004558:	fec71be3          	bne	a4,a2,8000454e <log_write+0x8e>
      break;
  }
  log[dev].lh.block[i] = b->blockno;
    8000455c:	02c00793          	li	a5,44
    80004560:	02f907b3          	mul	a5,s2,a5
    80004564:	97b2                	add	a5,a5,a2
    80004566:	07b1                	addi	a5,a5,12
    80004568:	078a                	slli	a5,a5,0x2
    8000456a:	00024717          	auipc	a4,0x24
    8000456e:	e4e70713          	addi	a4,a4,-434 # 800283b8 <log>
    80004572:	97ba                	add	a5,a5,a4
    80004574:	00c9a703          	lw	a4,12(s3)
    80004578:	c798                	sw	a4,8(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    bpin(b);
    8000457a:	854e                	mv	a0,s3
    8000457c:	fffff097          	auipc	ra,0xfffff
    80004580:	cbc080e7          	jalr	-836(ra) # 80003238 <bpin>
    log[dev].lh.n++;
    80004584:	0b000793          	li	a5,176
    80004588:	02f90933          	mul	s2,s2,a5
    8000458c:	00024797          	auipc	a5,0x24
    80004590:	e2c78793          	addi	a5,a5,-468 # 800283b8 <log>
    80004594:	993e                	add	s2,s2,a5
    80004596:	03492783          	lw	a5,52(s2)
    8000459a:	2785                	addiw	a5,a5,1
    8000459c:	02f92a23          	sw	a5,52(s2)
    800045a0:	a099                	j	800045e6 <log_write+0x126>
    panic("too big a transaction");
    800045a2:	00004517          	auipc	a0,0x4
    800045a6:	1be50513          	addi	a0,a0,446 # 80008760 <userret+0x6d0>
    800045aa:	ffffc097          	auipc	ra,0xffffc
    800045ae:	f9e080e7          	jalr	-98(ra) # 80000548 <panic>
    panic("log_write outside of trans");
    800045b2:	00004517          	auipc	a0,0x4
    800045b6:	1c650513          	addi	a0,a0,454 # 80008778 <userret+0x6e8>
    800045ba:	ffffc097          	auipc	ra,0xffffc
    800045be:	f8e080e7          	jalr	-114(ra) # 80000548 <panic>
  for (i = 0; i < log[dev].lh.n; i++) {
    800045c2:	4701                	li	a4,0
  log[dev].lh.block[i] = b->blockno;
    800045c4:	02c00793          	li	a5,44
    800045c8:	02f907b3          	mul	a5,s2,a5
    800045cc:	97ba                	add	a5,a5,a4
    800045ce:	07b1                	addi	a5,a5,12
    800045d0:	078a                	slli	a5,a5,0x2
    800045d2:	00024697          	auipc	a3,0x24
    800045d6:	de668693          	addi	a3,a3,-538 # 800283b8 <log>
    800045da:	97b6                	add	a5,a5,a3
    800045dc:	00c9a683          	lw	a3,12(s3)
    800045e0:	c794                	sw	a3,8(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    800045e2:	f8e60ce3          	beq	a2,a4,8000457a <log_write+0xba>
  }
  release(&log[dev].lock);
    800045e6:	8552                	mv	a0,s4
    800045e8:	ffffc097          	auipc	ra,0xffffc
    800045ec:	6b2080e7          	jalr	1714(ra) # 80000c9a <release>
}
    800045f0:	70a2                	ld	ra,40(sp)
    800045f2:	7402                	ld	s0,32(sp)
    800045f4:	64e2                	ld	s1,24(sp)
    800045f6:	6942                	ld	s2,16(sp)
    800045f8:	69a2                	ld	s3,8(sp)
    800045fa:	6a02                	ld	s4,0(sp)
    800045fc:	6145                	addi	sp,sp,48
    800045fe:	8082                	ret

0000000080004600 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004600:	1101                	addi	sp,sp,-32
    80004602:	ec06                	sd	ra,24(sp)
    80004604:	e822                	sd	s0,16(sp)
    80004606:	e426                	sd	s1,8(sp)
    80004608:	e04a                	sd	s2,0(sp)
    8000460a:	1000                	addi	s0,sp,32
    8000460c:	84aa                	mv	s1,a0
    8000460e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004610:	00004597          	auipc	a1,0x4
    80004614:	18858593          	addi	a1,a1,392 # 80008798 <userret+0x708>
    80004618:	0521                	addi	a0,a0,8
    8000461a:	ffffc097          	auipc	ra,0xffffc
    8000461e:	4c2080e7          	jalr	1218(ra) # 80000adc <initlock>
  lk->name = name;
    80004622:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80004626:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000462a:	0204a823          	sw	zero,48(s1)
}
    8000462e:	60e2                	ld	ra,24(sp)
    80004630:	6442                	ld	s0,16(sp)
    80004632:	64a2                	ld	s1,8(sp)
    80004634:	6902                	ld	s2,0(sp)
    80004636:	6105                	addi	sp,sp,32
    80004638:	8082                	ret

000000008000463a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000463a:	1101                	addi	sp,sp,-32
    8000463c:	ec06                	sd	ra,24(sp)
    8000463e:	e822                	sd	s0,16(sp)
    80004640:	e426                	sd	s1,8(sp)
    80004642:	e04a                	sd	s2,0(sp)
    80004644:	1000                	addi	s0,sp,32
    80004646:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004648:	00850913          	addi	s2,a0,8
    8000464c:	854a                	mv	a0,s2
    8000464e:	ffffc097          	auipc	ra,0xffffc
    80004652:	5dc080e7          	jalr	1500(ra) # 80000c2a <acquire>
  while (lk->locked) {
    80004656:	409c                	lw	a5,0(s1)
    80004658:	cb89                	beqz	a5,8000466a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000465a:	85ca                	mv	a1,s2
    8000465c:	8526                	mv	a0,s1
    8000465e:	ffffe097          	auipc	ra,0xffffe
    80004662:	cfa080e7          	jalr	-774(ra) # 80002358 <sleep>
  while (lk->locked) {
    80004666:	409c                	lw	a5,0(s1)
    80004668:	fbed                	bnez	a5,8000465a <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000466a:	4785                	li	a5,1
    8000466c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000466e:	ffffd097          	auipc	ra,0xffffd
    80004672:	514080e7          	jalr	1300(ra) # 80001b82 <myproc>
    80004676:	413c                	lw	a5,64(a0)
    80004678:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    8000467a:	854a                	mv	a0,s2
    8000467c:	ffffc097          	auipc	ra,0xffffc
    80004680:	61e080e7          	jalr	1566(ra) # 80000c9a <release>
}
    80004684:	60e2                	ld	ra,24(sp)
    80004686:	6442                	ld	s0,16(sp)
    80004688:	64a2                	ld	s1,8(sp)
    8000468a:	6902                	ld	s2,0(sp)
    8000468c:	6105                	addi	sp,sp,32
    8000468e:	8082                	ret

0000000080004690 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004690:	1101                	addi	sp,sp,-32
    80004692:	ec06                	sd	ra,24(sp)
    80004694:	e822                	sd	s0,16(sp)
    80004696:	e426                	sd	s1,8(sp)
    80004698:	e04a                	sd	s2,0(sp)
    8000469a:	1000                	addi	s0,sp,32
    8000469c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000469e:	00850913          	addi	s2,a0,8
    800046a2:	854a                	mv	a0,s2
    800046a4:	ffffc097          	auipc	ra,0xffffc
    800046a8:	586080e7          	jalr	1414(ra) # 80000c2a <acquire>
  lk->locked = 0;
    800046ac:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800046b0:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    800046b4:	8526                	mv	a0,s1
    800046b6:	ffffe097          	auipc	ra,0xffffe
    800046ba:	e22080e7          	jalr	-478(ra) # 800024d8 <wakeup>
  release(&lk->lk);
    800046be:	854a                	mv	a0,s2
    800046c0:	ffffc097          	auipc	ra,0xffffc
    800046c4:	5da080e7          	jalr	1498(ra) # 80000c9a <release>
}
    800046c8:	60e2                	ld	ra,24(sp)
    800046ca:	6442                	ld	s0,16(sp)
    800046cc:	64a2                	ld	s1,8(sp)
    800046ce:	6902                	ld	s2,0(sp)
    800046d0:	6105                	addi	sp,sp,32
    800046d2:	8082                	ret

00000000800046d4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800046d4:	7179                	addi	sp,sp,-48
    800046d6:	f406                	sd	ra,40(sp)
    800046d8:	f022                	sd	s0,32(sp)
    800046da:	ec26                	sd	s1,24(sp)
    800046dc:	e84a                	sd	s2,16(sp)
    800046de:	e44e                	sd	s3,8(sp)
    800046e0:	1800                	addi	s0,sp,48
    800046e2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800046e4:	00850913          	addi	s2,a0,8
    800046e8:	854a                	mv	a0,s2
    800046ea:	ffffc097          	auipc	ra,0xffffc
    800046ee:	540080e7          	jalr	1344(ra) # 80000c2a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800046f2:	409c                	lw	a5,0(s1)
    800046f4:	ef99                	bnez	a5,80004712 <holdingsleep+0x3e>
    800046f6:	4481                	li	s1,0
  release(&lk->lk);
    800046f8:	854a                	mv	a0,s2
    800046fa:	ffffc097          	auipc	ra,0xffffc
    800046fe:	5a0080e7          	jalr	1440(ra) # 80000c9a <release>
  return r;
}
    80004702:	8526                	mv	a0,s1
    80004704:	70a2                	ld	ra,40(sp)
    80004706:	7402                	ld	s0,32(sp)
    80004708:	64e2                	ld	s1,24(sp)
    8000470a:	6942                	ld	s2,16(sp)
    8000470c:	69a2                	ld	s3,8(sp)
    8000470e:	6145                	addi	sp,sp,48
    80004710:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004712:	0304a983          	lw	s3,48(s1)
    80004716:	ffffd097          	auipc	ra,0xffffd
    8000471a:	46c080e7          	jalr	1132(ra) # 80001b82 <myproc>
    8000471e:	4124                	lw	s1,64(a0)
    80004720:	413484b3          	sub	s1,s1,s3
    80004724:	0014b493          	seqz	s1,s1
    80004728:	bfc1                	j	800046f8 <holdingsleep+0x24>

000000008000472a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000472a:	1141                	addi	sp,sp,-16
    8000472c:	e406                	sd	ra,8(sp)
    8000472e:	e022                	sd	s0,0(sp)
    80004730:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004732:	00004597          	auipc	a1,0x4
    80004736:	07658593          	addi	a1,a1,118 # 800087a8 <userret+0x718>
    8000473a:	00024517          	auipc	a0,0x24
    8000473e:	e7e50513          	addi	a0,a0,-386 # 800285b8 <ftable>
    80004742:	ffffc097          	auipc	ra,0xffffc
    80004746:	39a080e7          	jalr	922(ra) # 80000adc <initlock>
}
    8000474a:	60a2                	ld	ra,8(sp)
    8000474c:	6402                	ld	s0,0(sp)
    8000474e:	0141                	addi	sp,sp,16
    80004750:	8082                	ret

0000000080004752 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004752:	1101                	addi	sp,sp,-32
    80004754:	ec06                	sd	ra,24(sp)
    80004756:	e822                	sd	s0,16(sp)
    80004758:	e426                	sd	s1,8(sp)
    8000475a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000475c:	00024517          	auipc	a0,0x24
    80004760:	e5c50513          	addi	a0,a0,-420 # 800285b8 <ftable>
    80004764:	ffffc097          	auipc	ra,0xffffc
    80004768:	4c6080e7          	jalr	1222(ra) # 80000c2a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000476c:	00024497          	auipc	s1,0x24
    80004770:	e6c48493          	addi	s1,s1,-404 # 800285d8 <ftable+0x20>
    80004774:	00025717          	auipc	a4,0x25
    80004778:	e0470713          	addi	a4,a4,-508 # 80029578 <ftable+0xfc0>
    if(f->ref == 0){
    8000477c:	40dc                	lw	a5,4(s1)
    8000477e:	cf99                	beqz	a5,8000479c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004780:	02848493          	addi	s1,s1,40
    80004784:	fee49ce3          	bne	s1,a4,8000477c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004788:	00024517          	auipc	a0,0x24
    8000478c:	e3050513          	addi	a0,a0,-464 # 800285b8 <ftable>
    80004790:	ffffc097          	auipc	ra,0xffffc
    80004794:	50a080e7          	jalr	1290(ra) # 80000c9a <release>
  return 0;
    80004798:	4481                	li	s1,0
    8000479a:	a819                	j	800047b0 <filealloc+0x5e>
      f->ref = 1;
    8000479c:	4785                	li	a5,1
    8000479e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800047a0:	00024517          	auipc	a0,0x24
    800047a4:	e1850513          	addi	a0,a0,-488 # 800285b8 <ftable>
    800047a8:	ffffc097          	auipc	ra,0xffffc
    800047ac:	4f2080e7          	jalr	1266(ra) # 80000c9a <release>
}
    800047b0:	8526                	mv	a0,s1
    800047b2:	60e2                	ld	ra,24(sp)
    800047b4:	6442                	ld	s0,16(sp)
    800047b6:	64a2                	ld	s1,8(sp)
    800047b8:	6105                	addi	sp,sp,32
    800047ba:	8082                	ret

00000000800047bc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800047bc:	1101                	addi	sp,sp,-32
    800047be:	ec06                	sd	ra,24(sp)
    800047c0:	e822                	sd	s0,16(sp)
    800047c2:	e426                	sd	s1,8(sp)
    800047c4:	1000                	addi	s0,sp,32
    800047c6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800047c8:	00024517          	auipc	a0,0x24
    800047cc:	df050513          	addi	a0,a0,-528 # 800285b8 <ftable>
    800047d0:	ffffc097          	auipc	ra,0xffffc
    800047d4:	45a080e7          	jalr	1114(ra) # 80000c2a <acquire>
  if(f->ref < 1)
    800047d8:	40dc                	lw	a5,4(s1)
    800047da:	02f05263          	blez	a5,800047fe <filedup+0x42>
    panic("filedup");
  f->ref++;
    800047de:	2785                	addiw	a5,a5,1
    800047e0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800047e2:	00024517          	auipc	a0,0x24
    800047e6:	dd650513          	addi	a0,a0,-554 # 800285b8 <ftable>
    800047ea:	ffffc097          	auipc	ra,0xffffc
    800047ee:	4b0080e7          	jalr	1200(ra) # 80000c9a <release>
  return f;
}
    800047f2:	8526                	mv	a0,s1
    800047f4:	60e2                	ld	ra,24(sp)
    800047f6:	6442                	ld	s0,16(sp)
    800047f8:	64a2                	ld	s1,8(sp)
    800047fa:	6105                	addi	sp,sp,32
    800047fc:	8082                	ret
    panic("filedup");
    800047fe:	00004517          	auipc	a0,0x4
    80004802:	fb250513          	addi	a0,a0,-78 # 800087b0 <userret+0x720>
    80004806:	ffffc097          	auipc	ra,0xffffc
    8000480a:	d42080e7          	jalr	-702(ra) # 80000548 <panic>

000000008000480e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000480e:	7139                	addi	sp,sp,-64
    80004810:	fc06                	sd	ra,56(sp)
    80004812:	f822                	sd	s0,48(sp)
    80004814:	f426                	sd	s1,40(sp)
    80004816:	f04a                	sd	s2,32(sp)
    80004818:	ec4e                	sd	s3,24(sp)
    8000481a:	e852                	sd	s4,16(sp)
    8000481c:	e456                	sd	s5,8(sp)
    8000481e:	0080                	addi	s0,sp,64
    80004820:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004822:	00024517          	auipc	a0,0x24
    80004826:	d9650513          	addi	a0,a0,-618 # 800285b8 <ftable>
    8000482a:	ffffc097          	auipc	ra,0xffffc
    8000482e:	400080e7          	jalr	1024(ra) # 80000c2a <acquire>
  if(f->ref < 1)
    80004832:	40dc                	lw	a5,4(s1)
    80004834:	06f05563          	blez	a5,8000489e <fileclose+0x90>
    panic("fileclose");
  if(--f->ref > 0){
    80004838:	37fd                	addiw	a5,a5,-1
    8000483a:	0007871b          	sext.w	a4,a5
    8000483e:	c0dc                	sw	a5,4(s1)
    80004840:	06e04763          	bgtz	a4,800048ae <fileclose+0xa0>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004844:	0004a903          	lw	s2,0(s1)
    80004848:	0094ca83          	lbu	s5,9(s1)
    8000484c:	0104ba03          	ld	s4,16(s1)
    80004850:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004854:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004858:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000485c:	00024517          	auipc	a0,0x24
    80004860:	d5c50513          	addi	a0,a0,-676 # 800285b8 <ftable>
    80004864:	ffffc097          	auipc	ra,0xffffc
    80004868:	436080e7          	jalr	1078(ra) # 80000c9a <release>

  if(ff.type == FD_PIPE){
    8000486c:	4785                	li	a5,1
    8000486e:	06f90163          	beq	s2,a5,800048d0 <fileclose+0xc2>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004872:	3979                	addiw	s2,s2,-2
    80004874:	4785                	li	a5,1
    80004876:	0527e463          	bltu	a5,s2,800048be <fileclose+0xb0>
    begin_op(ff.ip->dev);
    8000487a:	0009a503          	lw	a0,0(s3)
    8000487e:	00000097          	auipc	ra,0x0
    80004882:	9f6080e7          	jalr	-1546(ra) # 80004274 <begin_op>
    iput(ff.ip);
    80004886:	854e                	mv	a0,s3
    80004888:	fffff097          	auipc	ra,0xfffff
    8000488c:	114080e7          	jalr	276(ra) # 8000399c <iput>
    end_op(ff.ip->dev);
    80004890:	0009a503          	lw	a0,0(s3)
    80004894:	00000097          	auipc	ra,0x0
    80004898:	a8a080e7          	jalr	-1398(ra) # 8000431e <end_op>
    8000489c:	a00d                	j	800048be <fileclose+0xb0>
    panic("fileclose");
    8000489e:	00004517          	auipc	a0,0x4
    800048a2:	f1a50513          	addi	a0,a0,-230 # 800087b8 <userret+0x728>
    800048a6:	ffffc097          	auipc	ra,0xffffc
    800048aa:	ca2080e7          	jalr	-862(ra) # 80000548 <panic>
    release(&ftable.lock);
    800048ae:	00024517          	auipc	a0,0x24
    800048b2:	d0a50513          	addi	a0,a0,-758 # 800285b8 <ftable>
    800048b6:	ffffc097          	auipc	ra,0xffffc
    800048ba:	3e4080e7          	jalr	996(ra) # 80000c9a <release>
  }
}
    800048be:	70e2                	ld	ra,56(sp)
    800048c0:	7442                	ld	s0,48(sp)
    800048c2:	74a2                	ld	s1,40(sp)
    800048c4:	7902                	ld	s2,32(sp)
    800048c6:	69e2                	ld	s3,24(sp)
    800048c8:	6a42                	ld	s4,16(sp)
    800048ca:	6aa2                	ld	s5,8(sp)
    800048cc:	6121                	addi	sp,sp,64
    800048ce:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800048d0:	85d6                	mv	a1,s5
    800048d2:	8552                	mv	a0,s4
    800048d4:	00000097          	auipc	ra,0x0
    800048d8:	376080e7          	jalr	886(ra) # 80004c4a <pipeclose>
    800048dc:	b7cd                	j	800048be <fileclose+0xb0>

00000000800048de <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800048de:	715d                	addi	sp,sp,-80
    800048e0:	e486                	sd	ra,72(sp)
    800048e2:	e0a2                	sd	s0,64(sp)
    800048e4:	fc26                	sd	s1,56(sp)
    800048e6:	f84a                	sd	s2,48(sp)
    800048e8:	f44e                	sd	s3,40(sp)
    800048ea:	0880                	addi	s0,sp,80
    800048ec:	84aa                	mv	s1,a0
    800048ee:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800048f0:	ffffd097          	auipc	ra,0xffffd
    800048f4:	292080e7          	jalr	658(ra) # 80001b82 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800048f8:	409c                	lw	a5,0(s1)
    800048fa:	37f9                	addiw	a5,a5,-2
    800048fc:	4705                	li	a4,1
    800048fe:	04f76763          	bltu	a4,a5,8000494c <filestat+0x6e>
    80004902:	892a                	mv	s2,a0
    ilock(f->ip);
    80004904:	6c88                	ld	a0,24(s1)
    80004906:	fffff097          	auipc	ra,0xfffff
    8000490a:	f88080e7          	jalr	-120(ra) # 8000388e <ilock>
    stati(f->ip, &st);
    8000490e:	fb840593          	addi	a1,s0,-72
    80004912:	6c88                	ld	a0,24(s1)
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	1e0080e7          	jalr	480(ra) # 80003af4 <stati>
    iunlock(f->ip);
    8000491c:	6c88                	ld	a0,24(s1)
    8000491e:	fffff097          	auipc	ra,0xfffff
    80004922:	032080e7          	jalr	50(ra) # 80003950 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004926:	46e1                	li	a3,24
    80004928:	fb840613          	addi	a2,s0,-72
    8000492c:	85ce                	mv	a1,s3
    8000492e:	05893503          	ld	a0,88(s2)
    80004932:	ffffd097          	auipc	ra,0xffffd
    80004936:	f42080e7          	jalr	-190(ra) # 80001874 <copyout>
    8000493a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000493e:	60a6                	ld	ra,72(sp)
    80004940:	6406                	ld	s0,64(sp)
    80004942:	74e2                	ld	s1,56(sp)
    80004944:	7942                	ld	s2,48(sp)
    80004946:	79a2                	ld	s3,40(sp)
    80004948:	6161                	addi	sp,sp,80
    8000494a:	8082                	ret
  return -1;
    8000494c:	557d                	li	a0,-1
    8000494e:	bfc5                	j	8000493e <filestat+0x60>

0000000080004950 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004950:	7179                	addi	sp,sp,-48
    80004952:	f406                	sd	ra,40(sp)
    80004954:	f022                	sd	s0,32(sp)
    80004956:	ec26                	sd	s1,24(sp)
    80004958:	e84a                	sd	s2,16(sp)
    8000495a:	e44e                	sd	s3,8(sp)
    8000495c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000495e:	00854783          	lbu	a5,8(a0)
    80004962:	c7c5                	beqz	a5,80004a0a <fileread+0xba>
    80004964:	84aa                	mv	s1,a0
    80004966:	89ae                	mv	s3,a1
    80004968:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000496a:	411c                	lw	a5,0(a0)
    8000496c:	4705                	li	a4,1
    8000496e:	04e78963          	beq	a5,a4,800049c0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004972:	470d                	li	a4,3
    80004974:	04e78d63          	beq	a5,a4,800049ce <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(f, 1, addr, n);
  } else if(f->type == FD_INODE){
    80004978:	4709                	li	a4,2
    8000497a:	08e79063          	bne	a5,a4,800049fa <fileread+0xaa>
    ilock(f->ip);
    8000497e:	6d08                	ld	a0,24(a0)
    80004980:	fffff097          	auipc	ra,0xfffff
    80004984:	f0e080e7          	jalr	-242(ra) # 8000388e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004988:	874a                	mv	a4,s2
    8000498a:	5094                	lw	a3,32(s1)
    8000498c:	864e                	mv	a2,s3
    8000498e:	4585                	li	a1,1
    80004990:	6c88                	ld	a0,24(s1)
    80004992:	fffff097          	auipc	ra,0xfffff
    80004996:	18c080e7          	jalr	396(ra) # 80003b1e <readi>
    8000499a:	892a                	mv	s2,a0
    8000499c:	00a05563          	blez	a0,800049a6 <fileread+0x56>
      f->off += r;
    800049a0:	509c                	lw	a5,32(s1)
    800049a2:	9fa9                	addw	a5,a5,a0
    800049a4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800049a6:	6c88                	ld	a0,24(s1)
    800049a8:	fffff097          	auipc	ra,0xfffff
    800049ac:	fa8080e7          	jalr	-88(ra) # 80003950 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800049b0:	854a                	mv	a0,s2
    800049b2:	70a2                	ld	ra,40(sp)
    800049b4:	7402                	ld	s0,32(sp)
    800049b6:	64e2                	ld	s1,24(sp)
    800049b8:	6942                	ld	s2,16(sp)
    800049ba:	69a2                	ld	s3,8(sp)
    800049bc:	6145                	addi	sp,sp,48
    800049be:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800049c0:	6908                	ld	a0,16(a0)
    800049c2:	00000097          	auipc	ra,0x0
    800049c6:	406080e7          	jalr	1030(ra) # 80004dc8 <piperead>
    800049ca:	892a                	mv	s2,a0
    800049cc:	b7d5                	j	800049b0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800049ce:	02451783          	lh	a5,36(a0)
    800049d2:	03079693          	slli	a3,a5,0x30
    800049d6:	92c1                	srli	a3,a3,0x30
    800049d8:	4725                	li	a4,9
    800049da:	02d76a63          	bltu	a4,a3,80004a0e <fileread+0xbe>
    800049de:	0792                	slli	a5,a5,0x4
    800049e0:	00024717          	auipc	a4,0x24
    800049e4:	b3870713          	addi	a4,a4,-1224 # 80028518 <devsw>
    800049e8:	97ba                	add	a5,a5,a4
    800049ea:	639c                	ld	a5,0(a5)
    800049ec:	c39d                	beqz	a5,80004a12 <fileread+0xc2>
    r = devsw[f->major].read(f, 1, addr, n);
    800049ee:	86b2                	mv	a3,a2
    800049f0:	862e                	mv	a2,a1
    800049f2:	4585                	li	a1,1
    800049f4:	9782                	jalr	a5
    800049f6:	892a                	mv	s2,a0
    800049f8:	bf65                	j	800049b0 <fileread+0x60>
    panic("fileread");
    800049fa:	00004517          	auipc	a0,0x4
    800049fe:	dce50513          	addi	a0,a0,-562 # 800087c8 <userret+0x738>
    80004a02:	ffffc097          	auipc	ra,0xffffc
    80004a06:	b46080e7          	jalr	-1210(ra) # 80000548 <panic>
    return -1;
    80004a0a:	597d                	li	s2,-1
    80004a0c:	b755                	j	800049b0 <fileread+0x60>
      return -1;
    80004a0e:	597d                	li	s2,-1
    80004a10:	b745                	j	800049b0 <fileread+0x60>
    80004a12:	597d                	li	s2,-1
    80004a14:	bf71                	j	800049b0 <fileread+0x60>

0000000080004a16 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004a16:	00954783          	lbu	a5,9(a0)
    80004a1a:	14078663          	beqz	a5,80004b66 <filewrite+0x150>
{
    80004a1e:	715d                	addi	sp,sp,-80
    80004a20:	e486                	sd	ra,72(sp)
    80004a22:	e0a2                	sd	s0,64(sp)
    80004a24:	fc26                	sd	s1,56(sp)
    80004a26:	f84a                	sd	s2,48(sp)
    80004a28:	f44e                	sd	s3,40(sp)
    80004a2a:	f052                	sd	s4,32(sp)
    80004a2c:	ec56                	sd	s5,24(sp)
    80004a2e:	e85a                	sd	s6,16(sp)
    80004a30:	e45e                	sd	s7,8(sp)
    80004a32:	e062                	sd	s8,0(sp)
    80004a34:	0880                	addi	s0,sp,80
    80004a36:	84aa                	mv	s1,a0
    80004a38:	8aae                	mv	s5,a1
    80004a3a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004a3c:	411c                	lw	a5,0(a0)
    80004a3e:	4705                	li	a4,1
    80004a40:	02e78263          	beq	a5,a4,80004a64 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004a44:	470d                	li	a4,3
    80004a46:	02e78563          	beq	a5,a4,80004a70 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(f, 1, addr, n);
  } else if(f->type == FD_INODE){
    80004a4a:	4709                	li	a4,2
    80004a4c:	10e79563          	bne	a5,a4,80004b56 <filewrite+0x140>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004a50:	0ec05f63          	blez	a2,80004b4e <filewrite+0x138>
    int i = 0;
    80004a54:	4981                	li	s3,0
    80004a56:	6b05                	lui	s6,0x1
    80004a58:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004a5c:	6b85                	lui	s7,0x1
    80004a5e:	c00b8b9b          	addiw	s7,s7,-1024
    80004a62:	a851                	j	80004af6 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004a64:	6908                	ld	a0,16(a0)
    80004a66:	00000097          	auipc	ra,0x0
    80004a6a:	254080e7          	jalr	596(ra) # 80004cba <pipewrite>
    80004a6e:	a865                	j	80004b26 <filewrite+0x110>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004a70:	02451783          	lh	a5,36(a0)
    80004a74:	03079693          	slli	a3,a5,0x30
    80004a78:	92c1                	srli	a3,a3,0x30
    80004a7a:	4725                	li	a4,9
    80004a7c:	0ed76763          	bltu	a4,a3,80004b6a <filewrite+0x154>
    80004a80:	0792                	slli	a5,a5,0x4
    80004a82:	00024717          	auipc	a4,0x24
    80004a86:	a9670713          	addi	a4,a4,-1386 # 80028518 <devsw>
    80004a8a:	97ba                	add	a5,a5,a4
    80004a8c:	679c                	ld	a5,8(a5)
    80004a8e:	c3e5                	beqz	a5,80004b6e <filewrite+0x158>
    ret = devsw[f->major].write(f, 1, addr, n);
    80004a90:	86b2                	mv	a3,a2
    80004a92:	862e                	mv	a2,a1
    80004a94:	4585                	li	a1,1
    80004a96:	9782                	jalr	a5
    80004a98:	a079                	j	80004b26 <filewrite+0x110>
    80004a9a:	00090c1b          	sext.w	s8,s2
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op(f->ip->dev);
    80004a9e:	6c9c                	ld	a5,24(s1)
    80004aa0:	4388                	lw	a0,0(a5)
    80004aa2:	fffff097          	auipc	ra,0xfffff
    80004aa6:	7d2080e7          	jalr	2002(ra) # 80004274 <begin_op>
      ilock(f->ip);
    80004aaa:	6c88                	ld	a0,24(s1)
    80004aac:	fffff097          	auipc	ra,0xfffff
    80004ab0:	de2080e7          	jalr	-542(ra) # 8000388e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004ab4:	8762                	mv	a4,s8
    80004ab6:	5094                	lw	a3,32(s1)
    80004ab8:	01598633          	add	a2,s3,s5
    80004abc:	4585                	li	a1,1
    80004abe:	6c88                	ld	a0,24(s1)
    80004ac0:	fffff097          	auipc	ra,0xfffff
    80004ac4:	152080e7          	jalr	338(ra) # 80003c12 <writei>
    80004ac8:	892a                	mv	s2,a0
    80004aca:	02a05e63          	blez	a0,80004b06 <filewrite+0xf0>
        f->off += r;
    80004ace:	509c                	lw	a5,32(s1)
    80004ad0:	9fa9                	addw	a5,a5,a0
    80004ad2:	d09c                	sw	a5,32(s1)
      iunlock(f->ip);
    80004ad4:	6c88                	ld	a0,24(s1)
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	e7a080e7          	jalr	-390(ra) # 80003950 <iunlock>
      end_op(f->ip->dev);
    80004ade:	6c9c                	ld	a5,24(s1)
    80004ae0:	4388                	lw	a0,0(a5)
    80004ae2:	00000097          	auipc	ra,0x0
    80004ae6:	83c080e7          	jalr	-1988(ra) # 8000431e <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004aea:	052c1a63          	bne	s8,s2,80004b3e <filewrite+0x128>
        panic("short filewrite");
      i += r;
    80004aee:	013909bb          	addw	s3,s2,s3
    while(i < n){
    80004af2:	0349d763          	bge	s3,s4,80004b20 <filewrite+0x10a>
      int n1 = n - i;
    80004af6:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004afa:	893e                	mv	s2,a5
    80004afc:	2781                	sext.w	a5,a5
    80004afe:	f8fb5ee3          	bge	s6,a5,80004a9a <filewrite+0x84>
    80004b02:	895e                	mv	s2,s7
    80004b04:	bf59                	j	80004a9a <filewrite+0x84>
      iunlock(f->ip);
    80004b06:	6c88                	ld	a0,24(s1)
    80004b08:	fffff097          	auipc	ra,0xfffff
    80004b0c:	e48080e7          	jalr	-440(ra) # 80003950 <iunlock>
      end_op(f->ip->dev);
    80004b10:	6c9c                	ld	a5,24(s1)
    80004b12:	4388                	lw	a0,0(a5)
    80004b14:	00000097          	auipc	ra,0x0
    80004b18:	80a080e7          	jalr	-2038(ra) # 8000431e <end_op>
      if(r < 0)
    80004b1c:	fc0957e3          	bgez	s2,80004aea <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004b20:	8552                	mv	a0,s4
    80004b22:	033a1863          	bne	s4,s3,80004b52 <filewrite+0x13c>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004b26:	60a6                	ld	ra,72(sp)
    80004b28:	6406                	ld	s0,64(sp)
    80004b2a:	74e2                	ld	s1,56(sp)
    80004b2c:	7942                	ld	s2,48(sp)
    80004b2e:	79a2                	ld	s3,40(sp)
    80004b30:	7a02                	ld	s4,32(sp)
    80004b32:	6ae2                	ld	s5,24(sp)
    80004b34:	6b42                	ld	s6,16(sp)
    80004b36:	6ba2                	ld	s7,8(sp)
    80004b38:	6c02                	ld	s8,0(sp)
    80004b3a:	6161                	addi	sp,sp,80
    80004b3c:	8082                	ret
        panic("short filewrite");
    80004b3e:	00004517          	auipc	a0,0x4
    80004b42:	c9a50513          	addi	a0,a0,-870 # 800087d8 <userret+0x748>
    80004b46:	ffffc097          	auipc	ra,0xffffc
    80004b4a:	a02080e7          	jalr	-1534(ra) # 80000548 <panic>
    int i = 0;
    80004b4e:	4981                	li	s3,0
    80004b50:	bfc1                	j	80004b20 <filewrite+0x10a>
    ret = (i == n ? n : -1);
    80004b52:	557d                	li	a0,-1
    80004b54:	bfc9                	j	80004b26 <filewrite+0x110>
    panic("filewrite");
    80004b56:	00004517          	auipc	a0,0x4
    80004b5a:	c9250513          	addi	a0,a0,-878 # 800087e8 <userret+0x758>
    80004b5e:	ffffc097          	auipc	ra,0xffffc
    80004b62:	9ea080e7          	jalr	-1558(ra) # 80000548 <panic>
    return -1;
    80004b66:	557d                	li	a0,-1
}
    80004b68:	8082                	ret
      return -1;
    80004b6a:	557d                	li	a0,-1
    80004b6c:	bf6d                	j	80004b26 <filewrite+0x110>
    80004b6e:	557d                	li	a0,-1
    80004b70:	bf5d                	j	80004b26 <filewrite+0x110>

0000000080004b72 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004b72:	7179                	addi	sp,sp,-48
    80004b74:	f406                	sd	ra,40(sp)
    80004b76:	f022                	sd	s0,32(sp)
    80004b78:	ec26                	sd	s1,24(sp)
    80004b7a:	e84a                	sd	s2,16(sp)
    80004b7c:	e44e                	sd	s3,8(sp)
    80004b7e:	e052                	sd	s4,0(sp)
    80004b80:	1800                	addi	s0,sp,48
    80004b82:	84aa                	mv	s1,a0
    80004b84:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004b86:	0005b023          	sd	zero,0(a1)
    80004b8a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004b8e:	00000097          	auipc	ra,0x0
    80004b92:	bc4080e7          	jalr	-1084(ra) # 80004752 <filealloc>
    80004b96:	e088                	sd	a0,0(s1)
    80004b98:	c549                	beqz	a0,80004c22 <pipealloc+0xb0>
    80004b9a:	00000097          	auipc	ra,0x0
    80004b9e:	bb8080e7          	jalr	-1096(ra) # 80004752 <filealloc>
    80004ba2:	00aa3023          	sd	a0,0(s4)
    80004ba6:	c925                	beqz	a0,80004c16 <pipealloc+0xa4>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004ba8:	ffffc097          	auipc	ra,0xffffc
    80004bac:	e9c080e7          	jalr	-356(ra) # 80000a44 <kalloc>
    80004bb0:	892a                	mv	s2,a0
    80004bb2:	cd39                	beqz	a0,80004c10 <pipealloc+0x9e>
    goto bad;
  pi->readopen = 1;
    80004bb4:	4985                	li	s3,1
    80004bb6:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80004bba:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80004bbe:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80004bc2:	22052023          	sw	zero,544(a0)
  memset(&pi->lock, 0, sizeof(pi->lock));
    80004bc6:	02000613          	li	a2,32
    80004bca:	4581                	li	a1,0
    80004bcc:	ffffc097          	auipc	ra,0xffffc
    80004bd0:	2cc080e7          	jalr	716(ra) # 80000e98 <memset>
  (*f0)->type = FD_PIPE;
    80004bd4:	609c                	ld	a5,0(s1)
    80004bd6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004bda:	609c                	ld	a5,0(s1)
    80004bdc:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004be0:	609c                	ld	a5,0(s1)
    80004be2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004be6:	609c                	ld	a5,0(s1)
    80004be8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004bec:	000a3783          	ld	a5,0(s4)
    80004bf0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004bf4:	000a3783          	ld	a5,0(s4)
    80004bf8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004bfc:	000a3783          	ld	a5,0(s4)
    80004c00:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004c04:	000a3783          	ld	a5,0(s4)
    80004c08:	0127b823          	sd	s2,16(a5)
  return 0;
    80004c0c:	4501                	li	a0,0
    80004c0e:	a025                	j	80004c36 <pipealloc+0xc4>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004c10:	6088                	ld	a0,0(s1)
    80004c12:	e501                	bnez	a0,80004c1a <pipealloc+0xa8>
    80004c14:	a039                	j	80004c22 <pipealloc+0xb0>
    80004c16:	6088                	ld	a0,0(s1)
    80004c18:	c51d                	beqz	a0,80004c46 <pipealloc+0xd4>
    fileclose(*f0);
    80004c1a:	00000097          	auipc	ra,0x0
    80004c1e:	bf4080e7          	jalr	-1036(ra) # 8000480e <fileclose>
  if(*f1)
    80004c22:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004c26:	557d                	li	a0,-1
  if(*f1)
    80004c28:	c799                	beqz	a5,80004c36 <pipealloc+0xc4>
    fileclose(*f1);
    80004c2a:	853e                	mv	a0,a5
    80004c2c:	00000097          	auipc	ra,0x0
    80004c30:	be2080e7          	jalr	-1054(ra) # 8000480e <fileclose>
  return -1;
    80004c34:	557d                	li	a0,-1
}
    80004c36:	70a2                	ld	ra,40(sp)
    80004c38:	7402                	ld	s0,32(sp)
    80004c3a:	64e2                	ld	s1,24(sp)
    80004c3c:	6942                	ld	s2,16(sp)
    80004c3e:	69a2                	ld	s3,8(sp)
    80004c40:	6a02                	ld	s4,0(sp)
    80004c42:	6145                	addi	sp,sp,48
    80004c44:	8082                	ret
  return -1;
    80004c46:	557d                	li	a0,-1
    80004c48:	b7fd                	j	80004c36 <pipealloc+0xc4>

0000000080004c4a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004c4a:	1101                	addi	sp,sp,-32
    80004c4c:	ec06                	sd	ra,24(sp)
    80004c4e:	e822                	sd	s0,16(sp)
    80004c50:	e426                	sd	s1,8(sp)
    80004c52:	e04a                	sd	s2,0(sp)
    80004c54:	1000                	addi	s0,sp,32
    80004c56:	84aa                	mv	s1,a0
    80004c58:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004c5a:	ffffc097          	auipc	ra,0xffffc
    80004c5e:	fd0080e7          	jalr	-48(ra) # 80000c2a <acquire>
  if(writable){
    80004c62:	02090d63          	beqz	s2,80004c9c <pipeclose+0x52>
    pi->writeopen = 0;
    80004c66:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    80004c6a:	22048513          	addi	a0,s1,544
    80004c6e:	ffffe097          	auipc	ra,0xffffe
    80004c72:	86a080e7          	jalr	-1942(ra) # 800024d8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004c76:	2284b783          	ld	a5,552(s1)
    80004c7a:	eb95                	bnez	a5,80004cae <pipeclose+0x64>
    release(&pi->lock);
    80004c7c:	8526                	mv	a0,s1
    80004c7e:	ffffc097          	auipc	ra,0xffffc
    80004c82:	01c080e7          	jalr	28(ra) # 80000c9a <release>
    kfree((char*)pi);
    80004c86:	8526                	mv	a0,s1
    80004c88:	ffffc097          	auipc	ra,0xffffc
    80004c8c:	bdc080e7          	jalr	-1060(ra) # 80000864 <kfree>
  } else
    release(&pi->lock);
}
    80004c90:	60e2                	ld	ra,24(sp)
    80004c92:	6442                	ld	s0,16(sp)
    80004c94:	64a2                	ld	s1,8(sp)
    80004c96:	6902                	ld	s2,0(sp)
    80004c98:	6105                	addi	sp,sp,32
    80004c9a:	8082                	ret
    pi->readopen = 0;
    80004c9c:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    80004ca0:	22448513          	addi	a0,s1,548
    80004ca4:	ffffe097          	auipc	ra,0xffffe
    80004ca8:	834080e7          	jalr	-1996(ra) # 800024d8 <wakeup>
    80004cac:	b7e9                	j	80004c76 <pipeclose+0x2c>
    release(&pi->lock);
    80004cae:	8526                	mv	a0,s1
    80004cb0:	ffffc097          	auipc	ra,0xffffc
    80004cb4:	fea080e7          	jalr	-22(ra) # 80000c9a <release>
}
    80004cb8:	bfe1                	j	80004c90 <pipeclose+0x46>

0000000080004cba <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004cba:	711d                	addi	sp,sp,-96
    80004cbc:	ec86                	sd	ra,88(sp)
    80004cbe:	e8a2                	sd	s0,80(sp)
    80004cc0:	e4a6                	sd	s1,72(sp)
    80004cc2:	e0ca                	sd	s2,64(sp)
    80004cc4:	fc4e                	sd	s3,56(sp)
    80004cc6:	f852                	sd	s4,48(sp)
    80004cc8:	f456                	sd	s5,40(sp)
    80004cca:	f05a                	sd	s6,32(sp)
    80004ccc:	ec5e                	sd	s7,24(sp)
    80004cce:	e862                	sd	s8,16(sp)
    80004cd0:	1080                	addi	s0,sp,96
    80004cd2:	84aa                	mv	s1,a0
    80004cd4:	8aae                	mv	s5,a1
    80004cd6:	8a32                	mv	s4,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004cd8:	ffffd097          	auipc	ra,0xffffd
    80004cdc:	eaa080e7          	jalr	-342(ra) # 80001b82 <myproc>
    80004ce0:	8baa                	mv	s7,a0

  acquire(&pi->lock);
    80004ce2:	8526                	mv	a0,s1
    80004ce4:	ffffc097          	auipc	ra,0xffffc
    80004ce8:	f46080e7          	jalr	-186(ra) # 80000c2a <acquire>
  for(i = 0; i < n; i++){
    80004cec:	09405f63          	blez	s4,80004d8a <pipewrite+0xd0>
    80004cf0:	fffa0b1b          	addiw	s6,s4,-1
    80004cf4:	1b02                	slli	s6,s6,0x20
    80004cf6:	020b5b13          	srli	s6,s6,0x20
    80004cfa:	001a8793          	addi	a5,s5,1
    80004cfe:	9b3e                	add	s6,s6,a5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004d00:	22048993          	addi	s3,s1,544
      sleep(&pi->nwrite, &pi->lock);
    80004d04:	22448913          	addi	s2,s1,548
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004d08:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004d0a:	2204a783          	lw	a5,544(s1)
    80004d0e:	2244a703          	lw	a4,548(s1)
    80004d12:	2007879b          	addiw	a5,a5,512
    80004d16:	02f71e63          	bne	a4,a5,80004d52 <pipewrite+0x98>
      if(pi->readopen == 0 || myproc()->killed){
    80004d1a:	2284a783          	lw	a5,552(s1)
    80004d1e:	c3d9                	beqz	a5,80004da4 <pipewrite+0xea>
    80004d20:	ffffd097          	auipc	ra,0xffffd
    80004d24:	e62080e7          	jalr	-414(ra) # 80001b82 <myproc>
    80004d28:	5d1c                	lw	a5,56(a0)
    80004d2a:	efad                	bnez	a5,80004da4 <pipewrite+0xea>
      wakeup(&pi->nread);
    80004d2c:	854e                	mv	a0,s3
    80004d2e:	ffffd097          	auipc	ra,0xffffd
    80004d32:	7aa080e7          	jalr	1962(ra) # 800024d8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004d36:	85a6                	mv	a1,s1
    80004d38:	854a                	mv	a0,s2
    80004d3a:	ffffd097          	auipc	ra,0xffffd
    80004d3e:	61e080e7          	jalr	1566(ra) # 80002358 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004d42:	2204a783          	lw	a5,544(s1)
    80004d46:	2244a703          	lw	a4,548(s1)
    80004d4a:	2007879b          	addiw	a5,a5,512
    80004d4e:	fcf706e3          	beq	a4,a5,80004d1a <pipewrite+0x60>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004d52:	4685                	li	a3,1
    80004d54:	8656                	mv	a2,s5
    80004d56:	faf40593          	addi	a1,s0,-81
    80004d5a:	058bb503          	ld	a0,88(s7) # 1058 <_entry-0x7fffefa8>
    80004d5e:	ffffd097          	auipc	ra,0xffffd
    80004d62:	ba2080e7          	jalr	-1118(ra) # 80001900 <copyin>
    80004d66:	03850263          	beq	a0,s8,80004d8a <pipewrite+0xd0>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004d6a:	2244a783          	lw	a5,548(s1)
    80004d6e:	0017871b          	addiw	a4,a5,1
    80004d72:	22e4a223          	sw	a4,548(s1)
    80004d76:	1ff7f793          	andi	a5,a5,511
    80004d7a:	97a6                	add	a5,a5,s1
    80004d7c:	faf44703          	lbu	a4,-81(s0)
    80004d80:	02e78023          	sb	a4,32(a5)
  for(i = 0; i < n; i++){
    80004d84:	0a85                	addi	s5,s5,1
    80004d86:	f96a92e3          	bne	s5,s6,80004d0a <pipewrite+0x50>
  }
  wakeup(&pi->nread);
    80004d8a:	22048513          	addi	a0,s1,544
    80004d8e:	ffffd097          	auipc	ra,0xffffd
    80004d92:	74a080e7          	jalr	1866(ra) # 800024d8 <wakeup>
  release(&pi->lock);
    80004d96:	8526                	mv	a0,s1
    80004d98:	ffffc097          	auipc	ra,0xffffc
    80004d9c:	f02080e7          	jalr	-254(ra) # 80000c9a <release>
  return n;
    80004da0:	8552                	mv	a0,s4
    80004da2:	a039                	j	80004db0 <pipewrite+0xf6>
        release(&pi->lock);
    80004da4:	8526                	mv	a0,s1
    80004da6:	ffffc097          	auipc	ra,0xffffc
    80004daa:	ef4080e7          	jalr	-268(ra) # 80000c9a <release>
        return -1;
    80004dae:	557d                	li	a0,-1
}
    80004db0:	60e6                	ld	ra,88(sp)
    80004db2:	6446                	ld	s0,80(sp)
    80004db4:	64a6                	ld	s1,72(sp)
    80004db6:	6906                	ld	s2,64(sp)
    80004db8:	79e2                	ld	s3,56(sp)
    80004dba:	7a42                	ld	s4,48(sp)
    80004dbc:	7aa2                	ld	s5,40(sp)
    80004dbe:	7b02                	ld	s6,32(sp)
    80004dc0:	6be2                	ld	s7,24(sp)
    80004dc2:	6c42                	ld	s8,16(sp)
    80004dc4:	6125                	addi	sp,sp,96
    80004dc6:	8082                	ret

0000000080004dc8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004dc8:	715d                	addi	sp,sp,-80
    80004dca:	e486                	sd	ra,72(sp)
    80004dcc:	e0a2                	sd	s0,64(sp)
    80004dce:	fc26                	sd	s1,56(sp)
    80004dd0:	f84a                	sd	s2,48(sp)
    80004dd2:	f44e                	sd	s3,40(sp)
    80004dd4:	f052                	sd	s4,32(sp)
    80004dd6:	ec56                	sd	s5,24(sp)
    80004dd8:	e85a                	sd	s6,16(sp)
    80004dda:	0880                	addi	s0,sp,80
    80004ddc:	84aa                	mv	s1,a0
    80004dde:	892e                	mv	s2,a1
    80004de0:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80004de2:	ffffd097          	auipc	ra,0xffffd
    80004de6:	da0080e7          	jalr	-608(ra) # 80001b82 <myproc>
    80004dea:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80004dec:	8526                	mv	a0,s1
    80004dee:	ffffc097          	auipc	ra,0xffffc
    80004df2:	e3c080e7          	jalr	-452(ra) # 80000c2a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004df6:	2204a703          	lw	a4,544(s1)
    80004dfa:	2244a783          	lw	a5,548(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004dfe:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e02:	02f71763          	bne	a4,a5,80004e30 <piperead+0x68>
    80004e06:	22c4a783          	lw	a5,556(s1)
    80004e0a:	c39d                	beqz	a5,80004e30 <piperead+0x68>
    if(myproc()->killed){
    80004e0c:	ffffd097          	auipc	ra,0xffffd
    80004e10:	d76080e7          	jalr	-650(ra) # 80001b82 <myproc>
    80004e14:	5d1c                	lw	a5,56(a0)
    80004e16:	ebc1                	bnez	a5,80004ea6 <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004e18:	85a6                	mv	a1,s1
    80004e1a:	854e                	mv	a0,s3
    80004e1c:	ffffd097          	auipc	ra,0xffffd
    80004e20:	53c080e7          	jalr	1340(ra) # 80002358 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e24:	2204a703          	lw	a4,544(s1)
    80004e28:	2244a783          	lw	a5,548(s1)
    80004e2c:	fcf70de3          	beq	a4,a5,80004e06 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e30:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004e32:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e34:	05405363          	blez	s4,80004e7a <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004e38:	2204a783          	lw	a5,544(s1)
    80004e3c:	2244a703          	lw	a4,548(s1)
    80004e40:	02f70d63          	beq	a4,a5,80004e7a <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004e44:	0017871b          	addiw	a4,a5,1
    80004e48:	22e4a023          	sw	a4,544(s1)
    80004e4c:	1ff7f793          	andi	a5,a5,511
    80004e50:	97a6                	add	a5,a5,s1
    80004e52:	0207c783          	lbu	a5,32(a5)
    80004e56:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004e5a:	4685                	li	a3,1
    80004e5c:	fbf40613          	addi	a2,s0,-65
    80004e60:	85ca                	mv	a1,s2
    80004e62:	058ab503          	ld	a0,88(s5)
    80004e66:	ffffd097          	auipc	ra,0xffffd
    80004e6a:	a0e080e7          	jalr	-1522(ra) # 80001874 <copyout>
    80004e6e:	01650663          	beq	a0,s6,80004e7a <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e72:	2985                	addiw	s3,s3,1
    80004e74:	0905                	addi	s2,s2,1
    80004e76:	fd3a11e3          	bne	s4,s3,80004e38 <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004e7a:	22448513          	addi	a0,s1,548
    80004e7e:	ffffd097          	auipc	ra,0xffffd
    80004e82:	65a080e7          	jalr	1626(ra) # 800024d8 <wakeup>
  release(&pi->lock);
    80004e86:	8526                	mv	a0,s1
    80004e88:	ffffc097          	auipc	ra,0xffffc
    80004e8c:	e12080e7          	jalr	-494(ra) # 80000c9a <release>
  return i;
}
    80004e90:	854e                	mv	a0,s3
    80004e92:	60a6                	ld	ra,72(sp)
    80004e94:	6406                	ld	s0,64(sp)
    80004e96:	74e2                	ld	s1,56(sp)
    80004e98:	7942                	ld	s2,48(sp)
    80004e9a:	79a2                	ld	s3,40(sp)
    80004e9c:	7a02                	ld	s4,32(sp)
    80004e9e:	6ae2                	ld	s5,24(sp)
    80004ea0:	6b42                	ld	s6,16(sp)
    80004ea2:	6161                	addi	sp,sp,80
    80004ea4:	8082                	ret
      release(&pi->lock);
    80004ea6:	8526                	mv	a0,s1
    80004ea8:	ffffc097          	auipc	ra,0xffffc
    80004eac:	df2080e7          	jalr	-526(ra) # 80000c9a <release>
      return -1;
    80004eb0:	59fd                	li	s3,-1
    80004eb2:	bff9                	j	80004e90 <piperead+0xc8>

0000000080004eb4 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004eb4:	de010113          	addi	sp,sp,-544
    80004eb8:	20113c23          	sd	ra,536(sp)
    80004ebc:	20813823          	sd	s0,528(sp)
    80004ec0:	20913423          	sd	s1,520(sp)
    80004ec4:	21213023          	sd	s2,512(sp)
    80004ec8:	ffce                	sd	s3,504(sp)
    80004eca:	fbd2                	sd	s4,496(sp)
    80004ecc:	f7d6                	sd	s5,488(sp)
    80004ece:	f3da                	sd	s6,480(sp)
    80004ed0:	efde                	sd	s7,472(sp)
    80004ed2:	ebe2                	sd	s8,464(sp)
    80004ed4:	e7e6                	sd	s9,456(sp)
    80004ed6:	e3ea                	sd	s10,448(sp)
    80004ed8:	ff6e                	sd	s11,440(sp)
    80004eda:	1400                	addi	s0,sp,544
    80004edc:	892a                	mv	s2,a0
    80004ede:	dea43423          	sd	a0,-536(s0)
    80004ee2:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004ee6:	ffffd097          	auipc	ra,0xffffd
    80004eea:	c9c080e7          	jalr	-868(ra) # 80001b82 <myproc>
    80004eee:	84aa                	mv	s1,a0

  begin_op(ROOTDEV);
    80004ef0:	4501                	li	a0,0
    80004ef2:	fffff097          	auipc	ra,0xfffff
    80004ef6:	382080e7          	jalr	898(ra) # 80004274 <begin_op>

  if((ip = namei(path)) == 0){
    80004efa:	854a                	mv	a0,s2
    80004efc:	fffff097          	auipc	ra,0xfffff
    80004f00:	11c080e7          	jalr	284(ra) # 80004018 <namei>
    80004f04:	cd25                	beqz	a0,80004f7c <exec+0xc8>
    80004f06:	8aaa                	mv	s5,a0
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    80004f08:	fffff097          	auipc	ra,0xfffff
    80004f0c:	986080e7          	jalr	-1658(ra) # 8000388e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004f10:	04000713          	li	a4,64
    80004f14:	4681                	li	a3,0
    80004f16:	e4840613          	addi	a2,s0,-440
    80004f1a:	4581                	li	a1,0
    80004f1c:	8556                	mv	a0,s5
    80004f1e:	fffff097          	auipc	ra,0xfffff
    80004f22:	c00080e7          	jalr	-1024(ra) # 80003b1e <readi>
    80004f26:	04000793          	li	a5,64
    80004f2a:	00f51a63          	bne	a0,a5,80004f3e <exec+0x8a>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004f2e:	e4842703          	lw	a4,-440(s0)
    80004f32:	464c47b7          	lui	a5,0x464c4
    80004f36:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004f3a:	04f70863          	beq	a4,a5,80004f8a <exec+0xd6>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004f3e:	8556                	mv	a0,s5
    80004f40:	fffff097          	auipc	ra,0xfffff
    80004f44:	b8c080e7          	jalr	-1140(ra) # 80003acc <iunlockput>
    end_op(ROOTDEV);
    80004f48:	4501                	li	a0,0
    80004f4a:	fffff097          	auipc	ra,0xfffff
    80004f4e:	3d4080e7          	jalr	980(ra) # 8000431e <end_op>
  }
  return -1;
    80004f52:	557d                	li	a0,-1
}
    80004f54:	21813083          	ld	ra,536(sp)
    80004f58:	21013403          	ld	s0,528(sp)
    80004f5c:	20813483          	ld	s1,520(sp)
    80004f60:	20013903          	ld	s2,512(sp)
    80004f64:	79fe                	ld	s3,504(sp)
    80004f66:	7a5e                	ld	s4,496(sp)
    80004f68:	7abe                	ld	s5,488(sp)
    80004f6a:	7b1e                	ld	s6,480(sp)
    80004f6c:	6bfe                	ld	s7,472(sp)
    80004f6e:	6c5e                	ld	s8,464(sp)
    80004f70:	6cbe                	ld	s9,456(sp)
    80004f72:	6d1e                	ld	s10,448(sp)
    80004f74:	7dfa                	ld	s11,440(sp)
    80004f76:	22010113          	addi	sp,sp,544
    80004f7a:	8082                	ret
    end_op(ROOTDEV);
    80004f7c:	4501                	li	a0,0
    80004f7e:	fffff097          	auipc	ra,0xfffff
    80004f82:	3a0080e7          	jalr	928(ra) # 8000431e <end_op>
    return -1;
    80004f86:	557d                	li	a0,-1
    80004f88:	b7f1                	j	80004f54 <exec+0xa0>
  if((pagetable = proc_pagetable(p)) == 0)
    80004f8a:	8526                	mv	a0,s1
    80004f8c:	ffffd097          	auipc	ra,0xffffd
    80004f90:	cba080e7          	jalr	-838(ra) # 80001c46 <proc_pagetable>
    80004f94:	8b2a                	mv	s6,a0
    80004f96:	d545                	beqz	a0,80004f3e <exec+0x8a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f98:	e6842783          	lw	a5,-408(s0)
    80004f9c:	e8045703          	lhu	a4,-384(s0)
    80004fa0:	10070263          	beqz	a4,800050a4 <exec+0x1f0>
  sz = 0;
    80004fa4:	de043c23          	sd	zero,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004fa8:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004fac:	6a05                	lui	s4,0x1
    80004fae:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004fb2:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80004fb6:	6d85                	lui	s11,0x1
    80004fb8:	7d7d                	lui	s10,0xfffff
    80004fba:	a88d                	j	8000502c <exec+0x178>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004fbc:	00004517          	auipc	a0,0x4
    80004fc0:	83c50513          	addi	a0,a0,-1988 # 800087f8 <userret+0x768>
    80004fc4:	ffffb097          	auipc	ra,0xffffb
    80004fc8:	584080e7          	jalr	1412(ra) # 80000548 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004fcc:	874a                	mv	a4,s2
    80004fce:	009c86bb          	addw	a3,s9,s1
    80004fd2:	4581                	li	a1,0
    80004fd4:	8556                	mv	a0,s5
    80004fd6:	fffff097          	auipc	ra,0xfffff
    80004fda:	b48080e7          	jalr	-1208(ra) # 80003b1e <readi>
    80004fde:	2501                	sext.w	a0,a0
    80004fe0:	10a91863          	bne	s2,a0,800050f0 <exec+0x23c>
  for(i = 0; i < sz; i += PGSIZE){
    80004fe4:	009d84bb          	addw	s1,s11,s1
    80004fe8:	013d09bb          	addw	s3,s10,s3
    80004fec:	0374f263          	bgeu	s1,s7,80005010 <exec+0x15c>
    pa = walkaddr(pagetable, va + i);
    80004ff0:	02049593          	slli	a1,s1,0x20
    80004ff4:	9181                	srli	a1,a1,0x20
    80004ff6:	95e2                	add	a1,a1,s8
    80004ff8:	855a                	mv	a0,s6
    80004ffa:	ffffc097          	auipc	ra,0xffffc
    80004ffe:	298080e7          	jalr	664(ra) # 80001292 <walkaddr>
    80005002:	862a                	mv	a2,a0
    if(pa == 0)
    80005004:	dd45                	beqz	a0,80004fbc <exec+0x108>
      n = PGSIZE;
    80005006:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80005008:	fd49f2e3          	bgeu	s3,s4,80004fcc <exec+0x118>
      n = sz - i;
    8000500c:	894e                	mv	s2,s3
    8000500e:	bf7d                	j	80004fcc <exec+0x118>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005010:	e0843783          	ld	a5,-504(s0)
    80005014:	0017869b          	addiw	a3,a5,1
    80005018:	e0d43423          	sd	a3,-504(s0)
    8000501c:	e0043783          	ld	a5,-512(s0)
    80005020:	0387879b          	addiw	a5,a5,56
    80005024:	e8045703          	lhu	a4,-384(s0)
    80005028:	08e6d063          	bge	a3,a4,800050a8 <exec+0x1f4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000502c:	2781                	sext.w	a5,a5
    8000502e:	e0f43023          	sd	a5,-512(s0)
    80005032:	03800713          	li	a4,56
    80005036:	86be                	mv	a3,a5
    80005038:	e1040613          	addi	a2,s0,-496
    8000503c:	4581                	li	a1,0
    8000503e:	8556                	mv	a0,s5
    80005040:	fffff097          	auipc	ra,0xfffff
    80005044:	ade080e7          	jalr	-1314(ra) # 80003b1e <readi>
    80005048:	03800793          	li	a5,56
    8000504c:	0af51263          	bne	a0,a5,800050f0 <exec+0x23c>
    if(ph.type != ELF_PROG_LOAD)
    80005050:	e1042783          	lw	a5,-496(s0)
    80005054:	4705                	li	a4,1
    80005056:	fae79de3          	bne	a5,a4,80005010 <exec+0x15c>
    if(ph.memsz < ph.filesz)
    8000505a:	e3843603          	ld	a2,-456(s0)
    8000505e:	e3043783          	ld	a5,-464(s0)
    80005062:	08f66763          	bltu	a2,a5,800050f0 <exec+0x23c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005066:	e2043783          	ld	a5,-480(s0)
    8000506a:	963e                	add	a2,a2,a5
    8000506c:	08f66263          	bltu	a2,a5,800050f0 <exec+0x23c>
    if((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005070:	df843583          	ld	a1,-520(s0)
    80005074:	855a                	mv	a0,s6
    80005076:	ffffc097          	auipc	ra,0xffffc
    8000507a:	624080e7          	jalr	1572(ra) # 8000169a <uvmalloc>
    8000507e:	dea43c23          	sd	a0,-520(s0)
    80005082:	c53d                	beqz	a0,800050f0 <exec+0x23c>
    if(ph.vaddr % PGSIZE != 0)
    80005084:	e2043c03          	ld	s8,-480(s0)
    80005088:	de043783          	ld	a5,-544(s0)
    8000508c:	00fc77b3          	and	a5,s8,a5
    80005090:	e3a5                	bnez	a5,800050f0 <exec+0x23c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005092:	e1842c83          	lw	s9,-488(s0)
    80005096:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000509a:	f60b8be3          	beqz	s7,80005010 <exec+0x15c>
    8000509e:	89de                	mv	s3,s7
    800050a0:	4481                	li	s1,0
    800050a2:	b7b9                	j	80004ff0 <exec+0x13c>
  sz = 0;
    800050a4:	de043c23          	sd	zero,-520(s0)
  iunlockput(ip);
    800050a8:	8556                	mv	a0,s5
    800050aa:	fffff097          	auipc	ra,0xfffff
    800050ae:	a22080e7          	jalr	-1502(ra) # 80003acc <iunlockput>
  end_op(ROOTDEV);
    800050b2:	4501                	li	a0,0
    800050b4:	fffff097          	auipc	ra,0xfffff
    800050b8:	26a080e7          	jalr	618(ra) # 8000431e <end_op>
  p = myproc();
    800050bc:	ffffd097          	auipc	ra,0xffffd
    800050c0:	ac6080e7          	jalr	-1338(ra) # 80001b82 <myproc>
    800050c4:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800050c6:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    800050ca:	6585                	lui	a1,0x1
    800050cc:	15fd                	addi	a1,a1,-1
    800050ce:	df843783          	ld	a5,-520(s0)
    800050d2:	95be                	add	a1,a1,a5
    800050d4:	77fd                	lui	a5,0xfffff
    800050d6:	8dfd                	and	a1,a1,a5
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800050d8:	6609                	lui	a2,0x2
    800050da:	962e                	add	a2,a2,a1
    800050dc:	855a                	mv	a0,s6
    800050de:	ffffc097          	auipc	ra,0xffffc
    800050e2:	5bc080e7          	jalr	1468(ra) # 8000169a <uvmalloc>
    800050e6:	892a                	mv	s2,a0
    800050e8:	dea43c23          	sd	a0,-520(s0)
  ip = 0;
    800050ec:	4a81                	li	s5,0
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800050ee:	ed01                	bnez	a0,80005106 <exec+0x252>
    proc_freepagetable(pagetable, sz);
    800050f0:	df843583          	ld	a1,-520(s0)
    800050f4:	855a                	mv	a0,s6
    800050f6:	ffffd097          	auipc	ra,0xffffd
    800050fa:	c50080e7          	jalr	-944(ra) # 80001d46 <proc_freepagetable>
  if(ip){
    800050fe:	e40a90e3          	bnez	s5,80004f3e <exec+0x8a>
  return -1;
    80005102:	557d                	li	a0,-1
    80005104:	bd81                	j	80004f54 <exec+0xa0>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005106:	75f9                	lui	a1,0xffffe
    80005108:	95aa                	add	a1,a1,a0
    8000510a:	855a                	mv	a0,s6
    8000510c:	ffffc097          	auipc	ra,0xffffc
    80005110:	736080e7          	jalr	1846(ra) # 80001842 <uvmclear>
  stackbase = sp - PGSIZE;
    80005114:	7c7d                	lui	s8,0xfffff
    80005116:	9c4a                	add	s8,s8,s2
  for(argc = 0; argv[argc]; argc++) {
    80005118:	df043783          	ld	a5,-528(s0)
    8000511c:	6388                	ld	a0,0(a5)
    8000511e:	c52d                	beqz	a0,80005188 <exec+0x2d4>
    80005120:	e8840993          	addi	s3,s0,-376
    80005124:	f8840a93          	addi	s5,s0,-120
    80005128:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000512a:	ffffc097          	auipc	ra,0xffffc
    8000512e:	ef2080e7          	jalr	-270(ra) # 8000101c <strlen>
    80005132:	0015079b          	addiw	a5,a0,1
    80005136:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000513a:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000513e:	0f896b63          	bltu	s2,s8,80005234 <exec+0x380>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005142:	df043d03          	ld	s10,-528(s0)
    80005146:	000d3a03          	ld	s4,0(s10) # fffffffffffff000 <end+0xffffffff7ffcefa4>
    8000514a:	8552                	mv	a0,s4
    8000514c:	ffffc097          	auipc	ra,0xffffc
    80005150:	ed0080e7          	jalr	-304(ra) # 8000101c <strlen>
    80005154:	0015069b          	addiw	a3,a0,1
    80005158:	8652                	mv	a2,s4
    8000515a:	85ca                	mv	a1,s2
    8000515c:	855a                	mv	a0,s6
    8000515e:	ffffc097          	auipc	ra,0xffffc
    80005162:	716080e7          	jalr	1814(ra) # 80001874 <copyout>
    80005166:	0c054963          	bltz	a0,80005238 <exec+0x384>
    ustack[argc] = sp;
    8000516a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000516e:	0485                	addi	s1,s1,1
    80005170:	008d0793          	addi	a5,s10,8
    80005174:	def43823          	sd	a5,-528(s0)
    80005178:	008d3503          	ld	a0,8(s10)
    8000517c:	c909                	beqz	a0,8000518e <exec+0x2da>
    if(argc >= MAXARG)
    8000517e:	09a1                	addi	s3,s3,8
    80005180:	fb3a95e3          	bne	s5,s3,8000512a <exec+0x276>
  ip = 0;
    80005184:	4a81                	li	s5,0
    80005186:	b7ad                	j	800050f0 <exec+0x23c>
  sp = sz;
    80005188:	df843903          	ld	s2,-520(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000518c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000518e:	00349793          	slli	a5,s1,0x3
    80005192:	f9040713          	addi	a4,s0,-112
    80005196:	97ba                	add	a5,a5,a4
    80005198:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffcee9c>
  sp -= (argc+1) * sizeof(uint64);
    8000519c:	00148693          	addi	a3,s1,1
    800051a0:	068e                	slli	a3,a3,0x3
    800051a2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800051a6:	ff097913          	andi	s2,s2,-16
  ip = 0;
    800051aa:	4a81                	li	s5,0
  if(sp < stackbase)
    800051ac:	f58962e3          	bltu	s2,s8,800050f0 <exec+0x23c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800051b0:	e8840613          	addi	a2,s0,-376
    800051b4:	85ca                	mv	a1,s2
    800051b6:	855a                	mv	a0,s6
    800051b8:	ffffc097          	auipc	ra,0xffffc
    800051bc:	6bc080e7          	jalr	1724(ra) # 80001874 <copyout>
    800051c0:	06054e63          	bltz	a0,8000523c <exec+0x388>
  p->tf->a1 = sp;
    800051c4:	060bb783          	ld	a5,96(s7)
    800051c8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800051cc:	de843783          	ld	a5,-536(s0)
    800051d0:	0007c703          	lbu	a4,0(a5)
    800051d4:	cf11                	beqz	a4,800051f0 <exec+0x33c>
    800051d6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800051d8:	02f00693          	li	a3,47
    800051dc:	a039                	j	800051ea <exec+0x336>
      last = s+1;
    800051de:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800051e2:	0785                	addi	a5,a5,1
    800051e4:	fff7c703          	lbu	a4,-1(a5)
    800051e8:	c701                	beqz	a4,800051f0 <exec+0x33c>
    if(*s == '/')
    800051ea:	fed71ce3          	bne	a4,a3,800051e2 <exec+0x32e>
    800051ee:	bfc5                	j	800051de <exec+0x32a>
  safestrcpy(p->name, last, sizeof(p->name));
    800051f0:	4641                	li	a2,16
    800051f2:	de843583          	ld	a1,-536(s0)
    800051f6:	160b8513          	addi	a0,s7,352
    800051fa:	ffffc097          	auipc	ra,0xffffc
    800051fe:	df0080e7          	jalr	-528(ra) # 80000fea <safestrcpy>
  oldpagetable = p->pagetable;
    80005202:	058bb503          	ld	a0,88(s7)
  p->pagetable = pagetable;
    80005206:	056bbc23          	sd	s6,88(s7)
  p->sz = sz;
    8000520a:	df843783          	ld	a5,-520(s0)
    8000520e:	04fbb823          	sd	a5,80(s7)
  p->tf->epc = elf.entry;  // initial program counter = main
    80005212:	060bb783          	ld	a5,96(s7)
    80005216:	e6043703          	ld	a4,-416(s0)
    8000521a:	ef98                	sd	a4,24(a5)
  p->tf->sp = sp; // initial stack pointer
    8000521c:	060bb783          	ld	a5,96(s7)
    80005220:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005224:	85e6                	mv	a1,s9
    80005226:	ffffd097          	auipc	ra,0xffffd
    8000522a:	b20080e7          	jalr	-1248(ra) # 80001d46 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000522e:	0004851b          	sext.w	a0,s1
    80005232:	b30d                	j	80004f54 <exec+0xa0>
  ip = 0;
    80005234:	4a81                	li	s5,0
    80005236:	bd6d                	j	800050f0 <exec+0x23c>
    80005238:	4a81                	li	s5,0
    8000523a:	bd5d                	j	800050f0 <exec+0x23c>
    8000523c:	4a81                	li	s5,0
    8000523e:	bd4d                	j	800050f0 <exec+0x23c>

0000000080005240 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005240:	7179                	addi	sp,sp,-48
    80005242:	f406                	sd	ra,40(sp)
    80005244:	f022                	sd	s0,32(sp)
    80005246:	ec26                	sd	s1,24(sp)
    80005248:	e84a                	sd	s2,16(sp)
    8000524a:	1800                	addi	s0,sp,48
    8000524c:	892e                	mv	s2,a1
    8000524e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005250:	fdc40593          	addi	a1,s0,-36
    80005254:	ffffe097          	auipc	ra,0xffffe
    80005258:	9a8080e7          	jalr	-1624(ra) # 80002bfc <argint>
    8000525c:	04054063          	bltz	a0,8000529c <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005260:	fdc42703          	lw	a4,-36(s0)
    80005264:	47bd                	li	a5,15
    80005266:	02e7ed63          	bltu	a5,a4,800052a0 <argfd+0x60>
    8000526a:	ffffd097          	auipc	ra,0xffffd
    8000526e:	918080e7          	jalr	-1768(ra) # 80001b82 <myproc>
    80005272:	fdc42703          	lw	a4,-36(s0)
    80005276:	01a70793          	addi	a5,a4,26
    8000527a:	078e                	slli	a5,a5,0x3
    8000527c:	953e                	add	a0,a0,a5
    8000527e:	651c                	ld	a5,8(a0)
    80005280:	c395                	beqz	a5,800052a4 <argfd+0x64>
    return -1;
  if(pfd)
    80005282:	00090463          	beqz	s2,8000528a <argfd+0x4a>
    *pfd = fd;
    80005286:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000528a:	4501                	li	a0,0
  if(pf)
    8000528c:	c091                	beqz	s1,80005290 <argfd+0x50>
    *pf = f;
    8000528e:	e09c                	sd	a5,0(s1)
}
    80005290:	70a2                	ld	ra,40(sp)
    80005292:	7402                	ld	s0,32(sp)
    80005294:	64e2                	ld	s1,24(sp)
    80005296:	6942                	ld	s2,16(sp)
    80005298:	6145                	addi	sp,sp,48
    8000529a:	8082                	ret
    return -1;
    8000529c:	557d                	li	a0,-1
    8000529e:	bfcd                	j	80005290 <argfd+0x50>
    return -1;
    800052a0:	557d                	li	a0,-1
    800052a2:	b7fd                	j	80005290 <argfd+0x50>
    800052a4:	557d                	li	a0,-1
    800052a6:	b7ed                	j	80005290 <argfd+0x50>

00000000800052a8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800052a8:	1101                	addi	sp,sp,-32
    800052aa:	ec06                	sd	ra,24(sp)
    800052ac:	e822                	sd	s0,16(sp)
    800052ae:	e426                	sd	s1,8(sp)
    800052b0:	1000                	addi	s0,sp,32
    800052b2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800052b4:	ffffd097          	auipc	ra,0xffffd
    800052b8:	8ce080e7          	jalr	-1842(ra) # 80001b82 <myproc>
    800052bc:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800052be:	0d850793          	addi	a5,a0,216
    800052c2:	4501                	li	a0,0
    800052c4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800052c6:	6398                	ld	a4,0(a5)
    800052c8:	cb19                	beqz	a4,800052de <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800052ca:	2505                	addiw	a0,a0,1
    800052cc:	07a1                	addi	a5,a5,8
    800052ce:	fed51ce3          	bne	a0,a3,800052c6 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800052d2:	557d                	li	a0,-1
}
    800052d4:	60e2                	ld	ra,24(sp)
    800052d6:	6442                	ld	s0,16(sp)
    800052d8:	64a2                	ld	s1,8(sp)
    800052da:	6105                	addi	sp,sp,32
    800052dc:	8082                	ret
      p->ofile[fd] = f;
    800052de:	01a50793          	addi	a5,a0,26
    800052e2:	078e                	slli	a5,a5,0x3
    800052e4:	963e                	add	a2,a2,a5
    800052e6:	e604                	sd	s1,8(a2)
      return fd;
    800052e8:	b7f5                	j	800052d4 <fdalloc+0x2c>

00000000800052ea <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800052ea:	715d                	addi	sp,sp,-80
    800052ec:	e486                	sd	ra,72(sp)
    800052ee:	e0a2                	sd	s0,64(sp)
    800052f0:	fc26                	sd	s1,56(sp)
    800052f2:	f84a                	sd	s2,48(sp)
    800052f4:	f44e                	sd	s3,40(sp)
    800052f6:	f052                	sd	s4,32(sp)
    800052f8:	ec56                	sd	s5,24(sp)
    800052fa:	0880                	addi	s0,sp,80
    800052fc:	89ae                	mv	s3,a1
    800052fe:	8ab2                	mv	s5,a2
    80005300:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005302:	fb040593          	addi	a1,s0,-80
    80005306:	fffff097          	auipc	ra,0xfffff
    8000530a:	d30080e7          	jalr	-720(ra) # 80004036 <nameiparent>
    8000530e:	892a                	mv	s2,a0
    80005310:	12050e63          	beqz	a0,8000544c <create+0x162>
    return 0;

  ilock(dp);
    80005314:	ffffe097          	auipc	ra,0xffffe
    80005318:	57a080e7          	jalr	1402(ra) # 8000388e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000531c:	4601                	li	a2,0
    8000531e:	fb040593          	addi	a1,s0,-80
    80005322:	854a                	mv	a0,s2
    80005324:	fffff097          	auipc	ra,0xfffff
    80005328:	a22080e7          	jalr	-1502(ra) # 80003d46 <dirlookup>
    8000532c:	84aa                	mv	s1,a0
    8000532e:	c921                	beqz	a0,8000537e <create+0x94>
    iunlockput(dp);
    80005330:	854a                	mv	a0,s2
    80005332:	ffffe097          	auipc	ra,0xffffe
    80005336:	79a080e7          	jalr	1946(ra) # 80003acc <iunlockput>
    ilock(ip);
    8000533a:	8526                	mv	a0,s1
    8000533c:	ffffe097          	auipc	ra,0xffffe
    80005340:	552080e7          	jalr	1362(ra) # 8000388e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005344:	2981                	sext.w	s3,s3
    80005346:	4789                	li	a5,2
    80005348:	02f99463          	bne	s3,a5,80005370 <create+0x86>
    8000534c:	04c4d783          	lhu	a5,76(s1)
    80005350:	37f9                	addiw	a5,a5,-2
    80005352:	17c2                	slli	a5,a5,0x30
    80005354:	93c1                	srli	a5,a5,0x30
    80005356:	4705                	li	a4,1
    80005358:	00f76c63          	bltu	a4,a5,80005370 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000535c:	8526                	mv	a0,s1
    8000535e:	60a6                	ld	ra,72(sp)
    80005360:	6406                	ld	s0,64(sp)
    80005362:	74e2                	ld	s1,56(sp)
    80005364:	7942                	ld	s2,48(sp)
    80005366:	79a2                	ld	s3,40(sp)
    80005368:	7a02                	ld	s4,32(sp)
    8000536a:	6ae2                	ld	s5,24(sp)
    8000536c:	6161                	addi	sp,sp,80
    8000536e:	8082                	ret
    iunlockput(ip);
    80005370:	8526                	mv	a0,s1
    80005372:	ffffe097          	auipc	ra,0xffffe
    80005376:	75a080e7          	jalr	1882(ra) # 80003acc <iunlockput>
    return 0;
    8000537a:	4481                	li	s1,0
    8000537c:	b7c5                	j	8000535c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000537e:	85ce                	mv	a1,s3
    80005380:	00092503          	lw	a0,0(s2)
    80005384:	ffffe097          	auipc	ra,0xffffe
    80005388:	372080e7          	jalr	882(ra) # 800036f6 <ialloc>
    8000538c:	84aa                	mv	s1,a0
    8000538e:	c521                	beqz	a0,800053d6 <create+0xec>
  ilock(ip);
    80005390:	ffffe097          	auipc	ra,0xffffe
    80005394:	4fe080e7          	jalr	1278(ra) # 8000388e <ilock>
  ip->major = major;
    80005398:	05549723          	sh	s5,78(s1)
  ip->minor = minor;
    8000539c:	05449823          	sh	s4,80(s1)
  ip->nlink = 1;
    800053a0:	4a05                	li	s4,1
    800053a2:	05449923          	sh	s4,82(s1)
  iupdate(ip);
    800053a6:	8526                	mv	a0,s1
    800053a8:	ffffe097          	auipc	ra,0xffffe
    800053ac:	41c080e7          	jalr	1052(ra) # 800037c4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800053b0:	2981                	sext.w	s3,s3
    800053b2:	03498a63          	beq	s3,s4,800053e6 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800053b6:	40d0                	lw	a2,4(s1)
    800053b8:	fb040593          	addi	a1,s0,-80
    800053bc:	854a                	mv	a0,s2
    800053be:	fffff097          	auipc	ra,0xfffff
    800053c2:	b98080e7          	jalr	-1128(ra) # 80003f56 <dirlink>
    800053c6:	06054b63          	bltz	a0,8000543c <create+0x152>
  iunlockput(dp);
    800053ca:	854a                	mv	a0,s2
    800053cc:	ffffe097          	auipc	ra,0xffffe
    800053d0:	700080e7          	jalr	1792(ra) # 80003acc <iunlockput>
  return ip;
    800053d4:	b761                	j	8000535c <create+0x72>
    panic("create: ialloc");
    800053d6:	00003517          	auipc	a0,0x3
    800053da:	44250513          	addi	a0,a0,1090 # 80008818 <userret+0x788>
    800053de:	ffffb097          	auipc	ra,0xffffb
    800053e2:	16a080e7          	jalr	362(ra) # 80000548 <panic>
    dp->nlink++;  // for ".."
    800053e6:	05295783          	lhu	a5,82(s2)
    800053ea:	2785                	addiw	a5,a5,1
    800053ec:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    800053f0:	854a                	mv	a0,s2
    800053f2:	ffffe097          	auipc	ra,0xffffe
    800053f6:	3d2080e7          	jalr	978(ra) # 800037c4 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800053fa:	40d0                	lw	a2,4(s1)
    800053fc:	00003597          	auipc	a1,0x3
    80005400:	42c58593          	addi	a1,a1,1068 # 80008828 <userret+0x798>
    80005404:	8526                	mv	a0,s1
    80005406:	fffff097          	auipc	ra,0xfffff
    8000540a:	b50080e7          	jalr	-1200(ra) # 80003f56 <dirlink>
    8000540e:	00054f63          	bltz	a0,8000542c <create+0x142>
    80005412:	00492603          	lw	a2,4(s2)
    80005416:	00003597          	auipc	a1,0x3
    8000541a:	41a58593          	addi	a1,a1,1050 # 80008830 <userret+0x7a0>
    8000541e:	8526                	mv	a0,s1
    80005420:	fffff097          	auipc	ra,0xfffff
    80005424:	b36080e7          	jalr	-1226(ra) # 80003f56 <dirlink>
    80005428:	f80557e3          	bgez	a0,800053b6 <create+0xcc>
      panic("create dots");
    8000542c:	00003517          	auipc	a0,0x3
    80005430:	40c50513          	addi	a0,a0,1036 # 80008838 <userret+0x7a8>
    80005434:	ffffb097          	auipc	ra,0xffffb
    80005438:	114080e7          	jalr	276(ra) # 80000548 <panic>
    panic("create: dirlink");
    8000543c:	00003517          	auipc	a0,0x3
    80005440:	40c50513          	addi	a0,a0,1036 # 80008848 <userret+0x7b8>
    80005444:	ffffb097          	auipc	ra,0xffffb
    80005448:	104080e7          	jalr	260(ra) # 80000548 <panic>
    return 0;
    8000544c:	84aa                	mv	s1,a0
    8000544e:	b739                	j	8000535c <create+0x72>

0000000080005450 <sys_dup>:
{
    80005450:	7179                	addi	sp,sp,-48
    80005452:	f406                	sd	ra,40(sp)
    80005454:	f022                	sd	s0,32(sp)
    80005456:	ec26                	sd	s1,24(sp)
    80005458:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000545a:	fd840613          	addi	a2,s0,-40
    8000545e:	4581                	li	a1,0
    80005460:	4501                	li	a0,0
    80005462:	00000097          	auipc	ra,0x0
    80005466:	dde080e7          	jalr	-546(ra) # 80005240 <argfd>
    return -1;
    8000546a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000546c:	02054363          	bltz	a0,80005492 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005470:	fd843503          	ld	a0,-40(s0)
    80005474:	00000097          	auipc	ra,0x0
    80005478:	e34080e7          	jalr	-460(ra) # 800052a8 <fdalloc>
    8000547c:	84aa                	mv	s1,a0
    return -1;
    8000547e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005480:	00054963          	bltz	a0,80005492 <sys_dup+0x42>
  filedup(f);
    80005484:	fd843503          	ld	a0,-40(s0)
    80005488:	fffff097          	auipc	ra,0xfffff
    8000548c:	334080e7          	jalr	820(ra) # 800047bc <filedup>
  return fd;
    80005490:	87a6                	mv	a5,s1
}
    80005492:	853e                	mv	a0,a5
    80005494:	70a2                	ld	ra,40(sp)
    80005496:	7402                	ld	s0,32(sp)
    80005498:	64e2                	ld	s1,24(sp)
    8000549a:	6145                	addi	sp,sp,48
    8000549c:	8082                	ret

000000008000549e <sys_read>:
{
    8000549e:	7179                	addi	sp,sp,-48
    800054a0:	f406                	sd	ra,40(sp)
    800054a2:	f022                	sd	s0,32(sp)
    800054a4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054a6:	fe840613          	addi	a2,s0,-24
    800054aa:	4581                	li	a1,0
    800054ac:	4501                	li	a0,0
    800054ae:	00000097          	auipc	ra,0x0
    800054b2:	d92080e7          	jalr	-622(ra) # 80005240 <argfd>
    return -1;
    800054b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054b8:	04054163          	bltz	a0,800054fa <sys_read+0x5c>
    800054bc:	fe440593          	addi	a1,s0,-28
    800054c0:	4509                	li	a0,2
    800054c2:	ffffd097          	auipc	ra,0xffffd
    800054c6:	73a080e7          	jalr	1850(ra) # 80002bfc <argint>
    return -1;
    800054ca:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054cc:	02054763          	bltz	a0,800054fa <sys_read+0x5c>
    800054d0:	fd840593          	addi	a1,s0,-40
    800054d4:	4505                	li	a0,1
    800054d6:	ffffd097          	auipc	ra,0xffffd
    800054da:	748080e7          	jalr	1864(ra) # 80002c1e <argaddr>
    return -1;
    800054de:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054e0:	00054d63          	bltz	a0,800054fa <sys_read+0x5c>
  return fileread(f, p, n);
    800054e4:	fe442603          	lw	a2,-28(s0)
    800054e8:	fd843583          	ld	a1,-40(s0)
    800054ec:	fe843503          	ld	a0,-24(s0)
    800054f0:	fffff097          	auipc	ra,0xfffff
    800054f4:	460080e7          	jalr	1120(ra) # 80004950 <fileread>
    800054f8:	87aa                	mv	a5,a0
}
    800054fa:	853e                	mv	a0,a5
    800054fc:	70a2                	ld	ra,40(sp)
    800054fe:	7402                	ld	s0,32(sp)
    80005500:	6145                	addi	sp,sp,48
    80005502:	8082                	ret

0000000080005504 <sys_write>:
{
    80005504:	7179                	addi	sp,sp,-48
    80005506:	f406                	sd	ra,40(sp)
    80005508:	f022                	sd	s0,32(sp)
    8000550a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000550c:	fe840613          	addi	a2,s0,-24
    80005510:	4581                	li	a1,0
    80005512:	4501                	li	a0,0
    80005514:	00000097          	auipc	ra,0x0
    80005518:	d2c080e7          	jalr	-724(ra) # 80005240 <argfd>
    return -1;
    8000551c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000551e:	04054163          	bltz	a0,80005560 <sys_write+0x5c>
    80005522:	fe440593          	addi	a1,s0,-28
    80005526:	4509                	li	a0,2
    80005528:	ffffd097          	auipc	ra,0xffffd
    8000552c:	6d4080e7          	jalr	1748(ra) # 80002bfc <argint>
    return -1;
    80005530:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005532:	02054763          	bltz	a0,80005560 <sys_write+0x5c>
    80005536:	fd840593          	addi	a1,s0,-40
    8000553a:	4505                	li	a0,1
    8000553c:	ffffd097          	auipc	ra,0xffffd
    80005540:	6e2080e7          	jalr	1762(ra) # 80002c1e <argaddr>
    return -1;
    80005544:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005546:	00054d63          	bltz	a0,80005560 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000554a:	fe442603          	lw	a2,-28(s0)
    8000554e:	fd843583          	ld	a1,-40(s0)
    80005552:	fe843503          	ld	a0,-24(s0)
    80005556:	fffff097          	auipc	ra,0xfffff
    8000555a:	4c0080e7          	jalr	1216(ra) # 80004a16 <filewrite>
    8000555e:	87aa                	mv	a5,a0
}
    80005560:	853e                	mv	a0,a5
    80005562:	70a2                	ld	ra,40(sp)
    80005564:	7402                	ld	s0,32(sp)
    80005566:	6145                	addi	sp,sp,48
    80005568:	8082                	ret

000000008000556a <sys_close>:
{
    8000556a:	1101                	addi	sp,sp,-32
    8000556c:	ec06                	sd	ra,24(sp)
    8000556e:	e822                	sd	s0,16(sp)
    80005570:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005572:	fe040613          	addi	a2,s0,-32
    80005576:	fec40593          	addi	a1,s0,-20
    8000557a:	4501                	li	a0,0
    8000557c:	00000097          	auipc	ra,0x0
    80005580:	cc4080e7          	jalr	-828(ra) # 80005240 <argfd>
    return -1;
    80005584:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005586:	02054463          	bltz	a0,800055ae <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000558a:	ffffc097          	auipc	ra,0xffffc
    8000558e:	5f8080e7          	jalr	1528(ra) # 80001b82 <myproc>
    80005592:	fec42783          	lw	a5,-20(s0)
    80005596:	07e9                	addi	a5,a5,26
    80005598:	078e                	slli	a5,a5,0x3
    8000559a:	97aa                	add	a5,a5,a0
    8000559c:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    800055a0:	fe043503          	ld	a0,-32(s0)
    800055a4:	fffff097          	auipc	ra,0xfffff
    800055a8:	26a080e7          	jalr	618(ra) # 8000480e <fileclose>
  return 0;
    800055ac:	4781                	li	a5,0
}
    800055ae:	853e                	mv	a0,a5
    800055b0:	60e2                	ld	ra,24(sp)
    800055b2:	6442                	ld	s0,16(sp)
    800055b4:	6105                	addi	sp,sp,32
    800055b6:	8082                	ret

00000000800055b8 <sys_fstat>:
{
    800055b8:	1101                	addi	sp,sp,-32
    800055ba:	ec06                	sd	ra,24(sp)
    800055bc:	e822                	sd	s0,16(sp)
    800055be:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800055c0:	fe840613          	addi	a2,s0,-24
    800055c4:	4581                	li	a1,0
    800055c6:	4501                	li	a0,0
    800055c8:	00000097          	auipc	ra,0x0
    800055cc:	c78080e7          	jalr	-904(ra) # 80005240 <argfd>
    return -1;
    800055d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800055d2:	02054563          	bltz	a0,800055fc <sys_fstat+0x44>
    800055d6:	fe040593          	addi	a1,s0,-32
    800055da:	4505                	li	a0,1
    800055dc:	ffffd097          	auipc	ra,0xffffd
    800055e0:	642080e7          	jalr	1602(ra) # 80002c1e <argaddr>
    return -1;
    800055e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800055e6:	00054b63          	bltz	a0,800055fc <sys_fstat+0x44>
  return filestat(f, st);
    800055ea:	fe043583          	ld	a1,-32(s0)
    800055ee:	fe843503          	ld	a0,-24(s0)
    800055f2:	fffff097          	auipc	ra,0xfffff
    800055f6:	2ec080e7          	jalr	748(ra) # 800048de <filestat>
    800055fa:	87aa                	mv	a5,a0
}
    800055fc:	853e                	mv	a0,a5
    800055fe:	60e2                	ld	ra,24(sp)
    80005600:	6442                	ld	s0,16(sp)
    80005602:	6105                	addi	sp,sp,32
    80005604:	8082                	ret

0000000080005606 <sys_link>:
{
    80005606:	7169                	addi	sp,sp,-304
    80005608:	f606                	sd	ra,296(sp)
    8000560a:	f222                	sd	s0,288(sp)
    8000560c:	ee26                	sd	s1,280(sp)
    8000560e:	ea4a                	sd	s2,272(sp)
    80005610:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005612:	08000613          	li	a2,128
    80005616:	ed040593          	addi	a1,s0,-304
    8000561a:	4501                	li	a0,0
    8000561c:	ffffd097          	auipc	ra,0xffffd
    80005620:	624080e7          	jalr	1572(ra) # 80002c40 <argstr>
    return -1;
    80005624:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005626:	12054363          	bltz	a0,8000574c <sys_link+0x146>
    8000562a:	08000613          	li	a2,128
    8000562e:	f5040593          	addi	a1,s0,-176
    80005632:	4505                	li	a0,1
    80005634:	ffffd097          	auipc	ra,0xffffd
    80005638:	60c080e7          	jalr	1548(ra) # 80002c40 <argstr>
    return -1;
    8000563c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000563e:	10054763          	bltz	a0,8000574c <sys_link+0x146>
  begin_op(ROOTDEV);
    80005642:	4501                	li	a0,0
    80005644:	fffff097          	auipc	ra,0xfffff
    80005648:	c30080e7          	jalr	-976(ra) # 80004274 <begin_op>
  if((ip = namei(old)) == 0){
    8000564c:	ed040513          	addi	a0,s0,-304
    80005650:	fffff097          	auipc	ra,0xfffff
    80005654:	9c8080e7          	jalr	-1592(ra) # 80004018 <namei>
    80005658:	84aa                	mv	s1,a0
    8000565a:	c559                	beqz	a0,800056e8 <sys_link+0xe2>
  ilock(ip);
    8000565c:	ffffe097          	auipc	ra,0xffffe
    80005660:	232080e7          	jalr	562(ra) # 8000388e <ilock>
  if(ip->type == T_DIR){
    80005664:	04c49703          	lh	a4,76(s1)
    80005668:	4785                	li	a5,1
    8000566a:	08f70663          	beq	a4,a5,800056f6 <sys_link+0xf0>
  ip->nlink++;
    8000566e:	0524d783          	lhu	a5,82(s1)
    80005672:	2785                	addiw	a5,a5,1
    80005674:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80005678:	8526                	mv	a0,s1
    8000567a:	ffffe097          	auipc	ra,0xffffe
    8000567e:	14a080e7          	jalr	330(ra) # 800037c4 <iupdate>
  iunlock(ip);
    80005682:	8526                	mv	a0,s1
    80005684:	ffffe097          	auipc	ra,0xffffe
    80005688:	2cc080e7          	jalr	716(ra) # 80003950 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000568c:	fd040593          	addi	a1,s0,-48
    80005690:	f5040513          	addi	a0,s0,-176
    80005694:	fffff097          	auipc	ra,0xfffff
    80005698:	9a2080e7          	jalr	-1630(ra) # 80004036 <nameiparent>
    8000569c:	892a                	mv	s2,a0
    8000569e:	cd2d                	beqz	a0,80005718 <sys_link+0x112>
  ilock(dp);
    800056a0:	ffffe097          	auipc	ra,0xffffe
    800056a4:	1ee080e7          	jalr	494(ra) # 8000388e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800056a8:	00092703          	lw	a4,0(s2)
    800056ac:	409c                	lw	a5,0(s1)
    800056ae:	06f71063          	bne	a4,a5,8000570e <sys_link+0x108>
    800056b2:	40d0                	lw	a2,4(s1)
    800056b4:	fd040593          	addi	a1,s0,-48
    800056b8:	854a                	mv	a0,s2
    800056ba:	fffff097          	auipc	ra,0xfffff
    800056be:	89c080e7          	jalr	-1892(ra) # 80003f56 <dirlink>
    800056c2:	04054663          	bltz	a0,8000570e <sys_link+0x108>
  iunlockput(dp);
    800056c6:	854a                	mv	a0,s2
    800056c8:	ffffe097          	auipc	ra,0xffffe
    800056cc:	404080e7          	jalr	1028(ra) # 80003acc <iunlockput>
  iput(ip);
    800056d0:	8526                	mv	a0,s1
    800056d2:	ffffe097          	auipc	ra,0xffffe
    800056d6:	2ca080e7          	jalr	714(ra) # 8000399c <iput>
  end_op(ROOTDEV);
    800056da:	4501                	li	a0,0
    800056dc:	fffff097          	auipc	ra,0xfffff
    800056e0:	c42080e7          	jalr	-958(ra) # 8000431e <end_op>
  return 0;
    800056e4:	4781                	li	a5,0
    800056e6:	a09d                	j	8000574c <sys_link+0x146>
    end_op(ROOTDEV);
    800056e8:	4501                	li	a0,0
    800056ea:	fffff097          	auipc	ra,0xfffff
    800056ee:	c34080e7          	jalr	-972(ra) # 8000431e <end_op>
    return -1;
    800056f2:	57fd                	li	a5,-1
    800056f4:	a8a1                	j	8000574c <sys_link+0x146>
    iunlockput(ip);
    800056f6:	8526                	mv	a0,s1
    800056f8:	ffffe097          	auipc	ra,0xffffe
    800056fc:	3d4080e7          	jalr	980(ra) # 80003acc <iunlockput>
    end_op(ROOTDEV);
    80005700:	4501                	li	a0,0
    80005702:	fffff097          	auipc	ra,0xfffff
    80005706:	c1c080e7          	jalr	-996(ra) # 8000431e <end_op>
    return -1;
    8000570a:	57fd                	li	a5,-1
    8000570c:	a081                	j	8000574c <sys_link+0x146>
    iunlockput(dp);
    8000570e:	854a                	mv	a0,s2
    80005710:	ffffe097          	auipc	ra,0xffffe
    80005714:	3bc080e7          	jalr	956(ra) # 80003acc <iunlockput>
  ilock(ip);
    80005718:	8526                	mv	a0,s1
    8000571a:	ffffe097          	auipc	ra,0xffffe
    8000571e:	174080e7          	jalr	372(ra) # 8000388e <ilock>
  ip->nlink--;
    80005722:	0524d783          	lhu	a5,82(s1)
    80005726:	37fd                	addiw	a5,a5,-1
    80005728:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    8000572c:	8526                	mv	a0,s1
    8000572e:	ffffe097          	auipc	ra,0xffffe
    80005732:	096080e7          	jalr	150(ra) # 800037c4 <iupdate>
  iunlockput(ip);
    80005736:	8526                	mv	a0,s1
    80005738:	ffffe097          	auipc	ra,0xffffe
    8000573c:	394080e7          	jalr	916(ra) # 80003acc <iunlockput>
  end_op(ROOTDEV);
    80005740:	4501                	li	a0,0
    80005742:	fffff097          	auipc	ra,0xfffff
    80005746:	bdc080e7          	jalr	-1060(ra) # 8000431e <end_op>
  return -1;
    8000574a:	57fd                	li	a5,-1
}
    8000574c:	853e                	mv	a0,a5
    8000574e:	70b2                	ld	ra,296(sp)
    80005750:	7412                	ld	s0,288(sp)
    80005752:	64f2                	ld	s1,280(sp)
    80005754:	6952                	ld	s2,272(sp)
    80005756:	6155                	addi	sp,sp,304
    80005758:	8082                	ret

000000008000575a <sys_unlink>:
{
    8000575a:	7151                	addi	sp,sp,-240
    8000575c:	f586                	sd	ra,232(sp)
    8000575e:	f1a2                	sd	s0,224(sp)
    80005760:	eda6                	sd	s1,216(sp)
    80005762:	e9ca                	sd	s2,208(sp)
    80005764:	e5ce                	sd	s3,200(sp)
    80005766:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005768:	08000613          	li	a2,128
    8000576c:	f3040593          	addi	a1,s0,-208
    80005770:	4501                	li	a0,0
    80005772:	ffffd097          	auipc	ra,0xffffd
    80005776:	4ce080e7          	jalr	1230(ra) # 80002c40 <argstr>
    8000577a:	18054463          	bltz	a0,80005902 <sys_unlink+0x1a8>
  begin_op(ROOTDEV);
    8000577e:	4501                	li	a0,0
    80005780:	fffff097          	auipc	ra,0xfffff
    80005784:	af4080e7          	jalr	-1292(ra) # 80004274 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005788:	fb040593          	addi	a1,s0,-80
    8000578c:	f3040513          	addi	a0,s0,-208
    80005790:	fffff097          	auipc	ra,0xfffff
    80005794:	8a6080e7          	jalr	-1882(ra) # 80004036 <nameiparent>
    80005798:	84aa                	mv	s1,a0
    8000579a:	cd61                	beqz	a0,80005872 <sys_unlink+0x118>
  ilock(dp);
    8000579c:	ffffe097          	auipc	ra,0xffffe
    800057a0:	0f2080e7          	jalr	242(ra) # 8000388e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800057a4:	00003597          	auipc	a1,0x3
    800057a8:	08458593          	addi	a1,a1,132 # 80008828 <userret+0x798>
    800057ac:	fb040513          	addi	a0,s0,-80
    800057b0:	ffffe097          	auipc	ra,0xffffe
    800057b4:	57c080e7          	jalr	1404(ra) # 80003d2c <namecmp>
    800057b8:	14050c63          	beqz	a0,80005910 <sys_unlink+0x1b6>
    800057bc:	00003597          	auipc	a1,0x3
    800057c0:	07458593          	addi	a1,a1,116 # 80008830 <userret+0x7a0>
    800057c4:	fb040513          	addi	a0,s0,-80
    800057c8:	ffffe097          	auipc	ra,0xffffe
    800057cc:	564080e7          	jalr	1380(ra) # 80003d2c <namecmp>
    800057d0:	14050063          	beqz	a0,80005910 <sys_unlink+0x1b6>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800057d4:	f2c40613          	addi	a2,s0,-212
    800057d8:	fb040593          	addi	a1,s0,-80
    800057dc:	8526                	mv	a0,s1
    800057de:	ffffe097          	auipc	ra,0xffffe
    800057e2:	568080e7          	jalr	1384(ra) # 80003d46 <dirlookup>
    800057e6:	892a                	mv	s2,a0
    800057e8:	12050463          	beqz	a0,80005910 <sys_unlink+0x1b6>
  ilock(ip);
    800057ec:	ffffe097          	auipc	ra,0xffffe
    800057f0:	0a2080e7          	jalr	162(ra) # 8000388e <ilock>
  if(ip->nlink < 1)
    800057f4:	05291783          	lh	a5,82(s2)
    800057f8:	08f05463          	blez	a5,80005880 <sys_unlink+0x126>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800057fc:	04c91703          	lh	a4,76(s2)
    80005800:	4785                	li	a5,1
    80005802:	08f70763          	beq	a4,a5,80005890 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005806:	4641                	li	a2,16
    80005808:	4581                	li	a1,0
    8000580a:	fc040513          	addi	a0,s0,-64
    8000580e:	ffffb097          	auipc	ra,0xffffb
    80005812:	68a080e7          	jalr	1674(ra) # 80000e98 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005816:	4741                	li	a4,16
    80005818:	f2c42683          	lw	a3,-212(s0)
    8000581c:	fc040613          	addi	a2,s0,-64
    80005820:	4581                	li	a1,0
    80005822:	8526                	mv	a0,s1
    80005824:	ffffe097          	auipc	ra,0xffffe
    80005828:	3ee080e7          	jalr	1006(ra) # 80003c12 <writei>
    8000582c:	47c1                	li	a5,16
    8000582e:	0af51763          	bne	a0,a5,800058dc <sys_unlink+0x182>
  if(ip->type == T_DIR){
    80005832:	04c91703          	lh	a4,76(s2)
    80005836:	4785                	li	a5,1
    80005838:	0af70a63          	beq	a4,a5,800058ec <sys_unlink+0x192>
  iunlockput(dp);
    8000583c:	8526                	mv	a0,s1
    8000583e:	ffffe097          	auipc	ra,0xffffe
    80005842:	28e080e7          	jalr	654(ra) # 80003acc <iunlockput>
  ip->nlink--;
    80005846:	05295783          	lhu	a5,82(s2)
    8000584a:	37fd                	addiw	a5,a5,-1
    8000584c:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80005850:	854a                	mv	a0,s2
    80005852:	ffffe097          	auipc	ra,0xffffe
    80005856:	f72080e7          	jalr	-142(ra) # 800037c4 <iupdate>
  iunlockput(ip);
    8000585a:	854a                	mv	a0,s2
    8000585c:	ffffe097          	auipc	ra,0xffffe
    80005860:	270080e7          	jalr	624(ra) # 80003acc <iunlockput>
  end_op(ROOTDEV);
    80005864:	4501                	li	a0,0
    80005866:	fffff097          	auipc	ra,0xfffff
    8000586a:	ab8080e7          	jalr	-1352(ra) # 8000431e <end_op>
  return 0;
    8000586e:	4501                	li	a0,0
    80005870:	a85d                	j	80005926 <sys_unlink+0x1cc>
    end_op(ROOTDEV);
    80005872:	4501                	li	a0,0
    80005874:	fffff097          	auipc	ra,0xfffff
    80005878:	aaa080e7          	jalr	-1366(ra) # 8000431e <end_op>
    return -1;
    8000587c:	557d                	li	a0,-1
    8000587e:	a065                	j	80005926 <sys_unlink+0x1cc>
    panic("unlink: nlink < 1");
    80005880:	00003517          	auipc	a0,0x3
    80005884:	fd850513          	addi	a0,a0,-40 # 80008858 <userret+0x7c8>
    80005888:	ffffb097          	auipc	ra,0xffffb
    8000588c:	cc0080e7          	jalr	-832(ra) # 80000548 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005890:	05492703          	lw	a4,84(s2)
    80005894:	02000793          	li	a5,32
    80005898:	f6e7f7e3          	bgeu	a5,a4,80005806 <sys_unlink+0xac>
    8000589c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800058a0:	4741                	li	a4,16
    800058a2:	86ce                	mv	a3,s3
    800058a4:	f1840613          	addi	a2,s0,-232
    800058a8:	4581                	li	a1,0
    800058aa:	854a                	mv	a0,s2
    800058ac:	ffffe097          	auipc	ra,0xffffe
    800058b0:	272080e7          	jalr	626(ra) # 80003b1e <readi>
    800058b4:	47c1                	li	a5,16
    800058b6:	00f51b63          	bne	a0,a5,800058cc <sys_unlink+0x172>
    if(de.inum != 0)
    800058ba:	f1845783          	lhu	a5,-232(s0)
    800058be:	e7a1                	bnez	a5,80005906 <sys_unlink+0x1ac>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800058c0:	29c1                	addiw	s3,s3,16
    800058c2:	05492783          	lw	a5,84(s2)
    800058c6:	fcf9ede3          	bltu	s3,a5,800058a0 <sys_unlink+0x146>
    800058ca:	bf35                	j	80005806 <sys_unlink+0xac>
      panic("isdirempty: readi");
    800058cc:	00003517          	auipc	a0,0x3
    800058d0:	fa450513          	addi	a0,a0,-92 # 80008870 <userret+0x7e0>
    800058d4:	ffffb097          	auipc	ra,0xffffb
    800058d8:	c74080e7          	jalr	-908(ra) # 80000548 <panic>
    panic("unlink: writei");
    800058dc:	00003517          	auipc	a0,0x3
    800058e0:	fac50513          	addi	a0,a0,-84 # 80008888 <userret+0x7f8>
    800058e4:	ffffb097          	auipc	ra,0xffffb
    800058e8:	c64080e7          	jalr	-924(ra) # 80000548 <panic>
    dp->nlink--;
    800058ec:	0524d783          	lhu	a5,82(s1)
    800058f0:	37fd                	addiw	a5,a5,-1
    800058f2:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    800058f6:	8526                	mv	a0,s1
    800058f8:	ffffe097          	auipc	ra,0xffffe
    800058fc:	ecc080e7          	jalr	-308(ra) # 800037c4 <iupdate>
    80005900:	bf35                	j	8000583c <sys_unlink+0xe2>
    return -1;
    80005902:	557d                	li	a0,-1
    80005904:	a00d                	j	80005926 <sys_unlink+0x1cc>
    iunlockput(ip);
    80005906:	854a                	mv	a0,s2
    80005908:	ffffe097          	auipc	ra,0xffffe
    8000590c:	1c4080e7          	jalr	452(ra) # 80003acc <iunlockput>
  iunlockput(dp);
    80005910:	8526                	mv	a0,s1
    80005912:	ffffe097          	auipc	ra,0xffffe
    80005916:	1ba080e7          	jalr	442(ra) # 80003acc <iunlockput>
  end_op(ROOTDEV);
    8000591a:	4501                	li	a0,0
    8000591c:	fffff097          	auipc	ra,0xfffff
    80005920:	a02080e7          	jalr	-1534(ra) # 8000431e <end_op>
  return -1;
    80005924:	557d                	li	a0,-1
}
    80005926:	70ae                	ld	ra,232(sp)
    80005928:	740e                	ld	s0,224(sp)
    8000592a:	64ee                	ld	s1,216(sp)
    8000592c:	694e                	ld	s2,208(sp)
    8000592e:	69ae                	ld	s3,200(sp)
    80005930:	616d                	addi	sp,sp,240
    80005932:	8082                	ret

0000000080005934 <sys_open>:

uint64
sys_open(void)
{
    80005934:	7131                	addi	sp,sp,-192
    80005936:	fd06                	sd	ra,184(sp)
    80005938:	f922                	sd	s0,176(sp)
    8000593a:	f526                	sd	s1,168(sp)
    8000593c:	f14a                	sd	s2,160(sp)
    8000593e:	ed4e                	sd	s3,152(sp)
    80005940:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005942:	08000613          	li	a2,128
    80005946:	f5040593          	addi	a1,s0,-176
    8000594a:	4501                	li	a0,0
    8000594c:	ffffd097          	auipc	ra,0xffffd
    80005950:	2f4080e7          	jalr	756(ra) # 80002c40 <argstr>
    return -1;
    80005954:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005956:	0a054963          	bltz	a0,80005a08 <sys_open+0xd4>
    8000595a:	f4c40593          	addi	a1,s0,-180
    8000595e:	4505                	li	a0,1
    80005960:	ffffd097          	auipc	ra,0xffffd
    80005964:	29c080e7          	jalr	668(ra) # 80002bfc <argint>
    80005968:	0a054063          	bltz	a0,80005a08 <sys_open+0xd4>

  begin_op(ROOTDEV);
    8000596c:	4501                	li	a0,0
    8000596e:	fffff097          	auipc	ra,0xfffff
    80005972:	906080e7          	jalr	-1786(ra) # 80004274 <begin_op>

  if(omode & O_CREATE){
    80005976:	f4c42783          	lw	a5,-180(s0)
    8000597a:	2007f793          	andi	a5,a5,512
    8000597e:	c3dd                	beqz	a5,80005a24 <sys_open+0xf0>
    ip = create(path, T_FILE, 0, 0);
    80005980:	4681                	li	a3,0
    80005982:	4601                	li	a2,0
    80005984:	4589                	li	a1,2
    80005986:	f5040513          	addi	a0,s0,-176
    8000598a:	00000097          	auipc	ra,0x0
    8000598e:	960080e7          	jalr	-1696(ra) # 800052ea <create>
    80005992:	892a                	mv	s2,a0
    if(ip == 0){
    80005994:	c151                	beqz	a0,80005a18 <sys_open+0xe4>
      end_op(ROOTDEV);
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005996:	04c91703          	lh	a4,76(s2)
    8000599a:	478d                	li	a5,3
    8000599c:	00f71763          	bne	a4,a5,800059aa <sys_open+0x76>
    800059a0:	04e95703          	lhu	a4,78(s2)
    800059a4:	47a5                	li	a5,9
    800059a6:	0ce7e663          	bltu	a5,a4,80005a72 <sys_open+0x13e>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800059aa:	fffff097          	auipc	ra,0xfffff
    800059ae:	da8080e7          	jalr	-600(ra) # 80004752 <filealloc>
    800059b2:	89aa                	mv	s3,a0
    800059b4:	c97d                	beqz	a0,80005aaa <sys_open+0x176>
    800059b6:	00000097          	auipc	ra,0x0
    800059ba:	8f2080e7          	jalr	-1806(ra) # 800052a8 <fdalloc>
    800059be:	84aa                	mv	s1,a0
    800059c0:	0e054063          	bltz	a0,80005aa0 <sys_open+0x16c>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if(ip->type == T_DEVICE){
    800059c4:	04c91703          	lh	a4,76(s2)
    800059c8:	478d                	li	a5,3
    800059ca:	0cf70063          	beq	a4,a5,80005a8a <sys_open+0x156>
    f->type = FD_DEVICE;
    f->major = ip->major;
    f->minor = ip->minor;
  } else {
    f->type = FD_INODE;
    800059ce:	4789                	li	a5,2
    800059d0:	00f9a023          	sw	a5,0(s3)
  }
  f->ip = ip;
    800059d4:	0129bc23          	sd	s2,24(s3)
  f->off = 0;
    800059d8:	0209a023          	sw	zero,32(s3)
  f->readable = !(omode & O_WRONLY);
    800059dc:	f4c42783          	lw	a5,-180(s0)
    800059e0:	0017c713          	xori	a4,a5,1
    800059e4:	8b05                	andi	a4,a4,1
    800059e6:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800059ea:	8b8d                	andi	a5,a5,3
    800059ec:	00f037b3          	snez	a5,a5
    800059f0:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
    800059f4:	854a                	mv	a0,s2
    800059f6:	ffffe097          	auipc	ra,0xffffe
    800059fa:	f5a080e7          	jalr	-166(ra) # 80003950 <iunlock>
  end_op(ROOTDEV);
    800059fe:	4501                	li	a0,0
    80005a00:	fffff097          	auipc	ra,0xfffff
    80005a04:	91e080e7          	jalr	-1762(ra) # 8000431e <end_op>

  return fd;
}
    80005a08:	8526                	mv	a0,s1
    80005a0a:	70ea                	ld	ra,184(sp)
    80005a0c:	744a                	ld	s0,176(sp)
    80005a0e:	74aa                	ld	s1,168(sp)
    80005a10:	790a                	ld	s2,160(sp)
    80005a12:	69ea                	ld	s3,152(sp)
    80005a14:	6129                	addi	sp,sp,192
    80005a16:	8082                	ret
      end_op(ROOTDEV);
    80005a18:	4501                	li	a0,0
    80005a1a:	fffff097          	auipc	ra,0xfffff
    80005a1e:	904080e7          	jalr	-1788(ra) # 8000431e <end_op>
      return -1;
    80005a22:	b7dd                	j	80005a08 <sys_open+0xd4>
    if((ip = namei(path)) == 0){
    80005a24:	f5040513          	addi	a0,s0,-176
    80005a28:	ffffe097          	auipc	ra,0xffffe
    80005a2c:	5f0080e7          	jalr	1520(ra) # 80004018 <namei>
    80005a30:	892a                	mv	s2,a0
    80005a32:	c90d                	beqz	a0,80005a64 <sys_open+0x130>
    ilock(ip);
    80005a34:	ffffe097          	auipc	ra,0xffffe
    80005a38:	e5a080e7          	jalr	-422(ra) # 8000388e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005a3c:	04c91703          	lh	a4,76(s2)
    80005a40:	4785                	li	a5,1
    80005a42:	f4f71ae3          	bne	a4,a5,80005996 <sys_open+0x62>
    80005a46:	f4c42783          	lw	a5,-180(s0)
    80005a4a:	d3a5                	beqz	a5,800059aa <sys_open+0x76>
      iunlockput(ip);
    80005a4c:	854a                	mv	a0,s2
    80005a4e:	ffffe097          	auipc	ra,0xffffe
    80005a52:	07e080e7          	jalr	126(ra) # 80003acc <iunlockput>
      end_op(ROOTDEV);
    80005a56:	4501                	li	a0,0
    80005a58:	fffff097          	auipc	ra,0xfffff
    80005a5c:	8c6080e7          	jalr	-1850(ra) # 8000431e <end_op>
      return -1;
    80005a60:	54fd                	li	s1,-1
    80005a62:	b75d                	j	80005a08 <sys_open+0xd4>
      end_op(ROOTDEV);
    80005a64:	4501                	li	a0,0
    80005a66:	fffff097          	auipc	ra,0xfffff
    80005a6a:	8b8080e7          	jalr	-1864(ra) # 8000431e <end_op>
      return -1;
    80005a6e:	54fd                	li	s1,-1
    80005a70:	bf61                	j	80005a08 <sys_open+0xd4>
    iunlockput(ip);
    80005a72:	854a                	mv	a0,s2
    80005a74:	ffffe097          	auipc	ra,0xffffe
    80005a78:	058080e7          	jalr	88(ra) # 80003acc <iunlockput>
    end_op(ROOTDEV);
    80005a7c:	4501                	li	a0,0
    80005a7e:	fffff097          	auipc	ra,0xfffff
    80005a82:	8a0080e7          	jalr	-1888(ra) # 8000431e <end_op>
    return -1;
    80005a86:	54fd                	li	s1,-1
    80005a88:	b741                	j	80005a08 <sys_open+0xd4>
    f->type = FD_DEVICE;
    80005a8a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005a8e:	04e91783          	lh	a5,78(s2)
    80005a92:	02f99223          	sh	a5,36(s3)
    f->minor = ip->minor;
    80005a96:	05091783          	lh	a5,80(s2)
    80005a9a:	02f99323          	sh	a5,38(s3)
    80005a9e:	bf1d                	j	800059d4 <sys_open+0xa0>
      fileclose(f);
    80005aa0:	854e                	mv	a0,s3
    80005aa2:	fffff097          	auipc	ra,0xfffff
    80005aa6:	d6c080e7          	jalr	-660(ra) # 8000480e <fileclose>
    iunlockput(ip);
    80005aaa:	854a                	mv	a0,s2
    80005aac:	ffffe097          	auipc	ra,0xffffe
    80005ab0:	020080e7          	jalr	32(ra) # 80003acc <iunlockput>
    end_op(ROOTDEV);
    80005ab4:	4501                	li	a0,0
    80005ab6:	fffff097          	auipc	ra,0xfffff
    80005aba:	868080e7          	jalr	-1944(ra) # 8000431e <end_op>
    return -1;
    80005abe:	54fd                	li	s1,-1
    80005ac0:	b7a1                	j	80005a08 <sys_open+0xd4>

0000000080005ac2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005ac2:	7175                	addi	sp,sp,-144
    80005ac4:	e506                	sd	ra,136(sp)
    80005ac6:	e122                	sd	s0,128(sp)
    80005ac8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op(ROOTDEV);
    80005aca:	4501                	li	a0,0
    80005acc:	ffffe097          	auipc	ra,0xffffe
    80005ad0:	7a8080e7          	jalr	1960(ra) # 80004274 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005ad4:	08000613          	li	a2,128
    80005ad8:	f7040593          	addi	a1,s0,-144
    80005adc:	4501                	li	a0,0
    80005ade:	ffffd097          	auipc	ra,0xffffd
    80005ae2:	162080e7          	jalr	354(ra) # 80002c40 <argstr>
    80005ae6:	02054a63          	bltz	a0,80005b1a <sys_mkdir+0x58>
    80005aea:	4681                	li	a3,0
    80005aec:	4601                	li	a2,0
    80005aee:	4585                	li	a1,1
    80005af0:	f7040513          	addi	a0,s0,-144
    80005af4:	fffff097          	auipc	ra,0xfffff
    80005af8:	7f6080e7          	jalr	2038(ra) # 800052ea <create>
    80005afc:	cd19                	beqz	a0,80005b1a <sys_mkdir+0x58>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    80005afe:	ffffe097          	auipc	ra,0xffffe
    80005b02:	fce080e7          	jalr	-50(ra) # 80003acc <iunlockput>
  end_op(ROOTDEV);
    80005b06:	4501                	li	a0,0
    80005b08:	fffff097          	auipc	ra,0xfffff
    80005b0c:	816080e7          	jalr	-2026(ra) # 8000431e <end_op>
  return 0;
    80005b10:	4501                	li	a0,0
}
    80005b12:	60aa                	ld	ra,136(sp)
    80005b14:	640a                	ld	s0,128(sp)
    80005b16:	6149                	addi	sp,sp,144
    80005b18:	8082                	ret
    end_op(ROOTDEV);
    80005b1a:	4501                	li	a0,0
    80005b1c:	fffff097          	auipc	ra,0xfffff
    80005b20:	802080e7          	jalr	-2046(ra) # 8000431e <end_op>
    return -1;
    80005b24:	557d                	li	a0,-1
    80005b26:	b7f5                	j	80005b12 <sys_mkdir+0x50>

0000000080005b28 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005b28:	7135                	addi	sp,sp,-160
    80005b2a:	ed06                	sd	ra,152(sp)
    80005b2c:	e922                	sd	s0,144(sp)
    80005b2e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op(ROOTDEV);
    80005b30:	4501                	li	a0,0
    80005b32:	ffffe097          	auipc	ra,0xffffe
    80005b36:	742080e7          	jalr	1858(ra) # 80004274 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b3a:	08000613          	li	a2,128
    80005b3e:	f7040593          	addi	a1,s0,-144
    80005b42:	4501                	li	a0,0
    80005b44:	ffffd097          	auipc	ra,0xffffd
    80005b48:	0fc080e7          	jalr	252(ra) # 80002c40 <argstr>
    80005b4c:	04054b63          	bltz	a0,80005ba2 <sys_mknod+0x7a>
     argint(1, &major) < 0 ||
    80005b50:	f6c40593          	addi	a1,s0,-148
    80005b54:	4505                	li	a0,1
    80005b56:	ffffd097          	auipc	ra,0xffffd
    80005b5a:	0a6080e7          	jalr	166(ra) # 80002bfc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b5e:	04054263          	bltz	a0,80005ba2 <sys_mknod+0x7a>
     argint(2, &minor) < 0 ||
    80005b62:	f6840593          	addi	a1,s0,-152
    80005b66:	4509                	li	a0,2
    80005b68:	ffffd097          	auipc	ra,0xffffd
    80005b6c:	094080e7          	jalr	148(ra) # 80002bfc <argint>
     argint(1, &major) < 0 ||
    80005b70:	02054963          	bltz	a0,80005ba2 <sys_mknod+0x7a>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005b74:	f6841683          	lh	a3,-152(s0)
    80005b78:	f6c41603          	lh	a2,-148(s0)
    80005b7c:	458d                	li	a1,3
    80005b7e:	f7040513          	addi	a0,s0,-144
    80005b82:	fffff097          	auipc	ra,0xfffff
    80005b86:	768080e7          	jalr	1896(ra) # 800052ea <create>
     argint(2, &minor) < 0 ||
    80005b8a:	cd01                	beqz	a0,80005ba2 <sys_mknod+0x7a>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    80005b8c:	ffffe097          	auipc	ra,0xffffe
    80005b90:	f40080e7          	jalr	-192(ra) # 80003acc <iunlockput>
  end_op(ROOTDEV);
    80005b94:	4501                	li	a0,0
    80005b96:	ffffe097          	auipc	ra,0xffffe
    80005b9a:	788080e7          	jalr	1928(ra) # 8000431e <end_op>
  return 0;
    80005b9e:	4501                	li	a0,0
    80005ba0:	a039                	j	80005bae <sys_mknod+0x86>
    end_op(ROOTDEV);
    80005ba2:	4501                	li	a0,0
    80005ba4:	ffffe097          	auipc	ra,0xffffe
    80005ba8:	77a080e7          	jalr	1914(ra) # 8000431e <end_op>
    return -1;
    80005bac:	557d                	li	a0,-1
}
    80005bae:	60ea                	ld	ra,152(sp)
    80005bb0:	644a                	ld	s0,144(sp)
    80005bb2:	610d                	addi	sp,sp,160
    80005bb4:	8082                	ret

0000000080005bb6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005bb6:	7135                	addi	sp,sp,-160
    80005bb8:	ed06                	sd	ra,152(sp)
    80005bba:	e922                	sd	s0,144(sp)
    80005bbc:	e526                	sd	s1,136(sp)
    80005bbe:	e14a                	sd	s2,128(sp)
    80005bc0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005bc2:	ffffc097          	auipc	ra,0xffffc
    80005bc6:	fc0080e7          	jalr	-64(ra) # 80001b82 <myproc>
    80005bca:	892a                	mv	s2,a0
  
  begin_op(ROOTDEV);
    80005bcc:	4501                	li	a0,0
    80005bce:	ffffe097          	auipc	ra,0xffffe
    80005bd2:	6a6080e7          	jalr	1702(ra) # 80004274 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005bd6:	08000613          	li	a2,128
    80005bda:	f6040593          	addi	a1,s0,-160
    80005bde:	4501                	li	a0,0
    80005be0:	ffffd097          	auipc	ra,0xffffd
    80005be4:	060080e7          	jalr	96(ra) # 80002c40 <argstr>
    80005be8:	04054c63          	bltz	a0,80005c40 <sys_chdir+0x8a>
    80005bec:	f6040513          	addi	a0,s0,-160
    80005bf0:	ffffe097          	auipc	ra,0xffffe
    80005bf4:	428080e7          	jalr	1064(ra) # 80004018 <namei>
    80005bf8:	84aa                	mv	s1,a0
    80005bfa:	c139                	beqz	a0,80005c40 <sys_chdir+0x8a>
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    80005bfc:	ffffe097          	auipc	ra,0xffffe
    80005c00:	c92080e7          	jalr	-878(ra) # 8000388e <ilock>
  if(ip->type != T_DIR){
    80005c04:	04c49703          	lh	a4,76(s1)
    80005c08:	4785                	li	a5,1
    80005c0a:	04f71263          	bne	a4,a5,80005c4e <sys_chdir+0x98>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }
  iunlock(ip);
    80005c0e:	8526                	mv	a0,s1
    80005c10:	ffffe097          	auipc	ra,0xffffe
    80005c14:	d40080e7          	jalr	-704(ra) # 80003950 <iunlock>
  iput(p->cwd);
    80005c18:	15893503          	ld	a0,344(s2)
    80005c1c:	ffffe097          	auipc	ra,0xffffe
    80005c20:	d80080e7          	jalr	-640(ra) # 8000399c <iput>
  end_op(ROOTDEV);
    80005c24:	4501                	li	a0,0
    80005c26:	ffffe097          	auipc	ra,0xffffe
    80005c2a:	6f8080e7          	jalr	1784(ra) # 8000431e <end_op>
  p->cwd = ip;
    80005c2e:	14993c23          	sd	s1,344(s2)
  return 0;
    80005c32:	4501                	li	a0,0
}
    80005c34:	60ea                	ld	ra,152(sp)
    80005c36:	644a                	ld	s0,144(sp)
    80005c38:	64aa                	ld	s1,136(sp)
    80005c3a:	690a                	ld	s2,128(sp)
    80005c3c:	610d                	addi	sp,sp,160
    80005c3e:	8082                	ret
    end_op(ROOTDEV);
    80005c40:	4501                	li	a0,0
    80005c42:	ffffe097          	auipc	ra,0xffffe
    80005c46:	6dc080e7          	jalr	1756(ra) # 8000431e <end_op>
    return -1;
    80005c4a:	557d                	li	a0,-1
    80005c4c:	b7e5                	j	80005c34 <sys_chdir+0x7e>
    iunlockput(ip);
    80005c4e:	8526                	mv	a0,s1
    80005c50:	ffffe097          	auipc	ra,0xffffe
    80005c54:	e7c080e7          	jalr	-388(ra) # 80003acc <iunlockput>
    end_op(ROOTDEV);
    80005c58:	4501                	li	a0,0
    80005c5a:	ffffe097          	auipc	ra,0xffffe
    80005c5e:	6c4080e7          	jalr	1732(ra) # 8000431e <end_op>
    return -1;
    80005c62:	557d                	li	a0,-1
    80005c64:	bfc1                	j	80005c34 <sys_chdir+0x7e>

0000000080005c66 <sys_exec>:

uint64
sys_exec(void)
{
    80005c66:	7145                	addi	sp,sp,-464
    80005c68:	e786                	sd	ra,456(sp)
    80005c6a:	e3a2                	sd	s0,448(sp)
    80005c6c:	ff26                	sd	s1,440(sp)
    80005c6e:	fb4a                	sd	s2,432(sp)
    80005c70:	f74e                	sd	s3,424(sp)
    80005c72:	f352                	sd	s4,416(sp)
    80005c74:	ef56                	sd	s5,408(sp)
    80005c76:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005c78:	08000613          	li	a2,128
    80005c7c:	f4040593          	addi	a1,s0,-192
    80005c80:	4501                	li	a0,0
    80005c82:	ffffd097          	auipc	ra,0xffffd
    80005c86:	fbe080e7          	jalr	-66(ra) # 80002c40 <argstr>
    80005c8a:	0e054663          	bltz	a0,80005d76 <sys_exec+0x110>
    80005c8e:	e3840593          	addi	a1,s0,-456
    80005c92:	4505                	li	a0,1
    80005c94:	ffffd097          	auipc	ra,0xffffd
    80005c98:	f8a080e7          	jalr	-118(ra) # 80002c1e <argaddr>
    80005c9c:	0e054763          	bltz	a0,80005d8a <sys_exec+0x124>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    80005ca0:	10000613          	li	a2,256
    80005ca4:	4581                	li	a1,0
    80005ca6:	e4040513          	addi	a0,s0,-448
    80005caa:	ffffb097          	auipc	ra,0xffffb
    80005cae:	1ee080e7          	jalr	494(ra) # 80000e98 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005cb2:	e4040913          	addi	s2,s0,-448
  memset(argv, 0, sizeof(argv));
    80005cb6:	89ca                	mv	s3,s2
    80005cb8:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    80005cba:	02000a13          	li	s4,32
    80005cbe:	00048a9b          	sext.w	s5,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005cc2:	00349793          	slli	a5,s1,0x3
    80005cc6:	e3040593          	addi	a1,s0,-464
    80005cca:	e3843503          	ld	a0,-456(s0)
    80005cce:	953e                	add	a0,a0,a5
    80005cd0:	ffffd097          	auipc	ra,0xffffd
    80005cd4:	e92080e7          	jalr	-366(ra) # 80002b62 <fetchaddr>
    80005cd8:	02054a63          	bltz	a0,80005d0c <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005cdc:	e3043783          	ld	a5,-464(s0)
    80005ce0:	c7a1                	beqz	a5,80005d28 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005ce2:	ffffb097          	auipc	ra,0xffffb
    80005ce6:	d62080e7          	jalr	-670(ra) # 80000a44 <kalloc>
    80005cea:	85aa                	mv	a1,a0
    80005cec:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005cf0:	c92d                	beqz	a0,80005d62 <sys_exec+0xfc>
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
    80005cf2:	6605                	lui	a2,0x1
    80005cf4:	e3043503          	ld	a0,-464(s0)
    80005cf8:	ffffd097          	auipc	ra,0xffffd
    80005cfc:	ebc080e7          	jalr	-324(ra) # 80002bb4 <fetchstr>
    80005d00:	00054663          	bltz	a0,80005d0c <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005d04:	0485                	addi	s1,s1,1
    80005d06:	09a1                	addi	s3,s3,8
    80005d08:	fb449be3          	bne	s1,s4,80005cbe <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d0c:	10090493          	addi	s1,s2,256
    80005d10:	00093503          	ld	a0,0(s2)
    80005d14:	cd39                	beqz	a0,80005d72 <sys_exec+0x10c>
    kfree(argv[i]);
    80005d16:	ffffb097          	auipc	ra,0xffffb
    80005d1a:	b4e080e7          	jalr	-1202(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d1e:	0921                	addi	s2,s2,8
    80005d20:	fe9918e3          	bne	s2,s1,80005d10 <sys_exec+0xaa>
  return -1;
    80005d24:	557d                	li	a0,-1
    80005d26:	a889                	j	80005d78 <sys_exec+0x112>
      argv[i] = 0;
    80005d28:	0a8e                	slli	s5,s5,0x3
    80005d2a:	fc040793          	addi	a5,s0,-64
    80005d2e:	9abe                	add	s5,s5,a5
    80005d30:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005d34:	e4040593          	addi	a1,s0,-448
    80005d38:	f4040513          	addi	a0,s0,-192
    80005d3c:	fffff097          	auipc	ra,0xfffff
    80005d40:	178080e7          	jalr	376(ra) # 80004eb4 <exec>
    80005d44:	84aa                	mv	s1,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d46:	10090993          	addi	s3,s2,256
    80005d4a:	00093503          	ld	a0,0(s2)
    80005d4e:	c901                	beqz	a0,80005d5e <sys_exec+0xf8>
    kfree(argv[i]);
    80005d50:	ffffb097          	auipc	ra,0xffffb
    80005d54:	b14080e7          	jalr	-1260(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d58:	0921                	addi	s2,s2,8
    80005d5a:	ff3918e3          	bne	s2,s3,80005d4a <sys_exec+0xe4>
  return ret;
    80005d5e:	8526                	mv	a0,s1
    80005d60:	a821                	j	80005d78 <sys_exec+0x112>
      panic("sys_exec kalloc");
    80005d62:	00003517          	auipc	a0,0x3
    80005d66:	b3650513          	addi	a0,a0,-1226 # 80008898 <userret+0x808>
    80005d6a:	ffffa097          	auipc	ra,0xffffa
    80005d6e:	7de080e7          	jalr	2014(ra) # 80000548 <panic>
  return -1;
    80005d72:	557d                	li	a0,-1
    80005d74:	a011                	j	80005d78 <sys_exec+0x112>
    return -1;
    80005d76:	557d                	li	a0,-1
}
    80005d78:	60be                	ld	ra,456(sp)
    80005d7a:	641e                	ld	s0,448(sp)
    80005d7c:	74fa                	ld	s1,440(sp)
    80005d7e:	795a                	ld	s2,432(sp)
    80005d80:	79ba                	ld	s3,424(sp)
    80005d82:	7a1a                	ld	s4,416(sp)
    80005d84:	6afa                	ld	s5,408(sp)
    80005d86:	6179                	addi	sp,sp,464
    80005d88:	8082                	ret
    return -1;
    80005d8a:	557d                	li	a0,-1
    80005d8c:	b7f5                	j	80005d78 <sys_exec+0x112>

0000000080005d8e <sys_pipe>:

uint64
sys_pipe(void)
{
    80005d8e:	7139                	addi	sp,sp,-64
    80005d90:	fc06                	sd	ra,56(sp)
    80005d92:	f822                	sd	s0,48(sp)
    80005d94:	f426                	sd	s1,40(sp)
    80005d96:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005d98:	ffffc097          	auipc	ra,0xffffc
    80005d9c:	dea080e7          	jalr	-534(ra) # 80001b82 <myproc>
    80005da0:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005da2:	fd840593          	addi	a1,s0,-40
    80005da6:	4501                	li	a0,0
    80005da8:	ffffd097          	auipc	ra,0xffffd
    80005dac:	e76080e7          	jalr	-394(ra) # 80002c1e <argaddr>
    return -1;
    80005db0:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005db2:	0e054063          	bltz	a0,80005e92 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005db6:	fc840593          	addi	a1,s0,-56
    80005dba:	fd040513          	addi	a0,s0,-48
    80005dbe:	fffff097          	auipc	ra,0xfffff
    80005dc2:	db4080e7          	jalr	-588(ra) # 80004b72 <pipealloc>
    return -1;
    80005dc6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005dc8:	0c054563          	bltz	a0,80005e92 <sys_pipe+0x104>
  fd0 = -1;
    80005dcc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005dd0:	fd043503          	ld	a0,-48(s0)
    80005dd4:	fffff097          	auipc	ra,0xfffff
    80005dd8:	4d4080e7          	jalr	1236(ra) # 800052a8 <fdalloc>
    80005ddc:	fca42223          	sw	a0,-60(s0)
    80005de0:	08054c63          	bltz	a0,80005e78 <sys_pipe+0xea>
    80005de4:	fc843503          	ld	a0,-56(s0)
    80005de8:	fffff097          	auipc	ra,0xfffff
    80005dec:	4c0080e7          	jalr	1216(ra) # 800052a8 <fdalloc>
    80005df0:	fca42023          	sw	a0,-64(s0)
    80005df4:	06054863          	bltz	a0,80005e64 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005df8:	4691                	li	a3,4
    80005dfa:	fc440613          	addi	a2,s0,-60
    80005dfe:	fd843583          	ld	a1,-40(s0)
    80005e02:	6ca8                	ld	a0,88(s1)
    80005e04:	ffffc097          	auipc	ra,0xffffc
    80005e08:	a70080e7          	jalr	-1424(ra) # 80001874 <copyout>
    80005e0c:	02054063          	bltz	a0,80005e2c <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005e10:	4691                	li	a3,4
    80005e12:	fc040613          	addi	a2,s0,-64
    80005e16:	fd843583          	ld	a1,-40(s0)
    80005e1a:	0591                	addi	a1,a1,4
    80005e1c:	6ca8                	ld	a0,88(s1)
    80005e1e:	ffffc097          	auipc	ra,0xffffc
    80005e22:	a56080e7          	jalr	-1450(ra) # 80001874 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005e26:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e28:	06055563          	bgez	a0,80005e92 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005e2c:	fc442783          	lw	a5,-60(s0)
    80005e30:	07e9                	addi	a5,a5,26
    80005e32:	078e                	slli	a5,a5,0x3
    80005e34:	97a6                	add	a5,a5,s1
    80005e36:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005e3a:	fc042503          	lw	a0,-64(s0)
    80005e3e:	0569                	addi	a0,a0,26
    80005e40:	050e                	slli	a0,a0,0x3
    80005e42:	9526                	add	a0,a0,s1
    80005e44:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005e48:	fd043503          	ld	a0,-48(s0)
    80005e4c:	fffff097          	auipc	ra,0xfffff
    80005e50:	9c2080e7          	jalr	-1598(ra) # 8000480e <fileclose>
    fileclose(wf);
    80005e54:	fc843503          	ld	a0,-56(s0)
    80005e58:	fffff097          	auipc	ra,0xfffff
    80005e5c:	9b6080e7          	jalr	-1610(ra) # 8000480e <fileclose>
    return -1;
    80005e60:	57fd                	li	a5,-1
    80005e62:	a805                	j	80005e92 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005e64:	fc442783          	lw	a5,-60(s0)
    80005e68:	0007c863          	bltz	a5,80005e78 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005e6c:	01a78513          	addi	a0,a5,26
    80005e70:	050e                	slli	a0,a0,0x3
    80005e72:	9526                	add	a0,a0,s1
    80005e74:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005e78:	fd043503          	ld	a0,-48(s0)
    80005e7c:	fffff097          	auipc	ra,0xfffff
    80005e80:	992080e7          	jalr	-1646(ra) # 8000480e <fileclose>
    fileclose(wf);
    80005e84:	fc843503          	ld	a0,-56(s0)
    80005e88:	fffff097          	auipc	ra,0xfffff
    80005e8c:	986080e7          	jalr	-1658(ra) # 8000480e <fileclose>
    return -1;
    80005e90:	57fd                	li	a5,-1
}
    80005e92:	853e                	mv	a0,a5
    80005e94:	70e2                	ld	ra,56(sp)
    80005e96:	7442                	ld	s0,48(sp)
    80005e98:	74a2                	ld	s1,40(sp)
    80005e9a:	6121                	addi	sp,sp,64
    80005e9c:	8082                	ret
	...

0000000080005ea0 <kernelvec>:
    80005ea0:	7111                	addi	sp,sp,-256
    80005ea2:	e006                	sd	ra,0(sp)
    80005ea4:	e40a                	sd	sp,8(sp)
    80005ea6:	e80e                	sd	gp,16(sp)
    80005ea8:	ec12                	sd	tp,24(sp)
    80005eaa:	f016                	sd	t0,32(sp)
    80005eac:	f41a                	sd	t1,40(sp)
    80005eae:	f81e                	sd	t2,48(sp)
    80005eb0:	fc22                	sd	s0,56(sp)
    80005eb2:	e0a6                	sd	s1,64(sp)
    80005eb4:	e4aa                	sd	a0,72(sp)
    80005eb6:	e8ae                	sd	a1,80(sp)
    80005eb8:	ecb2                	sd	a2,88(sp)
    80005eba:	f0b6                	sd	a3,96(sp)
    80005ebc:	f4ba                	sd	a4,104(sp)
    80005ebe:	f8be                	sd	a5,112(sp)
    80005ec0:	fcc2                	sd	a6,120(sp)
    80005ec2:	e146                	sd	a7,128(sp)
    80005ec4:	e54a                	sd	s2,136(sp)
    80005ec6:	e94e                	sd	s3,144(sp)
    80005ec8:	ed52                	sd	s4,152(sp)
    80005eca:	f156                	sd	s5,160(sp)
    80005ecc:	f55a                	sd	s6,168(sp)
    80005ece:	f95e                	sd	s7,176(sp)
    80005ed0:	fd62                	sd	s8,184(sp)
    80005ed2:	e1e6                	sd	s9,192(sp)
    80005ed4:	e5ea                	sd	s10,200(sp)
    80005ed6:	e9ee                	sd	s11,208(sp)
    80005ed8:	edf2                	sd	t3,216(sp)
    80005eda:	f1f6                	sd	t4,224(sp)
    80005edc:	f5fa                	sd	t5,232(sp)
    80005ede:	f9fe                	sd	t6,240(sp)
    80005ee0:	b4ffc0ef          	jal	ra,80002a2e <kerneltrap>
    80005ee4:	6082                	ld	ra,0(sp)
    80005ee6:	6122                	ld	sp,8(sp)
    80005ee8:	61c2                	ld	gp,16(sp)
    80005eea:	7282                	ld	t0,32(sp)
    80005eec:	7322                	ld	t1,40(sp)
    80005eee:	73c2                	ld	t2,48(sp)
    80005ef0:	7462                	ld	s0,56(sp)
    80005ef2:	6486                	ld	s1,64(sp)
    80005ef4:	6526                	ld	a0,72(sp)
    80005ef6:	65c6                	ld	a1,80(sp)
    80005ef8:	6666                	ld	a2,88(sp)
    80005efa:	7686                	ld	a3,96(sp)
    80005efc:	7726                	ld	a4,104(sp)
    80005efe:	77c6                	ld	a5,112(sp)
    80005f00:	7866                	ld	a6,120(sp)
    80005f02:	688a                	ld	a7,128(sp)
    80005f04:	692a                	ld	s2,136(sp)
    80005f06:	69ca                	ld	s3,144(sp)
    80005f08:	6a6a                	ld	s4,152(sp)
    80005f0a:	7a8a                	ld	s5,160(sp)
    80005f0c:	7b2a                	ld	s6,168(sp)
    80005f0e:	7bca                	ld	s7,176(sp)
    80005f10:	7c6a                	ld	s8,184(sp)
    80005f12:	6c8e                	ld	s9,192(sp)
    80005f14:	6d2e                	ld	s10,200(sp)
    80005f16:	6dce                	ld	s11,208(sp)
    80005f18:	6e6e                	ld	t3,216(sp)
    80005f1a:	7e8e                	ld	t4,224(sp)
    80005f1c:	7f2e                	ld	t5,232(sp)
    80005f1e:	7fce                	ld	t6,240(sp)
    80005f20:	6111                	addi	sp,sp,256
    80005f22:	10200073          	sret
    80005f26:	00000013          	nop
    80005f2a:	00000013          	nop
    80005f2e:	0001                	nop

0000000080005f30 <timervec>:
    80005f30:	34051573          	csrrw	a0,mscratch,a0
    80005f34:	e10c                	sd	a1,0(a0)
    80005f36:	e510                	sd	a2,8(a0)
    80005f38:	e914                	sd	a3,16(a0)
    80005f3a:	710c                	ld	a1,32(a0)
    80005f3c:	7510                	ld	a2,40(a0)
    80005f3e:	6194                	ld	a3,0(a1)
    80005f40:	96b2                	add	a3,a3,a2
    80005f42:	e194                	sd	a3,0(a1)
    80005f44:	4589                	li	a1,2
    80005f46:	14459073          	csrw	sip,a1
    80005f4a:	6914                	ld	a3,16(a0)
    80005f4c:	6510                	ld	a2,8(a0)
    80005f4e:	610c                	ld	a1,0(a0)
    80005f50:	34051573          	csrrw	a0,mscratch,a0
    80005f54:	30200073          	mret
	...

0000000080005f5a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005f5a:	1141                	addi	sp,sp,-16
    80005f5c:	e422                	sd	s0,8(sp)
    80005f5e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005f60:	0c0007b7          	lui	a5,0xc000
    80005f64:	4705                	li	a4,1
    80005f66:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005f68:	c3d8                	sw	a4,4(a5)
}
    80005f6a:	6422                	ld	s0,8(sp)
    80005f6c:	0141                	addi	sp,sp,16
    80005f6e:	8082                	ret

0000000080005f70 <plicinithart>:

void
plicinithart(void)
{
    80005f70:	1141                	addi	sp,sp,-16
    80005f72:	e406                	sd	ra,8(sp)
    80005f74:	e022                	sd	s0,0(sp)
    80005f76:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005f78:	ffffc097          	auipc	ra,0xffffc
    80005f7c:	bde080e7          	jalr	-1058(ra) # 80001b56 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005f80:	0085171b          	slliw	a4,a0,0x8
    80005f84:	0c0027b7          	lui	a5,0xc002
    80005f88:	97ba                	add	a5,a5,a4
    80005f8a:	40200713          	li	a4,1026
    80005f8e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005f92:	00d5151b          	slliw	a0,a0,0xd
    80005f96:	0c2017b7          	lui	a5,0xc201
    80005f9a:	953e                	add	a0,a0,a5
    80005f9c:	00052023          	sw	zero,0(a0)
}
    80005fa0:	60a2                	ld	ra,8(sp)
    80005fa2:	6402                	ld	s0,0(sp)
    80005fa4:	0141                	addi	sp,sp,16
    80005fa6:	8082                	ret

0000000080005fa8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005fa8:	1141                	addi	sp,sp,-16
    80005faa:	e406                	sd	ra,8(sp)
    80005fac:	e022                	sd	s0,0(sp)
    80005fae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005fb0:	ffffc097          	auipc	ra,0xffffc
    80005fb4:	ba6080e7          	jalr	-1114(ra) # 80001b56 <cpuid>
  //int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005fb8:	00d5179b          	slliw	a5,a0,0xd
    80005fbc:	0c201537          	lui	a0,0xc201
    80005fc0:	953e                	add	a0,a0,a5
  return irq;
}
    80005fc2:	4148                	lw	a0,4(a0)
    80005fc4:	60a2                	ld	ra,8(sp)
    80005fc6:	6402                	ld	s0,0(sp)
    80005fc8:	0141                	addi	sp,sp,16
    80005fca:	8082                	ret

0000000080005fcc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005fcc:	1101                	addi	sp,sp,-32
    80005fce:	ec06                	sd	ra,24(sp)
    80005fd0:	e822                	sd	s0,16(sp)
    80005fd2:	e426                	sd	s1,8(sp)
    80005fd4:	1000                	addi	s0,sp,32
    80005fd6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005fd8:	ffffc097          	auipc	ra,0xffffc
    80005fdc:	b7e080e7          	jalr	-1154(ra) # 80001b56 <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005fe0:	00d5151b          	slliw	a0,a0,0xd
    80005fe4:	0c2017b7          	lui	a5,0xc201
    80005fe8:	97aa                	add	a5,a5,a0
    80005fea:	c3c4                	sw	s1,4(a5)
}
    80005fec:	60e2                	ld	ra,24(sp)
    80005fee:	6442                	ld	s0,16(sp)
    80005ff0:	64a2                	ld	s1,8(sp)
    80005ff2:	6105                	addi	sp,sp,32
    80005ff4:	8082                	ret

0000000080005ff6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int n, int i)
{
    80005ff6:	1141                	addi	sp,sp,-16
    80005ff8:	e406                	sd	ra,8(sp)
    80005ffa:	e022                	sd	s0,0(sp)
    80005ffc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005ffe:	479d                	li	a5,7
    80006000:	06b7c963          	blt	a5,a1,80006072 <free_desc+0x7c>
    panic("virtio_disk_intr 1");
  if(disk[n].free[i])
    80006004:	00151793          	slli	a5,a0,0x1
    80006008:	97aa                	add	a5,a5,a0
    8000600a:	00c79713          	slli	a4,a5,0xc
    8000600e:	00024797          	auipc	a5,0x24
    80006012:	ff278793          	addi	a5,a5,-14 # 8002a000 <disk>
    80006016:	97ba                	add	a5,a5,a4
    80006018:	97ae                	add	a5,a5,a1
    8000601a:	6709                	lui	a4,0x2
    8000601c:	97ba                	add	a5,a5,a4
    8000601e:	0187c783          	lbu	a5,24(a5)
    80006022:	e3a5                	bnez	a5,80006082 <free_desc+0x8c>
    panic("virtio_disk_intr 2");
  disk[n].desc[i].addr = 0;
    80006024:	00024817          	auipc	a6,0x24
    80006028:	fdc80813          	addi	a6,a6,-36 # 8002a000 <disk>
    8000602c:	00151693          	slli	a3,a0,0x1
    80006030:	00a68733          	add	a4,a3,a0
    80006034:	0732                	slli	a4,a4,0xc
    80006036:	00e807b3          	add	a5,a6,a4
    8000603a:	6709                	lui	a4,0x2
    8000603c:	00f70633          	add	a2,a4,a5
    80006040:	6210                	ld	a2,0(a2)
    80006042:	00459893          	slli	a7,a1,0x4
    80006046:	9646                	add	a2,a2,a7
    80006048:	00063023          	sd	zero,0(a2) # 1000 <_entry-0x7ffff000>
  disk[n].free[i] = 1;
    8000604c:	97ae                	add	a5,a5,a1
    8000604e:	97ba                	add	a5,a5,a4
    80006050:	4605                	li	a2,1
    80006052:	00c78c23          	sb	a2,24(a5)
  wakeup(&disk[n].free[0]);
    80006056:	96aa                	add	a3,a3,a0
    80006058:	06b2                	slli	a3,a3,0xc
    8000605a:	0761                	addi	a4,a4,24
    8000605c:	96ba                	add	a3,a3,a4
    8000605e:	00d80533          	add	a0,a6,a3
    80006062:	ffffc097          	auipc	ra,0xffffc
    80006066:	476080e7          	jalr	1142(ra) # 800024d8 <wakeup>
}
    8000606a:	60a2                	ld	ra,8(sp)
    8000606c:	6402                	ld	s0,0(sp)
    8000606e:	0141                	addi	sp,sp,16
    80006070:	8082                	ret
    panic("virtio_disk_intr 1");
    80006072:	00003517          	auipc	a0,0x3
    80006076:	83650513          	addi	a0,a0,-1994 # 800088a8 <userret+0x818>
    8000607a:	ffffa097          	auipc	ra,0xffffa
    8000607e:	4ce080e7          	jalr	1230(ra) # 80000548 <panic>
    panic("virtio_disk_intr 2");
    80006082:	00003517          	auipc	a0,0x3
    80006086:	83e50513          	addi	a0,a0,-1986 # 800088c0 <userret+0x830>
    8000608a:	ffffa097          	auipc	ra,0xffffa
    8000608e:	4be080e7          	jalr	1214(ra) # 80000548 <panic>

0000000080006092 <virtio_disk_init>:
  __sync_synchronize();
    80006092:	0ff0000f          	fence
  if(disk[n].init)
    80006096:	00151793          	slli	a5,a0,0x1
    8000609a:	97aa                	add	a5,a5,a0
    8000609c:	07b2                	slli	a5,a5,0xc
    8000609e:	00024717          	auipc	a4,0x24
    800060a2:	f6270713          	addi	a4,a4,-158 # 8002a000 <disk>
    800060a6:	973e                	add	a4,a4,a5
    800060a8:	6789                	lui	a5,0x2
    800060aa:	97ba                	add	a5,a5,a4
    800060ac:	0a87a783          	lw	a5,168(a5) # 20a8 <_entry-0x7fffdf58>
    800060b0:	c391                	beqz	a5,800060b4 <virtio_disk_init+0x22>
    800060b2:	8082                	ret
{
    800060b4:	7139                	addi	sp,sp,-64
    800060b6:	fc06                	sd	ra,56(sp)
    800060b8:	f822                	sd	s0,48(sp)
    800060ba:	f426                	sd	s1,40(sp)
    800060bc:	f04a                	sd	s2,32(sp)
    800060be:	ec4e                	sd	s3,24(sp)
    800060c0:	e852                	sd	s4,16(sp)
    800060c2:	e456                	sd	s5,8(sp)
    800060c4:	0080                	addi	s0,sp,64
    800060c6:	84aa                	mv	s1,a0
  printf("virtio disk init %d\n", n);
    800060c8:	85aa                	mv	a1,a0
    800060ca:	00003517          	auipc	a0,0x3
    800060ce:	80e50513          	addi	a0,a0,-2034 # 800088d8 <userret+0x848>
    800060d2:	ffffa097          	auipc	ra,0xffffa
    800060d6:	4d0080e7          	jalr	1232(ra) # 800005a2 <printf>
  initlock(&disk[n].vdisk_lock, "virtio_disk");
    800060da:	00149993          	slli	s3,s1,0x1
    800060de:	99a6                	add	s3,s3,s1
    800060e0:	09b2                	slli	s3,s3,0xc
    800060e2:	6789                	lui	a5,0x2
    800060e4:	0b078793          	addi	a5,a5,176 # 20b0 <_entry-0x7fffdf50>
    800060e8:	97ce                	add	a5,a5,s3
    800060ea:	00003597          	auipc	a1,0x3
    800060ee:	80658593          	addi	a1,a1,-2042 # 800088f0 <userret+0x860>
    800060f2:	00024517          	auipc	a0,0x24
    800060f6:	f0e50513          	addi	a0,a0,-242 # 8002a000 <disk>
    800060fa:	953e                	add	a0,a0,a5
    800060fc:	ffffb097          	auipc	ra,0xffffb
    80006100:	9e0080e7          	jalr	-1568(ra) # 80000adc <initlock>
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006104:	0014891b          	addiw	s2,s1,1
    80006108:	00c9191b          	slliw	s2,s2,0xc
    8000610c:	100007b7          	lui	a5,0x10000
    80006110:	97ca                	add	a5,a5,s2
    80006112:	4398                	lw	a4,0(a5)
    80006114:	2701                	sext.w	a4,a4
    80006116:	747277b7          	lui	a5,0x74727
    8000611a:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000611e:	12f71663          	bne	a4,a5,8000624a <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80006122:	100007b7          	lui	a5,0x10000
    80006126:	0791                	addi	a5,a5,4
    80006128:	97ca                	add	a5,a5,s2
    8000612a:	439c                	lw	a5,0(a5)
    8000612c:	2781                	sext.w	a5,a5
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000612e:	4705                	li	a4,1
    80006130:	10e79d63          	bne	a5,a4,8000624a <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006134:	100007b7          	lui	a5,0x10000
    80006138:	07a1                	addi	a5,a5,8
    8000613a:	97ca                	add	a5,a5,s2
    8000613c:	439c                	lw	a5,0(a5)
    8000613e:	2781                	sext.w	a5,a5
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80006140:	4709                	li	a4,2
    80006142:	10e79463          	bne	a5,a4,8000624a <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006146:	100007b7          	lui	a5,0x10000
    8000614a:	07b1                	addi	a5,a5,12
    8000614c:	97ca                	add	a5,a5,s2
    8000614e:	4398                	lw	a4,0(a5)
    80006150:	2701                	sext.w	a4,a4
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006152:	554d47b7          	lui	a5,0x554d4
    80006156:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000615a:	0ef71863          	bne	a4,a5,8000624a <virtio_disk_init+0x1b8>
  *R(n, VIRTIO_MMIO_STATUS) = status;
    8000615e:	100007b7          	lui	a5,0x10000
    80006162:	07078693          	addi	a3,a5,112 # 10000070 <_entry-0x6fffff90>
    80006166:	96ca                	add	a3,a3,s2
    80006168:	4705                	li	a4,1
    8000616a:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    8000616c:	470d                	li	a4,3
    8000616e:	c298                	sw	a4,0(a3)
  uint64 features = *R(n, VIRTIO_MMIO_DEVICE_FEATURES);
    80006170:	01078713          	addi	a4,a5,16
    80006174:	974a                	add	a4,a4,s2
    80006176:	430c                	lw	a1,0(a4)
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006178:	02078613          	addi	a2,a5,32
    8000617c:	964a                	add	a2,a2,s2
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000617e:	c7ffe737          	lui	a4,0xc7ffe
    80006182:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fce703>
    80006186:	8f6d                	and	a4,a4,a1
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006188:	2701                	sext.w	a4,a4
    8000618a:	c218                	sw	a4,0(a2)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    8000618c:	472d                	li	a4,11
    8000618e:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80006190:	473d                	li	a4,15
    80006192:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006194:	02878713          	addi	a4,a5,40
    80006198:	974a                	add	a4,a4,s2
    8000619a:	6685                	lui	a3,0x1
    8000619c:	c314                	sw	a3,0(a4)
  *R(n, VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000619e:	03078713          	addi	a4,a5,48
    800061a2:	974a                	add	a4,a4,s2
    800061a4:	00072023          	sw	zero,0(a4)
  uint32 max = *R(n, VIRTIO_MMIO_QUEUE_NUM_MAX);
    800061a8:	03478793          	addi	a5,a5,52
    800061ac:	97ca                	add	a5,a5,s2
    800061ae:	439c                	lw	a5,0(a5)
    800061b0:	2781                	sext.w	a5,a5
  if(max == 0)
    800061b2:	c7c5                	beqz	a5,8000625a <virtio_disk_init+0x1c8>
  if(max < NUM)
    800061b4:	471d                	li	a4,7
    800061b6:	0af77a63          	bgeu	a4,a5,8000626a <virtio_disk_init+0x1d8>
  *R(n, VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800061ba:	10000ab7          	lui	s5,0x10000
    800061be:	038a8793          	addi	a5,s5,56 # 10000038 <_entry-0x6fffffc8>
    800061c2:	97ca                	add	a5,a5,s2
    800061c4:	4721                	li	a4,8
    800061c6:	c398                	sw	a4,0(a5)
  memset(disk[n].pages, 0, sizeof(disk[n].pages));
    800061c8:	00024a17          	auipc	s4,0x24
    800061cc:	e38a0a13          	addi	s4,s4,-456 # 8002a000 <disk>
    800061d0:	99d2                	add	s3,s3,s4
    800061d2:	6609                	lui	a2,0x2
    800061d4:	4581                	li	a1,0
    800061d6:	854e                	mv	a0,s3
    800061d8:	ffffb097          	auipc	ra,0xffffb
    800061dc:	cc0080e7          	jalr	-832(ra) # 80000e98 <memset>
  *R(n, VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk[n].pages) >> PGSHIFT;
    800061e0:	040a8a93          	addi	s5,s5,64
    800061e4:	9956                	add	s2,s2,s5
    800061e6:	00c9d793          	srli	a5,s3,0xc
    800061ea:	2781                	sext.w	a5,a5
    800061ec:	00f92023          	sw	a5,0(s2)
  disk[n].desc = (struct VRingDesc *) disk[n].pages;
    800061f0:	00149693          	slli	a3,s1,0x1
    800061f4:	009687b3          	add	a5,a3,s1
    800061f8:	07b2                	slli	a5,a5,0xc
    800061fa:	97d2                	add	a5,a5,s4
    800061fc:	6609                	lui	a2,0x2
    800061fe:	97b2                	add	a5,a5,a2
    80006200:	0137b023          	sd	s3,0(a5)
  disk[n].avail = (uint16*)(((char*)disk[n].desc) + NUM*sizeof(struct VRingDesc));
    80006204:	08098713          	addi	a4,s3,128
    80006208:	e798                	sd	a4,8(a5)
  disk[n].used = (struct UsedArea *) (disk[n].pages + PGSIZE);
    8000620a:	6705                	lui	a4,0x1
    8000620c:	99ba                	add	s3,s3,a4
    8000620e:	0137b823          	sd	s3,16(a5)
    disk[n].free[i] = 1;
    80006212:	4705                	li	a4,1
    80006214:	00e78c23          	sb	a4,24(a5)
    80006218:	00e78ca3          	sb	a4,25(a5)
    8000621c:	00e78d23          	sb	a4,26(a5)
    80006220:	00e78da3          	sb	a4,27(a5)
    80006224:	00e78e23          	sb	a4,28(a5)
    80006228:	00e78ea3          	sb	a4,29(a5)
    8000622c:	00e78f23          	sb	a4,30(a5)
    80006230:	00e78fa3          	sb	a4,31(a5)
  disk[n].init = 1;
    80006234:	0ae7a423          	sw	a4,168(a5)
}
    80006238:	70e2                	ld	ra,56(sp)
    8000623a:	7442                	ld	s0,48(sp)
    8000623c:	74a2                	ld	s1,40(sp)
    8000623e:	7902                	ld	s2,32(sp)
    80006240:	69e2                	ld	s3,24(sp)
    80006242:	6a42                	ld	s4,16(sp)
    80006244:	6aa2                	ld	s5,8(sp)
    80006246:	6121                	addi	sp,sp,64
    80006248:	8082                	ret
    panic("could not find virtio disk");
    8000624a:	00002517          	auipc	a0,0x2
    8000624e:	6b650513          	addi	a0,a0,1718 # 80008900 <userret+0x870>
    80006252:	ffffa097          	auipc	ra,0xffffa
    80006256:	2f6080e7          	jalr	758(ra) # 80000548 <panic>
    panic("virtio disk has no queue 0");
    8000625a:	00002517          	auipc	a0,0x2
    8000625e:	6c650513          	addi	a0,a0,1734 # 80008920 <userret+0x890>
    80006262:	ffffa097          	auipc	ra,0xffffa
    80006266:	2e6080e7          	jalr	742(ra) # 80000548 <panic>
    panic("virtio disk max queue too short");
    8000626a:	00002517          	auipc	a0,0x2
    8000626e:	6d650513          	addi	a0,a0,1750 # 80008940 <userret+0x8b0>
    80006272:	ffffa097          	auipc	ra,0xffffa
    80006276:	2d6080e7          	jalr	726(ra) # 80000548 <panic>

000000008000627a <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(int n, struct buf *b, int write)
{
    8000627a:	7135                	addi	sp,sp,-160
    8000627c:	ed06                	sd	ra,152(sp)
    8000627e:	e922                	sd	s0,144(sp)
    80006280:	e526                	sd	s1,136(sp)
    80006282:	e14a                	sd	s2,128(sp)
    80006284:	fcce                	sd	s3,120(sp)
    80006286:	f8d2                	sd	s4,112(sp)
    80006288:	f4d6                	sd	s5,104(sp)
    8000628a:	f0da                	sd	s6,96(sp)
    8000628c:	ecde                	sd	s7,88(sp)
    8000628e:	e8e2                	sd	s8,80(sp)
    80006290:	e4e6                	sd	s9,72(sp)
    80006292:	e0ea                	sd	s10,64(sp)
    80006294:	fc6e                	sd	s11,56(sp)
    80006296:	1100                	addi	s0,sp,160
    80006298:	8aaa                	mv	s5,a0
    8000629a:	8c2e                	mv	s8,a1
    8000629c:	8db2                	mv	s11,a2
  uint64 sector = b->blockno * (BSIZE / 512);
    8000629e:	45dc                	lw	a5,12(a1)
    800062a0:	0017979b          	slliw	a5,a5,0x1
    800062a4:	1782                	slli	a5,a5,0x20
    800062a6:	9381                	srli	a5,a5,0x20
    800062a8:	f6f43423          	sd	a5,-152(s0)

  acquire(&disk[n].vdisk_lock);
    800062ac:	00151493          	slli	s1,a0,0x1
    800062b0:	94aa                	add	s1,s1,a0
    800062b2:	04b2                	slli	s1,s1,0xc
    800062b4:	6909                	lui	s2,0x2
    800062b6:	0b090c93          	addi	s9,s2,176 # 20b0 <_entry-0x7fffdf50>
    800062ba:	9ca6                	add	s9,s9,s1
    800062bc:	00024997          	auipc	s3,0x24
    800062c0:	d4498993          	addi	s3,s3,-700 # 8002a000 <disk>
    800062c4:	9cce                	add	s9,s9,s3
    800062c6:	8566                	mv	a0,s9
    800062c8:	ffffb097          	auipc	ra,0xffffb
    800062cc:	962080e7          	jalr	-1694(ra) # 80000c2a <acquire>
  int idx[3];
  while(1){
    if(alloc3_desc(n, idx) == 0) {
      break;
    }
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    800062d0:	0961                	addi	s2,s2,24
    800062d2:	94ca                	add	s1,s1,s2
    800062d4:	99a6                	add	s3,s3,s1
  for(int i = 0; i < 3; i++){
    800062d6:	4a01                	li	s4,0
  for(int i = 0; i < NUM; i++){
    800062d8:	44a1                	li	s1,8
      disk[n].free[i] = 0;
    800062da:	001a9793          	slli	a5,s5,0x1
    800062de:	97d6                	add	a5,a5,s5
    800062e0:	07b2                	slli	a5,a5,0xc
    800062e2:	00024b97          	auipc	s7,0x24
    800062e6:	d1eb8b93          	addi	s7,s7,-738 # 8002a000 <disk>
    800062ea:	9bbe                	add	s7,s7,a5
    800062ec:	a8a9                	j	80006346 <virtio_disk_rw+0xcc>
    800062ee:	00fb8733          	add	a4,s7,a5
    800062f2:	9742                	add	a4,a4,a6
    800062f4:	00070c23          	sb	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    idx[i] = alloc_desc(n);
    800062f8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800062fa:	0207c263          	bltz	a5,8000631e <virtio_disk_rw+0xa4>
  for(int i = 0; i < 3; i++){
    800062fe:	2905                	addiw	s2,s2,1
    80006300:	0611                	addi	a2,a2,4
    80006302:	1ca90463          	beq	s2,a0,800064ca <virtio_disk_rw+0x250>
    idx[i] = alloc_desc(n);
    80006306:	85b2                	mv	a1,a2
    80006308:	874e                	mv	a4,s3
  for(int i = 0; i < NUM; i++){
    8000630a:	87d2                	mv	a5,s4
    if(disk[n].free[i]){
    8000630c:	00074683          	lbu	a3,0(a4)
    80006310:	fef9                	bnez	a3,800062ee <virtio_disk_rw+0x74>
  for(int i = 0; i < NUM; i++){
    80006312:	2785                	addiw	a5,a5,1
    80006314:	0705                	addi	a4,a4,1
    80006316:	fe979be3          	bne	a5,s1,8000630c <virtio_disk_rw+0x92>
    idx[i] = alloc_desc(n);
    8000631a:	57fd                	li	a5,-1
    8000631c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000631e:	01205e63          	blez	s2,8000633a <virtio_disk_rw+0xc0>
    80006322:	8d52                	mv	s10,s4
        free_desc(n, idx[j]);
    80006324:	000b2583          	lw	a1,0(s6)
    80006328:	8556                	mv	a0,s5
    8000632a:	00000097          	auipc	ra,0x0
    8000632e:	ccc080e7          	jalr	-820(ra) # 80005ff6 <free_desc>
      for(int j = 0; j < i; j++)
    80006332:	2d05                	addiw	s10,s10,1
    80006334:	0b11                	addi	s6,s6,4
    80006336:	ffa917e3          	bne	s2,s10,80006324 <virtio_disk_rw+0xaa>
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    8000633a:	85e6                	mv	a1,s9
    8000633c:	854e                	mv	a0,s3
    8000633e:	ffffc097          	auipc	ra,0xffffc
    80006342:	01a080e7          	jalr	26(ra) # 80002358 <sleep>
  for(int i = 0; i < 3; i++){
    80006346:	f8040b13          	addi	s6,s0,-128
{
    8000634a:	865a                	mv	a2,s6
  for(int i = 0; i < 3; i++){
    8000634c:	8952                	mv	s2,s4
      disk[n].free[i] = 0;
    8000634e:	6809                	lui	a6,0x2
  for(int i = 0; i < 3; i++){
    80006350:	450d                	li	a0,3
    80006352:	bf55                	j	80006306 <virtio_disk_rw+0x8c>
  disk[n].desc[idx[0]].next = idx[1];

  disk[n].desc[idx[1]].addr = (uint64) b->data;
  disk[n].desc[idx[1]].len = BSIZE;
  if(write)
    disk[n].desc[idx[1]].flags = 0; // device reads b->data
    80006354:	001a9793          	slli	a5,s5,0x1
    80006358:	97d6                	add	a5,a5,s5
    8000635a:	07b2                	slli	a5,a5,0xc
    8000635c:	00024717          	auipc	a4,0x24
    80006360:	ca470713          	addi	a4,a4,-860 # 8002a000 <disk>
    80006364:	973e                	add	a4,a4,a5
    80006366:	6789                	lui	a5,0x2
    80006368:	97ba                	add	a5,a5,a4
    8000636a:	639c                	ld	a5,0(a5)
    8000636c:	97b6                	add	a5,a5,a3
    8000636e:	00079623          	sh	zero,12(a5) # 200c <_entry-0x7fffdff4>
  else
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk[n].desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006372:	00024517          	auipc	a0,0x24
    80006376:	c8e50513          	addi	a0,a0,-882 # 8002a000 <disk>
    8000637a:	001a9793          	slli	a5,s5,0x1
    8000637e:	01578733          	add	a4,a5,s5
    80006382:	0732                	slli	a4,a4,0xc
    80006384:	972a                	add	a4,a4,a0
    80006386:	6609                	lui	a2,0x2
    80006388:	9732                	add	a4,a4,a2
    8000638a:	6310                	ld	a2,0(a4)
    8000638c:	9636                	add	a2,a2,a3
    8000638e:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006392:	0015e593          	ori	a1,a1,1
    80006396:	00b61623          	sh	a1,12(a2)
  disk[n].desc[idx[1]].next = idx[2];
    8000639a:	f8842603          	lw	a2,-120(s0)
    8000639e:	630c                	ld	a1,0(a4)
    800063a0:	96ae                	add	a3,a3,a1
    800063a2:	00c69723          	sh	a2,14(a3) # 100e <_entry-0x7fffeff2>

  disk[n].info[idx[0]].status = 0;
    800063a6:	97d6                	add	a5,a5,s5
    800063a8:	07a2                	slli	a5,a5,0x8
    800063aa:	97a6                	add	a5,a5,s1
    800063ac:	20078793          	addi	a5,a5,512
    800063b0:	0792                	slli	a5,a5,0x4
    800063b2:	97aa                	add	a5,a5,a0
    800063b4:	02078823          	sb	zero,48(a5)
  disk[n].desc[idx[2]].addr = (uint64) &disk[n].info[idx[0]].status;
    800063b8:	00461693          	slli	a3,a2,0x4
    800063bc:	00073803          	ld	a6,0(a4)
    800063c0:	9836                	add	a6,a6,a3
    800063c2:	20348613          	addi	a2,s1,515
    800063c6:	001a9593          	slli	a1,s5,0x1
    800063ca:	95d6                	add	a1,a1,s5
    800063cc:	05a2                	slli	a1,a1,0x8
    800063ce:	962e                	add	a2,a2,a1
    800063d0:	0612                	slli	a2,a2,0x4
    800063d2:	962a                	add	a2,a2,a0
    800063d4:	00c83023          	sd	a2,0(a6) # 2000 <_entry-0x7fffe000>
  disk[n].desc[idx[2]].len = 1;
    800063d8:	630c                	ld	a1,0(a4)
    800063da:	95b6                	add	a1,a1,a3
    800063dc:	4605                	li	a2,1
    800063de:	c590                	sw	a2,8(a1)
  disk[n].desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800063e0:	630c                	ld	a1,0(a4)
    800063e2:	95b6                	add	a1,a1,a3
    800063e4:	4509                	li	a0,2
    800063e6:	00a59623          	sh	a0,12(a1)
  disk[n].desc[idx[2]].next = 0;
    800063ea:	630c                	ld	a1,0(a4)
    800063ec:	96ae                	add	a3,a3,a1
    800063ee:	00069723          	sh	zero,14(a3)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800063f2:	00cc2223          	sw	a2,4(s8) # fffffffffffff004 <end+0xffffffff7ffcefa8>
  disk[n].info[idx[0]].b = b;
    800063f6:	0387b423          	sd	s8,40(a5)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk[n].avail[2 + (disk[n].avail[1] % NUM)] = idx[0];
    800063fa:	6714                	ld	a3,8(a4)
    800063fc:	0026d783          	lhu	a5,2(a3)
    80006400:	8b9d                	andi	a5,a5,7
    80006402:	0789                	addi	a5,a5,2
    80006404:	0786                	slli	a5,a5,0x1
    80006406:	97b6                	add	a5,a5,a3
    80006408:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    8000640c:	0ff0000f          	fence
  disk[n].avail[1] = disk[n].avail[1] + 1;
    80006410:	6718                	ld	a4,8(a4)
    80006412:	00275783          	lhu	a5,2(a4)
    80006416:	2785                	addiw	a5,a5,1
    80006418:	00f71123          	sh	a5,2(a4)

  *R(n, VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000641c:	001a879b          	addiw	a5,s5,1
    80006420:	00c7979b          	slliw	a5,a5,0xc
    80006424:	10000737          	lui	a4,0x10000
    80006428:	05070713          	addi	a4,a4,80 # 10000050 <_entry-0x6fffffb0>
    8000642c:	97ba                	add	a5,a5,a4
    8000642e:	0007a023          	sw	zero,0(a5)

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006432:	004c2783          	lw	a5,4(s8)
    80006436:	00c79d63          	bne	a5,a2,80006450 <virtio_disk_rw+0x1d6>
    8000643a:	4485                	li	s1,1
    sleep(b, &disk[n].vdisk_lock);
    8000643c:	85e6                	mv	a1,s9
    8000643e:	8562                	mv	a0,s8
    80006440:	ffffc097          	auipc	ra,0xffffc
    80006444:	f18080e7          	jalr	-232(ra) # 80002358 <sleep>
  while(b->disk == 1) {
    80006448:	004c2783          	lw	a5,4(s8)
    8000644c:	fe9788e3          	beq	a5,s1,8000643c <virtio_disk_rw+0x1c2>
  }

  disk[n].info[idx[0]].b = 0;
    80006450:	f8042483          	lw	s1,-128(s0)
    80006454:	001a9793          	slli	a5,s5,0x1
    80006458:	97d6                	add	a5,a5,s5
    8000645a:	07a2                	slli	a5,a5,0x8
    8000645c:	97a6                	add	a5,a5,s1
    8000645e:	20078793          	addi	a5,a5,512
    80006462:	0792                	slli	a5,a5,0x4
    80006464:	00024717          	auipc	a4,0x24
    80006468:	b9c70713          	addi	a4,a4,-1124 # 8002a000 <disk>
    8000646c:	97ba                	add	a5,a5,a4
    8000646e:	0207b423          	sd	zero,40(a5)
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    80006472:	001a9793          	slli	a5,s5,0x1
    80006476:	97d6                	add	a5,a5,s5
    80006478:	07b2                	slli	a5,a5,0xc
    8000647a:	97ba                	add	a5,a5,a4
    8000647c:	6909                	lui	s2,0x2
    8000647e:	993e                	add	s2,s2,a5
    80006480:	a019                	j	80006486 <virtio_disk_rw+0x20c>
      i = disk[n].desc[i].next;
    80006482:	00e4d483          	lhu	s1,14(s1)
    free_desc(n, i);
    80006486:	85a6                	mv	a1,s1
    80006488:	8556                	mv	a0,s5
    8000648a:	00000097          	auipc	ra,0x0
    8000648e:	b6c080e7          	jalr	-1172(ra) # 80005ff6 <free_desc>
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    80006492:	0492                	slli	s1,s1,0x4
    80006494:	00093783          	ld	a5,0(s2) # 2000 <_entry-0x7fffe000>
    80006498:	94be                	add	s1,s1,a5
    8000649a:	00c4d783          	lhu	a5,12(s1)
    8000649e:	8b85                	andi	a5,a5,1
    800064a0:	f3ed                	bnez	a5,80006482 <virtio_disk_rw+0x208>
  free_chain(n, idx[0]);

  release(&disk[n].vdisk_lock);
    800064a2:	8566                	mv	a0,s9
    800064a4:	ffffa097          	auipc	ra,0xffffa
    800064a8:	7f6080e7          	jalr	2038(ra) # 80000c9a <release>
}
    800064ac:	60ea                	ld	ra,152(sp)
    800064ae:	644a                	ld	s0,144(sp)
    800064b0:	64aa                	ld	s1,136(sp)
    800064b2:	690a                	ld	s2,128(sp)
    800064b4:	79e6                	ld	s3,120(sp)
    800064b6:	7a46                	ld	s4,112(sp)
    800064b8:	7aa6                	ld	s5,104(sp)
    800064ba:	7b06                	ld	s6,96(sp)
    800064bc:	6be6                	ld	s7,88(sp)
    800064be:	6c46                	ld	s8,80(sp)
    800064c0:	6ca6                	ld	s9,72(sp)
    800064c2:	6d06                	ld	s10,64(sp)
    800064c4:	7de2                	ld	s11,56(sp)
    800064c6:	610d                	addi	sp,sp,160
    800064c8:	8082                	ret
  if(write)
    800064ca:	01b037b3          	snez	a5,s11
    800064ce:	f6f42823          	sw	a5,-144(s0)
  buf0.reserved = 0;
    800064d2:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    800064d6:	f6843783          	ld	a5,-152(s0)
    800064da:	f6f43c23          	sd	a5,-136(s0)
  disk[n].desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    800064de:	f8042483          	lw	s1,-128(s0)
    800064e2:	00449993          	slli	s3,s1,0x4
    800064e6:	001a9793          	slli	a5,s5,0x1
    800064ea:	97d6                	add	a5,a5,s5
    800064ec:	07b2                	slli	a5,a5,0xc
    800064ee:	00024917          	auipc	s2,0x24
    800064f2:	b1290913          	addi	s2,s2,-1262 # 8002a000 <disk>
    800064f6:	97ca                	add	a5,a5,s2
    800064f8:	6909                	lui	s2,0x2
    800064fa:	993e                	add	s2,s2,a5
    800064fc:	00093a03          	ld	s4,0(s2) # 2000 <_entry-0x7fffe000>
    80006500:	9a4e                	add	s4,s4,s3
    80006502:	f7040513          	addi	a0,s0,-144
    80006506:	ffffb097          	auipc	ra,0xffffb
    8000650a:	dce080e7          	jalr	-562(ra) # 800012d4 <kvmpa>
    8000650e:	00aa3023          	sd	a0,0(s4)
  disk[n].desc[idx[0]].len = sizeof(buf0);
    80006512:	00093783          	ld	a5,0(s2)
    80006516:	97ce                	add	a5,a5,s3
    80006518:	4741                	li	a4,16
    8000651a:	c798                	sw	a4,8(a5)
  disk[n].desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000651c:	00093783          	ld	a5,0(s2)
    80006520:	97ce                	add	a5,a5,s3
    80006522:	4705                	li	a4,1
    80006524:	00e79623          	sh	a4,12(a5)
  disk[n].desc[idx[0]].next = idx[1];
    80006528:	f8442683          	lw	a3,-124(s0)
    8000652c:	00093783          	ld	a5,0(s2)
    80006530:	99be                	add	s3,s3,a5
    80006532:	00d99723          	sh	a3,14(s3)
  disk[n].desc[idx[1]].addr = (uint64) b->data;
    80006536:	0692                	slli	a3,a3,0x4
    80006538:	00093783          	ld	a5,0(s2)
    8000653c:	97b6                	add	a5,a5,a3
    8000653e:	060c0713          	addi	a4,s8,96
    80006542:	e398                	sd	a4,0(a5)
  disk[n].desc[idx[1]].len = BSIZE;
    80006544:	00093783          	ld	a5,0(s2)
    80006548:	97b6                	add	a5,a5,a3
    8000654a:	40000713          	li	a4,1024
    8000654e:	c798                	sw	a4,8(a5)
  if(write)
    80006550:	e00d92e3          	bnez	s11,80006354 <virtio_disk_rw+0xda>
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006554:	001a9793          	slli	a5,s5,0x1
    80006558:	97d6                	add	a5,a5,s5
    8000655a:	07b2                	slli	a5,a5,0xc
    8000655c:	00024717          	auipc	a4,0x24
    80006560:	aa470713          	addi	a4,a4,-1372 # 8002a000 <disk>
    80006564:	973e                	add	a4,a4,a5
    80006566:	6789                	lui	a5,0x2
    80006568:	97ba                	add	a5,a5,a4
    8000656a:	639c                	ld	a5,0(a5)
    8000656c:	97b6                	add	a5,a5,a3
    8000656e:	4709                	li	a4,2
    80006570:	00e79623          	sh	a4,12(a5) # 200c <_entry-0x7fffdff4>
    80006574:	bbfd                	j	80006372 <virtio_disk_rw+0xf8>

0000000080006576 <virtio_disk_intr>:

void
virtio_disk_intr(int n)
{
    80006576:	7139                	addi	sp,sp,-64
    80006578:	fc06                	sd	ra,56(sp)
    8000657a:	f822                	sd	s0,48(sp)
    8000657c:	f426                	sd	s1,40(sp)
    8000657e:	f04a                	sd	s2,32(sp)
    80006580:	ec4e                	sd	s3,24(sp)
    80006582:	e852                	sd	s4,16(sp)
    80006584:	e456                	sd	s5,8(sp)
    80006586:	0080                	addi	s0,sp,64
    80006588:	84aa                	mv	s1,a0
  acquire(&disk[n].vdisk_lock);
    8000658a:	00151913          	slli	s2,a0,0x1
    8000658e:	00a90a33          	add	s4,s2,a0
    80006592:	0a32                	slli	s4,s4,0xc
    80006594:	6989                	lui	s3,0x2
    80006596:	0b098793          	addi	a5,s3,176 # 20b0 <_entry-0x7fffdf50>
    8000659a:	9a3e                	add	s4,s4,a5
    8000659c:	00024a97          	auipc	s5,0x24
    800065a0:	a64a8a93          	addi	s5,s5,-1436 # 8002a000 <disk>
    800065a4:	9a56                	add	s4,s4,s5
    800065a6:	8552                	mv	a0,s4
    800065a8:	ffffa097          	auipc	ra,0xffffa
    800065ac:	682080e7          	jalr	1666(ra) # 80000c2a <acquire>

  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    800065b0:	9926                	add	s2,s2,s1
    800065b2:	0932                	slli	s2,s2,0xc
    800065b4:	9956                	add	s2,s2,s5
    800065b6:	99ca                	add	s3,s3,s2
    800065b8:	0209d783          	lhu	a5,32(s3)
    800065bc:	0109b703          	ld	a4,16(s3)
    800065c0:	00275683          	lhu	a3,2(a4)
    800065c4:	8ebd                	xor	a3,a3,a5
    800065c6:	8a9d                	andi	a3,a3,7
    800065c8:	c2a5                	beqz	a3,80006628 <virtio_disk_intr+0xb2>
    int id = disk[n].used->elems[disk[n].used_idx].id;

    if(disk[n].info[id].status != 0)
    800065ca:	8956                	mv	s2,s5
    800065cc:	00149693          	slli	a3,s1,0x1
    800065d0:	96a6                	add	a3,a3,s1
    800065d2:	00869993          	slli	s3,a3,0x8
      panic("virtio_disk_intr status");
    
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk[n].info[id].b);

    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    800065d6:	06b2                	slli	a3,a3,0xc
    800065d8:	96d6                	add	a3,a3,s5
    800065da:	6489                	lui	s1,0x2
    800065dc:	94b6                	add	s1,s1,a3
    int id = disk[n].used->elems[disk[n].used_idx].id;
    800065de:	078e                	slli	a5,a5,0x3
    800065e0:	97ba                	add	a5,a5,a4
    800065e2:	43dc                	lw	a5,4(a5)
    if(disk[n].info[id].status != 0)
    800065e4:	00f98733          	add	a4,s3,a5
    800065e8:	20070713          	addi	a4,a4,512
    800065ec:	0712                	slli	a4,a4,0x4
    800065ee:	974a                	add	a4,a4,s2
    800065f0:	03074703          	lbu	a4,48(a4)
    800065f4:	eb21                	bnez	a4,80006644 <virtio_disk_intr+0xce>
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    800065f6:	97ce                	add	a5,a5,s3
    800065f8:	20078793          	addi	a5,a5,512
    800065fc:	0792                	slli	a5,a5,0x4
    800065fe:	97ca                	add	a5,a5,s2
    80006600:	7798                	ld	a4,40(a5)
    80006602:	00072223          	sw	zero,4(a4)
    wakeup(disk[n].info[id].b);
    80006606:	7788                	ld	a0,40(a5)
    80006608:	ffffc097          	auipc	ra,0xffffc
    8000660c:	ed0080e7          	jalr	-304(ra) # 800024d8 <wakeup>
    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    80006610:	0204d783          	lhu	a5,32(s1) # 2020 <_entry-0x7fffdfe0>
    80006614:	2785                	addiw	a5,a5,1
    80006616:	8b9d                	andi	a5,a5,7
    80006618:	02f49023          	sh	a5,32(s1)
  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    8000661c:	6898                	ld	a4,16(s1)
    8000661e:	00275683          	lhu	a3,2(a4)
    80006622:	8a9d                	andi	a3,a3,7
    80006624:	faf69de3          	bne	a3,a5,800065de <virtio_disk_intr+0x68>
  }

  release(&disk[n].vdisk_lock);
    80006628:	8552                	mv	a0,s4
    8000662a:	ffffa097          	auipc	ra,0xffffa
    8000662e:	670080e7          	jalr	1648(ra) # 80000c9a <release>
}
    80006632:	70e2                	ld	ra,56(sp)
    80006634:	7442                	ld	s0,48(sp)
    80006636:	74a2                	ld	s1,40(sp)
    80006638:	7902                	ld	s2,32(sp)
    8000663a:	69e2                	ld	s3,24(sp)
    8000663c:	6a42                	ld	s4,16(sp)
    8000663e:	6aa2                	ld	s5,8(sp)
    80006640:	6121                	addi	sp,sp,64
    80006642:	8082                	ret
      panic("virtio_disk_intr status");
    80006644:	00002517          	auipc	a0,0x2
    80006648:	31c50513          	addi	a0,a0,796 # 80008960 <userret+0x8d0>
    8000664c:	ffffa097          	auipc	ra,0xffffa
    80006650:	efc080e7          	jalr	-260(ra) # 80000548 <panic>

0000000080006654 <bit_isset>:
static Sz_info *bd_sizes; 
static void *bd_base;   // start address of memory managed by the buddy allocator
static struct spinlock lock;

// Return 1 if bit at position index in array is set to 1
int bit_isset(char *array, int index) {
    80006654:	1141                	addi	sp,sp,-16
    80006656:	e422                	sd	s0,8(sp)
    80006658:	0800                	addi	s0,sp,16
  char b = array[index/8];
  char m = (1 << (index % 8));
    8000665a:	41f5d79b          	sraiw	a5,a1,0x1f
    8000665e:	01d7d79b          	srliw	a5,a5,0x1d
    80006662:	9dbd                	addw	a1,a1,a5
    80006664:	0075f713          	andi	a4,a1,7
    80006668:	9f1d                	subw	a4,a4,a5
    8000666a:	4785                	li	a5,1
    8000666c:	00e797bb          	sllw	a5,a5,a4
    80006670:	0ff7f793          	andi	a5,a5,255
  char b = array[index/8];
    80006674:	4035d59b          	sraiw	a1,a1,0x3
    80006678:	95aa                	add	a1,a1,a0
  return (b & m) == m;
    8000667a:	0005c503          	lbu	a0,0(a1)
    8000667e:	8d7d                	and	a0,a0,a5
    80006680:	8d1d                	sub	a0,a0,a5
}
    80006682:	00153513          	seqz	a0,a0
    80006686:	6422                	ld	s0,8(sp)
    80006688:	0141                	addi	sp,sp,16
    8000668a:	8082                	ret

000000008000668c <bit_set>:

// Set bit at position index in array to 1
void bit_set(char *array, int index) {
    8000668c:	1141                	addi	sp,sp,-16
    8000668e:	e422                	sd	s0,8(sp)
    80006690:	0800                	addi	s0,sp,16
  char b = array[index/8];
    80006692:	41f5d79b          	sraiw	a5,a1,0x1f
    80006696:	01d7d79b          	srliw	a5,a5,0x1d
    8000669a:	9dbd                	addw	a1,a1,a5
    8000669c:	4035d71b          	sraiw	a4,a1,0x3
    800066a0:	953a                	add	a0,a0,a4
  char m = (1 << (index % 8));
    800066a2:	899d                	andi	a1,a1,7
    800066a4:	9d9d                	subw	a1,a1,a5
    800066a6:	4785                	li	a5,1
    800066a8:	00b795bb          	sllw	a1,a5,a1
  array[index/8] = (b | m);
    800066ac:	00054783          	lbu	a5,0(a0)
    800066b0:	8ddd                	or	a1,a1,a5
    800066b2:	00b50023          	sb	a1,0(a0)
}
    800066b6:	6422                	ld	s0,8(sp)
    800066b8:	0141                	addi	sp,sp,16
    800066ba:	8082                	ret

00000000800066bc <bit_clear>:

// Clear bit at position index in array
void bit_clear(char *array, int index) {
    800066bc:	1141                	addi	sp,sp,-16
    800066be:	e422                	sd	s0,8(sp)
    800066c0:	0800                	addi	s0,sp,16
  char b = array[index/8];
    800066c2:	41f5d79b          	sraiw	a5,a1,0x1f
    800066c6:	01d7d79b          	srliw	a5,a5,0x1d
    800066ca:	9dbd                	addw	a1,a1,a5
    800066cc:	4035d71b          	sraiw	a4,a1,0x3
    800066d0:	953a                	add	a0,a0,a4
  char m = (1 << (index % 8));
    800066d2:	899d                	andi	a1,a1,7
    800066d4:	9d9d                	subw	a1,a1,a5
    800066d6:	4785                	li	a5,1
    800066d8:	00b795bb          	sllw	a1,a5,a1
  array[index/8] = (b & ~m);
    800066dc:	fff5c593          	not	a1,a1
    800066e0:	00054783          	lbu	a5,0(a0)
    800066e4:	8dfd                	and	a1,a1,a5
    800066e6:	00b50023          	sb	a1,0(a0)
}
    800066ea:	6422                	ld	s0,8(sp)
    800066ec:	0141                	addi	sp,sp,16
    800066ee:	8082                	ret

00000000800066f0 <bd_print_vector>:

// Print a bit vector as a list of ranges of 1 bits
void
bd_print_vector(char *vector, int len) {
    800066f0:	715d                	addi	sp,sp,-80
    800066f2:	e486                	sd	ra,72(sp)
    800066f4:	e0a2                	sd	s0,64(sp)
    800066f6:	fc26                	sd	s1,56(sp)
    800066f8:	f84a                	sd	s2,48(sp)
    800066fa:	f44e                	sd	s3,40(sp)
    800066fc:	f052                	sd	s4,32(sp)
    800066fe:	ec56                	sd	s5,24(sp)
    80006700:	e85a                	sd	s6,16(sp)
    80006702:	e45e                	sd	s7,8(sp)
    80006704:	0880                	addi	s0,sp,80
    80006706:	8a2e                	mv	s4,a1
  int last, lb;
  
  last = 1;
  lb = 0;
  for (int b = 0; b < len; b++) {
    80006708:	08b05b63          	blez	a1,8000679e <bd_print_vector+0xae>
    8000670c:	89aa                	mv	s3,a0
    8000670e:	4481                	li	s1,0
  lb = 0;
    80006710:	4a81                	li	s5,0
  last = 1;
    80006712:	4905                	li	s2,1
    if (last == bit_isset(vector, b))
      continue;
    if(last == 1)
    80006714:	4b05                	li	s6,1
      printf(" [%d, %d)", lb, b);
    80006716:	00002b97          	auipc	s7,0x2
    8000671a:	262b8b93          	addi	s7,s7,610 # 80008978 <userret+0x8e8>
    8000671e:	a821                	j	80006736 <bd_print_vector+0x46>
    lb = b;
    last = bit_isset(vector, b);
    80006720:	85a6                	mv	a1,s1
    80006722:	854e                	mv	a0,s3
    80006724:	00000097          	auipc	ra,0x0
    80006728:	f30080e7          	jalr	-208(ra) # 80006654 <bit_isset>
    8000672c:	892a                	mv	s2,a0
    8000672e:	8aa6                	mv	s5,s1
  for (int b = 0; b < len; b++) {
    80006730:	2485                	addiw	s1,s1,1
    80006732:	029a0463          	beq	s4,s1,8000675a <bd_print_vector+0x6a>
    if (last == bit_isset(vector, b))
    80006736:	85a6                	mv	a1,s1
    80006738:	854e                	mv	a0,s3
    8000673a:	00000097          	auipc	ra,0x0
    8000673e:	f1a080e7          	jalr	-230(ra) # 80006654 <bit_isset>
    80006742:	ff2507e3          	beq	a0,s2,80006730 <bd_print_vector+0x40>
    if(last == 1)
    80006746:	fd691de3          	bne	s2,s6,80006720 <bd_print_vector+0x30>
      printf(" [%d, %d)", lb, b);
    8000674a:	8626                	mv	a2,s1
    8000674c:	85d6                	mv	a1,s5
    8000674e:	855e                	mv	a0,s7
    80006750:	ffffa097          	auipc	ra,0xffffa
    80006754:	e52080e7          	jalr	-430(ra) # 800005a2 <printf>
    80006758:	b7e1                	j	80006720 <bd_print_vector+0x30>
  }
  if(lb == 0 || last == 1) {
    8000675a:	000a8563          	beqz	s5,80006764 <bd_print_vector+0x74>
    8000675e:	4785                	li	a5,1
    80006760:	00f91c63          	bne	s2,a5,80006778 <bd_print_vector+0x88>
    printf(" [%d, %d)", lb, len);
    80006764:	8652                	mv	a2,s4
    80006766:	85d6                	mv	a1,s5
    80006768:	00002517          	auipc	a0,0x2
    8000676c:	21050513          	addi	a0,a0,528 # 80008978 <userret+0x8e8>
    80006770:	ffffa097          	auipc	ra,0xffffa
    80006774:	e32080e7          	jalr	-462(ra) # 800005a2 <printf>
  }
  printf("\n");
    80006778:	00002517          	auipc	a0,0x2
    8000677c:	b1850513          	addi	a0,a0,-1256 # 80008290 <userret+0x200>
    80006780:	ffffa097          	auipc	ra,0xffffa
    80006784:	e22080e7          	jalr	-478(ra) # 800005a2 <printf>
}
    80006788:	60a6                	ld	ra,72(sp)
    8000678a:	6406                	ld	s0,64(sp)
    8000678c:	74e2                	ld	s1,56(sp)
    8000678e:	7942                	ld	s2,48(sp)
    80006790:	79a2                	ld	s3,40(sp)
    80006792:	7a02                	ld	s4,32(sp)
    80006794:	6ae2                	ld	s5,24(sp)
    80006796:	6b42                	ld	s6,16(sp)
    80006798:	6ba2                	ld	s7,8(sp)
    8000679a:	6161                	addi	sp,sp,80
    8000679c:	8082                	ret
  lb = 0;
    8000679e:	4a81                	li	s5,0
    800067a0:	b7d1                	j	80006764 <bd_print_vector+0x74>

00000000800067a2 <bd_print>:

// Print buddy's data structures
void
bd_print() {
  for (int k = 0; k < nsizes; k++) {
    800067a2:	0002a697          	auipc	a3,0x2a
    800067a6:	8b66a683          	lw	a3,-1866(a3) # 80030058 <nsizes>
    800067aa:	10d05063          	blez	a3,800068aa <bd_print+0x108>
bd_print() {
    800067ae:	711d                	addi	sp,sp,-96
    800067b0:	ec86                	sd	ra,88(sp)
    800067b2:	e8a2                	sd	s0,80(sp)
    800067b4:	e4a6                	sd	s1,72(sp)
    800067b6:	e0ca                	sd	s2,64(sp)
    800067b8:	fc4e                	sd	s3,56(sp)
    800067ba:	f852                	sd	s4,48(sp)
    800067bc:	f456                	sd	s5,40(sp)
    800067be:	f05a                	sd	s6,32(sp)
    800067c0:	ec5e                	sd	s7,24(sp)
    800067c2:	e862                	sd	s8,16(sp)
    800067c4:	e466                	sd	s9,8(sp)
    800067c6:	e06a                	sd	s10,0(sp)
    800067c8:	1080                	addi	s0,sp,96
  for (int k = 0; k < nsizes; k++) {
    800067ca:	4481                	li	s1,0
    printf("size %d (blksz %d nblk %d): free list: ", k, BLK_SIZE(k), NBLK(k));
    800067cc:	4a85                	li	s5,1
    800067ce:	4c41                	li	s8,16
    800067d0:	00002b97          	auipc	s7,0x2
    800067d4:	1b8b8b93          	addi	s7,s7,440 # 80008988 <userret+0x8f8>
    lst_print(&bd_sizes[k].free);
    800067d8:	0002aa17          	auipc	s4,0x2a
    800067dc:	878a0a13          	addi	s4,s4,-1928 # 80030050 <bd_sizes>
    printf("  alloc:");
    800067e0:	00002b17          	auipc	s6,0x2
    800067e4:	1d0b0b13          	addi	s6,s6,464 # 800089b0 <userret+0x920>
    bd_print_vector(bd_sizes[k].alloc, NBLK(k));
    800067e8:	0002a997          	auipc	s3,0x2a
    800067ec:	87098993          	addi	s3,s3,-1936 # 80030058 <nsizes>
    if(k > 0) {
      printf("  split:");
    800067f0:	00002c97          	auipc	s9,0x2
    800067f4:	1d0c8c93          	addi	s9,s9,464 # 800089c0 <userret+0x930>
    800067f8:	a801                	j	80006808 <bd_print+0x66>
  for (int k = 0; k < nsizes; k++) {
    800067fa:	0009a683          	lw	a3,0(s3)
    800067fe:	0485                	addi	s1,s1,1
    80006800:	0004879b          	sext.w	a5,s1
    80006804:	08d7d563          	bge	a5,a3,8000688e <bd_print+0xec>
    80006808:	0004891b          	sext.w	s2,s1
    printf("size %d (blksz %d nblk %d): free list: ", k, BLK_SIZE(k), NBLK(k));
    8000680c:	36fd                	addiw	a3,a3,-1
    8000680e:	9e85                	subw	a3,a3,s1
    80006810:	00da96bb          	sllw	a3,s5,a3
    80006814:	009c1633          	sll	a2,s8,s1
    80006818:	85ca                	mv	a1,s2
    8000681a:	855e                	mv	a0,s7
    8000681c:	ffffa097          	auipc	ra,0xffffa
    80006820:	d86080e7          	jalr	-634(ra) # 800005a2 <printf>
    lst_print(&bd_sizes[k].free);
    80006824:	00549d13          	slli	s10,s1,0x5
    80006828:	000a3503          	ld	a0,0(s4)
    8000682c:	956a                	add	a0,a0,s10
    8000682e:	00001097          	auipc	ra,0x1
    80006832:	a56080e7          	jalr	-1450(ra) # 80007284 <lst_print>
    printf("  alloc:");
    80006836:	855a                	mv	a0,s6
    80006838:	ffffa097          	auipc	ra,0xffffa
    8000683c:	d6a080e7          	jalr	-662(ra) # 800005a2 <printf>
    bd_print_vector(bd_sizes[k].alloc, NBLK(k));
    80006840:	0009a583          	lw	a1,0(s3)
    80006844:	35fd                	addiw	a1,a1,-1
    80006846:	412585bb          	subw	a1,a1,s2
    8000684a:	000a3783          	ld	a5,0(s4)
    8000684e:	97ea                	add	a5,a5,s10
    80006850:	00ba95bb          	sllw	a1,s5,a1
    80006854:	6b88                	ld	a0,16(a5)
    80006856:	00000097          	auipc	ra,0x0
    8000685a:	e9a080e7          	jalr	-358(ra) # 800066f0 <bd_print_vector>
    if(k > 0) {
    8000685e:	f9205ee3          	blez	s2,800067fa <bd_print+0x58>
      printf("  split:");
    80006862:	8566                	mv	a0,s9
    80006864:	ffffa097          	auipc	ra,0xffffa
    80006868:	d3e080e7          	jalr	-706(ra) # 800005a2 <printf>
      bd_print_vector(bd_sizes[k].split, NBLK(k));
    8000686c:	0009a583          	lw	a1,0(s3)
    80006870:	35fd                	addiw	a1,a1,-1
    80006872:	412585bb          	subw	a1,a1,s2
    80006876:	000a3783          	ld	a5,0(s4)
    8000687a:	9d3e                	add	s10,s10,a5
    8000687c:	00ba95bb          	sllw	a1,s5,a1
    80006880:	018d3503          	ld	a0,24(s10)
    80006884:	00000097          	auipc	ra,0x0
    80006888:	e6c080e7          	jalr	-404(ra) # 800066f0 <bd_print_vector>
    8000688c:	b7bd                	j	800067fa <bd_print+0x58>
    }
  }
}
    8000688e:	60e6                	ld	ra,88(sp)
    80006890:	6446                	ld	s0,80(sp)
    80006892:	64a6                	ld	s1,72(sp)
    80006894:	6906                	ld	s2,64(sp)
    80006896:	79e2                	ld	s3,56(sp)
    80006898:	7a42                	ld	s4,48(sp)
    8000689a:	7aa2                	ld	s5,40(sp)
    8000689c:	7b02                	ld	s6,32(sp)
    8000689e:	6be2                	ld	s7,24(sp)
    800068a0:	6c42                	ld	s8,16(sp)
    800068a2:	6ca2                	ld	s9,8(sp)
    800068a4:	6d02                	ld	s10,0(sp)
    800068a6:	6125                	addi	sp,sp,96
    800068a8:	8082                	ret
    800068aa:	8082                	ret

00000000800068ac <firstk>:

// What is the first k such that 2^k >= n?
int
firstk(uint64 n) {
    800068ac:	1141                	addi	sp,sp,-16
    800068ae:	e422                	sd	s0,8(sp)
    800068b0:	0800                	addi	s0,sp,16
  int k = 0;
  uint64 size = LEAF_SIZE;

  while (size < n) {
    800068b2:	47c1                	li	a5,16
    800068b4:	00a7fb63          	bgeu	a5,a0,800068ca <firstk+0x1e>
    800068b8:	872a                	mv	a4,a0
  int k = 0;
    800068ba:	4501                	li	a0,0
    k++;
    800068bc:	2505                	addiw	a0,a0,1
    size *= 2;
    800068be:	0786                	slli	a5,a5,0x1
  while (size < n) {
    800068c0:	fee7eee3          	bltu	a5,a4,800068bc <firstk+0x10>
  }
  return k;
}
    800068c4:	6422                	ld	s0,8(sp)
    800068c6:	0141                	addi	sp,sp,16
    800068c8:	8082                	ret
  int k = 0;
    800068ca:	4501                	li	a0,0
    800068cc:	bfe5                	j	800068c4 <firstk+0x18>

00000000800068ce <blk_index>:

// Compute the block index for address p at size k
int
blk_index(int k, char *p) {
    800068ce:	1141                	addi	sp,sp,-16
    800068d0:	e422                	sd	s0,8(sp)
    800068d2:	0800                	addi	s0,sp,16
  int n = p - (char *) bd_base;
  return n / BLK_SIZE(k);
    800068d4:	00029797          	auipc	a5,0x29
    800068d8:	7747b783          	ld	a5,1908(a5) # 80030048 <bd_base>
    800068dc:	9d9d                	subw	a1,a1,a5
    800068de:	47c1                	li	a5,16
    800068e0:	00a797b3          	sll	a5,a5,a0
    800068e4:	02f5c5b3          	div	a1,a1,a5
}
    800068e8:	0005851b          	sext.w	a0,a1
    800068ec:	6422                	ld	s0,8(sp)
    800068ee:	0141                	addi	sp,sp,16
    800068f0:	8082                	ret

00000000800068f2 <addr>:

// Convert a block index at size k back into an address
void *addr(int k, int bi) {
    800068f2:	1141                	addi	sp,sp,-16
    800068f4:	e422                	sd	s0,8(sp)
    800068f6:	0800                	addi	s0,sp,16
  int n = bi * BLK_SIZE(k);
    800068f8:	47c1                	li	a5,16
    800068fa:	00a797b3          	sll	a5,a5,a0
  return (char *) bd_base + n;
    800068fe:	02b787bb          	mulw	a5,a5,a1
}
    80006902:	00029517          	auipc	a0,0x29
    80006906:	74653503          	ld	a0,1862(a0) # 80030048 <bd_base>
    8000690a:	953e                	add	a0,a0,a5
    8000690c:	6422                	ld	s0,8(sp)
    8000690e:	0141                	addi	sp,sp,16
    80006910:	8082                	ret

0000000080006912 <bd_malloc>:

// allocate nbytes, but malloc won't return anything smaller than LEAF_SIZE
void *
bd_malloc(uint64 nbytes)
{
    80006912:	7159                	addi	sp,sp,-112
    80006914:	f486                	sd	ra,104(sp)
    80006916:	f0a2                	sd	s0,96(sp)
    80006918:	eca6                	sd	s1,88(sp)
    8000691a:	e8ca                	sd	s2,80(sp)
    8000691c:	e4ce                	sd	s3,72(sp)
    8000691e:	e0d2                	sd	s4,64(sp)
    80006920:	fc56                	sd	s5,56(sp)
    80006922:	f85a                	sd	s6,48(sp)
    80006924:	f45e                	sd	s7,40(sp)
    80006926:	f062                	sd	s8,32(sp)
    80006928:	ec66                	sd	s9,24(sp)
    8000692a:	e86a                	sd	s10,16(sp)
    8000692c:	e46e                	sd	s11,8(sp)
    8000692e:	1880                	addi	s0,sp,112
    80006930:	84aa                	mv	s1,a0
  int fk, k;

  acquire(&lock);
    80006932:	00029517          	auipc	a0,0x29
    80006936:	6ce50513          	addi	a0,a0,1742 # 80030000 <lock>
    8000693a:	ffffa097          	auipc	ra,0xffffa
    8000693e:	2f0080e7          	jalr	752(ra) # 80000c2a <acquire>

  // Find a free block >= nbytes, starting with smallest k possible
  fk = firstk(nbytes);
    80006942:	8526                	mv	a0,s1
    80006944:	00000097          	auipc	ra,0x0
    80006948:	f68080e7          	jalr	-152(ra) # 800068ac <firstk>
  for (k = fk; k < nsizes; k++) {
    8000694c:	00029797          	auipc	a5,0x29
    80006950:	70c7a783          	lw	a5,1804(a5) # 80030058 <nsizes>
    80006954:	02f55d63          	bge	a0,a5,8000698e <bd_malloc+0x7c>
    80006958:	8c2a                	mv	s8,a0
    8000695a:	00551913          	slli	s2,a0,0x5
    8000695e:	84aa                	mv	s1,a0
    if(!lst_empty(&bd_sizes[k].free))
    80006960:	00029997          	auipc	s3,0x29
    80006964:	6f098993          	addi	s3,s3,1776 # 80030050 <bd_sizes>
  for (k = fk; k < nsizes; k++) {
    80006968:	00029a17          	auipc	s4,0x29
    8000696c:	6f0a0a13          	addi	s4,s4,1776 # 80030058 <nsizes>
    if(!lst_empty(&bd_sizes[k].free))
    80006970:	0009b503          	ld	a0,0(s3)
    80006974:	954a                	add	a0,a0,s2
    80006976:	00001097          	auipc	ra,0x1
    8000697a:	894080e7          	jalr	-1900(ra) # 8000720a <lst_empty>
    8000697e:	c115                	beqz	a0,800069a2 <bd_malloc+0x90>
  for (k = fk; k < nsizes; k++) {
    80006980:	2485                	addiw	s1,s1,1
    80006982:	02090913          	addi	s2,s2,32
    80006986:	000a2783          	lw	a5,0(s4)
    8000698a:	fef4c3e3          	blt	s1,a5,80006970 <bd_malloc+0x5e>
      break;
  }
  if(k >= nsizes) { // No free blocks?
    release(&lock);
    8000698e:	00029517          	auipc	a0,0x29
    80006992:	67250513          	addi	a0,a0,1650 # 80030000 <lock>
    80006996:	ffffa097          	auipc	ra,0xffffa
    8000699a:	304080e7          	jalr	772(ra) # 80000c9a <release>
    return 0;
    8000699e:	4b01                	li	s6,0
    800069a0:	a0e1                	j	80006a68 <bd_malloc+0x156>
  if(k >= nsizes) { // No free blocks?
    800069a2:	00029797          	auipc	a5,0x29
    800069a6:	6b67a783          	lw	a5,1718(a5) # 80030058 <nsizes>
    800069aa:	fef4d2e3          	bge	s1,a5,8000698e <bd_malloc+0x7c>
  }

  // Found a block; pop it and potentially split it.
  char *p = lst_pop(&bd_sizes[k].free);
    800069ae:	00549993          	slli	s3,s1,0x5
    800069b2:	00029917          	auipc	s2,0x29
    800069b6:	69e90913          	addi	s2,s2,1694 # 80030050 <bd_sizes>
    800069ba:	00093503          	ld	a0,0(s2)
    800069be:	954e                	add	a0,a0,s3
    800069c0:	00001097          	auipc	ra,0x1
    800069c4:	876080e7          	jalr	-1930(ra) # 80007236 <lst_pop>
    800069c8:	8b2a                	mv	s6,a0
  return n / BLK_SIZE(k);
    800069ca:	00029597          	auipc	a1,0x29
    800069ce:	67e5b583          	ld	a1,1662(a1) # 80030048 <bd_base>
    800069d2:	40b505bb          	subw	a1,a0,a1
    800069d6:	47c1                	li	a5,16
    800069d8:	009797b3          	sll	a5,a5,s1
    800069dc:	02f5c5b3          	div	a1,a1,a5
  bit_set(bd_sizes[k].alloc, blk_index(k, p));
    800069e0:	00093783          	ld	a5,0(s2)
    800069e4:	97ce                	add	a5,a5,s3
    800069e6:	2581                	sext.w	a1,a1
    800069e8:	6b88                	ld	a0,16(a5)
    800069ea:	00000097          	auipc	ra,0x0
    800069ee:	ca2080e7          	jalr	-862(ra) # 8000668c <bit_set>
  for(; k > fk; k--) {
    800069f2:	069c5363          	bge	s8,s1,80006a58 <bd_malloc+0x146>
    // split a block at size k and mark one half allocated at size k-1
    // and put the buddy on the free list at size k-1
    char *q = p + BLK_SIZE(k-1);   // p's buddy
    800069f6:	4bc1                	li	s7,16
    bit_set(bd_sizes[k].split, blk_index(k, p));
    800069f8:	8dca                	mv	s11,s2
  int n = p - (char *) bd_base;
    800069fa:	00029d17          	auipc	s10,0x29
    800069fe:	64ed0d13          	addi	s10,s10,1614 # 80030048 <bd_base>
    char *q = p + BLK_SIZE(k-1);   // p's buddy
    80006a02:	85a6                	mv	a1,s1
    80006a04:	34fd                	addiw	s1,s1,-1
    80006a06:	009b9ab3          	sll	s5,s7,s1
    80006a0a:	015b0cb3          	add	s9,s6,s5
    bit_set(bd_sizes[k].split, blk_index(k, p));
    80006a0e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
  int n = p - (char *) bd_base;
    80006a12:	000d3903          	ld	s2,0(s10)
  return n / BLK_SIZE(k);
    80006a16:	412b093b          	subw	s2,s6,s2
    80006a1a:	00bb95b3          	sll	a1,s7,a1
    80006a1e:	02b945b3          	div	a1,s2,a1
    bit_set(bd_sizes[k].split, blk_index(k, p));
    80006a22:	013a07b3          	add	a5,s4,s3
    80006a26:	2581                	sext.w	a1,a1
    80006a28:	6f88                	ld	a0,24(a5)
    80006a2a:	00000097          	auipc	ra,0x0
    80006a2e:	c62080e7          	jalr	-926(ra) # 8000668c <bit_set>
    bit_set(bd_sizes[k-1].alloc, blk_index(k-1, p));
    80006a32:	1981                	addi	s3,s3,-32
    80006a34:	9a4e                	add	s4,s4,s3
  return n / BLK_SIZE(k);
    80006a36:	035945b3          	div	a1,s2,s5
    bit_set(bd_sizes[k-1].alloc, blk_index(k-1, p));
    80006a3a:	2581                	sext.w	a1,a1
    80006a3c:	010a3503          	ld	a0,16(s4)
    80006a40:	00000097          	auipc	ra,0x0
    80006a44:	c4c080e7          	jalr	-948(ra) # 8000668c <bit_set>
    lst_push(&bd_sizes[k-1].free, q);
    80006a48:	85e6                	mv	a1,s9
    80006a4a:	8552                	mv	a0,s4
    80006a4c:	00001097          	auipc	ra,0x1
    80006a50:	820080e7          	jalr	-2016(ra) # 8000726c <lst_push>
  for(; k > fk; k--) {
    80006a54:	fb8497e3          	bne	s1,s8,80006a02 <bd_malloc+0xf0>
  }
  release(&lock);
    80006a58:	00029517          	auipc	a0,0x29
    80006a5c:	5a850513          	addi	a0,a0,1448 # 80030000 <lock>
    80006a60:	ffffa097          	auipc	ra,0xffffa
    80006a64:	23a080e7          	jalr	570(ra) # 80000c9a <release>

  return p;
}
    80006a68:	855a                	mv	a0,s6
    80006a6a:	70a6                	ld	ra,104(sp)
    80006a6c:	7406                	ld	s0,96(sp)
    80006a6e:	64e6                	ld	s1,88(sp)
    80006a70:	6946                	ld	s2,80(sp)
    80006a72:	69a6                	ld	s3,72(sp)
    80006a74:	6a06                	ld	s4,64(sp)
    80006a76:	7ae2                	ld	s5,56(sp)
    80006a78:	7b42                	ld	s6,48(sp)
    80006a7a:	7ba2                	ld	s7,40(sp)
    80006a7c:	7c02                	ld	s8,32(sp)
    80006a7e:	6ce2                	ld	s9,24(sp)
    80006a80:	6d42                	ld	s10,16(sp)
    80006a82:	6da2                	ld	s11,8(sp)
    80006a84:	6165                	addi	sp,sp,112
    80006a86:	8082                	ret

0000000080006a88 <size>:

// Find the size of the block that p points to.
int
size(char *p) {
    80006a88:	7139                	addi	sp,sp,-64
    80006a8a:	fc06                	sd	ra,56(sp)
    80006a8c:	f822                	sd	s0,48(sp)
    80006a8e:	f426                	sd	s1,40(sp)
    80006a90:	f04a                	sd	s2,32(sp)
    80006a92:	ec4e                	sd	s3,24(sp)
    80006a94:	e852                	sd	s4,16(sp)
    80006a96:	e456                	sd	s5,8(sp)
    80006a98:	e05a                	sd	s6,0(sp)
    80006a9a:	0080                	addi	s0,sp,64
  for (int k = 0; k < nsizes; k++) {
    80006a9c:	00029a97          	auipc	s5,0x29
    80006aa0:	5bcaaa83          	lw	s5,1468(s5) # 80030058 <nsizes>
  return n / BLK_SIZE(k);
    80006aa4:	00029a17          	auipc	s4,0x29
    80006aa8:	5a4a3a03          	ld	s4,1444(s4) # 80030048 <bd_base>
    80006aac:	41450a3b          	subw	s4,a0,s4
    80006ab0:	00029497          	auipc	s1,0x29
    80006ab4:	5a04b483          	ld	s1,1440(s1) # 80030050 <bd_sizes>
    80006ab8:	03848493          	addi	s1,s1,56
  for (int k = 0; k < nsizes; k++) {
    80006abc:	4901                	li	s2,0
  return n / BLK_SIZE(k);
    80006abe:	4b41                	li	s6,16
  for (int k = 0; k < nsizes; k++) {
    80006ac0:	03595363          	bge	s2,s5,80006ae6 <size+0x5e>
    if(bit_isset(bd_sizes[k+1].split, blk_index(k+1, p))) {
    80006ac4:	0019099b          	addiw	s3,s2,1
  return n / BLK_SIZE(k);
    80006ac8:	013b15b3          	sll	a1,s6,s3
    80006acc:	02ba45b3          	div	a1,s4,a1
    if(bit_isset(bd_sizes[k+1].split, blk_index(k+1, p))) {
    80006ad0:	2581                	sext.w	a1,a1
    80006ad2:	6088                	ld	a0,0(s1)
    80006ad4:	00000097          	auipc	ra,0x0
    80006ad8:	b80080e7          	jalr	-1152(ra) # 80006654 <bit_isset>
    80006adc:	02048493          	addi	s1,s1,32
    80006ae0:	e501                	bnez	a0,80006ae8 <size+0x60>
  for (int k = 0; k < nsizes; k++) {
    80006ae2:	894e                	mv	s2,s3
    80006ae4:	bff1                	j	80006ac0 <size+0x38>
      return k;
    }
  }
  return 0;
    80006ae6:	4901                	li	s2,0
}
    80006ae8:	854a                	mv	a0,s2
    80006aea:	70e2                	ld	ra,56(sp)
    80006aec:	7442                	ld	s0,48(sp)
    80006aee:	74a2                	ld	s1,40(sp)
    80006af0:	7902                	ld	s2,32(sp)
    80006af2:	69e2                	ld	s3,24(sp)
    80006af4:	6a42                	ld	s4,16(sp)
    80006af6:	6aa2                	ld	s5,8(sp)
    80006af8:	6b02                	ld	s6,0(sp)
    80006afa:	6121                	addi	sp,sp,64
    80006afc:	8082                	ret

0000000080006afe <bd_free>:

// Free memory pointed to by p, which was earlier allocated using
// bd_malloc.
void
bd_free(void *p) {
    80006afe:	7159                	addi	sp,sp,-112
    80006b00:	f486                	sd	ra,104(sp)
    80006b02:	f0a2                	sd	s0,96(sp)
    80006b04:	eca6                	sd	s1,88(sp)
    80006b06:	e8ca                	sd	s2,80(sp)
    80006b08:	e4ce                	sd	s3,72(sp)
    80006b0a:	e0d2                	sd	s4,64(sp)
    80006b0c:	fc56                	sd	s5,56(sp)
    80006b0e:	f85a                	sd	s6,48(sp)
    80006b10:	f45e                	sd	s7,40(sp)
    80006b12:	f062                	sd	s8,32(sp)
    80006b14:	ec66                	sd	s9,24(sp)
    80006b16:	e86a                	sd	s10,16(sp)
    80006b18:	e46e                	sd	s11,8(sp)
    80006b1a:	1880                	addi	s0,sp,112
    80006b1c:	8aaa                	mv	s5,a0
  void *q;
  int k;

  acquire(&lock);
    80006b1e:	00029517          	auipc	a0,0x29
    80006b22:	4e250513          	addi	a0,a0,1250 # 80030000 <lock>
    80006b26:	ffffa097          	auipc	ra,0xffffa
    80006b2a:	104080e7          	jalr	260(ra) # 80000c2a <acquire>
  for (k = size(p); k < MAXSIZE; k++) {
    80006b2e:	8556                	mv	a0,s5
    80006b30:	00000097          	auipc	ra,0x0
    80006b34:	f58080e7          	jalr	-168(ra) # 80006a88 <size>
    80006b38:	84aa                	mv	s1,a0
    80006b3a:	00029797          	auipc	a5,0x29
    80006b3e:	51e7a783          	lw	a5,1310(a5) # 80030058 <nsizes>
    80006b42:	37fd                	addiw	a5,a5,-1
    80006b44:	0cf55063          	bge	a0,a5,80006c04 <bd_free+0x106>
    80006b48:	00150a13          	addi	s4,a0,1
    80006b4c:	0a16                	slli	s4,s4,0x5
  int n = p - (char *) bd_base;
    80006b4e:	00029c17          	auipc	s8,0x29
    80006b52:	4fac0c13          	addi	s8,s8,1274 # 80030048 <bd_base>
  return n / BLK_SIZE(k);
    80006b56:	4bc1                	li	s7,16
    int bi = blk_index(k, p);
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    bit_clear(bd_sizes[k].alloc, bi);  // free p at size k
    80006b58:	00029b17          	auipc	s6,0x29
    80006b5c:	4f8b0b13          	addi	s6,s6,1272 # 80030050 <bd_sizes>
  for (k = size(p); k < MAXSIZE; k++) {
    80006b60:	00029c97          	auipc	s9,0x29
    80006b64:	4f8c8c93          	addi	s9,s9,1272 # 80030058 <nsizes>
    80006b68:	a82d                	j	80006ba2 <bd_free+0xa4>
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80006b6a:	fff58d9b          	addiw	s11,a1,-1
    80006b6e:	a881                	j	80006bbe <bd_free+0xc0>
    if(buddy % 2 == 0) {
      p = q;
    }
    // at size k+1, mark that the merged buddy pair isn't split
    // anymore
    bit_clear(bd_sizes[k+1].split, blk_index(k+1, p));
    80006b70:	2485                	addiw	s1,s1,1
  int n = p - (char *) bd_base;
    80006b72:	000c3583          	ld	a1,0(s8)
  return n / BLK_SIZE(k);
    80006b76:	40ba85bb          	subw	a1,s5,a1
    80006b7a:	009b97b3          	sll	a5,s7,s1
    80006b7e:	02f5c5b3          	div	a1,a1,a5
    bit_clear(bd_sizes[k+1].split, blk_index(k+1, p));
    80006b82:	000b3783          	ld	a5,0(s6)
    80006b86:	97d2                	add	a5,a5,s4
    80006b88:	2581                	sext.w	a1,a1
    80006b8a:	6f88                	ld	a0,24(a5)
    80006b8c:	00000097          	auipc	ra,0x0
    80006b90:	b30080e7          	jalr	-1232(ra) # 800066bc <bit_clear>
  for (k = size(p); k < MAXSIZE; k++) {
    80006b94:	020a0a13          	addi	s4,s4,32
    80006b98:	000ca783          	lw	a5,0(s9)
    80006b9c:	37fd                	addiw	a5,a5,-1
    80006b9e:	06f4d363          	bge	s1,a5,80006c04 <bd_free+0x106>
  int n = p - (char *) bd_base;
    80006ba2:	000c3903          	ld	s2,0(s8)
  return n / BLK_SIZE(k);
    80006ba6:	009b99b3          	sll	s3,s7,s1
    80006baa:	412a87bb          	subw	a5,s5,s2
    80006bae:	0337c7b3          	div	a5,a5,s3
    80006bb2:	0007859b          	sext.w	a1,a5
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80006bb6:	8b85                	andi	a5,a5,1
    80006bb8:	fbcd                	bnez	a5,80006b6a <bd_free+0x6c>
    80006bba:	00158d9b          	addiw	s11,a1,1
    bit_clear(bd_sizes[k].alloc, bi);  // free p at size k
    80006bbe:	fe0a0d13          	addi	s10,s4,-32
    80006bc2:	000b3783          	ld	a5,0(s6)
    80006bc6:	9d3e                	add	s10,s10,a5
    80006bc8:	010d3503          	ld	a0,16(s10)
    80006bcc:	00000097          	auipc	ra,0x0
    80006bd0:	af0080e7          	jalr	-1296(ra) # 800066bc <bit_clear>
    if (bit_isset(bd_sizes[k].alloc, buddy)) {  // is buddy allocated?
    80006bd4:	85ee                	mv	a1,s11
    80006bd6:	010d3503          	ld	a0,16(s10)
    80006bda:	00000097          	auipc	ra,0x0
    80006bde:	a7a080e7          	jalr	-1414(ra) # 80006654 <bit_isset>
    80006be2:	e10d                	bnez	a0,80006c04 <bd_free+0x106>
  int n = bi * BLK_SIZE(k);
    80006be4:	000d8d1b          	sext.w	s10,s11
  return (char *) bd_base + n;
    80006be8:	03b989bb          	mulw	s3,s3,s11
    80006bec:	994e                	add	s2,s2,s3
    lst_remove(q);    // remove buddy from free list
    80006bee:	854a                	mv	a0,s2
    80006bf0:	00000097          	auipc	ra,0x0
    80006bf4:	630080e7          	jalr	1584(ra) # 80007220 <lst_remove>
    if(buddy % 2 == 0) {
    80006bf8:	001d7d13          	andi	s10,s10,1
    80006bfc:	f60d1ae3          	bnez	s10,80006b70 <bd_free+0x72>
      p = q;
    80006c00:	8aca                	mv	s5,s2
    80006c02:	b7bd                	j	80006b70 <bd_free+0x72>
  }
  lst_push(&bd_sizes[k].free, p);
    80006c04:	0496                	slli	s1,s1,0x5
    80006c06:	85d6                	mv	a1,s5
    80006c08:	00029517          	auipc	a0,0x29
    80006c0c:	44853503          	ld	a0,1096(a0) # 80030050 <bd_sizes>
    80006c10:	9526                	add	a0,a0,s1
    80006c12:	00000097          	auipc	ra,0x0
    80006c16:	65a080e7          	jalr	1626(ra) # 8000726c <lst_push>
  release(&lock);
    80006c1a:	00029517          	auipc	a0,0x29
    80006c1e:	3e650513          	addi	a0,a0,998 # 80030000 <lock>
    80006c22:	ffffa097          	auipc	ra,0xffffa
    80006c26:	078080e7          	jalr	120(ra) # 80000c9a <release>
}
    80006c2a:	70a6                	ld	ra,104(sp)
    80006c2c:	7406                	ld	s0,96(sp)
    80006c2e:	64e6                	ld	s1,88(sp)
    80006c30:	6946                	ld	s2,80(sp)
    80006c32:	69a6                	ld	s3,72(sp)
    80006c34:	6a06                	ld	s4,64(sp)
    80006c36:	7ae2                	ld	s5,56(sp)
    80006c38:	7b42                	ld	s6,48(sp)
    80006c3a:	7ba2                	ld	s7,40(sp)
    80006c3c:	7c02                	ld	s8,32(sp)
    80006c3e:	6ce2                	ld	s9,24(sp)
    80006c40:	6d42                	ld	s10,16(sp)
    80006c42:	6da2                	ld	s11,8(sp)
    80006c44:	6165                	addi	sp,sp,112
    80006c46:	8082                	ret

0000000080006c48 <blk_index_next>:

// Compute the first block at size k that doesn't contain p
int
blk_index_next(int k, char *p) {
    80006c48:	1141                	addi	sp,sp,-16
    80006c4a:	e422                	sd	s0,8(sp)
    80006c4c:	0800                	addi	s0,sp,16
  int n = (p - (char *) bd_base) / BLK_SIZE(k);
    80006c4e:	00029797          	auipc	a5,0x29
    80006c52:	3fa7b783          	ld	a5,1018(a5) # 80030048 <bd_base>
    80006c56:	8d9d                	sub	a1,a1,a5
    80006c58:	47c1                	li	a5,16
    80006c5a:	00a797b3          	sll	a5,a5,a0
    80006c5e:	02f5c533          	div	a0,a1,a5
    80006c62:	2501                	sext.w	a0,a0
  if((p - (char*) bd_base) % BLK_SIZE(k) != 0)
    80006c64:	02f5e5b3          	rem	a1,a1,a5
    80006c68:	c191                	beqz	a1,80006c6c <blk_index_next+0x24>
      n++;
    80006c6a:	2505                	addiw	a0,a0,1
  return n ;
}
    80006c6c:	6422                	ld	s0,8(sp)
    80006c6e:	0141                	addi	sp,sp,16
    80006c70:	8082                	ret

0000000080006c72 <log2>:

int
log2(uint64 n) {
    80006c72:	1141                	addi	sp,sp,-16
    80006c74:	e422                	sd	s0,8(sp)
    80006c76:	0800                	addi	s0,sp,16
  int k = 0;
  while (n > 1) {
    80006c78:	4705                	li	a4,1
    80006c7a:	00a77b63          	bgeu	a4,a0,80006c90 <log2+0x1e>
    80006c7e:	87aa                	mv	a5,a0
  int k = 0;
    80006c80:	4501                	li	a0,0
    k++;
    80006c82:	2505                	addiw	a0,a0,1
    n = n >> 1;
    80006c84:	8385                	srli	a5,a5,0x1
  while (n > 1) {
    80006c86:	fef76ee3          	bltu	a4,a5,80006c82 <log2+0x10>
  }
  return k;
}
    80006c8a:	6422                	ld	s0,8(sp)
    80006c8c:	0141                	addi	sp,sp,16
    80006c8e:	8082                	ret
  int k = 0;
    80006c90:	4501                	li	a0,0
    80006c92:	bfe5                	j	80006c8a <log2+0x18>

0000000080006c94 <bd_mark>:

// Mark memory from [start, stop), starting at size 0, as allocated. 
void
bd_mark(void *start, void *stop)
{
    80006c94:	711d                	addi	sp,sp,-96
    80006c96:	ec86                	sd	ra,88(sp)
    80006c98:	e8a2                	sd	s0,80(sp)
    80006c9a:	e4a6                	sd	s1,72(sp)
    80006c9c:	e0ca                	sd	s2,64(sp)
    80006c9e:	fc4e                	sd	s3,56(sp)
    80006ca0:	f852                	sd	s4,48(sp)
    80006ca2:	f456                	sd	s5,40(sp)
    80006ca4:	f05a                	sd	s6,32(sp)
    80006ca6:	ec5e                	sd	s7,24(sp)
    80006ca8:	e862                	sd	s8,16(sp)
    80006caa:	e466                	sd	s9,8(sp)
    80006cac:	e06a                	sd	s10,0(sp)
    80006cae:	1080                	addi	s0,sp,96
  int bi, bj;

  if (((uint64) start % LEAF_SIZE != 0) || ((uint64) stop % LEAF_SIZE != 0))
    80006cb0:	00b56933          	or	s2,a0,a1
    80006cb4:	00f97913          	andi	s2,s2,15
    80006cb8:	04091263          	bnez	s2,80006cfc <bd_mark+0x68>
    80006cbc:	8b2a                	mv	s6,a0
    80006cbe:	8bae                	mv	s7,a1
    panic("bd_mark");

  for (int k = 0; k < nsizes; k++) {
    80006cc0:	00029c17          	auipc	s8,0x29
    80006cc4:	398c2c03          	lw	s8,920(s8) # 80030058 <nsizes>
    80006cc8:	4981                	li	s3,0
  int n = p - (char *) bd_base;
    80006cca:	00029d17          	auipc	s10,0x29
    80006cce:	37ed0d13          	addi	s10,s10,894 # 80030048 <bd_base>
  return n / BLK_SIZE(k);
    80006cd2:	4cc1                	li	s9,16
    bi = blk_index(k, start);
    bj = blk_index_next(k, stop);
    for(; bi < bj; bi++) {
      if(k > 0) {
        // if a block is allocated at size k, mark it as split too.
        bit_set(bd_sizes[k].split, bi);
    80006cd4:	00029a97          	auipc	s5,0x29
    80006cd8:	37ca8a93          	addi	s5,s5,892 # 80030050 <bd_sizes>
  for (int k = 0; k < nsizes; k++) {
    80006cdc:	07804563          	bgtz	s8,80006d46 <bd_mark+0xb2>
      }
      bit_set(bd_sizes[k].alloc, bi);
    }
  }
}
    80006ce0:	60e6                	ld	ra,88(sp)
    80006ce2:	6446                	ld	s0,80(sp)
    80006ce4:	64a6                	ld	s1,72(sp)
    80006ce6:	6906                	ld	s2,64(sp)
    80006ce8:	79e2                	ld	s3,56(sp)
    80006cea:	7a42                	ld	s4,48(sp)
    80006cec:	7aa2                	ld	s5,40(sp)
    80006cee:	7b02                	ld	s6,32(sp)
    80006cf0:	6be2                	ld	s7,24(sp)
    80006cf2:	6c42                	ld	s8,16(sp)
    80006cf4:	6ca2                	ld	s9,8(sp)
    80006cf6:	6d02                	ld	s10,0(sp)
    80006cf8:	6125                	addi	sp,sp,96
    80006cfa:	8082                	ret
    panic("bd_mark");
    80006cfc:	00002517          	auipc	a0,0x2
    80006d00:	cd450513          	addi	a0,a0,-812 # 800089d0 <userret+0x940>
    80006d04:	ffffa097          	auipc	ra,0xffffa
    80006d08:	844080e7          	jalr	-1980(ra) # 80000548 <panic>
      bit_set(bd_sizes[k].alloc, bi);
    80006d0c:	000ab783          	ld	a5,0(s5)
    80006d10:	97ca                	add	a5,a5,s2
    80006d12:	85a6                	mv	a1,s1
    80006d14:	6b88                	ld	a0,16(a5)
    80006d16:	00000097          	auipc	ra,0x0
    80006d1a:	976080e7          	jalr	-1674(ra) # 8000668c <bit_set>
    for(; bi < bj; bi++) {
    80006d1e:	2485                	addiw	s1,s1,1
    80006d20:	009a0e63          	beq	s4,s1,80006d3c <bd_mark+0xa8>
      if(k > 0) {
    80006d24:	ff3054e3          	blez	s3,80006d0c <bd_mark+0x78>
        bit_set(bd_sizes[k].split, bi);
    80006d28:	000ab783          	ld	a5,0(s5)
    80006d2c:	97ca                	add	a5,a5,s2
    80006d2e:	85a6                	mv	a1,s1
    80006d30:	6f88                	ld	a0,24(a5)
    80006d32:	00000097          	auipc	ra,0x0
    80006d36:	95a080e7          	jalr	-1702(ra) # 8000668c <bit_set>
    80006d3a:	bfc9                	j	80006d0c <bd_mark+0x78>
  for (int k = 0; k < nsizes; k++) {
    80006d3c:	2985                	addiw	s3,s3,1
    80006d3e:	02090913          	addi	s2,s2,32
    80006d42:	f9898fe3          	beq	s3,s8,80006ce0 <bd_mark+0x4c>
  int n = p - (char *) bd_base;
    80006d46:	000d3483          	ld	s1,0(s10)
  return n / BLK_SIZE(k);
    80006d4a:	409b04bb          	subw	s1,s6,s1
    80006d4e:	013c97b3          	sll	a5,s9,s3
    80006d52:	02f4c4b3          	div	s1,s1,a5
    80006d56:	2481                	sext.w	s1,s1
    bj = blk_index_next(k, stop);
    80006d58:	85de                	mv	a1,s7
    80006d5a:	854e                	mv	a0,s3
    80006d5c:	00000097          	auipc	ra,0x0
    80006d60:	eec080e7          	jalr	-276(ra) # 80006c48 <blk_index_next>
    80006d64:	8a2a                	mv	s4,a0
    for(; bi < bj; bi++) {
    80006d66:	faa4cfe3          	blt	s1,a0,80006d24 <bd_mark+0x90>
    80006d6a:	bfc9                	j	80006d3c <bd_mark+0xa8>

0000000080006d6c <bd_initfree_pair>:

// If a block is marked as allocated and the buddy is free, put the
// buddy on the free list at size k.
int
bd_initfree_pair(int k, int bi) {
    80006d6c:	7139                	addi	sp,sp,-64
    80006d6e:	fc06                	sd	ra,56(sp)
    80006d70:	f822                	sd	s0,48(sp)
    80006d72:	f426                	sd	s1,40(sp)
    80006d74:	f04a                	sd	s2,32(sp)
    80006d76:	ec4e                	sd	s3,24(sp)
    80006d78:	e852                	sd	s4,16(sp)
    80006d7a:	e456                	sd	s5,8(sp)
    80006d7c:	e05a                	sd	s6,0(sp)
    80006d7e:	0080                	addi	s0,sp,64
    80006d80:	89aa                	mv	s3,a0
  int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80006d82:	00058a9b          	sext.w	s5,a1
    80006d86:	0015f793          	andi	a5,a1,1
    80006d8a:	ebad                	bnez	a5,80006dfc <bd_initfree_pair+0x90>
    80006d8c:	00158a1b          	addiw	s4,a1,1
  int free = 0;
  if(bit_isset(bd_sizes[k].alloc, bi) !=  bit_isset(bd_sizes[k].alloc, buddy)) {
    80006d90:	00599493          	slli	s1,s3,0x5
    80006d94:	00029797          	auipc	a5,0x29
    80006d98:	2bc7b783          	ld	a5,700(a5) # 80030050 <bd_sizes>
    80006d9c:	94be                	add	s1,s1,a5
    80006d9e:	0104bb03          	ld	s6,16(s1)
    80006da2:	855a                	mv	a0,s6
    80006da4:	00000097          	auipc	ra,0x0
    80006da8:	8b0080e7          	jalr	-1872(ra) # 80006654 <bit_isset>
    80006dac:	892a                	mv	s2,a0
    80006dae:	85d2                	mv	a1,s4
    80006db0:	855a                	mv	a0,s6
    80006db2:	00000097          	auipc	ra,0x0
    80006db6:	8a2080e7          	jalr	-1886(ra) # 80006654 <bit_isset>
  int free = 0;
    80006dba:	4b01                	li	s6,0
  if(bit_isset(bd_sizes[k].alloc, bi) !=  bit_isset(bd_sizes[k].alloc, buddy)) {
    80006dbc:	02a90563          	beq	s2,a0,80006de6 <bd_initfree_pair+0x7a>
    // one of the pair is free
    free = BLK_SIZE(k);
    80006dc0:	45c1                	li	a1,16
    80006dc2:	013599b3          	sll	s3,a1,s3
    80006dc6:	00098b1b          	sext.w	s6,s3
    if(bit_isset(bd_sizes[k].alloc, bi))
    80006dca:	02090c63          	beqz	s2,80006e02 <bd_initfree_pair+0x96>
  return (char *) bd_base + n;
    80006dce:	034989bb          	mulw	s3,s3,s4
      lst_push(&bd_sizes[k].free, addr(k, buddy));   // put buddy on free list
    80006dd2:	00029597          	auipc	a1,0x29
    80006dd6:	2765b583          	ld	a1,630(a1) # 80030048 <bd_base>
    80006dda:	95ce                	add	a1,a1,s3
    80006ddc:	8526                	mv	a0,s1
    80006dde:	00000097          	auipc	ra,0x0
    80006de2:	48e080e7          	jalr	1166(ra) # 8000726c <lst_push>
    else
      lst_push(&bd_sizes[k].free, addr(k, bi));      // put bi on free list
  }
  return free;
}
    80006de6:	855a                	mv	a0,s6
    80006de8:	70e2                	ld	ra,56(sp)
    80006dea:	7442                	ld	s0,48(sp)
    80006dec:	74a2                	ld	s1,40(sp)
    80006dee:	7902                	ld	s2,32(sp)
    80006df0:	69e2                	ld	s3,24(sp)
    80006df2:	6a42                	ld	s4,16(sp)
    80006df4:	6aa2                	ld	s5,8(sp)
    80006df6:	6b02                	ld	s6,0(sp)
    80006df8:	6121                	addi	sp,sp,64
    80006dfa:	8082                	ret
  int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80006dfc:	fff58a1b          	addiw	s4,a1,-1
    80006e00:	bf41                	j	80006d90 <bd_initfree_pair+0x24>
  return (char *) bd_base + n;
    80006e02:	035989bb          	mulw	s3,s3,s5
      lst_push(&bd_sizes[k].free, addr(k, bi));      // put bi on free list
    80006e06:	00029597          	auipc	a1,0x29
    80006e0a:	2425b583          	ld	a1,578(a1) # 80030048 <bd_base>
    80006e0e:	95ce                	add	a1,a1,s3
    80006e10:	8526                	mv	a0,s1
    80006e12:	00000097          	auipc	ra,0x0
    80006e16:	45a080e7          	jalr	1114(ra) # 8000726c <lst_push>
    80006e1a:	b7f1                	j	80006de6 <bd_initfree_pair+0x7a>

0000000080006e1c <bd_initfree>:
  
// Initialize the free lists for each size k.  For each size k, there
// are only two pairs that may have a buddy that should be on free list:
// bd_left and bd_right.
int
bd_initfree(void *bd_left, void *bd_right) {
    80006e1c:	711d                	addi	sp,sp,-96
    80006e1e:	ec86                	sd	ra,88(sp)
    80006e20:	e8a2                	sd	s0,80(sp)
    80006e22:	e4a6                	sd	s1,72(sp)
    80006e24:	e0ca                	sd	s2,64(sp)
    80006e26:	fc4e                	sd	s3,56(sp)
    80006e28:	f852                	sd	s4,48(sp)
    80006e2a:	f456                	sd	s5,40(sp)
    80006e2c:	f05a                	sd	s6,32(sp)
    80006e2e:	ec5e                	sd	s7,24(sp)
    80006e30:	e862                	sd	s8,16(sp)
    80006e32:	e466                	sd	s9,8(sp)
    80006e34:	e06a                	sd	s10,0(sp)
    80006e36:	1080                	addi	s0,sp,96
  int free = 0;

  for (int k = 0; k < MAXSIZE; k++) {   // skip max size
    80006e38:	00029717          	auipc	a4,0x29
    80006e3c:	22072703          	lw	a4,544(a4) # 80030058 <nsizes>
    80006e40:	4785                	li	a5,1
    80006e42:	06e7db63          	bge	a5,a4,80006eb8 <bd_initfree+0x9c>
    80006e46:	8aaa                	mv	s5,a0
    80006e48:	8b2e                	mv	s6,a1
    80006e4a:	4901                	li	s2,0
  int free = 0;
    80006e4c:	4a01                	li	s4,0
  int n = p - (char *) bd_base;
    80006e4e:	00029c97          	auipc	s9,0x29
    80006e52:	1fac8c93          	addi	s9,s9,506 # 80030048 <bd_base>
  return n / BLK_SIZE(k);
    80006e56:	4c41                	li	s8,16
  for (int k = 0; k < MAXSIZE; k++) {   // skip max size
    80006e58:	00029b97          	auipc	s7,0x29
    80006e5c:	200b8b93          	addi	s7,s7,512 # 80030058 <nsizes>
    80006e60:	a039                	j	80006e6e <bd_initfree+0x52>
    80006e62:	2905                	addiw	s2,s2,1
    80006e64:	000ba783          	lw	a5,0(s7)
    80006e68:	37fd                	addiw	a5,a5,-1
    80006e6a:	04f95863          	bge	s2,a5,80006eba <bd_initfree+0x9e>
    int left = blk_index_next(k, bd_left);
    80006e6e:	85d6                	mv	a1,s5
    80006e70:	854a                	mv	a0,s2
    80006e72:	00000097          	auipc	ra,0x0
    80006e76:	dd6080e7          	jalr	-554(ra) # 80006c48 <blk_index_next>
    80006e7a:	89aa                	mv	s3,a0
  int n = p - (char *) bd_base;
    80006e7c:	000cb483          	ld	s1,0(s9)
  return n / BLK_SIZE(k);
    80006e80:	409b04bb          	subw	s1,s6,s1
    80006e84:	012c17b3          	sll	a5,s8,s2
    80006e88:	02f4c4b3          	div	s1,s1,a5
    80006e8c:	2481                	sext.w	s1,s1
    int right = blk_index(k, bd_right);
    free += bd_initfree_pair(k, left);
    80006e8e:	85aa                	mv	a1,a0
    80006e90:	854a                	mv	a0,s2
    80006e92:	00000097          	auipc	ra,0x0
    80006e96:	eda080e7          	jalr	-294(ra) # 80006d6c <bd_initfree_pair>
    80006e9a:	01450d3b          	addw	s10,a0,s4
    80006e9e:	000d0a1b          	sext.w	s4,s10
    if(right <= left)
    80006ea2:	fc99d0e3          	bge	s3,s1,80006e62 <bd_initfree+0x46>
      continue;
    free += bd_initfree_pair(k, right);
    80006ea6:	85a6                	mv	a1,s1
    80006ea8:	854a                	mv	a0,s2
    80006eaa:	00000097          	auipc	ra,0x0
    80006eae:	ec2080e7          	jalr	-318(ra) # 80006d6c <bd_initfree_pair>
    80006eb2:	00ad0a3b          	addw	s4,s10,a0
    80006eb6:	b775                	j	80006e62 <bd_initfree+0x46>
  int free = 0;
    80006eb8:	4a01                	li	s4,0
  }
  return free;
}
    80006eba:	8552                	mv	a0,s4
    80006ebc:	60e6                	ld	ra,88(sp)
    80006ebe:	6446                	ld	s0,80(sp)
    80006ec0:	64a6                	ld	s1,72(sp)
    80006ec2:	6906                	ld	s2,64(sp)
    80006ec4:	79e2                	ld	s3,56(sp)
    80006ec6:	7a42                	ld	s4,48(sp)
    80006ec8:	7aa2                	ld	s5,40(sp)
    80006eca:	7b02                	ld	s6,32(sp)
    80006ecc:	6be2                	ld	s7,24(sp)
    80006ece:	6c42                	ld	s8,16(sp)
    80006ed0:	6ca2                	ld	s9,8(sp)
    80006ed2:	6d02                	ld	s10,0(sp)
    80006ed4:	6125                	addi	sp,sp,96
    80006ed6:	8082                	ret

0000000080006ed8 <bd_mark_data_structures>:

// Mark the range [bd_base,p) as allocated
int
bd_mark_data_structures(char *p) {
    80006ed8:	7179                	addi	sp,sp,-48
    80006eda:	f406                	sd	ra,40(sp)
    80006edc:	f022                	sd	s0,32(sp)
    80006ede:	ec26                	sd	s1,24(sp)
    80006ee0:	e84a                	sd	s2,16(sp)
    80006ee2:	e44e                	sd	s3,8(sp)
    80006ee4:	1800                	addi	s0,sp,48
    80006ee6:	892a                	mv	s2,a0
  int meta = p - (char*)bd_base;
    80006ee8:	00029997          	auipc	s3,0x29
    80006eec:	16098993          	addi	s3,s3,352 # 80030048 <bd_base>
    80006ef0:	0009b483          	ld	s1,0(s3)
    80006ef4:	409504bb          	subw	s1,a0,s1
  printf("bd: %d meta bytes for managing %d bytes of memory\n", meta, BLK_SIZE(MAXSIZE));
    80006ef8:	00029797          	auipc	a5,0x29
    80006efc:	1607a783          	lw	a5,352(a5) # 80030058 <nsizes>
    80006f00:	37fd                	addiw	a5,a5,-1
    80006f02:	4641                	li	a2,16
    80006f04:	00f61633          	sll	a2,a2,a5
    80006f08:	85a6                	mv	a1,s1
    80006f0a:	00002517          	auipc	a0,0x2
    80006f0e:	ace50513          	addi	a0,a0,-1330 # 800089d8 <userret+0x948>
    80006f12:	ffff9097          	auipc	ra,0xffff9
    80006f16:	690080e7          	jalr	1680(ra) # 800005a2 <printf>
  bd_mark(bd_base, p);
    80006f1a:	85ca                	mv	a1,s2
    80006f1c:	0009b503          	ld	a0,0(s3)
    80006f20:	00000097          	auipc	ra,0x0
    80006f24:	d74080e7          	jalr	-652(ra) # 80006c94 <bd_mark>
  return meta;
}
    80006f28:	8526                	mv	a0,s1
    80006f2a:	70a2                	ld	ra,40(sp)
    80006f2c:	7402                	ld	s0,32(sp)
    80006f2e:	64e2                	ld	s1,24(sp)
    80006f30:	6942                	ld	s2,16(sp)
    80006f32:	69a2                	ld	s3,8(sp)
    80006f34:	6145                	addi	sp,sp,48
    80006f36:	8082                	ret

0000000080006f38 <bd_mark_unavailable>:

// Mark the range [end, HEAPSIZE) as allocated
int
bd_mark_unavailable(void *end, void *left) {
    80006f38:	1101                	addi	sp,sp,-32
    80006f3a:	ec06                	sd	ra,24(sp)
    80006f3c:	e822                	sd	s0,16(sp)
    80006f3e:	e426                	sd	s1,8(sp)
    80006f40:	1000                	addi	s0,sp,32
  int unavailable = BLK_SIZE(MAXSIZE)-(end-bd_base);
    80006f42:	00029497          	auipc	s1,0x29
    80006f46:	1164a483          	lw	s1,278(s1) # 80030058 <nsizes>
    80006f4a:	fff4879b          	addiw	a5,s1,-1
    80006f4e:	44c1                	li	s1,16
    80006f50:	00f494b3          	sll	s1,s1,a5
    80006f54:	00029797          	auipc	a5,0x29
    80006f58:	0f47b783          	ld	a5,244(a5) # 80030048 <bd_base>
    80006f5c:	8d1d                	sub	a0,a0,a5
    80006f5e:	40a4853b          	subw	a0,s1,a0
    80006f62:	0005049b          	sext.w	s1,a0
  if(unavailable > 0)
    80006f66:	00905a63          	blez	s1,80006f7a <bd_mark_unavailable+0x42>
    unavailable = ROUNDUP(unavailable, LEAF_SIZE);
    80006f6a:	357d                	addiw	a0,a0,-1
    80006f6c:	41f5549b          	sraiw	s1,a0,0x1f
    80006f70:	01c4d49b          	srliw	s1,s1,0x1c
    80006f74:	9ca9                	addw	s1,s1,a0
    80006f76:	98c1                	andi	s1,s1,-16
    80006f78:	24c1                	addiw	s1,s1,16
  printf("bd: 0x%x bytes unavailable\n", unavailable);
    80006f7a:	85a6                	mv	a1,s1
    80006f7c:	00002517          	auipc	a0,0x2
    80006f80:	a9450513          	addi	a0,a0,-1388 # 80008a10 <userret+0x980>
    80006f84:	ffff9097          	auipc	ra,0xffff9
    80006f88:	61e080e7          	jalr	1566(ra) # 800005a2 <printf>

  void *bd_end = bd_base+BLK_SIZE(MAXSIZE)-unavailable;
    80006f8c:	00029717          	auipc	a4,0x29
    80006f90:	0bc73703          	ld	a4,188(a4) # 80030048 <bd_base>
    80006f94:	00029597          	auipc	a1,0x29
    80006f98:	0c45a583          	lw	a1,196(a1) # 80030058 <nsizes>
    80006f9c:	fff5879b          	addiw	a5,a1,-1
    80006fa0:	45c1                	li	a1,16
    80006fa2:	00f595b3          	sll	a1,a1,a5
    80006fa6:	40958533          	sub	a0,a1,s1
  bd_mark(bd_end, bd_base+BLK_SIZE(MAXSIZE));
    80006faa:	95ba                	add	a1,a1,a4
    80006fac:	953a                	add	a0,a0,a4
    80006fae:	00000097          	auipc	ra,0x0
    80006fb2:	ce6080e7          	jalr	-794(ra) # 80006c94 <bd_mark>
  return unavailable;
}
    80006fb6:	8526                	mv	a0,s1
    80006fb8:	60e2                	ld	ra,24(sp)
    80006fba:	6442                	ld	s0,16(sp)
    80006fbc:	64a2                	ld	s1,8(sp)
    80006fbe:	6105                	addi	sp,sp,32
    80006fc0:	8082                	ret

0000000080006fc2 <bd_init>:

// Initialize the buddy allocator: it manages memory from [base, end).
void
bd_init(void *base, void *end) {
    80006fc2:	715d                	addi	sp,sp,-80
    80006fc4:	e486                	sd	ra,72(sp)
    80006fc6:	e0a2                	sd	s0,64(sp)
    80006fc8:	fc26                	sd	s1,56(sp)
    80006fca:	f84a                	sd	s2,48(sp)
    80006fcc:	f44e                	sd	s3,40(sp)
    80006fce:	f052                	sd	s4,32(sp)
    80006fd0:	ec56                	sd	s5,24(sp)
    80006fd2:	e85a                	sd	s6,16(sp)
    80006fd4:	e45e                	sd	s7,8(sp)
    80006fd6:	e062                	sd	s8,0(sp)
    80006fd8:	0880                	addi	s0,sp,80
    80006fda:	8c2e                	mv	s8,a1
  char *p = (char *) ROUNDUP((uint64)base, LEAF_SIZE);
    80006fdc:	fff50493          	addi	s1,a0,-1
    80006fe0:	98c1                	andi	s1,s1,-16
    80006fe2:	04c1                	addi	s1,s1,16
  int sz;

  initlock(&lock, "buddy");
    80006fe4:	00002597          	auipc	a1,0x2
    80006fe8:	a4c58593          	addi	a1,a1,-1460 # 80008a30 <userret+0x9a0>
    80006fec:	00029517          	auipc	a0,0x29
    80006ff0:	01450513          	addi	a0,a0,20 # 80030000 <lock>
    80006ff4:	ffffa097          	auipc	ra,0xffffa
    80006ff8:	ae8080e7          	jalr	-1304(ra) # 80000adc <initlock>
  bd_base = (void *) p;
    80006ffc:	00029797          	auipc	a5,0x29
    80007000:	0497b623          	sd	s1,76(a5) # 80030048 <bd_base>

  // compute the number of sizes we need to manage [base, end)
  nsizes = log2(((char *)end-p)/LEAF_SIZE) + 1;
    80007004:	409c0933          	sub	s2,s8,s1
    80007008:	43f95513          	srai	a0,s2,0x3f
    8000700c:	893d                	andi	a0,a0,15
    8000700e:	954a                	add	a0,a0,s2
    80007010:	8511                	srai	a0,a0,0x4
    80007012:	00000097          	auipc	ra,0x0
    80007016:	c60080e7          	jalr	-928(ra) # 80006c72 <log2>
  if((char*)end-p > BLK_SIZE(MAXSIZE)) {
    8000701a:	47c1                	li	a5,16
    8000701c:	00a797b3          	sll	a5,a5,a0
    80007020:	1b27c663          	blt	a5,s2,800071cc <bd_init+0x20a>
  nsizes = log2(((char *)end-p)/LEAF_SIZE) + 1;
    80007024:	2505                	addiw	a0,a0,1
    80007026:	00029797          	auipc	a5,0x29
    8000702a:	02a7a923          	sw	a0,50(a5) # 80030058 <nsizes>
    nsizes++;  // round up to the next power of 2
  }

  printf("bd: memory sz is %d bytes; allocate an size array of length %d\n",
    8000702e:	00029997          	auipc	s3,0x29
    80007032:	02a98993          	addi	s3,s3,42 # 80030058 <nsizes>
    80007036:	0009a603          	lw	a2,0(s3)
    8000703a:	85ca                	mv	a1,s2
    8000703c:	00002517          	auipc	a0,0x2
    80007040:	9fc50513          	addi	a0,a0,-1540 # 80008a38 <userret+0x9a8>
    80007044:	ffff9097          	auipc	ra,0xffff9
    80007048:	55e080e7          	jalr	1374(ra) # 800005a2 <printf>
         (char*) end - p, nsizes);

  // allocate bd_sizes array
  bd_sizes = (Sz_info *) p;
    8000704c:	00029797          	auipc	a5,0x29
    80007050:	0097b223          	sd	s1,4(a5) # 80030050 <bd_sizes>
  p += sizeof(Sz_info) * nsizes;
    80007054:	0009a603          	lw	a2,0(s3)
    80007058:	00561913          	slli	s2,a2,0x5
    8000705c:	9926                	add	s2,s2,s1
  memset(bd_sizes, 0, sizeof(Sz_info) * nsizes);
    8000705e:	0056161b          	slliw	a2,a2,0x5
    80007062:	4581                	li	a1,0
    80007064:	8526                	mv	a0,s1
    80007066:	ffffa097          	auipc	ra,0xffffa
    8000706a:	e32080e7          	jalr	-462(ra) # 80000e98 <memset>

  // initialize free list and allocate the alloc array for each size k
  for (int k = 0; k < nsizes; k++) {
    8000706e:	0009a783          	lw	a5,0(s3)
    80007072:	06f05a63          	blez	a5,800070e6 <bd_init+0x124>
    80007076:	4981                	li	s3,0
    lst_init(&bd_sizes[k].free);
    80007078:	00029a97          	auipc	s5,0x29
    8000707c:	fd8a8a93          	addi	s5,s5,-40 # 80030050 <bd_sizes>
    sz = sizeof(char)* ROUNDUP(NBLK(k), 8)/8;
    80007080:	00029a17          	auipc	s4,0x29
    80007084:	fd8a0a13          	addi	s4,s4,-40 # 80030058 <nsizes>
    80007088:	4b05                	li	s6,1
    lst_init(&bd_sizes[k].free);
    8000708a:	00599b93          	slli	s7,s3,0x5
    8000708e:	000ab503          	ld	a0,0(s5)
    80007092:	955e                	add	a0,a0,s7
    80007094:	00000097          	auipc	ra,0x0
    80007098:	166080e7          	jalr	358(ra) # 800071fa <lst_init>
    sz = sizeof(char)* ROUNDUP(NBLK(k), 8)/8;
    8000709c:	000a2483          	lw	s1,0(s4)
    800070a0:	34fd                	addiw	s1,s1,-1
    800070a2:	413484bb          	subw	s1,s1,s3
    800070a6:	009b14bb          	sllw	s1,s6,s1
    800070aa:	fff4879b          	addiw	a5,s1,-1
    800070ae:	41f7d49b          	sraiw	s1,a5,0x1f
    800070b2:	01d4d49b          	srliw	s1,s1,0x1d
    800070b6:	9cbd                	addw	s1,s1,a5
    800070b8:	98e1                	andi	s1,s1,-8
    800070ba:	24a1                	addiw	s1,s1,8
    bd_sizes[k].alloc = p;
    800070bc:	000ab783          	ld	a5,0(s5)
    800070c0:	9bbe                	add	s7,s7,a5
    800070c2:	012bb823          	sd	s2,16(s7)
    memset(bd_sizes[k].alloc, 0, sz);
    800070c6:	848d                	srai	s1,s1,0x3
    800070c8:	8626                	mv	a2,s1
    800070ca:	4581                	li	a1,0
    800070cc:	854a                	mv	a0,s2
    800070ce:	ffffa097          	auipc	ra,0xffffa
    800070d2:	dca080e7          	jalr	-566(ra) # 80000e98 <memset>
    p += sz;
    800070d6:	9926                	add	s2,s2,s1
  for (int k = 0; k < nsizes; k++) {
    800070d8:	0985                	addi	s3,s3,1
    800070da:	000a2703          	lw	a4,0(s4)
    800070de:	0009879b          	sext.w	a5,s3
    800070e2:	fae7c4e3          	blt	a5,a4,8000708a <bd_init+0xc8>
  }

  // allocate the split array for each size k, except for k = 0, since
  // we will not split blocks of size k = 0, the smallest size.
  for (int k = 1; k < nsizes; k++) {
    800070e6:	00029797          	auipc	a5,0x29
    800070ea:	f727a783          	lw	a5,-142(a5) # 80030058 <nsizes>
    800070ee:	4705                	li	a4,1
    800070f0:	06f75163          	bge	a4,a5,80007152 <bd_init+0x190>
    800070f4:	02000a13          	li	s4,32
    800070f8:	4985                	li	s3,1
    sz = sizeof(char)* (ROUNDUP(NBLK(k), 8))/8;
    800070fa:	4b85                	li	s7,1
    bd_sizes[k].split = p;
    800070fc:	00029b17          	auipc	s6,0x29
    80007100:	f54b0b13          	addi	s6,s6,-172 # 80030050 <bd_sizes>
  for (int k = 1; k < nsizes; k++) {
    80007104:	00029a97          	auipc	s5,0x29
    80007108:	f54a8a93          	addi	s5,s5,-172 # 80030058 <nsizes>
    sz = sizeof(char)* (ROUNDUP(NBLK(k), 8))/8;
    8000710c:	37fd                	addiw	a5,a5,-1
    8000710e:	413787bb          	subw	a5,a5,s3
    80007112:	00fb94bb          	sllw	s1,s7,a5
    80007116:	fff4879b          	addiw	a5,s1,-1
    8000711a:	41f7d49b          	sraiw	s1,a5,0x1f
    8000711e:	01d4d49b          	srliw	s1,s1,0x1d
    80007122:	9cbd                	addw	s1,s1,a5
    80007124:	98e1                	andi	s1,s1,-8
    80007126:	24a1                	addiw	s1,s1,8
    bd_sizes[k].split = p;
    80007128:	000b3783          	ld	a5,0(s6)
    8000712c:	97d2                	add	a5,a5,s4
    8000712e:	0127bc23          	sd	s2,24(a5)
    memset(bd_sizes[k].split, 0, sz);
    80007132:	848d                	srai	s1,s1,0x3
    80007134:	8626                	mv	a2,s1
    80007136:	4581                	li	a1,0
    80007138:	854a                	mv	a0,s2
    8000713a:	ffffa097          	auipc	ra,0xffffa
    8000713e:	d5e080e7          	jalr	-674(ra) # 80000e98 <memset>
    p += sz;
    80007142:	9926                	add	s2,s2,s1
  for (int k = 1; k < nsizes; k++) {
    80007144:	2985                	addiw	s3,s3,1
    80007146:	000aa783          	lw	a5,0(s5)
    8000714a:	020a0a13          	addi	s4,s4,32
    8000714e:	faf9cfe3          	blt	s3,a5,8000710c <bd_init+0x14a>
  }
  p = (char *) ROUNDUP((uint64) p, LEAF_SIZE);
    80007152:	197d                	addi	s2,s2,-1
    80007154:	ff097913          	andi	s2,s2,-16
    80007158:	0941                	addi	s2,s2,16

  // done allocating; mark the memory range [base, p) as allocated, so
  // that buddy will not hand out that memory.
  int meta = bd_mark_data_structures(p);
    8000715a:	854a                	mv	a0,s2
    8000715c:	00000097          	auipc	ra,0x0
    80007160:	d7c080e7          	jalr	-644(ra) # 80006ed8 <bd_mark_data_structures>
    80007164:	8a2a                	mv	s4,a0
  
  // mark the unavailable memory range [end, HEAP_SIZE) as allocated,
  // so that buddy will not hand out that memory.
  int unavailable = bd_mark_unavailable(end, p);
    80007166:	85ca                	mv	a1,s2
    80007168:	8562                	mv	a0,s8
    8000716a:	00000097          	auipc	ra,0x0
    8000716e:	dce080e7          	jalr	-562(ra) # 80006f38 <bd_mark_unavailable>
    80007172:	89aa                	mv	s3,a0
  void *bd_end = bd_base+BLK_SIZE(MAXSIZE)-unavailable;
    80007174:	00029a97          	auipc	s5,0x29
    80007178:	ee4a8a93          	addi	s5,s5,-284 # 80030058 <nsizes>
    8000717c:	000aa783          	lw	a5,0(s5)
    80007180:	37fd                	addiw	a5,a5,-1
    80007182:	44c1                	li	s1,16
    80007184:	00f497b3          	sll	a5,s1,a5
    80007188:	8f89                	sub	a5,a5,a0
  
  // initialize free lists for each size k
  int free = bd_initfree(p, bd_end);
    8000718a:	00029597          	auipc	a1,0x29
    8000718e:	ebe5b583          	ld	a1,-322(a1) # 80030048 <bd_base>
    80007192:	95be                	add	a1,a1,a5
    80007194:	854a                	mv	a0,s2
    80007196:	00000097          	auipc	ra,0x0
    8000719a:	c86080e7          	jalr	-890(ra) # 80006e1c <bd_initfree>

  // check if the amount that is free is what we expect
  if(free != BLK_SIZE(MAXSIZE)-meta-unavailable) {
    8000719e:	000aa603          	lw	a2,0(s5)
    800071a2:	367d                	addiw	a2,a2,-1
    800071a4:	00c49633          	sll	a2,s1,a2
    800071a8:	41460633          	sub	a2,a2,s4
    800071ac:	41360633          	sub	a2,a2,s3
    800071b0:	02c51463          	bne	a0,a2,800071d8 <bd_init+0x216>
    printf("free %d %d\n", free, BLK_SIZE(MAXSIZE)-meta-unavailable);
    panic("bd_init: free mem");
  }
}
    800071b4:	60a6                	ld	ra,72(sp)
    800071b6:	6406                	ld	s0,64(sp)
    800071b8:	74e2                	ld	s1,56(sp)
    800071ba:	7942                	ld	s2,48(sp)
    800071bc:	79a2                	ld	s3,40(sp)
    800071be:	7a02                	ld	s4,32(sp)
    800071c0:	6ae2                	ld	s5,24(sp)
    800071c2:	6b42                	ld	s6,16(sp)
    800071c4:	6ba2                	ld	s7,8(sp)
    800071c6:	6c02                	ld	s8,0(sp)
    800071c8:	6161                	addi	sp,sp,80
    800071ca:	8082                	ret
    nsizes++;  // round up to the next power of 2
    800071cc:	2509                	addiw	a0,a0,2
    800071ce:	00029797          	auipc	a5,0x29
    800071d2:	e8a7a523          	sw	a0,-374(a5) # 80030058 <nsizes>
    800071d6:	bda1                	j	8000702e <bd_init+0x6c>
    printf("free %d %d\n", free, BLK_SIZE(MAXSIZE)-meta-unavailable);
    800071d8:	85aa                	mv	a1,a0
    800071da:	00002517          	auipc	a0,0x2
    800071de:	89e50513          	addi	a0,a0,-1890 # 80008a78 <userret+0x9e8>
    800071e2:	ffff9097          	auipc	ra,0xffff9
    800071e6:	3c0080e7          	jalr	960(ra) # 800005a2 <printf>
    panic("bd_init: free mem");
    800071ea:	00002517          	auipc	a0,0x2
    800071ee:	89e50513          	addi	a0,a0,-1890 # 80008a88 <userret+0x9f8>
    800071f2:	ffff9097          	auipc	ra,0xffff9
    800071f6:	356080e7          	jalr	854(ra) # 80000548 <panic>

00000000800071fa <lst_init>:
// fast. circular simplifies code, because don't have to check for
// empty list in insert and remove.

void
lst_init(struct list *lst)
{
    800071fa:	1141                	addi	sp,sp,-16
    800071fc:	e422                	sd	s0,8(sp)
    800071fe:	0800                	addi	s0,sp,16
  lst->next = lst;
    80007200:	e108                	sd	a0,0(a0)
  lst->prev = lst;
    80007202:	e508                	sd	a0,8(a0)
}
    80007204:	6422                	ld	s0,8(sp)
    80007206:	0141                	addi	sp,sp,16
    80007208:	8082                	ret

000000008000720a <lst_empty>:

int
lst_empty(struct list *lst) {
    8000720a:	1141                	addi	sp,sp,-16
    8000720c:	e422                	sd	s0,8(sp)
    8000720e:	0800                	addi	s0,sp,16
  return lst->next == lst;
    80007210:	611c                	ld	a5,0(a0)
    80007212:	40a78533          	sub	a0,a5,a0
}
    80007216:	00153513          	seqz	a0,a0
    8000721a:	6422                	ld	s0,8(sp)
    8000721c:	0141                	addi	sp,sp,16
    8000721e:	8082                	ret

0000000080007220 <lst_remove>:

void
lst_remove(struct list *e) {
    80007220:	1141                	addi	sp,sp,-16
    80007222:	e422                	sd	s0,8(sp)
    80007224:	0800                	addi	s0,sp,16
  e->prev->next = e->next;
    80007226:	6518                	ld	a4,8(a0)
    80007228:	611c                	ld	a5,0(a0)
    8000722a:	e31c                	sd	a5,0(a4)
  e->next->prev = e->prev;
    8000722c:	6518                	ld	a4,8(a0)
    8000722e:	e798                	sd	a4,8(a5)
}
    80007230:	6422                	ld	s0,8(sp)
    80007232:	0141                	addi	sp,sp,16
    80007234:	8082                	ret

0000000080007236 <lst_pop>:

void*
lst_pop(struct list *lst) {
    80007236:	1101                	addi	sp,sp,-32
    80007238:	ec06                	sd	ra,24(sp)
    8000723a:	e822                	sd	s0,16(sp)
    8000723c:	e426                	sd	s1,8(sp)
    8000723e:	1000                	addi	s0,sp,32
  if(lst->next == lst)
    80007240:	6104                	ld	s1,0(a0)
    80007242:	00a48d63          	beq	s1,a0,8000725c <lst_pop+0x26>
    panic("lst_pop");
  struct list *p = lst->next;
  lst_remove(p);
    80007246:	8526                	mv	a0,s1
    80007248:	00000097          	auipc	ra,0x0
    8000724c:	fd8080e7          	jalr	-40(ra) # 80007220 <lst_remove>
  return (void *)p;
}
    80007250:	8526                	mv	a0,s1
    80007252:	60e2                	ld	ra,24(sp)
    80007254:	6442                	ld	s0,16(sp)
    80007256:	64a2                	ld	s1,8(sp)
    80007258:	6105                	addi	sp,sp,32
    8000725a:	8082                	ret
    panic("lst_pop");
    8000725c:	00002517          	auipc	a0,0x2
    80007260:	84450513          	addi	a0,a0,-1980 # 80008aa0 <userret+0xa10>
    80007264:	ffff9097          	auipc	ra,0xffff9
    80007268:	2e4080e7          	jalr	740(ra) # 80000548 <panic>

000000008000726c <lst_push>:

void
lst_push(struct list *lst, void *p)
{
    8000726c:	1141                	addi	sp,sp,-16
    8000726e:	e422                	sd	s0,8(sp)
    80007270:	0800                	addi	s0,sp,16
  struct list *e = (struct list *) p;
  e->next = lst->next;
    80007272:	611c                	ld	a5,0(a0)
    80007274:	e19c                	sd	a5,0(a1)
  e->prev = lst;
    80007276:	e588                	sd	a0,8(a1)
  lst->next->prev = p;
    80007278:	611c                	ld	a5,0(a0)
    8000727a:	e78c                	sd	a1,8(a5)
  lst->next = e;
    8000727c:	e10c                	sd	a1,0(a0)
}
    8000727e:	6422                	ld	s0,8(sp)
    80007280:	0141                	addi	sp,sp,16
    80007282:	8082                	ret

0000000080007284 <lst_print>:

void
lst_print(struct list *lst)
{
    80007284:	7179                	addi	sp,sp,-48
    80007286:	f406                	sd	ra,40(sp)
    80007288:	f022                	sd	s0,32(sp)
    8000728a:	ec26                	sd	s1,24(sp)
    8000728c:	e84a                	sd	s2,16(sp)
    8000728e:	e44e                	sd	s3,8(sp)
    80007290:	1800                	addi	s0,sp,48
  for (struct list *p = lst->next; p != lst; p = p->next) {
    80007292:	6104                	ld	s1,0(a0)
    80007294:	02950063          	beq	a0,s1,800072b4 <lst_print+0x30>
    80007298:	892a                	mv	s2,a0
    printf(" %p", p);
    8000729a:	00002997          	auipc	s3,0x2
    8000729e:	80e98993          	addi	s3,s3,-2034 # 80008aa8 <userret+0xa18>
    800072a2:	85a6                	mv	a1,s1
    800072a4:	854e                	mv	a0,s3
    800072a6:	ffff9097          	auipc	ra,0xffff9
    800072aa:	2fc080e7          	jalr	764(ra) # 800005a2 <printf>
  for (struct list *p = lst->next; p != lst; p = p->next) {
    800072ae:	6084                	ld	s1,0(s1)
    800072b0:	fe9919e3          	bne	s2,s1,800072a2 <lst_print+0x1e>
  }
  printf("\n");
    800072b4:	00001517          	auipc	a0,0x1
    800072b8:	fdc50513          	addi	a0,a0,-36 # 80008290 <userret+0x200>
    800072bc:	ffff9097          	auipc	ra,0xffff9
    800072c0:	2e6080e7          	jalr	742(ra) # 800005a2 <printf>
}
    800072c4:	70a2                	ld	ra,40(sp)
    800072c6:	7402                	ld	s0,32(sp)
    800072c8:	64e2                	ld	s1,24(sp)
    800072ca:	6942                	ld	s2,16(sp)
    800072cc:	69a2                	ld	s3,8(sp)
    800072ce:	6145                	addi	sp,sp,48
    800072d0:	8082                	ret
	...

0000000080008000 <trampoline>:
    80008000:	14051573          	csrrw	a0,sscratch,a0
    80008004:	02153423          	sd	ra,40(a0)
    80008008:	02253823          	sd	sp,48(a0)
    8000800c:	02353c23          	sd	gp,56(a0)
    80008010:	04453023          	sd	tp,64(a0)
    80008014:	04553423          	sd	t0,72(a0)
    80008018:	04653823          	sd	t1,80(a0)
    8000801c:	04753c23          	sd	t2,88(a0)
    80008020:	f120                	sd	s0,96(a0)
    80008022:	f524                	sd	s1,104(a0)
    80008024:	fd2c                	sd	a1,120(a0)
    80008026:	e150                	sd	a2,128(a0)
    80008028:	e554                	sd	a3,136(a0)
    8000802a:	e958                	sd	a4,144(a0)
    8000802c:	ed5c                	sd	a5,152(a0)
    8000802e:	0b053023          	sd	a6,160(a0)
    80008032:	0b153423          	sd	a7,168(a0)
    80008036:	0b253823          	sd	s2,176(a0)
    8000803a:	0b353c23          	sd	s3,184(a0)
    8000803e:	0d453023          	sd	s4,192(a0)
    80008042:	0d553423          	sd	s5,200(a0)
    80008046:	0d653823          	sd	s6,208(a0)
    8000804a:	0d753c23          	sd	s7,216(a0)
    8000804e:	0f853023          	sd	s8,224(a0)
    80008052:	0f953423          	sd	s9,232(a0)
    80008056:	0fa53823          	sd	s10,240(a0)
    8000805a:	0fb53c23          	sd	s11,248(a0)
    8000805e:	11c53023          	sd	t3,256(a0)
    80008062:	11d53423          	sd	t4,264(a0)
    80008066:	11e53823          	sd	t5,272(a0)
    8000806a:	11f53c23          	sd	t6,280(a0)
    8000806e:	140022f3          	csrr	t0,sscratch
    80008072:	06553823          	sd	t0,112(a0)
    80008076:	00853103          	ld	sp,8(a0)
    8000807a:	02053203          	ld	tp,32(a0)
    8000807e:	01053283          	ld	t0,16(a0)
    80008082:	00053303          	ld	t1,0(a0)
    80008086:	18031073          	csrw	satp,t1
    8000808a:	12000073          	sfence.vma
    8000808e:	8282                	jr	t0

0000000080008090 <userret>:
    80008090:	18059073          	csrw	satp,a1
    80008094:	12000073          	sfence.vma
    80008098:	07053283          	ld	t0,112(a0)
    8000809c:	14029073          	csrw	sscratch,t0
    800080a0:	02853083          	ld	ra,40(a0)
    800080a4:	03053103          	ld	sp,48(a0)
    800080a8:	03853183          	ld	gp,56(a0)
    800080ac:	04053203          	ld	tp,64(a0)
    800080b0:	04853283          	ld	t0,72(a0)
    800080b4:	05053303          	ld	t1,80(a0)
    800080b8:	05853383          	ld	t2,88(a0)
    800080bc:	7120                	ld	s0,96(a0)
    800080be:	7524                	ld	s1,104(a0)
    800080c0:	7d2c                	ld	a1,120(a0)
    800080c2:	6150                	ld	a2,128(a0)
    800080c4:	6554                	ld	a3,136(a0)
    800080c6:	6958                	ld	a4,144(a0)
    800080c8:	6d5c                	ld	a5,152(a0)
    800080ca:	0a053803          	ld	a6,160(a0)
    800080ce:	0a853883          	ld	a7,168(a0)
    800080d2:	0b053903          	ld	s2,176(a0)
    800080d6:	0b853983          	ld	s3,184(a0)
    800080da:	0c053a03          	ld	s4,192(a0)
    800080de:	0c853a83          	ld	s5,200(a0)
    800080e2:	0d053b03          	ld	s6,208(a0)
    800080e6:	0d853b83          	ld	s7,216(a0)
    800080ea:	0e053c03          	ld	s8,224(a0)
    800080ee:	0e853c83          	ld	s9,232(a0)
    800080f2:	0f053d03          	ld	s10,240(a0)
    800080f6:	0f853d83          	ld	s11,248(a0)
    800080fa:	10053e03          	ld	t3,256(a0)
    800080fe:	10853e83          	ld	t4,264(a0)
    80008102:	11053f03          	ld	t5,272(a0)
    80008106:	11853f83          	ld	t6,280(a0)
    8000810a:	14051573          	csrrw	a0,sscratch,a0
    8000810e:	10200073          	sret
