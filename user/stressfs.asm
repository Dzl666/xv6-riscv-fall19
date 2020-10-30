
user/_stressfs：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	85278793          	addi	a5,a5,-1966 # 868 <malloc+0x11c>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	80c50513          	addi	a0,a0,-2036 # 838 <malloc+0xec>
  34:	00000097          	auipc	ra,0x0
  38:	65a080e7          	jalr	1626(ra) # 68e <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	132080e7          	jalr	306(ra) # 17a <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	29a080e7          	jalr	666(ra) # 2ee <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00000517          	auipc	a0,0x0
  6c:	7e850513          	addi	a0,a0,2024 # 850 <malloc+0x104>
  70:	00000097          	auipc	ra,0x0
  74:	61e080e7          	jalr	1566(ra) # 68e <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9cbd                	addw	s1,s1,a5
  7e:	fc940c23          	sb	s1,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	2ac080e7          	jalr	684(ra) # 336 <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	276080e7          	jalr	630(ra) # 316 <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	270080e7          	jalr	624(ra) # 31e <close>

  printf("read\n");
  b6:	00000517          	auipc	a0,0x0
  ba:	7aa50513          	addi	a0,a0,1962 # 860 <malloc+0x114>
  be:	00000097          	auipc	ra,0x0
  c2:	5d0080e7          	jalr	1488(ra) # 68e <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	26a080e7          	jalr	618(ra) # 336 <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	22c080e7          	jalr	556(ra) # 30e <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	22e080e7          	jalr	558(ra) # 31e <close>

  wait();
  f8:	00000097          	auipc	ra,0x0
  fc:	206080e7          	jalr	518(ra) # 2fe <wait>

  exit();
 100:	00000097          	auipc	ra,0x0
 104:	1f6080e7          	jalr	502(ra) # 2f6 <exit>

0000000000000108 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e422                	sd	s0,8(sp)
 10c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10e:	87aa                	mv	a5,a0
 110:	0585                	addi	a1,a1,1
 112:	0785                	addi	a5,a5,1
 114:	fff5c703          	lbu	a4,-1(a1)
 118:	fee78fa3          	sb	a4,-1(a5)
 11c:	fb75                	bnez	a4,110 <strcpy+0x8>
    ;
  return os;
}
 11e:	6422                	ld	s0,8(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret

0000000000000124 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 124:	1141                	addi	sp,sp,-16
 126:	e422                	sd	s0,8(sp)
 128:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	cb91                	beqz	a5,142 <strcmp+0x1e>
 130:	0005c703          	lbu	a4,0(a1)
 134:	00f71763          	bne	a4,a5,142 <strcmp+0x1e>
    p++, q++;
 138:	0505                	addi	a0,a0,1
 13a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 13c:	00054783          	lbu	a5,0(a0)
 140:	fbe5                	bnez	a5,130 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 142:	0005c503          	lbu	a0,0(a1)
}
 146:	40a7853b          	subw	a0,a5,a0
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret

0000000000000150 <strlen>:

uint
strlen(const char *s)
{
 150:	1141                	addi	sp,sp,-16
 152:	e422                	sd	s0,8(sp)
 154:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cf91                	beqz	a5,176 <strlen+0x26>
 15c:	0505                	addi	a0,a0,1
 15e:	87aa                	mv	a5,a0
 160:	4685                	li	a3,1
 162:	9e89                	subw	a3,a3,a0
 164:	00f6853b          	addw	a0,a3,a5
 168:	0785                	addi	a5,a5,1
 16a:	fff7c703          	lbu	a4,-1(a5)
 16e:	fb7d                	bnez	a4,164 <strlen+0x14>
    ;
  return n;
}
 170:	6422                	ld	s0,8(sp)
 172:	0141                	addi	sp,sp,16
 174:	8082                	ret
  for(n = 0; s[n]; n++)
 176:	4501                	li	a0,0
 178:	bfe5                	j	170 <strlen+0x20>

000000000000017a <memset>:

void*
memset(void *dst, int c, uint n)
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e422                	sd	s0,8(sp)
 17e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 180:	ca19                	beqz	a2,196 <memset+0x1c>
 182:	87aa                	mv	a5,a0
 184:	1602                	slli	a2,a2,0x20
 186:	9201                	srli	a2,a2,0x20
 188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 18c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 190:	0785                	addi	a5,a5,1
 192:	fee79de3          	bne	a5,a4,18c <memset+0x12>
  }
  return dst;
}
 196:	6422                	ld	s0,8(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <strchr>:

char*
strchr(const char *s, char c)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	cb99                	beqz	a5,1bc <strchr+0x20>
    if(*s == c)
 1a8:	00f58763          	beq	a1,a5,1b6 <strchr+0x1a>
  for(; *s; s++)
 1ac:	0505                	addi	a0,a0,1
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	fbfd                	bnez	a5,1a8 <strchr+0xc>
      return (char*)s;
  return 0;
 1b4:	4501                	li	a0,0
}
 1b6:	6422                	ld	s0,8(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret
  return 0;
 1bc:	4501                	li	a0,0
 1be:	bfe5                	j	1b6 <strchr+0x1a>

00000000000001c0 <gets>:

char*
gets(char *buf, int max)
{
 1c0:	711d                	addi	sp,sp,-96
 1c2:	ec86                	sd	ra,88(sp)
 1c4:	e8a2                	sd	s0,80(sp)
 1c6:	e4a6                	sd	s1,72(sp)
 1c8:	e0ca                	sd	s2,64(sp)
 1ca:	fc4e                	sd	s3,56(sp)
 1cc:	f852                	sd	s4,48(sp)
 1ce:	f456                	sd	s5,40(sp)
 1d0:	f05a                	sd	s6,32(sp)
 1d2:	ec5e                	sd	s7,24(sp)
 1d4:	1080                	addi	s0,sp,96
 1d6:	8baa                	mv	s7,a0
 1d8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1da:	892a                	mv	s2,a0
 1dc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1de:	4aa9                	li	s5,10
 1e0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1e2:	89a6                	mv	s3,s1
 1e4:	2485                	addiw	s1,s1,1
 1e6:	0344d863          	bge	s1,s4,216 <gets+0x56>
    cc = read(0, &c, 1);
 1ea:	4605                	li	a2,1
 1ec:	faf40593          	addi	a1,s0,-81
 1f0:	4501                	li	a0,0
 1f2:	00000097          	auipc	ra,0x0
 1f6:	11c080e7          	jalr	284(ra) # 30e <read>
    if(cc < 1)
 1fa:	00a05e63          	blez	a0,216 <gets+0x56>
    buf[i++] = c;
 1fe:	faf44783          	lbu	a5,-81(s0)
 202:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 206:	01578763          	beq	a5,s5,214 <gets+0x54>
 20a:	0905                	addi	s2,s2,1
 20c:	fd679be3          	bne	a5,s6,1e2 <gets+0x22>
  for(i=0; i+1 < max; ){
 210:	89a6                	mv	s3,s1
 212:	a011                	j	216 <gets+0x56>
 214:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 216:	99de                	add	s3,s3,s7
 218:	00098023          	sb	zero,0(s3)
  return buf;
}
 21c:	855e                	mv	a0,s7
 21e:	60e6                	ld	ra,88(sp)
 220:	6446                	ld	s0,80(sp)
 222:	64a6                	ld	s1,72(sp)
 224:	6906                	ld	s2,64(sp)
 226:	79e2                	ld	s3,56(sp)
 228:	7a42                	ld	s4,48(sp)
 22a:	7aa2                	ld	s5,40(sp)
 22c:	7b02                	ld	s6,32(sp)
 22e:	6be2                	ld	s7,24(sp)
 230:	6125                	addi	sp,sp,96
 232:	8082                	ret

0000000000000234 <stat>:

int
stat(const char *n, struct stat *st)
{
 234:	1101                	addi	sp,sp,-32
 236:	ec06                	sd	ra,24(sp)
 238:	e822                	sd	s0,16(sp)
 23a:	e426                	sd	s1,8(sp)
 23c:	e04a                	sd	s2,0(sp)
 23e:	1000                	addi	s0,sp,32
 240:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 242:	4581                	li	a1,0
 244:	00000097          	auipc	ra,0x0
 248:	0f2080e7          	jalr	242(ra) # 336 <open>
  if(fd < 0)
 24c:	02054563          	bltz	a0,276 <stat+0x42>
 250:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 252:	85ca                	mv	a1,s2
 254:	00000097          	auipc	ra,0x0
 258:	0fa080e7          	jalr	250(ra) # 34e <fstat>
 25c:	892a                	mv	s2,a0
  close(fd);
 25e:	8526                	mv	a0,s1
 260:	00000097          	auipc	ra,0x0
 264:	0be080e7          	jalr	190(ra) # 31e <close>
  return r;
}
 268:	854a                	mv	a0,s2
 26a:	60e2                	ld	ra,24(sp)
 26c:	6442                	ld	s0,16(sp)
 26e:	64a2                	ld	s1,8(sp)
 270:	6902                	ld	s2,0(sp)
 272:	6105                	addi	sp,sp,32
 274:	8082                	ret
    return -1;
 276:	597d                	li	s2,-1
 278:	bfc5                	j	268 <stat+0x34>

000000000000027a <atoi>:

int
atoi(const char *s)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 280:	00054603          	lbu	a2,0(a0)
 284:	fd06079b          	addiw	a5,a2,-48
 288:	0ff7f793          	andi	a5,a5,255
 28c:	4725                	li	a4,9
 28e:	02f76963          	bltu	a4,a5,2c0 <atoi+0x46>
 292:	86aa                	mv	a3,a0
  n = 0;
 294:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 296:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 298:	0685                	addi	a3,a3,1
 29a:	0025179b          	slliw	a5,a0,0x2
 29e:	9fa9                	addw	a5,a5,a0
 2a0:	0017979b          	slliw	a5,a5,0x1
 2a4:	9fb1                	addw	a5,a5,a2
 2a6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2aa:	0006c603          	lbu	a2,0(a3)
 2ae:	fd06071b          	addiw	a4,a2,-48
 2b2:	0ff77713          	andi	a4,a4,255
 2b6:	fee5f1e3          	bgeu	a1,a4,298 <atoi+0x1e>
  return n;
}
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret
  n = 0;
 2c0:	4501                	li	a0,0
 2c2:	bfe5                	j	2ba <atoi+0x40>

00000000000002c4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ca:	00c05f63          	blez	a2,2e8 <memmove+0x24>
 2ce:	1602                	slli	a2,a2,0x20
 2d0:	9201                	srli	a2,a2,0x20
 2d2:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 2d6:	87aa                	mv	a5,a0
    *dst++ = *src++;
 2d8:	0585                	addi	a1,a1,1
 2da:	0785                	addi	a5,a5,1
 2dc:	fff5c703          	lbu	a4,-1(a1)
 2e0:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 2e4:	fed79ae3          	bne	a5,a3,2d8 <memmove+0x14>
  return vdst;
}
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret

00000000000002ee <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ee:	4885                	li	a7,1
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2f6:	4889                	li	a7,2
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <wait>:
.global wait
wait:
 li a7, SYS_wait
 2fe:	488d                	li	a7,3
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 306:	4891                	li	a7,4
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <read>:
.global read
read:
 li a7, SYS_read
 30e:	4895                	li	a7,5
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <write>:
.global write
write:
 li a7, SYS_write
 316:	48c1                	li	a7,16
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <close>:
.global close
close:
 li a7, SYS_close
 31e:	48d5                	li	a7,21
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <kill>:
.global kill
kill:
 li a7, SYS_kill
 326:	4899                	li	a7,6
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <exec>:
.global exec
exec:
 li a7, SYS_exec
 32e:	489d                	li	a7,7
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <open>:
.global open
open:
 li a7, SYS_open
 336:	48bd                	li	a7,15
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 33e:	48c5                	li	a7,17
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 346:	48c9                	li	a7,18
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 34e:	48a1                	li	a7,8
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <link>:
.global link
link:
 li a7, SYS_link
 356:	48cd                	li	a7,19
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 35e:	48d1                	li	a7,20
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 366:	48a5                	li	a7,9
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <dup>:
.global dup
dup:
 li a7, SYS_dup
 36e:	48a9                	li	a7,10
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 376:	48ad                	li	a7,11
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 37e:	48b1                	li	a7,12
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 386:	48b5                	li	a7,13
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 38e:	48b9                	li	a7,14
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 396:	48d9                	li	a7,22
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <crash>:
.global crash
crash:
 li a7, SYS_crash
 39e:	48dd                	li	a7,23
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <mount>:
.global mount
mount:
 li a7, SYS_mount
 3a6:	48e1                	li	a7,24
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <umount>:
.global umount
umount:
 li a7, SYS_umount
 3ae:	48e5                	li	a7,25
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b6:	1101                	addi	sp,sp,-32
 3b8:	ec06                	sd	ra,24(sp)
 3ba:	e822                	sd	s0,16(sp)
 3bc:	1000                	addi	s0,sp,32
 3be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c2:	4605                	li	a2,1
 3c4:	fef40593          	addi	a1,s0,-17
 3c8:	00000097          	auipc	ra,0x0
 3cc:	f4e080e7          	jalr	-178(ra) # 316 <write>
}
 3d0:	60e2                	ld	ra,24(sp)
 3d2:	6442                	ld	s0,16(sp)
 3d4:	6105                	addi	sp,sp,32
 3d6:	8082                	ret

00000000000003d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d8:	7139                	addi	sp,sp,-64
 3da:	fc06                	sd	ra,56(sp)
 3dc:	f822                	sd	s0,48(sp)
 3de:	f426                	sd	s1,40(sp)
 3e0:	f04a                	sd	s2,32(sp)
 3e2:	ec4e                	sd	s3,24(sp)
 3e4:	0080                	addi	s0,sp,64
 3e6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e8:	c299                	beqz	a3,3ee <printint+0x16>
 3ea:	0805c863          	bltz	a1,47a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ee:	2581                	sext.w	a1,a1
  neg = 0;
 3f0:	4881                	li	a7,0
 3f2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3f6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f8:	2601                	sext.w	a2,a2
 3fa:	00000517          	auipc	a0,0x0
 3fe:	48650513          	addi	a0,a0,1158 # 880 <digits>
 402:	883a                	mv	a6,a4
 404:	2705                	addiw	a4,a4,1
 406:	02c5f7bb          	remuw	a5,a1,a2
 40a:	1782                	slli	a5,a5,0x20
 40c:	9381                	srli	a5,a5,0x20
 40e:	97aa                	add	a5,a5,a0
 410:	0007c783          	lbu	a5,0(a5)
 414:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 418:	0005879b          	sext.w	a5,a1
 41c:	02c5d5bb          	divuw	a1,a1,a2
 420:	0685                	addi	a3,a3,1
 422:	fec7f0e3          	bgeu	a5,a2,402 <printint+0x2a>
  if(neg)
 426:	00088b63          	beqz	a7,43c <printint+0x64>
    buf[i++] = '-';
 42a:	fd040793          	addi	a5,s0,-48
 42e:	973e                	add	a4,a4,a5
 430:	02d00793          	li	a5,45
 434:	fef70823          	sb	a5,-16(a4)
 438:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 43c:	02e05863          	blez	a4,46c <printint+0x94>
 440:	fc040793          	addi	a5,s0,-64
 444:	00e78933          	add	s2,a5,a4
 448:	fff78993          	addi	s3,a5,-1
 44c:	99ba                	add	s3,s3,a4
 44e:	377d                	addiw	a4,a4,-1
 450:	1702                	slli	a4,a4,0x20
 452:	9301                	srli	a4,a4,0x20
 454:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 458:	fff94583          	lbu	a1,-1(s2)
 45c:	8526                	mv	a0,s1
 45e:	00000097          	auipc	ra,0x0
 462:	f58080e7          	jalr	-168(ra) # 3b6 <putc>
  while(--i >= 0)
 466:	197d                	addi	s2,s2,-1
 468:	ff3918e3          	bne	s2,s3,458 <printint+0x80>
}
 46c:	70e2                	ld	ra,56(sp)
 46e:	7442                	ld	s0,48(sp)
 470:	74a2                	ld	s1,40(sp)
 472:	7902                	ld	s2,32(sp)
 474:	69e2                	ld	s3,24(sp)
 476:	6121                	addi	sp,sp,64
 478:	8082                	ret
    x = -xx;
 47a:	40b005bb          	negw	a1,a1
    neg = 1;
 47e:	4885                	li	a7,1
    x = -xx;
 480:	bf8d                	j	3f2 <printint+0x1a>

0000000000000482 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 482:	7119                	addi	sp,sp,-128
 484:	fc86                	sd	ra,120(sp)
 486:	f8a2                	sd	s0,112(sp)
 488:	f4a6                	sd	s1,104(sp)
 48a:	f0ca                	sd	s2,96(sp)
 48c:	ecce                	sd	s3,88(sp)
 48e:	e8d2                	sd	s4,80(sp)
 490:	e4d6                	sd	s5,72(sp)
 492:	e0da                	sd	s6,64(sp)
 494:	fc5e                	sd	s7,56(sp)
 496:	f862                	sd	s8,48(sp)
 498:	f466                	sd	s9,40(sp)
 49a:	f06a                	sd	s10,32(sp)
 49c:	ec6e                	sd	s11,24(sp)
 49e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a0:	0005c903          	lbu	s2,0(a1)
 4a4:	18090f63          	beqz	s2,642 <vprintf+0x1c0>
 4a8:	8aaa                	mv	s5,a0
 4aa:	8b32                	mv	s6,a2
 4ac:	00158493          	addi	s1,a1,1
  state = 0;
 4b0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4b2:	02500a13          	li	s4,37
      if(c == 'd'){
 4b6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4ba:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4be:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4c2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4c6:	00000b97          	auipc	s7,0x0
 4ca:	3bab8b93          	addi	s7,s7,954 # 880 <digits>
 4ce:	a839                	j	4ec <vprintf+0x6a>
        putc(fd, c);
 4d0:	85ca                	mv	a1,s2
 4d2:	8556                	mv	a0,s5
 4d4:	00000097          	auipc	ra,0x0
 4d8:	ee2080e7          	jalr	-286(ra) # 3b6 <putc>
 4dc:	a019                	j	4e2 <vprintf+0x60>
    } else if(state == '%'){
 4de:	01498f63          	beq	s3,s4,4fc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4e2:	0485                	addi	s1,s1,1
 4e4:	fff4c903          	lbu	s2,-1(s1)
 4e8:	14090d63          	beqz	s2,642 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4ec:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4f0:	fe0997e3          	bnez	s3,4de <vprintf+0x5c>
      if(c == '%'){
 4f4:	fd479ee3          	bne	a5,s4,4d0 <vprintf+0x4e>
        state = '%';
 4f8:	89be                	mv	s3,a5
 4fa:	b7e5                	j	4e2 <vprintf+0x60>
      if(c == 'd'){
 4fc:	05878063          	beq	a5,s8,53c <vprintf+0xba>
      } else if(c == 'l') {
 500:	05978c63          	beq	a5,s9,558 <vprintf+0xd6>
      } else if(c == 'x') {
 504:	07a78863          	beq	a5,s10,574 <vprintf+0xf2>
      } else if(c == 'p') {
 508:	09b78463          	beq	a5,s11,590 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 50c:	07300713          	li	a4,115
 510:	0ce78663          	beq	a5,a4,5dc <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 514:	06300713          	li	a4,99
 518:	0ee78e63          	beq	a5,a4,614 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 51c:	11478863          	beq	a5,s4,62c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 520:	85d2                	mv	a1,s4
 522:	8556                	mv	a0,s5
 524:	00000097          	auipc	ra,0x0
 528:	e92080e7          	jalr	-366(ra) # 3b6 <putc>
        putc(fd, c);
 52c:	85ca                	mv	a1,s2
 52e:	8556                	mv	a0,s5
 530:	00000097          	auipc	ra,0x0
 534:	e86080e7          	jalr	-378(ra) # 3b6 <putc>
      }
      state = 0;
 538:	4981                	li	s3,0
 53a:	b765                	j	4e2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 53c:	008b0913          	addi	s2,s6,8
 540:	4685                	li	a3,1
 542:	4629                	li	a2,10
 544:	000b2583          	lw	a1,0(s6)
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	e8e080e7          	jalr	-370(ra) # 3d8 <printint>
 552:	8b4a                	mv	s6,s2
      state = 0;
 554:	4981                	li	s3,0
 556:	b771                	j	4e2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 558:	008b0913          	addi	s2,s6,8
 55c:	4681                	li	a3,0
 55e:	4629                	li	a2,10
 560:	000b2583          	lw	a1,0(s6)
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	e72080e7          	jalr	-398(ra) # 3d8 <printint>
 56e:	8b4a                	mv	s6,s2
      state = 0;
 570:	4981                	li	s3,0
 572:	bf85                	j	4e2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 574:	008b0913          	addi	s2,s6,8
 578:	4681                	li	a3,0
 57a:	4641                	li	a2,16
 57c:	000b2583          	lw	a1,0(s6)
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	e56080e7          	jalr	-426(ra) # 3d8 <printint>
 58a:	8b4a                	mv	s6,s2
      state = 0;
 58c:	4981                	li	s3,0
 58e:	bf91                	j	4e2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 590:	008b0793          	addi	a5,s6,8
 594:	f8f43423          	sd	a5,-120(s0)
 598:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 59c:	03000593          	li	a1,48
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e14080e7          	jalr	-492(ra) # 3b6 <putc>
  putc(fd, 'x');
 5aa:	85ea                	mv	a1,s10
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	e08080e7          	jalr	-504(ra) # 3b6 <putc>
 5b6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5b8:	03c9d793          	srli	a5,s3,0x3c
 5bc:	97de                	add	a5,a5,s7
 5be:	0007c583          	lbu	a1,0(a5)
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	df2080e7          	jalr	-526(ra) # 3b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5cc:	0992                	slli	s3,s3,0x4
 5ce:	397d                	addiw	s2,s2,-1
 5d0:	fe0914e3          	bnez	s2,5b8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5d4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	b721                	j	4e2 <vprintf+0x60>
        s = va_arg(ap, char*);
 5dc:	008b0993          	addi	s3,s6,8
 5e0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5e4:	02090163          	beqz	s2,606 <vprintf+0x184>
        while(*s != 0){
 5e8:	00094583          	lbu	a1,0(s2)
 5ec:	c9a1                	beqz	a1,63c <vprintf+0x1ba>
          putc(fd, *s);
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	dc6080e7          	jalr	-570(ra) # 3b6 <putc>
          s++;
 5f8:	0905                	addi	s2,s2,1
        while(*s != 0){
 5fa:	00094583          	lbu	a1,0(s2)
 5fe:	f9e5                	bnez	a1,5ee <vprintf+0x16c>
        s = va_arg(ap, char*);
 600:	8b4e                	mv	s6,s3
      state = 0;
 602:	4981                	li	s3,0
 604:	bdf9                	j	4e2 <vprintf+0x60>
          s = "(null)";
 606:	00000917          	auipc	s2,0x0
 60a:	27290913          	addi	s2,s2,626 # 878 <malloc+0x12c>
        while(*s != 0){
 60e:	02800593          	li	a1,40
 612:	bff1                	j	5ee <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 614:	008b0913          	addi	s2,s6,8
 618:	000b4583          	lbu	a1,0(s6)
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	d98080e7          	jalr	-616(ra) # 3b6 <putc>
 626:	8b4a                	mv	s6,s2
      state = 0;
 628:	4981                	li	s3,0
 62a:	bd65                	j	4e2 <vprintf+0x60>
        putc(fd, c);
 62c:	85d2                	mv	a1,s4
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	d86080e7          	jalr	-634(ra) # 3b6 <putc>
      state = 0;
 638:	4981                	li	s3,0
 63a:	b565                	j	4e2 <vprintf+0x60>
        s = va_arg(ap, char*);
 63c:	8b4e                	mv	s6,s3
      state = 0;
 63e:	4981                	li	s3,0
 640:	b54d                	j	4e2 <vprintf+0x60>
    }
  }
}
 642:	70e6                	ld	ra,120(sp)
 644:	7446                	ld	s0,112(sp)
 646:	74a6                	ld	s1,104(sp)
 648:	7906                	ld	s2,96(sp)
 64a:	69e6                	ld	s3,88(sp)
 64c:	6a46                	ld	s4,80(sp)
 64e:	6aa6                	ld	s5,72(sp)
 650:	6b06                	ld	s6,64(sp)
 652:	7be2                	ld	s7,56(sp)
 654:	7c42                	ld	s8,48(sp)
 656:	7ca2                	ld	s9,40(sp)
 658:	7d02                	ld	s10,32(sp)
 65a:	6de2                	ld	s11,24(sp)
 65c:	6109                	addi	sp,sp,128
 65e:	8082                	ret

0000000000000660 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 660:	715d                	addi	sp,sp,-80
 662:	ec06                	sd	ra,24(sp)
 664:	e822                	sd	s0,16(sp)
 666:	1000                	addi	s0,sp,32
 668:	e010                	sd	a2,0(s0)
 66a:	e414                	sd	a3,8(s0)
 66c:	e818                	sd	a4,16(s0)
 66e:	ec1c                	sd	a5,24(s0)
 670:	03043023          	sd	a6,32(s0)
 674:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 678:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 67c:	8622                	mv	a2,s0
 67e:	00000097          	auipc	ra,0x0
 682:	e04080e7          	jalr	-508(ra) # 482 <vprintf>
}
 686:	60e2                	ld	ra,24(sp)
 688:	6442                	ld	s0,16(sp)
 68a:	6161                	addi	sp,sp,80
 68c:	8082                	ret

000000000000068e <printf>:

void
printf(const char *fmt, ...)
{
 68e:	711d                	addi	sp,sp,-96
 690:	ec06                	sd	ra,24(sp)
 692:	e822                	sd	s0,16(sp)
 694:	1000                	addi	s0,sp,32
 696:	e40c                	sd	a1,8(s0)
 698:	e810                	sd	a2,16(s0)
 69a:	ec14                	sd	a3,24(s0)
 69c:	f018                	sd	a4,32(s0)
 69e:	f41c                	sd	a5,40(s0)
 6a0:	03043823          	sd	a6,48(s0)
 6a4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6a8:	00840613          	addi	a2,s0,8
 6ac:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6b0:	85aa                	mv	a1,a0
 6b2:	4505                	li	a0,1
 6b4:	00000097          	auipc	ra,0x0
 6b8:	dce080e7          	jalr	-562(ra) # 482 <vprintf>
}
 6bc:	60e2                	ld	ra,24(sp)
 6be:	6442                	ld	s0,16(sp)
 6c0:	6125                	addi	sp,sp,96
 6c2:	8082                	ret

00000000000006c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c4:	1141                	addi	sp,sp,-16
 6c6:	e422                	sd	s0,8(sp)
 6c8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ca:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ce:	00000797          	auipc	a5,0x0
 6d2:	1ca7b783          	ld	a5,458(a5) # 898 <freep>
 6d6:	a805                	j	706 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6d8:	4618                	lw	a4,8(a2)
 6da:	9db9                	addw	a1,a1,a4
 6dc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e0:	6398                	ld	a4,0(a5)
 6e2:	6318                	ld	a4,0(a4)
 6e4:	fee53823          	sd	a4,-16(a0)
 6e8:	a091                	j	72c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6ea:	ff852703          	lw	a4,-8(a0)
 6ee:	9e39                	addw	a2,a2,a4
 6f0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6f2:	ff053703          	ld	a4,-16(a0)
 6f6:	e398                	sd	a4,0(a5)
 6f8:	a099                	j	73e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fa:	6398                	ld	a4,0(a5)
 6fc:	00e7e463          	bltu	a5,a4,704 <free+0x40>
 700:	00e6ea63          	bltu	a3,a4,714 <free+0x50>
{
 704:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 706:	fed7fae3          	bgeu	a5,a3,6fa <free+0x36>
 70a:	6398                	ld	a4,0(a5)
 70c:	00e6e463          	bltu	a3,a4,714 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 710:	fee7eae3          	bltu	a5,a4,704 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 714:	ff852583          	lw	a1,-8(a0)
 718:	6390                	ld	a2,0(a5)
 71a:	02059813          	slli	a6,a1,0x20
 71e:	01c85713          	srli	a4,a6,0x1c
 722:	9736                	add	a4,a4,a3
 724:	fae60ae3          	beq	a2,a4,6d8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 728:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 72c:	4790                	lw	a2,8(a5)
 72e:	02061593          	slli	a1,a2,0x20
 732:	01c5d713          	srli	a4,a1,0x1c
 736:	973e                	add	a4,a4,a5
 738:	fae689e3          	beq	a3,a4,6ea <free+0x26>
  } else
    p->s.ptr = bp;
 73c:	e394                	sd	a3,0(a5)
  freep = p;
 73e:	00000717          	auipc	a4,0x0
 742:	14f73d23          	sd	a5,346(a4) # 898 <freep>
}
 746:	6422                	ld	s0,8(sp)
 748:	0141                	addi	sp,sp,16
 74a:	8082                	ret

000000000000074c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 74c:	7139                	addi	sp,sp,-64
 74e:	fc06                	sd	ra,56(sp)
 750:	f822                	sd	s0,48(sp)
 752:	f426                	sd	s1,40(sp)
 754:	f04a                	sd	s2,32(sp)
 756:	ec4e                	sd	s3,24(sp)
 758:	e852                	sd	s4,16(sp)
 75a:	e456                	sd	s5,8(sp)
 75c:	e05a                	sd	s6,0(sp)
 75e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 760:	02051493          	slli	s1,a0,0x20
 764:	9081                	srli	s1,s1,0x20
 766:	04bd                	addi	s1,s1,15
 768:	8091                	srli	s1,s1,0x4
 76a:	0014899b          	addiw	s3,s1,1
 76e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 770:	00000517          	auipc	a0,0x0
 774:	12853503          	ld	a0,296(a0) # 898 <freep>
 778:	c515                	beqz	a0,7a4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 77c:	4798                	lw	a4,8(a5)
 77e:	02977f63          	bgeu	a4,s1,7bc <malloc+0x70>
 782:	8a4e                	mv	s4,s3
 784:	0009871b          	sext.w	a4,s3
 788:	6685                	lui	a3,0x1
 78a:	00d77363          	bgeu	a4,a3,790 <malloc+0x44>
 78e:	6a05                	lui	s4,0x1
 790:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 794:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 798:	00000917          	auipc	s2,0x0
 79c:	10090913          	addi	s2,s2,256 # 898 <freep>
  if(p == (char*)-1)
 7a0:	5afd                	li	s5,-1
 7a2:	a895                	j	816 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7a4:	00000797          	auipc	a5,0x0
 7a8:	0fc78793          	addi	a5,a5,252 # 8a0 <base>
 7ac:	00000717          	auipc	a4,0x0
 7b0:	0ef73623          	sd	a5,236(a4) # 898 <freep>
 7b4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7b6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ba:	b7e1                	j	782 <malloc+0x36>
      if(p->s.size == nunits)
 7bc:	02e48c63          	beq	s1,a4,7f4 <malloc+0xa8>
        p->s.size -= nunits;
 7c0:	4137073b          	subw	a4,a4,s3
 7c4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7c6:	02071693          	slli	a3,a4,0x20
 7ca:	01c6d713          	srli	a4,a3,0x1c
 7ce:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7d0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7d4:	00000717          	auipc	a4,0x0
 7d8:	0ca73223          	sd	a0,196(a4) # 898 <freep>
      return (void*)(p + 1);
 7dc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7e0:	70e2                	ld	ra,56(sp)
 7e2:	7442                	ld	s0,48(sp)
 7e4:	74a2                	ld	s1,40(sp)
 7e6:	7902                	ld	s2,32(sp)
 7e8:	69e2                	ld	s3,24(sp)
 7ea:	6a42                	ld	s4,16(sp)
 7ec:	6aa2                	ld	s5,8(sp)
 7ee:	6b02                	ld	s6,0(sp)
 7f0:	6121                	addi	sp,sp,64
 7f2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7f4:	6398                	ld	a4,0(a5)
 7f6:	e118                	sd	a4,0(a0)
 7f8:	bff1                	j	7d4 <malloc+0x88>
  hp->s.size = nu;
 7fa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7fe:	0541                	addi	a0,a0,16
 800:	00000097          	auipc	ra,0x0
 804:	ec4080e7          	jalr	-316(ra) # 6c4 <free>
  return freep;
 808:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 80c:	d971                	beqz	a0,7e0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 810:	4798                	lw	a4,8(a5)
 812:	fa9775e3          	bgeu	a4,s1,7bc <malloc+0x70>
    if(p == freep)
 816:	00093703          	ld	a4,0(s2)
 81a:	853e                	mv	a0,a5
 81c:	fef719e3          	bne	a4,a5,80e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 820:	8552                	mv	a0,s4
 822:	00000097          	auipc	ra,0x0
 826:	b5c080e7          	jalr	-1188(ra) # 37e <sbrk>
  if(p == (char*)-1)
 82a:	fd5518e3          	bne	a0,s5,7fa <malloc+0xae>
        return 0;
 82e:	4501                	li	a0,0
 830:	bf45                	j	7e0 <malloc+0x94>
