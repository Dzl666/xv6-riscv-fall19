
user/_mounttest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
  test4();
  exit();
}

void test0()
{
       0:	7139                	addi	sp,sp,-64
       2:	fc06                	sd	ra,56(sp)
       4:	f822                	sd	s0,48(sp)
       6:	f426                	sd	s1,40(sp)
       8:	0080                	addi	s0,sp,64
  int fd;
  char buf[4];
  struct stat st;
  
  printf("test0 start\n");
       a:	00001517          	auipc	a0,0x1
       e:	17e50513          	addi	a0,a0,382 # 1188 <malloc+0xea>
      12:	00001097          	auipc	ra,0x1
      16:	fce080e7          	jalr	-50(ra) # fe0 <printf>

  mknod("disk1", DISK, 1);
      1a:	4605                	li	a2,1
      1c:	4581                	li	a1,0
      1e:	00001517          	auipc	a0,0x1
      22:	17a50513          	addi	a0,a0,378 # 1198 <malloc+0xfa>
      26:	00001097          	auipc	ra,0x1
      2a:	c6a080e7          	jalr	-918(ra) # c90 <mknod>
  mkdir("/m");
      2e:	00001517          	auipc	a0,0x1
      32:	17250513          	addi	a0,a0,370 # 11a0 <malloc+0x102>
      36:	00001097          	auipc	ra,0x1
      3a:	c7a080e7          	jalr	-902(ra) # cb0 <mkdir>
  
  if (mount("/disk1", "/m") < 0) {
      3e:	00001597          	auipc	a1,0x1
      42:	16258593          	addi	a1,a1,354 # 11a0 <malloc+0x102>
      46:	00001517          	auipc	a0,0x1
      4a:	16250513          	addi	a0,a0,354 # 11a8 <malloc+0x10a>
      4e:	00001097          	auipc	ra,0x1
      52:	caa080e7          	jalr	-854(ra) # cf8 <mount>
      56:	1a054663          	bltz	a0,202 <test0+0x202>
    printf("mount failed\n");
    exit();
  }    

  if (stat("/m", &st) < 0) {
      5a:	fc040593          	addi	a1,s0,-64
      5e:	00001517          	auipc	a0,0x1
      62:	14250513          	addi	a0,a0,322 # 11a0 <malloc+0x102>
      66:	00001097          	auipc	ra,0x1
      6a:	b20080e7          	jalr	-1248(ra) # b86 <stat>
      6e:	1a054663          	bltz	a0,21a <test0+0x21a>
    printf("stat /m failed\n");
    exit();
  }

  if (st.ino != 1 || minor(st.dev) != 1) {
      72:	f00017b7          	lui	a5,0xf0001
      76:	fc043703          	ld	a4,-64(s0)
      7a:	0792                	slli	a5,a5,0x4
      7c:	17fd                	addi	a5,a5,-1
      7e:	8f7d                	and	a4,a4,a5
      80:	4785                	li	a5,1
      82:	1782                	slli	a5,a5,0x20
      84:	0785                	addi	a5,a5,1
      86:	1af71663          	bne	a4,a5,232 <test0+0x232>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
    exit();
  }
  
  if ((fd = open("/m/README", O_RDONLY)) < 0) {
      8a:	4581                	li	a1,0
      8c:	00001517          	auipc	a0,0x1
      90:	16450513          	addi	a0,a0,356 # 11f0 <malloc+0x152>
      94:	00001097          	auipc	ra,0x1
      98:	bf4080e7          	jalr	-1036(ra) # c88 <open>
      9c:	84aa                	mv	s1,a0
      9e:	1a054a63          	bltz	a0,252 <test0+0x252>
    printf("open read failed\n");
    exit();
  }
  if (read(fd, buf, sizeof(buf)-1) != sizeof(buf)-1) {
      a2:	460d                	li	a2,3
      a4:	fd840593          	addi	a1,s0,-40
      a8:	00001097          	auipc	ra,0x1
      ac:	bb8080e7          	jalr	-1096(ra) # c60 <read>
      b0:	478d                	li	a5,3
      b2:	1af51c63          	bne	a0,a5,26a <test0+0x26a>
    printf("read failed\n");
    exit();
  }
  if (strcmp("xv6", buf) != 0) {
      b6:	fd840593          	addi	a1,s0,-40
      ba:	00001517          	auipc	a0,0x1
      be:	16e50513          	addi	a0,a0,366 # 1228 <malloc+0x18a>
      c2:	00001097          	auipc	ra,0x1
      c6:	9b4080e7          	jalr	-1612(ra) # a76 <strcmp>
      ca:	1a051c63          	bnez	a0,282 <test0+0x282>
    printf("read failed\n", buf);
  }
  close(fd);
      ce:	8526                	mv	a0,s1
      d0:	00001097          	auipc	ra,0x1
      d4:	ba0080e7          	jalr	-1120(ra) # c70 <close>
  
  if ((fd = open("/m/a", O_CREATE|O_WRONLY)) < 0) {
      d8:	20100593          	li	a1,513
      dc:	00001517          	auipc	a0,0x1
      e0:	15450513          	addi	a0,a0,340 # 1230 <malloc+0x192>
      e4:	00001097          	auipc	ra,0x1
      e8:	ba4080e7          	jalr	-1116(ra) # c88 <open>
      ec:	84aa                	mv	s1,a0
      ee:	1a054563          	bltz	a0,298 <test0+0x298>
    printf("open write failed\n");
    exit();
  }
  
  if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
      f2:	4611                	li	a2,4
      f4:	fd840593          	addi	a1,s0,-40
      f8:	00001097          	auipc	ra,0x1
      fc:	b70080e7          	jalr	-1168(ra) # c68 <write>
     100:	4791                	li	a5,4
     102:	1af51763          	bne	a0,a5,2b0 <test0+0x2b0>
    printf("write failed\n");
    exit();
  }

  close(fd);
     106:	8526                	mv	a0,s1
     108:	00001097          	auipc	ra,0x1
     10c:	b68080e7          	jalr	-1176(ra) # c70 <close>

  if (stat("/m/a", &st) < 0) {
     110:	fc040593          	addi	a1,s0,-64
     114:	00001517          	auipc	a0,0x1
     118:	11c50513          	addi	a0,a0,284 # 1230 <malloc+0x192>
     11c:	00001097          	auipc	ra,0x1
     120:	a6a080e7          	jalr	-1430(ra) # b86 <stat>
     124:	1a054263          	bltz	a0,2c8 <test0+0x2c8>
    printf("stat /m/a failed\n");
    exit();
  }

  if (minor(st.dev) != 1) {
     128:	fc045583          	lhu	a1,-64(s0)
     12c:	4785                	li	a5,1
     12e:	1af59963          	bne	a1,a5,2e0 <test0+0x2e0>
    printf("stat wrong minor %d\n", minor(st.dev));
    exit();
  }


  if (link("m/a", "/a") == 0) {
     132:	00001597          	auipc	a1,0x1
     136:	15e58593          	addi	a1,a1,350 # 1290 <malloc+0x1f2>
     13a:	00001517          	auipc	a0,0x1
     13e:	15e50513          	addi	a0,a0,350 # 1298 <malloc+0x1fa>
     142:	00001097          	auipc	ra,0x1
     146:	b66080e7          	jalr	-1178(ra) # ca8 <link>
     14a:	1a050763          	beqz	a0,2f8 <test0+0x2f8>
    printf("link m/a a succeeded\n");
    exit();
  }

  if (unlink("m/a") < 0) {
     14e:	00001517          	auipc	a0,0x1
     152:	14a50513          	addi	a0,a0,330 # 1298 <malloc+0x1fa>
     156:	00001097          	auipc	ra,0x1
     15a:	b42080e7          	jalr	-1214(ra) # c98 <unlink>
     15e:	1a054963          	bltz	a0,310 <test0+0x310>
    printf("unlink m/a failed\n");
    exit();
  }

  if (chdir("/m") < 0) {
     162:	00001517          	auipc	a0,0x1
     166:	03e50513          	addi	a0,a0,62 # 11a0 <malloc+0x102>
     16a:	00001097          	auipc	ra,0x1
     16e:	b4e080e7          	jalr	-1202(ra) # cb8 <chdir>
     172:	1a054b63          	bltz	a0,328 <test0+0x328>
    printf("chdir /m failed\n");
    exit();
  }

  if (stat(".", &st) < 0) {
     176:	fc040593          	addi	a1,s0,-64
     17a:	00001517          	auipc	a0,0x1
     17e:	16e50513          	addi	a0,a0,366 # 12e8 <malloc+0x24a>
     182:	00001097          	auipc	ra,0x1
     186:	a04080e7          	jalr	-1532(ra) # b86 <stat>
     18a:	1a054b63          	bltz	a0,340 <test0+0x340>
    printf("stat . failed\n");
    exit();
  }

  if (st.ino != 1 || minor(st.dev) != 1) {
     18e:	f00017b7          	lui	a5,0xf0001
     192:	fc043703          	ld	a4,-64(s0)
     196:	0792                	slli	a5,a5,0x4
     198:	17fd                	addi	a5,a5,-1
     19a:	8f7d                	and	a4,a4,a5
     19c:	4785                	li	a5,1
     19e:	1782                	slli	a5,a5,0x20
     1a0:	0785                	addi	a5,a5,1
     1a2:	1af71b63          	bne	a4,a5,358 <test0+0x358>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
    exit();
  }

  if (chdir("..") < 0) {
     1a6:	00001517          	auipc	a0,0x1
     1aa:	15a50513          	addi	a0,a0,346 # 1300 <malloc+0x262>
     1ae:	00001097          	auipc	ra,0x1
     1b2:	b0a080e7          	jalr	-1270(ra) # cb8 <chdir>
     1b6:	1c054163          	bltz	a0,378 <test0+0x378>
    printf("chdir .. failed\n");
    exit();
  }

  if (stat(".", &st) < 0) {
     1ba:	fc040593          	addi	a1,s0,-64
     1be:	00001517          	auipc	a0,0x1
     1c2:	12a50513          	addi	a0,a0,298 # 12e8 <malloc+0x24a>
     1c6:	00001097          	auipc	ra,0x1
     1ca:	9c0080e7          	jalr	-1600(ra) # b86 <stat>
     1ce:	1c054163          	bltz	a0,390 <test0+0x390>
    printf("stat . failed\n");
    exit();
  }

  if (st.ino == 1 && minor(st.dev) == 0) {
     1d2:	f00017b7          	lui	a5,0xf0001
     1d6:	fc043703          	ld	a4,-64(s0)
     1da:	0792                	slli	a5,a5,0x4
     1dc:	17fd                	addi	a5,a5,-1
     1de:	8ff9                	and	a5,a5,a4
     1e0:	4705                	li	a4,1
     1e2:	1702                	slli	a4,a4,0x20
     1e4:	1ce78263          	beq	a5,a4,3a8 <test0+0x3a8>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
    exit();
  }

  printf("test0 done\n");
     1e8:	00001517          	auipc	a0,0x1
     1ec:	13850513          	addi	a0,a0,312 # 1320 <malloc+0x282>
     1f0:	00001097          	auipc	ra,0x1
     1f4:	df0080e7          	jalr	-528(ra) # fe0 <printf>
}
     1f8:	70e2                	ld	ra,56(sp)
     1fa:	7442                	ld	s0,48(sp)
     1fc:	74a2                	ld	s1,40(sp)
     1fe:	6121                	addi	sp,sp,64
     200:	8082                	ret
    printf("mount failed\n");
     202:	00001517          	auipc	a0,0x1
     206:	fae50513          	addi	a0,a0,-82 # 11b0 <malloc+0x112>
     20a:	00001097          	auipc	ra,0x1
     20e:	dd6080e7          	jalr	-554(ra) # fe0 <printf>
    exit();
     212:	00001097          	auipc	ra,0x1
     216:	a36080e7          	jalr	-1482(ra) # c48 <exit>
    printf("stat /m failed\n");
     21a:	00001517          	auipc	a0,0x1
     21e:	fa650513          	addi	a0,a0,-90 # 11c0 <malloc+0x122>
     222:	00001097          	auipc	ra,0x1
     226:	dbe080e7          	jalr	-578(ra) # fe0 <printf>
    exit();
     22a:	00001097          	auipc	ra,0x1
     22e:	a1e080e7          	jalr	-1506(ra) # c48 <exit>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
     232:	fc045603          	lhu	a2,-64(s0)
     236:	fc442583          	lw	a1,-60(s0)
     23a:	00001517          	auipc	a0,0x1
     23e:	f9650513          	addi	a0,a0,-106 # 11d0 <malloc+0x132>
     242:	00001097          	auipc	ra,0x1
     246:	d9e080e7          	jalr	-610(ra) # fe0 <printf>
    exit();
     24a:	00001097          	auipc	ra,0x1
     24e:	9fe080e7          	jalr	-1538(ra) # c48 <exit>
    printf("open read failed\n");
     252:	00001517          	auipc	a0,0x1
     256:	fae50513          	addi	a0,a0,-82 # 1200 <malloc+0x162>
     25a:	00001097          	auipc	ra,0x1
     25e:	d86080e7          	jalr	-634(ra) # fe0 <printf>
    exit();
     262:	00001097          	auipc	ra,0x1
     266:	9e6080e7          	jalr	-1562(ra) # c48 <exit>
    printf("read failed\n");
     26a:	00001517          	auipc	a0,0x1
     26e:	fae50513          	addi	a0,a0,-82 # 1218 <malloc+0x17a>
     272:	00001097          	auipc	ra,0x1
     276:	d6e080e7          	jalr	-658(ra) # fe0 <printf>
    exit();
     27a:	00001097          	auipc	ra,0x1
     27e:	9ce080e7          	jalr	-1586(ra) # c48 <exit>
    printf("read failed\n", buf);
     282:	fd840593          	addi	a1,s0,-40
     286:	00001517          	auipc	a0,0x1
     28a:	f9250513          	addi	a0,a0,-110 # 1218 <malloc+0x17a>
     28e:	00001097          	auipc	ra,0x1
     292:	d52080e7          	jalr	-686(ra) # fe0 <printf>
     296:	bd25                	j	ce <test0+0xce>
    printf("open write failed\n");
     298:	00001517          	auipc	a0,0x1
     29c:	fa050513          	addi	a0,a0,-96 # 1238 <malloc+0x19a>
     2a0:	00001097          	auipc	ra,0x1
     2a4:	d40080e7          	jalr	-704(ra) # fe0 <printf>
    exit();
     2a8:	00001097          	auipc	ra,0x1
     2ac:	9a0080e7          	jalr	-1632(ra) # c48 <exit>
    printf("write failed\n");
     2b0:	00001517          	auipc	a0,0x1
     2b4:	fa050513          	addi	a0,a0,-96 # 1250 <malloc+0x1b2>
     2b8:	00001097          	auipc	ra,0x1
     2bc:	d28080e7          	jalr	-728(ra) # fe0 <printf>
    exit();
     2c0:	00001097          	auipc	ra,0x1
     2c4:	988080e7          	jalr	-1656(ra) # c48 <exit>
    printf("stat /m/a failed\n");
     2c8:	00001517          	auipc	a0,0x1
     2cc:	f9850513          	addi	a0,a0,-104 # 1260 <malloc+0x1c2>
     2d0:	00001097          	auipc	ra,0x1
     2d4:	d10080e7          	jalr	-752(ra) # fe0 <printf>
    exit();
     2d8:	00001097          	auipc	ra,0x1
     2dc:	970080e7          	jalr	-1680(ra) # c48 <exit>
    printf("stat wrong minor %d\n", minor(st.dev));
     2e0:	00001517          	auipc	a0,0x1
     2e4:	f9850513          	addi	a0,a0,-104 # 1278 <malloc+0x1da>
     2e8:	00001097          	auipc	ra,0x1
     2ec:	cf8080e7          	jalr	-776(ra) # fe0 <printf>
    exit();
     2f0:	00001097          	auipc	ra,0x1
     2f4:	958080e7          	jalr	-1704(ra) # c48 <exit>
    printf("link m/a a succeeded\n");
     2f8:	00001517          	auipc	a0,0x1
     2fc:	fa850513          	addi	a0,a0,-88 # 12a0 <malloc+0x202>
     300:	00001097          	auipc	ra,0x1
     304:	ce0080e7          	jalr	-800(ra) # fe0 <printf>
    exit();
     308:	00001097          	auipc	ra,0x1
     30c:	940080e7          	jalr	-1728(ra) # c48 <exit>
    printf("unlink m/a failed\n");
     310:	00001517          	auipc	a0,0x1
     314:	fa850513          	addi	a0,a0,-88 # 12b8 <malloc+0x21a>
     318:	00001097          	auipc	ra,0x1
     31c:	cc8080e7          	jalr	-824(ra) # fe0 <printf>
    exit();
     320:	00001097          	auipc	ra,0x1
     324:	928080e7          	jalr	-1752(ra) # c48 <exit>
    printf("chdir /m failed\n");
     328:	00001517          	auipc	a0,0x1
     32c:	fa850513          	addi	a0,a0,-88 # 12d0 <malloc+0x232>
     330:	00001097          	auipc	ra,0x1
     334:	cb0080e7          	jalr	-848(ra) # fe0 <printf>
    exit();
     338:	00001097          	auipc	ra,0x1
     33c:	910080e7          	jalr	-1776(ra) # c48 <exit>
    printf("stat . failed\n");
     340:	00001517          	auipc	a0,0x1
     344:	fb050513          	addi	a0,a0,-80 # 12f0 <malloc+0x252>
     348:	00001097          	auipc	ra,0x1
     34c:	c98080e7          	jalr	-872(ra) # fe0 <printf>
    exit();
     350:	00001097          	auipc	ra,0x1
     354:	8f8080e7          	jalr	-1800(ra) # c48 <exit>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
     358:	fc045603          	lhu	a2,-64(s0)
     35c:	fc442583          	lw	a1,-60(s0)
     360:	00001517          	auipc	a0,0x1
     364:	e7050513          	addi	a0,a0,-400 # 11d0 <malloc+0x132>
     368:	00001097          	auipc	ra,0x1
     36c:	c78080e7          	jalr	-904(ra) # fe0 <printf>
    exit();
     370:	00001097          	auipc	ra,0x1
     374:	8d8080e7          	jalr	-1832(ra) # c48 <exit>
    printf("chdir .. failed\n");
     378:	00001517          	auipc	a0,0x1
     37c:	f9050513          	addi	a0,a0,-112 # 1308 <malloc+0x26a>
     380:	00001097          	auipc	ra,0x1
     384:	c60080e7          	jalr	-928(ra) # fe0 <printf>
    exit();
     388:	00001097          	auipc	ra,0x1
     38c:	8c0080e7          	jalr	-1856(ra) # c48 <exit>
    printf("stat . failed\n");
     390:	00001517          	auipc	a0,0x1
     394:	f6050513          	addi	a0,a0,-160 # 12f0 <malloc+0x252>
     398:	00001097          	auipc	ra,0x1
     39c:	c48080e7          	jalr	-952(ra) # fe0 <printf>
    exit();
     3a0:	00001097          	auipc	ra,0x1
     3a4:	8a8080e7          	jalr	-1880(ra) # c48 <exit>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
     3a8:	fc045603          	lhu	a2,-64(s0)
     3ac:	fc442583          	lw	a1,-60(s0)
     3b0:	00001517          	auipc	a0,0x1
     3b4:	e2050513          	addi	a0,a0,-480 # 11d0 <malloc+0x132>
     3b8:	00001097          	auipc	ra,0x1
     3bc:	c28080e7          	jalr	-984(ra) # fe0 <printf>
    exit();
     3c0:	00001097          	auipc	ra,0x1
     3c4:	888080e7          	jalr	-1912(ra) # c48 <exit>

00000000000003c8 <test1>:

// depends on test0
void test1() {
     3c8:	715d                	addi	sp,sp,-80
     3ca:	e486                	sd	ra,72(sp)
     3cc:	e0a2                	sd	s0,64(sp)
     3ce:	fc26                	sd	s1,56(sp)
     3d0:	f84a                	sd	s2,48(sp)
     3d2:	f44e                	sd	s3,40(sp)
     3d4:	0880                	addi	s0,sp,80
  struct stat st;
  int fd;
  int i;
  
  printf("test1 start\n");
     3d6:	00001517          	auipc	a0,0x1
     3da:	f5a50513          	addi	a0,a0,-166 # 1330 <malloc+0x292>
     3de:	00001097          	auipc	ra,0x1
     3e2:	c02080e7          	jalr	-1022(ra) # fe0 <printf>

  if (mount("/disk1", "/m") == 0) {
     3e6:	00001597          	auipc	a1,0x1
     3ea:	dba58593          	addi	a1,a1,-582 # 11a0 <malloc+0x102>
     3ee:	00001517          	auipc	a0,0x1
     3f2:	dba50513          	addi	a0,a0,-582 # 11a8 <malloc+0x10a>
     3f6:	00001097          	auipc	ra,0x1
     3fa:	902080e7          	jalr	-1790(ra) # cf8 <mount>
     3fe:	10050d63          	beqz	a0,518 <test1+0x150>
    printf("mount should fail\n");
    exit();
  }    

  if (umount("/m") < 0) {
     402:	00001517          	auipc	a0,0x1
     406:	d9e50513          	addi	a0,a0,-610 # 11a0 <malloc+0x102>
     40a:	00001097          	auipc	ra,0x1
     40e:	8f6080e7          	jalr	-1802(ra) # d00 <umount>
     412:	10054f63          	bltz	a0,530 <test1+0x168>
    printf("umount /m failed\n");
    exit();
  }    

  if (umount("/m") == 0) {
     416:	00001517          	auipc	a0,0x1
     41a:	d8a50513          	addi	a0,a0,-630 # 11a0 <malloc+0x102>
     41e:	00001097          	auipc	ra,0x1
     422:	8e2080e7          	jalr	-1822(ra) # d00 <umount>
     426:	12050163          	beqz	a0,548 <test1+0x180>
    printf("umount /m succeeded\n");
    exit();
  }    

  if (umount("/") == 0) {
     42a:	00001517          	auipc	a0,0x1
     42e:	f5e50513          	addi	a0,a0,-162 # 1388 <malloc+0x2ea>
     432:	00001097          	auipc	ra,0x1
     436:	8ce080e7          	jalr	-1842(ra) # d00 <umount>
     43a:	12050363          	beqz	a0,560 <test1+0x198>
    printf("umount / succeeded\n");
    exit();
  }    

  if (stat("/m", &st) < 0) {
     43e:	fb840593          	addi	a1,s0,-72
     442:	00001517          	auipc	a0,0x1
     446:	d5e50513          	addi	a0,a0,-674 # 11a0 <malloc+0x102>
     44a:	00000097          	auipc	ra,0x0
     44e:	73c080e7          	jalr	1852(ra) # b86 <stat>
     452:	12054363          	bltz	a0,578 <test1+0x1b0>
    printf("stat /m failed\n");
    exit();
  }

  if (minor(st.dev) != 0) {
     456:	fb845603          	lhu	a2,-72(s0)
     45a:	06400493          	li	s1,100
    exit();
  }

  // many mounts and umounts
  for (i = 0; i < 100; i++) {
    if (mount("/disk1", "/m") < 0) {
     45e:	00001917          	auipc	s2,0x1
     462:	d4290913          	addi	s2,s2,-702 # 11a0 <malloc+0x102>
     466:	00001997          	auipc	s3,0x1
     46a:	d4298993          	addi	s3,s3,-702 # 11a8 <malloc+0x10a>
  if (minor(st.dev) != 0) {
     46e:	12061163          	bnez	a2,590 <test1+0x1c8>
    if (mount("/disk1", "/m") < 0) {
     472:	85ca                	mv	a1,s2
     474:	854e                	mv	a0,s3
     476:	00001097          	auipc	ra,0x1
     47a:	882080e7          	jalr	-1918(ra) # cf8 <mount>
     47e:	12054763          	bltz	a0,5ac <test1+0x1e4>
      printf("mount /m should succeed\n");
      exit();
    }    

    if (umount("/m") < 0) {
     482:	854a                	mv	a0,s2
     484:	00001097          	auipc	ra,0x1
     488:	87c080e7          	jalr	-1924(ra) # d00 <umount>
     48c:	12054c63          	bltz	a0,5c4 <test1+0x1fc>
  for (i = 0; i < 100; i++) {
     490:	34fd                	addiw	s1,s1,-1
     492:	f0e5                	bnez	s1,472 <test1+0xaa>
      printf("umount /m failed\n");
      exit();
    }
  }

  if (mount("/disk1", "/m") < 0) {
     494:	00001597          	auipc	a1,0x1
     498:	d0c58593          	addi	a1,a1,-756 # 11a0 <malloc+0x102>
     49c:	00001517          	auipc	a0,0x1
     4a0:	d0c50513          	addi	a0,a0,-756 # 11a8 <malloc+0x10a>
     4a4:	00001097          	auipc	ra,0x1
     4a8:	854080e7          	jalr	-1964(ra) # cf8 <mount>
     4ac:	12054863          	bltz	a0,5dc <test1+0x214>
    printf("mount /m should succeed\n");
    exit();
  }    

  if ((fd = open("/m/README", O_RDONLY)) < 0) {
     4b0:	4581                	li	a1,0
     4b2:	00001517          	auipc	a0,0x1
     4b6:	d3e50513          	addi	a0,a0,-706 # 11f0 <malloc+0x152>
     4ba:	00000097          	auipc	ra,0x0
     4be:	7ce080e7          	jalr	1998(ra) # c88 <open>
     4c2:	84aa                	mv	s1,a0
     4c4:	12054863          	bltz	a0,5f4 <test1+0x22c>
    printf("open read failed\n");
    exit();
  }

  if (umount("/m") == 0) {
     4c8:	00001517          	auipc	a0,0x1
     4cc:	cd850513          	addi	a0,a0,-808 # 11a0 <malloc+0x102>
     4d0:	00001097          	auipc	ra,0x1
     4d4:	830080e7          	jalr	-2000(ra) # d00 <umount>
     4d8:	12050a63          	beqz	a0,60c <test1+0x244>
    printf("umount /m succeeded\n");
    exit();
  }

  close(fd);
     4dc:	8526                	mv	a0,s1
     4de:	00000097          	auipc	ra,0x0
     4e2:	792080e7          	jalr	1938(ra) # c70 <close>
  
  if (umount("/m") < 0) {
     4e6:	00001517          	auipc	a0,0x1
     4ea:	cba50513          	addi	a0,a0,-838 # 11a0 <malloc+0x102>
     4ee:	00001097          	auipc	ra,0x1
     4f2:	812080e7          	jalr	-2030(ra) # d00 <umount>
     4f6:	12054763          	bltz	a0,624 <test1+0x25c>
    printf("final umount failed\n");
    exit();
  }

  printf("test1 done\n");
     4fa:	00001517          	auipc	a0,0x1
     4fe:	f0650513          	addi	a0,a0,-250 # 1400 <malloc+0x362>
     502:	00001097          	auipc	ra,0x1
     506:	ade080e7          	jalr	-1314(ra) # fe0 <printf>
}
     50a:	60a6                	ld	ra,72(sp)
     50c:	6406                	ld	s0,64(sp)
     50e:	74e2                	ld	s1,56(sp)
     510:	7942                	ld	s2,48(sp)
     512:	79a2                	ld	s3,40(sp)
     514:	6161                	addi	sp,sp,80
     516:	8082                	ret
    printf("mount should fail\n");
     518:	00001517          	auipc	a0,0x1
     51c:	e2850513          	addi	a0,a0,-472 # 1340 <malloc+0x2a2>
     520:	00001097          	auipc	ra,0x1
     524:	ac0080e7          	jalr	-1344(ra) # fe0 <printf>
    exit();
     528:	00000097          	auipc	ra,0x0
     52c:	720080e7          	jalr	1824(ra) # c48 <exit>
    printf("umount /m failed\n");
     530:	00001517          	auipc	a0,0x1
     534:	e2850513          	addi	a0,a0,-472 # 1358 <malloc+0x2ba>
     538:	00001097          	auipc	ra,0x1
     53c:	aa8080e7          	jalr	-1368(ra) # fe0 <printf>
    exit();
     540:	00000097          	auipc	ra,0x0
     544:	708080e7          	jalr	1800(ra) # c48 <exit>
    printf("umount /m succeeded\n");
     548:	00001517          	auipc	a0,0x1
     54c:	e2850513          	addi	a0,a0,-472 # 1370 <malloc+0x2d2>
     550:	00001097          	auipc	ra,0x1
     554:	a90080e7          	jalr	-1392(ra) # fe0 <printf>
    exit();
     558:	00000097          	auipc	ra,0x0
     55c:	6f0080e7          	jalr	1776(ra) # c48 <exit>
    printf("umount / succeeded\n");
     560:	00001517          	auipc	a0,0x1
     564:	e3050513          	addi	a0,a0,-464 # 1390 <malloc+0x2f2>
     568:	00001097          	auipc	ra,0x1
     56c:	a78080e7          	jalr	-1416(ra) # fe0 <printf>
    exit();
     570:	00000097          	auipc	ra,0x0
     574:	6d8080e7          	jalr	1752(ra) # c48 <exit>
    printf("stat /m failed\n");
     578:	00001517          	auipc	a0,0x1
     57c:	c4850513          	addi	a0,a0,-952 # 11c0 <malloc+0x122>
     580:	00001097          	auipc	ra,0x1
     584:	a60080e7          	jalr	-1440(ra) # fe0 <printf>
    exit();
     588:	00000097          	auipc	ra,0x0
     58c:	6c0080e7          	jalr	1728(ra) # c48 <exit>
    printf("stat wrong inum/dev %d %d\n", st.ino, minor(st.dev));
     590:	fbc42583          	lw	a1,-68(s0)
     594:	00001517          	auipc	a0,0x1
     598:	e1450513          	addi	a0,a0,-492 # 13a8 <malloc+0x30a>
     59c:	00001097          	auipc	ra,0x1
     5a0:	a44080e7          	jalr	-1468(ra) # fe0 <printf>
    exit();
     5a4:	00000097          	auipc	ra,0x0
     5a8:	6a4080e7          	jalr	1700(ra) # c48 <exit>
      printf("mount /m should succeed\n");
     5ac:	00001517          	auipc	a0,0x1
     5b0:	e1c50513          	addi	a0,a0,-484 # 13c8 <malloc+0x32a>
     5b4:	00001097          	auipc	ra,0x1
     5b8:	a2c080e7          	jalr	-1492(ra) # fe0 <printf>
      exit();
     5bc:	00000097          	auipc	ra,0x0
     5c0:	68c080e7          	jalr	1676(ra) # c48 <exit>
      printf("umount /m failed\n");
     5c4:	00001517          	auipc	a0,0x1
     5c8:	d9450513          	addi	a0,a0,-620 # 1358 <malloc+0x2ba>
     5cc:	00001097          	auipc	ra,0x1
     5d0:	a14080e7          	jalr	-1516(ra) # fe0 <printf>
      exit();
     5d4:	00000097          	auipc	ra,0x0
     5d8:	674080e7          	jalr	1652(ra) # c48 <exit>
    printf("mount /m should succeed\n");
     5dc:	00001517          	auipc	a0,0x1
     5e0:	dec50513          	addi	a0,a0,-532 # 13c8 <malloc+0x32a>
     5e4:	00001097          	auipc	ra,0x1
     5e8:	9fc080e7          	jalr	-1540(ra) # fe0 <printf>
    exit();
     5ec:	00000097          	auipc	ra,0x0
     5f0:	65c080e7          	jalr	1628(ra) # c48 <exit>
    printf("open read failed\n");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	c0c50513          	addi	a0,a0,-1012 # 1200 <malloc+0x162>
     5fc:	00001097          	auipc	ra,0x1
     600:	9e4080e7          	jalr	-1564(ra) # fe0 <printf>
    exit();
     604:	00000097          	auipc	ra,0x0
     608:	644080e7          	jalr	1604(ra) # c48 <exit>
    printf("umount /m succeeded\n");
     60c:	00001517          	auipc	a0,0x1
     610:	d6450513          	addi	a0,a0,-668 # 1370 <malloc+0x2d2>
     614:	00001097          	auipc	ra,0x1
     618:	9cc080e7          	jalr	-1588(ra) # fe0 <printf>
    exit();
     61c:	00000097          	auipc	ra,0x0
     620:	62c080e7          	jalr	1580(ra) # c48 <exit>
    printf("final umount failed\n");
     624:	00001517          	auipc	a0,0x1
     628:	dc450513          	addi	a0,a0,-572 # 13e8 <malloc+0x34a>
     62c:	00001097          	auipc	ra,0x1
     630:	9b4080e7          	jalr	-1612(ra) # fe0 <printf>
    exit();
     634:	00000097          	auipc	ra,0x0
     638:	614080e7          	jalr	1556(ra) # c48 <exit>

000000000000063c <test2>:
#define NOP 100

// try to trigger races/deadlocks in namex; it is helpful to add
// sleepticks(1) in if(ip->type != T_DIR) branch in namei, so that you
// will observe some more reliably.
void test2() {
     63c:	711d                	addi	sp,sp,-96
     63e:	ec86                	sd	ra,88(sp)
     640:	e8a2                	sd	s0,80(sp)
     642:	e4a6                	sd	s1,72(sp)
     644:	e0ca                	sd	s2,64(sp)
     646:	fc4e                	sd	s3,56(sp)
     648:	f852                	sd	s4,48(sp)
     64a:	f456                	sd	s5,40(sp)
     64c:	1080                	addi	s0,sp,96
  int pid[NPID];
  int fd;
  int i;
  char buf[1];

  printf("test2\n");
     64e:	00001517          	auipc	a0,0x1
     652:	dc250513          	addi	a0,a0,-574 # 1410 <malloc+0x372>
     656:	00001097          	auipc	ra,0x1
     65a:	98a080e7          	jalr	-1654(ra) # fe0 <printf>

  mkdir("/m");
     65e:	00001517          	auipc	a0,0x1
     662:	b4250513          	addi	a0,a0,-1214 # 11a0 <malloc+0x102>
     666:	00000097          	auipc	ra,0x0
     66a:	64a080e7          	jalr	1610(ra) # cb0 <mkdir>
  
  if (mount("/disk1", "/m") < 0) {
     66e:	00001597          	auipc	a1,0x1
     672:	b3258593          	addi	a1,a1,-1230 # 11a0 <malloc+0x102>
     676:	00001517          	auipc	a0,0x1
     67a:	b3250513          	addi	a0,a0,-1230 # 11a8 <malloc+0x10a>
     67e:	00000097          	auipc	ra,0x0
     682:	67a080e7          	jalr	1658(ra) # cf8 <mount>
     686:	0c054463          	bltz	a0,74e <test2+0x112>
     68a:	fb040a13          	addi	s4,s0,-80
     68e:	fc040a93          	addi	s5,s0,-64
     692:	84d2                	mv	s1,s4
      printf("mount failed\n");
      exit();
  }    

  for (i = 0; i < NPID; i++) {
    if ((pid[i] = fork()) < 0) {
     694:	00000097          	auipc	ra,0x0
     698:	5ac080e7          	jalr	1452(ra) # c40 <fork>
     69c:	c088                	sw	a0,0(s1)
     69e:	0c054463          	bltz	a0,766 <test2+0x12a>
      printf("fork failed\n");
      exit();
    }
    if (pid[i] == 0) {
     6a2:	cd71                	beqz	a0,77e <test2+0x142>
  for (i = 0; i < NPID; i++) {
     6a4:	0491                	addi	s1,s1,4
     6a6:	ff5497e3          	bne	s1,s5,694 <test2+0x58>
     6aa:	06400913          	li	s2,100
        }
      }
    }
  }
  for (i = 0; i < NOP; i++) {
    if ((fd = open("/m/b", O_CREATE|O_WRONLY)) < 0) {
     6ae:	00001997          	auipc	s3,0x1
     6b2:	d8298993          	addi	s3,s3,-638 # 1430 <malloc+0x392>
     6b6:	20100593          	li	a1,513
     6ba:	854e                	mv	a0,s3
     6bc:	00000097          	auipc	ra,0x0
     6c0:	5cc080e7          	jalr	1484(ra) # c88 <open>
     6c4:	84aa                	mv	s1,a0
     6c6:	0c054d63          	bltz	a0,7a0 <test2+0x164>
      printf("open write failed");
      exit();
    }
    if (unlink("/m/b") < 0) {
     6ca:	854e                	mv	a0,s3
     6cc:	00000097          	auipc	ra,0x0
     6d0:	5cc080e7          	jalr	1484(ra) # c98 <unlink>
     6d4:	0e054263          	bltz	a0,7b8 <test2+0x17c>
      printf("unlink failed\n");
      exit();
    }
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
     6d8:	4605                	li	a2,1
     6da:	fa840593          	addi	a1,s0,-88
     6de:	8526                	mv	a0,s1
     6e0:	00000097          	auipc	ra,0x0
     6e4:	588080e7          	jalr	1416(ra) # c68 <write>
     6e8:	4785                	li	a5,1
     6ea:	0ef51363          	bne	a0,a5,7d0 <test2+0x194>
      printf("write failed\n");
      exit();
    }
    close(fd);
     6ee:	8526                	mv	a0,s1
     6f0:	00000097          	auipc	ra,0x0
     6f4:	580080e7          	jalr	1408(ra) # c70 <close>
  for (i = 0; i < NOP; i++) {
     6f8:	397d                	addiw	s2,s2,-1
     6fa:	fa091ee3          	bnez	s2,6b6 <test2+0x7a>
  }
  for (i = 0; i < NPID; i++) {
    kill(pid[i]);
     6fe:	000a2503          	lw	a0,0(s4)
     702:	00000097          	auipc	ra,0x0
     706:	576080e7          	jalr	1398(ra) # c78 <kill>
    wait();
     70a:	00000097          	auipc	ra,0x0
     70e:	546080e7          	jalr	1350(ra) # c50 <wait>
  for (i = 0; i < NPID; i++) {
     712:	0a11                	addi	s4,s4,4
     714:	ff5a15e3          	bne	s4,s5,6fe <test2+0xc2>
  }
  if (umount("/m") < 0) {
     718:	00001517          	auipc	a0,0x1
     71c:	a8850513          	addi	a0,a0,-1400 # 11a0 <malloc+0x102>
     720:	00000097          	auipc	ra,0x0
     724:	5e0080e7          	jalr	1504(ra) # d00 <umount>
     728:	0c054063          	bltz	a0,7e8 <test2+0x1ac>
    printf("umount failed\n");
    exit();
  }    

  printf("test2 ok\n");
     72c:	00001517          	auipc	a0,0x1
     730:	d4450513          	addi	a0,a0,-700 # 1470 <malloc+0x3d2>
     734:	00001097          	auipc	ra,0x1
     738:	8ac080e7          	jalr	-1876(ra) # fe0 <printf>
}
     73c:	60e6                	ld	ra,88(sp)
     73e:	6446                	ld	s0,80(sp)
     740:	64a6                	ld	s1,72(sp)
     742:	6906                	ld	s2,64(sp)
     744:	79e2                	ld	s3,56(sp)
     746:	7a42                	ld	s4,48(sp)
     748:	7aa2                	ld	s5,40(sp)
     74a:	6125                	addi	sp,sp,96
     74c:	8082                	ret
      printf("mount failed\n");
     74e:	00001517          	auipc	a0,0x1
     752:	a6250513          	addi	a0,a0,-1438 # 11b0 <malloc+0x112>
     756:	00001097          	auipc	ra,0x1
     75a:	88a080e7          	jalr	-1910(ra) # fe0 <printf>
      exit();
     75e:	00000097          	auipc	ra,0x0
     762:	4ea080e7          	jalr	1258(ra) # c48 <exit>
      printf("fork failed\n");
     766:	00001517          	auipc	a0,0x1
     76a:	cb250513          	addi	a0,a0,-846 # 1418 <malloc+0x37a>
     76e:	00001097          	auipc	ra,0x1
     772:	872080e7          	jalr	-1934(ra) # fe0 <printf>
      exit();
     776:	00000097          	auipc	ra,0x0
     77a:	4d2080e7          	jalr	1234(ra) # c48 <exit>
        if ((fd = open("/m/b/c", O_RDONLY)) >= 0) {
     77e:	00001497          	auipc	s1,0x1
     782:	caa48493          	addi	s1,s1,-854 # 1428 <malloc+0x38a>
     786:	4581                	li	a1,0
     788:	8526                	mv	a0,s1
     78a:	00000097          	auipc	ra,0x0
     78e:	4fe080e7          	jalr	1278(ra) # c88 <open>
     792:	fe054ae3          	bltz	a0,786 <test2+0x14a>
          close(fd);
     796:	00000097          	auipc	ra,0x0
     79a:	4da080e7          	jalr	1242(ra) # c70 <close>
     79e:	b7e5                	j	786 <test2+0x14a>
      printf("open write failed");
     7a0:	00001517          	auipc	a0,0x1
     7a4:	c9850513          	addi	a0,a0,-872 # 1438 <malloc+0x39a>
     7a8:	00001097          	auipc	ra,0x1
     7ac:	838080e7          	jalr	-1992(ra) # fe0 <printf>
      exit();
     7b0:	00000097          	auipc	ra,0x0
     7b4:	498080e7          	jalr	1176(ra) # c48 <exit>
      printf("unlink failed\n");
     7b8:	00001517          	auipc	a0,0x1
     7bc:	c9850513          	addi	a0,a0,-872 # 1450 <malloc+0x3b2>
     7c0:	00001097          	auipc	ra,0x1
     7c4:	820080e7          	jalr	-2016(ra) # fe0 <printf>
      exit();
     7c8:	00000097          	auipc	ra,0x0
     7cc:	480080e7          	jalr	1152(ra) # c48 <exit>
      printf("write failed\n");
     7d0:	00001517          	auipc	a0,0x1
     7d4:	a8050513          	addi	a0,a0,-1408 # 1250 <malloc+0x1b2>
     7d8:	00001097          	auipc	ra,0x1
     7dc:	808080e7          	jalr	-2040(ra) # fe0 <printf>
      exit();
     7e0:	00000097          	auipc	ra,0x0
     7e4:	468080e7          	jalr	1128(ra) # c48 <exit>
    printf("umount failed\n");
     7e8:	00001517          	auipc	a0,0x1
     7ec:	c7850513          	addi	a0,a0,-904 # 1460 <malloc+0x3c2>
     7f0:	00000097          	auipc	ra,0x0
     7f4:	7f0080e7          	jalr	2032(ra) # fe0 <printf>
    exit();
     7f8:	00000097          	auipc	ra,0x0
     7fc:	450080e7          	jalr	1104(ra) # c48 <exit>

0000000000000800 <test3>:


// Mount/unmount concurrently with creating files on the mounted fs
void test3() {
     800:	7159                	addi	sp,sp,-112
     802:	f486                	sd	ra,104(sp)
     804:	f0a2                	sd	s0,96(sp)
     806:	eca6                	sd	s1,88(sp)
     808:	e8ca                	sd	s2,80(sp)
     80a:	e4ce                	sd	s3,72(sp)
     80c:	e0d2                	sd	s4,64(sp)
     80e:	fc56                	sd	s5,56(sp)
     810:	f85a                	sd	s6,48(sp)
     812:	f45e                	sd	s7,40(sp)
     814:	1880                	addi	s0,sp,112
  int pid[NPID];
  int fd;
  int i;
  char buf[1];

  printf("test3\n");
     816:	00001517          	auipc	a0,0x1
     81a:	c6a50513          	addi	a0,a0,-918 # 1480 <malloc+0x3e2>
     81e:	00000097          	auipc	ra,0x0
     822:	7c2080e7          	jalr	1986(ra) # fe0 <printf>

  mkdir("/m");
     826:	00001517          	auipc	a0,0x1
     82a:	97a50513          	addi	a0,a0,-1670 # 11a0 <malloc+0x102>
     82e:	00000097          	auipc	ra,0x0
     832:	482080e7          	jalr	1154(ra) # cb0 <mkdir>
  for (i = 0; i < NPID; i++) {
     836:	fa040b13          	addi	s6,s0,-96
     83a:	fb040b93          	addi	s7,s0,-80
  mkdir("/m");
     83e:	84da                	mv	s1,s6
    if ((pid[i] = fork()) < 0) {
     840:	00000097          	auipc	ra,0x0
     844:	400080e7          	jalr	1024(ra) # c40 <fork>
     848:	c088                	sw	a0,0(s1)
     84a:	02054663          	bltz	a0,876 <test3+0x76>
      printf("fork failed\n");
      exit();
    }
    if (pid[i] == 0) {
     84e:	c121                	beqz	a0,88e <test3+0x8e>
  for (i = 0; i < NPID; i++) {
     850:	0491                	addi	s1,s1,4
     852:	ff7497e3          	bne	s1,s7,840 <test3+0x40>
        close(fd);
        sleep(1);
      }
    }
  }
  for (i = 0; i < NOP; i++) {
     856:	4481                	li	s1,0
    if (mount("/disk1", "/m") < 0) {
     858:	00001917          	auipc	s2,0x1
     85c:	94890913          	addi	s2,s2,-1720 # 11a0 <malloc+0x102>
     860:	00001a97          	auipc	s5,0x1
     864:	948a8a93          	addi	s5,s5,-1720 # 11a8 <malloc+0x10a>
      printf("mount failed\n");
      exit();
    }    
    while (umount("/m") < 0) {
      printf("umount failed; try again %d\n", i);
     868:	00001997          	auipc	s3,0x1
     86c:	c2098993          	addi	s3,s3,-992 # 1488 <malloc+0x3ea>
  for (i = 0; i < NOP; i++) {
     870:	06400a13          	li	s4,100
     874:	a875                	j	930 <test3+0x130>
      printf("fork failed\n");
     876:	00001517          	auipc	a0,0x1
     87a:	ba250513          	addi	a0,a0,-1118 # 1418 <malloc+0x37a>
     87e:	00000097          	auipc	ra,0x0
     882:	762080e7          	jalr	1890(ra) # fe0 <printf>
      exit();
     886:	00000097          	auipc	ra,0x0
     88a:	3c2080e7          	jalr	962(ra) # c48 <exit>
        if ((fd = open("/m/b", O_CREATE|O_WRONLY)) < 0) {
     88e:	00001917          	auipc	s2,0x1
     892:	ba290913          	addi	s2,s2,-1118 # 1430 <malloc+0x392>
     896:	20100593          	li	a1,513
     89a:	854a                	mv	a0,s2
     89c:	00000097          	auipc	ra,0x0
     8a0:	3ec080e7          	jalr	1004(ra) # c88 <open>
     8a4:	84aa                	mv	s1,a0
     8a6:	02054d63          	bltz	a0,8e0 <test3+0xe0>
        unlink("/m/b");
     8aa:	854a                	mv	a0,s2
     8ac:	00000097          	auipc	ra,0x0
     8b0:	3ec080e7          	jalr	1004(ra) # c98 <unlink>
        if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
     8b4:	4605                	li	a2,1
     8b6:	f9840593          	addi	a1,s0,-104
     8ba:	8526                	mv	a0,s1
     8bc:	00000097          	auipc	ra,0x0
     8c0:	3ac080e7          	jalr	940(ra) # c68 <write>
     8c4:	4785                	li	a5,1
     8c6:	02f51963          	bne	a0,a5,8f8 <test3+0xf8>
        close(fd);
     8ca:	8526                	mv	a0,s1
     8cc:	00000097          	auipc	ra,0x0
     8d0:	3a4080e7          	jalr	932(ra) # c70 <close>
        sleep(1);
     8d4:	4505                	li	a0,1
     8d6:	00000097          	auipc	ra,0x0
     8da:	402080e7          	jalr	1026(ra) # cd8 <sleep>
        if ((fd = open("/m/b", O_CREATE|O_WRONLY)) < 0) {
     8de:	bf65                	j	896 <test3+0x96>
          printf("open write failed");
     8e0:	00001517          	auipc	a0,0x1
     8e4:	b5850513          	addi	a0,a0,-1192 # 1438 <malloc+0x39a>
     8e8:	00000097          	auipc	ra,0x0
     8ec:	6f8080e7          	jalr	1784(ra) # fe0 <printf>
          exit();
     8f0:	00000097          	auipc	ra,0x0
     8f4:	358080e7          	jalr	856(ra) # c48 <exit>
          printf("write failed\n");
     8f8:	00001517          	auipc	a0,0x1
     8fc:	95850513          	addi	a0,a0,-1704 # 1250 <malloc+0x1b2>
     900:	00000097          	auipc	ra,0x0
     904:	6e0080e7          	jalr	1760(ra) # fe0 <printf>
          exit();
     908:	00000097          	auipc	ra,0x0
     90c:	340080e7          	jalr	832(ra) # c48 <exit>
      printf("umount failed; try again %d\n", i);
     910:	85a6                	mv	a1,s1
     912:	854e                	mv	a0,s3
     914:	00000097          	auipc	ra,0x0
     918:	6cc080e7          	jalr	1740(ra) # fe0 <printf>
    while (umount("/m") < 0) {
     91c:	854a                	mv	a0,s2
     91e:	00000097          	auipc	ra,0x0
     922:	3e2080e7          	jalr	994(ra) # d00 <umount>
     926:	fe0545e3          	bltz	a0,910 <test3+0x110>
  for (i = 0; i < NOP; i++) {
     92a:	2485                	addiw	s1,s1,1
     92c:	03448663          	beq	s1,s4,958 <test3+0x158>
    if (mount("/disk1", "/m") < 0) {
     930:	85ca                	mv	a1,s2
     932:	8556                	mv	a0,s5
     934:	00000097          	auipc	ra,0x0
     938:	3c4080e7          	jalr	964(ra) # cf8 <mount>
     93c:	fe0550e3          	bgez	a0,91c <test3+0x11c>
      printf("mount failed\n");
     940:	00001517          	auipc	a0,0x1
     944:	87050513          	addi	a0,a0,-1936 # 11b0 <malloc+0x112>
     948:	00000097          	auipc	ra,0x0
     94c:	698080e7          	jalr	1688(ra) # fe0 <printf>
      exit();
     950:	00000097          	auipc	ra,0x0
     954:	2f8080e7          	jalr	760(ra) # c48 <exit>
    }    
  }
  for (i = 0; i < NPID; i++) {
    kill(pid[i]);
     958:	000b2503          	lw	a0,0(s6)
     95c:	00000097          	auipc	ra,0x0
     960:	31c080e7          	jalr	796(ra) # c78 <kill>
    wait();
     964:	00000097          	auipc	ra,0x0
     968:	2ec080e7          	jalr	748(ra) # c50 <wait>
  for (i = 0; i < NPID; i++) {
     96c:	0b11                	addi	s6,s6,4
     96e:	ff7b15e3          	bne	s6,s7,958 <test3+0x158>
  }
  printf("test3 ok\n");
     972:	00001517          	auipc	a0,0x1
     976:	b3650513          	addi	a0,a0,-1226 # 14a8 <malloc+0x40a>
     97a:	00000097          	auipc	ra,0x0
     97e:	666080e7          	jalr	1638(ra) # fe0 <printf>
}
     982:	70a6                	ld	ra,104(sp)
     984:	7406                	ld	s0,96(sp)
     986:	64e6                	ld	s1,88(sp)
     988:	6946                	ld	s2,80(sp)
     98a:	69a6                	ld	s3,72(sp)
     98c:	6a06                	ld	s4,64(sp)
     98e:	7ae2                	ld	s5,56(sp)
     990:	7b42                	ld	s6,48(sp)
     992:	7ba2                	ld	s7,40(sp)
     994:	6165                	addi	sp,sp,112
     996:	8082                	ret

0000000000000998 <test4>:

void
test4()
{
     998:	1141                	addi	sp,sp,-16
     99a:	e406                	sd	ra,8(sp)
     99c:	e022                	sd	s0,0(sp)
     99e:	0800                	addi	s0,sp,16
  printf("test4\n");
     9a0:	00001517          	auipc	a0,0x1
     9a4:	b1850513          	addi	a0,a0,-1256 # 14b8 <malloc+0x41a>
     9a8:	00000097          	auipc	ra,0x0
     9ac:	638080e7          	jalr	1592(ra) # fe0 <printf>

  mknod("disk1", DISK, 1);
     9b0:	4605                	li	a2,1
     9b2:	4581                	li	a1,0
     9b4:	00000517          	auipc	a0,0x0
     9b8:	7e450513          	addi	a0,a0,2020 # 1198 <malloc+0xfa>
     9bc:	00000097          	auipc	ra,0x0
     9c0:	2d4080e7          	jalr	724(ra) # c90 <mknod>
  mkdir("/m");
     9c4:	00000517          	auipc	a0,0x0
     9c8:	7dc50513          	addi	a0,a0,2012 # 11a0 <malloc+0x102>
     9cc:	00000097          	auipc	ra,0x0
     9d0:	2e4080e7          	jalr	740(ra) # cb0 <mkdir>
  if (mount("/disk1", "/m") < 0) {
     9d4:	00000597          	auipc	a1,0x0
     9d8:	7cc58593          	addi	a1,a1,1996 # 11a0 <malloc+0x102>
     9dc:	00000517          	auipc	a0,0x0
     9e0:	7cc50513          	addi	a0,a0,1996 # 11a8 <malloc+0x10a>
     9e4:	00000097          	auipc	ra,0x0
     9e8:	314080e7          	jalr	788(ra) # cf8 <mount>
     9ec:	00054f63          	bltz	a0,a0a <test4+0x72>
      printf("mount failed\n");
      exit();
  }
  crash("/m/crashf", 1);
     9f0:	4585                	li	a1,1
     9f2:	00001517          	auipc	a0,0x1
     9f6:	ace50513          	addi	a0,a0,-1330 # 14c0 <malloc+0x422>
     9fa:	00000097          	auipc	ra,0x0
     9fe:	2f6080e7          	jalr	758(ra) # cf0 <crash>
}
     a02:	60a2                	ld	ra,8(sp)
     a04:	6402                	ld	s0,0(sp)
     a06:	0141                	addi	sp,sp,16
     a08:	8082                	ret
      printf("mount failed\n");
     a0a:	00000517          	auipc	a0,0x0
     a0e:	7a650513          	addi	a0,a0,1958 # 11b0 <malloc+0x112>
     a12:	00000097          	auipc	ra,0x0
     a16:	5ce080e7          	jalr	1486(ra) # fe0 <printf>
      exit();
     a1a:	00000097          	auipc	ra,0x0
     a1e:	22e080e7          	jalr	558(ra) # c48 <exit>

0000000000000a22 <main>:
{
     a22:	1141                	addi	sp,sp,-16
     a24:	e406                	sd	ra,8(sp)
     a26:	e022                	sd	s0,0(sp)
     a28:	0800                	addi	s0,sp,16
  test0();
     a2a:	fffff097          	auipc	ra,0xfffff
     a2e:	5d6080e7          	jalr	1494(ra) # 0 <test0>
  test1();
     a32:	00000097          	auipc	ra,0x0
     a36:	996080e7          	jalr	-1642(ra) # 3c8 <test1>
  test2();
     a3a:	00000097          	auipc	ra,0x0
     a3e:	c02080e7          	jalr	-1022(ra) # 63c <test2>
  test3();
     a42:	00000097          	auipc	ra,0x0
     a46:	dbe080e7          	jalr	-578(ra) # 800 <test3>
  test4();
     a4a:	00000097          	auipc	ra,0x0
     a4e:	f4e080e7          	jalr	-178(ra) # 998 <test4>
  exit();
     a52:	00000097          	auipc	ra,0x0
     a56:	1f6080e7          	jalr	502(ra) # c48 <exit>

0000000000000a5a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     a5a:	1141                	addi	sp,sp,-16
     a5c:	e422                	sd	s0,8(sp)
     a5e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     a60:	87aa                	mv	a5,a0
     a62:	0585                	addi	a1,a1,1
     a64:	0785                	addi	a5,a5,1
     a66:	fff5c703          	lbu	a4,-1(a1)
     a6a:	fee78fa3          	sb	a4,-1(a5) # fffffffff0000fff <__global_pointer$+0xffffffffeffff316>
     a6e:	fb75                	bnez	a4,a62 <strcpy+0x8>
    ;
  return os;
}
     a70:	6422                	ld	s0,8(sp)
     a72:	0141                	addi	sp,sp,16
     a74:	8082                	ret

0000000000000a76 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     a76:	1141                	addi	sp,sp,-16
     a78:	e422                	sd	s0,8(sp)
     a7a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     a7c:	00054783          	lbu	a5,0(a0)
     a80:	cb91                	beqz	a5,a94 <strcmp+0x1e>
     a82:	0005c703          	lbu	a4,0(a1)
     a86:	00f71763          	bne	a4,a5,a94 <strcmp+0x1e>
    p++, q++;
     a8a:	0505                	addi	a0,a0,1
     a8c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     a8e:	00054783          	lbu	a5,0(a0)
     a92:	fbe5                	bnez	a5,a82 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     a94:	0005c503          	lbu	a0,0(a1)
}
     a98:	40a7853b          	subw	a0,a5,a0
     a9c:	6422                	ld	s0,8(sp)
     a9e:	0141                	addi	sp,sp,16
     aa0:	8082                	ret

0000000000000aa2 <strlen>:

uint
strlen(const char *s)
{
     aa2:	1141                	addi	sp,sp,-16
     aa4:	e422                	sd	s0,8(sp)
     aa6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     aa8:	00054783          	lbu	a5,0(a0)
     aac:	cf91                	beqz	a5,ac8 <strlen+0x26>
     aae:	0505                	addi	a0,a0,1
     ab0:	87aa                	mv	a5,a0
     ab2:	4685                	li	a3,1
     ab4:	9e89                	subw	a3,a3,a0
     ab6:	00f6853b          	addw	a0,a3,a5
     aba:	0785                	addi	a5,a5,1
     abc:	fff7c703          	lbu	a4,-1(a5)
     ac0:	fb7d                	bnez	a4,ab6 <strlen+0x14>
    ;
  return n;
}
     ac2:	6422                	ld	s0,8(sp)
     ac4:	0141                	addi	sp,sp,16
     ac6:	8082                	ret
  for(n = 0; s[n]; n++)
     ac8:	4501                	li	a0,0
     aca:	bfe5                	j	ac2 <strlen+0x20>

0000000000000acc <memset>:

void*
memset(void *dst, int c, uint n)
{
     acc:	1141                	addi	sp,sp,-16
     ace:	e422                	sd	s0,8(sp)
     ad0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     ad2:	ca19                	beqz	a2,ae8 <memset+0x1c>
     ad4:	87aa                	mv	a5,a0
     ad6:	1602                	slli	a2,a2,0x20
     ad8:	9201                	srli	a2,a2,0x20
     ada:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     ade:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     ae2:	0785                	addi	a5,a5,1
     ae4:	fee79de3          	bne	a5,a4,ade <memset+0x12>
  }
  return dst;
}
     ae8:	6422                	ld	s0,8(sp)
     aea:	0141                	addi	sp,sp,16
     aec:	8082                	ret

0000000000000aee <strchr>:

char*
strchr(const char *s, char c)
{
     aee:	1141                	addi	sp,sp,-16
     af0:	e422                	sd	s0,8(sp)
     af2:	0800                	addi	s0,sp,16
  for(; *s; s++)
     af4:	00054783          	lbu	a5,0(a0)
     af8:	cb99                	beqz	a5,b0e <strchr+0x20>
    if(*s == c)
     afa:	00f58763          	beq	a1,a5,b08 <strchr+0x1a>
  for(; *s; s++)
     afe:	0505                	addi	a0,a0,1
     b00:	00054783          	lbu	a5,0(a0)
     b04:	fbfd                	bnez	a5,afa <strchr+0xc>
      return (char*)s;
  return 0;
     b06:	4501                	li	a0,0
}
     b08:	6422                	ld	s0,8(sp)
     b0a:	0141                	addi	sp,sp,16
     b0c:	8082                	ret
  return 0;
     b0e:	4501                	li	a0,0
     b10:	bfe5                	j	b08 <strchr+0x1a>

0000000000000b12 <gets>:

char*
gets(char *buf, int max)
{
     b12:	711d                	addi	sp,sp,-96
     b14:	ec86                	sd	ra,88(sp)
     b16:	e8a2                	sd	s0,80(sp)
     b18:	e4a6                	sd	s1,72(sp)
     b1a:	e0ca                	sd	s2,64(sp)
     b1c:	fc4e                	sd	s3,56(sp)
     b1e:	f852                	sd	s4,48(sp)
     b20:	f456                	sd	s5,40(sp)
     b22:	f05a                	sd	s6,32(sp)
     b24:	ec5e                	sd	s7,24(sp)
     b26:	1080                	addi	s0,sp,96
     b28:	8baa                	mv	s7,a0
     b2a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     b2c:	892a                	mv	s2,a0
     b2e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     b30:	4aa9                	li	s5,10
     b32:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     b34:	89a6                	mv	s3,s1
     b36:	2485                	addiw	s1,s1,1
     b38:	0344d863          	bge	s1,s4,b68 <gets+0x56>
    cc = read(0, &c, 1);
     b3c:	4605                	li	a2,1
     b3e:	faf40593          	addi	a1,s0,-81
     b42:	4501                	li	a0,0
     b44:	00000097          	auipc	ra,0x0
     b48:	11c080e7          	jalr	284(ra) # c60 <read>
    if(cc < 1)
     b4c:	00a05e63          	blez	a0,b68 <gets+0x56>
    buf[i++] = c;
     b50:	faf44783          	lbu	a5,-81(s0)
     b54:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     b58:	01578763          	beq	a5,s5,b66 <gets+0x54>
     b5c:	0905                	addi	s2,s2,1
     b5e:	fd679be3          	bne	a5,s6,b34 <gets+0x22>
  for(i=0; i+1 < max; ){
     b62:	89a6                	mv	s3,s1
     b64:	a011                	j	b68 <gets+0x56>
     b66:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     b68:	99de                	add	s3,s3,s7
     b6a:	00098023          	sb	zero,0(s3)
  return buf;
}
     b6e:	855e                	mv	a0,s7
     b70:	60e6                	ld	ra,88(sp)
     b72:	6446                	ld	s0,80(sp)
     b74:	64a6                	ld	s1,72(sp)
     b76:	6906                	ld	s2,64(sp)
     b78:	79e2                	ld	s3,56(sp)
     b7a:	7a42                	ld	s4,48(sp)
     b7c:	7aa2                	ld	s5,40(sp)
     b7e:	7b02                	ld	s6,32(sp)
     b80:	6be2                	ld	s7,24(sp)
     b82:	6125                	addi	sp,sp,96
     b84:	8082                	ret

0000000000000b86 <stat>:

int
stat(const char *n, struct stat *st)
{
     b86:	1101                	addi	sp,sp,-32
     b88:	ec06                	sd	ra,24(sp)
     b8a:	e822                	sd	s0,16(sp)
     b8c:	e426                	sd	s1,8(sp)
     b8e:	e04a                	sd	s2,0(sp)
     b90:	1000                	addi	s0,sp,32
     b92:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b94:	4581                	li	a1,0
     b96:	00000097          	auipc	ra,0x0
     b9a:	0f2080e7          	jalr	242(ra) # c88 <open>
  if(fd < 0)
     b9e:	02054563          	bltz	a0,bc8 <stat+0x42>
     ba2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     ba4:	85ca                	mv	a1,s2
     ba6:	00000097          	auipc	ra,0x0
     baa:	0fa080e7          	jalr	250(ra) # ca0 <fstat>
     bae:	892a                	mv	s2,a0
  close(fd);
     bb0:	8526                	mv	a0,s1
     bb2:	00000097          	auipc	ra,0x0
     bb6:	0be080e7          	jalr	190(ra) # c70 <close>
  return r;
}
     bba:	854a                	mv	a0,s2
     bbc:	60e2                	ld	ra,24(sp)
     bbe:	6442                	ld	s0,16(sp)
     bc0:	64a2                	ld	s1,8(sp)
     bc2:	6902                	ld	s2,0(sp)
     bc4:	6105                	addi	sp,sp,32
     bc6:	8082                	ret
    return -1;
     bc8:	597d                	li	s2,-1
     bca:	bfc5                	j	bba <stat+0x34>

0000000000000bcc <atoi>:

int
atoi(const char *s)
{
     bcc:	1141                	addi	sp,sp,-16
     bce:	e422                	sd	s0,8(sp)
     bd0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     bd2:	00054603          	lbu	a2,0(a0)
     bd6:	fd06079b          	addiw	a5,a2,-48
     bda:	0ff7f793          	andi	a5,a5,255
     bde:	4725                	li	a4,9
     be0:	02f76963          	bltu	a4,a5,c12 <atoi+0x46>
     be4:	86aa                	mv	a3,a0
  n = 0;
     be6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     be8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     bea:	0685                	addi	a3,a3,1
     bec:	0025179b          	slliw	a5,a0,0x2
     bf0:	9fa9                	addw	a5,a5,a0
     bf2:	0017979b          	slliw	a5,a5,0x1
     bf6:	9fb1                	addw	a5,a5,a2
     bf8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     bfc:	0006c603          	lbu	a2,0(a3)
     c00:	fd06071b          	addiw	a4,a2,-48
     c04:	0ff77713          	andi	a4,a4,255
     c08:	fee5f1e3          	bgeu	a1,a4,bea <atoi+0x1e>
  return n;
}
     c0c:	6422                	ld	s0,8(sp)
     c0e:	0141                	addi	sp,sp,16
     c10:	8082                	ret
  n = 0;
     c12:	4501                	li	a0,0
     c14:	bfe5                	j	c0c <atoi+0x40>

0000000000000c16 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     c16:	1141                	addi	sp,sp,-16
     c18:	e422                	sd	s0,8(sp)
     c1a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     c1c:	00c05f63          	blez	a2,c3a <memmove+0x24>
     c20:	1602                	slli	a2,a2,0x20
     c22:	9201                	srli	a2,a2,0x20
     c24:	00c506b3          	add	a3,a0,a2
  dst = vdst;
     c28:	87aa                	mv	a5,a0
    *dst++ = *src++;
     c2a:	0585                	addi	a1,a1,1
     c2c:	0785                	addi	a5,a5,1
     c2e:	fff5c703          	lbu	a4,-1(a1)
     c32:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
     c36:	fed79ae3          	bne	a5,a3,c2a <memmove+0x14>
  return vdst;
}
     c3a:	6422                	ld	s0,8(sp)
     c3c:	0141                	addi	sp,sp,16
     c3e:	8082                	ret

0000000000000c40 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c40:	4885                	li	a7,1
 ecall
     c42:	00000073          	ecall
 ret
     c46:	8082                	ret

0000000000000c48 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c48:	4889                	li	a7,2
 ecall
     c4a:	00000073          	ecall
 ret
     c4e:	8082                	ret

0000000000000c50 <wait>:
.global wait
wait:
 li a7, SYS_wait
     c50:	488d                	li	a7,3
 ecall
     c52:	00000073          	ecall
 ret
     c56:	8082                	ret

0000000000000c58 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c58:	4891                	li	a7,4
 ecall
     c5a:	00000073          	ecall
 ret
     c5e:	8082                	ret

0000000000000c60 <read>:
.global read
read:
 li a7, SYS_read
     c60:	4895                	li	a7,5
 ecall
     c62:	00000073          	ecall
 ret
     c66:	8082                	ret

0000000000000c68 <write>:
.global write
write:
 li a7, SYS_write
     c68:	48c1                	li	a7,16
 ecall
     c6a:	00000073          	ecall
 ret
     c6e:	8082                	ret

0000000000000c70 <close>:
.global close
close:
 li a7, SYS_close
     c70:	48d5                	li	a7,21
 ecall
     c72:	00000073          	ecall
 ret
     c76:	8082                	ret

0000000000000c78 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c78:	4899                	li	a7,6
 ecall
     c7a:	00000073          	ecall
 ret
     c7e:	8082                	ret

0000000000000c80 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c80:	489d                	li	a7,7
 ecall
     c82:	00000073          	ecall
 ret
     c86:	8082                	ret

0000000000000c88 <open>:
.global open
open:
 li a7, SYS_open
     c88:	48bd                	li	a7,15
 ecall
     c8a:	00000073          	ecall
 ret
     c8e:	8082                	ret

0000000000000c90 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c90:	48c5                	li	a7,17
 ecall
     c92:	00000073          	ecall
 ret
     c96:	8082                	ret

0000000000000c98 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c98:	48c9                	li	a7,18
 ecall
     c9a:	00000073          	ecall
 ret
     c9e:	8082                	ret

0000000000000ca0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ca0:	48a1                	li	a7,8
 ecall
     ca2:	00000073          	ecall
 ret
     ca6:	8082                	ret

0000000000000ca8 <link>:
.global link
link:
 li a7, SYS_link
     ca8:	48cd                	li	a7,19
 ecall
     caa:	00000073          	ecall
 ret
     cae:	8082                	ret

0000000000000cb0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     cb0:	48d1                	li	a7,20
 ecall
     cb2:	00000073          	ecall
 ret
     cb6:	8082                	ret

0000000000000cb8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     cb8:	48a5                	li	a7,9
 ecall
     cba:	00000073          	ecall
 ret
     cbe:	8082                	ret

0000000000000cc0 <dup>:
.global dup
dup:
 li a7, SYS_dup
     cc0:	48a9                	li	a7,10
 ecall
     cc2:	00000073          	ecall
 ret
     cc6:	8082                	ret

0000000000000cc8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     cc8:	48ad                	li	a7,11
 ecall
     cca:	00000073          	ecall
 ret
     cce:	8082                	ret

0000000000000cd0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     cd0:	48b1                	li	a7,12
 ecall
     cd2:	00000073          	ecall
 ret
     cd6:	8082                	ret

0000000000000cd8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     cd8:	48b5                	li	a7,13
 ecall
     cda:	00000073          	ecall
 ret
     cde:	8082                	ret

0000000000000ce0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ce0:	48b9                	li	a7,14
 ecall
     ce2:	00000073          	ecall
 ret
     ce6:	8082                	ret

0000000000000ce8 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
     ce8:	48d9                	li	a7,22
 ecall
     cea:	00000073          	ecall
 ret
     cee:	8082                	ret

0000000000000cf0 <crash>:
.global crash
crash:
 li a7, SYS_crash
     cf0:	48dd                	li	a7,23
 ecall
     cf2:	00000073          	ecall
 ret
     cf6:	8082                	ret

0000000000000cf8 <mount>:
.global mount
mount:
 li a7, SYS_mount
     cf8:	48e1                	li	a7,24
 ecall
     cfa:	00000073          	ecall
 ret
     cfe:	8082                	ret

0000000000000d00 <umount>:
.global umount
umount:
 li a7, SYS_umount
     d00:	48e5                	li	a7,25
 ecall
     d02:	00000073          	ecall
 ret
     d06:	8082                	ret

0000000000000d08 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d08:	1101                	addi	sp,sp,-32
     d0a:	ec06                	sd	ra,24(sp)
     d0c:	e822                	sd	s0,16(sp)
     d0e:	1000                	addi	s0,sp,32
     d10:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d14:	4605                	li	a2,1
     d16:	fef40593          	addi	a1,s0,-17
     d1a:	00000097          	auipc	ra,0x0
     d1e:	f4e080e7          	jalr	-178(ra) # c68 <write>
}
     d22:	60e2                	ld	ra,24(sp)
     d24:	6442                	ld	s0,16(sp)
     d26:	6105                	addi	sp,sp,32
     d28:	8082                	ret

0000000000000d2a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     d2a:	7139                	addi	sp,sp,-64
     d2c:	fc06                	sd	ra,56(sp)
     d2e:	f822                	sd	s0,48(sp)
     d30:	f426                	sd	s1,40(sp)
     d32:	f04a                	sd	s2,32(sp)
     d34:	ec4e                	sd	s3,24(sp)
     d36:	0080                	addi	s0,sp,64
     d38:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d3a:	c299                	beqz	a3,d40 <printint+0x16>
     d3c:	0805c863          	bltz	a1,dcc <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     d40:	2581                	sext.w	a1,a1
  neg = 0;
     d42:	4881                	li	a7,0
     d44:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     d48:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d4a:	2601                	sext.w	a2,a2
     d4c:	00000517          	auipc	a0,0x0
     d50:	78c50513          	addi	a0,a0,1932 # 14d8 <digits>
     d54:	883a                	mv	a6,a4
     d56:	2705                	addiw	a4,a4,1
     d58:	02c5f7bb          	remuw	a5,a1,a2
     d5c:	1782                	slli	a5,a5,0x20
     d5e:	9381                	srli	a5,a5,0x20
     d60:	97aa                	add	a5,a5,a0
     d62:	0007c783          	lbu	a5,0(a5)
     d66:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d6a:	0005879b          	sext.w	a5,a1
     d6e:	02c5d5bb          	divuw	a1,a1,a2
     d72:	0685                	addi	a3,a3,1
     d74:	fec7f0e3          	bgeu	a5,a2,d54 <printint+0x2a>
  if(neg)
     d78:	00088b63          	beqz	a7,d8e <printint+0x64>
    buf[i++] = '-';
     d7c:	fd040793          	addi	a5,s0,-48
     d80:	973e                	add	a4,a4,a5
     d82:	02d00793          	li	a5,45
     d86:	fef70823          	sb	a5,-16(a4)
     d8a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     d8e:	02e05863          	blez	a4,dbe <printint+0x94>
     d92:	fc040793          	addi	a5,s0,-64
     d96:	00e78933          	add	s2,a5,a4
     d9a:	fff78993          	addi	s3,a5,-1
     d9e:	99ba                	add	s3,s3,a4
     da0:	377d                	addiw	a4,a4,-1
     da2:	1702                	slli	a4,a4,0x20
     da4:	9301                	srli	a4,a4,0x20
     da6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     daa:	fff94583          	lbu	a1,-1(s2)
     dae:	8526                	mv	a0,s1
     db0:	00000097          	auipc	ra,0x0
     db4:	f58080e7          	jalr	-168(ra) # d08 <putc>
  while(--i >= 0)
     db8:	197d                	addi	s2,s2,-1
     dba:	ff3918e3          	bne	s2,s3,daa <printint+0x80>
}
     dbe:	70e2                	ld	ra,56(sp)
     dc0:	7442                	ld	s0,48(sp)
     dc2:	74a2                	ld	s1,40(sp)
     dc4:	7902                	ld	s2,32(sp)
     dc6:	69e2                	ld	s3,24(sp)
     dc8:	6121                	addi	sp,sp,64
     dca:	8082                	ret
    x = -xx;
     dcc:	40b005bb          	negw	a1,a1
    neg = 1;
     dd0:	4885                	li	a7,1
    x = -xx;
     dd2:	bf8d                	j	d44 <printint+0x1a>

0000000000000dd4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     dd4:	7119                	addi	sp,sp,-128
     dd6:	fc86                	sd	ra,120(sp)
     dd8:	f8a2                	sd	s0,112(sp)
     dda:	f4a6                	sd	s1,104(sp)
     ddc:	f0ca                	sd	s2,96(sp)
     dde:	ecce                	sd	s3,88(sp)
     de0:	e8d2                	sd	s4,80(sp)
     de2:	e4d6                	sd	s5,72(sp)
     de4:	e0da                	sd	s6,64(sp)
     de6:	fc5e                	sd	s7,56(sp)
     de8:	f862                	sd	s8,48(sp)
     dea:	f466                	sd	s9,40(sp)
     dec:	f06a                	sd	s10,32(sp)
     dee:	ec6e                	sd	s11,24(sp)
     df0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     df2:	0005c903          	lbu	s2,0(a1)
     df6:	18090f63          	beqz	s2,f94 <vprintf+0x1c0>
     dfa:	8aaa                	mv	s5,a0
     dfc:	8b32                	mv	s6,a2
     dfe:	00158493          	addi	s1,a1,1
  state = 0;
     e02:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     e04:	02500a13          	li	s4,37
      if(c == 'd'){
     e08:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     e0c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     e10:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     e14:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e18:	00000b97          	auipc	s7,0x0
     e1c:	6c0b8b93          	addi	s7,s7,1728 # 14d8 <digits>
     e20:	a839                	j	e3e <vprintf+0x6a>
        putc(fd, c);
     e22:	85ca                	mv	a1,s2
     e24:	8556                	mv	a0,s5
     e26:	00000097          	auipc	ra,0x0
     e2a:	ee2080e7          	jalr	-286(ra) # d08 <putc>
     e2e:	a019                	j	e34 <vprintf+0x60>
    } else if(state == '%'){
     e30:	01498f63          	beq	s3,s4,e4e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     e34:	0485                	addi	s1,s1,1
     e36:	fff4c903          	lbu	s2,-1(s1)
     e3a:	14090d63          	beqz	s2,f94 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     e3e:	0009079b          	sext.w	a5,s2
    if(state == 0){
     e42:	fe0997e3          	bnez	s3,e30 <vprintf+0x5c>
      if(c == '%'){
     e46:	fd479ee3          	bne	a5,s4,e22 <vprintf+0x4e>
        state = '%';
     e4a:	89be                	mv	s3,a5
     e4c:	b7e5                	j	e34 <vprintf+0x60>
      if(c == 'd'){
     e4e:	05878063          	beq	a5,s8,e8e <vprintf+0xba>
      } else if(c == 'l') {
     e52:	05978c63          	beq	a5,s9,eaa <vprintf+0xd6>
      } else if(c == 'x') {
     e56:	07a78863          	beq	a5,s10,ec6 <vprintf+0xf2>
      } else if(c == 'p') {
     e5a:	09b78463          	beq	a5,s11,ee2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     e5e:	07300713          	li	a4,115
     e62:	0ce78663          	beq	a5,a4,f2e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     e66:	06300713          	li	a4,99
     e6a:	0ee78e63          	beq	a5,a4,f66 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     e6e:	11478863          	beq	a5,s4,f7e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     e72:	85d2                	mv	a1,s4
     e74:	8556                	mv	a0,s5
     e76:	00000097          	auipc	ra,0x0
     e7a:	e92080e7          	jalr	-366(ra) # d08 <putc>
        putc(fd, c);
     e7e:	85ca                	mv	a1,s2
     e80:	8556                	mv	a0,s5
     e82:	00000097          	auipc	ra,0x0
     e86:	e86080e7          	jalr	-378(ra) # d08 <putc>
      }
      state = 0;
     e8a:	4981                	li	s3,0
     e8c:	b765                	j	e34 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     e8e:	008b0913          	addi	s2,s6,8
     e92:	4685                	li	a3,1
     e94:	4629                	li	a2,10
     e96:	000b2583          	lw	a1,0(s6)
     e9a:	8556                	mv	a0,s5
     e9c:	00000097          	auipc	ra,0x0
     ea0:	e8e080e7          	jalr	-370(ra) # d2a <printint>
     ea4:	8b4a                	mv	s6,s2
      state = 0;
     ea6:	4981                	li	s3,0
     ea8:	b771                	j	e34 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     eaa:	008b0913          	addi	s2,s6,8
     eae:	4681                	li	a3,0
     eb0:	4629                	li	a2,10
     eb2:	000b2583          	lw	a1,0(s6)
     eb6:	8556                	mv	a0,s5
     eb8:	00000097          	auipc	ra,0x0
     ebc:	e72080e7          	jalr	-398(ra) # d2a <printint>
     ec0:	8b4a                	mv	s6,s2
      state = 0;
     ec2:	4981                	li	s3,0
     ec4:	bf85                	j	e34 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     ec6:	008b0913          	addi	s2,s6,8
     eca:	4681                	li	a3,0
     ecc:	4641                	li	a2,16
     ece:	000b2583          	lw	a1,0(s6)
     ed2:	8556                	mv	a0,s5
     ed4:	00000097          	auipc	ra,0x0
     ed8:	e56080e7          	jalr	-426(ra) # d2a <printint>
     edc:	8b4a                	mv	s6,s2
      state = 0;
     ede:	4981                	li	s3,0
     ee0:	bf91                	j	e34 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     ee2:	008b0793          	addi	a5,s6,8
     ee6:	f8f43423          	sd	a5,-120(s0)
     eea:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     eee:	03000593          	li	a1,48
     ef2:	8556                	mv	a0,s5
     ef4:	00000097          	auipc	ra,0x0
     ef8:	e14080e7          	jalr	-492(ra) # d08 <putc>
  putc(fd, 'x');
     efc:	85ea                	mv	a1,s10
     efe:	8556                	mv	a0,s5
     f00:	00000097          	auipc	ra,0x0
     f04:	e08080e7          	jalr	-504(ra) # d08 <putc>
     f08:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f0a:	03c9d793          	srli	a5,s3,0x3c
     f0e:	97de                	add	a5,a5,s7
     f10:	0007c583          	lbu	a1,0(a5)
     f14:	8556                	mv	a0,s5
     f16:	00000097          	auipc	ra,0x0
     f1a:	df2080e7          	jalr	-526(ra) # d08 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f1e:	0992                	slli	s3,s3,0x4
     f20:	397d                	addiw	s2,s2,-1
     f22:	fe0914e3          	bnez	s2,f0a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
     f26:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     f2a:	4981                	li	s3,0
     f2c:	b721                	j	e34 <vprintf+0x60>
        s = va_arg(ap, char*);
     f2e:	008b0993          	addi	s3,s6,8
     f32:	000b3903          	ld	s2,0(s6)
        if(s == 0)
     f36:	02090163          	beqz	s2,f58 <vprintf+0x184>
        while(*s != 0){
     f3a:	00094583          	lbu	a1,0(s2)
     f3e:	c9a1                	beqz	a1,f8e <vprintf+0x1ba>
          putc(fd, *s);
     f40:	8556                	mv	a0,s5
     f42:	00000097          	auipc	ra,0x0
     f46:	dc6080e7          	jalr	-570(ra) # d08 <putc>
          s++;
     f4a:	0905                	addi	s2,s2,1
        while(*s != 0){
     f4c:	00094583          	lbu	a1,0(s2)
     f50:	f9e5                	bnez	a1,f40 <vprintf+0x16c>
        s = va_arg(ap, char*);
     f52:	8b4e                	mv	s6,s3
      state = 0;
     f54:	4981                	li	s3,0
     f56:	bdf9                	j	e34 <vprintf+0x60>
          s = "(null)";
     f58:	00000917          	auipc	s2,0x0
     f5c:	57890913          	addi	s2,s2,1400 # 14d0 <malloc+0x432>
        while(*s != 0){
     f60:	02800593          	li	a1,40
     f64:	bff1                	j	f40 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
     f66:	008b0913          	addi	s2,s6,8
     f6a:	000b4583          	lbu	a1,0(s6)
     f6e:	8556                	mv	a0,s5
     f70:	00000097          	auipc	ra,0x0
     f74:	d98080e7          	jalr	-616(ra) # d08 <putc>
     f78:	8b4a                	mv	s6,s2
      state = 0;
     f7a:	4981                	li	s3,0
     f7c:	bd65                	j	e34 <vprintf+0x60>
        putc(fd, c);
     f7e:	85d2                	mv	a1,s4
     f80:	8556                	mv	a0,s5
     f82:	00000097          	auipc	ra,0x0
     f86:	d86080e7          	jalr	-634(ra) # d08 <putc>
      state = 0;
     f8a:	4981                	li	s3,0
     f8c:	b565                	j	e34 <vprintf+0x60>
        s = va_arg(ap, char*);
     f8e:	8b4e                	mv	s6,s3
      state = 0;
     f90:	4981                	li	s3,0
     f92:	b54d                	j	e34 <vprintf+0x60>
    }
  }
}
     f94:	70e6                	ld	ra,120(sp)
     f96:	7446                	ld	s0,112(sp)
     f98:	74a6                	ld	s1,104(sp)
     f9a:	7906                	ld	s2,96(sp)
     f9c:	69e6                	ld	s3,88(sp)
     f9e:	6a46                	ld	s4,80(sp)
     fa0:	6aa6                	ld	s5,72(sp)
     fa2:	6b06                	ld	s6,64(sp)
     fa4:	7be2                	ld	s7,56(sp)
     fa6:	7c42                	ld	s8,48(sp)
     fa8:	7ca2                	ld	s9,40(sp)
     faa:	7d02                	ld	s10,32(sp)
     fac:	6de2                	ld	s11,24(sp)
     fae:	6109                	addi	sp,sp,128
     fb0:	8082                	ret

0000000000000fb2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     fb2:	715d                	addi	sp,sp,-80
     fb4:	ec06                	sd	ra,24(sp)
     fb6:	e822                	sd	s0,16(sp)
     fb8:	1000                	addi	s0,sp,32
     fba:	e010                	sd	a2,0(s0)
     fbc:	e414                	sd	a3,8(s0)
     fbe:	e818                	sd	a4,16(s0)
     fc0:	ec1c                	sd	a5,24(s0)
     fc2:	03043023          	sd	a6,32(s0)
     fc6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     fca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     fce:	8622                	mv	a2,s0
     fd0:	00000097          	auipc	ra,0x0
     fd4:	e04080e7          	jalr	-508(ra) # dd4 <vprintf>
}
     fd8:	60e2                	ld	ra,24(sp)
     fda:	6442                	ld	s0,16(sp)
     fdc:	6161                	addi	sp,sp,80
     fde:	8082                	ret

0000000000000fe0 <printf>:

void
printf(const char *fmt, ...)
{
     fe0:	711d                	addi	sp,sp,-96
     fe2:	ec06                	sd	ra,24(sp)
     fe4:	e822                	sd	s0,16(sp)
     fe6:	1000                	addi	s0,sp,32
     fe8:	e40c                	sd	a1,8(s0)
     fea:	e810                	sd	a2,16(s0)
     fec:	ec14                	sd	a3,24(s0)
     fee:	f018                	sd	a4,32(s0)
     ff0:	f41c                	sd	a5,40(s0)
     ff2:	03043823          	sd	a6,48(s0)
     ff6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     ffa:	00840613          	addi	a2,s0,8
     ffe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1002:	85aa                	mv	a1,a0
    1004:	4505                	li	a0,1
    1006:	00000097          	auipc	ra,0x0
    100a:	dce080e7          	jalr	-562(ra) # dd4 <vprintf>
}
    100e:	60e2                	ld	ra,24(sp)
    1010:	6442                	ld	s0,16(sp)
    1012:	6125                	addi	sp,sp,96
    1014:	8082                	ret

0000000000001016 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1016:	1141                	addi	sp,sp,-16
    1018:	e422                	sd	s0,8(sp)
    101a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    101c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1020:	00000797          	auipc	a5,0x0
    1024:	4d07b783          	ld	a5,1232(a5) # 14f0 <freep>
    1028:	a805                	j	1058 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    102a:	4618                	lw	a4,8(a2)
    102c:	9db9                	addw	a1,a1,a4
    102e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1032:	6398                	ld	a4,0(a5)
    1034:	6318                	ld	a4,0(a4)
    1036:	fee53823          	sd	a4,-16(a0)
    103a:	a091                	j	107e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    103c:	ff852703          	lw	a4,-8(a0)
    1040:	9e39                	addw	a2,a2,a4
    1042:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1044:	ff053703          	ld	a4,-16(a0)
    1048:	e398                	sd	a4,0(a5)
    104a:	a099                	j	1090 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    104c:	6398                	ld	a4,0(a5)
    104e:	00e7e463          	bltu	a5,a4,1056 <free+0x40>
    1052:	00e6ea63          	bltu	a3,a4,1066 <free+0x50>
{
    1056:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1058:	fed7fae3          	bgeu	a5,a3,104c <free+0x36>
    105c:	6398                	ld	a4,0(a5)
    105e:	00e6e463          	bltu	a3,a4,1066 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1062:	fee7eae3          	bltu	a5,a4,1056 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1066:	ff852583          	lw	a1,-8(a0)
    106a:	6390                	ld	a2,0(a5)
    106c:	02059813          	slli	a6,a1,0x20
    1070:	01c85713          	srli	a4,a6,0x1c
    1074:	9736                	add	a4,a4,a3
    1076:	fae60ae3          	beq	a2,a4,102a <free+0x14>
    bp->s.ptr = p->s.ptr;
    107a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    107e:	4790                	lw	a2,8(a5)
    1080:	02061593          	slli	a1,a2,0x20
    1084:	01c5d713          	srli	a4,a1,0x1c
    1088:	973e                	add	a4,a4,a5
    108a:	fae689e3          	beq	a3,a4,103c <free+0x26>
  } else
    p->s.ptr = bp;
    108e:	e394                	sd	a3,0(a5)
  freep = p;
    1090:	00000717          	auipc	a4,0x0
    1094:	46f73023          	sd	a5,1120(a4) # 14f0 <freep>
}
    1098:	6422                	ld	s0,8(sp)
    109a:	0141                	addi	sp,sp,16
    109c:	8082                	ret

000000000000109e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    109e:	7139                	addi	sp,sp,-64
    10a0:	fc06                	sd	ra,56(sp)
    10a2:	f822                	sd	s0,48(sp)
    10a4:	f426                	sd	s1,40(sp)
    10a6:	f04a                	sd	s2,32(sp)
    10a8:	ec4e                	sd	s3,24(sp)
    10aa:	e852                	sd	s4,16(sp)
    10ac:	e456                	sd	s5,8(sp)
    10ae:	e05a                	sd	s6,0(sp)
    10b0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10b2:	02051493          	slli	s1,a0,0x20
    10b6:	9081                	srli	s1,s1,0x20
    10b8:	04bd                	addi	s1,s1,15
    10ba:	8091                	srli	s1,s1,0x4
    10bc:	0014899b          	addiw	s3,s1,1
    10c0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    10c2:	00000517          	auipc	a0,0x0
    10c6:	42e53503          	ld	a0,1070(a0) # 14f0 <freep>
    10ca:	c515                	beqz	a0,10f6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10ce:	4798                	lw	a4,8(a5)
    10d0:	02977f63          	bgeu	a4,s1,110e <malloc+0x70>
    10d4:	8a4e                	mv	s4,s3
    10d6:	0009871b          	sext.w	a4,s3
    10da:	6685                	lui	a3,0x1
    10dc:	00d77363          	bgeu	a4,a3,10e2 <malloc+0x44>
    10e0:	6a05                	lui	s4,0x1
    10e2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    10e6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    10ea:	00000917          	auipc	s2,0x0
    10ee:	40690913          	addi	s2,s2,1030 # 14f0 <freep>
  if(p == (char*)-1)
    10f2:	5afd                	li	s5,-1
    10f4:	a895                	j	1168 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    10f6:	00000797          	auipc	a5,0x0
    10fa:	40278793          	addi	a5,a5,1026 # 14f8 <base>
    10fe:	00000717          	auipc	a4,0x0
    1102:	3ef73923          	sd	a5,1010(a4) # 14f0 <freep>
    1106:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1108:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    110c:	b7e1                	j	10d4 <malloc+0x36>
      if(p->s.size == nunits)
    110e:	02e48c63          	beq	s1,a4,1146 <malloc+0xa8>
        p->s.size -= nunits;
    1112:	4137073b          	subw	a4,a4,s3
    1116:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1118:	02071693          	slli	a3,a4,0x20
    111c:	01c6d713          	srli	a4,a3,0x1c
    1120:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1122:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1126:	00000717          	auipc	a4,0x0
    112a:	3ca73523          	sd	a0,970(a4) # 14f0 <freep>
      return (void*)(p + 1);
    112e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1132:	70e2                	ld	ra,56(sp)
    1134:	7442                	ld	s0,48(sp)
    1136:	74a2                	ld	s1,40(sp)
    1138:	7902                	ld	s2,32(sp)
    113a:	69e2                	ld	s3,24(sp)
    113c:	6a42                	ld	s4,16(sp)
    113e:	6aa2                	ld	s5,8(sp)
    1140:	6b02                	ld	s6,0(sp)
    1142:	6121                	addi	sp,sp,64
    1144:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1146:	6398                	ld	a4,0(a5)
    1148:	e118                	sd	a4,0(a0)
    114a:	bff1                	j	1126 <malloc+0x88>
  hp->s.size = nu;
    114c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1150:	0541                	addi	a0,a0,16
    1152:	00000097          	auipc	ra,0x0
    1156:	ec4080e7          	jalr	-316(ra) # 1016 <free>
  return freep;
    115a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    115e:	d971                	beqz	a0,1132 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1160:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1162:	4798                	lw	a4,8(a5)
    1164:	fa9775e3          	bgeu	a4,s1,110e <malloc+0x70>
    if(p == freep)
    1168:	00093703          	ld	a4,0(s2)
    116c:	853e                	mv	a0,a5
    116e:	fef719e3          	bne	a4,a5,1160 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    1172:	8552                	mv	a0,s4
    1174:	00000097          	auipc	ra,0x0
    1178:	b5c080e7          	jalr	-1188(ra) # cd0 <sbrk>
  if(p == (char*)-1)
    117c:	fd5518e3          	bne	a0,s5,114c <malloc+0xae>
        return 0;
    1180:	4501                	li	a0,0
    1182:	bf45                	j	1132 <malloc+0x94>
