
user/_mkdir：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d763          	bge	a5,a0,3e <main+0x3e>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	02091793          	slli	a5,s2,0x20
  20:	01d7d913          	srli	s2,a5,0x1d
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	2a0080e7          	jalr	672(ra) # 2ca <mkdir>
  32:	02054363          	bltz	a0,58 <main+0x58>
  for(i = 1; i < argc; i++){
  36:	04a1                	addi	s1,s1,8
  38:	ff2498e3          	bne	s1,s2,28 <main+0x28>
  3c:	a805                	j	6c <main+0x6c>
    fprintf(2, "Usage: mkdir files...\n");
  3e:	00000597          	auipc	a1,0x0
  42:	76258593          	addi	a1,a1,1890 # 7a0 <malloc+0xe8>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	584080e7          	jalr	1412(ra) # 5cc <fprintf>
    exit();
  50:	00000097          	auipc	ra,0x0
  54:	212080e7          	jalr	530(ra) # 262 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  58:	6090                	ld	a2,0(s1)
  5a:	00000597          	auipc	a1,0x0
  5e:	75e58593          	addi	a1,a1,1886 # 7b8 <malloc+0x100>
  62:	4509                	li	a0,2
  64:	00000097          	auipc	ra,0x0
  68:	568080e7          	jalr	1384(ra) # 5cc <fprintf>
      break;
    }
  }

  exit();
  6c:	00000097          	auipc	ra,0x0
  70:	1f6080e7          	jalr	502(ra) # 262 <exit>

0000000000000074 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  74:	1141                	addi	sp,sp,-16
  76:	e422                	sd	s0,8(sp)
  78:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7a:	87aa                	mv	a5,a0
  7c:	0585                	addi	a1,a1,1
  7e:	0785                	addi	a5,a5,1
  80:	fff5c703          	lbu	a4,-1(a1)
  84:	fee78fa3          	sb	a4,-1(a5)
  88:	fb75                	bnez	a4,7c <strcpy+0x8>
    ;
  return os;
}
  8a:	6422                	ld	s0,8(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret

0000000000000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	1141                	addi	sp,sp,-16
  92:	e422                	sd	s0,8(sp)
  94:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  96:	00054783          	lbu	a5,0(a0)
  9a:	cb91                	beqz	a5,ae <strcmp+0x1e>
  9c:	0005c703          	lbu	a4,0(a1)
  a0:	00f71763          	bne	a4,a5,ae <strcmp+0x1e>
    p++, q++;
  a4:	0505                	addi	a0,a0,1
  a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a8:	00054783          	lbu	a5,0(a0)
  ac:	fbe5                	bnez	a5,9c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ae:	0005c503          	lbu	a0,0(a1)
}
  b2:	40a7853b          	subw	a0,a5,a0
  b6:	6422                	ld	s0,8(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strlen>:

uint
strlen(const char *s)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e422                	sd	s0,8(sp)
  c0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c2:	00054783          	lbu	a5,0(a0)
  c6:	cf91                	beqz	a5,e2 <strlen+0x26>
  c8:	0505                	addi	a0,a0,1
  ca:	87aa                	mv	a5,a0
  cc:	4685                	li	a3,1
  ce:	9e89                	subw	a3,a3,a0
  d0:	00f6853b          	addw	a0,a3,a5
  d4:	0785                	addi	a5,a5,1
  d6:	fff7c703          	lbu	a4,-1(a5)
  da:	fb7d                	bnez	a4,d0 <strlen+0x14>
    ;
  return n;
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret
  for(n = 0; s[n]; n++)
  e2:	4501                	li	a0,0
  e4:	bfe5                	j	dc <strlen+0x20>

00000000000000e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e422                	sd	s0,8(sp)
  ea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ec:	ca19                	beqz	a2,102 <memset+0x1c>
  ee:	87aa                	mv	a5,a0
  f0:	1602                	slli	a2,a2,0x20
  f2:	9201                	srli	a2,a2,0x20
  f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  fc:	0785                	addi	a5,a5,1
  fe:	fee79de3          	bne	a5,a4,f8 <memset+0x12>
  }
  return dst;
}
 102:	6422                	ld	s0,8(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret

0000000000000108 <strchr>:

char*
strchr(const char *s, char c)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e422                	sd	s0,8(sp)
 10c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 10e:	00054783          	lbu	a5,0(a0)
 112:	cb99                	beqz	a5,128 <strchr+0x20>
    if(*s == c)
 114:	00f58763          	beq	a1,a5,122 <strchr+0x1a>
  for(; *s; s++)
 118:	0505                	addi	a0,a0,1
 11a:	00054783          	lbu	a5,0(a0)
 11e:	fbfd                	bnez	a5,114 <strchr+0xc>
      return (char*)s;
  return 0;
 120:	4501                	li	a0,0
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret
  return 0;
 128:	4501                	li	a0,0
 12a:	bfe5                	j	122 <strchr+0x1a>

000000000000012c <gets>:

char*
gets(char *buf, int max)
{
 12c:	711d                	addi	sp,sp,-96
 12e:	ec86                	sd	ra,88(sp)
 130:	e8a2                	sd	s0,80(sp)
 132:	e4a6                	sd	s1,72(sp)
 134:	e0ca                	sd	s2,64(sp)
 136:	fc4e                	sd	s3,56(sp)
 138:	f852                	sd	s4,48(sp)
 13a:	f456                	sd	s5,40(sp)
 13c:	f05a                	sd	s6,32(sp)
 13e:	ec5e                	sd	s7,24(sp)
 140:	1080                	addi	s0,sp,96
 142:	8baa                	mv	s7,a0
 144:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 146:	892a                	mv	s2,a0
 148:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 14a:	4aa9                	li	s5,10
 14c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 14e:	89a6                	mv	s3,s1
 150:	2485                	addiw	s1,s1,1
 152:	0344d863          	bge	s1,s4,182 <gets+0x56>
    cc = read(0, &c, 1);
 156:	4605                	li	a2,1
 158:	faf40593          	addi	a1,s0,-81
 15c:	4501                	li	a0,0
 15e:	00000097          	auipc	ra,0x0
 162:	11c080e7          	jalr	284(ra) # 27a <read>
    if(cc < 1)
 166:	00a05e63          	blez	a0,182 <gets+0x56>
    buf[i++] = c;
 16a:	faf44783          	lbu	a5,-81(s0)
 16e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 172:	01578763          	beq	a5,s5,180 <gets+0x54>
 176:	0905                	addi	s2,s2,1
 178:	fd679be3          	bne	a5,s6,14e <gets+0x22>
  for(i=0; i+1 < max; ){
 17c:	89a6                	mv	s3,s1
 17e:	a011                	j	182 <gets+0x56>
 180:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 182:	99de                	add	s3,s3,s7
 184:	00098023          	sb	zero,0(s3)
  return buf;
}
 188:	855e                	mv	a0,s7
 18a:	60e6                	ld	ra,88(sp)
 18c:	6446                	ld	s0,80(sp)
 18e:	64a6                	ld	s1,72(sp)
 190:	6906                	ld	s2,64(sp)
 192:	79e2                	ld	s3,56(sp)
 194:	7a42                	ld	s4,48(sp)
 196:	7aa2                	ld	s5,40(sp)
 198:	7b02                	ld	s6,32(sp)
 19a:	6be2                	ld	s7,24(sp)
 19c:	6125                	addi	sp,sp,96
 19e:	8082                	ret

00000000000001a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a0:	1101                	addi	sp,sp,-32
 1a2:	ec06                	sd	ra,24(sp)
 1a4:	e822                	sd	s0,16(sp)
 1a6:	e426                	sd	s1,8(sp)
 1a8:	e04a                	sd	s2,0(sp)
 1aa:	1000                	addi	s0,sp,32
 1ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ae:	4581                	li	a1,0
 1b0:	00000097          	auipc	ra,0x0
 1b4:	0f2080e7          	jalr	242(ra) # 2a2 <open>
  if(fd < 0)
 1b8:	02054563          	bltz	a0,1e2 <stat+0x42>
 1bc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1be:	85ca                	mv	a1,s2
 1c0:	00000097          	auipc	ra,0x0
 1c4:	0fa080e7          	jalr	250(ra) # 2ba <fstat>
 1c8:	892a                	mv	s2,a0
  close(fd);
 1ca:	8526                	mv	a0,s1
 1cc:	00000097          	auipc	ra,0x0
 1d0:	0be080e7          	jalr	190(ra) # 28a <close>
  return r;
}
 1d4:	854a                	mv	a0,s2
 1d6:	60e2                	ld	ra,24(sp)
 1d8:	6442                	ld	s0,16(sp)
 1da:	64a2                	ld	s1,8(sp)
 1dc:	6902                	ld	s2,0(sp)
 1de:	6105                	addi	sp,sp,32
 1e0:	8082                	ret
    return -1;
 1e2:	597d                	li	s2,-1
 1e4:	bfc5                	j	1d4 <stat+0x34>

00000000000001e6 <atoi>:

int
atoi(const char *s)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ec:	00054603          	lbu	a2,0(a0)
 1f0:	fd06079b          	addiw	a5,a2,-48
 1f4:	0ff7f793          	andi	a5,a5,255
 1f8:	4725                	li	a4,9
 1fa:	02f76963          	bltu	a4,a5,22c <atoi+0x46>
 1fe:	86aa                	mv	a3,a0
  n = 0;
 200:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 202:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 204:	0685                	addi	a3,a3,1
 206:	0025179b          	slliw	a5,a0,0x2
 20a:	9fa9                	addw	a5,a5,a0
 20c:	0017979b          	slliw	a5,a5,0x1
 210:	9fb1                	addw	a5,a5,a2
 212:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 216:	0006c603          	lbu	a2,0(a3)
 21a:	fd06071b          	addiw	a4,a2,-48
 21e:	0ff77713          	andi	a4,a4,255
 222:	fee5f1e3          	bgeu	a1,a4,204 <atoi+0x1e>
  return n;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
  n = 0;
 22c:	4501                	li	a0,0
 22e:	bfe5                	j	226 <atoi+0x40>

0000000000000230 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 236:	00c05f63          	blez	a2,254 <memmove+0x24>
 23a:	1602                	slli	a2,a2,0x20
 23c:	9201                	srli	a2,a2,0x20
 23e:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 242:	87aa                	mv	a5,a0
    *dst++ = *src++;
 244:	0585                	addi	a1,a1,1
 246:	0785                	addi	a5,a5,1
 248:	fff5c703          	lbu	a4,-1(a1)
 24c:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 250:	fed79ae3          	bne	a5,a3,244 <memmove+0x14>
  return vdst;
}
 254:	6422                	ld	s0,8(sp)
 256:	0141                	addi	sp,sp,16
 258:	8082                	ret

000000000000025a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 25a:	4885                	li	a7,1
 ecall
 25c:	00000073          	ecall
 ret
 260:	8082                	ret

0000000000000262 <exit>:
.global exit
exit:
 li a7, SYS_exit
 262:	4889                	li	a7,2
 ecall
 264:	00000073          	ecall
 ret
 268:	8082                	ret

000000000000026a <wait>:
.global wait
wait:
 li a7, SYS_wait
 26a:	488d                	li	a7,3
 ecall
 26c:	00000073          	ecall
 ret
 270:	8082                	ret

0000000000000272 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 272:	4891                	li	a7,4
 ecall
 274:	00000073          	ecall
 ret
 278:	8082                	ret

000000000000027a <read>:
.global read
read:
 li a7, SYS_read
 27a:	4895                	li	a7,5
 ecall
 27c:	00000073          	ecall
 ret
 280:	8082                	ret

0000000000000282 <write>:
.global write
write:
 li a7, SYS_write
 282:	48c1                	li	a7,16
 ecall
 284:	00000073          	ecall
 ret
 288:	8082                	ret

000000000000028a <close>:
.global close
close:
 li a7, SYS_close
 28a:	48d5                	li	a7,21
 ecall
 28c:	00000073          	ecall
 ret
 290:	8082                	ret

0000000000000292 <kill>:
.global kill
kill:
 li a7, SYS_kill
 292:	4899                	li	a7,6
 ecall
 294:	00000073          	ecall
 ret
 298:	8082                	ret

000000000000029a <exec>:
.global exec
exec:
 li a7, SYS_exec
 29a:	489d                	li	a7,7
 ecall
 29c:	00000073          	ecall
 ret
 2a0:	8082                	ret

00000000000002a2 <open>:
.global open
open:
 li a7, SYS_open
 2a2:	48bd                	li	a7,15
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2aa:	48c5                	li	a7,17
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2b2:	48c9                	li	a7,18
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2ba:	48a1                	li	a7,8
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <link>:
.global link
link:
 li a7, SYS_link
 2c2:	48cd                	li	a7,19
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2ca:	48d1                	li	a7,20
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2d2:	48a5                	li	a7,9
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <dup>:
.global dup
dup:
 li a7, SYS_dup
 2da:	48a9                	li	a7,10
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2e2:	48ad                	li	a7,11
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2ea:	48b1                	li	a7,12
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2f2:	48b5                	li	a7,13
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 2fa:	48b9                	li	a7,14
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 302:	48d9                	li	a7,22
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <crash>:
.global crash
crash:
 li a7, SYS_crash
 30a:	48dd                	li	a7,23
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <mount>:
.global mount
mount:
 li a7, SYS_mount
 312:	48e1                	li	a7,24
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <umount>:
.global umount
umount:
 li a7, SYS_umount
 31a:	48e5                	li	a7,25
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 322:	1101                	addi	sp,sp,-32
 324:	ec06                	sd	ra,24(sp)
 326:	e822                	sd	s0,16(sp)
 328:	1000                	addi	s0,sp,32
 32a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 32e:	4605                	li	a2,1
 330:	fef40593          	addi	a1,s0,-17
 334:	00000097          	auipc	ra,0x0
 338:	f4e080e7          	jalr	-178(ra) # 282 <write>
}
 33c:	60e2                	ld	ra,24(sp)
 33e:	6442                	ld	s0,16(sp)
 340:	6105                	addi	sp,sp,32
 342:	8082                	ret

0000000000000344 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 344:	7139                	addi	sp,sp,-64
 346:	fc06                	sd	ra,56(sp)
 348:	f822                	sd	s0,48(sp)
 34a:	f426                	sd	s1,40(sp)
 34c:	f04a                	sd	s2,32(sp)
 34e:	ec4e                	sd	s3,24(sp)
 350:	0080                	addi	s0,sp,64
 352:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 354:	c299                	beqz	a3,35a <printint+0x16>
 356:	0805c863          	bltz	a1,3e6 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 35a:	2581                	sext.w	a1,a1
  neg = 0;
 35c:	4881                	li	a7,0
 35e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 362:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 364:	2601                	sext.w	a2,a2
 366:	00000517          	auipc	a0,0x0
 36a:	47a50513          	addi	a0,a0,1146 # 7e0 <digits>
 36e:	883a                	mv	a6,a4
 370:	2705                	addiw	a4,a4,1
 372:	02c5f7bb          	remuw	a5,a1,a2
 376:	1782                	slli	a5,a5,0x20
 378:	9381                	srli	a5,a5,0x20
 37a:	97aa                	add	a5,a5,a0
 37c:	0007c783          	lbu	a5,0(a5)
 380:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 384:	0005879b          	sext.w	a5,a1
 388:	02c5d5bb          	divuw	a1,a1,a2
 38c:	0685                	addi	a3,a3,1
 38e:	fec7f0e3          	bgeu	a5,a2,36e <printint+0x2a>
  if(neg)
 392:	00088b63          	beqz	a7,3a8 <printint+0x64>
    buf[i++] = '-';
 396:	fd040793          	addi	a5,s0,-48
 39a:	973e                	add	a4,a4,a5
 39c:	02d00793          	li	a5,45
 3a0:	fef70823          	sb	a5,-16(a4)
 3a4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3a8:	02e05863          	blez	a4,3d8 <printint+0x94>
 3ac:	fc040793          	addi	a5,s0,-64
 3b0:	00e78933          	add	s2,a5,a4
 3b4:	fff78993          	addi	s3,a5,-1
 3b8:	99ba                	add	s3,s3,a4
 3ba:	377d                	addiw	a4,a4,-1
 3bc:	1702                	slli	a4,a4,0x20
 3be:	9301                	srli	a4,a4,0x20
 3c0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3c4:	fff94583          	lbu	a1,-1(s2)
 3c8:	8526                	mv	a0,s1
 3ca:	00000097          	auipc	ra,0x0
 3ce:	f58080e7          	jalr	-168(ra) # 322 <putc>
  while(--i >= 0)
 3d2:	197d                	addi	s2,s2,-1
 3d4:	ff3918e3          	bne	s2,s3,3c4 <printint+0x80>
}
 3d8:	70e2                	ld	ra,56(sp)
 3da:	7442                	ld	s0,48(sp)
 3dc:	74a2                	ld	s1,40(sp)
 3de:	7902                	ld	s2,32(sp)
 3e0:	69e2                	ld	s3,24(sp)
 3e2:	6121                	addi	sp,sp,64
 3e4:	8082                	ret
    x = -xx;
 3e6:	40b005bb          	negw	a1,a1
    neg = 1;
 3ea:	4885                	li	a7,1
    x = -xx;
 3ec:	bf8d                	j	35e <printint+0x1a>

00000000000003ee <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3ee:	7119                	addi	sp,sp,-128
 3f0:	fc86                	sd	ra,120(sp)
 3f2:	f8a2                	sd	s0,112(sp)
 3f4:	f4a6                	sd	s1,104(sp)
 3f6:	f0ca                	sd	s2,96(sp)
 3f8:	ecce                	sd	s3,88(sp)
 3fa:	e8d2                	sd	s4,80(sp)
 3fc:	e4d6                	sd	s5,72(sp)
 3fe:	e0da                	sd	s6,64(sp)
 400:	fc5e                	sd	s7,56(sp)
 402:	f862                	sd	s8,48(sp)
 404:	f466                	sd	s9,40(sp)
 406:	f06a                	sd	s10,32(sp)
 408:	ec6e                	sd	s11,24(sp)
 40a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 40c:	0005c903          	lbu	s2,0(a1)
 410:	18090f63          	beqz	s2,5ae <vprintf+0x1c0>
 414:	8aaa                	mv	s5,a0
 416:	8b32                	mv	s6,a2
 418:	00158493          	addi	s1,a1,1
  state = 0;
 41c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 41e:	02500a13          	li	s4,37
      if(c == 'd'){
 422:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 426:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 42a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 42e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 432:	00000b97          	auipc	s7,0x0
 436:	3aeb8b93          	addi	s7,s7,942 # 7e0 <digits>
 43a:	a839                	j	458 <vprintf+0x6a>
        putc(fd, c);
 43c:	85ca                	mv	a1,s2
 43e:	8556                	mv	a0,s5
 440:	00000097          	auipc	ra,0x0
 444:	ee2080e7          	jalr	-286(ra) # 322 <putc>
 448:	a019                	j	44e <vprintf+0x60>
    } else if(state == '%'){
 44a:	01498f63          	beq	s3,s4,468 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 44e:	0485                	addi	s1,s1,1
 450:	fff4c903          	lbu	s2,-1(s1)
 454:	14090d63          	beqz	s2,5ae <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 458:	0009079b          	sext.w	a5,s2
    if(state == 0){
 45c:	fe0997e3          	bnez	s3,44a <vprintf+0x5c>
      if(c == '%'){
 460:	fd479ee3          	bne	a5,s4,43c <vprintf+0x4e>
        state = '%';
 464:	89be                	mv	s3,a5
 466:	b7e5                	j	44e <vprintf+0x60>
      if(c == 'd'){
 468:	05878063          	beq	a5,s8,4a8 <vprintf+0xba>
      } else if(c == 'l') {
 46c:	05978c63          	beq	a5,s9,4c4 <vprintf+0xd6>
      } else if(c == 'x') {
 470:	07a78863          	beq	a5,s10,4e0 <vprintf+0xf2>
      } else if(c == 'p') {
 474:	09b78463          	beq	a5,s11,4fc <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 478:	07300713          	li	a4,115
 47c:	0ce78663          	beq	a5,a4,548 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 480:	06300713          	li	a4,99
 484:	0ee78e63          	beq	a5,a4,580 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 488:	11478863          	beq	a5,s4,598 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 48c:	85d2                	mv	a1,s4
 48e:	8556                	mv	a0,s5
 490:	00000097          	auipc	ra,0x0
 494:	e92080e7          	jalr	-366(ra) # 322 <putc>
        putc(fd, c);
 498:	85ca                	mv	a1,s2
 49a:	8556                	mv	a0,s5
 49c:	00000097          	auipc	ra,0x0
 4a0:	e86080e7          	jalr	-378(ra) # 322 <putc>
      }
      state = 0;
 4a4:	4981                	li	s3,0
 4a6:	b765                	j	44e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4a8:	008b0913          	addi	s2,s6,8
 4ac:	4685                	li	a3,1
 4ae:	4629                	li	a2,10
 4b0:	000b2583          	lw	a1,0(s6)
 4b4:	8556                	mv	a0,s5
 4b6:	00000097          	auipc	ra,0x0
 4ba:	e8e080e7          	jalr	-370(ra) # 344 <printint>
 4be:	8b4a                	mv	s6,s2
      state = 0;
 4c0:	4981                	li	s3,0
 4c2:	b771                	j	44e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4c4:	008b0913          	addi	s2,s6,8
 4c8:	4681                	li	a3,0
 4ca:	4629                	li	a2,10
 4cc:	000b2583          	lw	a1,0(s6)
 4d0:	8556                	mv	a0,s5
 4d2:	00000097          	auipc	ra,0x0
 4d6:	e72080e7          	jalr	-398(ra) # 344 <printint>
 4da:	8b4a                	mv	s6,s2
      state = 0;
 4dc:	4981                	li	s3,0
 4de:	bf85                	j	44e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4e0:	008b0913          	addi	s2,s6,8
 4e4:	4681                	li	a3,0
 4e6:	4641                	li	a2,16
 4e8:	000b2583          	lw	a1,0(s6)
 4ec:	8556                	mv	a0,s5
 4ee:	00000097          	auipc	ra,0x0
 4f2:	e56080e7          	jalr	-426(ra) # 344 <printint>
 4f6:	8b4a                	mv	s6,s2
      state = 0;
 4f8:	4981                	li	s3,0
 4fa:	bf91                	j	44e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4fc:	008b0793          	addi	a5,s6,8
 500:	f8f43423          	sd	a5,-120(s0)
 504:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 508:	03000593          	li	a1,48
 50c:	8556                	mv	a0,s5
 50e:	00000097          	auipc	ra,0x0
 512:	e14080e7          	jalr	-492(ra) # 322 <putc>
  putc(fd, 'x');
 516:	85ea                	mv	a1,s10
 518:	8556                	mv	a0,s5
 51a:	00000097          	auipc	ra,0x0
 51e:	e08080e7          	jalr	-504(ra) # 322 <putc>
 522:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 524:	03c9d793          	srli	a5,s3,0x3c
 528:	97de                	add	a5,a5,s7
 52a:	0007c583          	lbu	a1,0(a5)
 52e:	8556                	mv	a0,s5
 530:	00000097          	auipc	ra,0x0
 534:	df2080e7          	jalr	-526(ra) # 322 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 538:	0992                	slli	s3,s3,0x4
 53a:	397d                	addiw	s2,s2,-1
 53c:	fe0914e3          	bnez	s2,524 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 540:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 544:	4981                	li	s3,0
 546:	b721                	j	44e <vprintf+0x60>
        s = va_arg(ap, char*);
 548:	008b0993          	addi	s3,s6,8
 54c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 550:	02090163          	beqz	s2,572 <vprintf+0x184>
        while(*s != 0){
 554:	00094583          	lbu	a1,0(s2)
 558:	c9a1                	beqz	a1,5a8 <vprintf+0x1ba>
          putc(fd, *s);
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	dc6080e7          	jalr	-570(ra) # 322 <putc>
          s++;
 564:	0905                	addi	s2,s2,1
        while(*s != 0){
 566:	00094583          	lbu	a1,0(s2)
 56a:	f9e5                	bnez	a1,55a <vprintf+0x16c>
        s = va_arg(ap, char*);
 56c:	8b4e                	mv	s6,s3
      state = 0;
 56e:	4981                	li	s3,0
 570:	bdf9                	j	44e <vprintf+0x60>
          s = "(null)";
 572:	00000917          	auipc	s2,0x0
 576:	26690913          	addi	s2,s2,614 # 7d8 <malloc+0x120>
        while(*s != 0){
 57a:	02800593          	li	a1,40
 57e:	bff1                	j	55a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 580:	008b0913          	addi	s2,s6,8
 584:	000b4583          	lbu	a1,0(s6)
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	d98080e7          	jalr	-616(ra) # 322 <putc>
 592:	8b4a                	mv	s6,s2
      state = 0;
 594:	4981                	li	s3,0
 596:	bd65                	j	44e <vprintf+0x60>
        putc(fd, c);
 598:	85d2                	mv	a1,s4
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	d86080e7          	jalr	-634(ra) # 322 <putc>
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b565                	j	44e <vprintf+0x60>
        s = va_arg(ap, char*);
 5a8:	8b4e                	mv	s6,s3
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	b54d                	j	44e <vprintf+0x60>
    }
  }
}
 5ae:	70e6                	ld	ra,120(sp)
 5b0:	7446                	ld	s0,112(sp)
 5b2:	74a6                	ld	s1,104(sp)
 5b4:	7906                	ld	s2,96(sp)
 5b6:	69e6                	ld	s3,88(sp)
 5b8:	6a46                	ld	s4,80(sp)
 5ba:	6aa6                	ld	s5,72(sp)
 5bc:	6b06                	ld	s6,64(sp)
 5be:	7be2                	ld	s7,56(sp)
 5c0:	7c42                	ld	s8,48(sp)
 5c2:	7ca2                	ld	s9,40(sp)
 5c4:	7d02                	ld	s10,32(sp)
 5c6:	6de2                	ld	s11,24(sp)
 5c8:	6109                	addi	sp,sp,128
 5ca:	8082                	ret

00000000000005cc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5cc:	715d                	addi	sp,sp,-80
 5ce:	ec06                	sd	ra,24(sp)
 5d0:	e822                	sd	s0,16(sp)
 5d2:	1000                	addi	s0,sp,32
 5d4:	e010                	sd	a2,0(s0)
 5d6:	e414                	sd	a3,8(s0)
 5d8:	e818                	sd	a4,16(s0)
 5da:	ec1c                	sd	a5,24(s0)
 5dc:	03043023          	sd	a6,32(s0)
 5e0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5e4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5e8:	8622                	mv	a2,s0
 5ea:	00000097          	auipc	ra,0x0
 5ee:	e04080e7          	jalr	-508(ra) # 3ee <vprintf>
}
 5f2:	60e2                	ld	ra,24(sp)
 5f4:	6442                	ld	s0,16(sp)
 5f6:	6161                	addi	sp,sp,80
 5f8:	8082                	ret

00000000000005fa <printf>:

void
printf(const char *fmt, ...)
{
 5fa:	711d                	addi	sp,sp,-96
 5fc:	ec06                	sd	ra,24(sp)
 5fe:	e822                	sd	s0,16(sp)
 600:	1000                	addi	s0,sp,32
 602:	e40c                	sd	a1,8(s0)
 604:	e810                	sd	a2,16(s0)
 606:	ec14                	sd	a3,24(s0)
 608:	f018                	sd	a4,32(s0)
 60a:	f41c                	sd	a5,40(s0)
 60c:	03043823          	sd	a6,48(s0)
 610:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 614:	00840613          	addi	a2,s0,8
 618:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 61c:	85aa                	mv	a1,a0
 61e:	4505                	li	a0,1
 620:	00000097          	auipc	ra,0x0
 624:	dce080e7          	jalr	-562(ra) # 3ee <vprintf>
}
 628:	60e2                	ld	ra,24(sp)
 62a:	6442                	ld	s0,16(sp)
 62c:	6125                	addi	sp,sp,96
 62e:	8082                	ret

0000000000000630 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 630:	1141                	addi	sp,sp,-16
 632:	e422                	sd	s0,8(sp)
 634:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 636:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63a:	00000797          	auipc	a5,0x0
 63e:	1be7b783          	ld	a5,446(a5) # 7f8 <freep>
 642:	a805                	j	672 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 644:	4618                	lw	a4,8(a2)
 646:	9db9                	addw	a1,a1,a4
 648:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 64c:	6398                	ld	a4,0(a5)
 64e:	6318                	ld	a4,0(a4)
 650:	fee53823          	sd	a4,-16(a0)
 654:	a091                	j	698 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 656:	ff852703          	lw	a4,-8(a0)
 65a:	9e39                	addw	a2,a2,a4
 65c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 65e:	ff053703          	ld	a4,-16(a0)
 662:	e398                	sd	a4,0(a5)
 664:	a099                	j	6aa <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 666:	6398                	ld	a4,0(a5)
 668:	00e7e463          	bltu	a5,a4,670 <free+0x40>
 66c:	00e6ea63          	bltu	a3,a4,680 <free+0x50>
{
 670:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 672:	fed7fae3          	bgeu	a5,a3,666 <free+0x36>
 676:	6398                	ld	a4,0(a5)
 678:	00e6e463          	bltu	a3,a4,680 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67c:	fee7eae3          	bltu	a5,a4,670 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 680:	ff852583          	lw	a1,-8(a0)
 684:	6390                	ld	a2,0(a5)
 686:	02059813          	slli	a6,a1,0x20
 68a:	01c85713          	srli	a4,a6,0x1c
 68e:	9736                	add	a4,a4,a3
 690:	fae60ae3          	beq	a2,a4,644 <free+0x14>
    bp->s.ptr = p->s.ptr;
 694:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 698:	4790                	lw	a2,8(a5)
 69a:	02061593          	slli	a1,a2,0x20
 69e:	01c5d713          	srli	a4,a1,0x1c
 6a2:	973e                	add	a4,a4,a5
 6a4:	fae689e3          	beq	a3,a4,656 <free+0x26>
  } else
    p->s.ptr = bp;
 6a8:	e394                	sd	a3,0(a5)
  freep = p;
 6aa:	00000717          	auipc	a4,0x0
 6ae:	14f73723          	sd	a5,334(a4) # 7f8 <freep>
}
 6b2:	6422                	ld	s0,8(sp)
 6b4:	0141                	addi	sp,sp,16
 6b6:	8082                	ret

00000000000006b8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6b8:	7139                	addi	sp,sp,-64
 6ba:	fc06                	sd	ra,56(sp)
 6bc:	f822                	sd	s0,48(sp)
 6be:	f426                	sd	s1,40(sp)
 6c0:	f04a                	sd	s2,32(sp)
 6c2:	ec4e                	sd	s3,24(sp)
 6c4:	e852                	sd	s4,16(sp)
 6c6:	e456                	sd	s5,8(sp)
 6c8:	e05a                	sd	s6,0(sp)
 6ca:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6cc:	02051493          	slli	s1,a0,0x20
 6d0:	9081                	srli	s1,s1,0x20
 6d2:	04bd                	addi	s1,s1,15
 6d4:	8091                	srli	s1,s1,0x4
 6d6:	0014899b          	addiw	s3,s1,1
 6da:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6dc:	00000517          	auipc	a0,0x0
 6e0:	11c53503          	ld	a0,284(a0) # 7f8 <freep>
 6e4:	c515                	beqz	a0,710 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6e8:	4798                	lw	a4,8(a5)
 6ea:	02977f63          	bgeu	a4,s1,728 <malloc+0x70>
 6ee:	8a4e                	mv	s4,s3
 6f0:	0009871b          	sext.w	a4,s3
 6f4:	6685                	lui	a3,0x1
 6f6:	00d77363          	bgeu	a4,a3,6fc <malloc+0x44>
 6fa:	6a05                	lui	s4,0x1
 6fc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 700:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 704:	00000917          	auipc	s2,0x0
 708:	0f490913          	addi	s2,s2,244 # 7f8 <freep>
  if(p == (char*)-1)
 70c:	5afd                	li	s5,-1
 70e:	a895                	j	782 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 710:	00000797          	auipc	a5,0x0
 714:	0f078793          	addi	a5,a5,240 # 800 <base>
 718:	00000717          	auipc	a4,0x0
 71c:	0ef73023          	sd	a5,224(a4) # 7f8 <freep>
 720:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 722:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 726:	b7e1                	j	6ee <malloc+0x36>
      if(p->s.size == nunits)
 728:	02e48c63          	beq	s1,a4,760 <malloc+0xa8>
        p->s.size -= nunits;
 72c:	4137073b          	subw	a4,a4,s3
 730:	c798                	sw	a4,8(a5)
        p += p->s.size;
 732:	02071693          	slli	a3,a4,0x20
 736:	01c6d713          	srli	a4,a3,0x1c
 73a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 73c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 740:	00000717          	auipc	a4,0x0
 744:	0aa73c23          	sd	a0,184(a4) # 7f8 <freep>
      return (void*)(p + 1);
 748:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 74c:	70e2                	ld	ra,56(sp)
 74e:	7442                	ld	s0,48(sp)
 750:	74a2                	ld	s1,40(sp)
 752:	7902                	ld	s2,32(sp)
 754:	69e2                	ld	s3,24(sp)
 756:	6a42                	ld	s4,16(sp)
 758:	6aa2                	ld	s5,8(sp)
 75a:	6b02                	ld	s6,0(sp)
 75c:	6121                	addi	sp,sp,64
 75e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 760:	6398                	ld	a4,0(a5)
 762:	e118                	sd	a4,0(a0)
 764:	bff1                	j	740 <malloc+0x88>
  hp->s.size = nu;
 766:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 76a:	0541                	addi	a0,a0,16
 76c:	00000097          	auipc	ra,0x0
 770:	ec4080e7          	jalr	-316(ra) # 630 <free>
  return freep;
 774:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 778:	d971                	beqz	a0,74c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 77c:	4798                	lw	a4,8(a5)
 77e:	fa9775e3          	bgeu	a4,s1,728 <malloc+0x70>
    if(p == freep)
 782:	00093703          	ld	a4,0(s2)
 786:	853e                	mv	a0,a5
 788:	fef719e3          	bne	a4,a5,77a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 78c:	8552                	mv	a0,s4
 78e:	00000097          	auipc	ra,0x0
 792:	b5c080e7          	jalr	-1188(ra) # 2ea <sbrk>
  if(p == (char*)-1)
 796:	fd5518e3          	bne	a0,s5,766 <malloc+0xae>
        return 0;
 79a:	4501                	li	a0,0
 79c:	bf45                	j	74c <malloc+0x94>
