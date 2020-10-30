
user/_kalloctest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
  test1();
  exit();
}

void test0()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  void *a, *a1;
  printf("start test0\n");  
  10:	00001517          	auipc	a0,0x1
  14:	9d050513          	addi	a0,a0,-1584 # 9e0 <malloc+0xea>
  18:	00001097          	auipc	ra,0x1
  1c:	820080e7          	jalr	-2016(ra) # 838 <printf>
  int n = ntas();
  20:	00000097          	auipc	ra,0x0
  24:	520080e7          	jalr	1312(ra) # 540 <ntas>
  28:	84aa                	mv	s1,a0
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
  2a:	00000097          	auipc	ra,0x0
  2e:	46e080e7          	jalr	1134(ra) # 498 <fork>
    if(pid < 0){
  32:	04054863          	bltz	a0,82 <test0+0x82>
      printf("fork failed");
      exit();
    }
    if(pid == 0){
  36:	c135                	beqz	a0,9a <test0+0x9a>
    int pid = fork();
  38:	00000097          	auipc	ra,0x0
  3c:	460080e7          	jalr	1120(ra) # 498 <fork>
    if(pid < 0){
  40:	04054163          	bltz	a0,82 <test0+0x82>
    if(pid == 0){
  44:	c939                	beqz	a0,9a <test0+0x9a>
      exit();
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait();
  46:	00000097          	auipc	ra,0x0
  4a:	462080e7          	jalr	1122(ra) # 4a8 <wait>
  4e:	00000097          	auipc	ra,0x0
  52:	45a080e7          	jalr	1114(ra) # 4a8 <wait>
  }
  int t = ntas();
  56:	00000097          	auipc	ra,0x0
  5a:	4ea080e7          	jalr	1258(ra) # 540 <ntas>
  printf("test0 done: #test-and-sets = %d\n", t - n);
  5e:	409505bb          	subw	a1,a0,s1
  62:	00001517          	auipc	a0,0x1
  66:	9ae50513          	addi	a0,a0,-1618 # a10 <malloc+0x11a>
  6a:	00000097          	auipc	ra,0x0
  6e:	7ce080e7          	jalr	1998(ra) # 838 <printf>
}
  72:	70a2                	ld	ra,40(sp)
  74:	7402                	ld	s0,32(sp)
  76:	64e2                	ld	s1,24(sp)
  78:	6942                	ld	s2,16(sp)
  7a:	69a2                	ld	s3,8(sp)
  7c:	6a02                	ld	s4,0(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
      printf("fork failed");
  82:	00001517          	auipc	a0,0x1
  86:	96e50513          	addi	a0,a0,-1682 # 9f0 <malloc+0xfa>
  8a:	00000097          	auipc	ra,0x0
  8e:	7ae080e7          	jalr	1966(ra) # 838 <printf>
      exit();
  92:	00000097          	auipc	ra,0x0
  96:	40e080e7          	jalr	1038(ra) # 4a0 <exit>
{
  9a:	6961                	lui	s2,0x18
  9c:	6a090913          	addi	s2,s2,1696 # 186a0 <__global_pointer$+0x1739f>
        if(a == (char*)0xffffffffffffffffL){
  a0:	59fd                	li	s3,-1
        *(int *)(a+4) = 1;
  a2:	4a05                	li	s4,1
        a = sbrk(4096);
  a4:	6505                	lui	a0,0x1
  a6:	00000097          	auipc	ra,0x0
  aa:	482080e7          	jalr	1154(ra) # 528 <sbrk>
  ae:	84aa                	mv	s1,a0
        if(a == (char*)0xffffffffffffffffL){
  b0:	03350063          	beq	a0,s3,d0 <test0+0xd0>
        *(int *)(a+4) = 1;
  b4:	01452223          	sw	s4,4(a0) # 1004 <__BSS_END__+0x4e4>
        a1 = sbrk(-4096);
  b8:	757d                	lui	a0,0xfffff
  ba:	00000097          	auipc	ra,0x0
  be:	46e080e7          	jalr	1134(ra) # 528 <sbrk>
        if (a1 != a + 4096) {
  c2:	6785                	lui	a5,0x1
  c4:	94be                	add	s1,s1,a5
  c6:	00951963          	bne	a0,s1,d8 <test0+0xd8>
      for(i = 0; i < N; i++) {
  ca:	397d                	addiw	s2,s2,-1
  cc:	fc091ce3          	bnez	s2,a4 <test0+0xa4>
      exit();
  d0:	00000097          	auipc	ra,0x0
  d4:	3d0080e7          	jalr	976(ra) # 4a0 <exit>
          printf("wrong sbrk\n");
  d8:	00001517          	auipc	a0,0x1
  dc:	92850513          	addi	a0,a0,-1752 # a00 <malloc+0x10a>
  e0:	00000097          	auipc	ra,0x0
  e4:	758080e7          	jalr	1880(ra) # 838 <printf>
          exit();
  e8:	00000097          	auipc	ra,0x0
  ec:	3b8080e7          	jalr	952(ra) # 4a0 <exit>

00000000000000f0 <test1>:

// Run system out of memory and count tot memory allocated
void test1()
{
  f0:	715d                	addi	sp,sp,-80
  f2:	e486                	sd	ra,72(sp)
  f4:	e0a2                	sd	s0,64(sp)
  f6:	fc26                	sd	s1,56(sp)
  f8:	f84a                	sd	s2,48(sp)
  fa:	f44e                	sd	s3,40(sp)
  fc:	f052                	sd	s4,32(sp)
  fe:	0880                	addi	s0,sp,80
  void *a;
  int pipes[NCHILD];
  int tot = 0;
  char buf[1];
  
  printf("start test1\n");  
 100:	00001517          	auipc	a0,0x1
 104:	93850513          	addi	a0,a0,-1736 # a38 <malloc+0x142>
 108:	00000097          	auipc	ra,0x0
 10c:	730080e7          	jalr	1840(ra) # 838 <printf>
  for(int i = 0; i < NCHILD; i++){
 110:	fc840913          	addi	s2,s0,-56
    int fds[2];
    if(pipe(fds) != 0){
 114:	fb840513          	addi	a0,s0,-72
 118:	00000097          	auipc	ra,0x0
 11c:	398080e7          	jalr	920(ra) # 4b0 <pipe>
 120:	84aa                	mv	s1,a0
 122:	e905                	bnez	a0,152 <test1+0x62>
      printf("pipe() failed\n");
      exit();
    }
    int pid = fork();
 124:	00000097          	auipc	ra,0x0
 128:	374080e7          	jalr	884(ra) # 498 <fork>
    if(pid < 0){
 12c:	02054f63          	bltz	a0,16a <test1+0x7a>
      printf("fork failed");
      exit();
    }
    if(pid == 0){
 130:	c929                	beqz	a0,182 <test1+0x92>
          exit();
        }
      }
      exit();
    } else {
      close(fds[1]);
 132:	fbc42503          	lw	a0,-68(s0)
 136:	00000097          	auipc	ra,0x0
 13a:	392080e7          	jalr	914(ra) # 4c8 <close>
      pipes[i] = fds[0];
 13e:	fb842783          	lw	a5,-72(s0)
 142:	00f92023          	sw	a5,0(s2)
  for(int i = 0; i < NCHILD; i++){
 146:	0911                	addi	s2,s2,4
 148:	fd040793          	addi	a5,s0,-48
 14c:	fd2794e3          	bne	a5,s2,114 <test1+0x24>
 150:	a855                	j	204 <test1+0x114>
      printf("pipe() failed\n");
 152:	00001517          	auipc	a0,0x1
 156:	8f650513          	addi	a0,a0,-1802 # a48 <malloc+0x152>
 15a:	00000097          	auipc	ra,0x0
 15e:	6de080e7          	jalr	1758(ra) # 838 <printf>
      exit();
 162:	00000097          	auipc	ra,0x0
 166:	33e080e7          	jalr	830(ra) # 4a0 <exit>
      printf("fork failed");
 16a:	00001517          	auipc	a0,0x1
 16e:	88650513          	addi	a0,a0,-1914 # 9f0 <malloc+0xfa>
 172:	00000097          	auipc	ra,0x0
 176:	6c6080e7          	jalr	1734(ra) # 838 <printf>
      exit();
 17a:	00000097          	auipc	ra,0x0
 17e:	326080e7          	jalr	806(ra) # 4a0 <exit>
      close(fds[0]);
 182:	fb842503          	lw	a0,-72(s0)
 186:	00000097          	auipc	ra,0x0
 18a:	342080e7          	jalr	834(ra) # 4c8 <close>
 18e:	64e1                	lui	s1,0x18
 190:	6a048493          	addi	s1,s1,1696 # 186a0 <__global_pointer$+0x1739f>
        if(a == (char*)0xffffffffffffffffL){
 194:	5a7d                	li	s4,-1
        *(int *)(a+4) = 1;
 196:	4905                	li	s2,1
        if (write(fds[1], "x", 1) != 1) {
 198:	00001997          	auipc	s3,0x1
 19c:	8c098993          	addi	s3,s3,-1856 # a58 <malloc+0x162>
        a = sbrk(PGSIZE);
 1a0:	6505                	lui	a0,0x1
 1a2:	00000097          	auipc	ra,0x0
 1a6:	386080e7          	jalr	902(ra) # 528 <sbrk>
        if(a == (char*)0xffffffffffffffffL){
 1aa:	03450063          	beq	a0,s4,1ca <test1+0xda>
        *(int *)(a+4) = 1;
 1ae:	01252223          	sw	s2,4(a0) # 1004 <__BSS_END__+0x4e4>
        if (write(fds[1], "x", 1) != 1) {
 1b2:	864a                	mv	a2,s2
 1b4:	85ce                	mv	a1,s3
 1b6:	fbc42503          	lw	a0,-68(s0)
 1ba:	00000097          	auipc	ra,0x0
 1be:	306080e7          	jalr	774(ra) # 4c0 <write>
 1c2:	01251863          	bne	a0,s2,1d2 <test1+0xe2>
      for(i = 0; i < N; i++) {
 1c6:	34fd                	addiw	s1,s1,-1
 1c8:	fce1                	bnez	s1,1a0 <test1+0xb0>
      exit();
 1ca:	00000097          	auipc	ra,0x0
 1ce:	2d6080e7          	jalr	726(ra) # 4a0 <exit>
          printf("write failed");
 1d2:	00001517          	auipc	a0,0x1
 1d6:	88e50513          	addi	a0,a0,-1906 # a60 <malloc+0x16a>
 1da:	00000097          	auipc	ra,0x0
 1de:	65e080e7          	jalr	1630(ra) # 838 <printf>
          exit();
 1e2:	00000097          	auipc	ra,0x0
 1e6:	2be080e7          	jalr	702(ra) # 4a0 <exit>
  int stop = 0;
  while (!stop) {
    stop = 1;
    for(int i = 0; i < NCHILD; i++){
      if (read(pipes[i], buf, 1) == 1) {
        tot += 1;
 1ea:	2485                	addiw	s1,s1,1
      if (read(pipes[i], buf, 1) == 1) {
 1ec:	4605                	li	a2,1
 1ee:	fc040593          	addi	a1,s0,-64
 1f2:	fcc42503          	lw	a0,-52(s0)
 1f6:	00000097          	auipc	ra,0x0
 1fa:	2c2080e7          	jalr	706(ra) # 4b8 <read>
 1fe:	4785                	li	a5,1
 200:	02f50a63          	beq	a0,a5,234 <test1+0x144>
 204:	4605                	li	a2,1
 206:	fc040593          	addi	a1,s0,-64
 20a:	fc842503          	lw	a0,-56(s0)
 20e:	00000097          	auipc	ra,0x0
 212:	2aa080e7          	jalr	682(ra) # 4b8 <read>
 216:	4785                	li	a5,1
 218:	fcf509e3          	beq	a0,a5,1ea <test1+0xfa>
 21c:	4605                	li	a2,1
 21e:	fc040593          	addi	a1,s0,-64
 222:	fcc42503          	lw	a0,-52(s0)
 226:	00000097          	auipc	ra,0x0
 22a:	292080e7          	jalr	658(ra) # 4b8 <read>
 22e:	4785                	li	a5,1
 230:	02f51063          	bne	a0,a5,250 <test1+0x160>
        tot += 1;
 234:	2485                	addiw	s1,s1,1
  while (!stop) {
 236:	b7f9                	j	204 <test1+0x114>
    }
  }
  int n = (PHYSTOP-KERNBASE)/PGSIZE;
  printf("total allocated number of pages: %d (out of %d)\n", tot, n);
  if(n - tot > 1000) {
    printf("test1 failed: cannot allocate enough memory\n");
 238:	00001517          	auipc	a0,0x1
 23c:	83850513          	addi	a0,a0,-1992 # a70 <malloc+0x17a>
 240:	00000097          	auipc	ra,0x0
 244:	5f8080e7          	jalr	1528(ra) # 838 <printf>
    exit();
 248:	00000097          	auipc	ra,0x0
 24c:	258080e7          	jalr	600(ra) # 4a0 <exit>
  printf("total allocated number of pages: %d (out of %d)\n", tot, n);
 250:	6621                	lui	a2,0x8
 252:	85a6                	mv	a1,s1
 254:	00001517          	auipc	a0,0x1
 258:	85c50513          	addi	a0,a0,-1956 # ab0 <malloc+0x1ba>
 25c:	00000097          	auipc	ra,0x0
 260:	5dc080e7          	jalr	1500(ra) # 838 <printf>
  if(n - tot > 1000) {
 264:	67a1                	lui	a5,0x8
 266:	409784bb          	subw	s1,a5,s1
 26a:	3e800793          	li	a5,1000
 26e:	fc97c5e3          	blt	a5,s1,238 <test1+0x148>
  }
  printf("test1 done\n");
 272:	00001517          	auipc	a0,0x1
 276:	82e50513          	addi	a0,a0,-2002 # aa0 <malloc+0x1aa>
 27a:	00000097          	auipc	ra,0x0
 27e:	5be080e7          	jalr	1470(ra) # 838 <printf>
}
 282:	60a6                	ld	ra,72(sp)
 284:	6406                	ld	s0,64(sp)
 286:	74e2                	ld	s1,56(sp)
 288:	7942                	ld	s2,48(sp)
 28a:	79a2                	ld	s3,40(sp)
 28c:	7a02                	ld	s4,32(sp)
 28e:	6161                	addi	sp,sp,80
 290:	8082                	ret

0000000000000292 <main>:
{
 292:	1141                	addi	sp,sp,-16
 294:	e406                	sd	ra,8(sp)
 296:	e022                	sd	s0,0(sp)
 298:	0800                	addi	s0,sp,16
  test0();
 29a:	00000097          	auipc	ra,0x0
 29e:	d66080e7          	jalr	-666(ra) # 0 <test0>
  test1();
 2a2:	00000097          	auipc	ra,0x0
 2a6:	e4e080e7          	jalr	-434(ra) # f0 <test1>
  exit();
 2aa:	00000097          	auipc	ra,0x0
 2ae:	1f6080e7          	jalr	502(ra) # 4a0 <exit>

00000000000002b2 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2b8:	87aa                	mv	a5,a0
 2ba:	0585                	addi	a1,a1,1
 2bc:	0785                	addi	a5,a5,1
 2be:	fff5c703          	lbu	a4,-1(a1)
 2c2:	fee78fa3          	sb	a4,-1(a5) # 7fff <__global_pointer$+0x6cfe>
 2c6:	fb75                	bnez	a4,2ba <strcpy+0x8>
    ;
  return os;
}
 2c8:	6422                	ld	s0,8(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret

00000000000002ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2d4:	00054783          	lbu	a5,0(a0)
 2d8:	cb91                	beqz	a5,2ec <strcmp+0x1e>
 2da:	0005c703          	lbu	a4,0(a1)
 2de:	00f71763          	bne	a4,a5,2ec <strcmp+0x1e>
    p++, q++;
 2e2:	0505                	addi	a0,a0,1
 2e4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	fbe5                	bnez	a5,2da <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2ec:	0005c503          	lbu	a0,0(a1)
}
 2f0:	40a7853b          	subw	a0,a5,a0
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret

00000000000002fa <strlen>:

uint
strlen(const char *s)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e422                	sd	s0,8(sp)
 2fe:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 300:	00054783          	lbu	a5,0(a0)
 304:	cf91                	beqz	a5,320 <strlen+0x26>
 306:	0505                	addi	a0,a0,1
 308:	87aa                	mv	a5,a0
 30a:	4685                	li	a3,1
 30c:	9e89                	subw	a3,a3,a0
 30e:	00f6853b          	addw	a0,a3,a5
 312:	0785                	addi	a5,a5,1
 314:	fff7c703          	lbu	a4,-1(a5)
 318:	fb7d                	bnez	a4,30e <strlen+0x14>
    ;
  return n;
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
  for(n = 0; s[n]; n++)
 320:	4501                	li	a0,0
 322:	bfe5                	j	31a <strlen+0x20>

0000000000000324 <memset>:

void*
memset(void *dst, int c, uint n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 32a:	ca19                	beqz	a2,340 <memset+0x1c>
 32c:	87aa                	mv	a5,a0
 32e:	1602                	slli	a2,a2,0x20
 330:	9201                	srli	a2,a2,0x20
 332:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 336:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 33a:	0785                	addi	a5,a5,1
 33c:	fee79de3          	bne	a5,a4,336 <memset+0x12>
  }
  return dst;
}
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret

0000000000000346 <strchr>:

char*
strchr(const char *s, char c)
{
 346:	1141                	addi	sp,sp,-16
 348:	e422                	sd	s0,8(sp)
 34a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 34c:	00054783          	lbu	a5,0(a0)
 350:	cb99                	beqz	a5,366 <strchr+0x20>
    if(*s == c)
 352:	00f58763          	beq	a1,a5,360 <strchr+0x1a>
  for(; *s; s++)
 356:	0505                	addi	a0,a0,1
 358:	00054783          	lbu	a5,0(a0)
 35c:	fbfd                	bnez	a5,352 <strchr+0xc>
      return (char*)s;
  return 0;
 35e:	4501                	li	a0,0
}
 360:	6422                	ld	s0,8(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
  return 0;
 366:	4501                	li	a0,0
 368:	bfe5                	j	360 <strchr+0x1a>

000000000000036a <gets>:

char*
gets(char *buf, int max)
{
 36a:	711d                	addi	sp,sp,-96
 36c:	ec86                	sd	ra,88(sp)
 36e:	e8a2                	sd	s0,80(sp)
 370:	e4a6                	sd	s1,72(sp)
 372:	e0ca                	sd	s2,64(sp)
 374:	fc4e                	sd	s3,56(sp)
 376:	f852                	sd	s4,48(sp)
 378:	f456                	sd	s5,40(sp)
 37a:	f05a                	sd	s6,32(sp)
 37c:	ec5e                	sd	s7,24(sp)
 37e:	1080                	addi	s0,sp,96
 380:	8baa                	mv	s7,a0
 382:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 384:	892a                	mv	s2,a0
 386:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 388:	4aa9                	li	s5,10
 38a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 38c:	89a6                	mv	s3,s1
 38e:	2485                	addiw	s1,s1,1
 390:	0344d863          	bge	s1,s4,3c0 <gets+0x56>
    cc = read(0, &c, 1);
 394:	4605                	li	a2,1
 396:	faf40593          	addi	a1,s0,-81
 39a:	4501                	li	a0,0
 39c:	00000097          	auipc	ra,0x0
 3a0:	11c080e7          	jalr	284(ra) # 4b8 <read>
    if(cc < 1)
 3a4:	00a05e63          	blez	a0,3c0 <gets+0x56>
    buf[i++] = c;
 3a8:	faf44783          	lbu	a5,-81(s0)
 3ac:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3b0:	01578763          	beq	a5,s5,3be <gets+0x54>
 3b4:	0905                	addi	s2,s2,1
 3b6:	fd679be3          	bne	a5,s6,38c <gets+0x22>
  for(i=0; i+1 < max; ){
 3ba:	89a6                	mv	s3,s1
 3bc:	a011                	j	3c0 <gets+0x56>
 3be:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3c0:	99de                	add	s3,s3,s7
 3c2:	00098023          	sb	zero,0(s3)
  return buf;
}
 3c6:	855e                	mv	a0,s7
 3c8:	60e6                	ld	ra,88(sp)
 3ca:	6446                	ld	s0,80(sp)
 3cc:	64a6                	ld	s1,72(sp)
 3ce:	6906                	ld	s2,64(sp)
 3d0:	79e2                	ld	s3,56(sp)
 3d2:	7a42                	ld	s4,48(sp)
 3d4:	7aa2                	ld	s5,40(sp)
 3d6:	7b02                	ld	s6,32(sp)
 3d8:	6be2                	ld	s7,24(sp)
 3da:	6125                	addi	sp,sp,96
 3dc:	8082                	ret

00000000000003de <stat>:

int
stat(const char *n, struct stat *st)
{
 3de:	1101                	addi	sp,sp,-32
 3e0:	ec06                	sd	ra,24(sp)
 3e2:	e822                	sd	s0,16(sp)
 3e4:	e426                	sd	s1,8(sp)
 3e6:	e04a                	sd	s2,0(sp)
 3e8:	1000                	addi	s0,sp,32
 3ea:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ec:	4581                	li	a1,0
 3ee:	00000097          	auipc	ra,0x0
 3f2:	0f2080e7          	jalr	242(ra) # 4e0 <open>
  if(fd < 0)
 3f6:	02054563          	bltz	a0,420 <stat+0x42>
 3fa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3fc:	85ca                	mv	a1,s2
 3fe:	00000097          	auipc	ra,0x0
 402:	0fa080e7          	jalr	250(ra) # 4f8 <fstat>
 406:	892a                	mv	s2,a0
  close(fd);
 408:	8526                	mv	a0,s1
 40a:	00000097          	auipc	ra,0x0
 40e:	0be080e7          	jalr	190(ra) # 4c8 <close>
  return r;
}
 412:	854a                	mv	a0,s2
 414:	60e2                	ld	ra,24(sp)
 416:	6442                	ld	s0,16(sp)
 418:	64a2                	ld	s1,8(sp)
 41a:	6902                	ld	s2,0(sp)
 41c:	6105                	addi	sp,sp,32
 41e:	8082                	ret
    return -1;
 420:	597d                	li	s2,-1
 422:	bfc5                	j	412 <stat+0x34>

0000000000000424 <atoi>:

int
atoi(const char *s)
{
 424:	1141                	addi	sp,sp,-16
 426:	e422                	sd	s0,8(sp)
 428:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 42a:	00054603          	lbu	a2,0(a0)
 42e:	fd06079b          	addiw	a5,a2,-48
 432:	0ff7f793          	andi	a5,a5,255
 436:	4725                	li	a4,9
 438:	02f76963          	bltu	a4,a5,46a <atoi+0x46>
 43c:	86aa                	mv	a3,a0
  n = 0;
 43e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 440:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 442:	0685                	addi	a3,a3,1
 444:	0025179b          	slliw	a5,a0,0x2
 448:	9fa9                	addw	a5,a5,a0
 44a:	0017979b          	slliw	a5,a5,0x1
 44e:	9fb1                	addw	a5,a5,a2
 450:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 454:	0006c603          	lbu	a2,0(a3)
 458:	fd06071b          	addiw	a4,a2,-48
 45c:	0ff77713          	andi	a4,a4,255
 460:	fee5f1e3          	bgeu	a1,a4,442 <atoi+0x1e>
  return n;
}
 464:	6422                	ld	s0,8(sp)
 466:	0141                	addi	sp,sp,16
 468:	8082                	ret
  n = 0;
 46a:	4501                	li	a0,0
 46c:	bfe5                	j	464 <atoi+0x40>

000000000000046e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 46e:	1141                	addi	sp,sp,-16
 470:	e422                	sd	s0,8(sp)
 472:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 474:	00c05f63          	blez	a2,492 <memmove+0x24>
 478:	1602                	slli	a2,a2,0x20
 47a:	9201                	srli	a2,a2,0x20
 47c:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 480:	87aa                	mv	a5,a0
    *dst++ = *src++;
 482:	0585                	addi	a1,a1,1
 484:	0785                	addi	a5,a5,1
 486:	fff5c703          	lbu	a4,-1(a1)
 48a:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 48e:	fed79ae3          	bne	a5,a3,482 <memmove+0x14>
  return vdst;
}
 492:	6422                	ld	s0,8(sp)
 494:	0141                	addi	sp,sp,16
 496:	8082                	ret

0000000000000498 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 498:	4885                	li	a7,1
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4a0:	4889                	li	a7,2
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4a8:	488d                	li	a7,3
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4b0:	4891                	li	a7,4
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <read>:
.global read
read:
 li a7, SYS_read
 4b8:	4895                	li	a7,5
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <write>:
.global write
write:
 li a7, SYS_write
 4c0:	48c1                	li	a7,16
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <close>:
.global close
close:
 li a7, SYS_close
 4c8:	48d5                	li	a7,21
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4d0:	4899                	li	a7,6
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4d8:	489d                	li	a7,7
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <open>:
.global open
open:
 li a7, SYS_open
 4e0:	48bd                	li	a7,15
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4e8:	48c5                	li	a7,17
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4f0:	48c9                	li	a7,18
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4f8:	48a1                	li	a7,8
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <link>:
.global link
link:
 li a7, SYS_link
 500:	48cd                	li	a7,19
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 508:	48d1                	li	a7,20
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 510:	48a5                	li	a7,9
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <dup>:
.global dup
dup:
 li a7, SYS_dup
 518:	48a9                	li	a7,10
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 520:	48ad                	li	a7,11
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 528:	48b1                	li	a7,12
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 530:	48b5                	li	a7,13
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 538:	48b9                	li	a7,14
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 540:	48d9                	li	a7,22
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <crash>:
.global crash
crash:
 li a7, SYS_crash
 548:	48dd                	li	a7,23
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <mount>:
.global mount
mount:
 li a7, SYS_mount
 550:	48e1                	li	a7,24
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <umount>:
.global umount
umount:
 li a7, SYS_umount
 558:	48e5                	li	a7,25
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 560:	1101                	addi	sp,sp,-32
 562:	ec06                	sd	ra,24(sp)
 564:	e822                	sd	s0,16(sp)
 566:	1000                	addi	s0,sp,32
 568:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 56c:	4605                	li	a2,1
 56e:	fef40593          	addi	a1,s0,-17
 572:	00000097          	auipc	ra,0x0
 576:	f4e080e7          	jalr	-178(ra) # 4c0 <write>
}
 57a:	60e2                	ld	ra,24(sp)
 57c:	6442                	ld	s0,16(sp)
 57e:	6105                	addi	sp,sp,32
 580:	8082                	ret

0000000000000582 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 582:	7139                	addi	sp,sp,-64
 584:	fc06                	sd	ra,56(sp)
 586:	f822                	sd	s0,48(sp)
 588:	f426                	sd	s1,40(sp)
 58a:	f04a                	sd	s2,32(sp)
 58c:	ec4e                	sd	s3,24(sp)
 58e:	0080                	addi	s0,sp,64
 590:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 592:	c299                	beqz	a3,598 <printint+0x16>
 594:	0805c863          	bltz	a1,624 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 598:	2581                	sext.w	a1,a1
  neg = 0;
 59a:	4881                	li	a7,0
 59c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5a2:	2601                	sext.w	a2,a2
 5a4:	00000517          	auipc	a0,0x0
 5a8:	54c50513          	addi	a0,a0,1356 # af0 <digits>
 5ac:	883a                	mv	a6,a4
 5ae:	2705                	addiw	a4,a4,1
 5b0:	02c5f7bb          	remuw	a5,a1,a2
 5b4:	1782                	slli	a5,a5,0x20
 5b6:	9381                	srli	a5,a5,0x20
 5b8:	97aa                	add	a5,a5,a0
 5ba:	0007c783          	lbu	a5,0(a5)
 5be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5c2:	0005879b          	sext.w	a5,a1
 5c6:	02c5d5bb          	divuw	a1,a1,a2
 5ca:	0685                	addi	a3,a3,1
 5cc:	fec7f0e3          	bgeu	a5,a2,5ac <printint+0x2a>
  if(neg)
 5d0:	00088b63          	beqz	a7,5e6 <printint+0x64>
    buf[i++] = '-';
 5d4:	fd040793          	addi	a5,s0,-48
 5d8:	973e                	add	a4,a4,a5
 5da:	02d00793          	li	a5,45
 5de:	fef70823          	sb	a5,-16(a4)
 5e2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5e6:	02e05863          	blez	a4,616 <printint+0x94>
 5ea:	fc040793          	addi	a5,s0,-64
 5ee:	00e78933          	add	s2,a5,a4
 5f2:	fff78993          	addi	s3,a5,-1
 5f6:	99ba                	add	s3,s3,a4
 5f8:	377d                	addiw	a4,a4,-1
 5fa:	1702                	slli	a4,a4,0x20
 5fc:	9301                	srli	a4,a4,0x20
 5fe:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 602:	fff94583          	lbu	a1,-1(s2)
 606:	8526                	mv	a0,s1
 608:	00000097          	auipc	ra,0x0
 60c:	f58080e7          	jalr	-168(ra) # 560 <putc>
  while(--i >= 0)
 610:	197d                	addi	s2,s2,-1
 612:	ff3918e3          	bne	s2,s3,602 <printint+0x80>
}
 616:	70e2                	ld	ra,56(sp)
 618:	7442                	ld	s0,48(sp)
 61a:	74a2                	ld	s1,40(sp)
 61c:	7902                	ld	s2,32(sp)
 61e:	69e2                	ld	s3,24(sp)
 620:	6121                	addi	sp,sp,64
 622:	8082                	ret
    x = -xx;
 624:	40b005bb          	negw	a1,a1
    neg = 1;
 628:	4885                	li	a7,1
    x = -xx;
 62a:	bf8d                	j	59c <printint+0x1a>

000000000000062c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 62c:	7119                	addi	sp,sp,-128
 62e:	fc86                	sd	ra,120(sp)
 630:	f8a2                	sd	s0,112(sp)
 632:	f4a6                	sd	s1,104(sp)
 634:	f0ca                	sd	s2,96(sp)
 636:	ecce                	sd	s3,88(sp)
 638:	e8d2                	sd	s4,80(sp)
 63a:	e4d6                	sd	s5,72(sp)
 63c:	e0da                	sd	s6,64(sp)
 63e:	fc5e                	sd	s7,56(sp)
 640:	f862                	sd	s8,48(sp)
 642:	f466                	sd	s9,40(sp)
 644:	f06a                	sd	s10,32(sp)
 646:	ec6e                	sd	s11,24(sp)
 648:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 64a:	0005c903          	lbu	s2,0(a1)
 64e:	18090f63          	beqz	s2,7ec <vprintf+0x1c0>
 652:	8aaa                	mv	s5,a0
 654:	8b32                	mv	s6,a2
 656:	00158493          	addi	s1,a1,1
  state = 0;
 65a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 65c:	02500a13          	li	s4,37
      if(c == 'd'){
 660:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 664:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 668:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 66c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 670:	00000b97          	auipc	s7,0x0
 674:	480b8b93          	addi	s7,s7,1152 # af0 <digits>
 678:	a839                	j	696 <vprintf+0x6a>
        putc(fd, c);
 67a:	85ca                	mv	a1,s2
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	ee2080e7          	jalr	-286(ra) # 560 <putc>
 686:	a019                	j	68c <vprintf+0x60>
    } else if(state == '%'){
 688:	01498f63          	beq	s3,s4,6a6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 68c:	0485                	addi	s1,s1,1
 68e:	fff4c903          	lbu	s2,-1(s1)
 692:	14090d63          	beqz	s2,7ec <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 696:	0009079b          	sext.w	a5,s2
    if(state == 0){
 69a:	fe0997e3          	bnez	s3,688 <vprintf+0x5c>
      if(c == '%'){
 69e:	fd479ee3          	bne	a5,s4,67a <vprintf+0x4e>
        state = '%';
 6a2:	89be                	mv	s3,a5
 6a4:	b7e5                	j	68c <vprintf+0x60>
      if(c == 'd'){
 6a6:	05878063          	beq	a5,s8,6e6 <vprintf+0xba>
      } else if(c == 'l') {
 6aa:	05978c63          	beq	a5,s9,702 <vprintf+0xd6>
      } else if(c == 'x') {
 6ae:	07a78863          	beq	a5,s10,71e <vprintf+0xf2>
      } else if(c == 'p') {
 6b2:	09b78463          	beq	a5,s11,73a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6b6:	07300713          	li	a4,115
 6ba:	0ce78663          	beq	a5,a4,786 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6be:	06300713          	li	a4,99
 6c2:	0ee78e63          	beq	a5,a4,7be <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6c6:	11478863          	beq	a5,s4,7d6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ca:	85d2                	mv	a1,s4
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e92080e7          	jalr	-366(ra) # 560 <putc>
        putc(fd, c);
 6d6:	85ca                	mv	a1,s2
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	e86080e7          	jalr	-378(ra) # 560 <putc>
      }
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b765                	j	68c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6e6:	008b0913          	addi	s2,s6,8
 6ea:	4685                	li	a3,1
 6ec:	4629                	li	a2,10
 6ee:	000b2583          	lw	a1,0(s6)
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	e8e080e7          	jalr	-370(ra) # 582 <printint>
 6fc:	8b4a                	mv	s6,s2
      state = 0;
 6fe:	4981                	li	s3,0
 700:	b771                	j	68c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 702:	008b0913          	addi	s2,s6,8
 706:	4681                	li	a3,0
 708:	4629                	li	a2,10
 70a:	000b2583          	lw	a1,0(s6)
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	e72080e7          	jalr	-398(ra) # 582 <printint>
 718:	8b4a                	mv	s6,s2
      state = 0;
 71a:	4981                	li	s3,0
 71c:	bf85                	j	68c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 71e:	008b0913          	addi	s2,s6,8
 722:	4681                	li	a3,0
 724:	4641                	li	a2,16
 726:	000b2583          	lw	a1,0(s6)
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	e56080e7          	jalr	-426(ra) # 582 <printint>
 734:	8b4a                	mv	s6,s2
      state = 0;
 736:	4981                	li	s3,0
 738:	bf91                	j	68c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 73a:	008b0793          	addi	a5,s6,8
 73e:	f8f43423          	sd	a5,-120(s0)
 742:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 746:	03000593          	li	a1,48
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	e14080e7          	jalr	-492(ra) # 560 <putc>
  putc(fd, 'x');
 754:	85ea                	mv	a1,s10
 756:	8556                	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	e08080e7          	jalr	-504(ra) # 560 <putc>
 760:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 762:	03c9d793          	srli	a5,s3,0x3c
 766:	97de                	add	a5,a5,s7
 768:	0007c583          	lbu	a1,0(a5)
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	df2080e7          	jalr	-526(ra) # 560 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 776:	0992                	slli	s3,s3,0x4
 778:	397d                	addiw	s2,s2,-1
 77a:	fe0914e3          	bnez	s2,762 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 77e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 782:	4981                	li	s3,0
 784:	b721                	j	68c <vprintf+0x60>
        s = va_arg(ap, char*);
 786:	008b0993          	addi	s3,s6,8
 78a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 78e:	02090163          	beqz	s2,7b0 <vprintf+0x184>
        while(*s != 0){
 792:	00094583          	lbu	a1,0(s2)
 796:	c9a1                	beqz	a1,7e6 <vprintf+0x1ba>
          putc(fd, *s);
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	dc6080e7          	jalr	-570(ra) # 560 <putc>
          s++;
 7a2:	0905                	addi	s2,s2,1
        while(*s != 0){
 7a4:	00094583          	lbu	a1,0(s2)
 7a8:	f9e5                	bnez	a1,798 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7aa:	8b4e                	mv	s6,s3
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	bdf9                	j	68c <vprintf+0x60>
          s = "(null)";
 7b0:	00000917          	auipc	s2,0x0
 7b4:	33890913          	addi	s2,s2,824 # ae8 <malloc+0x1f2>
        while(*s != 0){
 7b8:	02800593          	li	a1,40
 7bc:	bff1                	j	798 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7be:	008b0913          	addi	s2,s6,8
 7c2:	000b4583          	lbu	a1,0(s6)
 7c6:	8556                	mv	a0,s5
 7c8:	00000097          	auipc	ra,0x0
 7cc:	d98080e7          	jalr	-616(ra) # 560 <putc>
 7d0:	8b4a                	mv	s6,s2
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	bd65                	j	68c <vprintf+0x60>
        putc(fd, c);
 7d6:	85d2                	mv	a1,s4
 7d8:	8556                	mv	a0,s5
 7da:	00000097          	auipc	ra,0x0
 7de:	d86080e7          	jalr	-634(ra) # 560 <putc>
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	b565                	j	68c <vprintf+0x60>
        s = va_arg(ap, char*);
 7e6:	8b4e                	mv	s6,s3
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	b54d                	j	68c <vprintf+0x60>
    }
  }
}
 7ec:	70e6                	ld	ra,120(sp)
 7ee:	7446                	ld	s0,112(sp)
 7f0:	74a6                	ld	s1,104(sp)
 7f2:	7906                	ld	s2,96(sp)
 7f4:	69e6                	ld	s3,88(sp)
 7f6:	6a46                	ld	s4,80(sp)
 7f8:	6aa6                	ld	s5,72(sp)
 7fa:	6b06                	ld	s6,64(sp)
 7fc:	7be2                	ld	s7,56(sp)
 7fe:	7c42                	ld	s8,48(sp)
 800:	7ca2                	ld	s9,40(sp)
 802:	7d02                	ld	s10,32(sp)
 804:	6de2                	ld	s11,24(sp)
 806:	6109                	addi	sp,sp,128
 808:	8082                	ret

000000000000080a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 80a:	715d                	addi	sp,sp,-80
 80c:	ec06                	sd	ra,24(sp)
 80e:	e822                	sd	s0,16(sp)
 810:	1000                	addi	s0,sp,32
 812:	e010                	sd	a2,0(s0)
 814:	e414                	sd	a3,8(s0)
 816:	e818                	sd	a4,16(s0)
 818:	ec1c                	sd	a5,24(s0)
 81a:	03043023          	sd	a6,32(s0)
 81e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 822:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 826:	8622                	mv	a2,s0
 828:	00000097          	auipc	ra,0x0
 82c:	e04080e7          	jalr	-508(ra) # 62c <vprintf>
}
 830:	60e2                	ld	ra,24(sp)
 832:	6442                	ld	s0,16(sp)
 834:	6161                	addi	sp,sp,80
 836:	8082                	ret

0000000000000838 <printf>:

void
printf(const char *fmt, ...)
{
 838:	711d                	addi	sp,sp,-96
 83a:	ec06                	sd	ra,24(sp)
 83c:	e822                	sd	s0,16(sp)
 83e:	1000                	addi	s0,sp,32
 840:	e40c                	sd	a1,8(s0)
 842:	e810                	sd	a2,16(s0)
 844:	ec14                	sd	a3,24(s0)
 846:	f018                	sd	a4,32(s0)
 848:	f41c                	sd	a5,40(s0)
 84a:	03043823          	sd	a6,48(s0)
 84e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 852:	00840613          	addi	a2,s0,8
 856:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 85a:	85aa                	mv	a1,a0
 85c:	4505                	li	a0,1
 85e:	00000097          	auipc	ra,0x0
 862:	dce080e7          	jalr	-562(ra) # 62c <vprintf>
}
 866:	60e2                	ld	ra,24(sp)
 868:	6442                	ld	s0,16(sp)
 86a:	6125                	addi	sp,sp,96
 86c:	8082                	ret

000000000000086e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 86e:	1141                	addi	sp,sp,-16
 870:	e422                	sd	s0,8(sp)
 872:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 874:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 878:	00000797          	auipc	a5,0x0
 87c:	2907b783          	ld	a5,656(a5) # b08 <freep>
 880:	a805                	j	8b0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 882:	4618                	lw	a4,8(a2)
 884:	9db9                	addw	a1,a1,a4
 886:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 88a:	6398                	ld	a4,0(a5)
 88c:	6318                	ld	a4,0(a4)
 88e:	fee53823          	sd	a4,-16(a0)
 892:	a091                	j	8d6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 894:	ff852703          	lw	a4,-8(a0)
 898:	9e39                	addw	a2,a2,a4
 89a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 89c:	ff053703          	ld	a4,-16(a0)
 8a0:	e398                	sd	a4,0(a5)
 8a2:	a099                	j	8e8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a4:	6398                	ld	a4,0(a5)
 8a6:	00e7e463          	bltu	a5,a4,8ae <free+0x40>
 8aa:	00e6ea63          	bltu	a3,a4,8be <free+0x50>
{
 8ae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b0:	fed7fae3          	bgeu	a5,a3,8a4 <free+0x36>
 8b4:	6398                	ld	a4,0(a5)
 8b6:	00e6e463          	bltu	a3,a4,8be <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ba:	fee7eae3          	bltu	a5,a4,8ae <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8be:	ff852583          	lw	a1,-8(a0)
 8c2:	6390                	ld	a2,0(a5)
 8c4:	02059813          	slli	a6,a1,0x20
 8c8:	01c85713          	srli	a4,a6,0x1c
 8cc:	9736                	add	a4,a4,a3
 8ce:	fae60ae3          	beq	a2,a4,882 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8d2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8d6:	4790                	lw	a2,8(a5)
 8d8:	02061593          	slli	a1,a2,0x20
 8dc:	01c5d713          	srli	a4,a1,0x1c
 8e0:	973e                	add	a4,a4,a5
 8e2:	fae689e3          	beq	a3,a4,894 <free+0x26>
  } else
    p->s.ptr = bp;
 8e6:	e394                	sd	a3,0(a5)
  freep = p;
 8e8:	00000717          	auipc	a4,0x0
 8ec:	22f73023          	sd	a5,544(a4) # b08 <freep>
}
 8f0:	6422                	ld	s0,8(sp)
 8f2:	0141                	addi	sp,sp,16
 8f4:	8082                	ret

00000000000008f6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f6:	7139                	addi	sp,sp,-64
 8f8:	fc06                	sd	ra,56(sp)
 8fa:	f822                	sd	s0,48(sp)
 8fc:	f426                	sd	s1,40(sp)
 8fe:	f04a                	sd	s2,32(sp)
 900:	ec4e                	sd	s3,24(sp)
 902:	e852                	sd	s4,16(sp)
 904:	e456                	sd	s5,8(sp)
 906:	e05a                	sd	s6,0(sp)
 908:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 90a:	02051493          	slli	s1,a0,0x20
 90e:	9081                	srli	s1,s1,0x20
 910:	04bd                	addi	s1,s1,15
 912:	8091                	srli	s1,s1,0x4
 914:	0014899b          	addiw	s3,s1,1
 918:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 91a:	00000517          	auipc	a0,0x0
 91e:	1ee53503          	ld	a0,494(a0) # b08 <freep>
 922:	c515                	beqz	a0,94e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 924:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 926:	4798                	lw	a4,8(a5)
 928:	02977f63          	bgeu	a4,s1,966 <malloc+0x70>
 92c:	8a4e                	mv	s4,s3
 92e:	0009871b          	sext.w	a4,s3
 932:	6685                	lui	a3,0x1
 934:	00d77363          	bgeu	a4,a3,93a <malloc+0x44>
 938:	6a05                	lui	s4,0x1
 93a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 93e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 942:	00000917          	auipc	s2,0x0
 946:	1c690913          	addi	s2,s2,454 # b08 <freep>
  if(p == (char*)-1)
 94a:	5afd                	li	s5,-1
 94c:	a895                	j	9c0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 94e:	00000797          	auipc	a5,0x0
 952:	1c278793          	addi	a5,a5,450 # b10 <base>
 956:	00000717          	auipc	a4,0x0
 95a:	1af73923          	sd	a5,434(a4) # b08 <freep>
 95e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 960:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 964:	b7e1                	j	92c <malloc+0x36>
      if(p->s.size == nunits)
 966:	02e48c63          	beq	s1,a4,99e <malloc+0xa8>
        p->s.size -= nunits;
 96a:	4137073b          	subw	a4,a4,s3
 96e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 970:	02071693          	slli	a3,a4,0x20
 974:	01c6d713          	srli	a4,a3,0x1c
 978:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 97a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 97e:	00000717          	auipc	a4,0x0
 982:	18a73523          	sd	a0,394(a4) # b08 <freep>
      return (void*)(p + 1);
 986:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 98a:	70e2                	ld	ra,56(sp)
 98c:	7442                	ld	s0,48(sp)
 98e:	74a2                	ld	s1,40(sp)
 990:	7902                	ld	s2,32(sp)
 992:	69e2                	ld	s3,24(sp)
 994:	6a42                	ld	s4,16(sp)
 996:	6aa2                	ld	s5,8(sp)
 998:	6b02                	ld	s6,0(sp)
 99a:	6121                	addi	sp,sp,64
 99c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 99e:	6398                	ld	a4,0(a5)
 9a0:	e118                	sd	a4,0(a0)
 9a2:	bff1                	j	97e <malloc+0x88>
  hp->s.size = nu;
 9a4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9a8:	0541                	addi	a0,a0,16
 9aa:	00000097          	auipc	ra,0x0
 9ae:	ec4080e7          	jalr	-316(ra) # 86e <free>
  return freep;
 9b2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9b6:	d971                	beqz	a0,98a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ba:	4798                	lw	a4,8(a5)
 9bc:	fa9775e3          	bgeu	a4,s1,966 <malloc+0x70>
    if(p == freep)
 9c0:	00093703          	ld	a4,0(s2)
 9c4:	853e                	mv	a0,a5
 9c6:	fef719e3          	bne	a4,a5,9b8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9ca:	8552                	mv	a0,s4
 9cc:	00000097          	auipc	ra,0x0
 9d0:	b5c080e7          	jalr	-1188(ra) # 528 <sbrk>
  if(p == (char*)-1)
 9d4:	fd5518e3          	bne	a0,s5,9a4 <malloc+0xae>
        return 0;
 9d8:	4501                	li	a0,0
 9da:	bf45                	j	98a <malloc+0x94>
