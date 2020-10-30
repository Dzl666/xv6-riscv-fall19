
user/_cow：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:
// allocate more than half of physical memory,
// then fork. this will fail in the default
// kernel, which does not support copy-on-write.
void
simpletest()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = (phys_size / 3) * 2;

  printf("simple: ");
   e:	00001517          	auipc	a0,0x1
  12:	be250513          	addi	a0,a0,-1054 # bf0 <malloc+0xe8>
  16:	00001097          	auipc	ra,0x1
  1a:	a34080e7          	jalr	-1484(ra) # a4a <printf>
  
  char *p = sbrk(sz);
  1e:	05555537          	lui	a0,0x5555
  22:	55450513          	addi	a0,a0,1364 # 5555554 <__BSS_END__+0x5550814>
  26:	00000097          	auipc	ra,0x0
  2a:	714080e7          	jalr	1812(ra) # 73a <sbrk>
  if(p == (char*)0xffffffffffffffffL){
  2e:	57fd                	li	a5,-1
  30:	06f50463          	beq	a0,a5,98 <simpletest+0x98>
  34:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit();
  }

  for(char *q = p; q < p + sz; q += 4096){
  36:	05556937          	lui	s2,0x5556
  3a:	992a                	add	s2,s2,a0
  3c:	6985                	lui	s3,0x1
    *(int*)q = getpid();
  3e:	00000097          	auipc	ra,0x0
  42:	6f4080e7          	jalr	1780(ra) # 732 <getpid>
  46:	c088                	sw	a0,0(s1)
  for(char *q = p; q < p + sz; q += 4096){
  48:	94ce                	add	s1,s1,s3
  4a:	fe991ae3          	bne	s2,s1,3e <simpletest+0x3e>
  }

  int pid = fork();
  4e:	00000097          	auipc	ra,0x0
  52:	65c080e7          	jalr	1628(ra) # 6aa <fork>
  if(pid < 0){
  56:	06054163          	bltz	a0,b8 <simpletest+0xb8>
    printf("fork() failed\n");
    exit();
  }

  if(pid == 0)
  5a:	c93d                	beqz	a0,d0 <simpletest+0xd0>
    exit();

  wait();
  5c:	00000097          	auipc	ra,0x0
  60:	65e080e7          	jalr	1630(ra) # 6ba <wait>

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
  64:	faaab537          	lui	a0,0xfaaab
  68:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <__BSS_END__+0xfffffffffaaa5d6c>
  6c:	00000097          	auipc	ra,0x0
  70:	6ce080e7          	jalr	1742(ra) # 73a <sbrk>
  74:	57fd                	li	a5,-1
  76:	06f50163          	beq	a0,a5,d8 <simpletest+0xd8>
    printf("sbrk(-%d) failed\n", sz);
    exit();
  }

  printf("ok\n");
  7a:	00001517          	auipc	a0,0x1
  7e:	bc650513          	addi	a0,a0,-1082 # c40 <malloc+0x138>
  82:	00001097          	auipc	ra,0x1
  86:	9c8080e7          	jalr	-1592(ra) # a4a <printf>
}
  8a:	70a2                	ld	ra,40(sp)
  8c:	7402                	ld	s0,32(sp)
  8e:	64e2                	ld	s1,24(sp)
  90:	6942                	ld	s2,16(sp)
  92:	69a2                	ld	s3,8(sp)
  94:	6145                	addi	sp,sp,48
  96:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  98:	055555b7          	lui	a1,0x5555
  9c:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x5550814>
  a0:	00001517          	auipc	a0,0x1
  a4:	b6050513          	addi	a0,a0,-1184 # c00 <malloc+0xf8>
  a8:	00001097          	auipc	ra,0x1
  ac:	9a2080e7          	jalr	-1630(ra) # a4a <printf>
    exit();
  b0:	00000097          	auipc	ra,0x0
  b4:	602080e7          	jalr	1538(ra) # 6b2 <exit>
    printf("fork() failed\n");
  b8:	00001517          	auipc	a0,0x1
  bc:	b6050513          	addi	a0,a0,-1184 # c18 <malloc+0x110>
  c0:	00001097          	auipc	ra,0x1
  c4:	98a080e7          	jalr	-1654(ra) # a4a <printf>
    exit();
  c8:	00000097          	auipc	ra,0x0
  cc:	5ea080e7          	jalr	1514(ra) # 6b2 <exit>
    exit();
  d0:	00000097          	auipc	ra,0x0
  d4:	5e2080e7          	jalr	1506(ra) # 6b2 <exit>
    printf("sbrk(-%d) failed\n", sz);
  d8:	055555b7          	lui	a1,0x5555
  dc:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x5550814>
  e0:	00001517          	auipc	a0,0x1
  e4:	b4850513          	addi	a0,a0,-1208 # c28 <malloc+0x120>
  e8:	00001097          	auipc	ra,0x1
  ec:	962080e7          	jalr	-1694(ra) # a4a <printf>
    exit();
  f0:	00000097          	auipc	ra,0x0
  f4:	5c2080e7          	jalr	1474(ra) # 6b2 <exit>

00000000000000f8 <threetest>:
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void
threetest()
{
  f8:	7179                	addi	sp,sp,-48
  fa:	f406                	sd	ra,40(sp)
  fc:	f022                	sd	s0,32(sp)
  fe:	ec26                	sd	s1,24(sp)
 100:	e84a                	sd	s2,16(sp)
 102:	e44e                	sd	s3,8(sp)
 104:	e052                	sd	s4,0(sp)
 106:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;

  printf("three: ");
 108:	00001517          	auipc	a0,0x1
 10c:	b4050513          	addi	a0,a0,-1216 # c48 <malloc+0x140>
 110:	00001097          	auipc	ra,0x1
 114:	93a080e7          	jalr	-1734(ra) # a4a <printf>
  
  char *p = sbrk(sz);
 118:	02000537          	lui	a0,0x2000
 11c:	00000097          	auipc	ra,0x0
 120:	61e080e7          	jalr	1566(ra) # 73a <sbrk>
  if(p == (char*)0xffffffffffffffffL){
 124:	57fd                	li	a5,-1
 126:	08f50663          	beq	a0,a5,1b2 <threetest+0xba>
 12a:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit();
  }

  pid1 = fork();
 12c:	00000097          	auipc	ra,0x0
 130:	57e080e7          	jalr	1406(ra) # 6aa <fork>
  if(pid1 < 0){
 134:	08054d63          	bltz	a0,1ce <threetest+0xd6>
    printf("fork failed\n");
    exit();
  }
  if(pid1 == 0){
 138:	c55d                	beqz	a0,1e6 <threetest+0xee>
      *(int*)q = 9999;
    }
    exit();
  }

  for(char *q = p; q < p + sz; q += 4096){
 13a:	020009b7          	lui	s3,0x2000
 13e:	99a6                	add	s3,s3,s1
 140:	8926                	mv	s2,s1
 142:	6a05                	lui	s4,0x1
    *(int*)q = getpid();
 144:	00000097          	auipc	ra,0x0
 148:	5ee080e7          	jalr	1518(ra) # 732 <getpid>
 14c:	00a92023          	sw	a0,0(s2) # 5556000 <__BSS_END__+0x55512c0>
  for(char *q = p; q < p + sz; q += 4096){
 150:	9952                	add	s2,s2,s4
 152:	ff3919e3          	bne	s2,s3,144 <threetest+0x4c>
  }

  wait();
 156:	00000097          	auipc	ra,0x0
 15a:	564080e7          	jalr	1380(ra) # 6ba <wait>

  sleep(1);
 15e:	4505                	li	a0,1
 160:	00000097          	auipc	ra,0x0
 164:	5e2080e7          	jalr	1506(ra) # 742 <sleep>

  for(char *q = p; q < p + sz; q += 4096){
 168:	6a05                	lui	s4,0x1
    if(*(int*)q != getpid()){
 16a:	0004a903          	lw	s2,0(s1)
 16e:	00000097          	auipc	ra,0x0
 172:	5c4080e7          	jalr	1476(ra) # 732 <getpid>
 176:	10a91463          	bne	s2,a0,27e <threetest+0x186>
  for(char *q = p; q < p + sz; q += 4096){
 17a:	94d2                	add	s1,s1,s4
 17c:	ff3497e3          	bne	s1,s3,16a <threetest+0x72>
      printf("wrong content\n");
      exit();
    }
  }

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
 180:	fe000537          	lui	a0,0xfe000
 184:	00000097          	auipc	ra,0x0
 188:	5b6080e7          	jalr	1462(ra) # 73a <sbrk>
 18c:	57fd                	li	a5,-1
 18e:	10f50463          	beq	a0,a5,296 <threetest+0x19e>
    printf("sbrk(-%d) failed\n", sz);
    exit();
  }

  printf("ok\n");
 192:	00001517          	auipc	a0,0x1
 196:	aae50513          	addi	a0,a0,-1362 # c40 <malloc+0x138>
 19a:	00001097          	auipc	ra,0x1
 19e:	8b0080e7          	jalr	-1872(ra) # a4a <printf>
}
 1a2:	70a2                	ld	ra,40(sp)
 1a4:	7402                	ld	s0,32(sp)
 1a6:	64e2                	ld	s1,24(sp)
 1a8:	6942                	ld	s2,16(sp)
 1aa:	69a2                	ld	s3,8(sp)
 1ac:	6a02                	ld	s4,0(sp)
 1ae:	6145                	addi	sp,sp,48
 1b0:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 1b2:	020005b7          	lui	a1,0x2000
 1b6:	00001517          	auipc	a0,0x1
 1ba:	a4a50513          	addi	a0,a0,-1462 # c00 <malloc+0xf8>
 1be:	00001097          	auipc	ra,0x1
 1c2:	88c080e7          	jalr	-1908(ra) # a4a <printf>
    exit();
 1c6:	00000097          	auipc	ra,0x0
 1ca:	4ec080e7          	jalr	1260(ra) # 6b2 <exit>
    printf("fork failed\n");
 1ce:	00001517          	auipc	a0,0x1
 1d2:	a8250513          	addi	a0,a0,-1406 # c50 <malloc+0x148>
 1d6:	00001097          	auipc	ra,0x1
 1da:	874080e7          	jalr	-1932(ra) # a4a <printf>
    exit();
 1de:	00000097          	auipc	ra,0x0
 1e2:	4d4080e7          	jalr	1236(ra) # 6b2 <exit>
    pid2 = fork();
 1e6:	00000097          	auipc	ra,0x0
 1ea:	4c4080e7          	jalr	1220(ra) # 6aa <fork>
    if(pid2 < 0){
 1ee:	04054163          	bltz	a0,230 <threetest+0x138>
    if(pid2 == 0){
 1f2:	e939                	bnez	a0,248 <threetest+0x150>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 1f4:	0199a9b7          	lui	s3,0x199a
 1f8:	99a6                	add	s3,s3,s1
 1fa:	8926                	mv	s2,s1
 1fc:	6a05                	lui	s4,0x1
        *(int*)q = getpid();
 1fe:	00000097          	auipc	ra,0x0
 202:	534080e7          	jalr	1332(ra) # 732 <getpid>
 206:	00a92023          	sw	a0,0(s2)
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 20a:	9952                	add	s2,s2,s4
 20c:	ff2999e3          	bne	s3,s2,1fe <threetest+0x106>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 210:	6a05                	lui	s4,0x1
        if(*(int*)q != getpid()){
 212:	0004a903          	lw	s2,0(s1)
 216:	00000097          	auipc	ra,0x0
 21a:	51c080e7          	jalr	1308(ra) # 732 <getpid>
 21e:	04a91463          	bne	s2,a0,266 <threetest+0x16e>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 222:	94d2                	add	s1,s1,s4
 224:	fe9997e3          	bne	s3,s1,212 <threetest+0x11a>
      exit();
 228:	00000097          	auipc	ra,0x0
 22c:	48a080e7          	jalr	1162(ra) # 6b2 <exit>
      printf("fork failed");
 230:	00001517          	auipc	a0,0x1
 234:	a3050513          	addi	a0,a0,-1488 # c60 <malloc+0x158>
 238:	00001097          	auipc	ra,0x1
 23c:	812080e7          	jalr	-2030(ra) # a4a <printf>
      exit();
 240:	00000097          	auipc	ra,0x0
 244:	472080e7          	jalr	1138(ra) # 6b2 <exit>
    for(char *q = p; q < p + (sz/2); q += 4096){
 248:	01000737          	lui	a4,0x1000
 24c:	9726                	add	a4,a4,s1
      *(int*)q = 9999;
 24e:	6789                	lui	a5,0x2
 250:	70f78793          	addi	a5,a5,1807 # 270f <buf+0x9df>
    for(char *q = p; q < p + (sz/2); q += 4096){
 254:	6685                	lui	a3,0x1
      *(int*)q = 9999;
 256:	c09c                	sw	a5,0(s1)
    for(char *q = p; q < p + (sz/2); q += 4096){
 258:	94b6                	add	s1,s1,a3
 25a:	fee49ee3          	bne	s1,a4,256 <threetest+0x15e>
    exit();
 25e:	00000097          	auipc	ra,0x0
 262:	454080e7          	jalr	1108(ra) # 6b2 <exit>
          printf("wrong content\n");
 266:	00001517          	auipc	a0,0x1
 26a:	a0a50513          	addi	a0,a0,-1526 # c70 <malloc+0x168>
 26e:	00000097          	auipc	ra,0x0
 272:	7dc080e7          	jalr	2012(ra) # a4a <printf>
          exit();
 276:	00000097          	auipc	ra,0x0
 27a:	43c080e7          	jalr	1084(ra) # 6b2 <exit>
      printf("wrong content\n");
 27e:	00001517          	auipc	a0,0x1
 282:	9f250513          	addi	a0,a0,-1550 # c70 <malloc+0x168>
 286:	00000097          	auipc	ra,0x0
 28a:	7c4080e7          	jalr	1988(ra) # a4a <printf>
      exit();
 28e:	00000097          	auipc	ra,0x0
 292:	424080e7          	jalr	1060(ra) # 6b2 <exit>
    printf("sbrk(-%d) failed\n", sz);
 296:	020005b7          	lui	a1,0x2000
 29a:	00001517          	auipc	a0,0x1
 29e:	98e50513          	addi	a0,a0,-1650 # c28 <malloc+0x120>
 2a2:	00000097          	auipc	ra,0x0
 2a6:	7a8080e7          	jalr	1960(ra) # a4a <printf>
    exit();
 2aa:	00000097          	auipc	ra,0x0
 2ae:	408080e7          	jalr	1032(ra) # 6b2 <exit>

00000000000002b2 <filetest>:
char junk3[4096];

// test whether copyout() simulates COW faults.
void
filetest()
{
 2b2:	7139                	addi	sp,sp,-64
 2b4:	fc06                	sd	ra,56(sp)
 2b6:	f822                	sd	s0,48(sp)
 2b8:	f426                	sd	s1,40(sp)
 2ba:	f04a                	sd	s2,32(sp)
 2bc:	ec4e                	sd	s3,24(sp)
 2be:	0080                	addi	s0,sp,64
  int parent = getpid();
 2c0:	00000097          	auipc	ra,0x0
 2c4:	472080e7          	jalr	1138(ra) # 732 <getpid>
 2c8:	89aa                	mv	s3,a0
  
  printf("file: ");
 2ca:	00001517          	auipc	a0,0x1
 2ce:	9b650513          	addi	a0,a0,-1610 # c80 <malloc+0x178>
 2d2:	00000097          	auipc	ra,0x0
 2d6:	778080e7          	jalr	1912(ra) # a4a <printf>
  
  buf[0] = 99;
 2da:	06300793          	li	a5,99
 2de:	00002717          	auipc	a4,0x2
 2e2:	a4f70923          	sb	a5,-1454(a4) # 1d30 <buf>

  for(int i = 0; i < 4; i++){
 2e6:	fc042623          	sw	zero,-52(s0)
    if(pipe(fds) != 0){
 2ea:	00001497          	auipc	s1,0x1
 2ee:	a3648493          	addi	s1,s1,-1482 # d20 <fds>
  for(int i = 0; i < 4; i++){
 2f2:	490d                	li	s2,3
    if(pipe(fds) != 0){
 2f4:	8526                	mv	a0,s1
 2f6:	00000097          	auipc	ra,0x0
 2fa:	3cc080e7          	jalr	972(ra) # 6c2 <pipe>
 2fe:	e159                	bnez	a0,384 <filetest+0xd2>
      printf("pipe() failed\n");
      exit();
    }
    int pid = fork();
 300:	00000097          	auipc	ra,0x0
 304:	3aa080e7          	jalr	938(ra) # 6aa <fork>
    if(pid < 0){
 308:	08054a63          	bltz	a0,39c <filetest+0xea>
      printf("fork failed\n");
      exit();
    }
    if(pid == 0){
 30c:	c545                	beqz	a0,3b4 <filetest+0x102>
        kill(parent);
        exit();
      }
      exit();
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
 30e:	4611                	li	a2,4
 310:	fcc40593          	addi	a1,s0,-52
 314:	40c8                	lw	a0,4(s1)
 316:	00000097          	auipc	ra,0x0
 31a:	3bc080e7          	jalr	956(ra) # 6d2 <write>
 31e:	4791                	li	a5,4
 320:	12f51263          	bne	a0,a5,444 <filetest+0x192>
  for(int i = 0; i < 4; i++){
 324:	fcc42783          	lw	a5,-52(s0)
 328:	2785                	addiw	a5,a5,1
 32a:	0007871b          	sext.w	a4,a5
 32e:	fcf42623          	sw	a5,-52(s0)
 332:	fce951e3          	bge	s2,a4,2f4 <filetest+0x42>
      exit();
    }
  }

  for(int i = 0; i < 4; i++)
    wait();
 336:	00000097          	auipc	ra,0x0
 33a:	384080e7          	jalr	900(ra) # 6ba <wait>
 33e:	00000097          	auipc	ra,0x0
 342:	37c080e7          	jalr	892(ra) # 6ba <wait>
 346:	00000097          	auipc	ra,0x0
 34a:	374080e7          	jalr	884(ra) # 6ba <wait>
 34e:	00000097          	auipc	ra,0x0
 352:	36c080e7          	jalr	876(ra) # 6ba <wait>

  if(buf[0] != 99){
 356:	00002717          	auipc	a4,0x2
 35a:	9da74703          	lbu	a4,-1574(a4) # 1d30 <buf>
 35e:	06300793          	li	a5,99
 362:	0ef71d63          	bne	a4,a5,45c <filetest+0x1aa>
    printf("child overwrote parent\n");
    exit();
  }

  printf("ok\n");
 366:	00001517          	auipc	a0,0x1
 36a:	8da50513          	addi	a0,a0,-1830 # c40 <malloc+0x138>
 36e:	00000097          	auipc	ra,0x0
 372:	6dc080e7          	jalr	1756(ra) # a4a <printf>
}
 376:	70e2                	ld	ra,56(sp)
 378:	7442                	ld	s0,48(sp)
 37a:	74a2                	ld	s1,40(sp)
 37c:	7902                	ld	s2,32(sp)
 37e:	69e2                	ld	s3,24(sp)
 380:	6121                	addi	sp,sp,64
 382:	8082                	ret
      printf("pipe() failed\n");
 384:	00001517          	auipc	a0,0x1
 388:	90450513          	addi	a0,a0,-1788 # c88 <malloc+0x180>
 38c:	00000097          	auipc	ra,0x0
 390:	6be080e7          	jalr	1726(ra) # a4a <printf>
      exit();
 394:	00000097          	auipc	ra,0x0
 398:	31e080e7          	jalr	798(ra) # 6b2 <exit>
      printf("fork failed\n");
 39c:	00001517          	auipc	a0,0x1
 3a0:	8b450513          	addi	a0,a0,-1868 # c50 <malloc+0x148>
 3a4:	00000097          	auipc	ra,0x0
 3a8:	6a6080e7          	jalr	1702(ra) # a4a <printf>
      exit();
 3ac:	00000097          	auipc	ra,0x0
 3b0:	306080e7          	jalr	774(ra) # 6b2 <exit>
      sleep(1);
 3b4:	4505                	li	a0,1
 3b6:	00000097          	auipc	ra,0x0
 3ba:	38c080e7          	jalr	908(ra) # 742 <sleep>
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
 3be:	4611                	li	a2,4
 3c0:	00002597          	auipc	a1,0x2
 3c4:	97058593          	addi	a1,a1,-1680 # 1d30 <buf>
 3c8:	00001517          	auipc	a0,0x1
 3cc:	95852503          	lw	a0,-1704(a0) # d20 <fds>
 3d0:	00000097          	auipc	ra,0x0
 3d4:	2fa080e7          	jalr	762(ra) # 6ca <read>
 3d8:	4791                	li	a5,4
 3da:	04f51063          	bne	a0,a5,41a <filetest+0x168>
      sleep(1);
 3de:	4505                	li	a0,1
 3e0:	00000097          	auipc	ra,0x0
 3e4:	362080e7          	jalr	866(ra) # 742 <sleep>
      if(j != i){
 3e8:	fcc42703          	lw	a4,-52(s0)
 3ec:	00002797          	auipc	a5,0x2
 3f0:	9447a783          	lw	a5,-1724(a5) # 1d30 <buf>
 3f4:	04f70463          	beq	a4,a5,43c <filetest+0x18a>
        printf("read the wrong value\n");
 3f8:	00001517          	auipc	a0,0x1
 3fc:	8b050513          	addi	a0,a0,-1872 # ca8 <malloc+0x1a0>
 400:	00000097          	auipc	ra,0x0
 404:	64a080e7          	jalr	1610(ra) # a4a <printf>
        kill(parent);
 408:	854e                	mv	a0,s3
 40a:	00000097          	auipc	ra,0x0
 40e:	2d8080e7          	jalr	728(ra) # 6e2 <kill>
        exit();
 412:	00000097          	auipc	ra,0x0
 416:	2a0080e7          	jalr	672(ra) # 6b2 <exit>
        printf("read failed\n");
 41a:	00001517          	auipc	a0,0x1
 41e:	87e50513          	addi	a0,a0,-1922 # c98 <malloc+0x190>
 422:	00000097          	auipc	ra,0x0
 426:	628080e7          	jalr	1576(ra) # a4a <printf>
        kill(parent);
 42a:	854e                	mv	a0,s3
 42c:	00000097          	auipc	ra,0x0
 430:	2b6080e7          	jalr	694(ra) # 6e2 <kill>
        exit();
 434:	00000097          	auipc	ra,0x0
 438:	27e080e7          	jalr	638(ra) # 6b2 <exit>
      exit();
 43c:	00000097          	auipc	ra,0x0
 440:	276080e7          	jalr	630(ra) # 6b2 <exit>
      printf("write failed\n");
 444:	00001517          	auipc	a0,0x1
 448:	87c50513          	addi	a0,a0,-1924 # cc0 <malloc+0x1b8>
 44c:	00000097          	auipc	ra,0x0
 450:	5fe080e7          	jalr	1534(ra) # a4a <printf>
      exit();
 454:	00000097          	auipc	ra,0x0
 458:	25e080e7          	jalr	606(ra) # 6b2 <exit>
    printf("child overwrote parent\n");
 45c:	00001517          	auipc	a0,0x1
 460:	87450513          	addi	a0,a0,-1932 # cd0 <malloc+0x1c8>
 464:	00000097          	auipc	ra,0x0
 468:	5e6080e7          	jalr	1510(ra) # a4a <printf>
    exit();
 46c:	00000097          	auipc	ra,0x0
 470:	246080e7          	jalr	582(ra) # 6b2 <exit>

0000000000000474 <main>:

int
main(int argc, char *argv[])
{
 474:	1141                	addi	sp,sp,-16
 476:	e406                	sd	ra,8(sp)
 478:	e022                	sd	s0,0(sp)
 47a:	0800                	addi	s0,sp,16
  simpletest();
 47c:	00000097          	auipc	ra,0x0
 480:	b84080e7          	jalr	-1148(ra) # 0 <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 484:	00000097          	auipc	ra,0x0
 488:	b7c080e7          	jalr	-1156(ra) # 0 <simpletest>

  threetest();
 48c:	00000097          	auipc	ra,0x0
 490:	c6c080e7          	jalr	-916(ra) # f8 <threetest>
  threetest();
 494:	00000097          	auipc	ra,0x0
 498:	c64080e7          	jalr	-924(ra) # f8 <threetest>
  threetest();
 49c:	00000097          	auipc	ra,0x0
 4a0:	c5c080e7          	jalr	-932(ra) # f8 <threetest>

  filetest();
 4a4:	00000097          	auipc	ra,0x0
 4a8:	e0e080e7          	jalr	-498(ra) # 2b2 <filetest>

  printf("ALL COW TESTS PASSED\n");
 4ac:	00001517          	auipc	a0,0x1
 4b0:	83c50513          	addi	a0,a0,-1988 # ce8 <malloc+0x1e0>
 4b4:	00000097          	auipc	ra,0x0
 4b8:	596080e7          	jalr	1430(ra) # a4a <printf>

  exit();
 4bc:	00000097          	auipc	ra,0x0
 4c0:	1f6080e7          	jalr	502(ra) # 6b2 <exit>

00000000000004c4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 4c4:	1141                	addi	sp,sp,-16
 4c6:	e422                	sd	s0,8(sp)
 4c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4ca:	87aa                	mv	a5,a0
 4cc:	0585                	addi	a1,a1,1
 4ce:	0785                	addi	a5,a5,1
 4d0:	fff5c703          	lbu	a4,-1(a1)
 4d4:	fee78fa3          	sb	a4,-1(a5)
 4d8:	fb75                	bnez	a4,4cc <strcpy+0x8>
    ;
  return os;
}
 4da:	6422                	ld	s0,8(sp)
 4dc:	0141                	addi	sp,sp,16
 4de:	8082                	ret

00000000000004e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4e0:	1141                	addi	sp,sp,-16
 4e2:	e422                	sd	s0,8(sp)
 4e4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4e6:	00054783          	lbu	a5,0(a0)
 4ea:	cb91                	beqz	a5,4fe <strcmp+0x1e>
 4ec:	0005c703          	lbu	a4,0(a1)
 4f0:	00f71763          	bne	a4,a5,4fe <strcmp+0x1e>
    p++, q++;
 4f4:	0505                	addi	a0,a0,1
 4f6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4f8:	00054783          	lbu	a5,0(a0)
 4fc:	fbe5                	bnez	a5,4ec <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4fe:	0005c503          	lbu	a0,0(a1)
}
 502:	40a7853b          	subw	a0,a5,a0
 506:	6422                	ld	s0,8(sp)
 508:	0141                	addi	sp,sp,16
 50a:	8082                	ret

000000000000050c <strlen>:

uint
strlen(const char *s)
{
 50c:	1141                	addi	sp,sp,-16
 50e:	e422                	sd	s0,8(sp)
 510:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 512:	00054783          	lbu	a5,0(a0)
 516:	cf91                	beqz	a5,532 <strlen+0x26>
 518:	0505                	addi	a0,a0,1
 51a:	87aa                	mv	a5,a0
 51c:	4685                	li	a3,1
 51e:	9e89                	subw	a3,a3,a0
 520:	00f6853b          	addw	a0,a3,a5
 524:	0785                	addi	a5,a5,1
 526:	fff7c703          	lbu	a4,-1(a5)
 52a:	fb7d                	bnez	a4,520 <strlen+0x14>
    ;
  return n;
}
 52c:	6422                	ld	s0,8(sp)
 52e:	0141                	addi	sp,sp,16
 530:	8082                	ret
  for(n = 0; s[n]; n++)
 532:	4501                	li	a0,0
 534:	bfe5                	j	52c <strlen+0x20>

0000000000000536 <memset>:

void*
memset(void *dst, int c, uint n)
{
 536:	1141                	addi	sp,sp,-16
 538:	e422                	sd	s0,8(sp)
 53a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 53c:	ca19                	beqz	a2,552 <memset+0x1c>
 53e:	87aa                	mv	a5,a0
 540:	1602                	slli	a2,a2,0x20
 542:	9201                	srli	a2,a2,0x20
 544:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 548:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 54c:	0785                	addi	a5,a5,1
 54e:	fee79de3          	bne	a5,a4,548 <memset+0x12>
  }
  return dst;
}
 552:	6422                	ld	s0,8(sp)
 554:	0141                	addi	sp,sp,16
 556:	8082                	ret

0000000000000558 <strchr>:

char*
strchr(const char *s, char c)
{
 558:	1141                	addi	sp,sp,-16
 55a:	e422                	sd	s0,8(sp)
 55c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 55e:	00054783          	lbu	a5,0(a0)
 562:	cb99                	beqz	a5,578 <strchr+0x20>
    if(*s == c)
 564:	00f58763          	beq	a1,a5,572 <strchr+0x1a>
  for(; *s; s++)
 568:	0505                	addi	a0,a0,1
 56a:	00054783          	lbu	a5,0(a0)
 56e:	fbfd                	bnez	a5,564 <strchr+0xc>
      return (char*)s;
  return 0;
 570:	4501                	li	a0,0
}
 572:	6422                	ld	s0,8(sp)
 574:	0141                	addi	sp,sp,16
 576:	8082                	ret
  return 0;
 578:	4501                	li	a0,0
 57a:	bfe5                	j	572 <strchr+0x1a>

000000000000057c <gets>:

char*
gets(char *buf, int max)
{
 57c:	711d                	addi	sp,sp,-96
 57e:	ec86                	sd	ra,88(sp)
 580:	e8a2                	sd	s0,80(sp)
 582:	e4a6                	sd	s1,72(sp)
 584:	e0ca                	sd	s2,64(sp)
 586:	fc4e                	sd	s3,56(sp)
 588:	f852                	sd	s4,48(sp)
 58a:	f456                	sd	s5,40(sp)
 58c:	f05a                	sd	s6,32(sp)
 58e:	ec5e                	sd	s7,24(sp)
 590:	1080                	addi	s0,sp,96
 592:	8baa                	mv	s7,a0
 594:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 596:	892a                	mv	s2,a0
 598:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 59a:	4aa9                	li	s5,10
 59c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 59e:	89a6                	mv	s3,s1
 5a0:	2485                	addiw	s1,s1,1
 5a2:	0344d863          	bge	s1,s4,5d2 <gets+0x56>
    cc = read(0, &c, 1);
 5a6:	4605                	li	a2,1
 5a8:	faf40593          	addi	a1,s0,-81
 5ac:	4501                	li	a0,0
 5ae:	00000097          	auipc	ra,0x0
 5b2:	11c080e7          	jalr	284(ra) # 6ca <read>
    if(cc < 1)
 5b6:	00a05e63          	blez	a0,5d2 <gets+0x56>
    buf[i++] = c;
 5ba:	faf44783          	lbu	a5,-81(s0)
 5be:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5c2:	01578763          	beq	a5,s5,5d0 <gets+0x54>
 5c6:	0905                	addi	s2,s2,1
 5c8:	fd679be3          	bne	a5,s6,59e <gets+0x22>
  for(i=0; i+1 < max; ){
 5cc:	89a6                	mv	s3,s1
 5ce:	a011                	j	5d2 <gets+0x56>
 5d0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5d2:	99de                	add	s3,s3,s7
 5d4:	00098023          	sb	zero,0(s3) # 199a000 <__BSS_END__+0x19952c0>
  return buf;
}
 5d8:	855e                	mv	a0,s7
 5da:	60e6                	ld	ra,88(sp)
 5dc:	6446                	ld	s0,80(sp)
 5de:	64a6                	ld	s1,72(sp)
 5e0:	6906                	ld	s2,64(sp)
 5e2:	79e2                	ld	s3,56(sp)
 5e4:	7a42                	ld	s4,48(sp)
 5e6:	7aa2                	ld	s5,40(sp)
 5e8:	7b02                	ld	s6,32(sp)
 5ea:	6be2                	ld	s7,24(sp)
 5ec:	6125                	addi	sp,sp,96
 5ee:	8082                	ret

00000000000005f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 5f0:	1101                	addi	sp,sp,-32
 5f2:	ec06                	sd	ra,24(sp)
 5f4:	e822                	sd	s0,16(sp)
 5f6:	e426                	sd	s1,8(sp)
 5f8:	e04a                	sd	s2,0(sp)
 5fa:	1000                	addi	s0,sp,32
 5fc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5fe:	4581                	li	a1,0
 600:	00000097          	auipc	ra,0x0
 604:	0f2080e7          	jalr	242(ra) # 6f2 <open>
  if(fd < 0)
 608:	02054563          	bltz	a0,632 <stat+0x42>
 60c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 60e:	85ca                	mv	a1,s2
 610:	00000097          	auipc	ra,0x0
 614:	0fa080e7          	jalr	250(ra) # 70a <fstat>
 618:	892a                	mv	s2,a0
  close(fd);
 61a:	8526                	mv	a0,s1
 61c:	00000097          	auipc	ra,0x0
 620:	0be080e7          	jalr	190(ra) # 6da <close>
  return r;
}
 624:	854a                	mv	a0,s2
 626:	60e2                	ld	ra,24(sp)
 628:	6442                	ld	s0,16(sp)
 62a:	64a2                	ld	s1,8(sp)
 62c:	6902                	ld	s2,0(sp)
 62e:	6105                	addi	sp,sp,32
 630:	8082                	ret
    return -1;
 632:	597d                	li	s2,-1
 634:	bfc5                	j	624 <stat+0x34>

0000000000000636 <atoi>:

int
atoi(const char *s)
{
 636:	1141                	addi	sp,sp,-16
 638:	e422                	sd	s0,8(sp)
 63a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 63c:	00054603          	lbu	a2,0(a0)
 640:	fd06079b          	addiw	a5,a2,-48
 644:	0ff7f793          	andi	a5,a5,255
 648:	4725                	li	a4,9
 64a:	02f76963          	bltu	a4,a5,67c <atoi+0x46>
 64e:	86aa                	mv	a3,a0
  n = 0;
 650:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 652:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 654:	0685                	addi	a3,a3,1
 656:	0025179b          	slliw	a5,a0,0x2
 65a:	9fa9                	addw	a5,a5,a0
 65c:	0017979b          	slliw	a5,a5,0x1
 660:	9fb1                	addw	a5,a5,a2
 662:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 666:	0006c603          	lbu	a2,0(a3) # 1000 <junk3+0x2d0>
 66a:	fd06071b          	addiw	a4,a2,-48
 66e:	0ff77713          	andi	a4,a4,255
 672:	fee5f1e3          	bgeu	a1,a4,654 <atoi+0x1e>
  return n;
}
 676:	6422                	ld	s0,8(sp)
 678:	0141                	addi	sp,sp,16
 67a:	8082                	ret
  n = 0;
 67c:	4501                	li	a0,0
 67e:	bfe5                	j	676 <atoi+0x40>

0000000000000680 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 680:	1141                	addi	sp,sp,-16
 682:	e422                	sd	s0,8(sp)
 684:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 686:	00c05f63          	blez	a2,6a4 <memmove+0x24>
 68a:	1602                	slli	a2,a2,0x20
 68c:	9201                	srli	a2,a2,0x20
 68e:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 692:	87aa                	mv	a5,a0
    *dst++ = *src++;
 694:	0585                	addi	a1,a1,1
 696:	0785                	addi	a5,a5,1
 698:	fff5c703          	lbu	a4,-1(a1)
 69c:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 6a0:	fed79ae3          	bne	a5,a3,694 <memmove+0x14>
  return vdst;
}
 6a4:	6422                	ld	s0,8(sp)
 6a6:	0141                	addi	sp,sp,16
 6a8:	8082                	ret

00000000000006aa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6aa:	4885                	li	a7,1
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	8082                	ret

00000000000006b2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6b2:	4889                	li	a7,2
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <wait>:
.global wait
wait:
 li a7, SYS_wait
 6ba:	488d                	li	a7,3
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6c2:	4891                	li	a7,4
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <read>:
.global read
read:
 li a7, SYS_read
 6ca:	4895                	li	a7,5
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <write>:
.global write
write:
 li a7, SYS_write
 6d2:	48c1                	li	a7,16
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <close>:
.global close
close:
 li a7, SYS_close
 6da:	48d5                	li	a7,21
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 6e2:	4899                	li	a7,6
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <exec>:
.global exec
exec:
 li a7, SYS_exec
 6ea:	489d                	li	a7,7
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <open>:
.global open
open:
 li a7, SYS_open
 6f2:	48bd                	li	a7,15
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6fa:	48c5                	li	a7,17
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 702:	48c9                	li	a7,18
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 70a:	48a1                	li	a7,8
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <link>:
.global link
link:
 li a7, SYS_link
 712:	48cd                	li	a7,19
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 71a:	48d1                	li	a7,20
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 722:	48a5                	li	a7,9
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <dup>:
.global dup
dup:
 li a7, SYS_dup
 72a:	48a9                	li	a7,10
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 732:	48ad                	li	a7,11
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 73a:	48b1                	li	a7,12
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 742:	48b5                	li	a7,13
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 74a:	48b9                	li	a7,14
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 752:	48d9                	li	a7,22
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <crash>:
.global crash
crash:
 li a7, SYS_crash
 75a:	48dd                	li	a7,23
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <mount>:
.global mount
mount:
 li a7, SYS_mount
 762:	48e1                	li	a7,24
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <umount>:
.global umount
umount:
 li a7, SYS_umount
 76a:	48e5                	li	a7,25
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 772:	1101                	addi	sp,sp,-32
 774:	ec06                	sd	ra,24(sp)
 776:	e822                	sd	s0,16(sp)
 778:	1000                	addi	s0,sp,32
 77a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 77e:	4605                	li	a2,1
 780:	fef40593          	addi	a1,s0,-17
 784:	00000097          	auipc	ra,0x0
 788:	f4e080e7          	jalr	-178(ra) # 6d2 <write>
}
 78c:	60e2                	ld	ra,24(sp)
 78e:	6442                	ld	s0,16(sp)
 790:	6105                	addi	sp,sp,32
 792:	8082                	ret

0000000000000794 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 794:	7139                	addi	sp,sp,-64
 796:	fc06                	sd	ra,56(sp)
 798:	f822                	sd	s0,48(sp)
 79a:	f426                	sd	s1,40(sp)
 79c:	f04a                	sd	s2,32(sp)
 79e:	ec4e                	sd	s3,24(sp)
 7a0:	0080                	addi	s0,sp,64
 7a2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7a4:	c299                	beqz	a3,7aa <printint+0x16>
 7a6:	0805c863          	bltz	a1,836 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7aa:	2581                	sext.w	a1,a1
  neg = 0;
 7ac:	4881                	li	a7,0
 7ae:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7b2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7b4:	2601                	sext.w	a2,a2
 7b6:	00000517          	auipc	a0,0x0
 7ba:	55250513          	addi	a0,a0,1362 # d08 <digits>
 7be:	883a                	mv	a6,a4
 7c0:	2705                	addiw	a4,a4,1
 7c2:	02c5f7bb          	remuw	a5,a1,a2
 7c6:	1782                	slli	a5,a5,0x20
 7c8:	9381                	srli	a5,a5,0x20
 7ca:	97aa                	add	a5,a5,a0
 7cc:	0007c783          	lbu	a5,0(a5)
 7d0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7d4:	0005879b          	sext.w	a5,a1
 7d8:	02c5d5bb          	divuw	a1,a1,a2
 7dc:	0685                	addi	a3,a3,1
 7de:	fec7f0e3          	bgeu	a5,a2,7be <printint+0x2a>
  if(neg)
 7e2:	00088b63          	beqz	a7,7f8 <printint+0x64>
    buf[i++] = '-';
 7e6:	fd040793          	addi	a5,s0,-48
 7ea:	973e                	add	a4,a4,a5
 7ec:	02d00793          	li	a5,45
 7f0:	fef70823          	sb	a5,-16(a4)
 7f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 7f8:	02e05863          	blez	a4,828 <printint+0x94>
 7fc:	fc040793          	addi	a5,s0,-64
 800:	00e78933          	add	s2,a5,a4
 804:	fff78993          	addi	s3,a5,-1
 808:	99ba                	add	s3,s3,a4
 80a:	377d                	addiw	a4,a4,-1
 80c:	1702                	slli	a4,a4,0x20
 80e:	9301                	srli	a4,a4,0x20
 810:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 814:	fff94583          	lbu	a1,-1(s2)
 818:	8526                	mv	a0,s1
 81a:	00000097          	auipc	ra,0x0
 81e:	f58080e7          	jalr	-168(ra) # 772 <putc>
  while(--i >= 0)
 822:	197d                	addi	s2,s2,-1
 824:	ff3918e3          	bne	s2,s3,814 <printint+0x80>
}
 828:	70e2                	ld	ra,56(sp)
 82a:	7442                	ld	s0,48(sp)
 82c:	74a2                	ld	s1,40(sp)
 82e:	7902                	ld	s2,32(sp)
 830:	69e2                	ld	s3,24(sp)
 832:	6121                	addi	sp,sp,64
 834:	8082                	ret
    x = -xx;
 836:	40b005bb          	negw	a1,a1
    neg = 1;
 83a:	4885                	li	a7,1
    x = -xx;
 83c:	bf8d                	j	7ae <printint+0x1a>

000000000000083e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 83e:	7119                	addi	sp,sp,-128
 840:	fc86                	sd	ra,120(sp)
 842:	f8a2                	sd	s0,112(sp)
 844:	f4a6                	sd	s1,104(sp)
 846:	f0ca                	sd	s2,96(sp)
 848:	ecce                	sd	s3,88(sp)
 84a:	e8d2                	sd	s4,80(sp)
 84c:	e4d6                	sd	s5,72(sp)
 84e:	e0da                	sd	s6,64(sp)
 850:	fc5e                	sd	s7,56(sp)
 852:	f862                	sd	s8,48(sp)
 854:	f466                	sd	s9,40(sp)
 856:	f06a                	sd	s10,32(sp)
 858:	ec6e                	sd	s11,24(sp)
 85a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 85c:	0005c903          	lbu	s2,0(a1)
 860:	18090f63          	beqz	s2,9fe <vprintf+0x1c0>
 864:	8aaa                	mv	s5,a0
 866:	8b32                	mv	s6,a2
 868:	00158493          	addi	s1,a1,1
  state = 0;
 86c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 86e:	02500a13          	li	s4,37
      if(c == 'd'){
 872:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 876:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 87a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 87e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 882:	00000b97          	auipc	s7,0x0
 886:	486b8b93          	addi	s7,s7,1158 # d08 <digits>
 88a:	a839                	j	8a8 <vprintf+0x6a>
        putc(fd, c);
 88c:	85ca                	mv	a1,s2
 88e:	8556                	mv	a0,s5
 890:	00000097          	auipc	ra,0x0
 894:	ee2080e7          	jalr	-286(ra) # 772 <putc>
 898:	a019                	j	89e <vprintf+0x60>
    } else if(state == '%'){
 89a:	01498f63          	beq	s3,s4,8b8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 89e:	0485                	addi	s1,s1,1
 8a0:	fff4c903          	lbu	s2,-1(s1)
 8a4:	14090d63          	beqz	s2,9fe <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 8a8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8ac:	fe0997e3          	bnez	s3,89a <vprintf+0x5c>
      if(c == '%'){
 8b0:	fd479ee3          	bne	a5,s4,88c <vprintf+0x4e>
        state = '%';
 8b4:	89be                	mv	s3,a5
 8b6:	b7e5                	j	89e <vprintf+0x60>
      if(c == 'd'){
 8b8:	05878063          	beq	a5,s8,8f8 <vprintf+0xba>
      } else if(c == 'l') {
 8bc:	05978c63          	beq	a5,s9,914 <vprintf+0xd6>
      } else if(c == 'x') {
 8c0:	07a78863          	beq	a5,s10,930 <vprintf+0xf2>
      } else if(c == 'p') {
 8c4:	09b78463          	beq	a5,s11,94c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 8c8:	07300713          	li	a4,115
 8cc:	0ce78663          	beq	a5,a4,998 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8d0:	06300713          	li	a4,99
 8d4:	0ee78e63          	beq	a5,a4,9d0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 8d8:	11478863          	beq	a5,s4,9e8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8dc:	85d2                	mv	a1,s4
 8de:	8556                	mv	a0,s5
 8e0:	00000097          	auipc	ra,0x0
 8e4:	e92080e7          	jalr	-366(ra) # 772 <putc>
        putc(fd, c);
 8e8:	85ca                	mv	a1,s2
 8ea:	8556                	mv	a0,s5
 8ec:	00000097          	auipc	ra,0x0
 8f0:	e86080e7          	jalr	-378(ra) # 772 <putc>
      }
      state = 0;
 8f4:	4981                	li	s3,0
 8f6:	b765                	j	89e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 8f8:	008b0913          	addi	s2,s6,8
 8fc:	4685                	li	a3,1
 8fe:	4629                	li	a2,10
 900:	000b2583          	lw	a1,0(s6)
 904:	8556                	mv	a0,s5
 906:	00000097          	auipc	ra,0x0
 90a:	e8e080e7          	jalr	-370(ra) # 794 <printint>
 90e:	8b4a                	mv	s6,s2
      state = 0;
 910:	4981                	li	s3,0
 912:	b771                	j	89e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 914:	008b0913          	addi	s2,s6,8
 918:	4681                	li	a3,0
 91a:	4629                	li	a2,10
 91c:	000b2583          	lw	a1,0(s6)
 920:	8556                	mv	a0,s5
 922:	00000097          	auipc	ra,0x0
 926:	e72080e7          	jalr	-398(ra) # 794 <printint>
 92a:	8b4a                	mv	s6,s2
      state = 0;
 92c:	4981                	li	s3,0
 92e:	bf85                	j	89e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 930:	008b0913          	addi	s2,s6,8
 934:	4681                	li	a3,0
 936:	4641                	li	a2,16
 938:	000b2583          	lw	a1,0(s6)
 93c:	8556                	mv	a0,s5
 93e:	00000097          	auipc	ra,0x0
 942:	e56080e7          	jalr	-426(ra) # 794 <printint>
 946:	8b4a                	mv	s6,s2
      state = 0;
 948:	4981                	li	s3,0
 94a:	bf91                	j	89e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 94c:	008b0793          	addi	a5,s6,8
 950:	f8f43423          	sd	a5,-120(s0)
 954:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 958:	03000593          	li	a1,48
 95c:	8556                	mv	a0,s5
 95e:	00000097          	auipc	ra,0x0
 962:	e14080e7          	jalr	-492(ra) # 772 <putc>
  putc(fd, 'x');
 966:	85ea                	mv	a1,s10
 968:	8556                	mv	a0,s5
 96a:	00000097          	auipc	ra,0x0
 96e:	e08080e7          	jalr	-504(ra) # 772 <putc>
 972:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 974:	03c9d793          	srli	a5,s3,0x3c
 978:	97de                	add	a5,a5,s7
 97a:	0007c583          	lbu	a1,0(a5)
 97e:	8556                	mv	a0,s5
 980:	00000097          	auipc	ra,0x0
 984:	df2080e7          	jalr	-526(ra) # 772 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 988:	0992                	slli	s3,s3,0x4
 98a:	397d                	addiw	s2,s2,-1
 98c:	fe0914e3          	bnez	s2,974 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 990:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 994:	4981                	li	s3,0
 996:	b721                	j	89e <vprintf+0x60>
        s = va_arg(ap, char*);
 998:	008b0993          	addi	s3,s6,8
 99c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 9a0:	02090163          	beqz	s2,9c2 <vprintf+0x184>
        while(*s != 0){
 9a4:	00094583          	lbu	a1,0(s2)
 9a8:	c9a1                	beqz	a1,9f8 <vprintf+0x1ba>
          putc(fd, *s);
 9aa:	8556                	mv	a0,s5
 9ac:	00000097          	auipc	ra,0x0
 9b0:	dc6080e7          	jalr	-570(ra) # 772 <putc>
          s++;
 9b4:	0905                	addi	s2,s2,1
        while(*s != 0){
 9b6:	00094583          	lbu	a1,0(s2)
 9ba:	f9e5                	bnez	a1,9aa <vprintf+0x16c>
        s = va_arg(ap, char*);
 9bc:	8b4e                	mv	s6,s3
      state = 0;
 9be:	4981                	li	s3,0
 9c0:	bdf9                	j	89e <vprintf+0x60>
          s = "(null)";
 9c2:	00000917          	auipc	s2,0x0
 9c6:	33e90913          	addi	s2,s2,830 # d00 <malloc+0x1f8>
        while(*s != 0){
 9ca:	02800593          	li	a1,40
 9ce:	bff1                	j	9aa <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 9d0:	008b0913          	addi	s2,s6,8
 9d4:	000b4583          	lbu	a1,0(s6)
 9d8:	8556                	mv	a0,s5
 9da:	00000097          	auipc	ra,0x0
 9de:	d98080e7          	jalr	-616(ra) # 772 <putc>
 9e2:	8b4a                	mv	s6,s2
      state = 0;
 9e4:	4981                	li	s3,0
 9e6:	bd65                	j	89e <vprintf+0x60>
        putc(fd, c);
 9e8:	85d2                	mv	a1,s4
 9ea:	8556                	mv	a0,s5
 9ec:	00000097          	auipc	ra,0x0
 9f0:	d86080e7          	jalr	-634(ra) # 772 <putc>
      state = 0;
 9f4:	4981                	li	s3,0
 9f6:	b565                	j	89e <vprintf+0x60>
        s = va_arg(ap, char*);
 9f8:	8b4e                	mv	s6,s3
      state = 0;
 9fa:	4981                	li	s3,0
 9fc:	b54d                	j	89e <vprintf+0x60>
    }
  }
}
 9fe:	70e6                	ld	ra,120(sp)
 a00:	7446                	ld	s0,112(sp)
 a02:	74a6                	ld	s1,104(sp)
 a04:	7906                	ld	s2,96(sp)
 a06:	69e6                	ld	s3,88(sp)
 a08:	6a46                	ld	s4,80(sp)
 a0a:	6aa6                	ld	s5,72(sp)
 a0c:	6b06                	ld	s6,64(sp)
 a0e:	7be2                	ld	s7,56(sp)
 a10:	7c42                	ld	s8,48(sp)
 a12:	7ca2                	ld	s9,40(sp)
 a14:	7d02                	ld	s10,32(sp)
 a16:	6de2                	ld	s11,24(sp)
 a18:	6109                	addi	sp,sp,128
 a1a:	8082                	ret

0000000000000a1c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a1c:	715d                	addi	sp,sp,-80
 a1e:	ec06                	sd	ra,24(sp)
 a20:	e822                	sd	s0,16(sp)
 a22:	1000                	addi	s0,sp,32
 a24:	e010                	sd	a2,0(s0)
 a26:	e414                	sd	a3,8(s0)
 a28:	e818                	sd	a4,16(s0)
 a2a:	ec1c                	sd	a5,24(s0)
 a2c:	03043023          	sd	a6,32(s0)
 a30:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a34:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a38:	8622                	mv	a2,s0
 a3a:	00000097          	auipc	ra,0x0
 a3e:	e04080e7          	jalr	-508(ra) # 83e <vprintf>
}
 a42:	60e2                	ld	ra,24(sp)
 a44:	6442                	ld	s0,16(sp)
 a46:	6161                	addi	sp,sp,80
 a48:	8082                	ret

0000000000000a4a <printf>:

void
printf(const char *fmt, ...)
{
 a4a:	711d                	addi	sp,sp,-96
 a4c:	ec06                	sd	ra,24(sp)
 a4e:	e822                	sd	s0,16(sp)
 a50:	1000                	addi	s0,sp,32
 a52:	e40c                	sd	a1,8(s0)
 a54:	e810                	sd	a2,16(s0)
 a56:	ec14                	sd	a3,24(s0)
 a58:	f018                	sd	a4,32(s0)
 a5a:	f41c                	sd	a5,40(s0)
 a5c:	03043823          	sd	a6,48(s0)
 a60:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a64:	00840613          	addi	a2,s0,8
 a68:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a6c:	85aa                	mv	a1,a0
 a6e:	4505                	li	a0,1
 a70:	00000097          	auipc	ra,0x0
 a74:	dce080e7          	jalr	-562(ra) # 83e <vprintf>
}
 a78:	60e2                	ld	ra,24(sp)
 a7a:	6442                	ld	s0,16(sp)
 a7c:	6125                	addi	sp,sp,96
 a7e:	8082                	ret

0000000000000a80 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a80:	1141                	addi	sp,sp,-16
 a82:	e422                	sd	s0,8(sp)
 a84:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a86:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a8a:	00000797          	auipc	a5,0x0
 a8e:	29e7b783          	ld	a5,670(a5) # d28 <freep>
 a92:	a805                	j	ac2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a94:	4618                	lw	a4,8(a2)
 a96:	9db9                	addw	a1,a1,a4
 a98:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a9c:	6398                	ld	a4,0(a5)
 a9e:	6318                	ld	a4,0(a4)
 aa0:	fee53823          	sd	a4,-16(a0)
 aa4:	a091                	j	ae8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 aa6:	ff852703          	lw	a4,-8(a0)
 aaa:	9e39                	addw	a2,a2,a4
 aac:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 aae:	ff053703          	ld	a4,-16(a0)
 ab2:	e398                	sd	a4,0(a5)
 ab4:	a099                	j	afa <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ab6:	6398                	ld	a4,0(a5)
 ab8:	00e7e463          	bltu	a5,a4,ac0 <free+0x40>
 abc:	00e6ea63          	bltu	a3,a4,ad0 <free+0x50>
{
 ac0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac2:	fed7fae3          	bgeu	a5,a3,ab6 <free+0x36>
 ac6:	6398                	ld	a4,0(a5)
 ac8:	00e6e463          	bltu	a3,a4,ad0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 acc:	fee7eae3          	bltu	a5,a4,ac0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 ad0:	ff852583          	lw	a1,-8(a0)
 ad4:	6390                	ld	a2,0(a5)
 ad6:	02059813          	slli	a6,a1,0x20
 ada:	01c85713          	srli	a4,a6,0x1c
 ade:	9736                	add	a4,a4,a3
 ae0:	fae60ae3          	beq	a2,a4,a94 <free+0x14>
    bp->s.ptr = p->s.ptr;
 ae4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ae8:	4790                	lw	a2,8(a5)
 aea:	02061593          	slli	a1,a2,0x20
 aee:	01c5d713          	srli	a4,a1,0x1c
 af2:	973e                	add	a4,a4,a5
 af4:	fae689e3          	beq	a3,a4,aa6 <free+0x26>
  } else
    p->s.ptr = bp;
 af8:	e394                	sd	a3,0(a5)
  freep = p;
 afa:	00000717          	auipc	a4,0x0
 afe:	22f73723          	sd	a5,558(a4) # d28 <freep>
}
 b02:	6422                	ld	s0,8(sp)
 b04:	0141                	addi	sp,sp,16
 b06:	8082                	ret

0000000000000b08 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b08:	7139                	addi	sp,sp,-64
 b0a:	fc06                	sd	ra,56(sp)
 b0c:	f822                	sd	s0,48(sp)
 b0e:	f426                	sd	s1,40(sp)
 b10:	f04a                	sd	s2,32(sp)
 b12:	ec4e                	sd	s3,24(sp)
 b14:	e852                	sd	s4,16(sp)
 b16:	e456                	sd	s5,8(sp)
 b18:	e05a                	sd	s6,0(sp)
 b1a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b1c:	02051493          	slli	s1,a0,0x20
 b20:	9081                	srli	s1,s1,0x20
 b22:	04bd                	addi	s1,s1,15
 b24:	8091                	srli	s1,s1,0x4
 b26:	0014899b          	addiw	s3,s1,1
 b2a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b2c:	00000517          	auipc	a0,0x0
 b30:	1fc53503          	ld	a0,508(a0) # d28 <freep>
 b34:	c515                	beqz	a0,b60 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b36:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b38:	4798                	lw	a4,8(a5)
 b3a:	02977f63          	bgeu	a4,s1,b78 <malloc+0x70>
 b3e:	8a4e                	mv	s4,s3
 b40:	0009871b          	sext.w	a4,s3
 b44:	6685                	lui	a3,0x1
 b46:	00d77363          	bgeu	a4,a3,b4c <malloc+0x44>
 b4a:	6a05                	lui	s4,0x1
 b4c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b50:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b54:	00000917          	auipc	s2,0x0
 b58:	1d490913          	addi	s2,s2,468 # d28 <freep>
  if(p == (char*)-1)
 b5c:	5afd                	li	s5,-1
 b5e:	a895                	j	bd2 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 b60:	00004797          	auipc	a5,0x4
 b64:	1d078793          	addi	a5,a5,464 # 4d30 <base>
 b68:	00000717          	auipc	a4,0x0
 b6c:	1cf73023          	sd	a5,448(a4) # d28 <freep>
 b70:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b72:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b76:	b7e1                	j	b3e <malloc+0x36>
      if(p->s.size == nunits)
 b78:	02e48c63          	beq	s1,a4,bb0 <malloc+0xa8>
        p->s.size -= nunits;
 b7c:	4137073b          	subw	a4,a4,s3
 b80:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b82:	02071693          	slli	a3,a4,0x20
 b86:	01c6d713          	srli	a4,a3,0x1c
 b8a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b8c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b90:	00000717          	auipc	a4,0x0
 b94:	18a73c23          	sd	a0,408(a4) # d28 <freep>
      return (void*)(p + 1);
 b98:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b9c:	70e2                	ld	ra,56(sp)
 b9e:	7442                	ld	s0,48(sp)
 ba0:	74a2                	ld	s1,40(sp)
 ba2:	7902                	ld	s2,32(sp)
 ba4:	69e2                	ld	s3,24(sp)
 ba6:	6a42                	ld	s4,16(sp)
 ba8:	6aa2                	ld	s5,8(sp)
 baa:	6b02                	ld	s6,0(sp)
 bac:	6121                	addi	sp,sp,64
 bae:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bb0:	6398                	ld	a4,0(a5)
 bb2:	e118                	sd	a4,0(a0)
 bb4:	bff1                	j	b90 <malloc+0x88>
  hp->s.size = nu;
 bb6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bba:	0541                	addi	a0,a0,16
 bbc:	00000097          	auipc	ra,0x0
 bc0:	ec4080e7          	jalr	-316(ra) # a80 <free>
  return freep;
 bc4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bc8:	d971                	beqz	a0,b9c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bcc:	4798                	lw	a4,8(a5)
 bce:	fa9775e3          	bgeu	a4,s1,b78 <malloc+0x70>
    if(p == freep)
 bd2:	00093703          	ld	a4,0(s2)
 bd6:	853e                	mv	a0,a5
 bd8:	fef719e3          	bne	a4,a5,bca <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 bdc:	8552                	mv	a0,s4
 bde:	00000097          	auipc	ra,0x0
 be2:	b5c080e7          	jalr	-1188(ra) # 73a <sbrk>
  if(p == (char*)-1)
 be6:	fd5518e3          	bne	a0,s5,bb6 <malloc+0xae>
        return 0;
 bea:	4501                	li	a0,0
 bec:	bf45                	j	b9c <malloc+0x94>
