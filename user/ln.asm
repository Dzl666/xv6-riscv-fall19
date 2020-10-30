
user/_ln：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  if(argc != 3){
   a:	478d                	li	a5,3
   c:	00f50f63          	beq	a0,a5,2a <main+0x2a>
    fprintf(2, "Usage: ln old new\n");
  10:	00000597          	auipc	a1,0x0
  14:	77858593          	addi	a1,a1,1912 # 788 <malloc+0xe8>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	59a080e7          	jalr	1434(ra) # 5b4 <fprintf>
    exit();
  22:	00000097          	auipc	ra,0x0
  26:	228080e7          	jalr	552(ra) # 24a <exit>
  2a:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  2c:	698c                	ld	a1,16(a1)
  2e:	6488                	ld	a0,8(s1)
  30:	00000097          	auipc	ra,0x0
  34:	27a080e7          	jalr	634(ra) # 2aa <link>
  38:	00054663          	bltz	a0,44 <main+0x44>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  3c:	00000097          	auipc	ra,0x0
  40:	20e080e7          	jalr	526(ra) # 24a <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  44:	6894                	ld	a3,16(s1)
  46:	6490                	ld	a2,8(s1)
  48:	00000597          	auipc	a1,0x0
  4c:	75858593          	addi	a1,a1,1880 # 7a0 <malloc+0x100>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	562080e7          	jalr	1378(ra) # 5b4 <fprintf>
  5a:	b7cd                	j	3c <main+0x3c>

000000000000005c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  5c:	1141                	addi	sp,sp,-16
  5e:	e422                	sd	s0,8(sp)
  60:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  62:	87aa                	mv	a5,a0
  64:	0585                	addi	a1,a1,1
  66:	0785                	addi	a5,a5,1
  68:	fff5c703          	lbu	a4,-1(a1)
  6c:	fee78fa3          	sb	a4,-1(a5)
  70:	fb75                	bnez	a4,64 <strcpy+0x8>
    ;
  return os;
}
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  7e:	00054783          	lbu	a5,0(a0)
  82:	cb91                	beqz	a5,96 <strcmp+0x1e>
  84:	0005c703          	lbu	a4,0(a1)
  88:	00f71763          	bne	a4,a5,96 <strcmp+0x1e>
    p++, q++;
  8c:	0505                	addi	a0,a0,1
  8e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  90:	00054783          	lbu	a5,0(a0)
  94:	fbe5                	bnez	a5,84 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  96:	0005c503          	lbu	a0,0(a1)
}
  9a:	40a7853b          	subw	a0,a5,a0
  9e:	6422                	ld	s0,8(sp)
  a0:	0141                	addi	sp,sp,16
  a2:	8082                	ret

00000000000000a4 <strlen>:

uint
strlen(const char *s)
{
  a4:	1141                	addi	sp,sp,-16
  a6:	e422                	sd	s0,8(sp)
  a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  aa:	00054783          	lbu	a5,0(a0)
  ae:	cf91                	beqz	a5,ca <strlen+0x26>
  b0:	0505                	addi	a0,a0,1
  b2:	87aa                	mv	a5,a0
  b4:	4685                	li	a3,1
  b6:	9e89                	subw	a3,a3,a0
  b8:	00f6853b          	addw	a0,a3,a5
  bc:	0785                	addi	a5,a5,1
  be:	fff7c703          	lbu	a4,-1(a5)
  c2:	fb7d                	bnez	a4,b8 <strlen+0x14>
    ;
  return n;
}
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret
  for(n = 0; s[n]; n++)
  ca:	4501                	li	a0,0
  cc:	bfe5                	j	c4 <strlen+0x20>

00000000000000ce <memset>:

void*
memset(void *dst, int c, uint n)
{
  ce:	1141                	addi	sp,sp,-16
  d0:	e422                	sd	s0,8(sp)
  d2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d4:	ca19                	beqz	a2,ea <memset+0x1c>
  d6:	87aa                	mv	a5,a0
  d8:	1602                	slli	a2,a2,0x20
  da:	9201                	srli	a2,a2,0x20
  dc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  e4:	0785                	addi	a5,a5,1
  e6:	fee79de3          	bne	a5,a4,e0 <memset+0x12>
  }
  return dst;
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret

00000000000000f0 <strchr>:

char*
strchr(const char *s, char c)
{
  f0:	1141                	addi	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	addi	s0,sp,16
  for(; *s; s++)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cb99                	beqz	a5,110 <strchr+0x20>
    if(*s == c)
  fc:	00f58763          	beq	a1,a5,10a <strchr+0x1a>
  for(; *s; s++)
 100:	0505                	addi	a0,a0,1
 102:	00054783          	lbu	a5,0(a0)
 106:	fbfd                	bnez	a5,fc <strchr+0xc>
      return (char*)s;
  return 0;
 108:	4501                	li	a0,0
}
 10a:	6422                	ld	s0,8(sp)
 10c:	0141                	addi	sp,sp,16
 10e:	8082                	ret
  return 0;
 110:	4501                	li	a0,0
 112:	bfe5                	j	10a <strchr+0x1a>

0000000000000114 <gets>:

char*
gets(char *buf, int max)
{
 114:	711d                	addi	sp,sp,-96
 116:	ec86                	sd	ra,88(sp)
 118:	e8a2                	sd	s0,80(sp)
 11a:	e4a6                	sd	s1,72(sp)
 11c:	e0ca                	sd	s2,64(sp)
 11e:	fc4e                	sd	s3,56(sp)
 120:	f852                	sd	s4,48(sp)
 122:	f456                	sd	s5,40(sp)
 124:	f05a                	sd	s6,32(sp)
 126:	ec5e                	sd	s7,24(sp)
 128:	1080                	addi	s0,sp,96
 12a:	8baa                	mv	s7,a0
 12c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12e:	892a                	mv	s2,a0
 130:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 132:	4aa9                	li	s5,10
 134:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 136:	89a6                	mv	s3,s1
 138:	2485                	addiw	s1,s1,1
 13a:	0344d863          	bge	s1,s4,16a <gets+0x56>
    cc = read(0, &c, 1);
 13e:	4605                	li	a2,1
 140:	faf40593          	addi	a1,s0,-81
 144:	4501                	li	a0,0
 146:	00000097          	auipc	ra,0x0
 14a:	11c080e7          	jalr	284(ra) # 262 <read>
    if(cc < 1)
 14e:	00a05e63          	blez	a0,16a <gets+0x56>
    buf[i++] = c;
 152:	faf44783          	lbu	a5,-81(s0)
 156:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 15a:	01578763          	beq	a5,s5,168 <gets+0x54>
 15e:	0905                	addi	s2,s2,1
 160:	fd679be3          	bne	a5,s6,136 <gets+0x22>
  for(i=0; i+1 < max; ){
 164:	89a6                	mv	s3,s1
 166:	a011                	j	16a <gets+0x56>
 168:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 16a:	99de                	add	s3,s3,s7
 16c:	00098023          	sb	zero,0(s3)
  return buf;
}
 170:	855e                	mv	a0,s7
 172:	60e6                	ld	ra,88(sp)
 174:	6446                	ld	s0,80(sp)
 176:	64a6                	ld	s1,72(sp)
 178:	6906                	ld	s2,64(sp)
 17a:	79e2                	ld	s3,56(sp)
 17c:	7a42                	ld	s4,48(sp)
 17e:	7aa2                	ld	s5,40(sp)
 180:	7b02                	ld	s6,32(sp)
 182:	6be2                	ld	s7,24(sp)
 184:	6125                	addi	sp,sp,96
 186:	8082                	ret

0000000000000188 <stat>:

int
stat(const char *n, struct stat *st)
{
 188:	1101                	addi	sp,sp,-32
 18a:	ec06                	sd	ra,24(sp)
 18c:	e822                	sd	s0,16(sp)
 18e:	e426                	sd	s1,8(sp)
 190:	e04a                	sd	s2,0(sp)
 192:	1000                	addi	s0,sp,32
 194:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 196:	4581                	li	a1,0
 198:	00000097          	auipc	ra,0x0
 19c:	0f2080e7          	jalr	242(ra) # 28a <open>
  if(fd < 0)
 1a0:	02054563          	bltz	a0,1ca <stat+0x42>
 1a4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a6:	85ca                	mv	a1,s2
 1a8:	00000097          	auipc	ra,0x0
 1ac:	0fa080e7          	jalr	250(ra) # 2a2 <fstat>
 1b0:	892a                	mv	s2,a0
  close(fd);
 1b2:	8526                	mv	a0,s1
 1b4:	00000097          	auipc	ra,0x0
 1b8:	0be080e7          	jalr	190(ra) # 272 <close>
  return r;
}
 1bc:	854a                	mv	a0,s2
 1be:	60e2                	ld	ra,24(sp)
 1c0:	6442                	ld	s0,16(sp)
 1c2:	64a2                	ld	s1,8(sp)
 1c4:	6902                	ld	s2,0(sp)
 1c6:	6105                	addi	sp,sp,32
 1c8:	8082                	ret
    return -1;
 1ca:	597d                	li	s2,-1
 1cc:	bfc5                	j	1bc <stat+0x34>

00000000000001ce <atoi>:

int
atoi(const char *s)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e422                	sd	s0,8(sp)
 1d2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d4:	00054603          	lbu	a2,0(a0)
 1d8:	fd06079b          	addiw	a5,a2,-48
 1dc:	0ff7f793          	andi	a5,a5,255
 1e0:	4725                	li	a4,9
 1e2:	02f76963          	bltu	a4,a5,214 <atoi+0x46>
 1e6:	86aa                	mv	a3,a0
  n = 0;
 1e8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1ea:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1ec:	0685                	addi	a3,a3,1
 1ee:	0025179b          	slliw	a5,a0,0x2
 1f2:	9fa9                	addw	a5,a5,a0
 1f4:	0017979b          	slliw	a5,a5,0x1
 1f8:	9fb1                	addw	a5,a5,a2
 1fa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1fe:	0006c603          	lbu	a2,0(a3)
 202:	fd06071b          	addiw	a4,a2,-48
 206:	0ff77713          	andi	a4,a4,255
 20a:	fee5f1e3          	bgeu	a1,a4,1ec <atoi+0x1e>
  return n;
}
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret
  n = 0;
 214:	4501                	li	a0,0
 216:	bfe5                	j	20e <atoi+0x40>

0000000000000218 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 21e:	00c05f63          	blez	a2,23c <memmove+0x24>
 222:	1602                	slli	a2,a2,0x20
 224:	9201                	srli	a2,a2,0x20
 226:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 22a:	87aa                	mv	a5,a0
    *dst++ = *src++;
 22c:	0585                	addi	a1,a1,1
 22e:	0785                	addi	a5,a5,1
 230:	fff5c703          	lbu	a4,-1(a1)
 234:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 238:	fed79ae3          	bne	a5,a3,22c <memmove+0x14>
  return vdst;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret

0000000000000242 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 242:	4885                	li	a7,1
 ecall
 244:	00000073          	ecall
 ret
 248:	8082                	ret

000000000000024a <exit>:
.global exit
exit:
 li a7, SYS_exit
 24a:	4889                	li	a7,2
 ecall
 24c:	00000073          	ecall
 ret
 250:	8082                	ret

0000000000000252 <wait>:
.global wait
wait:
 li a7, SYS_wait
 252:	488d                	li	a7,3
 ecall
 254:	00000073          	ecall
 ret
 258:	8082                	ret

000000000000025a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 25a:	4891                	li	a7,4
 ecall
 25c:	00000073          	ecall
 ret
 260:	8082                	ret

0000000000000262 <read>:
.global read
read:
 li a7, SYS_read
 262:	4895                	li	a7,5
 ecall
 264:	00000073          	ecall
 ret
 268:	8082                	ret

000000000000026a <write>:
.global write
write:
 li a7, SYS_write
 26a:	48c1                	li	a7,16
 ecall
 26c:	00000073          	ecall
 ret
 270:	8082                	ret

0000000000000272 <close>:
.global close
close:
 li a7, SYS_close
 272:	48d5                	li	a7,21
 ecall
 274:	00000073          	ecall
 ret
 278:	8082                	ret

000000000000027a <kill>:
.global kill
kill:
 li a7, SYS_kill
 27a:	4899                	li	a7,6
 ecall
 27c:	00000073          	ecall
 ret
 280:	8082                	ret

0000000000000282 <exec>:
.global exec
exec:
 li a7, SYS_exec
 282:	489d                	li	a7,7
 ecall
 284:	00000073          	ecall
 ret
 288:	8082                	ret

000000000000028a <open>:
.global open
open:
 li a7, SYS_open
 28a:	48bd                	li	a7,15
 ecall
 28c:	00000073          	ecall
 ret
 290:	8082                	ret

0000000000000292 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 292:	48c5                	li	a7,17
 ecall
 294:	00000073          	ecall
 ret
 298:	8082                	ret

000000000000029a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 29a:	48c9                	li	a7,18
 ecall
 29c:	00000073          	ecall
 ret
 2a0:	8082                	ret

00000000000002a2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2a2:	48a1                	li	a7,8
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <link>:
.global link
link:
 li a7, SYS_link
 2aa:	48cd                	li	a7,19
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2b2:	48d1                	li	a7,20
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2ba:	48a5                	li	a7,9
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2c2:	48a9                	li	a7,10
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2ca:	48ad                	li	a7,11
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2d2:	48b1                	li	a7,12
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2da:	48b5                	li	a7,13
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 2e2:	48b9                	li	a7,14
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 2ea:	48d9                	li	a7,22
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <crash>:
.global crash
crash:
 li a7, SYS_crash
 2f2:	48dd                	li	a7,23
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <mount>:
.global mount
mount:
 li a7, SYS_mount
 2fa:	48e1                	li	a7,24
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <umount>:
.global umount
umount:
 li a7, SYS_umount
 302:	48e5                	li	a7,25
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 30a:	1101                	addi	sp,sp,-32
 30c:	ec06                	sd	ra,24(sp)
 30e:	e822                	sd	s0,16(sp)
 310:	1000                	addi	s0,sp,32
 312:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 316:	4605                	li	a2,1
 318:	fef40593          	addi	a1,s0,-17
 31c:	00000097          	auipc	ra,0x0
 320:	f4e080e7          	jalr	-178(ra) # 26a <write>
}
 324:	60e2                	ld	ra,24(sp)
 326:	6442                	ld	s0,16(sp)
 328:	6105                	addi	sp,sp,32
 32a:	8082                	ret

000000000000032c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 32c:	7139                	addi	sp,sp,-64
 32e:	fc06                	sd	ra,56(sp)
 330:	f822                	sd	s0,48(sp)
 332:	f426                	sd	s1,40(sp)
 334:	f04a                	sd	s2,32(sp)
 336:	ec4e                	sd	s3,24(sp)
 338:	0080                	addi	s0,sp,64
 33a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 33c:	c299                	beqz	a3,342 <printint+0x16>
 33e:	0805c863          	bltz	a1,3ce <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 342:	2581                	sext.w	a1,a1
  neg = 0;
 344:	4881                	li	a7,0
 346:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 34a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 34c:	2601                	sext.w	a2,a2
 34e:	00000517          	auipc	a0,0x0
 352:	47250513          	addi	a0,a0,1138 # 7c0 <digits>
 356:	883a                	mv	a6,a4
 358:	2705                	addiw	a4,a4,1
 35a:	02c5f7bb          	remuw	a5,a1,a2
 35e:	1782                	slli	a5,a5,0x20
 360:	9381                	srli	a5,a5,0x20
 362:	97aa                	add	a5,a5,a0
 364:	0007c783          	lbu	a5,0(a5)
 368:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 36c:	0005879b          	sext.w	a5,a1
 370:	02c5d5bb          	divuw	a1,a1,a2
 374:	0685                	addi	a3,a3,1
 376:	fec7f0e3          	bgeu	a5,a2,356 <printint+0x2a>
  if(neg)
 37a:	00088b63          	beqz	a7,390 <printint+0x64>
    buf[i++] = '-';
 37e:	fd040793          	addi	a5,s0,-48
 382:	973e                	add	a4,a4,a5
 384:	02d00793          	li	a5,45
 388:	fef70823          	sb	a5,-16(a4)
 38c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 390:	02e05863          	blez	a4,3c0 <printint+0x94>
 394:	fc040793          	addi	a5,s0,-64
 398:	00e78933          	add	s2,a5,a4
 39c:	fff78993          	addi	s3,a5,-1
 3a0:	99ba                	add	s3,s3,a4
 3a2:	377d                	addiw	a4,a4,-1
 3a4:	1702                	slli	a4,a4,0x20
 3a6:	9301                	srli	a4,a4,0x20
 3a8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3ac:	fff94583          	lbu	a1,-1(s2)
 3b0:	8526                	mv	a0,s1
 3b2:	00000097          	auipc	ra,0x0
 3b6:	f58080e7          	jalr	-168(ra) # 30a <putc>
  while(--i >= 0)
 3ba:	197d                	addi	s2,s2,-1
 3bc:	ff3918e3          	bne	s2,s3,3ac <printint+0x80>
}
 3c0:	70e2                	ld	ra,56(sp)
 3c2:	7442                	ld	s0,48(sp)
 3c4:	74a2                	ld	s1,40(sp)
 3c6:	7902                	ld	s2,32(sp)
 3c8:	69e2                	ld	s3,24(sp)
 3ca:	6121                	addi	sp,sp,64
 3cc:	8082                	ret
    x = -xx;
 3ce:	40b005bb          	negw	a1,a1
    neg = 1;
 3d2:	4885                	li	a7,1
    x = -xx;
 3d4:	bf8d                	j	346 <printint+0x1a>

00000000000003d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3d6:	7119                	addi	sp,sp,-128
 3d8:	fc86                	sd	ra,120(sp)
 3da:	f8a2                	sd	s0,112(sp)
 3dc:	f4a6                	sd	s1,104(sp)
 3de:	f0ca                	sd	s2,96(sp)
 3e0:	ecce                	sd	s3,88(sp)
 3e2:	e8d2                	sd	s4,80(sp)
 3e4:	e4d6                	sd	s5,72(sp)
 3e6:	e0da                	sd	s6,64(sp)
 3e8:	fc5e                	sd	s7,56(sp)
 3ea:	f862                	sd	s8,48(sp)
 3ec:	f466                	sd	s9,40(sp)
 3ee:	f06a                	sd	s10,32(sp)
 3f0:	ec6e                	sd	s11,24(sp)
 3f2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3f4:	0005c903          	lbu	s2,0(a1)
 3f8:	18090f63          	beqz	s2,596 <vprintf+0x1c0>
 3fc:	8aaa                	mv	s5,a0
 3fe:	8b32                	mv	s6,a2
 400:	00158493          	addi	s1,a1,1
  state = 0;
 404:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 406:	02500a13          	li	s4,37
      if(c == 'd'){
 40a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 40e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 412:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 416:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 41a:	00000b97          	auipc	s7,0x0
 41e:	3a6b8b93          	addi	s7,s7,934 # 7c0 <digits>
 422:	a839                	j	440 <vprintf+0x6a>
        putc(fd, c);
 424:	85ca                	mv	a1,s2
 426:	8556                	mv	a0,s5
 428:	00000097          	auipc	ra,0x0
 42c:	ee2080e7          	jalr	-286(ra) # 30a <putc>
 430:	a019                	j	436 <vprintf+0x60>
    } else if(state == '%'){
 432:	01498f63          	beq	s3,s4,450 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 436:	0485                	addi	s1,s1,1
 438:	fff4c903          	lbu	s2,-1(s1)
 43c:	14090d63          	beqz	s2,596 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 440:	0009079b          	sext.w	a5,s2
    if(state == 0){
 444:	fe0997e3          	bnez	s3,432 <vprintf+0x5c>
      if(c == '%'){
 448:	fd479ee3          	bne	a5,s4,424 <vprintf+0x4e>
        state = '%';
 44c:	89be                	mv	s3,a5
 44e:	b7e5                	j	436 <vprintf+0x60>
      if(c == 'd'){
 450:	05878063          	beq	a5,s8,490 <vprintf+0xba>
      } else if(c == 'l') {
 454:	05978c63          	beq	a5,s9,4ac <vprintf+0xd6>
      } else if(c == 'x') {
 458:	07a78863          	beq	a5,s10,4c8 <vprintf+0xf2>
      } else if(c == 'p') {
 45c:	09b78463          	beq	a5,s11,4e4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 460:	07300713          	li	a4,115
 464:	0ce78663          	beq	a5,a4,530 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 468:	06300713          	li	a4,99
 46c:	0ee78e63          	beq	a5,a4,568 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 470:	11478863          	beq	a5,s4,580 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 474:	85d2                	mv	a1,s4
 476:	8556                	mv	a0,s5
 478:	00000097          	auipc	ra,0x0
 47c:	e92080e7          	jalr	-366(ra) # 30a <putc>
        putc(fd, c);
 480:	85ca                	mv	a1,s2
 482:	8556                	mv	a0,s5
 484:	00000097          	auipc	ra,0x0
 488:	e86080e7          	jalr	-378(ra) # 30a <putc>
      }
      state = 0;
 48c:	4981                	li	s3,0
 48e:	b765                	j	436 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 490:	008b0913          	addi	s2,s6,8
 494:	4685                	li	a3,1
 496:	4629                	li	a2,10
 498:	000b2583          	lw	a1,0(s6)
 49c:	8556                	mv	a0,s5
 49e:	00000097          	auipc	ra,0x0
 4a2:	e8e080e7          	jalr	-370(ra) # 32c <printint>
 4a6:	8b4a                	mv	s6,s2
      state = 0;
 4a8:	4981                	li	s3,0
 4aa:	b771                	j	436 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4ac:	008b0913          	addi	s2,s6,8
 4b0:	4681                	li	a3,0
 4b2:	4629                	li	a2,10
 4b4:	000b2583          	lw	a1,0(s6)
 4b8:	8556                	mv	a0,s5
 4ba:	00000097          	auipc	ra,0x0
 4be:	e72080e7          	jalr	-398(ra) # 32c <printint>
 4c2:	8b4a                	mv	s6,s2
      state = 0;
 4c4:	4981                	li	s3,0
 4c6:	bf85                	j	436 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4c8:	008b0913          	addi	s2,s6,8
 4cc:	4681                	li	a3,0
 4ce:	4641                	li	a2,16
 4d0:	000b2583          	lw	a1,0(s6)
 4d4:	8556                	mv	a0,s5
 4d6:	00000097          	auipc	ra,0x0
 4da:	e56080e7          	jalr	-426(ra) # 32c <printint>
 4de:	8b4a                	mv	s6,s2
      state = 0;
 4e0:	4981                	li	s3,0
 4e2:	bf91                	j	436 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4e4:	008b0793          	addi	a5,s6,8
 4e8:	f8f43423          	sd	a5,-120(s0)
 4ec:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 4f0:	03000593          	li	a1,48
 4f4:	8556                	mv	a0,s5
 4f6:	00000097          	auipc	ra,0x0
 4fa:	e14080e7          	jalr	-492(ra) # 30a <putc>
  putc(fd, 'x');
 4fe:	85ea                	mv	a1,s10
 500:	8556                	mv	a0,s5
 502:	00000097          	auipc	ra,0x0
 506:	e08080e7          	jalr	-504(ra) # 30a <putc>
 50a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 50c:	03c9d793          	srli	a5,s3,0x3c
 510:	97de                	add	a5,a5,s7
 512:	0007c583          	lbu	a1,0(a5)
 516:	8556                	mv	a0,s5
 518:	00000097          	auipc	ra,0x0
 51c:	df2080e7          	jalr	-526(ra) # 30a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 520:	0992                	slli	s3,s3,0x4
 522:	397d                	addiw	s2,s2,-1
 524:	fe0914e3          	bnez	s2,50c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 528:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 52c:	4981                	li	s3,0
 52e:	b721                	j	436 <vprintf+0x60>
        s = va_arg(ap, char*);
 530:	008b0993          	addi	s3,s6,8
 534:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 538:	02090163          	beqz	s2,55a <vprintf+0x184>
        while(*s != 0){
 53c:	00094583          	lbu	a1,0(s2)
 540:	c9a1                	beqz	a1,590 <vprintf+0x1ba>
          putc(fd, *s);
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	dc6080e7          	jalr	-570(ra) # 30a <putc>
          s++;
 54c:	0905                	addi	s2,s2,1
        while(*s != 0){
 54e:	00094583          	lbu	a1,0(s2)
 552:	f9e5                	bnez	a1,542 <vprintf+0x16c>
        s = va_arg(ap, char*);
 554:	8b4e                	mv	s6,s3
      state = 0;
 556:	4981                	li	s3,0
 558:	bdf9                	j	436 <vprintf+0x60>
          s = "(null)";
 55a:	00000917          	auipc	s2,0x0
 55e:	25e90913          	addi	s2,s2,606 # 7b8 <malloc+0x118>
        while(*s != 0){
 562:	02800593          	li	a1,40
 566:	bff1                	j	542 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 568:	008b0913          	addi	s2,s6,8
 56c:	000b4583          	lbu	a1,0(s6)
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	d98080e7          	jalr	-616(ra) # 30a <putc>
 57a:	8b4a                	mv	s6,s2
      state = 0;
 57c:	4981                	li	s3,0
 57e:	bd65                	j	436 <vprintf+0x60>
        putc(fd, c);
 580:	85d2                	mv	a1,s4
 582:	8556                	mv	a0,s5
 584:	00000097          	auipc	ra,0x0
 588:	d86080e7          	jalr	-634(ra) # 30a <putc>
      state = 0;
 58c:	4981                	li	s3,0
 58e:	b565                	j	436 <vprintf+0x60>
        s = va_arg(ap, char*);
 590:	8b4e                	mv	s6,s3
      state = 0;
 592:	4981                	li	s3,0
 594:	b54d                	j	436 <vprintf+0x60>
    }
  }
}
 596:	70e6                	ld	ra,120(sp)
 598:	7446                	ld	s0,112(sp)
 59a:	74a6                	ld	s1,104(sp)
 59c:	7906                	ld	s2,96(sp)
 59e:	69e6                	ld	s3,88(sp)
 5a0:	6a46                	ld	s4,80(sp)
 5a2:	6aa6                	ld	s5,72(sp)
 5a4:	6b06                	ld	s6,64(sp)
 5a6:	7be2                	ld	s7,56(sp)
 5a8:	7c42                	ld	s8,48(sp)
 5aa:	7ca2                	ld	s9,40(sp)
 5ac:	7d02                	ld	s10,32(sp)
 5ae:	6de2                	ld	s11,24(sp)
 5b0:	6109                	addi	sp,sp,128
 5b2:	8082                	ret

00000000000005b4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5b4:	715d                	addi	sp,sp,-80
 5b6:	ec06                	sd	ra,24(sp)
 5b8:	e822                	sd	s0,16(sp)
 5ba:	1000                	addi	s0,sp,32
 5bc:	e010                	sd	a2,0(s0)
 5be:	e414                	sd	a3,8(s0)
 5c0:	e818                	sd	a4,16(s0)
 5c2:	ec1c                	sd	a5,24(s0)
 5c4:	03043023          	sd	a6,32(s0)
 5c8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5d0:	8622                	mv	a2,s0
 5d2:	00000097          	auipc	ra,0x0
 5d6:	e04080e7          	jalr	-508(ra) # 3d6 <vprintf>
}
 5da:	60e2                	ld	ra,24(sp)
 5dc:	6442                	ld	s0,16(sp)
 5de:	6161                	addi	sp,sp,80
 5e0:	8082                	ret

00000000000005e2 <printf>:

void
printf(const char *fmt, ...)
{
 5e2:	711d                	addi	sp,sp,-96
 5e4:	ec06                	sd	ra,24(sp)
 5e6:	e822                	sd	s0,16(sp)
 5e8:	1000                	addi	s0,sp,32
 5ea:	e40c                	sd	a1,8(s0)
 5ec:	e810                	sd	a2,16(s0)
 5ee:	ec14                	sd	a3,24(s0)
 5f0:	f018                	sd	a4,32(s0)
 5f2:	f41c                	sd	a5,40(s0)
 5f4:	03043823          	sd	a6,48(s0)
 5f8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 5fc:	00840613          	addi	a2,s0,8
 600:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 604:	85aa                	mv	a1,a0
 606:	4505                	li	a0,1
 608:	00000097          	auipc	ra,0x0
 60c:	dce080e7          	jalr	-562(ra) # 3d6 <vprintf>
}
 610:	60e2                	ld	ra,24(sp)
 612:	6442                	ld	s0,16(sp)
 614:	6125                	addi	sp,sp,96
 616:	8082                	ret

0000000000000618 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 618:	1141                	addi	sp,sp,-16
 61a:	e422                	sd	s0,8(sp)
 61c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 61e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 622:	00000797          	auipc	a5,0x0
 626:	1b67b783          	ld	a5,438(a5) # 7d8 <freep>
 62a:	a805                	j	65a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 62c:	4618                	lw	a4,8(a2)
 62e:	9db9                	addw	a1,a1,a4
 630:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 634:	6398                	ld	a4,0(a5)
 636:	6318                	ld	a4,0(a4)
 638:	fee53823          	sd	a4,-16(a0)
 63c:	a091                	j	680 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 63e:	ff852703          	lw	a4,-8(a0)
 642:	9e39                	addw	a2,a2,a4
 644:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 646:	ff053703          	ld	a4,-16(a0)
 64a:	e398                	sd	a4,0(a5)
 64c:	a099                	j	692 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64e:	6398                	ld	a4,0(a5)
 650:	00e7e463          	bltu	a5,a4,658 <free+0x40>
 654:	00e6ea63          	bltu	a3,a4,668 <free+0x50>
{
 658:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65a:	fed7fae3          	bgeu	a5,a3,64e <free+0x36>
 65e:	6398                	ld	a4,0(a5)
 660:	00e6e463          	bltu	a3,a4,668 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 664:	fee7eae3          	bltu	a5,a4,658 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 668:	ff852583          	lw	a1,-8(a0)
 66c:	6390                	ld	a2,0(a5)
 66e:	02059813          	slli	a6,a1,0x20
 672:	01c85713          	srli	a4,a6,0x1c
 676:	9736                	add	a4,a4,a3
 678:	fae60ae3          	beq	a2,a4,62c <free+0x14>
    bp->s.ptr = p->s.ptr;
 67c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 680:	4790                	lw	a2,8(a5)
 682:	02061593          	slli	a1,a2,0x20
 686:	01c5d713          	srli	a4,a1,0x1c
 68a:	973e                	add	a4,a4,a5
 68c:	fae689e3          	beq	a3,a4,63e <free+0x26>
  } else
    p->s.ptr = bp;
 690:	e394                	sd	a3,0(a5)
  freep = p;
 692:	00000717          	auipc	a4,0x0
 696:	14f73323          	sd	a5,326(a4) # 7d8 <freep>
}
 69a:	6422                	ld	s0,8(sp)
 69c:	0141                	addi	sp,sp,16
 69e:	8082                	ret

00000000000006a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6a0:	7139                	addi	sp,sp,-64
 6a2:	fc06                	sd	ra,56(sp)
 6a4:	f822                	sd	s0,48(sp)
 6a6:	f426                	sd	s1,40(sp)
 6a8:	f04a                	sd	s2,32(sp)
 6aa:	ec4e                	sd	s3,24(sp)
 6ac:	e852                	sd	s4,16(sp)
 6ae:	e456                	sd	s5,8(sp)
 6b0:	e05a                	sd	s6,0(sp)
 6b2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b4:	02051493          	slli	s1,a0,0x20
 6b8:	9081                	srli	s1,s1,0x20
 6ba:	04bd                	addi	s1,s1,15
 6bc:	8091                	srli	s1,s1,0x4
 6be:	0014899b          	addiw	s3,s1,1
 6c2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6c4:	00000517          	auipc	a0,0x0
 6c8:	11453503          	ld	a0,276(a0) # 7d8 <freep>
 6cc:	c515                	beqz	a0,6f8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6d0:	4798                	lw	a4,8(a5)
 6d2:	02977f63          	bgeu	a4,s1,710 <malloc+0x70>
 6d6:	8a4e                	mv	s4,s3
 6d8:	0009871b          	sext.w	a4,s3
 6dc:	6685                	lui	a3,0x1
 6de:	00d77363          	bgeu	a4,a3,6e4 <malloc+0x44>
 6e2:	6a05                	lui	s4,0x1
 6e4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6e8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6ec:	00000917          	auipc	s2,0x0
 6f0:	0ec90913          	addi	s2,s2,236 # 7d8 <freep>
  if(p == (char*)-1)
 6f4:	5afd                	li	s5,-1
 6f6:	a895                	j	76a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 6f8:	00000797          	auipc	a5,0x0
 6fc:	0e878793          	addi	a5,a5,232 # 7e0 <base>
 700:	00000717          	auipc	a4,0x0
 704:	0cf73c23          	sd	a5,216(a4) # 7d8 <freep>
 708:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 70a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 70e:	b7e1                	j	6d6 <malloc+0x36>
      if(p->s.size == nunits)
 710:	02e48c63          	beq	s1,a4,748 <malloc+0xa8>
        p->s.size -= nunits;
 714:	4137073b          	subw	a4,a4,s3
 718:	c798                	sw	a4,8(a5)
        p += p->s.size;
 71a:	02071693          	slli	a3,a4,0x20
 71e:	01c6d713          	srli	a4,a3,0x1c
 722:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 724:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 728:	00000717          	auipc	a4,0x0
 72c:	0aa73823          	sd	a0,176(a4) # 7d8 <freep>
      return (void*)(p + 1);
 730:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 734:	70e2                	ld	ra,56(sp)
 736:	7442                	ld	s0,48(sp)
 738:	74a2                	ld	s1,40(sp)
 73a:	7902                	ld	s2,32(sp)
 73c:	69e2                	ld	s3,24(sp)
 73e:	6a42                	ld	s4,16(sp)
 740:	6aa2                	ld	s5,8(sp)
 742:	6b02                	ld	s6,0(sp)
 744:	6121                	addi	sp,sp,64
 746:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 748:	6398                	ld	a4,0(a5)
 74a:	e118                	sd	a4,0(a0)
 74c:	bff1                	j	728 <malloc+0x88>
  hp->s.size = nu;
 74e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 752:	0541                	addi	a0,a0,16
 754:	00000097          	auipc	ra,0x0
 758:	ec4080e7          	jalr	-316(ra) # 618 <free>
  return freep;
 75c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 760:	d971                	beqz	a0,734 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 762:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 764:	4798                	lw	a4,8(a5)
 766:	fa9775e3          	bgeu	a4,s1,710 <malloc+0x70>
    if(p == freep)
 76a:	00093703          	ld	a4,0(s2)
 76e:	853e                	mv	a0,a5
 770:	fef719e3          	bne	a4,a5,762 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 774:	8552                	mv	a0,s4
 776:	00000097          	auipc	ra,0x0
 77a:	b5c080e7          	jalr	-1188(ra) # 2d2 <sbrk>
  if(p == (char*)-1)
 77e:	fd5518e3          	bne	a0,s5,74e <malloc+0xae>
        return 0;
 782:	4501                	li	a0,0
 784:	bf45                	j	734 <malloc+0x94>
