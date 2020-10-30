
user/_xargs：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int 
main(int argc, char *argv[])
{
   0:	c1010113          	addi	sp,sp,-1008
   4:	3e113423          	sd	ra,1000(sp)
   8:	3e813023          	sd	s0,992(sp)
   c:	3c913c23          	sd	s1,984(sp)
  10:	3d213823          	sd	s2,976(sp)
  14:	3d313423          	sd	s3,968(sp)
  18:	3d413023          	sd	s4,960(sp)
  1c:	3b513c23          	sd	s5,952(sp)
  20:	3b613823          	sd	s6,944(sp)
  24:	3b713423          	sd	s7,936(sp)
  28:	3b813023          	sd	s8,928(sp)
  2c:	39913c23          	sd	s9,920(sp)
  30:	39a13823          	sd	s10,912(sp)
  34:	1f80                	addi	s0,sp,1008
    int i,j = 0,cmd_cnt = 0,cmd_len;
    char cmd_xargs[50],buf[50];
    char *p,*argv_exec[100];
    p = buf;
    if(argc < 2){
  36:	4785                	li	a5,1
  38:	06a7d863          	bge	a5,a0,a8 <main+0xa8>
  3c:	8d2e                	mv	s10,a1
  3e:	00858713          	addi	a4,a1,8
  42:	c1040793          	addi	a5,s0,-1008
  46:	0005099b          	sext.w	s3,a0
  4a:	ffe5061b          	addiw	a2,a0,-2
  4e:	02061693          	slli	a3,a2,0x20
  52:	01d6d613          	srli	a2,a3,0x1d
  56:	c1840693          	addi	a3,s0,-1000
  5a:	9636                	add	a2,a2,a3
        printf("Usage: xargs <cmd> ...\n");
        exit();
    }
    for(i = 1;i < argc;i++){
        argv_exec[i-1] = argv[i];
  5c:	6314                	ld	a3,0(a4)
  5e:	e394                	sd	a3,0(a5)
    for(i = 1;i < argc;i++){
  60:	0721                	addi	a4,a4,8
  62:	07a1                	addi	a5,a5,8
  64:	fec79ce3          	bne	a5,a2,5c <main+0x5c>
        cmd_cnt++;
  68:	39fd                	addiw	s3,s3,-1
    p = buf;
  6a:	f3040b13          	addi	s6,s0,-208
    int i,j = 0,cmd_cnt = 0,cmd_len;
  6e:	4901                	li	s2,0
    }
    while((cmd_len = read(0, cmd_xargs, sizeof(cmd_xargs))) > 0){
        for(i = 0;i < cmd_len;i++){     //逐个字符处理
            if(cmd_xargs[i] == '\n' || cmd_xargs[i] == ' '){
  70:	4aa9                	li	s5,10
                buf[j++] = 0;
                argv_exec[cmd_cnt++] = p;
                if(cmd_xargs[i] == '\n'){
                    j = 0;
                    argv_exec[cmd_cnt] = 0;
                    cmd_cnt = argc - 1;
  72:	fff50c1b          	addiw	s8,a0,-1
    while((cmd_len = read(0, cmd_xargs, sizeof(cmd_xargs))) > 0){
  76:	03200613          	li	a2,50
  7a:	f6840593          	addi	a1,s0,-152
  7e:	4501                	li	a0,0
  80:	00000097          	auipc	ra,0x0
  84:	2e4080e7          	jalr	740(ra) # 364 <read>
  88:	04a05863          	blez	a0,d8 <main+0xd8>
  8c:	f6840493          	addi	s1,s0,-152
  90:	fff50a1b          	addiw	s4,a0,-1
  94:	1a02                	slli	s4,s4,0x20
  96:	020a5a13          	srli	s4,s4,0x20
  9a:	f6940793          	addi	a5,s0,-151
  9e:	9a3e                	add	s4,s4,a5
                    j = 0;
  a0:	4c81                	li	s9,0
            if(cmd_xargs[i] == '\n' || cmd_xargs[i] == ' '){
  a2:	02000b93          	li	s7,32
  a6:	a879                	j	144 <main+0x144>
        printf("Usage: xargs <cmd> ...\n");
  a8:	00000517          	auipc	a0,0x0
  ac:	7e050513          	addi	a0,a0,2016 # 888 <malloc+0xe6>
  b0:	00000097          	auipc	ra,0x0
  b4:	634080e7          	jalr	1588(ra) # 6e4 <printf>
        exit();
  b8:	00000097          	auipc	ra,0x0
  bc:	294080e7          	jalr	660(ra) # 34c <exit>
                    if(fork() == 0){
                        exec(argv[1], argv_exec);
  c0:	c1040593          	addi	a1,s0,-1008
  c4:	008d3503          	ld	a0,8(s10)
  c8:	00000097          	auipc	ra,0x0
  cc:	2bc080e7          	jalr	700(ra) # 384 <exec>
                        exit();
  d0:	00000097          	auipc	ra,0x0
  d4:	27c080e7          	jalr	636(ra) # 34c <exit>
            else{
                buf[j++] = cmd_xargs[i];
            }
        }
    }
    wait();
  d8:	00000097          	auipc	ra,0x0
  dc:	27c080e7          	jalr	636(ra) # 354 <wait>
    exit();
  e0:	00000097          	auipc	ra,0x0
  e4:	26c080e7          	jalr	620(ra) # 34c <exit>
                buf[j++] = 0;
  e8:	fa040793          	addi	a5,s0,-96
  ec:	993e                	add	s2,s2,a5
  ee:	f8090823          	sb	zero,-112(s2)
                argv_exec[cmd_cnt++] = p;
  f2:	00399793          	slli	a5,s3,0x3
  f6:	fa040713          	addi	a4,s0,-96
  fa:	97ba                	add	a5,a5,a4
  fc:	c767b823          	sd	s6,-912(a5)
                    argv_exec[cmd_cnt] = 0;
 100:	2985                	addiw	s3,s3,1
 102:	098e                	slli	s3,s3,0x3
 104:	99ba                	add	s3,s3,a4
 106:	c609b823          	sd	zero,-912(s3)
                    cmd_cnt = argc - 1;
 10a:	89e2                	mv	s3,s8
                    if(fork() == 0){
 10c:	00000097          	auipc	ra,0x0
 110:	238080e7          	jalr	568(ra) # 344 <fork>
 114:	d555                	beqz	a0,c0 <main+0xc0>
                    j = 0;
 116:	8966                	mv	s2,s9
 118:	a839                	j	136 <main+0x136>
                buf[j++] = 0;
 11a:	fa040793          	addi	a5,s0,-96
 11e:	97ca                	add	a5,a5,s2
 120:	f8078823          	sb	zero,-112(a5)
                argv_exec[cmd_cnt++] = p;
 124:	00399793          	slli	a5,s3,0x3
 128:	fa040713          	addi	a4,s0,-96
 12c:	97ba                	add	a5,a5,a4
 12e:	c767b823          	sd	s6,-912(a5)
 132:	2985                	addiw	s3,s3,1
                buf[j++] = 0;
 134:	2905                	addiw	s2,s2,1
                p = buf + j;    //pointer reset
 136:	f3040793          	addi	a5,s0,-208
 13a:	01278b33          	add	s6,a5,s2
        for(i = 0;i < cmd_len;i++){     //逐个字符处理
 13e:	0485                	addi	s1,s1,1
 140:	f3448be3          	beq	s1,s4,76 <main+0x76>
            if(cmd_xargs[i] == '\n' || cmd_xargs[i] == ' '){
 144:	0004c783          	lbu	a5,0(s1)
 148:	fb5780e3          	beq	a5,s5,e8 <main+0xe8>
 14c:	fd7787e3          	beq	a5,s7,11a <main+0x11a>
                buf[j++] = cmd_xargs[i];
 150:	fa040713          	addi	a4,s0,-96
 154:	974a                	add	a4,a4,s2
 156:	f8f70823          	sb	a5,-112(a4)
 15a:	2905                	addiw	s2,s2,1
 15c:	b7cd                	j	13e <main+0x13e>

000000000000015e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 15e:	1141                	addi	sp,sp,-16
 160:	e422                	sd	s0,8(sp)
 162:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 164:	87aa                	mv	a5,a0
 166:	0585                	addi	a1,a1,1
 168:	0785                	addi	a5,a5,1
 16a:	fff5c703          	lbu	a4,-1(a1)
 16e:	fee78fa3          	sb	a4,-1(a5)
 172:	fb75                	bnez	a4,166 <strcpy+0x8>
    ;
  return os;
}
 174:	6422                	ld	s0,8(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret

000000000000017a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e422                	sd	s0,8(sp)
 17e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 180:	00054783          	lbu	a5,0(a0)
 184:	cb91                	beqz	a5,198 <strcmp+0x1e>
 186:	0005c703          	lbu	a4,0(a1)
 18a:	00f71763          	bne	a4,a5,198 <strcmp+0x1e>
    p++, q++;
 18e:	0505                	addi	a0,a0,1
 190:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 192:	00054783          	lbu	a5,0(a0)
 196:	fbe5                	bnez	a5,186 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 198:	0005c503          	lbu	a0,0(a1)
}
 19c:	40a7853b          	subw	a0,a5,a0
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <strlen>:

uint
strlen(const char *s)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	cf91                	beqz	a5,1cc <strlen+0x26>
 1b2:	0505                	addi	a0,a0,1
 1b4:	87aa                	mv	a5,a0
 1b6:	4685                	li	a3,1
 1b8:	9e89                	subw	a3,a3,a0
 1ba:	00f6853b          	addw	a0,a3,a5
 1be:	0785                	addi	a5,a5,1
 1c0:	fff7c703          	lbu	a4,-1(a5)
 1c4:	fb7d                	bnez	a4,1ba <strlen+0x14>
    ;
  return n;
}
 1c6:	6422                	ld	s0,8(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret
  for(n = 0; s[n]; n++)
 1cc:	4501                	li	a0,0
 1ce:	bfe5                	j	1c6 <strlen+0x20>

00000000000001d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1d6:	ca19                	beqz	a2,1ec <memset+0x1c>
 1d8:	87aa                	mv	a5,a0
 1da:	1602                	slli	a2,a2,0x20
 1dc:	9201                	srli	a2,a2,0x20
 1de:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1e2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1e6:	0785                	addi	a5,a5,1
 1e8:	fee79de3          	bne	a5,a4,1e2 <memset+0x12>
  }
  return dst;
}
 1ec:	6422                	ld	s0,8(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret

00000000000001f2 <strchr>:

char*
strchr(const char *s, char c)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e422                	sd	s0,8(sp)
 1f6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1f8:	00054783          	lbu	a5,0(a0)
 1fc:	cb99                	beqz	a5,212 <strchr+0x20>
    if(*s == c)
 1fe:	00f58763          	beq	a1,a5,20c <strchr+0x1a>
  for(; *s; s++)
 202:	0505                	addi	a0,a0,1
 204:	00054783          	lbu	a5,0(a0)
 208:	fbfd                	bnez	a5,1fe <strchr+0xc>
      return (char*)s;
  return 0;
 20a:	4501                	li	a0,0
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret
  return 0;
 212:	4501                	li	a0,0
 214:	bfe5                	j	20c <strchr+0x1a>

0000000000000216 <gets>:

char*
gets(char *buf, int max)
{
 216:	711d                	addi	sp,sp,-96
 218:	ec86                	sd	ra,88(sp)
 21a:	e8a2                	sd	s0,80(sp)
 21c:	e4a6                	sd	s1,72(sp)
 21e:	e0ca                	sd	s2,64(sp)
 220:	fc4e                	sd	s3,56(sp)
 222:	f852                	sd	s4,48(sp)
 224:	f456                	sd	s5,40(sp)
 226:	f05a                	sd	s6,32(sp)
 228:	ec5e                	sd	s7,24(sp)
 22a:	1080                	addi	s0,sp,96
 22c:	8baa                	mv	s7,a0
 22e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 230:	892a                	mv	s2,a0
 232:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 234:	4aa9                	li	s5,10
 236:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 238:	89a6                	mv	s3,s1
 23a:	2485                	addiw	s1,s1,1
 23c:	0344d863          	bge	s1,s4,26c <gets+0x56>
    cc = read(0, &c, 1);
 240:	4605                	li	a2,1
 242:	faf40593          	addi	a1,s0,-81
 246:	4501                	li	a0,0
 248:	00000097          	auipc	ra,0x0
 24c:	11c080e7          	jalr	284(ra) # 364 <read>
    if(cc < 1)
 250:	00a05e63          	blez	a0,26c <gets+0x56>
    buf[i++] = c;
 254:	faf44783          	lbu	a5,-81(s0)
 258:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 25c:	01578763          	beq	a5,s5,26a <gets+0x54>
 260:	0905                	addi	s2,s2,1
 262:	fd679be3          	bne	a5,s6,238 <gets+0x22>
  for(i=0; i+1 < max; ){
 266:	89a6                	mv	s3,s1
 268:	a011                	j	26c <gets+0x56>
 26a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 26c:	99de                	add	s3,s3,s7
 26e:	00098023          	sb	zero,0(s3)
  return buf;
}
 272:	855e                	mv	a0,s7
 274:	60e6                	ld	ra,88(sp)
 276:	6446                	ld	s0,80(sp)
 278:	64a6                	ld	s1,72(sp)
 27a:	6906                	ld	s2,64(sp)
 27c:	79e2                	ld	s3,56(sp)
 27e:	7a42                	ld	s4,48(sp)
 280:	7aa2                	ld	s5,40(sp)
 282:	7b02                	ld	s6,32(sp)
 284:	6be2                	ld	s7,24(sp)
 286:	6125                	addi	sp,sp,96
 288:	8082                	ret

000000000000028a <stat>:

int
stat(const char *n, struct stat *st)
{
 28a:	1101                	addi	sp,sp,-32
 28c:	ec06                	sd	ra,24(sp)
 28e:	e822                	sd	s0,16(sp)
 290:	e426                	sd	s1,8(sp)
 292:	e04a                	sd	s2,0(sp)
 294:	1000                	addi	s0,sp,32
 296:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 298:	4581                	li	a1,0
 29a:	00000097          	auipc	ra,0x0
 29e:	0f2080e7          	jalr	242(ra) # 38c <open>
  if(fd < 0)
 2a2:	02054563          	bltz	a0,2cc <stat+0x42>
 2a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2a8:	85ca                	mv	a1,s2
 2aa:	00000097          	auipc	ra,0x0
 2ae:	0fa080e7          	jalr	250(ra) # 3a4 <fstat>
 2b2:	892a                	mv	s2,a0
  close(fd);
 2b4:	8526                	mv	a0,s1
 2b6:	00000097          	auipc	ra,0x0
 2ba:	0be080e7          	jalr	190(ra) # 374 <close>
  return r;
}
 2be:	854a                	mv	a0,s2
 2c0:	60e2                	ld	ra,24(sp)
 2c2:	6442                	ld	s0,16(sp)
 2c4:	64a2                	ld	s1,8(sp)
 2c6:	6902                	ld	s2,0(sp)
 2c8:	6105                	addi	sp,sp,32
 2ca:	8082                	ret
    return -1;
 2cc:	597d                	li	s2,-1
 2ce:	bfc5                	j	2be <stat+0x34>

00000000000002d0 <atoi>:

int
atoi(const char *s)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d6:	00054603          	lbu	a2,0(a0)
 2da:	fd06079b          	addiw	a5,a2,-48
 2de:	0ff7f793          	andi	a5,a5,255
 2e2:	4725                	li	a4,9
 2e4:	02f76963          	bltu	a4,a5,316 <atoi+0x46>
 2e8:	86aa                	mv	a3,a0
  n = 0;
 2ea:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2ec:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2ee:	0685                	addi	a3,a3,1
 2f0:	0025179b          	slliw	a5,a0,0x2
 2f4:	9fa9                	addw	a5,a5,a0
 2f6:	0017979b          	slliw	a5,a5,0x1
 2fa:	9fb1                	addw	a5,a5,a2
 2fc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 300:	0006c603          	lbu	a2,0(a3)
 304:	fd06071b          	addiw	a4,a2,-48
 308:	0ff77713          	andi	a4,a4,255
 30c:	fee5f1e3          	bgeu	a1,a4,2ee <atoi+0x1e>
  return n;
}
 310:	6422                	ld	s0,8(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret
  n = 0;
 316:	4501                	li	a0,0
 318:	bfe5                	j	310 <atoi+0x40>

000000000000031a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e422                	sd	s0,8(sp)
 31e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 320:	00c05f63          	blez	a2,33e <memmove+0x24>
 324:	1602                	slli	a2,a2,0x20
 326:	9201                	srli	a2,a2,0x20
 328:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 32c:	87aa                	mv	a5,a0
    *dst++ = *src++;
 32e:	0585                	addi	a1,a1,1
 330:	0785                	addi	a5,a5,1
 332:	fff5c703          	lbu	a4,-1(a1)
 336:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 33a:	fed79ae3          	bne	a5,a3,32e <memmove+0x14>
  return vdst;
}
 33e:	6422                	ld	s0,8(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret

0000000000000344 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 344:	4885                	li	a7,1
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <exit>:
.global exit
exit:
 li a7, SYS_exit
 34c:	4889                	li	a7,2
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <wait>:
.global wait
wait:
 li a7, SYS_wait
 354:	488d                	li	a7,3
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 35c:	4891                	li	a7,4
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <read>:
.global read
read:
 li a7, SYS_read
 364:	4895                	li	a7,5
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <write>:
.global write
write:
 li a7, SYS_write
 36c:	48c1                	li	a7,16
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <close>:
.global close
close:
 li a7, SYS_close
 374:	48d5                	li	a7,21
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <kill>:
.global kill
kill:
 li a7, SYS_kill
 37c:	4899                	li	a7,6
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <exec>:
.global exec
exec:
 li a7, SYS_exec
 384:	489d                	li	a7,7
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <open>:
.global open
open:
 li a7, SYS_open
 38c:	48bd                	li	a7,15
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 394:	48c5                	li	a7,17
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 39c:	48c9                	li	a7,18
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a4:	48a1                	li	a7,8
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <link>:
.global link
link:
 li a7, SYS_link
 3ac:	48cd                	li	a7,19
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b4:	48d1                	li	a7,20
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3bc:	48a5                	li	a7,9
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c4:	48a9                	li	a7,10
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3cc:	48ad                	li	a7,11
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d4:	48b1                	li	a7,12
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3dc:	48b5                	li	a7,13
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e4:	48b9                	li	a7,14
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 3ec:	48d9                	li	a7,22
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <crash>:
.global crash
crash:
 li a7, SYS_crash
 3f4:	48dd                	li	a7,23
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <mount>:
.global mount
mount:
 li a7, SYS_mount
 3fc:	48e1                	li	a7,24
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <umount>:
.global umount
umount:
 li a7, SYS_umount
 404:	48e5                	li	a7,25
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40c:	1101                	addi	sp,sp,-32
 40e:	ec06                	sd	ra,24(sp)
 410:	e822                	sd	s0,16(sp)
 412:	1000                	addi	s0,sp,32
 414:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 418:	4605                	li	a2,1
 41a:	fef40593          	addi	a1,s0,-17
 41e:	00000097          	auipc	ra,0x0
 422:	f4e080e7          	jalr	-178(ra) # 36c <write>
}
 426:	60e2                	ld	ra,24(sp)
 428:	6442                	ld	s0,16(sp)
 42a:	6105                	addi	sp,sp,32
 42c:	8082                	ret

000000000000042e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42e:	7139                	addi	sp,sp,-64
 430:	fc06                	sd	ra,56(sp)
 432:	f822                	sd	s0,48(sp)
 434:	f426                	sd	s1,40(sp)
 436:	f04a                	sd	s2,32(sp)
 438:	ec4e                	sd	s3,24(sp)
 43a:	0080                	addi	s0,sp,64
 43c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43e:	c299                	beqz	a3,444 <printint+0x16>
 440:	0805c863          	bltz	a1,4d0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 444:	2581                	sext.w	a1,a1
  neg = 0;
 446:	4881                	li	a7,0
 448:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 44c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 44e:	2601                	sext.w	a2,a2
 450:	00000517          	auipc	a0,0x0
 454:	45850513          	addi	a0,a0,1112 # 8a8 <digits>
 458:	883a                	mv	a6,a4
 45a:	2705                	addiw	a4,a4,1
 45c:	02c5f7bb          	remuw	a5,a1,a2
 460:	1782                	slli	a5,a5,0x20
 462:	9381                	srli	a5,a5,0x20
 464:	97aa                	add	a5,a5,a0
 466:	0007c783          	lbu	a5,0(a5)
 46a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 46e:	0005879b          	sext.w	a5,a1
 472:	02c5d5bb          	divuw	a1,a1,a2
 476:	0685                	addi	a3,a3,1
 478:	fec7f0e3          	bgeu	a5,a2,458 <printint+0x2a>
  if(neg)
 47c:	00088b63          	beqz	a7,492 <printint+0x64>
    buf[i++] = '-';
 480:	fd040793          	addi	a5,s0,-48
 484:	973e                	add	a4,a4,a5
 486:	02d00793          	li	a5,45
 48a:	fef70823          	sb	a5,-16(a4)
 48e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 492:	02e05863          	blez	a4,4c2 <printint+0x94>
 496:	fc040793          	addi	a5,s0,-64
 49a:	00e78933          	add	s2,a5,a4
 49e:	fff78993          	addi	s3,a5,-1
 4a2:	99ba                	add	s3,s3,a4
 4a4:	377d                	addiw	a4,a4,-1
 4a6:	1702                	slli	a4,a4,0x20
 4a8:	9301                	srli	a4,a4,0x20
 4aa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ae:	fff94583          	lbu	a1,-1(s2)
 4b2:	8526                	mv	a0,s1
 4b4:	00000097          	auipc	ra,0x0
 4b8:	f58080e7          	jalr	-168(ra) # 40c <putc>
  while(--i >= 0)
 4bc:	197d                	addi	s2,s2,-1
 4be:	ff3918e3          	bne	s2,s3,4ae <printint+0x80>
}
 4c2:	70e2                	ld	ra,56(sp)
 4c4:	7442                	ld	s0,48(sp)
 4c6:	74a2                	ld	s1,40(sp)
 4c8:	7902                	ld	s2,32(sp)
 4ca:	69e2                	ld	s3,24(sp)
 4cc:	6121                	addi	sp,sp,64
 4ce:	8082                	ret
    x = -xx;
 4d0:	40b005bb          	negw	a1,a1
    neg = 1;
 4d4:	4885                	li	a7,1
    x = -xx;
 4d6:	bf8d                	j	448 <printint+0x1a>

00000000000004d8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d8:	7119                	addi	sp,sp,-128
 4da:	fc86                	sd	ra,120(sp)
 4dc:	f8a2                	sd	s0,112(sp)
 4de:	f4a6                	sd	s1,104(sp)
 4e0:	f0ca                	sd	s2,96(sp)
 4e2:	ecce                	sd	s3,88(sp)
 4e4:	e8d2                	sd	s4,80(sp)
 4e6:	e4d6                	sd	s5,72(sp)
 4e8:	e0da                	sd	s6,64(sp)
 4ea:	fc5e                	sd	s7,56(sp)
 4ec:	f862                	sd	s8,48(sp)
 4ee:	f466                	sd	s9,40(sp)
 4f0:	f06a                	sd	s10,32(sp)
 4f2:	ec6e                	sd	s11,24(sp)
 4f4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f6:	0005c903          	lbu	s2,0(a1)
 4fa:	18090f63          	beqz	s2,698 <vprintf+0x1c0>
 4fe:	8aaa                	mv	s5,a0
 500:	8b32                	mv	s6,a2
 502:	00158493          	addi	s1,a1,1
  state = 0;
 506:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 508:	02500a13          	li	s4,37
      if(c == 'd'){
 50c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 510:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 514:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 518:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 51c:	00000b97          	auipc	s7,0x0
 520:	38cb8b93          	addi	s7,s7,908 # 8a8 <digits>
 524:	a839                	j	542 <vprintf+0x6a>
        putc(fd, c);
 526:	85ca                	mv	a1,s2
 528:	8556                	mv	a0,s5
 52a:	00000097          	auipc	ra,0x0
 52e:	ee2080e7          	jalr	-286(ra) # 40c <putc>
 532:	a019                	j	538 <vprintf+0x60>
    } else if(state == '%'){
 534:	01498f63          	beq	s3,s4,552 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 538:	0485                	addi	s1,s1,1
 53a:	fff4c903          	lbu	s2,-1(s1)
 53e:	14090d63          	beqz	s2,698 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 542:	0009079b          	sext.w	a5,s2
    if(state == 0){
 546:	fe0997e3          	bnez	s3,534 <vprintf+0x5c>
      if(c == '%'){
 54a:	fd479ee3          	bne	a5,s4,526 <vprintf+0x4e>
        state = '%';
 54e:	89be                	mv	s3,a5
 550:	b7e5                	j	538 <vprintf+0x60>
      if(c == 'd'){
 552:	05878063          	beq	a5,s8,592 <vprintf+0xba>
      } else if(c == 'l') {
 556:	05978c63          	beq	a5,s9,5ae <vprintf+0xd6>
      } else if(c == 'x') {
 55a:	07a78863          	beq	a5,s10,5ca <vprintf+0xf2>
      } else if(c == 'p') {
 55e:	09b78463          	beq	a5,s11,5e6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 562:	07300713          	li	a4,115
 566:	0ce78663          	beq	a5,a4,632 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 56a:	06300713          	li	a4,99
 56e:	0ee78e63          	beq	a5,a4,66a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 572:	11478863          	beq	a5,s4,682 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 576:	85d2                	mv	a1,s4
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	e92080e7          	jalr	-366(ra) # 40c <putc>
        putc(fd, c);
 582:	85ca                	mv	a1,s2
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	e86080e7          	jalr	-378(ra) # 40c <putc>
      }
      state = 0;
 58e:	4981                	li	s3,0
 590:	b765                	j	538 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 592:	008b0913          	addi	s2,s6,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000b2583          	lw	a1,0(s6)
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	e8e080e7          	jalr	-370(ra) # 42e <printint>
 5a8:	8b4a                	mv	s6,s2
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	b771                	j	538 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ae:	008b0913          	addi	s2,s6,8
 5b2:	4681                	li	a3,0
 5b4:	4629                	li	a2,10
 5b6:	000b2583          	lw	a1,0(s6)
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	e72080e7          	jalr	-398(ra) # 42e <printint>
 5c4:	8b4a                	mv	s6,s2
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	bf85                	j	538 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5ca:	008b0913          	addi	s2,s6,8
 5ce:	4681                	li	a3,0
 5d0:	4641                	li	a2,16
 5d2:	000b2583          	lw	a1,0(s6)
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e56080e7          	jalr	-426(ra) # 42e <printint>
 5e0:	8b4a                	mv	s6,s2
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	bf91                	j	538 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5e6:	008b0793          	addi	a5,s6,8
 5ea:	f8f43423          	sd	a5,-120(s0)
 5ee:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5f2:	03000593          	li	a1,48
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	e14080e7          	jalr	-492(ra) # 40c <putc>
  putc(fd, 'x');
 600:	85ea                	mv	a1,s10
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	e08080e7          	jalr	-504(ra) # 40c <putc>
 60c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60e:	03c9d793          	srli	a5,s3,0x3c
 612:	97de                	add	a5,a5,s7
 614:	0007c583          	lbu	a1,0(a5)
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	df2080e7          	jalr	-526(ra) # 40c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 622:	0992                	slli	s3,s3,0x4
 624:	397d                	addiw	s2,s2,-1
 626:	fe0914e3          	bnez	s2,60e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 62a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 62e:	4981                	li	s3,0
 630:	b721                	j	538 <vprintf+0x60>
        s = va_arg(ap, char*);
 632:	008b0993          	addi	s3,s6,8
 636:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 63a:	02090163          	beqz	s2,65c <vprintf+0x184>
        while(*s != 0){
 63e:	00094583          	lbu	a1,0(s2)
 642:	c9a1                	beqz	a1,692 <vprintf+0x1ba>
          putc(fd, *s);
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	dc6080e7          	jalr	-570(ra) # 40c <putc>
          s++;
 64e:	0905                	addi	s2,s2,1
        while(*s != 0){
 650:	00094583          	lbu	a1,0(s2)
 654:	f9e5                	bnez	a1,644 <vprintf+0x16c>
        s = va_arg(ap, char*);
 656:	8b4e                	mv	s6,s3
      state = 0;
 658:	4981                	li	s3,0
 65a:	bdf9                	j	538 <vprintf+0x60>
          s = "(null)";
 65c:	00000917          	auipc	s2,0x0
 660:	24490913          	addi	s2,s2,580 # 8a0 <malloc+0xfe>
        while(*s != 0){
 664:	02800593          	li	a1,40
 668:	bff1                	j	644 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 66a:	008b0913          	addi	s2,s6,8
 66e:	000b4583          	lbu	a1,0(s6)
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	d98080e7          	jalr	-616(ra) # 40c <putc>
 67c:	8b4a                	mv	s6,s2
      state = 0;
 67e:	4981                	li	s3,0
 680:	bd65                	j	538 <vprintf+0x60>
        putc(fd, c);
 682:	85d2                	mv	a1,s4
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	d86080e7          	jalr	-634(ra) # 40c <putc>
      state = 0;
 68e:	4981                	li	s3,0
 690:	b565                	j	538 <vprintf+0x60>
        s = va_arg(ap, char*);
 692:	8b4e                	mv	s6,s3
      state = 0;
 694:	4981                	li	s3,0
 696:	b54d                	j	538 <vprintf+0x60>
    }
  }
}
 698:	70e6                	ld	ra,120(sp)
 69a:	7446                	ld	s0,112(sp)
 69c:	74a6                	ld	s1,104(sp)
 69e:	7906                	ld	s2,96(sp)
 6a0:	69e6                	ld	s3,88(sp)
 6a2:	6a46                	ld	s4,80(sp)
 6a4:	6aa6                	ld	s5,72(sp)
 6a6:	6b06                	ld	s6,64(sp)
 6a8:	7be2                	ld	s7,56(sp)
 6aa:	7c42                	ld	s8,48(sp)
 6ac:	7ca2                	ld	s9,40(sp)
 6ae:	7d02                	ld	s10,32(sp)
 6b0:	6de2                	ld	s11,24(sp)
 6b2:	6109                	addi	sp,sp,128
 6b4:	8082                	ret

00000000000006b6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b6:	715d                	addi	sp,sp,-80
 6b8:	ec06                	sd	ra,24(sp)
 6ba:	e822                	sd	s0,16(sp)
 6bc:	1000                	addi	s0,sp,32
 6be:	e010                	sd	a2,0(s0)
 6c0:	e414                	sd	a3,8(s0)
 6c2:	e818                	sd	a4,16(s0)
 6c4:	ec1c                	sd	a5,24(s0)
 6c6:	03043023          	sd	a6,32(s0)
 6ca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ce:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6d2:	8622                	mv	a2,s0
 6d4:	00000097          	auipc	ra,0x0
 6d8:	e04080e7          	jalr	-508(ra) # 4d8 <vprintf>
}
 6dc:	60e2                	ld	ra,24(sp)
 6de:	6442                	ld	s0,16(sp)
 6e0:	6161                	addi	sp,sp,80
 6e2:	8082                	ret

00000000000006e4 <printf>:

void
printf(const char *fmt, ...)
{
 6e4:	711d                	addi	sp,sp,-96
 6e6:	ec06                	sd	ra,24(sp)
 6e8:	e822                	sd	s0,16(sp)
 6ea:	1000                	addi	s0,sp,32
 6ec:	e40c                	sd	a1,8(s0)
 6ee:	e810                	sd	a2,16(s0)
 6f0:	ec14                	sd	a3,24(s0)
 6f2:	f018                	sd	a4,32(s0)
 6f4:	f41c                	sd	a5,40(s0)
 6f6:	03043823          	sd	a6,48(s0)
 6fa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6fe:	00840613          	addi	a2,s0,8
 702:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 706:	85aa                	mv	a1,a0
 708:	4505                	li	a0,1
 70a:	00000097          	auipc	ra,0x0
 70e:	dce080e7          	jalr	-562(ra) # 4d8 <vprintf>
}
 712:	60e2                	ld	ra,24(sp)
 714:	6442                	ld	s0,16(sp)
 716:	6125                	addi	sp,sp,96
 718:	8082                	ret

000000000000071a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71a:	1141                	addi	sp,sp,-16
 71c:	e422                	sd	s0,8(sp)
 71e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 720:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 724:	00000797          	auipc	a5,0x0
 728:	19c7b783          	ld	a5,412(a5) # 8c0 <freep>
 72c:	a805                	j	75c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 72e:	4618                	lw	a4,8(a2)
 730:	9db9                	addw	a1,a1,a4
 732:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 736:	6398                	ld	a4,0(a5)
 738:	6318                	ld	a4,0(a4)
 73a:	fee53823          	sd	a4,-16(a0)
 73e:	a091                	j	782 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 740:	ff852703          	lw	a4,-8(a0)
 744:	9e39                	addw	a2,a2,a4
 746:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 748:	ff053703          	ld	a4,-16(a0)
 74c:	e398                	sd	a4,0(a5)
 74e:	a099                	j	794 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 750:	6398                	ld	a4,0(a5)
 752:	00e7e463          	bltu	a5,a4,75a <free+0x40>
 756:	00e6ea63          	bltu	a3,a4,76a <free+0x50>
{
 75a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75c:	fed7fae3          	bgeu	a5,a3,750 <free+0x36>
 760:	6398                	ld	a4,0(a5)
 762:	00e6e463          	bltu	a3,a4,76a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 766:	fee7eae3          	bltu	a5,a4,75a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 76a:	ff852583          	lw	a1,-8(a0)
 76e:	6390                	ld	a2,0(a5)
 770:	02059813          	slli	a6,a1,0x20
 774:	01c85713          	srli	a4,a6,0x1c
 778:	9736                	add	a4,a4,a3
 77a:	fae60ae3          	beq	a2,a4,72e <free+0x14>
    bp->s.ptr = p->s.ptr;
 77e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 782:	4790                	lw	a2,8(a5)
 784:	02061593          	slli	a1,a2,0x20
 788:	01c5d713          	srli	a4,a1,0x1c
 78c:	973e                	add	a4,a4,a5
 78e:	fae689e3          	beq	a3,a4,740 <free+0x26>
  } else
    p->s.ptr = bp;
 792:	e394                	sd	a3,0(a5)
  freep = p;
 794:	00000717          	auipc	a4,0x0
 798:	12f73623          	sd	a5,300(a4) # 8c0 <freep>
}
 79c:	6422                	ld	s0,8(sp)
 79e:	0141                	addi	sp,sp,16
 7a0:	8082                	ret

00000000000007a2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a2:	7139                	addi	sp,sp,-64
 7a4:	fc06                	sd	ra,56(sp)
 7a6:	f822                	sd	s0,48(sp)
 7a8:	f426                	sd	s1,40(sp)
 7aa:	f04a                	sd	s2,32(sp)
 7ac:	ec4e                	sd	s3,24(sp)
 7ae:	e852                	sd	s4,16(sp)
 7b0:	e456                	sd	s5,8(sp)
 7b2:	e05a                	sd	s6,0(sp)
 7b4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b6:	02051493          	slli	s1,a0,0x20
 7ba:	9081                	srli	s1,s1,0x20
 7bc:	04bd                	addi	s1,s1,15
 7be:	8091                	srli	s1,s1,0x4
 7c0:	0014899b          	addiw	s3,s1,1
 7c4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7c6:	00000517          	auipc	a0,0x0
 7ca:	0fa53503          	ld	a0,250(a0) # 8c0 <freep>
 7ce:	c515                	beqz	a0,7fa <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d2:	4798                	lw	a4,8(a5)
 7d4:	02977f63          	bgeu	a4,s1,812 <malloc+0x70>
 7d8:	8a4e                	mv	s4,s3
 7da:	0009871b          	sext.w	a4,s3
 7de:	6685                	lui	a3,0x1
 7e0:	00d77363          	bgeu	a4,a3,7e6 <malloc+0x44>
 7e4:	6a05                	lui	s4,0x1
 7e6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ea:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ee:	00000917          	auipc	s2,0x0
 7f2:	0d290913          	addi	s2,s2,210 # 8c0 <freep>
  if(p == (char*)-1)
 7f6:	5afd                	li	s5,-1
 7f8:	a895                	j	86c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7fa:	00000797          	auipc	a5,0x0
 7fe:	0ce78793          	addi	a5,a5,206 # 8c8 <base>
 802:	00000717          	auipc	a4,0x0
 806:	0af73f23          	sd	a5,190(a4) # 8c0 <freep>
 80a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 80c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 810:	b7e1                	j	7d8 <malloc+0x36>
      if(p->s.size == nunits)
 812:	02e48c63          	beq	s1,a4,84a <malloc+0xa8>
        p->s.size -= nunits;
 816:	4137073b          	subw	a4,a4,s3
 81a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 81c:	02071693          	slli	a3,a4,0x20
 820:	01c6d713          	srli	a4,a3,0x1c
 824:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 826:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 82a:	00000717          	auipc	a4,0x0
 82e:	08a73b23          	sd	a0,150(a4) # 8c0 <freep>
      return (void*)(p + 1);
 832:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 836:	70e2                	ld	ra,56(sp)
 838:	7442                	ld	s0,48(sp)
 83a:	74a2                	ld	s1,40(sp)
 83c:	7902                	ld	s2,32(sp)
 83e:	69e2                	ld	s3,24(sp)
 840:	6a42                	ld	s4,16(sp)
 842:	6aa2                	ld	s5,8(sp)
 844:	6b02                	ld	s6,0(sp)
 846:	6121                	addi	sp,sp,64
 848:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 84a:	6398                	ld	a4,0(a5)
 84c:	e118                	sd	a4,0(a0)
 84e:	bff1                	j	82a <malloc+0x88>
  hp->s.size = nu;
 850:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 854:	0541                	addi	a0,a0,16
 856:	00000097          	auipc	ra,0x0
 85a:	ec4080e7          	jalr	-316(ra) # 71a <free>
  return freep;
 85e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 862:	d971                	beqz	a0,836 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 864:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 866:	4798                	lw	a4,8(a5)
 868:	fa9775e3          	bgeu	a4,s1,812 <malloc+0x70>
    if(p == freep)
 86c:	00093703          	ld	a4,0(s2)
 870:	853e                	mv	a0,a5
 872:	fef719e3          	bne	a4,a5,864 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 876:	8552                	mv	a0,s4
 878:	00000097          	auipc	ra,0x0
 87c:	b5c080e7          	jalr	-1188(ra) # 3d4 <sbrk>
  if(p == (char*)-1)
 880:	fd5518e3          	bne	a0,s5,850 <malloc+0xae>
        return 0;
 884:	4501                	li	a0,0
 886:	bf45                	j	836 <malloc+0x94>
