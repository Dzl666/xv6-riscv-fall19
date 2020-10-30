
user/_usertests：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <iputtest>:
char *echoargv[] = { "echo", "ALL", "TESTS", "PASSED", 0 };

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  printf("iput test\n");
       8:	00004517          	auipc	a0,0x4
       c:	49050513          	addi	a0,a0,1168 # 4498 <malloc+0x106>
      10:	00004097          	auipc	ra,0x4
      14:	2c4080e7          	jalr	708(ra) # 42d4 <printf>

  if(mkdir("iputdir") < 0){
      18:	00004517          	auipc	a0,0x4
      1c:	49050513          	addi	a0,a0,1168 # 44a8 <malloc+0x116>
      20:	00004097          	auipc	ra,0x4
      24:	f84080e7          	jalr	-124(ra) # 3fa4 <mkdir>
      28:	04054c63          	bltz	a0,80 <iputtest+0x80>
    printf("mkdir failed\n");
    exit();
  }
  if(chdir("iputdir") < 0){
      2c:	00004517          	auipc	a0,0x4
      30:	47c50513          	addi	a0,a0,1148 # 44a8 <malloc+0x116>
      34:	00004097          	auipc	ra,0x4
      38:	f78080e7          	jalr	-136(ra) # 3fac <chdir>
      3c:	04054e63          	bltz	a0,98 <iputtest+0x98>
    printf("chdir iputdir failed\n");
    exit();
  }
  if(unlink("../iputdir") < 0){
      40:	00004517          	auipc	a0,0x4
      44:	49850513          	addi	a0,a0,1176 # 44d8 <malloc+0x146>
      48:	00004097          	auipc	ra,0x4
      4c:	f44080e7          	jalr	-188(ra) # 3f8c <unlink>
      50:	06054063          	bltz	a0,b0 <iputtest+0xb0>
    printf("unlink ../iputdir failed\n");
    exit();
  }
  if(chdir("/") < 0){
      54:	00004517          	auipc	a0,0x4
      58:	4b450513          	addi	a0,a0,1204 # 4508 <malloc+0x176>
      5c:	00004097          	auipc	ra,0x4
      60:	f50080e7          	jalr	-176(ra) # 3fac <chdir>
      64:	06054263          	bltz	a0,c8 <iputtest+0xc8>
    printf("chdir / failed\n");
    exit();
  }
  printf("iput test ok\n");
      68:	00004517          	auipc	a0,0x4
      6c:	4b850513          	addi	a0,a0,1208 # 4520 <malloc+0x18e>
      70:	00004097          	auipc	ra,0x4
      74:	264080e7          	jalr	612(ra) # 42d4 <printf>
}
      78:	60a2                	ld	ra,8(sp)
      7a:	6402                	ld	s0,0(sp)
      7c:	0141                	addi	sp,sp,16
      7e:	8082                	ret
    printf("mkdir failed\n");
      80:	00004517          	auipc	a0,0x4
      84:	43050513          	addi	a0,a0,1072 # 44b0 <malloc+0x11e>
      88:	00004097          	auipc	ra,0x4
      8c:	24c080e7          	jalr	588(ra) # 42d4 <printf>
    exit();
      90:	00004097          	auipc	ra,0x4
      94:	eac080e7          	jalr	-340(ra) # 3f3c <exit>
    printf("chdir iputdir failed\n");
      98:	00004517          	auipc	a0,0x4
      9c:	42850513          	addi	a0,a0,1064 # 44c0 <malloc+0x12e>
      a0:	00004097          	auipc	ra,0x4
      a4:	234080e7          	jalr	564(ra) # 42d4 <printf>
    exit();
      a8:	00004097          	auipc	ra,0x4
      ac:	e94080e7          	jalr	-364(ra) # 3f3c <exit>
    printf("unlink ../iputdir failed\n");
      b0:	00004517          	auipc	a0,0x4
      b4:	43850513          	addi	a0,a0,1080 # 44e8 <malloc+0x156>
      b8:	00004097          	auipc	ra,0x4
      bc:	21c080e7          	jalr	540(ra) # 42d4 <printf>
    exit();
      c0:	00004097          	auipc	ra,0x4
      c4:	e7c080e7          	jalr	-388(ra) # 3f3c <exit>
    printf("chdir / failed\n");
      c8:	00004517          	auipc	a0,0x4
      cc:	44850513          	addi	a0,a0,1096 # 4510 <malloc+0x17e>
      d0:	00004097          	auipc	ra,0x4
      d4:	204080e7          	jalr	516(ra) # 42d4 <printf>
    exit();
      d8:	00004097          	auipc	ra,0x4
      dc:	e64080e7          	jalr	-412(ra) # 3f3c <exit>

00000000000000e0 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      e0:	1141                	addi	sp,sp,-16
      e2:	e406                	sd	ra,8(sp)
      e4:	e022                	sd	s0,0(sp)
      e6:	0800                	addi	s0,sp,16
  int pid;

  printf("exitiput test\n");
      e8:	00004517          	auipc	a0,0x4
      ec:	44850513          	addi	a0,a0,1096 # 4530 <malloc+0x19e>
      f0:	00004097          	auipc	ra,0x4
      f4:	1e4080e7          	jalr	484(ra) # 42d4 <printf>

  pid = fork();
      f8:	00004097          	auipc	ra,0x4
      fc:	e3c080e7          	jalr	-452(ra) # 3f34 <fork>
  if(pid < 0){
     100:	04054563          	bltz	a0,14a <exitiputtest+0x6a>
    printf("fork failed\n");
    exit();
  }
  if(pid == 0){
     104:	e15d                	bnez	a0,1aa <exitiputtest+0xca>
    if(mkdir("iputdir") < 0){
     106:	00004517          	auipc	a0,0x4
     10a:	3a250513          	addi	a0,a0,930 # 44a8 <malloc+0x116>
     10e:	00004097          	auipc	ra,0x4
     112:	e96080e7          	jalr	-362(ra) # 3fa4 <mkdir>
     116:	04054663          	bltz	a0,162 <exitiputtest+0x82>
      printf("mkdir failed\n");
      exit();
    }
    if(chdir("iputdir") < 0){
     11a:	00004517          	auipc	a0,0x4
     11e:	38e50513          	addi	a0,a0,910 # 44a8 <malloc+0x116>
     122:	00004097          	auipc	ra,0x4
     126:	e8a080e7          	jalr	-374(ra) # 3fac <chdir>
     12a:	04054863          	bltz	a0,17a <exitiputtest+0x9a>
      printf("child chdir failed\n");
      exit();
    }
    if(unlink("../iputdir") < 0){
     12e:	00004517          	auipc	a0,0x4
     132:	3aa50513          	addi	a0,a0,938 # 44d8 <malloc+0x146>
     136:	00004097          	auipc	ra,0x4
     13a:	e56080e7          	jalr	-426(ra) # 3f8c <unlink>
     13e:	04054a63          	bltz	a0,192 <exitiputtest+0xb2>
      printf("unlink ../iputdir failed\n");
      exit();
    }
    exit();
     142:	00004097          	auipc	ra,0x4
     146:	dfa080e7          	jalr	-518(ra) # 3f3c <exit>
    printf("fork failed\n");
     14a:	00004517          	auipc	a0,0x4
     14e:	3f650513          	addi	a0,a0,1014 # 4540 <malloc+0x1ae>
     152:	00004097          	auipc	ra,0x4
     156:	182080e7          	jalr	386(ra) # 42d4 <printf>
    exit();
     15a:	00004097          	auipc	ra,0x4
     15e:	de2080e7          	jalr	-542(ra) # 3f3c <exit>
      printf("mkdir failed\n");
     162:	00004517          	auipc	a0,0x4
     166:	34e50513          	addi	a0,a0,846 # 44b0 <malloc+0x11e>
     16a:	00004097          	auipc	ra,0x4
     16e:	16a080e7          	jalr	362(ra) # 42d4 <printf>
      exit();
     172:	00004097          	auipc	ra,0x4
     176:	dca080e7          	jalr	-566(ra) # 3f3c <exit>
      printf("child chdir failed\n");
     17a:	00004517          	auipc	a0,0x4
     17e:	3d650513          	addi	a0,a0,982 # 4550 <malloc+0x1be>
     182:	00004097          	auipc	ra,0x4
     186:	152080e7          	jalr	338(ra) # 42d4 <printf>
      exit();
     18a:	00004097          	auipc	ra,0x4
     18e:	db2080e7          	jalr	-590(ra) # 3f3c <exit>
      printf("unlink ../iputdir failed\n");
     192:	00004517          	auipc	a0,0x4
     196:	35650513          	addi	a0,a0,854 # 44e8 <malloc+0x156>
     19a:	00004097          	auipc	ra,0x4
     19e:	13a080e7          	jalr	314(ra) # 42d4 <printf>
      exit();
     1a2:	00004097          	auipc	ra,0x4
     1a6:	d9a080e7          	jalr	-614(ra) # 3f3c <exit>
  }
  wait();
     1aa:	00004097          	auipc	ra,0x4
     1ae:	d9a080e7          	jalr	-614(ra) # 3f44 <wait>
  printf("exitiput test ok\n");
     1b2:	00004517          	auipc	a0,0x4
     1b6:	3b650513          	addi	a0,a0,950 # 4568 <malloc+0x1d6>
     1ba:	00004097          	auipc	ra,0x4
     1be:	11a080e7          	jalr	282(ra) # 42d4 <printf>
}
     1c2:	60a2                	ld	ra,8(sp)
     1c4:	6402                	ld	s0,0(sp)
     1c6:	0141                	addi	sp,sp,16
     1c8:	8082                	ret

00000000000001ca <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1ca:	1141                	addi	sp,sp,-16
     1cc:	e406                	sd	ra,8(sp)
     1ce:	e022                	sd	s0,0(sp)
     1d0:	0800                	addi	s0,sp,16
  int pid;

  printf("openiput test\n");
     1d2:	00004517          	auipc	a0,0x4
     1d6:	3ae50513          	addi	a0,a0,942 # 4580 <malloc+0x1ee>
     1da:	00004097          	auipc	ra,0x4
     1de:	0fa080e7          	jalr	250(ra) # 42d4 <printf>
  if(mkdir("oidir") < 0){
     1e2:	00004517          	auipc	a0,0x4
     1e6:	3ae50513          	addi	a0,a0,942 # 4590 <malloc+0x1fe>
     1ea:	00004097          	auipc	ra,0x4
     1ee:	dba080e7          	jalr	-582(ra) # 3fa4 <mkdir>
     1f2:	04054063          	bltz	a0,232 <openiputtest+0x68>
    printf("mkdir oidir failed\n");
    exit();
  }
  pid = fork();
     1f6:	00004097          	auipc	ra,0x4
     1fa:	d3e080e7          	jalr	-706(ra) # 3f34 <fork>
  if(pid < 0){
     1fe:	04054663          	bltz	a0,24a <openiputtest+0x80>
    printf("fork failed\n");
    exit();
  }
  if(pid == 0){
     202:	e525                	bnez	a0,26a <openiputtest+0xa0>
    int fd = open("oidir", O_RDWR);
     204:	4589                	li	a1,2
     206:	00004517          	auipc	a0,0x4
     20a:	38a50513          	addi	a0,a0,906 # 4590 <malloc+0x1fe>
     20e:	00004097          	auipc	ra,0x4
     212:	d6e080e7          	jalr	-658(ra) # 3f7c <open>
    if(fd >= 0){
     216:	04054663          	bltz	a0,262 <openiputtest+0x98>
      printf("open directory for write succeeded\n");
     21a:	00004517          	auipc	a0,0x4
     21e:	39650513          	addi	a0,a0,918 # 45b0 <malloc+0x21e>
     222:	00004097          	auipc	ra,0x4
     226:	0b2080e7          	jalr	178(ra) # 42d4 <printf>
      exit();
     22a:	00004097          	auipc	ra,0x4
     22e:	d12080e7          	jalr	-750(ra) # 3f3c <exit>
    printf("mkdir oidir failed\n");
     232:	00004517          	auipc	a0,0x4
     236:	36650513          	addi	a0,a0,870 # 4598 <malloc+0x206>
     23a:	00004097          	auipc	ra,0x4
     23e:	09a080e7          	jalr	154(ra) # 42d4 <printf>
    exit();
     242:	00004097          	auipc	ra,0x4
     246:	cfa080e7          	jalr	-774(ra) # 3f3c <exit>
    printf("fork failed\n");
     24a:	00004517          	auipc	a0,0x4
     24e:	2f650513          	addi	a0,a0,758 # 4540 <malloc+0x1ae>
     252:	00004097          	auipc	ra,0x4
     256:	082080e7          	jalr	130(ra) # 42d4 <printf>
    exit();
     25a:	00004097          	auipc	ra,0x4
     25e:	ce2080e7          	jalr	-798(ra) # 3f3c <exit>
    }
    exit();
     262:	00004097          	auipc	ra,0x4
     266:	cda080e7          	jalr	-806(ra) # 3f3c <exit>
  }
  sleep(1);
     26a:	4505                	li	a0,1
     26c:	00004097          	auipc	ra,0x4
     270:	d60080e7          	jalr	-672(ra) # 3fcc <sleep>
  if(unlink("oidir") != 0){
     274:	00004517          	auipc	a0,0x4
     278:	31c50513          	addi	a0,a0,796 # 4590 <malloc+0x1fe>
     27c:	00004097          	auipc	ra,0x4
     280:	d10080e7          	jalr	-752(ra) # 3f8c <unlink>
     284:	e10d                	bnez	a0,2a6 <openiputtest+0xdc>
    printf("unlink failed\n");
    exit();
  }
  wait();
     286:	00004097          	auipc	ra,0x4
     28a:	cbe080e7          	jalr	-834(ra) # 3f44 <wait>
  printf("openiput test ok\n");
     28e:	00004517          	auipc	a0,0x4
     292:	35a50513          	addi	a0,a0,858 # 45e8 <malloc+0x256>
     296:	00004097          	auipc	ra,0x4
     29a:	03e080e7          	jalr	62(ra) # 42d4 <printf>
}
     29e:	60a2                	ld	ra,8(sp)
     2a0:	6402                	ld	s0,0(sp)
     2a2:	0141                	addi	sp,sp,16
     2a4:	8082                	ret
    printf("unlink failed\n");
     2a6:	00004517          	auipc	a0,0x4
     2aa:	33250513          	addi	a0,a0,818 # 45d8 <malloc+0x246>
     2ae:	00004097          	auipc	ra,0x4
     2b2:	026080e7          	jalr	38(ra) # 42d4 <printf>
    exit();
     2b6:	00004097          	auipc	ra,0x4
     2ba:	c86080e7          	jalr	-890(ra) # 3f3c <exit>

00000000000002be <opentest>:

// simple file system tests

void
opentest(void)
{
     2be:	1141                	addi	sp,sp,-16
     2c0:	e406                	sd	ra,8(sp)
     2c2:	e022                	sd	s0,0(sp)
     2c4:	0800                	addi	s0,sp,16
  int fd;

  printf("open test\n");
     2c6:	00004517          	auipc	a0,0x4
     2ca:	33a50513          	addi	a0,a0,826 # 4600 <malloc+0x26e>
     2ce:	00004097          	auipc	ra,0x4
     2d2:	006080e7          	jalr	6(ra) # 42d4 <printf>
  fd = open("echo", 0);
     2d6:	4581                	li	a1,0
     2d8:	00004517          	auipc	a0,0x4
     2dc:	33850513          	addi	a0,a0,824 # 4610 <malloc+0x27e>
     2e0:	00004097          	auipc	ra,0x4
     2e4:	c9c080e7          	jalr	-868(ra) # 3f7c <open>
  if(fd < 0){
     2e8:	02054d63          	bltz	a0,322 <opentest+0x64>
    printf("open echo failed!\n");
    exit();
  }
  close(fd);
     2ec:	00004097          	auipc	ra,0x4
     2f0:	c78080e7          	jalr	-904(ra) # 3f64 <close>
  fd = open("doesnotexist", 0);
     2f4:	4581                	li	a1,0
     2f6:	00004517          	auipc	a0,0x4
     2fa:	33a50513          	addi	a0,a0,826 # 4630 <malloc+0x29e>
     2fe:	00004097          	auipc	ra,0x4
     302:	c7e080e7          	jalr	-898(ra) # 3f7c <open>
  if(fd >= 0){
     306:	02055a63          	bgez	a0,33a <opentest+0x7c>
    printf("open doesnotexist succeeded!\n");
    exit();
  }
  printf("open test ok\n");
     30a:	00004517          	auipc	a0,0x4
     30e:	35650513          	addi	a0,a0,854 # 4660 <malloc+0x2ce>
     312:	00004097          	auipc	ra,0x4
     316:	fc2080e7          	jalr	-62(ra) # 42d4 <printf>
}
     31a:	60a2                	ld	ra,8(sp)
     31c:	6402                	ld	s0,0(sp)
     31e:	0141                	addi	sp,sp,16
     320:	8082                	ret
    printf("open echo failed!\n");
     322:	00004517          	auipc	a0,0x4
     326:	2f650513          	addi	a0,a0,758 # 4618 <malloc+0x286>
     32a:	00004097          	auipc	ra,0x4
     32e:	faa080e7          	jalr	-86(ra) # 42d4 <printf>
    exit();
     332:	00004097          	auipc	ra,0x4
     336:	c0a080e7          	jalr	-1014(ra) # 3f3c <exit>
    printf("open doesnotexist succeeded!\n");
     33a:	00004517          	auipc	a0,0x4
     33e:	30650513          	addi	a0,a0,774 # 4640 <malloc+0x2ae>
     342:	00004097          	auipc	ra,0x4
     346:	f92080e7          	jalr	-110(ra) # 42d4 <printf>
    exit();
     34a:	00004097          	auipc	ra,0x4
     34e:	bf2080e7          	jalr	-1038(ra) # 3f3c <exit>

0000000000000352 <writetest>:

void
writetest(void)
{
     352:	7139                	addi	sp,sp,-64
     354:	fc06                	sd	ra,56(sp)
     356:	f822                	sd	s0,48(sp)
     358:	f426                	sd	s1,40(sp)
     35a:	f04a                	sd	s2,32(sp)
     35c:	ec4e                	sd	s3,24(sp)
     35e:	e852                	sd	s4,16(sp)
     360:	e456                	sd	s5,8(sp)
     362:	0080                	addi	s0,sp,64
  int fd;
  int i;
  enum { N=100, SZ=10 };
  
  printf("small file test\n");
     364:	00004517          	auipc	a0,0x4
     368:	30c50513          	addi	a0,a0,780 # 4670 <malloc+0x2de>
     36c:	00004097          	auipc	ra,0x4
     370:	f68080e7          	jalr	-152(ra) # 42d4 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     374:	20200593          	li	a1,514
     378:	00004517          	auipc	a0,0x4
     37c:	31050513          	addi	a0,a0,784 # 4688 <malloc+0x2f6>
     380:	00004097          	auipc	ra,0x4
     384:	bfc080e7          	jalr	-1028(ra) # 3f7c <open>
  if(fd >= 0){
     388:	10054563          	bltz	a0,492 <writetest+0x140>
     38c:	892a                	mv	s2,a0
    printf("creat small succeeded; ok\n");
     38e:	00004517          	auipc	a0,0x4
     392:	30250513          	addi	a0,a0,770 # 4690 <malloc+0x2fe>
     396:	00004097          	auipc	ra,0x4
     39a:	f3e080e7          	jalr	-194(ra) # 42d4 <printf>
  } else {
    printf("error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < N; i++){
     39e:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     3a0:	00004997          	auipc	s3,0x4
     3a4:	33098993          	addi	s3,s3,816 # 46d0 <malloc+0x33e>
      printf("error: write aa %d new file failed\n", i);
      exit();
    }
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     3a8:	00004a97          	auipc	s5,0x4
     3ac:	360a8a93          	addi	s5,s5,864 # 4708 <malloc+0x376>
  for(i = 0; i < N; i++){
     3b0:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     3b4:	4629                	li	a2,10
     3b6:	85ce                	mv	a1,s3
     3b8:	854a                	mv	a0,s2
     3ba:	00004097          	auipc	ra,0x4
     3be:	ba2080e7          	jalr	-1118(ra) # 3f5c <write>
     3c2:	47a9                	li	a5,10
     3c4:	0ef51363          	bne	a0,a5,4aa <writetest+0x158>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     3c8:	4629                	li	a2,10
     3ca:	85d6                	mv	a1,s5
     3cc:	854a                	mv	a0,s2
     3ce:	00004097          	auipc	ra,0x4
     3d2:	b8e080e7          	jalr	-1138(ra) # 3f5c <write>
     3d6:	47a9                	li	a5,10
     3d8:	0ef51663          	bne	a0,a5,4c4 <writetest+0x172>
  for(i = 0; i < N; i++){
     3dc:	2485                	addiw	s1,s1,1
     3de:	fd449be3          	bne	s1,s4,3b4 <writetest+0x62>
      printf("error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf("writes ok\n");
     3e2:	00004517          	auipc	a0,0x4
     3e6:	35e50513          	addi	a0,a0,862 # 4740 <malloc+0x3ae>
     3ea:	00004097          	auipc	ra,0x4
     3ee:	eea080e7          	jalr	-278(ra) # 42d4 <printf>
  close(fd);
     3f2:	854a                	mv	a0,s2
     3f4:	00004097          	auipc	ra,0x4
     3f8:	b70080e7          	jalr	-1168(ra) # 3f64 <close>
  fd = open("small", O_RDONLY);
     3fc:	4581                	li	a1,0
     3fe:	00004517          	auipc	a0,0x4
     402:	28a50513          	addi	a0,a0,650 # 4688 <malloc+0x2f6>
     406:	00004097          	auipc	ra,0x4
     40a:	b76080e7          	jalr	-1162(ra) # 3f7c <open>
     40e:	84aa                	mv	s1,a0
  if(fd >= 0){
     410:	0c054763          	bltz	a0,4de <writetest+0x18c>
    printf("open small succeeded ok\n");
     414:	00004517          	auipc	a0,0x4
     418:	33c50513          	addi	a0,a0,828 # 4750 <malloc+0x3be>
     41c:	00004097          	auipc	ra,0x4
     420:	eb8080e7          	jalr	-328(ra) # 42d4 <printf>
  } else {
    printf("error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, N*SZ*2);
     424:	7d000613          	li	a2,2000
     428:	00008597          	auipc	a1,0x8
     42c:	63858593          	addi	a1,a1,1592 # 8a60 <buf>
     430:	8526                	mv	a0,s1
     432:	00004097          	auipc	ra,0x4
     436:	b22080e7          	jalr	-1246(ra) # 3f54 <read>
  if(i == N*SZ*2){
     43a:	7d000793          	li	a5,2000
     43e:	0af51c63          	bne	a0,a5,4f6 <writetest+0x1a4>
    printf("read succeeded ok\n");
     442:	00004517          	auipc	a0,0x4
     446:	34e50513          	addi	a0,a0,846 # 4790 <malloc+0x3fe>
     44a:	00004097          	auipc	ra,0x4
     44e:	e8a080e7          	jalr	-374(ra) # 42d4 <printf>
  } else {
    printf("read failed\n");
    exit();
  }
  close(fd);
     452:	8526                	mv	a0,s1
     454:	00004097          	auipc	ra,0x4
     458:	b10080e7          	jalr	-1264(ra) # 3f64 <close>

  if(unlink("small") < 0){
     45c:	00004517          	auipc	a0,0x4
     460:	22c50513          	addi	a0,a0,556 # 4688 <malloc+0x2f6>
     464:	00004097          	auipc	ra,0x4
     468:	b28080e7          	jalr	-1240(ra) # 3f8c <unlink>
     46c:	0a054163          	bltz	a0,50e <writetest+0x1bc>
    printf("unlink small failed\n");
    exit();
  }
  printf("small file test ok\n");
     470:	00004517          	auipc	a0,0x4
     474:	36050513          	addi	a0,a0,864 # 47d0 <malloc+0x43e>
     478:	00004097          	auipc	ra,0x4
     47c:	e5c080e7          	jalr	-420(ra) # 42d4 <printf>
}
     480:	70e2                	ld	ra,56(sp)
     482:	7442                	ld	s0,48(sp)
     484:	74a2                	ld	s1,40(sp)
     486:	7902                	ld	s2,32(sp)
     488:	69e2                	ld	s3,24(sp)
     48a:	6a42                	ld	s4,16(sp)
     48c:	6aa2                	ld	s5,8(sp)
     48e:	6121                	addi	sp,sp,64
     490:	8082                	ret
    printf("error: creat small failed!\n");
     492:	00004517          	auipc	a0,0x4
     496:	21e50513          	addi	a0,a0,542 # 46b0 <malloc+0x31e>
     49a:	00004097          	auipc	ra,0x4
     49e:	e3a080e7          	jalr	-454(ra) # 42d4 <printf>
    exit();
     4a2:	00004097          	auipc	ra,0x4
     4a6:	a9a080e7          	jalr	-1382(ra) # 3f3c <exit>
      printf("error: write aa %d new file failed\n", i);
     4aa:	85a6                	mv	a1,s1
     4ac:	00004517          	auipc	a0,0x4
     4b0:	23450513          	addi	a0,a0,564 # 46e0 <malloc+0x34e>
     4b4:	00004097          	auipc	ra,0x4
     4b8:	e20080e7          	jalr	-480(ra) # 42d4 <printf>
      exit();
     4bc:	00004097          	auipc	ra,0x4
     4c0:	a80080e7          	jalr	-1408(ra) # 3f3c <exit>
      printf("error: write bb %d new file failed\n", i);
     4c4:	85a6                	mv	a1,s1
     4c6:	00004517          	auipc	a0,0x4
     4ca:	25250513          	addi	a0,a0,594 # 4718 <malloc+0x386>
     4ce:	00004097          	auipc	ra,0x4
     4d2:	e06080e7          	jalr	-506(ra) # 42d4 <printf>
      exit();
     4d6:	00004097          	auipc	ra,0x4
     4da:	a66080e7          	jalr	-1434(ra) # 3f3c <exit>
    printf("error: open small failed!\n");
     4de:	00004517          	auipc	a0,0x4
     4e2:	29250513          	addi	a0,a0,658 # 4770 <malloc+0x3de>
     4e6:	00004097          	auipc	ra,0x4
     4ea:	dee080e7          	jalr	-530(ra) # 42d4 <printf>
    exit();
     4ee:	00004097          	auipc	ra,0x4
     4f2:	a4e080e7          	jalr	-1458(ra) # 3f3c <exit>
    printf("read failed\n");
     4f6:	00004517          	auipc	a0,0x4
     4fa:	2b250513          	addi	a0,a0,690 # 47a8 <malloc+0x416>
     4fe:	00004097          	auipc	ra,0x4
     502:	dd6080e7          	jalr	-554(ra) # 42d4 <printf>
    exit();
     506:	00004097          	auipc	ra,0x4
     50a:	a36080e7          	jalr	-1482(ra) # 3f3c <exit>
    printf("unlink small failed\n");
     50e:	00004517          	auipc	a0,0x4
     512:	2aa50513          	addi	a0,a0,682 # 47b8 <malloc+0x426>
     516:	00004097          	auipc	ra,0x4
     51a:	dbe080e7          	jalr	-578(ra) # 42d4 <printf>
    exit();
     51e:	00004097          	auipc	ra,0x4
     522:	a1e080e7          	jalr	-1506(ra) # 3f3c <exit>

0000000000000526 <writetest1>:

void
writetest1(void)
{
     526:	7179                	addi	sp,sp,-48
     528:	f406                	sd	ra,40(sp)
     52a:	f022                	sd	s0,32(sp)
     52c:	ec26                	sd	s1,24(sp)
     52e:	e84a                	sd	s2,16(sp)
     530:	e44e                	sd	s3,8(sp)
     532:	e052                	sd	s4,0(sp)
     534:	1800                	addi	s0,sp,48
  int i, fd, n;

  printf("big files test\n");
     536:	00004517          	auipc	a0,0x4
     53a:	2b250513          	addi	a0,a0,690 # 47e8 <malloc+0x456>
     53e:	00004097          	auipc	ra,0x4
     542:	d96080e7          	jalr	-618(ra) # 42d4 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     546:	20200593          	li	a1,514
     54a:	00004517          	auipc	a0,0x4
     54e:	2ae50513          	addi	a0,a0,686 # 47f8 <malloc+0x466>
     552:	00004097          	auipc	ra,0x4
     556:	a2a080e7          	jalr	-1494(ra) # 3f7c <open>
     55a:	89aa                	mv	s3,a0
  if(fd < 0){
    printf("error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     55c:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     55e:	00008917          	auipc	s2,0x8
     562:	50290913          	addi	s2,s2,1282 # 8a60 <buf>
  for(i = 0; i < MAXFILE; i++){
     566:	10c00a13          	li	s4,268
  if(fd < 0){
     56a:	06054c63          	bltz	a0,5e2 <writetest1+0xbc>
    ((int*)buf)[0] = i;
     56e:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     572:	40000613          	li	a2,1024
     576:	85ca                	mv	a1,s2
     578:	854e                	mv	a0,s3
     57a:	00004097          	auipc	ra,0x4
     57e:	9e2080e7          	jalr	-1566(ra) # 3f5c <write>
     582:	40000793          	li	a5,1024
     586:	06f51a63          	bne	a0,a5,5fa <writetest1+0xd4>
  for(i = 0; i < MAXFILE; i++){
     58a:	2485                	addiw	s1,s1,1
     58c:	ff4491e3          	bne	s1,s4,56e <writetest1+0x48>
      printf("error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     590:	854e                	mv	a0,s3
     592:	00004097          	auipc	ra,0x4
     596:	9d2080e7          	jalr	-1582(ra) # 3f64 <close>

  fd = open("big", O_RDONLY);
     59a:	4581                	li	a1,0
     59c:	00004517          	auipc	a0,0x4
     5a0:	25c50513          	addi	a0,a0,604 # 47f8 <malloc+0x466>
     5a4:	00004097          	auipc	ra,0x4
     5a8:	9d8080e7          	jalr	-1576(ra) # 3f7c <open>
     5ac:	89aa                	mv	s3,a0
  if(fd < 0){
    printf("error: open big failed!\n");
    exit();
  }

  n = 0;
     5ae:	4481                	li	s1,0
  for(;;){
    i = read(fd, buf, BSIZE);
     5b0:	00008917          	auipc	s2,0x8
     5b4:	4b090913          	addi	s2,s2,1200 # 8a60 <buf>
  if(fd < 0){
     5b8:	04054e63          	bltz	a0,614 <writetest1+0xee>
    i = read(fd, buf, BSIZE);
     5bc:	40000613          	li	a2,1024
     5c0:	85ca                	mv	a1,s2
     5c2:	854e                	mv	a0,s3
     5c4:	00004097          	auipc	ra,0x4
     5c8:	990080e7          	jalr	-1648(ra) # 3f54 <read>
    if(i == 0){
     5cc:	c125                	beqz	a0,62c <writetest1+0x106>
      if(n == MAXFILE - 1){
        printf("read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != BSIZE){
     5ce:	40000793          	li	a5,1024
     5d2:	0af51e63          	bne	a0,a5,68e <writetest1+0x168>
      printf("read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
     5d6:	00092603          	lw	a2,0(s2)
     5da:	0c961763          	bne	a2,s1,6a8 <writetest1+0x182>
      printf("read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
     5de:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     5e0:	bff1                	j	5bc <writetest1+0x96>
    printf("error: creat big failed!\n");
     5e2:	00004517          	auipc	a0,0x4
     5e6:	21e50513          	addi	a0,a0,542 # 4800 <malloc+0x46e>
     5ea:	00004097          	auipc	ra,0x4
     5ee:	cea080e7          	jalr	-790(ra) # 42d4 <printf>
    exit();
     5f2:	00004097          	auipc	ra,0x4
     5f6:	94a080e7          	jalr	-1718(ra) # 3f3c <exit>
      printf("error: write big file failed\n", i);
     5fa:	85a6                	mv	a1,s1
     5fc:	00004517          	auipc	a0,0x4
     600:	22450513          	addi	a0,a0,548 # 4820 <malloc+0x48e>
     604:	00004097          	auipc	ra,0x4
     608:	cd0080e7          	jalr	-816(ra) # 42d4 <printf>
      exit();
     60c:	00004097          	auipc	ra,0x4
     610:	930080e7          	jalr	-1744(ra) # 3f3c <exit>
    printf("error: open big failed!\n");
     614:	00004517          	auipc	a0,0x4
     618:	22c50513          	addi	a0,a0,556 # 4840 <malloc+0x4ae>
     61c:	00004097          	auipc	ra,0x4
     620:	cb8080e7          	jalr	-840(ra) # 42d4 <printf>
    exit();
     624:	00004097          	auipc	ra,0x4
     628:	918080e7          	jalr	-1768(ra) # 3f3c <exit>
      if(n == MAXFILE - 1){
     62c:	10b00793          	li	a5,267
     630:	04f48163          	beq	s1,a5,672 <writetest1+0x14c>
  }
  close(fd);
     634:	854e                	mv	a0,s3
     636:	00004097          	auipc	ra,0x4
     63a:	92e080e7          	jalr	-1746(ra) # 3f64 <close>
  if(unlink("big") < 0){
     63e:	00004517          	auipc	a0,0x4
     642:	1ba50513          	addi	a0,a0,442 # 47f8 <malloc+0x466>
     646:	00004097          	auipc	ra,0x4
     64a:	946080e7          	jalr	-1722(ra) # 3f8c <unlink>
     64e:	06054a63          	bltz	a0,6c2 <writetest1+0x19c>
    printf("unlink big failed\n");
    exit();
  }
  printf("big files ok\n");
     652:	00004517          	auipc	a0,0x4
     656:	27650513          	addi	a0,a0,630 # 48c8 <malloc+0x536>
     65a:	00004097          	auipc	ra,0x4
     65e:	c7a080e7          	jalr	-902(ra) # 42d4 <printf>
}
     662:	70a2                	ld	ra,40(sp)
     664:	7402                	ld	s0,32(sp)
     666:	64e2                	ld	s1,24(sp)
     668:	6942                	ld	s2,16(sp)
     66a:	69a2                	ld	s3,8(sp)
     66c:	6a02                	ld	s4,0(sp)
     66e:	6145                	addi	sp,sp,48
     670:	8082                	ret
        printf("read only %d blocks from big", n);
     672:	10b00593          	li	a1,267
     676:	00004517          	auipc	a0,0x4
     67a:	1ea50513          	addi	a0,a0,490 # 4860 <malloc+0x4ce>
     67e:	00004097          	auipc	ra,0x4
     682:	c56080e7          	jalr	-938(ra) # 42d4 <printf>
        exit();
     686:	00004097          	auipc	ra,0x4
     68a:	8b6080e7          	jalr	-1866(ra) # 3f3c <exit>
      printf("read failed %d\n", i);
     68e:	85aa                	mv	a1,a0
     690:	00004517          	auipc	a0,0x4
     694:	1f050513          	addi	a0,a0,496 # 4880 <malloc+0x4ee>
     698:	00004097          	auipc	ra,0x4
     69c:	c3c080e7          	jalr	-964(ra) # 42d4 <printf>
      exit();
     6a0:	00004097          	auipc	ra,0x4
     6a4:	89c080e7          	jalr	-1892(ra) # 3f3c <exit>
      printf("read content of block %d is %d\n",
     6a8:	85a6                	mv	a1,s1
     6aa:	00004517          	auipc	a0,0x4
     6ae:	1e650513          	addi	a0,a0,486 # 4890 <malloc+0x4fe>
     6b2:	00004097          	auipc	ra,0x4
     6b6:	c22080e7          	jalr	-990(ra) # 42d4 <printf>
      exit();
     6ba:	00004097          	auipc	ra,0x4
     6be:	882080e7          	jalr	-1918(ra) # 3f3c <exit>
    printf("unlink big failed\n");
     6c2:	00004517          	auipc	a0,0x4
     6c6:	1ee50513          	addi	a0,a0,494 # 48b0 <malloc+0x51e>
     6ca:	00004097          	auipc	ra,0x4
     6ce:	c0a080e7          	jalr	-1014(ra) # 42d4 <printf>
    exit();
     6d2:	00004097          	auipc	ra,0x4
     6d6:	86a080e7          	jalr	-1942(ra) # 3f3c <exit>

00000000000006da <createtest>:

void
createtest(void)
{
     6da:	7179                	addi	sp,sp,-48
     6dc:	f406                	sd	ra,40(sp)
     6de:	f022                	sd	s0,32(sp)
     6e0:	ec26                	sd	s1,24(sp)
     6e2:	e84a                	sd	s2,16(sp)
     6e4:	e44e                	sd	s3,8(sp)
     6e6:	1800                	addi	s0,sp,48
  int i, fd;
  enum { N=52 };
  
  printf("many creates, followed by unlink test\n");
     6e8:	00004517          	auipc	a0,0x4
     6ec:	1f050513          	addi	a0,a0,496 # 48d8 <malloc+0x546>
     6f0:	00004097          	auipc	ra,0x4
     6f4:	be4080e7          	jalr	-1052(ra) # 42d4 <printf>

  name[0] = 'a';
     6f8:	00006797          	auipc	a5,0x6
     6fc:	b4878793          	addi	a5,a5,-1208 # 6240 <name>
     700:	06100713          	li	a4,97
     704:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     708:	00078123          	sb	zero,2(a5)
     70c:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
    name[1] = '0' + i;
     710:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     712:	06400993          	li	s3,100
    name[1] = '0' + i;
     716:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
     71a:	20200593          	li	a1,514
     71e:	854a                	mv	a0,s2
     720:	00004097          	auipc	ra,0x4
     724:	85c080e7          	jalr	-1956(ra) # 3f7c <open>
    close(fd);
     728:	00004097          	auipc	ra,0x4
     72c:	83c080e7          	jalr	-1988(ra) # 3f64 <close>
  for(i = 0; i < N; i++){
     730:	2485                	addiw	s1,s1,1
     732:	0ff4f493          	andi	s1,s1,255
     736:	ff3490e3          	bne	s1,s3,716 <createtest+0x3c>
  }
  name[0] = 'a';
     73a:	00006797          	auipc	a5,0x6
     73e:	b0678793          	addi	a5,a5,-1274 # 6240 <name>
     742:	06100713          	li	a4,97
     746:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     74a:	00078123          	sb	zero,2(a5)
     74e:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
    name[1] = '0' + i;
     752:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     754:	06400993          	li	s3,100
    name[1] = '0' + i;
     758:	009900a3          	sb	s1,1(s2)
    unlink(name);
     75c:	854a                	mv	a0,s2
     75e:	00004097          	auipc	ra,0x4
     762:	82e080e7          	jalr	-2002(ra) # 3f8c <unlink>
  for(i = 0; i < N; i++){
     766:	2485                	addiw	s1,s1,1
     768:	0ff4f493          	andi	s1,s1,255
     76c:	ff3496e3          	bne	s1,s3,758 <createtest+0x7e>
  }
  printf("many creates, followed by unlink; ok\n");
     770:	00004517          	auipc	a0,0x4
     774:	19050513          	addi	a0,a0,400 # 4900 <malloc+0x56e>
     778:	00004097          	auipc	ra,0x4
     77c:	b5c080e7          	jalr	-1188(ra) # 42d4 <printf>
}
     780:	70a2                	ld	ra,40(sp)
     782:	7402                	ld	s0,32(sp)
     784:	64e2                	ld	s1,24(sp)
     786:	6942                	ld	s2,16(sp)
     788:	69a2                	ld	s3,8(sp)
     78a:	6145                	addi	sp,sp,48
     78c:	8082                	ret

000000000000078e <dirtest>:

void dirtest(void)
{
     78e:	1141                	addi	sp,sp,-16
     790:	e406                	sd	ra,8(sp)
     792:	e022                	sd	s0,0(sp)
     794:	0800                	addi	s0,sp,16
  printf("mkdir test\n");
     796:	00004517          	auipc	a0,0x4
     79a:	19250513          	addi	a0,a0,402 # 4928 <malloc+0x596>
     79e:	00004097          	auipc	ra,0x4
     7a2:	b36080e7          	jalr	-1226(ra) # 42d4 <printf>

  if(mkdir("dir0") < 0){
     7a6:	00004517          	auipc	a0,0x4
     7aa:	19250513          	addi	a0,a0,402 # 4938 <malloc+0x5a6>
     7ae:	00003097          	auipc	ra,0x3
     7b2:	7f6080e7          	jalr	2038(ra) # 3fa4 <mkdir>
     7b6:	04054c63          	bltz	a0,80e <dirtest+0x80>
    printf("mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0){
     7ba:	00004517          	auipc	a0,0x4
     7be:	17e50513          	addi	a0,a0,382 # 4938 <malloc+0x5a6>
     7c2:	00003097          	auipc	ra,0x3
     7c6:	7ea080e7          	jalr	2026(ra) # 3fac <chdir>
     7ca:	04054e63          	bltz	a0,826 <dirtest+0x98>
    printf("chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0){
     7ce:	00004517          	auipc	a0,0x4
     7d2:	18a50513          	addi	a0,a0,394 # 4958 <malloc+0x5c6>
     7d6:	00003097          	auipc	ra,0x3
     7da:	7d6080e7          	jalr	2006(ra) # 3fac <chdir>
     7de:	06054063          	bltz	a0,83e <dirtest+0xb0>
    printf("chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
     7e2:	00004517          	auipc	a0,0x4
     7e6:	15650513          	addi	a0,a0,342 # 4938 <malloc+0x5a6>
     7ea:	00003097          	auipc	ra,0x3
     7ee:	7a2080e7          	jalr	1954(ra) # 3f8c <unlink>
     7f2:	06054263          	bltz	a0,856 <dirtest+0xc8>
    printf("unlink dir0 failed\n");
    exit();
  }
  printf("mkdir test ok\n");
     7f6:	00004517          	auipc	a0,0x4
     7fa:	19a50513          	addi	a0,a0,410 # 4990 <malloc+0x5fe>
     7fe:	00004097          	auipc	ra,0x4
     802:	ad6080e7          	jalr	-1322(ra) # 42d4 <printf>
}
     806:	60a2                	ld	ra,8(sp)
     808:	6402                	ld	s0,0(sp)
     80a:	0141                	addi	sp,sp,16
     80c:	8082                	ret
    printf("mkdir failed\n");
     80e:	00004517          	auipc	a0,0x4
     812:	ca250513          	addi	a0,a0,-862 # 44b0 <malloc+0x11e>
     816:	00004097          	auipc	ra,0x4
     81a:	abe080e7          	jalr	-1346(ra) # 42d4 <printf>
    exit();
     81e:	00003097          	auipc	ra,0x3
     822:	71e080e7          	jalr	1822(ra) # 3f3c <exit>
    printf("chdir dir0 failed\n");
     826:	00004517          	auipc	a0,0x4
     82a:	11a50513          	addi	a0,a0,282 # 4940 <malloc+0x5ae>
     82e:	00004097          	auipc	ra,0x4
     832:	aa6080e7          	jalr	-1370(ra) # 42d4 <printf>
    exit();
     836:	00003097          	auipc	ra,0x3
     83a:	706080e7          	jalr	1798(ra) # 3f3c <exit>
    printf("chdir .. failed\n");
     83e:	00004517          	auipc	a0,0x4
     842:	12250513          	addi	a0,a0,290 # 4960 <malloc+0x5ce>
     846:	00004097          	auipc	ra,0x4
     84a:	a8e080e7          	jalr	-1394(ra) # 42d4 <printf>
    exit();
     84e:	00003097          	auipc	ra,0x3
     852:	6ee080e7          	jalr	1774(ra) # 3f3c <exit>
    printf("unlink dir0 failed\n");
     856:	00004517          	auipc	a0,0x4
     85a:	12250513          	addi	a0,a0,290 # 4978 <malloc+0x5e6>
     85e:	00004097          	auipc	ra,0x4
     862:	a76080e7          	jalr	-1418(ra) # 42d4 <printf>
    exit();
     866:	00003097          	auipc	ra,0x3
     86a:	6d6080e7          	jalr	1750(ra) # 3f3c <exit>

000000000000086e <exectest>:

void
exectest(void)
{
     86e:	1141                	addi	sp,sp,-16
     870:	e406                	sd	ra,8(sp)
     872:	e022                	sd	s0,0(sp)
     874:	0800                	addi	s0,sp,16
  printf("exec test\n");
     876:	00004517          	auipc	a0,0x4
     87a:	12a50513          	addi	a0,a0,298 # 49a0 <malloc+0x60e>
     87e:	00004097          	auipc	ra,0x4
     882:	a56080e7          	jalr	-1450(ra) # 42d4 <printf>
  if(exec("echo", echoargv) < 0){
     886:	00006597          	auipc	a1,0x6
     88a:	98a58593          	addi	a1,a1,-1654 # 6210 <echoargv>
     88e:	00004517          	auipc	a0,0x4
     892:	d8250513          	addi	a0,a0,-638 # 4610 <malloc+0x27e>
     896:	00003097          	auipc	ra,0x3
     89a:	6de080e7          	jalr	1758(ra) # 3f74 <exec>
     89e:	00054663          	bltz	a0,8aa <exectest+0x3c>
    printf("exec echo failed\n");
    exit();
  }
}
     8a2:	60a2                	ld	ra,8(sp)
     8a4:	6402                	ld	s0,0(sp)
     8a6:	0141                	addi	sp,sp,16
     8a8:	8082                	ret
    printf("exec echo failed\n");
     8aa:	00004517          	auipc	a0,0x4
     8ae:	10650513          	addi	a0,a0,262 # 49b0 <malloc+0x61e>
     8b2:	00004097          	auipc	ra,0x4
     8b6:	a22080e7          	jalr	-1502(ra) # 42d4 <printf>
    exit();
     8ba:	00003097          	auipc	ra,0x3
     8be:	682080e7          	jalr	1666(ra) # 3f3c <exit>

00000000000008c2 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     8c2:	715d                	addi	sp,sp,-80
     8c4:	e486                	sd	ra,72(sp)
     8c6:	e0a2                	sd	s0,64(sp)
     8c8:	fc26                	sd	s1,56(sp)
     8ca:	f84a                	sd	s2,48(sp)
     8cc:	f44e                	sd	s3,40(sp)
     8ce:	f052                	sd	s4,32(sp)
     8d0:	ec56                	sd	s5,24(sp)
     8d2:	e85a                	sd	s6,16(sp)
     8d4:	0880                	addi	s0,sp,80
  int fds[2], pid;
  int seq, i, n, cc, total;
  enum { N=5, SZ=1033 };
  
  if(pipe(fds) != 0){
     8d6:	fb840513          	addi	a0,s0,-72
     8da:	00003097          	auipc	ra,0x3
     8de:	672080e7          	jalr	1650(ra) # 3f4c <pipe>
     8e2:	ed25                	bnez	a0,95a <pipe1+0x98>
     8e4:	84aa                	mv	s1,a0
    printf("pipe() failed\n");
    exit();
  }
  pid = fork();
     8e6:	00003097          	auipc	ra,0x3
     8ea:	64e080e7          	jalr	1614(ra) # 3f34 <fork>
     8ee:	89aa                	mv	s3,a0
  seq = 0;
  if(pid == 0){
     8f0:	c149                	beqz	a0,972 <pipe1+0xb0>
        printf("pipe1 oops 1\n");
        exit();
      }
    }
    exit();
  } else if(pid > 0){
     8f2:	16a05763          	blez	a0,a60 <pipe1+0x19e>
    close(fds[1]);
     8f6:	fbc42503          	lw	a0,-68(s0)
     8fa:	00003097          	auipc	ra,0x3
     8fe:	66a080e7          	jalr	1642(ra) # 3f64 <close>
    total = 0;
     902:	89a6                	mv	s3,s1
    cc = 1;
     904:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
     906:	00008a17          	auipc	s4,0x8
     90a:	15aa0a13          	addi	s4,s4,346 # 8a60 <buf>
          return;
        }
      }
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
     90e:	6a8d                	lui	s5,0x3
    while((n = read(fds[0], buf, cc)) > 0){
     910:	864a                	mv	a2,s2
     912:	85d2                	mv	a1,s4
     914:	fb842503          	lw	a0,-72(s0)
     918:	00003097          	auipc	ra,0x3
     91c:	63c080e7          	jalr	1596(ra) # 3f54 <read>
     920:	0ea05b63          	blez	a0,a16 <pipe1+0x154>
      for(i = 0; i < n; i++){
     924:	00008717          	auipc	a4,0x8
     928:	13c70713          	addi	a4,a4,316 # 8a60 <buf>
     92c:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     930:	00074683          	lbu	a3,0(a4)
     934:	0ff4f793          	andi	a5,s1,255
     938:	2485                	addiw	s1,s1,1
     93a:	0af69c63          	bne	a3,a5,9f2 <pipe1+0x130>
      for(i = 0; i < n; i++){
     93e:	0705                	addi	a4,a4,1
     940:	fec498e3          	bne	s1,a2,930 <pipe1+0x6e>
      total += n;
     944:	00a989bb          	addw	s3,s3,a0
      cc = cc * 2;
     948:	0019179b          	slliw	a5,s2,0x1
     94c:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
     950:	012af363          	bgeu	s5,s2,956 <pipe1+0x94>
        cc = sizeof(buf);
     954:	8956                	mv	s2,s5
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     956:	84b2                	mv	s1,a2
     958:	bf65                	j	910 <pipe1+0x4e>
    printf("pipe() failed\n");
     95a:	00004517          	auipc	a0,0x4
     95e:	06e50513          	addi	a0,a0,110 # 49c8 <malloc+0x636>
     962:	00004097          	auipc	ra,0x4
     966:	972080e7          	jalr	-1678(ra) # 42d4 <printf>
    exit();
     96a:	00003097          	auipc	ra,0x3
     96e:	5d2080e7          	jalr	1490(ra) # 3f3c <exit>
    close(fds[0]);
     972:	fb842503          	lw	a0,-72(s0)
     976:	00003097          	auipc	ra,0x3
     97a:	5ee080e7          	jalr	1518(ra) # 3f64 <close>
    for(n = 0; n < N; n++){
     97e:	00008a97          	auipc	s5,0x8
     982:	0e2a8a93          	addi	s5,s5,226 # 8a60 <buf>
     986:	415004bb          	negw	s1,s5
     98a:	0ff4f493          	andi	s1,s1,255
     98e:	409a8913          	addi	s2,s5,1033
      if(write(fds[1], buf, SZ) != SZ){
     992:	8b56                	mv	s6,s5
    for(n = 0; n < N; n++){
     994:	6a05                	lui	s4,0x1
     996:	42da0a13          	addi	s4,s4,1069 # 142d <fourfiles+0x1cf>
{
     99a:	87d6                	mv	a5,s5
        buf[i] = seq++;
     99c:	0097873b          	addw	a4,a5,s1
     9a0:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
     9a4:	0785                	addi	a5,a5,1
     9a6:	fef91be3          	bne	s2,a5,99c <pipe1+0xda>
        buf[i] = seq++;
     9aa:	4099899b          	addiw	s3,s3,1033
      if(write(fds[1], buf, SZ) != SZ){
     9ae:	40900613          	li	a2,1033
     9b2:	85da                	mv	a1,s6
     9b4:	fbc42503          	lw	a0,-68(s0)
     9b8:	00003097          	auipc	ra,0x3
     9bc:	5a4080e7          	jalr	1444(ra) # 3f5c <write>
     9c0:	40900793          	li	a5,1033
     9c4:	00f51b63          	bne	a0,a5,9da <pipe1+0x118>
    for(n = 0; n < N; n++){
     9c8:	24a5                	addiw	s1,s1,9
     9ca:	0ff4f493          	andi	s1,s1,255
     9ce:	fd4996e3          	bne	s3,s4,99a <pipe1+0xd8>
    exit();
     9d2:	00003097          	auipc	ra,0x3
     9d6:	56a080e7          	jalr	1386(ra) # 3f3c <exit>
        printf("pipe1 oops 1\n");
     9da:	00004517          	auipc	a0,0x4
     9de:	ffe50513          	addi	a0,a0,-2 # 49d8 <malloc+0x646>
     9e2:	00004097          	auipc	ra,0x4
     9e6:	8f2080e7          	jalr	-1806(ra) # 42d4 <printf>
        exit();
     9ea:	00003097          	auipc	ra,0x3
     9ee:	552080e7          	jalr	1362(ra) # 3f3c <exit>
          printf("pipe1 oops 2\n");
     9f2:	00004517          	auipc	a0,0x4
     9f6:	ff650513          	addi	a0,a0,-10 # 49e8 <malloc+0x656>
     9fa:	00004097          	auipc	ra,0x4
     9fe:	8da080e7          	jalr	-1830(ra) # 42d4 <printf>
  } else {
    printf("fork() failed\n");
    exit();
  }
  printf("pipe1 ok\n");
}
     a02:	60a6                	ld	ra,72(sp)
     a04:	6406                	ld	s0,64(sp)
     a06:	74e2                	ld	s1,56(sp)
     a08:	7942                	ld	s2,48(sp)
     a0a:	79a2                	ld	s3,40(sp)
     a0c:	7a02                	ld	s4,32(sp)
     a0e:	6ae2                	ld	s5,24(sp)
     a10:	6b42                	ld	s6,16(sp)
     a12:	6161                	addi	sp,sp,80
     a14:	8082                	ret
    if(total != N * SZ){
     a16:	6785                	lui	a5,0x1
     a18:	42d78793          	addi	a5,a5,1069 # 142d <fourfiles+0x1cf>
     a1c:	02f99563          	bne	s3,a5,a46 <pipe1+0x184>
    close(fds[0]);
     a20:	fb842503          	lw	a0,-72(s0)
     a24:	00003097          	auipc	ra,0x3
     a28:	540080e7          	jalr	1344(ra) # 3f64 <close>
    wait();
     a2c:	00003097          	auipc	ra,0x3
     a30:	518080e7          	jalr	1304(ra) # 3f44 <wait>
  printf("pipe1 ok\n");
     a34:	00004517          	auipc	a0,0x4
     a38:	fdc50513          	addi	a0,a0,-36 # 4a10 <malloc+0x67e>
     a3c:	00004097          	auipc	ra,0x4
     a40:	898080e7          	jalr	-1896(ra) # 42d4 <printf>
     a44:	bf7d                	j	a02 <pipe1+0x140>
      printf("pipe1 oops 3 total %d\n", total);
     a46:	85ce                	mv	a1,s3
     a48:	00004517          	auipc	a0,0x4
     a4c:	fb050513          	addi	a0,a0,-80 # 49f8 <malloc+0x666>
     a50:	00004097          	auipc	ra,0x4
     a54:	884080e7          	jalr	-1916(ra) # 42d4 <printf>
      exit();
     a58:	00003097          	auipc	ra,0x3
     a5c:	4e4080e7          	jalr	1252(ra) # 3f3c <exit>
    printf("fork() failed\n");
     a60:	00004517          	auipc	a0,0x4
     a64:	fc050513          	addi	a0,a0,-64 # 4a20 <malloc+0x68e>
     a68:	00004097          	auipc	ra,0x4
     a6c:	86c080e7          	jalr	-1940(ra) # 42d4 <printf>
    exit();
     a70:	00003097          	auipc	ra,0x3
     a74:	4cc080e7          	jalr	1228(ra) # 3f3c <exit>

0000000000000a78 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     a78:	7139                	addi	sp,sp,-64
     a7a:	fc06                	sd	ra,56(sp)
     a7c:	f822                	sd	s0,48(sp)
     a7e:	f426                	sd	s1,40(sp)
     a80:	f04a                	sd	s2,32(sp)
     a82:	ec4e                	sd	s3,24(sp)
     a84:	0080                	addi	s0,sp,64
  int pid1, pid2, pid3;
  int pfds[2];

  printf("preempt: ");
     a86:	00004517          	auipc	a0,0x4
     a8a:	faa50513          	addi	a0,a0,-86 # 4a30 <malloc+0x69e>
     a8e:	00004097          	auipc	ra,0x4
     a92:	846080e7          	jalr	-1978(ra) # 42d4 <printf>
  pid1 = fork();
     a96:	00003097          	auipc	ra,0x3
     a9a:	49e080e7          	jalr	1182(ra) # 3f34 <fork>
  if(pid1 < 0) {
     a9e:	00054563          	bltz	a0,aa8 <preempt+0x30>
     aa2:	84aa                	mv	s1,a0
    printf("fork failed");
    exit();
  }
  if(pid1 == 0)
     aa4:	ed11                	bnez	a0,ac0 <preempt+0x48>
    for(;;)
     aa6:	a001                	j	aa6 <preempt+0x2e>
    printf("fork failed");
     aa8:	00004517          	auipc	a0,0x4
     aac:	f9850513          	addi	a0,a0,-104 # 4a40 <malloc+0x6ae>
     ab0:	00004097          	auipc	ra,0x4
     ab4:	824080e7          	jalr	-2012(ra) # 42d4 <printf>
    exit();
     ab8:	00003097          	auipc	ra,0x3
     abc:	484080e7          	jalr	1156(ra) # 3f3c <exit>
      ;

  pid2 = fork();
     ac0:	00003097          	auipc	ra,0x3
     ac4:	474080e7          	jalr	1140(ra) # 3f34 <fork>
     ac8:	892a                	mv	s2,a0
  if(pid2 < 0) {
     aca:	00054463          	bltz	a0,ad2 <preempt+0x5a>
    printf("fork failed\n");
    exit();
  }
  if(pid2 == 0)
     ace:	ed11                	bnez	a0,aea <preempt+0x72>
    for(;;)
     ad0:	a001                	j	ad0 <preempt+0x58>
    printf("fork failed\n");
     ad2:	00004517          	auipc	a0,0x4
     ad6:	a6e50513          	addi	a0,a0,-1426 # 4540 <malloc+0x1ae>
     ada:	00003097          	auipc	ra,0x3
     ade:	7fa080e7          	jalr	2042(ra) # 42d4 <printf>
    exit();
     ae2:	00003097          	auipc	ra,0x3
     ae6:	45a080e7          	jalr	1114(ra) # 3f3c <exit>
      ;

  pipe(pfds);
     aea:	fc840513          	addi	a0,s0,-56
     aee:	00003097          	auipc	ra,0x3
     af2:	45e080e7          	jalr	1118(ra) # 3f4c <pipe>
  pid3 = fork();
     af6:	00003097          	auipc	ra,0x3
     afa:	43e080e7          	jalr	1086(ra) # 3f34 <fork>
     afe:	89aa                	mv	s3,a0
  if(pid3 < 0) {
     b00:	02054e63          	bltz	a0,b3c <preempt+0xc4>
     printf("fork failed\n");
     exit();
  }
  if(pid3 == 0){
     b04:	e12d                	bnez	a0,b66 <preempt+0xee>
    close(pfds[0]);
     b06:	fc842503          	lw	a0,-56(s0)
     b0a:	00003097          	auipc	ra,0x3
     b0e:	45a080e7          	jalr	1114(ra) # 3f64 <close>
    if(write(pfds[1], "x", 1) != 1)
     b12:	4605                	li	a2,1
     b14:	00004597          	auipc	a1,0x4
     b18:	f3c58593          	addi	a1,a1,-196 # 4a50 <malloc+0x6be>
     b1c:	fcc42503          	lw	a0,-52(s0)
     b20:	00003097          	auipc	ra,0x3
     b24:	43c080e7          	jalr	1084(ra) # 3f5c <write>
     b28:	4785                	li	a5,1
     b2a:	02f51563          	bne	a0,a5,b54 <preempt+0xdc>
      printf("preempt write error");
    close(pfds[1]);
     b2e:	fcc42503          	lw	a0,-52(s0)
     b32:	00003097          	auipc	ra,0x3
     b36:	432080e7          	jalr	1074(ra) # 3f64 <close>
    for(;;)
     b3a:	a001                	j	b3a <preempt+0xc2>
     printf("fork failed\n");
     b3c:	00004517          	auipc	a0,0x4
     b40:	a0450513          	addi	a0,a0,-1532 # 4540 <malloc+0x1ae>
     b44:	00003097          	auipc	ra,0x3
     b48:	790080e7          	jalr	1936(ra) # 42d4 <printf>
     exit();
     b4c:	00003097          	auipc	ra,0x3
     b50:	3f0080e7          	jalr	1008(ra) # 3f3c <exit>
      printf("preempt write error");
     b54:	00004517          	auipc	a0,0x4
     b58:	f0450513          	addi	a0,a0,-252 # 4a58 <malloc+0x6c6>
     b5c:	00003097          	auipc	ra,0x3
     b60:	778080e7          	jalr	1912(ra) # 42d4 <printf>
     b64:	b7e9                	j	b2e <preempt+0xb6>
      ;
  }

  close(pfds[1]);
     b66:	fcc42503          	lw	a0,-52(s0)
     b6a:	00003097          	auipc	ra,0x3
     b6e:	3fa080e7          	jalr	1018(ra) # 3f64 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     b72:	660d                	lui	a2,0x3
     b74:	00008597          	auipc	a1,0x8
     b78:	eec58593          	addi	a1,a1,-276 # 8a60 <buf>
     b7c:	fc842503          	lw	a0,-56(s0)
     b80:	00003097          	auipc	ra,0x3
     b84:	3d4080e7          	jalr	980(ra) # 3f54 <read>
     b88:	4785                	li	a5,1
     b8a:	02f50163          	beq	a0,a5,bac <preempt+0x134>
    printf("preempt read error");
     b8e:	00004517          	auipc	a0,0x4
     b92:	ee250513          	addi	a0,a0,-286 # 4a70 <malloc+0x6de>
     b96:	00003097          	auipc	ra,0x3
     b9a:	73e080e7          	jalr	1854(ra) # 42d4 <printf>
  printf("wait... ");
  wait();
  wait();
  wait();
  printf("preempt ok\n");
}
     b9e:	70e2                	ld	ra,56(sp)
     ba0:	7442                	ld	s0,48(sp)
     ba2:	74a2                	ld	s1,40(sp)
     ba4:	7902                	ld	s2,32(sp)
     ba6:	69e2                	ld	s3,24(sp)
     ba8:	6121                	addi	sp,sp,64
     baa:	8082                	ret
  close(pfds[0]);
     bac:	fc842503          	lw	a0,-56(s0)
     bb0:	00003097          	auipc	ra,0x3
     bb4:	3b4080e7          	jalr	948(ra) # 3f64 <close>
  printf("kill... ");
     bb8:	00004517          	auipc	a0,0x4
     bbc:	ed050513          	addi	a0,a0,-304 # 4a88 <malloc+0x6f6>
     bc0:	00003097          	auipc	ra,0x3
     bc4:	714080e7          	jalr	1812(ra) # 42d4 <printf>
  kill(pid1);
     bc8:	8526                	mv	a0,s1
     bca:	00003097          	auipc	ra,0x3
     bce:	3a2080e7          	jalr	930(ra) # 3f6c <kill>
  kill(pid2);
     bd2:	854a                	mv	a0,s2
     bd4:	00003097          	auipc	ra,0x3
     bd8:	398080e7          	jalr	920(ra) # 3f6c <kill>
  kill(pid3);
     bdc:	854e                	mv	a0,s3
     bde:	00003097          	auipc	ra,0x3
     be2:	38e080e7          	jalr	910(ra) # 3f6c <kill>
  printf("wait... ");
     be6:	00004517          	auipc	a0,0x4
     bea:	eb250513          	addi	a0,a0,-334 # 4a98 <malloc+0x706>
     bee:	00003097          	auipc	ra,0x3
     bf2:	6e6080e7          	jalr	1766(ra) # 42d4 <printf>
  wait();
     bf6:	00003097          	auipc	ra,0x3
     bfa:	34e080e7          	jalr	846(ra) # 3f44 <wait>
  wait();
     bfe:	00003097          	auipc	ra,0x3
     c02:	346080e7          	jalr	838(ra) # 3f44 <wait>
  wait();
     c06:	00003097          	auipc	ra,0x3
     c0a:	33e080e7          	jalr	830(ra) # 3f44 <wait>
  printf("preempt ok\n");
     c0e:	00004517          	auipc	a0,0x4
     c12:	e9a50513          	addi	a0,a0,-358 # 4aa8 <malloc+0x716>
     c16:	00003097          	auipc	ra,0x3
     c1a:	6be080e7          	jalr	1726(ra) # 42d4 <printf>
     c1e:	b741                	j	b9e <preempt+0x126>

0000000000000c20 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     c20:	1101                	addi	sp,sp,-32
     c22:	ec06                	sd	ra,24(sp)
     c24:	e822                	sd	s0,16(sp)
     c26:	e426                	sd	s1,8(sp)
     c28:	e04a                	sd	s2,0(sp)
     c2a:	1000                	addi	s0,sp,32
  int i, pid;

  printf("exitwait test\n");
     c2c:	00004517          	auipc	a0,0x4
     c30:	e8c50513          	addi	a0,a0,-372 # 4ab8 <malloc+0x726>
     c34:	00003097          	auipc	ra,0x3
     c38:	6a0080e7          	jalr	1696(ra) # 42d4 <printf>
     c3c:	06400913          	li	s2,100

  for(i = 0; i < 100; i++){
    pid = fork();
     c40:	00003097          	auipc	ra,0x3
     c44:	2f4080e7          	jalr	756(ra) # 3f34 <fork>
     c48:	84aa                	mv	s1,a0
    if(pid < 0){
     c4a:	02054a63          	bltz	a0,c7e <exitwait+0x5e>
      printf("fork failed\n");
      exit();
    }
    if(pid){
     c4e:	c125                	beqz	a0,cae <exitwait+0x8e>
      if(wait() != pid){
     c50:	00003097          	auipc	ra,0x3
     c54:	2f4080e7          	jalr	756(ra) # 3f44 <wait>
     c58:	02951f63          	bne	a0,s1,c96 <exitwait+0x76>
  for(i = 0; i < 100; i++){
     c5c:	397d                	addiw	s2,s2,-1
     c5e:	fe0911e3          	bnez	s2,c40 <exitwait+0x20>
      }
    } else {
      exit();
    }
  }
  printf("exitwait ok\n");
     c62:	00004517          	auipc	a0,0x4
     c66:	e7650513          	addi	a0,a0,-394 # 4ad8 <malloc+0x746>
     c6a:	00003097          	auipc	ra,0x3
     c6e:	66a080e7          	jalr	1642(ra) # 42d4 <printf>
}
     c72:	60e2                	ld	ra,24(sp)
     c74:	6442                	ld	s0,16(sp)
     c76:	64a2                	ld	s1,8(sp)
     c78:	6902                	ld	s2,0(sp)
     c7a:	6105                	addi	sp,sp,32
     c7c:	8082                	ret
      printf("fork failed\n");
     c7e:	00004517          	auipc	a0,0x4
     c82:	8c250513          	addi	a0,a0,-1854 # 4540 <malloc+0x1ae>
     c86:	00003097          	auipc	ra,0x3
     c8a:	64e080e7          	jalr	1614(ra) # 42d4 <printf>
      exit();
     c8e:	00003097          	auipc	ra,0x3
     c92:	2ae080e7          	jalr	686(ra) # 3f3c <exit>
        printf("wait wrong pid\n");
     c96:	00004517          	auipc	a0,0x4
     c9a:	e3250513          	addi	a0,a0,-462 # 4ac8 <malloc+0x736>
     c9e:	00003097          	auipc	ra,0x3
     ca2:	636080e7          	jalr	1590(ra) # 42d4 <printf>
        exit();
     ca6:	00003097          	auipc	ra,0x3
     caa:	296080e7          	jalr	662(ra) # 3f3c <exit>
      exit();
     cae:	00003097          	auipc	ra,0x3
     cb2:	28e080e7          	jalr	654(ra) # 3f3c <exit>

0000000000000cb6 <reparent>:
// try to find races in the reparenting
// code that handles a parent exiting
// when it still has live children.
void
reparent(void)
{
     cb6:	7179                	addi	sp,sp,-48
     cb8:	f406                	sd	ra,40(sp)
     cba:	f022                	sd	s0,32(sp)
     cbc:	ec26                	sd	s1,24(sp)
     cbe:	e84a                	sd	s2,16(sp)
     cc0:	e44e                	sd	s3,8(sp)
     cc2:	1800                	addi	s0,sp,48
  int master_pid = getpid();
     cc4:	00003097          	auipc	ra,0x3
     cc8:	2f8080e7          	jalr	760(ra) # 3fbc <getpid>
     ccc:	89aa                	mv	s3,a0
  
  printf("reparent test\n");
     cce:	00004517          	auipc	a0,0x4
     cd2:	e1a50513          	addi	a0,a0,-486 # 4ae8 <malloc+0x756>
     cd6:	00003097          	auipc	ra,0x3
     cda:	5fe080e7          	jalr	1534(ra) # 42d4 <printf>
     cde:	0c800913          	li	s2,200

  for(int i = 0; i < 200; i++){
    int pid = fork();
     ce2:	00003097          	auipc	ra,0x3
     ce6:	252080e7          	jalr	594(ra) # 3f34 <fork>
     cea:	84aa                	mv	s1,a0
    if(pid < 0){
     cec:	02054b63          	bltz	a0,d22 <reparent+0x6c>
      printf("fork failed\n");
      exit();
    }
    if(pid){
     cf0:	c12d                	beqz	a0,d52 <reparent+0x9c>
      if(wait() != pid){
     cf2:	00003097          	auipc	ra,0x3
     cf6:	252080e7          	jalr	594(ra) # 3f44 <wait>
     cfa:	04951063          	bne	a0,s1,d3a <reparent+0x84>
  for(int i = 0; i < 200; i++){
     cfe:	397d                	addiw	s2,s2,-1
     d00:	fe0911e3          	bnez	s2,ce2 <reparent+0x2c>
      } else {
        exit();
      }
    }
  }
  printf("reparent ok\n");
     d04:	00004517          	auipc	a0,0x4
     d08:	df450513          	addi	a0,a0,-524 # 4af8 <malloc+0x766>
     d0c:	00003097          	auipc	ra,0x3
     d10:	5c8080e7          	jalr	1480(ra) # 42d4 <printf>
}
     d14:	70a2                	ld	ra,40(sp)
     d16:	7402                	ld	s0,32(sp)
     d18:	64e2                	ld	s1,24(sp)
     d1a:	6942                	ld	s2,16(sp)
     d1c:	69a2                	ld	s3,8(sp)
     d1e:	6145                	addi	sp,sp,48
     d20:	8082                	ret
      printf("fork failed\n");
     d22:	00004517          	auipc	a0,0x4
     d26:	81e50513          	addi	a0,a0,-2018 # 4540 <malloc+0x1ae>
     d2a:	00003097          	auipc	ra,0x3
     d2e:	5aa080e7          	jalr	1450(ra) # 42d4 <printf>
      exit();
     d32:	00003097          	auipc	ra,0x3
     d36:	20a080e7          	jalr	522(ra) # 3f3c <exit>
        printf("wait wrong pid\n");
     d3a:	00004517          	auipc	a0,0x4
     d3e:	d8e50513          	addi	a0,a0,-626 # 4ac8 <malloc+0x736>
     d42:	00003097          	auipc	ra,0x3
     d46:	592080e7          	jalr	1426(ra) # 42d4 <printf>
        exit();
     d4a:	00003097          	auipc	ra,0x3
     d4e:	1f2080e7          	jalr	498(ra) # 3f3c <exit>
      int pid2 = fork();
     d52:	00003097          	auipc	ra,0x3
     d56:	1e2080e7          	jalr	482(ra) # 3f34 <fork>
      if(pid2 < 0){
     d5a:	00054763          	bltz	a0,d68 <reparent+0xb2>
      if(pid2 == 0){
     d5e:	e515                	bnez	a0,d8a <reparent+0xd4>
        exit();
     d60:	00003097          	auipc	ra,0x3
     d64:	1dc080e7          	jalr	476(ra) # 3f3c <exit>
        printf("fork failed\n");
     d68:	00003517          	auipc	a0,0x3
     d6c:	7d850513          	addi	a0,a0,2008 # 4540 <malloc+0x1ae>
     d70:	00003097          	auipc	ra,0x3
     d74:	564080e7          	jalr	1380(ra) # 42d4 <printf>
        kill(master_pid);
     d78:	854e                	mv	a0,s3
     d7a:	00003097          	auipc	ra,0x3
     d7e:	1f2080e7          	jalr	498(ra) # 3f6c <kill>
        exit();
     d82:	00003097          	auipc	ra,0x3
     d86:	1ba080e7          	jalr	442(ra) # 3f3c <exit>
        exit();
     d8a:	00003097          	auipc	ra,0x3
     d8e:	1b2080e7          	jalr	434(ra) # 3f3c <exit>

0000000000000d92 <twochildren>:

// what if two children exit() at the same time?
void
twochildren(void)
{
     d92:	1101                	addi	sp,sp,-32
     d94:	ec06                	sd	ra,24(sp)
     d96:	e822                	sd	s0,16(sp)
     d98:	e426                	sd	s1,8(sp)
     d9a:	1000                	addi	s0,sp,32
  printf("twochildren test\n");
     d9c:	00004517          	auipc	a0,0x4
     da0:	d6c50513          	addi	a0,a0,-660 # 4b08 <malloc+0x776>
     da4:	00003097          	auipc	ra,0x3
     da8:	530080e7          	jalr	1328(ra) # 42d4 <printf>
     dac:	3e800493          	li	s1,1000

  for(int i = 0; i < 1000; i++){
    int pid1 = fork();
     db0:	00003097          	auipc	ra,0x3
     db4:	184080e7          	jalr	388(ra) # 3f34 <fork>
    if(pid1 < 0){
     db8:	04054163          	bltz	a0,dfa <twochildren+0x68>
      printf("fork failed\n");
      exit();
    }
    if(pid1 == 0){
     dbc:	c939                	beqz	a0,e12 <twochildren+0x80>
      exit();
    } else {
      int pid2 = fork();
     dbe:	00003097          	auipc	ra,0x3
     dc2:	176080e7          	jalr	374(ra) # 3f34 <fork>
      if(pid2 < 0){
     dc6:	04054a63          	bltz	a0,e1a <twochildren+0x88>
        printf("fork failed\n");
        exit();
      }
      if(pid2 == 0){
     dca:	c525                	beqz	a0,e32 <twochildren+0xa0>
        exit();
      } else {
        wait();
     dcc:	00003097          	auipc	ra,0x3
     dd0:	178080e7          	jalr	376(ra) # 3f44 <wait>
        wait();
     dd4:	00003097          	auipc	ra,0x3
     dd8:	170080e7          	jalr	368(ra) # 3f44 <wait>
  for(int i = 0; i < 1000; i++){
     ddc:	34fd                	addiw	s1,s1,-1
     dde:	f8e9                	bnez	s1,db0 <twochildren+0x1e>
      }
    }
  }
  printf("twochildren ok\n");
     de0:	00004517          	auipc	a0,0x4
     de4:	d4050513          	addi	a0,a0,-704 # 4b20 <malloc+0x78e>
     de8:	00003097          	auipc	ra,0x3
     dec:	4ec080e7          	jalr	1260(ra) # 42d4 <printf>
}
     df0:	60e2                	ld	ra,24(sp)
     df2:	6442                	ld	s0,16(sp)
     df4:	64a2                	ld	s1,8(sp)
     df6:	6105                	addi	sp,sp,32
     df8:	8082                	ret
      printf("fork failed\n");
     dfa:	00003517          	auipc	a0,0x3
     dfe:	74650513          	addi	a0,a0,1862 # 4540 <malloc+0x1ae>
     e02:	00003097          	auipc	ra,0x3
     e06:	4d2080e7          	jalr	1234(ra) # 42d4 <printf>
      exit();
     e0a:	00003097          	auipc	ra,0x3
     e0e:	132080e7          	jalr	306(ra) # 3f3c <exit>
      exit();
     e12:	00003097          	auipc	ra,0x3
     e16:	12a080e7          	jalr	298(ra) # 3f3c <exit>
        printf("fork failed\n");
     e1a:	00003517          	auipc	a0,0x3
     e1e:	72650513          	addi	a0,a0,1830 # 4540 <malloc+0x1ae>
     e22:	00003097          	auipc	ra,0x3
     e26:	4b2080e7          	jalr	1202(ra) # 42d4 <printf>
        exit();
     e2a:	00003097          	auipc	ra,0x3
     e2e:	112080e7          	jalr	274(ra) # 3f3c <exit>
        exit();
     e32:	00003097          	auipc	ra,0x3
     e36:	10a080e7          	jalr	266(ra) # 3f3c <exit>

0000000000000e3a <forkfork>:

// concurrent forks to try to expose locking bugs.
void
forkfork(void)
{
     e3a:	1101                	addi	sp,sp,-32
     e3c:	ec06                	sd	ra,24(sp)
     e3e:	e822                	sd	s0,16(sp)
     e40:	e426                	sd	s1,8(sp)
     e42:	e04a                	sd	s2,0(sp)
     e44:	1000                	addi	s0,sp,32
  int ppid = getpid();
     e46:	00003097          	auipc	ra,0x3
     e4a:	176080e7          	jalr	374(ra) # 3fbc <getpid>
     e4e:	892a                	mv	s2,a0
  enum { N=2 };
  
  printf("forkfork test\n");
     e50:	00004517          	auipc	a0,0x4
     e54:	ce050513          	addi	a0,a0,-800 # 4b30 <malloc+0x79e>
     e58:	00003097          	auipc	ra,0x3
     e5c:	47c080e7          	jalr	1148(ra) # 42d4 <printf>

  for(int i = 0; i < N; i++){
    int pid = fork();
     e60:	00003097          	auipc	ra,0x3
     e64:	0d4080e7          	jalr	212(ra) # 3f34 <fork>
    if(pid < 0){
     e68:	04054063          	bltz	a0,ea8 <forkfork+0x6e>
      printf("fork failed");
      exit();
    }
    if(pid == 0){
     e6c:	c931                	beqz	a0,ec0 <forkfork+0x86>
    int pid = fork();
     e6e:	00003097          	auipc	ra,0x3
     e72:	0c6080e7          	jalr	198(ra) # 3f34 <fork>
    if(pid < 0){
     e76:	02054963          	bltz	a0,ea8 <forkfork+0x6e>
    if(pid == 0){
     e7a:	c139                	beqz	a0,ec0 <forkfork+0x86>
      exit();
    }
  }

  for(int i = 0; i < N; i++){
    wait();
     e7c:	00003097          	auipc	ra,0x3
     e80:	0c8080e7          	jalr	200(ra) # 3f44 <wait>
     e84:	00003097          	auipc	ra,0x3
     e88:	0c0080e7          	jalr	192(ra) # 3f44 <wait>
  }

  printf("forkfork ok\n");
     e8c:	00004517          	auipc	a0,0x4
     e90:	cb450513          	addi	a0,a0,-844 # 4b40 <malloc+0x7ae>
     e94:	00003097          	auipc	ra,0x3
     e98:	440080e7          	jalr	1088(ra) # 42d4 <printf>
}
     e9c:	60e2                	ld	ra,24(sp)
     e9e:	6442                	ld	s0,16(sp)
     ea0:	64a2                	ld	s1,8(sp)
     ea2:	6902                	ld	s2,0(sp)
     ea4:	6105                	addi	sp,sp,32
     ea6:	8082                	ret
      printf("fork failed");
     ea8:	00004517          	auipc	a0,0x4
     eac:	b9850513          	addi	a0,a0,-1128 # 4a40 <malloc+0x6ae>
     eb0:	00003097          	auipc	ra,0x3
     eb4:	424080e7          	jalr	1060(ra) # 42d4 <printf>
      exit();
     eb8:	00003097          	auipc	ra,0x3
     ebc:	084080e7          	jalr	132(ra) # 3f3c <exit>
{
     ec0:	0c800493          	li	s1,200
        int pid1 = fork();
     ec4:	00003097          	auipc	ra,0x3
     ec8:	070080e7          	jalr	112(ra) # 3f34 <fork>
        if(pid1 < 0){
     ecc:	00054d63          	bltz	a0,ee6 <forkfork+0xac>
        if(pid1 == 0){
     ed0:	cd05                	beqz	a0,f08 <forkfork+0xce>
        wait();
     ed2:	00003097          	auipc	ra,0x3
     ed6:	072080e7          	jalr	114(ra) # 3f44 <wait>
      for(int j = 0; j < 200; j++){
     eda:	34fd                	addiw	s1,s1,-1
     edc:	f4e5                	bnez	s1,ec4 <forkfork+0x8a>
      exit();
     ede:	00003097          	auipc	ra,0x3
     ee2:	05e080e7          	jalr	94(ra) # 3f3c <exit>
          printf("fork failed\n");
     ee6:	00003517          	auipc	a0,0x3
     eea:	65a50513          	addi	a0,a0,1626 # 4540 <malloc+0x1ae>
     eee:	00003097          	auipc	ra,0x3
     ef2:	3e6080e7          	jalr	998(ra) # 42d4 <printf>
          kill(ppid);
     ef6:	854a                	mv	a0,s2
     ef8:	00003097          	auipc	ra,0x3
     efc:	074080e7          	jalr	116(ra) # 3f6c <kill>
          exit();
     f00:	00003097          	auipc	ra,0x3
     f04:	03c080e7          	jalr	60(ra) # 3f3c <exit>
          exit();
     f08:	00003097          	auipc	ra,0x3
     f0c:	034080e7          	jalr	52(ra) # 3f3c <exit>

0000000000000f10 <forkforkfork>:

void
forkforkfork(void)
{
     f10:	1101                	addi	sp,sp,-32
     f12:	ec06                	sd	ra,24(sp)
     f14:	e822                	sd	s0,16(sp)
     f16:	e426                	sd	s1,8(sp)
     f18:	1000                	addi	s0,sp,32
  printf("forkforkfork test\n");
     f1a:	00004517          	auipc	a0,0x4
     f1e:	c3650513          	addi	a0,a0,-970 # 4b50 <malloc+0x7be>
     f22:	00003097          	auipc	ra,0x3
     f26:	3b2080e7          	jalr	946(ra) # 42d4 <printf>

  unlink("stopforking");
     f2a:	00004517          	auipc	a0,0x4
     f2e:	c3e50513          	addi	a0,a0,-962 # 4b68 <malloc+0x7d6>
     f32:	00003097          	auipc	ra,0x3
     f36:	05a080e7          	jalr	90(ra) # 3f8c <unlink>

  int pid = fork();
     f3a:	00003097          	auipc	ra,0x3
     f3e:	ffa080e7          	jalr	-6(ra) # 3f34 <fork>
  if(pid < 0){
     f42:	04054c63          	bltz	a0,f9a <forkforkfork+0x8a>
    printf("fork failed");
    exit();
  }
  if(pid == 0){
     f46:	c535                	beqz	a0,fb2 <forkforkfork+0xa2>
    }

    exit();
  }

  sleep(20); // two seconds
     f48:	4551                	li	a0,20
     f4a:	00003097          	auipc	ra,0x3
     f4e:	082080e7          	jalr	130(ra) # 3fcc <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
     f52:	20200593          	li	a1,514
     f56:	00004517          	auipc	a0,0x4
     f5a:	c1250513          	addi	a0,a0,-1006 # 4b68 <malloc+0x7d6>
     f5e:	00003097          	auipc	ra,0x3
     f62:	01e080e7          	jalr	30(ra) # 3f7c <open>
     f66:	00003097          	auipc	ra,0x3
     f6a:	ffe080e7          	jalr	-2(ra) # 3f64 <close>
  wait();
     f6e:	00003097          	auipc	ra,0x3
     f72:	fd6080e7          	jalr	-42(ra) # 3f44 <wait>
  sleep(10); // one second
     f76:	4529                	li	a0,10
     f78:	00003097          	auipc	ra,0x3
     f7c:	054080e7          	jalr	84(ra) # 3fcc <sleep>

  printf("forkforkfork ok\n");
     f80:	00004517          	auipc	a0,0x4
     f84:	bf850513          	addi	a0,a0,-1032 # 4b78 <malloc+0x7e6>
     f88:	00003097          	auipc	ra,0x3
     f8c:	34c080e7          	jalr	844(ra) # 42d4 <printf>
}
     f90:	60e2                	ld	ra,24(sp)
     f92:	6442                	ld	s0,16(sp)
     f94:	64a2                	ld	s1,8(sp)
     f96:	6105                	addi	sp,sp,32
     f98:	8082                	ret
    printf("fork failed");
     f9a:	00004517          	auipc	a0,0x4
     f9e:	aa650513          	addi	a0,a0,-1370 # 4a40 <malloc+0x6ae>
     fa2:	00003097          	auipc	ra,0x3
     fa6:	332080e7          	jalr	818(ra) # 42d4 <printf>
    exit();
     faa:	00003097          	auipc	ra,0x3
     fae:	f92080e7          	jalr	-110(ra) # 3f3c <exit>
      int fd = open("stopforking", 0);
     fb2:	00004497          	auipc	s1,0x4
     fb6:	bb648493          	addi	s1,s1,-1098 # 4b68 <malloc+0x7d6>
     fba:	4581                	li	a1,0
     fbc:	8526                	mv	a0,s1
     fbe:	00003097          	auipc	ra,0x3
     fc2:	fbe080e7          	jalr	-66(ra) # 3f7c <open>
      if(fd >= 0){
     fc6:	02055463          	bgez	a0,fee <forkforkfork+0xde>
      if(fork() < 0){
     fca:	00003097          	auipc	ra,0x3
     fce:	f6a080e7          	jalr	-150(ra) # 3f34 <fork>
     fd2:	fe0554e3          	bgez	a0,fba <forkforkfork+0xaa>
        close(open("stopforking", O_CREATE|O_RDWR));
     fd6:	20200593          	li	a1,514
     fda:	8526                	mv	a0,s1
     fdc:	00003097          	auipc	ra,0x3
     fe0:	fa0080e7          	jalr	-96(ra) # 3f7c <open>
     fe4:	00003097          	auipc	ra,0x3
     fe8:	f80080e7          	jalr	-128(ra) # 3f64 <close>
     fec:	b7f9                	j	fba <forkforkfork+0xaa>
        exit();
     fee:	00003097          	auipc	ra,0x3
     ff2:	f4e080e7          	jalr	-178(ra) # 3f3c <exit>

0000000000000ff6 <mem>:

void
mem(void)
{
     ff6:	7179                	addi	sp,sp,-48
     ff8:	f406                	sd	ra,40(sp)
     ffa:	f022                	sd	s0,32(sp)
     ffc:	ec26                	sd	s1,24(sp)
     ffe:	e84a                	sd	s2,16(sp)
    1000:	e44e                	sd	s3,8(sp)
    1002:	1800                	addi	s0,sp,48
  void *m1, *m2;
  int pid, ppid;

  printf("mem test\n");
    1004:	00004517          	auipc	a0,0x4
    1008:	b8c50513          	addi	a0,a0,-1140 # 4b90 <malloc+0x7fe>
    100c:	00003097          	auipc	ra,0x3
    1010:	2c8080e7          	jalr	712(ra) # 42d4 <printf>
  ppid = getpid();
    1014:	00003097          	auipc	ra,0x3
    1018:	fa8080e7          	jalr	-88(ra) # 3fbc <getpid>
    101c:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    101e:	00003097          	auipc	ra,0x3
    1022:	f16080e7          	jalr	-234(ra) # 3f34 <fork>
    m1 = 0;
    1026:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    1028:	6909                	lui	s2,0x2
    102a:	71190913          	addi	s2,s2,1809 # 2711 <subdir+0x6cf>
  if((pid = fork()) == 0){
    102e:	cd11                	beqz	a0,104a <mem+0x54>
    }
    free(m1);
    printf("mem ok\n");
    exit();
  } else {
    wait();
    1030:	00003097          	auipc	ra,0x3
    1034:	f14080e7          	jalr	-236(ra) # 3f44 <wait>
  }
}
    1038:	70a2                	ld	ra,40(sp)
    103a:	7402                	ld	s0,32(sp)
    103c:	64e2                	ld	s1,24(sp)
    103e:	6942                	ld	s2,16(sp)
    1040:	69a2                	ld	s3,8(sp)
    1042:	6145                	addi	sp,sp,48
    1044:	8082                	ret
      *(char**)m2 = m1;
    1046:	e104                	sd	s1,0(a0)
      m1 = m2;
    1048:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    104a:	854a                	mv	a0,s2
    104c:	00003097          	auipc	ra,0x3
    1050:	346080e7          	jalr	838(ra) # 4392 <malloc>
    1054:	f96d                	bnez	a0,1046 <mem+0x50>
    while(m1){
    1056:	c881                	beqz	s1,1066 <mem+0x70>
      m2 = *(char**)m1;
    1058:	8526                	mv	a0,s1
    105a:	6084                	ld	s1,0(s1)
      free(m1);
    105c:	00003097          	auipc	ra,0x3
    1060:	2ae080e7          	jalr	686(ra) # 430a <free>
    while(m1){
    1064:	f8f5                	bnez	s1,1058 <mem+0x62>
    m1 = malloc(1024*20);
    1066:	6515                	lui	a0,0x5
    1068:	00003097          	auipc	ra,0x3
    106c:	32a080e7          	jalr	810(ra) # 4392 <malloc>
    if(m1 == 0){
    1070:	c10d                	beqz	a0,1092 <mem+0x9c>
    free(m1);
    1072:	00003097          	auipc	ra,0x3
    1076:	298080e7          	jalr	664(ra) # 430a <free>
    printf("mem ok\n");
    107a:	00004517          	auipc	a0,0x4
    107e:	b4650513          	addi	a0,a0,-1210 # 4bc0 <malloc+0x82e>
    1082:	00003097          	auipc	ra,0x3
    1086:	252080e7          	jalr	594(ra) # 42d4 <printf>
    exit();
    108a:	00003097          	auipc	ra,0x3
    108e:	eb2080e7          	jalr	-334(ra) # 3f3c <exit>
      printf("couldn't allocate mem?!!\n");
    1092:	00004517          	auipc	a0,0x4
    1096:	b0e50513          	addi	a0,a0,-1266 # 4ba0 <malloc+0x80e>
    109a:	00003097          	auipc	ra,0x3
    109e:	23a080e7          	jalr	570(ra) # 42d4 <printf>
      kill(ppid);
    10a2:	854e                	mv	a0,s3
    10a4:	00003097          	auipc	ra,0x3
    10a8:	ec8080e7          	jalr	-312(ra) # 3f6c <kill>
      exit();
    10ac:	00003097          	auipc	ra,0x3
    10b0:	e90080e7          	jalr	-368(ra) # 3f3c <exit>

00000000000010b4 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
    10b4:	715d                	addi	sp,sp,-80
    10b6:	e486                	sd	ra,72(sp)
    10b8:	e0a2                	sd	s0,64(sp)
    10ba:	fc26                	sd	s1,56(sp)
    10bc:	f84a                	sd	s2,48(sp)
    10be:	f44e                	sd	s3,40(sp)
    10c0:	f052                	sd	s4,32(sp)
    10c2:	ec56                	sd	s5,24(sp)
    10c4:	e85a                	sd	s6,16(sp)
    10c6:	0880                	addi	s0,sp,80
  int fd, pid, i, n, nc, np;
  enum { N = 1000, SZ=10};
  char buf[SZ];

  printf("sharedfd test\n");
    10c8:	00004517          	auipc	a0,0x4
    10cc:	b0050513          	addi	a0,a0,-1280 # 4bc8 <malloc+0x836>
    10d0:	00003097          	auipc	ra,0x3
    10d4:	204080e7          	jalr	516(ra) # 42d4 <printf>

  unlink("sharedfd");
    10d8:	00004517          	auipc	a0,0x4
    10dc:	b0050513          	addi	a0,a0,-1280 # 4bd8 <malloc+0x846>
    10e0:	00003097          	auipc	ra,0x3
    10e4:	eac080e7          	jalr	-340(ra) # 3f8c <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    10e8:	20200593          	li	a1,514
    10ec:	00004517          	auipc	a0,0x4
    10f0:	aec50513          	addi	a0,a0,-1300 # 4bd8 <malloc+0x846>
    10f4:	00003097          	auipc	ra,0x3
    10f8:	e88080e7          	jalr	-376(ra) # 3f7c <open>
  if(fd < 0){
    10fc:	04054463          	bltz	a0,1144 <sharedfd+0x90>
    1100:	892a                	mv	s2,a0
    printf("fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
    1102:	00003097          	auipc	ra,0x3
    1106:	e32080e7          	jalr	-462(ra) # 3f34 <fork>
    110a:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    110c:	06300593          	li	a1,99
    1110:	c119                	beqz	a0,1116 <sharedfd+0x62>
    1112:	07000593          	li	a1,112
    1116:	4629                	li	a2,10
    1118:	fb040513          	addi	a0,s0,-80
    111c:	00003097          	auipc	ra,0x3
    1120:	ca4080e7          	jalr	-860(ra) # 3dc0 <memset>
    1124:	3e800493          	li	s1,1000
  for(i = 0; i < N; i++){
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    1128:	4629                	li	a2,10
    112a:	fb040593          	addi	a1,s0,-80
    112e:	854a                	mv	a0,s2
    1130:	00003097          	auipc	ra,0x3
    1134:	e2c080e7          	jalr	-468(ra) # 3f5c <write>
    1138:	47a9                	li	a5,10
    113a:	00f51e63          	bne	a0,a5,1156 <sharedfd+0xa2>
  for(i = 0; i < N; i++){
    113e:	34fd                	addiw	s1,s1,-1
    1140:	f4e5                	bnez	s1,1128 <sharedfd+0x74>
    1142:	a015                	j	1166 <sharedfd+0xb2>
    printf("fstests: cannot open sharedfd for writing");
    1144:	00004517          	auipc	a0,0x4
    1148:	aa450513          	addi	a0,a0,-1372 # 4be8 <malloc+0x856>
    114c:	00003097          	auipc	ra,0x3
    1150:	188080e7          	jalr	392(ra) # 42d4 <printf>
    return;
    1154:	a8e9                	j	122e <sharedfd+0x17a>
      printf("fstests: write sharedfd failed\n");
    1156:	00004517          	auipc	a0,0x4
    115a:	ac250513          	addi	a0,a0,-1342 # 4c18 <malloc+0x886>
    115e:	00003097          	auipc	ra,0x3
    1162:	176080e7          	jalr	374(ra) # 42d4 <printf>
      break;
    }
  }
  if(pid == 0)
    1166:	04098c63          	beqz	s3,11be <sharedfd+0x10a>
    exit();
  else
    wait();
    116a:	00003097          	auipc	ra,0x3
    116e:	dda080e7          	jalr	-550(ra) # 3f44 <wait>
  close(fd);
    1172:	854a                	mv	a0,s2
    1174:	00003097          	auipc	ra,0x3
    1178:	df0080e7          	jalr	-528(ra) # 3f64 <close>
  fd = open("sharedfd", 0);
    117c:	4581                	li	a1,0
    117e:	00004517          	auipc	a0,0x4
    1182:	a5a50513          	addi	a0,a0,-1446 # 4bd8 <malloc+0x846>
    1186:	00003097          	auipc	ra,0x3
    118a:	df6080e7          	jalr	-522(ra) # 3f7c <open>
    118e:	8b2a                	mv	s6,a0
  if(fd < 0){
    printf("fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
    1190:	4a01                	li	s4,0
    1192:	4981                	li	s3,0
  if(fd < 0){
    1194:	02054963          	bltz	a0,11c6 <sharedfd+0x112>
    1198:	fba40913          	addi	s2,s0,-70
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
      if(buf[i] == 'c')
    119c:	06300493          	li	s1,99
        nc++;
      if(buf[i] == 'p')
    11a0:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    11a4:	4629                	li	a2,10
    11a6:	fb040593          	addi	a1,s0,-80
    11aa:	855a                	mv	a0,s6
    11ac:	00003097          	auipc	ra,0x3
    11b0:	da8080e7          	jalr	-600(ra) # 3f54 <read>
    11b4:	02a05e63          	blez	a0,11f0 <sharedfd+0x13c>
    11b8:	fb040793          	addi	a5,s0,-80
    11bc:	a015                	j	11e0 <sharedfd+0x12c>
    exit();
    11be:	00003097          	auipc	ra,0x3
    11c2:	d7e080e7          	jalr	-642(ra) # 3f3c <exit>
    printf("fstests: cannot open sharedfd for reading\n");
    11c6:	00004517          	auipc	a0,0x4
    11ca:	a7250513          	addi	a0,a0,-1422 # 4c38 <malloc+0x8a6>
    11ce:	00003097          	auipc	ra,0x3
    11d2:	106080e7          	jalr	262(ra) # 42d4 <printf>
    return;
    11d6:	a8a1                	j	122e <sharedfd+0x17a>
        nc++;
    11d8:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    11da:	0785                	addi	a5,a5,1
    11dc:	fd2784e3          	beq	a5,s2,11a4 <sharedfd+0xf0>
      if(buf[i] == 'c')
    11e0:	0007c703          	lbu	a4,0(a5)
    11e4:	fe970ae3          	beq	a4,s1,11d8 <sharedfd+0x124>
      if(buf[i] == 'p')
    11e8:	ff5719e3          	bne	a4,s5,11da <sharedfd+0x126>
        np++;
    11ec:	2a05                	addiw	s4,s4,1
    11ee:	b7f5                	j	11da <sharedfd+0x126>
    }
  }
  close(fd);
    11f0:	855a                	mv	a0,s6
    11f2:	00003097          	auipc	ra,0x3
    11f6:	d72080e7          	jalr	-654(ra) # 3f64 <close>
  unlink("sharedfd");
    11fa:	00004517          	auipc	a0,0x4
    11fe:	9de50513          	addi	a0,a0,-1570 # 4bd8 <malloc+0x846>
    1202:	00003097          	auipc	ra,0x3
    1206:	d8a080e7          	jalr	-630(ra) # 3f8c <unlink>
  if(nc == N*SZ && np == N*SZ){
    120a:	6789                	lui	a5,0x2
    120c:	71078793          	addi	a5,a5,1808 # 2710 <subdir+0x6ce>
    1210:	02f99963          	bne	s3,a5,1242 <sharedfd+0x18e>
    1214:	6789                	lui	a5,0x2
    1216:	71078793          	addi	a5,a5,1808 # 2710 <subdir+0x6ce>
    121a:	02fa1463          	bne	s4,a5,1242 <sharedfd+0x18e>
    printf("sharedfd ok\n");
    121e:	00004517          	auipc	a0,0x4
    1222:	a4a50513          	addi	a0,a0,-1462 # 4c68 <malloc+0x8d6>
    1226:	00003097          	auipc	ra,0x3
    122a:	0ae080e7          	jalr	174(ra) # 42d4 <printf>
  } else {
    printf("sharedfd oops %d %d\n", nc, np);
    exit();
  }
}
    122e:	60a6                	ld	ra,72(sp)
    1230:	6406                	ld	s0,64(sp)
    1232:	74e2                	ld	s1,56(sp)
    1234:	7942                	ld	s2,48(sp)
    1236:	79a2                	ld	s3,40(sp)
    1238:	7a02                	ld	s4,32(sp)
    123a:	6ae2                	ld	s5,24(sp)
    123c:	6b42                	ld	s6,16(sp)
    123e:	6161                	addi	sp,sp,80
    1240:	8082                	ret
    printf("sharedfd oops %d %d\n", nc, np);
    1242:	8652                	mv	a2,s4
    1244:	85ce                	mv	a1,s3
    1246:	00004517          	auipc	a0,0x4
    124a:	a3250513          	addi	a0,a0,-1486 # 4c78 <malloc+0x8e6>
    124e:	00003097          	auipc	ra,0x3
    1252:	086080e7          	jalr	134(ra) # 42d4 <printf>
    exit();
    1256:	00003097          	auipc	ra,0x3
    125a:	ce6080e7          	jalr	-794(ra) # 3f3c <exit>

000000000000125e <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    125e:	7119                	addi	sp,sp,-128
    1260:	fc86                	sd	ra,120(sp)
    1262:	f8a2                	sd	s0,112(sp)
    1264:	f4a6                	sd	s1,104(sp)
    1266:	f0ca                	sd	s2,96(sp)
    1268:	ecce                	sd	s3,88(sp)
    126a:	e8d2                	sd	s4,80(sp)
    126c:	e4d6                	sd	s5,72(sp)
    126e:	e0da                	sd	s6,64(sp)
    1270:	fc5e                	sd	s7,56(sp)
    1272:	f862                	sd	s8,48(sp)
    1274:	f466                	sd	s9,40(sp)
    1276:	f06a                	sd	s10,32(sp)
    1278:	0100                	addi	s0,sp,128
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    127a:	00003797          	auipc	a5,0x3
    127e:	1fe78793          	addi	a5,a5,510 # 4478 <malloc+0xe6>
    1282:	f8f43023          	sd	a5,-128(s0)
    1286:	00003797          	auipc	a5,0x3
    128a:	1fa78793          	addi	a5,a5,506 # 4480 <malloc+0xee>
    128e:	f8f43423          	sd	a5,-120(s0)
    1292:	00003797          	auipc	a5,0x3
    1296:	1f678793          	addi	a5,a5,502 # 4488 <malloc+0xf6>
    129a:	f8f43823          	sd	a5,-112(s0)
    129e:	00003797          	auipc	a5,0x3
    12a2:	1f278793          	addi	a5,a5,498 # 4490 <malloc+0xfe>
    12a6:	f8f43c23          	sd	a5,-104(s0)
  char *fname;
  enum { N=12, NCHILD=4, SZ=500 };
  
  printf("fourfiles test\n");
    12aa:	00004517          	auipc	a0,0x4
    12ae:	9e650513          	addi	a0,a0,-1562 # 4c90 <malloc+0x8fe>
    12b2:	00003097          	auipc	ra,0x3
    12b6:	022080e7          	jalr	34(ra) # 42d4 <printf>

  for(pi = 0; pi < NCHILD; pi++){
    12ba:	f8040b93          	addi	s7,s0,-128
  printf("fourfiles test\n");
    12be:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    12c0:	4481                	li	s1,0
    12c2:	4a11                	li	s4,4
    fname = names[pi];
    12c4:	00093983          	ld	s3,0(s2)
    unlink(fname);
    12c8:	854e                	mv	a0,s3
    12ca:	00003097          	auipc	ra,0x3
    12ce:	cc2080e7          	jalr	-830(ra) # 3f8c <unlink>

    pid = fork();
    12d2:	00003097          	auipc	ra,0x3
    12d6:	c62080e7          	jalr	-926(ra) # 3f34 <fork>
    if(pid < 0){
    12da:	04054763          	bltz	a0,1328 <fourfiles+0xca>
      printf("fork failed\n");
      exit();
    }

    if(pid == 0){
    12de:	c12d                	beqz	a0,1340 <fourfiles+0xe2>
  for(pi = 0; pi < NCHILD; pi++){
    12e0:	2485                	addiw	s1,s1,1
    12e2:	0921                	addi	s2,s2,8
    12e4:	ff4490e3          	bne	s1,s4,12c4 <fourfiles+0x66>
      exit();
    }
  }

  for(pi = 0; pi < NCHILD; pi++){
    wait();
    12e8:	00003097          	auipc	ra,0x3
    12ec:	c5c080e7          	jalr	-932(ra) # 3f44 <wait>
    12f0:	00003097          	auipc	ra,0x3
    12f4:	c54080e7          	jalr	-940(ra) # 3f44 <wait>
    12f8:	00003097          	auipc	ra,0x3
    12fc:	c4c080e7          	jalr	-948(ra) # 3f44 <wait>
    1300:	00003097          	auipc	ra,0x3
    1304:	c44080e7          	jalr	-956(ra) # 3f44 <wait>
    1308:	03000b13          	li	s6,48

  for(i = 0; i < NCHILD; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    130c:	00007a17          	auipc	s4,0x7
    1310:	754a0a13          	addi	s4,s4,1876 # 8a60 <buf>
    1314:	00007a97          	auipc	s5,0x7
    1318:	74da8a93          	addi	s5,s5,1869 # 8a61 <buf+0x1>
        }
      }
      total += n;
    }
    close(fd);
    if(total != N*SZ){
    131c:	6c85                	lui	s9,0x1
    131e:	770c8c93          	addi	s9,s9,1904 # 1770 <unlinkread+0xac>
  for(i = 0; i < NCHILD; i++){
    1322:	03400d13          	li	s10,52
    1326:	aa19                	j	143c <fourfiles+0x1de>
      printf("fork failed\n");
    1328:	00003517          	auipc	a0,0x3
    132c:	21850513          	addi	a0,a0,536 # 4540 <malloc+0x1ae>
    1330:	00003097          	auipc	ra,0x3
    1334:	fa4080e7          	jalr	-92(ra) # 42d4 <printf>
      exit();
    1338:	00003097          	auipc	ra,0x3
    133c:	c04080e7          	jalr	-1020(ra) # 3f3c <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    1340:	20200593          	li	a1,514
    1344:	854e                	mv	a0,s3
    1346:	00003097          	auipc	ra,0x3
    134a:	c36080e7          	jalr	-970(ra) # 3f7c <open>
    134e:	892a                	mv	s2,a0
      if(fd < 0){
    1350:	04054663          	bltz	a0,139c <fourfiles+0x13e>
      memset(buf, '0'+pi, SZ);
    1354:	1f400613          	li	a2,500
    1358:	0304859b          	addiw	a1,s1,48
    135c:	00007517          	auipc	a0,0x7
    1360:	70450513          	addi	a0,a0,1796 # 8a60 <buf>
    1364:	00003097          	auipc	ra,0x3
    1368:	a5c080e7          	jalr	-1444(ra) # 3dc0 <memset>
    136c:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    136e:	00007997          	auipc	s3,0x7
    1372:	6f298993          	addi	s3,s3,1778 # 8a60 <buf>
    1376:	1f400613          	li	a2,500
    137a:	85ce                	mv	a1,s3
    137c:	854a                	mv	a0,s2
    137e:	00003097          	auipc	ra,0x3
    1382:	bde080e7          	jalr	-1058(ra) # 3f5c <write>
    1386:	85aa                	mv	a1,a0
    1388:	1f400793          	li	a5,500
    138c:	02f51463          	bne	a0,a5,13b4 <fourfiles+0x156>
      for(i = 0; i < N; i++){
    1390:	34fd                	addiw	s1,s1,-1
    1392:	f0f5                	bnez	s1,1376 <fourfiles+0x118>
      exit();
    1394:	00003097          	auipc	ra,0x3
    1398:	ba8080e7          	jalr	-1112(ra) # 3f3c <exit>
        printf("create failed\n");
    139c:	00004517          	auipc	a0,0x4
    13a0:	90450513          	addi	a0,a0,-1788 # 4ca0 <malloc+0x90e>
    13a4:	00003097          	auipc	ra,0x3
    13a8:	f30080e7          	jalr	-208(ra) # 42d4 <printf>
        exit();
    13ac:	00003097          	auipc	ra,0x3
    13b0:	b90080e7          	jalr	-1136(ra) # 3f3c <exit>
          printf("write failed %d\n", n);
    13b4:	00004517          	auipc	a0,0x4
    13b8:	8fc50513          	addi	a0,a0,-1796 # 4cb0 <malloc+0x91e>
    13bc:	00003097          	auipc	ra,0x3
    13c0:	f18080e7          	jalr	-232(ra) # 42d4 <printf>
          exit();
    13c4:	00003097          	auipc	ra,0x3
    13c8:	b78080e7          	jalr	-1160(ra) # 3f3c <exit>
          printf("wrong char\n");
    13cc:	00004517          	auipc	a0,0x4
    13d0:	8fc50513          	addi	a0,a0,-1796 # 4cc8 <malloc+0x936>
    13d4:	00003097          	auipc	ra,0x3
    13d8:	f00080e7          	jalr	-256(ra) # 42d4 <printf>
          exit();
    13dc:	00003097          	auipc	ra,0x3
    13e0:	b60080e7          	jalr	-1184(ra) # 3f3c <exit>
      total += n;
    13e4:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    13e8:	660d                	lui	a2,0x3
    13ea:	85d2                	mv	a1,s4
    13ec:	854e                	mv	a0,s3
    13ee:	00003097          	auipc	ra,0x3
    13f2:	b66080e7          	jalr	-1178(ra) # 3f54 <read>
    13f6:	02a05363          	blez	a0,141c <fourfiles+0x1be>
    13fa:	00007797          	auipc	a5,0x7
    13fe:	66678793          	addi	a5,a5,1638 # 8a60 <buf>
    1402:	fff5069b          	addiw	a3,a0,-1
    1406:	1682                	slli	a3,a3,0x20
    1408:	9281                	srli	a3,a3,0x20
    140a:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    140c:	0007c703          	lbu	a4,0(a5)
    1410:	fa971ee3          	bne	a4,s1,13cc <fourfiles+0x16e>
      for(j = 0; j < n; j++){
    1414:	0785                	addi	a5,a5,1
    1416:	fed79be3          	bne	a5,a3,140c <fourfiles+0x1ae>
    141a:	b7e9                	j	13e4 <fourfiles+0x186>
    close(fd);
    141c:	854e                	mv	a0,s3
    141e:	00003097          	auipc	ra,0x3
    1422:	b46080e7          	jalr	-1210(ra) # 3f64 <close>
    if(total != N*SZ){
    1426:	03991863          	bne	s2,s9,1456 <fourfiles+0x1f8>
      printf("wrong length %d\n", total);
      exit();
    }
    unlink(fname);
    142a:	8562                	mv	a0,s8
    142c:	00003097          	auipc	ra,0x3
    1430:	b60080e7          	jalr	-1184(ra) # 3f8c <unlink>
  for(i = 0; i < NCHILD; i++){
    1434:	0ba1                	addi	s7,s7,8
    1436:	2b05                	addiw	s6,s6,1
    1438:	03ab0c63          	beq	s6,s10,1470 <fourfiles+0x212>
    fname = names[i];
    143c:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    1440:	4581                	li	a1,0
    1442:	8562                	mv	a0,s8
    1444:	00003097          	auipc	ra,0x3
    1448:	b38080e7          	jalr	-1224(ra) # 3f7c <open>
    144c:	89aa                	mv	s3,a0
    total = 0;
    144e:	4901                	li	s2,0
        if(buf[j] != '0'+i){
    1450:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1454:	bf51                	j	13e8 <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    1456:	85ca                	mv	a1,s2
    1458:	00004517          	auipc	a0,0x4
    145c:	88050513          	addi	a0,a0,-1920 # 4cd8 <malloc+0x946>
    1460:	00003097          	auipc	ra,0x3
    1464:	e74080e7          	jalr	-396(ra) # 42d4 <printf>
      exit();
    1468:	00003097          	auipc	ra,0x3
    146c:	ad4080e7          	jalr	-1324(ra) # 3f3c <exit>
  }

  printf("fourfiles ok\n");
    1470:	00004517          	auipc	a0,0x4
    1474:	88050513          	addi	a0,a0,-1920 # 4cf0 <malloc+0x95e>
    1478:	00003097          	auipc	ra,0x3
    147c:	e5c080e7          	jalr	-420(ra) # 42d4 <printf>
}
    1480:	70e6                	ld	ra,120(sp)
    1482:	7446                	ld	s0,112(sp)
    1484:	74a6                	ld	s1,104(sp)
    1486:	7906                	ld	s2,96(sp)
    1488:	69e6                	ld	s3,88(sp)
    148a:	6a46                	ld	s4,80(sp)
    148c:	6aa6                	ld	s5,72(sp)
    148e:	6b06                	ld	s6,64(sp)
    1490:	7be2                	ld	s7,56(sp)
    1492:	7c42                	ld	s8,48(sp)
    1494:	7ca2                	ld	s9,40(sp)
    1496:	7d02                	ld	s10,32(sp)
    1498:	6109                	addi	sp,sp,128
    149a:	8082                	ret

000000000000149c <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    149c:	7159                	addi	sp,sp,-112
    149e:	f486                	sd	ra,104(sp)
    14a0:	f0a2                	sd	s0,96(sp)
    14a2:	eca6                	sd	s1,88(sp)
    14a4:	e8ca                	sd	s2,80(sp)
    14a6:	e4ce                	sd	s3,72(sp)
    14a8:	e0d2                	sd	s4,64(sp)
    14aa:	fc56                	sd	s5,56(sp)
    14ac:	f85a                	sd	s6,48(sp)
    14ae:	f45e                	sd	s7,40(sp)
    14b0:	f062                	sd	s8,32(sp)
    14b2:	1880                	addi	s0,sp,112
  enum { N = 20, NCHILD=4 };
  int pid, i, fd, pi;
  char name[32];

  printf("createdelete test\n");
    14b4:	00004517          	auipc	a0,0x4
    14b8:	84c50513          	addi	a0,a0,-1972 # 4d00 <malloc+0x96e>
    14bc:	00003097          	auipc	ra,0x3
    14c0:	e18080e7          	jalr	-488(ra) # 42d4 <printf>

  for(pi = 0; pi < NCHILD; pi++){
    14c4:	4901                	li	s2,0
    14c6:	4991                	li	s3,4
    pid = fork();
    14c8:	00003097          	auipc	ra,0x3
    14cc:	a6c080e7          	jalr	-1428(ra) # 3f34 <fork>
    14d0:	84aa                	mv	s1,a0
    if(pid < 0){
    14d2:	04054363          	bltz	a0,1518 <createdelete+0x7c>
      printf("fork failed\n");
      exit();
    }

    if(pid == 0){
    14d6:	cd29                	beqz	a0,1530 <createdelete+0x94>
  for(pi = 0; pi < NCHILD; pi++){
    14d8:	2905                	addiw	s2,s2,1
    14da:	ff3917e3          	bne	s2,s3,14c8 <createdelete+0x2c>
      exit();
    }
  }

  for(pi = 0; pi < NCHILD; pi++){
    wait();
    14de:	00003097          	auipc	ra,0x3
    14e2:	a66080e7          	jalr	-1434(ra) # 3f44 <wait>
    14e6:	00003097          	auipc	ra,0x3
    14ea:	a5e080e7          	jalr	-1442(ra) # 3f44 <wait>
    14ee:	00003097          	auipc	ra,0x3
    14f2:	a56080e7          	jalr	-1450(ra) # 3f44 <wait>
    14f6:	00003097          	auipc	ra,0x3
    14fa:	a4e080e7          	jalr	-1458(ra) # 3f44 <wait>
  }

  name[0] = name[1] = name[2] = 0;
    14fe:	f8040923          	sb	zero,-110(s0)
    1502:	03000993          	li	s3,48
    1506:	5a7d                	li	s4,-1
  for(i = 0; i < N; i++){
    1508:	4901                	li	s2,0
  for(pi = 0; pi < NCHILD; pi++){
    150a:	07000c13          	li	s8,112
      name[1] = '0' + i;
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
        printf("oops createdelete %s didn't exist\n", name);
        exit();
      } else if((i >= 1 && i < N/2) && fd >= 0){
    150e:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1510:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1512:	07400a93          	li	s5,116
    1516:	a299                	j	165c <createdelete+0x1c0>
      printf("fork failed\n");
    1518:	00003517          	auipc	a0,0x3
    151c:	02850513          	addi	a0,a0,40 # 4540 <malloc+0x1ae>
    1520:	00003097          	auipc	ra,0x3
    1524:	db4080e7          	jalr	-588(ra) # 42d4 <printf>
      exit();
    1528:	00003097          	auipc	ra,0x3
    152c:	a14080e7          	jalr	-1516(ra) # 3f3c <exit>
      name[0] = 'p' + pi;
    1530:	0709091b          	addiw	s2,s2,112
    1534:	f9240823          	sb	s2,-112(s0)
      name[2] = '\0';
    1538:	f8040923          	sb	zero,-110(s0)
      for(i = 0; i < N; i++){
    153c:	4951                	li	s2,20
    153e:	a005                	j	155e <createdelete+0xc2>
          printf("create failed\n");
    1540:	00003517          	auipc	a0,0x3
    1544:	76050513          	addi	a0,a0,1888 # 4ca0 <malloc+0x90e>
    1548:	00003097          	auipc	ra,0x3
    154c:	d8c080e7          	jalr	-628(ra) # 42d4 <printf>
          exit();
    1550:	00003097          	auipc	ra,0x3
    1554:	9ec080e7          	jalr	-1556(ra) # 3f3c <exit>
      for(i = 0; i < N; i++){
    1558:	2485                	addiw	s1,s1,1
    155a:	07248663          	beq	s1,s2,15c6 <createdelete+0x12a>
        name[1] = '0' + i;
    155e:	0304879b          	addiw	a5,s1,48
    1562:	f8f408a3          	sb	a5,-111(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1566:	20200593          	li	a1,514
    156a:	f9040513          	addi	a0,s0,-112
    156e:	00003097          	auipc	ra,0x3
    1572:	a0e080e7          	jalr	-1522(ra) # 3f7c <open>
        if(fd < 0){
    1576:	fc0545e3          	bltz	a0,1540 <createdelete+0xa4>
        close(fd);
    157a:	00003097          	auipc	ra,0x3
    157e:	9ea080e7          	jalr	-1558(ra) # 3f64 <close>
        if(i > 0 && (i % 2 ) == 0){
    1582:	fc905be3          	blez	s1,1558 <createdelete+0xbc>
    1586:	0014f793          	andi	a5,s1,1
    158a:	f7f9                	bnez	a5,1558 <createdelete+0xbc>
          name[1] = '0' + (i / 2);
    158c:	01f4d79b          	srliw	a5,s1,0x1f
    1590:	9fa5                	addw	a5,a5,s1
    1592:	4017d79b          	sraiw	a5,a5,0x1
    1596:	0307879b          	addiw	a5,a5,48
    159a:	f8f408a3          	sb	a5,-111(s0)
          if(unlink(name) < 0){
    159e:	f9040513          	addi	a0,s0,-112
    15a2:	00003097          	auipc	ra,0x3
    15a6:	9ea080e7          	jalr	-1558(ra) # 3f8c <unlink>
    15aa:	fa0557e3          	bgez	a0,1558 <createdelete+0xbc>
            printf("unlink failed\n");
    15ae:	00003517          	auipc	a0,0x3
    15b2:	02a50513          	addi	a0,a0,42 # 45d8 <malloc+0x246>
    15b6:	00003097          	auipc	ra,0x3
    15ba:	d1e080e7          	jalr	-738(ra) # 42d4 <printf>
            exit();
    15be:	00003097          	auipc	ra,0x3
    15c2:	97e080e7          	jalr	-1666(ra) # 3f3c <exit>
      exit();
    15c6:	00003097          	auipc	ra,0x3
    15ca:	976080e7          	jalr	-1674(ra) # 3f3c <exit>
        printf("oops createdelete %s didn't exist\n", name);
    15ce:	f9040593          	addi	a1,s0,-112
    15d2:	00003517          	auipc	a0,0x3
    15d6:	74650513          	addi	a0,a0,1862 # 4d18 <malloc+0x986>
    15da:	00003097          	auipc	ra,0x3
    15de:	cfa080e7          	jalr	-774(ra) # 42d4 <printf>
        exit();
    15e2:	00003097          	auipc	ra,0x3
    15e6:	95a080e7          	jalr	-1702(ra) # 3f3c <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    15ea:	054b7163          	bgeu	s6,s4,162c <createdelete+0x190>
        printf("oops createdelete %s did exist\n", name);
        exit();
      }
      if(fd >= 0)
    15ee:	02055a63          	bgez	a0,1622 <createdelete+0x186>
    for(pi = 0; pi < NCHILD; pi++){
    15f2:	2485                	addiw	s1,s1,1
    15f4:	0ff4f493          	andi	s1,s1,255
    15f8:	05548a63          	beq	s1,s5,164c <createdelete+0x1b0>
      name[0] = 'p' + pi;
    15fc:	f8940823          	sb	s1,-112(s0)
      name[1] = '0' + i;
    1600:	f93408a3          	sb	s3,-111(s0)
      fd = open(name, 0);
    1604:	4581                	li	a1,0
    1606:	f9040513          	addi	a0,s0,-112
    160a:	00003097          	auipc	ra,0x3
    160e:	972080e7          	jalr	-1678(ra) # 3f7c <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1612:	00090463          	beqz	s2,161a <createdelete+0x17e>
    1616:	fd2bdae3          	bge	s7,s2,15ea <createdelete+0x14e>
    161a:	fa054ae3          	bltz	a0,15ce <createdelete+0x132>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    161e:	014b7963          	bgeu	s6,s4,1630 <createdelete+0x194>
        close(fd);
    1622:	00003097          	auipc	ra,0x3
    1626:	942080e7          	jalr	-1726(ra) # 3f64 <close>
    162a:	b7e1                	j	15f2 <createdelete+0x156>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    162c:	fc0543e3          	bltz	a0,15f2 <createdelete+0x156>
        printf("oops createdelete %s did exist\n", name);
    1630:	f9040593          	addi	a1,s0,-112
    1634:	00003517          	auipc	a0,0x3
    1638:	70c50513          	addi	a0,a0,1804 # 4d40 <malloc+0x9ae>
    163c:	00003097          	auipc	ra,0x3
    1640:	c98080e7          	jalr	-872(ra) # 42d4 <printf>
        exit();
    1644:	00003097          	auipc	ra,0x3
    1648:	8f8080e7          	jalr	-1800(ra) # 3f3c <exit>
  for(i = 0; i < N; i++){
    164c:	2905                	addiw	s2,s2,1
    164e:	2a05                	addiw	s4,s4,1
    1650:	2985                	addiw	s3,s3,1
    1652:	0ff9f993          	andi	s3,s3,255
    1656:	47d1                	li	a5,20
    1658:	02f90a63          	beq	s2,a5,168c <createdelete+0x1f0>
  for(pi = 0; pi < NCHILD; pi++){
    165c:	84e2                	mv	s1,s8
    165e:	bf79                	j	15fc <createdelete+0x160>
    }
  }

  for(i = 0; i < N; i++){
    1660:	2905                	addiw	s2,s2,1
    1662:	0ff97913          	andi	s2,s2,255
    1666:	2985                	addiw	s3,s3,1
    1668:	0ff9f993          	andi	s3,s3,255
    166c:	03490863          	beq	s2,s4,169c <createdelete+0x200>
  for(i = 0; i < N; i++){
    1670:	84d6                	mv	s1,s5
    for(pi = 0; pi < NCHILD; pi++){
      name[0] = 'p' + i;
    1672:	f9240823          	sb	s2,-112(s0)
      name[1] = '0' + i;
    1676:	f93408a3          	sb	s3,-111(s0)
      unlink(name);
    167a:	f9040513          	addi	a0,s0,-112
    167e:	00003097          	auipc	ra,0x3
    1682:	90e080e7          	jalr	-1778(ra) # 3f8c <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1686:	34fd                	addiw	s1,s1,-1
    1688:	f4ed                	bnez	s1,1672 <createdelete+0x1d6>
    168a:	bfd9                	j	1660 <createdelete+0x1c4>
    168c:	03000993          	li	s3,48
    1690:	07000913          	li	s2,112
  for(i = 0; i < N; i++){
    1694:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1696:	08400a13          	li	s4,132
    169a:	bfd9                	j	1670 <createdelete+0x1d4>
    }
  }

  printf("createdelete ok\n");
    169c:	00003517          	auipc	a0,0x3
    16a0:	6c450513          	addi	a0,a0,1732 # 4d60 <malloc+0x9ce>
    16a4:	00003097          	auipc	ra,0x3
    16a8:	c30080e7          	jalr	-976(ra) # 42d4 <printf>
}
    16ac:	70a6                	ld	ra,104(sp)
    16ae:	7406                	ld	s0,96(sp)
    16b0:	64e6                	ld	s1,88(sp)
    16b2:	6946                	ld	s2,80(sp)
    16b4:	69a6                	ld	s3,72(sp)
    16b6:	6a06                	ld	s4,64(sp)
    16b8:	7ae2                	ld	s5,56(sp)
    16ba:	7b42                	ld	s6,48(sp)
    16bc:	7ba2                	ld	s7,40(sp)
    16be:	7c02                	ld	s8,32(sp)
    16c0:	6165                	addi	sp,sp,112
    16c2:	8082                	ret

00000000000016c4 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    16c4:	1101                	addi	sp,sp,-32
    16c6:	ec06                	sd	ra,24(sp)
    16c8:	e822                	sd	s0,16(sp)
    16ca:	e426                	sd	s1,8(sp)
    16cc:	e04a                	sd	s2,0(sp)
    16ce:	1000                	addi	s0,sp,32
  enum { SZ = 5 };
  int fd, fd1;

  printf("unlinkread test\n");
    16d0:	00003517          	auipc	a0,0x3
    16d4:	6a850513          	addi	a0,a0,1704 # 4d78 <malloc+0x9e6>
    16d8:	00003097          	auipc	ra,0x3
    16dc:	bfc080e7          	jalr	-1028(ra) # 42d4 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    16e0:	20200593          	li	a1,514
    16e4:	00003517          	auipc	a0,0x3
    16e8:	6ac50513          	addi	a0,a0,1708 # 4d90 <malloc+0x9fe>
    16ec:	00003097          	auipc	ra,0x3
    16f0:	890080e7          	jalr	-1904(ra) # 3f7c <open>
  if(fd < 0){
    16f4:	0e054c63          	bltz	a0,17ec <unlinkread+0x128>
    16f8:	84aa                	mv	s1,a0
    printf("create unlinkread failed\n");
    exit();
  }
  write(fd, "hello", SZ);
    16fa:	4615                	li	a2,5
    16fc:	00003597          	auipc	a1,0x3
    1700:	6c458593          	addi	a1,a1,1732 # 4dc0 <malloc+0xa2e>
    1704:	00003097          	auipc	ra,0x3
    1708:	858080e7          	jalr	-1960(ra) # 3f5c <write>
  close(fd);
    170c:	8526                	mv	a0,s1
    170e:	00003097          	auipc	ra,0x3
    1712:	856080e7          	jalr	-1962(ra) # 3f64 <close>

  fd = open("unlinkread", O_RDWR);
    1716:	4589                	li	a1,2
    1718:	00003517          	auipc	a0,0x3
    171c:	67850513          	addi	a0,a0,1656 # 4d90 <malloc+0x9fe>
    1720:	00003097          	auipc	ra,0x3
    1724:	85c080e7          	jalr	-1956(ra) # 3f7c <open>
    1728:	84aa                	mv	s1,a0
  if(fd < 0){
    172a:	0c054d63          	bltz	a0,1804 <unlinkread+0x140>
    printf("open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    172e:	00003517          	auipc	a0,0x3
    1732:	66250513          	addi	a0,a0,1634 # 4d90 <malloc+0x9fe>
    1736:	00003097          	auipc	ra,0x3
    173a:	856080e7          	jalr	-1962(ra) # 3f8c <unlink>
    173e:	ed79                	bnez	a0,181c <unlinkread+0x158>
    printf("unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1740:	20200593          	li	a1,514
    1744:	00003517          	auipc	a0,0x3
    1748:	64c50513          	addi	a0,a0,1612 # 4d90 <malloc+0x9fe>
    174c:	00003097          	auipc	ra,0x3
    1750:	830080e7          	jalr	-2000(ra) # 3f7c <open>
    1754:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
    1756:	460d                	li	a2,3
    1758:	00003597          	auipc	a1,0x3
    175c:	6a858593          	addi	a1,a1,1704 # 4e00 <malloc+0xa6e>
    1760:	00002097          	auipc	ra,0x2
    1764:	7fc080e7          	jalr	2044(ra) # 3f5c <write>
  close(fd1);
    1768:	854a                	mv	a0,s2
    176a:	00002097          	auipc	ra,0x2
    176e:	7fa080e7          	jalr	2042(ra) # 3f64 <close>

  if(read(fd, buf, sizeof(buf)) != SZ){
    1772:	660d                	lui	a2,0x3
    1774:	00007597          	auipc	a1,0x7
    1778:	2ec58593          	addi	a1,a1,748 # 8a60 <buf>
    177c:	8526                	mv	a0,s1
    177e:	00002097          	auipc	ra,0x2
    1782:	7d6080e7          	jalr	2006(ra) # 3f54 <read>
    1786:	4795                	li	a5,5
    1788:	0af51663          	bne	a0,a5,1834 <unlinkread+0x170>
    printf("unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    178c:	00007717          	auipc	a4,0x7
    1790:	2d474703          	lbu	a4,724(a4) # 8a60 <buf>
    1794:	06800793          	li	a5,104
    1798:	0af71a63          	bne	a4,a5,184c <unlinkread+0x188>
    printf("unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    179c:	4629                	li	a2,10
    179e:	00007597          	auipc	a1,0x7
    17a2:	2c258593          	addi	a1,a1,706 # 8a60 <buf>
    17a6:	8526                	mv	a0,s1
    17a8:	00002097          	auipc	ra,0x2
    17ac:	7b4080e7          	jalr	1972(ra) # 3f5c <write>
    17b0:	47a9                	li	a5,10
    17b2:	0af51963          	bne	a0,a5,1864 <unlinkread+0x1a0>
    printf("unlinkread write failed\n");
    exit();
  }
  close(fd);
    17b6:	8526                	mv	a0,s1
    17b8:	00002097          	auipc	ra,0x2
    17bc:	7ac080e7          	jalr	1964(ra) # 3f64 <close>
  unlink("unlinkread");
    17c0:	00003517          	auipc	a0,0x3
    17c4:	5d050513          	addi	a0,a0,1488 # 4d90 <malloc+0x9fe>
    17c8:	00002097          	auipc	ra,0x2
    17cc:	7c4080e7          	jalr	1988(ra) # 3f8c <unlink>
  printf("unlinkread ok\n");
    17d0:	00003517          	auipc	a0,0x3
    17d4:	68850513          	addi	a0,a0,1672 # 4e58 <malloc+0xac6>
    17d8:	00003097          	auipc	ra,0x3
    17dc:	afc080e7          	jalr	-1284(ra) # 42d4 <printf>
}
    17e0:	60e2                	ld	ra,24(sp)
    17e2:	6442                	ld	s0,16(sp)
    17e4:	64a2                	ld	s1,8(sp)
    17e6:	6902                	ld	s2,0(sp)
    17e8:	6105                	addi	sp,sp,32
    17ea:	8082                	ret
    printf("create unlinkread failed\n");
    17ec:	00003517          	auipc	a0,0x3
    17f0:	5b450513          	addi	a0,a0,1460 # 4da0 <malloc+0xa0e>
    17f4:	00003097          	auipc	ra,0x3
    17f8:	ae0080e7          	jalr	-1312(ra) # 42d4 <printf>
    exit();
    17fc:	00002097          	auipc	ra,0x2
    1800:	740080e7          	jalr	1856(ra) # 3f3c <exit>
    printf("open unlinkread failed\n");
    1804:	00003517          	auipc	a0,0x3
    1808:	5c450513          	addi	a0,a0,1476 # 4dc8 <malloc+0xa36>
    180c:	00003097          	auipc	ra,0x3
    1810:	ac8080e7          	jalr	-1336(ra) # 42d4 <printf>
    exit();
    1814:	00002097          	auipc	ra,0x2
    1818:	728080e7          	jalr	1832(ra) # 3f3c <exit>
    printf("unlink unlinkread failed\n");
    181c:	00003517          	auipc	a0,0x3
    1820:	5c450513          	addi	a0,a0,1476 # 4de0 <malloc+0xa4e>
    1824:	00003097          	auipc	ra,0x3
    1828:	ab0080e7          	jalr	-1360(ra) # 42d4 <printf>
    exit();
    182c:	00002097          	auipc	ra,0x2
    1830:	710080e7          	jalr	1808(ra) # 3f3c <exit>
    printf("unlinkread read failed");
    1834:	00003517          	auipc	a0,0x3
    1838:	5d450513          	addi	a0,a0,1492 # 4e08 <malloc+0xa76>
    183c:	00003097          	auipc	ra,0x3
    1840:	a98080e7          	jalr	-1384(ra) # 42d4 <printf>
    exit();
    1844:	00002097          	auipc	ra,0x2
    1848:	6f8080e7          	jalr	1784(ra) # 3f3c <exit>
    printf("unlinkread wrong data\n");
    184c:	00003517          	auipc	a0,0x3
    1850:	5d450513          	addi	a0,a0,1492 # 4e20 <malloc+0xa8e>
    1854:	00003097          	auipc	ra,0x3
    1858:	a80080e7          	jalr	-1408(ra) # 42d4 <printf>
    exit();
    185c:	00002097          	auipc	ra,0x2
    1860:	6e0080e7          	jalr	1760(ra) # 3f3c <exit>
    printf("unlinkread write failed\n");
    1864:	00003517          	auipc	a0,0x3
    1868:	5d450513          	addi	a0,a0,1492 # 4e38 <malloc+0xaa6>
    186c:	00003097          	auipc	ra,0x3
    1870:	a68080e7          	jalr	-1432(ra) # 42d4 <printf>
    exit();
    1874:	00002097          	auipc	ra,0x2
    1878:	6c8080e7          	jalr	1736(ra) # 3f3c <exit>

000000000000187c <linktest>:

void
linktest(void)
{
    187c:	1101                	addi	sp,sp,-32
    187e:	ec06                	sd	ra,24(sp)
    1880:	e822                	sd	s0,16(sp)
    1882:	e426                	sd	s1,8(sp)
    1884:	1000                	addi	s0,sp,32
  enum { SZ = 5 };
  int fd;

  printf("linktest\n");
    1886:	00003517          	auipc	a0,0x3
    188a:	5e250513          	addi	a0,a0,1506 # 4e68 <malloc+0xad6>
    188e:	00003097          	auipc	ra,0x3
    1892:	a46080e7          	jalr	-1466(ra) # 42d4 <printf>

  unlink("lf1");
    1896:	00003517          	auipc	a0,0x3
    189a:	5e250513          	addi	a0,a0,1506 # 4e78 <malloc+0xae6>
    189e:	00002097          	auipc	ra,0x2
    18a2:	6ee080e7          	jalr	1774(ra) # 3f8c <unlink>
  unlink("lf2");
    18a6:	00003517          	auipc	a0,0x3
    18aa:	5da50513          	addi	a0,a0,1498 # 4e80 <malloc+0xaee>
    18ae:	00002097          	auipc	ra,0x2
    18b2:	6de080e7          	jalr	1758(ra) # 3f8c <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    18b6:	20200593          	li	a1,514
    18ba:	00003517          	auipc	a0,0x3
    18be:	5be50513          	addi	a0,a0,1470 # 4e78 <malloc+0xae6>
    18c2:	00002097          	auipc	ra,0x2
    18c6:	6ba080e7          	jalr	1722(ra) # 3f7c <open>
  if(fd < 0){
    18ca:	10054e63          	bltz	a0,19e6 <linktest+0x16a>
    18ce:	84aa                	mv	s1,a0
    printf("create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", SZ) != SZ){
    18d0:	4615                	li	a2,5
    18d2:	00003597          	auipc	a1,0x3
    18d6:	4ee58593          	addi	a1,a1,1262 # 4dc0 <malloc+0xa2e>
    18da:	00002097          	auipc	ra,0x2
    18de:	682080e7          	jalr	1666(ra) # 3f5c <write>
    18e2:	4795                	li	a5,5
    18e4:	10f51d63          	bne	a0,a5,19fe <linktest+0x182>
    printf("write lf1 failed\n");
    exit();
  }
  close(fd);
    18e8:	8526                	mv	a0,s1
    18ea:	00002097          	auipc	ra,0x2
    18ee:	67a080e7          	jalr	1658(ra) # 3f64 <close>

  if(link("lf1", "lf2") < 0){
    18f2:	00003597          	auipc	a1,0x3
    18f6:	58e58593          	addi	a1,a1,1422 # 4e80 <malloc+0xaee>
    18fa:	00003517          	auipc	a0,0x3
    18fe:	57e50513          	addi	a0,a0,1406 # 4e78 <malloc+0xae6>
    1902:	00002097          	auipc	ra,0x2
    1906:	69a080e7          	jalr	1690(ra) # 3f9c <link>
    190a:	10054663          	bltz	a0,1a16 <linktest+0x19a>
    printf("link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");
    190e:	00003517          	auipc	a0,0x3
    1912:	56a50513          	addi	a0,a0,1386 # 4e78 <malloc+0xae6>
    1916:	00002097          	auipc	ra,0x2
    191a:	676080e7          	jalr	1654(ra) # 3f8c <unlink>

  if(open("lf1", 0) >= 0){
    191e:	4581                	li	a1,0
    1920:	00003517          	auipc	a0,0x3
    1924:	55850513          	addi	a0,a0,1368 # 4e78 <malloc+0xae6>
    1928:	00002097          	auipc	ra,0x2
    192c:	654080e7          	jalr	1620(ra) # 3f7c <open>
    1930:	0e055f63          	bgez	a0,1a2e <linktest+0x1b2>
    printf("unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    1934:	4581                	li	a1,0
    1936:	00003517          	auipc	a0,0x3
    193a:	54a50513          	addi	a0,a0,1354 # 4e80 <malloc+0xaee>
    193e:	00002097          	auipc	ra,0x2
    1942:	63e080e7          	jalr	1598(ra) # 3f7c <open>
    1946:	84aa                	mv	s1,a0
  if(fd < 0){
    1948:	0e054f63          	bltz	a0,1a46 <linktest+0x1ca>
    printf("open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != SZ){
    194c:	660d                	lui	a2,0x3
    194e:	00007597          	auipc	a1,0x7
    1952:	11258593          	addi	a1,a1,274 # 8a60 <buf>
    1956:	00002097          	auipc	ra,0x2
    195a:	5fe080e7          	jalr	1534(ra) # 3f54 <read>
    195e:	4795                	li	a5,5
    1960:	0ef51f63          	bne	a0,a5,1a5e <linktest+0x1e2>
    printf("read lf2 failed\n");
    exit();
  }
  close(fd);
    1964:	8526                	mv	a0,s1
    1966:	00002097          	auipc	ra,0x2
    196a:	5fe080e7          	jalr	1534(ra) # 3f64 <close>

  if(link("lf2", "lf2") >= 0){
    196e:	00003597          	auipc	a1,0x3
    1972:	51258593          	addi	a1,a1,1298 # 4e80 <malloc+0xaee>
    1976:	852e                	mv	a0,a1
    1978:	00002097          	auipc	ra,0x2
    197c:	624080e7          	jalr	1572(ra) # 3f9c <link>
    1980:	0e055b63          	bgez	a0,1a76 <linktest+0x1fa>
    printf("link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
    1984:	00003517          	auipc	a0,0x3
    1988:	4fc50513          	addi	a0,a0,1276 # 4e80 <malloc+0xaee>
    198c:	00002097          	auipc	ra,0x2
    1990:	600080e7          	jalr	1536(ra) # 3f8c <unlink>
  if(link("lf2", "lf1") >= 0){
    1994:	00003597          	auipc	a1,0x3
    1998:	4e458593          	addi	a1,a1,1252 # 4e78 <malloc+0xae6>
    199c:	00003517          	auipc	a0,0x3
    19a0:	4e450513          	addi	a0,a0,1252 # 4e80 <malloc+0xaee>
    19a4:	00002097          	auipc	ra,0x2
    19a8:	5f8080e7          	jalr	1528(ra) # 3f9c <link>
    19ac:	0e055163          	bgez	a0,1a8e <linktest+0x212>
    printf("link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    19b0:	00003597          	auipc	a1,0x3
    19b4:	4c858593          	addi	a1,a1,1224 # 4e78 <malloc+0xae6>
    19b8:	00003517          	auipc	a0,0x3
    19bc:	5b850513          	addi	a0,a0,1464 # 4f70 <malloc+0xbde>
    19c0:	00002097          	auipc	ra,0x2
    19c4:	5dc080e7          	jalr	1500(ra) # 3f9c <link>
    19c8:	0c055f63          	bgez	a0,1aa6 <linktest+0x22a>
    printf("link . lf1 succeeded! oops\n");
    exit();
  }

  printf("linktest ok\n");
    19cc:	00003517          	auipc	a0,0x3
    19d0:	5cc50513          	addi	a0,a0,1484 # 4f98 <malloc+0xc06>
    19d4:	00003097          	auipc	ra,0x3
    19d8:	900080e7          	jalr	-1792(ra) # 42d4 <printf>
}
    19dc:	60e2                	ld	ra,24(sp)
    19de:	6442                	ld	s0,16(sp)
    19e0:	64a2                	ld	s1,8(sp)
    19e2:	6105                	addi	sp,sp,32
    19e4:	8082                	ret
    printf("create lf1 failed\n");
    19e6:	00003517          	auipc	a0,0x3
    19ea:	4a250513          	addi	a0,a0,1186 # 4e88 <malloc+0xaf6>
    19ee:	00003097          	auipc	ra,0x3
    19f2:	8e6080e7          	jalr	-1818(ra) # 42d4 <printf>
    exit();
    19f6:	00002097          	auipc	ra,0x2
    19fa:	546080e7          	jalr	1350(ra) # 3f3c <exit>
    printf("write lf1 failed\n");
    19fe:	00003517          	auipc	a0,0x3
    1a02:	4a250513          	addi	a0,a0,1186 # 4ea0 <malloc+0xb0e>
    1a06:	00003097          	auipc	ra,0x3
    1a0a:	8ce080e7          	jalr	-1842(ra) # 42d4 <printf>
    exit();
    1a0e:	00002097          	auipc	ra,0x2
    1a12:	52e080e7          	jalr	1326(ra) # 3f3c <exit>
    printf("link lf1 lf2 failed\n");
    1a16:	00003517          	auipc	a0,0x3
    1a1a:	4a250513          	addi	a0,a0,1186 # 4eb8 <malloc+0xb26>
    1a1e:	00003097          	auipc	ra,0x3
    1a22:	8b6080e7          	jalr	-1866(ra) # 42d4 <printf>
    exit();
    1a26:	00002097          	auipc	ra,0x2
    1a2a:	516080e7          	jalr	1302(ra) # 3f3c <exit>
    printf("unlinked lf1 but it is still there!\n");
    1a2e:	00003517          	auipc	a0,0x3
    1a32:	4a250513          	addi	a0,a0,1186 # 4ed0 <malloc+0xb3e>
    1a36:	00003097          	auipc	ra,0x3
    1a3a:	89e080e7          	jalr	-1890(ra) # 42d4 <printf>
    exit();
    1a3e:	00002097          	auipc	ra,0x2
    1a42:	4fe080e7          	jalr	1278(ra) # 3f3c <exit>
    printf("open lf2 failed\n");
    1a46:	00003517          	auipc	a0,0x3
    1a4a:	4b250513          	addi	a0,a0,1202 # 4ef8 <malloc+0xb66>
    1a4e:	00003097          	auipc	ra,0x3
    1a52:	886080e7          	jalr	-1914(ra) # 42d4 <printf>
    exit();
    1a56:	00002097          	auipc	ra,0x2
    1a5a:	4e6080e7          	jalr	1254(ra) # 3f3c <exit>
    printf("read lf2 failed\n");
    1a5e:	00003517          	auipc	a0,0x3
    1a62:	4b250513          	addi	a0,a0,1202 # 4f10 <malloc+0xb7e>
    1a66:	00003097          	auipc	ra,0x3
    1a6a:	86e080e7          	jalr	-1938(ra) # 42d4 <printf>
    exit();
    1a6e:	00002097          	auipc	ra,0x2
    1a72:	4ce080e7          	jalr	1230(ra) # 3f3c <exit>
    printf("link lf2 lf2 succeeded! oops\n");
    1a76:	00003517          	auipc	a0,0x3
    1a7a:	4b250513          	addi	a0,a0,1202 # 4f28 <malloc+0xb96>
    1a7e:	00003097          	auipc	ra,0x3
    1a82:	856080e7          	jalr	-1962(ra) # 42d4 <printf>
    exit();
    1a86:	00002097          	auipc	ra,0x2
    1a8a:	4b6080e7          	jalr	1206(ra) # 3f3c <exit>
    printf("link non-existant succeeded! oops\n");
    1a8e:	00003517          	auipc	a0,0x3
    1a92:	4ba50513          	addi	a0,a0,1210 # 4f48 <malloc+0xbb6>
    1a96:	00003097          	auipc	ra,0x3
    1a9a:	83e080e7          	jalr	-1986(ra) # 42d4 <printf>
    exit();
    1a9e:	00002097          	auipc	ra,0x2
    1aa2:	49e080e7          	jalr	1182(ra) # 3f3c <exit>
    printf("link . lf1 succeeded! oops\n");
    1aa6:	00003517          	auipc	a0,0x3
    1aaa:	4d250513          	addi	a0,a0,1234 # 4f78 <malloc+0xbe6>
    1aae:	00003097          	auipc	ra,0x3
    1ab2:	826080e7          	jalr	-2010(ra) # 42d4 <printf>
    exit();
    1ab6:	00002097          	auipc	ra,0x2
    1aba:	486080e7          	jalr	1158(ra) # 3f3c <exit>

0000000000001abe <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1abe:	7119                	addi	sp,sp,-128
    1ac0:	fc86                	sd	ra,120(sp)
    1ac2:	f8a2                	sd	s0,112(sp)
    1ac4:	f4a6                	sd	s1,104(sp)
    1ac6:	f0ca                	sd	s2,96(sp)
    1ac8:	ecce                	sd	s3,88(sp)
    1aca:	e8d2                	sd	s4,80(sp)
    1acc:	e4d6                	sd	s5,72(sp)
    1ace:	0100                	addi	s0,sp,128
  struct {
    ushort inum;
    char name[DIRSIZ];
  } de;

  printf("concreate test\n");
    1ad0:	00003517          	auipc	a0,0x3
    1ad4:	4d850513          	addi	a0,a0,1240 # 4fa8 <malloc+0xc16>
    1ad8:	00002097          	auipc	ra,0x2
    1adc:	7fc080e7          	jalr	2044(ra) # 42d4 <printf>
  file[0] = 'C';
    1ae0:	04300793          	li	a5,67
    1ae4:	faf40c23          	sb	a5,-72(s0)
  file[2] = '\0';
    1ae8:	fa040d23          	sb	zero,-70(s0)
  for(i = 0; i < N; i++){
    1aec:	4481                	li	s1,0
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
    1aee:	4a0d                	li	s4,3
    1af0:	4985                	li	s3,1
      link("C0", file);
    1af2:	00003a97          	auipc	s5,0x3
    1af6:	4c6a8a93          	addi	s5,s5,1222 # 4fb8 <malloc+0xc26>
  for(i = 0; i < N; i++){
    1afa:	02800913          	li	s2,40
    1afe:	a441                	j	1d7e <concreate+0x2c0>
      link("C0", file);
    1b00:	fb840593          	addi	a1,s0,-72
    1b04:	8556                	mv	a0,s5
    1b06:	00002097          	auipc	ra,0x2
    1b0a:	496080e7          	jalr	1174(ra) # 3f9c <link>
        printf("concreate create %s failed\n", file);
        exit();
      }
      close(fd);
    }
    if(pid == 0)
    1b0e:	a48d                	j	1d70 <concreate+0x2b2>
    } else if(pid == 0 && (i % 5) == 1){
    1b10:	4795                	li	a5,5
    1b12:	02f4e4bb          	remw	s1,s1,a5
    1b16:	4785                	li	a5,1
    1b18:	02f48a63          	beq	s1,a5,1b4c <concreate+0x8e>
      fd = open(file, O_CREATE | O_RDWR);
    1b1c:	20200593          	li	a1,514
    1b20:	fb840513          	addi	a0,s0,-72
    1b24:	00002097          	auipc	ra,0x2
    1b28:	458080e7          	jalr	1112(ra) # 3f7c <open>
      if(fd < 0){
    1b2c:	22055963          	bgez	a0,1d5e <concreate+0x2a0>
        printf("concreate create %s failed\n", file);
    1b30:	fb840593          	addi	a1,s0,-72
    1b34:	00003517          	auipc	a0,0x3
    1b38:	48c50513          	addi	a0,a0,1164 # 4fc0 <malloc+0xc2e>
    1b3c:	00002097          	auipc	ra,0x2
    1b40:	798080e7          	jalr	1944(ra) # 42d4 <printf>
        exit();
    1b44:	00002097          	auipc	ra,0x2
    1b48:	3f8080e7          	jalr	1016(ra) # 3f3c <exit>
      link("C0", file);
    1b4c:	fb840593          	addi	a1,s0,-72
    1b50:	00003517          	auipc	a0,0x3
    1b54:	46850513          	addi	a0,a0,1128 # 4fb8 <malloc+0xc26>
    1b58:	00002097          	auipc	ra,0x2
    1b5c:	444080e7          	jalr	1092(ra) # 3f9c <link>
      exit();
    1b60:	00002097          	auipc	ra,0x2
    1b64:	3dc080e7          	jalr	988(ra) # 3f3c <exit>
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    1b68:	02800613          	li	a2,40
    1b6c:	4581                	li	a1,0
    1b6e:	f9040513          	addi	a0,s0,-112
    1b72:	00002097          	auipc	ra,0x2
    1b76:	24e080e7          	jalr	590(ra) # 3dc0 <memset>
  fd = open(".", 0);
    1b7a:	4581                	li	a1,0
    1b7c:	00003517          	auipc	a0,0x3
    1b80:	3f450513          	addi	a0,a0,1012 # 4f70 <malloc+0xbde>
    1b84:	00002097          	auipc	ra,0x2
    1b88:	3f8080e7          	jalr	1016(ra) # 3f7c <open>
    1b8c:	84aa                	mv	s1,a0
  n = 0;
    1b8e:	4981                	li	s3,0
  while(read(fd, &de, sizeof(de)) > 0){
    if(de.inum == 0)
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1b90:	04300913          	li	s2,67
      i = de.name[1] - '0';
      if(i < 0 || i >= sizeof(fa)){
    1b94:	02700a13          	li	s4,39
      }
      if(fa[i]){
        printf("concreate duplicate file %s\n", de.name);
        exit();
      }
      fa[i] = 1;
    1b98:	4a85                	li	s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    1b9a:	4641                	li	a2,16
    1b9c:	f8040593          	addi	a1,s0,-128
    1ba0:	8526                	mv	a0,s1
    1ba2:	00002097          	auipc	ra,0x2
    1ba6:	3b2080e7          	jalr	946(ra) # 3f54 <read>
    1baa:	06a05d63          	blez	a0,1c24 <concreate+0x166>
    if(de.inum == 0)
    1bae:	f8045783          	lhu	a5,-128(s0)
    1bb2:	d7e5                	beqz	a5,1b9a <concreate+0xdc>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1bb4:	f8244783          	lbu	a5,-126(s0)
    1bb8:	ff2791e3          	bne	a5,s2,1b9a <concreate+0xdc>
    1bbc:	f8444783          	lbu	a5,-124(s0)
    1bc0:	ffe9                	bnez	a5,1b9a <concreate+0xdc>
      i = de.name[1] - '0';
    1bc2:	f8344783          	lbu	a5,-125(s0)
    1bc6:	fd07879b          	addiw	a5,a5,-48
    1bca:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    1bce:	00ea6f63          	bltu	s4,a4,1bec <concreate+0x12e>
      if(fa[i]){
    1bd2:	fc040793          	addi	a5,s0,-64
    1bd6:	97ba                	add	a5,a5,a4
    1bd8:	fd07c783          	lbu	a5,-48(a5)
    1bdc:	e795                	bnez	a5,1c08 <concreate+0x14a>
      fa[i] = 1;
    1bde:	fc040793          	addi	a5,s0,-64
    1be2:	973e                	add	a4,a4,a5
    1be4:	fd570823          	sb	s5,-48(a4)
      n++;
    1be8:	2985                	addiw	s3,s3,1
    1bea:	bf45                	j	1b9a <concreate+0xdc>
        printf("concreate weird file %s\n", de.name);
    1bec:	f8240593          	addi	a1,s0,-126
    1bf0:	00003517          	auipc	a0,0x3
    1bf4:	3f050513          	addi	a0,a0,1008 # 4fe0 <malloc+0xc4e>
    1bf8:	00002097          	auipc	ra,0x2
    1bfc:	6dc080e7          	jalr	1756(ra) # 42d4 <printf>
        exit();
    1c00:	00002097          	auipc	ra,0x2
    1c04:	33c080e7          	jalr	828(ra) # 3f3c <exit>
        printf("concreate duplicate file %s\n", de.name);
    1c08:	f8240593          	addi	a1,s0,-126
    1c0c:	00003517          	auipc	a0,0x3
    1c10:	3f450513          	addi	a0,a0,1012 # 5000 <malloc+0xc6e>
    1c14:	00002097          	auipc	ra,0x2
    1c18:	6c0080e7          	jalr	1728(ra) # 42d4 <printf>
        exit();
    1c1c:	00002097          	auipc	ra,0x2
    1c20:	320080e7          	jalr	800(ra) # 3f3c <exit>
    }
  }
  close(fd);
    1c24:	8526                	mv	a0,s1
    1c26:	00002097          	auipc	ra,0x2
    1c2a:	33e080e7          	jalr	830(ra) # 3f64 <close>

  if(n != N){
    1c2e:	02800793          	li	a5,40
    printf("concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < N; i++){
    1c32:	4901                	li	s2,0
  if(n != N){
    1c34:	00f99763          	bne	s3,a5,1c42 <concreate+0x184>
    pid = fork();
    if(pid < 0){
      printf("fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1c38:	4a0d                	li	s4,3
    1c3a:	4a85                	li	s5,1
  for(i = 0; i < N; i++){
    1c3c:	02800993          	li	s3,40
    1c40:	a869                	j	1cda <concreate+0x21c>
    printf("concreate not enough files in directory listing\n");
    1c42:	00003517          	auipc	a0,0x3
    1c46:	3de50513          	addi	a0,a0,990 # 5020 <malloc+0xc8e>
    1c4a:	00002097          	auipc	ra,0x2
    1c4e:	68a080e7          	jalr	1674(ra) # 42d4 <printf>
    exit();
    1c52:	00002097          	auipc	ra,0x2
    1c56:	2ea080e7          	jalr	746(ra) # 3f3c <exit>
      printf("fork failed\n");
    1c5a:	00003517          	auipc	a0,0x3
    1c5e:	8e650513          	addi	a0,a0,-1818 # 4540 <malloc+0x1ae>
    1c62:	00002097          	auipc	ra,0x2
    1c66:	672080e7          	jalr	1650(ra) # 42d4 <printf>
      exit();
    1c6a:	00002097          	auipc	ra,0x2
    1c6e:	2d2080e7          	jalr	722(ra) # 3f3c <exit>
       ((i % 3) == 1 && pid != 0)){
      close(open(file, 0));
    1c72:	4581                	li	a1,0
    1c74:	fb840513          	addi	a0,s0,-72
    1c78:	00002097          	auipc	ra,0x2
    1c7c:	304080e7          	jalr	772(ra) # 3f7c <open>
    1c80:	00002097          	auipc	ra,0x2
    1c84:	2e4080e7          	jalr	740(ra) # 3f64 <close>
      close(open(file, 0));
    1c88:	4581                	li	a1,0
    1c8a:	fb840513          	addi	a0,s0,-72
    1c8e:	00002097          	auipc	ra,0x2
    1c92:	2ee080e7          	jalr	750(ra) # 3f7c <open>
    1c96:	00002097          	auipc	ra,0x2
    1c9a:	2ce080e7          	jalr	718(ra) # 3f64 <close>
      close(open(file, 0));
    1c9e:	4581                	li	a1,0
    1ca0:	fb840513          	addi	a0,s0,-72
    1ca4:	00002097          	auipc	ra,0x2
    1ca8:	2d8080e7          	jalr	728(ra) # 3f7c <open>
    1cac:	00002097          	auipc	ra,0x2
    1cb0:	2b8080e7          	jalr	696(ra) # 3f64 <close>
      close(open(file, 0));
    1cb4:	4581                	li	a1,0
    1cb6:	fb840513          	addi	a0,s0,-72
    1cba:	00002097          	auipc	ra,0x2
    1cbe:	2c2080e7          	jalr	706(ra) # 3f7c <open>
    1cc2:	00002097          	auipc	ra,0x2
    1cc6:	2a2080e7          	jalr	674(ra) # 3f64 <close>
      unlink(file);
      unlink(file);
      unlink(file);
      unlink(file);
    }
    if(pid == 0)
    1cca:	c4ad                	beqz	s1,1d34 <concreate+0x276>
      exit();
    else
      wait();
    1ccc:	00002097          	auipc	ra,0x2
    1cd0:	278080e7          	jalr	632(ra) # 3f44 <wait>
  for(i = 0; i < N; i++){
    1cd4:	2905                	addiw	s2,s2,1
    1cd6:	07390363          	beq	s2,s3,1d3c <concreate+0x27e>
    file[1] = '0' + i;
    1cda:	0309079b          	addiw	a5,s2,48
    1cde:	faf40ca3          	sb	a5,-71(s0)
    pid = fork();
    1ce2:	00002097          	auipc	ra,0x2
    1ce6:	252080e7          	jalr	594(ra) # 3f34 <fork>
    1cea:	84aa                	mv	s1,a0
    if(pid < 0){
    1cec:	f60547e3          	bltz	a0,1c5a <concreate+0x19c>
    if(((i % 3) == 0 && pid == 0) ||
    1cf0:	0349673b          	remw	a4,s2,s4
    1cf4:	00a767b3          	or	a5,a4,a0
    1cf8:	2781                	sext.w	a5,a5
    1cfa:	dfa5                	beqz	a5,1c72 <concreate+0x1b4>
    1cfc:	01571363          	bne	a4,s5,1d02 <concreate+0x244>
       ((i % 3) == 1 && pid != 0)){
    1d00:	f92d                	bnez	a0,1c72 <concreate+0x1b4>
      unlink(file);
    1d02:	fb840513          	addi	a0,s0,-72
    1d06:	00002097          	auipc	ra,0x2
    1d0a:	286080e7          	jalr	646(ra) # 3f8c <unlink>
      unlink(file);
    1d0e:	fb840513          	addi	a0,s0,-72
    1d12:	00002097          	auipc	ra,0x2
    1d16:	27a080e7          	jalr	634(ra) # 3f8c <unlink>
      unlink(file);
    1d1a:	fb840513          	addi	a0,s0,-72
    1d1e:	00002097          	auipc	ra,0x2
    1d22:	26e080e7          	jalr	622(ra) # 3f8c <unlink>
      unlink(file);
    1d26:	fb840513          	addi	a0,s0,-72
    1d2a:	00002097          	auipc	ra,0x2
    1d2e:	262080e7          	jalr	610(ra) # 3f8c <unlink>
    1d32:	bf61                	j	1cca <concreate+0x20c>
      exit();
    1d34:	00002097          	auipc	ra,0x2
    1d38:	208080e7          	jalr	520(ra) # 3f3c <exit>
  }

  printf("concreate ok\n");
    1d3c:	00003517          	auipc	a0,0x3
    1d40:	31c50513          	addi	a0,a0,796 # 5058 <malloc+0xcc6>
    1d44:	00002097          	auipc	ra,0x2
    1d48:	590080e7          	jalr	1424(ra) # 42d4 <printf>
}
    1d4c:	70e6                	ld	ra,120(sp)
    1d4e:	7446                	ld	s0,112(sp)
    1d50:	74a6                	ld	s1,104(sp)
    1d52:	7906                	ld	s2,96(sp)
    1d54:	69e6                	ld	s3,88(sp)
    1d56:	6a46                	ld	s4,80(sp)
    1d58:	6aa6                	ld	s5,72(sp)
    1d5a:	6109                	addi	sp,sp,128
    1d5c:	8082                	ret
      close(fd);
    1d5e:	00002097          	auipc	ra,0x2
    1d62:	206080e7          	jalr	518(ra) # 3f64 <close>
    if(pid == 0)
    1d66:	bbed                	j	1b60 <concreate+0xa2>
      close(fd);
    1d68:	00002097          	auipc	ra,0x2
    1d6c:	1fc080e7          	jalr	508(ra) # 3f64 <close>
      wait();
    1d70:	00002097          	auipc	ra,0x2
    1d74:	1d4080e7          	jalr	468(ra) # 3f44 <wait>
  for(i = 0; i < N; i++){
    1d78:	2485                	addiw	s1,s1,1
    1d7a:	df2487e3          	beq	s1,s2,1b68 <concreate+0xaa>
    file[1] = '0' + i;
    1d7e:	0304879b          	addiw	a5,s1,48
    1d82:	faf40ca3          	sb	a5,-71(s0)
    unlink(file);
    1d86:	fb840513          	addi	a0,s0,-72
    1d8a:	00002097          	auipc	ra,0x2
    1d8e:	202080e7          	jalr	514(ra) # 3f8c <unlink>
    pid = fork();
    1d92:	00002097          	auipc	ra,0x2
    1d96:	1a2080e7          	jalr	418(ra) # 3f34 <fork>
    if(pid && (i % 3) == 1){
    1d9a:	d6050be3          	beqz	a0,1b10 <concreate+0x52>
    1d9e:	0344e7bb          	remw	a5,s1,s4
    1da2:	d5378fe3          	beq	a5,s3,1b00 <concreate+0x42>
      fd = open(file, O_CREATE | O_RDWR);
    1da6:	20200593          	li	a1,514
    1daa:	fb840513          	addi	a0,s0,-72
    1dae:	00002097          	auipc	ra,0x2
    1db2:	1ce080e7          	jalr	462(ra) # 3f7c <open>
      if(fd < 0){
    1db6:	fa0559e3          	bgez	a0,1d68 <concreate+0x2aa>
    1dba:	bb9d                	j	1b30 <concreate+0x72>

0000000000001dbc <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1dbc:	711d                	addi	sp,sp,-96
    1dbe:	ec86                	sd	ra,88(sp)
    1dc0:	e8a2                	sd	s0,80(sp)
    1dc2:	e4a6                	sd	s1,72(sp)
    1dc4:	e0ca                	sd	s2,64(sp)
    1dc6:	fc4e                	sd	s3,56(sp)
    1dc8:	f852                	sd	s4,48(sp)
    1dca:	f456                	sd	s5,40(sp)
    1dcc:	f05a                	sd	s6,32(sp)
    1dce:	ec5e                	sd	s7,24(sp)
    1dd0:	e862                	sd	s8,16(sp)
    1dd2:	e466                	sd	s9,8(sp)
    1dd4:	1080                	addi	s0,sp,96
  int pid, i;

  printf("linkunlink test\n");
    1dd6:	00003517          	auipc	a0,0x3
    1dda:	29250513          	addi	a0,a0,658 # 5068 <malloc+0xcd6>
    1dde:	00002097          	auipc	ra,0x2
    1de2:	4f6080e7          	jalr	1270(ra) # 42d4 <printf>

  unlink("x");
    1de6:	00003517          	auipc	a0,0x3
    1dea:	c6a50513          	addi	a0,a0,-918 # 4a50 <malloc+0x6be>
    1dee:	00002097          	auipc	ra,0x2
    1df2:	19e080e7          	jalr	414(ra) # 3f8c <unlink>
  pid = fork();
    1df6:	00002097          	auipc	ra,0x2
    1dfa:	13e080e7          	jalr	318(ra) # 3f34 <fork>
  if(pid < 0){
    1dfe:	02054b63          	bltz	a0,1e34 <linkunlink+0x78>
    1e02:	8c2a                	mv	s8,a0
    printf("fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
    1e04:	4c85                	li	s9,1
    1e06:	e119                	bnez	a0,1e0c <linkunlink+0x50>
    1e08:	06100c93          	li	s9,97
    1e0c:	06400493          	li	s1,100
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    1e10:	41c659b7          	lui	s3,0x41c65
    1e14:	e6d9899b          	addiw	s3,s3,-403
    1e18:	690d                	lui	s2,0x3
    1e1a:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e1e:	4a0d                	li	s4,3
      close(open("x", O_RDWR | O_CREATE));
    } else if((x % 3) == 1){
    1e20:	4b05                	li	s6,1
      link("cat", "x");
    } else {
      unlink("x");
    1e22:	00003a97          	auipc	s5,0x3
    1e26:	c2ea8a93          	addi	s5,s5,-978 # 4a50 <malloc+0x6be>
      link("cat", "x");
    1e2a:	00003b97          	auipc	s7,0x3
    1e2e:	256b8b93          	addi	s7,s7,598 # 5080 <malloc+0xcee>
    1e32:	a815                	j	1e66 <linkunlink+0xaa>
    printf("fork failed\n");
    1e34:	00002517          	auipc	a0,0x2
    1e38:	70c50513          	addi	a0,a0,1804 # 4540 <malloc+0x1ae>
    1e3c:	00002097          	auipc	ra,0x2
    1e40:	498080e7          	jalr	1176(ra) # 42d4 <printf>
    exit();
    1e44:	00002097          	auipc	ra,0x2
    1e48:	0f8080e7          	jalr	248(ra) # 3f3c <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e4c:	20200593          	li	a1,514
    1e50:	8556                	mv	a0,s5
    1e52:	00002097          	auipc	ra,0x2
    1e56:	12a080e7          	jalr	298(ra) # 3f7c <open>
    1e5a:	00002097          	auipc	ra,0x2
    1e5e:	10a080e7          	jalr	266(ra) # 3f64 <close>
  for(i = 0; i < 100; i++){
    1e62:	34fd                	addiw	s1,s1,-1
    1e64:	c88d                	beqz	s1,1e96 <linkunlink+0xda>
    x = x * 1103515245 + 12345;
    1e66:	033c87bb          	mulw	a5,s9,s3
    1e6a:	012787bb          	addw	a5,a5,s2
    1e6e:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e72:	0347f7bb          	remuw	a5,a5,s4
    1e76:	dbf9                	beqz	a5,1e4c <linkunlink+0x90>
    } else if((x % 3) == 1){
    1e78:	01678863          	beq	a5,s6,1e88 <linkunlink+0xcc>
      unlink("x");
    1e7c:	8556                	mv	a0,s5
    1e7e:	00002097          	auipc	ra,0x2
    1e82:	10e080e7          	jalr	270(ra) # 3f8c <unlink>
    1e86:	bff1                	j	1e62 <linkunlink+0xa6>
      link("cat", "x");
    1e88:	85d6                	mv	a1,s5
    1e8a:	855e                	mv	a0,s7
    1e8c:	00002097          	auipc	ra,0x2
    1e90:	110080e7          	jalr	272(ra) # 3f9c <link>
    1e94:	b7f9                	j	1e62 <linkunlink+0xa6>
    }
  }

  if(pid)
    1e96:	020c0b63          	beqz	s8,1ecc <linkunlink+0x110>
    wait();
    1e9a:	00002097          	auipc	ra,0x2
    1e9e:	0aa080e7          	jalr	170(ra) # 3f44 <wait>
  else
    exit();

  printf("linkunlink ok\n");
    1ea2:	00003517          	auipc	a0,0x3
    1ea6:	1e650513          	addi	a0,a0,486 # 5088 <malloc+0xcf6>
    1eaa:	00002097          	auipc	ra,0x2
    1eae:	42a080e7          	jalr	1066(ra) # 42d4 <printf>
}
    1eb2:	60e6                	ld	ra,88(sp)
    1eb4:	6446                	ld	s0,80(sp)
    1eb6:	64a6                	ld	s1,72(sp)
    1eb8:	6906                	ld	s2,64(sp)
    1eba:	79e2                	ld	s3,56(sp)
    1ebc:	7a42                	ld	s4,48(sp)
    1ebe:	7aa2                	ld	s5,40(sp)
    1ec0:	7b02                	ld	s6,32(sp)
    1ec2:	6be2                	ld	s7,24(sp)
    1ec4:	6c42                	ld	s8,16(sp)
    1ec6:	6ca2                	ld	s9,8(sp)
    1ec8:	6125                	addi	sp,sp,96
    1eca:	8082                	ret
    exit();
    1ecc:	00002097          	auipc	ra,0x2
    1ed0:	070080e7          	jalr	112(ra) # 3f3c <exit>

0000000000001ed4 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1ed4:	715d                	addi	sp,sp,-80
    1ed6:	e486                	sd	ra,72(sp)
    1ed8:	e0a2                	sd	s0,64(sp)
    1eda:	fc26                	sd	s1,56(sp)
    1edc:	f84a                	sd	s2,48(sp)
    1ede:	f44e                	sd	s3,40(sp)
    1ee0:	f052                	sd	s4,32(sp)
    1ee2:	ec56                	sd	s5,24(sp)
    1ee4:	0880                	addi	s0,sp,80
  enum { N = 500 };
  int i, fd;
  char name[10];

  printf("bigdir test\n");
    1ee6:	00003517          	auipc	a0,0x3
    1eea:	1b250513          	addi	a0,a0,434 # 5098 <malloc+0xd06>
    1eee:	00002097          	auipc	ra,0x2
    1ef2:	3e6080e7          	jalr	998(ra) # 42d4 <printf>
  unlink("bd");
    1ef6:	00003517          	auipc	a0,0x3
    1efa:	1b250513          	addi	a0,a0,434 # 50a8 <malloc+0xd16>
    1efe:	00002097          	auipc	ra,0x2
    1f02:	08e080e7          	jalr	142(ra) # 3f8c <unlink>

  fd = open("bd", O_CREATE);
    1f06:	20000593          	li	a1,512
    1f0a:	00003517          	auipc	a0,0x3
    1f0e:	19e50513          	addi	a0,a0,414 # 50a8 <malloc+0xd16>
    1f12:	00002097          	auipc	ra,0x2
    1f16:	06a080e7          	jalr	106(ra) # 3f7c <open>
  if(fd < 0){
    1f1a:	0e054063          	bltz	a0,1ffa <bigdir+0x126>
    printf("bigdir create failed\n");
    exit();
  }
  close(fd);
    1f1e:	00002097          	auipc	ra,0x2
    1f22:	046080e7          	jalr	70(ra) # 3f64 <close>

  for(i = 0; i < N; i++){
    1f26:	4901                	li	s2,0
    name[0] = 'x';
    1f28:	07800a13          	li	s4,120
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(link("bd", name) != 0){
    1f2c:	00003997          	auipc	s3,0x3
    1f30:	17c98993          	addi	s3,s3,380 # 50a8 <malloc+0xd16>
  for(i = 0; i < N; i++){
    1f34:	1f400a93          	li	s5,500
    name[0] = 'x';
    1f38:	fb440823          	sb	s4,-80(s0)
    name[1] = '0' + (i / 64);
    1f3c:	41f9579b          	sraiw	a5,s2,0x1f
    1f40:	01a7d71b          	srliw	a4,a5,0x1a
    1f44:	012707bb          	addw	a5,a4,s2
    1f48:	4067d69b          	sraiw	a3,a5,0x6
    1f4c:	0306869b          	addiw	a3,a3,48
    1f50:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1f54:	03f7f793          	andi	a5,a5,63
    1f58:	9f99                	subw	a5,a5,a4
    1f5a:	0307879b          	addiw	a5,a5,48
    1f5e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1f62:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1f66:	fb040593          	addi	a1,s0,-80
    1f6a:	854e                	mv	a0,s3
    1f6c:	00002097          	auipc	ra,0x2
    1f70:	030080e7          	jalr	48(ra) # 3f9c <link>
    1f74:	84aa                	mv	s1,a0
    1f76:	ed51                	bnez	a0,2012 <bigdir+0x13e>
  for(i = 0; i < N; i++){
    1f78:	2905                	addiw	s2,s2,1
    1f7a:	fb591fe3          	bne	s2,s5,1f38 <bigdir+0x64>
      printf("bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1f7e:	00003517          	auipc	a0,0x3
    1f82:	12a50513          	addi	a0,a0,298 # 50a8 <malloc+0xd16>
    1f86:	00002097          	auipc	ra,0x2
    1f8a:	006080e7          	jalr	6(ra) # 3f8c <unlink>
  for(i = 0; i < N; i++){
    name[0] = 'x';
    1f8e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1f92:	1f400993          	li	s3,500
    name[0] = 'x';
    1f96:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1f9a:	41f4d79b          	sraiw	a5,s1,0x1f
    1f9e:	01a7d71b          	srliw	a4,a5,0x1a
    1fa2:	009707bb          	addw	a5,a4,s1
    1fa6:	4067d69b          	sraiw	a3,a5,0x6
    1faa:	0306869b          	addiw	a3,a3,48
    1fae:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1fb2:	03f7f793          	andi	a5,a5,63
    1fb6:	9f99                	subw	a5,a5,a4
    1fb8:	0307879b          	addiw	a5,a5,48
    1fbc:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1fc0:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1fc4:	fb040513          	addi	a0,s0,-80
    1fc8:	00002097          	auipc	ra,0x2
    1fcc:	fc4080e7          	jalr	-60(ra) # 3f8c <unlink>
    1fd0:	ed29                	bnez	a0,202a <bigdir+0x156>
  for(i = 0; i < N; i++){
    1fd2:	2485                	addiw	s1,s1,1
    1fd4:	fd3491e3          	bne	s1,s3,1f96 <bigdir+0xc2>
      printf("bigdir unlink failed");
      exit();
    }
  }

  printf("bigdir ok\n");
    1fd8:	00003517          	auipc	a0,0x3
    1fdc:	12050513          	addi	a0,a0,288 # 50f8 <malloc+0xd66>
    1fe0:	00002097          	auipc	ra,0x2
    1fe4:	2f4080e7          	jalr	756(ra) # 42d4 <printf>
}
    1fe8:	60a6                	ld	ra,72(sp)
    1fea:	6406                	ld	s0,64(sp)
    1fec:	74e2                	ld	s1,56(sp)
    1fee:	7942                	ld	s2,48(sp)
    1ff0:	79a2                	ld	s3,40(sp)
    1ff2:	7a02                	ld	s4,32(sp)
    1ff4:	6ae2                	ld	s5,24(sp)
    1ff6:	6161                	addi	sp,sp,80
    1ff8:	8082                	ret
    printf("bigdir create failed\n");
    1ffa:	00003517          	auipc	a0,0x3
    1ffe:	0b650513          	addi	a0,a0,182 # 50b0 <malloc+0xd1e>
    2002:	00002097          	auipc	ra,0x2
    2006:	2d2080e7          	jalr	722(ra) # 42d4 <printf>
    exit();
    200a:	00002097          	auipc	ra,0x2
    200e:	f32080e7          	jalr	-206(ra) # 3f3c <exit>
      printf("bigdir link failed\n");
    2012:	00003517          	auipc	a0,0x3
    2016:	0b650513          	addi	a0,a0,182 # 50c8 <malloc+0xd36>
    201a:	00002097          	auipc	ra,0x2
    201e:	2ba080e7          	jalr	698(ra) # 42d4 <printf>
      exit();
    2022:	00002097          	auipc	ra,0x2
    2026:	f1a080e7          	jalr	-230(ra) # 3f3c <exit>
      printf("bigdir unlink failed");
    202a:	00003517          	auipc	a0,0x3
    202e:	0b650513          	addi	a0,a0,182 # 50e0 <malloc+0xd4e>
    2032:	00002097          	auipc	ra,0x2
    2036:	2a2080e7          	jalr	674(ra) # 42d4 <printf>
      exit();
    203a:	00002097          	auipc	ra,0x2
    203e:	f02080e7          	jalr	-254(ra) # 3f3c <exit>

0000000000002042 <subdir>:

void
subdir(void)
{
    2042:	1101                	addi	sp,sp,-32
    2044:	ec06                	sd	ra,24(sp)
    2046:	e822                	sd	s0,16(sp)
    2048:	e426                	sd	s1,8(sp)
    204a:	1000                	addi	s0,sp,32
  int fd, cc;

  printf("subdir test\n");
    204c:	00003517          	auipc	a0,0x3
    2050:	0bc50513          	addi	a0,a0,188 # 5108 <malloc+0xd76>
    2054:	00002097          	auipc	ra,0x2
    2058:	280080e7          	jalr	640(ra) # 42d4 <printf>

  unlink("ff");
    205c:	00003517          	auipc	a0,0x3
    2060:	1d450513          	addi	a0,a0,468 # 5230 <malloc+0xe9e>
    2064:	00002097          	auipc	ra,0x2
    2068:	f28080e7          	jalr	-216(ra) # 3f8c <unlink>
  if(mkdir("dd") != 0){
    206c:	00003517          	auipc	a0,0x3
    2070:	0ac50513          	addi	a0,a0,172 # 5118 <malloc+0xd86>
    2074:	00002097          	auipc	ra,0x2
    2078:	f30080e7          	jalr	-208(ra) # 3fa4 <mkdir>
    207c:	38051d63          	bnez	a0,2416 <subdir+0x3d4>
    printf("subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    2080:	20200593          	li	a1,514
    2084:	00003517          	auipc	a0,0x3
    2088:	0b450513          	addi	a0,a0,180 # 5138 <malloc+0xda6>
    208c:	00002097          	auipc	ra,0x2
    2090:	ef0080e7          	jalr	-272(ra) # 3f7c <open>
    2094:	84aa                	mv	s1,a0
  if(fd < 0){
    2096:	38054c63          	bltz	a0,242e <subdir+0x3ec>
    printf("create dd/ff failed\n");
    exit();
  }
  write(fd, "ff", 2);
    209a:	4609                	li	a2,2
    209c:	00003597          	auipc	a1,0x3
    20a0:	19458593          	addi	a1,a1,404 # 5230 <malloc+0xe9e>
    20a4:	00002097          	auipc	ra,0x2
    20a8:	eb8080e7          	jalr	-328(ra) # 3f5c <write>
  close(fd);
    20ac:	8526                	mv	a0,s1
    20ae:	00002097          	auipc	ra,0x2
    20b2:	eb6080e7          	jalr	-330(ra) # 3f64 <close>

  if(unlink("dd") >= 0){
    20b6:	00003517          	auipc	a0,0x3
    20ba:	06250513          	addi	a0,a0,98 # 5118 <malloc+0xd86>
    20be:	00002097          	auipc	ra,0x2
    20c2:	ece080e7          	jalr	-306(ra) # 3f8c <unlink>
    20c6:	38055063          	bgez	a0,2446 <subdir+0x404>
    printf("unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    20ca:	00003517          	auipc	a0,0x3
    20ce:	0b650513          	addi	a0,a0,182 # 5180 <malloc+0xdee>
    20d2:	00002097          	auipc	ra,0x2
    20d6:	ed2080e7          	jalr	-302(ra) # 3fa4 <mkdir>
    20da:	38051263          	bnez	a0,245e <subdir+0x41c>
    printf("subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    20de:	20200593          	li	a1,514
    20e2:	00003517          	auipc	a0,0x3
    20e6:	0c650513          	addi	a0,a0,198 # 51a8 <malloc+0xe16>
    20ea:	00002097          	auipc	ra,0x2
    20ee:	e92080e7          	jalr	-366(ra) # 3f7c <open>
    20f2:	84aa                	mv	s1,a0
  if(fd < 0){
    20f4:	38054163          	bltz	a0,2476 <subdir+0x434>
    printf("create dd/dd/ff failed\n");
    exit();
  }
  write(fd, "FF", 2);
    20f8:	4609                	li	a2,2
    20fa:	00003597          	auipc	a1,0x3
    20fe:	0d658593          	addi	a1,a1,214 # 51d0 <malloc+0xe3e>
    2102:	00002097          	auipc	ra,0x2
    2106:	e5a080e7          	jalr	-422(ra) # 3f5c <write>
  close(fd);
    210a:	8526                	mv	a0,s1
    210c:	00002097          	auipc	ra,0x2
    2110:	e58080e7          	jalr	-424(ra) # 3f64 <close>

  fd = open("dd/dd/../ff", 0);
    2114:	4581                	li	a1,0
    2116:	00003517          	auipc	a0,0x3
    211a:	0c250513          	addi	a0,a0,194 # 51d8 <malloc+0xe46>
    211e:	00002097          	auipc	ra,0x2
    2122:	e5e080e7          	jalr	-418(ra) # 3f7c <open>
    2126:	84aa                	mv	s1,a0
  if(fd < 0){
    2128:	36054363          	bltz	a0,248e <subdir+0x44c>
    printf("open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
    212c:	660d                	lui	a2,0x3
    212e:	00007597          	auipc	a1,0x7
    2132:	93258593          	addi	a1,a1,-1742 # 8a60 <buf>
    2136:	00002097          	auipc	ra,0x2
    213a:	e1e080e7          	jalr	-482(ra) # 3f54 <read>
  if(cc != 2 || buf[0] != 'f'){
    213e:	4789                	li	a5,2
    2140:	36f51363          	bne	a0,a5,24a6 <subdir+0x464>
    2144:	00007717          	auipc	a4,0x7
    2148:	91c74703          	lbu	a4,-1764(a4) # 8a60 <buf>
    214c:	06600793          	li	a5,102
    2150:	34f71b63          	bne	a4,a5,24a6 <subdir+0x464>
    printf("dd/dd/../ff wrong content\n");
    exit();
  }
  close(fd);
    2154:	8526                	mv	a0,s1
    2156:	00002097          	auipc	ra,0x2
    215a:	e0e080e7          	jalr	-498(ra) # 3f64 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    215e:	00003597          	auipc	a1,0x3
    2162:	0ca58593          	addi	a1,a1,202 # 5228 <malloc+0xe96>
    2166:	00003517          	auipc	a0,0x3
    216a:	04250513          	addi	a0,a0,66 # 51a8 <malloc+0xe16>
    216e:	00002097          	auipc	ra,0x2
    2172:	e2e080e7          	jalr	-466(ra) # 3f9c <link>
    2176:	34051463          	bnez	a0,24be <subdir+0x47c>
    printf("link dd/dd/ff dd/dd/ffff failed\n");
    exit();
  }

  if(unlink("dd/dd/ff") != 0){
    217a:	00003517          	auipc	a0,0x3
    217e:	02e50513          	addi	a0,a0,46 # 51a8 <malloc+0xe16>
    2182:	00002097          	auipc	ra,0x2
    2186:	e0a080e7          	jalr	-502(ra) # 3f8c <unlink>
    218a:	34051663          	bnez	a0,24d6 <subdir+0x494>
    printf("unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    218e:	4581                	li	a1,0
    2190:	00003517          	auipc	a0,0x3
    2194:	01850513          	addi	a0,a0,24 # 51a8 <malloc+0xe16>
    2198:	00002097          	auipc	ra,0x2
    219c:	de4080e7          	jalr	-540(ra) # 3f7c <open>
    21a0:	34055763          	bgez	a0,24ee <subdir+0x4ac>
    printf("open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    21a4:	00003517          	auipc	a0,0x3
    21a8:	f7450513          	addi	a0,a0,-140 # 5118 <malloc+0xd86>
    21ac:	00002097          	auipc	ra,0x2
    21b0:	e00080e7          	jalr	-512(ra) # 3fac <chdir>
    21b4:	34051963          	bnez	a0,2506 <subdir+0x4c4>
    printf("chdir dd failed\n");
    exit();
  }
  if(chdir("dd/../../dd") != 0){
    21b8:	00003517          	auipc	a0,0x3
    21bc:	10050513          	addi	a0,a0,256 # 52b8 <malloc+0xf26>
    21c0:	00002097          	auipc	ra,0x2
    21c4:	dec080e7          	jalr	-532(ra) # 3fac <chdir>
    21c8:	34051b63          	bnez	a0,251e <subdir+0x4dc>
    printf("chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    21cc:	00003517          	auipc	a0,0x3
    21d0:	11c50513          	addi	a0,a0,284 # 52e8 <malloc+0xf56>
    21d4:	00002097          	auipc	ra,0x2
    21d8:	dd8080e7          	jalr	-552(ra) # 3fac <chdir>
    21dc:	34051d63          	bnez	a0,2536 <subdir+0x4f4>
    printf("chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    21e0:	00003517          	auipc	a0,0x3
    21e4:	11850513          	addi	a0,a0,280 # 52f8 <malloc+0xf66>
    21e8:	00002097          	auipc	ra,0x2
    21ec:	dc4080e7          	jalr	-572(ra) # 3fac <chdir>
    21f0:	34051f63          	bnez	a0,254e <subdir+0x50c>
    printf("chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    21f4:	4581                	li	a1,0
    21f6:	00003517          	auipc	a0,0x3
    21fa:	03250513          	addi	a0,a0,50 # 5228 <malloc+0xe96>
    21fe:	00002097          	auipc	ra,0x2
    2202:	d7e080e7          	jalr	-642(ra) # 3f7c <open>
    2206:	84aa                	mv	s1,a0
  if(fd < 0){
    2208:	34054f63          	bltz	a0,2566 <subdir+0x524>
    printf("open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    220c:	660d                	lui	a2,0x3
    220e:	00007597          	auipc	a1,0x7
    2212:	85258593          	addi	a1,a1,-1966 # 8a60 <buf>
    2216:	00002097          	auipc	ra,0x2
    221a:	d3e080e7          	jalr	-706(ra) # 3f54 <read>
    221e:	4789                	li	a5,2
    2220:	34f51f63          	bne	a0,a5,257e <subdir+0x53c>
    printf("read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);
    2224:	8526                	mv	a0,s1
    2226:	00002097          	auipc	ra,0x2
    222a:	d3e080e7          	jalr	-706(ra) # 3f64 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    222e:	4581                	li	a1,0
    2230:	00003517          	auipc	a0,0x3
    2234:	f7850513          	addi	a0,a0,-136 # 51a8 <malloc+0xe16>
    2238:	00002097          	auipc	ra,0x2
    223c:	d44080e7          	jalr	-700(ra) # 3f7c <open>
    2240:	34055b63          	bgez	a0,2596 <subdir+0x554>
    printf("open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2244:	20200593          	li	a1,514
    2248:	00003517          	auipc	a0,0x3
    224c:	13050513          	addi	a0,a0,304 # 5378 <malloc+0xfe6>
    2250:	00002097          	auipc	ra,0x2
    2254:	d2c080e7          	jalr	-724(ra) # 3f7c <open>
    2258:	34055b63          	bgez	a0,25ae <subdir+0x56c>
    printf("create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    225c:	20200593          	li	a1,514
    2260:	00003517          	auipc	a0,0x3
    2264:	14850513          	addi	a0,a0,328 # 53a8 <malloc+0x1016>
    2268:	00002097          	auipc	ra,0x2
    226c:	d14080e7          	jalr	-748(ra) # 3f7c <open>
    2270:	34055b63          	bgez	a0,25c6 <subdir+0x584>
    printf("create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    2274:	20000593          	li	a1,512
    2278:	00003517          	auipc	a0,0x3
    227c:	ea050513          	addi	a0,a0,-352 # 5118 <malloc+0xd86>
    2280:	00002097          	auipc	ra,0x2
    2284:	cfc080e7          	jalr	-772(ra) # 3f7c <open>
    2288:	34055b63          	bgez	a0,25de <subdir+0x59c>
    printf("create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    228c:	4589                	li	a1,2
    228e:	00003517          	auipc	a0,0x3
    2292:	e8a50513          	addi	a0,a0,-374 # 5118 <malloc+0xd86>
    2296:	00002097          	auipc	ra,0x2
    229a:	ce6080e7          	jalr	-794(ra) # 3f7c <open>
    229e:	34055c63          	bgez	a0,25f6 <subdir+0x5b4>
    printf("open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    22a2:	4585                	li	a1,1
    22a4:	00003517          	auipc	a0,0x3
    22a8:	e7450513          	addi	a0,a0,-396 # 5118 <malloc+0xd86>
    22ac:	00002097          	auipc	ra,0x2
    22b0:	cd0080e7          	jalr	-816(ra) # 3f7c <open>
    22b4:	34055d63          	bgez	a0,260e <subdir+0x5cc>
    printf("open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    22b8:	00003597          	auipc	a1,0x3
    22bc:	17858593          	addi	a1,a1,376 # 5430 <malloc+0x109e>
    22c0:	00003517          	auipc	a0,0x3
    22c4:	0b850513          	addi	a0,a0,184 # 5378 <malloc+0xfe6>
    22c8:	00002097          	auipc	ra,0x2
    22cc:	cd4080e7          	jalr	-812(ra) # 3f9c <link>
    22d0:	34050b63          	beqz	a0,2626 <subdir+0x5e4>
    printf("link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    22d4:	00003597          	auipc	a1,0x3
    22d8:	15c58593          	addi	a1,a1,348 # 5430 <malloc+0x109e>
    22dc:	00003517          	auipc	a0,0x3
    22e0:	0cc50513          	addi	a0,a0,204 # 53a8 <malloc+0x1016>
    22e4:	00002097          	auipc	ra,0x2
    22e8:	cb8080e7          	jalr	-840(ra) # 3f9c <link>
    22ec:	34050963          	beqz	a0,263e <subdir+0x5fc>
    printf("link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    22f0:	00003597          	auipc	a1,0x3
    22f4:	f3858593          	addi	a1,a1,-200 # 5228 <malloc+0xe96>
    22f8:	00003517          	auipc	a0,0x3
    22fc:	e4050513          	addi	a0,a0,-448 # 5138 <malloc+0xda6>
    2300:	00002097          	auipc	ra,0x2
    2304:	c9c080e7          	jalr	-868(ra) # 3f9c <link>
    2308:	34050763          	beqz	a0,2656 <subdir+0x614>
    printf("link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    230c:	00003517          	auipc	a0,0x3
    2310:	06c50513          	addi	a0,a0,108 # 5378 <malloc+0xfe6>
    2314:	00002097          	auipc	ra,0x2
    2318:	c90080e7          	jalr	-880(ra) # 3fa4 <mkdir>
    231c:	34050963          	beqz	a0,266e <subdir+0x62c>
    printf("mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    2320:	00003517          	auipc	a0,0x3
    2324:	08850513          	addi	a0,a0,136 # 53a8 <malloc+0x1016>
    2328:	00002097          	auipc	ra,0x2
    232c:	c7c080e7          	jalr	-900(ra) # 3fa4 <mkdir>
    2330:	34050b63          	beqz	a0,2686 <subdir+0x644>
    printf("mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    2334:	00003517          	auipc	a0,0x3
    2338:	ef450513          	addi	a0,a0,-268 # 5228 <malloc+0xe96>
    233c:	00002097          	auipc	ra,0x2
    2340:	c68080e7          	jalr	-920(ra) # 3fa4 <mkdir>
    2344:	34050d63          	beqz	a0,269e <subdir+0x65c>
    printf("mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    2348:	00003517          	auipc	a0,0x3
    234c:	06050513          	addi	a0,a0,96 # 53a8 <malloc+0x1016>
    2350:	00002097          	auipc	ra,0x2
    2354:	c3c080e7          	jalr	-964(ra) # 3f8c <unlink>
    2358:	34050f63          	beqz	a0,26b6 <subdir+0x674>
    printf("unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    235c:	00003517          	auipc	a0,0x3
    2360:	01c50513          	addi	a0,a0,28 # 5378 <malloc+0xfe6>
    2364:	00002097          	auipc	ra,0x2
    2368:	c28080e7          	jalr	-984(ra) # 3f8c <unlink>
    236c:	36050163          	beqz	a0,26ce <subdir+0x68c>
    printf("unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    2370:	00003517          	auipc	a0,0x3
    2374:	dc850513          	addi	a0,a0,-568 # 5138 <malloc+0xda6>
    2378:	00002097          	auipc	ra,0x2
    237c:	c34080e7          	jalr	-972(ra) # 3fac <chdir>
    2380:	36050363          	beqz	a0,26e6 <subdir+0x6a4>
    printf("chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    2384:	00003517          	auipc	a0,0x3
    2388:	1ec50513          	addi	a0,a0,492 # 5570 <malloc+0x11de>
    238c:	00002097          	auipc	ra,0x2
    2390:	c20080e7          	jalr	-992(ra) # 3fac <chdir>
    2394:	36050563          	beqz	a0,26fe <subdir+0x6bc>
    printf("chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    2398:	00003517          	auipc	a0,0x3
    239c:	e9050513          	addi	a0,a0,-368 # 5228 <malloc+0xe96>
    23a0:	00002097          	auipc	ra,0x2
    23a4:	bec080e7          	jalr	-1044(ra) # 3f8c <unlink>
    23a8:	36051763          	bnez	a0,2716 <subdir+0x6d4>
    printf("unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    23ac:	00003517          	auipc	a0,0x3
    23b0:	d8c50513          	addi	a0,a0,-628 # 5138 <malloc+0xda6>
    23b4:	00002097          	auipc	ra,0x2
    23b8:	bd8080e7          	jalr	-1064(ra) # 3f8c <unlink>
    23bc:	36051963          	bnez	a0,272e <subdir+0x6ec>
    printf("unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    23c0:	00003517          	auipc	a0,0x3
    23c4:	d5850513          	addi	a0,a0,-680 # 5118 <malloc+0xd86>
    23c8:	00002097          	auipc	ra,0x2
    23cc:	bc4080e7          	jalr	-1084(ra) # 3f8c <unlink>
    23d0:	36050b63          	beqz	a0,2746 <subdir+0x704>
    printf("unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    23d4:	00003517          	auipc	a0,0x3
    23d8:	1f450513          	addi	a0,a0,500 # 55c8 <malloc+0x1236>
    23dc:	00002097          	auipc	ra,0x2
    23e0:	bb0080e7          	jalr	-1104(ra) # 3f8c <unlink>
    23e4:	36054d63          	bltz	a0,275e <subdir+0x71c>
    printf("unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    23e8:	00003517          	auipc	a0,0x3
    23ec:	d3050513          	addi	a0,a0,-720 # 5118 <malloc+0xd86>
    23f0:	00002097          	auipc	ra,0x2
    23f4:	b9c080e7          	jalr	-1124(ra) # 3f8c <unlink>
    23f8:	36054f63          	bltz	a0,2776 <subdir+0x734>
    printf("unlink dd failed\n");
    exit();
  }

  printf("subdir ok\n");
    23fc:	00003517          	auipc	a0,0x3
    2400:	20450513          	addi	a0,a0,516 # 5600 <malloc+0x126e>
    2404:	00002097          	auipc	ra,0x2
    2408:	ed0080e7          	jalr	-304(ra) # 42d4 <printf>
}
    240c:	60e2                	ld	ra,24(sp)
    240e:	6442                	ld	s0,16(sp)
    2410:	64a2                	ld	s1,8(sp)
    2412:	6105                	addi	sp,sp,32
    2414:	8082                	ret
    printf("subdir mkdir dd failed\n");
    2416:	00003517          	auipc	a0,0x3
    241a:	d0a50513          	addi	a0,a0,-758 # 5120 <malloc+0xd8e>
    241e:	00002097          	auipc	ra,0x2
    2422:	eb6080e7          	jalr	-330(ra) # 42d4 <printf>
    exit();
    2426:	00002097          	auipc	ra,0x2
    242a:	b16080e7          	jalr	-1258(ra) # 3f3c <exit>
    printf("create dd/ff failed\n");
    242e:	00003517          	auipc	a0,0x3
    2432:	d1250513          	addi	a0,a0,-750 # 5140 <malloc+0xdae>
    2436:	00002097          	auipc	ra,0x2
    243a:	e9e080e7          	jalr	-354(ra) # 42d4 <printf>
    exit();
    243e:	00002097          	auipc	ra,0x2
    2442:	afe080e7          	jalr	-1282(ra) # 3f3c <exit>
    printf("unlink dd (non-empty dir) succeeded!\n");
    2446:	00003517          	auipc	a0,0x3
    244a:	d1250513          	addi	a0,a0,-750 # 5158 <malloc+0xdc6>
    244e:	00002097          	auipc	ra,0x2
    2452:	e86080e7          	jalr	-378(ra) # 42d4 <printf>
    exit();
    2456:	00002097          	auipc	ra,0x2
    245a:	ae6080e7          	jalr	-1306(ra) # 3f3c <exit>
    printf("subdir mkdir dd/dd failed\n");
    245e:	00003517          	auipc	a0,0x3
    2462:	d2a50513          	addi	a0,a0,-726 # 5188 <malloc+0xdf6>
    2466:	00002097          	auipc	ra,0x2
    246a:	e6e080e7          	jalr	-402(ra) # 42d4 <printf>
    exit();
    246e:	00002097          	auipc	ra,0x2
    2472:	ace080e7          	jalr	-1330(ra) # 3f3c <exit>
    printf("create dd/dd/ff failed\n");
    2476:	00003517          	auipc	a0,0x3
    247a:	d4250513          	addi	a0,a0,-702 # 51b8 <malloc+0xe26>
    247e:	00002097          	auipc	ra,0x2
    2482:	e56080e7          	jalr	-426(ra) # 42d4 <printf>
    exit();
    2486:	00002097          	auipc	ra,0x2
    248a:	ab6080e7          	jalr	-1354(ra) # 3f3c <exit>
    printf("open dd/dd/../ff failed\n");
    248e:	00003517          	auipc	a0,0x3
    2492:	d5a50513          	addi	a0,a0,-678 # 51e8 <malloc+0xe56>
    2496:	00002097          	auipc	ra,0x2
    249a:	e3e080e7          	jalr	-450(ra) # 42d4 <printf>
    exit();
    249e:	00002097          	auipc	ra,0x2
    24a2:	a9e080e7          	jalr	-1378(ra) # 3f3c <exit>
    printf("dd/dd/../ff wrong content\n");
    24a6:	00003517          	auipc	a0,0x3
    24aa:	d6250513          	addi	a0,a0,-670 # 5208 <malloc+0xe76>
    24ae:	00002097          	auipc	ra,0x2
    24b2:	e26080e7          	jalr	-474(ra) # 42d4 <printf>
    exit();
    24b6:	00002097          	auipc	ra,0x2
    24ba:	a86080e7          	jalr	-1402(ra) # 3f3c <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n");
    24be:	00003517          	auipc	a0,0x3
    24c2:	d7a50513          	addi	a0,a0,-646 # 5238 <malloc+0xea6>
    24c6:	00002097          	auipc	ra,0x2
    24ca:	e0e080e7          	jalr	-498(ra) # 42d4 <printf>
    exit();
    24ce:	00002097          	auipc	ra,0x2
    24d2:	a6e080e7          	jalr	-1426(ra) # 3f3c <exit>
    printf("unlink dd/dd/ff failed\n");
    24d6:	00003517          	auipc	a0,0x3
    24da:	d8a50513          	addi	a0,a0,-630 # 5260 <malloc+0xece>
    24de:	00002097          	auipc	ra,0x2
    24e2:	df6080e7          	jalr	-522(ra) # 42d4 <printf>
    exit();
    24e6:	00002097          	auipc	ra,0x2
    24ea:	a56080e7          	jalr	-1450(ra) # 3f3c <exit>
    printf("open (unlinked) dd/dd/ff succeeded\n");
    24ee:	00003517          	auipc	a0,0x3
    24f2:	d8a50513          	addi	a0,a0,-630 # 5278 <malloc+0xee6>
    24f6:	00002097          	auipc	ra,0x2
    24fa:	dde080e7          	jalr	-546(ra) # 42d4 <printf>
    exit();
    24fe:	00002097          	auipc	ra,0x2
    2502:	a3e080e7          	jalr	-1474(ra) # 3f3c <exit>
    printf("chdir dd failed\n");
    2506:	00003517          	auipc	a0,0x3
    250a:	d9a50513          	addi	a0,a0,-614 # 52a0 <malloc+0xf0e>
    250e:	00002097          	auipc	ra,0x2
    2512:	dc6080e7          	jalr	-570(ra) # 42d4 <printf>
    exit();
    2516:	00002097          	auipc	ra,0x2
    251a:	a26080e7          	jalr	-1498(ra) # 3f3c <exit>
    printf("chdir dd/../../dd failed\n");
    251e:	00003517          	auipc	a0,0x3
    2522:	daa50513          	addi	a0,a0,-598 # 52c8 <malloc+0xf36>
    2526:	00002097          	auipc	ra,0x2
    252a:	dae080e7          	jalr	-594(ra) # 42d4 <printf>
    exit();
    252e:	00002097          	auipc	ra,0x2
    2532:	a0e080e7          	jalr	-1522(ra) # 3f3c <exit>
    printf("chdir dd/../../dd failed\n");
    2536:	00003517          	auipc	a0,0x3
    253a:	d9250513          	addi	a0,a0,-622 # 52c8 <malloc+0xf36>
    253e:	00002097          	auipc	ra,0x2
    2542:	d96080e7          	jalr	-618(ra) # 42d4 <printf>
    exit();
    2546:	00002097          	auipc	ra,0x2
    254a:	9f6080e7          	jalr	-1546(ra) # 3f3c <exit>
    printf("chdir ./.. failed\n");
    254e:	00003517          	auipc	a0,0x3
    2552:	db250513          	addi	a0,a0,-590 # 5300 <malloc+0xf6e>
    2556:	00002097          	auipc	ra,0x2
    255a:	d7e080e7          	jalr	-642(ra) # 42d4 <printf>
    exit();
    255e:	00002097          	auipc	ra,0x2
    2562:	9de080e7          	jalr	-1570(ra) # 3f3c <exit>
    printf("open dd/dd/ffff failed\n");
    2566:	00003517          	auipc	a0,0x3
    256a:	db250513          	addi	a0,a0,-590 # 5318 <malloc+0xf86>
    256e:	00002097          	auipc	ra,0x2
    2572:	d66080e7          	jalr	-666(ra) # 42d4 <printf>
    exit();
    2576:	00002097          	auipc	ra,0x2
    257a:	9c6080e7          	jalr	-1594(ra) # 3f3c <exit>
    printf("read dd/dd/ffff wrong len\n");
    257e:	00003517          	auipc	a0,0x3
    2582:	db250513          	addi	a0,a0,-590 # 5330 <malloc+0xf9e>
    2586:	00002097          	auipc	ra,0x2
    258a:	d4e080e7          	jalr	-690(ra) # 42d4 <printf>
    exit();
    258e:	00002097          	auipc	ra,0x2
    2592:	9ae080e7          	jalr	-1618(ra) # 3f3c <exit>
    printf("open (unlinked) dd/dd/ff succeeded!\n");
    2596:	00003517          	auipc	a0,0x3
    259a:	dba50513          	addi	a0,a0,-582 # 5350 <malloc+0xfbe>
    259e:	00002097          	auipc	ra,0x2
    25a2:	d36080e7          	jalr	-714(ra) # 42d4 <printf>
    exit();
    25a6:	00002097          	auipc	ra,0x2
    25aa:	996080e7          	jalr	-1642(ra) # 3f3c <exit>
    printf("create dd/ff/ff succeeded!\n");
    25ae:	00003517          	auipc	a0,0x3
    25b2:	dda50513          	addi	a0,a0,-550 # 5388 <malloc+0xff6>
    25b6:	00002097          	auipc	ra,0x2
    25ba:	d1e080e7          	jalr	-738(ra) # 42d4 <printf>
    exit();
    25be:	00002097          	auipc	ra,0x2
    25c2:	97e080e7          	jalr	-1666(ra) # 3f3c <exit>
    printf("create dd/xx/ff succeeded!\n");
    25c6:	00003517          	auipc	a0,0x3
    25ca:	df250513          	addi	a0,a0,-526 # 53b8 <malloc+0x1026>
    25ce:	00002097          	auipc	ra,0x2
    25d2:	d06080e7          	jalr	-762(ra) # 42d4 <printf>
    exit();
    25d6:	00002097          	auipc	ra,0x2
    25da:	966080e7          	jalr	-1690(ra) # 3f3c <exit>
    printf("create dd succeeded!\n");
    25de:	00003517          	auipc	a0,0x3
    25e2:	dfa50513          	addi	a0,a0,-518 # 53d8 <malloc+0x1046>
    25e6:	00002097          	auipc	ra,0x2
    25ea:	cee080e7          	jalr	-786(ra) # 42d4 <printf>
    exit();
    25ee:	00002097          	auipc	ra,0x2
    25f2:	94e080e7          	jalr	-1714(ra) # 3f3c <exit>
    printf("open dd rdwr succeeded!\n");
    25f6:	00003517          	auipc	a0,0x3
    25fa:	dfa50513          	addi	a0,a0,-518 # 53f0 <malloc+0x105e>
    25fe:	00002097          	auipc	ra,0x2
    2602:	cd6080e7          	jalr	-810(ra) # 42d4 <printf>
    exit();
    2606:	00002097          	auipc	ra,0x2
    260a:	936080e7          	jalr	-1738(ra) # 3f3c <exit>
    printf("open dd wronly succeeded!\n");
    260e:	00003517          	auipc	a0,0x3
    2612:	e0250513          	addi	a0,a0,-510 # 5410 <malloc+0x107e>
    2616:	00002097          	auipc	ra,0x2
    261a:	cbe080e7          	jalr	-834(ra) # 42d4 <printf>
    exit();
    261e:	00002097          	auipc	ra,0x2
    2622:	91e080e7          	jalr	-1762(ra) # 3f3c <exit>
    printf("link dd/ff/ff dd/dd/xx succeeded!\n");
    2626:	00003517          	auipc	a0,0x3
    262a:	e1a50513          	addi	a0,a0,-486 # 5440 <malloc+0x10ae>
    262e:	00002097          	auipc	ra,0x2
    2632:	ca6080e7          	jalr	-858(ra) # 42d4 <printf>
    exit();
    2636:	00002097          	auipc	ra,0x2
    263a:	906080e7          	jalr	-1786(ra) # 3f3c <exit>
    printf("link dd/xx/ff dd/dd/xx succeeded!\n");
    263e:	00003517          	auipc	a0,0x3
    2642:	e2a50513          	addi	a0,a0,-470 # 5468 <malloc+0x10d6>
    2646:	00002097          	auipc	ra,0x2
    264a:	c8e080e7          	jalr	-882(ra) # 42d4 <printf>
    exit();
    264e:	00002097          	auipc	ra,0x2
    2652:	8ee080e7          	jalr	-1810(ra) # 3f3c <exit>
    printf("link dd/ff dd/dd/ffff succeeded!\n");
    2656:	00003517          	auipc	a0,0x3
    265a:	e3a50513          	addi	a0,a0,-454 # 5490 <malloc+0x10fe>
    265e:	00002097          	auipc	ra,0x2
    2662:	c76080e7          	jalr	-906(ra) # 42d4 <printf>
    exit();
    2666:	00002097          	auipc	ra,0x2
    266a:	8d6080e7          	jalr	-1834(ra) # 3f3c <exit>
    printf("mkdir dd/ff/ff succeeded!\n");
    266e:	00003517          	auipc	a0,0x3
    2672:	e4a50513          	addi	a0,a0,-438 # 54b8 <malloc+0x1126>
    2676:	00002097          	auipc	ra,0x2
    267a:	c5e080e7          	jalr	-930(ra) # 42d4 <printf>
    exit();
    267e:	00002097          	auipc	ra,0x2
    2682:	8be080e7          	jalr	-1858(ra) # 3f3c <exit>
    printf("mkdir dd/xx/ff succeeded!\n");
    2686:	00003517          	auipc	a0,0x3
    268a:	e5250513          	addi	a0,a0,-430 # 54d8 <malloc+0x1146>
    268e:	00002097          	auipc	ra,0x2
    2692:	c46080e7          	jalr	-954(ra) # 42d4 <printf>
    exit();
    2696:	00002097          	auipc	ra,0x2
    269a:	8a6080e7          	jalr	-1882(ra) # 3f3c <exit>
    printf("mkdir dd/dd/ffff succeeded!\n");
    269e:	00003517          	auipc	a0,0x3
    26a2:	e5a50513          	addi	a0,a0,-422 # 54f8 <malloc+0x1166>
    26a6:	00002097          	auipc	ra,0x2
    26aa:	c2e080e7          	jalr	-978(ra) # 42d4 <printf>
    exit();
    26ae:	00002097          	auipc	ra,0x2
    26b2:	88e080e7          	jalr	-1906(ra) # 3f3c <exit>
    printf("unlink dd/xx/ff succeeded!\n");
    26b6:	00003517          	auipc	a0,0x3
    26ba:	e6250513          	addi	a0,a0,-414 # 5518 <malloc+0x1186>
    26be:	00002097          	auipc	ra,0x2
    26c2:	c16080e7          	jalr	-1002(ra) # 42d4 <printf>
    exit();
    26c6:	00002097          	auipc	ra,0x2
    26ca:	876080e7          	jalr	-1930(ra) # 3f3c <exit>
    printf("unlink dd/ff/ff succeeded!\n");
    26ce:	00003517          	auipc	a0,0x3
    26d2:	e6a50513          	addi	a0,a0,-406 # 5538 <malloc+0x11a6>
    26d6:	00002097          	auipc	ra,0x2
    26da:	bfe080e7          	jalr	-1026(ra) # 42d4 <printf>
    exit();
    26de:	00002097          	auipc	ra,0x2
    26e2:	85e080e7          	jalr	-1954(ra) # 3f3c <exit>
    printf("chdir dd/ff succeeded!\n");
    26e6:	00003517          	auipc	a0,0x3
    26ea:	e7250513          	addi	a0,a0,-398 # 5558 <malloc+0x11c6>
    26ee:	00002097          	auipc	ra,0x2
    26f2:	be6080e7          	jalr	-1050(ra) # 42d4 <printf>
    exit();
    26f6:	00002097          	auipc	ra,0x2
    26fa:	846080e7          	jalr	-1978(ra) # 3f3c <exit>
    printf("chdir dd/xx succeeded!\n");
    26fe:	00003517          	auipc	a0,0x3
    2702:	e7a50513          	addi	a0,a0,-390 # 5578 <malloc+0x11e6>
    2706:	00002097          	auipc	ra,0x2
    270a:	bce080e7          	jalr	-1074(ra) # 42d4 <printf>
    exit();
    270e:	00002097          	auipc	ra,0x2
    2712:	82e080e7          	jalr	-2002(ra) # 3f3c <exit>
    printf("unlink dd/dd/ff failed\n");
    2716:	00003517          	auipc	a0,0x3
    271a:	b4a50513          	addi	a0,a0,-1206 # 5260 <malloc+0xece>
    271e:	00002097          	auipc	ra,0x2
    2722:	bb6080e7          	jalr	-1098(ra) # 42d4 <printf>
    exit();
    2726:	00002097          	auipc	ra,0x2
    272a:	816080e7          	jalr	-2026(ra) # 3f3c <exit>
    printf("unlink dd/ff failed\n");
    272e:	00003517          	auipc	a0,0x3
    2732:	e6250513          	addi	a0,a0,-414 # 5590 <malloc+0x11fe>
    2736:	00002097          	auipc	ra,0x2
    273a:	b9e080e7          	jalr	-1122(ra) # 42d4 <printf>
    exit();
    273e:	00001097          	auipc	ra,0x1
    2742:	7fe080e7          	jalr	2046(ra) # 3f3c <exit>
    printf("unlink non-empty dd succeeded!\n");
    2746:	00003517          	auipc	a0,0x3
    274a:	e6250513          	addi	a0,a0,-414 # 55a8 <malloc+0x1216>
    274e:	00002097          	auipc	ra,0x2
    2752:	b86080e7          	jalr	-1146(ra) # 42d4 <printf>
    exit();
    2756:	00001097          	auipc	ra,0x1
    275a:	7e6080e7          	jalr	2022(ra) # 3f3c <exit>
    printf("unlink dd/dd failed\n");
    275e:	00003517          	auipc	a0,0x3
    2762:	e7250513          	addi	a0,a0,-398 # 55d0 <malloc+0x123e>
    2766:	00002097          	auipc	ra,0x2
    276a:	b6e080e7          	jalr	-1170(ra) # 42d4 <printf>
    exit();
    276e:	00001097          	auipc	ra,0x1
    2772:	7ce080e7          	jalr	1998(ra) # 3f3c <exit>
    printf("unlink dd failed\n");
    2776:	00003517          	auipc	a0,0x3
    277a:	e7250513          	addi	a0,a0,-398 # 55e8 <malloc+0x1256>
    277e:	00002097          	auipc	ra,0x2
    2782:	b56080e7          	jalr	-1194(ra) # 42d4 <printf>
    exit();
    2786:	00001097          	auipc	ra,0x1
    278a:	7b6080e7          	jalr	1974(ra) # 3f3c <exit>

000000000000278e <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    278e:	7139                	addi	sp,sp,-64
    2790:	fc06                	sd	ra,56(sp)
    2792:	f822                	sd	s0,48(sp)
    2794:	f426                	sd	s1,40(sp)
    2796:	f04a                	sd	s2,32(sp)
    2798:	ec4e                	sd	s3,24(sp)
    279a:	e852                	sd	s4,16(sp)
    279c:	e456                	sd	s5,8(sp)
    279e:	e05a                	sd	s6,0(sp)
    27a0:	0080                	addi	s0,sp,64
  int fd, sz;

  printf("bigwrite test\n");
    27a2:	00003517          	auipc	a0,0x3
    27a6:	e6e50513          	addi	a0,a0,-402 # 5610 <malloc+0x127e>
    27aa:	00002097          	auipc	ra,0x2
    27ae:	b2a080e7          	jalr	-1238(ra) # 42d4 <printf>

  unlink("bigwrite");
    27b2:	00003517          	auipc	a0,0x3
    27b6:	e6e50513          	addi	a0,a0,-402 # 5620 <malloc+0x128e>
    27ba:	00001097          	auipc	ra,0x1
    27be:	7d2080e7          	jalr	2002(ra) # 3f8c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    27c2:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
    27c6:	00003a97          	auipc	s5,0x3
    27ca:	e5aa8a93          	addi	s5,s5,-422 # 5620 <malloc+0x128e>
      printf("cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
    27ce:	00006a17          	auipc	s4,0x6
    27d2:	292a0a13          	addi	s4,s4,658 # 8a60 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    27d6:	6b0d                	lui	s6,0x3
    27d8:	1c9b0b13          	addi	s6,s6,457 # 31c9 <sbrktest+0x6b>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    27dc:	20200593          	li	a1,514
    27e0:	8556                	mv	a0,s5
    27e2:	00001097          	auipc	ra,0x1
    27e6:	79a080e7          	jalr	1946(ra) # 3f7c <open>
    27ea:	892a                	mv	s2,a0
    if(fd < 0){
    27ec:	06054463          	bltz	a0,2854 <bigwrite+0xc6>
      int cc = write(fd, buf, sz);
    27f0:	8626                	mv	a2,s1
    27f2:	85d2                	mv	a1,s4
    27f4:	00001097          	auipc	ra,0x1
    27f8:	768080e7          	jalr	1896(ra) # 3f5c <write>
    27fc:	89aa                	mv	s3,a0
      if(cc != sz){
    27fe:	06a49963          	bne	s1,a0,2870 <bigwrite+0xe2>
      int cc = write(fd, buf, sz);
    2802:	8626                	mv	a2,s1
    2804:	85d2                	mv	a1,s4
    2806:	854a                	mv	a0,s2
    2808:	00001097          	auipc	ra,0x1
    280c:	754080e7          	jalr	1876(ra) # 3f5c <write>
      if(cc != sz){
    2810:	04951e63          	bne	a0,s1,286c <bigwrite+0xde>
        printf("write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    2814:	854a                	mv	a0,s2
    2816:	00001097          	auipc	ra,0x1
    281a:	74e080e7          	jalr	1870(ra) # 3f64 <close>
    unlink("bigwrite");
    281e:	8556                	mv	a0,s5
    2820:	00001097          	auipc	ra,0x1
    2824:	76c080e7          	jalr	1900(ra) # 3f8c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    2828:	1d74849b          	addiw	s1,s1,471
    282c:	fb6498e3          	bne	s1,s6,27dc <bigwrite+0x4e>
  }

  printf("bigwrite ok\n");
    2830:	00003517          	auipc	a0,0x3
    2834:	e3050513          	addi	a0,a0,-464 # 5660 <malloc+0x12ce>
    2838:	00002097          	auipc	ra,0x2
    283c:	a9c080e7          	jalr	-1380(ra) # 42d4 <printf>
}
    2840:	70e2                	ld	ra,56(sp)
    2842:	7442                	ld	s0,48(sp)
    2844:	74a2                	ld	s1,40(sp)
    2846:	7902                	ld	s2,32(sp)
    2848:	69e2                	ld	s3,24(sp)
    284a:	6a42                	ld	s4,16(sp)
    284c:	6aa2                	ld	s5,8(sp)
    284e:	6b02                	ld	s6,0(sp)
    2850:	6121                	addi	sp,sp,64
    2852:	8082                	ret
      printf("cannot create bigwrite\n");
    2854:	00003517          	auipc	a0,0x3
    2858:	ddc50513          	addi	a0,a0,-548 # 5630 <malloc+0x129e>
    285c:	00002097          	auipc	ra,0x2
    2860:	a78080e7          	jalr	-1416(ra) # 42d4 <printf>
      exit();
    2864:	00001097          	auipc	ra,0x1
    2868:	6d8080e7          	jalr	1752(ra) # 3f3c <exit>
    286c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
    286e:	89aa                	mv	s3,a0
        printf("write(%d) ret %d\n", sz, cc);
    2870:	864e                	mv	a2,s3
    2872:	85a6                	mv	a1,s1
    2874:	00003517          	auipc	a0,0x3
    2878:	dd450513          	addi	a0,a0,-556 # 5648 <malloc+0x12b6>
    287c:	00002097          	auipc	ra,0x2
    2880:	a58080e7          	jalr	-1448(ra) # 42d4 <printf>
        exit();
    2884:	00001097          	auipc	ra,0x1
    2888:	6b8080e7          	jalr	1720(ra) # 3f3c <exit>

000000000000288c <bigfile>:

void
bigfile(void)
{
    288c:	7179                	addi	sp,sp,-48
    288e:	f406                	sd	ra,40(sp)
    2890:	f022                	sd	s0,32(sp)
    2892:	ec26                	sd	s1,24(sp)
    2894:	e84a                	sd	s2,16(sp)
    2896:	e44e                	sd	s3,8(sp)
    2898:	e052                	sd	s4,0(sp)
    289a:	1800                	addi	s0,sp,48
  enum { N = 20, SZ=600 };
  int fd, i, total, cc;

  printf("bigfile test\n");
    289c:	00003517          	auipc	a0,0x3
    28a0:	dd450513          	addi	a0,a0,-556 # 5670 <malloc+0x12de>
    28a4:	00002097          	auipc	ra,0x2
    28a8:	a30080e7          	jalr	-1488(ra) # 42d4 <printf>

  unlink("bigfile");
    28ac:	00003517          	auipc	a0,0x3
    28b0:	dd450513          	addi	a0,a0,-556 # 5680 <malloc+0x12ee>
    28b4:	00001097          	auipc	ra,0x1
    28b8:	6d8080e7          	jalr	1752(ra) # 3f8c <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    28bc:	20200593          	li	a1,514
    28c0:	00003517          	auipc	a0,0x3
    28c4:	dc050513          	addi	a0,a0,-576 # 5680 <malloc+0x12ee>
    28c8:	00001097          	auipc	ra,0x1
    28cc:	6b4080e7          	jalr	1716(ra) # 3f7c <open>
    28d0:	89aa                	mv	s3,a0
  if(fd < 0){
    printf("cannot create bigfile");
    exit();
  }
  for(i = 0; i < N; i++){
    28d2:	4481                	li	s1,0
    memset(buf, i, SZ);
    28d4:	00006917          	auipc	s2,0x6
    28d8:	18c90913          	addi	s2,s2,396 # 8a60 <buf>
  for(i = 0; i < N; i++){
    28dc:	4a51                	li	s4,20
  if(fd < 0){
    28de:	0a054063          	bltz	a0,297e <bigfile+0xf2>
    memset(buf, i, SZ);
    28e2:	25800613          	li	a2,600
    28e6:	85a6                	mv	a1,s1
    28e8:	854a                	mv	a0,s2
    28ea:	00001097          	auipc	ra,0x1
    28ee:	4d6080e7          	jalr	1238(ra) # 3dc0 <memset>
    if(write(fd, buf, SZ) != SZ){
    28f2:	25800613          	li	a2,600
    28f6:	85ca                	mv	a1,s2
    28f8:	854e                	mv	a0,s3
    28fa:	00001097          	auipc	ra,0x1
    28fe:	662080e7          	jalr	1634(ra) # 3f5c <write>
    2902:	25800793          	li	a5,600
    2906:	08f51863          	bne	a0,a5,2996 <bigfile+0x10a>
  for(i = 0; i < N; i++){
    290a:	2485                	addiw	s1,s1,1
    290c:	fd449be3          	bne	s1,s4,28e2 <bigfile+0x56>
      printf("write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    2910:	854e                	mv	a0,s3
    2912:	00001097          	auipc	ra,0x1
    2916:	652080e7          	jalr	1618(ra) # 3f64 <close>

  fd = open("bigfile", 0);
    291a:	4581                	li	a1,0
    291c:	00003517          	auipc	a0,0x3
    2920:	d6450513          	addi	a0,a0,-668 # 5680 <malloc+0x12ee>
    2924:	00001097          	auipc	ra,0x1
    2928:	658080e7          	jalr	1624(ra) # 3f7c <open>
    292c:	8a2a                	mv	s4,a0
  if(fd < 0){
    printf("cannot open bigfile\n");
    exit();
  }
  total = 0;
    292e:	4981                	li	s3,0
  for(i = 0; ; i++){
    2930:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    2932:	00006917          	auipc	s2,0x6
    2936:	12e90913          	addi	s2,s2,302 # 8a60 <buf>
  if(fd < 0){
    293a:	06054a63          	bltz	a0,29ae <bigfile+0x122>
    cc = read(fd, buf, SZ/2);
    293e:	12c00613          	li	a2,300
    2942:	85ca                	mv	a1,s2
    2944:	8552                	mv	a0,s4
    2946:	00001097          	auipc	ra,0x1
    294a:	60e080e7          	jalr	1550(ra) # 3f54 <read>
    if(cc < 0){
    294e:	06054c63          	bltz	a0,29c6 <bigfile+0x13a>
      printf("read bigfile failed\n");
      exit();
    }
    if(cc == 0)
    2952:	cd55                	beqz	a0,2a0e <bigfile+0x182>
      break;
    if(cc != SZ/2){
    2954:	12c00793          	li	a5,300
    2958:	08f51363          	bne	a0,a5,29de <bigfile+0x152>
      printf("short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    295c:	01f4d79b          	srliw	a5,s1,0x1f
    2960:	9fa5                	addw	a5,a5,s1
    2962:	4017d79b          	sraiw	a5,a5,0x1
    2966:	00094703          	lbu	a4,0(s2)
    296a:	08f71663          	bne	a4,a5,29f6 <bigfile+0x16a>
    296e:	12b94703          	lbu	a4,299(s2)
    2972:	08f71263          	bne	a4,a5,29f6 <bigfile+0x16a>
      printf("read bigfile wrong data\n");
      exit();
    }
    total += cc;
    2976:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    297a:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    297c:	b7c9                	j	293e <bigfile+0xb2>
    printf("cannot create bigfile");
    297e:	00003517          	auipc	a0,0x3
    2982:	d0a50513          	addi	a0,a0,-758 # 5688 <malloc+0x12f6>
    2986:	00002097          	auipc	ra,0x2
    298a:	94e080e7          	jalr	-1714(ra) # 42d4 <printf>
    exit();
    298e:	00001097          	auipc	ra,0x1
    2992:	5ae080e7          	jalr	1454(ra) # 3f3c <exit>
      printf("write bigfile failed\n");
    2996:	00003517          	auipc	a0,0x3
    299a:	d0a50513          	addi	a0,a0,-758 # 56a0 <malloc+0x130e>
    299e:	00002097          	auipc	ra,0x2
    29a2:	936080e7          	jalr	-1738(ra) # 42d4 <printf>
      exit();
    29a6:	00001097          	auipc	ra,0x1
    29aa:	596080e7          	jalr	1430(ra) # 3f3c <exit>
    printf("cannot open bigfile\n");
    29ae:	00003517          	auipc	a0,0x3
    29b2:	d0a50513          	addi	a0,a0,-758 # 56b8 <malloc+0x1326>
    29b6:	00002097          	auipc	ra,0x2
    29ba:	91e080e7          	jalr	-1762(ra) # 42d4 <printf>
    exit();
    29be:	00001097          	auipc	ra,0x1
    29c2:	57e080e7          	jalr	1406(ra) # 3f3c <exit>
      printf("read bigfile failed\n");
    29c6:	00003517          	auipc	a0,0x3
    29ca:	d0a50513          	addi	a0,a0,-758 # 56d0 <malloc+0x133e>
    29ce:	00002097          	auipc	ra,0x2
    29d2:	906080e7          	jalr	-1786(ra) # 42d4 <printf>
      exit();
    29d6:	00001097          	auipc	ra,0x1
    29da:	566080e7          	jalr	1382(ra) # 3f3c <exit>
      printf("short read bigfile\n");
    29de:	00003517          	auipc	a0,0x3
    29e2:	d0a50513          	addi	a0,a0,-758 # 56e8 <malloc+0x1356>
    29e6:	00002097          	auipc	ra,0x2
    29ea:	8ee080e7          	jalr	-1810(ra) # 42d4 <printf>
      exit();
    29ee:	00001097          	auipc	ra,0x1
    29f2:	54e080e7          	jalr	1358(ra) # 3f3c <exit>
      printf("read bigfile wrong data\n");
    29f6:	00003517          	auipc	a0,0x3
    29fa:	d0a50513          	addi	a0,a0,-758 # 5700 <malloc+0x136e>
    29fe:	00002097          	auipc	ra,0x2
    2a02:	8d6080e7          	jalr	-1834(ra) # 42d4 <printf>
      exit();
    2a06:	00001097          	auipc	ra,0x1
    2a0a:	536080e7          	jalr	1334(ra) # 3f3c <exit>
  }
  close(fd);
    2a0e:	8552                	mv	a0,s4
    2a10:	00001097          	auipc	ra,0x1
    2a14:	554080e7          	jalr	1364(ra) # 3f64 <close>
  if(total != N*SZ){
    2a18:	678d                	lui	a5,0x3
    2a1a:	ee078793          	addi	a5,a5,-288 # 2ee0 <dirfile+0x1b0>
    2a1e:	02f99a63          	bne	s3,a5,2a52 <bigfile+0x1c6>
    printf("read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");
    2a22:	00003517          	auipc	a0,0x3
    2a26:	c5e50513          	addi	a0,a0,-930 # 5680 <malloc+0x12ee>
    2a2a:	00001097          	auipc	ra,0x1
    2a2e:	562080e7          	jalr	1378(ra) # 3f8c <unlink>

  printf("bigfile test ok\n");
    2a32:	00003517          	auipc	a0,0x3
    2a36:	d0e50513          	addi	a0,a0,-754 # 5740 <malloc+0x13ae>
    2a3a:	00002097          	auipc	ra,0x2
    2a3e:	89a080e7          	jalr	-1894(ra) # 42d4 <printf>
}
    2a42:	70a2                	ld	ra,40(sp)
    2a44:	7402                	ld	s0,32(sp)
    2a46:	64e2                	ld	s1,24(sp)
    2a48:	6942                	ld	s2,16(sp)
    2a4a:	69a2                	ld	s3,8(sp)
    2a4c:	6a02                	ld	s4,0(sp)
    2a4e:	6145                	addi	sp,sp,48
    2a50:	8082                	ret
    printf("read bigfile wrong total\n");
    2a52:	00003517          	auipc	a0,0x3
    2a56:	cce50513          	addi	a0,a0,-818 # 5720 <malloc+0x138e>
    2a5a:	00002097          	auipc	ra,0x2
    2a5e:	87a080e7          	jalr	-1926(ra) # 42d4 <printf>
    exit();
    2a62:	00001097          	auipc	ra,0x1
    2a66:	4da080e7          	jalr	1242(ra) # 3f3c <exit>

0000000000002a6a <fourteen>:

void
fourteen(void)
{
    2a6a:	1141                	addi	sp,sp,-16
    2a6c:	e406                	sd	ra,8(sp)
    2a6e:	e022                	sd	s0,0(sp)
    2a70:	0800                	addi	s0,sp,16
  int fd;

  // DIRSIZ is 14.
  printf("fourteen test\n");
    2a72:	00003517          	auipc	a0,0x3
    2a76:	ce650513          	addi	a0,a0,-794 # 5758 <malloc+0x13c6>
    2a7a:	00002097          	auipc	ra,0x2
    2a7e:	85a080e7          	jalr	-1958(ra) # 42d4 <printf>

  if(mkdir("12345678901234") != 0){
    2a82:	00003517          	auipc	a0,0x3
    2a86:	e9650513          	addi	a0,a0,-362 # 5918 <malloc+0x1586>
    2a8a:	00001097          	auipc	ra,0x1
    2a8e:	51a080e7          	jalr	1306(ra) # 3fa4 <mkdir>
    2a92:	e559                	bnez	a0,2b20 <fourteen+0xb6>
    printf("mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2a94:	00003517          	auipc	a0,0x3
    2a98:	cf450513          	addi	a0,a0,-780 # 5788 <malloc+0x13f6>
    2a9c:	00001097          	auipc	ra,0x1
    2aa0:	508080e7          	jalr	1288(ra) # 3fa4 <mkdir>
    2aa4:	e951                	bnez	a0,2b38 <fourteen+0xce>
    printf("mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2aa6:	20000593          	li	a1,512
    2aaa:	00003517          	auipc	a0,0x3
    2aae:	d2e50513          	addi	a0,a0,-722 # 57d8 <malloc+0x1446>
    2ab2:	00001097          	auipc	ra,0x1
    2ab6:	4ca080e7          	jalr	1226(ra) # 3f7c <open>
  if(fd < 0){
    2aba:	08054b63          	bltz	a0,2b50 <fourteen+0xe6>
    printf("create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
    2abe:	00001097          	auipc	ra,0x1
    2ac2:	4a6080e7          	jalr	1190(ra) # 3f64 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2ac6:	4581                	li	a1,0
    2ac8:	00003517          	auipc	a0,0x3
    2acc:	d8050513          	addi	a0,a0,-640 # 5848 <malloc+0x14b6>
    2ad0:	00001097          	auipc	ra,0x1
    2ad4:	4ac080e7          	jalr	1196(ra) # 3f7c <open>
  if(fd < 0){
    2ad8:	08054863          	bltz	a0,2b68 <fourteen+0xfe>
    printf("open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);
    2adc:	00001097          	auipc	ra,0x1
    2ae0:	488080e7          	jalr	1160(ra) # 3f64 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2ae4:	00003517          	auipc	a0,0x3
    2ae8:	dd450513          	addi	a0,a0,-556 # 58b8 <malloc+0x1526>
    2aec:	00001097          	auipc	ra,0x1
    2af0:	4b8080e7          	jalr	1208(ra) # 3fa4 <mkdir>
    2af4:	c551                	beqz	a0,2b80 <fourteen+0x116>
    printf("mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2af6:	00003517          	auipc	a0,0x3
    2afa:	e1250513          	addi	a0,a0,-494 # 5908 <malloc+0x1576>
    2afe:	00001097          	auipc	ra,0x1
    2b02:	4a6080e7          	jalr	1190(ra) # 3fa4 <mkdir>
    2b06:	c949                	beqz	a0,2b98 <fourteen+0x12e>
    printf("mkdir 12345678901234/123456789012345 succeeded!\n");
    exit();
  }

  printf("fourteen ok\n");
    2b08:	00003517          	auipc	a0,0x3
    2b0c:	e5850513          	addi	a0,a0,-424 # 5960 <malloc+0x15ce>
    2b10:	00001097          	auipc	ra,0x1
    2b14:	7c4080e7          	jalr	1988(ra) # 42d4 <printf>
}
    2b18:	60a2                	ld	ra,8(sp)
    2b1a:	6402                	ld	s0,0(sp)
    2b1c:	0141                	addi	sp,sp,16
    2b1e:	8082                	ret
    printf("mkdir 12345678901234 failed\n");
    2b20:	00003517          	auipc	a0,0x3
    2b24:	c4850513          	addi	a0,a0,-952 # 5768 <malloc+0x13d6>
    2b28:	00001097          	auipc	ra,0x1
    2b2c:	7ac080e7          	jalr	1964(ra) # 42d4 <printf>
    exit();
    2b30:	00001097          	auipc	ra,0x1
    2b34:	40c080e7          	jalr	1036(ra) # 3f3c <exit>
    printf("mkdir 12345678901234/123456789012345 failed\n");
    2b38:	00003517          	auipc	a0,0x3
    2b3c:	c7050513          	addi	a0,a0,-912 # 57a8 <malloc+0x1416>
    2b40:	00001097          	auipc	ra,0x1
    2b44:	794080e7          	jalr	1940(ra) # 42d4 <printf>
    exit();
    2b48:	00001097          	auipc	ra,0x1
    2b4c:	3f4080e7          	jalr	1012(ra) # 3f3c <exit>
    printf("create 123456789012345/123456789012345/123456789012345 failed\n");
    2b50:	00003517          	auipc	a0,0x3
    2b54:	cb850513          	addi	a0,a0,-840 # 5808 <malloc+0x1476>
    2b58:	00001097          	auipc	ra,0x1
    2b5c:	77c080e7          	jalr	1916(ra) # 42d4 <printf>
    exit();
    2b60:	00001097          	auipc	ra,0x1
    2b64:	3dc080e7          	jalr	988(ra) # 3f3c <exit>
    printf("open 12345678901234/12345678901234/12345678901234 failed\n");
    2b68:	00003517          	auipc	a0,0x3
    2b6c:	d1050513          	addi	a0,a0,-752 # 5878 <malloc+0x14e6>
    2b70:	00001097          	auipc	ra,0x1
    2b74:	764080e7          	jalr	1892(ra) # 42d4 <printf>
    exit();
    2b78:	00001097          	auipc	ra,0x1
    2b7c:	3c4080e7          	jalr	964(ra) # 3f3c <exit>
    printf("mkdir 12345678901234/12345678901234 succeeded!\n");
    2b80:	00003517          	auipc	a0,0x3
    2b84:	d5850513          	addi	a0,a0,-680 # 58d8 <malloc+0x1546>
    2b88:	00001097          	auipc	ra,0x1
    2b8c:	74c080e7          	jalr	1868(ra) # 42d4 <printf>
    exit();
    2b90:	00001097          	auipc	ra,0x1
    2b94:	3ac080e7          	jalr	940(ra) # 3f3c <exit>
    printf("mkdir 12345678901234/123456789012345 succeeded!\n");
    2b98:	00003517          	auipc	a0,0x3
    2b9c:	d9050513          	addi	a0,a0,-624 # 5928 <malloc+0x1596>
    2ba0:	00001097          	auipc	ra,0x1
    2ba4:	734080e7          	jalr	1844(ra) # 42d4 <printf>
    exit();
    2ba8:	00001097          	auipc	ra,0x1
    2bac:	394080e7          	jalr	916(ra) # 3f3c <exit>

0000000000002bb0 <rmdot>:

void
rmdot(void)
{
    2bb0:	1141                	addi	sp,sp,-16
    2bb2:	e406                	sd	ra,8(sp)
    2bb4:	e022                	sd	s0,0(sp)
    2bb6:	0800                	addi	s0,sp,16
  printf("rmdot test\n");
    2bb8:	00003517          	auipc	a0,0x3
    2bbc:	db850513          	addi	a0,a0,-584 # 5970 <malloc+0x15de>
    2bc0:	00001097          	auipc	ra,0x1
    2bc4:	714080e7          	jalr	1812(ra) # 42d4 <printf>
  if(mkdir("dots") != 0){
    2bc8:	00003517          	auipc	a0,0x3
    2bcc:	db850513          	addi	a0,a0,-584 # 5980 <malloc+0x15ee>
    2bd0:	00001097          	auipc	ra,0x1
    2bd4:	3d4080e7          	jalr	980(ra) # 3fa4 <mkdir>
    2bd8:	ed41                	bnez	a0,2c70 <rmdot+0xc0>
    printf("mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
    2bda:	00003517          	auipc	a0,0x3
    2bde:	da650513          	addi	a0,a0,-602 # 5980 <malloc+0x15ee>
    2be2:	00001097          	auipc	ra,0x1
    2be6:	3ca080e7          	jalr	970(ra) # 3fac <chdir>
    2bea:	ed59                	bnez	a0,2c88 <rmdot+0xd8>
    printf("chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
    2bec:	00002517          	auipc	a0,0x2
    2bf0:	38450513          	addi	a0,a0,900 # 4f70 <malloc+0xbde>
    2bf4:	00001097          	auipc	ra,0x1
    2bf8:	398080e7          	jalr	920(ra) # 3f8c <unlink>
    2bfc:	c155                	beqz	a0,2ca0 <rmdot+0xf0>
    printf("rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
    2bfe:	00002517          	auipc	a0,0x2
    2c02:	d5a50513          	addi	a0,a0,-678 # 4958 <malloc+0x5c6>
    2c06:	00001097          	auipc	ra,0x1
    2c0a:	386080e7          	jalr	902(ra) # 3f8c <unlink>
    2c0e:	c54d                	beqz	a0,2cb8 <rmdot+0x108>
    printf("rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
    2c10:	00002517          	auipc	a0,0x2
    2c14:	8f850513          	addi	a0,a0,-1800 # 4508 <malloc+0x176>
    2c18:	00001097          	auipc	ra,0x1
    2c1c:	394080e7          	jalr	916(ra) # 3fac <chdir>
    2c20:	e945                	bnez	a0,2cd0 <rmdot+0x120>
    printf("chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
    2c22:	00003517          	auipc	a0,0x3
    2c26:	db650513          	addi	a0,a0,-586 # 59d8 <malloc+0x1646>
    2c2a:	00001097          	auipc	ra,0x1
    2c2e:	362080e7          	jalr	866(ra) # 3f8c <unlink>
    2c32:	c95d                	beqz	a0,2ce8 <rmdot+0x138>
    printf("unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
    2c34:	00003517          	auipc	a0,0x3
    2c38:	dc450513          	addi	a0,a0,-572 # 59f8 <malloc+0x1666>
    2c3c:	00001097          	auipc	ra,0x1
    2c40:	350080e7          	jalr	848(ra) # 3f8c <unlink>
    2c44:	cd55                	beqz	a0,2d00 <rmdot+0x150>
    printf("unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
    2c46:	00003517          	auipc	a0,0x3
    2c4a:	d3a50513          	addi	a0,a0,-710 # 5980 <malloc+0x15ee>
    2c4e:	00001097          	auipc	ra,0x1
    2c52:	33e080e7          	jalr	830(ra) # 3f8c <unlink>
    2c56:	e169                	bnez	a0,2d18 <rmdot+0x168>
    printf("unlink dots failed!\n");
    exit();
  }
  printf("rmdot ok\n");
    2c58:	00003517          	auipc	a0,0x3
    2c5c:	dd850513          	addi	a0,a0,-552 # 5a30 <malloc+0x169e>
    2c60:	00001097          	auipc	ra,0x1
    2c64:	674080e7          	jalr	1652(ra) # 42d4 <printf>
}
    2c68:	60a2                	ld	ra,8(sp)
    2c6a:	6402                	ld	s0,0(sp)
    2c6c:	0141                	addi	sp,sp,16
    2c6e:	8082                	ret
    printf("mkdir dots failed\n");
    2c70:	00003517          	auipc	a0,0x3
    2c74:	d1850513          	addi	a0,a0,-744 # 5988 <malloc+0x15f6>
    2c78:	00001097          	auipc	ra,0x1
    2c7c:	65c080e7          	jalr	1628(ra) # 42d4 <printf>
    exit();
    2c80:	00001097          	auipc	ra,0x1
    2c84:	2bc080e7          	jalr	700(ra) # 3f3c <exit>
    printf("chdir dots failed\n");
    2c88:	00003517          	auipc	a0,0x3
    2c8c:	d1850513          	addi	a0,a0,-744 # 59a0 <malloc+0x160e>
    2c90:	00001097          	auipc	ra,0x1
    2c94:	644080e7          	jalr	1604(ra) # 42d4 <printf>
    exit();
    2c98:	00001097          	auipc	ra,0x1
    2c9c:	2a4080e7          	jalr	676(ra) # 3f3c <exit>
    printf("rm . worked!\n");
    2ca0:	00003517          	auipc	a0,0x3
    2ca4:	d1850513          	addi	a0,a0,-744 # 59b8 <malloc+0x1626>
    2ca8:	00001097          	auipc	ra,0x1
    2cac:	62c080e7          	jalr	1580(ra) # 42d4 <printf>
    exit();
    2cb0:	00001097          	auipc	ra,0x1
    2cb4:	28c080e7          	jalr	652(ra) # 3f3c <exit>
    printf("rm .. worked!\n");
    2cb8:	00003517          	auipc	a0,0x3
    2cbc:	d1050513          	addi	a0,a0,-752 # 59c8 <malloc+0x1636>
    2cc0:	00001097          	auipc	ra,0x1
    2cc4:	614080e7          	jalr	1556(ra) # 42d4 <printf>
    exit();
    2cc8:	00001097          	auipc	ra,0x1
    2ccc:	274080e7          	jalr	628(ra) # 3f3c <exit>
    printf("chdir / failed\n");
    2cd0:	00002517          	auipc	a0,0x2
    2cd4:	84050513          	addi	a0,a0,-1984 # 4510 <malloc+0x17e>
    2cd8:	00001097          	auipc	ra,0x1
    2cdc:	5fc080e7          	jalr	1532(ra) # 42d4 <printf>
    exit();
    2ce0:	00001097          	auipc	ra,0x1
    2ce4:	25c080e7          	jalr	604(ra) # 3f3c <exit>
    printf("unlink dots/. worked!\n");
    2ce8:	00003517          	auipc	a0,0x3
    2cec:	cf850513          	addi	a0,a0,-776 # 59e0 <malloc+0x164e>
    2cf0:	00001097          	auipc	ra,0x1
    2cf4:	5e4080e7          	jalr	1508(ra) # 42d4 <printf>
    exit();
    2cf8:	00001097          	auipc	ra,0x1
    2cfc:	244080e7          	jalr	580(ra) # 3f3c <exit>
    printf("unlink dots/.. worked!\n");
    2d00:	00003517          	auipc	a0,0x3
    2d04:	d0050513          	addi	a0,a0,-768 # 5a00 <malloc+0x166e>
    2d08:	00001097          	auipc	ra,0x1
    2d0c:	5cc080e7          	jalr	1484(ra) # 42d4 <printf>
    exit();
    2d10:	00001097          	auipc	ra,0x1
    2d14:	22c080e7          	jalr	556(ra) # 3f3c <exit>
    printf("unlink dots failed!\n");
    2d18:	00003517          	auipc	a0,0x3
    2d1c:	d0050513          	addi	a0,a0,-768 # 5a18 <malloc+0x1686>
    2d20:	00001097          	auipc	ra,0x1
    2d24:	5b4080e7          	jalr	1460(ra) # 42d4 <printf>
    exit();
    2d28:	00001097          	auipc	ra,0x1
    2d2c:	214080e7          	jalr	532(ra) # 3f3c <exit>

0000000000002d30 <dirfile>:

void
dirfile(void)
{
    2d30:	1101                	addi	sp,sp,-32
    2d32:	ec06                	sd	ra,24(sp)
    2d34:	e822                	sd	s0,16(sp)
    2d36:	e426                	sd	s1,8(sp)
    2d38:	1000                	addi	s0,sp,32
  int fd;

  printf("dir vs file\n");
    2d3a:	00003517          	auipc	a0,0x3
    2d3e:	d0650513          	addi	a0,a0,-762 # 5a40 <malloc+0x16ae>
    2d42:	00001097          	auipc	ra,0x1
    2d46:	592080e7          	jalr	1426(ra) # 42d4 <printf>

  fd = open("dirfile", O_CREATE);
    2d4a:	20000593          	li	a1,512
    2d4e:	00003517          	auipc	a0,0x3
    2d52:	d0250513          	addi	a0,a0,-766 # 5a50 <malloc+0x16be>
    2d56:	00001097          	auipc	ra,0x1
    2d5a:	226080e7          	jalr	550(ra) # 3f7c <open>
  if(fd < 0){
    2d5e:	10054563          	bltz	a0,2e68 <dirfile+0x138>
    printf("create dirfile failed\n");
    exit();
  }
  close(fd);
    2d62:	00001097          	auipc	ra,0x1
    2d66:	202080e7          	jalr	514(ra) # 3f64 <close>
  if(chdir("dirfile") == 0){
    2d6a:	00003517          	auipc	a0,0x3
    2d6e:	ce650513          	addi	a0,a0,-794 # 5a50 <malloc+0x16be>
    2d72:	00001097          	auipc	ra,0x1
    2d76:	23a080e7          	jalr	570(ra) # 3fac <chdir>
    2d7a:	10050363          	beqz	a0,2e80 <dirfile+0x150>
    printf("chdir dirfile succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", 0);
    2d7e:	4581                	li	a1,0
    2d80:	00003517          	auipc	a0,0x3
    2d84:	d1050513          	addi	a0,a0,-752 # 5a90 <malloc+0x16fe>
    2d88:	00001097          	auipc	ra,0x1
    2d8c:	1f4080e7          	jalr	500(ra) # 3f7c <open>
  if(fd >= 0){
    2d90:	10055463          	bgez	a0,2e98 <dirfile+0x168>
    printf("create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
    2d94:	20000593          	li	a1,512
    2d98:	00003517          	auipc	a0,0x3
    2d9c:	cf850513          	addi	a0,a0,-776 # 5a90 <malloc+0x16fe>
    2da0:	00001097          	auipc	ra,0x1
    2da4:	1dc080e7          	jalr	476(ra) # 3f7c <open>
  if(fd >= 0){
    2da8:	10055463          	bgez	a0,2eb0 <dirfile+0x180>
    printf("create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    2dac:	00003517          	auipc	a0,0x3
    2db0:	ce450513          	addi	a0,a0,-796 # 5a90 <malloc+0x16fe>
    2db4:	00001097          	auipc	ra,0x1
    2db8:	1f0080e7          	jalr	496(ra) # 3fa4 <mkdir>
    2dbc:	10050663          	beqz	a0,2ec8 <dirfile+0x198>
    printf("mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    2dc0:	00003517          	auipc	a0,0x3
    2dc4:	cd050513          	addi	a0,a0,-816 # 5a90 <malloc+0x16fe>
    2dc8:	00001097          	auipc	ra,0x1
    2dcc:	1c4080e7          	jalr	452(ra) # 3f8c <unlink>
    2dd0:	10050863          	beqz	a0,2ee0 <dirfile+0x1b0>
    printf("unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    2dd4:	00003597          	auipc	a1,0x3
    2dd8:	cbc58593          	addi	a1,a1,-836 # 5a90 <malloc+0x16fe>
    2ddc:	00003517          	auipc	a0,0x3
    2de0:	d2450513          	addi	a0,a0,-732 # 5b00 <malloc+0x176e>
    2de4:	00001097          	auipc	ra,0x1
    2de8:	1b8080e7          	jalr	440(ra) # 3f9c <link>
    2dec:	10050663          	beqz	a0,2ef8 <dirfile+0x1c8>
    printf("link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    2df0:	00003517          	auipc	a0,0x3
    2df4:	c6050513          	addi	a0,a0,-928 # 5a50 <malloc+0x16be>
    2df8:	00001097          	auipc	ra,0x1
    2dfc:	194080e7          	jalr	404(ra) # 3f8c <unlink>
    2e00:	10051863          	bnez	a0,2f10 <dirfile+0x1e0>
    printf("unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
    2e04:	4589                	li	a1,2
    2e06:	00002517          	auipc	a0,0x2
    2e0a:	16a50513          	addi	a0,a0,362 # 4f70 <malloc+0xbde>
    2e0e:	00001097          	auipc	ra,0x1
    2e12:	16e080e7          	jalr	366(ra) # 3f7c <open>
  if(fd >= 0){
    2e16:	10055963          	bgez	a0,2f28 <dirfile+0x1f8>
    printf("open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
    2e1a:	4581                	li	a1,0
    2e1c:	00002517          	auipc	a0,0x2
    2e20:	15450513          	addi	a0,a0,340 # 4f70 <malloc+0xbde>
    2e24:	00001097          	auipc	ra,0x1
    2e28:	158080e7          	jalr	344(ra) # 3f7c <open>
    2e2c:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    2e2e:	4605                	li	a2,1
    2e30:	00002597          	auipc	a1,0x2
    2e34:	c2058593          	addi	a1,a1,-992 # 4a50 <malloc+0x6be>
    2e38:	00001097          	auipc	ra,0x1
    2e3c:	124080e7          	jalr	292(ra) # 3f5c <write>
    2e40:	10a04063          	bgtz	a0,2f40 <dirfile+0x210>
    printf("write . succeeded!\n");
    exit();
  }
  close(fd);
    2e44:	8526                	mv	a0,s1
    2e46:	00001097          	auipc	ra,0x1
    2e4a:	11e080e7          	jalr	286(ra) # 3f64 <close>

  printf("dir vs file OK\n");
    2e4e:	00003517          	auipc	a0,0x3
    2e52:	d2a50513          	addi	a0,a0,-726 # 5b78 <malloc+0x17e6>
    2e56:	00001097          	auipc	ra,0x1
    2e5a:	47e080e7          	jalr	1150(ra) # 42d4 <printf>
}
    2e5e:	60e2                	ld	ra,24(sp)
    2e60:	6442                	ld	s0,16(sp)
    2e62:	64a2                	ld	s1,8(sp)
    2e64:	6105                	addi	sp,sp,32
    2e66:	8082                	ret
    printf("create dirfile failed\n");
    2e68:	00003517          	auipc	a0,0x3
    2e6c:	bf050513          	addi	a0,a0,-1040 # 5a58 <malloc+0x16c6>
    2e70:	00001097          	auipc	ra,0x1
    2e74:	464080e7          	jalr	1124(ra) # 42d4 <printf>
    exit();
    2e78:	00001097          	auipc	ra,0x1
    2e7c:	0c4080e7          	jalr	196(ra) # 3f3c <exit>
    printf("chdir dirfile succeeded!\n");
    2e80:	00003517          	auipc	a0,0x3
    2e84:	bf050513          	addi	a0,a0,-1040 # 5a70 <malloc+0x16de>
    2e88:	00001097          	auipc	ra,0x1
    2e8c:	44c080e7          	jalr	1100(ra) # 42d4 <printf>
    exit();
    2e90:	00001097          	auipc	ra,0x1
    2e94:	0ac080e7          	jalr	172(ra) # 3f3c <exit>
    printf("create dirfile/xx succeeded!\n");
    2e98:	00003517          	auipc	a0,0x3
    2e9c:	c0850513          	addi	a0,a0,-1016 # 5aa0 <malloc+0x170e>
    2ea0:	00001097          	auipc	ra,0x1
    2ea4:	434080e7          	jalr	1076(ra) # 42d4 <printf>
    exit();
    2ea8:	00001097          	auipc	ra,0x1
    2eac:	094080e7          	jalr	148(ra) # 3f3c <exit>
    printf("create dirfile/xx succeeded!\n");
    2eb0:	00003517          	auipc	a0,0x3
    2eb4:	bf050513          	addi	a0,a0,-1040 # 5aa0 <malloc+0x170e>
    2eb8:	00001097          	auipc	ra,0x1
    2ebc:	41c080e7          	jalr	1052(ra) # 42d4 <printf>
    exit();
    2ec0:	00001097          	auipc	ra,0x1
    2ec4:	07c080e7          	jalr	124(ra) # 3f3c <exit>
    printf("mkdir dirfile/xx succeeded!\n");
    2ec8:	00003517          	auipc	a0,0x3
    2ecc:	bf850513          	addi	a0,a0,-1032 # 5ac0 <malloc+0x172e>
    2ed0:	00001097          	auipc	ra,0x1
    2ed4:	404080e7          	jalr	1028(ra) # 42d4 <printf>
    exit();
    2ed8:	00001097          	auipc	ra,0x1
    2edc:	064080e7          	jalr	100(ra) # 3f3c <exit>
    printf("unlink dirfile/xx succeeded!\n");
    2ee0:	00003517          	auipc	a0,0x3
    2ee4:	c0050513          	addi	a0,a0,-1024 # 5ae0 <malloc+0x174e>
    2ee8:	00001097          	auipc	ra,0x1
    2eec:	3ec080e7          	jalr	1004(ra) # 42d4 <printf>
    exit();
    2ef0:	00001097          	auipc	ra,0x1
    2ef4:	04c080e7          	jalr	76(ra) # 3f3c <exit>
    printf("link to dirfile/xx succeeded!\n");
    2ef8:	00003517          	auipc	a0,0x3
    2efc:	c1050513          	addi	a0,a0,-1008 # 5b08 <malloc+0x1776>
    2f00:	00001097          	auipc	ra,0x1
    2f04:	3d4080e7          	jalr	980(ra) # 42d4 <printf>
    exit();
    2f08:	00001097          	auipc	ra,0x1
    2f0c:	034080e7          	jalr	52(ra) # 3f3c <exit>
    printf("unlink dirfile failed!\n");
    2f10:	00003517          	auipc	a0,0x3
    2f14:	c1850513          	addi	a0,a0,-1000 # 5b28 <malloc+0x1796>
    2f18:	00001097          	auipc	ra,0x1
    2f1c:	3bc080e7          	jalr	956(ra) # 42d4 <printf>
    exit();
    2f20:	00001097          	auipc	ra,0x1
    2f24:	01c080e7          	jalr	28(ra) # 3f3c <exit>
    printf("open . for writing succeeded!\n");
    2f28:	00003517          	auipc	a0,0x3
    2f2c:	c1850513          	addi	a0,a0,-1000 # 5b40 <malloc+0x17ae>
    2f30:	00001097          	auipc	ra,0x1
    2f34:	3a4080e7          	jalr	932(ra) # 42d4 <printf>
    exit();
    2f38:	00001097          	auipc	ra,0x1
    2f3c:	004080e7          	jalr	4(ra) # 3f3c <exit>
    printf("write . succeeded!\n");
    2f40:	00003517          	auipc	a0,0x3
    2f44:	c2050513          	addi	a0,a0,-992 # 5b60 <malloc+0x17ce>
    2f48:	00001097          	auipc	ra,0x1
    2f4c:	38c080e7          	jalr	908(ra) # 42d4 <printf>
    exit();
    2f50:	00001097          	auipc	ra,0x1
    2f54:	fec080e7          	jalr	-20(ra) # 3f3c <exit>

0000000000002f58 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2f58:	7139                	addi	sp,sp,-64
    2f5a:	fc06                	sd	ra,56(sp)
    2f5c:	f822                	sd	s0,48(sp)
    2f5e:	f426                	sd	s1,40(sp)
    2f60:	f04a                	sd	s2,32(sp)
    2f62:	ec4e                	sd	s3,24(sp)
    2f64:	e852                	sd	s4,16(sp)
    2f66:	e456                	sd	s5,8(sp)
    2f68:	0080                	addi	s0,sp,64
  int i, fd;

  printf("empty file name\n");
    2f6a:	00003517          	auipc	a0,0x3
    2f6e:	c1e50513          	addi	a0,a0,-994 # 5b88 <malloc+0x17f6>
    2f72:	00001097          	auipc	ra,0x1
    2f76:	362080e7          	jalr	866(ra) # 42d4 <printf>
    2f7a:	03300913          	li	s2,51

  for(i = 0; i < NINODE + 1; i++){
    if(mkdir("irefd") != 0){
    2f7e:	00003a17          	auipc	s4,0x3
    2f82:	c22a0a13          	addi	s4,s4,-990 # 5ba0 <malloc+0x180e>
    if(chdir("irefd") != 0){
      printf("chdir irefd failed\n");
      exit();
    }

    mkdir("");
    2f86:	00003497          	auipc	s1,0x3
    2f8a:	9d248493          	addi	s1,s1,-1582 # 5958 <malloc+0x15c6>
    link("README", "");
    2f8e:	00003a97          	auipc	s5,0x3
    2f92:	b72a8a93          	addi	s5,s5,-1166 # 5b00 <malloc+0x176e>
    fd = open("", O_CREATE);
    if(fd >= 0)
      close(fd);
    fd = open("xx", O_CREATE);
    2f96:	00003997          	auipc	s3,0x3
    2f9a:	b0298993          	addi	s3,s3,-1278 # 5a98 <malloc+0x1706>
    2f9e:	a0b1                	j	2fea <iref+0x92>
      printf("mkdir irefd failed\n");
    2fa0:	00003517          	auipc	a0,0x3
    2fa4:	c0850513          	addi	a0,a0,-1016 # 5ba8 <malloc+0x1816>
    2fa8:	00001097          	auipc	ra,0x1
    2fac:	32c080e7          	jalr	812(ra) # 42d4 <printf>
      exit();
    2fb0:	00001097          	auipc	ra,0x1
    2fb4:	f8c080e7          	jalr	-116(ra) # 3f3c <exit>
      printf("chdir irefd failed\n");
    2fb8:	00003517          	auipc	a0,0x3
    2fbc:	c0850513          	addi	a0,a0,-1016 # 5bc0 <malloc+0x182e>
    2fc0:	00001097          	auipc	ra,0x1
    2fc4:	314080e7          	jalr	788(ra) # 42d4 <printf>
      exit();
    2fc8:	00001097          	auipc	ra,0x1
    2fcc:	f74080e7          	jalr	-140(ra) # 3f3c <exit>
      close(fd);
    2fd0:	00001097          	auipc	ra,0x1
    2fd4:	f94080e7          	jalr	-108(ra) # 3f64 <close>
    2fd8:	a889                	j	302a <iref+0xd2>
    if(fd >= 0)
      close(fd);
    unlink("xx");
    2fda:	854e                	mv	a0,s3
    2fdc:	00001097          	auipc	ra,0x1
    2fe0:	fb0080e7          	jalr	-80(ra) # 3f8c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    2fe4:	397d                	addiw	s2,s2,-1
    2fe6:	06090063          	beqz	s2,3046 <iref+0xee>
    if(mkdir("irefd") != 0){
    2fea:	8552                	mv	a0,s4
    2fec:	00001097          	auipc	ra,0x1
    2ff0:	fb8080e7          	jalr	-72(ra) # 3fa4 <mkdir>
    2ff4:	f555                	bnez	a0,2fa0 <iref+0x48>
    if(chdir("irefd") != 0){
    2ff6:	8552                	mv	a0,s4
    2ff8:	00001097          	auipc	ra,0x1
    2ffc:	fb4080e7          	jalr	-76(ra) # 3fac <chdir>
    3000:	fd45                	bnez	a0,2fb8 <iref+0x60>
    mkdir("");
    3002:	8526                	mv	a0,s1
    3004:	00001097          	auipc	ra,0x1
    3008:	fa0080e7          	jalr	-96(ra) # 3fa4 <mkdir>
    link("README", "");
    300c:	85a6                	mv	a1,s1
    300e:	8556                	mv	a0,s5
    3010:	00001097          	auipc	ra,0x1
    3014:	f8c080e7          	jalr	-116(ra) # 3f9c <link>
    fd = open("", O_CREATE);
    3018:	20000593          	li	a1,512
    301c:	8526                	mv	a0,s1
    301e:	00001097          	auipc	ra,0x1
    3022:	f5e080e7          	jalr	-162(ra) # 3f7c <open>
    if(fd >= 0)
    3026:	fa0555e3          	bgez	a0,2fd0 <iref+0x78>
    fd = open("xx", O_CREATE);
    302a:	20000593          	li	a1,512
    302e:	854e                	mv	a0,s3
    3030:	00001097          	auipc	ra,0x1
    3034:	f4c080e7          	jalr	-180(ra) # 3f7c <open>
    if(fd >= 0)
    3038:	fa0541e3          	bltz	a0,2fda <iref+0x82>
      close(fd);
    303c:	00001097          	auipc	ra,0x1
    3040:	f28080e7          	jalr	-216(ra) # 3f64 <close>
    3044:	bf59                	j	2fda <iref+0x82>
  }

  chdir("/");
    3046:	00001517          	auipc	a0,0x1
    304a:	4c250513          	addi	a0,a0,1218 # 4508 <malloc+0x176>
    304e:	00001097          	auipc	ra,0x1
    3052:	f5e080e7          	jalr	-162(ra) # 3fac <chdir>
  printf("empty file name OK\n");
    3056:	00003517          	auipc	a0,0x3
    305a:	b8250513          	addi	a0,a0,-1150 # 5bd8 <malloc+0x1846>
    305e:	00001097          	auipc	ra,0x1
    3062:	276080e7          	jalr	630(ra) # 42d4 <printf>
}
    3066:	70e2                	ld	ra,56(sp)
    3068:	7442                	ld	s0,48(sp)
    306a:	74a2                	ld	s1,40(sp)
    306c:	7902                	ld	s2,32(sp)
    306e:	69e2                	ld	s3,24(sp)
    3070:	6a42                	ld	s4,16(sp)
    3072:	6aa2                	ld	s5,8(sp)
    3074:	6121                	addi	sp,sp,64
    3076:	8082                	ret

0000000000003078 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    3078:	1101                	addi	sp,sp,-32
    307a:	ec06                	sd	ra,24(sp)
    307c:	e822                	sd	s0,16(sp)
    307e:	e426                	sd	s1,8(sp)
    3080:	e04a                	sd	s2,0(sp)
    3082:	1000                	addi	s0,sp,32
  enum{ N = 1000 };
  int n, pid;

  printf("fork test\n");
    3084:	00002517          	auipc	a0,0x2
    3088:	ad450513          	addi	a0,a0,-1324 # 4b58 <malloc+0x7c6>
    308c:	00001097          	auipc	ra,0x1
    3090:	248080e7          	jalr	584(ra) # 42d4 <printf>

  for(n=0; n<N; n++){
    3094:	4481                	li	s1,0
    3096:	3e800913          	li	s2,1000
    pid = fork();
    309a:	00001097          	auipc	ra,0x1
    309e:	e9a080e7          	jalr	-358(ra) # 3f34 <fork>
    if(pid < 0)
    30a2:	02054663          	bltz	a0,30ce <forktest+0x56>
      break;
    if(pid == 0)
    30a6:	c105                	beqz	a0,30c6 <forktest+0x4e>
  for(n=0; n<N; n++){
    30a8:	2485                	addiw	s1,s1,1
    30aa:	ff2498e3          	bne	s1,s2,309a <forktest+0x22>
    printf("no fork at all!\n");
    exit();
  }

  if(n == N){
    printf("fork claimed to work 1000 times!\n");
    30ae:	00003517          	auipc	a0,0x3
    30b2:	b5a50513          	addi	a0,a0,-1190 # 5c08 <malloc+0x1876>
    30b6:	00001097          	auipc	ra,0x1
    30ba:	21e080e7          	jalr	542(ra) # 42d4 <printf>
    exit();
    30be:	00001097          	auipc	ra,0x1
    30c2:	e7e080e7          	jalr	-386(ra) # 3f3c <exit>
      exit();
    30c6:	00001097          	auipc	ra,0x1
    30ca:	e76080e7          	jalr	-394(ra) # 3f3c <exit>
  if (n == 0) {
    30ce:	c4a1                	beqz	s1,3116 <forktest+0x9e>
  if(n == N){
    30d0:	3e800793          	li	a5,1000
    30d4:	fcf48de3          	beq	s1,a5,30ae <forktest+0x36>
  }

  for(; n > 0; n--){
    30d8:	00905a63          	blez	s1,30ec <forktest+0x74>
    if(wait() < 0){
    30dc:	00001097          	auipc	ra,0x1
    30e0:	e68080e7          	jalr	-408(ra) # 3f44 <wait>
    30e4:	04054563          	bltz	a0,312e <forktest+0xb6>
  for(; n > 0; n--){
    30e8:	34fd                	addiw	s1,s1,-1
    30ea:	f8ed                	bnez	s1,30dc <forktest+0x64>
      printf("wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
    30ec:	00001097          	auipc	ra,0x1
    30f0:	e58080e7          	jalr	-424(ra) # 3f44 <wait>
    30f4:	57fd                	li	a5,-1
    30f6:	04f51863          	bne	a0,a5,3146 <forktest+0xce>
    printf("wait got too many\n");
    exit();
  }

  printf("fork test OK\n");
    30fa:	00003517          	auipc	a0,0x3
    30fe:	b6650513          	addi	a0,a0,-1178 # 5c60 <malloc+0x18ce>
    3102:	00001097          	auipc	ra,0x1
    3106:	1d2080e7          	jalr	466(ra) # 42d4 <printf>
}
    310a:	60e2                	ld	ra,24(sp)
    310c:	6442                	ld	s0,16(sp)
    310e:	64a2                	ld	s1,8(sp)
    3110:	6902                	ld	s2,0(sp)
    3112:	6105                	addi	sp,sp,32
    3114:	8082                	ret
    printf("no fork at all!\n");
    3116:	00003517          	auipc	a0,0x3
    311a:	ada50513          	addi	a0,a0,-1318 # 5bf0 <malloc+0x185e>
    311e:	00001097          	auipc	ra,0x1
    3122:	1b6080e7          	jalr	438(ra) # 42d4 <printf>
    exit();
    3126:	00001097          	auipc	ra,0x1
    312a:	e16080e7          	jalr	-490(ra) # 3f3c <exit>
      printf("wait stopped early\n");
    312e:	00003517          	auipc	a0,0x3
    3132:	b0250513          	addi	a0,a0,-1278 # 5c30 <malloc+0x189e>
    3136:	00001097          	auipc	ra,0x1
    313a:	19e080e7          	jalr	414(ra) # 42d4 <printf>
      exit();
    313e:	00001097          	auipc	ra,0x1
    3142:	dfe080e7          	jalr	-514(ra) # 3f3c <exit>
    printf("wait got too many\n");
    3146:	00003517          	auipc	a0,0x3
    314a:	b0250513          	addi	a0,a0,-1278 # 5c48 <malloc+0x18b6>
    314e:	00001097          	auipc	ra,0x1
    3152:	186080e7          	jalr	390(ra) # 42d4 <printf>
    exit();
    3156:	00001097          	auipc	ra,0x1
    315a:	de6080e7          	jalr	-538(ra) # 3f3c <exit>

000000000000315e <sbrktest>:

void
sbrktest(void)
{
    315e:	7119                	addi	sp,sp,-128
    3160:	fc86                	sd	ra,120(sp)
    3162:	f8a2                	sd	s0,112(sp)
    3164:	f4a6                	sd	s1,104(sp)
    3166:	f0ca                	sd	s2,96(sp)
    3168:	ecce                	sd	s3,88(sp)
    316a:	e8d2                	sd	s4,80(sp)
    316c:	e4d6                	sd	s5,72(sp)
    316e:	0100                	addi	s0,sp,128
  char *c, *oldbrk, scratch, *a, *b, *lastaddr, *p;
  uint64 amt;
  int fd;
  int n;

  printf("sbrk test\n");
    3170:	00003517          	auipc	a0,0x3
    3174:	b0050513          	addi	a0,a0,-1280 # 5c70 <malloc+0x18de>
    3178:	00001097          	auipc	ra,0x1
    317c:	15c080e7          	jalr	348(ra) # 42d4 <printf>
  oldbrk = sbrk(0);
    3180:	4501                	li	a0,0
    3182:	00001097          	auipc	ra,0x1
    3186:	e42080e7          	jalr	-446(ra) # 3fc4 <sbrk>
    318a:	89aa                	mv	s3,a0

  // does sbrk() return the expected failure value?
  a = sbrk(TOOMUCH);
    318c:	40000537          	lui	a0,0x40000
    3190:	00001097          	auipc	ra,0x1
    3194:	e34080e7          	jalr	-460(ra) # 3fc4 <sbrk>
  if(a != (char*)0xffffffffffffffffL){
    3198:	57fd                	li	a5,-1
    319a:	00f51d63          	bne	a0,a5,31b4 <sbrktest+0x56>
    printf("sbrk(<toomuch>) returned %p\n", a);
    exit();
  }

  // can one sbrk() less than a page?
  a = sbrk(0);
    319e:	4501                	li	a0,0
    31a0:	00001097          	auipc	ra,0x1
    31a4:	e24080e7          	jalr	-476(ra) # 3fc4 <sbrk>
    31a8:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    31aa:	4901                	li	s2,0
    31ac:	6a05                	lui	s4,0x1
    31ae:	388a0a13          	addi	s4,s4,904 # 1388 <fourfiles+0x12a>
    31b2:	a839                	j	31d0 <sbrktest+0x72>
    printf("sbrk(<toomuch>) returned %p\n", a);
    31b4:	85aa                	mv	a1,a0
    31b6:	00003517          	auipc	a0,0x3
    31ba:	aca50513          	addi	a0,a0,-1334 # 5c80 <malloc+0x18ee>
    31be:	00001097          	auipc	ra,0x1
    31c2:	116080e7          	jalr	278(ra) # 42d4 <printf>
    exit();
    31c6:	00001097          	auipc	ra,0x1
    31ca:	d76080e7          	jalr	-650(ra) # 3f3c <exit>
    if(b != a){
      printf("sbrk test failed %d %x %x\n", i, a, b);
      exit();
    }
    *b = 1;
    a = b + 1;
    31ce:	84be                	mv	s1,a5
    b = sbrk(1);
    31d0:	4505                	li	a0,1
    31d2:	00001097          	auipc	ra,0x1
    31d6:	df2080e7          	jalr	-526(ra) # 3fc4 <sbrk>
    if(b != a){
    31da:	14951f63          	bne	a0,s1,3338 <sbrktest+0x1da>
    *b = 1;
    31de:	4785                	li	a5,1
    31e0:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    31e4:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    31e8:	2905                	addiw	s2,s2,1
    31ea:	ff4912e3          	bne	s2,s4,31ce <sbrktest+0x70>
  }
  pid = fork();
    31ee:	00001097          	auipc	ra,0x1
    31f2:	d46080e7          	jalr	-698(ra) # 3f34 <fork>
    31f6:	892a                	mv	s2,a0
  if(pid < 0){
    31f8:	14054f63          	bltz	a0,3356 <sbrktest+0x1f8>
    printf("sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
    31fc:	4505                	li	a0,1
    31fe:	00001097          	auipc	ra,0x1
    3202:	dc6080e7          	jalr	-570(ra) # 3fc4 <sbrk>
  c = sbrk(1);
    3206:	4505                	li	a0,1
    3208:	00001097          	auipc	ra,0x1
    320c:	dbc080e7          	jalr	-580(ra) # 3fc4 <sbrk>
  if(c != a + 1){
    3210:	0489                	addi	s1,s1,2
    3212:	14a49e63          	bne	s1,a0,336e <sbrktest+0x210>
    printf("sbrk test failed post-fork\n");
    exit();
  }
  if(pid == 0)
    3216:	16090863          	beqz	s2,3386 <sbrktest+0x228>
    exit();
  wait();
    321a:	00001097          	auipc	ra,0x1
    321e:	d2a080e7          	jalr	-726(ra) # 3f44 <wait>

  // can one grow address space to something big?
  a = sbrk(0);
    3222:	4501                	li	a0,0
    3224:	00001097          	auipc	ra,0x1
    3228:	da0080e7          	jalr	-608(ra) # 3fc4 <sbrk>
    322c:	84aa                	mv	s1,a0
  amt = BIG - (uint64)a;
  p = sbrk(amt);
    322e:	06400537          	lui	a0,0x6400
    3232:	9d05                	subw	a0,a0,s1
    3234:	00001097          	auipc	ra,0x1
    3238:	d90080e7          	jalr	-624(ra) # 3fc4 <sbrk>
  if (p != a) {
    323c:	14a49963          	bne	s1,a0,338e <sbrktest+0x230>
    printf("sbrk test failed to grow big address space; enough phys mem?\n");
    exit();
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    3240:	064007b7          	lui	a5,0x6400
    3244:	06300713          	li	a4,99
    3248:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f458f>

  // can one de-allocate?
  a = sbrk(0);
    324c:	4501                	li	a0,0
    324e:	00001097          	auipc	ra,0x1
    3252:	d76080e7          	jalr	-650(ra) # 3fc4 <sbrk>
    3256:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    3258:	757d                	lui	a0,0xfffff
    325a:	00001097          	auipc	ra,0x1
    325e:	d6a080e7          	jalr	-662(ra) # 3fc4 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    3262:	57fd                	li	a5,-1
    3264:	14f50163          	beq	a0,a5,33a6 <sbrktest+0x248>
    printf("sbrk could not deallocate\n");
    exit();
  }
  c = sbrk(0);
    3268:	4501                	li	a0,0
    326a:	00001097          	auipc	ra,0x1
    326e:	d5a080e7          	jalr	-678(ra) # 3fc4 <sbrk>
  if(c != a - PGSIZE){
    3272:	77fd                	lui	a5,0xfffff
    3274:	97a6                	add	a5,a5,s1
    3276:	14f51463          	bne	a0,a5,33be <sbrktest+0x260>
    printf("sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
    327a:	4501                	li	a0,0
    327c:	00001097          	auipc	ra,0x1
    3280:	d48080e7          	jalr	-696(ra) # 3fc4 <sbrk>
    3284:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    3286:	6505                	lui	a0,0x1
    3288:	00001097          	auipc	ra,0x1
    328c:	d3c080e7          	jalr	-708(ra) # 3fc4 <sbrk>
    3290:	892a                	mv	s2,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    3292:	14a49463          	bne	s1,a0,33da <sbrktest+0x27c>
    3296:	4501                	li	a0,0
    3298:	00001097          	auipc	ra,0x1
    329c:	d2c080e7          	jalr	-724(ra) # 3fc4 <sbrk>
    32a0:	6785                	lui	a5,0x1
    32a2:	97a6                	add	a5,a5,s1
    32a4:	12f51b63          	bne	a0,a5,33da <sbrktest+0x27c>
    printf("sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
    32a8:	064007b7          	lui	a5,0x6400
    32ac:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f458f>
    32b0:	06300793          	li	a5,99
    32b4:	14f70163          	beq	a4,a5,33f6 <sbrktest+0x298>
    // should be zero
    printf("sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
    32b8:	4501                	li	a0,0
    32ba:	00001097          	auipc	ra,0x1
    32be:	d0a080e7          	jalr	-758(ra) # 3fc4 <sbrk>
    32c2:	892a                	mv	s2,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    32c4:	4501                	li	a0,0
    32c6:	00001097          	auipc	ra,0x1
    32ca:	cfe080e7          	jalr	-770(ra) # 3fc4 <sbrk>
    32ce:	40a9853b          	subw	a0,s3,a0
    32d2:	00001097          	auipc	ra,0x1
    32d6:	cf2080e7          	jalr	-782(ra) # 3fc4 <sbrk>
    printf("sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    32da:	4485                	li	s1,1
    32dc:	04fe                	slli	s1,s1,0x1f
  if(c != a){
    32de:	12a91863          	bne	s2,a0,340e <sbrktest+0x2b0>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    32e2:	6ab1                	lui	s5,0xc
    32e4:	350a8a93          	addi	s5,s5,848 # c350 <__BSS_END__+0x8e0>
    32e8:	1003da37          	lui	s4,0x1003d
    32ec:	0a0e                	slli	s4,s4,0x3
    32ee:	480a0a13          	addi	s4,s4,1152 # 1003d480 <__BSS_END__+0x10031a10>
    ppid = getpid();
    32f2:	00001097          	auipc	ra,0x1
    32f6:	cca080e7          	jalr	-822(ra) # 3fbc <getpid>
    32fa:	892a                	mv	s2,a0
    pid = fork();
    32fc:	00001097          	auipc	ra,0x1
    3300:	c38080e7          	jalr	-968(ra) # 3f34 <fork>
    if(pid < 0){
    3304:	12054363          	bltz	a0,342a <sbrktest+0x2cc>
      printf("fork failed\n");
      exit();
    }
    if(pid == 0){
    3308:	12050d63          	beqz	a0,3442 <sbrktest+0x2e4>
      printf("oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit();
    }
    wait();
    330c:	00001097          	auipc	ra,0x1
    3310:	c38080e7          	jalr	-968(ra) # 3f44 <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3314:	94d6                	add	s1,s1,s5
    3316:	fd449ee3          	bne	s1,s4,32f2 <sbrktest+0x194>
  }
    
  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    331a:	fb840513          	addi	a0,s0,-72
    331e:	00001097          	auipc	ra,0x1
    3322:	c2e080e7          	jalr	-978(ra) # 3f4c <pipe>
    3326:	14051263          	bnez	a0,346a <sbrktest+0x30c>
    332a:	f9040493          	addi	s1,s0,-112
    332e:	fb840a13          	addi	s4,s0,-72
    3332:	8926                	mv	s2,s1
      sbrk(BIG - (uint64)sbrk(0));
      write(fds[1], "x", 1);
      // sit around until killed
      for(;;) sleep(1000);
    }
    if(pids[i] != -1)
    3334:	5afd                	li	s5,-1
    3336:	a279                	j	34c4 <sbrktest+0x366>
      printf("sbrk test failed %d %x %x\n", i, a, b);
    3338:	86aa                	mv	a3,a0
    333a:	8626                	mv	a2,s1
    333c:	85ca                	mv	a1,s2
    333e:	00003517          	auipc	a0,0x3
    3342:	96250513          	addi	a0,a0,-1694 # 5ca0 <malloc+0x190e>
    3346:	00001097          	auipc	ra,0x1
    334a:	f8e080e7          	jalr	-114(ra) # 42d4 <printf>
      exit();
    334e:	00001097          	auipc	ra,0x1
    3352:	bee080e7          	jalr	-1042(ra) # 3f3c <exit>
    printf("sbrk test fork failed\n");
    3356:	00003517          	auipc	a0,0x3
    335a:	96a50513          	addi	a0,a0,-1686 # 5cc0 <malloc+0x192e>
    335e:	00001097          	auipc	ra,0x1
    3362:	f76080e7          	jalr	-138(ra) # 42d4 <printf>
    exit();
    3366:	00001097          	auipc	ra,0x1
    336a:	bd6080e7          	jalr	-1066(ra) # 3f3c <exit>
    printf("sbrk test failed post-fork\n");
    336e:	00003517          	auipc	a0,0x3
    3372:	96a50513          	addi	a0,a0,-1686 # 5cd8 <malloc+0x1946>
    3376:	00001097          	auipc	ra,0x1
    337a:	f5e080e7          	jalr	-162(ra) # 42d4 <printf>
    exit();
    337e:	00001097          	auipc	ra,0x1
    3382:	bbe080e7          	jalr	-1090(ra) # 3f3c <exit>
    exit();
    3386:	00001097          	auipc	ra,0x1
    338a:	bb6080e7          	jalr	-1098(ra) # 3f3c <exit>
    printf("sbrk test failed to grow big address space; enough phys mem?\n");
    338e:	00003517          	auipc	a0,0x3
    3392:	96a50513          	addi	a0,a0,-1686 # 5cf8 <malloc+0x1966>
    3396:	00001097          	auipc	ra,0x1
    339a:	f3e080e7          	jalr	-194(ra) # 42d4 <printf>
    exit();
    339e:	00001097          	auipc	ra,0x1
    33a2:	b9e080e7          	jalr	-1122(ra) # 3f3c <exit>
    printf("sbrk could not deallocate\n");
    33a6:	00003517          	auipc	a0,0x3
    33aa:	99250513          	addi	a0,a0,-1646 # 5d38 <malloc+0x19a6>
    33ae:	00001097          	auipc	ra,0x1
    33b2:	f26080e7          	jalr	-218(ra) # 42d4 <printf>
    exit();
    33b6:	00001097          	auipc	ra,0x1
    33ba:	b86080e7          	jalr	-1146(ra) # 3f3c <exit>
    printf("sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    33be:	862a                	mv	a2,a0
    33c0:	85a6                	mv	a1,s1
    33c2:	00003517          	auipc	a0,0x3
    33c6:	99650513          	addi	a0,a0,-1642 # 5d58 <malloc+0x19c6>
    33ca:	00001097          	auipc	ra,0x1
    33ce:	f0a080e7          	jalr	-246(ra) # 42d4 <printf>
    exit();
    33d2:	00001097          	auipc	ra,0x1
    33d6:	b6a080e7          	jalr	-1174(ra) # 3f3c <exit>
    printf("sbrk re-allocation failed, a %x c %x\n", a, c);
    33da:	864a                	mv	a2,s2
    33dc:	85a6                	mv	a1,s1
    33de:	00003517          	auipc	a0,0x3
    33e2:	9b250513          	addi	a0,a0,-1614 # 5d90 <malloc+0x19fe>
    33e6:	00001097          	auipc	ra,0x1
    33ea:	eee080e7          	jalr	-274(ra) # 42d4 <printf>
    exit();
    33ee:	00001097          	auipc	ra,0x1
    33f2:	b4e080e7          	jalr	-1202(ra) # 3f3c <exit>
    printf("sbrk de-allocation didn't really deallocate\n");
    33f6:	00003517          	auipc	a0,0x3
    33fa:	9c250513          	addi	a0,a0,-1598 # 5db8 <malloc+0x1a26>
    33fe:	00001097          	auipc	ra,0x1
    3402:	ed6080e7          	jalr	-298(ra) # 42d4 <printf>
    exit();
    3406:	00001097          	auipc	ra,0x1
    340a:	b36080e7          	jalr	-1226(ra) # 3f3c <exit>
    printf("sbrk downsize failed, a %x c %x\n", a, c);
    340e:	862a                	mv	a2,a0
    3410:	85ca                	mv	a1,s2
    3412:	00003517          	auipc	a0,0x3
    3416:	9d650513          	addi	a0,a0,-1578 # 5de8 <malloc+0x1a56>
    341a:	00001097          	auipc	ra,0x1
    341e:	eba080e7          	jalr	-326(ra) # 42d4 <printf>
    exit();
    3422:	00001097          	auipc	ra,0x1
    3426:	b1a080e7          	jalr	-1254(ra) # 3f3c <exit>
      printf("fork failed\n");
    342a:	00001517          	auipc	a0,0x1
    342e:	11650513          	addi	a0,a0,278 # 4540 <malloc+0x1ae>
    3432:	00001097          	auipc	ra,0x1
    3436:	ea2080e7          	jalr	-350(ra) # 42d4 <printf>
      exit();
    343a:	00001097          	auipc	ra,0x1
    343e:	b02080e7          	jalr	-1278(ra) # 3f3c <exit>
      printf("oops could read %x = %x\n", a, *a);
    3442:	0004c603          	lbu	a2,0(s1)
    3446:	85a6                	mv	a1,s1
    3448:	00003517          	auipc	a0,0x3
    344c:	9c850513          	addi	a0,a0,-1592 # 5e10 <malloc+0x1a7e>
    3450:	00001097          	auipc	ra,0x1
    3454:	e84080e7          	jalr	-380(ra) # 42d4 <printf>
      kill(ppid);
    3458:	854a                	mv	a0,s2
    345a:	00001097          	auipc	ra,0x1
    345e:	b12080e7          	jalr	-1262(ra) # 3f6c <kill>
      exit();
    3462:	00001097          	auipc	ra,0x1
    3466:	ada080e7          	jalr	-1318(ra) # 3f3c <exit>
    printf("pipe() failed\n");
    346a:	00001517          	auipc	a0,0x1
    346e:	55e50513          	addi	a0,a0,1374 # 49c8 <malloc+0x636>
    3472:	00001097          	auipc	ra,0x1
    3476:	e62080e7          	jalr	-414(ra) # 42d4 <printf>
    exit();
    347a:	00001097          	auipc	ra,0x1
    347e:	ac2080e7          	jalr	-1342(ra) # 3f3c <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3482:	00001097          	auipc	ra,0x1
    3486:	b42080e7          	jalr	-1214(ra) # 3fc4 <sbrk>
    348a:	064007b7          	lui	a5,0x6400
    348e:	40a7853b          	subw	a0,a5,a0
    3492:	00001097          	auipc	ra,0x1
    3496:	b32080e7          	jalr	-1230(ra) # 3fc4 <sbrk>
      write(fds[1], "x", 1);
    349a:	4605                	li	a2,1
    349c:	00001597          	auipc	a1,0x1
    34a0:	5b458593          	addi	a1,a1,1460 # 4a50 <malloc+0x6be>
    34a4:	fbc42503          	lw	a0,-68(s0)
    34a8:	00001097          	auipc	ra,0x1
    34ac:	ab4080e7          	jalr	-1356(ra) # 3f5c <write>
      for(;;) sleep(1000);
    34b0:	3e800513          	li	a0,1000
    34b4:	00001097          	auipc	ra,0x1
    34b8:	b18080e7          	jalr	-1256(ra) # 3fcc <sleep>
    34bc:	bfd5                	j	34b0 <sbrktest+0x352>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    34be:	0911                	addi	s2,s2,4
    34c0:	03490563          	beq	s2,s4,34ea <sbrktest+0x38c>
    if((pids[i] = fork()) == 0){
    34c4:	00001097          	auipc	ra,0x1
    34c8:	a70080e7          	jalr	-1424(ra) # 3f34 <fork>
    34cc:	00a92023          	sw	a0,0(s2)
    34d0:	d94d                	beqz	a0,3482 <sbrktest+0x324>
    if(pids[i] != -1)
    34d2:	ff5506e3          	beq	a0,s5,34be <sbrktest+0x360>
      read(fds[0], &scratch, 1);
    34d6:	4605                	li	a2,1
    34d8:	f8f40593          	addi	a1,s0,-113
    34dc:	fb842503          	lw	a0,-72(s0)
    34e0:	00001097          	auipc	ra,0x1
    34e4:	a74080e7          	jalr	-1420(ra) # 3f54 <read>
    34e8:	bfd9                	j	34be <sbrktest+0x360>
  }

  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(PGSIZE);
    34ea:	6505                	lui	a0,0x1
    34ec:	00001097          	auipc	ra,0x1
    34f0:	ad8080e7          	jalr	-1320(ra) # 3fc4 <sbrk>
    34f4:	8aaa                	mv	s5,a0
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
    34f6:	597d                	li	s2,-1
    34f8:	a021                	j	3500 <sbrktest+0x3a2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    34fa:	0491                	addi	s1,s1,4
    34fc:	01448e63          	beq	s1,s4,3518 <sbrktest+0x3ba>
    if(pids[i] == -1)
    3500:	4088                	lw	a0,0(s1)
    3502:	ff250ce3          	beq	a0,s2,34fa <sbrktest+0x39c>
      continue;
    kill(pids[i]);
    3506:	00001097          	auipc	ra,0x1
    350a:	a66080e7          	jalr	-1434(ra) # 3f6c <kill>
    wait();
    350e:	00001097          	auipc	ra,0x1
    3512:	a36080e7          	jalr	-1482(ra) # 3f44 <wait>
    3516:	b7d5                	j	34fa <sbrktest+0x39c>
  }
  if(c == (char*)0xffffffffffffffffL){
    3518:	57fd                	li	a5,-1
    351a:	0afa8e63          	beq	s5,a5,35d6 <sbrktest+0x478>
    printf("failed sbrk leaked memory\n");
    exit();
  }

  // test running fork with the above allocated page 
  ppid = getpid();
    351e:	00001097          	auipc	ra,0x1
    3522:	a9e080e7          	jalr	-1378(ra) # 3fbc <getpid>
    3526:	892a                	mv	s2,a0
  pid = fork();
    3528:	00001097          	auipc	ra,0x1
    352c:	a0c080e7          	jalr	-1524(ra) # 3f34 <fork>
    3530:	84aa                	mv	s1,a0
  if(pid < 0){
    3532:	0a054e63          	bltz	a0,35ee <sbrktest+0x490>
    printf("fork failed\n");
    exit();
  }

  // test out of memory during sbrk
  if(pid == 0){
    3536:	c961                	beqz	a0,3606 <sbrktest+0x4a8>
    }
    printf("allocate a lot of memory succeeded %d\n", n);
    kill(ppid);
    exit();
  }
  wait();
    3538:	00001097          	auipc	ra,0x1
    353c:	a0c080e7          	jalr	-1524(ra) # 3f44 <wait>

  // test reads from allocated memory
  a = sbrk(PGSIZE);
    3540:	6505                	lui	a0,0x1
    3542:	00001097          	auipc	ra,0x1
    3546:	a82080e7          	jalr	-1406(ra) # 3fc4 <sbrk>
    354a:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    354c:	20100593          	li	a1,513
    3550:	00003517          	auipc	a0,0x3
    3554:	92850513          	addi	a0,a0,-1752 # 5e78 <malloc+0x1ae6>
    3558:	00001097          	auipc	ra,0x1
    355c:	a24080e7          	jalr	-1500(ra) # 3f7c <open>
    3560:	84aa                	mv	s1,a0
  unlink("sbrk");
    3562:	00003517          	auipc	a0,0x3
    3566:	91650513          	addi	a0,a0,-1770 # 5e78 <malloc+0x1ae6>
    356a:	00001097          	auipc	ra,0x1
    356e:	a22080e7          	jalr	-1502(ra) # 3f8c <unlink>
  if(fd < 0)  {
    3572:	0e04c363          	bltz	s1,3658 <sbrktest+0x4fa>
    printf("open sbrk failed\n");
    exit();
  }
  if ((n = write(fd, a, 10)) < 0) {
    3576:	4629                	li	a2,10
    3578:	85ca                	mv	a1,s2
    357a:	8526                	mv	a0,s1
    357c:	00001097          	auipc	ra,0x1
    3580:	9e0080e7          	jalr	-1568(ra) # 3f5c <write>
    3584:	0e054663          	bltz	a0,3670 <sbrktest+0x512>
    printf("write sbrk failed\n");
    exit();
  }
  close(fd);
    3588:	8526                	mv	a0,s1
    358a:	00001097          	auipc	ra,0x1
    358e:	9da080e7          	jalr	-1574(ra) # 3f64 <close>

  // test writes to allocated memory
  a = sbrk(PGSIZE);
    3592:	6505                	lui	a0,0x1
    3594:	00001097          	auipc	ra,0x1
    3598:	a30080e7          	jalr	-1488(ra) # 3fc4 <sbrk>
  if(pipe((int *) a) != 0){
    359c:	00001097          	auipc	ra,0x1
    35a0:	9b0080e7          	jalr	-1616(ra) # 3f4c <pipe>
    35a4:	e175                	bnez	a0,3688 <sbrktest+0x52a>
    printf("pipe() failed\n");
    exit();
  } 

  if(sbrk(0) > oldbrk)
    35a6:	4501                	li	a0,0
    35a8:	00001097          	auipc	ra,0x1
    35ac:	a1c080e7          	jalr	-1508(ra) # 3fc4 <sbrk>
    35b0:	0ea9e863          	bltu	s3,a0,36a0 <sbrktest+0x542>
    sbrk(-(sbrk(0) - oldbrk));

  printf("sbrk test OK\n");
    35b4:	00003517          	auipc	a0,0x3
    35b8:	8fc50513          	addi	a0,a0,-1796 # 5eb0 <malloc+0x1b1e>
    35bc:	00001097          	auipc	ra,0x1
    35c0:	d18080e7          	jalr	-744(ra) # 42d4 <printf>
}
    35c4:	70e6                	ld	ra,120(sp)
    35c6:	7446                	ld	s0,112(sp)
    35c8:	74a6                	ld	s1,104(sp)
    35ca:	7906                	ld	s2,96(sp)
    35cc:	69e6                	ld	s3,88(sp)
    35ce:	6a46                	ld	s4,80(sp)
    35d0:	6aa6                	ld	s5,72(sp)
    35d2:	6109                	addi	sp,sp,128
    35d4:	8082                	ret
    printf("failed sbrk leaked memory\n");
    35d6:	00003517          	auipc	a0,0x3
    35da:	85a50513          	addi	a0,a0,-1958 # 5e30 <malloc+0x1a9e>
    35de:	00001097          	auipc	ra,0x1
    35e2:	cf6080e7          	jalr	-778(ra) # 42d4 <printf>
    exit();
    35e6:	00001097          	auipc	ra,0x1
    35ea:	956080e7          	jalr	-1706(ra) # 3f3c <exit>
    printf("fork failed\n");
    35ee:	00001517          	auipc	a0,0x1
    35f2:	f5250513          	addi	a0,a0,-174 # 4540 <malloc+0x1ae>
    35f6:	00001097          	auipc	ra,0x1
    35fa:	cde080e7          	jalr	-802(ra) # 42d4 <printf>
    exit();
    35fe:	00001097          	auipc	ra,0x1
    3602:	93e080e7          	jalr	-1730(ra) # 3f3c <exit>
    a = sbrk(0);
    3606:	4501                	li	a0,0
    3608:	00001097          	auipc	ra,0x1
    360c:	9bc080e7          	jalr	-1604(ra) # 3fc4 <sbrk>
    3610:	89aa                	mv	s3,a0
    sbrk(10*BIG);
    3612:	3e800537          	lui	a0,0x3e800
    3616:	00001097          	auipc	ra,0x1
    361a:	9ae080e7          	jalr	-1618(ra) # 3fc4 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    361e:	87ce                	mv	a5,s3
    3620:	3e800737          	lui	a4,0x3e800
    3624:	99ba                	add	s3,s3,a4
    3626:	6705                	lui	a4,0x1
      n += *(a+i);
    3628:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f4590>
    362c:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    362e:	97ba                	add	a5,a5,a4
    3630:	ff379ce3          	bne	a5,s3,3628 <sbrktest+0x4ca>
    printf("allocate a lot of memory succeeded %d\n", n);
    3634:	85a6                	mv	a1,s1
    3636:	00003517          	auipc	a0,0x3
    363a:	81a50513          	addi	a0,a0,-2022 # 5e50 <malloc+0x1abe>
    363e:	00001097          	auipc	ra,0x1
    3642:	c96080e7          	jalr	-874(ra) # 42d4 <printf>
    kill(ppid);
    3646:	854a                	mv	a0,s2
    3648:	00001097          	auipc	ra,0x1
    364c:	924080e7          	jalr	-1756(ra) # 3f6c <kill>
    exit();
    3650:	00001097          	auipc	ra,0x1
    3654:	8ec080e7          	jalr	-1812(ra) # 3f3c <exit>
    printf("open sbrk failed\n");
    3658:	00003517          	auipc	a0,0x3
    365c:	82850513          	addi	a0,a0,-2008 # 5e80 <malloc+0x1aee>
    3660:	00001097          	auipc	ra,0x1
    3664:	c74080e7          	jalr	-908(ra) # 42d4 <printf>
    exit();
    3668:	00001097          	auipc	ra,0x1
    366c:	8d4080e7          	jalr	-1836(ra) # 3f3c <exit>
    printf("write sbrk failed\n");
    3670:	00003517          	auipc	a0,0x3
    3674:	82850513          	addi	a0,a0,-2008 # 5e98 <malloc+0x1b06>
    3678:	00001097          	auipc	ra,0x1
    367c:	c5c080e7          	jalr	-932(ra) # 42d4 <printf>
    exit();
    3680:	00001097          	auipc	ra,0x1
    3684:	8bc080e7          	jalr	-1860(ra) # 3f3c <exit>
    printf("pipe() failed\n");
    3688:	00001517          	auipc	a0,0x1
    368c:	34050513          	addi	a0,a0,832 # 49c8 <malloc+0x636>
    3690:	00001097          	auipc	ra,0x1
    3694:	c44080e7          	jalr	-956(ra) # 42d4 <printf>
    exit();
    3698:	00001097          	auipc	ra,0x1
    369c:	8a4080e7          	jalr	-1884(ra) # 3f3c <exit>
    sbrk(-(sbrk(0) - oldbrk));
    36a0:	4501                	li	a0,0
    36a2:	00001097          	auipc	ra,0x1
    36a6:	922080e7          	jalr	-1758(ra) # 3fc4 <sbrk>
    36aa:	40a9853b          	subw	a0,s3,a0
    36ae:	00001097          	auipc	ra,0x1
    36b2:	916080e7          	jalr	-1770(ra) # 3fc4 <sbrk>
    36b6:	bdfd                	j	35b4 <sbrktest+0x456>

00000000000036b8 <validatetest>:

void
validatetest(void)
{
    36b8:	7139                	addi	sp,sp,-64
    36ba:	fc06                	sd	ra,56(sp)
    36bc:	f822                	sd	s0,48(sp)
    36be:	f426                	sd	s1,40(sp)
    36c0:	f04a                	sd	s2,32(sp)
    36c2:	ec4e                	sd	s3,24(sp)
    36c4:	e852                	sd	s4,16(sp)
    36c6:	e456                	sd	s5,8(sp)
    36c8:	0080                	addi	s0,sp,64
  int hi;
  uint64 p;

  printf("validate test\n");
    36ca:	00002517          	auipc	a0,0x2
    36ce:	7f650513          	addi	a0,a0,2038 # 5ec0 <malloc+0x1b2e>
    36d2:	00001097          	auipc	ra,0x1
    36d6:	c02080e7          	jalr	-1022(ra) # 42d4 <printf>
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += PGSIZE){
    36da:	4481                	li	s1,0
    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    36dc:	00002997          	auipc	s3,0x2
    36e0:	7f498993          	addi	s3,s3,2036 # 5ed0 <malloc+0x1b3e>
    36e4:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    36e6:	6a85                	lui	s5,0x1
    36e8:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    36ec:	85a6                	mv	a1,s1
    36ee:	854e                	mv	a0,s3
    36f0:	00001097          	auipc	ra,0x1
    36f4:	8ac080e7          	jalr	-1876(ra) # 3f9c <link>
    36f8:	03251663          	bne	a0,s2,3724 <validatetest+0x6c>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    36fc:	94d6                	add	s1,s1,s5
    36fe:	ff4497e3          	bne	s1,s4,36ec <validatetest+0x34>
      printf("link should not succeed\n");
      exit();
    }
  }

  printf("validate ok\n");
    3702:	00002517          	auipc	a0,0x2
    3706:	7fe50513          	addi	a0,a0,2046 # 5f00 <malloc+0x1b6e>
    370a:	00001097          	auipc	ra,0x1
    370e:	bca080e7          	jalr	-1078(ra) # 42d4 <printf>
}
    3712:	70e2                	ld	ra,56(sp)
    3714:	7442                	ld	s0,48(sp)
    3716:	74a2                	ld	s1,40(sp)
    3718:	7902                	ld	s2,32(sp)
    371a:	69e2                	ld	s3,24(sp)
    371c:	6a42                	ld	s4,16(sp)
    371e:	6aa2                	ld	s5,8(sp)
    3720:	6121                	addi	sp,sp,64
    3722:	8082                	ret
      printf("link should not succeed\n");
    3724:	00002517          	auipc	a0,0x2
    3728:	7bc50513          	addi	a0,a0,1980 # 5ee0 <malloc+0x1b4e>
    372c:	00001097          	auipc	ra,0x1
    3730:	ba8080e7          	jalr	-1112(ra) # 42d4 <printf>
      exit();
    3734:	00001097          	auipc	ra,0x1
    3738:	808080e7          	jalr	-2040(ra) # 3f3c <exit>

000000000000373c <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    373c:	1141                	addi	sp,sp,-16
    373e:	e406                	sd	ra,8(sp)
    3740:	e022                	sd	s0,0(sp)
    3742:	0800                	addi	s0,sp,16
  int i;

  printf("bss test\n");
    3744:	00002517          	auipc	a0,0x2
    3748:	7cc50513          	addi	a0,a0,1996 # 5f10 <malloc+0x1b7e>
    374c:	00001097          	auipc	ra,0x1
    3750:	b88080e7          	jalr	-1144(ra) # 42d4 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    3754:	00003797          	auipc	a5,0x3
    3758:	bfc78793          	addi	a5,a5,-1028 # 6350 <uninit>
    375c:	00005697          	auipc	a3,0x5
    3760:	30468693          	addi	a3,a3,772 # 8a60 <buf>
    if(uninit[i] != '\0'){
    3764:	0007c703          	lbu	a4,0(a5)
    3768:	e305                	bnez	a4,3788 <bsstest+0x4c>
  for(i = 0; i < sizeof(uninit); i++){
    376a:	0785                	addi	a5,a5,1
    376c:	fed79ce3          	bne	a5,a3,3764 <bsstest+0x28>
      printf("bss test failed\n");
      exit();
    }
  }
  printf("bss test ok\n");
    3770:	00002517          	auipc	a0,0x2
    3774:	7c850513          	addi	a0,a0,1992 # 5f38 <malloc+0x1ba6>
    3778:	00001097          	auipc	ra,0x1
    377c:	b5c080e7          	jalr	-1188(ra) # 42d4 <printf>
}
    3780:	60a2                	ld	ra,8(sp)
    3782:	6402                	ld	s0,0(sp)
    3784:	0141                	addi	sp,sp,16
    3786:	8082                	ret
      printf("bss test failed\n");
    3788:	00002517          	auipc	a0,0x2
    378c:	79850513          	addi	a0,a0,1944 # 5f20 <malloc+0x1b8e>
    3790:	00001097          	auipc	ra,0x1
    3794:	b44080e7          	jalr	-1212(ra) # 42d4 <printf>
      exit();
    3798:	00000097          	auipc	ra,0x0
    379c:	7a4080e7          	jalr	1956(ra) # 3f3c <exit>

00000000000037a0 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    37a0:	1101                	addi	sp,sp,-32
    37a2:	ec06                	sd	ra,24(sp)
    37a4:	e822                	sd	s0,16(sp)
    37a6:	e426                	sd	s1,8(sp)
    37a8:	1000                	addi	s0,sp,32
  int pid, fd;

  unlink("bigarg-ok");
    37aa:	00002517          	auipc	a0,0x2
    37ae:	79e50513          	addi	a0,a0,1950 # 5f48 <malloc+0x1bb6>
    37b2:	00000097          	auipc	ra,0x0
    37b6:	7da080e7          	jalr	2010(ra) # 3f8c <unlink>
  pid = fork();
    37ba:	00000097          	auipc	ra,0x0
    37be:	77a080e7          	jalr	1914(ra) # 3f34 <fork>
  if(pid == 0){
    37c2:	c139                	beqz	a0,3808 <bigargtest+0x68>
    exec("echo", args);
    printf("bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit();
  } else if(pid < 0){
    37c4:	0c054363          	bltz	a0,388a <bigargtest+0xea>
    printf("bigargtest: fork failed\n");
    exit();
  }
  wait();
    37c8:	00000097          	auipc	ra,0x0
    37cc:	77c080e7          	jalr	1916(ra) # 3f44 <wait>
  fd = open("bigarg-ok", 0);
    37d0:	4581                	li	a1,0
    37d2:	00002517          	auipc	a0,0x2
    37d6:	77650513          	addi	a0,a0,1910 # 5f48 <malloc+0x1bb6>
    37da:	00000097          	auipc	ra,0x0
    37de:	7a2080e7          	jalr	1954(ra) # 3f7c <open>
  if(fd < 0){
    37e2:	0c054063          	bltz	a0,38a2 <bigargtest+0x102>
    printf("bigarg test failed!\n");
    exit();
  }
  close(fd);
    37e6:	00000097          	auipc	ra,0x0
    37ea:	77e080e7          	jalr	1918(ra) # 3f64 <close>
  unlink("bigarg-ok");
    37ee:	00002517          	auipc	a0,0x2
    37f2:	75a50513          	addi	a0,a0,1882 # 5f48 <malloc+0x1bb6>
    37f6:	00000097          	auipc	ra,0x0
    37fa:	796080e7          	jalr	1942(ra) # 3f8c <unlink>
}
    37fe:	60e2                	ld	ra,24(sp)
    3800:	6442                	ld	s0,16(sp)
    3802:	64a2                	ld	s1,8(sp)
    3804:	6105                	addi	sp,sp,32
    3806:	8082                	ret
    3808:	00003797          	auipc	a5,0x3
    380c:	a4878793          	addi	a5,a5,-1464 # 6250 <args.0>
    3810:	00003697          	auipc	a3,0x3
    3814:	b3868693          	addi	a3,a3,-1224 # 6348 <args.0+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3818:	00002717          	auipc	a4,0x2
    381c:	74070713          	addi	a4,a4,1856 # 5f58 <malloc+0x1bc6>
    3820:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    3822:	07a1                	addi	a5,a5,8
    3824:	fed79ee3          	bne	a5,a3,3820 <bigargtest+0x80>
    args[MAXARG-1] = 0;
    3828:	00003497          	auipc	s1,0x3
    382c:	a2848493          	addi	s1,s1,-1496 # 6250 <args.0>
    3830:	0e04bc23          	sd	zero,248(s1)
    printf("bigarg test\n");
    3834:	00003517          	auipc	a0,0x3
    3838:	80450513          	addi	a0,a0,-2044 # 6038 <malloc+0x1ca6>
    383c:	00001097          	auipc	ra,0x1
    3840:	a98080e7          	jalr	-1384(ra) # 42d4 <printf>
    exec("echo", args);
    3844:	85a6                	mv	a1,s1
    3846:	00001517          	auipc	a0,0x1
    384a:	dca50513          	addi	a0,a0,-566 # 4610 <malloc+0x27e>
    384e:	00000097          	auipc	ra,0x0
    3852:	726080e7          	jalr	1830(ra) # 3f74 <exec>
    printf("bigarg test ok\n");
    3856:	00002517          	auipc	a0,0x2
    385a:	7f250513          	addi	a0,a0,2034 # 6048 <malloc+0x1cb6>
    385e:	00001097          	auipc	ra,0x1
    3862:	a76080e7          	jalr	-1418(ra) # 42d4 <printf>
    fd = open("bigarg-ok", O_CREATE);
    3866:	20000593          	li	a1,512
    386a:	00002517          	auipc	a0,0x2
    386e:	6de50513          	addi	a0,a0,1758 # 5f48 <malloc+0x1bb6>
    3872:	00000097          	auipc	ra,0x0
    3876:	70a080e7          	jalr	1802(ra) # 3f7c <open>
    close(fd);
    387a:	00000097          	auipc	ra,0x0
    387e:	6ea080e7          	jalr	1770(ra) # 3f64 <close>
    exit();
    3882:	00000097          	auipc	ra,0x0
    3886:	6ba080e7          	jalr	1722(ra) # 3f3c <exit>
    printf("bigargtest: fork failed\n");
    388a:	00002517          	auipc	a0,0x2
    388e:	7ce50513          	addi	a0,a0,1998 # 6058 <malloc+0x1cc6>
    3892:	00001097          	auipc	ra,0x1
    3896:	a42080e7          	jalr	-1470(ra) # 42d4 <printf>
    exit();
    389a:	00000097          	auipc	ra,0x0
    389e:	6a2080e7          	jalr	1698(ra) # 3f3c <exit>
    printf("bigarg test failed!\n");
    38a2:	00002517          	auipc	a0,0x2
    38a6:	7d650513          	addi	a0,a0,2006 # 6078 <malloc+0x1ce6>
    38aa:	00001097          	auipc	ra,0x1
    38ae:	a2a080e7          	jalr	-1494(ra) # 42d4 <printf>
    exit();
    38b2:	00000097          	auipc	ra,0x0
    38b6:	68a080e7          	jalr	1674(ra) # 3f3c <exit>

00000000000038ba <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    38ba:	7171                	addi	sp,sp,-176
    38bc:	f506                	sd	ra,168(sp)
    38be:	f122                	sd	s0,160(sp)
    38c0:	ed26                	sd	s1,152(sp)
    38c2:	e94a                	sd	s2,144(sp)
    38c4:	e54e                	sd	s3,136(sp)
    38c6:	e152                	sd	s4,128(sp)
    38c8:	fcd6                	sd	s5,120(sp)
    38ca:	f8da                	sd	s6,112(sp)
    38cc:	f4de                	sd	s7,104(sp)
    38ce:	f0e2                	sd	s8,96(sp)
    38d0:	ece6                	sd	s9,88(sp)
    38d2:	e8ea                	sd	s10,80(sp)
    38d4:	e4ee                	sd	s11,72(sp)
    38d6:	1900                	addi	s0,sp,176
  int nfiles;
  int fsblocks = 0;

  printf("fsfull test\n");
    38d8:	00002517          	auipc	a0,0x2
    38dc:	7b850513          	addi	a0,a0,1976 # 6090 <malloc+0x1cfe>
    38e0:	00001097          	auipc	ra,0x1
    38e4:	9f4080e7          	jalr	-1548(ra) # 42d4 <printf>

  for(nfiles = 0; ; nfiles++){
    38e8:	4481                	li	s1,0
    char name[64];
    name[0] = 'f';
    38ea:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    38ee:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    38f2:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    38f6:	4b29                	li	s6,10
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    printf("writing %s\n", name);
    38f8:	00002c97          	auipc	s9,0x2
    38fc:	7a8c8c93          	addi	s9,s9,1960 # 60a0 <malloc+0x1d0e>
    int fd = open(name, O_CREATE|O_RDWR);
    if(fd < 0){
      printf("open %s failed\n", name);
      break;
    }
    int total = 0;
    3900:	4d81                	li	s11,0
    while(1){
      int cc = write(fd, buf, BSIZE);
    3902:	00005a17          	auipc	s4,0x5
    3906:	15ea0a13          	addi	s4,s4,350 # 8a60 <buf>
    name[0] = 'f';
    390a:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    390e:	0384c7bb          	divw	a5,s1,s8
    3912:	0307879b          	addiw	a5,a5,48
    3916:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    391a:	0384e7bb          	remw	a5,s1,s8
    391e:	0377c7bb          	divw	a5,a5,s7
    3922:	0307879b          	addiw	a5,a5,48
    3926:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    392a:	0374e7bb          	remw	a5,s1,s7
    392e:	0367c7bb          	divw	a5,a5,s6
    3932:	0307879b          	addiw	a5,a5,48
    3936:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    393a:	0364e7bb          	remw	a5,s1,s6
    393e:	0307879b          	addiw	a5,a5,48
    3942:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    3946:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    394a:	f5040593          	addi	a1,s0,-176
    394e:	8566                	mv	a0,s9
    3950:	00001097          	auipc	ra,0x1
    3954:	984080e7          	jalr	-1660(ra) # 42d4 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3958:	20200593          	li	a1,514
    395c:	f5040513          	addi	a0,s0,-176
    3960:	00000097          	auipc	ra,0x0
    3964:	61c080e7          	jalr	1564(ra) # 3f7c <open>
    3968:	892a                	mv	s2,a0
    if(fd < 0){
    396a:	0a055663          	bgez	a0,3a16 <fsfull+0x15c>
      printf("open %s failed\n", name);
    396e:	f5040593          	addi	a1,s0,-176
    3972:	00002517          	auipc	a0,0x2
    3976:	73e50513          	addi	a0,a0,1854 # 60b0 <malloc+0x1d1e>
    397a:	00001097          	auipc	ra,0x1
    397e:	95a080e7          	jalr	-1702(ra) # 42d4 <printf>
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3982:	0604c363          	bltz	s1,39e8 <fsfull+0x12e>
    char name[64];
    name[0] = 'f';
    3986:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    398a:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    398e:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    3992:	4929                	li	s2,10
  while(nfiles >= 0){
    3994:	5afd                	li	s5,-1
    name[0] = 'f';
    3996:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    399a:	0344c7bb          	divw	a5,s1,s4
    399e:	0307879b          	addiw	a5,a5,48
    39a2:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    39a6:	0344e7bb          	remw	a5,s1,s4
    39aa:	0337c7bb          	divw	a5,a5,s3
    39ae:	0307879b          	addiw	a5,a5,48
    39b2:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    39b6:	0334e7bb          	remw	a5,s1,s3
    39ba:	0327c7bb          	divw	a5,a5,s2
    39be:	0307879b          	addiw	a5,a5,48
    39c2:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    39c6:	0324e7bb          	remw	a5,s1,s2
    39ca:	0307879b          	addiw	a5,a5,48
    39ce:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    39d2:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    39d6:	f5040513          	addi	a0,s0,-176
    39da:	00000097          	auipc	ra,0x0
    39de:	5b2080e7          	jalr	1458(ra) # 3f8c <unlink>
    nfiles--;
    39e2:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    39e4:	fb5499e3          	bne	s1,s5,3996 <fsfull+0xdc>
  }

  printf("fsfull test finished\n");
    39e8:	00002517          	auipc	a0,0x2
    39ec:	6e850513          	addi	a0,a0,1768 # 60d0 <malloc+0x1d3e>
    39f0:	00001097          	auipc	ra,0x1
    39f4:	8e4080e7          	jalr	-1820(ra) # 42d4 <printf>
}
    39f8:	70aa                	ld	ra,168(sp)
    39fa:	740a                	ld	s0,160(sp)
    39fc:	64ea                	ld	s1,152(sp)
    39fe:	694a                	ld	s2,144(sp)
    3a00:	69aa                	ld	s3,136(sp)
    3a02:	6a0a                	ld	s4,128(sp)
    3a04:	7ae6                	ld	s5,120(sp)
    3a06:	7b46                	ld	s6,112(sp)
    3a08:	7ba6                	ld	s7,104(sp)
    3a0a:	7c06                	ld	s8,96(sp)
    3a0c:	6ce6                	ld	s9,88(sp)
    3a0e:	6d46                	ld	s10,80(sp)
    3a10:	6da6                	ld	s11,72(sp)
    3a12:	614d                	addi	sp,sp,176
    3a14:	8082                	ret
    int total = 0;
    3a16:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    3a18:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    3a1c:	40000613          	li	a2,1024
    3a20:	85d2                	mv	a1,s4
    3a22:	854a                	mv	a0,s2
    3a24:	00000097          	auipc	ra,0x0
    3a28:	538080e7          	jalr	1336(ra) # 3f5c <write>
      if(cc < BSIZE)
    3a2c:	00aad563          	bge	s5,a0,3a36 <fsfull+0x17c>
      total += cc;
    3a30:	00a989bb          	addw	s3,s3,a0
    while(1){
    3a34:	b7e5                	j	3a1c <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    3a36:	85ce                	mv	a1,s3
    3a38:	00002517          	auipc	a0,0x2
    3a3c:	68850513          	addi	a0,a0,1672 # 60c0 <malloc+0x1d2e>
    3a40:	00001097          	auipc	ra,0x1
    3a44:	894080e7          	jalr	-1900(ra) # 42d4 <printf>
    close(fd);
    3a48:	854a                	mv	a0,s2
    3a4a:	00000097          	auipc	ra,0x0
    3a4e:	51a080e7          	jalr	1306(ra) # 3f64 <close>
    if(total == 0)
    3a52:	f20988e3          	beqz	s3,3982 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    3a56:	2485                	addiw	s1,s1,1
    3a58:	bd4d                	j	390a <fsfull+0x50>

0000000000003a5a <argptest>:

void argptest()
{
    3a5a:	1101                	addi	sp,sp,-32
    3a5c:	ec06                	sd	ra,24(sp)
    3a5e:	e822                	sd	s0,16(sp)
    3a60:	e426                	sd	s1,8(sp)
    3a62:	1000                	addi	s0,sp,32
  int fd;
  fd = open("init", O_RDONLY);
    3a64:	4581                	li	a1,0
    3a66:	00002517          	auipc	a0,0x2
    3a6a:	68250513          	addi	a0,a0,1666 # 60e8 <malloc+0x1d56>
    3a6e:	00000097          	auipc	ra,0x0
    3a72:	50e080e7          	jalr	1294(ra) # 3f7c <open>
  if (fd < 0) {
    3a76:	04054263          	bltz	a0,3aba <argptest+0x60>
    3a7a:	84aa                	mv	s1,a0
    fprintf(2, "open failed\n");
    exit();
  }
  read(fd, sbrk(0) - 1, -1);
    3a7c:	4501                	li	a0,0
    3a7e:	00000097          	auipc	ra,0x0
    3a82:	546080e7          	jalr	1350(ra) # 3fc4 <sbrk>
    3a86:	567d                	li	a2,-1
    3a88:	fff50593          	addi	a1,a0,-1
    3a8c:	8526                	mv	a0,s1
    3a8e:	00000097          	auipc	ra,0x0
    3a92:	4c6080e7          	jalr	1222(ra) # 3f54 <read>
  close(fd);
    3a96:	8526                	mv	a0,s1
    3a98:	00000097          	auipc	ra,0x0
    3a9c:	4cc080e7          	jalr	1228(ra) # 3f64 <close>
  printf("arg test passed\n");
    3aa0:	00002517          	auipc	a0,0x2
    3aa4:	66050513          	addi	a0,a0,1632 # 6100 <malloc+0x1d6e>
    3aa8:	00001097          	auipc	ra,0x1
    3aac:	82c080e7          	jalr	-2004(ra) # 42d4 <printf>
}
    3ab0:	60e2                	ld	ra,24(sp)
    3ab2:	6442                	ld	s0,16(sp)
    3ab4:	64a2                	ld	s1,8(sp)
    3ab6:	6105                	addi	sp,sp,32
    3ab8:	8082                	ret
    fprintf(2, "open failed\n");
    3aba:	00002597          	auipc	a1,0x2
    3abe:	63658593          	addi	a1,a1,1590 # 60f0 <malloc+0x1d5e>
    3ac2:	4509                	li	a0,2
    3ac4:	00000097          	auipc	ra,0x0
    3ac8:	7e2080e7          	jalr	2018(ra) # 42a6 <fprintf>
    exit();
    3acc:	00000097          	auipc	ra,0x0
    3ad0:	470080e7          	jalr	1136(ra) # 3f3c <exit>

0000000000003ad4 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3ad4:	1141                	addi	sp,sp,-16
    3ad6:	e422                	sd	s0,8(sp)
    3ad8:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    3ada:	00002717          	auipc	a4,0x2
    3ade:	75e70713          	addi	a4,a4,1886 # 6238 <randstate>
    3ae2:	6308                	ld	a0,0(a4)
    3ae4:	001967b7          	lui	a5,0x196
    3ae8:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x18ab9d>
    3aec:	02f50533          	mul	a0,a0,a5
    3af0:	3c6ef7b7          	lui	a5,0x3c6ef
    3af4:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e38ef>
    3af8:	953e                	add	a0,a0,a5
    3afa:	e308                	sd	a0,0(a4)
  return randstate;
}
    3afc:	2501                	sext.w	a0,a0
    3afe:	6422                	ld	s0,8(sp)
    3b00:	0141                	addi	sp,sp,16
    3b02:	8082                	ret

0000000000003b04 <stacktest>:

// check that there's an invalid page beneath
// the user stack, to catch stack overflow.
void
stacktest()
{
    3b04:	1101                	addi	sp,sp,-32
    3b06:	ec06                	sd	ra,24(sp)
    3b08:	e822                	sd	s0,16(sp)
    3b0a:	e426                	sd	s1,8(sp)
    3b0c:	1000                	addi	s0,sp,32
  int pid;
  int ppid = getpid();
    3b0e:	00000097          	auipc	ra,0x0
    3b12:	4ae080e7          	jalr	1198(ra) # 3fbc <getpid>
    3b16:	84aa                	mv	s1,a0
  
  printf("stack guard test\n");
    3b18:	00002517          	auipc	a0,0x2
    3b1c:	60050513          	addi	a0,a0,1536 # 6118 <malloc+0x1d86>
    3b20:	00000097          	auipc	ra,0x0
    3b24:	7b4080e7          	jalr	1972(ra) # 42d4 <printf>
  pid = fork();
    3b28:	00000097          	auipc	ra,0x0
    3b2c:	40c080e7          	jalr	1036(ra) # 3f34 <fork>
  if(pid == 0) {
    3b30:	c505                	beqz	a0,3b58 <stacktest+0x54>
    // the *sp should cause a trap.
    printf("stacktest: read below stack %p\n", *sp);
    printf("stacktest: test FAILED\n");
    kill(ppid);
    exit();
  } else if(pid < 0){
    3b32:	06054163          	bltz	a0,3b94 <stacktest+0x90>
    printf("fork failed\n");
    exit();
  }
  wait();
    3b36:	00000097          	auipc	ra,0x0
    3b3a:	40e080e7          	jalr	1038(ra) # 3f44 <wait>
  printf("stack guard test ok\n");
    3b3e:	00002517          	auipc	a0,0x2
    3b42:	62a50513          	addi	a0,a0,1578 # 6168 <malloc+0x1dd6>
    3b46:	00000097          	auipc	ra,0x0
    3b4a:	78e080e7          	jalr	1934(ra) # 42d4 <printf>
}
    3b4e:	60e2                	ld	ra,24(sp)
    3b50:	6442                	ld	s0,16(sp)
    3b52:	64a2                	ld	s1,8(sp)
    3b54:	6105                	addi	sp,sp,32
    3b56:	8082                	ret

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    3b58:	870a                	mv	a4,sp
    printf("stacktest: read below stack %p\n", *sp);
    3b5a:	77fd                	lui	a5,0xfffff
    3b5c:	97ba                	add	a5,a5,a4
    3b5e:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff3590>
    3b62:	00002517          	auipc	a0,0x2
    3b66:	5ce50513          	addi	a0,a0,1486 # 6130 <malloc+0x1d9e>
    3b6a:	00000097          	auipc	ra,0x0
    3b6e:	76a080e7          	jalr	1898(ra) # 42d4 <printf>
    printf("stacktest: test FAILED\n");
    3b72:	00002517          	auipc	a0,0x2
    3b76:	5de50513          	addi	a0,a0,1502 # 6150 <malloc+0x1dbe>
    3b7a:	00000097          	auipc	ra,0x0
    3b7e:	75a080e7          	jalr	1882(ra) # 42d4 <printf>
    kill(ppid);
    3b82:	8526                	mv	a0,s1
    3b84:	00000097          	auipc	ra,0x0
    3b88:	3e8080e7          	jalr	1000(ra) # 3f6c <kill>
    exit();
    3b8c:	00000097          	auipc	ra,0x0
    3b90:	3b0080e7          	jalr	944(ra) # 3f3c <exit>
    printf("fork failed\n");
    3b94:	00001517          	auipc	a0,0x1
    3b98:	9ac50513          	addi	a0,a0,-1620 # 4540 <malloc+0x1ae>
    3b9c:	00000097          	auipc	ra,0x0
    3ba0:	738080e7          	jalr	1848(ra) # 42d4 <printf>
    exit();
    3ba4:	00000097          	auipc	ra,0x0
    3ba8:	398080e7          	jalr	920(ra) # 3f3c <exit>

0000000000003bac <main>:

int
main(int argc, char *argv[])
{
    3bac:	1141                	addi	sp,sp,-16
    3bae:	e406                	sd	ra,8(sp)
    3bb0:	e022                	sd	s0,0(sp)
    3bb2:	0800                	addi	s0,sp,16
  printf("usertests starting\n");
    3bb4:	00002517          	auipc	a0,0x2
    3bb8:	5cc50513          	addi	a0,a0,1484 # 6180 <malloc+0x1dee>
    3bbc:	00000097          	auipc	ra,0x0
    3bc0:	718080e7          	jalr	1816(ra) # 42d4 <printf>

  if(open("usertests.ran", 0) >= 0){
    3bc4:	4581                	li	a1,0
    3bc6:	00002517          	auipc	a0,0x2
    3bca:	5d250513          	addi	a0,a0,1490 # 6198 <malloc+0x1e06>
    3bce:	00000097          	auipc	ra,0x0
    3bd2:	3ae080e7          	jalr	942(ra) # 3f7c <open>
    3bd6:	00054e63          	bltz	a0,3bf2 <main+0x46>
    printf("already ran user tests -- rebuild fs.img\n");
    3bda:	00002517          	auipc	a0,0x2
    3bde:	5ce50513          	addi	a0,a0,1486 # 61a8 <malloc+0x1e16>
    3be2:	00000097          	auipc	ra,0x0
    3be6:	6f2080e7          	jalr	1778(ra) # 42d4 <printf>
    exit();
    3bea:	00000097          	auipc	ra,0x0
    3bee:	352080e7          	jalr	850(ra) # 3f3c <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3bf2:	20000593          	li	a1,512
    3bf6:	00002517          	auipc	a0,0x2
    3bfa:	5a250513          	addi	a0,a0,1442 # 6198 <malloc+0x1e06>
    3bfe:	00000097          	auipc	ra,0x0
    3c02:	37e080e7          	jalr	894(ra) # 3f7c <open>
    3c06:	00000097          	auipc	ra,0x0
    3c0a:	35e080e7          	jalr	862(ra) # 3f64 <close>

  reparent();
    3c0e:	ffffd097          	auipc	ra,0xffffd
    3c12:	0a8080e7          	jalr	168(ra) # cb6 <reparent>
  twochildren();
    3c16:	ffffd097          	auipc	ra,0xffffd
    3c1a:	17c080e7          	jalr	380(ra) # d92 <twochildren>
  forkfork();
    3c1e:	ffffd097          	auipc	ra,0xffffd
    3c22:	21c080e7          	jalr	540(ra) # e3a <forkfork>
  forkforkfork();
    3c26:	ffffd097          	auipc	ra,0xffffd
    3c2a:	2ea080e7          	jalr	746(ra) # f10 <forkforkfork>
  
  argptest();
    3c2e:	00000097          	auipc	ra,0x0
    3c32:	e2c080e7          	jalr	-468(ra) # 3a5a <argptest>
  createdelete();
    3c36:	ffffe097          	auipc	ra,0xffffe
    3c3a:	866080e7          	jalr	-1946(ra) # 149c <createdelete>
  linkunlink();
    3c3e:	ffffe097          	auipc	ra,0xffffe
    3c42:	17e080e7          	jalr	382(ra) # 1dbc <linkunlink>
  concreate();
    3c46:	ffffe097          	auipc	ra,0xffffe
    3c4a:	e78080e7          	jalr	-392(ra) # 1abe <concreate>
  fourfiles();
    3c4e:	ffffd097          	auipc	ra,0xffffd
    3c52:	610080e7          	jalr	1552(ra) # 125e <fourfiles>
  sharedfd();
    3c56:	ffffd097          	auipc	ra,0xffffd
    3c5a:	45e080e7          	jalr	1118(ra) # 10b4 <sharedfd>

  bigargtest();
    3c5e:	00000097          	auipc	ra,0x0
    3c62:	b42080e7          	jalr	-1214(ra) # 37a0 <bigargtest>
  bigwrite();
    3c66:	fffff097          	auipc	ra,0xfffff
    3c6a:	b28080e7          	jalr	-1240(ra) # 278e <bigwrite>
  bigargtest();
    3c6e:	00000097          	auipc	ra,0x0
    3c72:	b32080e7          	jalr	-1230(ra) # 37a0 <bigargtest>
  bsstest();
    3c76:	00000097          	auipc	ra,0x0
    3c7a:	ac6080e7          	jalr	-1338(ra) # 373c <bsstest>
  sbrktest();
    3c7e:	fffff097          	auipc	ra,0xfffff
    3c82:	4e0080e7          	jalr	1248(ra) # 315e <sbrktest>
  validatetest();
    3c86:	00000097          	auipc	ra,0x0
    3c8a:	a32080e7          	jalr	-1486(ra) # 36b8 <validatetest>
  stacktest();
    3c8e:	00000097          	auipc	ra,0x0
    3c92:	e76080e7          	jalr	-394(ra) # 3b04 <stacktest>
  
  opentest();
    3c96:	ffffc097          	auipc	ra,0xffffc
    3c9a:	628080e7          	jalr	1576(ra) # 2be <opentest>
  writetest();
    3c9e:	ffffc097          	auipc	ra,0xffffc
    3ca2:	6b4080e7          	jalr	1716(ra) # 352 <writetest>
  writetest1();
    3ca6:	ffffd097          	auipc	ra,0xffffd
    3caa:	880080e7          	jalr	-1920(ra) # 526 <writetest1>
  createtest();
    3cae:	ffffd097          	auipc	ra,0xffffd
    3cb2:	a2c080e7          	jalr	-1492(ra) # 6da <createtest>

  openiputtest();
    3cb6:	ffffc097          	auipc	ra,0xffffc
    3cba:	514080e7          	jalr	1300(ra) # 1ca <openiputtest>
  exitiputtest();
    3cbe:	ffffc097          	auipc	ra,0xffffc
    3cc2:	422080e7          	jalr	1058(ra) # e0 <exitiputtest>
  iputtest();
    3cc6:	ffffc097          	auipc	ra,0xffffc
    3cca:	33a080e7          	jalr	826(ra) # 0 <iputtest>

  mem();
    3cce:	ffffd097          	auipc	ra,0xffffd
    3cd2:	328080e7          	jalr	808(ra) # ff6 <mem>
  pipe1();
    3cd6:	ffffd097          	auipc	ra,0xffffd
    3cda:	bec080e7          	jalr	-1044(ra) # 8c2 <pipe1>
  preempt();
    3cde:	ffffd097          	auipc	ra,0xffffd
    3ce2:	d9a080e7          	jalr	-614(ra) # a78 <preempt>
  exitwait();
    3ce6:	ffffd097          	auipc	ra,0xffffd
    3cea:	f3a080e7          	jalr	-198(ra) # c20 <exitwait>

  rmdot();
    3cee:	fffff097          	auipc	ra,0xfffff
    3cf2:	ec2080e7          	jalr	-318(ra) # 2bb0 <rmdot>
  fourteen();
    3cf6:	fffff097          	auipc	ra,0xfffff
    3cfa:	d74080e7          	jalr	-652(ra) # 2a6a <fourteen>
  bigfile();
    3cfe:	fffff097          	auipc	ra,0xfffff
    3d02:	b8e080e7          	jalr	-1138(ra) # 288c <bigfile>
  subdir();
    3d06:	ffffe097          	auipc	ra,0xffffe
    3d0a:	33c080e7          	jalr	828(ra) # 2042 <subdir>
  linktest();
    3d0e:	ffffe097          	auipc	ra,0xffffe
    3d12:	b6e080e7          	jalr	-1170(ra) # 187c <linktest>
  unlinkread();
    3d16:	ffffe097          	auipc	ra,0xffffe
    3d1a:	9ae080e7          	jalr	-1618(ra) # 16c4 <unlinkread>
  dirfile();
    3d1e:	fffff097          	auipc	ra,0xfffff
    3d22:	012080e7          	jalr	18(ra) # 2d30 <dirfile>
  iref();
    3d26:	fffff097          	auipc	ra,0xfffff
    3d2a:	232080e7          	jalr	562(ra) # 2f58 <iref>
  forktest();
    3d2e:	fffff097          	auipc	ra,0xfffff
    3d32:	34a080e7          	jalr	842(ra) # 3078 <forktest>
  bigdir(); // slow
    3d36:	ffffe097          	auipc	ra,0xffffe
    3d3a:	19e080e7          	jalr	414(ra) # 1ed4 <bigdir>

  exectest();
    3d3e:	ffffd097          	auipc	ra,0xffffd
    3d42:	b30080e7          	jalr	-1232(ra) # 86e <exectest>

  exit();
    3d46:	00000097          	auipc	ra,0x0
    3d4a:	1f6080e7          	jalr	502(ra) # 3f3c <exit>

0000000000003d4e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    3d4e:	1141                	addi	sp,sp,-16
    3d50:	e422                	sd	s0,8(sp)
    3d52:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    3d54:	87aa                	mv	a5,a0
    3d56:	0585                	addi	a1,a1,1
    3d58:	0785                	addi	a5,a5,1
    3d5a:	fff5c703          	lbu	a4,-1(a1)
    3d5e:	fee78fa3          	sb	a4,-1(a5)
    3d62:	fb75                	bnez	a4,3d56 <strcpy+0x8>
    ;
  return os;
}
    3d64:	6422                	ld	s0,8(sp)
    3d66:	0141                	addi	sp,sp,16
    3d68:	8082                	ret

0000000000003d6a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3d6a:	1141                	addi	sp,sp,-16
    3d6c:	e422                	sd	s0,8(sp)
    3d6e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    3d70:	00054783          	lbu	a5,0(a0)
    3d74:	cb91                	beqz	a5,3d88 <strcmp+0x1e>
    3d76:	0005c703          	lbu	a4,0(a1)
    3d7a:	00f71763          	bne	a4,a5,3d88 <strcmp+0x1e>
    p++, q++;
    3d7e:	0505                	addi	a0,a0,1
    3d80:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    3d82:	00054783          	lbu	a5,0(a0)
    3d86:	fbe5                	bnez	a5,3d76 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    3d88:	0005c503          	lbu	a0,0(a1)
}
    3d8c:	40a7853b          	subw	a0,a5,a0
    3d90:	6422                	ld	s0,8(sp)
    3d92:	0141                	addi	sp,sp,16
    3d94:	8082                	ret

0000000000003d96 <strlen>:

uint
strlen(const char *s)
{
    3d96:	1141                	addi	sp,sp,-16
    3d98:	e422                	sd	s0,8(sp)
    3d9a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    3d9c:	00054783          	lbu	a5,0(a0)
    3da0:	cf91                	beqz	a5,3dbc <strlen+0x26>
    3da2:	0505                	addi	a0,a0,1
    3da4:	87aa                	mv	a5,a0
    3da6:	4685                	li	a3,1
    3da8:	9e89                	subw	a3,a3,a0
    3daa:	00f6853b          	addw	a0,a3,a5
    3dae:	0785                	addi	a5,a5,1
    3db0:	fff7c703          	lbu	a4,-1(a5)
    3db4:	fb7d                	bnez	a4,3daa <strlen+0x14>
    ;
  return n;
}
    3db6:	6422                	ld	s0,8(sp)
    3db8:	0141                	addi	sp,sp,16
    3dba:	8082                	ret
  for(n = 0; s[n]; n++)
    3dbc:	4501                	li	a0,0
    3dbe:	bfe5                	j	3db6 <strlen+0x20>

0000000000003dc0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3dc0:	1141                	addi	sp,sp,-16
    3dc2:	e422                	sd	s0,8(sp)
    3dc4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    3dc6:	ca19                	beqz	a2,3ddc <memset+0x1c>
    3dc8:	87aa                	mv	a5,a0
    3dca:	1602                	slli	a2,a2,0x20
    3dcc:	9201                	srli	a2,a2,0x20
    3dce:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    3dd2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    3dd6:	0785                	addi	a5,a5,1
    3dd8:	fee79de3          	bne	a5,a4,3dd2 <memset+0x12>
  }
  return dst;
}
    3ddc:	6422                	ld	s0,8(sp)
    3dde:	0141                	addi	sp,sp,16
    3de0:	8082                	ret

0000000000003de2 <strchr>:

char*
strchr(const char *s, char c)
{
    3de2:	1141                	addi	sp,sp,-16
    3de4:	e422                	sd	s0,8(sp)
    3de6:	0800                	addi	s0,sp,16
  for(; *s; s++)
    3de8:	00054783          	lbu	a5,0(a0)
    3dec:	cb99                	beqz	a5,3e02 <strchr+0x20>
    if(*s == c)
    3dee:	00f58763          	beq	a1,a5,3dfc <strchr+0x1a>
  for(; *s; s++)
    3df2:	0505                	addi	a0,a0,1
    3df4:	00054783          	lbu	a5,0(a0)
    3df8:	fbfd                	bnez	a5,3dee <strchr+0xc>
      return (char*)s;
  return 0;
    3dfa:	4501                	li	a0,0
}
    3dfc:	6422                	ld	s0,8(sp)
    3dfe:	0141                	addi	sp,sp,16
    3e00:	8082                	ret
  return 0;
    3e02:	4501                	li	a0,0
    3e04:	bfe5                	j	3dfc <strchr+0x1a>

0000000000003e06 <gets>:

char*
gets(char *buf, int max)
{
    3e06:	711d                	addi	sp,sp,-96
    3e08:	ec86                	sd	ra,88(sp)
    3e0a:	e8a2                	sd	s0,80(sp)
    3e0c:	e4a6                	sd	s1,72(sp)
    3e0e:	e0ca                	sd	s2,64(sp)
    3e10:	fc4e                	sd	s3,56(sp)
    3e12:	f852                	sd	s4,48(sp)
    3e14:	f456                	sd	s5,40(sp)
    3e16:	f05a                	sd	s6,32(sp)
    3e18:	ec5e                	sd	s7,24(sp)
    3e1a:	1080                	addi	s0,sp,96
    3e1c:	8baa                	mv	s7,a0
    3e1e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3e20:	892a                	mv	s2,a0
    3e22:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    3e24:	4aa9                	li	s5,10
    3e26:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    3e28:	89a6                	mv	s3,s1
    3e2a:	2485                	addiw	s1,s1,1
    3e2c:	0344d863          	bge	s1,s4,3e5c <gets+0x56>
    cc = read(0, &c, 1);
    3e30:	4605                	li	a2,1
    3e32:	faf40593          	addi	a1,s0,-81
    3e36:	4501                	li	a0,0
    3e38:	00000097          	auipc	ra,0x0
    3e3c:	11c080e7          	jalr	284(ra) # 3f54 <read>
    if(cc < 1)
    3e40:	00a05e63          	blez	a0,3e5c <gets+0x56>
    buf[i++] = c;
    3e44:	faf44783          	lbu	a5,-81(s0)
    3e48:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    3e4c:	01578763          	beq	a5,s5,3e5a <gets+0x54>
    3e50:	0905                	addi	s2,s2,1
    3e52:	fd679be3          	bne	a5,s6,3e28 <gets+0x22>
  for(i=0; i+1 < max; ){
    3e56:	89a6                	mv	s3,s1
    3e58:	a011                	j	3e5c <gets+0x56>
    3e5a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    3e5c:	99de                	add	s3,s3,s7
    3e5e:	00098023          	sb	zero,0(s3)
  return buf;
}
    3e62:	855e                	mv	a0,s7
    3e64:	60e6                	ld	ra,88(sp)
    3e66:	6446                	ld	s0,80(sp)
    3e68:	64a6                	ld	s1,72(sp)
    3e6a:	6906                	ld	s2,64(sp)
    3e6c:	79e2                	ld	s3,56(sp)
    3e6e:	7a42                	ld	s4,48(sp)
    3e70:	7aa2                	ld	s5,40(sp)
    3e72:	7b02                	ld	s6,32(sp)
    3e74:	6be2                	ld	s7,24(sp)
    3e76:	6125                	addi	sp,sp,96
    3e78:	8082                	ret

0000000000003e7a <stat>:

int
stat(const char *n, struct stat *st)
{
    3e7a:	1101                	addi	sp,sp,-32
    3e7c:	ec06                	sd	ra,24(sp)
    3e7e:	e822                	sd	s0,16(sp)
    3e80:	e426                	sd	s1,8(sp)
    3e82:	e04a                	sd	s2,0(sp)
    3e84:	1000                	addi	s0,sp,32
    3e86:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3e88:	4581                	li	a1,0
    3e8a:	00000097          	auipc	ra,0x0
    3e8e:	0f2080e7          	jalr	242(ra) # 3f7c <open>
  if(fd < 0)
    3e92:	02054563          	bltz	a0,3ebc <stat+0x42>
    3e96:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    3e98:	85ca                	mv	a1,s2
    3e9a:	00000097          	auipc	ra,0x0
    3e9e:	0fa080e7          	jalr	250(ra) # 3f94 <fstat>
    3ea2:	892a                	mv	s2,a0
  close(fd);
    3ea4:	8526                	mv	a0,s1
    3ea6:	00000097          	auipc	ra,0x0
    3eaa:	0be080e7          	jalr	190(ra) # 3f64 <close>
  return r;
}
    3eae:	854a                	mv	a0,s2
    3eb0:	60e2                	ld	ra,24(sp)
    3eb2:	6442                	ld	s0,16(sp)
    3eb4:	64a2                	ld	s1,8(sp)
    3eb6:	6902                	ld	s2,0(sp)
    3eb8:	6105                	addi	sp,sp,32
    3eba:	8082                	ret
    return -1;
    3ebc:	597d                	li	s2,-1
    3ebe:	bfc5                	j	3eae <stat+0x34>

0000000000003ec0 <atoi>:

int
atoi(const char *s)
{
    3ec0:	1141                	addi	sp,sp,-16
    3ec2:	e422                	sd	s0,8(sp)
    3ec4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3ec6:	00054603          	lbu	a2,0(a0)
    3eca:	fd06079b          	addiw	a5,a2,-48
    3ece:	0ff7f793          	andi	a5,a5,255
    3ed2:	4725                	li	a4,9
    3ed4:	02f76963          	bltu	a4,a5,3f06 <atoi+0x46>
    3ed8:	86aa                	mv	a3,a0
  n = 0;
    3eda:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    3edc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    3ede:	0685                	addi	a3,a3,1
    3ee0:	0025179b          	slliw	a5,a0,0x2
    3ee4:	9fa9                	addw	a5,a5,a0
    3ee6:	0017979b          	slliw	a5,a5,0x1
    3eea:	9fb1                	addw	a5,a5,a2
    3eec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    3ef0:	0006c603          	lbu	a2,0(a3)
    3ef4:	fd06071b          	addiw	a4,a2,-48
    3ef8:	0ff77713          	andi	a4,a4,255
    3efc:	fee5f1e3          	bgeu	a1,a4,3ede <atoi+0x1e>
  return n;
}
    3f00:	6422                	ld	s0,8(sp)
    3f02:	0141                	addi	sp,sp,16
    3f04:	8082                	ret
  n = 0;
    3f06:	4501                	li	a0,0
    3f08:	bfe5                	j	3f00 <atoi+0x40>

0000000000003f0a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    3f0a:	1141                	addi	sp,sp,-16
    3f0c:	e422                	sd	s0,8(sp)
    3f0e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3f10:	00c05f63          	blez	a2,3f2e <memmove+0x24>
    3f14:	1602                	slli	a2,a2,0x20
    3f16:	9201                	srli	a2,a2,0x20
    3f18:	00c506b3          	add	a3,a0,a2
  dst = vdst;
    3f1c:	87aa                	mv	a5,a0
    *dst++ = *src++;
    3f1e:	0585                	addi	a1,a1,1
    3f20:	0785                	addi	a5,a5,1
    3f22:	fff5c703          	lbu	a4,-1(a1)
    3f26:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
    3f2a:	fed79ae3          	bne	a5,a3,3f1e <memmove+0x14>
  return vdst;
}
    3f2e:	6422                	ld	s0,8(sp)
    3f30:	0141                	addi	sp,sp,16
    3f32:	8082                	ret

0000000000003f34 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    3f34:	4885                	li	a7,1
 ecall
    3f36:	00000073          	ecall
 ret
    3f3a:	8082                	ret

0000000000003f3c <exit>:
.global exit
exit:
 li a7, SYS_exit
    3f3c:	4889                	li	a7,2
 ecall
    3f3e:	00000073          	ecall
 ret
    3f42:	8082                	ret

0000000000003f44 <wait>:
.global wait
wait:
 li a7, SYS_wait
    3f44:	488d                	li	a7,3
 ecall
    3f46:	00000073          	ecall
 ret
    3f4a:	8082                	ret

0000000000003f4c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    3f4c:	4891                	li	a7,4
 ecall
    3f4e:	00000073          	ecall
 ret
    3f52:	8082                	ret

0000000000003f54 <read>:
.global read
read:
 li a7, SYS_read
    3f54:	4895                	li	a7,5
 ecall
    3f56:	00000073          	ecall
 ret
    3f5a:	8082                	ret

0000000000003f5c <write>:
.global write
write:
 li a7, SYS_write
    3f5c:	48c1                	li	a7,16
 ecall
    3f5e:	00000073          	ecall
 ret
    3f62:	8082                	ret

0000000000003f64 <close>:
.global close
close:
 li a7, SYS_close
    3f64:	48d5                	li	a7,21
 ecall
    3f66:	00000073          	ecall
 ret
    3f6a:	8082                	ret

0000000000003f6c <kill>:
.global kill
kill:
 li a7, SYS_kill
    3f6c:	4899                	li	a7,6
 ecall
    3f6e:	00000073          	ecall
 ret
    3f72:	8082                	ret

0000000000003f74 <exec>:
.global exec
exec:
 li a7, SYS_exec
    3f74:	489d                	li	a7,7
 ecall
    3f76:	00000073          	ecall
 ret
    3f7a:	8082                	ret

0000000000003f7c <open>:
.global open
open:
 li a7, SYS_open
    3f7c:	48bd                	li	a7,15
 ecall
    3f7e:	00000073          	ecall
 ret
    3f82:	8082                	ret

0000000000003f84 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    3f84:	48c5                	li	a7,17
 ecall
    3f86:	00000073          	ecall
 ret
    3f8a:	8082                	ret

0000000000003f8c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    3f8c:	48c9                	li	a7,18
 ecall
    3f8e:	00000073          	ecall
 ret
    3f92:	8082                	ret

0000000000003f94 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    3f94:	48a1                	li	a7,8
 ecall
    3f96:	00000073          	ecall
 ret
    3f9a:	8082                	ret

0000000000003f9c <link>:
.global link
link:
 li a7, SYS_link
    3f9c:	48cd                	li	a7,19
 ecall
    3f9e:	00000073          	ecall
 ret
    3fa2:	8082                	ret

0000000000003fa4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    3fa4:	48d1                	li	a7,20
 ecall
    3fa6:	00000073          	ecall
 ret
    3faa:	8082                	ret

0000000000003fac <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    3fac:	48a5                	li	a7,9
 ecall
    3fae:	00000073          	ecall
 ret
    3fb2:	8082                	ret

0000000000003fb4 <dup>:
.global dup
dup:
 li a7, SYS_dup
    3fb4:	48a9                	li	a7,10
 ecall
    3fb6:	00000073          	ecall
 ret
    3fba:	8082                	ret

0000000000003fbc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    3fbc:	48ad                	li	a7,11
 ecall
    3fbe:	00000073          	ecall
 ret
    3fc2:	8082                	ret

0000000000003fc4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    3fc4:	48b1                	li	a7,12
 ecall
    3fc6:	00000073          	ecall
 ret
    3fca:	8082                	ret

0000000000003fcc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    3fcc:	48b5                	li	a7,13
 ecall
    3fce:	00000073          	ecall
 ret
    3fd2:	8082                	ret

0000000000003fd4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    3fd4:	48b9                	li	a7,14
 ecall
    3fd6:	00000073          	ecall
 ret
    3fda:	8082                	ret

0000000000003fdc <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
    3fdc:	48d9                	li	a7,22
 ecall
    3fde:	00000073          	ecall
 ret
    3fe2:	8082                	ret

0000000000003fe4 <crash>:
.global crash
crash:
 li a7, SYS_crash
    3fe4:	48dd                	li	a7,23
 ecall
    3fe6:	00000073          	ecall
 ret
    3fea:	8082                	ret

0000000000003fec <mount>:
.global mount
mount:
 li a7, SYS_mount
    3fec:	48e1                	li	a7,24
 ecall
    3fee:	00000073          	ecall
 ret
    3ff2:	8082                	ret

0000000000003ff4 <umount>:
.global umount
umount:
 li a7, SYS_umount
    3ff4:	48e5                	li	a7,25
 ecall
    3ff6:	00000073          	ecall
 ret
    3ffa:	8082                	ret

0000000000003ffc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    3ffc:	1101                	addi	sp,sp,-32
    3ffe:	ec06                	sd	ra,24(sp)
    4000:	e822                	sd	s0,16(sp)
    4002:	1000                	addi	s0,sp,32
    4004:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4008:	4605                	li	a2,1
    400a:	fef40593          	addi	a1,s0,-17
    400e:	00000097          	auipc	ra,0x0
    4012:	f4e080e7          	jalr	-178(ra) # 3f5c <write>
}
    4016:	60e2                	ld	ra,24(sp)
    4018:	6442                	ld	s0,16(sp)
    401a:	6105                	addi	sp,sp,32
    401c:	8082                	ret

000000000000401e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    401e:	7139                	addi	sp,sp,-64
    4020:	fc06                	sd	ra,56(sp)
    4022:	f822                	sd	s0,48(sp)
    4024:	f426                	sd	s1,40(sp)
    4026:	f04a                	sd	s2,32(sp)
    4028:	ec4e                	sd	s3,24(sp)
    402a:	0080                	addi	s0,sp,64
    402c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    402e:	c299                	beqz	a3,4034 <printint+0x16>
    4030:	0805c863          	bltz	a1,40c0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4034:	2581                	sext.w	a1,a1
  neg = 0;
    4036:	4881                	li	a7,0
    4038:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    403c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    403e:	2601                	sext.w	a2,a2
    4040:	00002517          	auipc	a0,0x2
    4044:	1b850513          	addi	a0,a0,440 # 61f8 <digits>
    4048:	883a                	mv	a6,a4
    404a:	2705                	addiw	a4,a4,1
    404c:	02c5f7bb          	remuw	a5,a1,a2
    4050:	1782                	slli	a5,a5,0x20
    4052:	9381                	srli	a5,a5,0x20
    4054:	97aa                	add	a5,a5,a0
    4056:	0007c783          	lbu	a5,0(a5)
    405a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    405e:	0005879b          	sext.w	a5,a1
    4062:	02c5d5bb          	divuw	a1,a1,a2
    4066:	0685                	addi	a3,a3,1
    4068:	fec7f0e3          	bgeu	a5,a2,4048 <printint+0x2a>
  if(neg)
    406c:	00088b63          	beqz	a7,4082 <printint+0x64>
    buf[i++] = '-';
    4070:	fd040793          	addi	a5,s0,-48
    4074:	973e                	add	a4,a4,a5
    4076:	02d00793          	li	a5,45
    407a:	fef70823          	sb	a5,-16(a4)
    407e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    4082:	02e05863          	blez	a4,40b2 <printint+0x94>
    4086:	fc040793          	addi	a5,s0,-64
    408a:	00e78933          	add	s2,a5,a4
    408e:	fff78993          	addi	s3,a5,-1
    4092:	99ba                	add	s3,s3,a4
    4094:	377d                	addiw	a4,a4,-1
    4096:	1702                	slli	a4,a4,0x20
    4098:	9301                	srli	a4,a4,0x20
    409a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    409e:	fff94583          	lbu	a1,-1(s2)
    40a2:	8526                	mv	a0,s1
    40a4:	00000097          	auipc	ra,0x0
    40a8:	f58080e7          	jalr	-168(ra) # 3ffc <putc>
  while(--i >= 0)
    40ac:	197d                	addi	s2,s2,-1
    40ae:	ff3918e3          	bne	s2,s3,409e <printint+0x80>
}
    40b2:	70e2                	ld	ra,56(sp)
    40b4:	7442                	ld	s0,48(sp)
    40b6:	74a2                	ld	s1,40(sp)
    40b8:	7902                	ld	s2,32(sp)
    40ba:	69e2                	ld	s3,24(sp)
    40bc:	6121                	addi	sp,sp,64
    40be:	8082                	ret
    x = -xx;
    40c0:	40b005bb          	negw	a1,a1
    neg = 1;
    40c4:	4885                	li	a7,1
    x = -xx;
    40c6:	bf8d                	j	4038 <printint+0x1a>

00000000000040c8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    40c8:	7119                	addi	sp,sp,-128
    40ca:	fc86                	sd	ra,120(sp)
    40cc:	f8a2                	sd	s0,112(sp)
    40ce:	f4a6                	sd	s1,104(sp)
    40d0:	f0ca                	sd	s2,96(sp)
    40d2:	ecce                	sd	s3,88(sp)
    40d4:	e8d2                	sd	s4,80(sp)
    40d6:	e4d6                	sd	s5,72(sp)
    40d8:	e0da                	sd	s6,64(sp)
    40da:	fc5e                	sd	s7,56(sp)
    40dc:	f862                	sd	s8,48(sp)
    40de:	f466                	sd	s9,40(sp)
    40e0:	f06a                	sd	s10,32(sp)
    40e2:	ec6e                	sd	s11,24(sp)
    40e4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    40e6:	0005c903          	lbu	s2,0(a1)
    40ea:	18090f63          	beqz	s2,4288 <vprintf+0x1c0>
    40ee:	8aaa                	mv	s5,a0
    40f0:	8b32                	mv	s6,a2
    40f2:	00158493          	addi	s1,a1,1
  state = 0;
    40f6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    40f8:	02500a13          	li	s4,37
      if(c == 'd'){
    40fc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    4100:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    4104:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    4108:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    410c:	00002b97          	auipc	s7,0x2
    4110:	0ecb8b93          	addi	s7,s7,236 # 61f8 <digits>
    4114:	a839                	j	4132 <vprintf+0x6a>
        putc(fd, c);
    4116:	85ca                	mv	a1,s2
    4118:	8556                	mv	a0,s5
    411a:	00000097          	auipc	ra,0x0
    411e:	ee2080e7          	jalr	-286(ra) # 3ffc <putc>
    4122:	a019                	j	4128 <vprintf+0x60>
    } else if(state == '%'){
    4124:	01498f63          	beq	s3,s4,4142 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    4128:	0485                	addi	s1,s1,1
    412a:	fff4c903          	lbu	s2,-1(s1)
    412e:	14090d63          	beqz	s2,4288 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    4132:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4136:	fe0997e3          	bnez	s3,4124 <vprintf+0x5c>
      if(c == '%'){
    413a:	fd479ee3          	bne	a5,s4,4116 <vprintf+0x4e>
        state = '%';
    413e:	89be                	mv	s3,a5
    4140:	b7e5                	j	4128 <vprintf+0x60>
      if(c == 'd'){
    4142:	05878063          	beq	a5,s8,4182 <vprintf+0xba>
      } else if(c == 'l') {
    4146:	05978c63          	beq	a5,s9,419e <vprintf+0xd6>
      } else if(c == 'x') {
    414a:	07a78863          	beq	a5,s10,41ba <vprintf+0xf2>
      } else if(c == 'p') {
    414e:	09b78463          	beq	a5,s11,41d6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    4152:	07300713          	li	a4,115
    4156:	0ce78663          	beq	a5,a4,4222 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    415a:	06300713          	li	a4,99
    415e:	0ee78e63          	beq	a5,a4,425a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    4162:	11478863          	beq	a5,s4,4272 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    4166:	85d2                	mv	a1,s4
    4168:	8556                	mv	a0,s5
    416a:	00000097          	auipc	ra,0x0
    416e:	e92080e7          	jalr	-366(ra) # 3ffc <putc>
        putc(fd, c);
    4172:	85ca                	mv	a1,s2
    4174:	8556                	mv	a0,s5
    4176:	00000097          	auipc	ra,0x0
    417a:	e86080e7          	jalr	-378(ra) # 3ffc <putc>
      }
      state = 0;
    417e:	4981                	li	s3,0
    4180:	b765                	j	4128 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    4182:	008b0913          	addi	s2,s6,8
    4186:	4685                	li	a3,1
    4188:	4629                	li	a2,10
    418a:	000b2583          	lw	a1,0(s6)
    418e:	8556                	mv	a0,s5
    4190:	00000097          	auipc	ra,0x0
    4194:	e8e080e7          	jalr	-370(ra) # 401e <printint>
    4198:	8b4a                	mv	s6,s2
      state = 0;
    419a:	4981                	li	s3,0
    419c:	b771                	j	4128 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    419e:	008b0913          	addi	s2,s6,8
    41a2:	4681                	li	a3,0
    41a4:	4629                	li	a2,10
    41a6:	000b2583          	lw	a1,0(s6)
    41aa:	8556                	mv	a0,s5
    41ac:	00000097          	auipc	ra,0x0
    41b0:	e72080e7          	jalr	-398(ra) # 401e <printint>
    41b4:	8b4a                	mv	s6,s2
      state = 0;
    41b6:	4981                	li	s3,0
    41b8:	bf85                	j	4128 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    41ba:	008b0913          	addi	s2,s6,8
    41be:	4681                	li	a3,0
    41c0:	4641                	li	a2,16
    41c2:	000b2583          	lw	a1,0(s6)
    41c6:	8556                	mv	a0,s5
    41c8:	00000097          	auipc	ra,0x0
    41cc:	e56080e7          	jalr	-426(ra) # 401e <printint>
    41d0:	8b4a                	mv	s6,s2
      state = 0;
    41d2:	4981                	li	s3,0
    41d4:	bf91                	j	4128 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    41d6:	008b0793          	addi	a5,s6,8
    41da:	f8f43423          	sd	a5,-120(s0)
    41de:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    41e2:	03000593          	li	a1,48
    41e6:	8556                	mv	a0,s5
    41e8:	00000097          	auipc	ra,0x0
    41ec:	e14080e7          	jalr	-492(ra) # 3ffc <putc>
  putc(fd, 'x');
    41f0:	85ea                	mv	a1,s10
    41f2:	8556                	mv	a0,s5
    41f4:	00000097          	auipc	ra,0x0
    41f8:	e08080e7          	jalr	-504(ra) # 3ffc <putc>
    41fc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    41fe:	03c9d793          	srli	a5,s3,0x3c
    4202:	97de                	add	a5,a5,s7
    4204:	0007c583          	lbu	a1,0(a5)
    4208:	8556                	mv	a0,s5
    420a:	00000097          	auipc	ra,0x0
    420e:	df2080e7          	jalr	-526(ra) # 3ffc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    4212:	0992                	slli	s3,s3,0x4
    4214:	397d                	addiw	s2,s2,-1
    4216:	fe0914e3          	bnez	s2,41fe <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    421a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    421e:	4981                	li	s3,0
    4220:	b721                	j	4128 <vprintf+0x60>
        s = va_arg(ap, char*);
    4222:	008b0993          	addi	s3,s6,8
    4226:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    422a:	02090163          	beqz	s2,424c <vprintf+0x184>
        while(*s != 0){
    422e:	00094583          	lbu	a1,0(s2)
    4232:	c9a1                	beqz	a1,4282 <vprintf+0x1ba>
          putc(fd, *s);
    4234:	8556                	mv	a0,s5
    4236:	00000097          	auipc	ra,0x0
    423a:	dc6080e7          	jalr	-570(ra) # 3ffc <putc>
          s++;
    423e:	0905                	addi	s2,s2,1
        while(*s != 0){
    4240:	00094583          	lbu	a1,0(s2)
    4244:	f9e5                	bnez	a1,4234 <vprintf+0x16c>
        s = va_arg(ap, char*);
    4246:	8b4e                	mv	s6,s3
      state = 0;
    4248:	4981                	li	s3,0
    424a:	bdf9                	j	4128 <vprintf+0x60>
          s = "(null)";
    424c:	00002917          	auipc	s2,0x2
    4250:	fa490913          	addi	s2,s2,-92 # 61f0 <malloc+0x1e5e>
        while(*s != 0){
    4254:	02800593          	li	a1,40
    4258:	bff1                	j	4234 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    425a:	008b0913          	addi	s2,s6,8
    425e:	000b4583          	lbu	a1,0(s6)
    4262:	8556                	mv	a0,s5
    4264:	00000097          	auipc	ra,0x0
    4268:	d98080e7          	jalr	-616(ra) # 3ffc <putc>
    426c:	8b4a                	mv	s6,s2
      state = 0;
    426e:	4981                	li	s3,0
    4270:	bd65                	j	4128 <vprintf+0x60>
        putc(fd, c);
    4272:	85d2                	mv	a1,s4
    4274:	8556                	mv	a0,s5
    4276:	00000097          	auipc	ra,0x0
    427a:	d86080e7          	jalr	-634(ra) # 3ffc <putc>
      state = 0;
    427e:	4981                	li	s3,0
    4280:	b565                	j	4128 <vprintf+0x60>
        s = va_arg(ap, char*);
    4282:	8b4e                	mv	s6,s3
      state = 0;
    4284:	4981                	li	s3,0
    4286:	b54d                	j	4128 <vprintf+0x60>
    }
  }
}
    4288:	70e6                	ld	ra,120(sp)
    428a:	7446                	ld	s0,112(sp)
    428c:	74a6                	ld	s1,104(sp)
    428e:	7906                	ld	s2,96(sp)
    4290:	69e6                	ld	s3,88(sp)
    4292:	6a46                	ld	s4,80(sp)
    4294:	6aa6                	ld	s5,72(sp)
    4296:	6b06                	ld	s6,64(sp)
    4298:	7be2                	ld	s7,56(sp)
    429a:	7c42                	ld	s8,48(sp)
    429c:	7ca2                	ld	s9,40(sp)
    429e:	7d02                	ld	s10,32(sp)
    42a0:	6de2                	ld	s11,24(sp)
    42a2:	6109                	addi	sp,sp,128
    42a4:	8082                	ret

00000000000042a6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    42a6:	715d                	addi	sp,sp,-80
    42a8:	ec06                	sd	ra,24(sp)
    42aa:	e822                	sd	s0,16(sp)
    42ac:	1000                	addi	s0,sp,32
    42ae:	e010                	sd	a2,0(s0)
    42b0:	e414                	sd	a3,8(s0)
    42b2:	e818                	sd	a4,16(s0)
    42b4:	ec1c                	sd	a5,24(s0)
    42b6:	03043023          	sd	a6,32(s0)
    42ba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    42be:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    42c2:	8622                	mv	a2,s0
    42c4:	00000097          	auipc	ra,0x0
    42c8:	e04080e7          	jalr	-508(ra) # 40c8 <vprintf>
}
    42cc:	60e2                	ld	ra,24(sp)
    42ce:	6442                	ld	s0,16(sp)
    42d0:	6161                	addi	sp,sp,80
    42d2:	8082                	ret

00000000000042d4 <printf>:

void
printf(const char *fmt, ...)
{
    42d4:	711d                	addi	sp,sp,-96
    42d6:	ec06                	sd	ra,24(sp)
    42d8:	e822                	sd	s0,16(sp)
    42da:	1000                	addi	s0,sp,32
    42dc:	e40c                	sd	a1,8(s0)
    42de:	e810                	sd	a2,16(s0)
    42e0:	ec14                	sd	a3,24(s0)
    42e2:	f018                	sd	a4,32(s0)
    42e4:	f41c                	sd	a5,40(s0)
    42e6:	03043823          	sd	a6,48(s0)
    42ea:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    42ee:	00840613          	addi	a2,s0,8
    42f2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    42f6:	85aa                	mv	a1,a0
    42f8:	4505                	li	a0,1
    42fa:	00000097          	auipc	ra,0x0
    42fe:	dce080e7          	jalr	-562(ra) # 40c8 <vprintf>
}
    4302:	60e2                	ld	ra,24(sp)
    4304:	6442                	ld	s0,16(sp)
    4306:	6125                	addi	sp,sp,96
    4308:	8082                	ret

000000000000430a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    430a:	1141                	addi	sp,sp,-16
    430c:	e422                	sd	s0,8(sp)
    430e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4310:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4314:	00002797          	auipc	a5,0x2
    4318:	f347b783          	ld	a5,-204(a5) # 6248 <freep>
    431c:	a805                	j	434c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    431e:	4618                	lw	a4,8(a2)
    4320:	9db9                	addw	a1,a1,a4
    4322:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    4326:	6398                	ld	a4,0(a5)
    4328:	6318                	ld	a4,0(a4)
    432a:	fee53823          	sd	a4,-16(a0)
    432e:	a091                	j	4372 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    4330:	ff852703          	lw	a4,-8(a0)
    4334:	9e39                	addw	a2,a2,a4
    4336:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    4338:	ff053703          	ld	a4,-16(a0)
    433c:	e398                	sd	a4,0(a5)
    433e:	a099                	j	4384 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4340:	6398                	ld	a4,0(a5)
    4342:	00e7e463          	bltu	a5,a4,434a <free+0x40>
    4346:	00e6ea63          	bltu	a3,a4,435a <free+0x50>
{
    434a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    434c:	fed7fae3          	bgeu	a5,a3,4340 <free+0x36>
    4350:	6398                	ld	a4,0(a5)
    4352:	00e6e463          	bltu	a3,a4,435a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4356:	fee7eae3          	bltu	a5,a4,434a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    435a:	ff852583          	lw	a1,-8(a0)
    435e:	6390                	ld	a2,0(a5)
    4360:	02059813          	slli	a6,a1,0x20
    4364:	01c85713          	srli	a4,a6,0x1c
    4368:	9736                	add	a4,a4,a3
    436a:	fae60ae3          	beq	a2,a4,431e <free+0x14>
    bp->s.ptr = p->s.ptr;
    436e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    4372:	4790                	lw	a2,8(a5)
    4374:	02061593          	slli	a1,a2,0x20
    4378:	01c5d713          	srli	a4,a1,0x1c
    437c:	973e                	add	a4,a4,a5
    437e:	fae689e3          	beq	a3,a4,4330 <free+0x26>
  } else
    p->s.ptr = bp;
    4382:	e394                	sd	a3,0(a5)
  freep = p;
    4384:	00002717          	auipc	a4,0x2
    4388:	ecf73223          	sd	a5,-316(a4) # 6248 <freep>
}
    438c:	6422                	ld	s0,8(sp)
    438e:	0141                	addi	sp,sp,16
    4390:	8082                	ret

0000000000004392 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    4392:	7139                	addi	sp,sp,-64
    4394:	fc06                	sd	ra,56(sp)
    4396:	f822                	sd	s0,48(sp)
    4398:	f426                	sd	s1,40(sp)
    439a:	f04a                	sd	s2,32(sp)
    439c:	ec4e                	sd	s3,24(sp)
    439e:	e852                	sd	s4,16(sp)
    43a0:	e456                	sd	s5,8(sp)
    43a2:	e05a                	sd	s6,0(sp)
    43a4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    43a6:	02051493          	slli	s1,a0,0x20
    43aa:	9081                	srli	s1,s1,0x20
    43ac:	04bd                	addi	s1,s1,15
    43ae:	8091                	srli	s1,s1,0x4
    43b0:	0014899b          	addiw	s3,s1,1
    43b4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    43b6:	00002517          	auipc	a0,0x2
    43ba:	e9253503          	ld	a0,-366(a0) # 6248 <freep>
    43be:	c515                	beqz	a0,43ea <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    43c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    43c2:	4798                	lw	a4,8(a5)
    43c4:	02977f63          	bgeu	a4,s1,4402 <malloc+0x70>
    43c8:	8a4e                	mv	s4,s3
    43ca:	0009871b          	sext.w	a4,s3
    43ce:	6685                	lui	a3,0x1
    43d0:	00d77363          	bgeu	a4,a3,43d6 <malloc+0x44>
    43d4:	6a05                	lui	s4,0x1
    43d6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    43da:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    43de:	00002917          	auipc	s2,0x2
    43e2:	e6a90913          	addi	s2,s2,-406 # 6248 <freep>
  if(p == (char*)-1)
    43e6:	5afd                	li	s5,-1
    43e8:	a895                	j	445c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    43ea:	00007797          	auipc	a5,0x7
    43ee:	67678793          	addi	a5,a5,1654 # ba60 <base>
    43f2:	00002717          	auipc	a4,0x2
    43f6:	e4f73b23          	sd	a5,-426(a4) # 6248 <freep>
    43fa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    43fc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    4400:	b7e1                	j	43c8 <malloc+0x36>
      if(p->s.size == nunits)
    4402:	02e48c63          	beq	s1,a4,443a <malloc+0xa8>
        p->s.size -= nunits;
    4406:	4137073b          	subw	a4,a4,s3
    440a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    440c:	02071693          	slli	a3,a4,0x20
    4410:	01c6d713          	srli	a4,a3,0x1c
    4414:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    4416:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    441a:	00002717          	auipc	a4,0x2
    441e:	e2a73723          	sd	a0,-466(a4) # 6248 <freep>
      return (void*)(p + 1);
    4422:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    4426:	70e2                	ld	ra,56(sp)
    4428:	7442                	ld	s0,48(sp)
    442a:	74a2                	ld	s1,40(sp)
    442c:	7902                	ld	s2,32(sp)
    442e:	69e2                	ld	s3,24(sp)
    4430:	6a42                	ld	s4,16(sp)
    4432:	6aa2                	ld	s5,8(sp)
    4434:	6b02                	ld	s6,0(sp)
    4436:	6121                	addi	sp,sp,64
    4438:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    443a:	6398                	ld	a4,0(a5)
    443c:	e118                	sd	a4,0(a0)
    443e:	bff1                	j	441a <malloc+0x88>
  hp->s.size = nu;
    4440:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    4444:	0541                	addi	a0,a0,16
    4446:	00000097          	auipc	ra,0x0
    444a:	ec4080e7          	jalr	-316(ra) # 430a <free>
  return freep;
    444e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    4452:	d971                	beqz	a0,4426 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4454:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4456:	4798                	lw	a4,8(a5)
    4458:	fa9775e3          	bgeu	a4,s1,4402 <malloc+0x70>
    if(p == freep)
    445c:	00093703          	ld	a4,0(s2)
    4460:	853e                	mv	a0,a5
    4462:	fef719e3          	bne	a4,a5,4454 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    4466:	8552                	mv	a0,s4
    4468:	00000097          	auipc	ra,0x0
    446c:	b5c080e7          	jalr	-1188(ra) # 3fc4 <sbrk>
  if(p == (char*)-1)
    4470:	fd5518e3          	bne	a0,s5,4440 <malloc+0xae>
        return 0;
    4474:	4501                	li	a0,0
    4476:	bf45                	j	4426 <malloc+0x94>
