
user/_cowtest：     文件格式 elf64-littleriscv


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
  12:	bf250513          	addi	a0,a0,-1038 # c00 <malloc+0xe8>
  16:	00001097          	auipc	ra,0x1
  1a:	a44080e7          	jalr	-1468(ra) # a5a <printf>
  
  char *p = sbrk(sz);
  1e:	05555537          	lui	a0,0x5555
  22:	55450513          	addi	a0,a0,1364 # 5555554 <__BSS_END__+0x55507e4>
  26:	00000097          	auipc	ra,0x0
  2a:	724080e7          	jalr	1828(ra) # 74a <sbrk>
  if(p == (char*)0xffffffffffffffffL){
  2e:	57fd                	li	a5,-1
  30:	06f50563          	beq	a0,a5,9a <simpletest+0x9a>
  34:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  for(char *q = p; q < p + sz; q += 4096){
  36:	05556937          	lui	s2,0x5556
  3a:	992a                	add	s2,s2,a0
  3c:	6985                	lui	s3,0x1
    *(int*)q = getpid();
  3e:	00000097          	auipc	ra,0x0
  42:	704080e7          	jalr	1796(ra) # 742 <getpid>
  46:	c088                	sw	a0,0(s1)
  for(char *q = p; q < p + sz; q += 4096){
  48:	94ce                	add	s1,s1,s3
  4a:	fe991ae3          	bne	s2,s1,3e <simpletest+0x3e>
  }

  int pid = fork();
  4e:	00000097          	auipc	ra,0x0
  52:	66c080e7          	jalr	1644(ra) # 6ba <fork>
  if(pid < 0){
  56:	06054363          	bltz	a0,bc <simpletest+0xbc>
    printf("fork() failed\n");
    exit(-1);
  }

  if(pid == 0)
  5a:	cd35                	beqz	a0,d6 <simpletest+0xd6>
    exit(0);

  wait(0);
  5c:	4501                	li	a0,0
  5e:	00000097          	auipc	ra,0x0
  62:	66c080e7          	jalr	1644(ra) # 6ca <wait>

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
  66:	faaab537          	lui	a0,0xfaaab
  6a:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <__BSS_END__+0xfffffffffaaa5d3c>
  6e:	00000097          	auipc	ra,0x0
  72:	6dc080e7          	jalr	1756(ra) # 74a <sbrk>
  76:	57fd                	li	a5,-1
  78:	06f50363          	beq	a0,a5,de <simpletest+0xde>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
  7c:	00001517          	auipc	a0,0x1
  80:	bd450513          	addi	a0,a0,-1068 # c50 <malloc+0x138>
  84:	00001097          	auipc	ra,0x1
  88:	9d6080e7          	jalr	-1578(ra) # a5a <printf>
}
  8c:	70a2                	ld	ra,40(sp)
  8e:	7402                	ld	s0,32(sp)
  90:	64e2                	ld	s1,24(sp)
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	6145                	addi	sp,sp,48
  98:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  9a:	055555b7          	lui	a1,0x5555
  9e:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x55507e4>
  a2:	00001517          	auipc	a0,0x1
  a6:	b6e50513          	addi	a0,a0,-1170 # c10 <malloc+0xf8>
  aa:	00001097          	auipc	ra,0x1
  ae:	9b0080e7          	jalr	-1616(ra) # a5a <printf>
    exit(-1);
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	60e080e7          	jalr	1550(ra) # 6c2 <exit>
    printf("fork() failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	b6c50513          	addi	a0,a0,-1172 # c28 <malloc+0x110>
  c4:	00001097          	auipc	ra,0x1
  c8:	996080e7          	jalr	-1642(ra) # a5a <printf>
    exit(-1);
  cc:	557d                	li	a0,-1
  ce:	00000097          	auipc	ra,0x0
  d2:	5f4080e7          	jalr	1524(ra) # 6c2 <exit>
    exit(0);
  d6:	00000097          	auipc	ra,0x0
  da:	5ec080e7          	jalr	1516(ra) # 6c2 <exit>
    printf("sbrk(-%d) failed\n", sz);
  de:	055555b7          	lui	a1,0x5555
  e2:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x55507e4>
  e6:	00001517          	auipc	a0,0x1
  ea:	b5250513          	addi	a0,a0,-1198 # c38 <malloc+0x120>
  ee:	00001097          	auipc	ra,0x1
  f2:	96c080e7          	jalr	-1684(ra) # a5a <printf>
    exit(-1);
  f6:	557d                	li	a0,-1
  f8:	00000097          	auipc	ra,0x0
  fc:	5ca080e7          	jalr	1482(ra) # 6c2 <exit>

0000000000000100 <threetest>:
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void
threetest()
{
 100:	7179                	addi	sp,sp,-48
 102:	f406                	sd	ra,40(sp)
 104:	f022                	sd	s0,32(sp)
 106:	ec26                	sd	s1,24(sp)
 108:	e84a                	sd	s2,16(sp)
 10a:	e44e                	sd	s3,8(sp)
 10c:	e052                	sd	s4,0(sp)
 10e:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;

  printf("three: ");
 110:	00001517          	auipc	a0,0x1
 114:	b4850513          	addi	a0,a0,-1208 # c58 <malloc+0x140>
 118:	00001097          	auipc	ra,0x1
 11c:	942080e7          	jalr	-1726(ra) # a5a <printf>
  
  char *p = sbrk(sz);
 120:	02000537          	lui	a0,0x2000
 124:	00000097          	auipc	ra,0x0
 128:	626080e7          	jalr	1574(ra) # 74a <sbrk>
  if(p == (char*)0xffffffffffffffffL){
 12c:	57fd                	li	a5,-1
 12e:	08f50763          	beq	a0,a5,1bc <threetest+0xbc>
 132:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  pid1 = fork();
 134:	00000097          	auipc	ra,0x0
 138:	586080e7          	jalr	1414(ra) # 6ba <fork>
  if(pid1 < 0){
 13c:	08054f63          	bltz	a0,1da <threetest+0xda>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid1 == 0){
 140:	c955                	beqz	a0,1f4 <threetest+0xf4>
      *(int*)q = 9999;
    }
    exit(0);
  }

  for(char *q = p; q < p + sz; q += 4096){
 142:	020009b7          	lui	s3,0x2000
 146:	99a6                	add	s3,s3,s1
 148:	8926                	mv	s2,s1
 14a:	6a05                	lui	s4,0x1
    *(int*)q = getpid();
 14c:	00000097          	auipc	ra,0x0
 150:	5f6080e7          	jalr	1526(ra) # 742 <getpid>
 154:	00a92023          	sw	a0,0(s2) # 5556000 <__BSS_END__+0x5551290>
  for(char *q = p; q < p + sz; q += 4096){
 158:	9952                	add	s2,s2,s4
 15a:	ff3919e3          	bne	s2,s3,14c <threetest+0x4c>
  }

  wait(0);
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	56a080e7          	jalr	1386(ra) # 6ca <wait>

  sleep(1);
 168:	4505                	li	a0,1
 16a:	00000097          	auipc	ra,0x0
 16e:	5e8080e7          	jalr	1512(ra) # 752 <sleep>

  for(char *q = p; q < p + sz; q += 4096){
 172:	6a05                	lui	s4,0x1
    if(*(int*)q != getpid()){
 174:	0004a903          	lw	s2,0(s1)
 178:	00000097          	auipc	ra,0x0
 17c:	5ca080e7          	jalr	1482(ra) # 742 <getpid>
 180:	10a91a63          	bne	s2,a0,294 <threetest+0x194>
  for(char *q = p; q < p + sz; q += 4096){
 184:	94d2                	add	s1,s1,s4
 186:	ff3497e3          	bne	s1,s3,174 <threetest+0x74>
      printf("wrong content\n");
      exit(-1);
    }
  }

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
 18a:	fe000537          	lui	a0,0xfe000
 18e:	00000097          	auipc	ra,0x0
 192:	5bc080e7          	jalr	1468(ra) # 74a <sbrk>
 196:	57fd                	li	a5,-1
 198:	10f50b63          	beq	a0,a5,2ae <threetest+0x1ae>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	ab450513          	addi	a0,a0,-1356 # c50 <malloc+0x138>
 1a4:	00001097          	auipc	ra,0x1
 1a8:	8b6080e7          	jalr	-1866(ra) # a5a <printf>
}
 1ac:	70a2                	ld	ra,40(sp)
 1ae:	7402                	ld	s0,32(sp)
 1b0:	64e2                	ld	s1,24(sp)
 1b2:	6942                	ld	s2,16(sp)
 1b4:	69a2                	ld	s3,8(sp)
 1b6:	6a02                	ld	s4,0(sp)
 1b8:	6145                	addi	sp,sp,48
 1ba:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 1bc:	020005b7          	lui	a1,0x2000
 1c0:	00001517          	auipc	a0,0x1
 1c4:	a5050513          	addi	a0,a0,-1456 # c10 <malloc+0xf8>
 1c8:	00001097          	auipc	ra,0x1
 1cc:	892080e7          	jalr	-1902(ra) # a5a <printf>
    exit(-1);
 1d0:	557d                	li	a0,-1
 1d2:	00000097          	auipc	ra,0x0
 1d6:	4f0080e7          	jalr	1264(ra) # 6c2 <exit>
    printf("fork failed\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	a8650513          	addi	a0,a0,-1402 # c60 <malloc+0x148>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	878080e7          	jalr	-1928(ra) # a5a <printf>
    exit(-1);
 1ea:	557d                	li	a0,-1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	4d6080e7          	jalr	1238(ra) # 6c2 <exit>
    pid2 = fork();
 1f4:	00000097          	auipc	ra,0x0
 1f8:	4c6080e7          	jalr	1222(ra) # 6ba <fork>
    if(pid2 < 0){
 1fc:	04054263          	bltz	a0,240 <threetest+0x140>
    if(pid2 == 0){
 200:	ed29                	bnez	a0,25a <threetest+0x15a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 202:	0199a9b7          	lui	s3,0x199a
 206:	99a6                	add	s3,s3,s1
 208:	8926                	mv	s2,s1
 20a:	6a05                	lui	s4,0x1
        *(int*)q = getpid();
 20c:	00000097          	auipc	ra,0x0
 210:	536080e7          	jalr	1334(ra) # 742 <getpid>
 214:	00a92023          	sw	a0,0(s2)
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 218:	9952                	add	s2,s2,s4
 21a:	ff2999e3          	bne	s3,s2,20c <threetest+0x10c>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 21e:	6a05                	lui	s4,0x1
        if(*(int*)q != getpid()){
 220:	0004a903          	lw	s2,0(s1)
 224:	00000097          	auipc	ra,0x0
 228:	51e080e7          	jalr	1310(ra) # 742 <getpid>
 22c:	04a91763          	bne	s2,a0,27a <threetest+0x17a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 230:	94d2                	add	s1,s1,s4
 232:	fe9997e3          	bne	s3,s1,220 <threetest+0x120>
      exit(-1);
 236:	557d                	li	a0,-1
 238:	00000097          	auipc	ra,0x0
 23c:	48a080e7          	jalr	1162(ra) # 6c2 <exit>
      printf("fork failed");
 240:	00001517          	auipc	a0,0x1
 244:	a3050513          	addi	a0,a0,-1488 # c70 <malloc+0x158>
 248:	00001097          	auipc	ra,0x1
 24c:	812080e7          	jalr	-2030(ra) # a5a <printf>
      exit(-1);
 250:	557d                	li	a0,-1
 252:	00000097          	auipc	ra,0x0
 256:	470080e7          	jalr	1136(ra) # 6c2 <exit>
    for(char *q = p; q < p + (sz/2); q += 4096){
 25a:	01000737          	lui	a4,0x1000
 25e:	9726                	add	a4,a4,s1
      *(int*)q = 9999;
 260:	6789                	lui	a5,0x2
 262:	70f78793          	addi	a5,a5,1807 # 270f <buf+0x9af>
    for(char *q = p; q < p + (sz/2); q += 4096){
 266:	6685                	lui	a3,0x1
      *(int*)q = 9999;
 268:	c09c                	sw	a5,0(s1)
    for(char *q = p; q < p + (sz/2); q += 4096){
 26a:	94b6                	add	s1,s1,a3
 26c:	fee49ee3          	bne	s1,a4,268 <threetest+0x168>
    exit(0);
 270:	4501                	li	a0,0
 272:	00000097          	auipc	ra,0x0
 276:	450080e7          	jalr	1104(ra) # 6c2 <exit>
          printf("wrong content\n");
 27a:	00001517          	auipc	a0,0x1
 27e:	a0650513          	addi	a0,a0,-1530 # c80 <malloc+0x168>
 282:	00000097          	auipc	ra,0x0
 286:	7d8080e7          	jalr	2008(ra) # a5a <printf>
          exit(-1);
 28a:	557d                	li	a0,-1
 28c:	00000097          	auipc	ra,0x0
 290:	436080e7          	jalr	1078(ra) # 6c2 <exit>
      printf("wrong content\n");
 294:	00001517          	auipc	a0,0x1
 298:	9ec50513          	addi	a0,a0,-1556 # c80 <malloc+0x168>
 29c:	00000097          	auipc	ra,0x0
 2a0:	7be080e7          	jalr	1982(ra) # a5a <printf>
      exit(-1);
 2a4:	557d                	li	a0,-1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	41c080e7          	jalr	1052(ra) # 6c2 <exit>
    printf("sbrk(-%d) failed\n", sz);
 2ae:	020005b7          	lui	a1,0x2000
 2b2:	00001517          	auipc	a0,0x1
 2b6:	98650513          	addi	a0,a0,-1658 # c38 <malloc+0x120>
 2ba:	00000097          	auipc	ra,0x0
 2be:	7a0080e7          	jalr	1952(ra) # a5a <printf>
    exit(-1);
 2c2:	557d                	li	a0,-1
 2c4:	00000097          	auipc	ra,0x0
 2c8:	3fe080e7          	jalr	1022(ra) # 6c2 <exit>

00000000000002cc <filetest>:
char junk3[4096];

// test whether copyout() simulates COW faults.
void
filetest()
{
 2cc:	7179                	addi	sp,sp,-48
 2ce:	f406                	sd	ra,40(sp)
 2d0:	f022                	sd	s0,32(sp)
 2d2:	ec26                	sd	s1,24(sp)
 2d4:	e84a                	sd	s2,16(sp)
 2d6:	1800                	addi	s0,sp,48
  printf("file: ");
 2d8:	00001517          	auipc	a0,0x1
 2dc:	9b850513          	addi	a0,a0,-1608 # c90 <malloc+0x178>
 2e0:	00000097          	auipc	ra,0x0
 2e4:	77a080e7          	jalr	1914(ra) # a5a <printf>
  
  buf[0] = 99;
 2e8:	06300793          	li	a5,99
 2ec:	00002717          	auipc	a4,0x2
 2f0:	a6f70a23          	sb	a5,-1420(a4) # 1d60 <buf>

  for(int i = 0; i < 4; i++){
 2f4:	fc042c23          	sw	zero,-40(s0)
    if(pipe(fds) != 0){
 2f8:	00001497          	auipc	s1,0x1
 2fc:	a5848493          	addi	s1,s1,-1448 # d50 <fds>
  for(int i = 0; i < 4; i++){
 300:	490d                	li	s2,3
    if(pipe(fds) != 0){
 302:	8526                	mv	a0,s1
 304:	00000097          	auipc	ra,0x0
 308:	3ce080e7          	jalr	974(ra) # 6d2 <pipe>
 30c:	e149                	bnez	a0,38e <filetest+0xc2>
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
 30e:	00000097          	auipc	ra,0x0
 312:	3ac080e7          	jalr	940(ra) # 6ba <fork>
    if(pid < 0){
 316:	08054963          	bltz	a0,3a8 <filetest+0xdc>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid == 0){
 31a:	c545                	beqz	a0,3c2 <filetest+0xf6>
        printf("error: read the wrong value\n");
        exit(1);
      }
      exit(0);
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
 31c:	4611                	li	a2,4
 31e:	fd840593          	addi	a1,s0,-40
 322:	40c8                	lw	a0,4(s1)
 324:	00000097          	auipc	ra,0x0
 328:	3be080e7          	jalr	958(ra) # 6e2 <write>
 32c:	4791                	li	a5,4
 32e:	10f51b63          	bne	a0,a5,444 <filetest+0x178>
  for(int i = 0; i < 4; i++){
 332:	fd842783          	lw	a5,-40(s0)
 336:	2785                	addiw	a5,a5,1
 338:	0007871b          	sext.w	a4,a5
 33c:	fcf42c23          	sw	a5,-40(s0)
 340:	fce951e3          	bge	s2,a4,302 <filetest+0x36>
      printf("error: write failed\n");
      exit(-1);
    }
  }

  int xstatus = 0;
 344:	fc042e23          	sw	zero,-36(s0)
 348:	4491                	li	s1,4
  for(int i = 0; i < 4; i++) {
    wait(&xstatus);
 34a:	fdc40513          	addi	a0,s0,-36
 34e:	00000097          	auipc	ra,0x0
 352:	37c080e7          	jalr	892(ra) # 6ca <wait>
    if(xstatus != 0) {
 356:	fdc42783          	lw	a5,-36(s0)
 35a:	10079263          	bnez	a5,45e <filetest+0x192>
  for(int i = 0; i < 4; i++) {
 35e:	34fd                	addiw	s1,s1,-1
 360:	f4ed                	bnez	s1,34a <filetest+0x7e>
      exit(1);
    }
  }

  if(buf[0] != 99){
 362:	00002717          	auipc	a4,0x2
 366:	9fe74703          	lbu	a4,-1538(a4) # 1d60 <buf>
 36a:	06300793          	li	a5,99
 36e:	0ef71d63          	bne	a4,a5,468 <filetest+0x19c>
    printf("error: child overwrote parent\n");
    exit(1);
  }

  printf("ok\n");
 372:	00001517          	auipc	a0,0x1
 376:	8de50513          	addi	a0,a0,-1826 # c50 <malloc+0x138>
 37a:	00000097          	auipc	ra,0x0
 37e:	6e0080e7          	jalr	1760(ra) # a5a <printf>
}
 382:	70a2                	ld	ra,40(sp)
 384:	7402                	ld	s0,32(sp)
 386:	64e2                	ld	s1,24(sp)
 388:	6942                	ld	s2,16(sp)
 38a:	6145                	addi	sp,sp,48
 38c:	8082                	ret
      printf("pipe() failed\n");
 38e:	00001517          	auipc	a0,0x1
 392:	90a50513          	addi	a0,a0,-1782 # c98 <malloc+0x180>
 396:	00000097          	auipc	ra,0x0
 39a:	6c4080e7          	jalr	1732(ra) # a5a <printf>
      exit(-1);
 39e:	557d                	li	a0,-1
 3a0:	00000097          	auipc	ra,0x0
 3a4:	322080e7          	jalr	802(ra) # 6c2 <exit>
      printf("fork failed\n");
 3a8:	00001517          	auipc	a0,0x1
 3ac:	8b850513          	addi	a0,a0,-1864 # c60 <malloc+0x148>
 3b0:	00000097          	auipc	ra,0x0
 3b4:	6aa080e7          	jalr	1706(ra) # a5a <printf>
      exit(-1);
 3b8:	557d                	li	a0,-1
 3ba:	00000097          	auipc	ra,0x0
 3be:	308080e7          	jalr	776(ra) # 6c2 <exit>
      sleep(1);
 3c2:	4505                	li	a0,1
 3c4:	00000097          	auipc	ra,0x0
 3c8:	38e080e7          	jalr	910(ra) # 752 <sleep>
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
 3cc:	4611                	li	a2,4
 3ce:	00002597          	auipc	a1,0x2
 3d2:	99258593          	addi	a1,a1,-1646 # 1d60 <buf>
 3d6:	00001517          	auipc	a0,0x1
 3da:	97a52503          	lw	a0,-1670(a0) # d50 <fds>
 3de:	00000097          	auipc	ra,0x0
 3e2:	2fc080e7          	jalr	764(ra) # 6da <read>
 3e6:	4791                	li	a5,4
 3e8:	02f51c63          	bne	a0,a5,420 <filetest+0x154>
      sleep(1);
 3ec:	4505                	li	a0,1
 3ee:	00000097          	auipc	ra,0x0
 3f2:	364080e7          	jalr	868(ra) # 752 <sleep>
      if(j != i){
 3f6:	fd842703          	lw	a4,-40(s0)
 3fa:	00002797          	auipc	a5,0x2
 3fe:	9667a783          	lw	a5,-1690(a5) # 1d60 <buf>
 402:	02f70c63          	beq	a4,a5,43a <filetest+0x16e>
        printf("error: read the wrong value\n");
 406:	00001517          	auipc	a0,0x1
 40a:	8ba50513          	addi	a0,a0,-1862 # cc0 <malloc+0x1a8>
 40e:	00000097          	auipc	ra,0x0
 412:	64c080e7          	jalr	1612(ra) # a5a <printf>
        exit(1);
 416:	4505                	li	a0,1
 418:	00000097          	auipc	ra,0x0
 41c:	2aa080e7          	jalr	682(ra) # 6c2 <exit>
        printf("error: read failed\n");
 420:	00001517          	auipc	a0,0x1
 424:	88850513          	addi	a0,a0,-1912 # ca8 <malloc+0x190>
 428:	00000097          	auipc	ra,0x0
 42c:	632080e7          	jalr	1586(ra) # a5a <printf>
        exit(1);
 430:	4505                	li	a0,1
 432:	00000097          	auipc	ra,0x0
 436:	290080e7          	jalr	656(ra) # 6c2 <exit>
      exit(0);
 43a:	4501                	li	a0,0
 43c:	00000097          	auipc	ra,0x0
 440:	286080e7          	jalr	646(ra) # 6c2 <exit>
      printf("error: write failed\n");
 444:	00001517          	auipc	a0,0x1
 448:	89c50513          	addi	a0,a0,-1892 # ce0 <malloc+0x1c8>
 44c:	00000097          	auipc	ra,0x0
 450:	60e080e7          	jalr	1550(ra) # a5a <printf>
      exit(-1);
 454:	557d                	li	a0,-1
 456:	00000097          	auipc	ra,0x0
 45a:	26c080e7          	jalr	620(ra) # 6c2 <exit>
      exit(1);
 45e:	4505                	li	a0,1
 460:	00000097          	auipc	ra,0x0
 464:	262080e7          	jalr	610(ra) # 6c2 <exit>
    printf("error: child overwrote parent\n");
 468:	00001517          	auipc	a0,0x1
 46c:	89050513          	addi	a0,a0,-1904 # cf8 <malloc+0x1e0>
 470:	00000097          	auipc	ra,0x0
 474:	5ea080e7          	jalr	1514(ra) # a5a <printf>
    exit(1);
 478:	4505                	li	a0,1
 47a:	00000097          	auipc	ra,0x0
 47e:	248080e7          	jalr	584(ra) # 6c2 <exit>

0000000000000482 <main>:

int
main(int argc, char *argv[])
{
 482:	1141                	addi	sp,sp,-16
 484:	e406                	sd	ra,8(sp)
 486:	e022                	sd	s0,0(sp)
 488:	0800                	addi	s0,sp,16
  simpletest();
 48a:	00000097          	auipc	ra,0x0
 48e:	b76080e7          	jalr	-1162(ra) # 0 <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 492:	00000097          	auipc	ra,0x0
 496:	b6e080e7          	jalr	-1170(ra) # 0 <simpletest>

  threetest();
 49a:	00000097          	auipc	ra,0x0
 49e:	c66080e7          	jalr	-922(ra) # 100 <threetest>
  threetest();
 4a2:	00000097          	auipc	ra,0x0
 4a6:	c5e080e7          	jalr	-930(ra) # 100 <threetest>
  threetest();
 4aa:	00000097          	auipc	ra,0x0
 4ae:	c56080e7          	jalr	-938(ra) # 100 <threetest>

  filetest();
 4b2:	00000097          	auipc	ra,0x0
 4b6:	e1a080e7          	jalr	-486(ra) # 2cc <filetest>

  printf("ALL COW TESTS PASSED\n");
 4ba:	00001517          	auipc	a0,0x1
 4be:	85e50513          	addi	a0,a0,-1954 # d18 <malloc+0x200>
 4c2:	00000097          	auipc	ra,0x0
 4c6:	598080e7          	jalr	1432(ra) # a5a <printf>

  exit(0);
 4ca:	4501                	li	a0,0
 4cc:	00000097          	auipc	ra,0x0
 4d0:	1f6080e7          	jalr	502(ra) # 6c2 <exit>

00000000000004d4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 4d4:	1141                	addi	sp,sp,-16
 4d6:	e422                	sd	s0,8(sp)
 4d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4da:	87aa                	mv	a5,a0
 4dc:	0585                	addi	a1,a1,1
 4de:	0785                	addi	a5,a5,1
 4e0:	fff5c703          	lbu	a4,-1(a1)
 4e4:	fee78fa3          	sb	a4,-1(a5)
 4e8:	fb75                	bnez	a4,4dc <strcpy+0x8>
    ;
  return os;
}
 4ea:	6422                	ld	s0,8(sp)
 4ec:	0141                	addi	sp,sp,16
 4ee:	8082                	ret

00000000000004f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4f0:	1141                	addi	sp,sp,-16
 4f2:	e422                	sd	s0,8(sp)
 4f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4f6:	00054783          	lbu	a5,0(a0)
 4fa:	cb91                	beqz	a5,50e <strcmp+0x1e>
 4fc:	0005c703          	lbu	a4,0(a1)
 500:	00f71763          	bne	a4,a5,50e <strcmp+0x1e>
    p++, q++;
 504:	0505                	addi	a0,a0,1
 506:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 508:	00054783          	lbu	a5,0(a0)
 50c:	fbe5                	bnez	a5,4fc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 50e:	0005c503          	lbu	a0,0(a1)
}
 512:	40a7853b          	subw	a0,a5,a0
 516:	6422                	ld	s0,8(sp)
 518:	0141                	addi	sp,sp,16
 51a:	8082                	ret

000000000000051c <strlen>:

uint
strlen(const char *s)
{
 51c:	1141                	addi	sp,sp,-16
 51e:	e422                	sd	s0,8(sp)
 520:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 522:	00054783          	lbu	a5,0(a0)
 526:	cf91                	beqz	a5,542 <strlen+0x26>
 528:	0505                	addi	a0,a0,1
 52a:	87aa                	mv	a5,a0
 52c:	4685                	li	a3,1
 52e:	9e89                	subw	a3,a3,a0
 530:	00f6853b          	addw	a0,a3,a5
 534:	0785                	addi	a5,a5,1
 536:	fff7c703          	lbu	a4,-1(a5)
 53a:	fb7d                	bnez	a4,530 <strlen+0x14>
    ;
  return n;
}
 53c:	6422                	ld	s0,8(sp)
 53e:	0141                	addi	sp,sp,16
 540:	8082                	ret
  for(n = 0; s[n]; n++)
 542:	4501                	li	a0,0
 544:	bfe5                	j	53c <strlen+0x20>

0000000000000546 <memset>:

void*
memset(void *dst, int c, uint n)
{
 546:	1141                	addi	sp,sp,-16
 548:	e422                	sd	s0,8(sp)
 54a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 54c:	ca19                	beqz	a2,562 <memset+0x1c>
 54e:	87aa                	mv	a5,a0
 550:	1602                	slli	a2,a2,0x20
 552:	9201                	srli	a2,a2,0x20
 554:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 558:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 55c:	0785                	addi	a5,a5,1
 55e:	fee79de3          	bne	a5,a4,558 <memset+0x12>
  }
  return dst;
}
 562:	6422                	ld	s0,8(sp)
 564:	0141                	addi	sp,sp,16
 566:	8082                	ret

0000000000000568 <strchr>:

char*
strchr(const char *s, char c)
{
 568:	1141                	addi	sp,sp,-16
 56a:	e422                	sd	s0,8(sp)
 56c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 56e:	00054783          	lbu	a5,0(a0)
 572:	cb99                	beqz	a5,588 <strchr+0x20>
    if(*s == c)
 574:	00f58763          	beq	a1,a5,582 <strchr+0x1a>
  for(; *s; s++)
 578:	0505                	addi	a0,a0,1
 57a:	00054783          	lbu	a5,0(a0)
 57e:	fbfd                	bnez	a5,574 <strchr+0xc>
      return (char*)s;
  return 0;
 580:	4501                	li	a0,0
}
 582:	6422                	ld	s0,8(sp)
 584:	0141                	addi	sp,sp,16
 586:	8082                	ret
  return 0;
 588:	4501                	li	a0,0
 58a:	bfe5                	j	582 <strchr+0x1a>

000000000000058c <gets>:

char*
gets(char *buf, int max)
{
 58c:	711d                	addi	sp,sp,-96
 58e:	ec86                	sd	ra,88(sp)
 590:	e8a2                	sd	s0,80(sp)
 592:	e4a6                	sd	s1,72(sp)
 594:	e0ca                	sd	s2,64(sp)
 596:	fc4e                	sd	s3,56(sp)
 598:	f852                	sd	s4,48(sp)
 59a:	f456                	sd	s5,40(sp)
 59c:	f05a                	sd	s6,32(sp)
 59e:	ec5e                	sd	s7,24(sp)
 5a0:	1080                	addi	s0,sp,96
 5a2:	8baa                	mv	s7,a0
 5a4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5a6:	892a                	mv	s2,a0
 5a8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5aa:	4aa9                	li	s5,10
 5ac:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5ae:	89a6                	mv	s3,s1
 5b0:	2485                	addiw	s1,s1,1
 5b2:	0344d863          	bge	s1,s4,5e2 <gets+0x56>
    cc = read(0, &c, 1);
 5b6:	4605                	li	a2,1
 5b8:	faf40593          	addi	a1,s0,-81
 5bc:	4501                	li	a0,0
 5be:	00000097          	auipc	ra,0x0
 5c2:	11c080e7          	jalr	284(ra) # 6da <read>
    if(cc < 1)
 5c6:	00a05e63          	blez	a0,5e2 <gets+0x56>
    buf[i++] = c;
 5ca:	faf44783          	lbu	a5,-81(s0)
 5ce:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5d2:	01578763          	beq	a5,s5,5e0 <gets+0x54>
 5d6:	0905                	addi	s2,s2,1
 5d8:	fd679be3          	bne	a5,s6,5ae <gets+0x22>
  for(i=0; i+1 < max; ){
 5dc:	89a6                	mv	s3,s1
 5de:	a011                	j	5e2 <gets+0x56>
 5e0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5e2:	99de                	add	s3,s3,s7
 5e4:	00098023          	sb	zero,0(s3) # 199a000 <__BSS_END__+0x1995290>
  return buf;
}
 5e8:	855e                	mv	a0,s7
 5ea:	60e6                	ld	ra,88(sp)
 5ec:	6446                	ld	s0,80(sp)
 5ee:	64a6                	ld	s1,72(sp)
 5f0:	6906                	ld	s2,64(sp)
 5f2:	79e2                	ld	s3,56(sp)
 5f4:	7a42                	ld	s4,48(sp)
 5f6:	7aa2                	ld	s5,40(sp)
 5f8:	7b02                	ld	s6,32(sp)
 5fa:	6be2                	ld	s7,24(sp)
 5fc:	6125                	addi	sp,sp,96
 5fe:	8082                	ret

0000000000000600 <stat>:

int
stat(const char *n, struct stat *st)
{
 600:	1101                	addi	sp,sp,-32
 602:	ec06                	sd	ra,24(sp)
 604:	e822                	sd	s0,16(sp)
 606:	e426                	sd	s1,8(sp)
 608:	e04a                	sd	s2,0(sp)
 60a:	1000                	addi	s0,sp,32
 60c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 60e:	4581                	li	a1,0
 610:	00000097          	auipc	ra,0x0
 614:	0f2080e7          	jalr	242(ra) # 702 <open>
  if(fd < 0)
 618:	02054563          	bltz	a0,642 <stat+0x42>
 61c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 61e:	85ca                	mv	a1,s2
 620:	00000097          	auipc	ra,0x0
 624:	0fa080e7          	jalr	250(ra) # 71a <fstat>
 628:	892a                	mv	s2,a0
  close(fd);
 62a:	8526                	mv	a0,s1
 62c:	00000097          	auipc	ra,0x0
 630:	0be080e7          	jalr	190(ra) # 6ea <close>
  return r;
}
 634:	854a                	mv	a0,s2
 636:	60e2                	ld	ra,24(sp)
 638:	6442                	ld	s0,16(sp)
 63a:	64a2                	ld	s1,8(sp)
 63c:	6902                	ld	s2,0(sp)
 63e:	6105                	addi	sp,sp,32
 640:	8082                	ret
    return -1;
 642:	597d                	li	s2,-1
 644:	bfc5                	j	634 <stat+0x34>

0000000000000646 <atoi>:

int
atoi(const char *s)
{
 646:	1141                	addi	sp,sp,-16
 648:	e422                	sd	s0,8(sp)
 64a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 64c:	00054603          	lbu	a2,0(a0)
 650:	fd06079b          	addiw	a5,a2,-48
 654:	0ff7f793          	andi	a5,a5,255
 658:	4725                	li	a4,9
 65a:	02f76963          	bltu	a4,a5,68c <atoi+0x46>
 65e:	86aa                	mv	a3,a0
  n = 0;
 660:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 662:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 664:	0685                	addi	a3,a3,1
 666:	0025179b          	slliw	a5,a0,0x2
 66a:	9fa9                	addw	a5,a5,a0
 66c:	0017979b          	slliw	a5,a5,0x1
 670:	9fb1                	addw	a5,a5,a2
 672:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 676:	0006c603          	lbu	a2,0(a3) # 1000 <junk3+0x2a0>
 67a:	fd06071b          	addiw	a4,a2,-48
 67e:	0ff77713          	andi	a4,a4,255
 682:	fee5f1e3          	bgeu	a1,a4,664 <atoi+0x1e>
  return n;
}
 686:	6422                	ld	s0,8(sp)
 688:	0141                	addi	sp,sp,16
 68a:	8082                	ret
  n = 0;
 68c:	4501                	li	a0,0
 68e:	bfe5                	j	686 <atoi+0x40>

0000000000000690 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 690:	1141                	addi	sp,sp,-16
 692:	e422                	sd	s0,8(sp)
 694:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 696:	00c05f63          	blez	a2,6b4 <memmove+0x24>
 69a:	1602                	slli	a2,a2,0x20
 69c:	9201                	srli	a2,a2,0x20
 69e:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 6a2:	87aa                	mv	a5,a0
    *dst++ = *src++;
 6a4:	0585                	addi	a1,a1,1
 6a6:	0785                	addi	a5,a5,1
 6a8:	fff5c703          	lbu	a4,-1(a1)
 6ac:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 6b0:	fed79ae3          	bne	a5,a3,6a4 <memmove+0x14>
  return vdst;
}
 6b4:	6422                	ld	s0,8(sp)
 6b6:	0141                	addi	sp,sp,16
 6b8:	8082                	ret

00000000000006ba <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6ba:	4885                	li	a7,1
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6c2:	4889                	li	a7,2
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <wait>:
.global wait
wait:
 li a7, SYS_wait
 6ca:	488d                	li	a7,3
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6d2:	4891                	li	a7,4
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <read>:
.global read
read:
 li a7, SYS_read
 6da:	4895                	li	a7,5
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <write>:
.global write
write:
 li a7, SYS_write
 6e2:	48c1                	li	a7,16
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <close>:
.global close
close:
 li a7, SYS_close
 6ea:	48d5                	li	a7,21
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 6f2:	4899                	li	a7,6
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <exec>:
.global exec
exec:
 li a7, SYS_exec
 6fa:	489d                	li	a7,7
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <open>:
.global open
open:
 li a7, SYS_open
 702:	48bd                	li	a7,15
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 70a:	48c5                	li	a7,17
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 712:	48c9                	li	a7,18
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 71a:	48a1                	li	a7,8
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <link>:
.global link
link:
 li a7, SYS_link
 722:	48cd                	li	a7,19
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 72a:	48d1                	li	a7,20
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 732:	48a5                	li	a7,9
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <dup>:
.global dup
dup:
 li a7, SYS_dup
 73a:	48a9                	li	a7,10
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 742:	48ad                	li	a7,11
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 74a:	48b1                	li	a7,12
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 752:	48b5                	li	a7,13
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 75a:	48b9                	li	a7,14
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 762:	48d9                	li	a7,22
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <crash>:
.global crash
crash:
 li a7, SYS_crash
 76a:	48dd                	li	a7,23
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <mount>:
.global mount
mount:
 li a7, SYS_mount
 772:	48e1                	li	a7,24
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <umount>:
.global umount
umount:
 li a7, SYS_umount
 77a:	48e5                	li	a7,25
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 782:	1101                	addi	sp,sp,-32
 784:	ec06                	sd	ra,24(sp)
 786:	e822                	sd	s0,16(sp)
 788:	1000                	addi	s0,sp,32
 78a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 78e:	4605                	li	a2,1
 790:	fef40593          	addi	a1,s0,-17
 794:	00000097          	auipc	ra,0x0
 798:	f4e080e7          	jalr	-178(ra) # 6e2 <write>
}
 79c:	60e2                	ld	ra,24(sp)
 79e:	6442                	ld	s0,16(sp)
 7a0:	6105                	addi	sp,sp,32
 7a2:	8082                	ret

00000000000007a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7a4:	7139                	addi	sp,sp,-64
 7a6:	fc06                	sd	ra,56(sp)
 7a8:	f822                	sd	s0,48(sp)
 7aa:	f426                	sd	s1,40(sp)
 7ac:	f04a                	sd	s2,32(sp)
 7ae:	ec4e                	sd	s3,24(sp)
 7b0:	0080                	addi	s0,sp,64
 7b2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7b4:	c299                	beqz	a3,7ba <printint+0x16>
 7b6:	0805c863          	bltz	a1,846 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7ba:	2581                	sext.w	a1,a1
  neg = 0;
 7bc:	4881                	li	a7,0
 7be:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7c2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7c4:	2601                	sext.w	a2,a2
 7c6:	00000517          	auipc	a0,0x0
 7ca:	57250513          	addi	a0,a0,1394 # d38 <digits>
 7ce:	883a                	mv	a6,a4
 7d0:	2705                	addiw	a4,a4,1
 7d2:	02c5f7bb          	remuw	a5,a1,a2
 7d6:	1782                	slli	a5,a5,0x20
 7d8:	9381                	srli	a5,a5,0x20
 7da:	97aa                	add	a5,a5,a0
 7dc:	0007c783          	lbu	a5,0(a5)
 7e0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7e4:	0005879b          	sext.w	a5,a1
 7e8:	02c5d5bb          	divuw	a1,a1,a2
 7ec:	0685                	addi	a3,a3,1
 7ee:	fec7f0e3          	bgeu	a5,a2,7ce <printint+0x2a>
  if(neg)
 7f2:	00088b63          	beqz	a7,808 <printint+0x64>
    buf[i++] = '-';
 7f6:	fd040793          	addi	a5,s0,-48
 7fa:	973e                	add	a4,a4,a5
 7fc:	02d00793          	li	a5,45
 800:	fef70823          	sb	a5,-16(a4)
 804:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 808:	02e05863          	blez	a4,838 <printint+0x94>
 80c:	fc040793          	addi	a5,s0,-64
 810:	00e78933          	add	s2,a5,a4
 814:	fff78993          	addi	s3,a5,-1
 818:	99ba                	add	s3,s3,a4
 81a:	377d                	addiw	a4,a4,-1
 81c:	1702                	slli	a4,a4,0x20
 81e:	9301                	srli	a4,a4,0x20
 820:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 824:	fff94583          	lbu	a1,-1(s2)
 828:	8526                	mv	a0,s1
 82a:	00000097          	auipc	ra,0x0
 82e:	f58080e7          	jalr	-168(ra) # 782 <putc>
  while(--i >= 0)
 832:	197d                	addi	s2,s2,-1
 834:	ff3918e3          	bne	s2,s3,824 <printint+0x80>
}
 838:	70e2                	ld	ra,56(sp)
 83a:	7442                	ld	s0,48(sp)
 83c:	74a2                	ld	s1,40(sp)
 83e:	7902                	ld	s2,32(sp)
 840:	69e2                	ld	s3,24(sp)
 842:	6121                	addi	sp,sp,64
 844:	8082                	ret
    x = -xx;
 846:	40b005bb          	negw	a1,a1
    neg = 1;
 84a:	4885                	li	a7,1
    x = -xx;
 84c:	bf8d                	j	7be <printint+0x1a>

000000000000084e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 84e:	7119                	addi	sp,sp,-128
 850:	fc86                	sd	ra,120(sp)
 852:	f8a2                	sd	s0,112(sp)
 854:	f4a6                	sd	s1,104(sp)
 856:	f0ca                	sd	s2,96(sp)
 858:	ecce                	sd	s3,88(sp)
 85a:	e8d2                	sd	s4,80(sp)
 85c:	e4d6                	sd	s5,72(sp)
 85e:	e0da                	sd	s6,64(sp)
 860:	fc5e                	sd	s7,56(sp)
 862:	f862                	sd	s8,48(sp)
 864:	f466                	sd	s9,40(sp)
 866:	f06a                	sd	s10,32(sp)
 868:	ec6e                	sd	s11,24(sp)
 86a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 86c:	0005c903          	lbu	s2,0(a1)
 870:	18090f63          	beqz	s2,a0e <vprintf+0x1c0>
 874:	8aaa                	mv	s5,a0
 876:	8b32                	mv	s6,a2
 878:	00158493          	addi	s1,a1,1
  state = 0;
 87c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 87e:	02500a13          	li	s4,37
      if(c == 'd'){
 882:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 886:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 88a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 88e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 892:	00000b97          	auipc	s7,0x0
 896:	4a6b8b93          	addi	s7,s7,1190 # d38 <digits>
 89a:	a839                	j	8b8 <vprintf+0x6a>
        putc(fd, c);
 89c:	85ca                	mv	a1,s2
 89e:	8556                	mv	a0,s5
 8a0:	00000097          	auipc	ra,0x0
 8a4:	ee2080e7          	jalr	-286(ra) # 782 <putc>
 8a8:	a019                	j	8ae <vprintf+0x60>
    } else if(state == '%'){
 8aa:	01498f63          	beq	s3,s4,8c8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 8ae:	0485                	addi	s1,s1,1
 8b0:	fff4c903          	lbu	s2,-1(s1)
 8b4:	14090d63          	beqz	s2,a0e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 8b8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8bc:	fe0997e3          	bnez	s3,8aa <vprintf+0x5c>
      if(c == '%'){
 8c0:	fd479ee3          	bne	a5,s4,89c <vprintf+0x4e>
        state = '%';
 8c4:	89be                	mv	s3,a5
 8c6:	b7e5                	j	8ae <vprintf+0x60>
      if(c == 'd'){
 8c8:	05878063          	beq	a5,s8,908 <vprintf+0xba>
      } else if(c == 'l') {
 8cc:	05978c63          	beq	a5,s9,924 <vprintf+0xd6>
      } else if(c == 'x') {
 8d0:	07a78863          	beq	a5,s10,940 <vprintf+0xf2>
      } else if(c == 'p') {
 8d4:	09b78463          	beq	a5,s11,95c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 8d8:	07300713          	li	a4,115
 8dc:	0ce78663          	beq	a5,a4,9a8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8e0:	06300713          	li	a4,99
 8e4:	0ee78e63          	beq	a5,a4,9e0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 8e8:	11478863          	beq	a5,s4,9f8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8ec:	85d2                	mv	a1,s4
 8ee:	8556                	mv	a0,s5
 8f0:	00000097          	auipc	ra,0x0
 8f4:	e92080e7          	jalr	-366(ra) # 782 <putc>
        putc(fd, c);
 8f8:	85ca                	mv	a1,s2
 8fa:	8556                	mv	a0,s5
 8fc:	00000097          	auipc	ra,0x0
 900:	e86080e7          	jalr	-378(ra) # 782 <putc>
      }
      state = 0;
 904:	4981                	li	s3,0
 906:	b765                	j	8ae <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 908:	008b0913          	addi	s2,s6,8
 90c:	4685                	li	a3,1
 90e:	4629                	li	a2,10
 910:	000b2583          	lw	a1,0(s6)
 914:	8556                	mv	a0,s5
 916:	00000097          	auipc	ra,0x0
 91a:	e8e080e7          	jalr	-370(ra) # 7a4 <printint>
 91e:	8b4a                	mv	s6,s2
      state = 0;
 920:	4981                	li	s3,0
 922:	b771                	j	8ae <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 924:	008b0913          	addi	s2,s6,8
 928:	4681                	li	a3,0
 92a:	4629                	li	a2,10
 92c:	000b2583          	lw	a1,0(s6)
 930:	8556                	mv	a0,s5
 932:	00000097          	auipc	ra,0x0
 936:	e72080e7          	jalr	-398(ra) # 7a4 <printint>
 93a:	8b4a                	mv	s6,s2
      state = 0;
 93c:	4981                	li	s3,0
 93e:	bf85                	j	8ae <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 940:	008b0913          	addi	s2,s6,8
 944:	4681                	li	a3,0
 946:	4641                	li	a2,16
 948:	000b2583          	lw	a1,0(s6)
 94c:	8556                	mv	a0,s5
 94e:	00000097          	auipc	ra,0x0
 952:	e56080e7          	jalr	-426(ra) # 7a4 <printint>
 956:	8b4a                	mv	s6,s2
      state = 0;
 958:	4981                	li	s3,0
 95a:	bf91                	j	8ae <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 95c:	008b0793          	addi	a5,s6,8
 960:	f8f43423          	sd	a5,-120(s0)
 964:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 968:	03000593          	li	a1,48
 96c:	8556                	mv	a0,s5
 96e:	00000097          	auipc	ra,0x0
 972:	e14080e7          	jalr	-492(ra) # 782 <putc>
  putc(fd, 'x');
 976:	85ea                	mv	a1,s10
 978:	8556                	mv	a0,s5
 97a:	00000097          	auipc	ra,0x0
 97e:	e08080e7          	jalr	-504(ra) # 782 <putc>
 982:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 984:	03c9d793          	srli	a5,s3,0x3c
 988:	97de                	add	a5,a5,s7
 98a:	0007c583          	lbu	a1,0(a5)
 98e:	8556                	mv	a0,s5
 990:	00000097          	auipc	ra,0x0
 994:	df2080e7          	jalr	-526(ra) # 782 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 998:	0992                	slli	s3,s3,0x4
 99a:	397d                	addiw	s2,s2,-1
 99c:	fe0914e3          	bnez	s2,984 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 9a0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 9a4:	4981                	li	s3,0
 9a6:	b721                	j	8ae <vprintf+0x60>
        s = va_arg(ap, char*);
 9a8:	008b0993          	addi	s3,s6,8
 9ac:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 9b0:	02090163          	beqz	s2,9d2 <vprintf+0x184>
        while(*s != 0){
 9b4:	00094583          	lbu	a1,0(s2)
 9b8:	c9a1                	beqz	a1,a08 <vprintf+0x1ba>
          putc(fd, *s);
 9ba:	8556                	mv	a0,s5
 9bc:	00000097          	auipc	ra,0x0
 9c0:	dc6080e7          	jalr	-570(ra) # 782 <putc>
          s++;
 9c4:	0905                	addi	s2,s2,1
        while(*s != 0){
 9c6:	00094583          	lbu	a1,0(s2)
 9ca:	f9e5                	bnez	a1,9ba <vprintf+0x16c>
        s = va_arg(ap, char*);
 9cc:	8b4e                	mv	s6,s3
      state = 0;
 9ce:	4981                	li	s3,0
 9d0:	bdf9                	j	8ae <vprintf+0x60>
          s = "(null)";
 9d2:	00000917          	auipc	s2,0x0
 9d6:	35e90913          	addi	s2,s2,862 # d30 <malloc+0x218>
        while(*s != 0){
 9da:	02800593          	li	a1,40
 9de:	bff1                	j	9ba <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 9e0:	008b0913          	addi	s2,s6,8
 9e4:	000b4583          	lbu	a1,0(s6)
 9e8:	8556                	mv	a0,s5
 9ea:	00000097          	auipc	ra,0x0
 9ee:	d98080e7          	jalr	-616(ra) # 782 <putc>
 9f2:	8b4a                	mv	s6,s2
      state = 0;
 9f4:	4981                	li	s3,0
 9f6:	bd65                	j	8ae <vprintf+0x60>
        putc(fd, c);
 9f8:	85d2                	mv	a1,s4
 9fa:	8556                	mv	a0,s5
 9fc:	00000097          	auipc	ra,0x0
 a00:	d86080e7          	jalr	-634(ra) # 782 <putc>
      state = 0;
 a04:	4981                	li	s3,0
 a06:	b565                	j	8ae <vprintf+0x60>
        s = va_arg(ap, char*);
 a08:	8b4e                	mv	s6,s3
      state = 0;
 a0a:	4981                	li	s3,0
 a0c:	b54d                	j	8ae <vprintf+0x60>
    }
  }
}
 a0e:	70e6                	ld	ra,120(sp)
 a10:	7446                	ld	s0,112(sp)
 a12:	74a6                	ld	s1,104(sp)
 a14:	7906                	ld	s2,96(sp)
 a16:	69e6                	ld	s3,88(sp)
 a18:	6a46                	ld	s4,80(sp)
 a1a:	6aa6                	ld	s5,72(sp)
 a1c:	6b06                	ld	s6,64(sp)
 a1e:	7be2                	ld	s7,56(sp)
 a20:	7c42                	ld	s8,48(sp)
 a22:	7ca2                	ld	s9,40(sp)
 a24:	7d02                	ld	s10,32(sp)
 a26:	6de2                	ld	s11,24(sp)
 a28:	6109                	addi	sp,sp,128
 a2a:	8082                	ret

0000000000000a2c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a2c:	715d                	addi	sp,sp,-80
 a2e:	ec06                	sd	ra,24(sp)
 a30:	e822                	sd	s0,16(sp)
 a32:	1000                	addi	s0,sp,32
 a34:	e010                	sd	a2,0(s0)
 a36:	e414                	sd	a3,8(s0)
 a38:	e818                	sd	a4,16(s0)
 a3a:	ec1c                	sd	a5,24(s0)
 a3c:	03043023          	sd	a6,32(s0)
 a40:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a44:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a48:	8622                	mv	a2,s0
 a4a:	00000097          	auipc	ra,0x0
 a4e:	e04080e7          	jalr	-508(ra) # 84e <vprintf>
}
 a52:	60e2                	ld	ra,24(sp)
 a54:	6442                	ld	s0,16(sp)
 a56:	6161                	addi	sp,sp,80
 a58:	8082                	ret

0000000000000a5a <printf>:

void
printf(const char *fmt, ...)
{
 a5a:	711d                	addi	sp,sp,-96
 a5c:	ec06                	sd	ra,24(sp)
 a5e:	e822                	sd	s0,16(sp)
 a60:	1000                	addi	s0,sp,32
 a62:	e40c                	sd	a1,8(s0)
 a64:	e810                	sd	a2,16(s0)
 a66:	ec14                	sd	a3,24(s0)
 a68:	f018                	sd	a4,32(s0)
 a6a:	f41c                	sd	a5,40(s0)
 a6c:	03043823          	sd	a6,48(s0)
 a70:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a74:	00840613          	addi	a2,s0,8
 a78:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a7c:	85aa                	mv	a1,a0
 a7e:	4505                	li	a0,1
 a80:	00000097          	auipc	ra,0x0
 a84:	dce080e7          	jalr	-562(ra) # 84e <vprintf>
}
 a88:	60e2                	ld	ra,24(sp)
 a8a:	6442                	ld	s0,16(sp)
 a8c:	6125                	addi	sp,sp,96
 a8e:	8082                	ret

0000000000000a90 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a90:	1141                	addi	sp,sp,-16
 a92:	e422                	sd	s0,8(sp)
 a94:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a96:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a9a:	00000797          	auipc	a5,0x0
 a9e:	2be7b783          	ld	a5,702(a5) # d58 <freep>
 aa2:	a805                	j	ad2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 aa4:	4618                	lw	a4,8(a2)
 aa6:	9db9                	addw	a1,a1,a4
 aa8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 aac:	6398                	ld	a4,0(a5)
 aae:	6318                	ld	a4,0(a4)
 ab0:	fee53823          	sd	a4,-16(a0)
 ab4:	a091                	j	af8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ab6:	ff852703          	lw	a4,-8(a0)
 aba:	9e39                	addw	a2,a2,a4
 abc:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 abe:	ff053703          	ld	a4,-16(a0)
 ac2:	e398                	sd	a4,0(a5)
 ac4:	a099                	j	b0a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac6:	6398                	ld	a4,0(a5)
 ac8:	00e7e463          	bltu	a5,a4,ad0 <free+0x40>
 acc:	00e6ea63          	bltu	a3,a4,ae0 <free+0x50>
{
 ad0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad2:	fed7fae3          	bgeu	a5,a3,ac6 <free+0x36>
 ad6:	6398                	ld	a4,0(a5)
 ad8:	00e6e463          	bltu	a3,a4,ae0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 adc:	fee7eae3          	bltu	a5,a4,ad0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 ae0:	ff852583          	lw	a1,-8(a0)
 ae4:	6390                	ld	a2,0(a5)
 ae6:	02059813          	slli	a6,a1,0x20
 aea:	01c85713          	srli	a4,a6,0x1c
 aee:	9736                	add	a4,a4,a3
 af0:	fae60ae3          	beq	a2,a4,aa4 <free+0x14>
    bp->s.ptr = p->s.ptr;
 af4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 af8:	4790                	lw	a2,8(a5)
 afa:	02061593          	slli	a1,a2,0x20
 afe:	01c5d713          	srli	a4,a1,0x1c
 b02:	973e                	add	a4,a4,a5
 b04:	fae689e3          	beq	a3,a4,ab6 <free+0x26>
  } else
    p->s.ptr = bp;
 b08:	e394                	sd	a3,0(a5)
  freep = p;
 b0a:	00000717          	auipc	a4,0x0
 b0e:	24f73723          	sd	a5,590(a4) # d58 <freep>
}
 b12:	6422                	ld	s0,8(sp)
 b14:	0141                	addi	sp,sp,16
 b16:	8082                	ret

0000000000000b18 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b18:	7139                	addi	sp,sp,-64
 b1a:	fc06                	sd	ra,56(sp)
 b1c:	f822                	sd	s0,48(sp)
 b1e:	f426                	sd	s1,40(sp)
 b20:	f04a                	sd	s2,32(sp)
 b22:	ec4e                	sd	s3,24(sp)
 b24:	e852                	sd	s4,16(sp)
 b26:	e456                	sd	s5,8(sp)
 b28:	e05a                	sd	s6,0(sp)
 b2a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b2c:	02051493          	slli	s1,a0,0x20
 b30:	9081                	srli	s1,s1,0x20
 b32:	04bd                	addi	s1,s1,15
 b34:	8091                	srli	s1,s1,0x4
 b36:	0014899b          	addiw	s3,s1,1
 b3a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b3c:	00000517          	auipc	a0,0x0
 b40:	21c53503          	ld	a0,540(a0) # d58 <freep>
 b44:	c515                	beqz	a0,b70 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b46:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b48:	4798                	lw	a4,8(a5)
 b4a:	02977f63          	bgeu	a4,s1,b88 <malloc+0x70>
 b4e:	8a4e                	mv	s4,s3
 b50:	0009871b          	sext.w	a4,s3
 b54:	6685                	lui	a3,0x1
 b56:	00d77363          	bgeu	a4,a3,b5c <malloc+0x44>
 b5a:	6a05                	lui	s4,0x1
 b5c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b60:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b64:	00000917          	auipc	s2,0x0
 b68:	1f490913          	addi	s2,s2,500 # d58 <freep>
  if(p == (char*)-1)
 b6c:	5afd                	li	s5,-1
 b6e:	a895                	j	be2 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 b70:	00004797          	auipc	a5,0x4
 b74:	1f078793          	addi	a5,a5,496 # 4d60 <base>
 b78:	00000717          	auipc	a4,0x0
 b7c:	1ef73023          	sd	a5,480(a4) # d58 <freep>
 b80:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b82:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b86:	b7e1                	j	b4e <malloc+0x36>
      if(p->s.size == nunits)
 b88:	02e48c63          	beq	s1,a4,bc0 <malloc+0xa8>
        p->s.size -= nunits;
 b8c:	4137073b          	subw	a4,a4,s3
 b90:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b92:	02071693          	slli	a3,a4,0x20
 b96:	01c6d713          	srli	a4,a3,0x1c
 b9a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b9c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ba0:	00000717          	auipc	a4,0x0
 ba4:	1aa73c23          	sd	a0,440(a4) # d58 <freep>
      return (void*)(p + 1);
 ba8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bac:	70e2                	ld	ra,56(sp)
 bae:	7442                	ld	s0,48(sp)
 bb0:	74a2                	ld	s1,40(sp)
 bb2:	7902                	ld	s2,32(sp)
 bb4:	69e2                	ld	s3,24(sp)
 bb6:	6a42                	ld	s4,16(sp)
 bb8:	6aa2                	ld	s5,8(sp)
 bba:	6b02                	ld	s6,0(sp)
 bbc:	6121                	addi	sp,sp,64
 bbe:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bc0:	6398                	ld	a4,0(a5)
 bc2:	e118                	sd	a4,0(a0)
 bc4:	bff1                	j	ba0 <malloc+0x88>
  hp->s.size = nu;
 bc6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bca:	0541                	addi	a0,a0,16
 bcc:	00000097          	auipc	ra,0x0
 bd0:	ec4080e7          	jalr	-316(ra) # a90 <free>
  return freep;
 bd4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bd8:	d971                	beqz	a0,bac <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bda:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bdc:	4798                	lw	a4,8(a5)
 bde:	fa9775e3          	bgeu	a4,s1,b88 <malloc+0x70>
    if(p == freep)
 be2:	00093703          	ld	a4,0(s2)
 be6:	853e                	mv	a0,a5
 be8:	fef719e3          	bne	a4,a5,bda <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 bec:	8552                	mv	a0,s4
 bee:	00000097          	auipc	ra,0x0
 bf2:	b5c080e7          	jalr	-1188(ra) # 74a <sbrk>
  if(p == (char*)-1)
 bf6:	fd5518e3          	bne	a0,s5,bc6 <malloc+0xae>
        return 0;
 bfa:	4501                	li	a0,0
 bfc:	bf45                	j	bac <malloc+0x94>
