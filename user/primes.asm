
user/_primes：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <isPrime>:
#include "kernel/types.h"
#include "user/user.h"

void 
isPrime()
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
    int len,prime,num;
    int fd[2];
    if((len = read(0, &prime, sizeof(prime))) <= 0){
   8:	4611                	li	a2,4
   a:	fec40593          	addi	a1,s0,-20
   e:	4501                	li	a0,0
  10:	00000097          	auipc	ra,0x0
  14:	3d0080e7          	jalr	976(ra) # 3e0 <read>
  18:	08a05863          	blez	a0,a8 <isPrime+0xa8>
        close(0);
        close(1);
        exit();     //没有数据了直接退出
    }
    printf("prime %d\n",prime);
  1c:	fec42583          	lw	a1,-20(s0)
  20:	00001517          	auipc	a0,0x1
  24:	8e850513          	addi	a0,a0,-1816 # 908 <malloc+0xea>
  28:	00000097          	auipc	ra,0x0
  2c:	738080e7          	jalr	1848(ra) # 760 <printf>

    pipe(fd);       //建立当前进程与子进程的pipe
  30:	fe040513          	addi	a0,s0,-32
  34:	00000097          	auipc	ra,0x0
  38:	3a4080e7          	jalr	932(ra) # 3d8 <pipe>
    if(fork() == 0){
  3c:	00000097          	auipc	ra,0x0
  40:	384080e7          	jalr	900(ra) # 3c0 <fork>
  44:	c141                	beqz	a0,c4 <isPrime+0xc4>
        dup(fd[0]);
        close(fd[0]);
        close(fd[1]);   
        isPrime();
    }
    close(1);
  46:	4505                	li	a0,1
  48:	00000097          	auipc	ra,0x0
  4c:	3a8080e7          	jalr	936(ra) # 3f0 <close>
    dup(fd[1]);
  50:	fe442503          	lw	a0,-28(s0)
  54:	00000097          	auipc	ra,0x0
  58:	3ec080e7          	jalr	1004(ra) # 440 <dup>
    close(fd[0]);
  5c:	fe042503          	lw	a0,-32(s0)
  60:	00000097          	auipc	ra,0x0
  64:	390080e7          	jalr	912(ra) # 3f0 <close>
    close(fd[1]);
  68:	fe442503          	lw	a0,-28(s0)
  6c:	00000097          	auipc	ra,0x0
  70:	384080e7          	jalr	900(ra) # 3f0 <close>
    while((len = read(0, &num, sizeof(num))) > 0){
  74:	4611                	li	a2,4
  76:	fe840593          	addi	a1,s0,-24
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	364080e7          	jalr	868(ra) # 3e0 <read>
  84:	06a05a63          	blez	a0,f8 <isPrime+0xf8>
        if(num % prime != 0){
  88:	fe842783          	lw	a5,-24(s0)
  8c:	fec42703          	lw	a4,-20(s0)
  90:	02e7e7bb          	remw	a5,a5,a4
  94:	d3e5                	beqz	a5,74 <isPrime+0x74>
            write(1, &num, sizeof(num));
  96:	4611                	li	a2,4
  98:	fe840593          	addi	a1,s0,-24
  9c:	4505                	li	a0,1
  9e:	00000097          	auipc	ra,0x0
  a2:	34a080e7          	jalr	842(ra) # 3e8 <write>
  a6:	b7f9                	j	74 <isPrime+0x74>
        close(0);
  a8:	4501                	li	a0,0
  aa:	00000097          	auipc	ra,0x0
  ae:	346080e7          	jalr	838(ra) # 3f0 <close>
        close(1);
  b2:	4505                	li	a0,1
  b4:	00000097          	auipc	ra,0x0
  b8:	33c080e7          	jalr	828(ra) # 3f0 <close>
        exit();     //没有数据了直接退出
  bc:	00000097          	auipc	ra,0x0
  c0:	30c080e7          	jalr	780(ra) # 3c8 <exit>
        close(0);
  c4:	00000097          	auipc	ra,0x0
  c8:	32c080e7          	jalr	812(ra) # 3f0 <close>
        dup(fd[0]);
  cc:	fe042503          	lw	a0,-32(s0)
  d0:	00000097          	auipc	ra,0x0
  d4:	370080e7          	jalr	880(ra) # 440 <dup>
        close(fd[0]);
  d8:	fe042503          	lw	a0,-32(s0)
  dc:	00000097          	auipc	ra,0x0
  e0:	314080e7          	jalr	788(ra) # 3f0 <close>
        close(fd[1]);   
  e4:	fe442503          	lw	a0,-28(s0)
  e8:	00000097          	auipc	ra,0x0
  ec:	308080e7          	jalr	776(ra) # 3f0 <close>
        isPrime();
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <isPrime>
        }
    }
    close(1);
  f8:	4505                	li	a0,1
  fa:	00000097          	auipc	ra,0x0
  fe:	2f6080e7          	jalr	758(ra) # 3f0 <close>
    wait();
 102:	00000097          	auipc	ra,0x0
 106:	2ce080e7          	jalr	718(ra) # 3d0 <wait>
    exit();
 10a:	00000097          	auipc	ra,0x0
 10e:	2be080e7          	jalr	702(ra) # 3c8 <exit>

0000000000000112 <main>:
}

int 
main(int argc, char *argv[])
{
 112:	7179                	addi	sp,sp,-48
 114:	f406                	sd	ra,40(sp)
 116:	f022                	sd	s0,32(sp)
 118:	ec26                	sd	s1,24(sp)
 11a:	1800                	addi	s0,sp,48
    int i;
    int fd[2];
    pipe(fd);       //建立当前进程与子进程的pipe
 11c:	fd040513          	addi	a0,s0,-48
 120:	00000097          	auipc	ra,0x0
 124:	2b8080e7          	jalr	696(ra) # 3d8 <pipe>
    if(fork() == 0){
 128:	00000097          	auipc	ra,0x0
 12c:	298080e7          	jalr	664(ra) # 3c0 <fork>
 130:	e91d                	bnez	a0,166 <main+0x54>
        close(0);
 132:	00000097          	auipc	ra,0x0
 136:	2be080e7          	jalr	702(ra) # 3f0 <close>
        dup(fd[0]);
 13a:	fd042503          	lw	a0,-48(s0)
 13e:	00000097          	auipc	ra,0x0
 142:	302080e7          	jalr	770(ra) # 440 <dup>
        close(fd[0]);
 146:	fd042503          	lw	a0,-48(s0)
 14a:	00000097          	auipc	ra,0x0
 14e:	2a6080e7          	jalr	678(ra) # 3f0 <close>
        close(fd[1]);
 152:	fd442503          	lw	a0,-44(s0)
 156:	00000097          	auipc	ra,0x0
 15a:	29a080e7          	jalr	666(ra) # 3f0 <close>
        isPrime();
 15e:	00000097          	auipc	ra,0x0
 162:	ea2080e7          	jalr	-350(ra) # 0 <isPrime>
    }
    close(1);
 166:	4505                	li	a0,1
 168:	00000097          	auipc	ra,0x0
 16c:	288080e7          	jalr	648(ra) # 3f0 <close>
    dup(fd[1]);     //fd[0]读端,fd[1]写端
 170:	fd442503          	lw	a0,-44(s0)
 174:	00000097          	auipc	ra,0x0
 178:	2cc080e7          	jalr	716(ra) # 440 <dup>
    close(fd[0]);
 17c:	fd042503          	lw	a0,-48(s0)
 180:	00000097          	auipc	ra,0x0
 184:	270080e7          	jalr	624(ra) # 3f0 <close>
    close(fd[1]);
 188:	fd442503          	lw	a0,-44(s0)
 18c:	00000097          	auipc	ra,0x0
 190:	264080e7          	jalr	612(ra) # 3f0 <close>
    //写入初始数据
    for(i = 2;i < 36;i++){
 194:	4789                	li	a5,2
 196:	fcf42e23          	sw	a5,-36(s0)
 19a:	02300493          	li	s1,35
        write(1, &i, sizeof(i));
 19e:	4611                	li	a2,4
 1a0:	fdc40593          	addi	a1,s0,-36
 1a4:	4505                	li	a0,1
 1a6:	00000097          	auipc	ra,0x0
 1aa:	242080e7          	jalr	578(ra) # 3e8 <write>
    for(i = 2;i < 36;i++){
 1ae:	fdc42783          	lw	a5,-36(s0)
 1b2:	2785                	addiw	a5,a5,1
 1b4:	0007871b          	sext.w	a4,a5
 1b8:	fcf42e23          	sw	a5,-36(s0)
 1bc:	fee4d1e3          	bge	s1,a4,19e <main+0x8c>
    }
    close(1);
 1c0:	4505                	li	a0,1
 1c2:	00000097          	auipc	ra,0x0
 1c6:	22e080e7          	jalr	558(ra) # 3f0 <close>
    wait();
 1ca:	00000097          	auipc	ra,0x0
 1ce:	206080e7          	jalr	518(ra) # 3d0 <wait>
    exit();
 1d2:	00000097          	auipc	ra,0x0
 1d6:	1f6080e7          	jalr	502(ra) # 3c8 <exit>

00000000000001da <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1e0:	87aa                	mv	a5,a0
 1e2:	0585                	addi	a1,a1,1
 1e4:	0785                	addi	a5,a5,1
 1e6:	fff5c703          	lbu	a4,-1(a1)
 1ea:	fee78fa3          	sb	a4,-1(a5)
 1ee:	fb75                	bnez	a4,1e2 <strcpy+0x8>
    ;
  return os;
}
 1f0:	6422                	ld	s0,8(sp)
 1f2:	0141                	addi	sp,sp,16
 1f4:	8082                	ret

00000000000001f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e422                	sd	s0,8(sp)
 1fa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1fc:	00054783          	lbu	a5,0(a0)
 200:	cb91                	beqz	a5,214 <strcmp+0x1e>
 202:	0005c703          	lbu	a4,0(a1)
 206:	00f71763          	bne	a4,a5,214 <strcmp+0x1e>
    p++, q++;
 20a:	0505                	addi	a0,a0,1
 20c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 20e:	00054783          	lbu	a5,0(a0)
 212:	fbe5                	bnez	a5,202 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 214:	0005c503          	lbu	a0,0(a1)
}
 218:	40a7853b          	subw	a0,a5,a0
 21c:	6422                	ld	s0,8(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret

0000000000000222 <strlen>:

uint
strlen(const char *s)
{
 222:	1141                	addi	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 228:	00054783          	lbu	a5,0(a0)
 22c:	cf91                	beqz	a5,248 <strlen+0x26>
 22e:	0505                	addi	a0,a0,1
 230:	87aa                	mv	a5,a0
 232:	4685                	li	a3,1
 234:	9e89                	subw	a3,a3,a0
 236:	00f6853b          	addw	a0,a3,a5
 23a:	0785                	addi	a5,a5,1
 23c:	fff7c703          	lbu	a4,-1(a5)
 240:	fb7d                	bnez	a4,236 <strlen+0x14>
    ;
  return n;
}
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
  for(n = 0; s[n]; n++)
 248:	4501                	li	a0,0
 24a:	bfe5                	j	242 <strlen+0x20>

000000000000024c <memset>:

void*
memset(void *dst, int c, uint n)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 252:	ca19                	beqz	a2,268 <memset+0x1c>
 254:	87aa                	mv	a5,a0
 256:	1602                	slli	a2,a2,0x20
 258:	9201                	srli	a2,a2,0x20
 25a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 25e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 262:	0785                	addi	a5,a5,1
 264:	fee79de3          	bne	a5,a4,25e <memset+0x12>
  }
  return dst;
}
 268:	6422                	ld	s0,8(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret

000000000000026e <strchr>:

char*
strchr(const char *s, char c)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
  for(; *s; s++)
 274:	00054783          	lbu	a5,0(a0)
 278:	cb99                	beqz	a5,28e <strchr+0x20>
    if(*s == c)
 27a:	00f58763          	beq	a1,a5,288 <strchr+0x1a>
  for(; *s; s++)
 27e:	0505                	addi	a0,a0,1
 280:	00054783          	lbu	a5,0(a0)
 284:	fbfd                	bnez	a5,27a <strchr+0xc>
      return (char*)s;
  return 0;
 286:	4501                	li	a0,0
}
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret
  return 0;
 28e:	4501                	li	a0,0
 290:	bfe5                	j	288 <strchr+0x1a>

0000000000000292 <gets>:

char*
gets(char *buf, int max)
{
 292:	711d                	addi	sp,sp,-96
 294:	ec86                	sd	ra,88(sp)
 296:	e8a2                	sd	s0,80(sp)
 298:	e4a6                	sd	s1,72(sp)
 29a:	e0ca                	sd	s2,64(sp)
 29c:	fc4e                	sd	s3,56(sp)
 29e:	f852                	sd	s4,48(sp)
 2a0:	f456                	sd	s5,40(sp)
 2a2:	f05a                	sd	s6,32(sp)
 2a4:	ec5e                	sd	s7,24(sp)
 2a6:	1080                	addi	s0,sp,96
 2a8:	8baa                	mv	s7,a0
 2aa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ac:	892a                	mv	s2,a0
 2ae:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2b0:	4aa9                	li	s5,10
 2b2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2b4:	89a6                	mv	s3,s1
 2b6:	2485                	addiw	s1,s1,1
 2b8:	0344d863          	bge	s1,s4,2e8 <gets+0x56>
    cc = read(0, &c, 1);
 2bc:	4605                	li	a2,1
 2be:	faf40593          	addi	a1,s0,-81
 2c2:	4501                	li	a0,0
 2c4:	00000097          	auipc	ra,0x0
 2c8:	11c080e7          	jalr	284(ra) # 3e0 <read>
    if(cc < 1)
 2cc:	00a05e63          	blez	a0,2e8 <gets+0x56>
    buf[i++] = c;
 2d0:	faf44783          	lbu	a5,-81(s0)
 2d4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2d8:	01578763          	beq	a5,s5,2e6 <gets+0x54>
 2dc:	0905                	addi	s2,s2,1
 2de:	fd679be3          	bne	a5,s6,2b4 <gets+0x22>
  for(i=0; i+1 < max; ){
 2e2:	89a6                	mv	s3,s1
 2e4:	a011                	j	2e8 <gets+0x56>
 2e6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2e8:	99de                	add	s3,s3,s7
 2ea:	00098023          	sb	zero,0(s3)
  return buf;
}
 2ee:	855e                	mv	a0,s7
 2f0:	60e6                	ld	ra,88(sp)
 2f2:	6446                	ld	s0,80(sp)
 2f4:	64a6                	ld	s1,72(sp)
 2f6:	6906                	ld	s2,64(sp)
 2f8:	79e2                	ld	s3,56(sp)
 2fa:	7a42                	ld	s4,48(sp)
 2fc:	7aa2                	ld	s5,40(sp)
 2fe:	7b02                	ld	s6,32(sp)
 300:	6be2                	ld	s7,24(sp)
 302:	6125                	addi	sp,sp,96
 304:	8082                	ret

0000000000000306 <stat>:

int
stat(const char *n, struct stat *st)
{
 306:	1101                	addi	sp,sp,-32
 308:	ec06                	sd	ra,24(sp)
 30a:	e822                	sd	s0,16(sp)
 30c:	e426                	sd	s1,8(sp)
 30e:	e04a                	sd	s2,0(sp)
 310:	1000                	addi	s0,sp,32
 312:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 314:	4581                	li	a1,0
 316:	00000097          	auipc	ra,0x0
 31a:	0f2080e7          	jalr	242(ra) # 408 <open>
  if(fd < 0)
 31e:	02054563          	bltz	a0,348 <stat+0x42>
 322:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 324:	85ca                	mv	a1,s2
 326:	00000097          	auipc	ra,0x0
 32a:	0fa080e7          	jalr	250(ra) # 420 <fstat>
 32e:	892a                	mv	s2,a0
  close(fd);
 330:	8526                	mv	a0,s1
 332:	00000097          	auipc	ra,0x0
 336:	0be080e7          	jalr	190(ra) # 3f0 <close>
  return r;
}
 33a:	854a                	mv	a0,s2
 33c:	60e2                	ld	ra,24(sp)
 33e:	6442                	ld	s0,16(sp)
 340:	64a2                	ld	s1,8(sp)
 342:	6902                	ld	s2,0(sp)
 344:	6105                	addi	sp,sp,32
 346:	8082                	ret
    return -1;
 348:	597d                	li	s2,-1
 34a:	bfc5                	j	33a <stat+0x34>

000000000000034c <atoi>:

int
atoi(const char *s)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e422                	sd	s0,8(sp)
 350:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 352:	00054603          	lbu	a2,0(a0)
 356:	fd06079b          	addiw	a5,a2,-48
 35a:	0ff7f793          	andi	a5,a5,255
 35e:	4725                	li	a4,9
 360:	02f76963          	bltu	a4,a5,392 <atoi+0x46>
 364:	86aa                	mv	a3,a0
  n = 0;
 366:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 368:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 36a:	0685                	addi	a3,a3,1
 36c:	0025179b          	slliw	a5,a0,0x2
 370:	9fa9                	addw	a5,a5,a0
 372:	0017979b          	slliw	a5,a5,0x1
 376:	9fb1                	addw	a5,a5,a2
 378:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 37c:	0006c603          	lbu	a2,0(a3)
 380:	fd06071b          	addiw	a4,a2,-48
 384:	0ff77713          	andi	a4,a4,255
 388:	fee5f1e3          	bgeu	a1,a4,36a <atoi+0x1e>
  return n;
}
 38c:	6422                	ld	s0,8(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret
  n = 0;
 392:	4501                	li	a0,0
 394:	bfe5                	j	38c <atoi+0x40>

0000000000000396 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 396:	1141                	addi	sp,sp,-16
 398:	e422                	sd	s0,8(sp)
 39a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 39c:	00c05f63          	blez	a2,3ba <memmove+0x24>
 3a0:	1602                	slli	a2,a2,0x20
 3a2:	9201                	srli	a2,a2,0x20
 3a4:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 3a8:	87aa                	mv	a5,a0
    *dst++ = *src++;
 3aa:	0585                	addi	a1,a1,1
 3ac:	0785                	addi	a5,a5,1
 3ae:	fff5c703          	lbu	a4,-1(a1)
 3b2:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 3b6:	fed79ae3          	bne	a5,a3,3aa <memmove+0x14>
  return vdst;
}
 3ba:	6422                	ld	s0,8(sp)
 3bc:	0141                	addi	sp,sp,16
 3be:	8082                	ret

00000000000003c0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c0:	4885                	li	a7,1
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c8:	4889                	li	a7,2
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d0:	488d                	li	a7,3
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d8:	4891                	li	a7,4
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <read>:
.global read
read:
 li a7, SYS_read
 3e0:	4895                	li	a7,5
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <write>:
.global write
write:
 li a7, SYS_write
 3e8:	48c1                	li	a7,16
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <close>:
.global close
close:
 li a7, SYS_close
 3f0:	48d5                	li	a7,21
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f8:	4899                	li	a7,6
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <exec>:
.global exec
exec:
 li a7, SYS_exec
 400:	489d                	li	a7,7
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <open>:
.global open
open:
 li a7, SYS_open
 408:	48bd                	li	a7,15
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 410:	48c5                	li	a7,17
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 418:	48c9                	li	a7,18
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 420:	48a1                	li	a7,8
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <link>:
.global link
link:
 li a7, SYS_link
 428:	48cd                	li	a7,19
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 430:	48d1                	li	a7,20
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 438:	48a5                	li	a7,9
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <dup>:
.global dup
dup:
 li a7, SYS_dup
 440:	48a9                	li	a7,10
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 448:	48ad                	li	a7,11
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 450:	48b1                	li	a7,12
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 458:	48b5                	li	a7,13
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 460:	48b9                	li	a7,14
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 468:	48d9                	li	a7,22
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <crash>:
.global crash
crash:
 li a7, SYS_crash
 470:	48dd                	li	a7,23
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <mount>:
.global mount
mount:
 li a7, SYS_mount
 478:	48e1                	li	a7,24
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <umount>:
.global umount
umount:
 li a7, SYS_umount
 480:	48e5                	li	a7,25
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 488:	1101                	addi	sp,sp,-32
 48a:	ec06                	sd	ra,24(sp)
 48c:	e822                	sd	s0,16(sp)
 48e:	1000                	addi	s0,sp,32
 490:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 494:	4605                	li	a2,1
 496:	fef40593          	addi	a1,s0,-17
 49a:	00000097          	auipc	ra,0x0
 49e:	f4e080e7          	jalr	-178(ra) # 3e8 <write>
}
 4a2:	60e2                	ld	ra,24(sp)
 4a4:	6442                	ld	s0,16(sp)
 4a6:	6105                	addi	sp,sp,32
 4a8:	8082                	ret

00000000000004aa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4aa:	7139                	addi	sp,sp,-64
 4ac:	fc06                	sd	ra,56(sp)
 4ae:	f822                	sd	s0,48(sp)
 4b0:	f426                	sd	s1,40(sp)
 4b2:	f04a                	sd	s2,32(sp)
 4b4:	ec4e                	sd	s3,24(sp)
 4b6:	0080                	addi	s0,sp,64
 4b8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ba:	c299                	beqz	a3,4c0 <printint+0x16>
 4bc:	0805c863          	bltz	a1,54c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c0:	2581                	sext.w	a1,a1
  neg = 0;
 4c2:	4881                	li	a7,0
 4c4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4c8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ca:	2601                	sext.w	a2,a2
 4cc:	00000517          	auipc	a0,0x0
 4d0:	45450513          	addi	a0,a0,1108 # 920 <digits>
 4d4:	883a                	mv	a6,a4
 4d6:	2705                	addiw	a4,a4,1
 4d8:	02c5f7bb          	remuw	a5,a1,a2
 4dc:	1782                	slli	a5,a5,0x20
 4de:	9381                	srli	a5,a5,0x20
 4e0:	97aa                	add	a5,a5,a0
 4e2:	0007c783          	lbu	a5,0(a5)
 4e6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ea:	0005879b          	sext.w	a5,a1
 4ee:	02c5d5bb          	divuw	a1,a1,a2
 4f2:	0685                	addi	a3,a3,1
 4f4:	fec7f0e3          	bgeu	a5,a2,4d4 <printint+0x2a>
  if(neg)
 4f8:	00088b63          	beqz	a7,50e <printint+0x64>
    buf[i++] = '-';
 4fc:	fd040793          	addi	a5,s0,-48
 500:	973e                	add	a4,a4,a5
 502:	02d00793          	li	a5,45
 506:	fef70823          	sb	a5,-16(a4)
 50a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 50e:	02e05863          	blez	a4,53e <printint+0x94>
 512:	fc040793          	addi	a5,s0,-64
 516:	00e78933          	add	s2,a5,a4
 51a:	fff78993          	addi	s3,a5,-1
 51e:	99ba                	add	s3,s3,a4
 520:	377d                	addiw	a4,a4,-1
 522:	1702                	slli	a4,a4,0x20
 524:	9301                	srli	a4,a4,0x20
 526:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 52a:	fff94583          	lbu	a1,-1(s2)
 52e:	8526                	mv	a0,s1
 530:	00000097          	auipc	ra,0x0
 534:	f58080e7          	jalr	-168(ra) # 488 <putc>
  while(--i >= 0)
 538:	197d                	addi	s2,s2,-1
 53a:	ff3918e3          	bne	s2,s3,52a <printint+0x80>
}
 53e:	70e2                	ld	ra,56(sp)
 540:	7442                	ld	s0,48(sp)
 542:	74a2                	ld	s1,40(sp)
 544:	7902                	ld	s2,32(sp)
 546:	69e2                	ld	s3,24(sp)
 548:	6121                	addi	sp,sp,64
 54a:	8082                	ret
    x = -xx;
 54c:	40b005bb          	negw	a1,a1
    neg = 1;
 550:	4885                	li	a7,1
    x = -xx;
 552:	bf8d                	j	4c4 <printint+0x1a>

0000000000000554 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 554:	7119                	addi	sp,sp,-128
 556:	fc86                	sd	ra,120(sp)
 558:	f8a2                	sd	s0,112(sp)
 55a:	f4a6                	sd	s1,104(sp)
 55c:	f0ca                	sd	s2,96(sp)
 55e:	ecce                	sd	s3,88(sp)
 560:	e8d2                	sd	s4,80(sp)
 562:	e4d6                	sd	s5,72(sp)
 564:	e0da                	sd	s6,64(sp)
 566:	fc5e                	sd	s7,56(sp)
 568:	f862                	sd	s8,48(sp)
 56a:	f466                	sd	s9,40(sp)
 56c:	f06a                	sd	s10,32(sp)
 56e:	ec6e                	sd	s11,24(sp)
 570:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 572:	0005c903          	lbu	s2,0(a1)
 576:	18090f63          	beqz	s2,714 <vprintf+0x1c0>
 57a:	8aaa                	mv	s5,a0
 57c:	8b32                	mv	s6,a2
 57e:	00158493          	addi	s1,a1,1
  state = 0;
 582:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 584:	02500a13          	li	s4,37
      if(c == 'd'){
 588:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 58c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 590:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 594:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 598:	00000b97          	auipc	s7,0x0
 59c:	388b8b93          	addi	s7,s7,904 # 920 <digits>
 5a0:	a839                	j	5be <vprintf+0x6a>
        putc(fd, c);
 5a2:	85ca                	mv	a1,s2
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	ee2080e7          	jalr	-286(ra) # 488 <putc>
 5ae:	a019                	j	5b4 <vprintf+0x60>
    } else if(state == '%'){
 5b0:	01498f63          	beq	s3,s4,5ce <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5b4:	0485                	addi	s1,s1,1
 5b6:	fff4c903          	lbu	s2,-1(s1)
 5ba:	14090d63          	beqz	s2,714 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5be:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5c2:	fe0997e3          	bnez	s3,5b0 <vprintf+0x5c>
      if(c == '%'){
 5c6:	fd479ee3          	bne	a5,s4,5a2 <vprintf+0x4e>
        state = '%';
 5ca:	89be                	mv	s3,a5
 5cc:	b7e5                	j	5b4 <vprintf+0x60>
      if(c == 'd'){
 5ce:	05878063          	beq	a5,s8,60e <vprintf+0xba>
      } else if(c == 'l') {
 5d2:	05978c63          	beq	a5,s9,62a <vprintf+0xd6>
      } else if(c == 'x') {
 5d6:	07a78863          	beq	a5,s10,646 <vprintf+0xf2>
      } else if(c == 'p') {
 5da:	09b78463          	beq	a5,s11,662 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5de:	07300713          	li	a4,115
 5e2:	0ce78663          	beq	a5,a4,6ae <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e6:	06300713          	li	a4,99
 5ea:	0ee78e63          	beq	a5,a4,6e6 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5ee:	11478863          	beq	a5,s4,6fe <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f2:	85d2                	mv	a1,s4
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	e92080e7          	jalr	-366(ra) # 488 <putc>
        putc(fd, c);
 5fe:	85ca                	mv	a1,s2
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	e86080e7          	jalr	-378(ra) # 488 <putc>
      }
      state = 0;
 60a:	4981                	li	s3,0
 60c:	b765                	j	5b4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 60e:	008b0913          	addi	s2,s6,8
 612:	4685                	li	a3,1
 614:	4629                	li	a2,10
 616:	000b2583          	lw	a1,0(s6)
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	e8e080e7          	jalr	-370(ra) # 4aa <printint>
 624:	8b4a                	mv	s6,s2
      state = 0;
 626:	4981                	li	s3,0
 628:	b771                	j	5b4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62a:	008b0913          	addi	s2,s6,8
 62e:	4681                	li	a3,0
 630:	4629                	li	a2,10
 632:	000b2583          	lw	a1,0(s6)
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	e72080e7          	jalr	-398(ra) # 4aa <printint>
 640:	8b4a                	mv	s6,s2
      state = 0;
 642:	4981                	li	s3,0
 644:	bf85                	j	5b4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 646:	008b0913          	addi	s2,s6,8
 64a:	4681                	li	a3,0
 64c:	4641                	li	a2,16
 64e:	000b2583          	lw	a1,0(s6)
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	e56080e7          	jalr	-426(ra) # 4aa <printint>
 65c:	8b4a                	mv	s6,s2
      state = 0;
 65e:	4981                	li	s3,0
 660:	bf91                	j	5b4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 662:	008b0793          	addi	a5,s6,8
 666:	f8f43423          	sd	a5,-120(s0)
 66a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 66e:	03000593          	li	a1,48
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	e14080e7          	jalr	-492(ra) # 488 <putc>
  putc(fd, 'x');
 67c:	85ea                	mv	a1,s10
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	e08080e7          	jalr	-504(ra) # 488 <putc>
 688:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68a:	03c9d793          	srli	a5,s3,0x3c
 68e:	97de                	add	a5,a5,s7
 690:	0007c583          	lbu	a1,0(a5)
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	df2080e7          	jalr	-526(ra) # 488 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 69e:	0992                	slli	s3,s3,0x4
 6a0:	397d                	addiw	s2,s2,-1
 6a2:	fe0914e3          	bnez	s2,68a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6a6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b721                	j	5b4 <vprintf+0x60>
        s = va_arg(ap, char*);
 6ae:	008b0993          	addi	s3,s6,8
 6b2:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6b6:	02090163          	beqz	s2,6d8 <vprintf+0x184>
        while(*s != 0){
 6ba:	00094583          	lbu	a1,0(s2)
 6be:	c9a1                	beqz	a1,70e <vprintf+0x1ba>
          putc(fd, *s);
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	dc6080e7          	jalr	-570(ra) # 488 <putc>
          s++;
 6ca:	0905                	addi	s2,s2,1
        while(*s != 0){
 6cc:	00094583          	lbu	a1,0(s2)
 6d0:	f9e5                	bnez	a1,6c0 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6d2:	8b4e                	mv	s6,s3
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	bdf9                	j	5b4 <vprintf+0x60>
          s = "(null)";
 6d8:	00000917          	auipc	s2,0x0
 6dc:	24090913          	addi	s2,s2,576 # 918 <malloc+0xfa>
        while(*s != 0){
 6e0:	02800593          	li	a1,40
 6e4:	bff1                	j	6c0 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6e6:	008b0913          	addi	s2,s6,8
 6ea:	000b4583          	lbu	a1,0(s6)
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	d98080e7          	jalr	-616(ra) # 488 <putc>
 6f8:	8b4a                	mv	s6,s2
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	bd65                	j	5b4 <vprintf+0x60>
        putc(fd, c);
 6fe:	85d2                	mv	a1,s4
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	d86080e7          	jalr	-634(ra) # 488 <putc>
      state = 0;
 70a:	4981                	li	s3,0
 70c:	b565                	j	5b4 <vprintf+0x60>
        s = va_arg(ap, char*);
 70e:	8b4e                	mv	s6,s3
      state = 0;
 710:	4981                	li	s3,0
 712:	b54d                	j	5b4 <vprintf+0x60>
    }
  }
}
 714:	70e6                	ld	ra,120(sp)
 716:	7446                	ld	s0,112(sp)
 718:	74a6                	ld	s1,104(sp)
 71a:	7906                	ld	s2,96(sp)
 71c:	69e6                	ld	s3,88(sp)
 71e:	6a46                	ld	s4,80(sp)
 720:	6aa6                	ld	s5,72(sp)
 722:	6b06                	ld	s6,64(sp)
 724:	7be2                	ld	s7,56(sp)
 726:	7c42                	ld	s8,48(sp)
 728:	7ca2                	ld	s9,40(sp)
 72a:	7d02                	ld	s10,32(sp)
 72c:	6de2                	ld	s11,24(sp)
 72e:	6109                	addi	sp,sp,128
 730:	8082                	ret

0000000000000732 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 732:	715d                	addi	sp,sp,-80
 734:	ec06                	sd	ra,24(sp)
 736:	e822                	sd	s0,16(sp)
 738:	1000                	addi	s0,sp,32
 73a:	e010                	sd	a2,0(s0)
 73c:	e414                	sd	a3,8(s0)
 73e:	e818                	sd	a4,16(s0)
 740:	ec1c                	sd	a5,24(s0)
 742:	03043023          	sd	a6,32(s0)
 746:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 74a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 74e:	8622                	mv	a2,s0
 750:	00000097          	auipc	ra,0x0
 754:	e04080e7          	jalr	-508(ra) # 554 <vprintf>
}
 758:	60e2                	ld	ra,24(sp)
 75a:	6442                	ld	s0,16(sp)
 75c:	6161                	addi	sp,sp,80
 75e:	8082                	ret

0000000000000760 <printf>:

void
printf(const char *fmt, ...)
{
 760:	711d                	addi	sp,sp,-96
 762:	ec06                	sd	ra,24(sp)
 764:	e822                	sd	s0,16(sp)
 766:	1000                	addi	s0,sp,32
 768:	e40c                	sd	a1,8(s0)
 76a:	e810                	sd	a2,16(s0)
 76c:	ec14                	sd	a3,24(s0)
 76e:	f018                	sd	a4,32(s0)
 770:	f41c                	sd	a5,40(s0)
 772:	03043823          	sd	a6,48(s0)
 776:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77a:	00840613          	addi	a2,s0,8
 77e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 782:	85aa                	mv	a1,a0
 784:	4505                	li	a0,1
 786:	00000097          	auipc	ra,0x0
 78a:	dce080e7          	jalr	-562(ra) # 554 <vprintf>
}
 78e:	60e2                	ld	ra,24(sp)
 790:	6442                	ld	s0,16(sp)
 792:	6125                	addi	sp,sp,96
 794:	8082                	ret

0000000000000796 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 796:	1141                	addi	sp,sp,-16
 798:	e422                	sd	s0,8(sp)
 79a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a0:	00000797          	auipc	a5,0x0
 7a4:	1987b783          	ld	a5,408(a5) # 938 <freep>
 7a8:	a805                	j	7d8 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7aa:	4618                	lw	a4,8(a2)
 7ac:	9db9                	addw	a1,a1,a4
 7ae:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b2:	6398                	ld	a4,0(a5)
 7b4:	6318                	ld	a4,0(a4)
 7b6:	fee53823          	sd	a4,-16(a0)
 7ba:	a091                	j	7fe <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7bc:	ff852703          	lw	a4,-8(a0)
 7c0:	9e39                	addw	a2,a2,a4
 7c2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7c4:	ff053703          	ld	a4,-16(a0)
 7c8:	e398                	sd	a4,0(a5)
 7ca:	a099                	j	810 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7cc:	6398                	ld	a4,0(a5)
 7ce:	00e7e463          	bltu	a5,a4,7d6 <free+0x40>
 7d2:	00e6ea63          	bltu	a3,a4,7e6 <free+0x50>
{
 7d6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d8:	fed7fae3          	bgeu	a5,a3,7cc <free+0x36>
 7dc:	6398                	ld	a4,0(a5)
 7de:	00e6e463          	bltu	a3,a4,7e6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	fee7eae3          	bltu	a5,a4,7d6 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7e6:	ff852583          	lw	a1,-8(a0)
 7ea:	6390                	ld	a2,0(a5)
 7ec:	02059813          	slli	a6,a1,0x20
 7f0:	01c85713          	srli	a4,a6,0x1c
 7f4:	9736                	add	a4,a4,a3
 7f6:	fae60ae3          	beq	a2,a4,7aa <free+0x14>
    bp->s.ptr = p->s.ptr;
 7fa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7fe:	4790                	lw	a2,8(a5)
 800:	02061593          	slli	a1,a2,0x20
 804:	01c5d713          	srli	a4,a1,0x1c
 808:	973e                	add	a4,a4,a5
 80a:	fae689e3          	beq	a3,a4,7bc <free+0x26>
  } else
    p->s.ptr = bp;
 80e:	e394                	sd	a3,0(a5)
  freep = p;
 810:	00000717          	auipc	a4,0x0
 814:	12f73423          	sd	a5,296(a4) # 938 <freep>
}
 818:	6422                	ld	s0,8(sp)
 81a:	0141                	addi	sp,sp,16
 81c:	8082                	ret

000000000000081e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 81e:	7139                	addi	sp,sp,-64
 820:	fc06                	sd	ra,56(sp)
 822:	f822                	sd	s0,48(sp)
 824:	f426                	sd	s1,40(sp)
 826:	f04a                	sd	s2,32(sp)
 828:	ec4e                	sd	s3,24(sp)
 82a:	e852                	sd	s4,16(sp)
 82c:	e456                	sd	s5,8(sp)
 82e:	e05a                	sd	s6,0(sp)
 830:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 832:	02051493          	slli	s1,a0,0x20
 836:	9081                	srli	s1,s1,0x20
 838:	04bd                	addi	s1,s1,15
 83a:	8091                	srli	s1,s1,0x4
 83c:	0014899b          	addiw	s3,s1,1
 840:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 842:	00000517          	auipc	a0,0x0
 846:	0f653503          	ld	a0,246(a0) # 938 <freep>
 84a:	c515                	beqz	a0,876 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84e:	4798                	lw	a4,8(a5)
 850:	02977f63          	bgeu	a4,s1,88e <malloc+0x70>
 854:	8a4e                	mv	s4,s3
 856:	0009871b          	sext.w	a4,s3
 85a:	6685                	lui	a3,0x1
 85c:	00d77363          	bgeu	a4,a3,862 <malloc+0x44>
 860:	6a05                	lui	s4,0x1
 862:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 866:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 86a:	00000917          	auipc	s2,0x0
 86e:	0ce90913          	addi	s2,s2,206 # 938 <freep>
  if(p == (char*)-1)
 872:	5afd                	li	s5,-1
 874:	a895                	j	8e8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 876:	00000797          	auipc	a5,0x0
 87a:	0ca78793          	addi	a5,a5,202 # 940 <base>
 87e:	00000717          	auipc	a4,0x0
 882:	0af73d23          	sd	a5,186(a4) # 938 <freep>
 886:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 888:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 88c:	b7e1                	j	854 <malloc+0x36>
      if(p->s.size == nunits)
 88e:	02e48c63          	beq	s1,a4,8c6 <malloc+0xa8>
        p->s.size -= nunits;
 892:	4137073b          	subw	a4,a4,s3
 896:	c798                	sw	a4,8(a5)
        p += p->s.size;
 898:	02071693          	slli	a3,a4,0x20
 89c:	01c6d713          	srli	a4,a3,0x1c
 8a0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a6:	00000717          	auipc	a4,0x0
 8aa:	08a73923          	sd	a0,146(a4) # 938 <freep>
      return (void*)(p + 1);
 8ae:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8b2:	70e2                	ld	ra,56(sp)
 8b4:	7442                	ld	s0,48(sp)
 8b6:	74a2                	ld	s1,40(sp)
 8b8:	7902                	ld	s2,32(sp)
 8ba:	69e2                	ld	s3,24(sp)
 8bc:	6a42                	ld	s4,16(sp)
 8be:	6aa2                	ld	s5,8(sp)
 8c0:	6b02                	ld	s6,0(sp)
 8c2:	6121                	addi	sp,sp,64
 8c4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8c6:	6398                	ld	a4,0(a5)
 8c8:	e118                	sd	a4,0(a0)
 8ca:	bff1                	j	8a6 <malloc+0x88>
  hp->s.size = nu;
 8cc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d0:	0541                	addi	a0,a0,16
 8d2:	00000097          	auipc	ra,0x0
 8d6:	ec4080e7          	jalr	-316(ra) # 796 <free>
  return freep;
 8da:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8de:	d971                	beqz	a0,8b2 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e2:	4798                	lw	a4,8(a5)
 8e4:	fa9775e3          	bgeu	a4,s1,88e <malloc+0x70>
    if(p == freep)
 8e8:	00093703          	ld	a4,0(s2)
 8ec:	853e                	mv	a0,a5
 8ee:	fef719e3          	bne	a4,a5,8e0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8f2:	8552                	mv	a0,s4
 8f4:	00000097          	auipc	ra,0x0
 8f8:	b5c080e7          	jalr	-1188(ra) # 450 <sbrk>
  if(p == (char*)-1)
 8fc:	fd5518e3          	bne	a0,s5,8cc <malloc+0xae>
        return 0;
 900:	4501                	li	a0,0
 902:	bf45                	j	8b2 <malloc+0x94>
