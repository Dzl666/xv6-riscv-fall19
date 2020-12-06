
user/_alloctest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
#include "kernel/fcntl.h"
#include "kernel/memlayout.h"
#include "user/user.h"

void
test0() {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	0880                	addi	s0,sp,80
  enum { NCHILD = 50, NFD = 10};
  int i, j;
  int fd;

  printf("filetest: start\n");
  12:	00001517          	auipc	a0,0x1
  16:	97650513          	addi	a0,a0,-1674 # 988 <malloc+0xec>
  1a:	00000097          	auipc	ra,0x0
  1e:	7c4080e7          	jalr	1988(ra) # 7de <printf>
  22:	03200493          	li	s1,50
    printf("test setup is wrong\n");
    exit(1);
  }

  for (i = 0; i < NCHILD; i++) {
    int pid = fork();
  26:	00000097          	auipc	ra,0x0
  2a:	418080e7          	jalr	1048(ra) # 43e <fork>
    if(pid < 0){
  2e:	00054f63          	bltz	a0,4c <test0+0x4c>
      printf("fork failed");
      exit(1);
    }
    if(pid == 0){
  32:	c915                	beqz	a0,66 <test0+0x66>
  for (i = 0; i < NCHILD; i++) {
  34:	34fd                	addiw	s1,s1,-1
  36:	f8e5                	bnez	s1,26 <test0+0x26>
  38:	03200493          	li	s1,50
      sleep(10);
      exit(0);  // no errors; exit with 0.
    }
  }

  int all_ok = 1;
  3c:	4905                	li	s2,1
  for(int i = 0; i < NCHILD; i++){
    int xstatus;
    wait(&xstatus);
    if(xstatus != 0) {
      if(all_ok == 1)
  3e:	4985                	li	s3,1
        printf("filetest: FAILED\n");
  40:	00001a97          	auipc	s5,0x1
  44:	978a8a93          	addi	s5,s5,-1672 # 9b8 <malloc+0x11c>
      all_ok = 0;
  48:	4a01                	li	s4,0
  4a:	a8b1                	j	a6 <test0+0xa6>
      printf("fork failed");
  4c:	00001517          	auipc	a0,0x1
  50:	95450513          	addi	a0,a0,-1708 # 9a0 <malloc+0x104>
  54:	00000097          	auipc	ra,0x0
  58:	78a080e7          	jalr	1930(ra) # 7de <printf>
      exit(1);
  5c:	4505                	li	a0,1
  5e:	00000097          	auipc	ra,0x0
  62:	3e8080e7          	jalr	1000(ra) # 446 <exit>
  66:	44a9                	li	s1,10
        if ((fd = open("README", O_RDONLY)) < 0) {
  68:	00001917          	auipc	s2,0x1
  6c:	94890913          	addi	s2,s2,-1720 # 9b0 <malloc+0x114>
  70:	4581                	li	a1,0
  72:	854a                	mv	a0,s2
  74:	00000097          	auipc	ra,0x0
  78:	412080e7          	jalr	1042(ra) # 486 <open>
  7c:	00054e63          	bltz	a0,98 <test0+0x98>
      for(j = 0; j < NFD; j++) {
  80:	34fd                	addiw	s1,s1,-1
  82:	f4fd                	bnez	s1,70 <test0+0x70>
      sleep(10);
  84:	4529                	li	a0,10
  86:	00000097          	auipc	ra,0x0
  8a:	450080e7          	jalr	1104(ra) # 4d6 <sleep>
      exit(0);  // no errors; exit with 0.
  8e:	4501                	li	a0,0
  90:	00000097          	auipc	ra,0x0
  94:	3b6080e7          	jalr	950(ra) # 446 <exit>
          exit(1);
  98:	4505                	li	a0,1
  9a:	00000097          	auipc	ra,0x0
  9e:	3ac080e7          	jalr	940(ra) # 446 <exit>
  for(int i = 0; i < NCHILD; i++){
  a2:	34fd                	addiw	s1,s1,-1
  a4:	c09d                	beqz	s1,ca <test0+0xca>
    wait(&xstatus);
  a6:	fbc40513          	addi	a0,s0,-68
  aa:	00000097          	auipc	ra,0x0
  ae:	3a4080e7          	jalr	932(ra) # 44e <wait>
    if(xstatus != 0) {
  b2:	fbc42783          	lw	a5,-68(s0)
  b6:	d7f5                	beqz	a5,a2 <test0+0xa2>
      if(all_ok == 1)
  b8:	ff3915e3          	bne	s2,s3,a2 <test0+0xa2>
        printf("filetest: FAILED\n");
  bc:	8556                	mv	a0,s5
  be:	00000097          	auipc	ra,0x0
  c2:	720080e7          	jalr	1824(ra) # 7de <printf>
      all_ok = 0;
  c6:	8952                	mv	s2,s4
  c8:	bfe9                	j	a2 <test0+0xa2>
    }
  }

  if(all_ok)
  ca:	00091b63          	bnez	s2,e0 <test0+0xe0>
    printf("filetest: OK\n");
}
  ce:	60a6                	ld	ra,72(sp)
  d0:	6406                	ld	s0,64(sp)
  d2:	74e2                	ld	s1,56(sp)
  d4:	7942                	ld	s2,48(sp)
  d6:	79a2                	ld	s3,40(sp)
  d8:	7a02                	ld	s4,32(sp)
  da:	6ae2                	ld	s5,24(sp)
  dc:	6161                	addi	sp,sp,80
  de:	8082                	ret
    printf("filetest: OK\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	8f050513          	addi	a0,a0,-1808 # 9d0 <malloc+0x134>
  e8:	00000097          	auipc	ra,0x0
  ec:	6f6080e7          	jalr	1782(ra) # 7de <printf>
}
  f0:	bff9                	j	ce <test0+0xce>

00000000000000f2 <test1>:

// Allocate all free memory and count how it is
void test1()
{
  f2:	7139                	addi	sp,sp,-64
  f4:	fc06                	sd	ra,56(sp)
  f6:	f822                	sd	s0,48(sp)
  f8:	f426                	sd	s1,40(sp)
  fa:	f04a                	sd	s2,32(sp)
  fc:	ec4e                	sd	s3,24(sp)
  fe:	0080                	addi	s0,sp,64
  void *a;
  int tot = 0;
  char buf[1];
  int fds[2];
  
  printf("memtest: start\n");  
 100:	00001517          	auipc	a0,0x1
 104:	8e050513          	addi	a0,a0,-1824 # 9e0 <malloc+0x144>
 108:	00000097          	auipc	ra,0x0
 10c:	6d6080e7          	jalr	1750(ra) # 7de <printf>
  if(pipe(fds) != 0){
 110:	fc040513          	addi	a0,s0,-64
 114:	00000097          	auipc	ra,0x0
 118:	342080e7          	jalr	834(ra) # 456 <pipe>
 11c:	e525                	bnez	a0,184 <test1+0x92>
 11e:	84aa                	mv	s1,a0
    printf("pipe() failed\n");
    exit(1);
  }
  int pid = fork();
 120:	00000097          	auipc	ra,0x0
 124:	31e080e7          	jalr	798(ra) # 43e <fork>
  if(pid < 0){
 128:	06054b63          	bltz	a0,19e <test1+0xac>
    printf("fork failed");
    exit(1);
  }
  if(pid == 0){
 12c:	e959                	bnez	a0,1c2 <test1+0xd0>
      close(fds[0]);
 12e:	fc042503          	lw	a0,-64(s0)
 132:	00000097          	auipc	ra,0x0
 136:	33c080e7          	jalr	828(ra) # 46e <close>
      while(1) {
        a = sbrk(PGSIZE);
        if (a == (char*)0xffffffffffffffffL)
 13a:	597d                	li	s2,-1
          exit(0);
        *(int *)(a+4) = 1;
 13c:	4485                	li	s1,1
        if (write(fds[1], "x", 1) != 1) {
 13e:	00001997          	auipc	s3,0x1
 142:	8c298993          	addi	s3,s3,-1854 # a00 <malloc+0x164>
        a = sbrk(PGSIZE);
 146:	6505                	lui	a0,0x1
 148:	00000097          	auipc	ra,0x0
 14c:	386080e7          	jalr	902(ra) # 4ce <sbrk>
        if (a == (char*)0xffffffffffffffffL)
 150:	07250463          	beq	a0,s2,1b8 <test1+0xc6>
        *(int *)(a+4) = 1;
 154:	c144                	sw	s1,4(a0)
        if (write(fds[1], "x", 1) != 1) {
 156:	8626                	mv	a2,s1
 158:	85ce                	mv	a1,s3
 15a:	fc442503          	lw	a0,-60(s0)
 15e:	00000097          	auipc	ra,0x0
 162:	308080e7          	jalr	776(ra) # 466 <write>
 166:	fe9500e3          	beq	a0,s1,146 <test1+0x54>
          printf("write failed");
 16a:	00001517          	auipc	a0,0x1
 16e:	89e50513          	addi	a0,a0,-1890 # a08 <malloc+0x16c>
 172:	00000097          	auipc	ra,0x0
 176:	66c080e7          	jalr	1644(ra) # 7de <printf>
          exit(1);
 17a:	4505                	li	a0,1
 17c:	00000097          	auipc	ra,0x0
 180:	2ca080e7          	jalr	714(ra) # 446 <exit>
    printf("pipe() failed\n");
 184:	00001517          	auipc	a0,0x1
 188:	86c50513          	addi	a0,a0,-1940 # 9f0 <malloc+0x154>
 18c:	00000097          	auipc	ra,0x0
 190:	652080e7          	jalr	1618(ra) # 7de <printf>
    exit(1);
 194:	4505                	li	a0,1
 196:	00000097          	auipc	ra,0x0
 19a:	2b0080e7          	jalr	688(ra) # 446 <exit>
    printf("fork failed");
 19e:	00001517          	auipc	a0,0x1
 1a2:	80250513          	addi	a0,a0,-2046 # 9a0 <malloc+0x104>
 1a6:	00000097          	auipc	ra,0x0
 1aa:	638080e7          	jalr	1592(ra) # 7de <printf>
    exit(1);
 1ae:	4505                	li	a0,1
 1b0:	00000097          	auipc	ra,0x0
 1b4:	296080e7          	jalr	662(ra) # 446 <exit>
          exit(0);
 1b8:	4501                	li	a0,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	28c080e7          	jalr	652(ra) # 446 <exit>
        }
      }
      exit(0);
  }
  close(fds[1]);
 1c2:	fc442503          	lw	a0,-60(s0)
 1c6:	00000097          	auipc	ra,0x0
 1ca:	2a8080e7          	jalr	680(ra) # 46e <close>
  while(1) {
      if (read(fds[0], buf, 1) != 1) {
 1ce:	4605                	li	a2,1
 1d0:	fc840593          	addi	a1,s0,-56
 1d4:	fc042503          	lw	a0,-64(s0)
 1d8:	00000097          	auipc	ra,0x0
 1dc:	286080e7          	jalr	646(ra) # 45e <read>
 1e0:	4785                	li	a5,1
 1e2:	00f51463          	bne	a0,a5,1ea <test1+0xf8>
        break;
      } else {
        tot += 1;
 1e6:	2485                	addiw	s1,s1,1
      if (read(fds[0], buf, 1) != 1) {
 1e8:	b7dd                	j	1ce <test1+0xdc>
      }
  }
  //int n = (PHYSTOP-KERNBASE)/PGSIZE;
  //printf("allocated %d out of %d pages\n", tot, n);
  if(tot < 31950) {
 1ea:	67a1                	lui	a5,0x8
 1ec:	ccd78793          	addi	a5,a5,-819 # 7ccd <__global_pointer$+0x6a3c>
 1f0:	0297ca63          	blt	a5,s1,224 <test1+0x132>
    printf("expected to allocate at least 31950, only got %d\n", tot);
 1f4:	85a6                	mv	a1,s1
 1f6:	00001517          	auipc	a0,0x1
 1fa:	82250513          	addi	a0,a0,-2014 # a18 <malloc+0x17c>
 1fe:	00000097          	auipc	ra,0x0
 202:	5e0080e7          	jalr	1504(ra) # 7de <printf>
    printf("memtest: FAILED\n");  
 206:	00001517          	auipc	a0,0x1
 20a:	84a50513          	addi	a0,a0,-1974 # a50 <malloc+0x1b4>
 20e:	00000097          	auipc	ra,0x0
 212:	5d0080e7          	jalr	1488(ra) # 7de <printf>
  } else {
    printf("memtest: OK\n");  
  }
}
 216:	70e2                	ld	ra,56(sp)
 218:	7442                	ld	s0,48(sp)
 21a:	74a2                	ld	s1,40(sp)
 21c:	7902                	ld	s2,32(sp)
 21e:	69e2                	ld	s3,24(sp)
 220:	6121                	addi	sp,sp,64
 222:	8082                	ret
    printf("memtest: OK\n");  
 224:	00001517          	auipc	a0,0x1
 228:	84450513          	addi	a0,a0,-1980 # a68 <malloc+0x1cc>
 22c:	00000097          	auipc	ra,0x0
 230:	5b2080e7          	jalr	1458(ra) # 7de <printf>
}
 234:	b7cd                	j	216 <test1+0x124>

0000000000000236 <main>:

int
main(int argc, char *argv[])
{
 236:	1141                	addi	sp,sp,-16
 238:	e406                	sd	ra,8(sp)
 23a:	e022                	sd	s0,0(sp)
 23c:	0800                	addi	s0,sp,16
  test0();
 23e:	00000097          	auipc	ra,0x0
 242:	dc2080e7          	jalr	-574(ra) # 0 <test0>
  test1();
 246:	00000097          	auipc	ra,0x0
 24a:	eac080e7          	jalr	-340(ra) # f2 <test1>
  exit(0);
 24e:	4501                	li	a0,0
 250:	00000097          	auipc	ra,0x0
 254:	1f6080e7          	jalr	502(ra) # 446 <exit>

0000000000000258 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e422                	sd	s0,8(sp)
 25c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 25e:	87aa                	mv	a5,a0
 260:	0585                	addi	a1,a1,1
 262:	0785                	addi	a5,a5,1
 264:	fff5c703          	lbu	a4,-1(a1)
 268:	fee78fa3          	sb	a4,-1(a5)
 26c:	fb75                	bnez	a4,260 <strcpy+0x8>
    ;
  return os;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret

0000000000000274 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 27a:	00054783          	lbu	a5,0(a0)
 27e:	cb91                	beqz	a5,292 <strcmp+0x1e>
 280:	0005c703          	lbu	a4,0(a1)
 284:	00f71763          	bne	a4,a5,292 <strcmp+0x1e>
    p++, q++;
 288:	0505                	addi	a0,a0,1
 28a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 28c:	00054783          	lbu	a5,0(a0)
 290:	fbe5                	bnez	a5,280 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 292:	0005c503          	lbu	a0,0(a1)
}
 296:	40a7853b          	subw	a0,a5,a0
 29a:	6422                	ld	s0,8(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret

00000000000002a0 <strlen>:

uint
strlen(const char *s)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e422                	sd	s0,8(sp)
 2a4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2a6:	00054783          	lbu	a5,0(a0)
 2aa:	cf91                	beqz	a5,2c6 <strlen+0x26>
 2ac:	0505                	addi	a0,a0,1
 2ae:	87aa                	mv	a5,a0
 2b0:	4685                	li	a3,1
 2b2:	9e89                	subw	a3,a3,a0
 2b4:	00f6853b          	addw	a0,a3,a5
 2b8:	0785                	addi	a5,a5,1
 2ba:	fff7c703          	lbu	a4,-1(a5)
 2be:	fb7d                	bnez	a4,2b4 <strlen+0x14>
    ;
  return n;
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret
  for(n = 0; s[n]; n++)
 2c6:	4501                	li	a0,0
 2c8:	bfe5                	j	2c0 <strlen+0x20>

00000000000002ca <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e422                	sd	s0,8(sp)
 2ce:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2d0:	ca19                	beqz	a2,2e6 <memset+0x1c>
 2d2:	87aa                	mv	a5,a0
 2d4:	1602                	slli	a2,a2,0x20
 2d6:	9201                	srli	a2,a2,0x20
 2d8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2dc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2e0:	0785                	addi	a5,a5,1
 2e2:	fee79de3          	bne	a5,a4,2dc <memset+0x12>
  }
  return dst;
}
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <strchr>:

char*
strchr(const char *s, char c)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2f2:	00054783          	lbu	a5,0(a0)
 2f6:	cb99                	beqz	a5,30c <strchr+0x20>
    if(*s == c)
 2f8:	00f58763          	beq	a1,a5,306 <strchr+0x1a>
  for(; *s; s++)
 2fc:	0505                	addi	a0,a0,1
 2fe:	00054783          	lbu	a5,0(a0)
 302:	fbfd                	bnez	a5,2f8 <strchr+0xc>
      return (char*)s;
  return 0;
 304:	4501                	li	a0,0
}
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
  return 0;
 30c:	4501                	li	a0,0
 30e:	bfe5                	j	306 <strchr+0x1a>

0000000000000310 <gets>:

char*
gets(char *buf, int max)
{
 310:	711d                	addi	sp,sp,-96
 312:	ec86                	sd	ra,88(sp)
 314:	e8a2                	sd	s0,80(sp)
 316:	e4a6                	sd	s1,72(sp)
 318:	e0ca                	sd	s2,64(sp)
 31a:	fc4e                	sd	s3,56(sp)
 31c:	f852                	sd	s4,48(sp)
 31e:	f456                	sd	s5,40(sp)
 320:	f05a                	sd	s6,32(sp)
 322:	ec5e                	sd	s7,24(sp)
 324:	1080                	addi	s0,sp,96
 326:	8baa                	mv	s7,a0
 328:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32a:	892a                	mv	s2,a0
 32c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 32e:	4aa9                	li	s5,10
 330:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 332:	89a6                	mv	s3,s1
 334:	2485                	addiw	s1,s1,1
 336:	0344d863          	bge	s1,s4,366 <gets+0x56>
    cc = read(0, &c, 1);
 33a:	4605                	li	a2,1
 33c:	faf40593          	addi	a1,s0,-81
 340:	4501                	li	a0,0
 342:	00000097          	auipc	ra,0x0
 346:	11c080e7          	jalr	284(ra) # 45e <read>
    if(cc < 1)
 34a:	00a05e63          	blez	a0,366 <gets+0x56>
    buf[i++] = c;
 34e:	faf44783          	lbu	a5,-81(s0)
 352:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 356:	01578763          	beq	a5,s5,364 <gets+0x54>
 35a:	0905                	addi	s2,s2,1
 35c:	fd679be3          	bne	a5,s6,332 <gets+0x22>
  for(i=0; i+1 < max; ){
 360:	89a6                	mv	s3,s1
 362:	a011                	j	366 <gets+0x56>
 364:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 366:	99de                	add	s3,s3,s7
 368:	00098023          	sb	zero,0(s3)
  return buf;
}
 36c:	855e                	mv	a0,s7
 36e:	60e6                	ld	ra,88(sp)
 370:	6446                	ld	s0,80(sp)
 372:	64a6                	ld	s1,72(sp)
 374:	6906                	ld	s2,64(sp)
 376:	79e2                	ld	s3,56(sp)
 378:	7a42                	ld	s4,48(sp)
 37a:	7aa2                	ld	s5,40(sp)
 37c:	7b02                	ld	s6,32(sp)
 37e:	6be2                	ld	s7,24(sp)
 380:	6125                	addi	sp,sp,96
 382:	8082                	ret

0000000000000384 <stat>:

int
stat(const char *n, struct stat *st)
{
 384:	1101                	addi	sp,sp,-32
 386:	ec06                	sd	ra,24(sp)
 388:	e822                	sd	s0,16(sp)
 38a:	e426                	sd	s1,8(sp)
 38c:	e04a                	sd	s2,0(sp)
 38e:	1000                	addi	s0,sp,32
 390:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 392:	4581                	li	a1,0
 394:	00000097          	auipc	ra,0x0
 398:	0f2080e7          	jalr	242(ra) # 486 <open>
  if(fd < 0)
 39c:	02054563          	bltz	a0,3c6 <stat+0x42>
 3a0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3a2:	85ca                	mv	a1,s2
 3a4:	00000097          	auipc	ra,0x0
 3a8:	0fa080e7          	jalr	250(ra) # 49e <fstat>
 3ac:	892a                	mv	s2,a0
  close(fd);
 3ae:	8526                	mv	a0,s1
 3b0:	00000097          	auipc	ra,0x0
 3b4:	0be080e7          	jalr	190(ra) # 46e <close>
  return r;
}
 3b8:	854a                	mv	a0,s2
 3ba:	60e2                	ld	ra,24(sp)
 3bc:	6442                	ld	s0,16(sp)
 3be:	64a2                	ld	s1,8(sp)
 3c0:	6902                	ld	s2,0(sp)
 3c2:	6105                	addi	sp,sp,32
 3c4:	8082                	ret
    return -1;
 3c6:	597d                	li	s2,-1
 3c8:	bfc5                	j	3b8 <stat+0x34>

00000000000003ca <atoi>:

int
atoi(const char *s)
{
 3ca:	1141                	addi	sp,sp,-16
 3cc:	e422                	sd	s0,8(sp)
 3ce:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3d0:	00054603          	lbu	a2,0(a0)
 3d4:	fd06079b          	addiw	a5,a2,-48
 3d8:	0ff7f793          	andi	a5,a5,255
 3dc:	4725                	li	a4,9
 3de:	02f76963          	bltu	a4,a5,410 <atoi+0x46>
 3e2:	86aa                	mv	a3,a0
  n = 0;
 3e4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3e6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3e8:	0685                	addi	a3,a3,1
 3ea:	0025179b          	slliw	a5,a0,0x2
 3ee:	9fa9                	addw	a5,a5,a0
 3f0:	0017979b          	slliw	a5,a5,0x1
 3f4:	9fb1                	addw	a5,a5,a2
 3f6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3fa:	0006c603          	lbu	a2,0(a3)
 3fe:	fd06071b          	addiw	a4,a2,-48
 402:	0ff77713          	andi	a4,a4,255
 406:	fee5f1e3          	bgeu	a1,a4,3e8 <atoi+0x1e>
  return n;
}
 40a:	6422                	ld	s0,8(sp)
 40c:	0141                	addi	sp,sp,16
 40e:	8082                	ret
  n = 0;
 410:	4501                	li	a0,0
 412:	bfe5                	j	40a <atoi+0x40>

0000000000000414 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 414:	1141                	addi	sp,sp,-16
 416:	e422                	sd	s0,8(sp)
 418:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 41a:	00c05f63          	blez	a2,438 <memmove+0x24>
 41e:	1602                	slli	a2,a2,0x20
 420:	9201                	srli	a2,a2,0x20
 422:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 426:	87aa                	mv	a5,a0
    *dst++ = *src++;
 428:	0585                	addi	a1,a1,1
 42a:	0785                	addi	a5,a5,1
 42c:	fff5c703          	lbu	a4,-1(a1)
 430:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 434:	fed79ae3          	bne	a5,a3,428 <memmove+0x14>
  return vdst;
}
 438:	6422                	ld	s0,8(sp)
 43a:	0141                	addi	sp,sp,16
 43c:	8082                	ret

000000000000043e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 43e:	4885                	li	a7,1
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <exit>:
.global exit
exit:
 li a7, SYS_exit
 446:	4889                	li	a7,2
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <wait>:
.global wait
wait:
 li a7, SYS_wait
 44e:	488d                	li	a7,3
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 456:	4891                	li	a7,4
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <read>:
.global read
read:
 li a7, SYS_read
 45e:	4895                	li	a7,5
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <write>:
.global write
write:
 li a7, SYS_write
 466:	48c1                	li	a7,16
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <close>:
.global close
close:
 li a7, SYS_close
 46e:	48d5                	li	a7,21
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <kill>:
.global kill
kill:
 li a7, SYS_kill
 476:	4899                	li	a7,6
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <exec>:
.global exec
exec:
 li a7, SYS_exec
 47e:	489d                	li	a7,7
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <open>:
.global open
open:
 li a7, SYS_open
 486:	48bd                	li	a7,15
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 48e:	48c5                	li	a7,17
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 496:	48c9                	li	a7,18
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 49e:	48a1                	li	a7,8
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <link>:
.global link
link:
 li a7, SYS_link
 4a6:	48cd                	li	a7,19
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ae:	48d1                	li	a7,20
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4b6:	48a5                	li	a7,9
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <dup>:
.global dup
dup:
 li a7, SYS_dup
 4be:	48a9                	li	a7,10
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4c6:	48ad                	li	a7,11
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4ce:	48b1                	li	a7,12
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4d6:	48b5                	li	a7,13
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4de:	48b9                	li	a7,14
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 4e6:	48d9                	li	a7,22
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <crash>:
.global crash
crash:
 li a7, SYS_crash
 4ee:	48dd                	li	a7,23
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <mount>:
.global mount
mount:
 li a7, SYS_mount
 4f6:	48e1                	li	a7,24
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <umount>:
.global umount
umount:
 li a7, SYS_umount
 4fe:	48e5                	li	a7,25
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 506:	1101                	addi	sp,sp,-32
 508:	ec06                	sd	ra,24(sp)
 50a:	e822                	sd	s0,16(sp)
 50c:	1000                	addi	s0,sp,32
 50e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 512:	4605                	li	a2,1
 514:	fef40593          	addi	a1,s0,-17
 518:	00000097          	auipc	ra,0x0
 51c:	f4e080e7          	jalr	-178(ra) # 466 <write>
}
 520:	60e2                	ld	ra,24(sp)
 522:	6442                	ld	s0,16(sp)
 524:	6105                	addi	sp,sp,32
 526:	8082                	ret

0000000000000528 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 528:	7139                	addi	sp,sp,-64
 52a:	fc06                	sd	ra,56(sp)
 52c:	f822                	sd	s0,48(sp)
 52e:	f426                	sd	s1,40(sp)
 530:	f04a                	sd	s2,32(sp)
 532:	ec4e                	sd	s3,24(sp)
 534:	0080                	addi	s0,sp,64
 536:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 538:	c299                	beqz	a3,53e <printint+0x16>
 53a:	0805c863          	bltz	a1,5ca <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 53e:	2581                	sext.w	a1,a1
  neg = 0;
 540:	4881                	li	a7,0
 542:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 546:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 548:	2601                	sext.w	a2,a2
 54a:	00000517          	auipc	a0,0x0
 54e:	53650513          	addi	a0,a0,1334 # a80 <digits>
 552:	883a                	mv	a6,a4
 554:	2705                	addiw	a4,a4,1
 556:	02c5f7bb          	remuw	a5,a1,a2
 55a:	1782                	slli	a5,a5,0x20
 55c:	9381                	srli	a5,a5,0x20
 55e:	97aa                	add	a5,a5,a0
 560:	0007c783          	lbu	a5,0(a5)
 564:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 568:	0005879b          	sext.w	a5,a1
 56c:	02c5d5bb          	divuw	a1,a1,a2
 570:	0685                	addi	a3,a3,1
 572:	fec7f0e3          	bgeu	a5,a2,552 <printint+0x2a>
  if(neg)
 576:	00088b63          	beqz	a7,58c <printint+0x64>
    buf[i++] = '-';
 57a:	fd040793          	addi	a5,s0,-48
 57e:	973e                	add	a4,a4,a5
 580:	02d00793          	li	a5,45
 584:	fef70823          	sb	a5,-16(a4)
 588:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 58c:	02e05863          	blez	a4,5bc <printint+0x94>
 590:	fc040793          	addi	a5,s0,-64
 594:	00e78933          	add	s2,a5,a4
 598:	fff78993          	addi	s3,a5,-1
 59c:	99ba                	add	s3,s3,a4
 59e:	377d                	addiw	a4,a4,-1
 5a0:	1702                	slli	a4,a4,0x20
 5a2:	9301                	srli	a4,a4,0x20
 5a4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5a8:	fff94583          	lbu	a1,-1(s2)
 5ac:	8526                	mv	a0,s1
 5ae:	00000097          	auipc	ra,0x0
 5b2:	f58080e7          	jalr	-168(ra) # 506 <putc>
  while(--i >= 0)
 5b6:	197d                	addi	s2,s2,-1
 5b8:	ff3918e3          	bne	s2,s3,5a8 <printint+0x80>
}
 5bc:	70e2                	ld	ra,56(sp)
 5be:	7442                	ld	s0,48(sp)
 5c0:	74a2                	ld	s1,40(sp)
 5c2:	7902                	ld	s2,32(sp)
 5c4:	69e2                	ld	s3,24(sp)
 5c6:	6121                	addi	sp,sp,64
 5c8:	8082                	ret
    x = -xx;
 5ca:	40b005bb          	negw	a1,a1
    neg = 1;
 5ce:	4885                	li	a7,1
    x = -xx;
 5d0:	bf8d                	j	542 <printint+0x1a>

00000000000005d2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5d2:	7119                	addi	sp,sp,-128
 5d4:	fc86                	sd	ra,120(sp)
 5d6:	f8a2                	sd	s0,112(sp)
 5d8:	f4a6                	sd	s1,104(sp)
 5da:	f0ca                	sd	s2,96(sp)
 5dc:	ecce                	sd	s3,88(sp)
 5de:	e8d2                	sd	s4,80(sp)
 5e0:	e4d6                	sd	s5,72(sp)
 5e2:	e0da                	sd	s6,64(sp)
 5e4:	fc5e                	sd	s7,56(sp)
 5e6:	f862                	sd	s8,48(sp)
 5e8:	f466                	sd	s9,40(sp)
 5ea:	f06a                	sd	s10,32(sp)
 5ec:	ec6e                	sd	s11,24(sp)
 5ee:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f0:	0005c903          	lbu	s2,0(a1)
 5f4:	18090f63          	beqz	s2,792 <vprintf+0x1c0>
 5f8:	8aaa                	mv	s5,a0
 5fa:	8b32                	mv	s6,a2
 5fc:	00158493          	addi	s1,a1,1
  state = 0;
 600:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 602:	02500a13          	li	s4,37
      if(c == 'd'){
 606:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 60a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 60e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 612:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 616:	00000b97          	auipc	s7,0x0
 61a:	46ab8b93          	addi	s7,s7,1130 # a80 <digits>
 61e:	a839                	j	63c <vprintf+0x6a>
        putc(fd, c);
 620:	85ca                	mv	a1,s2
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	ee2080e7          	jalr	-286(ra) # 506 <putc>
 62c:	a019                	j	632 <vprintf+0x60>
    } else if(state == '%'){
 62e:	01498f63          	beq	s3,s4,64c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 632:	0485                	addi	s1,s1,1
 634:	fff4c903          	lbu	s2,-1(s1)
 638:	14090d63          	beqz	s2,792 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 63c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 640:	fe0997e3          	bnez	s3,62e <vprintf+0x5c>
      if(c == '%'){
 644:	fd479ee3          	bne	a5,s4,620 <vprintf+0x4e>
        state = '%';
 648:	89be                	mv	s3,a5
 64a:	b7e5                	j	632 <vprintf+0x60>
      if(c == 'd'){
 64c:	05878063          	beq	a5,s8,68c <vprintf+0xba>
      } else if(c == 'l') {
 650:	05978c63          	beq	a5,s9,6a8 <vprintf+0xd6>
      } else if(c == 'x') {
 654:	07a78863          	beq	a5,s10,6c4 <vprintf+0xf2>
      } else if(c == 'p') {
 658:	09b78463          	beq	a5,s11,6e0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 65c:	07300713          	li	a4,115
 660:	0ce78663          	beq	a5,a4,72c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 664:	06300713          	li	a4,99
 668:	0ee78e63          	beq	a5,a4,764 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 66c:	11478863          	beq	a5,s4,77c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 670:	85d2                	mv	a1,s4
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	e92080e7          	jalr	-366(ra) # 506 <putc>
        putc(fd, c);
 67c:	85ca                	mv	a1,s2
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	e86080e7          	jalr	-378(ra) # 506 <putc>
      }
      state = 0;
 688:	4981                	li	s3,0
 68a:	b765                	j	632 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 68c:	008b0913          	addi	s2,s6,8
 690:	4685                	li	a3,1
 692:	4629                	li	a2,10
 694:	000b2583          	lw	a1,0(s6)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	e8e080e7          	jalr	-370(ra) # 528 <printint>
 6a2:	8b4a                	mv	s6,s2
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b771                	j	632 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a8:	008b0913          	addi	s2,s6,8
 6ac:	4681                	li	a3,0
 6ae:	4629                	li	a2,10
 6b0:	000b2583          	lw	a1,0(s6)
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	e72080e7          	jalr	-398(ra) # 528 <printint>
 6be:	8b4a                	mv	s6,s2
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	bf85                	j	632 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6c4:	008b0913          	addi	s2,s6,8
 6c8:	4681                	li	a3,0
 6ca:	4641                	li	a2,16
 6cc:	000b2583          	lw	a1,0(s6)
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	e56080e7          	jalr	-426(ra) # 528 <printint>
 6da:	8b4a                	mv	s6,s2
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	bf91                	j	632 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6e0:	008b0793          	addi	a5,s6,8
 6e4:	f8f43423          	sd	a5,-120(s0)
 6e8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6ec:	03000593          	li	a1,48
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	e14080e7          	jalr	-492(ra) # 506 <putc>
  putc(fd, 'x');
 6fa:	85ea                	mv	a1,s10
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	e08080e7          	jalr	-504(ra) # 506 <putc>
 706:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 708:	03c9d793          	srli	a5,s3,0x3c
 70c:	97de                	add	a5,a5,s7
 70e:	0007c583          	lbu	a1,0(a5)
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	df2080e7          	jalr	-526(ra) # 506 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71c:	0992                	slli	s3,s3,0x4
 71e:	397d                	addiw	s2,s2,-1
 720:	fe0914e3          	bnez	s2,708 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 724:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 728:	4981                	li	s3,0
 72a:	b721                	j	632 <vprintf+0x60>
        s = va_arg(ap, char*);
 72c:	008b0993          	addi	s3,s6,8
 730:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 734:	02090163          	beqz	s2,756 <vprintf+0x184>
        while(*s != 0){
 738:	00094583          	lbu	a1,0(s2)
 73c:	c9a1                	beqz	a1,78c <vprintf+0x1ba>
          putc(fd, *s);
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	dc6080e7          	jalr	-570(ra) # 506 <putc>
          s++;
 748:	0905                	addi	s2,s2,1
        while(*s != 0){
 74a:	00094583          	lbu	a1,0(s2)
 74e:	f9e5                	bnez	a1,73e <vprintf+0x16c>
        s = va_arg(ap, char*);
 750:	8b4e                	mv	s6,s3
      state = 0;
 752:	4981                	li	s3,0
 754:	bdf9                	j	632 <vprintf+0x60>
          s = "(null)";
 756:	00000917          	auipc	s2,0x0
 75a:	32290913          	addi	s2,s2,802 # a78 <malloc+0x1dc>
        while(*s != 0){
 75e:	02800593          	li	a1,40
 762:	bff1                	j	73e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 764:	008b0913          	addi	s2,s6,8
 768:	000b4583          	lbu	a1,0(s6)
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	d98080e7          	jalr	-616(ra) # 506 <putc>
 776:	8b4a                	mv	s6,s2
      state = 0;
 778:	4981                	li	s3,0
 77a:	bd65                	j	632 <vprintf+0x60>
        putc(fd, c);
 77c:	85d2                	mv	a1,s4
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	d86080e7          	jalr	-634(ra) # 506 <putc>
      state = 0;
 788:	4981                	li	s3,0
 78a:	b565                	j	632 <vprintf+0x60>
        s = va_arg(ap, char*);
 78c:	8b4e                	mv	s6,s3
      state = 0;
 78e:	4981                	li	s3,0
 790:	b54d                	j	632 <vprintf+0x60>
    }
  }
}
 792:	70e6                	ld	ra,120(sp)
 794:	7446                	ld	s0,112(sp)
 796:	74a6                	ld	s1,104(sp)
 798:	7906                	ld	s2,96(sp)
 79a:	69e6                	ld	s3,88(sp)
 79c:	6a46                	ld	s4,80(sp)
 79e:	6aa6                	ld	s5,72(sp)
 7a0:	6b06                	ld	s6,64(sp)
 7a2:	7be2                	ld	s7,56(sp)
 7a4:	7c42                	ld	s8,48(sp)
 7a6:	7ca2                	ld	s9,40(sp)
 7a8:	7d02                	ld	s10,32(sp)
 7aa:	6de2                	ld	s11,24(sp)
 7ac:	6109                	addi	sp,sp,128
 7ae:	8082                	ret

00000000000007b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b0:	715d                	addi	sp,sp,-80
 7b2:	ec06                	sd	ra,24(sp)
 7b4:	e822                	sd	s0,16(sp)
 7b6:	1000                	addi	s0,sp,32
 7b8:	e010                	sd	a2,0(s0)
 7ba:	e414                	sd	a3,8(s0)
 7bc:	e818                	sd	a4,16(s0)
 7be:	ec1c                	sd	a5,24(s0)
 7c0:	03043023          	sd	a6,32(s0)
 7c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7cc:	8622                	mv	a2,s0
 7ce:	00000097          	auipc	ra,0x0
 7d2:	e04080e7          	jalr	-508(ra) # 5d2 <vprintf>
}
 7d6:	60e2                	ld	ra,24(sp)
 7d8:	6442                	ld	s0,16(sp)
 7da:	6161                	addi	sp,sp,80
 7dc:	8082                	ret

00000000000007de <printf>:

void
printf(const char *fmt, ...)
{
 7de:	711d                	addi	sp,sp,-96
 7e0:	ec06                	sd	ra,24(sp)
 7e2:	e822                	sd	s0,16(sp)
 7e4:	1000                	addi	s0,sp,32
 7e6:	e40c                	sd	a1,8(s0)
 7e8:	e810                	sd	a2,16(s0)
 7ea:	ec14                	sd	a3,24(s0)
 7ec:	f018                	sd	a4,32(s0)
 7ee:	f41c                	sd	a5,40(s0)
 7f0:	03043823          	sd	a6,48(s0)
 7f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f8:	00840613          	addi	a2,s0,8
 7fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 800:	85aa                	mv	a1,a0
 802:	4505                	li	a0,1
 804:	00000097          	auipc	ra,0x0
 808:	dce080e7          	jalr	-562(ra) # 5d2 <vprintf>
}
 80c:	60e2                	ld	ra,24(sp)
 80e:	6442                	ld	s0,16(sp)
 810:	6125                	addi	sp,sp,96
 812:	8082                	ret

0000000000000814 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 814:	1141                	addi	sp,sp,-16
 816:	e422                	sd	s0,8(sp)
 818:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 81a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81e:	00000797          	auipc	a5,0x0
 822:	27a7b783          	ld	a5,634(a5) # a98 <freep>
 826:	a805                	j	856 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 828:	4618                	lw	a4,8(a2)
 82a:	9db9                	addw	a1,a1,a4
 82c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 830:	6398                	ld	a4,0(a5)
 832:	6318                	ld	a4,0(a4)
 834:	fee53823          	sd	a4,-16(a0)
 838:	a091                	j	87c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 83a:	ff852703          	lw	a4,-8(a0)
 83e:	9e39                	addw	a2,a2,a4
 840:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 842:	ff053703          	ld	a4,-16(a0)
 846:	e398                	sd	a4,0(a5)
 848:	a099                	j	88e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84a:	6398                	ld	a4,0(a5)
 84c:	00e7e463          	bltu	a5,a4,854 <free+0x40>
 850:	00e6ea63          	bltu	a3,a4,864 <free+0x50>
{
 854:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 856:	fed7fae3          	bgeu	a5,a3,84a <free+0x36>
 85a:	6398                	ld	a4,0(a5)
 85c:	00e6e463          	bltu	a3,a4,864 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 860:	fee7eae3          	bltu	a5,a4,854 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 864:	ff852583          	lw	a1,-8(a0)
 868:	6390                	ld	a2,0(a5)
 86a:	02059813          	slli	a6,a1,0x20
 86e:	01c85713          	srli	a4,a6,0x1c
 872:	9736                	add	a4,a4,a3
 874:	fae60ae3          	beq	a2,a4,828 <free+0x14>
    bp->s.ptr = p->s.ptr;
 878:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 87c:	4790                	lw	a2,8(a5)
 87e:	02061593          	slli	a1,a2,0x20
 882:	01c5d713          	srli	a4,a1,0x1c
 886:	973e                	add	a4,a4,a5
 888:	fae689e3          	beq	a3,a4,83a <free+0x26>
  } else
    p->s.ptr = bp;
 88c:	e394                	sd	a3,0(a5)
  freep = p;
 88e:	00000717          	auipc	a4,0x0
 892:	20f73523          	sd	a5,522(a4) # a98 <freep>
}
 896:	6422                	ld	s0,8(sp)
 898:	0141                	addi	sp,sp,16
 89a:	8082                	ret

000000000000089c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 89c:	7139                	addi	sp,sp,-64
 89e:	fc06                	sd	ra,56(sp)
 8a0:	f822                	sd	s0,48(sp)
 8a2:	f426                	sd	s1,40(sp)
 8a4:	f04a                	sd	s2,32(sp)
 8a6:	ec4e                	sd	s3,24(sp)
 8a8:	e852                	sd	s4,16(sp)
 8aa:	e456                	sd	s5,8(sp)
 8ac:	e05a                	sd	s6,0(sp)
 8ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b0:	02051493          	slli	s1,a0,0x20
 8b4:	9081                	srli	s1,s1,0x20
 8b6:	04bd                	addi	s1,s1,15
 8b8:	8091                	srli	s1,s1,0x4
 8ba:	0014899b          	addiw	s3,s1,1
 8be:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8c0:	00000517          	auipc	a0,0x0
 8c4:	1d853503          	ld	a0,472(a0) # a98 <freep>
 8c8:	c515                	beqz	a0,8f4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8cc:	4798                	lw	a4,8(a5)
 8ce:	02977f63          	bgeu	a4,s1,90c <malloc+0x70>
 8d2:	8a4e                	mv	s4,s3
 8d4:	0009871b          	sext.w	a4,s3
 8d8:	6685                	lui	a3,0x1
 8da:	00d77363          	bgeu	a4,a3,8e0 <malloc+0x44>
 8de:	6a05                	lui	s4,0x1
 8e0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8e8:	00000917          	auipc	s2,0x0
 8ec:	1b090913          	addi	s2,s2,432 # a98 <freep>
  if(p == (char*)-1)
 8f0:	5afd                	li	s5,-1
 8f2:	a895                	j	966 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8f4:	00000797          	auipc	a5,0x0
 8f8:	1ac78793          	addi	a5,a5,428 # aa0 <base>
 8fc:	00000717          	auipc	a4,0x0
 900:	18f73e23          	sd	a5,412(a4) # a98 <freep>
 904:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 906:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 90a:	b7e1                	j	8d2 <malloc+0x36>
      if(p->s.size == nunits)
 90c:	02e48c63          	beq	s1,a4,944 <malloc+0xa8>
        p->s.size -= nunits;
 910:	4137073b          	subw	a4,a4,s3
 914:	c798                	sw	a4,8(a5)
        p += p->s.size;
 916:	02071693          	slli	a3,a4,0x20
 91a:	01c6d713          	srli	a4,a3,0x1c
 91e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 920:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 924:	00000717          	auipc	a4,0x0
 928:	16a73a23          	sd	a0,372(a4) # a98 <freep>
      return (void*)(p + 1);
 92c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 930:	70e2                	ld	ra,56(sp)
 932:	7442                	ld	s0,48(sp)
 934:	74a2                	ld	s1,40(sp)
 936:	7902                	ld	s2,32(sp)
 938:	69e2                	ld	s3,24(sp)
 93a:	6a42                	ld	s4,16(sp)
 93c:	6aa2                	ld	s5,8(sp)
 93e:	6b02                	ld	s6,0(sp)
 940:	6121                	addi	sp,sp,64
 942:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 944:	6398                	ld	a4,0(a5)
 946:	e118                	sd	a4,0(a0)
 948:	bff1                	j	924 <malloc+0x88>
  hp->s.size = nu;
 94a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 94e:	0541                	addi	a0,a0,16
 950:	00000097          	auipc	ra,0x0
 954:	ec4080e7          	jalr	-316(ra) # 814 <free>
  return freep;
 958:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 95c:	d971                	beqz	a0,930 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 960:	4798                	lw	a4,8(a5)
 962:	fa9775e3          	bgeu	a4,s1,90c <malloc+0x70>
    if(p == freep)
 966:	00093703          	ld	a4,0(s2)
 96a:	853e                	mv	a0,a5
 96c:	fef719e3          	bne	a4,a5,95e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 970:	8552                	mv	a0,s4
 972:	00000097          	auipc	ra,0x0
 976:	b5c080e7          	jalr	-1188(ra) # 4ce <sbrk>
  if(p == (char*)-1)
 97a:	fd5518e3          	bne	a0,s5,94a <malloc+0xae>
        return 0;
 97e:	4501                	li	a0,0
 980:	bf45                	j	930 <malloc+0x94>
