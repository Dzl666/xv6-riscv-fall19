
user/_nsh：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <runcmd>:
}

// Execute cmd.  Never returns.
void
runcmd(char *argv[],int argc)
{
   0:	711d                	addi	sp,sp,-96
   2:	ec86                	sd	ra,88(sp)
   4:	e8a2                	sd	s0,80(sp)
   6:	e4a6                	sd	s1,72(sp)
   8:	e0ca                	sd	s2,64(sp)
   a:	fc4e                	sd	s3,56(sp)
   c:	f852                	sd	s4,48(sp)
   e:	f456                	sd	s5,40(sp)
  10:	f05a                	sd	s6,32(sp)
  12:	ec5e                	sd	s7,24(sp)
  14:	e862                	sd	s8,16(sp)
  16:	e466                	sd	s9,8(sp)
  18:	e06a                	sd	s10,0(sp)
  1a:	1080                	addi	s0,sp,96
  1c:	8baa                	mv	s7,a0
    int i;
    for(i = 1;i < argc;i++){
  1e:	4785                	li	a5,1
  20:	0eb7d863          	bge	a5,a1,110 <runcmd+0x110>
  24:	8a2e                	mv	s4,a1
  26:	00850913          	addi	s2,a0,8
  2a:	84ca                	mv	s1,s2
  2c:	4985                	li	s3,1
        if(strcmp(argv[i], "|") == 0){    //output redir
  2e:	00001a97          	auipc	s5,0x1
  32:	b22a8a93          	addi	s5,s5,-1246 # b50 <malloc+0xea>
  36:	85d6                	mv	a1,s5
  38:	6088                	ld	a0,0(s1)
  3a:	00000097          	auipc	ra,0x0
  3e:	404080e7          	jalr	1028(ra) # 43e <strcmp>
  42:	c511                	beqz	a0,4e <runcmd+0x4e>
    for(i = 1;i < argc;i++){
  44:	2985                	addiw	s3,s3,1
  46:	04a1                	addi	s1,s1,8
  48:	ff3a17e3          	bne	s4,s3,36 <runcmd+0x36>
  4c:	a811                	j	60 <runcmd+0x60>
            argv[i] = '\0';
  4e:	0004b023          	sd	zero,0(s1)
            pipecmd(argv, argc, i);
  52:	864e                	mv	a2,s3
  54:	85d2                	mv	a1,s4
  56:	855e                	mv	a0,s7
  58:	00000097          	auipc	ra,0x0
  5c:	0e2080e7          	jalr	226(ra) # 13a <pipecmd>
    for(i = 1;i < argc;i++){
  60:	4485                	li	s1,1
            break;
        }
    }

    for(i = 1;i < argc;i++){
        if(strcmp(argv[i], "<") == 0){    //input redir
  62:	00001b17          	auipc	s6,0x1
  66:	af6b0b13          	addi	s6,s6,-1290 # b58 <malloc+0xf2>
            if(i == argc-1){
  6a:	fffa0c1b          	addiw	s8,s4,-1
                fprintf(2,"Usage: cmd < filenme.\n");
  6e:	00001d17          	auipc	s10,0x1
  72:	af2d0d13          	addi	s10,s10,-1294 # b60 <malloc+0xfa>
            }
            close(0);
            open(argv[i+1], O_RDONLY);
            argv[i] = '\0';
        }
        if(strcmp(argv[i], ">") == 0){    //output redir
  76:	00001a97          	auipc	s5,0x1
  7a:	b02a8a93          	addi	s5,s5,-1278 # b78 <malloc+0x112>
            if(i == argc-1){
                fprintf(2,"Usage: cmd > filenme.\n");
  7e:	00001c97          	auipc	s9,0x1
  82:	b02c8c93          	addi	s9,s9,-1278 # b80 <malloc+0x11a>
  86:	a81d                	j	bc <runcmd+0xbc>
                fprintf(2,"Usage: cmd < filenme.\n");
  88:	85ea                	mv	a1,s10
  8a:	4509                	li	a0,2
  8c:	00001097          	auipc	ra,0x1
  90:	8ee080e7          	jalr	-1810(ra) # 97a <fprintf>
  94:	a83d                	j	d2 <runcmd+0xd2>
            }
            close(1);
  96:	4505                	li	a0,1
  98:	00000097          	auipc	ra,0x0
  9c:	5a0080e7          	jalr	1440(ra) # 638 <close>
            open(argv[i+1], O_CREATE|O_WRONLY);
  a0:	20100593          	li	a1,513
  a4:	0089b503          	ld	a0,8(s3)
  a8:	00000097          	auipc	ra,0x0
  ac:	5a8080e7          	jalr	1448(ra) # 650 <open>
            argv[i] = '\0';
  b0:	0009b023          	sd	zero,0(s3)
    for(i = 1;i < argc;i++){
  b4:	2485                	addiw	s1,s1,1
  b6:	0921                	addi	s2,s2,8
  b8:	049a0c63          	beq	s4,s1,110 <runcmd+0x110>
        if(strcmp(argv[i], "<") == 0){    //input redir
  bc:	89ca                	mv	s3,s2
  be:	85da                	mv	a1,s6
  c0:	00093503          	ld	a0,0(s2)
  c4:	00000097          	auipc	ra,0x0
  c8:	37a080e7          	jalr	890(ra) # 43e <strcmp>
  cc:	e10d                	bnez	a0,ee <runcmd+0xee>
            if(i == argc-1){
  ce:	fa9c0de3          	beq	s8,s1,88 <runcmd+0x88>
            close(0);
  d2:	4501                	li	a0,0
  d4:	00000097          	auipc	ra,0x0
  d8:	564080e7          	jalr	1380(ra) # 638 <close>
            open(argv[i+1], O_RDONLY);
  dc:	4581                	li	a1,0
  de:	0089b503          	ld	a0,8(s3)
  e2:	00000097          	auipc	ra,0x0
  e6:	56e080e7          	jalr	1390(ra) # 650 <open>
            argv[i] = '\0';
  ea:	0009b023          	sd	zero,0(s3)
        if(strcmp(argv[i], ">") == 0){    //output redir
  ee:	85d6                	mv	a1,s5
  f0:	0009b503          	ld	a0,0(s3)
  f4:	00000097          	auipc	ra,0x0
  f8:	34a080e7          	jalr	842(ra) # 43e <strcmp>
  fc:	fd45                	bnez	a0,b4 <runcmd+0xb4>
            if(i == argc-1){
  fe:	f89c1ce3          	bne	s8,s1,96 <runcmd+0x96>
                fprintf(2,"Usage: cmd > filenme.\n");
 102:	85e6                	mv	a1,s9
 104:	4509                	li	a0,2
 106:	00001097          	auipc	ra,0x1
 10a:	874080e7          	jalr	-1932(ra) # 97a <fprintf>
 10e:	b761                	j	96 <runcmd+0x96>
        }
    }
    exec(argv[0], argv);
 110:	85de                	mv	a1,s7
 112:	000bb503          	ld	a0,0(s7)
 116:	00000097          	auipc	ra,0x0
 11a:	532080e7          	jalr	1330(ra) # 648 <exec>
}
 11e:	60e6                	ld	ra,88(sp)
 120:	6446                	ld	s0,80(sp)
 122:	64a6                	ld	s1,72(sp)
 124:	6906                	ld	s2,64(sp)
 126:	79e2                	ld	s3,56(sp)
 128:	7a42                	ld	s4,48(sp)
 12a:	7aa2                	ld	s5,40(sp)
 12c:	7b02                	ld	s6,32(sp)
 12e:	6be2                	ld	s7,24(sp)
 130:	6c42                	ld	s8,16(sp)
 132:	6ca2                	ld	s9,8(sp)
 134:	6d02                	ld	s10,0(sp)
 136:	6125                	addi	sp,sp,96
 138:	8082                	ret

000000000000013a <pipecmd>:
{
 13a:	7139                	addi	sp,sp,-64
 13c:	fc06                	sd	ra,56(sp)
 13e:	f822                	sd	s0,48(sp)
 140:	f426                	sd	s1,40(sp)
 142:	f04a                	sd	s2,32(sp)
 144:	ec4e                	sd	s3,24(sp)
 146:	0080                	addi	s0,sp,64
 148:	89aa                	mv	s3,a0
 14a:	892e                	mv	s2,a1
 14c:	84b2                	mv	s1,a2
    pipe(fd);   //fd[0]读端 fd[1]写端
 14e:	fc840513          	addi	a0,s0,-56
 152:	00000097          	auipc	ra,0x0
 156:	4ce080e7          	jalr	1230(ra) # 620 <pipe>
    if(fork() == 0){    //exec left cmd of pipe
 15a:	00000097          	auipc	ra,0x0
 15e:	4ae080e7          	jalr	1198(ra) # 608 <fork>
 162:	e921                	bnez	a0,1b2 <pipecmd+0x78>
        close(1);   //close stdout
 164:	4505                	li	a0,1
 166:	00000097          	auipc	ra,0x0
 16a:	4d2080e7          	jalr	1234(ra) # 638 <close>
        dup(fd[1]);
 16e:	fcc42503          	lw	a0,-52(s0)
 172:	00000097          	auipc	ra,0x0
 176:	516080e7          	jalr	1302(ra) # 688 <dup>
        close(fd[0]);
 17a:	fc842503          	lw	a0,-56(s0)
 17e:	00000097          	auipc	ra,0x0
 182:	4ba080e7          	jalr	1210(ra) # 638 <close>
        close(fd[1]);
 186:	fcc42503          	lw	a0,-52(s0)
 18a:	00000097          	auipc	ra,0x0
 18e:	4ae080e7          	jalr	1198(ra) # 638 <close>
        runcmd(argv, largc);
 192:	85a6                	mv	a1,s1
 194:	854e                	mv	a0,s3
 196:	00000097          	auipc	ra,0x0
 19a:	e6a080e7          	jalr	-406(ra) # 0 <runcmd>
    wait(0);
 19e:	4501                	li	a0,0
 1a0:	00000097          	auipc	ra,0x0
 1a4:	478080e7          	jalr	1144(ra) # 618 <wait>
    exit(0);
 1a8:	4501                	li	a0,0
 1aa:	00000097          	auipc	ra,0x0
 1ae:	466080e7          	jalr	1126(ra) # 610 <exit>
        close(0);   //close stdin
 1b2:	4501                	li	a0,0
 1b4:	00000097          	auipc	ra,0x0
 1b8:	484080e7          	jalr	1156(ra) # 638 <close>
        dup(fd[0]);
 1bc:	fc842503          	lw	a0,-56(s0)
 1c0:	00000097          	auipc	ra,0x0
 1c4:	4c8080e7          	jalr	1224(ra) # 688 <dup>
        close(fd[0]);
 1c8:	fc842503          	lw	a0,-56(s0)
 1cc:	00000097          	auipc	ra,0x0
 1d0:	46c080e7          	jalr	1132(ra) # 638 <close>
        close(fd[1]);
 1d4:	fcc42503          	lw	a0,-52(s0)
 1d8:	00000097          	auipc	ra,0x0
 1dc:	460080e7          	jalr	1120(ra) # 638 <close>
    int rargc = argc - largc -1;
 1e0:	409905bb          	subw	a1,s2,s1
        runcmd(argv+largc+1, rargc);
 1e4:	0485                	addi	s1,s1,1
 1e6:	048e                	slli	s1,s1,0x3
 1e8:	35fd                	addiw	a1,a1,-1
 1ea:	00998533          	add	a0,s3,s1
 1ee:	00000097          	auipc	ra,0x0
 1f2:	e12080e7          	jalr	-494(ra) # 0 <runcmd>
 1f6:	b765                	j	19e <pipecmd+0x64>

00000000000001f8 <getcmd>:

int
getcmd(char *buf, int nbuf)
{
 1f8:	1101                	addi	sp,sp,-32
 1fa:	ec06                	sd	ra,24(sp)
 1fc:	e822                	sd	s0,16(sp)
 1fe:	e426                	sd	s1,8(sp)
 200:	e04a                	sd	s2,0(sp)
 202:	1000                	addi	s0,sp,32
 204:	84aa                	mv	s1,a0
 206:	892e                	mv	s2,a1
  fprintf(2, "@ ");
 208:	00001597          	auipc	a1,0x1
 20c:	99058593          	addi	a1,a1,-1648 # b98 <malloc+0x132>
 210:	4509                	li	a0,2
 212:	00000097          	auipc	ra,0x0
 216:	768080e7          	jalr	1896(ra) # 97a <fprintf>
  memset(buf, 0, nbuf);
 21a:	864a                	mv	a2,s2
 21c:	4581                	li	a1,0
 21e:	8526                	mv	a0,s1
 220:	00000097          	auipc	ra,0x0
 224:	274080e7          	jalr	628(ra) # 494 <memset>
  gets(buf, nbuf);
 228:	85ca                	mv	a1,s2
 22a:	8526                	mv	a0,s1
 22c:	00000097          	auipc	ra,0x0
 230:	2ae080e7          	jalr	686(ra) # 4da <gets>
  if(buf[0] == 0) // EOF
 234:	0004c503          	lbu	a0,0(s1)
 238:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
 23c:	40a00533          	neg	a0,a0
 240:	60e2                	ld	ra,24(sp)
 242:	6442                	ld	s0,16(sp)
 244:	64a2                	ld	s1,8(sp)
 246:	6902                	ld	s2,0(sp)
 248:	6105                	addi	sp,sp,32
 24a:	8082                	ret

000000000000024c <parsecmd>:

void 
parsecmd(char buf[],char *argv[],int *argc)
{
 24c:	7139                	addi	sp,sp,-64
 24e:	fc06                	sd	ra,56(sp)
 250:	f822                	sd	s0,48(sp)
 252:	f426                	sd	s1,40(sp)
 254:	f04a                	sd	s2,32(sp)
 256:	ec4e                	sd	s3,24(sp)
 258:	e852                	sd	s4,16(sp)
 25a:	e456                	sd	s5,8(sp)
 25c:	e05a                	sd	s6,0(sp)
 25e:	0080                	addi	s0,sp,64
 260:	89aa                	mv	s3,a0
 262:	8a2e                	mv	s4,a1
 264:	8932                	mv	s2,a2
    int j = 0;
    char *p;
    p = buf;

    while(buf[j] != '\n'){
 266:	00054583          	lbu	a1,0(a0)
 26a:	47a9                	li	a5,10
 26c:	04f58563          	beq	a1,a5,2b6 <parsecmd+0x6a>
 270:	00150493          	addi	s1,a0,1
        if(strchr(whitespace,buf[j])){
 274:	00001b17          	auipc	s6,0x1
 278:	964b0b13          	addi	s6,s6,-1692 # bd8 <whitespace>
    while(buf[j] != '\n'){
 27c:	4aa9                	li	s5,10
 27e:	a02d                	j	2a8 <parsecmd+0x5c>
            buf[j] = '\0';
 280:	fe048fa3          	sb	zero,-1(s1)
            argv[++(*argc)] = p;
 284:	00092703          	lw	a4,0(s2)
 288:	2705                	addiw	a4,a4,1
 28a:	0007079b          	sext.w	a5,a4
 28e:	00e92023          	sw	a4,0(s2)
 292:	078e                	slli	a5,a5,0x3
 294:	97d2                	add	a5,a5,s4
 296:	0137b023          	sd	s3,0(a5)
            p = buf + j + 1;
 29a:	89a6                	mv	s3,s1
    while(buf[j] != '\n'){
 29c:	87a6                	mv	a5,s1
 29e:	0485                	addi	s1,s1,1
 2a0:	fff4c583          	lbu	a1,-1(s1)
 2a4:	01558a63          	beq	a1,s5,2b8 <parsecmd+0x6c>
        if(strchr(whitespace,buf[j])){
 2a8:	855a                	mv	a0,s6
 2aa:	00000097          	auipc	ra,0x0
 2ae:	20c080e7          	jalr	524(ra) # 4b6 <strchr>
 2b2:	f579                	bnez	a0,280 <parsecmd+0x34>
 2b4:	b7e5                	j	29c <parsecmd+0x50>
    while(buf[j] != '\n'){
 2b6:	87aa                	mv	a5,a0
        }
        j++;
    }
    buf[j] = '\0';
 2b8:	00078023          	sb	zero,0(a5)
    argv[++(*argc)] = p;
 2bc:	00092703          	lw	a4,0(s2)
 2c0:	2705                	addiw	a4,a4,1
 2c2:	0007079b          	sext.w	a5,a4
 2c6:	00e92023          	sw	a4,0(s2)
 2ca:	078e                	slli	a5,a5,0x3
 2cc:	97d2                	add	a5,a5,s4
 2ce:	0137b023          	sd	s3,0(a5)
    argv[++(*argc) + 1] = '\0';
 2d2:	00092783          	lw	a5,0(s2)
 2d6:	2785                	addiw	a5,a5,1
 2d8:	0007859b          	sext.w	a1,a5
 2dc:	00f92023          	sw	a5,0(s2)
 2e0:	0585                	addi	a1,a1,1
 2e2:	058e                	slli	a1,a1,0x3
 2e4:	9a2e                	add	s4,s4,a1
 2e6:	000a3023          	sd	zero,0(s4)
}
 2ea:	70e2                	ld	ra,56(sp)
 2ec:	7442                	ld	s0,48(sp)
 2ee:	74a2                	ld	s1,40(sp)
 2f0:	7902                	ld	s2,32(sp)
 2f2:	69e2                	ld	s3,24(sp)
 2f4:	6a42                	ld	s4,16(sp)
 2f6:	6aa2                	ld	s5,8(sp)
 2f8:	6b02                	ld	s6,0(sp)
 2fa:	6121                	addi	sp,sp,64
 2fc:	8082                	ret

00000000000002fe <main>:

int
main(void)
{
 2fe:	c9010113          	addi	sp,sp,-880
 302:	36113423          	sd	ra,872(sp)
 306:	36813023          	sd	s0,864(sp)
 30a:	34913c23          	sd	s1,856(sp)
 30e:	35213823          	sd	s2,848(sp)
 312:	35313423          	sd	s3,840(sp)
 316:	35413023          	sd	s4,832(sp)
 31a:	33513c23          	sd	s5,824(sp)
 31e:	1e80                	addi	s0,sp,880
    static char buf[100];
    int fd;

    // Ensure that three file descriptors are open.
    while((fd = open("console", O_RDWR)) >= 0){
 320:	00001497          	auipc	s1,0x1
 324:	88048493          	addi	s1,s1,-1920 # ba0 <malloc+0x13a>
 328:	4589                	li	a1,2
 32a:	8526                	mv	a0,s1
 32c:	00000097          	auipc	ra,0x0
 330:	324080e7          	jalr	804(ra) # 650 <open>
 334:	00054963          	bltz	a0,346 <main+0x48>
        if(fd >= 3){
 338:	4789                	li	a5,2
 33a:	fea7d7e3          	bge	a5,a0,328 <main+0x2a>
            close(fd);
 33e:	00000097          	auipc	ra,0x0
 342:	2fa080e7          	jalr	762(ra) # 638 <close>
            break;
        }
    }

    // Read and run input commands.
    while(getcmd(buf, sizeof(buf)) >= 0){
 346:	00001497          	auipc	s1,0x1
 34a:	8a248493          	addi	s1,s1,-1886 # be8 <buf.0>
        if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
 34e:	06300913          	li	s2,99
 352:	02000993          	li	s3,32
            // Chdir must be called by the parent, not the child.
            buf[strlen(buf)-1] = 0;  // chop \n
            if(chdir(buf+3) < 0)
 356:	00001a17          	auipc	s4,0x1
 35a:	895a0a13          	addi	s4,s4,-1899 # beb <buf.0+0x3>
                fprintf(2, "cannot cd %s\n", buf+3);
 35e:	00001a97          	auipc	s5,0x1
 362:	84aa8a93          	addi	s5,s5,-1974 # ba8 <malloc+0x142>
 366:	a819                	j	37c <main+0x7e>
            continue;
        }
        if(fork() == 0){
 368:	00000097          	auipc	ra,0x0
 36c:	2a0080e7          	jalr	672(ra) # 608 <fork>
 370:	c925                	beqz	a0,3e0 <main+0xe2>
            int argc = -1;
            parsecmd(buf, argv, &argc);
            runcmd(argv, argc);
            exit(0);
        }
        wait(0);
 372:	4501                	li	a0,0
 374:	00000097          	auipc	ra,0x0
 378:	2a4080e7          	jalr	676(ra) # 618 <wait>
    while(getcmd(buf, sizeof(buf)) >= 0){
 37c:	06400593          	li	a1,100
 380:	8526                	mv	a0,s1
 382:	00000097          	auipc	ra,0x0
 386:	e76080e7          	jalr	-394(ra) # 1f8 <getcmd>
 38a:	08054763          	bltz	a0,418 <main+0x11a>
        if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
 38e:	0004c783          	lbu	a5,0(s1)
 392:	fd279be3          	bne	a5,s2,368 <main+0x6a>
 396:	0014c703          	lbu	a4,1(s1)
 39a:	06400793          	li	a5,100
 39e:	fcf715e3          	bne	a4,a5,368 <main+0x6a>
 3a2:	0024c783          	lbu	a5,2(s1)
 3a6:	fd3791e3          	bne	a5,s3,368 <main+0x6a>
            buf[strlen(buf)-1] = 0;  // chop \n
 3aa:	8526                	mv	a0,s1
 3ac:	00000097          	auipc	ra,0x0
 3b0:	0be080e7          	jalr	190(ra) # 46a <strlen>
 3b4:	fff5079b          	addiw	a5,a0,-1
 3b8:	1782                	slli	a5,a5,0x20
 3ba:	9381                	srli	a5,a5,0x20
 3bc:	97a6                	add	a5,a5,s1
 3be:	00078023          	sb	zero,0(a5)
            if(chdir(buf+3) < 0)
 3c2:	8552                	mv	a0,s4
 3c4:	00000097          	auipc	ra,0x0
 3c8:	2bc080e7          	jalr	700(ra) # 680 <chdir>
 3cc:	fa0558e3          	bgez	a0,37c <main+0x7e>
                fprintf(2, "cannot cd %s\n", buf+3);
 3d0:	8652                	mv	a2,s4
 3d2:	85d6                	mv	a1,s5
 3d4:	4509                	li	a0,2
 3d6:	00000097          	auipc	ra,0x0
 3da:	5a4080e7          	jalr	1444(ra) # 97a <fprintf>
 3de:	bf79                	j	37c <main+0x7e>
            int argc = -1;
 3e0:	57fd                	li	a5,-1
 3e2:	c8f42e23          	sw	a5,-868(s0)
            parsecmd(buf, argv, &argc);
 3e6:	c9c40613          	addi	a2,s0,-868
 3ea:	ca040593          	addi	a1,s0,-864
 3ee:	00000517          	auipc	a0,0x0
 3f2:	7fa50513          	addi	a0,a0,2042 # be8 <buf.0>
 3f6:	00000097          	auipc	ra,0x0
 3fa:	e56080e7          	jalr	-426(ra) # 24c <parsecmd>
            runcmd(argv, argc);
 3fe:	c9c42583          	lw	a1,-868(s0)
 402:	ca040513          	addi	a0,s0,-864
 406:	00000097          	auipc	ra,0x0
 40a:	bfa080e7          	jalr	-1030(ra) # 0 <runcmd>
            exit(0);
 40e:	4501                	li	a0,0
 410:	00000097          	auipc	ra,0x0
 414:	200080e7          	jalr	512(ra) # 610 <exit>
    }
    exit(0);
 418:	4501                	li	a0,0
 41a:	00000097          	auipc	ra,0x0
 41e:	1f6080e7          	jalr	502(ra) # 610 <exit>

0000000000000422 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 422:	1141                	addi	sp,sp,-16
 424:	e422                	sd	s0,8(sp)
 426:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 428:	87aa                	mv	a5,a0
 42a:	0585                	addi	a1,a1,1
 42c:	0785                	addi	a5,a5,1
 42e:	fff5c703          	lbu	a4,-1(a1)
 432:	fee78fa3          	sb	a4,-1(a5)
 436:	fb75                	bnez	a4,42a <strcpy+0x8>
    ;
  return os;
}
 438:	6422                	ld	s0,8(sp)
 43a:	0141                	addi	sp,sp,16
 43c:	8082                	ret

000000000000043e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 43e:	1141                	addi	sp,sp,-16
 440:	e422                	sd	s0,8(sp)
 442:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 444:	00054783          	lbu	a5,0(a0)
 448:	cb91                	beqz	a5,45c <strcmp+0x1e>
 44a:	0005c703          	lbu	a4,0(a1)
 44e:	00f71763          	bne	a4,a5,45c <strcmp+0x1e>
    p++, q++;
 452:	0505                	addi	a0,a0,1
 454:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 456:	00054783          	lbu	a5,0(a0)
 45a:	fbe5                	bnez	a5,44a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 45c:	0005c503          	lbu	a0,0(a1)
}
 460:	40a7853b          	subw	a0,a5,a0
 464:	6422                	ld	s0,8(sp)
 466:	0141                	addi	sp,sp,16
 468:	8082                	ret

000000000000046a <strlen>:

uint
strlen(const char *s)
{
 46a:	1141                	addi	sp,sp,-16
 46c:	e422                	sd	s0,8(sp)
 46e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 470:	00054783          	lbu	a5,0(a0)
 474:	cf91                	beqz	a5,490 <strlen+0x26>
 476:	0505                	addi	a0,a0,1
 478:	87aa                	mv	a5,a0
 47a:	4685                	li	a3,1
 47c:	9e89                	subw	a3,a3,a0
 47e:	00f6853b          	addw	a0,a3,a5
 482:	0785                	addi	a5,a5,1
 484:	fff7c703          	lbu	a4,-1(a5)
 488:	fb7d                	bnez	a4,47e <strlen+0x14>
    ;
  return n;
}
 48a:	6422                	ld	s0,8(sp)
 48c:	0141                	addi	sp,sp,16
 48e:	8082                	ret
  for(n = 0; s[n]; n++)
 490:	4501                	li	a0,0
 492:	bfe5                	j	48a <strlen+0x20>

0000000000000494 <memset>:

void*
memset(void *dst, int c, uint n)
{
 494:	1141                	addi	sp,sp,-16
 496:	e422                	sd	s0,8(sp)
 498:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 49a:	ca19                	beqz	a2,4b0 <memset+0x1c>
 49c:	87aa                	mv	a5,a0
 49e:	1602                	slli	a2,a2,0x20
 4a0:	9201                	srli	a2,a2,0x20
 4a2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4a6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4aa:	0785                	addi	a5,a5,1
 4ac:	fee79de3          	bne	a5,a4,4a6 <memset+0x12>
  }
  return dst;
}
 4b0:	6422                	ld	s0,8(sp)
 4b2:	0141                	addi	sp,sp,16
 4b4:	8082                	ret

00000000000004b6 <strchr>:

char*
strchr(const char *s, char c)
{
 4b6:	1141                	addi	sp,sp,-16
 4b8:	e422                	sd	s0,8(sp)
 4ba:	0800                	addi	s0,sp,16
  for(; *s; s++)
 4bc:	00054783          	lbu	a5,0(a0)
 4c0:	cb99                	beqz	a5,4d6 <strchr+0x20>
    if(*s == c)
 4c2:	00f58763          	beq	a1,a5,4d0 <strchr+0x1a>
  for(; *s; s++)
 4c6:	0505                	addi	a0,a0,1
 4c8:	00054783          	lbu	a5,0(a0)
 4cc:	fbfd                	bnez	a5,4c2 <strchr+0xc>
      return (char*)s;
  return 0;
 4ce:	4501                	li	a0,0
}
 4d0:	6422                	ld	s0,8(sp)
 4d2:	0141                	addi	sp,sp,16
 4d4:	8082                	ret
  return 0;
 4d6:	4501                	li	a0,0
 4d8:	bfe5                	j	4d0 <strchr+0x1a>

00000000000004da <gets>:

char*
gets(char *buf, int max)
{
 4da:	711d                	addi	sp,sp,-96
 4dc:	ec86                	sd	ra,88(sp)
 4de:	e8a2                	sd	s0,80(sp)
 4e0:	e4a6                	sd	s1,72(sp)
 4e2:	e0ca                	sd	s2,64(sp)
 4e4:	fc4e                	sd	s3,56(sp)
 4e6:	f852                	sd	s4,48(sp)
 4e8:	f456                	sd	s5,40(sp)
 4ea:	f05a                	sd	s6,32(sp)
 4ec:	ec5e                	sd	s7,24(sp)
 4ee:	1080                	addi	s0,sp,96
 4f0:	8baa                	mv	s7,a0
 4f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4f4:	892a                	mv	s2,a0
 4f6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4f8:	4aa9                	li	s5,10
 4fa:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4fc:	89a6                	mv	s3,s1
 4fe:	2485                	addiw	s1,s1,1
 500:	0344d863          	bge	s1,s4,530 <gets+0x56>
    cc = read(0, &c, 1);
 504:	4605                	li	a2,1
 506:	faf40593          	addi	a1,s0,-81
 50a:	4501                	li	a0,0
 50c:	00000097          	auipc	ra,0x0
 510:	11c080e7          	jalr	284(ra) # 628 <read>
    if(cc < 1)
 514:	00a05e63          	blez	a0,530 <gets+0x56>
    buf[i++] = c;
 518:	faf44783          	lbu	a5,-81(s0)
 51c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 520:	01578763          	beq	a5,s5,52e <gets+0x54>
 524:	0905                	addi	s2,s2,1
 526:	fd679be3          	bne	a5,s6,4fc <gets+0x22>
  for(i=0; i+1 < max; ){
 52a:	89a6                	mv	s3,s1
 52c:	a011                	j	530 <gets+0x56>
 52e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 530:	99de                	add	s3,s3,s7
 532:	00098023          	sb	zero,0(s3)
  return buf;
}
 536:	855e                	mv	a0,s7
 538:	60e6                	ld	ra,88(sp)
 53a:	6446                	ld	s0,80(sp)
 53c:	64a6                	ld	s1,72(sp)
 53e:	6906                	ld	s2,64(sp)
 540:	79e2                	ld	s3,56(sp)
 542:	7a42                	ld	s4,48(sp)
 544:	7aa2                	ld	s5,40(sp)
 546:	7b02                	ld	s6,32(sp)
 548:	6be2                	ld	s7,24(sp)
 54a:	6125                	addi	sp,sp,96
 54c:	8082                	ret

000000000000054e <stat>:

int
stat(const char *n, struct stat *st)
{
 54e:	1101                	addi	sp,sp,-32
 550:	ec06                	sd	ra,24(sp)
 552:	e822                	sd	s0,16(sp)
 554:	e426                	sd	s1,8(sp)
 556:	e04a                	sd	s2,0(sp)
 558:	1000                	addi	s0,sp,32
 55a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 55c:	4581                	li	a1,0
 55e:	00000097          	auipc	ra,0x0
 562:	0f2080e7          	jalr	242(ra) # 650 <open>
  if(fd < 0)
 566:	02054563          	bltz	a0,590 <stat+0x42>
 56a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 56c:	85ca                	mv	a1,s2
 56e:	00000097          	auipc	ra,0x0
 572:	0fa080e7          	jalr	250(ra) # 668 <fstat>
 576:	892a                	mv	s2,a0
  close(fd);
 578:	8526                	mv	a0,s1
 57a:	00000097          	auipc	ra,0x0
 57e:	0be080e7          	jalr	190(ra) # 638 <close>
  return r;
}
 582:	854a                	mv	a0,s2
 584:	60e2                	ld	ra,24(sp)
 586:	6442                	ld	s0,16(sp)
 588:	64a2                	ld	s1,8(sp)
 58a:	6902                	ld	s2,0(sp)
 58c:	6105                	addi	sp,sp,32
 58e:	8082                	ret
    return -1;
 590:	597d                	li	s2,-1
 592:	bfc5                	j	582 <stat+0x34>

0000000000000594 <atoi>:

int
atoi(const char *s)
{
 594:	1141                	addi	sp,sp,-16
 596:	e422                	sd	s0,8(sp)
 598:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 59a:	00054603          	lbu	a2,0(a0)
 59e:	fd06079b          	addiw	a5,a2,-48
 5a2:	0ff7f793          	andi	a5,a5,255
 5a6:	4725                	li	a4,9
 5a8:	02f76963          	bltu	a4,a5,5da <atoi+0x46>
 5ac:	86aa                	mv	a3,a0
  n = 0;
 5ae:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 5b0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 5b2:	0685                	addi	a3,a3,1
 5b4:	0025179b          	slliw	a5,a0,0x2
 5b8:	9fa9                	addw	a5,a5,a0
 5ba:	0017979b          	slliw	a5,a5,0x1
 5be:	9fb1                	addw	a5,a5,a2
 5c0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 5c4:	0006c603          	lbu	a2,0(a3)
 5c8:	fd06071b          	addiw	a4,a2,-48
 5cc:	0ff77713          	andi	a4,a4,255
 5d0:	fee5f1e3          	bgeu	a1,a4,5b2 <atoi+0x1e>
  return n;
}
 5d4:	6422                	ld	s0,8(sp)
 5d6:	0141                	addi	sp,sp,16
 5d8:	8082                	ret
  n = 0;
 5da:	4501                	li	a0,0
 5dc:	bfe5                	j	5d4 <atoi+0x40>

00000000000005de <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5de:	1141                	addi	sp,sp,-16
 5e0:	e422                	sd	s0,8(sp)
 5e2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5e4:	00c05f63          	blez	a2,602 <memmove+0x24>
 5e8:	1602                	slli	a2,a2,0x20
 5ea:	9201                	srli	a2,a2,0x20
 5ec:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 5f0:	87aa                	mv	a5,a0
    *dst++ = *src++;
 5f2:	0585                	addi	a1,a1,1
 5f4:	0785                	addi	a5,a5,1
 5f6:	fff5c703          	lbu	a4,-1(a1)
 5fa:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 5fe:	fed79ae3          	bne	a5,a3,5f2 <memmove+0x14>
  return vdst;
}
 602:	6422                	ld	s0,8(sp)
 604:	0141                	addi	sp,sp,16
 606:	8082                	ret

0000000000000608 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 608:	4885                	li	a7,1
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <exit>:
.global exit
exit:
 li a7, SYS_exit
 610:	4889                	li	a7,2
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <wait>:
.global wait
wait:
 li a7, SYS_wait
 618:	488d                	li	a7,3
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 620:	4891                	li	a7,4
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <read>:
.global read
read:
 li a7, SYS_read
 628:	4895                	li	a7,5
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <write>:
.global write
write:
 li a7, SYS_write
 630:	48c1                	li	a7,16
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <close>:
.global close
close:
 li a7, SYS_close
 638:	48d5                	li	a7,21
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <kill>:
.global kill
kill:
 li a7, SYS_kill
 640:	4899                	li	a7,6
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <exec>:
.global exec
exec:
 li a7, SYS_exec
 648:	489d                	li	a7,7
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <open>:
.global open
open:
 li a7, SYS_open
 650:	48bd                	li	a7,15
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 658:	48c5                	li	a7,17
 ecall
 65a:	00000073          	ecall
 ret
 65e:	8082                	ret

0000000000000660 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 660:	48c9                	li	a7,18
 ecall
 662:	00000073          	ecall
 ret
 666:	8082                	ret

0000000000000668 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 668:	48a1                	li	a7,8
 ecall
 66a:	00000073          	ecall
 ret
 66e:	8082                	ret

0000000000000670 <link>:
.global link
link:
 li a7, SYS_link
 670:	48cd                	li	a7,19
 ecall
 672:	00000073          	ecall
 ret
 676:	8082                	ret

0000000000000678 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 678:	48d1                	li	a7,20
 ecall
 67a:	00000073          	ecall
 ret
 67e:	8082                	ret

0000000000000680 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 680:	48a5                	li	a7,9
 ecall
 682:	00000073          	ecall
 ret
 686:	8082                	ret

0000000000000688 <dup>:
.global dup
dup:
 li a7, SYS_dup
 688:	48a9                	li	a7,10
 ecall
 68a:	00000073          	ecall
 ret
 68e:	8082                	ret

0000000000000690 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 690:	48ad                	li	a7,11
 ecall
 692:	00000073          	ecall
 ret
 696:	8082                	ret

0000000000000698 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 698:	48b1                	li	a7,12
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6a0:	48b5                	li	a7,13
 ecall
 6a2:	00000073          	ecall
 ret
 6a6:	8082                	ret

00000000000006a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6a8:	48b9                	li	a7,14
 ecall
 6aa:	00000073          	ecall
 ret
 6ae:	8082                	ret

00000000000006b0 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 6b0:	48d9                	li	a7,22
 ecall
 6b2:	00000073          	ecall
 ret
 6b6:	8082                	ret

00000000000006b8 <crash>:
.global crash
crash:
 li a7, SYS_crash
 6b8:	48dd                	li	a7,23
 ecall
 6ba:	00000073          	ecall
 ret
 6be:	8082                	ret

00000000000006c0 <mount>:
.global mount
mount:
 li a7, SYS_mount
 6c0:	48e1                	li	a7,24
 ecall
 6c2:	00000073          	ecall
 ret
 6c6:	8082                	ret

00000000000006c8 <umount>:
.global umount
umount:
 li a7, SYS_umount
 6c8:	48e5                	li	a7,25
 ecall
 6ca:	00000073          	ecall
 ret
 6ce:	8082                	ret

00000000000006d0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6d0:	1101                	addi	sp,sp,-32
 6d2:	ec06                	sd	ra,24(sp)
 6d4:	e822                	sd	s0,16(sp)
 6d6:	1000                	addi	s0,sp,32
 6d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6dc:	4605                	li	a2,1
 6de:	fef40593          	addi	a1,s0,-17
 6e2:	00000097          	auipc	ra,0x0
 6e6:	f4e080e7          	jalr	-178(ra) # 630 <write>
}
 6ea:	60e2                	ld	ra,24(sp)
 6ec:	6442                	ld	s0,16(sp)
 6ee:	6105                	addi	sp,sp,32
 6f0:	8082                	ret

00000000000006f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6f2:	7139                	addi	sp,sp,-64
 6f4:	fc06                	sd	ra,56(sp)
 6f6:	f822                	sd	s0,48(sp)
 6f8:	f426                	sd	s1,40(sp)
 6fa:	f04a                	sd	s2,32(sp)
 6fc:	ec4e                	sd	s3,24(sp)
 6fe:	0080                	addi	s0,sp,64
 700:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 702:	c299                	beqz	a3,708 <printint+0x16>
 704:	0805c863          	bltz	a1,794 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 708:	2581                	sext.w	a1,a1
  neg = 0;
 70a:	4881                	li	a7,0
 70c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 710:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 712:	2601                	sext.w	a2,a2
 714:	00000517          	auipc	a0,0x0
 718:	4ac50513          	addi	a0,a0,1196 # bc0 <digits>
 71c:	883a                	mv	a6,a4
 71e:	2705                	addiw	a4,a4,1
 720:	02c5f7bb          	remuw	a5,a1,a2
 724:	1782                	slli	a5,a5,0x20
 726:	9381                	srli	a5,a5,0x20
 728:	97aa                	add	a5,a5,a0
 72a:	0007c783          	lbu	a5,0(a5)
 72e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 732:	0005879b          	sext.w	a5,a1
 736:	02c5d5bb          	divuw	a1,a1,a2
 73a:	0685                	addi	a3,a3,1
 73c:	fec7f0e3          	bgeu	a5,a2,71c <printint+0x2a>
  if(neg)
 740:	00088b63          	beqz	a7,756 <printint+0x64>
    buf[i++] = '-';
 744:	fd040793          	addi	a5,s0,-48
 748:	973e                	add	a4,a4,a5
 74a:	02d00793          	li	a5,45
 74e:	fef70823          	sb	a5,-16(a4)
 752:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 756:	02e05863          	blez	a4,786 <printint+0x94>
 75a:	fc040793          	addi	a5,s0,-64
 75e:	00e78933          	add	s2,a5,a4
 762:	fff78993          	addi	s3,a5,-1
 766:	99ba                	add	s3,s3,a4
 768:	377d                	addiw	a4,a4,-1
 76a:	1702                	slli	a4,a4,0x20
 76c:	9301                	srli	a4,a4,0x20
 76e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 772:	fff94583          	lbu	a1,-1(s2)
 776:	8526                	mv	a0,s1
 778:	00000097          	auipc	ra,0x0
 77c:	f58080e7          	jalr	-168(ra) # 6d0 <putc>
  while(--i >= 0)
 780:	197d                	addi	s2,s2,-1
 782:	ff3918e3          	bne	s2,s3,772 <printint+0x80>
}
 786:	70e2                	ld	ra,56(sp)
 788:	7442                	ld	s0,48(sp)
 78a:	74a2                	ld	s1,40(sp)
 78c:	7902                	ld	s2,32(sp)
 78e:	69e2                	ld	s3,24(sp)
 790:	6121                	addi	sp,sp,64
 792:	8082                	ret
    x = -xx;
 794:	40b005bb          	negw	a1,a1
    neg = 1;
 798:	4885                	li	a7,1
    x = -xx;
 79a:	bf8d                	j	70c <printint+0x1a>

000000000000079c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 79c:	7119                	addi	sp,sp,-128
 79e:	fc86                	sd	ra,120(sp)
 7a0:	f8a2                	sd	s0,112(sp)
 7a2:	f4a6                	sd	s1,104(sp)
 7a4:	f0ca                	sd	s2,96(sp)
 7a6:	ecce                	sd	s3,88(sp)
 7a8:	e8d2                	sd	s4,80(sp)
 7aa:	e4d6                	sd	s5,72(sp)
 7ac:	e0da                	sd	s6,64(sp)
 7ae:	fc5e                	sd	s7,56(sp)
 7b0:	f862                	sd	s8,48(sp)
 7b2:	f466                	sd	s9,40(sp)
 7b4:	f06a                	sd	s10,32(sp)
 7b6:	ec6e                	sd	s11,24(sp)
 7b8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7ba:	0005c903          	lbu	s2,0(a1)
 7be:	18090f63          	beqz	s2,95c <vprintf+0x1c0>
 7c2:	8aaa                	mv	s5,a0
 7c4:	8b32                	mv	s6,a2
 7c6:	00158493          	addi	s1,a1,1
  state = 0;
 7ca:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7cc:	02500a13          	li	s4,37
      if(c == 'd'){
 7d0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 7d4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 7d8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 7dc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e0:	00000b97          	auipc	s7,0x0
 7e4:	3e0b8b93          	addi	s7,s7,992 # bc0 <digits>
 7e8:	a839                	j	806 <vprintf+0x6a>
        putc(fd, c);
 7ea:	85ca                	mv	a1,s2
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	ee2080e7          	jalr	-286(ra) # 6d0 <putc>
 7f6:	a019                	j	7fc <vprintf+0x60>
    } else if(state == '%'){
 7f8:	01498f63          	beq	s3,s4,816 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 7fc:	0485                	addi	s1,s1,1
 7fe:	fff4c903          	lbu	s2,-1(s1)
 802:	14090d63          	beqz	s2,95c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 806:	0009079b          	sext.w	a5,s2
    if(state == 0){
 80a:	fe0997e3          	bnez	s3,7f8 <vprintf+0x5c>
      if(c == '%'){
 80e:	fd479ee3          	bne	a5,s4,7ea <vprintf+0x4e>
        state = '%';
 812:	89be                	mv	s3,a5
 814:	b7e5                	j	7fc <vprintf+0x60>
      if(c == 'd'){
 816:	05878063          	beq	a5,s8,856 <vprintf+0xba>
      } else if(c == 'l') {
 81a:	05978c63          	beq	a5,s9,872 <vprintf+0xd6>
      } else if(c == 'x') {
 81e:	07a78863          	beq	a5,s10,88e <vprintf+0xf2>
      } else if(c == 'p') {
 822:	09b78463          	beq	a5,s11,8aa <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 826:	07300713          	li	a4,115
 82a:	0ce78663          	beq	a5,a4,8f6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 82e:	06300713          	li	a4,99
 832:	0ee78e63          	beq	a5,a4,92e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 836:	11478863          	beq	a5,s4,946 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 83a:	85d2                	mv	a1,s4
 83c:	8556                	mv	a0,s5
 83e:	00000097          	auipc	ra,0x0
 842:	e92080e7          	jalr	-366(ra) # 6d0 <putc>
        putc(fd, c);
 846:	85ca                	mv	a1,s2
 848:	8556                	mv	a0,s5
 84a:	00000097          	auipc	ra,0x0
 84e:	e86080e7          	jalr	-378(ra) # 6d0 <putc>
      }
      state = 0;
 852:	4981                	li	s3,0
 854:	b765                	j	7fc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 856:	008b0913          	addi	s2,s6,8
 85a:	4685                	li	a3,1
 85c:	4629                	li	a2,10
 85e:	000b2583          	lw	a1,0(s6)
 862:	8556                	mv	a0,s5
 864:	00000097          	auipc	ra,0x0
 868:	e8e080e7          	jalr	-370(ra) # 6f2 <printint>
 86c:	8b4a                	mv	s6,s2
      state = 0;
 86e:	4981                	li	s3,0
 870:	b771                	j	7fc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 872:	008b0913          	addi	s2,s6,8
 876:	4681                	li	a3,0
 878:	4629                	li	a2,10
 87a:	000b2583          	lw	a1,0(s6)
 87e:	8556                	mv	a0,s5
 880:	00000097          	auipc	ra,0x0
 884:	e72080e7          	jalr	-398(ra) # 6f2 <printint>
 888:	8b4a                	mv	s6,s2
      state = 0;
 88a:	4981                	li	s3,0
 88c:	bf85                	j	7fc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 88e:	008b0913          	addi	s2,s6,8
 892:	4681                	li	a3,0
 894:	4641                	li	a2,16
 896:	000b2583          	lw	a1,0(s6)
 89a:	8556                	mv	a0,s5
 89c:	00000097          	auipc	ra,0x0
 8a0:	e56080e7          	jalr	-426(ra) # 6f2 <printint>
 8a4:	8b4a                	mv	s6,s2
      state = 0;
 8a6:	4981                	li	s3,0
 8a8:	bf91                	j	7fc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8aa:	008b0793          	addi	a5,s6,8
 8ae:	f8f43423          	sd	a5,-120(s0)
 8b2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8b6:	03000593          	li	a1,48
 8ba:	8556                	mv	a0,s5
 8bc:	00000097          	auipc	ra,0x0
 8c0:	e14080e7          	jalr	-492(ra) # 6d0 <putc>
  putc(fd, 'x');
 8c4:	85ea                	mv	a1,s10
 8c6:	8556                	mv	a0,s5
 8c8:	00000097          	auipc	ra,0x0
 8cc:	e08080e7          	jalr	-504(ra) # 6d0 <putc>
 8d0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8d2:	03c9d793          	srli	a5,s3,0x3c
 8d6:	97de                	add	a5,a5,s7
 8d8:	0007c583          	lbu	a1,0(a5)
 8dc:	8556                	mv	a0,s5
 8de:	00000097          	auipc	ra,0x0
 8e2:	df2080e7          	jalr	-526(ra) # 6d0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8e6:	0992                	slli	s3,s3,0x4
 8e8:	397d                	addiw	s2,s2,-1
 8ea:	fe0914e3          	bnez	s2,8d2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 8ee:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 8f2:	4981                	li	s3,0
 8f4:	b721                	j	7fc <vprintf+0x60>
        s = va_arg(ap, char*);
 8f6:	008b0993          	addi	s3,s6,8
 8fa:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 8fe:	02090163          	beqz	s2,920 <vprintf+0x184>
        while(*s != 0){
 902:	00094583          	lbu	a1,0(s2)
 906:	c9a1                	beqz	a1,956 <vprintf+0x1ba>
          putc(fd, *s);
 908:	8556                	mv	a0,s5
 90a:	00000097          	auipc	ra,0x0
 90e:	dc6080e7          	jalr	-570(ra) # 6d0 <putc>
          s++;
 912:	0905                	addi	s2,s2,1
        while(*s != 0){
 914:	00094583          	lbu	a1,0(s2)
 918:	f9e5                	bnez	a1,908 <vprintf+0x16c>
        s = va_arg(ap, char*);
 91a:	8b4e                	mv	s6,s3
      state = 0;
 91c:	4981                	li	s3,0
 91e:	bdf9                	j	7fc <vprintf+0x60>
          s = "(null)";
 920:	00000917          	auipc	s2,0x0
 924:	29890913          	addi	s2,s2,664 # bb8 <malloc+0x152>
        while(*s != 0){
 928:	02800593          	li	a1,40
 92c:	bff1                	j	908 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 92e:	008b0913          	addi	s2,s6,8
 932:	000b4583          	lbu	a1,0(s6)
 936:	8556                	mv	a0,s5
 938:	00000097          	auipc	ra,0x0
 93c:	d98080e7          	jalr	-616(ra) # 6d0 <putc>
 940:	8b4a                	mv	s6,s2
      state = 0;
 942:	4981                	li	s3,0
 944:	bd65                	j	7fc <vprintf+0x60>
        putc(fd, c);
 946:	85d2                	mv	a1,s4
 948:	8556                	mv	a0,s5
 94a:	00000097          	auipc	ra,0x0
 94e:	d86080e7          	jalr	-634(ra) # 6d0 <putc>
      state = 0;
 952:	4981                	li	s3,0
 954:	b565                	j	7fc <vprintf+0x60>
        s = va_arg(ap, char*);
 956:	8b4e                	mv	s6,s3
      state = 0;
 958:	4981                	li	s3,0
 95a:	b54d                	j	7fc <vprintf+0x60>
    }
  }
}
 95c:	70e6                	ld	ra,120(sp)
 95e:	7446                	ld	s0,112(sp)
 960:	74a6                	ld	s1,104(sp)
 962:	7906                	ld	s2,96(sp)
 964:	69e6                	ld	s3,88(sp)
 966:	6a46                	ld	s4,80(sp)
 968:	6aa6                	ld	s5,72(sp)
 96a:	6b06                	ld	s6,64(sp)
 96c:	7be2                	ld	s7,56(sp)
 96e:	7c42                	ld	s8,48(sp)
 970:	7ca2                	ld	s9,40(sp)
 972:	7d02                	ld	s10,32(sp)
 974:	6de2                	ld	s11,24(sp)
 976:	6109                	addi	sp,sp,128
 978:	8082                	ret

000000000000097a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 97a:	715d                	addi	sp,sp,-80
 97c:	ec06                	sd	ra,24(sp)
 97e:	e822                	sd	s0,16(sp)
 980:	1000                	addi	s0,sp,32
 982:	e010                	sd	a2,0(s0)
 984:	e414                	sd	a3,8(s0)
 986:	e818                	sd	a4,16(s0)
 988:	ec1c                	sd	a5,24(s0)
 98a:	03043023          	sd	a6,32(s0)
 98e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 992:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 996:	8622                	mv	a2,s0
 998:	00000097          	auipc	ra,0x0
 99c:	e04080e7          	jalr	-508(ra) # 79c <vprintf>
}
 9a0:	60e2                	ld	ra,24(sp)
 9a2:	6442                	ld	s0,16(sp)
 9a4:	6161                	addi	sp,sp,80
 9a6:	8082                	ret

00000000000009a8 <printf>:

void
printf(const char *fmt, ...)
{
 9a8:	711d                	addi	sp,sp,-96
 9aa:	ec06                	sd	ra,24(sp)
 9ac:	e822                	sd	s0,16(sp)
 9ae:	1000                	addi	s0,sp,32
 9b0:	e40c                	sd	a1,8(s0)
 9b2:	e810                	sd	a2,16(s0)
 9b4:	ec14                	sd	a3,24(s0)
 9b6:	f018                	sd	a4,32(s0)
 9b8:	f41c                	sd	a5,40(s0)
 9ba:	03043823          	sd	a6,48(s0)
 9be:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9c2:	00840613          	addi	a2,s0,8
 9c6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9ca:	85aa                	mv	a1,a0
 9cc:	4505                	li	a0,1
 9ce:	00000097          	auipc	ra,0x0
 9d2:	dce080e7          	jalr	-562(ra) # 79c <vprintf>
}
 9d6:	60e2                	ld	ra,24(sp)
 9d8:	6442                	ld	s0,16(sp)
 9da:	6125                	addi	sp,sp,96
 9dc:	8082                	ret

00000000000009de <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9de:	1141                	addi	sp,sp,-16
 9e0:	e422                	sd	s0,8(sp)
 9e2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9e4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9e8:	00000797          	auipc	a5,0x0
 9ec:	1f87b783          	ld	a5,504(a5) # be0 <freep>
 9f0:	a805                	j	a20 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9f2:	4618                	lw	a4,8(a2)
 9f4:	9db9                	addw	a1,a1,a4
 9f6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9fa:	6398                	ld	a4,0(a5)
 9fc:	6318                	ld	a4,0(a4)
 9fe:	fee53823          	sd	a4,-16(a0)
 a02:	a091                	j	a46 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a04:	ff852703          	lw	a4,-8(a0)
 a08:	9e39                	addw	a2,a2,a4
 a0a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a0c:	ff053703          	ld	a4,-16(a0)
 a10:	e398                	sd	a4,0(a5)
 a12:	a099                	j	a58 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a14:	6398                	ld	a4,0(a5)
 a16:	00e7e463          	bltu	a5,a4,a1e <free+0x40>
 a1a:	00e6ea63          	bltu	a3,a4,a2e <free+0x50>
{
 a1e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a20:	fed7fae3          	bgeu	a5,a3,a14 <free+0x36>
 a24:	6398                	ld	a4,0(a5)
 a26:	00e6e463          	bltu	a3,a4,a2e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a2a:	fee7eae3          	bltu	a5,a4,a1e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a2e:	ff852583          	lw	a1,-8(a0)
 a32:	6390                	ld	a2,0(a5)
 a34:	02059813          	slli	a6,a1,0x20
 a38:	01c85713          	srli	a4,a6,0x1c
 a3c:	9736                	add	a4,a4,a3
 a3e:	fae60ae3          	beq	a2,a4,9f2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 a42:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a46:	4790                	lw	a2,8(a5)
 a48:	02061593          	slli	a1,a2,0x20
 a4c:	01c5d713          	srli	a4,a1,0x1c
 a50:	973e                	add	a4,a4,a5
 a52:	fae689e3          	beq	a3,a4,a04 <free+0x26>
  } else
    p->s.ptr = bp;
 a56:	e394                	sd	a3,0(a5)
  freep = p;
 a58:	00000717          	auipc	a4,0x0
 a5c:	18f73423          	sd	a5,392(a4) # be0 <freep>
}
 a60:	6422                	ld	s0,8(sp)
 a62:	0141                	addi	sp,sp,16
 a64:	8082                	ret

0000000000000a66 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a66:	7139                	addi	sp,sp,-64
 a68:	fc06                	sd	ra,56(sp)
 a6a:	f822                	sd	s0,48(sp)
 a6c:	f426                	sd	s1,40(sp)
 a6e:	f04a                	sd	s2,32(sp)
 a70:	ec4e                	sd	s3,24(sp)
 a72:	e852                	sd	s4,16(sp)
 a74:	e456                	sd	s5,8(sp)
 a76:	e05a                	sd	s6,0(sp)
 a78:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a7a:	02051493          	slli	s1,a0,0x20
 a7e:	9081                	srli	s1,s1,0x20
 a80:	04bd                	addi	s1,s1,15
 a82:	8091                	srli	s1,s1,0x4
 a84:	0014899b          	addiw	s3,s1,1
 a88:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a8a:	00000517          	auipc	a0,0x0
 a8e:	15653503          	ld	a0,342(a0) # be0 <freep>
 a92:	c515                	beqz	a0,abe <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a94:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a96:	4798                	lw	a4,8(a5)
 a98:	02977f63          	bgeu	a4,s1,ad6 <malloc+0x70>
 a9c:	8a4e                	mv	s4,s3
 a9e:	0009871b          	sext.w	a4,s3
 aa2:	6685                	lui	a3,0x1
 aa4:	00d77363          	bgeu	a4,a3,aaa <malloc+0x44>
 aa8:	6a05                	lui	s4,0x1
 aaa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 aae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ab2:	00000917          	auipc	s2,0x0
 ab6:	12e90913          	addi	s2,s2,302 # be0 <freep>
  if(p == (char*)-1)
 aba:	5afd                	li	s5,-1
 abc:	a895                	j	b30 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 abe:	00000797          	auipc	a5,0x0
 ac2:	19278793          	addi	a5,a5,402 # c50 <base>
 ac6:	00000717          	auipc	a4,0x0
 aca:	10f73d23          	sd	a5,282(a4) # be0 <freep>
 ace:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ad0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ad4:	b7e1                	j	a9c <malloc+0x36>
      if(p->s.size == nunits)
 ad6:	02e48c63          	beq	s1,a4,b0e <malloc+0xa8>
        p->s.size -= nunits;
 ada:	4137073b          	subw	a4,a4,s3
 ade:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ae0:	02071693          	slli	a3,a4,0x20
 ae4:	01c6d713          	srli	a4,a3,0x1c
 ae8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aea:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aee:	00000717          	auipc	a4,0x0
 af2:	0ea73923          	sd	a0,242(a4) # be0 <freep>
      return (void*)(p + 1);
 af6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 afa:	70e2                	ld	ra,56(sp)
 afc:	7442                	ld	s0,48(sp)
 afe:	74a2                	ld	s1,40(sp)
 b00:	7902                	ld	s2,32(sp)
 b02:	69e2                	ld	s3,24(sp)
 b04:	6a42                	ld	s4,16(sp)
 b06:	6aa2                	ld	s5,8(sp)
 b08:	6b02                	ld	s6,0(sp)
 b0a:	6121                	addi	sp,sp,64
 b0c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b0e:	6398                	ld	a4,0(a5)
 b10:	e118                	sd	a4,0(a0)
 b12:	bff1                	j	aee <malloc+0x88>
  hp->s.size = nu;
 b14:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b18:	0541                	addi	a0,a0,16
 b1a:	00000097          	auipc	ra,0x0
 b1e:	ec4080e7          	jalr	-316(ra) # 9de <free>
  return freep;
 b22:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b26:	d971                	beqz	a0,afa <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b28:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b2a:	4798                	lw	a4,8(a5)
 b2c:	fa9775e3          	bgeu	a4,s1,ad6 <malloc+0x70>
    if(p == freep)
 b30:	00093703          	ld	a4,0(s2)
 b34:	853e                	mv	a0,a5
 b36:	fef719e3          	bne	a4,a5,b28 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 b3a:	8552                	mv	a0,s4
 b3c:	00000097          	auipc	ra,0x0
 b40:	b5c080e7          	jalr	-1188(ra) # 698 <sbrk>
  if(p == (char*)-1)
 b44:	fd5518e3          	bne	a0,s5,b14 <malloc+0xae>
        return 0;
 b48:	4501                	li	a0,0
 b4a:	bf45                	j	afa <malloc+0x94>
