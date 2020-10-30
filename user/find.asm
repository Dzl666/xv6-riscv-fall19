
user/_find：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "user/user.h"

char*
fmtname(char *path)   //找出路径中的文件名
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
    static char buf[DIRSIZ+1];
    char *p;

    // Find first character after last slash.
    for(p=path+strlen(path); p >= path && *p != '/'; p--)
   e:	00000097          	auipc	ra,0x0
  12:	2da080e7          	jalr	730(ra) # 2e8 <strlen>
  16:	02051593          	slli	a1,a0,0x20
  1a:	9181                	srli	a1,a1,0x20
  1c:	95a6                	add	a1,a1,s1
  1e:	02f00713          	li	a4,47
  22:	0095e963          	bltu	a1,s1,34 <fmtname+0x34>
  26:	0005c783          	lbu	a5,0(a1)
  2a:	00e78563          	beq	a5,a4,34 <fmtname+0x34>
  2e:	15fd                	addi	a1,a1,-1
  30:	fe95fbe3          	bgeu	a1,s1,26 <fmtname+0x26>
        ;
    p++;
  34:	00158493          	addi	s1,a1,1
    memset(buf, '\0', sizeof(buf)); //clean
  38:	00001917          	auipc	s2,0x1
  3c:	a5090913          	addi	s2,s2,-1456 # a88 <buf.0>
  40:	463d                	li	a2,15
  42:	4581                	li	a1,0
  44:	854a                	mv	a0,s2
  46:	00000097          	auipc	ra,0x0
  4a:	2cc080e7          	jalr	716(ra) # 312 <memset>
    // Return blank-padded name.
    memmove(buf, p, strlen(p));
  4e:	8526                	mv	a0,s1
  50:	00000097          	auipc	ra,0x0
  54:	298080e7          	jalr	664(ra) # 2e8 <strlen>
  58:	0005061b          	sext.w	a2,a0
  5c:	85a6                	mv	a1,s1
  5e:	854a                	mv	a0,s2
  60:	00000097          	auipc	ra,0x0
  64:	3fc080e7          	jalr	1020(ra) # 45c <memmove>
    return buf;
}
  68:	854a                	mv	a0,s2
  6a:	60e2                	ld	ra,24(sp)
  6c:	6442                	ld	s0,16(sp)
  6e:	64a2                	ld	s1,8(sp)
  70:	6902                	ld	s2,0(sp)
  72:	6105                	addi	sp,sp,32
  74:	8082                	ret

0000000000000076 <find>:

void 
find(char* path, char* filename)
{
  76:	d8010113          	addi	sp,sp,-640
  7a:	26113c23          	sd	ra,632(sp)
  7e:	26813823          	sd	s0,624(sp)
  82:	26913423          	sd	s1,616(sp)
  86:	27213023          	sd	s2,608(sp)
  8a:	25313c23          	sd	s3,600(sp)
  8e:	25413823          	sd	s4,592(sp)
  92:	25513423          	sd	s5,584(sp)
  96:	25613023          	sd	s6,576(sp)
  9a:	23713c23          	sd	s7,568(sp)
  9e:	0500                	addi	s0,sp,640
  a0:	892a                	mv	s2,a0
  a2:	89ae                	mv	s3,a1
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if((fd = open(path, 0)) < 0){
  a4:	4581                	li	a1,0
  a6:	00000097          	auipc	ra,0x0
  aa:	428080e7          	jalr	1064(ra) # 4ce <open>
  ae:	06054a63          	bltz	a0,122 <find+0xac>
  b2:	84aa                	mv	s1,a0
        fprintf(2, "ls: cannot open %s\n", path);
        return;
    }

    if(fstat(fd, &st) < 0){
  b4:	d8840593          	addi	a1,s0,-632
  b8:	00000097          	auipc	ra,0x0
  bc:	42e080e7          	jalr	1070(ra) # 4e6 <fstat>
  c0:	06054c63          	bltz	a0,138 <find+0xc2>
        fprintf(2, "ls: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch(st.type){
  c4:	d9041783          	lh	a5,-624(s0)
  c8:	0007869b          	sext.w	a3,a5
  cc:	4705                	li	a4,1
  ce:	08e68f63          	beq	a3,a4,16c <find+0xf6>
  d2:	4709                	li	a4,2
  d4:	00e69d63          	bne	a3,a4,ee <find+0x78>
    case T_FILE:
        if(strcmp(fmtname(path),filename) == 0){
  d8:	854a                	mv	a0,s2
  da:	00000097          	auipc	ra,0x0
  de:	f26080e7          	jalr	-218(ra) # 0 <fmtname>
  e2:	85ce                	mv	a1,s3
  e4:	00000097          	auipc	ra,0x0
  e8:	1d8080e7          	jalr	472(ra) # 2bc <strcmp>
  ec:	c535                	beqz	a0,158 <find+0xe2>
            //printf("%s\n", buf);
            find(buf, filename);
        }
        break;
    }
    close(fd);
  ee:	8526                	mv	a0,s1
  f0:	00000097          	auipc	ra,0x0
  f4:	3c6080e7          	jalr	966(ra) # 4b6 <close>
    return;
}
  f8:	27813083          	ld	ra,632(sp)
  fc:	27013403          	ld	s0,624(sp)
 100:	26813483          	ld	s1,616(sp)
 104:	26013903          	ld	s2,608(sp)
 108:	25813983          	ld	s3,600(sp)
 10c:	25013a03          	ld	s4,592(sp)
 110:	24813a83          	ld	s5,584(sp)
 114:	24013b03          	ld	s6,576(sp)
 118:	23813b83          	ld	s7,568(sp)
 11c:	28010113          	addi	sp,sp,640
 120:	8082                	ret
        fprintf(2, "ls: cannot open %s\n", path);
 122:	864a                	mv	a2,s2
 124:	00001597          	auipc	a1,0x1
 128:	8ac58593          	addi	a1,a1,-1876 # 9d0 <malloc+0xec>
 12c:	4509                	li	a0,2
 12e:	00000097          	auipc	ra,0x0
 132:	6ca080e7          	jalr	1738(ra) # 7f8 <fprintf>
        return;
 136:	b7c9                	j	f8 <find+0x82>
        fprintf(2, "ls: cannot stat %s\n", path);
 138:	864a                	mv	a2,s2
 13a:	00001597          	auipc	a1,0x1
 13e:	8ae58593          	addi	a1,a1,-1874 # 9e8 <malloc+0x104>
 142:	4509                	li	a0,2
 144:	00000097          	auipc	ra,0x0
 148:	6b4080e7          	jalr	1716(ra) # 7f8 <fprintf>
        close(fd);
 14c:	8526                	mv	a0,s1
 14e:	00000097          	auipc	ra,0x0
 152:	368080e7          	jalr	872(ra) # 4b6 <close>
        return;
 156:	b74d                	j	f8 <find+0x82>
            printf("%s\n",path);
 158:	85ca                	mv	a1,s2
 15a:	00001517          	auipc	a0,0x1
 15e:	88650513          	addi	a0,a0,-1914 # 9e0 <malloc+0xfc>
 162:	00000097          	auipc	ra,0x0
 166:	6c4080e7          	jalr	1732(ra) # 826 <printf>
 16a:	b751                	j	ee <find+0x78>
        if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 16c:	854a                	mv	a0,s2
 16e:	00000097          	auipc	ra,0x0
 172:	17a080e7          	jalr	378(ra) # 2e8 <strlen>
 176:	2541                	addiw	a0,a0,16
 178:	20000793          	li	a5,512
 17c:	00a7fb63          	bgeu	a5,a0,192 <find+0x11c>
            printf("find: path too long\n");
 180:	00001517          	auipc	a0,0x1
 184:	88050513          	addi	a0,a0,-1920 # a00 <malloc+0x11c>
 188:	00000097          	auipc	ra,0x0
 18c:	69e080e7          	jalr	1694(ra) # 826 <printf>
            break;
 190:	bfb9                	j	ee <find+0x78>
        strcpy(buf, path);
 192:	85ca                	mv	a1,s2
 194:	db040513          	addi	a0,s0,-592
 198:	00000097          	auipc	ra,0x0
 19c:	108080e7          	jalr	264(ra) # 2a0 <strcpy>
        p = buf+strlen(buf);
 1a0:	db040513          	addi	a0,s0,-592
 1a4:	00000097          	auipc	ra,0x0
 1a8:	144080e7          	jalr	324(ra) # 2e8 <strlen>
 1ac:	02051913          	slli	s2,a0,0x20
 1b0:	02095913          	srli	s2,s2,0x20
 1b4:	db040793          	addi	a5,s0,-592
 1b8:	993e                	add	s2,s2,a5
        *p++ = '/';
 1ba:	00190b93          	addi	s7,s2,1
 1be:	02f00793          	li	a5,47
 1c2:	00f90023          	sb	a5,0(s2)
            if(de.inum == 0||de.inum == 1||strcmp(de.name,".") == 0||strcmp(de.name,"..") == 0)
 1c6:	4a05                	li	s4,1
 1c8:	00001a97          	auipc	s5,0x1
 1cc:	850a8a93          	addi	s5,s5,-1968 # a18 <malloc+0x134>
 1d0:	00001b17          	auipc	s6,0x1
 1d4:	850b0b13          	addi	s6,s6,-1968 # a20 <malloc+0x13c>
        while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1d8:	4641                	li	a2,16
 1da:	da040593          	addi	a1,s0,-608
 1de:	8526                	mv	a0,s1
 1e0:	00000097          	auipc	ra,0x0
 1e4:	2c6080e7          	jalr	710(ra) # 4a6 <read>
 1e8:	47c1                	li	a5,16
 1ea:	f0f512e3          	bne	a0,a5,ee <find+0x78>
            if(de.inum == 0||de.inum == 1||strcmp(de.name,".") == 0||strcmp(de.name,"..") == 0)
 1ee:	da045783          	lhu	a5,-608(s0)
 1f2:	fefa73e3          	bgeu	s4,a5,1d8 <find+0x162>
 1f6:	85d6                	mv	a1,s5
 1f8:	da240513          	addi	a0,s0,-606
 1fc:	00000097          	auipc	ra,0x0
 200:	0c0080e7          	jalr	192(ra) # 2bc <strcmp>
 204:	d971                	beqz	a0,1d8 <find+0x162>
 206:	85da                	mv	a1,s6
 208:	da240513          	addi	a0,s0,-606
 20c:	00000097          	auipc	ra,0x0
 210:	0b0080e7          	jalr	176(ra) # 2bc <strcmp>
 214:	d171                	beqz	a0,1d8 <find+0x162>
            memmove(p, de.name, sizeof(de.name));
 216:	4639                	li	a2,14
 218:	da240593          	addi	a1,s0,-606
 21c:	855e                	mv	a0,s7
 21e:	00000097          	auipc	ra,0x0
 222:	23e080e7          	jalr	574(ra) # 45c <memmove>
            p[sizeof(de.name)] = 0;     //修饰符
 226:	000907a3          	sb	zero,15(s2)
            if(stat(buf, &st) < 0){
 22a:	d8840593          	addi	a1,s0,-632
 22e:	db040513          	addi	a0,s0,-592
 232:	00000097          	auipc	ra,0x0
 236:	19a080e7          	jalr	410(ra) # 3cc <stat>
 23a:	00054a63          	bltz	a0,24e <find+0x1d8>
            find(buf, filename);
 23e:	85ce                	mv	a1,s3
 240:	db040513          	addi	a0,s0,-592
 244:	00000097          	auipc	ra,0x0
 248:	e32080e7          	jalr	-462(ra) # 76 <find>
 24c:	b771                	j	1d8 <find+0x162>
                printf("find: cannot stat %s\n", buf);
 24e:	db040593          	addi	a1,s0,-592
 252:	00000517          	auipc	a0,0x0
 256:	7d650513          	addi	a0,a0,2006 # a28 <malloc+0x144>
 25a:	00000097          	auipc	ra,0x0
 25e:	5cc080e7          	jalr	1484(ra) # 826 <printf>
                continue;
 262:	bf9d                	j	1d8 <find+0x162>

0000000000000264 <main>:

int 
main(int argc, char *argv[])
{
 264:	1141                	addi	sp,sp,-16
 266:	e406                	sd	ra,8(sp)
 268:	e022                	sd	s0,0(sp)
 26a:	0800                	addi	s0,sp,16
    if(argc < 3){
 26c:	4709                	li	a4,2
 26e:	00a74e63          	blt	a4,a0,28a <main+0x26>
        printf("Usage: find <path> <filename>\n");
 272:	00000517          	auipc	a0,0x0
 276:	7ce50513          	addi	a0,a0,1998 # a40 <malloc+0x15c>
 27a:	00000097          	auipc	ra,0x0
 27e:	5ac080e7          	jalr	1452(ra) # 826 <printf>
        exit();
 282:	00000097          	auipc	ra,0x0
 286:	20c080e7          	jalr	524(ra) # 48e <exit>
 28a:	87ae                	mv	a5,a1
    }
    find(argv[1], argv[2]);
 28c:	698c                	ld	a1,16(a1)
 28e:	6788                	ld	a0,8(a5)
 290:	00000097          	auipc	ra,0x0
 294:	de6080e7          	jalr	-538(ra) # 76 <find>
    exit();
 298:	00000097          	auipc	ra,0x0
 29c:	1f6080e7          	jalr	502(ra) # 48e <exit>

00000000000002a0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e422                	sd	s0,8(sp)
 2a4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a6:	87aa                	mv	a5,a0
 2a8:	0585                	addi	a1,a1,1
 2aa:	0785                	addi	a5,a5,1
 2ac:	fff5c703          	lbu	a4,-1(a1)
 2b0:	fee78fa3          	sb	a4,-1(a5)
 2b4:	fb75                	bnez	a4,2a8 <strcpy+0x8>
    ;
  return os;
}
 2b6:	6422                	ld	s0,8(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret

00000000000002bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e422                	sd	s0,8(sp)
 2c0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2c2:	00054783          	lbu	a5,0(a0)
 2c6:	cb91                	beqz	a5,2da <strcmp+0x1e>
 2c8:	0005c703          	lbu	a4,0(a1)
 2cc:	00f71763          	bne	a4,a5,2da <strcmp+0x1e>
    p++, q++;
 2d0:	0505                	addi	a0,a0,1
 2d2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2d4:	00054783          	lbu	a5,0(a0)
 2d8:	fbe5                	bnez	a5,2c8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2da:	0005c503          	lbu	a0,0(a1)
}
 2de:	40a7853b          	subw	a0,a5,a0
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <strlen>:

uint
strlen(const char *s)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e422                	sd	s0,8(sp)
 2ec:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ee:	00054783          	lbu	a5,0(a0)
 2f2:	cf91                	beqz	a5,30e <strlen+0x26>
 2f4:	0505                	addi	a0,a0,1
 2f6:	87aa                	mv	a5,a0
 2f8:	4685                	li	a3,1
 2fa:	9e89                	subw	a3,a3,a0
 2fc:	00f6853b          	addw	a0,a3,a5
 300:	0785                	addi	a5,a5,1
 302:	fff7c703          	lbu	a4,-1(a5)
 306:	fb7d                	bnez	a4,2fc <strlen+0x14>
    ;
  return n;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
  for(n = 0; s[n]; n++)
 30e:	4501                	li	a0,0
 310:	bfe5                	j	308 <strlen+0x20>

0000000000000312 <memset>:

void*
memset(void *dst, int c, uint n)
{
 312:	1141                	addi	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 318:	ca19                	beqz	a2,32e <memset+0x1c>
 31a:	87aa                	mv	a5,a0
 31c:	1602                	slli	a2,a2,0x20
 31e:	9201                	srli	a2,a2,0x20
 320:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 324:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 328:	0785                	addi	a5,a5,1
 32a:	fee79de3          	bne	a5,a4,324 <memset+0x12>
  }
  return dst;
}
 32e:	6422                	ld	s0,8(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret

0000000000000334 <strchr>:

char*
strchr(const char *s, char c)
{
 334:	1141                	addi	sp,sp,-16
 336:	e422                	sd	s0,8(sp)
 338:	0800                	addi	s0,sp,16
  for(; *s; s++)
 33a:	00054783          	lbu	a5,0(a0)
 33e:	cb99                	beqz	a5,354 <strchr+0x20>
    if(*s == c)
 340:	00f58763          	beq	a1,a5,34e <strchr+0x1a>
  for(; *s; s++)
 344:	0505                	addi	a0,a0,1
 346:	00054783          	lbu	a5,0(a0)
 34a:	fbfd                	bnez	a5,340 <strchr+0xc>
      return (char*)s;
  return 0;
 34c:	4501                	li	a0,0
}
 34e:	6422                	ld	s0,8(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret
  return 0;
 354:	4501                	li	a0,0
 356:	bfe5                	j	34e <strchr+0x1a>

0000000000000358 <gets>:

char*
gets(char *buf, int max)
{
 358:	711d                	addi	sp,sp,-96
 35a:	ec86                	sd	ra,88(sp)
 35c:	e8a2                	sd	s0,80(sp)
 35e:	e4a6                	sd	s1,72(sp)
 360:	e0ca                	sd	s2,64(sp)
 362:	fc4e                	sd	s3,56(sp)
 364:	f852                	sd	s4,48(sp)
 366:	f456                	sd	s5,40(sp)
 368:	f05a                	sd	s6,32(sp)
 36a:	ec5e                	sd	s7,24(sp)
 36c:	1080                	addi	s0,sp,96
 36e:	8baa                	mv	s7,a0
 370:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 372:	892a                	mv	s2,a0
 374:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 376:	4aa9                	li	s5,10
 378:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 37a:	89a6                	mv	s3,s1
 37c:	2485                	addiw	s1,s1,1
 37e:	0344d863          	bge	s1,s4,3ae <gets+0x56>
    cc = read(0, &c, 1);
 382:	4605                	li	a2,1
 384:	faf40593          	addi	a1,s0,-81
 388:	4501                	li	a0,0
 38a:	00000097          	auipc	ra,0x0
 38e:	11c080e7          	jalr	284(ra) # 4a6 <read>
    if(cc < 1)
 392:	00a05e63          	blez	a0,3ae <gets+0x56>
    buf[i++] = c;
 396:	faf44783          	lbu	a5,-81(s0)
 39a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 39e:	01578763          	beq	a5,s5,3ac <gets+0x54>
 3a2:	0905                	addi	s2,s2,1
 3a4:	fd679be3          	bne	a5,s6,37a <gets+0x22>
  for(i=0; i+1 < max; ){
 3a8:	89a6                	mv	s3,s1
 3aa:	a011                	j	3ae <gets+0x56>
 3ac:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3ae:	99de                	add	s3,s3,s7
 3b0:	00098023          	sb	zero,0(s3)
  return buf;
}
 3b4:	855e                	mv	a0,s7
 3b6:	60e6                	ld	ra,88(sp)
 3b8:	6446                	ld	s0,80(sp)
 3ba:	64a6                	ld	s1,72(sp)
 3bc:	6906                	ld	s2,64(sp)
 3be:	79e2                	ld	s3,56(sp)
 3c0:	7a42                	ld	s4,48(sp)
 3c2:	7aa2                	ld	s5,40(sp)
 3c4:	7b02                	ld	s6,32(sp)
 3c6:	6be2                	ld	s7,24(sp)
 3c8:	6125                	addi	sp,sp,96
 3ca:	8082                	ret

00000000000003cc <stat>:

int
stat(const char *n, struct stat *st)
{
 3cc:	1101                	addi	sp,sp,-32
 3ce:	ec06                	sd	ra,24(sp)
 3d0:	e822                	sd	s0,16(sp)
 3d2:	e426                	sd	s1,8(sp)
 3d4:	e04a                	sd	s2,0(sp)
 3d6:	1000                	addi	s0,sp,32
 3d8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3da:	4581                	li	a1,0
 3dc:	00000097          	auipc	ra,0x0
 3e0:	0f2080e7          	jalr	242(ra) # 4ce <open>
  if(fd < 0)
 3e4:	02054563          	bltz	a0,40e <stat+0x42>
 3e8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3ea:	85ca                	mv	a1,s2
 3ec:	00000097          	auipc	ra,0x0
 3f0:	0fa080e7          	jalr	250(ra) # 4e6 <fstat>
 3f4:	892a                	mv	s2,a0
  close(fd);
 3f6:	8526                	mv	a0,s1
 3f8:	00000097          	auipc	ra,0x0
 3fc:	0be080e7          	jalr	190(ra) # 4b6 <close>
  return r;
}
 400:	854a                	mv	a0,s2
 402:	60e2                	ld	ra,24(sp)
 404:	6442                	ld	s0,16(sp)
 406:	64a2                	ld	s1,8(sp)
 408:	6902                	ld	s2,0(sp)
 40a:	6105                	addi	sp,sp,32
 40c:	8082                	ret
    return -1;
 40e:	597d                	li	s2,-1
 410:	bfc5                	j	400 <stat+0x34>

0000000000000412 <atoi>:

int
atoi(const char *s)
{
 412:	1141                	addi	sp,sp,-16
 414:	e422                	sd	s0,8(sp)
 416:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 418:	00054603          	lbu	a2,0(a0)
 41c:	fd06079b          	addiw	a5,a2,-48
 420:	0ff7f793          	andi	a5,a5,255
 424:	4725                	li	a4,9
 426:	02f76963          	bltu	a4,a5,458 <atoi+0x46>
 42a:	86aa                	mv	a3,a0
  n = 0;
 42c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 42e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 430:	0685                	addi	a3,a3,1
 432:	0025179b          	slliw	a5,a0,0x2
 436:	9fa9                	addw	a5,a5,a0
 438:	0017979b          	slliw	a5,a5,0x1
 43c:	9fb1                	addw	a5,a5,a2
 43e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 442:	0006c603          	lbu	a2,0(a3)
 446:	fd06071b          	addiw	a4,a2,-48
 44a:	0ff77713          	andi	a4,a4,255
 44e:	fee5f1e3          	bgeu	a1,a4,430 <atoi+0x1e>
  return n;
}
 452:	6422                	ld	s0,8(sp)
 454:	0141                	addi	sp,sp,16
 456:	8082                	ret
  n = 0;
 458:	4501                	li	a0,0
 45a:	bfe5                	j	452 <atoi+0x40>

000000000000045c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 45c:	1141                	addi	sp,sp,-16
 45e:	e422                	sd	s0,8(sp)
 460:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 462:	00c05f63          	blez	a2,480 <memmove+0x24>
 466:	1602                	slli	a2,a2,0x20
 468:	9201                	srli	a2,a2,0x20
 46a:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 46e:	87aa                	mv	a5,a0
    *dst++ = *src++;
 470:	0585                	addi	a1,a1,1
 472:	0785                	addi	a5,a5,1
 474:	fff5c703          	lbu	a4,-1(a1)
 478:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 47c:	fed79ae3          	bne	a5,a3,470 <memmove+0x14>
  return vdst;
}
 480:	6422                	ld	s0,8(sp)
 482:	0141                	addi	sp,sp,16
 484:	8082                	ret

0000000000000486 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 486:	4885                	li	a7,1
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <exit>:
.global exit
exit:
 li a7, SYS_exit
 48e:	4889                	li	a7,2
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <wait>:
.global wait
wait:
 li a7, SYS_wait
 496:	488d                	li	a7,3
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 49e:	4891                	li	a7,4
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <read>:
.global read
read:
 li a7, SYS_read
 4a6:	4895                	li	a7,5
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <write>:
.global write
write:
 li a7, SYS_write
 4ae:	48c1                	li	a7,16
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <close>:
.global close
close:
 li a7, SYS_close
 4b6:	48d5                	li	a7,21
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <kill>:
.global kill
kill:
 li a7, SYS_kill
 4be:	4899                	li	a7,6
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4c6:	489d                	li	a7,7
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <open>:
.global open
open:
 li a7, SYS_open
 4ce:	48bd                	li	a7,15
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4d6:	48c5                	li	a7,17
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4de:	48c9                	li	a7,18
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4e6:	48a1                	li	a7,8
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <link>:
.global link
link:
 li a7, SYS_link
 4ee:	48cd                	li	a7,19
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4f6:	48d1                	li	a7,20
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4fe:	48a5                	li	a7,9
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <dup>:
.global dup
dup:
 li a7, SYS_dup
 506:	48a9                	li	a7,10
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 50e:	48ad                	li	a7,11
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 516:	48b1                	li	a7,12
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 51e:	48b5                	li	a7,13
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 526:	48b9                	li	a7,14
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 52e:	48d9                	li	a7,22
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <crash>:
.global crash
crash:
 li a7, SYS_crash
 536:	48dd                	li	a7,23
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <mount>:
.global mount
mount:
 li a7, SYS_mount
 53e:	48e1                	li	a7,24
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <umount>:
.global umount
umount:
 li a7, SYS_umount
 546:	48e5                	li	a7,25
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 54e:	1101                	addi	sp,sp,-32
 550:	ec06                	sd	ra,24(sp)
 552:	e822                	sd	s0,16(sp)
 554:	1000                	addi	s0,sp,32
 556:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 55a:	4605                	li	a2,1
 55c:	fef40593          	addi	a1,s0,-17
 560:	00000097          	auipc	ra,0x0
 564:	f4e080e7          	jalr	-178(ra) # 4ae <write>
}
 568:	60e2                	ld	ra,24(sp)
 56a:	6442                	ld	s0,16(sp)
 56c:	6105                	addi	sp,sp,32
 56e:	8082                	ret

0000000000000570 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 570:	7139                	addi	sp,sp,-64
 572:	fc06                	sd	ra,56(sp)
 574:	f822                	sd	s0,48(sp)
 576:	f426                	sd	s1,40(sp)
 578:	f04a                	sd	s2,32(sp)
 57a:	ec4e                	sd	s3,24(sp)
 57c:	0080                	addi	s0,sp,64
 57e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 580:	c299                	beqz	a3,586 <printint+0x16>
 582:	0805c863          	bltz	a1,612 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 586:	2581                	sext.w	a1,a1
  neg = 0;
 588:	4881                	li	a7,0
 58a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 58e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 590:	2601                	sext.w	a2,a2
 592:	00000517          	auipc	a0,0x0
 596:	4d650513          	addi	a0,a0,1238 # a68 <digits>
 59a:	883a                	mv	a6,a4
 59c:	2705                	addiw	a4,a4,1
 59e:	02c5f7bb          	remuw	a5,a1,a2
 5a2:	1782                	slli	a5,a5,0x20
 5a4:	9381                	srli	a5,a5,0x20
 5a6:	97aa                	add	a5,a5,a0
 5a8:	0007c783          	lbu	a5,0(a5)
 5ac:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5b0:	0005879b          	sext.w	a5,a1
 5b4:	02c5d5bb          	divuw	a1,a1,a2
 5b8:	0685                	addi	a3,a3,1
 5ba:	fec7f0e3          	bgeu	a5,a2,59a <printint+0x2a>
  if(neg)
 5be:	00088b63          	beqz	a7,5d4 <printint+0x64>
    buf[i++] = '-';
 5c2:	fd040793          	addi	a5,s0,-48
 5c6:	973e                	add	a4,a4,a5
 5c8:	02d00793          	li	a5,45
 5cc:	fef70823          	sb	a5,-16(a4)
 5d0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5d4:	02e05863          	blez	a4,604 <printint+0x94>
 5d8:	fc040793          	addi	a5,s0,-64
 5dc:	00e78933          	add	s2,a5,a4
 5e0:	fff78993          	addi	s3,a5,-1
 5e4:	99ba                	add	s3,s3,a4
 5e6:	377d                	addiw	a4,a4,-1
 5e8:	1702                	slli	a4,a4,0x20
 5ea:	9301                	srli	a4,a4,0x20
 5ec:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5f0:	fff94583          	lbu	a1,-1(s2)
 5f4:	8526                	mv	a0,s1
 5f6:	00000097          	auipc	ra,0x0
 5fa:	f58080e7          	jalr	-168(ra) # 54e <putc>
  while(--i >= 0)
 5fe:	197d                	addi	s2,s2,-1
 600:	ff3918e3          	bne	s2,s3,5f0 <printint+0x80>
}
 604:	70e2                	ld	ra,56(sp)
 606:	7442                	ld	s0,48(sp)
 608:	74a2                	ld	s1,40(sp)
 60a:	7902                	ld	s2,32(sp)
 60c:	69e2                	ld	s3,24(sp)
 60e:	6121                	addi	sp,sp,64
 610:	8082                	ret
    x = -xx;
 612:	40b005bb          	negw	a1,a1
    neg = 1;
 616:	4885                	li	a7,1
    x = -xx;
 618:	bf8d                	j	58a <printint+0x1a>

000000000000061a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 61a:	7119                	addi	sp,sp,-128
 61c:	fc86                	sd	ra,120(sp)
 61e:	f8a2                	sd	s0,112(sp)
 620:	f4a6                	sd	s1,104(sp)
 622:	f0ca                	sd	s2,96(sp)
 624:	ecce                	sd	s3,88(sp)
 626:	e8d2                	sd	s4,80(sp)
 628:	e4d6                	sd	s5,72(sp)
 62a:	e0da                	sd	s6,64(sp)
 62c:	fc5e                	sd	s7,56(sp)
 62e:	f862                	sd	s8,48(sp)
 630:	f466                	sd	s9,40(sp)
 632:	f06a                	sd	s10,32(sp)
 634:	ec6e                	sd	s11,24(sp)
 636:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 638:	0005c903          	lbu	s2,0(a1)
 63c:	18090f63          	beqz	s2,7da <vprintf+0x1c0>
 640:	8aaa                	mv	s5,a0
 642:	8b32                	mv	s6,a2
 644:	00158493          	addi	s1,a1,1
  state = 0;
 648:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 64a:	02500a13          	li	s4,37
      if(c == 'd'){
 64e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 652:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 656:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 65a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 65e:	00000b97          	auipc	s7,0x0
 662:	40ab8b93          	addi	s7,s7,1034 # a68 <digits>
 666:	a839                	j	684 <vprintf+0x6a>
        putc(fd, c);
 668:	85ca                	mv	a1,s2
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	ee2080e7          	jalr	-286(ra) # 54e <putc>
 674:	a019                	j	67a <vprintf+0x60>
    } else if(state == '%'){
 676:	01498f63          	beq	s3,s4,694 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 67a:	0485                	addi	s1,s1,1
 67c:	fff4c903          	lbu	s2,-1(s1)
 680:	14090d63          	beqz	s2,7da <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 684:	0009079b          	sext.w	a5,s2
    if(state == 0){
 688:	fe0997e3          	bnez	s3,676 <vprintf+0x5c>
      if(c == '%'){
 68c:	fd479ee3          	bne	a5,s4,668 <vprintf+0x4e>
        state = '%';
 690:	89be                	mv	s3,a5
 692:	b7e5                	j	67a <vprintf+0x60>
      if(c == 'd'){
 694:	05878063          	beq	a5,s8,6d4 <vprintf+0xba>
      } else if(c == 'l') {
 698:	05978c63          	beq	a5,s9,6f0 <vprintf+0xd6>
      } else if(c == 'x') {
 69c:	07a78863          	beq	a5,s10,70c <vprintf+0xf2>
      } else if(c == 'p') {
 6a0:	09b78463          	beq	a5,s11,728 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6a4:	07300713          	li	a4,115
 6a8:	0ce78663          	beq	a5,a4,774 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ac:	06300713          	li	a4,99
 6b0:	0ee78e63          	beq	a5,a4,7ac <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6b4:	11478863          	beq	a5,s4,7c4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6b8:	85d2                	mv	a1,s4
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	e92080e7          	jalr	-366(ra) # 54e <putc>
        putc(fd, c);
 6c4:	85ca                	mv	a1,s2
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	e86080e7          	jalr	-378(ra) # 54e <putc>
      }
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b765                	j	67a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6d4:	008b0913          	addi	s2,s6,8
 6d8:	4685                	li	a3,1
 6da:	4629                	li	a2,10
 6dc:	000b2583          	lw	a1,0(s6)
 6e0:	8556                	mv	a0,s5
 6e2:	00000097          	auipc	ra,0x0
 6e6:	e8e080e7          	jalr	-370(ra) # 570 <printint>
 6ea:	8b4a                	mv	s6,s2
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	b771                	j	67a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f0:	008b0913          	addi	s2,s6,8
 6f4:	4681                	li	a3,0
 6f6:	4629                	li	a2,10
 6f8:	000b2583          	lw	a1,0(s6)
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	e72080e7          	jalr	-398(ra) # 570 <printint>
 706:	8b4a                	mv	s6,s2
      state = 0;
 708:	4981                	li	s3,0
 70a:	bf85                	j	67a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 70c:	008b0913          	addi	s2,s6,8
 710:	4681                	li	a3,0
 712:	4641                	li	a2,16
 714:	000b2583          	lw	a1,0(s6)
 718:	8556                	mv	a0,s5
 71a:	00000097          	auipc	ra,0x0
 71e:	e56080e7          	jalr	-426(ra) # 570 <printint>
 722:	8b4a                	mv	s6,s2
      state = 0;
 724:	4981                	li	s3,0
 726:	bf91                	j	67a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 728:	008b0793          	addi	a5,s6,8
 72c:	f8f43423          	sd	a5,-120(s0)
 730:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 734:	03000593          	li	a1,48
 738:	8556                	mv	a0,s5
 73a:	00000097          	auipc	ra,0x0
 73e:	e14080e7          	jalr	-492(ra) # 54e <putc>
  putc(fd, 'x');
 742:	85ea                	mv	a1,s10
 744:	8556                	mv	a0,s5
 746:	00000097          	auipc	ra,0x0
 74a:	e08080e7          	jalr	-504(ra) # 54e <putc>
 74e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 750:	03c9d793          	srli	a5,s3,0x3c
 754:	97de                	add	a5,a5,s7
 756:	0007c583          	lbu	a1,0(a5)
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	df2080e7          	jalr	-526(ra) # 54e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 764:	0992                	slli	s3,s3,0x4
 766:	397d                	addiw	s2,s2,-1
 768:	fe0914e3          	bnez	s2,750 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 76c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 770:	4981                	li	s3,0
 772:	b721                	j	67a <vprintf+0x60>
        s = va_arg(ap, char*);
 774:	008b0993          	addi	s3,s6,8
 778:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 77c:	02090163          	beqz	s2,79e <vprintf+0x184>
        while(*s != 0){
 780:	00094583          	lbu	a1,0(s2)
 784:	c9a1                	beqz	a1,7d4 <vprintf+0x1ba>
          putc(fd, *s);
 786:	8556                	mv	a0,s5
 788:	00000097          	auipc	ra,0x0
 78c:	dc6080e7          	jalr	-570(ra) # 54e <putc>
          s++;
 790:	0905                	addi	s2,s2,1
        while(*s != 0){
 792:	00094583          	lbu	a1,0(s2)
 796:	f9e5                	bnez	a1,786 <vprintf+0x16c>
        s = va_arg(ap, char*);
 798:	8b4e                	mv	s6,s3
      state = 0;
 79a:	4981                	li	s3,0
 79c:	bdf9                	j	67a <vprintf+0x60>
          s = "(null)";
 79e:	00000917          	auipc	s2,0x0
 7a2:	2c290913          	addi	s2,s2,706 # a60 <malloc+0x17c>
        while(*s != 0){
 7a6:	02800593          	li	a1,40
 7aa:	bff1                	j	786 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7ac:	008b0913          	addi	s2,s6,8
 7b0:	000b4583          	lbu	a1,0(s6)
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	d98080e7          	jalr	-616(ra) # 54e <putc>
 7be:	8b4a                	mv	s6,s2
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	bd65                	j	67a <vprintf+0x60>
        putc(fd, c);
 7c4:	85d2                	mv	a1,s4
 7c6:	8556                	mv	a0,s5
 7c8:	00000097          	auipc	ra,0x0
 7cc:	d86080e7          	jalr	-634(ra) # 54e <putc>
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	b565                	j	67a <vprintf+0x60>
        s = va_arg(ap, char*);
 7d4:	8b4e                	mv	s6,s3
      state = 0;
 7d6:	4981                	li	s3,0
 7d8:	b54d                	j	67a <vprintf+0x60>
    }
  }
}
 7da:	70e6                	ld	ra,120(sp)
 7dc:	7446                	ld	s0,112(sp)
 7de:	74a6                	ld	s1,104(sp)
 7e0:	7906                	ld	s2,96(sp)
 7e2:	69e6                	ld	s3,88(sp)
 7e4:	6a46                	ld	s4,80(sp)
 7e6:	6aa6                	ld	s5,72(sp)
 7e8:	6b06                	ld	s6,64(sp)
 7ea:	7be2                	ld	s7,56(sp)
 7ec:	7c42                	ld	s8,48(sp)
 7ee:	7ca2                	ld	s9,40(sp)
 7f0:	7d02                	ld	s10,32(sp)
 7f2:	6de2                	ld	s11,24(sp)
 7f4:	6109                	addi	sp,sp,128
 7f6:	8082                	ret

00000000000007f8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7f8:	715d                	addi	sp,sp,-80
 7fa:	ec06                	sd	ra,24(sp)
 7fc:	e822                	sd	s0,16(sp)
 7fe:	1000                	addi	s0,sp,32
 800:	e010                	sd	a2,0(s0)
 802:	e414                	sd	a3,8(s0)
 804:	e818                	sd	a4,16(s0)
 806:	ec1c                	sd	a5,24(s0)
 808:	03043023          	sd	a6,32(s0)
 80c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 810:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 814:	8622                	mv	a2,s0
 816:	00000097          	auipc	ra,0x0
 81a:	e04080e7          	jalr	-508(ra) # 61a <vprintf>
}
 81e:	60e2                	ld	ra,24(sp)
 820:	6442                	ld	s0,16(sp)
 822:	6161                	addi	sp,sp,80
 824:	8082                	ret

0000000000000826 <printf>:

void
printf(const char *fmt, ...)
{
 826:	711d                	addi	sp,sp,-96
 828:	ec06                	sd	ra,24(sp)
 82a:	e822                	sd	s0,16(sp)
 82c:	1000                	addi	s0,sp,32
 82e:	e40c                	sd	a1,8(s0)
 830:	e810                	sd	a2,16(s0)
 832:	ec14                	sd	a3,24(s0)
 834:	f018                	sd	a4,32(s0)
 836:	f41c                	sd	a5,40(s0)
 838:	03043823          	sd	a6,48(s0)
 83c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 840:	00840613          	addi	a2,s0,8
 844:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 848:	85aa                	mv	a1,a0
 84a:	4505                	li	a0,1
 84c:	00000097          	auipc	ra,0x0
 850:	dce080e7          	jalr	-562(ra) # 61a <vprintf>
}
 854:	60e2                	ld	ra,24(sp)
 856:	6442                	ld	s0,16(sp)
 858:	6125                	addi	sp,sp,96
 85a:	8082                	ret

000000000000085c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 85c:	1141                	addi	sp,sp,-16
 85e:	e422                	sd	s0,8(sp)
 860:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 862:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 866:	00000797          	auipc	a5,0x0
 86a:	21a7b783          	ld	a5,538(a5) # a80 <freep>
 86e:	a805                	j	89e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 870:	4618                	lw	a4,8(a2)
 872:	9db9                	addw	a1,a1,a4
 874:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 878:	6398                	ld	a4,0(a5)
 87a:	6318                	ld	a4,0(a4)
 87c:	fee53823          	sd	a4,-16(a0)
 880:	a091                	j	8c4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 882:	ff852703          	lw	a4,-8(a0)
 886:	9e39                	addw	a2,a2,a4
 888:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 88a:	ff053703          	ld	a4,-16(a0)
 88e:	e398                	sd	a4,0(a5)
 890:	a099                	j	8d6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 892:	6398                	ld	a4,0(a5)
 894:	00e7e463          	bltu	a5,a4,89c <free+0x40>
 898:	00e6ea63          	bltu	a3,a4,8ac <free+0x50>
{
 89c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89e:	fed7fae3          	bgeu	a5,a3,892 <free+0x36>
 8a2:	6398                	ld	a4,0(a5)
 8a4:	00e6e463          	bltu	a3,a4,8ac <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a8:	fee7eae3          	bltu	a5,a4,89c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8ac:	ff852583          	lw	a1,-8(a0)
 8b0:	6390                	ld	a2,0(a5)
 8b2:	02059813          	slli	a6,a1,0x20
 8b6:	01c85713          	srli	a4,a6,0x1c
 8ba:	9736                	add	a4,a4,a3
 8bc:	fae60ae3          	beq	a2,a4,870 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8c0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8c4:	4790                	lw	a2,8(a5)
 8c6:	02061593          	slli	a1,a2,0x20
 8ca:	01c5d713          	srli	a4,a1,0x1c
 8ce:	973e                	add	a4,a4,a5
 8d0:	fae689e3          	beq	a3,a4,882 <free+0x26>
  } else
    p->s.ptr = bp;
 8d4:	e394                	sd	a3,0(a5)
  freep = p;
 8d6:	00000717          	auipc	a4,0x0
 8da:	1af73523          	sd	a5,426(a4) # a80 <freep>
}
 8de:	6422                	ld	s0,8(sp)
 8e0:	0141                	addi	sp,sp,16
 8e2:	8082                	ret

00000000000008e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e4:	7139                	addi	sp,sp,-64
 8e6:	fc06                	sd	ra,56(sp)
 8e8:	f822                	sd	s0,48(sp)
 8ea:	f426                	sd	s1,40(sp)
 8ec:	f04a                	sd	s2,32(sp)
 8ee:	ec4e                	sd	s3,24(sp)
 8f0:	e852                	sd	s4,16(sp)
 8f2:	e456                	sd	s5,8(sp)
 8f4:	e05a                	sd	s6,0(sp)
 8f6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f8:	02051493          	slli	s1,a0,0x20
 8fc:	9081                	srli	s1,s1,0x20
 8fe:	04bd                	addi	s1,s1,15
 900:	8091                	srli	s1,s1,0x4
 902:	0014899b          	addiw	s3,s1,1
 906:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 908:	00000517          	auipc	a0,0x0
 90c:	17853503          	ld	a0,376(a0) # a80 <freep>
 910:	c515                	beqz	a0,93c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 912:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 914:	4798                	lw	a4,8(a5)
 916:	02977f63          	bgeu	a4,s1,954 <malloc+0x70>
 91a:	8a4e                	mv	s4,s3
 91c:	0009871b          	sext.w	a4,s3
 920:	6685                	lui	a3,0x1
 922:	00d77363          	bgeu	a4,a3,928 <malloc+0x44>
 926:	6a05                	lui	s4,0x1
 928:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 92c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 930:	00000917          	auipc	s2,0x0
 934:	15090913          	addi	s2,s2,336 # a80 <freep>
  if(p == (char*)-1)
 938:	5afd                	li	s5,-1
 93a:	a895                	j	9ae <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 93c:	00000797          	auipc	a5,0x0
 940:	15c78793          	addi	a5,a5,348 # a98 <base>
 944:	00000717          	auipc	a4,0x0
 948:	12f73e23          	sd	a5,316(a4) # a80 <freep>
 94c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 94e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 952:	b7e1                	j	91a <malloc+0x36>
      if(p->s.size == nunits)
 954:	02e48c63          	beq	s1,a4,98c <malloc+0xa8>
        p->s.size -= nunits;
 958:	4137073b          	subw	a4,a4,s3
 95c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 95e:	02071693          	slli	a3,a4,0x20
 962:	01c6d713          	srli	a4,a3,0x1c
 966:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 968:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 96c:	00000717          	auipc	a4,0x0
 970:	10a73a23          	sd	a0,276(a4) # a80 <freep>
      return (void*)(p + 1);
 974:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 978:	70e2                	ld	ra,56(sp)
 97a:	7442                	ld	s0,48(sp)
 97c:	74a2                	ld	s1,40(sp)
 97e:	7902                	ld	s2,32(sp)
 980:	69e2                	ld	s3,24(sp)
 982:	6a42                	ld	s4,16(sp)
 984:	6aa2                	ld	s5,8(sp)
 986:	6b02                	ld	s6,0(sp)
 988:	6121                	addi	sp,sp,64
 98a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 98c:	6398                	ld	a4,0(a5)
 98e:	e118                	sd	a4,0(a0)
 990:	bff1                	j	96c <malloc+0x88>
  hp->s.size = nu;
 992:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 996:	0541                	addi	a0,a0,16
 998:	00000097          	auipc	ra,0x0
 99c:	ec4080e7          	jalr	-316(ra) # 85c <free>
  return freep;
 9a0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9a4:	d971                	beqz	a0,978 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a8:	4798                	lw	a4,8(a5)
 9aa:	fa9775e3          	bgeu	a4,s1,954 <malloc+0x70>
    if(p == freep)
 9ae:	00093703          	ld	a4,0(s2)
 9b2:	853e                	mv	a0,a5
 9b4:	fef719e3          	bne	a4,a5,9a6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9b8:	8552                	mv	a0,s4
 9ba:	00000097          	auipc	ra,0x0
 9be:	b5c080e7          	jalr	-1188(ra) # 516 <sbrk>
  if(p == (char*)-1)
 9c2:	fd5518e3          	bne	a0,s5,992 <malloc+0xae>
        return 0;
 9c6:	4501                	li	a0,0
 9c8:	bf45                	j	978 <malloc+0x94>
