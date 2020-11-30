
user/_bigfile：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"
#include "kernel/fs.h"

int
main()
{
   0:	bd010113          	addi	sp,sp,-1072
   4:	42113423          	sd	ra,1064(sp)
   8:	42813023          	sd	s0,1056(sp)
   c:	40913c23          	sd	s1,1048(sp)
  10:	41213823          	sd	s2,1040(sp)
  14:	41313423          	sd	s3,1032(sp)
  18:	41413023          	sd	s4,1024(sp)
  1c:	43010413          	addi	s0,sp,1072
  char buf[BSIZE];
  int fd, i, sectors;

  fd = open("big.file", O_CREATE | O_WRONLY);
  20:	20100593          	li	a1,513
  24:	00001517          	auipc	a0,0x1
  28:	8d450513          	addi	a0,a0,-1836 # 8f8 <malloc+0xec>
  2c:	00000097          	auipc	ra,0x0
  30:	3e2080e7          	jalr	994(ra) # 40e <open>
  if(fd < 0){
  34:	04054463          	bltz	a0,7c <main+0x7c>
  38:	892a                	mv	s2,a0
  3a:	4481                	li	s1,0
    *(int*)buf = sectors;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
    sectors++;
    if (sectors % 100 == 0)
  3c:	06400993          	li	s3,100
      printf(".");
  40:	00001a17          	auipc	s4,0x1
  44:	8f8a0a13          	addi	s4,s4,-1800 # 938 <malloc+0x12c>
    *(int*)buf = sectors;
  48:	bc942823          	sw	s1,-1072(s0)
    int cc = write(fd, buf, sizeof(buf));
  4c:	40000613          	li	a2,1024
  50:	bd040593          	addi	a1,s0,-1072
  54:	854a                	mv	a0,s2
  56:	00000097          	auipc	ra,0x0
  5a:	398080e7          	jalr	920(ra) # 3ee <write>
    if(cc <= 0)
  5e:	02a05c63          	blez	a0,96 <main+0x96>
    sectors++;
  62:	0014879b          	addiw	a5,s1,1
  66:	0007849b          	sext.w	s1,a5
    if (sectors % 100 == 0)
  6a:	0337e7bb          	remw	a5,a5,s3
  6e:	ffe9                	bnez	a5,48 <main+0x48>
      printf(".");
  70:	8552                	mv	a0,s4
  72:	00000097          	auipc	ra,0x0
  76:	6dc080e7          	jalr	1756(ra) # 74e <printf>
  7a:	b7f9                	j	48 <main+0x48>
    printf("bigfile: cannot open big.file for writing\n");
  7c:	00001517          	auipc	a0,0x1
  80:	88c50513          	addi	a0,a0,-1908 # 908 <malloc+0xfc>
  84:	00000097          	auipc	ra,0x0
  88:	6ca080e7          	jalr	1738(ra) # 74e <printf>
    exit(-1);
  8c:	557d                	li	a0,-1
  8e:	00000097          	auipc	ra,0x0
  92:	340080e7          	jalr	832(ra) # 3ce <exit>
  }

  printf("\nwrote %d sectors\n", sectors);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
  9c:	8a850513          	addi	a0,a0,-1880 # 940 <malloc+0x134>
  a0:	00000097          	auipc	ra,0x0
  a4:	6ae080e7          	jalr	1710(ra) # 74e <printf>

  close(fd);
  a8:	854a                	mv	a0,s2
  aa:	00000097          	auipc	ra,0x0
  ae:	34c080e7          	jalr	844(ra) # 3f6 <close>
  fd = open("big.file", O_RDONLY);
  b2:	4581                	li	a1,0
  b4:	00001517          	auipc	a0,0x1
  b8:	84450513          	addi	a0,a0,-1980 # 8f8 <malloc+0xec>
  bc:	00000097          	auipc	ra,0x0
  c0:	352080e7          	jalr	850(ra) # 40e <open>
  c4:	89aa                	mv	s3,a0
  if(fd < 0){
  c6:	04054463          	bltz	a0,10e <main+0x10e>
    printf("bigfile: cannot re-open big.file for reading\n");
    exit(-1);
  }
  for(i = 0; i < sectors; i++){
  ca:	4901                	li	s2,0
  cc:	02905463          	blez	s1,f4 <main+0xf4>
    int cc = read(fd, buf, sizeof(buf));
  d0:	40000613          	li	a2,1024
  d4:	bd040593          	addi	a1,s0,-1072
  d8:	854e                	mv	a0,s3
  da:	00000097          	auipc	ra,0x0
  de:	30c080e7          	jalr	780(ra) # 3e6 <read>
    if(cc <= 0){
  e2:	04a05363          	blez	a0,128 <main+0x128>
      printf("bigfile: read error at sector %d\n", i);
      exit(-1);
    }
    if(*(int*)buf != i){
  e6:	bd042583          	lw	a1,-1072(s0)
  ea:	05259d63          	bne	a1,s2,144 <main+0x144>
  for(i = 0; i < sectors; i++){
  ee:	2905                	addiw	s2,s2,1
  f0:	ff2490e3          	bne	s1,s2,d0 <main+0xd0>
             *(int*)buf, i);
      exit(-1);
    }
  }

  printf("done; ok\n"); 
  f4:	00001517          	auipc	a0,0x1
  f8:	8f450513          	addi	a0,a0,-1804 # 9e8 <malloc+0x1dc>
  fc:	00000097          	auipc	ra,0x0
 100:	652080e7          	jalr	1618(ra) # 74e <printf>

  exit(0);
 104:	4501                	li	a0,0
 106:	00000097          	auipc	ra,0x0
 10a:	2c8080e7          	jalr	712(ra) # 3ce <exit>
    printf("bigfile: cannot re-open big.file for reading\n");
 10e:	00001517          	auipc	a0,0x1
 112:	84a50513          	addi	a0,a0,-1974 # 958 <malloc+0x14c>
 116:	00000097          	auipc	ra,0x0
 11a:	638080e7          	jalr	1592(ra) # 74e <printf>
    exit(-1);
 11e:	557d                	li	a0,-1
 120:	00000097          	auipc	ra,0x0
 124:	2ae080e7          	jalr	686(ra) # 3ce <exit>
      printf("bigfile: read error at sector %d\n", i);
 128:	85ca                	mv	a1,s2
 12a:	00001517          	auipc	a0,0x1
 12e:	85e50513          	addi	a0,a0,-1954 # 988 <malloc+0x17c>
 132:	00000097          	auipc	ra,0x0
 136:	61c080e7          	jalr	1564(ra) # 74e <printf>
      exit(-1);
 13a:	557d                	li	a0,-1
 13c:	00000097          	auipc	ra,0x0
 140:	292080e7          	jalr	658(ra) # 3ce <exit>
      printf("bigfile: read the wrong data (%d) for sector %d\n",
 144:	864a                	mv	a2,s2
 146:	00001517          	auipc	a0,0x1
 14a:	86a50513          	addi	a0,a0,-1942 # 9b0 <malloc+0x1a4>
 14e:	00000097          	auipc	ra,0x0
 152:	600080e7          	jalr	1536(ra) # 74e <printf>
      exit(-1);
 156:	557d                	li	a0,-1
 158:	00000097          	auipc	ra,0x0
 15c:	276080e7          	jalr	630(ra) # 3ce <exit>

0000000000000160 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 160:	1141                	addi	sp,sp,-16
 162:	e422                	sd	s0,8(sp)
 164:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 166:	87aa                	mv	a5,a0
 168:	0585                	addi	a1,a1,1
 16a:	0785                	addi	a5,a5,1
 16c:	fff5c703          	lbu	a4,-1(a1)
 170:	fee78fa3          	sb	a4,-1(a5)
 174:	fb75                	bnez	a4,168 <strcpy+0x8>
    ;
  return os;
}
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 182:	00054783          	lbu	a5,0(a0)
 186:	cb91                	beqz	a5,19a <strcmp+0x1e>
 188:	0005c703          	lbu	a4,0(a1)
 18c:	00f71763          	bne	a4,a5,19a <strcmp+0x1e>
    p++, q++;
 190:	0505                	addi	a0,a0,1
 192:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 194:	00054783          	lbu	a5,0(a0)
 198:	fbe5                	bnez	a5,188 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 19a:	0005c503          	lbu	a0,0(a1)
}
 19e:	40a7853b          	subw	a0,a5,a0
 1a2:	6422                	ld	s0,8(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strlen>:

uint
strlen(const char *s)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	cf91                	beqz	a5,1ce <strlen+0x26>
 1b4:	0505                	addi	a0,a0,1
 1b6:	87aa                	mv	a5,a0
 1b8:	4685                	li	a3,1
 1ba:	9e89                	subw	a3,a3,a0
 1bc:	00f6853b          	addw	a0,a3,a5
 1c0:	0785                	addi	a5,a5,1
 1c2:	fff7c703          	lbu	a4,-1(a5)
 1c6:	fb7d                	bnez	a4,1bc <strlen+0x14>
    ;
  return n;
}
 1c8:	6422                	ld	s0,8(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret
  for(n = 0; s[n]; n++)
 1ce:	4501                	li	a0,0
 1d0:	bfe5                	j	1c8 <strlen+0x20>

00000000000001d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1d8:	ca19                	beqz	a2,1ee <memset+0x1c>
 1da:	87aa                	mv	a5,a0
 1dc:	1602                	slli	a2,a2,0x20
 1de:	9201                	srli	a2,a2,0x20
 1e0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1e8:	0785                	addi	a5,a5,1
 1ea:	fee79de3          	bne	a5,a4,1e4 <memset+0x12>
  }
  return dst;
}
 1ee:	6422                	ld	s0,8(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret

00000000000001f4 <strchr>:

char*
strchr(const char *s, char c)
{
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e422                	sd	s0,8(sp)
 1f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1fa:	00054783          	lbu	a5,0(a0)
 1fe:	cb99                	beqz	a5,214 <strchr+0x20>
    if(*s == c)
 200:	00f58763          	beq	a1,a5,20e <strchr+0x1a>
  for(; *s; s++)
 204:	0505                	addi	a0,a0,1
 206:	00054783          	lbu	a5,0(a0)
 20a:	fbfd                	bnez	a5,200 <strchr+0xc>
      return (char*)s;
  return 0;
 20c:	4501                	li	a0,0
}
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret
  return 0;
 214:	4501                	li	a0,0
 216:	bfe5                	j	20e <strchr+0x1a>

0000000000000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	711d                	addi	sp,sp,-96
 21a:	ec86                	sd	ra,88(sp)
 21c:	e8a2                	sd	s0,80(sp)
 21e:	e4a6                	sd	s1,72(sp)
 220:	e0ca                	sd	s2,64(sp)
 222:	fc4e                	sd	s3,56(sp)
 224:	f852                	sd	s4,48(sp)
 226:	f456                	sd	s5,40(sp)
 228:	f05a                	sd	s6,32(sp)
 22a:	ec5e                	sd	s7,24(sp)
 22c:	1080                	addi	s0,sp,96
 22e:	8baa                	mv	s7,a0
 230:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 232:	892a                	mv	s2,a0
 234:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 236:	4aa9                	li	s5,10
 238:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 23a:	89a6                	mv	s3,s1
 23c:	2485                	addiw	s1,s1,1
 23e:	0344d863          	bge	s1,s4,26e <gets+0x56>
    cc = read(0, &c, 1);
 242:	4605                	li	a2,1
 244:	faf40593          	addi	a1,s0,-81
 248:	4501                	li	a0,0
 24a:	00000097          	auipc	ra,0x0
 24e:	19c080e7          	jalr	412(ra) # 3e6 <read>
    if(cc < 1)
 252:	00a05e63          	blez	a0,26e <gets+0x56>
    buf[i++] = c;
 256:	faf44783          	lbu	a5,-81(s0)
 25a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 25e:	01578763          	beq	a5,s5,26c <gets+0x54>
 262:	0905                	addi	s2,s2,1
 264:	fd679be3          	bne	a5,s6,23a <gets+0x22>
  for(i=0; i+1 < max; ){
 268:	89a6                	mv	s3,s1
 26a:	a011                	j	26e <gets+0x56>
 26c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 26e:	99de                	add	s3,s3,s7
 270:	00098023          	sb	zero,0(s3)
  return buf;
}
 274:	855e                	mv	a0,s7
 276:	60e6                	ld	ra,88(sp)
 278:	6446                	ld	s0,80(sp)
 27a:	64a6                	ld	s1,72(sp)
 27c:	6906                	ld	s2,64(sp)
 27e:	79e2                	ld	s3,56(sp)
 280:	7a42                	ld	s4,48(sp)
 282:	7aa2                	ld	s5,40(sp)
 284:	7b02                	ld	s6,32(sp)
 286:	6be2                	ld	s7,24(sp)
 288:	6125                	addi	sp,sp,96
 28a:	8082                	ret

000000000000028c <stat>:

int
stat(const char *n, struct stat *st)
{
 28c:	1101                	addi	sp,sp,-32
 28e:	ec06                	sd	ra,24(sp)
 290:	e822                	sd	s0,16(sp)
 292:	e426                	sd	s1,8(sp)
 294:	e04a                	sd	s2,0(sp)
 296:	1000                	addi	s0,sp,32
 298:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29a:	4581                	li	a1,0
 29c:	00000097          	auipc	ra,0x0
 2a0:	172080e7          	jalr	370(ra) # 40e <open>
  if(fd < 0)
 2a4:	02054563          	bltz	a0,2ce <stat+0x42>
 2a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2aa:	85ca                	mv	a1,s2
 2ac:	00000097          	auipc	ra,0x0
 2b0:	17a080e7          	jalr	378(ra) # 426 <fstat>
 2b4:	892a                	mv	s2,a0
  close(fd);
 2b6:	8526                	mv	a0,s1
 2b8:	00000097          	auipc	ra,0x0
 2bc:	13e080e7          	jalr	318(ra) # 3f6 <close>
  return r;
}
 2c0:	854a                	mv	a0,s2
 2c2:	60e2                	ld	ra,24(sp)
 2c4:	6442                	ld	s0,16(sp)
 2c6:	64a2                	ld	s1,8(sp)
 2c8:	6902                	ld	s2,0(sp)
 2ca:	6105                	addi	sp,sp,32
 2cc:	8082                	ret
    return -1;
 2ce:	597d                	li	s2,-1
 2d0:	bfc5                	j	2c0 <stat+0x34>

00000000000002d2 <atoi>:

int
atoi(const char *s)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e422                	sd	s0,8(sp)
 2d6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d8:	00054603          	lbu	a2,0(a0)
 2dc:	fd06079b          	addiw	a5,a2,-48
 2e0:	0ff7f793          	andi	a5,a5,255
 2e4:	4725                	li	a4,9
 2e6:	02f76963          	bltu	a4,a5,318 <atoi+0x46>
 2ea:	86aa                	mv	a3,a0
  n = 0;
 2ec:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2ee:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2f0:	0685                	addi	a3,a3,1
 2f2:	0025179b          	slliw	a5,a0,0x2
 2f6:	9fa9                	addw	a5,a5,a0
 2f8:	0017979b          	slliw	a5,a5,0x1
 2fc:	9fb1                	addw	a5,a5,a2
 2fe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 302:	0006c603          	lbu	a2,0(a3)
 306:	fd06071b          	addiw	a4,a2,-48
 30a:	0ff77713          	andi	a4,a4,255
 30e:	fee5f1e3          	bgeu	a1,a4,2f0 <atoi+0x1e>
  return n;
}
 312:	6422                	ld	s0,8(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret
  n = 0;
 318:	4501                	li	a0,0
 31a:	bfe5                	j	312 <atoi+0x40>

000000000000031c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 322:	02b57463          	bgeu	a0,a1,34a <memmove+0x2e>
    while(n-- > 0)
 326:	00c05f63          	blez	a2,344 <memmove+0x28>
 32a:	1602                	slli	a2,a2,0x20
 32c:	9201                	srli	a2,a2,0x20
 32e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 332:	872a                	mv	a4,a0
      *dst++ = *src++;
 334:	0585                	addi	a1,a1,1
 336:	0705                	addi	a4,a4,1
 338:	fff5c683          	lbu	a3,-1(a1)
 33c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 340:	fee79ae3          	bne	a5,a4,334 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 344:	6422                	ld	s0,8(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret
    dst += n;
 34a:	00c50733          	add	a4,a0,a2
    src += n;
 34e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 350:	fec05ae3          	blez	a2,344 <memmove+0x28>
 354:	fff6079b          	addiw	a5,a2,-1
 358:	1782                	slli	a5,a5,0x20
 35a:	9381                	srli	a5,a5,0x20
 35c:	fff7c793          	not	a5,a5
 360:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 362:	15fd                	addi	a1,a1,-1
 364:	177d                	addi	a4,a4,-1
 366:	0005c683          	lbu	a3,0(a1)
 36a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 36e:	fee79ae3          	bne	a5,a4,362 <memmove+0x46>
 372:	bfc9                	j	344 <memmove+0x28>

0000000000000374 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 374:	1141                	addi	sp,sp,-16
 376:	e422                	sd	s0,8(sp)
 378:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 37a:	ca05                	beqz	a2,3aa <memcmp+0x36>
 37c:	fff6069b          	addiw	a3,a2,-1
 380:	1682                	slli	a3,a3,0x20
 382:	9281                	srli	a3,a3,0x20
 384:	0685                	addi	a3,a3,1
 386:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 388:	00054783          	lbu	a5,0(a0)
 38c:	0005c703          	lbu	a4,0(a1)
 390:	00e79863          	bne	a5,a4,3a0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 394:	0505                	addi	a0,a0,1
    p2++;
 396:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 398:	fed518e3          	bne	a0,a3,388 <memcmp+0x14>
  }
  return 0;
 39c:	4501                	li	a0,0
 39e:	a019                	j	3a4 <memcmp+0x30>
      return *p1 - *p2;
 3a0:	40e7853b          	subw	a0,a5,a4
}
 3a4:	6422                	ld	s0,8(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret
  return 0;
 3aa:	4501                	li	a0,0
 3ac:	bfe5                	j	3a4 <memcmp+0x30>

00000000000003ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ae:	1141                	addi	sp,sp,-16
 3b0:	e406                	sd	ra,8(sp)
 3b2:	e022                	sd	s0,0(sp)
 3b4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b6:	00000097          	auipc	ra,0x0
 3ba:	f66080e7          	jalr	-154(ra) # 31c <memmove>
}
 3be:	60a2                	ld	ra,8(sp)
 3c0:	6402                	ld	s0,0(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret

00000000000003c6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c6:	4885                	li	a7,1
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ce:	4889                	li	a7,2
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d6:	488d                	li	a7,3
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3de:	4891                	li	a7,4
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <read>:
.global read
read:
 li a7, SYS_read
 3e6:	4895                	li	a7,5
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <write>:
.global write
write:
 li a7, SYS_write
 3ee:	48c1                	li	a7,16
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <close>:
.global close
close:
 li a7, SYS_close
 3f6:	48d5                	li	a7,21
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <kill>:
.global kill
kill:
 li a7, SYS_kill
 3fe:	4899                	li	a7,6
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <exec>:
.global exec
exec:
 li a7, SYS_exec
 406:	489d                	li	a7,7
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <open>:
.global open
open:
 li a7, SYS_open
 40e:	48bd                	li	a7,15
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 416:	48c5                	li	a7,17
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 41e:	48c9                	li	a7,18
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 426:	48a1                	li	a7,8
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <link>:
.global link
link:
 li a7, SYS_link
 42e:	48cd                	li	a7,19
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 436:	48d1                	li	a7,20
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 43e:	48a5                	li	a7,9
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <dup>:
.global dup
dup:
 li a7, SYS_dup
 446:	48a9                	li	a7,10
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 44e:	48ad                	li	a7,11
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 456:	48b1                	li	a7,12
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 45e:	48b5                	li	a7,13
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 466:	48b9                	li	a7,14
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 46e:	48d9                	li	a7,22
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 476:	1101                	addi	sp,sp,-32
 478:	ec06                	sd	ra,24(sp)
 47a:	e822                	sd	s0,16(sp)
 47c:	1000                	addi	s0,sp,32
 47e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 482:	4605                	li	a2,1
 484:	fef40593          	addi	a1,s0,-17
 488:	00000097          	auipc	ra,0x0
 48c:	f66080e7          	jalr	-154(ra) # 3ee <write>
}
 490:	60e2                	ld	ra,24(sp)
 492:	6442                	ld	s0,16(sp)
 494:	6105                	addi	sp,sp,32
 496:	8082                	ret

0000000000000498 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 498:	7139                	addi	sp,sp,-64
 49a:	fc06                	sd	ra,56(sp)
 49c:	f822                	sd	s0,48(sp)
 49e:	f426                	sd	s1,40(sp)
 4a0:	f04a                	sd	s2,32(sp)
 4a2:	ec4e                	sd	s3,24(sp)
 4a4:	0080                	addi	s0,sp,64
 4a6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a8:	c299                	beqz	a3,4ae <printint+0x16>
 4aa:	0805c863          	bltz	a1,53a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4ae:	2581                	sext.w	a1,a1
  neg = 0;
 4b0:	4881                	li	a7,0
 4b2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4b6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4b8:	2601                	sext.w	a2,a2
 4ba:	00000517          	auipc	a0,0x0
 4be:	54650513          	addi	a0,a0,1350 # a00 <digits>
 4c2:	883a                	mv	a6,a4
 4c4:	2705                	addiw	a4,a4,1
 4c6:	02c5f7bb          	remuw	a5,a1,a2
 4ca:	1782                	slli	a5,a5,0x20
 4cc:	9381                	srli	a5,a5,0x20
 4ce:	97aa                	add	a5,a5,a0
 4d0:	0007c783          	lbu	a5,0(a5)
 4d4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4d8:	0005879b          	sext.w	a5,a1
 4dc:	02c5d5bb          	divuw	a1,a1,a2
 4e0:	0685                	addi	a3,a3,1
 4e2:	fec7f0e3          	bgeu	a5,a2,4c2 <printint+0x2a>
  if(neg)
 4e6:	00088b63          	beqz	a7,4fc <printint+0x64>
    buf[i++] = '-';
 4ea:	fd040793          	addi	a5,s0,-48
 4ee:	973e                	add	a4,a4,a5
 4f0:	02d00793          	li	a5,45
 4f4:	fef70823          	sb	a5,-16(a4)
 4f8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4fc:	02e05863          	blez	a4,52c <printint+0x94>
 500:	fc040793          	addi	a5,s0,-64
 504:	00e78933          	add	s2,a5,a4
 508:	fff78993          	addi	s3,a5,-1
 50c:	99ba                	add	s3,s3,a4
 50e:	377d                	addiw	a4,a4,-1
 510:	1702                	slli	a4,a4,0x20
 512:	9301                	srli	a4,a4,0x20
 514:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 518:	fff94583          	lbu	a1,-1(s2)
 51c:	8526                	mv	a0,s1
 51e:	00000097          	auipc	ra,0x0
 522:	f58080e7          	jalr	-168(ra) # 476 <putc>
  while(--i >= 0)
 526:	197d                	addi	s2,s2,-1
 528:	ff3918e3          	bne	s2,s3,518 <printint+0x80>
}
 52c:	70e2                	ld	ra,56(sp)
 52e:	7442                	ld	s0,48(sp)
 530:	74a2                	ld	s1,40(sp)
 532:	7902                	ld	s2,32(sp)
 534:	69e2                	ld	s3,24(sp)
 536:	6121                	addi	sp,sp,64
 538:	8082                	ret
    x = -xx;
 53a:	40b005bb          	negw	a1,a1
    neg = 1;
 53e:	4885                	li	a7,1
    x = -xx;
 540:	bf8d                	j	4b2 <printint+0x1a>

0000000000000542 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 542:	7119                	addi	sp,sp,-128
 544:	fc86                	sd	ra,120(sp)
 546:	f8a2                	sd	s0,112(sp)
 548:	f4a6                	sd	s1,104(sp)
 54a:	f0ca                	sd	s2,96(sp)
 54c:	ecce                	sd	s3,88(sp)
 54e:	e8d2                	sd	s4,80(sp)
 550:	e4d6                	sd	s5,72(sp)
 552:	e0da                	sd	s6,64(sp)
 554:	fc5e                	sd	s7,56(sp)
 556:	f862                	sd	s8,48(sp)
 558:	f466                	sd	s9,40(sp)
 55a:	f06a                	sd	s10,32(sp)
 55c:	ec6e                	sd	s11,24(sp)
 55e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 560:	0005c903          	lbu	s2,0(a1)
 564:	18090f63          	beqz	s2,702 <vprintf+0x1c0>
 568:	8aaa                	mv	s5,a0
 56a:	8b32                	mv	s6,a2
 56c:	00158493          	addi	s1,a1,1
  state = 0;
 570:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 572:	02500a13          	li	s4,37
      if(c == 'd'){
 576:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 57a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 57e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 582:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 586:	00000b97          	auipc	s7,0x0
 58a:	47ab8b93          	addi	s7,s7,1146 # a00 <digits>
 58e:	a839                	j	5ac <vprintf+0x6a>
        putc(fd, c);
 590:	85ca                	mv	a1,s2
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	ee2080e7          	jalr	-286(ra) # 476 <putc>
 59c:	a019                	j	5a2 <vprintf+0x60>
    } else if(state == '%'){
 59e:	01498f63          	beq	s3,s4,5bc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5a2:	0485                	addi	s1,s1,1
 5a4:	fff4c903          	lbu	s2,-1(s1)
 5a8:	14090d63          	beqz	s2,702 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5ac:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5b0:	fe0997e3          	bnez	s3,59e <vprintf+0x5c>
      if(c == '%'){
 5b4:	fd479ee3          	bne	a5,s4,590 <vprintf+0x4e>
        state = '%';
 5b8:	89be                	mv	s3,a5
 5ba:	b7e5                	j	5a2 <vprintf+0x60>
      if(c == 'd'){
 5bc:	05878063          	beq	a5,s8,5fc <vprintf+0xba>
      } else if(c == 'l') {
 5c0:	05978c63          	beq	a5,s9,618 <vprintf+0xd6>
      } else if(c == 'x') {
 5c4:	07a78863          	beq	a5,s10,634 <vprintf+0xf2>
      } else if(c == 'p') {
 5c8:	09b78463          	beq	a5,s11,650 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5cc:	07300713          	li	a4,115
 5d0:	0ce78663          	beq	a5,a4,69c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d4:	06300713          	li	a4,99
 5d8:	0ee78e63          	beq	a5,a4,6d4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5dc:	11478863          	beq	a5,s4,6ec <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e0:	85d2                	mv	a1,s4
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	e92080e7          	jalr	-366(ra) # 476 <putc>
        putc(fd, c);
 5ec:	85ca                	mv	a1,s2
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e86080e7          	jalr	-378(ra) # 476 <putc>
      }
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	b765                	j	5a2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5fc:	008b0913          	addi	s2,s6,8
 600:	4685                	li	a3,1
 602:	4629                	li	a2,10
 604:	000b2583          	lw	a1,0(s6)
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	e8e080e7          	jalr	-370(ra) # 498 <printint>
 612:	8b4a                	mv	s6,s2
      state = 0;
 614:	4981                	li	s3,0
 616:	b771                	j	5a2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 618:	008b0913          	addi	s2,s6,8
 61c:	4681                	li	a3,0
 61e:	4629                	li	a2,10
 620:	000b2583          	lw	a1,0(s6)
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	e72080e7          	jalr	-398(ra) # 498 <printint>
 62e:	8b4a                	mv	s6,s2
      state = 0;
 630:	4981                	li	s3,0
 632:	bf85                	j	5a2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 634:	008b0913          	addi	s2,s6,8
 638:	4681                	li	a3,0
 63a:	4641                	li	a2,16
 63c:	000b2583          	lw	a1,0(s6)
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	e56080e7          	jalr	-426(ra) # 498 <printint>
 64a:	8b4a                	mv	s6,s2
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bf91                	j	5a2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 650:	008b0793          	addi	a5,s6,8
 654:	f8f43423          	sd	a5,-120(s0)
 658:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 65c:	03000593          	li	a1,48
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	e14080e7          	jalr	-492(ra) # 476 <putc>
  putc(fd, 'x');
 66a:	85ea                	mv	a1,s10
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	e08080e7          	jalr	-504(ra) # 476 <putc>
 676:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 678:	03c9d793          	srli	a5,s3,0x3c
 67c:	97de                	add	a5,a5,s7
 67e:	0007c583          	lbu	a1,0(a5)
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	df2080e7          	jalr	-526(ra) # 476 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 68c:	0992                	slli	s3,s3,0x4
 68e:	397d                	addiw	s2,s2,-1
 690:	fe0914e3          	bnez	s2,678 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 694:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 698:	4981                	li	s3,0
 69a:	b721                	j	5a2 <vprintf+0x60>
        s = va_arg(ap, char*);
 69c:	008b0993          	addi	s3,s6,8
 6a0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6a4:	02090163          	beqz	s2,6c6 <vprintf+0x184>
        while(*s != 0){
 6a8:	00094583          	lbu	a1,0(s2)
 6ac:	c9a1                	beqz	a1,6fc <vprintf+0x1ba>
          putc(fd, *s);
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	dc6080e7          	jalr	-570(ra) # 476 <putc>
          s++;
 6b8:	0905                	addi	s2,s2,1
        while(*s != 0){
 6ba:	00094583          	lbu	a1,0(s2)
 6be:	f9e5                	bnez	a1,6ae <vprintf+0x16c>
        s = va_arg(ap, char*);
 6c0:	8b4e                	mv	s6,s3
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	bdf9                	j	5a2 <vprintf+0x60>
          s = "(null)";
 6c6:	00000917          	auipc	s2,0x0
 6ca:	33290913          	addi	s2,s2,818 # 9f8 <malloc+0x1ec>
        while(*s != 0){
 6ce:	02800593          	li	a1,40
 6d2:	bff1                	j	6ae <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6d4:	008b0913          	addi	s2,s6,8
 6d8:	000b4583          	lbu	a1,0(s6)
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	d98080e7          	jalr	-616(ra) # 476 <putc>
 6e6:	8b4a                	mv	s6,s2
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bd65                	j	5a2 <vprintf+0x60>
        putc(fd, c);
 6ec:	85d2                	mv	a1,s4
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	d86080e7          	jalr	-634(ra) # 476 <putc>
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b565                	j	5a2 <vprintf+0x60>
        s = va_arg(ap, char*);
 6fc:	8b4e                	mv	s6,s3
      state = 0;
 6fe:	4981                	li	s3,0
 700:	b54d                	j	5a2 <vprintf+0x60>
    }
  }
}
 702:	70e6                	ld	ra,120(sp)
 704:	7446                	ld	s0,112(sp)
 706:	74a6                	ld	s1,104(sp)
 708:	7906                	ld	s2,96(sp)
 70a:	69e6                	ld	s3,88(sp)
 70c:	6a46                	ld	s4,80(sp)
 70e:	6aa6                	ld	s5,72(sp)
 710:	6b06                	ld	s6,64(sp)
 712:	7be2                	ld	s7,56(sp)
 714:	7c42                	ld	s8,48(sp)
 716:	7ca2                	ld	s9,40(sp)
 718:	7d02                	ld	s10,32(sp)
 71a:	6de2                	ld	s11,24(sp)
 71c:	6109                	addi	sp,sp,128
 71e:	8082                	ret

0000000000000720 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 720:	715d                	addi	sp,sp,-80
 722:	ec06                	sd	ra,24(sp)
 724:	e822                	sd	s0,16(sp)
 726:	1000                	addi	s0,sp,32
 728:	e010                	sd	a2,0(s0)
 72a:	e414                	sd	a3,8(s0)
 72c:	e818                	sd	a4,16(s0)
 72e:	ec1c                	sd	a5,24(s0)
 730:	03043023          	sd	a6,32(s0)
 734:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 738:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 73c:	8622                	mv	a2,s0
 73e:	00000097          	auipc	ra,0x0
 742:	e04080e7          	jalr	-508(ra) # 542 <vprintf>
}
 746:	60e2                	ld	ra,24(sp)
 748:	6442                	ld	s0,16(sp)
 74a:	6161                	addi	sp,sp,80
 74c:	8082                	ret

000000000000074e <printf>:

void
printf(const char *fmt, ...)
{
 74e:	711d                	addi	sp,sp,-96
 750:	ec06                	sd	ra,24(sp)
 752:	e822                	sd	s0,16(sp)
 754:	1000                	addi	s0,sp,32
 756:	e40c                	sd	a1,8(s0)
 758:	e810                	sd	a2,16(s0)
 75a:	ec14                	sd	a3,24(s0)
 75c:	f018                	sd	a4,32(s0)
 75e:	f41c                	sd	a5,40(s0)
 760:	03043823          	sd	a6,48(s0)
 764:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 768:	00840613          	addi	a2,s0,8
 76c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 770:	85aa                	mv	a1,a0
 772:	4505                	li	a0,1
 774:	00000097          	auipc	ra,0x0
 778:	dce080e7          	jalr	-562(ra) # 542 <vprintf>
}
 77c:	60e2                	ld	ra,24(sp)
 77e:	6442                	ld	s0,16(sp)
 780:	6125                	addi	sp,sp,96
 782:	8082                	ret

0000000000000784 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 784:	1141                	addi	sp,sp,-16
 786:	e422                	sd	s0,8(sp)
 788:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 78a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78e:	00000797          	auipc	a5,0x0
 792:	28a7b783          	ld	a5,650(a5) # a18 <freep>
 796:	a805                	j	7c6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 798:	4618                	lw	a4,8(a2)
 79a:	9db9                	addw	a1,a1,a4
 79c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a0:	6398                	ld	a4,0(a5)
 7a2:	6318                	ld	a4,0(a4)
 7a4:	fee53823          	sd	a4,-16(a0)
 7a8:	a091                	j	7ec <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7aa:	ff852703          	lw	a4,-8(a0)
 7ae:	9e39                	addw	a2,a2,a4
 7b0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7b2:	ff053703          	ld	a4,-16(a0)
 7b6:	e398                	sd	a4,0(a5)
 7b8:	a099                	j	7fe <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ba:	6398                	ld	a4,0(a5)
 7bc:	00e7e463          	bltu	a5,a4,7c4 <free+0x40>
 7c0:	00e6ea63          	bltu	a3,a4,7d4 <free+0x50>
{
 7c4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c6:	fed7fae3          	bgeu	a5,a3,7ba <free+0x36>
 7ca:	6398                	ld	a4,0(a5)
 7cc:	00e6e463          	bltu	a3,a4,7d4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	fee7eae3          	bltu	a5,a4,7c4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7d4:	ff852583          	lw	a1,-8(a0)
 7d8:	6390                	ld	a2,0(a5)
 7da:	02059813          	slli	a6,a1,0x20
 7de:	01c85713          	srli	a4,a6,0x1c
 7e2:	9736                	add	a4,a4,a3
 7e4:	fae60ae3          	beq	a2,a4,798 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7e8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ec:	4790                	lw	a2,8(a5)
 7ee:	02061593          	slli	a1,a2,0x20
 7f2:	01c5d713          	srli	a4,a1,0x1c
 7f6:	973e                	add	a4,a4,a5
 7f8:	fae689e3          	beq	a3,a4,7aa <free+0x26>
  } else
    p->s.ptr = bp;
 7fc:	e394                	sd	a3,0(a5)
  freep = p;
 7fe:	00000717          	auipc	a4,0x0
 802:	20f73d23          	sd	a5,538(a4) # a18 <freep>
}
 806:	6422                	ld	s0,8(sp)
 808:	0141                	addi	sp,sp,16
 80a:	8082                	ret

000000000000080c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 80c:	7139                	addi	sp,sp,-64
 80e:	fc06                	sd	ra,56(sp)
 810:	f822                	sd	s0,48(sp)
 812:	f426                	sd	s1,40(sp)
 814:	f04a                	sd	s2,32(sp)
 816:	ec4e                	sd	s3,24(sp)
 818:	e852                	sd	s4,16(sp)
 81a:	e456                	sd	s5,8(sp)
 81c:	e05a                	sd	s6,0(sp)
 81e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 820:	02051493          	slli	s1,a0,0x20
 824:	9081                	srli	s1,s1,0x20
 826:	04bd                	addi	s1,s1,15
 828:	8091                	srli	s1,s1,0x4
 82a:	0014899b          	addiw	s3,s1,1
 82e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 830:	00000517          	auipc	a0,0x0
 834:	1e853503          	ld	a0,488(a0) # a18 <freep>
 838:	c515                	beqz	a0,864 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83c:	4798                	lw	a4,8(a5)
 83e:	02977f63          	bgeu	a4,s1,87c <malloc+0x70>
 842:	8a4e                	mv	s4,s3
 844:	0009871b          	sext.w	a4,s3
 848:	6685                	lui	a3,0x1
 84a:	00d77363          	bgeu	a4,a3,850 <malloc+0x44>
 84e:	6a05                	lui	s4,0x1
 850:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 854:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 858:	00000917          	auipc	s2,0x0
 85c:	1c090913          	addi	s2,s2,448 # a18 <freep>
  if(p == (char*)-1)
 860:	5afd                	li	s5,-1
 862:	a895                	j	8d6 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 864:	00000797          	auipc	a5,0x0
 868:	1bc78793          	addi	a5,a5,444 # a20 <base>
 86c:	00000717          	auipc	a4,0x0
 870:	1af73623          	sd	a5,428(a4) # a18 <freep>
 874:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 876:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 87a:	b7e1                	j	842 <malloc+0x36>
      if(p->s.size == nunits)
 87c:	02e48c63          	beq	s1,a4,8b4 <malloc+0xa8>
        p->s.size -= nunits;
 880:	4137073b          	subw	a4,a4,s3
 884:	c798                	sw	a4,8(a5)
        p += p->s.size;
 886:	02071693          	slli	a3,a4,0x20
 88a:	01c6d713          	srli	a4,a3,0x1c
 88e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 890:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 894:	00000717          	auipc	a4,0x0
 898:	18a73223          	sd	a0,388(a4) # a18 <freep>
      return (void*)(p + 1);
 89c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8a0:	70e2                	ld	ra,56(sp)
 8a2:	7442                	ld	s0,48(sp)
 8a4:	74a2                	ld	s1,40(sp)
 8a6:	7902                	ld	s2,32(sp)
 8a8:	69e2                	ld	s3,24(sp)
 8aa:	6a42                	ld	s4,16(sp)
 8ac:	6aa2                	ld	s5,8(sp)
 8ae:	6b02                	ld	s6,0(sp)
 8b0:	6121                	addi	sp,sp,64
 8b2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8b4:	6398                	ld	a4,0(a5)
 8b6:	e118                	sd	a4,0(a0)
 8b8:	bff1                	j	894 <malloc+0x88>
  hp->s.size = nu;
 8ba:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8be:	0541                	addi	a0,a0,16
 8c0:	00000097          	auipc	ra,0x0
 8c4:	ec4080e7          	jalr	-316(ra) # 784 <free>
  return freep;
 8c8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8cc:	d971                	beqz	a0,8a0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d0:	4798                	lw	a4,8(a5)
 8d2:	fa9775e3          	bgeu	a4,s1,87c <malloc+0x70>
    if(p == freep)
 8d6:	00093703          	ld	a4,0(s2)
 8da:	853e                	mv	a0,a5
 8dc:	fef719e3          	bne	a4,a5,8ce <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8e0:	8552                	mv	a0,s4
 8e2:	00000097          	auipc	ra,0x0
 8e6:	b74080e7          	jalr	-1164(ra) # 456 <sbrk>
  if(p == (char*)-1)
 8ea:	fd5518e3          	bne	a0,s5,8ba <malloc+0xae>
        return 0;
 8ee:	4501                	li	a0,0
 8f0:	bf45                	j	8a0 <malloc+0x94>
