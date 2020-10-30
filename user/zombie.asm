
user/_zombie：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	206080e7          	jalr	518(ra) # 20e <fork>
  10:	00a04663          	bgtz	a0,1c <main+0x1c>
    sleep(5);  // Let child exit before parent.
  exit();
  14:	00000097          	auipc	ra,0x0
  18:	202080e7          	jalr	514(ra) # 216 <exit>
    sleep(5);  // Let child exit before parent.
  1c:	4515                	li	a0,5
  1e:	00000097          	auipc	ra,0x0
  22:	288080e7          	jalr	648(ra) # 2a6 <sleep>
  26:	b7fd                	j	14 <main+0x14>

0000000000000028 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  28:	1141                	addi	sp,sp,-16
  2a:	e422                	sd	s0,8(sp)
  2c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  2e:	87aa                	mv	a5,a0
  30:	0585                	addi	a1,a1,1
  32:	0785                	addi	a5,a5,1
  34:	fff5c703          	lbu	a4,-1(a1)
  38:	fee78fa3          	sb	a4,-1(a5)
  3c:	fb75                	bnez	a4,30 <strcpy+0x8>
    ;
  return os;
}
  3e:	6422                	ld	s0,8(sp)
  40:	0141                	addi	sp,sp,16
  42:	8082                	ret

0000000000000044 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4a:	00054783          	lbu	a5,0(a0)
  4e:	cb91                	beqz	a5,62 <strcmp+0x1e>
  50:	0005c703          	lbu	a4,0(a1)
  54:	00f71763          	bne	a4,a5,62 <strcmp+0x1e>
    p++, q++;
  58:	0505                	addi	a0,a0,1
  5a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5c:	00054783          	lbu	a5,0(a0)
  60:	fbe5                	bnez	a5,50 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  62:	0005c503          	lbu	a0,0(a1)
}
  66:	40a7853b          	subw	a0,a5,a0
  6a:	6422                	ld	s0,8(sp)
  6c:	0141                	addi	sp,sp,16
  6e:	8082                	ret

0000000000000070 <strlen>:

uint
strlen(const char *s)
{
  70:	1141                	addi	sp,sp,-16
  72:	e422                	sd	s0,8(sp)
  74:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  76:	00054783          	lbu	a5,0(a0)
  7a:	cf91                	beqz	a5,96 <strlen+0x26>
  7c:	0505                	addi	a0,a0,1
  7e:	87aa                	mv	a5,a0
  80:	4685                	li	a3,1
  82:	9e89                	subw	a3,a3,a0
  84:	00f6853b          	addw	a0,a3,a5
  88:	0785                	addi	a5,a5,1
  8a:	fff7c703          	lbu	a4,-1(a5)
  8e:	fb7d                	bnez	a4,84 <strlen+0x14>
    ;
  return n;
}
  90:	6422                	ld	s0,8(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret
  for(n = 0; s[n]; n++)
  96:	4501                	li	a0,0
  98:	bfe5                	j	90 <strlen+0x20>

000000000000009a <memset>:

void*
memset(void *dst, int c, uint n)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e422                	sd	s0,8(sp)
  9e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a0:	ca19                	beqz	a2,b6 <memset+0x1c>
  a2:	87aa                	mv	a5,a0
  a4:	1602                	slli	a2,a2,0x20
  a6:	9201                	srli	a2,a2,0x20
  a8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ac:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b0:	0785                	addi	a5,a5,1
  b2:	fee79de3          	bne	a5,a4,ac <memset+0x12>
  }
  return dst;
}
  b6:	6422                	ld	s0,8(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strchr>:

char*
strchr(const char *s, char c)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e422                	sd	s0,8(sp)
  c0:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c2:	00054783          	lbu	a5,0(a0)
  c6:	cb99                	beqz	a5,dc <strchr+0x20>
    if(*s == c)
  c8:	00f58763          	beq	a1,a5,d6 <strchr+0x1a>
  for(; *s; s++)
  cc:	0505                	addi	a0,a0,1
  ce:	00054783          	lbu	a5,0(a0)
  d2:	fbfd                	bnez	a5,c8 <strchr+0xc>
      return (char*)s;
  return 0;
  d4:	4501                	li	a0,0
}
  d6:	6422                	ld	s0,8(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret
  return 0;
  dc:	4501                	li	a0,0
  de:	bfe5                	j	d6 <strchr+0x1a>

00000000000000e0 <gets>:

char*
gets(char *buf, int max)
{
  e0:	711d                	addi	sp,sp,-96
  e2:	ec86                	sd	ra,88(sp)
  e4:	e8a2                	sd	s0,80(sp)
  e6:	e4a6                	sd	s1,72(sp)
  e8:	e0ca                	sd	s2,64(sp)
  ea:	fc4e                	sd	s3,56(sp)
  ec:	f852                	sd	s4,48(sp)
  ee:	f456                	sd	s5,40(sp)
  f0:	f05a                	sd	s6,32(sp)
  f2:	ec5e                	sd	s7,24(sp)
  f4:	1080                	addi	s0,sp,96
  f6:	8baa                	mv	s7,a0
  f8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fa:	892a                	mv	s2,a0
  fc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  fe:	4aa9                	li	s5,10
 100:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 102:	89a6                	mv	s3,s1
 104:	2485                	addiw	s1,s1,1
 106:	0344d863          	bge	s1,s4,136 <gets+0x56>
    cc = read(0, &c, 1);
 10a:	4605                	li	a2,1
 10c:	faf40593          	addi	a1,s0,-81
 110:	4501                	li	a0,0
 112:	00000097          	auipc	ra,0x0
 116:	11c080e7          	jalr	284(ra) # 22e <read>
    if(cc < 1)
 11a:	00a05e63          	blez	a0,136 <gets+0x56>
    buf[i++] = c;
 11e:	faf44783          	lbu	a5,-81(s0)
 122:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 126:	01578763          	beq	a5,s5,134 <gets+0x54>
 12a:	0905                	addi	s2,s2,1
 12c:	fd679be3          	bne	a5,s6,102 <gets+0x22>
  for(i=0; i+1 < max; ){
 130:	89a6                	mv	s3,s1
 132:	a011                	j	136 <gets+0x56>
 134:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 136:	99de                	add	s3,s3,s7
 138:	00098023          	sb	zero,0(s3)
  return buf;
}
 13c:	855e                	mv	a0,s7
 13e:	60e6                	ld	ra,88(sp)
 140:	6446                	ld	s0,80(sp)
 142:	64a6                	ld	s1,72(sp)
 144:	6906                	ld	s2,64(sp)
 146:	79e2                	ld	s3,56(sp)
 148:	7a42                	ld	s4,48(sp)
 14a:	7aa2                	ld	s5,40(sp)
 14c:	7b02                	ld	s6,32(sp)
 14e:	6be2                	ld	s7,24(sp)
 150:	6125                	addi	sp,sp,96
 152:	8082                	ret

0000000000000154 <stat>:

int
stat(const char *n, struct stat *st)
{
 154:	1101                	addi	sp,sp,-32
 156:	ec06                	sd	ra,24(sp)
 158:	e822                	sd	s0,16(sp)
 15a:	e426                	sd	s1,8(sp)
 15c:	e04a                	sd	s2,0(sp)
 15e:	1000                	addi	s0,sp,32
 160:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 162:	4581                	li	a1,0
 164:	00000097          	auipc	ra,0x0
 168:	0f2080e7          	jalr	242(ra) # 256 <open>
  if(fd < 0)
 16c:	02054563          	bltz	a0,196 <stat+0x42>
 170:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 172:	85ca                	mv	a1,s2
 174:	00000097          	auipc	ra,0x0
 178:	0fa080e7          	jalr	250(ra) # 26e <fstat>
 17c:	892a                	mv	s2,a0
  close(fd);
 17e:	8526                	mv	a0,s1
 180:	00000097          	auipc	ra,0x0
 184:	0be080e7          	jalr	190(ra) # 23e <close>
  return r;
}
 188:	854a                	mv	a0,s2
 18a:	60e2                	ld	ra,24(sp)
 18c:	6442                	ld	s0,16(sp)
 18e:	64a2                	ld	s1,8(sp)
 190:	6902                	ld	s2,0(sp)
 192:	6105                	addi	sp,sp,32
 194:	8082                	ret
    return -1;
 196:	597d                	li	s2,-1
 198:	bfc5                	j	188 <stat+0x34>

000000000000019a <atoi>:

int
atoi(const char *s)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e422                	sd	s0,8(sp)
 19e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a0:	00054603          	lbu	a2,0(a0)
 1a4:	fd06079b          	addiw	a5,a2,-48
 1a8:	0ff7f793          	andi	a5,a5,255
 1ac:	4725                	li	a4,9
 1ae:	02f76963          	bltu	a4,a5,1e0 <atoi+0x46>
 1b2:	86aa                	mv	a3,a0
  n = 0;
 1b4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1b6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1b8:	0685                	addi	a3,a3,1
 1ba:	0025179b          	slliw	a5,a0,0x2
 1be:	9fa9                	addw	a5,a5,a0
 1c0:	0017979b          	slliw	a5,a5,0x1
 1c4:	9fb1                	addw	a5,a5,a2
 1c6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ca:	0006c603          	lbu	a2,0(a3)
 1ce:	fd06071b          	addiw	a4,a2,-48
 1d2:	0ff77713          	andi	a4,a4,255
 1d6:	fee5f1e3          	bgeu	a1,a4,1b8 <atoi+0x1e>
  return n;
}
 1da:	6422                	ld	s0,8(sp)
 1dc:	0141                	addi	sp,sp,16
 1de:	8082                	ret
  n = 0;
 1e0:	4501                	li	a0,0
 1e2:	bfe5                	j	1da <atoi+0x40>

00000000000001e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e422                	sd	s0,8(sp)
 1e8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1ea:	00c05f63          	blez	a2,208 <memmove+0x24>
 1ee:	1602                	slli	a2,a2,0x20
 1f0:	9201                	srli	a2,a2,0x20
 1f2:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 1f6:	87aa                	mv	a5,a0
    *dst++ = *src++;
 1f8:	0585                	addi	a1,a1,1
 1fa:	0785                	addi	a5,a5,1
 1fc:	fff5c703          	lbu	a4,-1(a1)
 200:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 204:	fed79ae3          	bne	a5,a3,1f8 <memmove+0x14>
  return vdst;
}
 208:	6422                	ld	s0,8(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret

000000000000020e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 20e:	4885                	li	a7,1
 ecall
 210:	00000073          	ecall
 ret
 214:	8082                	ret

0000000000000216 <exit>:
.global exit
exit:
 li a7, SYS_exit
 216:	4889                	li	a7,2
 ecall
 218:	00000073          	ecall
 ret
 21c:	8082                	ret

000000000000021e <wait>:
.global wait
wait:
 li a7, SYS_wait
 21e:	488d                	li	a7,3
 ecall
 220:	00000073          	ecall
 ret
 224:	8082                	ret

0000000000000226 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 226:	4891                	li	a7,4
 ecall
 228:	00000073          	ecall
 ret
 22c:	8082                	ret

000000000000022e <read>:
.global read
read:
 li a7, SYS_read
 22e:	4895                	li	a7,5
 ecall
 230:	00000073          	ecall
 ret
 234:	8082                	ret

0000000000000236 <write>:
.global write
write:
 li a7, SYS_write
 236:	48c1                	li	a7,16
 ecall
 238:	00000073          	ecall
 ret
 23c:	8082                	ret

000000000000023e <close>:
.global close
close:
 li a7, SYS_close
 23e:	48d5                	li	a7,21
 ecall
 240:	00000073          	ecall
 ret
 244:	8082                	ret

0000000000000246 <kill>:
.global kill
kill:
 li a7, SYS_kill
 246:	4899                	li	a7,6
 ecall
 248:	00000073          	ecall
 ret
 24c:	8082                	ret

000000000000024e <exec>:
.global exec
exec:
 li a7, SYS_exec
 24e:	489d                	li	a7,7
 ecall
 250:	00000073          	ecall
 ret
 254:	8082                	ret

0000000000000256 <open>:
.global open
open:
 li a7, SYS_open
 256:	48bd                	li	a7,15
 ecall
 258:	00000073          	ecall
 ret
 25c:	8082                	ret

000000000000025e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 25e:	48c5                	li	a7,17
 ecall
 260:	00000073          	ecall
 ret
 264:	8082                	ret

0000000000000266 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 266:	48c9                	li	a7,18
 ecall
 268:	00000073          	ecall
 ret
 26c:	8082                	ret

000000000000026e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 26e:	48a1                	li	a7,8
 ecall
 270:	00000073          	ecall
 ret
 274:	8082                	ret

0000000000000276 <link>:
.global link
link:
 li a7, SYS_link
 276:	48cd                	li	a7,19
 ecall
 278:	00000073          	ecall
 ret
 27c:	8082                	ret

000000000000027e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 27e:	48d1                	li	a7,20
 ecall
 280:	00000073          	ecall
 ret
 284:	8082                	ret

0000000000000286 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 286:	48a5                	li	a7,9
 ecall
 288:	00000073          	ecall
 ret
 28c:	8082                	ret

000000000000028e <dup>:
.global dup
dup:
 li a7, SYS_dup
 28e:	48a9                	li	a7,10
 ecall
 290:	00000073          	ecall
 ret
 294:	8082                	ret

0000000000000296 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 296:	48ad                	li	a7,11
 ecall
 298:	00000073          	ecall
 ret
 29c:	8082                	ret

000000000000029e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 29e:	48b1                	li	a7,12
 ecall
 2a0:	00000073          	ecall
 ret
 2a4:	8082                	ret

00000000000002a6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2a6:	48b5                	li	a7,13
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 2ae:	48b9                	li	a7,14
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 2b6:	48d9                	li	a7,22
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <crash>:
.global crash
crash:
 li a7, SYS_crash
 2be:	48dd                	li	a7,23
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <mount>:
.global mount
mount:
 li a7, SYS_mount
 2c6:	48e1                	li	a7,24
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <umount>:
.global umount
umount:
 li a7, SYS_umount
 2ce:	48e5                	li	a7,25
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 2d6:	1101                	addi	sp,sp,-32
 2d8:	ec06                	sd	ra,24(sp)
 2da:	e822                	sd	s0,16(sp)
 2dc:	1000                	addi	s0,sp,32
 2de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 2e2:	4605                	li	a2,1
 2e4:	fef40593          	addi	a1,s0,-17
 2e8:	00000097          	auipc	ra,0x0
 2ec:	f4e080e7          	jalr	-178(ra) # 236 <write>
}
 2f0:	60e2                	ld	ra,24(sp)
 2f2:	6442                	ld	s0,16(sp)
 2f4:	6105                	addi	sp,sp,32
 2f6:	8082                	ret

00000000000002f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2f8:	7139                	addi	sp,sp,-64
 2fa:	fc06                	sd	ra,56(sp)
 2fc:	f822                	sd	s0,48(sp)
 2fe:	f426                	sd	s1,40(sp)
 300:	f04a                	sd	s2,32(sp)
 302:	ec4e                	sd	s3,24(sp)
 304:	0080                	addi	s0,sp,64
 306:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 308:	c299                	beqz	a3,30e <printint+0x16>
 30a:	0805c863          	bltz	a1,39a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 30e:	2581                	sext.w	a1,a1
  neg = 0;
 310:	4881                	li	a7,0
 312:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 316:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 318:	2601                	sext.w	a2,a2
 31a:	00000517          	auipc	a0,0x0
 31e:	44650513          	addi	a0,a0,1094 # 760 <digits>
 322:	883a                	mv	a6,a4
 324:	2705                	addiw	a4,a4,1
 326:	02c5f7bb          	remuw	a5,a1,a2
 32a:	1782                	slli	a5,a5,0x20
 32c:	9381                	srli	a5,a5,0x20
 32e:	97aa                	add	a5,a5,a0
 330:	0007c783          	lbu	a5,0(a5)
 334:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 338:	0005879b          	sext.w	a5,a1
 33c:	02c5d5bb          	divuw	a1,a1,a2
 340:	0685                	addi	a3,a3,1
 342:	fec7f0e3          	bgeu	a5,a2,322 <printint+0x2a>
  if(neg)
 346:	00088b63          	beqz	a7,35c <printint+0x64>
    buf[i++] = '-';
 34a:	fd040793          	addi	a5,s0,-48
 34e:	973e                	add	a4,a4,a5
 350:	02d00793          	li	a5,45
 354:	fef70823          	sb	a5,-16(a4)
 358:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 35c:	02e05863          	blez	a4,38c <printint+0x94>
 360:	fc040793          	addi	a5,s0,-64
 364:	00e78933          	add	s2,a5,a4
 368:	fff78993          	addi	s3,a5,-1
 36c:	99ba                	add	s3,s3,a4
 36e:	377d                	addiw	a4,a4,-1
 370:	1702                	slli	a4,a4,0x20
 372:	9301                	srli	a4,a4,0x20
 374:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 378:	fff94583          	lbu	a1,-1(s2)
 37c:	8526                	mv	a0,s1
 37e:	00000097          	auipc	ra,0x0
 382:	f58080e7          	jalr	-168(ra) # 2d6 <putc>
  while(--i >= 0)
 386:	197d                	addi	s2,s2,-1
 388:	ff3918e3          	bne	s2,s3,378 <printint+0x80>
}
 38c:	70e2                	ld	ra,56(sp)
 38e:	7442                	ld	s0,48(sp)
 390:	74a2                	ld	s1,40(sp)
 392:	7902                	ld	s2,32(sp)
 394:	69e2                	ld	s3,24(sp)
 396:	6121                	addi	sp,sp,64
 398:	8082                	ret
    x = -xx;
 39a:	40b005bb          	negw	a1,a1
    neg = 1;
 39e:	4885                	li	a7,1
    x = -xx;
 3a0:	bf8d                	j	312 <printint+0x1a>

00000000000003a2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3a2:	7119                	addi	sp,sp,-128
 3a4:	fc86                	sd	ra,120(sp)
 3a6:	f8a2                	sd	s0,112(sp)
 3a8:	f4a6                	sd	s1,104(sp)
 3aa:	f0ca                	sd	s2,96(sp)
 3ac:	ecce                	sd	s3,88(sp)
 3ae:	e8d2                	sd	s4,80(sp)
 3b0:	e4d6                	sd	s5,72(sp)
 3b2:	e0da                	sd	s6,64(sp)
 3b4:	fc5e                	sd	s7,56(sp)
 3b6:	f862                	sd	s8,48(sp)
 3b8:	f466                	sd	s9,40(sp)
 3ba:	f06a                	sd	s10,32(sp)
 3bc:	ec6e                	sd	s11,24(sp)
 3be:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3c0:	0005c903          	lbu	s2,0(a1)
 3c4:	18090f63          	beqz	s2,562 <vprintf+0x1c0>
 3c8:	8aaa                	mv	s5,a0
 3ca:	8b32                	mv	s6,a2
 3cc:	00158493          	addi	s1,a1,1
  state = 0;
 3d0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3d2:	02500a13          	li	s4,37
      if(c == 'd'){
 3d6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 3da:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 3de:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 3e2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 3e6:	00000b97          	auipc	s7,0x0
 3ea:	37ab8b93          	addi	s7,s7,890 # 760 <digits>
 3ee:	a839                	j	40c <vprintf+0x6a>
        putc(fd, c);
 3f0:	85ca                	mv	a1,s2
 3f2:	8556                	mv	a0,s5
 3f4:	00000097          	auipc	ra,0x0
 3f8:	ee2080e7          	jalr	-286(ra) # 2d6 <putc>
 3fc:	a019                	j	402 <vprintf+0x60>
    } else if(state == '%'){
 3fe:	01498f63          	beq	s3,s4,41c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 402:	0485                	addi	s1,s1,1
 404:	fff4c903          	lbu	s2,-1(s1)
 408:	14090d63          	beqz	s2,562 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 40c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 410:	fe0997e3          	bnez	s3,3fe <vprintf+0x5c>
      if(c == '%'){
 414:	fd479ee3          	bne	a5,s4,3f0 <vprintf+0x4e>
        state = '%';
 418:	89be                	mv	s3,a5
 41a:	b7e5                	j	402 <vprintf+0x60>
      if(c == 'd'){
 41c:	05878063          	beq	a5,s8,45c <vprintf+0xba>
      } else if(c == 'l') {
 420:	05978c63          	beq	a5,s9,478 <vprintf+0xd6>
      } else if(c == 'x') {
 424:	07a78863          	beq	a5,s10,494 <vprintf+0xf2>
      } else if(c == 'p') {
 428:	09b78463          	beq	a5,s11,4b0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 42c:	07300713          	li	a4,115
 430:	0ce78663          	beq	a5,a4,4fc <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 434:	06300713          	li	a4,99
 438:	0ee78e63          	beq	a5,a4,534 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 43c:	11478863          	beq	a5,s4,54c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 440:	85d2                	mv	a1,s4
 442:	8556                	mv	a0,s5
 444:	00000097          	auipc	ra,0x0
 448:	e92080e7          	jalr	-366(ra) # 2d6 <putc>
        putc(fd, c);
 44c:	85ca                	mv	a1,s2
 44e:	8556                	mv	a0,s5
 450:	00000097          	auipc	ra,0x0
 454:	e86080e7          	jalr	-378(ra) # 2d6 <putc>
      }
      state = 0;
 458:	4981                	li	s3,0
 45a:	b765                	j	402 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 45c:	008b0913          	addi	s2,s6,8
 460:	4685                	li	a3,1
 462:	4629                	li	a2,10
 464:	000b2583          	lw	a1,0(s6)
 468:	8556                	mv	a0,s5
 46a:	00000097          	auipc	ra,0x0
 46e:	e8e080e7          	jalr	-370(ra) # 2f8 <printint>
 472:	8b4a                	mv	s6,s2
      state = 0;
 474:	4981                	li	s3,0
 476:	b771                	j	402 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 478:	008b0913          	addi	s2,s6,8
 47c:	4681                	li	a3,0
 47e:	4629                	li	a2,10
 480:	000b2583          	lw	a1,0(s6)
 484:	8556                	mv	a0,s5
 486:	00000097          	auipc	ra,0x0
 48a:	e72080e7          	jalr	-398(ra) # 2f8 <printint>
 48e:	8b4a                	mv	s6,s2
      state = 0;
 490:	4981                	li	s3,0
 492:	bf85                	j	402 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 494:	008b0913          	addi	s2,s6,8
 498:	4681                	li	a3,0
 49a:	4641                	li	a2,16
 49c:	000b2583          	lw	a1,0(s6)
 4a0:	8556                	mv	a0,s5
 4a2:	00000097          	auipc	ra,0x0
 4a6:	e56080e7          	jalr	-426(ra) # 2f8 <printint>
 4aa:	8b4a                	mv	s6,s2
      state = 0;
 4ac:	4981                	li	s3,0
 4ae:	bf91                	j	402 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4b0:	008b0793          	addi	a5,s6,8
 4b4:	f8f43423          	sd	a5,-120(s0)
 4b8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 4bc:	03000593          	li	a1,48
 4c0:	8556                	mv	a0,s5
 4c2:	00000097          	auipc	ra,0x0
 4c6:	e14080e7          	jalr	-492(ra) # 2d6 <putc>
  putc(fd, 'x');
 4ca:	85ea                	mv	a1,s10
 4cc:	8556                	mv	a0,s5
 4ce:	00000097          	auipc	ra,0x0
 4d2:	e08080e7          	jalr	-504(ra) # 2d6 <putc>
 4d6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4d8:	03c9d793          	srli	a5,s3,0x3c
 4dc:	97de                	add	a5,a5,s7
 4de:	0007c583          	lbu	a1,0(a5)
 4e2:	8556                	mv	a0,s5
 4e4:	00000097          	auipc	ra,0x0
 4e8:	df2080e7          	jalr	-526(ra) # 2d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 4ec:	0992                	slli	s3,s3,0x4
 4ee:	397d                	addiw	s2,s2,-1
 4f0:	fe0914e3          	bnez	s2,4d8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 4f4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 4f8:	4981                	li	s3,0
 4fa:	b721                	j	402 <vprintf+0x60>
        s = va_arg(ap, char*);
 4fc:	008b0993          	addi	s3,s6,8
 500:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 504:	02090163          	beqz	s2,526 <vprintf+0x184>
        while(*s != 0){
 508:	00094583          	lbu	a1,0(s2)
 50c:	c9a1                	beqz	a1,55c <vprintf+0x1ba>
          putc(fd, *s);
 50e:	8556                	mv	a0,s5
 510:	00000097          	auipc	ra,0x0
 514:	dc6080e7          	jalr	-570(ra) # 2d6 <putc>
          s++;
 518:	0905                	addi	s2,s2,1
        while(*s != 0){
 51a:	00094583          	lbu	a1,0(s2)
 51e:	f9e5                	bnez	a1,50e <vprintf+0x16c>
        s = va_arg(ap, char*);
 520:	8b4e                	mv	s6,s3
      state = 0;
 522:	4981                	li	s3,0
 524:	bdf9                	j	402 <vprintf+0x60>
          s = "(null)";
 526:	00000917          	auipc	s2,0x0
 52a:	23290913          	addi	s2,s2,562 # 758 <malloc+0xec>
        while(*s != 0){
 52e:	02800593          	li	a1,40
 532:	bff1                	j	50e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 534:	008b0913          	addi	s2,s6,8
 538:	000b4583          	lbu	a1,0(s6)
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	d98080e7          	jalr	-616(ra) # 2d6 <putc>
 546:	8b4a                	mv	s6,s2
      state = 0;
 548:	4981                	li	s3,0
 54a:	bd65                	j	402 <vprintf+0x60>
        putc(fd, c);
 54c:	85d2                	mv	a1,s4
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	d86080e7          	jalr	-634(ra) # 2d6 <putc>
      state = 0;
 558:	4981                	li	s3,0
 55a:	b565                	j	402 <vprintf+0x60>
        s = va_arg(ap, char*);
 55c:	8b4e                	mv	s6,s3
      state = 0;
 55e:	4981                	li	s3,0
 560:	b54d                	j	402 <vprintf+0x60>
    }
  }
}
 562:	70e6                	ld	ra,120(sp)
 564:	7446                	ld	s0,112(sp)
 566:	74a6                	ld	s1,104(sp)
 568:	7906                	ld	s2,96(sp)
 56a:	69e6                	ld	s3,88(sp)
 56c:	6a46                	ld	s4,80(sp)
 56e:	6aa6                	ld	s5,72(sp)
 570:	6b06                	ld	s6,64(sp)
 572:	7be2                	ld	s7,56(sp)
 574:	7c42                	ld	s8,48(sp)
 576:	7ca2                	ld	s9,40(sp)
 578:	7d02                	ld	s10,32(sp)
 57a:	6de2                	ld	s11,24(sp)
 57c:	6109                	addi	sp,sp,128
 57e:	8082                	ret

0000000000000580 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 580:	715d                	addi	sp,sp,-80
 582:	ec06                	sd	ra,24(sp)
 584:	e822                	sd	s0,16(sp)
 586:	1000                	addi	s0,sp,32
 588:	e010                	sd	a2,0(s0)
 58a:	e414                	sd	a3,8(s0)
 58c:	e818                	sd	a4,16(s0)
 58e:	ec1c                	sd	a5,24(s0)
 590:	03043023          	sd	a6,32(s0)
 594:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 598:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 59c:	8622                	mv	a2,s0
 59e:	00000097          	auipc	ra,0x0
 5a2:	e04080e7          	jalr	-508(ra) # 3a2 <vprintf>
}
 5a6:	60e2                	ld	ra,24(sp)
 5a8:	6442                	ld	s0,16(sp)
 5aa:	6161                	addi	sp,sp,80
 5ac:	8082                	ret

00000000000005ae <printf>:

void
printf(const char *fmt, ...)
{
 5ae:	711d                	addi	sp,sp,-96
 5b0:	ec06                	sd	ra,24(sp)
 5b2:	e822                	sd	s0,16(sp)
 5b4:	1000                	addi	s0,sp,32
 5b6:	e40c                	sd	a1,8(s0)
 5b8:	e810                	sd	a2,16(s0)
 5ba:	ec14                	sd	a3,24(s0)
 5bc:	f018                	sd	a4,32(s0)
 5be:	f41c                	sd	a5,40(s0)
 5c0:	03043823          	sd	a6,48(s0)
 5c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 5c8:	00840613          	addi	a2,s0,8
 5cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 5d0:	85aa                	mv	a1,a0
 5d2:	4505                	li	a0,1
 5d4:	00000097          	auipc	ra,0x0
 5d8:	dce080e7          	jalr	-562(ra) # 3a2 <vprintf>
}
 5dc:	60e2                	ld	ra,24(sp)
 5de:	6442                	ld	s0,16(sp)
 5e0:	6125                	addi	sp,sp,96
 5e2:	8082                	ret

00000000000005e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e4:	1141                	addi	sp,sp,-16
 5e6:	e422                	sd	s0,8(sp)
 5e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ee:	00000797          	auipc	a5,0x0
 5f2:	18a7b783          	ld	a5,394(a5) # 778 <freep>
 5f6:	a805                	j	626 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 5f8:	4618                	lw	a4,8(a2)
 5fa:	9db9                	addw	a1,a1,a4
 5fc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 600:	6398                	ld	a4,0(a5)
 602:	6318                	ld	a4,0(a4)
 604:	fee53823          	sd	a4,-16(a0)
 608:	a091                	j	64c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 60a:	ff852703          	lw	a4,-8(a0)
 60e:	9e39                	addw	a2,a2,a4
 610:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 612:	ff053703          	ld	a4,-16(a0)
 616:	e398                	sd	a4,0(a5)
 618:	a099                	j	65e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61a:	6398                	ld	a4,0(a5)
 61c:	00e7e463          	bltu	a5,a4,624 <free+0x40>
 620:	00e6ea63          	bltu	a3,a4,634 <free+0x50>
{
 624:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 626:	fed7fae3          	bgeu	a5,a3,61a <free+0x36>
 62a:	6398                	ld	a4,0(a5)
 62c:	00e6e463          	bltu	a3,a4,634 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 630:	fee7eae3          	bltu	a5,a4,624 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 634:	ff852583          	lw	a1,-8(a0)
 638:	6390                	ld	a2,0(a5)
 63a:	02059813          	slli	a6,a1,0x20
 63e:	01c85713          	srli	a4,a6,0x1c
 642:	9736                	add	a4,a4,a3
 644:	fae60ae3          	beq	a2,a4,5f8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 648:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 64c:	4790                	lw	a2,8(a5)
 64e:	02061593          	slli	a1,a2,0x20
 652:	01c5d713          	srli	a4,a1,0x1c
 656:	973e                	add	a4,a4,a5
 658:	fae689e3          	beq	a3,a4,60a <free+0x26>
  } else
    p->s.ptr = bp;
 65c:	e394                	sd	a3,0(a5)
  freep = p;
 65e:	00000717          	auipc	a4,0x0
 662:	10f73d23          	sd	a5,282(a4) # 778 <freep>
}
 666:	6422                	ld	s0,8(sp)
 668:	0141                	addi	sp,sp,16
 66a:	8082                	ret

000000000000066c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 66c:	7139                	addi	sp,sp,-64
 66e:	fc06                	sd	ra,56(sp)
 670:	f822                	sd	s0,48(sp)
 672:	f426                	sd	s1,40(sp)
 674:	f04a                	sd	s2,32(sp)
 676:	ec4e                	sd	s3,24(sp)
 678:	e852                	sd	s4,16(sp)
 67a:	e456                	sd	s5,8(sp)
 67c:	e05a                	sd	s6,0(sp)
 67e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 680:	02051493          	slli	s1,a0,0x20
 684:	9081                	srli	s1,s1,0x20
 686:	04bd                	addi	s1,s1,15
 688:	8091                	srli	s1,s1,0x4
 68a:	0014899b          	addiw	s3,s1,1
 68e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 690:	00000517          	auipc	a0,0x0
 694:	0e853503          	ld	a0,232(a0) # 778 <freep>
 698:	c515                	beqz	a0,6c4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 69a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 69c:	4798                	lw	a4,8(a5)
 69e:	02977f63          	bgeu	a4,s1,6dc <malloc+0x70>
 6a2:	8a4e                	mv	s4,s3
 6a4:	0009871b          	sext.w	a4,s3
 6a8:	6685                	lui	a3,0x1
 6aa:	00d77363          	bgeu	a4,a3,6b0 <malloc+0x44>
 6ae:	6a05                	lui	s4,0x1
 6b0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6b4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6b8:	00000917          	auipc	s2,0x0
 6bc:	0c090913          	addi	s2,s2,192 # 778 <freep>
  if(p == (char*)-1)
 6c0:	5afd                	li	s5,-1
 6c2:	a895                	j	736 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 6c4:	00000797          	auipc	a5,0x0
 6c8:	0bc78793          	addi	a5,a5,188 # 780 <base>
 6cc:	00000717          	auipc	a4,0x0
 6d0:	0af73623          	sd	a5,172(a4) # 778 <freep>
 6d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 6d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 6da:	b7e1                	j	6a2 <malloc+0x36>
      if(p->s.size == nunits)
 6dc:	02e48c63          	beq	s1,a4,714 <malloc+0xa8>
        p->s.size -= nunits;
 6e0:	4137073b          	subw	a4,a4,s3
 6e4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 6e6:	02071693          	slli	a3,a4,0x20
 6ea:	01c6d713          	srli	a4,a3,0x1c
 6ee:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 6f0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 6f4:	00000717          	auipc	a4,0x0
 6f8:	08a73223          	sd	a0,132(a4) # 778 <freep>
      return (void*)(p + 1);
 6fc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 700:	70e2                	ld	ra,56(sp)
 702:	7442                	ld	s0,48(sp)
 704:	74a2                	ld	s1,40(sp)
 706:	7902                	ld	s2,32(sp)
 708:	69e2                	ld	s3,24(sp)
 70a:	6a42                	ld	s4,16(sp)
 70c:	6aa2                	ld	s5,8(sp)
 70e:	6b02                	ld	s6,0(sp)
 710:	6121                	addi	sp,sp,64
 712:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 714:	6398                	ld	a4,0(a5)
 716:	e118                	sd	a4,0(a0)
 718:	bff1                	j	6f4 <malloc+0x88>
  hp->s.size = nu;
 71a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 71e:	0541                	addi	a0,a0,16
 720:	00000097          	auipc	ra,0x0
 724:	ec4080e7          	jalr	-316(ra) # 5e4 <free>
  return freep;
 728:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 72c:	d971                	beqz	a0,700 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 730:	4798                	lw	a4,8(a5)
 732:	fa9775e3          	bgeu	a4,s1,6dc <malloc+0x70>
    if(p == freep)
 736:	00093703          	ld	a4,0(s2)
 73a:	853e                	mv	a0,a5
 73c:	fef719e3          	bne	a4,a5,72e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 740:	8552                	mv	a0,s4
 742:	00000097          	auipc	ra,0x0
 746:	b5c080e7          	jalr	-1188(ra) # 29e <sbrk>
  if(p == (char*)-1)
 74a:	fd5518e3          	bne	a0,s5,71a <malloc+0xae>
        return 0;
 74e:	4501                	li	a0,0
 750:	bf45                	j	700 <malloc+0x94>
