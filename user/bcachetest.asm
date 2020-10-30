
user/_bcachetest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <createfile>:
  exit();
}

void
createfile(char *file, int nblock)
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	21513423          	sd	s5,520(sp)
  20:	0480                	addi	s0,sp,576
  22:	8a2a                	mv	s4,a0
  24:	89ae                	mv	s3,a1
  int fd;
  char buf[512];
  int i;
  
  fd = open(file, O_CREATE | O_RDWR);
  26:	20200593          	li	a1,514
  2a:	00000097          	auipc	ra,0x0
  2e:	594080e7          	jalr	1428(ra) # 5be <open>
  if(fd < 0){
  32:	04054063          	bltz	a0,72 <createfile+0x72>
  36:	892a                	mv	s2,a0
    printf("test0 create %s failed\n", file);
    exit();
  }
  for(i = 0; i < nblock; i++) {
  38:	4481                	li	s1,0
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)) {
      printf("write %s failed\n", file);
  3a:	00001a97          	auipc	s5,0x1
  3e:	a9ea8a93          	addi	s5,s5,-1378 # ad8 <malloc+0x104>
  for(i = 0; i < nblock; i++) {
  42:	05304863          	bgtz	s3,92 <createfile+0x92>
    }
  }
  close(fd);
  46:	854a                	mv	a0,s2
  48:	00000097          	auipc	ra,0x0
  4c:	55e080e7          	jalr	1374(ra) # 5a6 <close>
}
  50:	23813083          	ld	ra,568(sp)
  54:	23013403          	ld	s0,560(sp)
  58:	22813483          	ld	s1,552(sp)
  5c:	22013903          	ld	s2,544(sp)
  60:	21813983          	ld	s3,536(sp)
  64:	21013a03          	ld	s4,528(sp)
  68:	20813a83          	ld	s5,520(sp)
  6c:	24010113          	addi	sp,sp,576
  70:	8082                	ret
    printf("test0 create %s failed\n", file);
  72:	85d2                	mv	a1,s4
  74:	00001517          	auipc	a0,0x1
  78:	a4c50513          	addi	a0,a0,-1460 # ac0 <malloc+0xec>
  7c:	00001097          	auipc	ra,0x1
  80:	89a080e7          	jalr	-1894(ra) # 916 <printf>
    exit();
  84:	00000097          	auipc	ra,0x0
  88:	4fa080e7          	jalr	1274(ra) # 57e <exit>
  for(i = 0; i < nblock; i++) {
  8c:	2485                	addiw	s1,s1,1
  8e:	fa998ce3          	beq	s3,s1,46 <createfile+0x46>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)) {
  92:	20000613          	li	a2,512
  96:	dc040593          	addi	a1,s0,-576
  9a:	854a                	mv	a0,s2
  9c:	00000097          	auipc	ra,0x0
  a0:	502080e7          	jalr	1282(ra) # 59e <write>
  a4:	20000793          	li	a5,512
  a8:	fef502e3          	beq	a0,a5,8c <createfile+0x8c>
      printf("write %s failed\n", file);
  ac:	85d2                	mv	a1,s4
  ae:	8556                	mv	a0,s5
  b0:	00001097          	auipc	ra,0x1
  b4:	866080e7          	jalr	-1946(ra) # 916 <printf>
  b8:	bfd1                	j	8c <createfile+0x8c>

00000000000000ba <readfile>:

void
readfile(char *file, int nblock)
{
  ba:	dd010113          	addi	sp,sp,-560
  be:	22113423          	sd	ra,552(sp)
  c2:	22813023          	sd	s0,544(sp)
  c6:	20913c23          	sd	s1,536(sp)
  ca:	21213823          	sd	s2,528(sp)
  ce:	21313423          	sd	s3,520(sp)
  d2:	21413023          	sd	s4,512(sp)
  d6:	1c00                	addi	s0,sp,560
  d8:	8a2a                	mv	s4,a0
  da:	89ae                	mv	s3,a1
  char buf[512];
  int fd;
  int i;
  
  if ((fd = open(file, O_RDONLY)) < 0) {
  dc:	4581                	li	a1,0
  de:	00000097          	auipc	ra,0x0
  e2:	4e0080e7          	jalr	1248(ra) # 5be <open>
  e6:	04054a63          	bltz	a0,13a <readfile+0x80>
  ea:	892a                	mv	s2,a0
    printf("test0 open %s failed\n", file);
    exit();
  }
  for (i = 0; i < nblock; i++) {
  ec:	4481                	li	s1,0
  ee:	03305263          	blez	s3,112 <readfile+0x58>
    if(read(fd, buf, sizeof(buf)) != sizeof(buf)) {
  f2:	20000613          	li	a2,512
  f6:	dd040593          	addi	a1,s0,-560
  fa:	854a                	mv	a0,s2
  fc:	00000097          	auipc	ra,0x0
 100:	49a080e7          	jalr	1178(ra) # 596 <read>
 104:	20000793          	li	a5,512
 108:	04f51663          	bne	a0,a5,154 <readfile+0x9a>
  for (i = 0; i < nblock; i++) {
 10c:	2485                	addiw	s1,s1,1
 10e:	fe9992e3          	bne	s3,s1,f2 <readfile+0x38>
      printf("read %s failed for block %d (%d)\n", file, i, nblock);
      exit();
    }
  }
  close(fd);
 112:	854a                	mv	a0,s2
 114:	00000097          	auipc	ra,0x0
 118:	492080e7          	jalr	1170(ra) # 5a6 <close>
}
 11c:	22813083          	ld	ra,552(sp)
 120:	22013403          	ld	s0,544(sp)
 124:	21813483          	ld	s1,536(sp)
 128:	21013903          	ld	s2,528(sp)
 12c:	20813983          	ld	s3,520(sp)
 130:	20013a03          	ld	s4,512(sp)
 134:	23010113          	addi	sp,sp,560
 138:	8082                	ret
    printf("test0 open %s failed\n", file);
 13a:	85d2                	mv	a1,s4
 13c:	00001517          	auipc	a0,0x1
 140:	9b450513          	addi	a0,a0,-1612 # af0 <malloc+0x11c>
 144:	00000097          	auipc	ra,0x0
 148:	7d2080e7          	jalr	2002(ra) # 916 <printf>
    exit();
 14c:	00000097          	auipc	ra,0x0
 150:	432080e7          	jalr	1074(ra) # 57e <exit>
      printf("read %s failed for block %d (%d)\n", file, i, nblock);
 154:	86ce                	mv	a3,s3
 156:	8626                	mv	a2,s1
 158:	85d2                	mv	a1,s4
 15a:	00001517          	auipc	a0,0x1
 15e:	9ae50513          	addi	a0,a0,-1618 # b08 <malloc+0x134>
 162:	00000097          	auipc	ra,0x0
 166:	7b4080e7          	jalr	1972(ra) # 916 <printf>
      exit();
 16a:	00000097          	auipc	ra,0x0
 16e:	414080e7          	jalr	1044(ra) # 57e <exit>

0000000000000172 <test0>:

void
test0()
{
 172:	7139                	addi	sp,sp,-64
 174:	fc06                	sd	ra,56(sp)
 176:	f822                	sd	s0,48(sp)
 178:	f426                	sd	s1,40(sp)
 17a:	f04a                	sd	s2,32(sp)
 17c:	ec4e                	sd	s3,24(sp)
 17e:	0080                	addi	s0,sp,64
  char file[3];

  file[0] = 'B';
 180:	04200793          	li	a5,66
 184:	fcf40423          	sb	a5,-56(s0)
  file[2] = '\0';
 188:	fc040523          	sb	zero,-54(s0)

  printf("start test0\n");
 18c:	00001517          	auipc	a0,0x1
 190:	9a450513          	addi	a0,a0,-1628 # b30 <malloc+0x15c>
 194:	00000097          	auipc	ra,0x0
 198:	782080e7          	jalr	1922(ra) # 916 <printf>
  int n = ntas();
 19c:	00000097          	auipc	ra,0x0
 1a0:	482080e7          	jalr	1154(ra) # 61e <ntas>
 1a4:	892a                	mv	s2,a0
 1a6:	03000493          	li	s1,48
  for(int i = 0; i < NCHILD; i++){
 1aa:	03300993          	li	s3,51
    file[1] = '0' + i;
 1ae:	fc9404a3          	sb	s1,-55(s0)
    createfile(file, 1);
 1b2:	4585                	li	a1,1
 1b4:	fc840513          	addi	a0,s0,-56
 1b8:	00000097          	auipc	ra,0x0
 1bc:	e48080e7          	jalr	-440(ra) # 0 <createfile>
    int pid = fork();
 1c0:	00000097          	auipc	ra,0x0
 1c4:	3b6080e7          	jalr	950(ra) # 576 <fork>
    if(pid < 0){
 1c8:	04054963          	bltz	a0,21a <test0+0xa8>
      printf("fork failed");
      exit();
    }
    if(pid == 0){
 1cc:	c13d                	beqz	a0,232 <test0+0xc0>
  for(int i = 0; i < NCHILD; i++){
 1ce:	2485                	addiw	s1,s1,1
 1d0:	0ff4f493          	andi	s1,s1,255
 1d4:	fd349de3          	bne	s1,s3,1ae <test0+0x3c>
      exit();
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait();
 1d8:	00000097          	auipc	ra,0x0
 1dc:	3ae080e7          	jalr	942(ra) # 586 <wait>
 1e0:	00000097          	auipc	ra,0x0
 1e4:	3a6080e7          	jalr	934(ra) # 586 <wait>
 1e8:	00000097          	auipc	ra,0x0
 1ec:	39e080e7          	jalr	926(ra) # 586 <wait>
  }
  printf("test0 done: #test-and-sets: %d\n", ntas() - n);
 1f0:	00000097          	auipc	ra,0x0
 1f4:	42e080e7          	jalr	1070(ra) # 61e <ntas>
 1f8:	412505bb          	subw	a1,a0,s2
 1fc:	00001517          	auipc	a0,0x1
 200:	95450513          	addi	a0,a0,-1708 # b50 <malloc+0x17c>
 204:	00000097          	auipc	ra,0x0
 208:	712080e7          	jalr	1810(ra) # 916 <printf>
}
 20c:	70e2                	ld	ra,56(sp)
 20e:	7442                	ld	s0,48(sp)
 210:	74a2                	ld	s1,40(sp)
 212:	7902                	ld	s2,32(sp)
 214:	69e2                	ld	s3,24(sp)
 216:	6121                	addi	sp,sp,64
 218:	8082                	ret
      printf("fork failed");
 21a:	00001517          	auipc	a0,0x1
 21e:	92650513          	addi	a0,a0,-1754 # b40 <malloc+0x16c>
 222:	00000097          	auipc	ra,0x0
 226:	6f4080e7          	jalr	1780(ra) # 916 <printf>
      exit();
 22a:	00000097          	auipc	ra,0x0
 22e:	354080e7          	jalr	852(ra) # 57e <exit>
 232:	3e800493          	li	s1,1000
        readfile(file, 1);
 236:	4585                	li	a1,1
 238:	fc840513          	addi	a0,s0,-56
 23c:	00000097          	auipc	ra,0x0
 240:	e7e080e7          	jalr	-386(ra) # ba <readfile>
      for (i = 0; i < N; i++) {
 244:	34fd                	addiw	s1,s1,-1
 246:	f8e5                	bnez	s1,236 <test0+0xc4>
      unlink(file);
 248:	fc840513          	addi	a0,s0,-56
 24c:	00000097          	auipc	ra,0x0
 250:	382080e7          	jalr	898(ra) # 5ce <unlink>
      exit();
 254:	00000097          	auipc	ra,0x0
 258:	32a080e7          	jalr	810(ra) # 57e <exit>

000000000000025c <test1>:

void test1()
{
 25c:	7179                	addi	sp,sp,-48
 25e:	f406                	sd	ra,40(sp)
 260:	f022                	sd	s0,32(sp)
 262:	ec26                	sd	s1,24(sp)
 264:	1800                	addi	s0,sp,48
  char file[3];
  
  printf("start test1\n");
 266:	00001517          	auipc	a0,0x1
 26a:	90a50513          	addi	a0,a0,-1782 # b70 <malloc+0x19c>
 26e:	00000097          	auipc	ra,0x0
 272:	6a8080e7          	jalr	1704(ra) # 916 <printf>
  file[0] = 'B';
 276:	04200793          	li	a5,66
 27a:	fcf40c23          	sb	a5,-40(s0)
  file[2] = '\0';
 27e:	fc040d23          	sb	zero,-38(s0)
  for(int i = 0; i < 2; i++){
    file[1] = '0' + i;
 282:	03000493          	li	s1,48
 286:	fc940ca3          	sb	s1,-39(s0)
    if (i == 0) {
      createfile(file, BIG);
 28a:	06400593          	li	a1,100
 28e:	fd840513          	addi	a0,s0,-40
 292:	00000097          	auipc	ra,0x0
 296:	d6e080e7          	jalr	-658(ra) # 0 <createfile>
    file[1] = '0' + i;
 29a:	03100793          	li	a5,49
 29e:	fcf40ca3          	sb	a5,-39(s0)
    } else {
      createfile(file, 1);
 2a2:	4585                	li	a1,1
 2a4:	fd840513          	addi	a0,s0,-40
 2a8:	00000097          	auipc	ra,0x0
 2ac:	d58080e7          	jalr	-680(ra) # 0 <createfile>
    }
  }
  for(int i = 0; i < 2; i++){
    file[1] = '0' + i;
 2b0:	fc940ca3          	sb	s1,-39(s0)
    int pid = fork();
 2b4:	00000097          	auipc	ra,0x0
 2b8:	2c2080e7          	jalr	706(ra) # 576 <fork>
    if(pid < 0){
 2bc:	04054363          	bltz	a0,302 <test1+0xa6>
      printf("fork failed");
      exit();
    }
    if(pid == 0){
 2c0:	cd29                	beqz	a0,31a <test1+0xbe>
    file[1] = '0' + i;
 2c2:	03100793          	li	a5,49
 2c6:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
 2ca:	00000097          	auipc	ra,0x0
 2ce:	2ac080e7          	jalr	684(ra) # 576 <fork>
    if(pid < 0){
 2d2:	02054863          	bltz	a0,302 <test1+0xa6>
    if(pid == 0){
 2d6:	c925                	beqz	a0,346 <test1+0xea>
      exit();
    }
  }

  for(int i = 0; i < 2; i++){
    wait();
 2d8:	00000097          	auipc	ra,0x0
 2dc:	2ae080e7          	jalr	686(ra) # 586 <wait>
 2e0:	00000097          	auipc	ra,0x0
 2e4:	2a6080e7          	jalr	678(ra) # 586 <wait>
  }
  printf("test1 done\n");
 2e8:	00001517          	auipc	a0,0x1
 2ec:	89850513          	addi	a0,a0,-1896 # b80 <malloc+0x1ac>
 2f0:	00000097          	auipc	ra,0x0
 2f4:	626080e7          	jalr	1574(ra) # 916 <printf>
}
 2f8:	70a2                	ld	ra,40(sp)
 2fa:	7402                	ld	s0,32(sp)
 2fc:	64e2                	ld	s1,24(sp)
 2fe:	6145                	addi	sp,sp,48
 300:	8082                	ret
      printf("fork failed");
 302:	00001517          	auipc	a0,0x1
 306:	83e50513          	addi	a0,a0,-1986 # b40 <malloc+0x16c>
 30a:	00000097          	auipc	ra,0x0
 30e:	60c080e7          	jalr	1548(ra) # 916 <printf>
      exit();
 312:	00000097          	auipc	ra,0x0
 316:	26c080e7          	jalr	620(ra) # 57e <exit>
    if(pid == 0){
 31a:	3e800493          	li	s1,1000
          readfile(file, BIG);
 31e:	06400593          	li	a1,100
 322:	fd840513          	addi	a0,s0,-40
 326:	00000097          	auipc	ra,0x0
 32a:	d94080e7          	jalr	-620(ra) # ba <readfile>
        for (i = 0; i < N; i++) {
 32e:	34fd                	addiw	s1,s1,-1
 330:	f4fd                	bnez	s1,31e <test1+0xc2>
        unlink(file);
 332:	fd840513          	addi	a0,s0,-40
 336:	00000097          	auipc	ra,0x0
 33a:	298080e7          	jalr	664(ra) # 5ce <unlink>
        exit();
 33e:	00000097          	auipc	ra,0x0
 342:	240080e7          	jalr	576(ra) # 57e <exit>
 346:	3e800493          	li	s1,1000
          readfile(file, 1);
 34a:	4585                	li	a1,1
 34c:	fd840513          	addi	a0,s0,-40
 350:	00000097          	auipc	ra,0x0
 354:	d6a080e7          	jalr	-662(ra) # ba <readfile>
        for (i = 0; i < N; i++) {
 358:	34fd                	addiw	s1,s1,-1
 35a:	f8e5                	bnez	s1,34a <test1+0xee>
        unlink(file);
 35c:	fd840513          	addi	a0,s0,-40
 360:	00000097          	auipc	ra,0x0
 364:	26e080e7          	jalr	622(ra) # 5ce <unlink>
      exit();
 368:	00000097          	auipc	ra,0x0
 36c:	216080e7          	jalr	534(ra) # 57e <exit>

0000000000000370 <main>:
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  test0();
 378:	00000097          	auipc	ra,0x0
 37c:	dfa080e7          	jalr	-518(ra) # 172 <test0>
  test1();
 380:	00000097          	auipc	ra,0x0
 384:	edc080e7          	jalr	-292(ra) # 25c <test1>
  exit();
 388:	00000097          	auipc	ra,0x0
 38c:	1f6080e7          	jalr	502(ra) # 57e <exit>

0000000000000390 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 390:	1141                	addi	sp,sp,-16
 392:	e422                	sd	s0,8(sp)
 394:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 396:	87aa                	mv	a5,a0
 398:	0585                	addi	a1,a1,1
 39a:	0785                	addi	a5,a5,1
 39c:	fff5c703          	lbu	a4,-1(a1)
 3a0:	fee78fa3          	sb	a4,-1(a5)
 3a4:	fb75                	bnez	a4,398 <strcpy+0x8>
    ;
  return os;
}
 3a6:	6422                	ld	s0,8(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret

00000000000003ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e422                	sd	s0,8(sp)
 3b0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3b2:	00054783          	lbu	a5,0(a0)
 3b6:	cb91                	beqz	a5,3ca <strcmp+0x1e>
 3b8:	0005c703          	lbu	a4,0(a1)
 3bc:	00f71763          	bne	a4,a5,3ca <strcmp+0x1e>
    p++, q++;
 3c0:	0505                	addi	a0,a0,1
 3c2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3c4:	00054783          	lbu	a5,0(a0)
 3c8:	fbe5                	bnez	a5,3b8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 3ca:	0005c503          	lbu	a0,0(a1)
}
 3ce:	40a7853b          	subw	a0,a5,a0
 3d2:	6422                	ld	s0,8(sp)
 3d4:	0141                	addi	sp,sp,16
 3d6:	8082                	ret

00000000000003d8 <strlen>:

uint
strlen(const char *s)
{
 3d8:	1141                	addi	sp,sp,-16
 3da:	e422                	sd	s0,8(sp)
 3dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3de:	00054783          	lbu	a5,0(a0)
 3e2:	cf91                	beqz	a5,3fe <strlen+0x26>
 3e4:	0505                	addi	a0,a0,1
 3e6:	87aa                	mv	a5,a0
 3e8:	4685                	li	a3,1
 3ea:	9e89                	subw	a3,a3,a0
 3ec:	00f6853b          	addw	a0,a3,a5
 3f0:	0785                	addi	a5,a5,1
 3f2:	fff7c703          	lbu	a4,-1(a5)
 3f6:	fb7d                	bnez	a4,3ec <strlen+0x14>
    ;
  return n;
}
 3f8:	6422                	ld	s0,8(sp)
 3fa:	0141                	addi	sp,sp,16
 3fc:	8082                	ret
  for(n = 0; s[n]; n++)
 3fe:	4501                	li	a0,0
 400:	bfe5                	j	3f8 <strlen+0x20>

0000000000000402 <memset>:

void*
memset(void *dst, int c, uint n)
{
 402:	1141                	addi	sp,sp,-16
 404:	e422                	sd	s0,8(sp)
 406:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 408:	ca19                	beqz	a2,41e <memset+0x1c>
 40a:	87aa                	mv	a5,a0
 40c:	1602                	slli	a2,a2,0x20
 40e:	9201                	srli	a2,a2,0x20
 410:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 414:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 418:	0785                	addi	a5,a5,1
 41a:	fee79de3          	bne	a5,a4,414 <memset+0x12>
  }
  return dst;
}
 41e:	6422                	ld	s0,8(sp)
 420:	0141                	addi	sp,sp,16
 422:	8082                	ret

0000000000000424 <strchr>:

char*
strchr(const char *s, char c)
{
 424:	1141                	addi	sp,sp,-16
 426:	e422                	sd	s0,8(sp)
 428:	0800                	addi	s0,sp,16
  for(; *s; s++)
 42a:	00054783          	lbu	a5,0(a0)
 42e:	cb99                	beqz	a5,444 <strchr+0x20>
    if(*s == c)
 430:	00f58763          	beq	a1,a5,43e <strchr+0x1a>
  for(; *s; s++)
 434:	0505                	addi	a0,a0,1
 436:	00054783          	lbu	a5,0(a0)
 43a:	fbfd                	bnez	a5,430 <strchr+0xc>
      return (char*)s;
  return 0;
 43c:	4501                	li	a0,0
}
 43e:	6422                	ld	s0,8(sp)
 440:	0141                	addi	sp,sp,16
 442:	8082                	ret
  return 0;
 444:	4501                	li	a0,0
 446:	bfe5                	j	43e <strchr+0x1a>

0000000000000448 <gets>:

char*
gets(char *buf, int max)
{
 448:	711d                	addi	sp,sp,-96
 44a:	ec86                	sd	ra,88(sp)
 44c:	e8a2                	sd	s0,80(sp)
 44e:	e4a6                	sd	s1,72(sp)
 450:	e0ca                	sd	s2,64(sp)
 452:	fc4e                	sd	s3,56(sp)
 454:	f852                	sd	s4,48(sp)
 456:	f456                	sd	s5,40(sp)
 458:	f05a                	sd	s6,32(sp)
 45a:	ec5e                	sd	s7,24(sp)
 45c:	1080                	addi	s0,sp,96
 45e:	8baa                	mv	s7,a0
 460:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 462:	892a                	mv	s2,a0
 464:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 466:	4aa9                	li	s5,10
 468:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 46a:	89a6                	mv	s3,s1
 46c:	2485                	addiw	s1,s1,1
 46e:	0344d863          	bge	s1,s4,49e <gets+0x56>
    cc = read(0, &c, 1);
 472:	4605                	li	a2,1
 474:	faf40593          	addi	a1,s0,-81
 478:	4501                	li	a0,0
 47a:	00000097          	auipc	ra,0x0
 47e:	11c080e7          	jalr	284(ra) # 596 <read>
    if(cc < 1)
 482:	00a05e63          	blez	a0,49e <gets+0x56>
    buf[i++] = c;
 486:	faf44783          	lbu	a5,-81(s0)
 48a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 48e:	01578763          	beq	a5,s5,49c <gets+0x54>
 492:	0905                	addi	s2,s2,1
 494:	fd679be3          	bne	a5,s6,46a <gets+0x22>
  for(i=0; i+1 < max; ){
 498:	89a6                	mv	s3,s1
 49a:	a011                	j	49e <gets+0x56>
 49c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 49e:	99de                	add	s3,s3,s7
 4a0:	00098023          	sb	zero,0(s3)
  return buf;
}
 4a4:	855e                	mv	a0,s7
 4a6:	60e6                	ld	ra,88(sp)
 4a8:	6446                	ld	s0,80(sp)
 4aa:	64a6                	ld	s1,72(sp)
 4ac:	6906                	ld	s2,64(sp)
 4ae:	79e2                	ld	s3,56(sp)
 4b0:	7a42                	ld	s4,48(sp)
 4b2:	7aa2                	ld	s5,40(sp)
 4b4:	7b02                	ld	s6,32(sp)
 4b6:	6be2                	ld	s7,24(sp)
 4b8:	6125                	addi	sp,sp,96
 4ba:	8082                	ret

00000000000004bc <stat>:

int
stat(const char *n, struct stat *st)
{
 4bc:	1101                	addi	sp,sp,-32
 4be:	ec06                	sd	ra,24(sp)
 4c0:	e822                	sd	s0,16(sp)
 4c2:	e426                	sd	s1,8(sp)
 4c4:	e04a                	sd	s2,0(sp)
 4c6:	1000                	addi	s0,sp,32
 4c8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4ca:	4581                	li	a1,0
 4cc:	00000097          	auipc	ra,0x0
 4d0:	0f2080e7          	jalr	242(ra) # 5be <open>
  if(fd < 0)
 4d4:	02054563          	bltz	a0,4fe <stat+0x42>
 4d8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4da:	85ca                	mv	a1,s2
 4dc:	00000097          	auipc	ra,0x0
 4e0:	0fa080e7          	jalr	250(ra) # 5d6 <fstat>
 4e4:	892a                	mv	s2,a0
  close(fd);
 4e6:	8526                	mv	a0,s1
 4e8:	00000097          	auipc	ra,0x0
 4ec:	0be080e7          	jalr	190(ra) # 5a6 <close>
  return r;
}
 4f0:	854a                	mv	a0,s2
 4f2:	60e2                	ld	ra,24(sp)
 4f4:	6442                	ld	s0,16(sp)
 4f6:	64a2                	ld	s1,8(sp)
 4f8:	6902                	ld	s2,0(sp)
 4fa:	6105                	addi	sp,sp,32
 4fc:	8082                	ret
    return -1;
 4fe:	597d                	li	s2,-1
 500:	bfc5                	j	4f0 <stat+0x34>

0000000000000502 <atoi>:

int
atoi(const char *s)
{
 502:	1141                	addi	sp,sp,-16
 504:	e422                	sd	s0,8(sp)
 506:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 508:	00054603          	lbu	a2,0(a0)
 50c:	fd06079b          	addiw	a5,a2,-48
 510:	0ff7f793          	andi	a5,a5,255
 514:	4725                	li	a4,9
 516:	02f76963          	bltu	a4,a5,548 <atoi+0x46>
 51a:	86aa                	mv	a3,a0
  n = 0;
 51c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 51e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 520:	0685                	addi	a3,a3,1
 522:	0025179b          	slliw	a5,a0,0x2
 526:	9fa9                	addw	a5,a5,a0
 528:	0017979b          	slliw	a5,a5,0x1
 52c:	9fb1                	addw	a5,a5,a2
 52e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 532:	0006c603          	lbu	a2,0(a3)
 536:	fd06071b          	addiw	a4,a2,-48
 53a:	0ff77713          	andi	a4,a4,255
 53e:	fee5f1e3          	bgeu	a1,a4,520 <atoi+0x1e>
  return n;
}
 542:	6422                	ld	s0,8(sp)
 544:	0141                	addi	sp,sp,16
 546:	8082                	ret
  n = 0;
 548:	4501                	li	a0,0
 54a:	bfe5                	j	542 <atoi+0x40>

000000000000054c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 54c:	1141                	addi	sp,sp,-16
 54e:	e422                	sd	s0,8(sp)
 550:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 552:	00c05f63          	blez	a2,570 <memmove+0x24>
 556:	1602                	slli	a2,a2,0x20
 558:	9201                	srli	a2,a2,0x20
 55a:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 55e:	87aa                	mv	a5,a0
    *dst++ = *src++;
 560:	0585                	addi	a1,a1,1
 562:	0785                	addi	a5,a5,1
 564:	fff5c703          	lbu	a4,-1(a1)
 568:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 56c:	fed79ae3          	bne	a5,a3,560 <memmove+0x14>
  return vdst;
}
 570:	6422                	ld	s0,8(sp)
 572:	0141                	addi	sp,sp,16
 574:	8082                	ret

0000000000000576 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 576:	4885                	li	a7,1
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <exit>:
.global exit
exit:
 li a7, SYS_exit
 57e:	4889                	li	a7,2
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <wait>:
.global wait
wait:
 li a7, SYS_wait
 586:	488d                	li	a7,3
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 58e:	4891                	li	a7,4
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <read>:
.global read
read:
 li a7, SYS_read
 596:	4895                	li	a7,5
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <write>:
.global write
write:
 li a7, SYS_write
 59e:	48c1                	li	a7,16
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <close>:
.global close
close:
 li a7, SYS_close
 5a6:	48d5                	li	a7,21
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 5ae:	4899                	li	a7,6
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5b6:	489d                	li	a7,7
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <open>:
.global open
open:
 li a7, SYS_open
 5be:	48bd                	li	a7,15
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5c6:	48c5                	li	a7,17
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5ce:	48c9                	li	a7,18
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5d6:	48a1                	li	a7,8
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <link>:
.global link
link:
 li a7, SYS_link
 5de:	48cd                	li	a7,19
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5e6:	48d1                	li	a7,20
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5ee:	48a5                	li	a7,9
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5f6:	48a9                	li	a7,10
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5fe:	48ad                	li	a7,11
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 606:	48b1                	li	a7,12
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 60e:	48b5                	li	a7,13
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 616:	48b9                	li	a7,14
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 61e:	48d9                	li	a7,22
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <crash>:
.global crash
crash:
 li a7, SYS_crash
 626:	48dd                	li	a7,23
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <mount>:
.global mount
mount:
 li a7, SYS_mount
 62e:	48e1                	li	a7,24
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <umount>:
.global umount
umount:
 li a7, SYS_umount
 636:	48e5                	li	a7,25
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 63e:	1101                	addi	sp,sp,-32
 640:	ec06                	sd	ra,24(sp)
 642:	e822                	sd	s0,16(sp)
 644:	1000                	addi	s0,sp,32
 646:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 64a:	4605                	li	a2,1
 64c:	fef40593          	addi	a1,s0,-17
 650:	00000097          	auipc	ra,0x0
 654:	f4e080e7          	jalr	-178(ra) # 59e <write>
}
 658:	60e2                	ld	ra,24(sp)
 65a:	6442                	ld	s0,16(sp)
 65c:	6105                	addi	sp,sp,32
 65e:	8082                	ret

0000000000000660 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 660:	7139                	addi	sp,sp,-64
 662:	fc06                	sd	ra,56(sp)
 664:	f822                	sd	s0,48(sp)
 666:	f426                	sd	s1,40(sp)
 668:	f04a                	sd	s2,32(sp)
 66a:	ec4e                	sd	s3,24(sp)
 66c:	0080                	addi	s0,sp,64
 66e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 670:	c299                	beqz	a3,676 <printint+0x16>
 672:	0805c863          	bltz	a1,702 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 676:	2581                	sext.w	a1,a1
  neg = 0;
 678:	4881                	li	a7,0
 67a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 67e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 680:	2601                	sext.w	a2,a2
 682:	00000517          	auipc	a0,0x0
 686:	51650513          	addi	a0,a0,1302 # b98 <digits>
 68a:	883a                	mv	a6,a4
 68c:	2705                	addiw	a4,a4,1
 68e:	02c5f7bb          	remuw	a5,a1,a2
 692:	1782                	slli	a5,a5,0x20
 694:	9381                	srli	a5,a5,0x20
 696:	97aa                	add	a5,a5,a0
 698:	0007c783          	lbu	a5,0(a5)
 69c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6a0:	0005879b          	sext.w	a5,a1
 6a4:	02c5d5bb          	divuw	a1,a1,a2
 6a8:	0685                	addi	a3,a3,1
 6aa:	fec7f0e3          	bgeu	a5,a2,68a <printint+0x2a>
  if(neg)
 6ae:	00088b63          	beqz	a7,6c4 <printint+0x64>
    buf[i++] = '-';
 6b2:	fd040793          	addi	a5,s0,-48
 6b6:	973e                	add	a4,a4,a5
 6b8:	02d00793          	li	a5,45
 6bc:	fef70823          	sb	a5,-16(a4)
 6c0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6c4:	02e05863          	blez	a4,6f4 <printint+0x94>
 6c8:	fc040793          	addi	a5,s0,-64
 6cc:	00e78933          	add	s2,a5,a4
 6d0:	fff78993          	addi	s3,a5,-1
 6d4:	99ba                	add	s3,s3,a4
 6d6:	377d                	addiw	a4,a4,-1
 6d8:	1702                	slli	a4,a4,0x20
 6da:	9301                	srli	a4,a4,0x20
 6dc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6e0:	fff94583          	lbu	a1,-1(s2)
 6e4:	8526                	mv	a0,s1
 6e6:	00000097          	auipc	ra,0x0
 6ea:	f58080e7          	jalr	-168(ra) # 63e <putc>
  while(--i >= 0)
 6ee:	197d                	addi	s2,s2,-1
 6f0:	ff3918e3          	bne	s2,s3,6e0 <printint+0x80>
}
 6f4:	70e2                	ld	ra,56(sp)
 6f6:	7442                	ld	s0,48(sp)
 6f8:	74a2                	ld	s1,40(sp)
 6fa:	7902                	ld	s2,32(sp)
 6fc:	69e2                	ld	s3,24(sp)
 6fe:	6121                	addi	sp,sp,64
 700:	8082                	ret
    x = -xx;
 702:	40b005bb          	negw	a1,a1
    neg = 1;
 706:	4885                	li	a7,1
    x = -xx;
 708:	bf8d                	j	67a <printint+0x1a>

000000000000070a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 70a:	7119                	addi	sp,sp,-128
 70c:	fc86                	sd	ra,120(sp)
 70e:	f8a2                	sd	s0,112(sp)
 710:	f4a6                	sd	s1,104(sp)
 712:	f0ca                	sd	s2,96(sp)
 714:	ecce                	sd	s3,88(sp)
 716:	e8d2                	sd	s4,80(sp)
 718:	e4d6                	sd	s5,72(sp)
 71a:	e0da                	sd	s6,64(sp)
 71c:	fc5e                	sd	s7,56(sp)
 71e:	f862                	sd	s8,48(sp)
 720:	f466                	sd	s9,40(sp)
 722:	f06a                	sd	s10,32(sp)
 724:	ec6e                	sd	s11,24(sp)
 726:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 728:	0005c903          	lbu	s2,0(a1)
 72c:	18090f63          	beqz	s2,8ca <vprintf+0x1c0>
 730:	8aaa                	mv	s5,a0
 732:	8b32                	mv	s6,a2
 734:	00158493          	addi	s1,a1,1
  state = 0;
 738:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 73a:	02500a13          	li	s4,37
      if(c == 'd'){
 73e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 742:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 746:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 74a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 74e:	00000b97          	auipc	s7,0x0
 752:	44ab8b93          	addi	s7,s7,1098 # b98 <digits>
 756:	a839                	j	774 <vprintf+0x6a>
        putc(fd, c);
 758:	85ca                	mv	a1,s2
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	ee2080e7          	jalr	-286(ra) # 63e <putc>
 764:	a019                	j	76a <vprintf+0x60>
    } else if(state == '%'){
 766:	01498f63          	beq	s3,s4,784 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 76a:	0485                	addi	s1,s1,1
 76c:	fff4c903          	lbu	s2,-1(s1)
 770:	14090d63          	beqz	s2,8ca <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 774:	0009079b          	sext.w	a5,s2
    if(state == 0){
 778:	fe0997e3          	bnez	s3,766 <vprintf+0x5c>
      if(c == '%'){
 77c:	fd479ee3          	bne	a5,s4,758 <vprintf+0x4e>
        state = '%';
 780:	89be                	mv	s3,a5
 782:	b7e5                	j	76a <vprintf+0x60>
      if(c == 'd'){
 784:	05878063          	beq	a5,s8,7c4 <vprintf+0xba>
      } else if(c == 'l') {
 788:	05978c63          	beq	a5,s9,7e0 <vprintf+0xd6>
      } else if(c == 'x') {
 78c:	07a78863          	beq	a5,s10,7fc <vprintf+0xf2>
      } else if(c == 'p') {
 790:	09b78463          	beq	a5,s11,818 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 794:	07300713          	li	a4,115
 798:	0ce78663          	beq	a5,a4,864 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 79c:	06300713          	li	a4,99
 7a0:	0ee78e63          	beq	a5,a4,89c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 7a4:	11478863          	beq	a5,s4,8b4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7a8:	85d2                	mv	a1,s4
 7aa:	8556                	mv	a0,s5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	e92080e7          	jalr	-366(ra) # 63e <putc>
        putc(fd, c);
 7b4:	85ca                	mv	a1,s2
 7b6:	8556                	mv	a0,s5
 7b8:	00000097          	auipc	ra,0x0
 7bc:	e86080e7          	jalr	-378(ra) # 63e <putc>
      }
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b765                	j	76a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7c4:	008b0913          	addi	s2,s6,8
 7c8:	4685                	li	a3,1
 7ca:	4629                	li	a2,10
 7cc:	000b2583          	lw	a1,0(s6)
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e8e080e7          	jalr	-370(ra) # 660 <printint>
 7da:	8b4a                	mv	s6,s2
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	b771                	j	76a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e0:	008b0913          	addi	s2,s6,8
 7e4:	4681                	li	a3,0
 7e6:	4629                	li	a2,10
 7e8:	000b2583          	lw	a1,0(s6)
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	e72080e7          	jalr	-398(ra) # 660 <printint>
 7f6:	8b4a                	mv	s6,s2
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	bf85                	j	76a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7fc:	008b0913          	addi	s2,s6,8
 800:	4681                	li	a3,0
 802:	4641                	li	a2,16
 804:	000b2583          	lw	a1,0(s6)
 808:	8556                	mv	a0,s5
 80a:	00000097          	auipc	ra,0x0
 80e:	e56080e7          	jalr	-426(ra) # 660 <printint>
 812:	8b4a                	mv	s6,s2
      state = 0;
 814:	4981                	li	s3,0
 816:	bf91                	j	76a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 818:	008b0793          	addi	a5,s6,8
 81c:	f8f43423          	sd	a5,-120(s0)
 820:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 824:	03000593          	li	a1,48
 828:	8556                	mv	a0,s5
 82a:	00000097          	auipc	ra,0x0
 82e:	e14080e7          	jalr	-492(ra) # 63e <putc>
  putc(fd, 'x');
 832:	85ea                	mv	a1,s10
 834:	8556                	mv	a0,s5
 836:	00000097          	auipc	ra,0x0
 83a:	e08080e7          	jalr	-504(ra) # 63e <putc>
 83e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 840:	03c9d793          	srli	a5,s3,0x3c
 844:	97de                	add	a5,a5,s7
 846:	0007c583          	lbu	a1,0(a5)
 84a:	8556                	mv	a0,s5
 84c:	00000097          	auipc	ra,0x0
 850:	df2080e7          	jalr	-526(ra) # 63e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 854:	0992                	slli	s3,s3,0x4
 856:	397d                	addiw	s2,s2,-1
 858:	fe0914e3          	bnez	s2,840 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 85c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 860:	4981                	li	s3,0
 862:	b721                	j	76a <vprintf+0x60>
        s = va_arg(ap, char*);
 864:	008b0993          	addi	s3,s6,8
 868:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 86c:	02090163          	beqz	s2,88e <vprintf+0x184>
        while(*s != 0){
 870:	00094583          	lbu	a1,0(s2)
 874:	c9a1                	beqz	a1,8c4 <vprintf+0x1ba>
          putc(fd, *s);
 876:	8556                	mv	a0,s5
 878:	00000097          	auipc	ra,0x0
 87c:	dc6080e7          	jalr	-570(ra) # 63e <putc>
          s++;
 880:	0905                	addi	s2,s2,1
        while(*s != 0){
 882:	00094583          	lbu	a1,0(s2)
 886:	f9e5                	bnez	a1,876 <vprintf+0x16c>
        s = va_arg(ap, char*);
 888:	8b4e                	mv	s6,s3
      state = 0;
 88a:	4981                	li	s3,0
 88c:	bdf9                	j	76a <vprintf+0x60>
          s = "(null)";
 88e:	00000917          	auipc	s2,0x0
 892:	30290913          	addi	s2,s2,770 # b90 <malloc+0x1bc>
        while(*s != 0){
 896:	02800593          	li	a1,40
 89a:	bff1                	j	876 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 89c:	008b0913          	addi	s2,s6,8
 8a0:	000b4583          	lbu	a1,0(s6)
 8a4:	8556                	mv	a0,s5
 8a6:	00000097          	auipc	ra,0x0
 8aa:	d98080e7          	jalr	-616(ra) # 63e <putc>
 8ae:	8b4a                	mv	s6,s2
      state = 0;
 8b0:	4981                	li	s3,0
 8b2:	bd65                	j	76a <vprintf+0x60>
        putc(fd, c);
 8b4:	85d2                	mv	a1,s4
 8b6:	8556                	mv	a0,s5
 8b8:	00000097          	auipc	ra,0x0
 8bc:	d86080e7          	jalr	-634(ra) # 63e <putc>
      state = 0;
 8c0:	4981                	li	s3,0
 8c2:	b565                	j	76a <vprintf+0x60>
        s = va_arg(ap, char*);
 8c4:	8b4e                	mv	s6,s3
      state = 0;
 8c6:	4981                	li	s3,0
 8c8:	b54d                	j	76a <vprintf+0x60>
    }
  }
}
 8ca:	70e6                	ld	ra,120(sp)
 8cc:	7446                	ld	s0,112(sp)
 8ce:	74a6                	ld	s1,104(sp)
 8d0:	7906                	ld	s2,96(sp)
 8d2:	69e6                	ld	s3,88(sp)
 8d4:	6a46                	ld	s4,80(sp)
 8d6:	6aa6                	ld	s5,72(sp)
 8d8:	6b06                	ld	s6,64(sp)
 8da:	7be2                	ld	s7,56(sp)
 8dc:	7c42                	ld	s8,48(sp)
 8de:	7ca2                	ld	s9,40(sp)
 8e0:	7d02                	ld	s10,32(sp)
 8e2:	6de2                	ld	s11,24(sp)
 8e4:	6109                	addi	sp,sp,128
 8e6:	8082                	ret

00000000000008e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8e8:	715d                	addi	sp,sp,-80
 8ea:	ec06                	sd	ra,24(sp)
 8ec:	e822                	sd	s0,16(sp)
 8ee:	1000                	addi	s0,sp,32
 8f0:	e010                	sd	a2,0(s0)
 8f2:	e414                	sd	a3,8(s0)
 8f4:	e818                	sd	a4,16(s0)
 8f6:	ec1c                	sd	a5,24(s0)
 8f8:	03043023          	sd	a6,32(s0)
 8fc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 900:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 904:	8622                	mv	a2,s0
 906:	00000097          	auipc	ra,0x0
 90a:	e04080e7          	jalr	-508(ra) # 70a <vprintf>
}
 90e:	60e2                	ld	ra,24(sp)
 910:	6442                	ld	s0,16(sp)
 912:	6161                	addi	sp,sp,80
 914:	8082                	ret

0000000000000916 <printf>:

void
printf(const char *fmt, ...)
{
 916:	711d                	addi	sp,sp,-96
 918:	ec06                	sd	ra,24(sp)
 91a:	e822                	sd	s0,16(sp)
 91c:	1000                	addi	s0,sp,32
 91e:	e40c                	sd	a1,8(s0)
 920:	e810                	sd	a2,16(s0)
 922:	ec14                	sd	a3,24(s0)
 924:	f018                	sd	a4,32(s0)
 926:	f41c                	sd	a5,40(s0)
 928:	03043823          	sd	a6,48(s0)
 92c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 930:	00840613          	addi	a2,s0,8
 934:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 938:	85aa                	mv	a1,a0
 93a:	4505                	li	a0,1
 93c:	00000097          	auipc	ra,0x0
 940:	dce080e7          	jalr	-562(ra) # 70a <vprintf>
}
 944:	60e2                	ld	ra,24(sp)
 946:	6442                	ld	s0,16(sp)
 948:	6125                	addi	sp,sp,96
 94a:	8082                	ret

000000000000094c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 94c:	1141                	addi	sp,sp,-16
 94e:	e422                	sd	s0,8(sp)
 950:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 952:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 956:	00000797          	auipc	a5,0x0
 95a:	25a7b783          	ld	a5,602(a5) # bb0 <freep>
 95e:	a805                	j	98e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 960:	4618                	lw	a4,8(a2)
 962:	9db9                	addw	a1,a1,a4
 964:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 968:	6398                	ld	a4,0(a5)
 96a:	6318                	ld	a4,0(a4)
 96c:	fee53823          	sd	a4,-16(a0)
 970:	a091                	j	9b4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 972:	ff852703          	lw	a4,-8(a0)
 976:	9e39                	addw	a2,a2,a4
 978:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 97a:	ff053703          	ld	a4,-16(a0)
 97e:	e398                	sd	a4,0(a5)
 980:	a099                	j	9c6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 982:	6398                	ld	a4,0(a5)
 984:	00e7e463          	bltu	a5,a4,98c <free+0x40>
 988:	00e6ea63          	bltu	a3,a4,99c <free+0x50>
{
 98c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 98e:	fed7fae3          	bgeu	a5,a3,982 <free+0x36>
 992:	6398                	ld	a4,0(a5)
 994:	00e6e463          	bltu	a3,a4,99c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 998:	fee7eae3          	bltu	a5,a4,98c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 99c:	ff852583          	lw	a1,-8(a0)
 9a0:	6390                	ld	a2,0(a5)
 9a2:	02059813          	slli	a6,a1,0x20
 9a6:	01c85713          	srli	a4,a6,0x1c
 9aa:	9736                	add	a4,a4,a3
 9ac:	fae60ae3          	beq	a2,a4,960 <free+0x14>
    bp->s.ptr = p->s.ptr;
 9b0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9b4:	4790                	lw	a2,8(a5)
 9b6:	02061593          	slli	a1,a2,0x20
 9ba:	01c5d713          	srli	a4,a1,0x1c
 9be:	973e                	add	a4,a4,a5
 9c0:	fae689e3          	beq	a3,a4,972 <free+0x26>
  } else
    p->s.ptr = bp;
 9c4:	e394                	sd	a3,0(a5)
  freep = p;
 9c6:	00000717          	auipc	a4,0x0
 9ca:	1ef73523          	sd	a5,490(a4) # bb0 <freep>
}
 9ce:	6422                	ld	s0,8(sp)
 9d0:	0141                	addi	sp,sp,16
 9d2:	8082                	ret

00000000000009d4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9d4:	7139                	addi	sp,sp,-64
 9d6:	fc06                	sd	ra,56(sp)
 9d8:	f822                	sd	s0,48(sp)
 9da:	f426                	sd	s1,40(sp)
 9dc:	f04a                	sd	s2,32(sp)
 9de:	ec4e                	sd	s3,24(sp)
 9e0:	e852                	sd	s4,16(sp)
 9e2:	e456                	sd	s5,8(sp)
 9e4:	e05a                	sd	s6,0(sp)
 9e6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e8:	02051493          	slli	s1,a0,0x20
 9ec:	9081                	srli	s1,s1,0x20
 9ee:	04bd                	addi	s1,s1,15
 9f0:	8091                	srli	s1,s1,0x4
 9f2:	0014899b          	addiw	s3,s1,1
 9f6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9f8:	00000517          	auipc	a0,0x0
 9fc:	1b853503          	ld	a0,440(a0) # bb0 <freep>
 a00:	c515                	beqz	a0,a2c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a02:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a04:	4798                	lw	a4,8(a5)
 a06:	02977f63          	bgeu	a4,s1,a44 <malloc+0x70>
 a0a:	8a4e                	mv	s4,s3
 a0c:	0009871b          	sext.w	a4,s3
 a10:	6685                	lui	a3,0x1
 a12:	00d77363          	bgeu	a4,a3,a18 <malloc+0x44>
 a16:	6a05                	lui	s4,0x1
 a18:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a1c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a20:	00000917          	auipc	s2,0x0
 a24:	19090913          	addi	s2,s2,400 # bb0 <freep>
  if(p == (char*)-1)
 a28:	5afd                	li	s5,-1
 a2a:	a895                	j	a9e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a2c:	00000797          	auipc	a5,0x0
 a30:	18c78793          	addi	a5,a5,396 # bb8 <base>
 a34:	00000717          	auipc	a4,0x0
 a38:	16f73e23          	sd	a5,380(a4) # bb0 <freep>
 a3c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a3e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a42:	b7e1                	j	a0a <malloc+0x36>
      if(p->s.size == nunits)
 a44:	02e48c63          	beq	s1,a4,a7c <malloc+0xa8>
        p->s.size -= nunits;
 a48:	4137073b          	subw	a4,a4,s3
 a4c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a4e:	02071693          	slli	a3,a4,0x20
 a52:	01c6d713          	srli	a4,a3,0x1c
 a56:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a58:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a5c:	00000717          	auipc	a4,0x0
 a60:	14a73a23          	sd	a0,340(a4) # bb0 <freep>
      return (void*)(p + 1);
 a64:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a68:	70e2                	ld	ra,56(sp)
 a6a:	7442                	ld	s0,48(sp)
 a6c:	74a2                	ld	s1,40(sp)
 a6e:	7902                	ld	s2,32(sp)
 a70:	69e2                	ld	s3,24(sp)
 a72:	6a42                	ld	s4,16(sp)
 a74:	6aa2                	ld	s5,8(sp)
 a76:	6b02                	ld	s6,0(sp)
 a78:	6121                	addi	sp,sp,64
 a7a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a7c:	6398                	ld	a4,0(a5)
 a7e:	e118                	sd	a4,0(a0)
 a80:	bff1                	j	a5c <malloc+0x88>
  hp->s.size = nu;
 a82:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a86:	0541                	addi	a0,a0,16
 a88:	00000097          	auipc	ra,0x0
 a8c:	ec4080e7          	jalr	-316(ra) # 94c <free>
  return freep;
 a90:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a94:	d971                	beqz	a0,a68 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a96:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a98:	4798                	lw	a4,8(a5)
 a9a:	fa9775e3          	bgeu	a4,s1,a44 <malloc+0x70>
    if(p == freep)
 a9e:	00093703          	ld	a4,0(s2)
 aa2:	853e                	mv	a0,a5
 aa4:	fef719e3          	bne	a4,a5,a96 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 aa8:	8552                	mv	a0,s4
 aaa:	00000097          	auipc	ra,0x0
 aae:	b5c080e7          	jalr	-1188(ra) # 606 <sbrk>
  if(p == (char*)-1)
 ab2:	fd5518e3          	bne	a0,s5,a82 <malloc+0xae>
        return 0;
 ab6:	4501                	li	a0,0
 ab8:	bf45                	j	a68 <malloc+0x94>
