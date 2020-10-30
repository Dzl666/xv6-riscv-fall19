
user/_crashtest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
  test0();
  exit();
}

void test0()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
  struct stat st;
  
  printf("test0 start\n");
   8:	00001517          	auipc	a0,0x1
   c:	83850513          	addi	a0,a0,-1992 # 840 <malloc+0xec>
  10:	00000097          	auipc	ra,0x0
  14:	686080e7          	jalr	1670(ra) # 696 <printf>

  mknod("disk1", DISK, 1);
  18:	4605                	li	a2,1
  1a:	4581                	li	a1,0
  1c:	00001517          	auipc	a0,0x1
  20:	83450513          	addi	a0,a0,-1996 # 850 <malloc+0xfc>
  24:	00000097          	auipc	ra,0x0
  28:	322080e7          	jalr	802(ra) # 346 <mknod>

  if (stat("/m/crashf", &st) == 0) {
  2c:	fd840593          	addi	a1,s0,-40
  30:	00001517          	auipc	a0,0x1
  34:	82850513          	addi	a0,a0,-2008 # 858 <malloc+0x104>
  38:	00000097          	auipc	ra,0x0
  3c:	204080e7          	jalr	516(ra) # 23c <stat>
  40:	cd21                	beqz	a0,98 <test0+0x98>
    printf("stat /m/crashf succeeded\n");
    exit();
  }

  if (mount("/disk1", "/m") < 0) {
  42:	00001597          	auipc	a1,0x1
  46:	84658593          	addi	a1,a1,-1978 # 888 <malloc+0x134>
  4a:	00001517          	auipc	a0,0x1
  4e:	84650513          	addi	a0,a0,-1978 # 890 <malloc+0x13c>
  52:	00000097          	auipc	ra,0x0
  56:	35c080e7          	jalr	860(ra) # 3ae <mount>
  5a:	04054b63          	bltz	a0,b0 <test0+0xb0>
    printf("mount failed\n");
    exit();
  }    

  if (stat("/m/crashf", &st) < 0) {
  5e:	fd840593          	addi	a1,s0,-40
  62:	00000517          	auipc	a0,0x0
  66:	7f650513          	addi	a0,a0,2038 # 858 <malloc+0x104>
  6a:	00000097          	auipc	ra,0x0
  6e:	1d2080e7          	jalr	466(ra) # 23c <stat>
  72:	04054b63          	bltz	a0,c8 <test0+0xc8>
    printf("stat /m/crashf failed\n");
    exit();
  }

  if (minor(st.dev) != 1) {
  76:	fd845583          	lhu	a1,-40(s0)
  7a:	4785                	li	a5,1
  7c:	06f59263          	bne	a1,a5,e0 <test0+0xe0>
    printf("stat wrong minor %d\n", minor(st.dev));
    exit();
  }
  
  printf("test0 ok\n");
  80:	00001517          	auipc	a0,0x1
  84:	85850513          	addi	a0,a0,-1960 # 8d8 <malloc+0x184>
  88:	00000097          	auipc	ra,0x0
  8c:	60e080e7          	jalr	1550(ra) # 696 <printf>
}
  90:	70a2                	ld	ra,40(sp)
  92:	7402                	ld	s0,32(sp)
  94:	6145                	addi	sp,sp,48
  96:	8082                	ret
    printf("stat /m/crashf succeeded\n");
  98:	00000517          	auipc	a0,0x0
  9c:	7d050513          	addi	a0,a0,2000 # 868 <malloc+0x114>
  a0:	00000097          	auipc	ra,0x0
  a4:	5f6080e7          	jalr	1526(ra) # 696 <printf>
    exit();
  a8:	00000097          	auipc	ra,0x0
  ac:	256080e7          	jalr	598(ra) # 2fe <exit>
    printf("mount failed\n");
  b0:	00000517          	auipc	a0,0x0
  b4:	7e850513          	addi	a0,a0,2024 # 898 <malloc+0x144>
  b8:	00000097          	auipc	ra,0x0
  bc:	5de080e7          	jalr	1502(ra) # 696 <printf>
    exit();
  c0:	00000097          	auipc	ra,0x0
  c4:	23e080e7          	jalr	574(ra) # 2fe <exit>
    printf("stat /m/crashf failed\n");
  c8:	00000517          	auipc	a0,0x0
  cc:	7e050513          	addi	a0,a0,2016 # 8a8 <malloc+0x154>
  d0:	00000097          	auipc	ra,0x0
  d4:	5c6080e7          	jalr	1478(ra) # 696 <printf>
    exit();
  d8:	00000097          	auipc	ra,0x0
  dc:	226080e7          	jalr	550(ra) # 2fe <exit>
    printf("stat wrong minor %d\n", minor(st.dev));
  e0:	00000517          	auipc	a0,0x0
  e4:	7e050513          	addi	a0,a0,2016 # 8c0 <malloc+0x16c>
  e8:	00000097          	auipc	ra,0x0
  ec:	5ae080e7          	jalr	1454(ra) # 696 <printf>
    exit();
  f0:	00000097          	auipc	ra,0x0
  f4:	20e080e7          	jalr	526(ra) # 2fe <exit>

00000000000000f8 <main>:
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  test0();
 100:	00000097          	auipc	ra,0x0
 104:	f00080e7          	jalr	-256(ra) # 0 <test0>
  exit();
 108:	00000097          	auipc	ra,0x0
 10c:	1f6080e7          	jalr	502(ra) # 2fe <exit>

0000000000000110 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 110:	1141                	addi	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 116:	87aa                	mv	a5,a0
 118:	0585                	addi	a1,a1,1
 11a:	0785                	addi	a5,a5,1
 11c:	fff5c703          	lbu	a4,-1(a1)
 120:	fee78fa3          	sb	a4,-1(a5)
 124:	fb75                	bnez	a4,118 <strcpy+0x8>
    ;
  return os;
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret

000000000000012c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e422                	sd	s0,8(sp)
 130:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 132:	00054783          	lbu	a5,0(a0)
 136:	cb91                	beqz	a5,14a <strcmp+0x1e>
 138:	0005c703          	lbu	a4,0(a1)
 13c:	00f71763          	bne	a4,a5,14a <strcmp+0x1e>
    p++, q++;
 140:	0505                	addi	a0,a0,1
 142:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 144:	00054783          	lbu	a5,0(a0)
 148:	fbe5                	bnez	a5,138 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14a:	0005c503          	lbu	a0,0(a1)
}
 14e:	40a7853b          	subw	a0,a5,a0
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strlen>:

uint
strlen(const char *s)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cf91                	beqz	a5,17e <strlen+0x26>
 164:	0505                	addi	a0,a0,1
 166:	87aa                	mv	a5,a0
 168:	4685                	li	a3,1
 16a:	9e89                	subw	a3,a3,a0
 16c:	00f6853b          	addw	a0,a3,a5
 170:	0785                	addi	a5,a5,1
 172:	fff7c703          	lbu	a4,-1(a5)
 176:	fb7d                	bnez	a4,16c <strlen+0x14>
    ;
  return n;
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret
  for(n = 0; s[n]; n++)
 17e:	4501                	li	a0,0
 180:	bfe5                	j	178 <strlen+0x20>

0000000000000182 <memset>:

void*
memset(void *dst, int c, uint n)
{
 182:	1141                	addi	sp,sp,-16
 184:	e422                	sd	s0,8(sp)
 186:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 188:	ca19                	beqz	a2,19e <memset+0x1c>
 18a:	87aa                	mv	a5,a0
 18c:	1602                	slli	a2,a2,0x20
 18e:	9201                	srli	a2,a2,0x20
 190:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 194:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 198:	0785                	addi	a5,a5,1
 19a:	fee79de3          	bne	a5,a4,194 <memset+0x12>
  }
  return dst;
}
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <strchr>:

char*
strchr(const char *s, char c)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cb99                	beqz	a5,1c4 <strchr+0x20>
    if(*s == c)
 1b0:	00f58763          	beq	a1,a5,1be <strchr+0x1a>
  for(; *s; s++)
 1b4:	0505                	addi	a0,a0,1
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	fbfd                	bnez	a5,1b0 <strchr+0xc>
      return (char*)s;
  return 0;
 1bc:	4501                	li	a0,0
}
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	addi	sp,sp,16
 1c2:	8082                	ret
  return 0;
 1c4:	4501                	li	a0,0
 1c6:	bfe5                	j	1be <strchr+0x1a>

00000000000001c8 <gets>:

char*
gets(char *buf, int max)
{
 1c8:	711d                	addi	sp,sp,-96
 1ca:	ec86                	sd	ra,88(sp)
 1cc:	e8a2                	sd	s0,80(sp)
 1ce:	e4a6                	sd	s1,72(sp)
 1d0:	e0ca                	sd	s2,64(sp)
 1d2:	fc4e                	sd	s3,56(sp)
 1d4:	f852                	sd	s4,48(sp)
 1d6:	f456                	sd	s5,40(sp)
 1d8:	f05a                	sd	s6,32(sp)
 1da:	ec5e                	sd	s7,24(sp)
 1dc:	1080                	addi	s0,sp,96
 1de:	8baa                	mv	s7,a0
 1e0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e2:	892a                	mv	s2,a0
 1e4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e6:	4aa9                	li	s5,10
 1e8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ea:	89a6                	mv	s3,s1
 1ec:	2485                	addiw	s1,s1,1
 1ee:	0344d863          	bge	s1,s4,21e <gets+0x56>
    cc = read(0, &c, 1);
 1f2:	4605                	li	a2,1
 1f4:	faf40593          	addi	a1,s0,-81
 1f8:	4501                	li	a0,0
 1fa:	00000097          	auipc	ra,0x0
 1fe:	11c080e7          	jalr	284(ra) # 316 <read>
    if(cc < 1)
 202:	00a05e63          	blez	a0,21e <gets+0x56>
    buf[i++] = c;
 206:	faf44783          	lbu	a5,-81(s0)
 20a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20e:	01578763          	beq	a5,s5,21c <gets+0x54>
 212:	0905                	addi	s2,s2,1
 214:	fd679be3          	bne	a5,s6,1ea <gets+0x22>
  for(i=0; i+1 < max; ){
 218:	89a6                	mv	s3,s1
 21a:	a011                	j	21e <gets+0x56>
 21c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 21e:	99de                	add	s3,s3,s7
 220:	00098023          	sb	zero,0(s3)
  return buf;
}
 224:	855e                	mv	a0,s7
 226:	60e6                	ld	ra,88(sp)
 228:	6446                	ld	s0,80(sp)
 22a:	64a6                	ld	s1,72(sp)
 22c:	6906                	ld	s2,64(sp)
 22e:	79e2                	ld	s3,56(sp)
 230:	7a42                	ld	s4,48(sp)
 232:	7aa2                	ld	s5,40(sp)
 234:	7b02                	ld	s6,32(sp)
 236:	6be2                	ld	s7,24(sp)
 238:	6125                	addi	sp,sp,96
 23a:	8082                	ret

000000000000023c <stat>:

int
stat(const char *n, struct stat *st)
{
 23c:	1101                	addi	sp,sp,-32
 23e:	ec06                	sd	ra,24(sp)
 240:	e822                	sd	s0,16(sp)
 242:	e426                	sd	s1,8(sp)
 244:	e04a                	sd	s2,0(sp)
 246:	1000                	addi	s0,sp,32
 248:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24a:	4581                	li	a1,0
 24c:	00000097          	auipc	ra,0x0
 250:	0f2080e7          	jalr	242(ra) # 33e <open>
  if(fd < 0)
 254:	02054563          	bltz	a0,27e <stat+0x42>
 258:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25a:	85ca                	mv	a1,s2
 25c:	00000097          	auipc	ra,0x0
 260:	0fa080e7          	jalr	250(ra) # 356 <fstat>
 264:	892a                	mv	s2,a0
  close(fd);
 266:	8526                	mv	a0,s1
 268:	00000097          	auipc	ra,0x0
 26c:	0be080e7          	jalr	190(ra) # 326 <close>
  return r;
}
 270:	854a                	mv	a0,s2
 272:	60e2                	ld	ra,24(sp)
 274:	6442                	ld	s0,16(sp)
 276:	64a2                	ld	s1,8(sp)
 278:	6902                	ld	s2,0(sp)
 27a:	6105                	addi	sp,sp,32
 27c:	8082                	ret
    return -1;
 27e:	597d                	li	s2,-1
 280:	bfc5                	j	270 <stat+0x34>

0000000000000282 <atoi>:

int
atoi(const char *s)
{
 282:	1141                	addi	sp,sp,-16
 284:	e422                	sd	s0,8(sp)
 286:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 288:	00054603          	lbu	a2,0(a0)
 28c:	fd06079b          	addiw	a5,a2,-48
 290:	0ff7f793          	andi	a5,a5,255
 294:	4725                	li	a4,9
 296:	02f76963          	bltu	a4,a5,2c8 <atoi+0x46>
 29a:	86aa                	mv	a3,a0
  n = 0;
 29c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 29e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2a0:	0685                	addi	a3,a3,1
 2a2:	0025179b          	slliw	a5,a0,0x2
 2a6:	9fa9                	addw	a5,a5,a0
 2a8:	0017979b          	slliw	a5,a5,0x1
 2ac:	9fb1                	addw	a5,a5,a2
 2ae:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b2:	0006c603          	lbu	a2,0(a3)
 2b6:	fd06071b          	addiw	a4,a2,-48
 2ba:	0ff77713          	andi	a4,a4,255
 2be:	fee5f1e3          	bgeu	a1,a4,2a0 <atoi+0x1e>
  return n;
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
  n = 0;
 2c8:	4501                	li	a0,0
 2ca:	bfe5                	j	2c2 <atoi+0x40>

00000000000002cc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d2:	00c05f63          	blez	a2,2f0 <memmove+0x24>
 2d6:	1602                	slli	a2,a2,0x20
 2d8:	9201                	srli	a2,a2,0x20
 2da:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 2de:	87aa                	mv	a5,a0
    *dst++ = *src++;
 2e0:	0585                	addi	a1,a1,1
 2e2:	0785                	addi	a5,a5,1
 2e4:	fff5c703          	lbu	a4,-1(a1)
 2e8:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 2ec:	fed79ae3          	bne	a5,a3,2e0 <memmove+0x14>
  return vdst;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret

00000000000002f6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f6:	4885                	li	a7,1
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <exit>:
.global exit
exit:
 li a7, SYS_exit
 2fe:	4889                	li	a7,2
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <wait>:
.global wait
wait:
 li a7, SYS_wait
 306:	488d                	li	a7,3
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 30e:	4891                	li	a7,4
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <read>:
.global read
read:
 li a7, SYS_read
 316:	4895                	li	a7,5
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <write>:
.global write
write:
 li a7, SYS_write
 31e:	48c1                	li	a7,16
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <close>:
.global close
close:
 li a7, SYS_close
 326:	48d5                	li	a7,21
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <kill>:
.global kill
kill:
 li a7, SYS_kill
 32e:	4899                	li	a7,6
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <exec>:
.global exec
exec:
 li a7, SYS_exec
 336:	489d                	li	a7,7
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <open>:
.global open
open:
 li a7, SYS_open
 33e:	48bd                	li	a7,15
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 346:	48c5                	li	a7,17
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 34e:	48c9                	li	a7,18
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 356:	48a1                	li	a7,8
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <link>:
.global link
link:
 li a7, SYS_link
 35e:	48cd                	li	a7,19
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 366:	48d1                	li	a7,20
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 36e:	48a5                	li	a7,9
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <dup>:
.global dup
dup:
 li a7, SYS_dup
 376:	48a9                	li	a7,10
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 37e:	48ad                	li	a7,11
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 386:	48b1                	li	a7,12
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 38e:	48b5                	li	a7,13
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 396:	48b9                	li	a7,14
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 39e:	48d9                	li	a7,22
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <crash>:
.global crash
crash:
 li a7, SYS_crash
 3a6:	48dd                	li	a7,23
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <mount>:
.global mount
mount:
 li a7, SYS_mount
 3ae:	48e1                	li	a7,24
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <umount>:
.global umount
umount:
 li a7, SYS_umount
 3b6:	48e5                	li	a7,25
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3be:	1101                	addi	sp,sp,-32
 3c0:	ec06                	sd	ra,24(sp)
 3c2:	e822                	sd	s0,16(sp)
 3c4:	1000                	addi	s0,sp,32
 3c6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ca:	4605                	li	a2,1
 3cc:	fef40593          	addi	a1,s0,-17
 3d0:	00000097          	auipc	ra,0x0
 3d4:	f4e080e7          	jalr	-178(ra) # 31e <write>
}
 3d8:	60e2                	ld	ra,24(sp)
 3da:	6442                	ld	s0,16(sp)
 3dc:	6105                	addi	sp,sp,32
 3de:	8082                	ret

00000000000003e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e0:	7139                	addi	sp,sp,-64
 3e2:	fc06                	sd	ra,56(sp)
 3e4:	f822                	sd	s0,48(sp)
 3e6:	f426                	sd	s1,40(sp)
 3e8:	f04a                	sd	s2,32(sp)
 3ea:	ec4e                	sd	s3,24(sp)
 3ec:	0080                	addi	s0,sp,64
 3ee:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f0:	c299                	beqz	a3,3f6 <printint+0x16>
 3f2:	0805c863          	bltz	a1,482 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f6:	2581                	sext.w	a1,a1
  neg = 0;
 3f8:	4881                	li	a7,0
 3fa:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3fe:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 400:	2601                	sext.w	a2,a2
 402:	00000517          	auipc	a0,0x0
 406:	4ee50513          	addi	a0,a0,1262 # 8f0 <digits>
 40a:	883a                	mv	a6,a4
 40c:	2705                	addiw	a4,a4,1
 40e:	02c5f7bb          	remuw	a5,a1,a2
 412:	1782                	slli	a5,a5,0x20
 414:	9381                	srli	a5,a5,0x20
 416:	97aa                	add	a5,a5,a0
 418:	0007c783          	lbu	a5,0(a5)
 41c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 420:	0005879b          	sext.w	a5,a1
 424:	02c5d5bb          	divuw	a1,a1,a2
 428:	0685                	addi	a3,a3,1
 42a:	fec7f0e3          	bgeu	a5,a2,40a <printint+0x2a>
  if(neg)
 42e:	00088b63          	beqz	a7,444 <printint+0x64>
    buf[i++] = '-';
 432:	fd040793          	addi	a5,s0,-48
 436:	973e                	add	a4,a4,a5
 438:	02d00793          	li	a5,45
 43c:	fef70823          	sb	a5,-16(a4)
 440:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 444:	02e05863          	blez	a4,474 <printint+0x94>
 448:	fc040793          	addi	a5,s0,-64
 44c:	00e78933          	add	s2,a5,a4
 450:	fff78993          	addi	s3,a5,-1
 454:	99ba                	add	s3,s3,a4
 456:	377d                	addiw	a4,a4,-1
 458:	1702                	slli	a4,a4,0x20
 45a:	9301                	srli	a4,a4,0x20
 45c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 460:	fff94583          	lbu	a1,-1(s2)
 464:	8526                	mv	a0,s1
 466:	00000097          	auipc	ra,0x0
 46a:	f58080e7          	jalr	-168(ra) # 3be <putc>
  while(--i >= 0)
 46e:	197d                	addi	s2,s2,-1
 470:	ff3918e3          	bne	s2,s3,460 <printint+0x80>
}
 474:	70e2                	ld	ra,56(sp)
 476:	7442                	ld	s0,48(sp)
 478:	74a2                	ld	s1,40(sp)
 47a:	7902                	ld	s2,32(sp)
 47c:	69e2                	ld	s3,24(sp)
 47e:	6121                	addi	sp,sp,64
 480:	8082                	ret
    x = -xx;
 482:	40b005bb          	negw	a1,a1
    neg = 1;
 486:	4885                	li	a7,1
    x = -xx;
 488:	bf8d                	j	3fa <printint+0x1a>

000000000000048a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 48a:	7119                	addi	sp,sp,-128
 48c:	fc86                	sd	ra,120(sp)
 48e:	f8a2                	sd	s0,112(sp)
 490:	f4a6                	sd	s1,104(sp)
 492:	f0ca                	sd	s2,96(sp)
 494:	ecce                	sd	s3,88(sp)
 496:	e8d2                	sd	s4,80(sp)
 498:	e4d6                	sd	s5,72(sp)
 49a:	e0da                	sd	s6,64(sp)
 49c:	fc5e                	sd	s7,56(sp)
 49e:	f862                	sd	s8,48(sp)
 4a0:	f466                	sd	s9,40(sp)
 4a2:	f06a                	sd	s10,32(sp)
 4a4:	ec6e                	sd	s11,24(sp)
 4a6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a8:	0005c903          	lbu	s2,0(a1)
 4ac:	18090f63          	beqz	s2,64a <vprintf+0x1c0>
 4b0:	8aaa                	mv	s5,a0
 4b2:	8b32                	mv	s6,a2
 4b4:	00158493          	addi	s1,a1,1
  state = 0;
 4b8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ba:	02500a13          	li	s4,37
      if(c == 'd'){
 4be:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4c2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4c6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4ca:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4ce:	00000b97          	auipc	s7,0x0
 4d2:	422b8b93          	addi	s7,s7,1058 # 8f0 <digits>
 4d6:	a839                	j	4f4 <vprintf+0x6a>
        putc(fd, c);
 4d8:	85ca                	mv	a1,s2
 4da:	8556                	mv	a0,s5
 4dc:	00000097          	auipc	ra,0x0
 4e0:	ee2080e7          	jalr	-286(ra) # 3be <putc>
 4e4:	a019                	j	4ea <vprintf+0x60>
    } else if(state == '%'){
 4e6:	01498f63          	beq	s3,s4,504 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4ea:	0485                	addi	s1,s1,1
 4ec:	fff4c903          	lbu	s2,-1(s1)
 4f0:	14090d63          	beqz	s2,64a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4f4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4f8:	fe0997e3          	bnez	s3,4e6 <vprintf+0x5c>
      if(c == '%'){
 4fc:	fd479ee3          	bne	a5,s4,4d8 <vprintf+0x4e>
        state = '%';
 500:	89be                	mv	s3,a5
 502:	b7e5                	j	4ea <vprintf+0x60>
      if(c == 'd'){
 504:	05878063          	beq	a5,s8,544 <vprintf+0xba>
      } else if(c == 'l') {
 508:	05978c63          	beq	a5,s9,560 <vprintf+0xd6>
      } else if(c == 'x') {
 50c:	07a78863          	beq	a5,s10,57c <vprintf+0xf2>
      } else if(c == 'p') {
 510:	09b78463          	beq	a5,s11,598 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 514:	07300713          	li	a4,115
 518:	0ce78663          	beq	a5,a4,5e4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 51c:	06300713          	li	a4,99
 520:	0ee78e63          	beq	a5,a4,61c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 524:	11478863          	beq	a5,s4,634 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 528:	85d2                	mv	a1,s4
 52a:	8556                	mv	a0,s5
 52c:	00000097          	auipc	ra,0x0
 530:	e92080e7          	jalr	-366(ra) # 3be <putc>
        putc(fd, c);
 534:	85ca                	mv	a1,s2
 536:	8556                	mv	a0,s5
 538:	00000097          	auipc	ra,0x0
 53c:	e86080e7          	jalr	-378(ra) # 3be <putc>
      }
      state = 0;
 540:	4981                	li	s3,0
 542:	b765                	j	4ea <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 544:	008b0913          	addi	s2,s6,8
 548:	4685                	li	a3,1
 54a:	4629                	li	a2,10
 54c:	000b2583          	lw	a1,0(s6)
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	e8e080e7          	jalr	-370(ra) # 3e0 <printint>
 55a:	8b4a                	mv	s6,s2
      state = 0;
 55c:	4981                	li	s3,0
 55e:	b771                	j	4ea <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 560:	008b0913          	addi	s2,s6,8
 564:	4681                	li	a3,0
 566:	4629                	li	a2,10
 568:	000b2583          	lw	a1,0(s6)
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	e72080e7          	jalr	-398(ra) # 3e0 <printint>
 576:	8b4a                	mv	s6,s2
      state = 0;
 578:	4981                	li	s3,0
 57a:	bf85                	j	4ea <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 57c:	008b0913          	addi	s2,s6,8
 580:	4681                	li	a3,0
 582:	4641                	li	a2,16
 584:	000b2583          	lw	a1,0(s6)
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	e56080e7          	jalr	-426(ra) # 3e0 <printint>
 592:	8b4a                	mv	s6,s2
      state = 0;
 594:	4981                	li	s3,0
 596:	bf91                	j	4ea <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 598:	008b0793          	addi	a5,s6,8
 59c:	f8f43423          	sd	a5,-120(s0)
 5a0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5a4:	03000593          	li	a1,48
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	e14080e7          	jalr	-492(ra) # 3be <putc>
  putc(fd, 'x');
 5b2:	85ea                	mv	a1,s10
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	e08080e7          	jalr	-504(ra) # 3be <putc>
 5be:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c0:	03c9d793          	srli	a5,s3,0x3c
 5c4:	97de                	add	a5,a5,s7
 5c6:	0007c583          	lbu	a1,0(a5)
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	df2080e7          	jalr	-526(ra) # 3be <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5d4:	0992                	slli	s3,s3,0x4
 5d6:	397d                	addiw	s2,s2,-1
 5d8:	fe0914e3          	bnez	s2,5c0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5dc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b721                	j	4ea <vprintf+0x60>
        s = va_arg(ap, char*);
 5e4:	008b0993          	addi	s3,s6,8
 5e8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5ec:	02090163          	beqz	s2,60e <vprintf+0x184>
        while(*s != 0){
 5f0:	00094583          	lbu	a1,0(s2)
 5f4:	c9a1                	beqz	a1,644 <vprintf+0x1ba>
          putc(fd, *s);
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	dc6080e7          	jalr	-570(ra) # 3be <putc>
          s++;
 600:	0905                	addi	s2,s2,1
        while(*s != 0){
 602:	00094583          	lbu	a1,0(s2)
 606:	f9e5                	bnez	a1,5f6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 608:	8b4e                	mv	s6,s3
      state = 0;
 60a:	4981                	li	s3,0
 60c:	bdf9                	j	4ea <vprintf+0x60>
          s = "(null)";
 60e:	00000917          	auipc	s2,0x0
 612:	2da90913          	addi	s2,s2,730 # 8e8 <malloc+0x194>
        while(*s != 0){
 616:	02800593          	li	a1,40
 61a:	bff1                	j	5f6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 61c:	008b0913          	addi	s2,s6,8
 620:	000b4583          	lbu	a1,0(s6)
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	d98080e7          	jalr	-616(ra) # 3be <putc>
 62e:	8b4a                	mv	s6,s2
      state = 0;
 630:	4981                	li	s3,0
 632:	bd65                	j	4ea <vprintf+0x60>
        putc(fd, c);
 634:	85d2                	mv	a1,s4
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	d86080e7          	jalr	-634(ra) # 3be <putc>
      state = 0;
 640:	4981                	li	s3,0
 642:	b565                	j	4ea <vprintf+0x60>
        s = va_arg(ap, char*);
 644:	8b4e                	mv	s6,s3
      state = 0;
 646:	4981                	li	s3,0
 648:	b54d                	j	4ea <vprintf+0x60>
    }
  }
}
 64a:	70e6                	ld	ra,120(sp)
 64c:	7446                	ld	s0,112(sp)
 64e:	74a6                	ld	s1,104(sp)
 650:	7906                	ld	s2,96(sp)
 652:	69e6                	ld	s3,88(sp)
 654:	6a46                	ld	s4,80(sp)
 656:	6aa6                	ld	s5,72(sp)
 658:	6b06                	ld	s6,64(sp)
 65a:	7be2                	ld	s7,56(sp)
 65c:	7c42                	ld	s8,48(sp)
 65e:	7ca2                	ld	s9,40(sp)
 660:	7d02                	ld	s10,32(sp)
 662:	6de2                	ld	s11,24(sp)
 664:	6109                	addi	sp,sp,128
 666:	8082                	ret

0000000000000668 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 668:	715d                	addi	sp,sp,-80
 66a:	ec06                	sd	ra,24(sp)
 66c:	e822                	sd	s0,16(sp)
 66e:	1000                	addi	s0,sp,32
 670:	e010                	sd	a2,0(s0)
 672:	e414                	sd	a3,8(s0)
 674:	e818                	sd	a4,16(s0)
 676:	ec1c                	sd	a5,24(s0)
 678:	03043023          	sd	a6,32(s0)
 67c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 680:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 684:	8622                	mv	a2,s0
 686:	00000097          	auipc	ra,0x0
 68a:	e04080e7          	jalr	-508(ra) # 48a <vprintf>
}
 68e:	60e2                	ld	ra,24(sp)
 690:	6442                	ld	s0,16(sp)
 692:	6161                	addi	sp,sp,80
 694:	8082                	ret

0000000000000696 <printf>:

void
printf(const char *fmt, ...)
{
 696:	711d                	addi	sp,sp,-96
 698:	ec06                	sd	ra,24(sp)
 69a:	e822                	sd	s0,16(sp)
 69c:	1000                	addi	s0,sp,32
 69e:	e40c                	sd	a1,8(s0)
 6a0:	e810                	sd	a2,16(s0)
 6a2:	ec14                	sd	a3,24(s0)
 6a4:	f018                	sd	a4,32(s0)
 6a6:	f41c                	sd	a5,40(s0)
 6a8:	03043823          	sd	a6,48(s0)
 6ac:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6b0:	00840613          	addi	a2,s0,8
 6b4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6b8:	85aa                	mv	a1,a0
 6ba:	4505                	li	a0,1
 6bc:	00000097          	auipc	ra,0x0
 6c0:	dce080e7          	jalr	-562(ra) # 48a <vprintf>
}
 6c4:	60e2                	ld	ra,24(sp)
 6c6:	6442                	ld	s0,16(sp)
 6c8:	6125                	addi	sp,sp,96
 6ca:	8082                	ret

00000000000006cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6cc:	1141                	addi	sp,sp,-16
 6ce:	e422                	sd	s0,8(sp)
 6d0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d6:	00000797          	auipc	a5,0x0
 6da:	2327b783          	ld	a5,562(a5) # 908 <freep>
 6de:	a805                	j	70e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6e0:	4618                	lw	a4,8(a2)
 6e2:	9db9                	addw	a1,a1,a4
 6e4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e8:	6398                	ld	a4,0(a5)
 6ea:	6318                	ld	a4,0(a4)
 6ec:	fee53823          	sd	a4,-16(a0)
 6f0:	a091                	j	734 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6f2:	ff852703          	lw	a4,-8(a0)
 6f6:	9e39                	addw	a2,a2,a4
 6f8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6fa:	ff053703          	ld	a4,-16(a0)
 6fe:	e398                	sd	a4,0(a5)
 700:	a099                	j	746 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 702:	6398                	ld	a4,0(a5)
 704:	00e7e463          	bltu	a5,a4,70c <free+0x40>
 708:	00e6ea63          	bltu	a3,a4,71c <free+0x50>
{
 70c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70e:	fed7fae3          	bgeu	a5,a3,702 <free+0x36>
 712:	6398                	ld	a4,0(a5)
 714:	00e6e463          	bltu	a3,a4,71c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 718:	fee7eae3          	bltu	a5,a4,70c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 71c:	ff852583          	lw	a1,-8(a0)
 720:	6390                	ld	a2,0(a5)
 722:	02059813          	slli	a6,a1,0x20
 726:	01c85713          	srli	a4,a6,0x1c
 72a:	9736                	add	a4,a4,a3
 72c:	fae60ae3          	beq	a2,a4,6e0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 730:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 734:	4790                	lw	a2,8(a5)
 736:	02061593          	slli	a1,a2,0x20
 73a:	01c5d713          	srli	a4,a1,0x1c
 73e:	973e                	add	a4,a4,a5
 740:	fae689e3          	beq	a3,a4,6f2 <free+0x26>
  } else
    p->s.ptr = bp;
 744:	e394                	sd	a3,0(a5)
  freep = p;
 746:	00000717          	auipc	a4,0x0
 74a:	1cf73123          	sd	a5,450(a4) # 908 <freep>
}
 74e:	6422                	ld	s0,8(sp)
 750:	0141                	addi	sp,sp,16
 752:	8082                	ret

0000000000000754 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 754:	7139                	addi	sp,sp,-64
 756:	fc06                	sd	ra,56(sp)
 758:	f822                	sd	s0,48(sp)
 75a:	f426                	sd	s1,40(sp)
 75c:	f04a                	sd	s2,32(sp)
 75e:	ec4e                	sd	s3,24(sp)
 760:	e852                	sd	s4,16(sp)
 762:	e456                	sd	s5,8(sp)
 764:	e05a                	sd	s6,0(sp)
 766:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 768:	02051493          	slli	s1,a0,0x20
 76c:	9081                	srli	s1,s1,0x20
 76e:	04bd                	addi	s1,s1,15
 770:	8091                	srli	s1,s1,0x4
 772:	0014899b          	addiw	s3,s1,1
 776:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 778:	00000517          	auipc	a0,0x0
 77c:	19053503          	ld	a0,400(a0) # 908 <freep>
 780:	c515                	beqz	a0,7ac <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 782:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 784:	4798                	lw	a4,8(a5)
 786:	02977f63          	bgeu	a4,s1,7c4 <malloc+0x70>
 78a:	8a4e                	mv	s4,s3
 78c:	0009871b          	sext.w	a4,s3
 790:	6685                	lui	a3,0x1
 792:	00d77363          	bgeu	a4,a3,798 <malloc+0x44>
 796:	6a05                	lui	s4,0x1
 798:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 79c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a0:	00000917          	auipc	s2,0x0
 7a4:	16890913          	addi	s2,s2,360 # 908 <freep>
  if(p == (char*)-1)
 7a8:	5afd                	li	s5,-1
 7aa:	a895                	j	81e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7ac:	00000797          	auipc	a5,0x0
 7b0:	16478793          	addi	a5,a5,356 # 910 <base>
 7b4:	00000717          	auipc	a4,0x0
 7b8:	14f73a23          	sd	a5,340(a4) # 908 <freep>
 7bc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7be:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7c2:	b7e1                	j	78a <malloc+0x36>
      if(p->s.size == nunits)
 7c4:	02e48c63          	beq	s1,a4,7fc <malloc+0xa8>
        p->s.size -= nunits;
 7c8:	4137073b          	subw	a4,a4,s3
 7cc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7ce:	02071693          	slli	a3,a4,0x20
 7d2:	01c6d713          	srli	a4,a3,0x1c
 7d6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7d8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7dc:	00000717          	auipc	a4,0x0
 7e0:	12a73623          	sd	a0,300(a4) # 908 <freep>
      return (void*)(p + 1);
 7e4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7e8:	70e2                	ld	ra,56(sp)
 7ea:	7442                	ld	s0,48(sp)
 7ec:	74a2                	ld	s1,40(sp)
 7ee:	7902                	ld	s2,32(sp)
 7f0:	69e2                	ld	s3,24(sp)
 7f2:	6a42                	ld	s4,16(sp)
 7f4:	6aa2                	ld	s5,8(sp)
 7f6:	6b02                	ld	s6,0(sp)
 7f8:	6121                	addi	sp,sp,64
 7fa:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7fc:	6398                	ld	a4,0(a5)
 7fe:	e118                	sd	a4,0(a0)
 800:	bff1                	j	7dc <malloc+0x88>
  hp->s.size = nu;
 802:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 806:	0541                	addi	a0,a0,16
 808:	00000097          	auipc	ra,0x0
 80c:	ec4080e7          	jalr	-316(ra) # 6cc <free>
  return freep;
 810:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 814:	d971                	beqz	a0,7e8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 816:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 818:	4798                	lw	a4,8(a5)
 81a:	fa9775e3          	bgeu	a4,s1,7c4 <malloc+0x70>
    if(p == freep)
 81e:	00093703          	ld	a4,0(s2)
 822:	853e                	mv	a0,a5
 824:	fef719e3          	bne	a4,a5,816 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 828:	8552                	mv	a0,s4
 82a:	00000097          	auipc	ra,0x0
 82e:	b5c080e7          	jalr	-1188(ra) # 386 <sbrk>
  if(p == (char*)-1)
 832:	fd5518e3          	bne	a0,s5,802 <malloc+0xae>
        return 0;
 836:	4501                	li	a0,0
 838:	bf45                	j	7e8 <malloc+0x94>
