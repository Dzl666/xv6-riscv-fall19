
user/_wc：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	8fbd8d93          	addi	s11,s11,-1797 # 929 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	880a0a13          	addi	s4,s4,-1920 # 8b8 <malloc+0xe6>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1dc080e7          	jalr	476(ra) # 222 <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01248d63          	beq	s1,s2,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2b85                	addiw	s7,s7,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0997e3          	bnez	s3,52 <wc+0x52>
        w++;
  68:	2c05                	addiw	s8,s8,1
        inword = 1;
  6a:	4985                	li	s3,1
  6c:	b7dd                	j	52 <wc+0x52>
      c++;
  6e:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	00001597          	auipc	a1,0x1
  7a:	8b258593          	addi	a1,a1,-1870 # 928 <buf>
  7e:	f8843503          	ld	a0,-120(s0)
  82:	00000097          	auipc	ra,0x0
  86:	312080e7          	jalr	786(ra) # 394 <read>
  8a:	00a05f63          	blez	a0,a8 <wc+0xa8>
    for(i=0; i<n; i++){
  8e:	00001497          	auipc	s1,0x1
  92:	89a48493          	addi	s1,s1,-1894 # 928 <buf>
  96:	00050d1b          	sext.w	s10,a0
  9a:	fff5091b          	addiw	s2,a0,-1
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	996e                	add	s2,s2,s11
  a6:	bf4d                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  a8:	02054e63          	bltz	a0,e4 <wc+0xe4>
    printf("wc: read error\n");
    exit();
  }
  printf("%d %d %d %s\n", l, w, c, name);
  ac:	f8043703          	ld	a4,-128(s0)
  b0:	86e6                	mv	a3,s9
  b2:	8662                	mv	a2,s8
  b4:	85de                	mv	a1,s7
  b6:	00001517          	auipc	a0,0x1
  ba:	81a50513          	addi	a0,a0,-2022 # 8d0 <malloc+0xfe>
  be:	00000097          	auipc	ra,0x0
  c2:	656080e7          	jalr	1622(ra) # 714 <printf>
}
  c6:	70e6                	ld	ra,120(sp)
  c8:	7446                	ld	s0,112(sp)
  ca:	74a6                	ld	s1,104(sp)
  cc:	7906                	ld	s2,96(sp)
  ce:	69e6                	ld	s3,88(sp)
  d0:	6a46                	ld	s4,80(sp)
  d2:	6aa6                	ld	s5,72(sp)
  d4:	6b06                	ld	s6,64(sp)
  d6:	7be2                	ld	s7,56(sp)
  d8:	7c42                	ld	s8,48(sp)
  da:	7ca2                	ld	s9,40(sp)
  dc:	7d02                	ld	s10,32(sp)
  de:	6de2                	ld	s11,24(sp)
  e0:	6109                	addi	sp,sp,128
  e2:	8082                	ret
    printf("wc: read error\n");
  e4:	00000517          	auipc	a0,0x0
  e8:	7dc50513          	addi	a0,a0,2012 # 8c0 <malloc+0xee>
  ec:	00000097          	auipc	ra,0x0
  f0:	628080e7          	jalr	1576(ra) # 714 <printf>
    exit();
  f4:	00000097          	auipc	ra,0x0
  f8:	288080e7          	jalr	648(ra) # 37c <exit>

00000000000000fc <main>:

int
main(int argc, char *argv[])
{
  fc:	7179                	addi	sp,sp,-48
  fe:	f406                	sd	ra,40(sp)
 100:	f022                	sd	s0,32(sp)
 102:	ec26                	sd	s1,24(sp)
 104:	e84a                	sd	s2,16(sp)
 106:	e44e                	sd	s3,8(sp)
 108:	e052                	sd	s4,0(sp)
 10a:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 10c:	4785                	li	a5,1
 10e:	04a7d663          	bge	a5,a0,15a <main+0x5e>
 112:	00858493          	addi	s1,a1,8
 116:	ffe5099b          	addiw	s3,a0,-2
 11a:	02099793          	slli	a5,s3,0x20
 11e:	01d7d993          	srli	s3,a5,0x1d
 122:	05c1                	addi	a1,a1,16
 124:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 126:	4581                	li	a1,0
 128:	6088                	ld	a0,0(s1)
 12a:	00000097          	auipc	ra,0x0
 12e:	292080e7          	jalr	658(ra) # 3bc <open>
 132:	892a                	mv	s2,a0
 134:	04054063          	bltz	a0,174 <main+0x78>
      printf("wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 138:	608c                	ld	a1,0(s1)
 13a:	00000097          	auipc	ra,0x0
 13e:	ec6080e7          	jalr	-314(ra) # 0 <wc>
    close(fd);
 142:	854a                	mv	a0,s2
 144:	00000097          	auipc	ra,0x0
 148:	260080e7          	jalr	608(ra) # 3a4 <close>
  for(i = 1; i < argc; i++){
 14c:	04a1                	addi	s1,s1,8
 14e:	fd349ce3          	bne	s1,s3,126 <main+0x2a>
  }
  exit();
 152:	00000097          	auipc	ra,0x0
 156:	22a080e7          	jalr	554(ra) # 37c <exit>
    wc(0, "");
 15a:	00000597          	auipc	a1,0x0
 15e:	78658593          	addi	a1,a1,1926 # 8e0 <malloc+0x10e>
 162:	4501                	li	a0,0
 164:	00000097          	auipc	ra,0x0
 168:	e9c080e7          	jalr	-356(ra) # 0 <wc>
    exit();
 16c:	00000097          	auipc	ra,0x0
 170:	210080e7          	jalr	528(ra) # 37c <exit>
      printf("wc: cannot open %s\n", argv[i]);
 174:	608c                	ld	a1,0(s1)
 176:	00000517          	auipc	a0,0x0
 17a:	77250513          	addi	a0,a0,1906 # 8e8 <malloc+0x116>
 17e:	00000097          	auipc	ra,0x0
 182:	596080e7          	jalr	1430(ra) # 714 <printf>
      exit();
 186:	00000097          	auipc	ra,0x0
 18a:	1f6080e7          	jalr	502(ra) # 37c <exit>

000000000000018e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 194:	87aa                	mv	a5,a0
 196:	0585                	addi	a1,a1,1
 198:	0785                	addi	a5,a5,1
 19a:	fff5c703          	lbu	a4,-1(a1)
 19e:	fee78fa3          	sb	a4,-1(a5)
 1a2:	fb75                	bnez	a4,196 <strcpy+0x8>
    ;
  return os;
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	cb91                	beqz	a5,1c8 <strcmp+0x1e>
 1b6:	0005c703          	lbu	a4,0(a1)
 1ba:	00f71763          	bne	a4,a5,1c8 <strcmp+0x1e>
    p++, q++;
 1be:	0505                	addi	a0,a0,1
 1c0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1c2:	00054783          	lbu	a5,0(a0)
 1c6:	fbe5                	bnez	a5,1b6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1c8:	0005c503          	lbu	a0,0(a1)
}
 1cc:	40a7853b          	subw	a0,a5,a0
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret

00000000000001d6 <strlen>:

uint
strlen(const char *s)
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1dc:	00054783          	lbu	a5,0(a0)
 1e0:	cf91                	beqz	a5,1fc <strlen+0x26>
 1e2:	0505                	addi	a0,a0,1
 1e4:	87aa                	mv	a5,a0
 1e6:	4685                	li	a3,1
 1e8:	9e89                	subw	a3,a3,a0
 1ea:	00f6853b          	addw	a0,a3,a5
 1ee:	0785                	addi	a5,a5,1
 1f0:	fff7c703          	lbu	a4,-1(a5)
 1f4:	fb7d                	bnez	a4,1ea <strlen+0x14>
    ;
  return n;
}
 1f6:	6422                	ld	s0,8(sp)
 1f8:	0141                	addi	sp,sp,16
 1fa:	8082                	ret
  for(n = 0; s[n]; n++)
 1fc:	4501                	li	a0,0
 1fe:	bfe5                	j	1f6 <strlen+0x20>

0000000000000200 <memset>:

void*
memset(void *dst, int c, uint n)
{
 200:	1141                	addi	sp,sp,-16
 202:	e422                	sd	s0,8(sp)
 204:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 206:	ca19                	beqz	a2,21c <memset+0x1c>
 208:	87aa                	mv	a5,a0
 20a:	1602                	slli	a2,a2,0x20
 20c:	9201                	srli	a2,a2,0x20
 20e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 212:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 216:	0785                	addi	a5,a5,1
 218:	fee79de3          	bne	a5,a4,212 <memset+0x12>
  }
  return dst;
}
 21c:	6422                	ld	s0,8(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret

0000000000000222 <strchr>:

char*
strchr(const char *s, char c)
{
 222:	1141                	addi	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	addi	s0,sp,16
  for(; *s; s++)
 228:	00054783          	lbu	a5,0(a0)
 22c:	cb99                	beqz	a5,242 <strchr+0x20>
    if(*s == c)
 22e:	00f58763          	beq	a1,a5,23c <strchr+0x1a>
  for(; *s; s++)
 232:	0505                	addi	a0,a0,1
 234:	00054783          	lbu	a5,0(a0)
 238:	fbfd                	bnez	a5,22e <strchr+0xc>
      return (char*)s;
  return 0;
 23a:	4501                	li	a0,0
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret
  return 0;
 242:	4501                	li	a0,0
 244:	bfe5                	j	23c <strchr+0x1a>

0000000000000246 <gets>:

char*
gets(char *buf, int max)
{
 246:	711d                	addi	sp,sp,-96
 248:	ec86                	sd	ra,88(sp)
 24a:	e8a2                	sd	s0,80(sp)
 24c:	e4a6                	sd	s1,72(sp)
 24e:	e0ca                	sd	s2,64(sp)
 250:	fc4e                	sd	s3,56(sp)
 252:	f852                	sd	s4,48(sp)
 254:	f456                	sd	s5,40(sp)
 256:	f05a                	sd	s6,32(sp)
 258:	ec5e                	sd	s7,24(sp)
 25a:	1080                	addi	s0,sp,96
 25c:	8baa                	mv	s7,a0
 25e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 260:	892a                	mv	s2,a0
 262:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 264:	4aa9                	li	s5,10
 266:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 268:	89a6                	mv	s3,s1
 26a:	2485                	addiw	s1,s1,1
 26c:	0344d863          	bge	s1,s4,29c <gets+0x56>
    cc = read(0, &c, 1);
 270:	4605                	li	a2,1
 272:	faf40593          	addi	a1,s0,-81
 276:	4501                	li	a0,0
 278:	00000097          	auipc	ra,0x0
 27c:	11c080e7          	jalr	284(ra) # 394 <read>
    if(cc < 1)
 280:	00a05e63          	blez	a0,29c <gets+0x56>
    buf[i++] = c;
 284:	faf44783          	lbu	a5,-81(s0)
 288:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 28c:	01578763          	beq	a5,s5,29a <gets+0x54>
 290:	0905                	addi	s2,s2,1
 292:	fd679be3          	bne	a5,s6,268 <gets+0x22>
  for(i=0; i+1 < max; ){
 296:	89a6                	mv	s3,s1
 298:	a011                	j	29c <gets+0x56>
 29a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 29c:	99de                	add	s3,s3,s7
 29e:	00098023          	sb	zero,0(s3)
  return buf;
}
 2a2:	855e                	mv	a0,s7
 2a4:	60e6                	ld	ra,88(sp)
 2a6:	6446                	ld	s0,80(sp)
 2a8:	64a6                	ld	s1,72(sp)
 2aa:	6906                	ld	s2,64(sp)
 2ac:	79e2                	ld	s3,56(sp)
 2ae:	7a42                	ld	s4,48(sp)
 2b0:	7aa2                	ld	s5,40(sp)
 2b2:	7b02                	ld	s6,32(sp)
 2b4:	6be2                	ld	s7,24(sp)
 2b6:	6125                	addi	sp,sp,96
 2b8:	8082                	ret

00000000000002ba <stat>:

int
stat(const char *n, struct stat *st)
{
 2ba:	1101                	addi	sp,sp,-32
 2bc:	ec06                	sd	ra,24(sp)
 2be:	e822                	sd	s0,16(sp)
 2c0:	e426                	sd	s1,8(sp)
 2c2:	e04a                	sd	s2,0(sp)
 2c4:	1000                	addi	s0,sp,32
 2c6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c8:	4581                	li	a1,0
 2ca:	00000097          	auipc	ra,0x0
 2ce:	0f2080e7          	jalr	242(ra) # 3bc <open>
  if(fd < 0)
 2d2:	02054563          	bltz	a0,2fc <stat+0x42>
 2d6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d8:	85ca                	mv	a1,s2
 2da:	00000097          	auipc	ra,0x0
 2de:	0fa080e7          	jalr	250(ra) # 3d4 <fstat>
 2e2:	892a                	mv	s2,a0
  close(fd);
 2e4:	8526                	mv	a0,s1
 2e6:	00000097          	auipc	ra,0x0
 2ea:	0be080e7          	jalr	190(ra) # 3a4 <close>
  return r;
}
 2ee:	854a                	mv	a0,s2
 2f0:	60e2                	ld	ra,24(sp)
 2f2:	6442                	ld	s0,16(sp)
 2f4:	64a2                	ld	s1,8(sp)
 2f6:	6902                	ld	s2,0(sp)
 2f8:	6105                	addi	sp,sp,32
 2fa:	8082                	ret
    return -1;
 2fc:	597d                	li	s2,-1
 2fe:	bfc5                	j	2ee <stat+0x34>

0000000000000300 <atoi>:

int
atoi(const char *s)
{
 300:	1141                	addi	sp,sp,-16
 302:	e422                	sd	s0,8(sp)
 304:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 306:	00054603          	lbu	a2,0(a0)
 30a:	fd06079b          	addiw	a5,a2,-48
 30e:	0ff7f793          	andi	a5,a5,255
 312:	4725                	li	a4,9
 314:	02f76963          	bltu	a4,a5,346 <atoi+0x46>
 318:	86aa                	mv	a3,a0
  n = 0;
 31a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 31c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 31e:	0685                	addi	a3,a3,1
 320:	0025179b          	slliw	a5,a0,0x2
 324:	9fa9                	addw	a5,a5,a0
 326:	0017979b          	slliw	a5,a5,0x1
 32a:	9fb1                	addw	a5,a5,a2
 32c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 330:	0006c603          	lbu	a2,0(a3)
 334:	fd06071b          	addiw	a4,a2,-48
 338:	0ff77713          	andi	a4,a4,255
 33c:	fee5f1e3          	bgeu	a1,a4,31e <atoi+0x1e>
  return n;
}
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret
  n = 0;
 346:	4501                	li	a0,0
 348:	bfe5                	j	340 <atoi+0x40>

000000000000034a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e422                	sd	s0,8(sp)
 34e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 350:	00c05f63          	blez	a2,36e <memmove+0x24>
 354:	1602                	slli	a2,a2,0x20
 356:	9201                	srli	a2,a2,0x20
 358:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 35c:	87aa                	mv	a5,a0
    *dst++ = *src++;
 35e:	0585                	addi	a1,a1,1
 360:	0785                	addi	a5,a5,1
 362:	fff5c703          	lbu	a4,-1(a1)
 366:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 36a:	fed79ae3          	bne	a5,a3,35e <memmove+0x14>
  return vdst;
}
 36e:	6422                	ld	s0,8(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret

0000000000000374 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 374:	4885                	li	a7,1
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <exit>:
.global exit
exit:
 li a7, SYS_exit
 37c:	4889                	li	a7,2
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <wait>:
.global wait
wait:
 li a7, SYS_wait
 384:	488d                	li	a7,3
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38c:	4891                	li	a7,4
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <read>:
.global read
read:
 li a7, SYS_read
 394:	4895                	li	a7,5
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <write>:
.global write
write:
 li a7, SYS_write
 39c:	48c1                	li	a7,16
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <close>:
.global close
close:
 li a7, SYS_close
 3a4:	48d5                	li	a7,21
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ac:	4899                	li	a7,6
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b4:	489d                	li	a7,7
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <open>:
.global open
open:
 li a7, SYS_open
 3bc:	48bd                	li	a7,15
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c4:	48c5                	li	a7,17
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3cc:	48c9                	li	a7,18
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d4:	48a1                	li	a7,8
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <link>:
.global link
link:
 li a7, SYS_link
 3dc:	48cd                	li	a7,19
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e4:	48d1                	li	a7,20
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ec:	48a5                	li	a7,9
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f4:	48a9                	li	a7,10
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fc:	48ad                	li	a7,11
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 404:	48b1                	li	a7,12
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 40c:	48b5                	li	a7,13
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 414:	48b9                	li	a7,14
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 41c:	48d9                	li	a7,22
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <crash>:
.global crash
crash:
 li a7, SYS_crash
 424:	48dd                	li	a7,23
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <mount>:
.global mount
mount:
 li a7, SYS_mount
 42c:	48e1                	li	a7,24
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <umount>:
.global umount
umount:
 li a7, SYS_umount
 434:	48e5                	li	a7,25
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 43c:	1101                	addi	sp,sp,-32
 43e:	ec06                	sd	ra,24(sp)
 440:	e822                	sd	s0,16(sp)
 442:	1000                	addi	s0,sp,32
 444:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 448:	4605                	li	a2,1
 44a:	fef40593          	addi	a1,s0,-17
 44e:	00000097          	auipc	ra,0x0
 452:	f4e080e7          	jalr	-178(ra) # 39c <write>
}
 456:	60e2                	ld	ra,24(sp)
 458:	6442                	ld	s0,16(sp)
 45a:	6105                	addi	sp,sp,32
 45c:	8082                	ret

000000000000045e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45e:	7139                	addi	sp,sp,-64
 460:	fc06                	sd	ra,56(sp)
 462:	f822                	sd	s0,48(sp)
 464:	f426                	sd	s1,40(sp)
 466:	f04a                	sd	s2,32(sp)
 468:	ec4e                	sd	s3,24(sp)
 46a:	0080                	addi	s0,sp,64
 46c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 46e:	c299                	beqz	a3,474 <printint+0x16>
 470:	0805c863          	bltz	a1,500 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 474:	2581                	sext.w	a1,a1
  neg = 0;
 476:	4881                	li	a7,0
 478:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 47c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 47e:	2601                	sext.w	a2,a2
 480:	00000517          	auipc	a0,0x0
 484:	48850513          	addi	a0,a0,1160 # 908 <digits>
 488:	883a                	mv	a6,a4
 48a:	2705                	addiw	a4,a4,1
 48c:	02c5f7bb          	remuw	a5,a1,a2
 490:	1782                	slli	a5,a5,0x20
 492:	9381                	srli	a5,a5,0x20
 494:	97aa                	add	a5,a5,a0
 496:	0007c783          	lbu	a5,0(a5)
 49a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 49e:	0005879b          	sext.w	a5,a1
 4a2:	02c5d5bb          	divuw	a1,a1,a2
 4a6:	0685                	addi	a3,a3,1
 4a8:	fec7f0e3          	bgeu	a5,a2,488 <printint+0x2a>
  if(neg)
 4ac:	00088b63          	beqz	a7,4c2 <printint+0x64>
    buf[i++] = '-';
 4b0:	fd040793          	addi	a5,s0,-48
 4b4:	973e                	add	a4,a4,a5
 4b6:	02d00793          	li	a5,45
 4ba:	fef70823          	sb	a5,-16(a4)
 4be:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4c2:	02e05863          	blez	a4,4f2 <printint+0x94>
 4c6:	fc040793          	addi	a5,s0,-64
 4ca:	00e78933          	add	s2,a5,a4
 4ce:	fff78993          	addi	s3,a5,-1
 4d2:	99ba                	add	s3,s3,a4
 4d4:	377d                	addiw	a4,a4,-1
 4d6:	1702                	slli	a4,a4,0x20
 4d8:	9301                	srli	a4,a4,0x20
 4da:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4de:	fff94583          	lbu	a1,-1(s2)
 4e2:	8526                	mv	a0,s1
 4e4:	00000097          	auipc	ra,0x0
 4e8:	f58080e7          	jalr	-168(ra) # 43c <putc>
  while(--i >= 0)
 4ec:	197d                	addi	s2,s2,-1
 4ee:	ff3918e3          	bne	s2,s3,4de <printint+0x80>
}
 4f2:	70e2                	ld	ra,56(sp)
 4f4:	7442                	ld	s0,48(sp)
 4f6:	74a2                	ld	s1,40(sp)
 4f8:	7902                	ld	s2,32(sp)
 4fa:	69e2                	ld	s3,24(sp)
 4fc:	6121                	addi	sp,sp,64
 4fe:	8082                	ret
    x = -xx;
 500:	40b005bb          	negw	a1,a1
    neg = 1;
 504:	4885                	li	a7,1
    x = -xx;
 506:	bf8d                	j	478 <printint+0x1a>

0000000000000508 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 508:	7119                	addi	sp,sp,-128
 50a:	fc86                	sd	ra,120(sp)
 50c:	f8a2                	sd	s0,112(sp)
 50e:	f4a6                	sd	s1,104(sp)
 510:	f0ca                	sd	s2,96(sp)
 512:	ecce                	sd	s3,88(sp)
 514:	e8d2                	sd	s4,80(sp)
 516:	e4d6                	sd	s5,72(sp)
 518:	e0da                	sd	s6,64(sp)
 51a:	fc5e                	sd	s7,56(sp)
 51c:	f862                	sd	s8,48(sp)
 51e:	f466                	sd	s9,40(sp)
 520:	f06a                	sd	s10,32(sp)
 522:	ec6e                	sd	s11,24(sp)
 524:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 526:	0005c903          	lbu	s2,0(a1)
 52a:	18090f63          	beqz	s2,6c8 <vprintf+0x1c0>
 52e:	8aaa                	mv	s5,a0
 530:	8b32                	mv	s6,a2
 532:	00158493          	addi	s1,a1,1
  state = 0;
 536:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 538:	02500a13          	li	s4,37
      if(c == 'd'){
 53c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 540:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 544:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 548:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 54c:	00000b97          	auipc	s7,0x0
 550:	3bcb8b93          	addi	s7,s7,956 # 908 <digits>
 554:	a839                	j	572 <vprintf+0x6a>
        putc(fd, c);
 556:	85ca                	mv	a1,s2
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	ee2080e7          	jalr	-286(ra) # 43c <putc>
 562:	a019                	j	568 <vprintf+0x60>
    } else if(state == '%'){
 564:	01498f63          	beq	s3,s4,582 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 568:	0485                	addi	s1,s1,1
 56a:	fff4c903          	lbu	s2,-1(s1)
 56e:	14090d63          	beqz	s2,6c8 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 572:	0009079b          	sext.w	a5,s2
    if(state == 0){
 576:	fe0997e3          	bnez	s3,564 <vprintf+0x5c>
      if(c == '%'){
 57a:	fd479ee3          	bne	a5,s4,556 <vprintf+0x4e>
        state = '%';
 57e:	89be                	mv	s3,a5
 580:	b7e5                	j	568 <vprintf+0x60>
      if(c == 'd'){
 582:	05878063          	beq	a5,s8,5c2 <vprintf+0xba>
      } else if(c == 'l') {
 586:	05978c63          	beq	a5,s9,5de <vprintf+0xd6>
      } else if(c == 'x') {
 58a:	07a78863          	beq	a5,s10,5fa <vprintf+0xf2>
      } else if(c == 'p') {
 58e:	09b78463          	beq	a5,s11,616 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 592:	07300713          	li	a4,115
 596:	0ce78663          	beq	a5,a4,662 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 59a:	06300713          	li	a4,99
 59e:	0ee78e63          	beq	a5,a4,69a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5a2:	11478863          	beq	a5,s4,6b2 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a6:	85d2                	mv	a1,s4
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	e92080e7          	jalr	-366(ra) # 43c <putc>
        putc(fd, c);
 5b2:	85ca                	mv	a1,s2
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	e86080e7          	jalr	-378(ra) # 43c <putc>
      }
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	b765                	j	568 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5c2:	008b0913          	addi	s2,s6,8
 5c6:	4685                	li	a3,1
 5c8:	4629                	li	a2,10
 5ca:	000b2583          	lw	a1,0(s6)
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	e8e080e7          	jalr	-370(ra) # 45e <printint>
 5d8:	8b4a                	mv	s6,s2
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b771                	j	568 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5de:	008b0913          	addi	s2,s6,8
 5e2:	4681                	li	a3,0
 5e4:	4629                	li	a2,10
 5e6:	000b2583          	lw	a1,0(s6)
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	e72080e7          	jalr	-398(ra) # 45e <printint>
 5f4:	8b4a                	mv	s6,s2
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	bf85                	j	568 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5fa:	008b0913          	addi	s2,s6,8
 5fe:	4681                	li	a3,0
 600:	4641                	li	a2,16
 602:	000b2583          	lw	a1,0(s6)
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	e56080e7          	jalr	-426(ra) # 45e <printint>
 610:	8b4a                	mv	s6,s2
      state = 0;
 612:	4981                	li	s3,0
 614:	bf91                	j	568 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 616:	008b0793          	addi	a5,s6,8
 61a:	f8f43423          	sd	a5,-120(s0)
 61e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 622:	03000593          	li	a1,48
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	e14080e7          	jalr	-492(ra) # 43c <putc>
  putc(fd, 'x');
 630:	85ea                	mv	a1,s10
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	e08080e7          	jalr	-504(ra) # 43c <putc>
 63c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63e:	03c9d793          	srli	a5,s3,0x3c
 642:	97de                	add	a5,a5,s7
 644:	0007c583          	lbu	a1,0(a5)
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	df2080e7          	jalr	-526(ra) # 43c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 652:	0992                	slli	s3,s3,0x4
 654:	397d                	addiw	s2,s2,-1
 656:	fe0914e3          	bnez	s2,63e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 65a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 65e:	4981                	li	s3,0
 660:	b721                	j	568 <vprintf+0x60>
        s = va_arg(ap, char*);
 662:	008b0993          	addi	s3,s6,8
 666:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 66a:	02090163          	beqz	s2,68c <vprintf+0x184>
        while(*s != 0){
 66e:	00094583          	lbu	a1,0(s2)
 672:	c9a1                	beqz	a1,6c2 <vprintf+0x1ba>
          putc(fd, *s);
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	dc6080e7          	jalr	-570(ra) # 43c <putc>
          s++;
 67e:	0905                	addi	s2,s2,1
        while(*s != 0){
 680:	00094583          	lbu	a1,0(s2)
 684:	f9e5                	bnez	a1,674 <vprintf+0x16c>
        s = va_arg(ap, char*);
 686:	8b4e                	mv	s6,s3
      state = 0;
 688:	4981                	li	s3,0
 68a:	bdf9                	j	568 <vprintf+0x60>
          s = "(null)";
 68c:	00000917          	auipc	s2,0x0
 690:	27490913          	addi	s2,s2,628 # 900 <malloc+0x12e>
        while(*s != 0){
 694:	02800593          	li	a1,40
 698:	bff1                	j	674 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 69a:	008b0913          	addi	s2,s6,8
 69e:	000b4583          	lbu	a1,0(s6)
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	d98080e7          	jalr	-616(ra) # 43c <putc>
 6ac:	8b4a                	mv	s6,s2
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	bd65                	j	568 <vprintf+0x60>
        putc(fd, c);
 6b2:	85d2                	mv	a1,s4
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	d86080e7          	jalr	-634(ra) # 43c <putc>
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	b565                	j	568 <vprintf+0x60>
        s = va_arg(ap, char*);
 6c2:	8b4e                	mv	s6,s3
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	b54d                	j	568 <vprintf+0x60>
    }
  }
}
 6c8:	70e6                	ld	ra,120(sp)
 6ca:	7446                	ld	s0,112(sp)
 6cc:	74a6                	ld	s1,104(sp)
 6ce:	7906                	ld	s2,96(sp)
 6d0:	69e6                	ld	s3,88(sp)
 6d2:	6a46                	ld	s4,80(sp)
 6d4:	6aa6                	ld	s5,72(sp)
 6d6:	6b06                	ld	s6,64(sp)
 6d8:	7be2                	ld	s7,56(sp)
 6da:	7c42                	ld	s8,48(sp)
 6dc:	7ca2                	ld	s9,40(sp)
 6de:	7d02                	ld	s10,32(sp)
 6e0:	6de2                	ld	s11,24(sp)
 6e2:	6109                	addi	sp,sp,128
 6e4:	8082                	ret

00000000000006e6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6e6:	715d                	addi	sp,sp,-80
 6e8:	ec06                	sd	ra,24(sp)
 6ea:	e822                	sd	s0,16(sp)
 6ec:	1000                	addi	s0,sp,32
 6ee:	e010                	sd	a2,0(s0)
 6f0:	e414                	sd	a3,8(s0)
 6f2:	e818                	sd	a4,16(s0)
 6f4:	ec1c                	sd	a5,24(s0)
 6f6:	03043023          	sd	a6,32(s0)
 6fa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6fe:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 702:	8622                	mv	a2,s0
 704:	00000097          	auipc	ra,0x0
 708:	e04080e7          	jalr	-508(ra) # 508 <vprintf>
}
 70c:	60e2                	ld	ra,24(sp)
 70e:	6442                	ld	s0,16(sp)
 710:	6161                	addi	sp,sp,80
 712:	8082                	ret

0000000000000714 <printf>:

void
printf(const char *fmt, ...)
{
 714:	711d                	addi	sp,sp,-96
 716:	ec06                	sd	ra,24(sp)
 718:	e822                	sd	s0,16(sp)
 71a:	1000                	addi	s0,sp,32
 71c:	e40c                	sd	a1,8(s0)
 71e:	e810                	sd	a2,16(s0)
 720:	ec14                	sd	a3,24(s0)
 722:	f018                	sd	a4,32(s0)
 724:	f41c                	sd	a5,40(s0)
 726:	03043823          	sd	a6,48(s0)
 72a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 72e:	00840613          	addi	a2,s0,8
 732:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 736:	85aa                	mv	a1,a0
 738:	4505                	li	a0,1
 73a:	00000097          	auipc	ra,0x0
 73e:	dce080e7          	jalr	-562(ra) # 508 <vprintf>
}
 742:	60e2                	ld	ra,24(sp)
 744:	6442                	ld	s0,16(sp)
 746:	6125                	addi	sp,sp,96
 748:	8082                	ret

000000000000074a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74a:	1141                	addi	sp,sp,-16
 74c:	e422                	sd	s0,8(sp)
 74e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 750:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 754:	00000797          	auipc	a5,0x0
 758:	1cc7b783          	ld	a5,460(a5) # 920 <freep>
 75c:	a805                	j	78c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 75e:	4618                	lw	a4,8(a2)
 760:	9db9                	addw	a1,a1,a4
 762:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 766:	6398                	ld	a4,0(a5)
 768:	6318                	ld	a4,0(a4)
 76a:	fee53823          	sd	a4,-16(a0)
 76e:	a091                	j	7b2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 770:	ff852703          	lw	a4,-8(a0)
 774:	9e39                	addw	a2,a2,a4
 776:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 778:	ff053703          	ld	a4,-16(a0)
 77c:	e398                	sd	a4,0(a5)
 77e:	a099                	j	7c4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	6398                	ld	a4,0(a5)
 782:	00e7e463          	bltu	a5,a4,78a <free+0x40>
 786:	00e6ea63          	bltu	a3,a4,79a <free+0x50>
{
 78a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78c:	fed7fae3          	bgeu	a5,a3,780 <free+0x36>
 790:	6398                	ld	a4,0(a5)
 792:	00e6e463          	bltu	a3,a4,79a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 796:	fee7eae3          	bltu	a5,a4,78a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 79a:	ff852583          	lw	a1,-8(a0)
 79e:	6390                	ld	a2,0(a5)
 7a0:	02059813          	slli	a6,a1,0x20
 7a4:	01c85713          	srli	a4,a6,0x1c
 7a8:	9736                	add	a4,a4,a3
 7aa:	fae60ae3          	beq	a2,a4,75e <free+0x14>
    bp->s.ptr = p->s.ptr;
 7ae:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b2:	4790                	lw	a2,8(a5)
 7b4:	02061593          	slli	a1,a2,0x20
 7b8:	01c5d713          	srli	a4,a1,0x1c
 7bc:	973e                	add	a4,a4,a5
 7be:	fae689e3          	beq	a3,a4,770 <free+0x26>
  } else
    p->s.ptr = bp;
 7c2:	e394                	sd	a3,0(a5)
  freep = p;
 7c4:	00000717          	auipc	a4,0x0
 7c8:	14f73e23          	sd	a5,348(a4) # 920 <freep>
}
 7cc:	6422                	ld	s0,8(sp)
 7ce:	0141                	addi	sp,sp,16
 7d0:	8082                	ret

00000000000007d2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d2:	7139                	addi	sp,sp,-64
 7d4:	fc06                	sd	ra,56(sp)
 7d6:	f822                	sd	s0,48(sp)
 7d8:	f426                	sd	s1,40(sp)
 7da:	f04a                	sd	s2,32(sp)
 7dc:	ec4e                	sd	s3,24(sp)
 7de:	e852                	sd	s4,16(sp)
 7e0:	e456                	sd	s5,8(sp)
 7e2:	e05a                	sd	s6,0(sp)
 7e4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e6:	02051493          	slli	s1,a0,0x20
 7ea:	9081                	srli	s1,s1,0x20
 7ec:	04bd                	addi	s1,s1,15
 7ee:	8091                	srli	s1,s1,0x4
 7f0:	0014899b          	addiw	s3,s1,1
 7f4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7f6:	00000517          	auipc	a0,0x0
 7fa:	12a53503          	ld	a0,298(a0) # 920 <freep>
 7fe:	c515                	beqz	a0,82a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 800:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 802:	4798                	lw	a4,8(a5)
 804:	02977f63          	bgeu	a4,s1,842 <malloc+0x70>
 808:	8a4e                	mv	s4,s3
 80a:	0009871b          	sext.w	a4,s3
 80e:	6685                	lui	a3,0x1
 810:	00d77363          	bgeu	a4,a3,816 <malloc+0x44>
 814:	6a05                	lui	s4,0x1
 816:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 81a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 81e:	00000917          	auipc	s2,0x0
 822:	10290913          	addi	s2,s2,258 # 920 <freep>
  if(p == (char*)-1)
 826:	5afd                	li	s5,-1
 828:	a895                	j	89c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 82a:	00000797          	auipc	a5,0x0
 82e:	2fe78793          	addi	a5,a5,766 # b28 <base>
 832:	00000717          	auipc	a4,0x0
 836:	0ef73723          	sd	a5,238(a4) # 920 <freep>
 83a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 83c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 840:	b7e1                	j	808 <malloc+0x36>
      if(p->s.size == nunits)
 842:	02e48c63          	beq	s1,a4,87a <malloc+0xa8>
        p->s.size -= nunits;
 846:	4137073b          	subw	a4,a4,s3
 84a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 84c:	02071693          	slli	a3,a4,0x20
 850:	01c6d713          	srli	a4,a3,0x1c
 854:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 856:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 85a:	00000717          	auipc	a4,0x0
 85e:	0ca73323          	sd	a0,198(a4) # 920 <freep>
      return (void*)(p + 1);
 862:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 866:	70e2                	ld	ra,56(sp)
 868:	7442                	ld	s0,48(sp)
 86a:	74a2                	ld	s1,40(sp)
 86c:	7902                	ld	s2,32(sp)
 86e:	69e2                	ld	s3,24(sp)
 870:	6a42                	ld	s4,16(sp)
 872:	6aa2                	ld	s5,8(sp)
 874:	6b02                	ld	s6,0(sp)
 876:	6121                	addi	sp,sp,64
 878:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 87a:	6398                	ld	a4,0(a5)
 87c:	e118                	sd	a4,0(a0)
 87e:	bff1                	j	85a <malloc+0x88>
  hp->s.size = nu;
 880:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 884:	0541                	addi	a0,a0,16
 886:	00000097          	auipc	ra,0x0
 88a:	ec4080e7          	jalr	-316(ra) # 74a <free>
  return freep;
 88e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 892:	d971                	beqz	a0,866 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 894:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 896:	4798                	lw	a4,8(a5)
 898:	fa9775e3          	bgeu	a4,s1,842 <malloc+0x70>
    if(p == freep)
 89c:	00093703          	ld	a4,0(s2)
 8a0:	853e                	mv	a0,a5
 8a2:	fef719e3          	bne	a4,a5,894 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8a6:	8552                	mv	a0,s4
 8a8:	00000097          	auipc	ra,0x0
 8ac:	b5c080e7          	jalr	-1188(ra) # 404 <sbrk>
  if(p == (char*)-1)
 8b0:	fd5518e3          	bne	a0,s5,880 <malloc+0xae>
        return 0;
 8b4:	4501                	li	a0,0
 8b6:	bf45                	j	866 <malloc+0x94>
