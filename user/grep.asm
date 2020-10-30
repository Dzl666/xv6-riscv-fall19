
user/_grep：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	715d                	addi	sp,sp,-80
 11c:	e486                	sd	ra,72(sp)
 11e:	e0a2                	sd	s0,64(sp)
 120:	fc26                	sd	s1,56(sp)
 122:	f84a                	sd	s2,48(sp)
 124:	f44e                	sd	s3,40(sp)
 126:	f052                	sd	s4,32(sp)
 128:	ec56                	sd	s5,24(sp)
 12a:	e85a                	sd	s6,16(sp)
 12c:	e45e                	sd	s7,8(sp)
 12e:	0880                	addi	s0,sp,80
 130:	89aa                	mv	s3,a0
 132:	8b2e                	mv	s6,a1
  m = 0;
 134:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 136:	3ff00b93          	li	s7,1023
 13a:	00001a97          	auipc	s5,0x1
 13e:	8e6a8a93          	addi	s5,s5,-1818 # a20 <buf>
 142:	a0a1                	j	18a <grep+0x70>
      p = q+1;
 144:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 148:	45a9                	li	a1,10
 14a:	854a                	mv	a0,s2
 14c:	00000097          	auipc	ra,0x0
 150:	1de080e7          	jalr	478(ra) # 32a <strchr>
 154:	84aa                	mv	s1,a0
 156:	c905                	beqz	a0,186 <grep+0x6c>
      *q = 0;
 158:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 15c:	85ca                	mv	a1,s2
 15e:	854e                	mv	a0,s3
 160:	00000097          	auipc	ra,0x0
 164:	f6c080e7          	jalr	-148(ra) # cc <match>
 168:	dd71                	beqz	a0,144 <grep+0x2a>
        *q = '\n';
 16a:	47a9                	li	a5,10
 16c:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 170:	00148613          	addi	a2,s1,1
 174:	4126063b          	subw	a2,a2,s2
 178:	85ca                	mv	a1,s2
 17a:	4505                	li	a0,1
 17c:	00000097          	auipc	ra,0x0
 180:	328080e7          	jalr	808(ra) # 4a4 <write>
 184:	b7c1                	j	144 <grep+0x2a>
    if(m > 0){
 186:	03404563          	bgtz	s4,1b0 <grep+0x96>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18a:	414b863b          	subw	a2,s7,s4
 18e:	014a85b3          	add	a1,s5,s4
 192:	855a                	mv	a0,s6
 194:	00000097          	auipc	ra,0x0
 198:	308080e7          	jalr	776(ra) # 49c <read>
 19c:	02a05663          	blez	a0,1c8 <grep+0xae>
    m += n;
 1a0:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
 1a4:	014a87b3          	add	a5,s5,s4
 1a8:	00078023          	sb	zero,0(a5)
    p = buf;
 1ac:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 1ae:	bf69                	j	148 <grep+0x2e>
      m -= p - buf;
 1b0:	415907b3          	sub	a5,s2,s5
 1b4:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
 1b8:	8652                	mv	a2,s4
 1ba:	85ca                	mv	a1,s2
 1bc:	8556                	mv	a0,s5
 1be:	00000097          	auipc	ra,0x0
 1c2:	294080e7          	jalr	660(ra) # 452 <memmove>
 1c6:	b7d1                	j	18a <grep+0x70>
}
 1c8:	60a6                	ld	ra,72(sp)
 1ca:	6406                	ld	s0,64(sp)
 1cc:	74e2                	ld	s1,56(sp)
 1ce:	7942                	ld	s2,48(sp)
 1d0:	79a2                	ld	s3,40(sp)
 1d2:	7a02                	ld	s4,32(sp)
 1d4:	6ae2                	ld	s5,24(sp)
 1d6:	6b42                	ld	s6,16(sp)
 1d8:	6ba2                	ld	s7,8(sp)
 1da:	6161                	addi	sp,sp,80
 1dc:	8082                	ret

00000000000001de <main>:
{
 1de:	7139                	addi	sp,sp,-64
 1e0:	fc06                	sd	ra,56(sp)
 1e2:	f822                	sd	s0,48(sp)
 1e4:	f426                	sd	s1,40(sp)
 1e6:	f04a                	sd	s2,32(sp)
 1e8:	ec4e                	sd	s3,24(sp)
 1ea:	e852                	sd	s4,16(sp)
 1ec:	e456                	sd	s5,8(sp)
 1ee:	0080                	addi	s0,sp,64
  if(argc <= 1){
 1f0:	4785                	li	a5,1
 1f2:	04a7dd63          	bge	a5,a0,24c <main+0x6e>
  pattern = argv[1];
 1f6:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1fa:	4789                	li	a5,2
 1fc:	06a7d563          	bge	a5,a0,266 <main+0x88>
 200:	01058913          	addi	s2,a1,16
 204:	ffd5099b          	addiw	s3,a0,-3
 208:	02099793          	slli	a5,s3,0x20
 20c:	01d7d993          	srli	s3,a5,0x1d
 210:	05e1                	addi	a1,a1,24
 212:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 214:	4581                	li	a1,0
 216:	00093503          	ld	a0,0(s2)
 21a:	00000097          	auipc	ra,0x0
 21e:	2aa080e7          	jalr	682(ra) # 4c4 <open>
 222:	84aa                	mv	s1,a0
 224:	04054b63          	bltz	a0,27a <main+0x9c>
    grep(pattern, fd);
 228:	85aa                	mv	a1,a0
 22a:	8552                	mv	a0,s4
 22c:	00000097          	auipc	ra,0x0
 230:	eee080e7          	jalr	-274(ra) # 11a <grep>
    close(fd);
 234:	8526                	mv	a0,s1
 236:	00000097          	auipc	ra,0x0
 23a:	276080e7          	jalr	630(ra) # 4ac <close>
  for(i = 2; i < argc; i++){
 23e:	0921                	addi	s2,s2,8
 240:	fd391ae3          	bne	s2,s3,214 <main+0x36>
  exit();
 244:	00000097          	auipc	ra,0x0
 248:	240080e7          	jalr	576(ra) # 484 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 24c:	00000597          	auipc	a1,0x0
 250:	77458593          	addi	a1,a1,1908 # 9c0 <malloc+0xe6>
 254:	4509                	li	a0,2
 256:	00000097          	auipc	ra,0x0
 25a:	598080e7          	jalr	1432(ra) # 7ee <fprintf>
    exit();
 25e:	00000097          	auipc	ra,0x0
 262:	226080e7          	jalr	550(ra) # 484 <exit>
    grep(pattern, 0);
 266:	4581                	li	a1,0
 268:	8552                	mv	a0,s4
 26a:	00000097          	auipc	ra,0x0
 26e:	eb0080e7          	jalr	-336(ra) # 11a <grep>
    exit();
 272:	00000097          	auipc	ra,0x0
 276:	212080e7          	jalr	530(ra) # 484 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 27a:	00093583          	ld	a1,0(s2)
 27e:	00000517          	auipc	a0,0x0
 282:	76250513          	addi	a0,a0,1890 # 9e0 <malloc+0x106>
 286:	00000097          	auipc	ra,0x0
 28a:	596080e7          	jalr	1430(ra) # 81c <printf>
      exit();
 28e:	00000097          	auipc	ra,0x0
 292:	1f6080e7          	jalr	502(ra) # 484 <exit>

0000000000000296 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 29c:	87aa                	mv	a5,a0
 29e:	0585                	addi	a1,a1,1
 2a0:	0785                	addi	a5,a5,1
 2a2:	fff5c703          	lbu	a4,-1(a1)
 2a6:	fee78fa3          	sb	a4,-1(a5)
 2aa:	fb75                	bnez	a4,29e <strcpy+0x8>
    ;
  return os;
}
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	cb91                	beqz	a5,2d0 <strcmp+0x1e>
 2be:	0005c703          	lbu	a4,0(a1)
 2c2:	00f71763          	bne	a4,a5,2d0 <strcmp+0x1e>
    p++, q++;
 2c6:	0505                	addi	a0,a0,1
 2c8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ca:	00054783          	lbu	a5,0(a0)
 2ce:	fbe5                	bnez	a5,2be <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2d0:	0005c503          	lbu	a0,0(a1)
}
 2d4:	40a7853b          	subw	a0,a5,a0
 2d8:	6422                	ld	s0,8(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <strlen>:

uint
strlen(const char *s)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	cf91                	beqz	a5,304 <strlen+0x26>
 2ea:	0505                	addi	a0,a0,1
 2ec:	87aa                	mv	a5,a0
 2ee:	4685                	li	a3,1
 2f0:	9e89                	subw	a3,a3,a0
 2f2:	00f6853b          	addw	a0,a3,a5
 2f6:	0785                	addi	a5,a5,1
 2f8:	fff7c703          	lbu	a4,-1(a5)
 2fc:	fb7d                	bnez	a4,2f2 <strlen+0x14>
    ;
  return n;
}
 2fe:	6422                	ld	s0,8(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret
  for(n = 0; s[n]; n++)
 304:	4501                	li	a0,0
 306:	bfe5                	j	2fe <strlen+0x20>

0000000000000308 <memset>:

void*
memset(void *dst, int c, uint n)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 30e:	ca19                	beqz	a2,324 <memset+0x1c>
 310:	87aa                	mv	a5,a0
 312:	1602                	slli	a2,a2,0x20
 314:	9201                	srli	a2,a2,0x20
 316:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 31a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 31e:	0785                	addi	a5,a5,1
 320:	fee79de3          	bne	a5,a4,31a <memset+0x12>
  }
  return dst;
}
 324:	6422                	ld	s0,8(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret

000000000000032a <strchr>:

char*
strchr(const char *s, char c)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e422                	sd	s0,8(sp)
 32e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 330:	00054783          	lbu	a5,0(a0)
 334:	cb99                	beqz	a5,34a <strchr+0x20>
    if(*s == c)
 336:	00f58763          	beq	a1,a5,344 <strchr+0x1a>
  for(; *s; s++)
 33a:	0505                	addi	a0,a0,1
 33c:	00054783          	lbu	a5,0(a0)
 340:	fbfd                	bnez	a5,336 <strchr+0xc>
      return (char*)s;
  return 0;
 342:	4501                	li	a0,0
}
 344:	6422                	ld	s0,8(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret
  return 0;
 34a:	4501                	li	a0,0
 34c:	bfe5                	j	344 <strchr+0x1a>

000000000000034e <gets>:

char*
gets(char *buf, int max)
{
 34e:	711d                	addi	sp,sp,-96
 350:	ec86                	sd	ra,88(sp)
 352:	e8a2                	sd	s0,80(sp)
 354:	e4a6                	sd	s1,72(sp)
 356:	e0ca                	sd	s2,64(sp)
 358:	fc4e                	sd	s3,56(sp)
 35a:	f852                	sd	s4,48(sp)
 35c:	f456                	sd	s5,40(sp)
 35e:	f05a                	sd	s6,32(sp)
 360:	ec5e                	sd	s7,24(sp)
 362:	1080                	addi	s0,sp,96
 364:	8baa                	mv	s7,a0
 366:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 368:	892a                	mv	s2,a0
 36a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 36c:	4aa9                	li	s5,10
 36e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 370:	89a6                	mv	s3,s1
 372:	2485                	addiw	s1,s1,1
 374:	0344d863          	bge	s1,s4,3a4 <gets+0x56>
    cc = read(0, &c, 1);
 378:	4605                	li	a2,1
 37a:	faf40593          	addi	a1,s0,-81
 37e:	4501                	li	a0,0
 380:	00000097          	auipc	ra,0x0
 384:	11c080e7          	jalr	284(ra) # 49c <read>
    if(cc < 1)
 388:	00a05e63          	blez	a0,3a4 <gets+0x56>
    buf[i++] = c;
 38c:	faf44783          	lbu	a5,-81(s0)
 390:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 394:	01578763          	beq	a5,s5,3a2 <gets+0x54>
 398:	0905                	addi	s2,s2,1
 39a:	fd679be3          	bne	a5,s6,370 <gets+0x22>
  for(i=0; i+1 < max; ){
 39e:	89a6                	mv	s3,s1
 3a0:	a011                	j	3a4 <gets+0x56>
 3a2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3a4:	99de                	add	s3,s3,s7
 3a6:	00098023          	sb	zero,0(s3)
  return buf;
}
 3aa:	855e                	mv	a0,s7
 3ac:	60e6                	ld	ra,88(sp)
 3ae:	6446                	ld	s0,80(sp)
 3b0:	64a6                	ld	s1,72(sp)
 3b2:	6906                	ld	s2,64(sp)
 3b4:	79e2                	ld	s3,56(sp)
 3b6:	7a42                	ld	s4,48(sp)
 3b8:	7aa2                	ld	s5,40(sp)
 3ba:	7b02                	ld	s6,32(sp)
 3bc:	6be2                	ld	s7,24(sp)
 3be:	6125                	addi	sp,sp,96
 3c0:	8082                	ret

00000000000003c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3c2:	1101                	addi	sp,sp,-32
 3c4:	ec06                	sd	ra,24(sp)
 3c6:	e822                	sd	s0,16(sp)
 3c8:	e426                	sd	s1,8(sp)
 3ca:	e04a                	sd	s2,0(sp)
 3cc:	1000                	addi	s0,sp,32
 3ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d0:	4581                	li	a1,0
 3d2:	00000097          	auipc	ra,0x0
 3d6:	0f2080e7          	jalr	242(ra) # 4c4 <open>
  if(fd < 0)
 3da:	02054563          	bltz	a0,404 <stat+0x42>
 3de:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3e0:	85ca                	mv	a1,s2
 3e2:	00000097          	auipc	ra,0x0
 3e6:	0fa080e7          	jalr	250(ra) # 4dc <fstat>
 3ea:	892a                	mv	s2,a0
  close(fd);
 3ec:	8526                	mv	a0,s1
 3ee:	00000097          	auipc	ra,0x0
 3f2:	0be080e7          	jalr	190(ra) # 4ac <close>
  return r;
}
 3f6:	854a                	mv	a0,s2
 3f8:	60e2                	ld	ra,24(sp)
 3fa:	6442                	ld	s0,16(sp)
 3fc:	64a2                	ld	s1,8(sp)
 3fe:	6902                	ld	s2,0(sp)
 400:	6105                	addi	sp,sp,32
 402:	8082                	ret
    return -1;
 404:	597d                	li	s2,-1
 406:	bfc5                	j	3f6 <stat+0x34>

0000000000000408 <atoi>:

int
atoi(const char *s)
{
 408:	1141                	addi	sp,sp,-16
 40a:	e422                	sd	s0,8(sp)
 40c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 40e:	00054603          	lbu	a2,0(a0)
 412:	fd06079b          	addiw	a5,a2,-48
 416:	0ff7f793          	andi	a5,a5,255
 41a:	4725                	li	a4,9
 41c:	02f76963          	bltu	a4,a5,44e <atoi+0x46>
 420:	86aa                	mv	a3,a0
  n = 0;
 422:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 424:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 426:	0685                	addi	a3,a3,1
 428:	0025179b          	slliw	a5,a0,0x2
 42c:	9fa9                	addw	a5,a5,a0
 42e:	0017979b          	slliw	a5,a5,0x1
 432:	9fb1                	addw	a5,a5,a2
 434:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 438:	0006c603          	lbu	a2,0(a3)
 43c:	fd06071b          	addiw	a4,a2,-48
 440:	0ff77713          	andi	a4,a4,255
 444:	fee5f1e3          	bgeu	a1,a4,426 <atoi+0x1e>
  return n;
}
 448:	6422                	ld	s0,8(sp)
 44a:	0141                	addi	sp,sp,16
 44c:	8082                	ret
  n = 0;
 44e:	4501                	li	a0,0
 450:	bfe5                	j	448 <atoi+0x40>

0000000000000452 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 452:	1141                	addi	sp,sp,-16
 454:	e422                	sd	s0,8(sp)
 456:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 458:	00c05f63          	blez	a2,476 <memmove+0x24>
 45c:	1602                	slli	a2,a2,0x20
 45e:	9201                	srli	a2,a2,0x20
 460:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 464:	87aa                	mv	a5,a0
    *dst++ = *src++;
 466:	0585                	addi	a1,a1,1
 468:	0785                	addi	a5,a5,1
 46a:	fff5c703          	lbu	a4,-1(a1)
 46e:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 472:	fed79ae3          	bne	a5,a3,466 <memmove+0x14>
  return vdst;
}
 476:	6422                	ld	s0,8(sp)
 478:	0141                	addi	sp,sp,16
 47a:	8082                	ret

000000000000047c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 47c:	4885                	li	a7,1
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <exit>:
.global exit
exit:
 li a7, SYS_exit
 484:	4889                	li	a7,2
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <wait>:
.global wait
wait:
 li a7, SYS_wait
 48c:	488d                	li	a7,3
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 494:	4891                	li	a7,4
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <read>:
.global read
read:
 li a7, SYS_read
 49c:	4895                	li	a7,5
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <write>:
.global write
write:
 li a7, SYS_write
 4a4:	48c1                	li	a7,16
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <close>:
.global close
close:
 li a7, SYS_close
 4ac:	48d5                	li	a7,21
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4b4:	4899                	li	a7,6
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <exec>:
.global exec
exec:
 li a7, SYS_exec
 4bc:	489d                	li	a7,7
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <open>:
.global open
open:
 li a7, SYS_open
 4c4:	48bd                	li	a7,15
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4cc:	48c5                	li	a7,17
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4d4:	48c9                	li	a7,18
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4dc:	48a1                	li	a7,8
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <link>:
.global link
link:
 li a7, SYS_link
 4e4:	48cd                	li	a7,19
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ec:	48d1                	li	a7,20
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4f4:	48a5                	li	a7,9
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <dup>:
.global dup
dup:
 li a7, SYS_dup
 4fc:	48a9                	li	a7,10
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 504:	48ad                	li	a7,11
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 50c:	48b1                	li	a7,12
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 514:	48b5                	li	a7,13
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 51c:	48b9                	li	a7,14
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 524:	48d9                	li	a7,22
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <crash>:
.global crash
crash:
 li a7, SYS_crash
 52c:	48dd                	li	a7,23
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <mount>:
.global mount
mount:
 li a7, SYS_mount
 534:	48e1                	li	a7,24
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <umount>:
.global umount
umount:
 li a7, SYS_umount
 53c:	48e5                	li	a7,25
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 544:	1101                	addi	sp,sp,-32
 546:	ec06                	sd	ra,24(sp)
 548:	e822                	sd	s0,16(sp)
 54a:	1000                	addi	s0,sp,32
 54c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 550:	4605                	li	a2,1
 552:	fef40593          	addi	a1,s0,-17
 556:	00000097          	auipc	ra,0x0
 55a:	f4e080e7          	jalr	-178(ra) # 4a4 <write>
}
 55e:	60e2                	ld	ra,24(sp)
 560:	6442                	ld	s0,16(sp)
 562:	6105                	addi	sp,sp,32
 564:	8082                	ret

0000000000000566 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 566:	7139                	addi	sp,sp,-64
 568:	fc06                	sd	ra,56(sp)
 56a:	f822                	sd	s0,48(sp)
 56c:	f426                	sd	s1,40(sp)
 56e:	f04a                	sd	s2,32(sp)
 570:	ec4e                	sd	s3,24(sp)
 572:	0080                	addi	s0,sp,64
 574:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 576:	c299                	beqz	a3,57c <printint+0x16>
 578:	0805c863          	bltz	a1,608 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 57c:	2581                	sext.w	a1,a1
  neg = 0;
 57e:	4881                	li	a7,0
 580:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 584:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 586:	2601                	sext.w	a2,a2
 588:	00000517          	auipc	a0,0x0
 58c:	47850513          	addi	a0,a0,1144 # a00 <digits>
 590:	883a                	mv	a6,a4
 592:	2705                	addiw	a4,a4,1
 594:	02c5f7bb          	remuw	a5,a1,a2
 598:	1782                	slli	a5,a5,0x20
 59a:	9381                	srli	a5,a5,0x20
 59c:	97aa                	add	a5,a5,a0
 59e:	0007c783          	lbu	a5,0(a5)
 5a2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5a6:	0005879b          	sext.w	a5,a1
 5aa:	02c5d5bb          	divuw	a1,a1,a2
 5ae:	0685                	addi	a3,a3,1
 5b0:	fec7f0e3          	bgeu	a5,a2,590 <printint+0x2a>
  if(neg)
 5b4:	00088b63          	beqz	a7,5ca <printint+0x64>
    buf[i++] = '-';
 5b8:	fd040793          	addi	a5,s0,-48
 5bc:	973e                	add	a4,a4,a5
 5be:	02d00793          	li	a5,45
 5c2:	fef70823          	sb	a5,-16(a4)
 5c6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5ca:	02e05863          	blez	a4,5fa <printint+0x94>
 5ce:	fc040793          	addi	a5,s0,-64
 5d2:	00e78933          	add	s2,a5,a4
 5d6:	fff78993          	addi	s3,a5,-1
 5da:	99ba                	add	s3,s3,a4
 5dc:	377d                	addiw	a4,a4,-1
 5de:	1702                	slli	a4,a4,0x20
 5e0:	9301                	srli	a4,a4,0x20
 5e2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5e6:	fff94583          	lbu	a1,-1(s2)
 5ea:	8526                	mv	a0,s1
 5ec:	00000097          	auipc	ra,0x0
 5f0:	f58080e7          	jalr	-168(ra) # 544 <putc>
  while(--i >= 0)
 5f4:	197d                	addi	s2,s2,-1
 5f6:	ff3918e3          	bne	s2,s3,5e6 <printint+0x80>
}
 5fa:	70e2                	ld	ra,56(sp)
 5fc:	7442                	ld	s0,48(sp)
 5fe:	74a2                	ld	s1,40(sp)
 600:	7902                	ld	s2,32(sp)
 602:	69e2                	ld	s3,24(sp)
 604:	6121                	addi	sp,sp,64
 606:	8082                	ret
    x = -xx;
 608:	40b005bb          	negw	a1,a1
    neg = 1;
 60c:	4885                	li	a7,1
    x = -xx;
 60e:	bf8d                	j	580 <printint+0x1a>

0000000000000610 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 610:	7119                	addi	sp,sp,-128
 612:	fc86                	sd	ra,120(sp)
 614:	f8a2                	sd	s0,112(sp)
 616:	f4a6                	sd	s1,104(sp)
 618:	f0ca                	sd	s2,96(sp)
 61a:	ecce                	sd	s3,88(sp)
 61c:	e8d2                	sd	s4,80(sp)
 61e:	e4d6                	sd	s5,72(sp)
 620:	e0da                	sd	s6,64(sp)
 622:	fc5e                	sd	s7,56(sp)
 624:	f862                	sd	s8,48(sp)
 626:	f466                	sd	s9,40(sp)
 628:	f06a                	sd	s10,32(sp)
 62a:	ec6e                	sd	s11,24(sp)
 62c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 62e:	0005c903          	lbu	s2,0(a1)
 632:	18090f63          	beqz	s2,7d0 <vprintf+0x1c0>
 636:	8aaa                	mv	s5,a0
 638:	8b32                	mv	s6,a2
 63a:	00158493          	addi	s1,a1,1
  state = 0;
 63e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 640:	02500a13          	li	s4,37
      if(c == 'd'){
 644:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 648:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 64c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 650:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 654:	00000b97          	auipc	s7,0x0
 658:	3acb8b93          	addi	s7,s7,940 # a00 <digits>
 65c:	a839                	j	67a <vprintf+0x6a>
        putc(fd, c);
 65e:	85ca                	mv	a1,s2
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	ee2080e7          	jalr	-286(ra) # 544 <putc>
 66a:	a019                	j	670 <vprintf+0x60>
    } else if(state == '%'){
 66c:	01498f63          	beq	s3,s4,68a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 670:	0485                	addi	s1,s1,1
 672:	fff4c903          	lbu	s2,-1(s1)
 676:	14090d63          	beqz	s2,7d0 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 67a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 67e:	fe0997e3          	bnez	s3,66c <vprintf+0x5c>
      if(c == '%'){
 682:	fd479ee3          	bne	a5,s4,65e <vprintf+0x4e>
        state = '%';
 686:	89be                	mv	s3,a5
 688:	b7e5                	j	670 <vprintf+0x60>
      if(c == 'd'){
 68a:	05878063          	beq	a5,s8,6ca <vprintf+0xba>
      } else if(c == 'l') {
 68e:	05978c63          	beq	a5,s9,6e6 <vprintf+0xd6>
      } else if(c == 'x') {
 692:	07a78863          	beq	a5,s10,702 <vprintf+0xf2>
      } else if(c == 'p') {
 696:	09b78463          	beq	a5,s11,71e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 69a:	07300713          	li	a4,115
 69e:	0ce78663          	beq	a5,a4,76a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6a2:	06300713          	li	a4,99
 6a6:	0ee78e63          	beq	a5,a4,7a2 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6aa:	11478863          	beq	a5,s4,7ba <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ae:	85d2                	mv	a1,s4
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	e92080e7          	jalr	-366(ra) # 544 <putc>
        putc(fd, c);
 6ba:	85ca                	mv	a1,s2
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	e86080e7          	jalr	-378(ra) # 544 <putc>
      }
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	b765                	j	670 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6ca:	008b0913          	addi	s2,s6,8
 6ce:	4685                	li	a3,1
 6d0:	4629                	li	a2,10
 6d2:	000b2583          	lw	a1,0(s6)
 6d6:	8556                	mv	a0,s5
 6d8:	00000097          	auipc	ra,0x0
 6dc:	e8e080e7          	jalr	-370(ra) # 566 <printint>
 6e0:	8b4a                	mv	s6,s2
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b771                	j	670 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e6:	008b0913          	addi	s2,s6,8
 6ea:	4681                	li	a3,0
 6ec:	4629                	li	a2,10
 6ee:	000b2583          	lw	a1,0(s6)
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	e72080e7          	jalr	-398(ra) # 566 <printint>
 6fc:	8b4a                	mv	s6,s2
      state = 0;
 6fe:	4981                	li	s3,0
 700:	bf85                	j	670 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 702:	008b0913          	addi	s2,s6,8
 706:	4681                	li	a3,0
 708:	4641                	li	a2,16
 70a:	000b2583          	lw	a1,0(s6)
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	e56080e7          	jalr	-426(ra) # 566 <printint>
 718:	8b4a                	mv	s6,s2
      state = 0;
 71a:	4981                	li	s3,0
 71c:	bf91                	j	670 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 71e:	008b0793          	addi	a5,s6,8
 722:	f8f43423          	sd	a5,-120(s0)
 726:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 72a:	03000593          	li	a1,48
 72e:	8556                	mv	a0,s5
 730:	00000097          	auipc	ra,0x0
 734:	e14080e7          	jalr	-492(ra) # 544 <putc>
  putc(fd, 'x');
 738:	85ea                	mv	a1,s10
 73a:	8556                	mv	a0,s5
 73c:	00000097          	auipc	ra,0x0
 740:	e08080e7          	jalr	-504(ra) # 544 <putc>
 744:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 746:	03c9d793          	srli	a5,s3,0x3c
 74a:	97de                	add	a5,a5,s7
 74c:	0007c583          	lbu	a1,0(a5)
 750:	8556                	mv	a0,s5
 752:	00000097          	auipc	ra,0x0
 756:	df2080e7          	jalr	-526(ra) # 544 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 75a:	0992                	slli	s3,s3,0x4
 75c:	397d                	addiw	s2,s2,-1
 75e:	fe0914e3          	bnez	s2,746 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 762:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 766:	4981                	li	s3,0
 768:	b721                	j	670 <vprintf+0x60>
        s = va_arg(ap, char*);
 76a:	008b0993          	addi	s3,s6,8
 76e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 772:	02090163          	beqz	s2,794 <vprintf+0x184>
        while(*s != 0){
 776:	00094583          	lbu	a1,0(s2)
 77a:	c9a1                	beqz	a1,7ca <vprintf+0x1ba>
          putc(fd, *s);
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	dc6080e7          	jalr	-570(ra) # 544 <putc>
          s++;
 786:	0905                	addi	s2,s2,1
        while(*s != 0){
 788:	00094583          	lbu	a1,0(s2)
 78c:	f9e5                	bnez	a1,77c <vprintf+0x16c>
        s = va_arg(ap, char*);
 78e:	8b4e                	mv	s6,s3
      state = 0;
 790:	4981                	li	s3,0
 792:	bdf9                	j	670 <vprintf+0x60>
          s = "(null)";
 794:	00000917          	auipc	s2,0x0
 798:	26490913          	addi	s2,s2,612 # 9f8 <malloc+0x11e>
        while(*s != 0){
 79c:	02800593          	li	a1,40
 7a0:	bff1                	j	77c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7a2:	008b0913          	addi	s2,s6,8
 7a6:	000b4583          	lbu	a1,0(s6)
 7aa:	8556                	mv	a0,s5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	d98080e7          	jalr	-616(ra) # 544 <putc>
 7b4:	8b4a                	mv	s6,s2
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	bd65                	j	670 <vprintf+0x60>
        putc(fd, c);
 7ba:	85d2                	mv	a1,s4
 7bc:	8556                	mv	a0,s5
 7be:	00000097          	auipc	ra,0x0
 7c2:	d86080e7          	jalr	-634(ra) # 544 <putc>
      state = 0;
 7c6:	4981                	li	s3,0
 7c8:	b565                	j	670 <vprintf+0x60>
        s = va_arg(ap, char*);
 7ca:	8b4e                	mv	s6,s3
      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	b54d                	j	670 <vprintf+0x60>
    }
  }
}
 7d0:	70e6                	ld	ra,120(sp)
 7d2:	7446                	ld	s0,112(sp)
 7d4:	74a6                	ld	s1,104(sp)
 7d6:	7906                	ld	s2,96(sp)
 7d8:	69e6                	ld	s3,88(sp)
 7da:	6a46                	ld	s4,80(sp)
 7dc:	6aa6                	ld	s5,72(sp)
 7de:	6b06                	ld	s6,64(sp)
 7e0:	7be2                	ld	s7,56(sp)
 7e2:	7c42                	ld	s8,48(sp)
 7e4:	7ca2                	ld	s9,40(sp)
 7e6:	7d02                	ld	s10,32(sp)
 7e8:	6de2                	ld	s11,24(sp)
 7ea:	6109                	addi	sp,sp,128
 7ec:	8082                	ret

00000000000007ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ee:	715d                	addi	sp,sp,-80
 7f0:	ec06                	sd	ra,24(sp)
 7f2:	e822                	sd	s0,16(sp)
 7f4:	1000                	addi	s0,sp,32
 7f6:	e010                	sd	a2,0(s0)
 7f8:	e414                	sd	a3,8(s0)
 7fa:	e818                	sd	a4,16(s0)
 7fc:	ec1c                	sd	a5,24(s0)
 7fe:	03043023          	sd	a6,32(s0)
 802:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 806:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 80a:	8622                	mv	a2,s0
 80c:	00000097          	auipc	ra,0x0
 810:	e04080e7          	jalr	-508(ra) # 610 <vprintf>
}
 814:	60e2                	ld	ra,24(sp)
 816:	6442                	ld	s0,16(sp)
 818:	6161                	addi	sp,sp,80
 81a:	8082                	ret

000000000000081c <printf>:

void
printf(const char *fmt, ...)
{
 81c:	711d                	addi	sp,sp,-96
 81e:	ec06                	sd	ra,24(sp)
 820:	e822                	sd	s0,16(sp)
 822:	1000                	addi	s0,sp,32
 824:	e40c                	sd	a1,8(s0)
 826:	e810                	sd	a2,16(s0)
 828:	ec14                	sd	a3,24(s0)
 82a:	f018                	sd	a4,32(s0)
 82c:	f41c                	sd	a5,40(s0)
 82e:	03043823          	sd	a6,48(s0)
 832:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 836:	00840613          	addi	a2,s0,8
 83a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 83e:	85aa                	mv	a1,a0
 840:	4505                	li	a0,1
 842:	00000097          	auipc	ra,0x0
 846:	dce080e7          	jalr	-562(ra) # 610 <vprintf>
}
 84a:	60e2                	ld	ra,24(sp)
 84c:	6442                	ld	s0,16(sp)
 84e:	6125                	addi	sp,sp,96
 850:	8082                	ret

0000000000000852 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 852:	1141                	addi	sp,sp,-16
 854:	e422                	sd	s0,8(sp)
 856:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 858:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85c:	00000797          	auipc	a5,0x0
 860:	1bc7b783          	ld	a5,444(a5) # a18 <freep>
 864:	a805                	j	894 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 866:	4618                	lw	a4,8(a2)
 868:	9db9                	addw	a1,a1,a4
 86a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 86e:	6398                	ld	a4,0(a5)
 870:	6318                	ld	a4,0(a4)
 872:	fee53823          	sd	a4,-16(a0)
 876:	a091                	j	8ba <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 878:	ff852703          	lw	a4,-8(a0)
 87c:	9e39                	addw	a2,a2,a4
 87e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 880:	ff053703          	ld	a4,-16(a0)
 884:	e398                	sd	a4,0(a5)
 886:	a099                	j	8cc <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 888:	6398                	ld	a4,0(a5)
 88a:	00e7e463          	bltu	a5,a4,892 <free+0x40>
 88e:	00e6ea63          	bltu	a3,a4,8a2 <free+0x50>
{
 892:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 894:	fed7fae3          	bgeu	a5,a3,888 <free+0x36>
 898:	6398                	ld	a4,0(a5)
 89a:	00e6e463          	bltu	a3,a4,8a2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89e:	fee7eae3          	bltu	a5,a4,892 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8a2:	ff852583          	lw	a1,-8(a0)
 8a6:	6390                	ld	a2,0(a5)
 8a8:	02059813          	slli	a6,a1,0x20
 8ac:	01c85713          	srli	a4,a6,0x1c
 8b0:	9736                	add	a4,a4,a3
 8b2:	fae60ae3          	beq	a2,a4,866 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8b6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ba:	4790                	lw	a2,8(a5)
 8bc:	02061593          	slli	a1,a2,0x20
 8c0:	01c5d713          	srli	a4,a1,0x1c
 8c4:	973e                	add	a4,a4,a5
 8c6:	fae689e3          	beq	a3,a4,878 <free+0x26>
  } else
    p->s.ptr = bp;
 8ca:	e394                	sd	a3,0(a5)
  freep = p;
 8cc:	00000717          	auipc	a4,0x0
 8d0:	14f73623          	sd	a5,332(a4) # a18 <freep>
}
 8d4:	6422                	ld	s0,8(sp)
 8d6:	0141                	addi	sp,sp,16
 8d8:	8082                	ret

00000000000008da <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8da:	7139                	addi	sp,sp,-64
 8dc:	fc06                	sd	ra,56(sp)
 8de:	f822                	sd	s0,48(sp)
 8e0:	f426                	sd	s1,40(sp)
 8e2:	f04a                	sd	s2,32(sp)
 8e4:	ec4e                	sd	s3,24(sp)
 8e6:	e852                	sd	s4,16(sp)
 8e8:	e456                	sd	s5,8(sp)
 8ea:	e05a                	sd	s6,0(sp)
 8ec:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ee:	02051493          	slli	s1,a0,0x20
 8f2:	9081                	srli	s1,s1,0x20
 8f4:	04bd                	addi	s1,s1,15
 8f6:	8091                	srli	s1,s1,0x4
 8f8:	0014899b          	addiw	s3,s1,1
 8fc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8fe:	00000517          	auipc	a0,0x0
 902:	11a53503          	ld	a0,282(a0) # a18 <freep>
 906:	c515                	beqz	a0,932 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 908:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 90a:	4798                	lw	a4,8(a5)
 90c:	02977f63          	bgeu	a4,s1,94a <malloc+0x70>
 910:	8a4e                	mv	s4,s3
 912:	0009871b          	sext.w	a4,s3
 916:	6685                	lui	a3,0x1
 918:	00d77363          	bgeu	a4,a3,91e <malloc+0x44>
 91c:	6a05                	lui	s4,0x1
 91e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 922:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 926:	00000917          	auipc	s2,0x0
 92a:	0f290913          	addi	s2,s2,242 # a18 <freep>
  if(p == (char*)-1)
 92e:	5afd                	li	s5,-1
 930:	a895                	j	9a4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 932:	00000797          	auipc	a5,0x0
 936:	4ee78793          	addi	a5,a5,1262 # e20 <base>
 93a:	00000717          	auipc	a4,0x0
 93e:	0cf73f23          	sd	a5,222(a4) # a18 <freep>
 942:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 944:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 948:	b7e1                	j	910 <malloc+0x36>
      if(p->s.size == nunits)
 94a:	02e48c63          	beq	s1,a4,982 <malloc+0xa8>
        p->s.size -= nunits;
 94e:	4137073b          	subw	a4,a4,s3
 952:	c798                	sw	a4,8(a5)
        p += p->s.size;
 954:	02071693          	slli	a3,a4,0x20
 958:	01c6d713          	srli	a4,a3,0x1c
 95c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 95e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 962:	00000717          	auipc	a4,0x0
 966:	0aa73b23          	sd	a0,182(a4) # a18 <freep>
      return (void*)(p + 1);
 96a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 96e:	70e2                	ld	ra,56(sp)
 970:	7442                	ld	s0,48(sp)
 972:	74a2                	ld	s1,40(sp)
 974:	7902                	ld	s2,32(sp)
 976:	69e2                	ld	s3,24(sp)
 978:	6a42                	ld	s4,16(sp)
 97a:	6aa2                	ld	s5,8(sp)
 97c:	6b02                	ld	s6,0(sp)
 97e:	6121                	addi	sp,sp,64
 980:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 982:	6398                	ld	a4,0(a5)
 984:	e118                	sd	a4,0(a0)
 986:	bff1                	j	962 <malloc+0x88>
  hp->s.size = nu;
 988:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 98c:	0541                	addi	a0,a0,16
 98e:	00000097          	auipc	ra,0x0
 992:	ec4080e7          	jalr	-316(ra) # 852 <free>
  return freep;
 996:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 99a:	d971                	beqz	a0,96e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 99e:	4798                	lw	a4,8(a5)
 9a0:	fa9775e3          	bgeu	a4,s1,94a <malloc+0x70>
    if(p == freep)
 9a4:	00093703          	ld	a4,0(s2)
 9a8:	853e                	mv	a0,a5
 9aa:	fef719e3          	bne	a4,a5,99c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9ae:	8552                	mv	a0,s4
 9b0:	00000097          	auipc	ra,0x0
 9b4:	b5c080e7          	jalr	-1188(ra) # 50c <sbrk>
  if(p == (char*)-1)
 9b8:	fd5518e3          	bne	a0,s5,988 <malloc+0xae>
        return 0;
 9bc:	4501                	li	a0,0
 9be:	bf45                	j	96e <malloc+0x94>
