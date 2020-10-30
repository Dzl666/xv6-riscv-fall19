
user/_ls：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	308080e7          	jalr	776(ra) # 318 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	2dc080e7          	jalr	732(ra) # 318 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2ba080e7          	jalr	698(ra) # 318 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	a3298993          	addi	s3,s3,-1486 # a98 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	416080e7          	jalr	1046(ra) # 48c <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	298080e7          	jalr	664(ra) # 318 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	28a080e7          	jalr	650(ra) # 318 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	29a080e7          	jalr	666(ra) # 342 <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	addi	s0,sp,624
  d6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  d8:	4581                	li	a1,0
  da:	00000097          	auipc	ra,0x0
  de:	424080e7          	jalr	1060(ra) # 4fe <open>
  e2:	06054f63          	bltz	a0,160 <ls+0xac>
  e6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  e8:	d9840593          	addi	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	42a080e7          	jalr	1066(ra) # 516 <fstat>
  f4:	08054163          	bltz	a0,176 <ls+0xc2>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  f8:	da041783          	lh	a5,-608(s0)
  fc:	0007869b          	sext.w	a3,a5
 100:	4705                	li	a4,1
 102:	08e68a63          	beq	a3,a4,196 <ls+0xe2>
 106:	4709                	li	a4,2
 108:	02e69663          	bne	a3,a4,134 <ls+0x80>
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 10c:	854a                	mv	a0,s2
 10e:	00000097          	auipc	ra,0x0
 112:	ef2080e7          	jalr	-270(ra) # 0 <fmtname>
 116:	85aa                	mv	a1,a0
 118:	da843703          	ld	a4,-600(s0)
 11c:	d9c42683          	lw	a3,-612(s0)
 120:	da041603          	lh	a2,-608(s0)
 124:	00001517          	auipc	a0,0x1
 128:	90c50513          	addi	a0,a0,-1780 # a30 <malloc+0x11c>
 12c:	00000097          	auipc	ra,0x0
 130:	72a080e7          	jalr	1834(ra) # 856 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 134:	8526                	mv	a0,s1
 136:	00000097          	auipc	ra,0x0
 13a:	3b0080e7          	jalr	944(ra) # 4e6 <close>
}
 13e:	26813083          	ld	ra,616(sp)
 142:	26013403          	ld	s0,608(sp)
 146:	25813483          	ld	s1,600(sp)
 14a:	25013903          	ld	s2,592(sp)
 14e:	24813983          	ld	s3,584(sp)
 152:	24013a03          	ld	s4,576(sp)
 156:	23813a83          	ld	s5,568(sp)
 15a:	27010113          	addi	sp,sp,624
 15e:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 160:	864a                	mv	a2,s2
 162:	00001597          	auipc	a1,0x1
 166:	89e58593          	addi	a1,a1,-1890 # a00 <malloc+0xec>
 16a:	4509                	li	a0,2
 16c:	00000097          	auipc	ra,0x0
 170:	6bc080e7          	jalr	1724(ra) # 828 <fprintf>
    return;
 174:	b7e9                	j	13e <ls+0x8a>
    fprintf(2, "ls: cannot stat %s\n", path);
 176:	864a                	mv	a2,s2
 178:	00001597          	auipc	a1,0x1
 17c:	8a058593          	addi	a1,a1,-1888 # a18 <malloc+0x104>
 180:	4509                	li	a0,2
 182:	00000097          	auipc	ra,0x0
 186:	6a6080e7          	jalr	1702(ra) # 828 <fprintf>
    close(fd);
 18a:	8526                	mv	a0,s1
 18c:	00000097          	auipc	ra,0x0
 190:	35a080e7          	jalr	858(ra) # 4e6 <close>
    return;
 194:	b76d                	j	13e <ls+0x8a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 196:	854a                	mv	a0,s2
 198:	00000097          	auipc	ra,0x0
 19c:	180080e7          	jalr	384(ra) # 318 <strlen>
 1a0:	2541                	addiw	a0,a0,16
 1a2:	20000793          	li	a5,512
 1a6:	00a7fb63          	bgeu	a5,a0,1bc <ls+0x108>
      printf("ls: path too long\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	89650513          	addi	a0,a0,-1898 # a40 <malloc+0x12c>
 1b2:	00000097          	auipc	ra,0x0
 1b6:	6a4080e7          	jalr	1700(ra) # 856 <printf>
      break;
 1ba:	bfad                	j	134 <ls+0x80>
    strcpy(buf, path);
 1bc:	85ca                	mv	a1,s2
 1be:	dc040513          	addi	a0,s0,-576
 1c2:	00000097          	auipc	ra,0x0
 1c6:	10e080e7          	jalr	270(ra) # 2d0 <strcpy>
    p = buf+strlen(buf);
 1ca:	dc040513          	addi	a0,s0,-576
 1ce:	00000097          	auipc	ra,0x0
 1d2:	14a080e7          	jalr	330(ra) # 318 <strlen>
 1d6:	02051913          	slli	s2,a0,0x20
 1da:	02095913          	srli	s2,s2,0x20
 1de:	dc040793          	addi	a5,s0,-576
 1e2:	993e                	add	s2,s2,a5
    *p++ = '/';
 1e4:	00190993          	addi	s3,s2,1
 1e8:	02f00793          	li	a5,47
 1ec:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1f0:	00001a17          	auipc	s4,0x1
 1f4:	868a0a13          	addi	s4,s4,-1944 # a58 <malloc+0x144>
        printf("ls: cannot stat %s\n", buf);
 1f8:	00001a97          	auipc	s5,0x1
 1fc:	820a8a93          	addi	s5,s5,-2016 # a18 <malloc+0x104>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 200:	a801                	j	210 <ls+0x15c>
        printf("ls: cannot stat %s\n", buf);
 202:	dc040593          	addi	a1,s0,-576
 206:	8556                	mv	a0,s5
 208:	00000097          	auipc	ra,0x0
 20c:	64e080e7          	jalr	1614(ra) # 856 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 210:	4641                	li	a2,16
 212:	db040593          	addi	a1,s0,-592
 216:	8526                	mv	a0,s1
 218:	00000097          	auipc	ra,0x0
 21c:	2be080e7          	jalr	702(ra) # 4d6 <read>
 220:	47c1                	li	a5,16
 222:	f0f519e3          	bne	a0,a5,134 <ls+0x80>
      if(de.inum == 0)
 226:	db045783          	lhu	a5,-592(s0)
 22a:	d3fd                	beqz	a5,210 <ls+0x15c>
      memmove(p, de.name, DIRSIZ);
 22c:	4639                	li	a2,14
 22e:	db240593          	addi	a1,s0,-590
 232:	854e                	mv	a0,s3
 234:	00000097          	auipc	ra,0x0
 238:	258080e7          	jalr	600(ra) # 48c <memmove>
      p[DIRSIZ] = 0;
 23c:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 240:	d9840593          	addi	a1,s0,-616
 244:	dc040513          	addi	a0,s0,-576
 248:	00000097          	auipc	ra,0x0
 24c:	1b4080e7          	jalr	436(ra) # 3fc <stat>
 250:	fa0549e3          	bltz	a0,202 <ls+0x14e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 254:	dc040513          	addi	a0,s0,-576
 258:	00000097          	auipc	ra,0x0
 25c:	da8080e7          	jalr	-600(ra) # 0 <fmtname>
 260:	85aa                	mv	a1,a0
 262:	da843703          	ld	a4,-600(s0)
 266:	d9c42683          	lw	a3,-612(s0)
 26a:	da041603          	lh	a2,-608(s0)
 26e:	8552                	mv	a0,s4
 270:	00000097          	auipc	ra,0x0
 274:	5e6080e7          	jalr	1510(ra) # 856 <printf>
 278:	bf61                	j	210 <ls+0x15c>

000000000000027a <main>:

int
main(int argc, char *argv[])
{
 27a:	1101                	addi	sp,sp,-32
 27c:	ec06                	sd	ra,24(sp)
 27e:	e822                	sd	s0,16(sp)
 280:	e426                	sd	s1,8(sp)
 282:	e04a                	sd	s2,0(sp)
 284:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 286:	4785                	li	a5,1
 288:	02a7d863          	bge	a5,a0,2b8 <main+0x3e>
 28c:	00858493          	addi	s1,a1,8
 290:	ffe5091b          	addiw	s2,a0,-2
 294:	02091793          	slli	a5,s2,0x20
 298:	01d7d913          	srli	s2,a5,0x1d
 29c:	05c1                	addi	a1,a1,16
 29e:	992e                	add	s2,s2,a1
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a0:	6088                	ld	a0,0(s1)
 2a2:	00000097          	auipc	ra,0x0
 2a6:	e12080e7          	jalr	-494(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2aa:	04a1                	addi	s1,s1,8
 2ac:	ff249ae3          	bne	s1,s2,2a0 <main+0x26>
  exit();
 2b0:	00000097          	auipc	ra,0x0
 2b4:	20e080e7          	jalr	526(ra) # 4be <exit>
    ls(".");
 2b8:	00000517          	auipc	a0,0x0
 2bc:	7b050513          	addi	a0,a0,1968 # a68 <malloc+0x154>
 2c0:	00000097          	auipc	ra,0x0
 2c4:	df4080e7          	jalr	-524(ra) # b4 <ls>
    exit();
 2c8:	00000097          	auipc	ra,0x0
 2cc:	1f6080e7          	jalr	502(ra) # 4be <exit>

00000000000002d0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2d6:	87aa                	mv	a5,a0
 2d8:	0585                	addi	a1,a1,1
 2da:	0785                	addi	a5,a5,1
 2dc:	fff5c703          	lbu	a4,-1(a1)
 2e0:	fee78fa3          	sb	a4,-1(a5)
 2e4:	fb75                	bnez	a4,2d8 <strcpy+0x8>
    ;
  return os;
}
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2f2:	00054783          	lbu	a5,0(a0)
 2f6:	cb91                	beqz	a5,30a <strcmp+0x1e>
 2f8:	0005c703          	lbu	a4,0(a1)
 2fc:	00f71763          	bne	a4,a5,30a <strcmp+0x1e>
    p++, q++;
 300:	0505                	addi	a0,a0,1
 302:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 304:	00054783          	lbu	a5,0(a0)
 308:	fbe5                	bnez	a5,2f8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 30a:	0005c503          	lbu	a0,0(a1)
}
 30e:	40a7853b          	subw	a0,a5,a0
 312:	6422                	ld	s0,8(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <strlen>:

uint
strlen(const char *s)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 31e:	00054783          	lbu	a5,0(a0)
 322:	cf91                	beqz	a5,33e <strlen+0x26>
 324:	0505                	addi	a0,a0,1
 326:	87aa                	mv	a5,a0
 328:	4685                	li	a3,1
 32a:	9e89                	subw	a3,a3,a0
 32c:	00f6853b          	addw	a0,a3,a5
 330:	0785                	addi	a5,a5,1
 332:	fff7c703          	lbu	a4,-1(a5)
 336:	fb7d                	bnez	a4,32c <strlen+0x14>
    ;
  return n;
}
 338:	6422                	ld	s0,8(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret
  for(n = 0; s[n]; n++)
 33e:	4501                	li	a0,0
 340:	bfe5                	j	338 <strlen+0x20>

0000000000000342 <memset>:

void*
memset(void *dst, int c, uint n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e422                	sd	s0,8(sp)
 346:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 348:	ca19                	beqz	a2,35e <memset+0x1c>
 34a:	87aa                	mv	a5,a0
 34c:	1602                	slli	a2,a2,0x20
 34e:	9201                	srli	a2,a2,0x20
 350:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 354:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 358:	0785                	addi	a5,a5,1
 35a:	fee79de3          	bne	a5,a4,354 <memset+0x12>
  }
  return dst;
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret

0000000000000364 <strchr>:

char*
strchr(const char *s, char c)
{
 364:	1141                	addi	sp,sp,-16
 366:	e422                	sd	s0,8(sp)
 368:	0800                	addi	s0,sp,16
  for(; *s; s++)
 36a:	00054783          	lbu	a5,0(a0)
 36e:	cb99                	beqz	a5,384 <strchr+0x20>
    if(*s == c)
 370:	00f58763          	beq	a1,a5,37e <strchr+0x1a>
  for(; *s; s++)
 374:	0505                	addi	a0,a0,1
 376:	00054783          	lbu	a5,0(a0)
 37a:	fbfd                	bnez	a5,370 <strchr+0xc>
      return (char*)s;
  return 0;
 37c:	4501                	li	a0,0
}
 37e:	6422                	ld	s0,8(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret
  return 0;
 384:	4501                	li	a0,0
 386:	bfe5                	j	37e <strchr+0x1a>

0000000000000388 <gets>:

char*
gets(char *buf, int max)
{
 388:	711d                	addi	sp,sp,-96
 38a:	ec86                	sd	ra,88(sp)
 38c:	e8a2                	sd	s0,80(sp)
 38e:	e4a6                	sd	s1,72(sp)
 390:	e0ca                	sd	s2,64(sp)
 392:	fc4e                	sd	s3,56(sp)
 394:	f852                	sd	s4,48(sp)
 396:	f456                	sd	s5,40(sp)
 398:	f05a                	sd	s6,32(sp)
 39a:	ec5e                	sd	s7,24(sp)
 39c:	1080                	addi	s0,sp,96
 39e:	8baa                	mv	s7,a0
 3a0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a2:	892a                	mv	s2,a0
 3a4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3a6:	4aa9                	li	s5,10
 3a8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3aa:	89a6                	mv	s3,s1
 3ac:	2485                	addiw	s1,s1,1
 3ae:	0344d863          	bge	s1,s4,3de <gets+0x56>
    cc = read(0, &c, 1);
 3b2:	4605                	li	a2,1
 3b4:	faf40593          	addi	a1,s0,-81
 3b8:	4501                	li	a0,0
 3ba:	00000097          	auipc	ra,0x0
 3be:	11c080e7          	jalr	284(ra) # 4d6 <read>
    if(cc < 1)
 3c2:	00a05e63          	blez	a0,3de <gets+0x56>
    buf[i++] = c;
 3c6:	faf44783          	lbu	a5,-81(s0)
 3ca:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3ce:	01578763          	beq	a5,s5,3dc <gets+0x54>
 3d2:	0905                	addi	s2,s2,1
 3d4:	fd679be3          	bne	a5,s6,3aa <gets+0x22>
  for(i=0; i+1 < max; ){
 3d8:	89a6                	mv	s3,s1
 3da:	a011                	j	3de <gets+0x56>
 3dc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3de:	99de                	add	s3,s3,s7
 3e0:	00098023          	sb	zero,0(s3)
  return buf;
}
 3e4:	855e                	mv	a0,s7
 3e6:	60e6                	ld	ra,88(sp)
 3e8:	6446                	ld	s0,80(sp)
 3ea:	64a6                	ld	s1,72(sp)
 3ec:	6906                	ld	s2,64(sp)
 3ee:	79e2                	ld	s3,56(sp)
 3f0:	7a42                	ld	s4,48(sp)
 3f2:	7aa2                	ld	s5,40(sp)
 3f4:	7b02                	ld	s6,32(sp)
 3f6:	6be2                	ld	s7,24(sp)
 3f8:	6125                	addi	sp,sp,96
 3fa:	8082                	ret

00000000000003fc <stat>:

int
stat(const char *n, struct stat *st)
{
 3fc:	1101                	addi	sp,sp,-32
 3fe:	ec06                	sd	ra,24(sp)
 400:	e822                	sd	s0,16(sp)
 402:	e426                	sd	s1,8(sp)
 404:	e04a                	sd	s2,0(sp)
 406:	1000                	addi	s0,sp,32
 408:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 40a:	4581                	li	a1,0
 40c:	00000097          	auipc	ra,0x0
 410:	0f2080e7          	jalr	242(ra) # 4fe <open>
  if(fd < 0)
 414:	02054563          	bltz	a0,43e <stat+0x42>
 418:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 41a:	85ca                	mv	a1,s2
 41c:	00000097          	auipc	ra,0x0
 420:	0fa080e7          	jalr	250(ra) # 516 <fstat>
 424:	892a                	mv	s2,a0
  close(fd);
 426:	8526                	mv	a0,s1
 428:	00000097          	auipc	ra,0x0
 42c:	0be080e7          	jalr	190(ra) # 4e6 <close>
  return r;
}
 430:	854a                	mv	a0,s2
 432:	60e2                	ld	ra,24(sp)
 434:	6442                	ld	s0,16(sp)
 436:	64a2                	ld	s1,8(sp)
 438:	6902                	ld	s2,0(sp)
 43a:	6105                	addi	sp,sp,32
 43c:	8082                	ret
    return -1;
 43e:	597d                	li	s2,-1
 440:	bfc5                	j	430 <stat+0x34>

0000000000000442 <atoi>:

int
atoi(const char *s)
{
 442:	1141                	addi	sp,sp,-16
 444:	e422                	sd	s0,8(sp)
 446:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 448:	00054603          	lbu	a2,0(a0)
 44c:	fd06079b          	addiw	a5,a2,-48
 450:	0ff7f793          	andi	a5,a5,255
 454:	4725                	li	a4,9
 456:	02f76963          	bltu	a4,a5,488 <atoi+0x46>
 45a:	86aa                	mv	a3,a0
  n = 0;
 45c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 45e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 460:	0685                	addi	a3,a3,1
 462:	0025179b          	slliw	a5,a0,0x2
 466:	9fa9                	addw	a5,a5,a0
 468:	0017979b          	slliw	a5,a5,0x1
 46c:	9fb1                	addw	a5,a5,a2
 46e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 472:	0006c603          	lbu	a2,0(a3)
 476:	fd06071b          	addiw	a4,a2,-48
 47a:	0ff77713          	andi	a4,a4,255
 47e:	fee5f1e3          	bgeu	a1,a4,460 <atoi+0x1e>
  return n;
}
 482:	6422                	ld	s0,8(sp)
 484:	0141                	addi	sp,sp,16
 486:	8082                	ret
  n = 0;
 488:	4501                	li	a0,0
 48a:	bfe5                	j	482 <atoi+0x40>

000000000000048c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 48c:	1141                	addi	sp,sp,-16
 48e:	e422                	sd	s0,8(sp)
 490:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 492:	00c05f63          	blez	a2,4b0 <memmove+0x24>
 496:	1602                	slli	a2,a2,0x20
 498:	9201                	srli	a2,a2,0x20
 49a:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 49e:	87aa                	mv	a5,a0
    *dst++ = *src++;
 4a0:	0585                	addi	a1,a1,1
 4a2:	0785                	addi	a5,a5,1
 4a4:	fff5c703          	lbu	a4,-1(a1)
 4a8:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 4ac:	fed79ae3          	bne	a5,a3,4a0 <memmove+0x14>
  return vdst;
}
 4b0:	6422                	ld	s0,8(sp)
 4b2:	0141                	addi	sp,sp,16
 4b4:	8082                	ret

00000000000004b6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4b6:	4885                	li	a7,1
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <exit>:
.global exit
exit:
 li a7, SYS_exit
 4be:	4889                	li	a7,2
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4c6:	488d                	li	a7,3
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4ce:	4891                	li	a7,4
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <read>:
.global read
read:
 li a7, SYS_read
 4d6:	4895                	li	a7,5
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <write>:
.global write
write:
 li a7, SYS_write
 4de:	48c1                	li	a7,16
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <close>:
.global close
close:
 li a7, SYS_close
 4e6:	48d5                	li	a7,21
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ee:	4899                	li	a7,6
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4f6:	489d                	li	a7,7
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <open>:
.global open
open:
 li a7, SYS_open
 4fe:	48bd                	li	a7,15
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 506:	48c5                	li	a7,17
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 50e:	48c9                	li	a7,18
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 516:	48a1                	li	a7,8
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <link>:
.global link
link:
 li a7, SYS_link
 51e:	48cd                	li	a7,19
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 526:	48d1                	li	a7,20
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 52e:	48a5                	li	a7,9
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <dup>:
.global dup
dup:
 li a7, SYS_dup
 536:	48a9                	li	a7,10
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 53e:	48ad                	li	a7,11
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 546:	48b1                	li	a7,12
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 54e:	48b5                	li	a7,13
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 556:	48b9                	li	a7,14
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 55e:	48d9                	li	a7,22
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <crash>:
.global crash
crash:
 li a7, SYS_crash
 566:	48dd                	li	a7,23
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <mount>:
.global mount
mount:
 li a7, SYS_mount
 56e:	48e1                	li	a7,24
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <umount>:
.global umount
umount:
 li a7, SYS_umount
 576:	48e5                	li	a7,25
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 57e:	1101                	addi	sp,sp,-32
 580:	ec06                	sd	ra,24(sp)
 582:	e822                	sd	s0,16(sp)
 584:	1000                	addi	s0,sp,32
 586:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 58a:	4605                	li	a2,1
 58c:	fef40593          	addi	a1,s0,-17
 590:	00000097          	auipc	ra,0x0
 594:	f4e080e7          	jalr	-178(ra) # 4de <write>
}
 598:	60e2                	ld	ra,24(sp)
 59a:	6442                	ld	s0,16(sp)
 59c:	6105                	addi	sp,sp,32
 59e:	8082                	ret

00000000000005a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5a0:	7139                	addi	sp,sp,-64
 5a2:	fc06                	sd	ra,56(sp)
 5a4:	f822                	sd	s0,48(sp)
 5a6:	f426                	sd	s1,40(sp)
 5a8:	f04a                	sd	s2,32(sp)
 5aa:	ec4e                	sd	s3,24(sp)
 5ac:	0080                	addi	s0,sp,64
 5ae:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5b0:	c299                	beqz	a3,5b6 <printint+0x16>
 5b2:	0805c863          	bltz	a1,642 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5b6:	2581                	sext.w	a1,a1
  neg = 0;
 5b8:	4881                	li	a7,0
 5ba:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5be:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5c0:	2601                	sext.w	a2,a2
 5c2:	00000517          	auipc	a0,0x0
 5c6:	4b650513          	addi	a0,a0,1206 # a78 <digits>
 5ca:	883a                	mv	a6,a4
 5cc:	2705                	addiw	a4,a4,1
 5ce:	02c5f7bb          	remuw	a5,a1,a2
 5d2:	1782                	slli	a5,a5,0x20
 5d4:	9381                	srli	a5,a5,0x20
 5d6:	97aa                	add	a5,a5,a0
 5d8:	0007c783          	lbu	a5,0(a5)
 5dc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5e0:	0005879b          	sext.w	a5,a1
 5e4:	02c5d5bb          	divuw	a1,a1,a2
 5e8:	0685                	addi	a3,a3,1
 5ea:	fec7f0e3          	bgeu	a5,a2,5ca <printint+0x2a>
  if(neg)
 5ee:	00088b63          	beqz	a7,604 <printint+0x64>
    buf[i++] = '-';
 5f2:	fd040793          	addi	a5,s0,-48
 5f6:	973e                	add	a4,a4,a5
 5f8:	02d00793          	li	a5,45
 5fc:	fef70823          	sb	a5,-16(a4)
 600:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 604:	02e05863          	blez	a4,634 <printint+0x94>
 608:	fc040793          	addi	a5,s0,-64
 60c:	00e78933          	add	s2,a5,a4
 610:	fff78993          	addi	s3,a5,-1
 614:	99ba                	add	s3,s3,a4
 616:	377d                	addiw	a4,a4,-1
 618:	1702                	slli	a4,a4,0x20
 61a:	9301                	srli	a4,a4,0x20
 61c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 620:	fff94583          	lbu	a1,-1(s2)
 624:	8526                	mv	a0,s1
 626:	00000097          	auipc	ra,0x0
 62a:	f58080e7          	jalr	-168(ra) # 57e <putc>
  while(--i >= 0)
 62e:	197d                	addi	s2,s2,-1
 630:	ff3918e3          	bne	s2,s3,620 <printint+0x80>
}
 634:	70e2                	ld	ra,56(sp)
 636:	7442                	ld	s0,48(sp)
 638:	74a2                	ld	s1,40(sp)
 63a:	7902                	ld	s2,32(sp)
 63c:	69e2                	ld	s3,24(sp)
 63e:	6121                	addi	sp,sp,64
 640:	8082                	ret
    x = -xx;
 642:	40b005bb          	negw	a1,a1
    neg = 1;
 646:	4885                	li	a7,1
    x = -xx;
 648:	bf8d                	j	5ba <printint+0x1a>

000000000000064a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 64a:	7119                	addi	sp,sp,-128
 64c:	fc86                	sd	ra,120(sp)
 64e:	f8a2                	sd	s0,112(sp)
 650:	f4a6                	sd	s1,104(sp)
 652:	f0ca                	sd	s2,96(sp)
 654:	ecce                	sd	s3,88(sp)
 656:	e8d2                	sd	s4,80(sp)
 658:	e4d6                	sd	s5,72(sp)
 65a:	e0da                	sd	s6,64(sp)
 65c:	fc5e                	sd	s7,56(sp)
 65e:	f862                	sd	s8,48(sp)
 660:	f466                	sd	s9,40(sp)
 662:	f06a                	sd	s10,32(sp)
 664:	ec6e                	sd	s11,24(sp)
 666:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 668:	0005c903          	lbu	s2,0(a1)
 66c:	18090f63          	beqz	s2,80a <vprintf+0x1c0>
 670:	8aaa                	mv	s5,a0
 672:	8b32                	mv	s6,a2
 674:	00158493          	addi	s1,a1,1
  state = 0;
 678:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 67a:	02500a13          	li	s4,37
      if(c == 'd'){
 67e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 682:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 686:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 68a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68e:	00000b97          	auipc	s7,0x0
 692:	3eab8b93          	addi	s7,s7,1002 # a78 <digits>
 696:	a839                	j	6b4 <vprintf+0x6a>
        putc(fd, c);
 698:	85ca                	mv	a1,s2
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	ee2080e7          	jalr	-286(ra) # 57e <putc>
 6a4:	a019                	j	6aa <vprintf+0x60>
    } else if(state == '%'){
 6a6:	01498f63          	beq	s3,s4,6c4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6aa:	0485                	addi	s1,s1,1
 6ac:	fff4c903          	lbu	s2,-1(s1)
 6b0:	14090d63          	beqz	s2,80a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6b4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6b8:	fe0997e3          	bnez	s3,6a6 <vprintf+0x5c>
      if(c == '%'){
 6bc:	fd479ee3          	bne	a5,s4,698 <vprintf+0x4e>
        state = '%';
 6c0:	89be                	mv	s3,a5
 6c2:	b7e5                	j	6aa <vprintf+0x60>
      if(c == 'd'){
 6c4:	05878063          	beq	a5,s8,704 <vprintf+0xba>
      } else if(c == 'l') {
 6c8:	05978c63          	beq	a5,s9,720 <vprintf+0xd6>
      } else if(c == 'x') {
 6cc:	07a78863          	beq	a5,s10,73c <vprintf+0xf2>
      } else if(c == 'p') {
 6d0:	09b78463          	beq	a5,s11,758 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6d4:	07300713          	li	a4,115
 6d8:	0ce78663          	beq	a5,a4,7a4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6dc:	06300713          	li	a4,99
 6e0:	0ee78e63          	beq	a5,a4,7dc <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6e4:	11478863          	beq	a5,s4,7f4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6e8:	85d2                	mv	a1,s4
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	e92080e7          	jalr	-366(ra) # 57e <putc>
        putc(fd, c);
 6f4:	85ca                	mv	a1,s2
 6f6:	8556                	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	e86080e7          	jalr	-378(ra) # 57e <putc>
      }
      state = 0;
 700:	4981                	li	s3,0
 702:	b765                	j	6aa <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 704:	008b0913          	addi	s2,s6,8
 708:	4685                	li	a3,1
 70a:	4629                	li	a2,10
 70c:	000b2583          	lw	a1,0(s6)
 710:	8556                	mv	a0,s5
 712:	00000097          	auipc	ra,0x0
 716:	e8e080e7          	jalr	-370(ra) # 5a0 <printint>
 71a:	8b4a                	mv	s6,s2
      state = 0;
 71c:	4981                	li	s3,0
 71e:	b771                	j	6aa <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 720:	008b0913          	addi	s2,s6,8
 724:	4681                	li	a3,0
 726:	4629                	li	a2,10
 728:	000b2583          	lw	a1,0(s6)
 72c:	8556                	mv	a0,s5
 72e:	00000097          	auipc	ra,0x0
 732:	e72080e7          	jalr	-398(ra) # 5a0 <printint>
 736:	8b4a                	mv	s6,s2
      state = 0;
 738:	4981                	li	s3,0
 73a:	bf85                	j	6aa <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 73c:	008b0913          	addi	s2,s6,8
 740:	4681                	li	a3,0
 742:	4641                	li	a2,16
 744:	000b2583          	lw	a1,0(s6)
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	e56080e7          	jalr	-426(ra) # 5a0 <printint>
 752:	8b4a                	mv	s6,s2
      state = 0;
 754:	4981                	li	s3,0
 756:	bf91                	j	6aa <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 758:	008b0793          	addi	a5,s6,8
 75c:	f8f43423          	sd	a5,-120(s0)
 760:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 764:	03000593          	li	a1,48
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	e14080e7          	jalr	-492(ra) # 57e <putc>
  putc(fd, 'x');
 772:	85ea                	mv	a1,s10
 774:	8556                	mv	a0,s5
 776:	00000097          	auipc	ra,0x0
 77a:	e08080e7          	jalr	-504(ra) # 57e <putc>
 77e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 780:	03c9d793          	srli	a5,s3,0x3c
 784:	97de                	add	a5,a5,s7
 786:	0007c583          	lbu	a1,0(a5)
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	df2080e7          	jalr	-526(ra) # 57e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 794:	0992                	slli	s3,s3,0x4
 796:	397d                	addiw	s2,s2,-1
 798:	fe0914e3          	bnez	s2,780 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 79c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	b721                	j	6aa <vprintf+0x60>
        s = va_arg(ap, char*);
 7a4:	008b0993          	addi	s3,s6,8
 7a8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7ac:	02090163          	beqz	s2,7ce <vprintf+0x184>
        while(*s != 0){
 7b0:	00094583          	lbu	a1,0(s2)
 7b4:	c9a1                	beqz	a1,804 <vprintf+0x1ba>
          putc(fd, *s);
 7b6:	8556                	mv	a0,s5
 7b8:	00000097          	auipc	ra,0x0
 7bc:	dc6080e7          	jalr	-570(ra) # 57e <putc>
          s++;
 7c0:	0905                	addi	s2,s2,1
        while(*s != 0){
 7c2:	00094583          	lbu	a1,0(s2)
 7c6:	f9e5                	bnez	a1,7b6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7c8:	8b4e                	mv	s6,s3
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	bdf9                	j	6aa <vprintf+0x60>
          s = "(null)";
 7ce:	00000917          	auipc	s2,0x0
 7d2:	2a290913          	addi	s2,s2,674 # a70 <malloc+0x15c>
        while(*s != 0){
 7d6:	02800593          	li	a1,40
 7da:	bff1                	j	7b6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7dc:	008b0913          	addi	s2,s6,8
 7e0:	000b4583          	lbu	a1,0(s6)
 7e4:	8556                	mv	a0,s5
 7e6:	00000097          	auipc	ra,0x0
 7ea:	d98080e7          	jalr	-616(ra) # 57e <putc>
 7ee:	8b4a                	mv	s6,s2
      state = 0;
 7f0:	4981                	li	s3,0
 7f2:	bd65                	j	6aa <vprintf+0x60>
        putc(fd, c);
 7f4:	85d2                	mv	a1,s4
 7f6:	8556                	mv	a0,s5
 7f8:	00000097          	auipc	ra,0x0
 7fc:	d86080e7          	jalr	-634(ra) # 57e <putc>
      state = 0;
 800:	4981                	li	s3,0
 802:	b565                	j	6aa <vprintf+0x60>
        s = va_arg(ap, char*);
 804:	8b4e                	mv	s6,s3
      state = 0;
 806:	4981                	li	s3,0
 808:	b54d                	j	6aa <vprintf+0x60>
    }
  }
}
 80a:	70e6                	ld	ra,120(sp)
 80c:	7446                	ld	s0,112(sp)
 80e:	74a6                	ld	s1,104(sp)
 810:	7906                	ld	s2,96(sp)
 812:	69e6                	ld	s3,88(sp)
 814:	6a46                	ld	s4,80(sp)
 816:	6aa6                	ld	s5,72(sp)
 818:	6b06                	ld	s6,64(sp)
 81a:	7be2                	ld	s7,56(sp)
 81c:	7c42                	ld	s8,48(sp)
 81e:	7ca2                	ld	s9,40(sp)
 820:	7d02                	ld	s10,32(sp)
 822:	6de2                	ld	s11,24(sp)
 824:	6109                	addi	sp,sp,128
 826:	8082                	ret

0000000000000828 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 828:	715d                	addi	sp,sp,-80
 82a:	ec06                	sd	ra,24(sp)
 82c:	e822                	sd	s0,16(sp)
 82e:	1000                	addi	s0,sp,32
 830:	e010                	sd	a2,0(s0)
 832:	e414                	sd	a3,8(s0)
 834:	e818                	sd	a4,16(s0)
 836:	ec1c                	sd	a5,24(s0)
 838:	03043023          	sd	a6,32(s0)
 83c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 840:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 844:	8622                	mv	a2,s0
 846:	00000097          	auipc	ra,0x0
 84a:	e04080e7          	jalr	-508(ra) # 64a <vprintf>
}
 84e:	60e2                	ld	ra,24(sp)
 850:	6442                	ld	s0,16(sp)
 852:	6161                	addi	sp,sp,80
 854:	8082                	ret

0000000000000856 <printf>:

void
printf(const char *fmt, ...)
{
 856:	711d                	addi	sp,sp,-96
 858:	ec06                	sd	ra,24(sp)
 85a:	e822                	sd	s0,16(sp)
 85c:	1000                	addi	s0,sp,32
 85e:	e40c                	sd	a1,8(s0)
 860:	e810                	sd	a2,16(s0)
 862:	ec14                	sd	a3,24(s0)
 864:	f018                	sd	a4,32(s0)
 866:	f41c                	sd	a5,40(s0)
 868:	03043823          	sd	a6,48(s0)
 86c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 870:	00840613          	addi	a2,s0,8
 874:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 878:	85aa                	mv	a1,a0
 87a:	4505                	li	a0,1
 87c:	00000097          	auipc	ra,0x0
 880:	dce080e7          	jalr	-562(ra) # 64a <vprintf>
}
 884:	60e2                	ld	ra,24(sp)
 886:	6442                	ld	s0,16(sp)
 888:	6125                	addi	sp,sp,96
 88a:	8082                	ret

000000000000088c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 88c:	1141                	addi	sp,sp,-16
 88e:	e422                	sd	s0,8(sp)
 890:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 892:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 896:	00000797          	auipc	a5,0x0
 89a:	1fa7b783          	ld	a5,506(a5) # a90 <freep>
 89e:	a805                	j	8ce <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8a0:	4618                	lw	a4,8(a2)
 8a2:	9db9                	addw	a1,a1,a4
 8a4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a8:	6398                	ld	a4,0(a5)
 8aa:	6318                	ld	a4,0(a4)
 8ac:	fee53823          	sd	a4,-16(a0)
 8b0:	a091                	j	8f4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8b2:	ff852703          	lw	a4,-8(a0)
 8b6:	9e39                	addw	a2,a2,a4
 8b8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8ba:	ff053703          	ld	a4,-16(a0)
 8be:	e398                	sd	a4,0(a5)
 8c0:	a099                	j	906 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c2:	6398                	ld	a4,0(a5)
 8c4:	00e7e463          	bltu	a5,a4,8cc <free+0x40>
 8c8:	00e6ea63          	bltu	a3,a4,8dc <free+0x50>
{
 8cc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ce:	fed7fae3          	bgeu	a5,a3,8c2 <free+0x36>
 8d2:	6398                	ld	a4,0(a5)
 8d4:	00e6e463          	bltu	a3,a4,8dc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d8:	fee7eae3          	bltu	a5,a4,8cc <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8dc:	ff852583          	lw	a1,-8(a0)
 8e0:	6390                	ld	a2,0(a5)
 8e2:	02059813          	slli	a6,a1,0x20
 8e6:	01c85713          	srli	a4,a6,0x1c
 8ea:	9736                	add	a4,a4,a3
 8ec:	fae60ae3          	beq	a2,a4,8a0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8f0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8f4:	4790                	lw	a2,8(a5)
 8f6:	02061593          	slli	a1,a2,0x20
 8fa:	01c5d713          	srli	a4,a1,0x1c
 8fe:	973e                	add	a4,a4,a5
 900:	fae689e3          	beq	a3,a4,8b2 <free+0x26>
  } else
    p->s.ptr = bp;
 904:	e394                	sd	a3,0(a5)
  freep = p;
 906:	00000717          	auipc	a4,0x0
 90a:	18f73523          	sd	a5,394(a4) # a90 <freep>
}
 90e:	6422                	ld	s0,8(sp)
 910:	0141                	addi	sp,sp,16
 912:	8082                	ret

0000000000000914 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 914:	7139                	addi	sp,sp,-64
 916:	fc06                	sd	ra,56(sp)
 918:	f822                	sd	s0,48(sp)
 91a:	f426                	sd	s1,40(sp)
 91c:	f04a                	sd	s2,32(sp)
 91e:	ec4e                	sd	s3,24(sp)
 920:	e852                	sd	s4,16(sp)
 922:	e456                	sd	s5,8(sp)
 924:	e05a                	sd	s6,0(sp)
 926:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 928:	02051493          	slli	s1,a0,0x20
 92c:	9081                	srli	s1,s1,0x20
 92e:	04bd                	addi	s1,s1,15
 930:	8091                	srli	s1,s1,0x4
 932:	0014899b          	addiw	s3,s1,1
 936:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 938:	00000517          	auipc	a0,0x0
 93c:	15853503          	ld	a0,344(a0) # a90 <freep>
 940:	c515                	beqz	a0,96c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 942:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 944:	4798                	lw	a4,8(a5)
 946:	02977f63          	bgeu	a4,s1,984 <malloc+0x70>
 94a:	8a4e                	mv	s4,s3
 94c:	0009871b          	sext.w	a4,s3
 950:	6685                	lui	a3,0x1
 952:	00d77363          	bgeu	a4,a3,958 <malloc+0x44>
 956:	6a05                	lui	s4,0x1
 958:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 95c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 960:	00000917          	auipc	s2,0x0
 964:	13090913          	addi	s2,s2,304 # a90 <freep>
  if(p == (char*)-1)
 968:	5afd                	li	s5,-1
 96a:	a895                	j	9de <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 96c:	00000797          	auipc	a5,0x0
 970:	13c78793          	addi	a5,a5,316 # aa8 <base>
 974:	00000717          	auipc	a4,0x0
 978:	10f73e23          	sd	a5,284(a4) # a90 <freep>
 97c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 97e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 982:	b7e1                	j	94a <malloc+0x36>
      if(p->s.size == nunits)
 984:	02e48c63          	beq	s1,a4,9bc <malloc+0xa8>
        p->s.size -= nunits;
 988:	4137073b          	subw	a4,a4,s3
 98c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 98e:	02071693          	slli	a3,a4,0x20
 992:	01c6d713          	srli	a4,a3,0x1c
 996:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 998:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 99c:	00000717          	auipc	a4,0x0
 9a0:	0ea73a23          	sd	a0,244(a4) # a90 <freep>
      return (void*)(p + 1);
 9a4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9a8:	70e2                	ld	ra,56(sp)
 9aa:	7442                	ld	s0,48(sp)
 9ac:	74a2                	ld	s1,40(sp)
 9ae:	7902                	ld	s2,32(sp)
 9b0:	69e2                	ld	s3,24(sp)
 9b2:	6a42                	ld	s4,16(sp)
 9b4:	6aa2                	ld	s5,8(sp)
 9b6:	6b02                	ld	s6,0(sp)
 9b8:	6121                	addi	sp,sp,64
 9ba:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9bc:	6398                	ld	a4,0(a5)
 9be:	e118                	sd	a4,0(a0)
 9c0:	bff1                	j	99c <malloc+0x88>
  hp->s.size = nu;
 9c2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9c6:	0541                	addi	a0,a0,16
 9c8:	00000097          	auipc	ra,0x0
 9cc:	ec4080e7          	jalr	-316(ra) # 88c <free>
  return freep;
 9d0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9d4:	d971                	beqz	a0,9a8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d8:	4798                	lw	a4,8(a5)
 9da:	fa9775e3          	bgeu	a4,s1,984 <malloc+0x70>
    if(p == freep)
 9de:	00093703          	ld	a4,0(s2)
 9e2:	853e                	mv	a0,a5
 9e4:	fef719e3          	bne	a4,a5,9d6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9e8:	8552                	mv	a0,s4
 9ea:	00000097          	auipc	ra,0x0
 9ee:	b5c080e7          	jalr	-1188(ra) # 546 <sbrk>
  if(p == (char*)-1)
 9f2:	fd5518e3          	bne	a0,s5,9c2 <malloc+0xae>
        return 0;
 9f6:	4501                	li	a0,0
 9f8:	bf45                	j	9a8 <malloc+0x94>
