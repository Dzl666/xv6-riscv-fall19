
user/_pingpong：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int 
main(int argc,int *argv[]){
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
    int parent_fd[2],child_fd[2];
    pipe(parent_fd);
   8:	fe840513          	addi	a0,s0,-24
   c:	00000097          	auipc	ra,0x0
  10:	392080e7          	jalr	914(ra) # 39e <pipe>
    pipe(child_fd);
  14:	fe040513          	addi	a0,s0,-32
  18:	00000097          	auipc	ra,0x0
  1c:	386080e7          	jalr	902(ra) # 39e <pipe>
    char buffer[] = {'A'};
  20:	04100793          	li	a5,65
  24:	fcf40c23          	sb	a5,-40(s0)
    int len = sizeof(buffer);
    //函数调用成功返回r/w两个文件描述符,fd[0]读端,fd[1]写端
    //pipe无需open，但需手动close。读写数据其实是在读写内核缓冲区
    if(fork()==0){
  28:	00000097          	auipc	ra,0x0
  2c:	35e080e7          	jalr	862(ra) # 386 <fork>
  30:	e955                	bnez	a0,e4 <main+0xe4>
        close(parent_fd[1]); //close write,open read
  32:	fec42503          	lw	a0,-20(s0)
  36:	00000097          	auipc	ra,0x0
  3a:	380080e7          	jalr	896(ra) # 3b6 <close>
        close(child_fd[0]);  //close read,open write
  3e:	fe042503          	lw	a0,-32(s0)
  42:	00000097          	auipc	ra,0x0
  46:	374080e7          	jalr	884(ra) # 3b6 <close>
        if(read(parent_fd[0], buffer, len) != len){
  4a:	4605                	li	a2,1
  4c:	fd840593          	addi	a1,s0,-40
  50:	fe842503          	lw	a0,-24(s0)
  54:	00000097          	auipc	ra,0x0
  58:	352080e7          	jalr	850(ra) # 3a6 <read>
  5c:	4785                	li	a5,1
  5e:	00f50e63          	beq	a0,a5,7a <main+0x7a>
            printf("pingpong: son read error\n");
  62:	00001517          	auipc	a0,0x1
  66:	86e50513          	addi	a0,a0,-1938 # 8d0 <malloc+0xec>
  6a:	00000097          	auipc	ra,0x0
  6e:	6bc080e7          	jalr	1724(ra) # 726 <printf>
            exit();
  72:	00000097          	auipc	ra,0x0
  76:	31c080e7          	jalr	796(ra) # 38e <exit>
        }
        printf("%d: received ping\n",getpid());
  7a:	00000097          	auipc	ra,0x0
  7e:	394080e7          	jalr	916(ra) # 40e <getpid>
  82:	85aa                	mv	a1,a0
  84:	00001517          	auipc	a0,0x1
  88:	86c50513          	addi	a0,a0,-1940 # 8f0 <malloc+0x10c>
  8c:	00000097          	auipc	ra,0x0
  90:	69a080e7          	jalr	1690(ra) # 726 <printf>
        if(write(child_fd[1], buffer, len) != len){
  94:	4605                	li	a2,1
  96:	fd840593          	addi	a1,s0,-40
  9a:	fe442503          	lw	a0,-28(s0)
  9e:	00000097          	auipc	ra,0x0
  a2:	310080e7          	jalr	784(ra) # 3ae <write>
  a6:	4785                	li	a5,1
  a8:	00f50e63          	beq	a0,a5,c4 <main+0xc4>
            printf("pingpong: son write error\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	85c50513          	addi	a0,a0,-1956 # 908 <malloc+0x124>
  b4:	00000097          	auipc	ra,0x0
  b8:	672080e7          	jalr	1650(ra) # 726 <printf>
            exit();
  bc:	00000097          	auipc	ra,0x0
  c0:	2d2080e7          	jalr	722(ra) # 38e <exit>
        }
        close(parent_fd[0]);
  c4:	fe842503          	lw	a0,-24(s0)
  c8:	00000097          	auipc	ra,0x0
  cc:	2ee080e7          	jalr	750(ra) # 3b6 <close>
        close(child_fd[1]);
  d0:	fe442503          	lw	a0,-28(s0)
  d4:	00000097          	auipc	ra,0x0
  d8:	2e2080e7          	jalr	738(ra) # 3b6 <close>
        exit();
  dc:	00000097          	auipc	ra,0x0
  e0:	2b2080e7          	jalr	690(ra) # 38e <exit>
    }
    close(parent_fd[0]); //close read,open write
  e4:	fe842503          	lw	a0,-24(s0)
  e8:	00000097          	auipc	ra,0x0
  ec:	2ce080e7          	jalr	718(ra) # 3b6 <close>
    close(child_fd[1]);  //close write,open read
  f0:	fe442503          	lw	a0,-28(s0)
  f4:	00000097          	auipc	ra,0x0
  f8:	2c2080e7          	jalr	706(ra) # 3b6 <close>
    
    if(write(parent_fd[1], buffer, 1) != 1){
  fc:	4605                	li	a2,1
  fe:	fd840593          	addi	a1,s0,-40
 102:	fec42503          	lw	a0,-20(s0)
 106:	00000097          	auipc	ra,0x0
 10a:	2a8080e7          	jalr	680(ra) # 3ae <write>
 10e:	4785                	li	a5,1
 110:	00f50e63          	beq	a0,a5,12c <main+0x12c>
        printf("pingpong: parent write error\n");
 114:	00001517          	auipc	a0,0x1
 118:	81450513          	addi	a0,a0,-2028 # 928 <malloc+0x144>
 11c:	00000097          	auipc	ra,0x0
 120:	60a080e7          	jalr	1546(ra) # 726 <printf>
        exit();
 124:	00000097          	auipc	ra,0x0
 128:	26a080e7          	jalr	618(ra) # 38e <exit>
    }
    if(read(child_fd[0], buffer, 1) != 1){
 12c:	4605                	li	a2,1
 12e:	fd840593          	addi	a1,s0,-40
 132:	fe042503          	lw	a0,-32(s0)
 136:	00000097          	auipc	ra,0x0
 13a:	270080e7          	jalr	624(ra) # 3a6 <read>
 13e:	4785                	li	a5,1
 140:	00f50e63          	beq	a0,a5,15c <main+0x15c>
        printf("pingpong: parent read error\n");
 144:	00001517          	auipc	a0,0x1
 148:	80450513          	addi	a0,a0,-2044 # 948 <malloc+0x164>
 14c:	00000097          	auipc	ra,0x0
 150:	5da080e7          	jalr	1498(ra) # 726 <printf>
        exit();
 154:	00000097          	auipc	ra,0x0
 158:	23a080e7          	jalr	570(ra) # 38e <exit>
    }
    fprintf(2,"%d: received pong\n",getpid());
 15c:	00000097          	auipc	ra,0x0
 160:	2b2080e7          	jalr	690(ra) # 40e <getpid>
 164:	862a                	mv	a2,a0
 166:	00001597          	auipc	a1,0x1
 16a:	80258593          	addi	a1,a1,-2046 # 968 <malloc+0x184>
 16e:	4509                	li	a0,2
 170:	00000097          	auipc	ra,0x0
 174:	588080e7          	jalr	1416(ra) # 6f8 <fprintf>
    close(parent_fd[1]);
 178:	fec42503          	lw	a0,-20(s0)
 17c:	00000097          	auipc	ra,0x0
 180:	23a080e7          	jalr	570(ra) # 3b6 <close>
    close(child_fd[0]);
 184:	fe042503          	lw	a0,-32(s0)
 188:	00000097          	auipc	ra,0x0
 18c:	22e080e7          	jalr	558(ra) # 3b6 <close>
    wait();
 190:	00000097          	auipc	ra,0x0
 194:	206080e7          	jalr	518(ra) # 396 <wait>
    exit();
 198:	00000097          	auipc	ra,0x0
 19c:	1f6080e7          	jalr	502(ra) # 38e <exit>

00000000000001a0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a6:	87aa                	mv	a5,a0
 1a8:	0585                	addi	a1,a1,1
 1aa:	0785                	addi	a5,a5,1
 1ac:	fff5c703          	lbu	a4,-1(a1)
 1b0:	fee78fa3          	sb	a4,-1(a5)
 1b4:	fb75                	bnez	a4,1a8 <strcpy+0x8>
    ;
  return os;
}
 1b6:	6422                	ld	s0,8(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret

00000000000001bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e422                	sd	s0,8(sp)
 1c0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1c2:	00054783          	lbu	a5,0(a0)
 1c6:	cb91                	beqz	a5,1da <strcmp+0x1e>
 1c8:	0005c703          	lbu	a4,0(a1)
 1cc:	00f71763          	bne	a4,a5,1da <strcmp+0x1e>
    p++, q++;
 1d0:	0505                	addi	a0,a0,1
 1d2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1d4:	00054783          	lbu	a5,0(a0)
 1d8:	fbe5                	bnez	a5,1c8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1da:	0005c503          	lbu	a0,0(a1)
}
 1de:	40a7853b          	subw	a0,a5,a0
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret

00000000000001e8 <strlen>:

uint
strlen(const char *s)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e422                	sd	s0,8(sp)
 1ec:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ee:	00054783          	lbu	a5,0(a0)
 1f2:	cf91                	beqz	a5,20e <strlen+0x26>
 1f4:	0505                	addi	a0,a0,1
 1f6:	87aa                	mv	a5,a0
 1f8:	4685                	li	a3,1
 1fa:	9e89                	subw	a3,a3,a0
 1fc:	00f6853b          	addw	a0,a3,a5
 200:	0785                	addi	a5,a5,1
 202:	fff7c703          	lbu	a4,-1(a5)
 206:	fb7d                	bnez	a4,1fc <strlen+0x14>
    ;
  return n;
}
 208:	6422                	ld	s0,8(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret
  for(n = 0; s[n]; n++)
 20e:	4501                	li	a0,0
 210:	bfe5                	j	208 <strlen+0x20>

0000000000000212 <memset>:

void*
memset(void *dst, int c, uint n)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 218:	ca19                	beqz	a2,22e <memset+0x1c>
 21a:	87aa                	mv	a5,a0
 21c:	1602                	slli	a2,a2,0x20
 21e:	9201                	srli	a2,a2,0x20
 220:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 224:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 228:	0785                	addi	a5,a5,1
 22a:	fee79de3          	bne	a5,a4,224 <memset+0x12>
  }
  return dst;
}
 22e:	6422                	ld	s0,8(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret

0000000000000234 <strchr>:

char*
strchr(const char *s, char c)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  for(; *s; s++)
 23a:	00054783          	lbu	a5,0(a0)
 23e:	cb99                	beqz	a5,254 <strchr+0x20>
    if(*s == c)
 240:	00f58763          	beq	a1,a5,24e <strchr+0x1a>
  for(; *s; s++)
 244:	0505                	addi	a0,a0,1
 246:	00054783          	lbu	a5,0(a0)
 24a:	fbfd                	bnez	a5,240 <strchr+0xc>
      return (char*)s;
  return 0;
 24c:	4501                	li	a0,0
}
 24e:	6422                	ld	s0,8(sp)
 250:	0141                	addi	sp,sp,16
 252:	8082                	ret
  return 0;
 254:	4501                	li	a0,0
 256:	bfe5                	j	24e <strchr+0x1a>

0000000000000258 <gets>:

char*
gets(char *buf, int max)
{
 258:	711d                	addi	sp,sp,-96
 25a:	ec86                	sd	ra,88(sp)
 25c:	e8a2                	sd	s0,80(sp)
 25e:	e4a6                	sd	s1,72(sp)
 260:	e0ca                	sd	s2,64(sp)
 262:	fc4e                	sd	s3,56(sp)
 264:	f852                	sd	s4,48(sp)
 266:	f456                	sd	s5,40(sp)
 268:	f05a                	sd	s6,32(sp)
 26a:	ec5e                	sd	s7,24(sp)
 26c:	1080                	addi	s0,sp,96
 26e:	8baa                	mv	s7,a0
 270:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 272:	892a                	mv	s2,a0
 274:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 276:	4aa9                	li	s5,10
 278:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 27a:	89a6                	mv	s3,s1
 27c:	2485                	addiw	s1,s1,1
 27e:	0344d863          	bge	s1,s4,2ae <gets+0x56>
    cc = read(0, &c, 1);
 282:	4605                	li	a2,1
 284:	faf40593          	addi	a1,s0,-81
 288:	4501                	li	a0,0
 28a:	00000097          	auipc	ra,0x0
 28e:	11c080e7          	jalr	284(ra) # 3a6 <read>
    if(cc < 1)
 292:	00a05e63          	blez	a0,2ae <gets+0x56>
    buf[i++] = c;
 296:	faf44783          	lbu	a5,-81(s0)
 29a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 29e:	01578763          	beq	a5,s5,2ac <gets+0x54>
 2a2:	0905                	addi	s2,s2,1
 2a4:	fd679be3          	bne	a5,s6,27a <gets+0x22>
  for(i=0; i+1 < max; ){
 2a8:	89a6                	mv	s3,s1
 2aa:	a011                	j	2ae <gets+0x56>
 2ac:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2ae:	99de                	add	s3,s3,s7
 2b0:	00098023          	sb	zero,0(s3)
  return buf;
}
 2b4:	855e                	mv	a0,s7
 2b6:	60e6                	ld	ra,88(sp)
 2b8:	6446                	ld	s0,80(sp)
 2ba:	64a6                	ld	s1,72(sp)
 2bc:	6906                	ld	s2,64(sp)
 2be:	79e2                	ld	s3,56(sp)
 2c0:	7a42                	ld	s4,48(sp)
 2c2:	7aa2                	ld	s5,40(sp)
 2c4:	7b02                	ld	s6,32(sp)
 2c6:	6be2                	ld	s7,24(sp)
 2c8:	6125                	addi	sp,sp,96
 2ca:	8082                	ret

00000000000002cc <stat>:

int
stat(const char *n, struct stat *st)
{
 2cc:	1101                	addi	sp,sp,-32
 2ce:	ec06                	sd	ra,24(sp)
 2d0:	e822                	sd	s0,16(sp)
 2d2:	e426                	sd	s1,8(sp)
 2d4:	e04a                	sd	s2,0(sp)
 2d6:	1000                	addi	s0,sp,32
 2d8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2da:	4581                	li	a1,0
 2dc:	00000097          	auipc	ra,0x0
 2e0:	0f2080e7          	jalr	242(ra) # 3ce <open>
  if(fd < 0)
 2e4:	02054563          	bltz	a0,30e <stat+0x42>
 2e8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ea:	85ca                	mv	a1,s2
 2ec:	00000097          	auipc	ra,0x0
 2f0:	0fa080e7          	jalr	250(ra) # 3e6 <fstat>
 2f4:	892a                	mv	s2,a0
  close(fd);
 2f6:	8526                	mv	a0,s1
 2f8:	00000097          	auipc	ra,0x0
 2fc:	0be080e7          	jalr	190(ra) # 3b6 <close>
  return r;
}
 300:	854a                	mv	a0,s2
 302:	60e2                	ld	ra,24(sp)
 304:	6442                	ld	s0,16(sp)
 306:	64a2                	ld	s1,8(sp)
 308:	6902                	ld	s2,0(sp)
 30a:	6105                	addi	sp,sp,32
 30c:	8082                	ret
    return -1;
 30e:	597d                	li	s2,-1
 310:	bfc5                	j	300 <stat+0x34>

0000000000000312 <atoi>:

int
atoi(const char *s)
{
 312:	1141                	addi	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 318:	00054603          	lbu	a2,0(a0)
 31c:	fd06079b          	addiw	a5,a2,-48
 320:	0ff7f793          	andi	a5,a5,255
 324:	4725                	li	a4,9
 326:	02f76963          	bltu	a4,a5,358 <atoi+0x46>
 32a:	86aa                	mv	a3,a0
  n = 0;
 32c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 32e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 330:	0685                	addi	a3,a3,1
 332:	0025179b          	slliw	a5,a0,0x2
 336:	9fa9                	addw	a5,a5,a0
 338:	0017979b          	slliw	a5,a5,0x1
 33c:	9fb1                	addw	a5,a5,a2
 33e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 342:	0006c603          	lbu	a2,0(a3)
 346:	fd06071b          	addiw	a4,a2,-48
 34a:	0ff77713          	andi	a4,a4,255
 34e:	fee5f1e3          	bgeu	a1,a4,330 <atoi+0x1e>
  return n;
}
 352:	6422                	ld	s0,8(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret
  n = 0;
 358:	4501                	li	a0,0
 35a:	bfe5                	j	352 <atoi+0x40>

000000000000035c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 35c:	1141                	addi	sp,sp,-16
 35e:	e422                	sd	s0,8(sp)
 360:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 362:	00c05f63          	blez	a2,380 <memmove+0x24>
 366:	1602                	slli	a2,a2,0x20
 368:	9201                	srli	a2,a2,0x20
 36a:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 36e:	87aa                	mv	a5,a0
    *dst++ = *src++;
 370:	0585                	addi	a1,a1,1
 372:	0785                	addi	a5,a5,1
 374:	fff5c703          	lbu	a4,-1(a1)
 378:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 37c:	fed79ae3          	bne	a5,a3,370 <memmove+0x14>
  return vdst;
}
 380:	6422                	ld	s0,8(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret

0000000000000386 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 386:	4885                	li	a7,1
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <exit>:
.global exit
exit:
 li a7, SYS_exit
 38e:	4889                	li	a7,2
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <wait>:
.global wait
wait:
 li a7, SYS_wait
 396:	488d                	li	a7,3
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39e:	4891                	li	a7,4
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <read>:
.global read
read:
 li a7, SYS_read
 3a6:	4895                	li	a7,5
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <write>:
.global write
write:
 li a7, SYS_write
 3ae:	48c1                	li	a7,16
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <close>:
.global close
close:
 li a7, SYS_close
 3b6:	48d5                	li	a7,21
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <kill>:
.global kill
kill:
 li a7, SYS_kill
 3be:	4899                	li	a7,6
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c6:	489d                	li	a7,7
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <open>:
.global open
open:
 li a7, SYS_open
 3ce:	48bd                	li	a7,15
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d6:	48c5                	li	a7,17
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3de:	48c9                	li	a7,18
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e6:	48a1                	li	a7,8
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <link>:
.global link
link:
 li a7, SYS_link
 3ee:	48cd                	li	a7,19
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f6:	48d1                	li	a7,20
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fe:	48a5                	li	a7,9
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <dup>:
.global dup
dup:
 li a7, SYS_dup
 406:	48a9                	li	a7,10
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40e:	48ad                	li	a7,11
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 416:	48b1                	li	a7,12
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 41e:	48b5                	li	a7,13
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 426:	48b9                	li	a7,14
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 42e:	48d9                	li	a7,22
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <crash>:
.global crash
crash:
 li a7, SYS_crash
 436:	48dd                	li	a7,23
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <mount>:
.global mount
mount:
 li a7, SYS_mount
 43e:	48e1                	li	a7,24
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <umount>:
.global umount
umount:
 li a7, SYS_umount
 446:	48e5                	li	a7,25
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 44e:	1101                	addi	sp,sp,-32
 450:	ec06                	sd	ra,24(sp)
 452:	e822                	sd	s0,16(sp)
 454:	1000                	addi	s0,sp,32
 456:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 45a:	4605                	li	a2,1
 45c:	fef40593          	addi	a1,s0,-17
 460:	00000097          	auipc	ra,0x0
 464:	f4e080e7          	jalr	-178(ra) # 3ae <write>
}
 468:	60e2                	ld	ra,24(sp)
 46a:	6442                	ld	s0,16(sp)
 46c:	6105                	addi	sp,sp,32
 46e:	8082                	ret

0000000000000470 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 470:	7139                	addi	sp,sp,-64
 472:	fc06                	sd	ra,56(sp)
 474:	f822                	sd	s0,48(sp)
 476:	f426                	sd	s1,40(sp)
 478:	f04a                	sd	s2,32(sp)
 47a:	ec4e                	sd	s3,24(sp)
 47c:	0080                	addi	s0,sp,64
 47e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 480:	c299                	beqz	a3,486 <printint+0x16>
 482:	0805c863          	bltz	a1,512 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 486:	2581                	sext.w	a1,a1
  neg = 0;
 488:	4881                	li	a7,0
 48a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 48e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 490:	2601                	sext.w	a2,a2
 492:	00000517          	auipc	a0,0x0
 496:	4f650513          	addi	a0,a0,1270 # 988 <digits>
 49a:	883a                	mv	a6,a4
 49c:	2705                	addiw	a4,a4,1
 49e:	02c5f7bb          	remuw	a5,a1,a2
 4a2:	1782                	slli	a5,a5,0x20
 4a4:	9381                	srli	a5,a5,0x20
 4a6:	97aa                	add	a5,a5,a0
 4a8:	0007c783          	lbu	a5,0(a5)
 4ac:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b0:	0005879b          	sext.w	a5,a1
 4b4:	02c5d5bb          	divuw	a1,a1,a2
 4b8:	0685                	addi	a3,a3,1
 4ba:	fec7f0e3          	bgeu	a5,a2,49a <printint+0x2a>
  if(neg)
 4be:	00088b63          	beqz	a7,4d4 <printint+0x64>
    buf[i++] = '-';
 4c2:	fd040793          	addi	a5,s0,-48
 4c6:	973e                	add	a4,a4,a5
 4c8:	02d00793          	li	a5,45
 4cc:	fef70823          	sb	a5,-16(a4)
 4d0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4d4:	02e05863          	blez	a4,504 <printint+0x94>
 4d8:	fc040793          	addi	a5,s0,-64
 4dc:	00e78933          	add	s2,a5,a4
 4e0:	fff78993          	addi	s3,a5,-1
 4e4:	99ba                	add	s3,s3,a4
 4e6:	377d                	addiw	a4,a4,-1
 4e8:	1702                	slli	a4,a4,0x20
 4ea:	9301                	srli	a4,a4,0x20
 4ec:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f0:	fff94583          	lbu	a1,-1(s2)
 4f4:	8526                	mv	a0,s1
 4f6:	00000097          	auipc	ra,0x0
 4fa:	f58080e7          	jalr	-168(ra) # 44e <putc>
  while(--i >= 0)
 4fe:	197d                	addi	s2,s2,-1
 500:	ff3918e3          	bne	s2,s3,4f0 <printint+0x80>
}
 504:	70e2                	ld	ra,56(sp)
 506:	7442                	ld	s0,48(sp)
 508:	74a2                	ld	s1,40(sp)
 50a:	7902                	ld	s2,32(sp)
 50c:	69e2                	ld	s3,24(sp)
 50e:	6121                	addi	sp,sp,64
 510:	8082                	ret
    x = -xx;
 512:	40b005bb          	negw	a1,a1
    neg = 1;
 516:	4885                	li	a7,1
    x = -xx;
 518:	bf8d                	j	48a <printint+0x1a>

000000000000051a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 51a:	7119                	addi	sp,sp,-128
 51c:	fc86                	sd	ra,120(sp)
 51e:	f8a2                	sd	s0,112(sp)
 520:	f4a6                	sd	s1,104(sp)
 522:	f0ca                	sd	s2,96(sp)
 524:	ecce                	sd	s3,88(sp)
 526:	e8d2                	sd	s4,80(sp)
 528:	e4d6                	sd	s5,72(sp)
 52a:	e0da                	sd	s6,64(sp)
 52c:	fc5e                	sd	s7,56(sp)
 52e:	f862                	sd	s8,48(sp)
 530:	f466                	sd	s9,40(sp)
 532:	f06a                	sd	s10,32(sp)
 534:	ec6e                	sd	s11,24(sp)
 536:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 538:	0005c903          	lbu	s2,0(a1)
 53c:	18090f63          	beqz	s2,6da <vprintf+0x1c0>
 540:	8aaa                	mv	s5,a0
 542:	8b32                	mv	s6,a2
 544:	00158493          	addi	s1,a1,1
  state = 0;
 548:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 54a:	02500a13          	li	s4,37
      if(c == 'd'){
 54e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 552:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 556:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 55a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 55e:	00000b97          	auipc	s7,0x0
 562:	42ab8b93          	addi	s7,s7,1066 # 988 <digits>
 566:	a839                	j	584 <vprintf+0x6a>
        putc(fd, c);
 568:	85ca                	mv	a1,s2
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	ee2080e7          	jalr	-286(ra) # 44e <putc>
 574:	a019                	j	57a <vprintf+0x60>
    } else if(state == '%'){
 576:	01498f63          	beq	s3,s4,594 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 57a:	0485                	addi	s1,s1,1
 57c:	fff4c903          	lbu	s2,-1(s1)
 580:	14090d63          	beqz	s2,6da <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 584:	0009079b          	sext.w	a5,s2
    if(state == 0){
 588:	fe0997e3          	bnez	s3,576 <vprintf+0x5c>
      if(c == '%'){
 58c:	fd479ee3          	bne	a5,s4,568 <vprintf+0x4e>
        state = '%';
 590:	89be                	mv	s3,a5
 592:	b7e5                	j	57a <vprintf+0x60>
      if(c == 'd'){
 594:	05878063          	beq	a5,s8,5d4 <vprintf+0xba>
      } else if(c == 'l') {
 598:	05978c63          	beq	a5,s9,5f0 <vprintf+0xd6>
      } else if(c == 'x') {
 59c:	07a78863          	beq	a5,s10,60c <vprintf+0xf2>
      } else if(c == 'p') {
 5a0:	09b78463          	beq	a5,s11,628 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5a4:	07300713          	li	a4,115
 5a8:	0ce78663          	beq	a5,a4,674 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ac:	06300713          	li	a4,99
 5b0:	0ee78e63          	beq	a5,a4,6ac <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5b4:	11478863          	beq	a5,s4,6c4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b8:	85d2                	mv	a1,s4
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	e92080e7          	jalr	-366(ra) # 44e <putc>
        putc(fd, c);
 5c4:	85ca                	mv	a1,s2
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	e86080e7          	jalr	-378(ra) # 44e <putc>
      }
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b765                	j	57a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5d4:	008b0913          	addi	s2,s6,8
 5d8:	4685                	li	a3,1
 5da:	4629                	li	a2,10
 5dc:	000b2583          	lw	a1,0(s6)
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	e8e080e7          	jalr	-370(ra) # 470 <printint>
 5ea:	8b4a                	mv	s6,s2
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b771                	j	57a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f0:	008b0913          	addi	s2,s6,8
 5f4:	4681                	li	a3,0
 5f6:	4629                	li	a2,10
 5f8:	000b2583          	lw	a1,0(s6)
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	e72080e7          	jalr	-398(ra) # 470 <printint>
 606:	8b4a                	mv	s6,s2
      state = 0;
 608:	4981                	li	s3,0
 60a:	bf85                	j	57a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 60c:	008b0913          	addi	s2,s6,8
 610:	4681                	li	a3,0
 612:	4641                	li	a2,16
 614:	000b2583          	lw	a1,0(s6)
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	e56080e7          	jalr	-426(ra) # 470 <printint>
 622:	8b4a                	mv	s6,s2
      state = 0;
 624:	4981                	li	s3,0
 626:	bf91                	j	57a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 628:	008b0793          	addi	a5,s6,8
 62c:	f8f43423          	sd	a5,-120(s0)
 630:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 634:	03000593          	li	a1,48
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	e14080e7          	jalr	-492(ra) # 44e <putc>
  putc(fd, 'x');
 642:	85ea                	mv	a1,s10
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	e08080e7          	jalr	-504(ra) # 44e <putc>
 64e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 650:	03c9d793          	srli	a5,s3,0x3c
 654:	97de                	add	a5,a5,s7
 656:	0007c583          	lbu	a1,0(a5)
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	df2080e7          	jalr	-526(ra) # 44e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 664:	0992                	slli	s3,s3,0x4
 666:	397d                	addiw	s2,s2,-1
 668:	fe0914e3          	bnez	s2,650 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 66c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 670:	4981                	li	s3,0
 672:	b721                	j	57a <vprintf+0x60>
        s = va_arg(ap, char*);
 674:	008b0993          	addi	s3,s6,8
 678:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 67c:	02090163          	beqz	s2,69e <vprintf+0x184>
        while(*s != 0){
 680:	00094583          	lbu	a1,0(s2)
 684:	c9a1                	beqz	a1,6d4 <vprintf+0x1ba>
          putc(fd, *s);
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	dc6080e7          	jalr	-570(ra) # 44e <putc>
          s++;
 690:	0905                	addi	s2,s2,1
        while(*s != 0){
 692:	00094583          	lbu	a1,0(s2)
 696:	f9e5                	bnez	a1,686 <vprintf+0x16c>
        s = va_arg(ap, char*);
 698:	8b4e                	mv	s6,s3
      state = 0;
 69a:	4981                	li	s3,0
 69c:	bdf9                	j	57a <vprintf+0x60>
          s = "(null)";
 69e:	00000917          	auipc	s2,0x0
 6a2:	2e290913          	addi	s2,s2,738 # 980 <malloc+0x19c>
        while(*s != 0){
 6a6:	02800593          	li	a1,40
 6aa:	bff1                	j	686 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6ac:	008b0913          	addi	s2,s6,8
 6b0:	000b4583          	lbu	a1,0(s6)
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	d98080e7          	jalr	-616(ra) # 44e <putc>
 6be:	8b4a                	mv	s6,s2
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	bd65                	j	57a <vprintf+0x60>
        putc(fd, c);
 6c4:	85d2                	mv	a1,s4
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	d86080e7          	jalr	-634(ra) # 44e <putc>
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b565                	j	57a <vprintf+0x60>
        s = va_arg(ap, char*);
 6d4:	8b4e                	mv	s6,s3
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	b54d                	j	57a <vprintf+0x60>
    }
  }
}
 6da:	70e6                	ld	ra,120(sp)
 6dc:	7446                	ld	s0,112(sp)
 6de:	74a6                	ld	s1,104(sp)
 6e0:	7906                	ld	s2,96(sp)
 6e2:	69e6                	ld	s3,88(sp)
 6e4:	6a46                	ld	s4,80(sp)
 6e6:	6aa6                	ld	s5,72(sp)
 6e8:	6b06                	ld	s6,64(sp)
 6ea:	7be2                	ld	s7,56(sp)
 6ec:	7c42                	ld	s8,48(sp)
 6ee:	7ca2                	ld	s9,40(sp)
 6f0:	7d02                	ld	s10,32(sp)
 6f2:	6de2                	ld	s11,24(sp)
 6f4:	6109                	addi	sp,sp,128
 6f6:	8082                	ret

00000000000006f8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f8:	715d                	addi	sp,sp,-80
 6fa:	ec06                	sd	ra,24(sp)
 6fc:	e822                	sd	s0,16(sp)
 6fe:	1000                	addi	s0,sp,32
 700:	e010                	sd	a2,0(s0)
 702:	e414                	sd	a3,8(s0)
 704:	e818                	sd	a4,16(s0)
 706:	ec1c                	sd	a5,24(s0)
 708:	03043023          	sd	a6,32(s0)
 70c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 710:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 714:	8622                	mv	a2,s0
 716:	00000097          	auipc	ra,0x0
 71a:	e04080e7          	jalr	-508(ra) # 51a <vprintf>
}
 71e:	60e2                	ld	ra,24(sp)
 720:	6442                	ld	s0,16(sp)
 722:	6161                	addi	sp,sp,80
 724:	8082                	ret

0000000000000726 <printf>:

void
printf(const char *fmt, ...)
{
 726:	711d                	addi	sp,sp,-96
 728:	ec06                	sd	ra,24(sp)
 72a:	e822                	sd	s0,16(sp)
 72c:	1000                	addi	s0,sp,32
 72e:	e40c                	sd	a1,8(s0)
 730:	e810                	sd	a2,16(s0)
 732:	ec14                	sd	a3,24(s0)
 734:	f018                	sd	a4,32(s0)
 736:	f41c                	sd	a5,40(s0)
 738:	03043823          	sd	a6,48(s0)
 73c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 740:	00840613          	addi	a2,s0,8
 744:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 748:	85aa                	mv	a1,a0
 74a:	4505                	li	a0,1
 74c:	00000097          	auipc	ra,0x0
 750:	dce080e7          	jalr	-562(ra) # 51a <vprintf>
}
 754:	60e2                	ld	ra,24(sp)
 756:	6442                	ld	s0,16(sp)
 758:	6125                	addi	sp,sp,96
 75a:	8082                	ret

000000000000075c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 75c:	1141                	addi	sp,sp,-16
 75e:	e422                	sd	s0,8(sp)
 760:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 762:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 766:	00000797          	auipc	a5,0x0
 76a:	23a7b783          	ld	a5,570(a5) # 9a0 <freep>
 76e:	a805                	j	79e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 770:	4618                	lw	a4,8(a2)
 772:	9db9                	addw	a1,a1,a4
 774:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 778:	6398                	ld	a4,0(a5)
 77a:	6318                	ld	a4,0(a4)
 77c:	fee53823          	sd	a4,-16(a0)
 780:	a091                	j	7c4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 782:	ff852703          	lw	a4,-8(a0)
 786:	9e39                	addw	a2,a2,a4
 788:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 78a:	ff053703          	ld	a4,-16(a0)
 78e:	e398                	sd	a4,0(a5)
 790:	a099                	j	7d6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 792:	6398                	ld	a4,0(a5)
 794:	00e7e463          	bltu	a5,a4,79c <free+0x40>
 798:	00e6ea63          	bltu	a3,a4,7ac <free+0x50>
{
 79c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79e:	fed7fae3          	bgeu	a5,a3,792 <free+0x36>
 7a2:	6398                	ld	a4,0(a5)
 7a4:	00e6e463          	bltu	a3,a4,7ac <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a8:	fee7eae3          	bltu	a5,a4,79c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7ac:	ff852583          	lw	a1,-8(a0)
 7b0:	6390                	ld	a2,0(a5)
 7b2:	02059813          	slli	a6,a1,0x20
 7b6:	01c85713          	srli	a4,a6,0x1c
 7ba:	9736                	add	a4,a4,a3
 7bc:	fae60ae3          	beq	a2,a4,770 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7c0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c4:	4790                	lw	a2,8(a5)
 7c6:	02061593          	slli	a1,a2,0x20
 7ca:	01c5d713          	srli	a4,a1,0x1c
 7ce:	973e                	add	a4,a4,a5
 7d0:	fae689e3          	beq	a3,a4,782 <free+0x26>
  } else
    p->s.ptr = bp;
 7d4:	e394                	sd	a3,0(a5)
  freep = p;
 7d6:	00000717          	auipc	a4,0x0
 7da:	1cf73523          	sd	a5,458(a4) # 9a0 <freep>
}
 7de:	6422                	ld	s0,8(sp)
 7e0:	0141                	addi	sp,sp,16
 7e2:	8082                	ret

00000000000007e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e4:	7139                	addi	sp,sp,-64
 7e6:	fc06                	sd	ra,56(sp)
 7e8:	f822                	sd	s0,48(sp)
 7ea:	f426                	sd	s1,40(sp)
 7ec:	f04a                	sd	s2,32(sp)
 7ee:	ec4e                	sd	s3,24(sp)
 7f0:	e852                	sd	s4,16(sp)
 7f2:	e456                	sd	s5,8(sp)
 7f4:	e05a                	sd	s6,0(sp)
 7f6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f8:	02051493          	slli	s1,a0,0x20
 7fc:	9081                	srli	s1,s1,0x20
 7fe:	04bd                	addi	s1,s1,15
 800:	8091                	srli	s1,s1,0x4
 802:	0014899b          	addiw	s3,s1,1
 806:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 808:	00000517          	auipc	a0,0x0
 80c:	19853503          	ld	a0,408(a0) # 9a0 <freep>
 810:	c515                	beqz	a0,83c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 812:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 814:	4798                	lw	a4,8(a5)
 816:	02977f63          	bgeu	a4,s1,854 <malloc+0x70>
 81a:	8a4e                	mv	s4,s3
 81c:	0009871b          	sext.w	a4,s3
 820:	6685                	lui	a3,0x1
 822:	00d77363          	bgeu	a4,a3,828 <malloc+0x44>
 826:	6a05                	lui	s4,0x1
 828:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 82c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 830:	00000917          	auipc	s2,0x0
 834:	17090913          	addi	s2,s2,368 # 9a0 <freep>
  if(p == (char*)-1)
 838:	5afd                	li	s5,-1
 83a:	a895                	j	8ae <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 83c:	00000797          	auipc	a5,0x0
 840:	16c78793          	addi	a5,a5,364 # 9a8 <base>
 844:	00000717          	auipc	a4,0x0
 848:	14f73e23          	sd	a5,348(a4) # 9a0 <freep>
 84c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 84e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 852:	b7e1                	j	81a <malloc+0x36>
      if(p->s.size == nunits)
 854:	02e48c63          	beq	s1,a4,88c <malloc+0xa8>
        p->s.size -= nunits;
 858:	4137073b          	subw	a4,a4,s3
 85c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 85e:	02071693          	slli	a3,a4,0x20
 862:	01c6d713          	srli	a4,a3,0x1c
 866:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 868:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 86c:	00000717          	auipc	a4,0x0
 870:	12a73a23          	sd	a0,308(a4) # 9a0 <freep>
      return (void*)(p + 1);
 874:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 878:	70e2                	ld	ra,56(sp)
 87a:	7442                	ld	s0,48(sp)
 87c:	74a2                	ld	s1,40(sp)
 87e:	7902                	ld	s2,32(sp)
 880:	69e2                	ld	s3,24(sp)
 882:	6a42                	ld	s4,16(sp)
 884:	6aa2                	ld	s5,8(sp)
 886:	6b02                	ld	s6,0(sp)
 888:	6121                	addi	sp,sp,64
 88a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 88c:	6398                	ld	a4,0(a5)
 88e:	e118                	sd	a4,0(a0)
 890:	bff1                	j	86c <malloc+0x88>
  hp->s.size = nu;
 892:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 896:	0541                	addi	a0,a0,16
 898:	00000097          	auipc	ra,0x0
 89c:	ec4080e7          	jalr	-316(ra) # 75c <free>
  return freep;
 8a0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8a4:	d971                	beqz	a0,878 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a8:	4798                	lw	a4,8(a5)
 8aa:	fa9775e3          	bgeu	a4,s1,854 <malloc+0x70>
    if(p == freep)
 8ae:	00093703          	ld	a4,0(s2)
 8b2:	853e                	mv	a0,a5
 8b4:	fef719e3          	bne	a4,a5,8a6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8b8:	8552                	mv	a0,s4
 8ba:	00000097          	auipc	ra,0x0
 8be:	b5c080e7          	jalr	-1188(ra) # 416 <sbrk>
  if(p == (char*)-1)
 8c2:	fd5518e3          	bne	a0,s5,892 <malloc+0xae>
        return 0;
 8c6:	4501                	li	a0,0
 8c8:	bf45                	j	878 <malloc+0x94>
