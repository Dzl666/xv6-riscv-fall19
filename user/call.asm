
user/_call：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <g>:
#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int g(int x) {
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  return x+3;
}
   6:	250d                	addiw	a0,a0,3
   8:	6422                	ld	s0,8(sp)
   a:	0141                	addi	sp,sp,16
   c:	8082                	ret

000000000000000e <f>:

int f(int x) {
   e:	1141                	addi	sp,sp,-16
  10:	e422                	sd	s0,8(sp)
  12:	0800                	addi	s0,sp,16
  return g(x);
}
  14:	250d                	addiw	a0,a0,3
  16:	6422                	ld	s0,8(sp)
  18:	0141                	addi	sp,sp,16
  1a:	8082                	ret

000000000000001c <main>:

void main(void) {
  1c:	1141                	addi	sp,sp,-16
  1e:	e406                	sd	ra,8(sp)
  20:	e022                	sd	s0,0(sp)
  22:	0800                	addi	s0,sp,16
  printf("%d %d\n", f(8)+1, 13);
  24:	4635                	li	a2,13
  26:	45b1                	li	a1,12
  28:	00000517          	auipc	a0,0x0
  2c:	74850513          	addi	a0,a0,1864 # 770 <malloc+0xec>
  30:	00000097          	auipc	ra,0x0
  34:	596080e7          	jalr	1430(ra) # 5c6 <printf>
  exit();
  38:	00000097          	auipc	ra,0x0
  3c:	1f6080e7          	jalr	502(ra) # 22e <exit>

0000000000000040 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  40:	1141                	addi	sp,sp,-16
  42:	e422                	sd	s0,8(sp)
  44:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  46:	87aa                	mv	a5,a0
  48:	0585                	addi	a1,a1,1
  4a:	0785                	addi	a5,a5,1
  4c:	fff5c703          	lbu	a4,-1(a1)
  50:	fee78fa3          	sb	a4,-1(a5)
  54:	fb75                	bnez	a4,48 <strcpy+0x8>
    ;
  return os;
}
  56:	6422                	ld	s0,8(sp)
  58:	0141                	addi	sp,sp,16
  5a:	8082                	ret

000000000000005c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  5c:	1141                	addi	sp,sp,-16
  5e:	e422                	sd	s0,8(sp)
  60:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  62:	00054783          	lbu	a5,0(a0)
  66:	cb91                	beqz	a5,7a <strcmp+0x1e>
  68:	0005c703          	lbu	a4,0(a1)
  6c:	00f71763          	bne	a4,a5,7a <strcmp+0x1e>
    p++, q++;
  70:	0505                	addi	a0,a0,1
  72:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  74:	00054783          	lbu	a5,0(a0)
  78:	fbe5                	bnez	a5,68 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7a:	0005c503          	lbu	a0,0(a1)
}
  7e:	40a7853b          	subw	a0,a5,a0
  82:	6422                	ld	s0,8(sp)
  84:	0141                	addi	sp,sp,16
  86:	8082                	ret

0000000000000088 <strlen>:

uint
strlen(const char *s)
{
  88:	1141                	addi	sp,sp,-16
  8a:	e422                	sd	s0,8(sp)
  8c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  8e:	00054783          	lbu	a5,0(a0)
  92:	cf91                	beqz	a5,ae <strlen+0x26>
  94:	0505                	addi	a0,a0,1
  96:	87aa                	mv	a5,a0
  98:	4685                	li	a3,1
  9a:	9e89                	subw	a3,a3,a0
  9c:	00f6853b          	addw	a0,a3,a5
  a0:	0785                	addi	a5,a5,1
  a2:	fff7c703          	lbu	a4,-1(a5)
  a6:	fb7d                	bnez	a4,9c <strlen+0x14>
    ;
  return n;
}
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret
  for(n = 0; s[n]; n++)
  ae:	4501                	li	a0,0
  b0:	bfe5                	j	a8 <strlen+0x20>

00000000000000b2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b2:	1141                	addi	sp,sp,-16
  b4:	e422                	sd	s0,8(sp)
  b6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b8:	ca19                	beqz	a2,ce <memset+0x1c>
  ba:	87aa                	mv	a5,a0
  bc:	1602                	slli	a2,a2,0x20
  be:	9201                	srli	a2,a2,0x20
  c0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c8:	0785                	addi	a5,a5,1
  ca:	fee79de3          	bne	a5,a4,c4 <memset+0x12>
  }
  return dst;
}
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret

00000000000000d4 <strchr>:

char*
strchr(const char *s, char c)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  da:	00054783          	lbu	a5,0(a0)
  de:	cb99                	beqz	a5,f4 <strchr+0x20>
    if(*s == c)
  e0:	00f58763          	beq	a1,a5,ee <strchr+0x1a>
  for(; *s; s++)
  e4:	0505                	addi	a0,a0,1
  e6:	00054783          	lbu	a5,0(a0)
  ea:	fbfd                	bnez	a5,e0 <strchr+0xc>
      return (char*)s;
  return 0;
  ec:	4501                	li	a0,0
}
  ee:	6422                	ld	s0,8(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret
  return 0;
  f4:	4501                	li	a0,0
  f6:	bfe5                	j	ee <strchr+0x1a>

00000000000000f8 <gets>:

char*
gets(char *buf, int max)
{
  f8:	711d                	addi	sp,sp,-96
  fa:	ec86                	sd	ra,88(sp)
  fc:	e8a2                	sd	s0,80(sp)
  fe:	e4a6                	sd	s1,72(sp)
 100:	e0ca                	sd	s2,64(sp)
 102:	fc4e                	sd	s3,56(sp)
 104:	f852                	sd	s4,48(sp)
 106:	f456                	sd	s5,40(sp)
 108:	f05a                	sd	s6,32(sp)
 10a:	ec5e                	sd	s7,24(sp)
 10c:	1080                	addi	s0,sp,96
 10e:	8baa                	mv	s7,a0
 110:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 112:	892a                	mv	s2,a0
 114:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 116:	4aa9                	li	s5,10
 118:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 11a:	89a6                	mv	s3,s1
 11c:	2485                	addiw	s1,s1,1
 11e:	0344d863          	bge	s1,s4,14e <gets+0x56>
    cc = read(0, &c, 1);
 122:	4605                	li	a2,1
 124:	faf40593          	addi	a1,s0,-81
 128:	4501                	li	a0,0
 12a:	00000097          	auipc	ra,0x0
 12e:	11c080e7          	jalr	284(ra) # 246 <read>
    if(cc < 1)
 132:	00a05e63          	blez	a0,14e <gets+0x56>
    buf[i++] = c;
 136:	faf44783          	lbu	a5,-81(s0)
 13a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 13e:	01578763          	beq	a5,s5,14c <gets+0x54>
 142:	0905                	addi	s2,s2,1
 144:	fd679be3          	bne	a5,s6,11a <gets+0x22>
  for(i=0; i+1 < max; ){
 148:	89a6                	mv	s3,s1
 14a:	a011                	j	14e <gets+0x56>
 14c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 14e:	99de                	add	s3,s3,s7
 150:	00098023          	sb	zero,0(s3)
  return buf;
}
 154:	855e                	mv	a0,s7
 156:	60e6                	ld	ra,88(sp)
 158:	6446                	ld	s0,80(sp)
 15a:	64a6                	ld	s1,72(sp)
 15c:	6906                	ld	s2,64(sp)
 15e:	79e2                	ld	s3,56(sp)
 160:	7a42                	ld	s4,48(sp)
 162:	7aa2                	ld	s5,40(sp)
 164:	7b02                	ld	s6,32(sp)
 166:	6be2                	ld	s7,24(sp)
 168:	6125                	addi	sp,sp,96
 16a:	8082                	ret

000000000000016c <stat>:

int
stat(const char *n, struct stat *st)
{
 16c:	1101                	addi	sp,sp,-32
 16e:	ec06                	sd	ra,24(sp)
 170:	e822                	sd	s0,16(sp)
 172:	e426                	sd	s1,8(sp)
 174:	e04a                	sd	s2,0(sp)
 176:	1000                	addi	s0,sp,32
 178:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17a:	4581                	li	a1,0
 17c:	00000097          	auipc	ra,0x0
 180:	0f2080e7          	jalr	242(ra) # 26e <open>
  if(fd < 0)
 184:	02054563          	bltz	a0,1ae <stat+0x42>
 188:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18a:	85ca                	mv	a1,s2
 18c:	00000097          	auipc	ra,0x0
 190:	0fa080e7          	jalr	250(ra) # 286 <fstat>
 194:	892a                	mv	s2,a0
  close(fd);
 196:	8526                	mv	a0,s1
 198:	00000097          	auipc	ra,0x0
 19c:	0be080e7          	jalr	190(ra) # 256 <close>
  return r;
}
 1a0:	854a                	mv	a0,s2
 1a2:	60e2                	ld	ra,24(sp)
 1a4:	6442                	ld	s0,16(sp)
 1a6:	64a2                	ld	s1,8(sp)
 1a8:	6902                	ld	s2,0(sp)
 1aa:	6105                	addi	sp,sp,32
 1ac:	8082                	ret
    return -1;
 1ae:	597d                	li	s2,-1
 1b0:	bfc5                	j	1a0 <stat+0x34>

00000000000001b2 <atoi>:

int
atoi(const char *s)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b8:	00054603          	lbu	a2,0(a0)
 1bc:	fd06079b          	addiw	a5,a2,-48
 1c0:	0ff7f793          	andi	a5,a5,255
 1c4:	4725                	li	a4,9
 1c6:	02f76963          	bltu	a4,a5,1f8 <atoi+0x46>
 1ca:	86aa                	mv	a3,a0
  n = 0;
 1cc:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1ce:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1d0:	0685                	addi	a3,a3,1
 1d2:	0025179b          	slliw	a5,a0,0x2
 1d6:	9fa9                	addw	a5,a5,a0
 1d8:	0017979b          	slliw	a5,a5,0x1
 1dc:	9fb1                	addw	a5,a5,a2
 1de:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e2:	0006c603          	lbu	a2,0(a3)
 1e6:	fd06071b          	addiw	a4,a2,-48
 1ea:	0ff77713          	andi	a4,a4,255
 1ee:	fee5f1e3          	bgeu	a1,a4,1d0 <atoi+0x1e>
  return n;
}
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	addi	sp,sp,16
 1f6:	8082                	ret
  n = 0;
 1f8:	4501                	li	a0,0
 1fa:	bfe5                	j	1f2 <atoi+0x40>

00000000000001fc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 202:	00c05f63          	blez	a2,220 <memmove+0x24>
 206:	1602                	slli	a2,a2,0x20
 208:	9201                	srli	a2,a2,0x20
 20a:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 20e:	87aa                	mv	a5,a0
    *dst++ = *src++;
 210:	0585                	addi	a1,a1,1
 212:	0785                	addi	a5,a5,1
 214:	fff5c703          	lbu	a4,-1(a1)
 218:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 21c:	fed79ae3          	bne	a5,a3,210 <memmove+0x14>
  return vdst;
}
 220:	6422                	ld	s0,8(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret

0000000000000226 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 226:	4885                	li	a7,1
 ecall
 228:	00000073          	ecall
 ret
 22c:	8082                	ret

000000000000022e <exit>:
.global exit
exit:
 li a7, SYS_exit
 22e:	4889                	li	a7,2
 ecall
 230:	00000073          	ecall
 ret
 234:	8082                	ret

0000000000000236 <wait>:
.global wait
wait:
 li a7, SYS_wait
 236:	488d                	li	a7,3
 ecall
 238:	00000073          	ecall
 ret
 23c:	8082                	ret

000000000000023e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 23e:	4891                	li	a7,4
 ecall
 240:	00000073          	ecall
 ret
 244:	8082                	ret

0000000000000246 <read>:
.global read
read:
 li a7, SYS_read
 246:	4895                	li	a7,5
 ecall
 248:	00000073          	ecall
 ret
 24c:	8082                	ret

000000000000024e <write>:
.global write
write:
 li a7, SYS_write
 24e:	48c1                	li	a7,16
 ecall
 250:	00000073          	ecall
 ret
 254:	8082                	ret

0000000000000256 <close>:
.global close
close:
 li a7, SYS_close
 256:	48d5                	li	a7,21
 ecall
 258:	00000073          	ecall
 ret
 25c:	8082                	ret

000000000000025e <kill>:
.global kill
kill:
 li a7, SYS_kill
 25e:	4899                	li	a7,6
 ecall
 260:	00000073          	ecall
 ret
 264:	8082                	ret

0000000000000266 <exec>:
.global exec
exec:
 li a7, SYS_exec
 266:	489d                	li	a7,7
 ecall
 268:	00000073          	ecall
 ret
 26c:	8082                	ret

000000000000026e <open>:
.global open
open:
 li a7, SYS_open
 26e:	48bd                	li	a7,15
 ecall
 270:	00000073          	ecall
 ret
 274:	8082                	ret

0000000000000276 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 276:	48c5                	li	a7,17
 ecall
 278:	00000073          	ecall
 ret
 27c:	8082                	ret

000000000000027e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 27e:	48c9                	li	a7,18
 ecall
 280:	00000073          	ecall
 ret
 284:	8082                	ret

0000000000000286 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 286:	48a1                	li	a7,8
 ecall
 288:	00000073          	ecall
 ret
 28c:	8082                	ret

000000000000028e <link>:
.global link
link:
 li a7, SYS_link
 28e:	48cd                	li	a7,19
 ecall
 290:	00000073          	ecall
 ret
 294:	8082                	ret

0000000000000296 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 296:	48d1                	li	a7,20
 ecall
 298:	00000073          	ecall
 ret
 29c:	8082                	ret

000000000000029e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 29e:	48a5                	li	a7,9
 ecall
 2a0:	00000073          	ecall
 ret
 2a4:	8082                	ret

00000000000002a6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2a6:	48a9                	li	a7,10
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2ae:	48ad                	li	a7,11
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2b6:	48b1                	li	a7,12
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2be:	48b5                	li	a7,13
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 2c6:	48b9                	li	a7,14
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 2ce:	48d9                	li	a7,22
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <crash>:
.global crash
crash:
 li a7, SYS_crash
 2d6:	48dd                	li	a7,23
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <mount>:
.global mount
mount:
 li a7, SYS_mount
 2de:	48e1                	li	a7,24
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <umount>:
.global umount
umount:
 li a7, SYS_umount
 2e6:	48e5                	li	a7,25
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 2ee:	1101                	addi	sp,sp,-32
 2f0:	ec06                	sd	ra,24(sp)
 2f2:	e822                	sd	s0,16(sp)
 2f4:	1000                	addi	s0,sp,32
 2f6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 2fa:	4605                	li	a2,1
 2fc:	fef40593          	addi	a1,s0,-17
 300:	00000097          	auipc	ra,0x0
 304:	f4e080e7          	jalr	-178(ra) # 24e <write>
}
 308:	60e2                	ld	ra,24(sp)
 30a:	6442                	ld	s0,16(sp)
 30c:	6105                	addi	sp,sp,32
 30e:	8082                	ret

0000000000000310 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 310:	7139                	addi	sp,sp,-64
 312:	fc06                	sd	ra,56(sp)
 314:	f822                	sd	s0,48(sp)
 316:	f426                	sd	s1,40(sp)
 318:	f04a                	sd	s2,32(sp)
 31a:	ec4e                	sd	s3,24(sp)
 31c:	0080                	addi	s0,sp,64
 31e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 320:	c299                	beqz	a3,326 <printint+0x16>
 322:	0805c863          	bltz	a1,3b2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 326:	2581                	sext.w	a1,a1
  neg = 0;
 328:	4881                	li	a7,0
 32a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 32e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 330:	2601                	sext.w	a2,a2
 332:	00000517          	auipc	a0,0x0
 336:	44e50513          	addi	a0,a0,1102 # 780 <digits>
 33a:	883a                	mv	a6,a4
 33c:	2705                	addiw	a4,a4,1
 33e:	02c5f7bb          	remuw	a5,a1,a2
 342:	1782                	slli	a5,a5,0x20
 344:	9381                	srli	a5,a5,0x20
 346:	97aa                	add	a5,a5,a0
 348:	0007c783          	lbu	a5,0(a5)
 34c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 350:	0005879b          	sext.w	a5,a1
 354:	02c5d5bb          	divuw	a1,a1,a2
 358:	0685                	addi	a3,a3,1
 35a:	fec7f0e3          	bgeu	a5,a2,33a <printint+0x2a>
  if(neg)
 35e:	00088b63          	beqz	a7,374 <printint+0x64>
    buf[i++] = '-';
 362:	fd040793          	addi	a5,s0,-48
 366:	973e                	add	a4,a4,a5
 368:	02d00793          	li	a5,45
 36c:	fef70823          	sb	a5,-16(a4)
 370:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 374:	02e05863          	blez	a4,3a4 <printint+0x94>
 378:	fc040793          	addi	a5,s0,-64
 37c:	00e78933          	add	s2,a5,a4
 380:	fff78993          	addi	s3,a5,-1
 384:	99ba                	add	s3,s3,a4
 386:	377d                	addiw	a4,a4,-1
 388:	1702                	slli	a4,a4,0x20
 38a:	9301                	srli	a4,a4,0x20
 38c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 390:	fff94583          	lbu	a1,-1(s2)
 394:	8526                	mv	a0,s1
 396:	00000097          	auipc	ra,0x0
 39a:	f58080e7          	jalr	-168(ra) # 2ee <putc>
  while(--i >= 0)
 39e:	197d                	addi	s2,s2,-1
 3a0:	ff3918e3          	bne	s2,s3,390 <printint+0x80>
}
 3a4:	70e2                	ld	ra,56(sp)
 3a6:	7442                	ld	s0,48(sp)
 3a8:	74a2                	ld	s1,40(sp)
 3aa:	7902                	ld	s2,32(sp)
 3ac:	69e2                	ld	s3,24(sp)
 3ae:	6121                	addi	sp,sp,64
 3b0:	8082                	ret
    x = -xx;
 3b2:	40b005bb          	negw	a1,a1
    neg = 1;
 3b6:	4885                	li	a7,1
    x = -xx;
 3b8:	bf8d                	j	32a <printint+0x1a>

00000000000003ba <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3ba:	7119                	addi	sp,sp,-128
 3bc:	fc86                	sd	ra,120(sp)
 3be:	f8a2                	sd	s0,112(sp)
 3c0:	f4a6                	sd	s1,104(sp)
 3c2:	f0ca                	sd	s2,96(sp)
 3c4:	ecce                	sd	s3,88(sp)
 3c6:	e8d2                	sd	s4,80(sp)
 3c8:	e4d6                	sd	s5,72(sp)
 3ca:	e0da                	sd	s6,64(sp)
 3cc:	fc5e                	sd	s7,56(sp)
 3ce:	f862                	sd	s8,48(sp)
 3d0:	f466                	sd	s9,40(sp)
 3d2:	f06a                	sd	s10,32(sp)
 3d4:	ec6e                	sd	s11,24(sp)
 3d6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3d8:	0005c903          	lbu	s2,0(a1)
 3dc:	18090f63          	beqz	s2,57a <vprintf+0x1c0>
 3e0:	8aaa                	mv	s5,a0
 3e2:	8b32                	mv	s6,a2
 3e4:	00158493          	addi	s1,a1,1
  state = 0;
 3e8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3ea:	02500a13          	li	s4,37
      if(c == 'd'){
 3ee:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 3f2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 3f6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 3fa:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 3fe:	00000b97          	auipc	s7,0x0
 402:	382b8b93          	addi	s7,s7,898 # 780 <digits>
 406:	a839                	j	424 <vprintf+0x6a>
        putc(fd, c);
 408:	85ca                	mv	a1,s2
 40a:	8556                	mv	a0,s5
 40c:	00000097          	auipc	ra,0x0
 410:	ee2080e7          	jalr	-286(ra) # 2ee <putc>
 414:	a019                	j	41a <vprintf+0x60>
    } else if(state == '%'){
 416:	01498f63          	beq	s3,s4,434 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 41a:	0485                	addi	s1,s1,1
 41c:	fff4c903          	lbu	s2,-1(s1)
 420:	14090d63          	beqz	s2,57a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 424:	0009079b          	sext.w	a5,s2
    if(state == 0){
 428:	fe0997e3          	bnez	s3,416 <vprintf+0x5c>
      if(c == '%'){
 42c:	fd479ee3          	bne	a5,s4,408 <vprintf+0x4e>
        state = '%';
 430:	89be                	mv	s3,a5
 432:	b7e5                	j	41a <vprintf+0x60>
      if(c == 'd'){
 434:	05878063          	beq	a5,s8,474 <vprintf+0xba>
      } else if(c == 'l') {
 438:	05978c63          	beq	a5,s9,490 <vprintf+0xd6>
      } else if(c == 'x') {
 43c:	07a78863          	beq	a5,s10,4ac <vprintf+0xf2>
      } else if(c == 'p') {
 440:	09b78463          	beq	a5,s11,4c8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 444:	07300713          	li	a4,115
 448:	0ce78663          	beq	a5,a4,514 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 44c:	06300713          	li	a4,99
 450:	0ee78e63          	beq	a5,a4,54c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 454:	11478863          	beq	a5,s4,564 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 458:	85d2                	mv	a1,s4
 45a:	8556                	mv	a0,s5
 45c:	00000097          	auipc	ra,0x0
 460:	e92080e7          	jalr	-366(ra) # 2ee <putc>
        putc(fd, c);
 464:	85ca                	mv	a1,s2
 466:	8556                	mv	a0,s5
 468:	00000097          	auipc	ra,0x0
 46c:	e86080e7          	jalr	-378(ra) # 2ee <putc>
      }
      state = 0;
 470:	4981                	li	s3,0
 472:	b765                	j	41a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 474:	008b0913          	addi	s2,s6,8
 478:	4685                	li	a3,1
 47a:	4629                	li	a2,10
 47c:	000b2583          	lw	a1,0(s6)
 480:	8556                	mv	a0,s5
 482:	00000097          	auipc	ra,0x0
 486:	e8e080e7          	jalr	-370(ra) # 310 <printint>
 48a:	8b4a                	mv	s6,s2
      state = 0;
 48c:	4981                	li	s3,0
 48e:	b771                	j	41a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 490:	008b0913          	addi	s2,s6,8
 494:	4681                	li	a3,0
 496:	4629                	li	a2,10
 498:	000b2583          	lw	a1,0(s6)
 49c:	8556                	mv	a0,s5
 49e:	00000097          	auipc	ra,0x0
 4a2:	e72080e7          	jalr	-398(ra) # 310 <printint>
 4a6:	8b4a                	mv	s6,s2
      state = 0;
 4a8:	4981                	li	s3,0
 4aa:	bf85                	j	41a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4ac:	008b0913          	addi	s2,s6,8
 4b0:	4681                	li	a3,0
 4b2:	4641                	li	a2,16
 4b4:	000b2583          	lw	a1,0(s6)
 4b8:	8556                	mv	a0,s5
 4ba:	00000097          	auipc	ra,0x0
 4be:	e56080e7          	jalr	-426(ra) # 310 <printint>
 4c2:	8b4a                	mv	s6,s2
      state = 0;
 4c4:	4981                	li	s3,0
 4c6:	bf91                	j	41a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4c8:	008b0793          	addi	a5,s6,8
 4cc:	f8f43423          	sd	a5,-120(s0)
 4d0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 4d4:	03000593          	li	a1,48
 4d8:	8556                	mv	a0,s5
 4da:	00000097          	auipc	ra,0x0
 4de:	e14080e7          	jalr	-492(ra) # 2ee <putc>
  putc(fd, 'x');
 4e2:	85ea                	mv	a1,s10
 4e4:	8556                	mv	a0,s5
 4e6:	00000097          	auipc	ra,0x0
 4ea:	e08080e7          	jalr	-504(ra) # 2ee <putc>
 4ee:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4f0:	03c9d793          	srli	a5,s3,0x3c
 4f4:	97de                	add	a5,a5,s7
 4f6:	0007c583          	lbu	a1,0(a5)
 4fa:	8556                	mv	a0,s5
 4fc:	00000097          	auipc	ra,0x0
 500:	df2080e7          	jalr	-526(ra) # 2ee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 504:	0992                	slli	s3,s3,0x4
 506:	397d                	addiw	s2,s2,-1
 508:	fe0914e3          	bnez	s2,4f0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 50c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 510:	4981                	li	s3,0
 512:	b721                	j	41a <vprintf+0x60>
        s = va_arg(ap, char*);
 514:	008b0993          	addi	s3,s6,8
 518:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 51c:	02090163          	beqz	s2,53e <vprintf+0x184>
        while(*s != 0){
 520:	00094583          	lbu	a1,0(s2)
 524:	c9a1                	beqz	a1,574 <vprintf+0x1ba>
          putc(fd, *s);
 526:	8556                	mv	a0,s5
 528:	00000097          	auipc	ra,0x0
 52c:	dc6080e7          	jalr	-570(ra) # 2ee <putc>
          s++;
 530:	0905                	addi	s2,s2,1
        while(*s != 0){
 532:	00094583          	lbu	a1,0(s2)
 536:	f9e5                	bnez	a1,526 <vprintf+0x16c>
        s = va_arg(ap, char*);
 538:	8b4e                	mv	s6,s3
      state = 0;
 53a:	4981                	li	s3,0
 53c:	bdf9                	j	41a <vprintf+0x60>
          s = "(null)";
 53e:	00000917          	auipc	s2,0x0
 542:	23a90913          	addi	s2,s2,570 # 778 <malloc+0xf4>
        while(*s != 0){
 546:	02800593          	li	a1,40
 54a:	bff1                	j	526 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 54c:	008b0913          	addi	s2,s6,8
 550:	000b4583          	lbu	a1,0(s6)
 554:	8556                	mv	a0,s5
 556:	00000097          	auipc	ra,0x0
 55a:	d98080e7          	jalr	-616(ra) # 2ee <putc>
 55e:	8b4a                	mv	s6,s2
      state = 0;
 560:	4981                	li	s3,0
 562:	bd65                	j	41a <vprintf+0x60>
        putc(fd, c);
 564:	85d2                	mv	a1,s4
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	d86080e7          	jalr	-634(ra) # 2ee <putc>
      state = 0;
 570:	4981                	li	s3,0
 572:	b565                	j	41a <vprintf+0x60>
        s = va_arg(ap, char*);
 574:	8b4e                	mv	s6,s3
      state = 0;
 576:	4981                	li	s3,0
 578:	b54d                	j	41a <vprintf+0x60>
    }
  }
}
 57a:	70e6                	ld	ra,120(sp)
 57c:	7446                	ld	s0,112(sp)
 57e:	74a6                	ld	s1,104(sp)
 580:	7906                	ld	s2,96(sp)
 582:	69e6                	ld	s3,88(sp)
 584:	6a46                	ld	s4,80(sp)
 586:	6aa6                	ld	s5,72(sp)
 588:	6b06                	ld	s6,64(sp)
 58a:	7be2                	ld	s7,56(sp)
 58c:	7c42                	ld	s8,48(sp)
 58e:	7ca2                	ld	s9,40(sp)
 590:	7d02                	ld	s10,32(sp)
 592:	6de2                	ld	s11,24(sp)
 594:	6109                	addi	sp,sp,128
 596:	8082                	ret

0000000000000598 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 598:	715d                	addi	sp,sp,-80
 59a:	ec06                	sd	ra,24(sp)
 59c:	e822                	sd	s0,16(sp)
 59e:	1000                	addi	s0,sp,32
 5a0:	e010                	sd	a2,0(s0)
 5a2:	e414                	sd	a3,8(s0)
 5a4:	e818                	sd	a4,16(s0)
 5a6:	ec1c                	sd	a5,24(s0)
 5a8:	03043023          	sd	a6,32(s0)
 5ac:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5b0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5b4:	8622                	mv	a2,s0
 5b6:	00000097          	auipc	ra,0x0
 5ba:	e04080e7          	jalr	-508(ra) # 3ba <vprintf>
}
 5be:	60e2                	ld	ra,24(sp)
 5c0:	6442                	ld	s0,16(sp)
 5c2:	6161                	addi	sp,sp,80
 5c4:	8082                	ret

00000000000005c6 <printf>:

void
printf(const char *fmt, ...)
{
 5c6:	711d                	addi	sp,sp,-96
 5c8:	ec06                	sd	ra,24(sp)
 5ca:	e822                	sd	s0,16(sp)
 5cc:	1000                	addi	s0,sp,32
 5ce:	e40c                	sd	a1,8(s0)
 5d0:	e810                	sd	a2,16(s0)
 5d2:	ec14                	sd	a3,24(s0)
 5d4:	f018                	sd	a4,32(s0)
 5d6:	f41c                	sd	a5,40(s0)
 5d8:	03043823          	sd	a6,48(s0)
 5dc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 5e0:	00840613          	addi	a2,s0,8
 5e4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 5e8:	85aa                	mv	a1,a0
 5ea:	4505                	li	a0,1
 5ec:	00000097          	auipc	ra,0x0
 5f0:	dce080e7          	jalr	-562(ra) # 3ba <vprintf>
}
 5f4:	60e2                	ld	ra,24(sp)
 5f6:	6442                	ld	s0,16(sp)
 5f8:	6125                	addi	sp,sp,96
 5fa:	8082                	ret

00000000000005fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5fc:	1141                	addi	sp,sp,-16
 5fe:	e422                	sd	s0,8(sp)
 600:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 602:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 606:	00000797          	auipc	a5,0x0
 60a:	1927b783          	ld	a5,402(a5) # 798 <freep>
 60e:	a805                	j	63e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 610:	4618                	lw	a4,8(a2)
 612:	9db9                	addw	a1,a1,a4
 614:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 618:	6398                	ld	a4,0(a5)
 61a:	6318                	ld	a4,0(a4)
 61c:	fee53823          	sd	a4,-16(a0)
 620:	a091                	j	664 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 622:	ff852703          	lw	a4,-8(a0)
 626:	9e39                	addw	a2,a2,a4
 628:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 62a:	ff053703          	ld	a4,-16(a0)
 62e:	e398                	sd	a4,0(a5)
 630:	a099                	j	676 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 632:	6398                	ld	a4,0(a5)
 634:	00e7e463          	bltu	a5,a4,63c <free+0x40>
 638:	00e6ea63          	bltu	a3,a4,64c <free+0x50>
{
 63c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63e:	fed7fae3          	bgeu	a5,a3,632 <free+0x36>
 642:	6398                	ld	a4,0(a5)
 644:	00e6e463          	bltu	a3,a4,64c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 648:	fee7eae3          	bltu	a5,a4,63c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 64c:	ff852583          	lw	a1,-8(a0)
 650:	6390                	ld	a2,0(a5)
 652:	02059813          	slli	a6,a1,0x20
 656:	01c85713          	srli	a4,a6,0x1c
 65a:	9736                	add	a4,a4,a3
 65c:	fae60ae3          	beq	a2,a4,610 <free+0x14>
    bp->s.ptr = p->s.ptr;
 660:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 664:	4790                	lw	a2,8(a5)
 666:	02061593          	slli	a1,a2,0x20
 66a:	01c5d713          	srli	a4,a1,0x1c
 66e:	973e                	add	a4,a4,a5
 670:	fae689e3          	beq	a3,a4,622 <free+0x26>
  } else
    p->s.ptr = bp;
 674:	e394                	sd	a3,0(a5)
  freep = p;
 676:	00000717          	auipc	a4,0x0
 67a:	12f73123          	sd	a5,290(a4) # 798 <freep>
}
 67e:	6422                	ld	s0,8(sp)
 680:	0141                	addi	sp,sp,16
 682:	8082                	ret

0000000000000684 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 684:	7139                	addi	sp,sp,-64
 686:	fc06                	sd	ra,56(sp)
 688:	f822                	sd	s0,48(sp)
 68a:	f426                	sd	s1,40(sp)
 68c:	f04a                	sd	s2,32(sp)
 68e:	ec4e                	sd	s3,24(sp)
 690:	e852                	sd	s4,16(sp)
 692:	e456                	sd	s5,8(sp)
 694:	e05a                	sd	s6,0(sp)
 696:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 698:	02051493          	slli	s1,a0,0x20
 69c:	9081                	srli	s1,s1,0x20
 69e:	04bd                	addi	s1,s1,15
 6a0:	8091                	srli	s1,s1,0x4
 6a2:	0014899b          	addiw	s3,s1,1
 6a6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6a8:	00000517          	auipc	a0,0x0
 6ac:	0f053503          	ld	a0,240(a0) # 798 <freep>
 6b0:	c515                	beqz	a0,6dc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6b4:	4798                	lw	a4,8(a5)
 6b6:	02977f63          	bgeu	a4,s1,6f4 <malloc+0x70>
 6ba:	8a4e                	mv	s4,s3
 6bc:	0009871b          	sext.w	a4,s3
 6c0:	6685                	lui	a3,0x1
 6c2:	00d77363          	bgeu	a4,a3,6c8 <malloc+0x44>
 6c6:	6a05                	lui	s4,0x1
 6c8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6cc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6d0:	00000917          	auipc	s2,0x0
 6d4:	0c890913          	addi	s2,s2,200 # 798 <freep>
  if(p == (char*)-1)
 6d8:	5afd                	li	s5,-1
 6da:	a895                	j	74e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 6dc:	00000797          	auipc	a5,0x0
 6e0:	0c478793          	addi	a5,a5,196 # 7a0 <base>
 6e4:	00000717          	auipc	a4,0x0
 6e8:	0af73a23          	sd	a5,180(a4) # 798 <freep>
 6ec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 6ee:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 6f2:	b7e1                	j	6ba <malloc+0x36>
      if(p->s.size == nunits)
 6f4:	02e48c63          	beq	s1,a4,72c <malloc+0xa8>
        p->s.size -= nunits;
 6f8:	4137073b          	subw	a4,a4,s3
 6fc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 6fe:	02071693          	slli	a3,a4,0x20
 702:	01c6d713          	srli	a4,a3,0x1c
 706:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 708:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 70c:	00000717          	auipc	a4,0x0
 710:	08a73623          	sd	a0,140(a4) # 798 <freep>
      return (void*)(p + 1);
 714:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 718:	70e2                	ld	ra,56(sp)
 71a:	7442                	ld	s0,48(sp)
 71c:	74a2                	ld	s1,40(sp)
 71e:	7902                	ld	s2,32(sp)
 720:	69e2                	ld	s3,24(sp)
 722:	6a42                	ld	s4,16(sp)
 724:	6aa2                	ld	s5,8(sp)
 726:	6b02                	ld	s6,0(sp)
 728:	6121                	addi	sp,sp,64
 72a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 72c:	6398                	ld	a4,0(a5)
 72e:	e118                	sd	a4,0(a0)
 730:	bff1                	j	70c <malloc+0x88>
  hp->s.size = nu;
 732:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 736:	0541                	addi	a0,a0,16
 738:	00000097          	auipc	ra,0x0
 73c:	ec4080e7          	jalr	-316(ra) # 5fc <free>
  return freep;
 740:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 744:	d971                	beqz	a0,718 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 746:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 748:	4798                	lw	a4,8(a5)
 74a:	fa9775e3          	bgeu	a4,s1,6f4 <malloc+0x70>
    if(p == freep)
 74e:	00093703          	ld	a4,0(s2)
 752:	853e                	mv	a0,a5
 754:	fef719e3          	bne	a4,a5,746 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 758:	8552                	mv	a0,s4
 75a:	00000097          	auipc	ra,0x0
 75e:	b5c080e7          	jalr	-1188(ra) # 2b6 <sbrk>
  if(p == (char*)-1)
 762:	fd5518e3          	bne	a0,s5,732 <malloc+0xae>
        return 0;
 766:	4501                	li	a0,0
 768:	bf45                	j	718 <malloc+0x94>
