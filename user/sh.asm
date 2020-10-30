
user/_sh：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  fprintf(2, "$ ");
      10:	00001597          	auipc	a1,0x1
      14:	26058593          	addi	a1,a1,608 # 1270 <malloc+0xec>
      18:	4509                	li	a0,2
      1a:	00001097          	auipc	ra,0x1
      1e:	07e080e7          	jalr	126(ra) # 1098 <fprintf>
  memset(buf, 0, nbuf);
      22:	864a                	mv	a2,s2
      24:	4581                	li	a1,0
      26:	8526                	mv	a0,s1
      28:	00001097          	auipc	ra,0x1
      2c:	b8a080e7          	jalr	-1142(ra) # bb2 <memset>
  gets(buf, nbuf);
      30:	85ca                	mv	a1,s2
      32:	8526                	mv	a0,s1
      34:	00001097          	auipc	ra,0x1
      38:	bc4080e7          	jalr	-1084(ra) # bf8 <gets>
  if(buf[0] == 0) // EOF
      3c:	0004c503          	lbu	a0,0(s1)
      40:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      44:	40a00533          	neg	a0,a0
      48:	60e2                	ld	ra,24(sp)
      4a:	6442                	ld	s0,16(sp)
      4c:	64a2                	ld	s1,8(sp)
      4e:	6902                	ld	s2,0(sp)
      50:	6105                	addi	sp,sp,32
      52:	8082                	ret

0000000000000054 <panic>:
  exit();
}

void
panic(char *s)
{
      54:	1141                	addi	sp,sp,-16
      56:	e406                	sd	ra,8(sp)
      58:	e022                	sd	s0,0(sp)
      5a:	0800                	addi	s0,sp,16
      5c:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      5e:	00001597          	auipc	a1,0x1
      62:	21a58593          	addi	a1,a1,538 # 1278 <malloc+0xf4>
      66:	4509                	li	a0,2
      68:	00001097          	auipc	ra,0x1
      6c:	030080e7          	jalr	48(ra) # 1098 <fprintf>
  exit();
      70:	00001097          	auipc	ra,0x1
      74:	cbe080e7          	jalr	-834(ra) # d2e <exit>

0000000000000078 <fork1>:
}

int
fork1(void)
{
      78:	1141                	addi	sp,sp,-16
      7a:	e406                	sd	ra,8(sp)
      7c:	e022                	sd	s0,0(sp)
      7e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      80:	00001097          	auipc	ra,0x1
      84:	ca6080e7          	jalr	-858(ra) # d26 <fork>
  if(pid == -1)
      88:	57fd                	li	a5,-1
      8a:	00f50663          	beq	a0,a5,96 <fork1+0x1e>
    panic("fork");
  return pid;
}
      8e:	60a2                	ld	ra,8(sp)
      90:	6402                	ld	s0,0(sp)
      92:	0141                	addi	sp,sp,16
      94:	8082                	ret
    panic("fork");
      96:	00001517          	auipc	a0,0x1
      9a:	1ea50513          	addi	a0,a0,490 # 1280 <malloc+0xfc>
      9e:	00000097          	auipc	ra,0x0
      a2:	fb6080e7          	jalr	-74(ra) # 54 <panic>

00000000000000a6 <runcmd>:
{
      a6:	7179                	addi	sp,sp,-48
      a8:	f406                	sd	ra,40(sp)
      aa:	f022                	sd	s0,32(sp)
      ac:	ec26                	sd	s1,24(sp)
      ae:	1800                	addi	s0,sp,48
  if(cmd == 0)
      b0:	c10d                	beqz	a0,d2 <runcmd+0x2c>
      b2:	84aa                	mv	s1,a0
  switch(cmd->type){
      b4:	4118                	lw	a4,0(a0)
      b6:	4795                	li	a5,5
      b8:	02e7e163          	bltu	a5,a4,da <runcmd+0x34>
      bc:	00056783          	lwu	a5,0(a0)
      c0:	078a                	slli	a5,a5,0x2
      c2:	00001717          	auipc	a4,0x1
      c6:	2be70713          	addi	a4,a4,702 # 1380 <malloc+0x1fc>
      ca:	97ba                	add	a5,a5,a4
      cc:	439c                	lw	a5,0(a5)
      ce:	97ba                	add	a5,a5,a4
      d0:	8782                	jr	a5
    exit();
      d2:	00001097          	auipc	ra,0x1
      d6:	c5c080e7          	jalr	-932(ra) # d2e <exit>
    panic("runcmd");
      da:	00001517          	auipc	a0,0x1
      de:	1ae50513          	addi	a0,a0,430 # 1288 <malloc+0x104>
      e2:	00000097          	auipc	ra,0x0
      e6:	f72080e7          	jalr	-142(ra) # 54 <panic>
    if(ecmd->argv[0] == 0)
      ea:	6508                	ld	a0,8(a0)
      ec:	c50d                	beqz	a0,116 <runcmd+0x70>
    exec(ecmd->argv[0], ecmd->argv);
      ee:	00848593          	addi	a1,s1,8
      f2:	00001097          	auipc	ra,0x1
      f6:	c74080e7          	jalr	-908(ra) # d66 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      fa:	6490                	ld	a2,8(s1)
      fc:	00001597          	auipc	a1,0x1
     100:	19458593          	addi	a1,a1,404 # 1290 <malloc+0x10c>
     104:	4509                	li	a0,2
     106:	00001097          	auipc	ra,0x1
     10a:	f92080e7          	jalr	-110(ra) # 1098 <fprintf>
  exit();
     10e:	00001097          	auipc	ra,0x1
     112:	c20080e7          	jalr	-992(ra) # d2e <exit>
      exit();
     116:	00001097          	auipc	ra,0x1
     11a:	c18080e7          	jalr	-1000(ra) # d2e <exit>
    close(rcmd->fd);
     11e:	5148                	lw	a0,36(a0)
     120:	00001097          	auipc	ra,0x1
     124:	c36080e7          	jalr	-970(ra) # d56 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     128:	508c                	lw	a1,32(s1)
     12a:	6888                	ld	a0,16(s1)
     12c:	00001097          	auipc	ra,0x1
     130:	c42080e7          	jalr	-958(ra) # d6e <open>
     134:	00054763          	bltz	a0,142 <runcmd+0x9c>
    runcmd(rcmd->cmd);
     138:	6488                	ld	a0,8(s1)
     13a:	00000097          	auipc	ra,0x0
     13e:	f6c080e7          	jalr	-148(ra) # a6 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     142:	6890                	ld	a2,16(s1)
     144:	00001597          	auipc	a1,0x1
     148:	15c58593          	addi	a1,a1,348 # 12a0 <malloc+0x11c>
     14c:	4509                	li	a0,2
     14e:	00001097          	auipc	ra,0x1
     152:	f4a080e7          	jalr	-182(ra) # 1098 <fprintf>
      exit();
     156:	00001097          	auipc	ra,0x1
     15a:	bd8080e7          	jalr	-1064(ra) # d2e <exit>
    if(fork1() == 0)
     15e:	00000097          	auipc	ra,0x0
     162:	f1a080e7          	jalr	-230(ra) # 78 <fork1>
     166:	c911                	beqz	a0,17a <runcmd+0xd4>
    wait();
     168:	00001097          	auipc	ra,0x1
     16c:	bce080e7          	jalr	-1074(ra) # d36 <wait>
    runcmd(lcmd->right);
     170:	6888                	ld	a0,16(s1)
     172:	00000097          	auipc	ra,0x0
     176:	f34080e7          	jalr	-204(ra) # a6 <runcmd>
      runcmd(lcmd->left);
     17a:	6488                	ld	a0,8(s1)
     17c:	00000097          	auipc	ra,0x0
     180:	f2a080e7          	jalr	-214(ra) # a6 <runcmd>
    if(pipe(p) < 0)
     184:	fd840513          	addi	a0,s0,-40
     188:	00001097          	auipc	ra,0x1
     18c:	bb6080e7          	jalr	-1098(ra) # d3e <pipe>
     190:	04054163          	bltz	a0,1d2 <runcmd+0x12c>
    if(fork1() == 0){
     194:	00000097          	auipc	ra,0x0
     198:	ee4080e7          	jalr	-284(ra) # 78 <fork1>
     19c:	c139                	beqz	a0,1e2 <runcmd+0x13c>
    if(fork1() == 0){
     19e:	00000097          	auipc	ra,0x0
     1a2:	eda080e7          	jalr	-294(ra) # 78 <fork1>
     1a6:	c935                	beqz	a0,21a <runcmd+0x174>
    close(p[0]);
     1a8:	fd842503          	lw	a0,-40(s0)
     1ac:	00001097          	auipc	ra,0x1
     1b0:	baa080e7          	jalr	-1110(ra) # d56 <close>
    close(p[1]);
     1b4:	fdc42503          	lw	a0,-36(s0)
     1b8:	00001097          	auipc	ra,0x1
     1bc:	b9e080e7          	jalr	-1122(ra) # d56 <close>
    wait();
     1c0:	00001097          	auipc	ra,0x1
     1c4:	b76080e7          	jalr	-1162(ra) # d36 <wait>
    wait();
     1c8:	00001097          	auipc	ra,0x1
     1cc:	b6e080e7          	jalr	-1170(ra) # d36 <wait>
    break;
     1d0:	bf3d                	j	10e <runcmd+0x68>
      panic("pipe");
     1d2:	00001517          	auipc	a0,0x1
     1d6:	0de50513          	addi	a0,a0,222 # 12b0 <malloc+0x12c>
     1da:	00000097          	auipc	ra,0x0
     1de:	e7a080e7          	jalr	-390(ra) # 54 <panic>
      close(1);
     1e2:	4505                	li	a0,1
     1e4:	00001097          	auipc	ra,0x1
     1e8:	b72080e7          	jalr	-1166(ra) # d56 <close>
      dup(p[1]);
     1ec:	fdc42503          	lw	a0,-36(s0)
     1f0:	00001097          	auipc	ra,0x1
     1f4:	bb6080e7          	jalr	-1098(ra) # da6 <dup>
      close(p[0]);
     1f8:	fd842503          	lw	a0,-40(s0)
     1fc:	00001097          	auipc	ra,0x1
     200:	b5a080e7          	jalr	-1190(ra) # d56 <close>
      close(p[1]);
     204:	fdc42503          	lw	a0,-36(s0)
     208:	00001097          	auipc	ra,0x1
     20c:	b4e080e7          	jalr	-1202(ra) # d56 <close>
      runcmd(pcmd->left);
     210:	6488                	ld	a0,8(s1)
     212:	00000097          	auipc	ra,0x0
     216:	e94080e7          	jalr	-364(ra) # a6 <runcmd>
      close(0);
     21a:	00001097          	auipc	ra,0x1
     21e:	b3c080e7          	jalr	-1220(ra) # d56 <close>
      dup(p[0]);
     222:	fd842503          	lw	a0,-40(s0)
     226:	00001097          	auipc	ra,0x1
     22a:	b80080e7          	jalr	-1152(ra) # da6 <dup>
      close(p[0]);
     22e:	fd842503          	lw	a0,-40(s0)
     232:	00001097          	auipc	ra,0x1
     236:	b24080e7          	jalr	-1244(ra) # d56 <close>
      close(p[1]);
     23a:	fdc42503          	lw	a0,-36(s0)
     23e:	00001097          	auipc	ra,0x1
     242:	b18080e7          	jalr	-1256(ra) # d56 <close>
      runcmd(pcmd->right);
     246:	6888                	ld	a0,16(s1)
     248:	00000097          	auipc	ra,0x0
     24c:	e5e080e7          	jalr	-418(ra) # a6 <runcmd>
    if(fork1() == 0)
     250:	00000097          	auipc	ra,0x0
     254:	e28080e7          	jalr	-472(ra) # 78 <fork1>
     258:	ea051be3          	bnez	a0,10e <runcmd+0x68>
      runcmd(bcmd->cmd);
     25c:	6488                	ld	a0,8(s1)
     25e:	00000097          	auipc	ra,0x0
     262:	e48080e7          	jalr	-440(ra) # a6 <runcmd>

0000000000000266 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     266:	1101                	addi	sp,sp,-32
     268:	ec06                	sd	ra,24(sp)
     26a:	e822                	sd	s0,16(sp)
     26c:	e426                	sd	s1,8(sp)
     26e:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     270:	0a800513          	li	a0,168
     274:	00001097          	auipc	ra,0x1
     278:	f10080e7          	jalr	-240(ra) # 1184 <malloc>
     27c:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     27e:	0a800613          	li	a2,168
     282:	4581                	li	a1,0
     284:	00001097          	auipc	ra,0x1
     288:	92e080e7          	jalr	-1746(ra) # bb2 <memset>
  cmd->type = EXEC;
     28c:	4785                	li	a5,1
     28e:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     290:	8526                	mv	a0,s1
     292:	60e2                	ld	ra,24(sp)
     294:	6442                	ld	s0,16(sp)
     296:	64a2                	ld	s1,8(sp)
     298:	6105                	addi	sp,sp,32
     29a:	8082                	ret

000000000000029c <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     29c:	7139                	addi	sp,sp,-64
     29e:	fc06                	sd	ra,56(sp)
     2a0:	f822                	sd	s0,48(sp)
     2a2:	f426                	sd	s1,40(sp)
     2a4:	f04a                	sd	s2,32(sp)
     2a6:	ec4e                	sd	s3,24(sp)
     2a8:	e852                	sd	s4,16(sp)
     2aa:	e456                	sd	s5,8(sp)
     2ac:	e05a                	sd	s6,0(sp)
     2ae:	0080                	addi	s0,sp,64
     2b0:	8b2a                	mv	s6,a0
     2b2:	8aae                	mv	s5,a1
     2b4:	8a32                	mv	s4,a2
     2b6:	89b6                	mv	s3,a3
     2b8:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ba:	02800513          	li	a0,40
     2be:	00001097          	auipc	ra,0x1
     2c2:	ec6080e7          	jalr	-314(ra) # 1184 <malloc>
     2c6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2c8:	02800613          	li	a2,40
     2cc:	4581                	li	a1,0
     2ce:	00001097          	auipc	ra,0x1
     2d2:	8e4080e7          	jalr	-1820(ra) # bb2 <memset>
  cmd->type = REDIR;
     2d6:	4789                	li	a5,2
     2d8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2da:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     2de:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     2e2:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2e6:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     2ea:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     2ee:	8526                	mv	a0,s1
     2f0:	70e2                	ld	ra,56(sp)
     2f2:	7442                	ld	s0,48(sp)
     2f4:	74a2                	ld	s1,40(sp)
     2f6:	7902                	ld	s2,32(sp)
     2f8:	69e2                	ld	s3,24(sp)
     2fa:	6a42                	ld	s4,16(sp)
     2fc:	6aa2                	ld	s5,8(sp)
     2fe:	6b02                	ld	s6,0(sp)
     300:	6121                	addi	sp,sp,64
     302:	8082                	ret

0000000000000304 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     304:	7179                	addi	sp,sp,-48
     306:	f406                	sd	ra,40(sp)
     308:	f022                	sd	s0,32(sp)
     30a:	ec26                	sd	s1,24(sp)
     30c:	e84a                	sd	s2,16(sp)
     30e:	e44e                	sd	s3,8(sp)
     310:	1800                	addi	s0,sp,48
     312:	89aa                	mv	s3,a0
     314:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     316:	4561                	li	a0,24
     318:	00001097          	auipc	ra,0x1
     31c:	e6c080e7          	jalr	-404(ra) # 1184 <malloc>
     320:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     322:	4661                	li	a2,24
     324:	4581                	li	a1,0
     326:	00001097          	auipc	ra,0x1
     32a:	88c080e7          	jalr	-1908(ra) # bb2 <memset>
  cmd->type = PIPE;
     32e:	478d                	li	a5,3
     330:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     332:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     336:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     33a:	8526                	mv	a0,s1
     33c:	70a2                	ld	ra,40(sp)
     33e:	7402                	ld	s0,32(sp)
     340:	64e2                	ld	s1,24(sp)
     342:	6942                	ld	s2,16(sp)
     344:	69a2                	ld	s3,8(sp)
     346:	6145                	addi	sp,sp,48
     348:	8082                	ret

000000000000034a <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     34a:	7179                	addi	sp,sp,-48
     34c:	f406                	sd	ra,40(sp)
     34e:	f022                	sd	s0,32(sp)
     350:	ec26                	sd	s1,24(sp)
     352:	e84a                	sd	s2,16(sp)
     354:	e44e                	sd	s3,8(sp)
     356:	1800                	addi	s0,sp,48
     358:	89aa                	mv	s3,a0
     35a:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     35c:	4561                	li	a0,24
     35e:	00001097          	auipc	ra,0x1
     362:	e26080e7          	jalr	-474(ra) # 1184 <malloc>
     366:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     368:	4661                	li	a2,24
     36a:	4581                	li	a1,0
     36c:	00001097          	auipc	ra,0x1
     370:	846080e7          	jalr	-1978(ra) # bb2 <memset>
  cmd->type = LIST;
     374:	4791                	li	a5,4
     376:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     378:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     37c:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     380:	8526                	mv	a0,s1
     382:	70a2                	ld	ra,40(sp)
     384:	7402                	ld	s0,32(sp)
     386:	64e2                	ld	s1,24(sp)
     388:	6942                	ld	s2,16(sp)
     38a:	69a2                	ld	s3,8(sp)
     38c:	6145                	addi	sp,sp,48
     38e:	8082                	ret

0000000000000390 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     390:	1101                	addi	sp,sp,-32
     392:	ec06                	sd	ra,24(sp)
     394:	e822                	sd	s0,16(sp)
     396:	e426                	sd	s1,8(sp)
     398:	e04a                	sd	s2,0(sp)
     39a:	1000                	addi	s0,sp,32
     39c:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     39e:	4541                	li	a0,16
     3a0:	00001097          	auipc	ra,0x1
     3a4:	de4080e7          	jalr	-540(ra) # 1184 <malloc>
     3a8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3aa:	4641                	li	a2,16
     3ac:	4581                	li	a1,0
     3ae:	00001097          	auipc	ra,0x1
     3b2:	804080e7          	jalr	-2044(ra) # bb2 <memset>
  cmd->type = BACK;
     3b6:	4795                	li	a5,5
     3b8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3ba:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3be:	8526                	mv	a0,s1
     3c0:	60e2                	ld	ra,24(sp)
     3c2:	6442                	ld	s0,16(sp)
     3c4:	64a2                	ld	s1,8(sp)
     3c6:	6902                	ld	s2,0(sp)
     3c8:	6105                	addi	sp,sp,32
     3ca:	8082                	ret

00000000000003cc <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3cc:	7139                	addi	sp,sp,-64
     3ce:	fc06                	sd	ra,56(sp)
     3d0:	f822                	sd	s0,48(sp)
     3d2:	f426                	sd	s1,40(sp)
     3d4:	f04a                	sd	s2,32(sp)
     3d6:	ec4e                	sd	s3,24(sp)
     3d8:	e852                	sd	s4,16(sp)
     3da:	e456                	sd	s5,8(sp)
     3dc:	e05a                	sd	s6,0(sp)
     3de:	0080                	addi	s0,sp,64
     3e0:	8a2a                	mv	s4,a0
     3e2:	892e                	mv	s2,a1
     3e4:	8ab2                	mv	s5,a2
     3e6:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3e8:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3ea:	00001997          	auipc	s3,0x1
     3ee:	fee98993          	addi	s3,s3,-18 # 13d8 <whitespace>
     3f2:	00b4fd63          	bgeu	s1,a1,40c <gettoken+0x40>
     3f6:	0004c583          	lbu	a1,0(s1)
     3fa:	854e                	mv	a0,s3
     3fc:	00000097          	auipc	ra,0x0
     400:	7d8080e7          	jalr	2008(ra) # bd4 <strchr>
     404:	c501                	beqz	a0,40c <gettoken+0x40>
    s++;
     406:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     408:	fe9917e3          	bne	s2,s1,3f6 <gettoken+0x2a>
  if(q)
     40c:	000a8463          	beqz	s5,414 <gettoken+0x48>
    *q = s;
     410:	009ab023          	sd	s1,0(s5)
  ret = *s;
     414:	0004c783          	lbu	a5,0(s1)
     418:	00078a9b          	sext.w	s5,a5
  switch(*s){
     41c:	03c00713          	li	a4,60
     420:	06f76563          	bltu	a4,a5,48a <gettoken+0xbe>
     424:	03a00713          	li	a4,58
     428:	00f76e63          	bltu	a4,a5,444 <gettoken+0x78>
     42c:	cf89                	beqz	a5,446 <gettoken+0x7a>
     42e:	02600713          	li	a4,38
     432:	00e78963          	beq	a5,a4,444 <gettoken+0x78>
     436:	fd87879b          	addiw	a5,a5,-40
     43a:	0ff7f793          	andi	a5,a5,255
     43e:	4705                	li	a4,1
     440:	06f76c63          	bltu	a4,a5,4b8 <gettoken+0xec>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     444:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     446:	000b0463          	beqz	s6,44e <gettoken+0x82>
    *eq = s;
     44a:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     44e:	00001997          	auipc	s3,0x1
     452:	f8a98993          	addi	s3,s3,-118 # 13d8 <whitespace>
     456:	0124fd63          	bgeu	s1,s2,470 <gettoken+0xa4>
     45a:	0004c583          	lbu	a1,0(s1)
     45e:	854e                	mv	a0,s3
     460:	00000097          	auipc	ra,0x0
     464:	774080e7          	jalr	1908(ra) # bd4 <strchr>
     468:	c501                	beqz	a0,470 <gettoken+0xa4>
    s++;
     46a:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     46c:	fe9917e3          	bne	s2,s1,45a <gettoken+0x8e>
  *ps = s;
     470:	009a3023          	sd	s1,0(s4)
  return ret;
}
     474:	8556                	mv	a0,s5
     476:	70e2                	ld	ra,56(sp)
     478:	7442                	ld	s0,48(sp)
     47a:	74a2                	ld	s1,40(sp)
     47c:	7902                	ld	s2,32(sp)
     47e:	69e2                	ld	s3,24(sp)
     480:	6a42                	ld	s4,16(sp)
     482:	6aa2                	ld	s5,8(sp)
     484:	6b02                	ld	s6,0(sp)
     486:	6121                	addi	sp,sp,64
     488:	8082                	ret
  switch(*s){
     48a:	03e00713          	li	a4,62
     48e:	02e79163          	bne	a5,a4,4b0 <gettoken+0xe4>
    s++;
     492:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     496:	0014c703          	lbu	a4,1(s1)
     49a:	03e00793          	li	a5,62
      s++;
     49e:	0489                	addi	s1,s1,2
      ret = '+';
     4a0:	02b00a93          	li	s5,43
    if(*s == '>'){
     4a4:	faf701e3          	beq	a4,a5,446 <gettoken+0x7a>
    s++;
     4a8:	84b6                	mv	s1,a3
  ret = *s;
     4aa:	03e00a93          	li	s5,62
     4ae:	bf61                	j	446 <gettoken+0x7a>
  switch(*s){
     4b0:	07c00713          	li	a4,124
     4b4:	f8e788e3          	beq	a5,a4,444 <gettoken+0x78>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4b8:	00001997          	auipc	s3,0x1
     4bc:	f2098993          	addi	s3,s3,-224 # 13d8 <whitespace>
     4c0:	00001a97          	auipc	s5,0x1
     4c4:	f10a8a93          	addi	s5,s5,-240 # 13d0 <symbols>
     4c8:	0324f563          	bgeu	s1,s2,4f2 <gettoken+0x126>
     4cc:	0004c583          	lbu	a1,0(s1)
     4d0:	854e                	mv	a0,s3
     4d2:	00000097          	auipc	ra,0x0
     4d6:	702080e7          	jalr	1794(ra) # bd4 <strchr>
     4da:	e505                	bnez	a0,502 <gettoken+0x136>
     4dc:	0004c583          	lbu	a1,0(s1)
     4e0:	8556                	mv	a0,s5
     4e2:	00000097          	auipc	ra,0x0
     4e6:	6f2080e7          	jalr	1778(ra) # bd4 <strchr>
     4ea:	e909                	bnez	a0,4fc <gettoken+0x130>
      s++;
     4ec:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4ee:	fc991fe3          	bne	s2,s1,4cc <gettoken+0x100>
  if(eq)
     4f2:	06100a93          	li	s5,97
     4f6:	f40b1ae3          	bnez	s6,44a <gettoken+0x7e>
     4fa:	bf9d                	j	470 <gettoken+0xa4>
    ret = 'a';
     4fc:	06100a93          	li	s5,97
     500:	b799                	j	446 <gettoken+0x7a>
     502:	06100a93          	li	s5,97
     506:	b781                	j	446 <gettoken+0x7a>

0000000000000508 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     508:	7139                	addi	sp,sp,-64
     50a:	fc06                	sd	ra,56(sp)
     50c:	f822                	sd	s0,48(sp)
     50e:	f426                	sd	s1,40(sp)
     510:	f04a                	sd	s2,32(sp)
     512:	ec4e                	sd	s3,24(sp)
     514:	e852                	sd	s4,16(sp)
     516:	e456                	sd	s5,8(sp)
     518:	0080                	addi	s0,sp,64
     51a:	8a2a                	mv	s4,a0
     51c:	892e                	mv	s2,a1
     51e:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     520:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     522:	00001997          	auipc	s3,0x1
     526:	eb698993          	addi	s3,s3,-330 # 13d8 <whitespace>
     52a:	00b4fd63          	bgeu	s1,a1,544 <peek+0x3c>
     52e:	0004c583          	lbu	a1,0(s1)
     532:	854e                	mv	a0,s3
     534:	00000097          	auipc	ra,0x0
     538:	6a0080e7          	jalr	1696(ra) # bd4 <strchr>
     53c:	c501                	beqz	a0,544 <peek+0x3c>
    s++;
     53e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     540:	fe9917e3          	bne	s2,s1,52e <peek+0x26>
  *ps = s;
     544:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     548:	0004c583          	lbu	a1,0(s1)
     54c:	4501                	li	a0,0
     54e:	e991                	bnez	a1,562 <peek+0x5a>
}
     550:	70e2                	ld	ra,56(sp)
     552:	7442                	ld	s0,48(sp)
     554:	74a2                	ld	s1,40(sp)
     556:	7902                	ld	s2,32(sp)
     558:	69e2                	ld	s3,24(sp)
     55a:	6a42                	ld	s4,16(sp)
     55c:	6aa2                	ld	s5,8(sp)
     55e:	6121                	addi	sp,sp,64
     560:	8082                	ret
  return *s && strchr(toks, *s);
     562:	8556                	mv	a0,s5
     564:	00000097          	auipc	ra,0x0
     568:	670080e7          	jalr	1648(ra) # bd4 <strchr>
     56c:	00a03533          	snez	a0,a0
     570:	b7c5                	j	550 <peek+0x48>

0000000000000572 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     572:	7159                	addi	sp,sp,-112
     574:	f486                	sd	ra,104(sp)
     576:	f0a2                	sd	s0,96(sp)
     578:	eca6                	sd	s1,88(sp)
     57a:	e8ca                	sd	s2,80(sp)
     57c:	e4ce                	sd	s3,72(sp)
     57e:	e0d2                	sd	s4,64(sp)
     580:	fc56                	sd	s5,56(sp)
     582:	f85a                	sd	s6,48(sp)
     584:	f45e                	sd	s7,40(sp)
     586:	f062                	sd	s8,32(sp)
     588:	ec66                	sd	s9,24(sp)
     58a:	1880                	addi	s0,sp,112
     58c:	8a2a                	mv	s4,a0
     58e:	89ae                	mv	s3,a1
     590:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     592:	00001b97          	auipc	s7,0x1
     596:	d46b8b93          	addi	s7,s7,-698 # 12d8 <malloc+0x154>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     59a:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     59e:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     5a2:	a02d                	j	5cc <parseredirs+0x5a>
      panic("missing file for redirection");
     5a4:	00001517          	auipc	a0,0x1
     5a8:	d1450513          	addi	a0,a0,-748 # 12b8 <malloc+0x134>
     5ac:	00000097          	auipc	ra,0x0
     5b0:	aa8080e7          	jalr	-1368(ra) # 54 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5b4:	4701                	li	a4,0
     5b6:	4681                	li	a3,0
     5b8:	f9043603          	ld	a2,-112(s0)
     5bc:	f9843583          	ld	a1,-104(s0)
     5c0:	8552                	mv	a0,s4
     5c2:	00000097          	auipc	ra,0x0
     5c6:	cda080e7          	jalr	-806(ra) # 29c <redircmd>
     5ca:	8a2a                	mv	s4,a0
    switch(tok){
     5cc:	03e00b13          	li	s6,62
     5d0:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     5d4:	865e                	mv	a2,s7
     5d6:	85ca                	mv	a1,s2
     5d8:	854e                	mv	a0,s3
     5da:	00000097          	auipc	ra,0x0
     5de:	f2e080e7          	jalr	-210(ra) # 508 <peek>
     5e2:	c925                	beqz	a0,652 <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
     5e4:	4681                	li	a3,0
     5e6:	4601                	li	a2,0
     5e8:	85ca                	mv	a1,s2
     5ea:	854e                	mv	a0,s3
     5ec:	00000097          	auipc	ra,0x0
     5f0:	de0080e7          	jalr	-544(ra) # 3cc <gettoken>
     5f4:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     5f6:	f9040693          	addi	a3,s0,-112
     5fa:	f9840613          	addi	a2,s0,-104
     5fe:	85ca                	mv	a1,s2
     600:	854e                	mv	a0,s3
     602:	00000097          	auipc	ra,0x0
     606:	dca080e7          	jalr	-566(ra) # 3cc <gettoken>
     60a:	f9851de3          	bne	a0,s8,5a4 <parseredirs+0x32>
    switch(tok){
     60e:	fb9483e3          	beq	s1,s9,5b4 <parseredirs+0x42>
     612:	03648263          	beq	s1,s6,636 <parseredirs+0xc4>
     616:	fb549fe3          	bne	s1,s5,5d4 <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     61a:	4705                	li	a4,1
     61c:	20100693          	li	a3,513
     620:	f9043603          	ld	a2,-112(s0)
     624:	f9843583          	ld	a1,-104(s0)
     628:	8552                	mv	a0,s4
     62a:	00000097          	auipc	ra,0x0
     62e:	c72080e7          	jalr	-910(ra) # 29c <redircmd>
     632:	8a2a                	mv	s4,a0
      break;
     634:	bf61                	j	5cc <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     636:	4705                	li	a4,1
     638:	20100693          	li	a3,513
     63c:	f9043603          	ld	a2,-112(s0)
     640:	f9843583          	ld	a1,-104(s0)
     644:	8552                	mv	a0,s4
     646:	00000097          	auipc	ra,0x0
     64a:	c56080e7          	jalr	-938(ra) # 29c <redircmd>
     64e:	8a2a                	mv	s4,a0
      break;
     650:	bfb5                	j	5cc <parseredirs+0x5a>
    }
  }
  return cmd;
}
     652:	8552                	mv	a0,s4
     654:	70a6                	ld	ra,104(sp)
     656:	7406                	ld	s0,96(sp)
     658:	64e6                	ld	s1,88(sp)
     65a:	6946                	ld	s2,80(sp)
     65c:	69a6                	ld	s3,72(sp)
     65e:	6a06                	ld	s4,64(sp)
     660:	7ae2                	ld	s5,56(sp)
     662:	7b42                	ld	s6,48(sp)
     664:	7ba2                	ld	s7,40(sp)
     666:	7c02                	ld	s8,32(sp)
     668:	6ce2                	ld	s9,24(sp)
     66a:	6165                	addi	sp,sp,112
     66c:	8082                	ret

000000000000066e <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     66e:	7159                	addi	sp,sp,-112
     670:	f486                	sd	ra,104(sp)
     672:	f0a2                	sd	s0,96(sp)
     674:	eca6                	sd	s1,88(sp)
     676:	e8ca                	sd	s2,80(sp)
     678:	e4ce                	sd	s3,72(sp)
     67a:	e0d2                	sd	s4,64(sp)
     67c:	fc56                	sd	s5,56(sp)
     67e:	f85a                	sd	s6,48(sp)
     680:	f45e                	sd	s7,40(sp)
     682:	f062                	sd	s8,32(sp)
     684:	ec66                	sd	s9,24(sp)
     686:	1880                	addi	s0,sp,112
     688:	8a2a                	mv	s4,a0
     68a:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     68c:	00001617          	auipc	a2,0x1
     690:	c5460613          	addi	a2,a2,-940 # 12e0 <malloc+0x15c>
     694:	00000097          	auipc	ra,0x0
     698:	e74080e7          	jalr	-396(ra) # 508 <peek>
     69c:	e905                	bnez	a0,6cc <parseexec+0x5e>
     69e:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6a0:	00000097          	auipc	ra,0x0
     6a4:	bc6080e7          	jalr	-1082(ra) # 266 <execcmd>
     6a8:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6aa:	8656                	mv	a2,s5
     6ac:	85d2                	mv	a1,s4
     6ae:	00000097          	auipc	ra,0x0
     6b2:	ec4080e7          	jalr	-316(ra) # 572 <parseredirs>
     6b6:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6b8:	008c0913          	addi	s2,s8,8
     6bc:	00001b17          	auipc	s6,0x1
     6c0:	c44b0b13          	addi	s6,s6,-956 # 1300 <malloc+0x17c>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     6c4:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6c8:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     6ca:	a0b1                	j	716 <parseexec+0xa8>
    return parseblock(ps, es);
     6cc:	85d6                	mv	a1,s5
     6ce:	8552                	mv	a0,s4
     6d0:	00000097          	auipc	ra,0x0
     6d4:	1bc080e7          	jalr	444(ra) # 88c <parseblock>
     6d8:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     6da:	8526                	mv	a0,s1
     6dc:	70a6                	ld	ra,104(sp)
     6de:	7406                	ld	s0,96(sp)
     6e0:	64e6                	ld	s1,88(sp)
     6e2:	6946                	ld	s2,80(sp)
     6e4:	69a6                	ld	s3,72(sp)
     6e6:	6a06                	ld	s4,64(sp)
     6e8:	7ae2                	ld	s5,56(sp)
     6ea:	7b42                	ld	s6,48(sp)
     6ec:	7ba2                	ld	s7,40(sp)
     6ee:	7c02                	ld	s8,32(sp)
     6f0:	6ce2                	ld	s9,24(sp)
     6f2:	6165                	addi	sp,sp,112
     6f4:	8082                	ret
      panic("syntax");
     6f6:	00001517          	auipc	a0,0x1
     6fa:	bf250513          	addi	a0,a0,-1038 # 12e8 <malloc+0x164>
     6fe:	00000097          	auipc	ra,0x0
     702:	956080e7          	jalr	-1706(ra) # 54 <panic>
    ret = parseredirs(ret, ps, es);
     706:	8656                	mv	a2,s5
     708:	85d2                	mv	a1,s4
     70a:	8526                	mv	a0,s1
     70c:	00000097          	auipc	ra,0x0
     710:	e66080e7          	jalr	-410(ra) # 572 <parseredirs>
     714:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     716:	865a                	mv	a2,s6
     718:	85d6                	mv	a1,s5
     71a:	8552                	mv	a0,s4
     71c:	00000097          	auipc	ra,0x0
     720:	dec080e7          	jalr	-532(ra) # 508 <peek>
     724:	e131                	bnez	a0,768 <parseexec+0xfa>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     726:	f9040693          	addi	a3,s0,-112
     72a:	f9840613          	addi	a2,s0,-104
     72e:	85d6                	mv	a1,s5
     730:	8552                	mv	a0,s4
     732:	00000097          	auipc	ra,0x0
     736:	c9a080e7          	jalr	-870(ra) # 3cc <gettoken>
     73a:	c51d                	beqz	a0,768 <parseexec+0xfa>
    if(tok != 'a')
     73c:	fb951de3          	bne	a0,s9,6f6 <parseexec+0x88>
    cmd->argv[argc] = q;
     740:	f9843783          	ld	a5,-104(s0)
     744:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     748:	f9043783          	ld	a5,-112(s0)
     74c:	04f93823          	sd	a5,80(s2)
    argc++;
     750:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     752:	0921                	addi	s2,s2,8
     754:	fb7999e3          	bne	s3,s7,706 <parseexec+0x98>
      panic("too many args");
     758:	00001517          	auipc	a0,0x1
     75c:	b9850513          	addi	a0,a0,-1128 # 12f0 <malloc+0x16c>
     760:	00000097          	auipc	ra,0x0
     764:	8f4080e7          	jalr	-1804(ra) # 54 <panic>
  cmd->argv[argc] = 0;
     768:	098e                	slli	s3,s3,0x3
     76a:	99e2                	add	s3,s3,s8
     76c:	0009b423          	sd	zero,8(s3)
  cmd->eargv[argc] = 0;
     770:	0409bc23          	sd	zero,88(s3)
  return ret;
     774:	b79d                	j	6da <parseexec+0x6c>

0000000000000776 <parsepipe>:
{
     776:	7179                	addi	sp,sp,-48
     778:	f406                	sd	ra,40(sp)
     77a:	f022                	sd	s0,32(sp)
     77c:	ec26                	sd	s1,24(sp)
     77e:	e84a                	sd	s2,16(sp)
     780:	e44e                	sd	s3,8(sp)
     782:	1800                	addi	s0,sp,48
     784:	892a                	mv	s2,a0
     786:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     788:	00000097          	auipc	ra,0x0
     78c:	ee6080e7          	jalr	-282(ra) # 66e <parseexec>
     790:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     792:	00001617          	auipc	a2,0x1
     796:	b7660613          	addi	a2,a2,-1162 # 1308 <malloc+0x184>
     79a:	85ce                	mv	a1,s3
     79c:	854a                	mv	a0,s2
     79e:	00000097          	auipc	ra,0x0
     7a2:	d6a080e7          	jalr	-662(ra) # 508 <peek>
     7a6:	e909                	bnez	a0,7b8 <parsepipe+0x42>
}
     7a8:	8526                	mv	a0,s1
     7aa:	70a2                	ld	ra,40(sp)
     7ac:	7402                	ld	s0,32(sp)
     7ae:	64e2                	ld	s1,24(sp)
     7b0:	6942                	ld	s2,16(sp)
     7b2:	69a2                	ld	s3,8(sp)
     7b4:	6145                	addi	sp,sp,48
     7b6:	8082                	ret
    gettoken(ps, es, 0, 0);
     7b8:	4681                	li	a3,0
     7ba:	4601                	li	a2,0
     7bc:	85ce                	mv	a1,s3
     7be:	854a                	mv	a0,s2
     7c0:	00000097          	auipc	ra,0x0
     7c4:	c0c080e7          	jalr	-1012(ra) # 3cc <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7c8:	85ce                	mv	a1,s3
     7ca:	854a                	mv	a0,s2
     7cc:	00000097          	auipc	ra,0x0
     7d0:	faa080e7          	jalr	-86(ra) # 776 <parsepipe>
     7d4:	85aa                	mv	a1,a0
     7d6:	8526                	mv	a0,s1
     7d8:	00000097          	auipc	ra,0x0
     7dc:	b2c080e7          	jalr	-1236(ra) # 304 <pipecmd>
     7e0:	84aa                	mv	s1,a0
  return cmd;
     7e2:	b7d9                	j	7a8 <parsepipe+0x32>

00000000000007e4 <parseline>:
{
     7e4:	7179                	addi	sp,sp,-48
     7e6:	f406                	sd	ra,40(sp)
     7e8:	f022                	sd	s0,32(sp)
     7ea:	ec26                	sd	s1,24(sp)
     7ec:	e84a                	sd	s2,16(sp)
     7ee:	e44e                	sd	s3,8(sp)
     7f0:	e052                	sd	s4,0(sp)
     7f2:	1800                	addi	s0,sp,48
     7f4:	892a                	mv	s2,a0
     7f6:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     7f8:	00000097          	auipc	ra,0x0
     7fc:	f7e080e7          	jalr	-130(ra) # 776 <parsepipe>
     800:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     802:	00001a17          	auipc	s4,0x1
     806:	b0ea0a13          	addi	s4,s4,-1266 # 1310 <malloc+0x18c>
     80a:	a839                	j	828 <parseline+0x44>
    gettoken(ps, es, 0, 0);
     80c:	4681                	li	a3,0
     80e:	4601                	li	a2,0
     810:	85ce                	mv	a1,s3
     812:	854a                	mv	a0,s2
     814:	00000097          	auipc	ra,0x0
     818:	bb8080e7          	jalr	-1096(ra) # 3cc <gettoken>
    cmd = backcmd(cmd);
     81c:	8526                	mv	a0,s1
     81e:	00000097          	auipc	ra,0x0
     822:	b72080e7          	jalr	-1166(ra) # 390 <backcmd>
     826:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     828:	8652                	mv	a2,s4
     82a:	85ce                	mv	a1,s3
     82c:	854a                	mv	a0,s2
     82e:	00000097          	auipc	ra,0x0
     832:	cda080e7          	jalr	-806(ra) # 508 <peek>
     836:	f979                	bnez	a0,80c <parseline+0x28>
  if(peek(ps, es, ";")){
     838:	00001617          	auipc	a2,0x1
     83c:	ae060613          	addi	a2,a2,-1312 # 1318 <malloc+0x194>
     840:	85ce                	mv	a1,s3
     842:	854a                	mv	a0,s2
     844:	00000097          	auipc	ra,0x0
     848:	cc4080e7          	jalr	-828(ra) # 508 <peek>
     84c:	e911                	bnez	a0,860 <parseline+0x7c>
}
     84e:	8526                	mv	a0,s1
     850:	70a2                	ld	ra,40(sp)
     852:	7402                	ld	s0,32(sp)
     854:	64e2                	ld	s1,24(sp)
     856:	6942                	ld	s2,16(sp)
     858:	69a2                	ld	s3,8(sp)
     85a:	6a02                	ld	s4,0(sp)
     85c:	6145                	addi	sp,sp,48
     85e:	8082                	ret
    gettoken(ps, es, 0, 0);
     860:	4681                	li	a3,0
     862:	4601                	li	a2,0
     864:	85ce                	mv	a1,s3
     866:	854a                	mv	a0,s2
     868:	00000097          	auipc	ra,0x0
     86c:	b64080e7          	jalr	-1180(ra) # 3cc <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     870:	85ce                	mv	a1,s3
     872:	854a                	mv	a0,s2
     874:	00000097          	auipc	ra,0x0
     878:	f70080e7          	jalr	-144(ra) # 7e4 <parseline>
     87c:	85aa                	mv	a1,a0
     87e:	8526                	mv	a0,s1
     880:	00000097          	auipc	ra,0x0
     884:	aca080e7          	jalr	-1334(ra) # 34a <listcmd>
     888:	84aa                	mv	s1,a0
  return cmd;
     88a:	b7d1                	j	84e <parseline+0x6a>

000000000000088c <parseblock>:
{
     88c:	7179                	addi	sp,sp,-48
     88e:	f406                	sd	ra,40(sp)
     890:	f022                	sd	s0,32(sp)
     892:	ec26                	sd	s1,24(sp)
     894:	e84a                	sd	s2,16(sp)
     896:	e44e                	sd	s3,8(sp)
     898:	1800                	addi	s0,sp,48
     89a:	84aa                	mv	s1,a0
     89c:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     89e:	00001617          	auipc	a2,0x1
     8a2:	a4260613          	addi	a2,a2,-1470 # 12e0 <malloc+0x15c>
     8a6:	00000097          	auipc	ra,0x0
     8aa:	c62080e7          	jalr	-926(ra) # 508 <peek>
     8ae:	c12d                	beqz	a0,910 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8b0:	4681                	li	a3,0
     8b2:	4601                	li	a2,0
     8b4:	85ca                	mv	a1,s2
     8b6:	8526                	mv	a0,s1
     8b8:	00000097          	auipc	ra,0x0
     8bc:	b14080e7          	jalr	-1260(ra) # 3cc <gettoken>
  cmd = parseline(ps, es);
     8c0:	85ca                	mv	a1,s2
     8c2:	8526                	mv	a0,s1
     8c4:	00000097          	auipc	ra,0x0
     8c8:	f20080e7          	jalr	-224(ra) # 7e4 <parseline>
     8cc:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     8ce:	00001617          	auipc	a2,0x1
     8d2:	a6260613          	addi	a2,a2,-1438 # 1330 <malloc+0x1ac>
     8d6:	85ca                	mv	a1,s2
     8d8:	8526                	mv	a0,s1
     8da:	00000097          	auipc	ra,0x0
     8de:	c2e080e7          	jalr	-978(ra) # 508 <peek>
     8e2:	cd1d                	beqz	a0,920 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     8e4:	4681                	li	a3,0
     8e6:	4601                	li	a2,0
     8e8:	85ca                	mv	a1,s2
     8ea:	8526                	mv	a0,s1
     8ec:	00000097          	auipc	ra,0x0
     8f0:	ae0080e7          	jalr	-1312(ra) # 3cc <gettoken>
  cmd = parseredirs(cmd, ps, es);
     8f4:	864a                	mv	a2,s2
     8f6:	85a6                	mv	a1,s1
     8f8:	854e                	mv	a0,s3
     8fa:	00000097          	auipc	ra,0x0
     8fe:	c78080e7          	jalr	-904(ra) # 572 <parseredirs>
}
     902:	70a2                	ld	ra,40(sp)
     904:	7402                	ld	s0,32(sp)
     906:	64e2                	ld	s1,24(sp)
     908:	6942                	ld	s2,16(sp)
     90a:	69a2                	ld	s3,8(sp)
     90c:	6145                	addi	sp,sp,48
     90e:	8082                	ret
    panic("parseblock");
     910:	00001517          	auipc	a0,0x1
     914:	a1050513          	addi	a0,a0,-1520 # 1320 <malloc+0x19c>
     918:	fffff097          	auipc	ra,0xfffff
     91c:	73c080e7          	jalr	1852(ra) # 54 <panic>
    panic("syntax - missing )");
     920:	00001517          	auipc	a0,0x1
     924:	a1850513          	addi	a0,a0,-1512 # 1338 <malloc+0x1b4>
     928:	fffff097          	auipc	ra,0xfffff
     92c:	72c080e7          	jalr	1836(ra) # 54 <panic>

0000000000000930 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     930:	1101                	addi	sp,sp,-32
     932:	ec06                	sd	ra,24(sp)
     934:	e822                	sd	s0,16(sp)
     936:	e426                	sd	s1,8(sp)
     938:	1000                	addi	s0,sp,32
     93a:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     93c:	c521                	beqz	a0,984 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     93e:	4118                	lw	a4,0(a0)
     940:	4795                	li	a5,5
     942:	04e7e163          	bltu	a5,a4,984 <nulterminate+0x54>
     946:	00056783          	lwu	a5,0(a0)
     94a:	078a                	slli	a5,a5,0x2
     94c:	00001717          	auipc	a4,0x1
     950:	a4c70713          	addi	a4,a4,-1460 # 1398 <malloc+0x214>
     954:	97ba                	add	a5,a5,a4
     956:	439c                	lw	a5,0(a5)
     958:	97ba                	add	a5,a5,a4
     95a:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     95c:	651c                	ld	a5,8(a0)
     95e:	c39d                	beqz	a5,984 <nulterminate+0x54>
     960:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     964:	67b8                	ld	a4,72(a5)
     966:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     96a:	07a1                	addi	a5,a5,8
     96c:	ff87b703          	ld	a4,-8(a5)
     970:	fb75                	bnez	a4,964 <nulterminate+0x34>
     972:	a809                	j	984 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     974:	6508                	ld	a0,8(a0)
     976:	00000097          	auipc	ra,0x0
     97a:	fba080e7          	jalr	-70(ra) # 930 <nulterminate>
    *rcmd->efile = 0;
     97e:	6c9c                	ld	a5,24(s1)
     980:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     984:	8526                	mv	a0,s1
     986:	60e2                	ld	ra,24(sp)
     988:	6442                	ld	s0,16(sp)
     98a:	64a2                	ld	s1,8(sp)
     98c:	6105                	addi	sp,sp,32
     98e:	8082                	ret
    nulterminate(pcmd->left);
     990:	6508                	ld	a0,8(a0)
     992:	00000097          	auipc	ra,0x0
     996:	f9e080e7          	jalr	-98(ra) # 930 <nulterminate>
    nulterminate(pcmd->right);
     99a:	6888                	ld	a0,16(s1)
     99c:	00000097          	auipc	ra,0x0
     9a0:	f94080e7          	jalr	-108(ra) # 930 <nulterminate>
    break;
     9a4:	b7c5                	j	984 <nulterminate+0x54>
    nulterminate(lcmd->left);
     9a6:	6508                	ld	a0,8(a0)
     9a8:	00000097          	auipc	ra,0x0
     9ac:	f88080e7          	jalr	-120(ra) # 930 <nulterminate>
    nulterminate(lcmd->right);
     9b0:	6888                	ld	a0,16(s1)
     9b2:	00000097          	auipc	ra,0x0
     9b6:	f7e080e7          	jalr	-130(ra) # 930 <nulterminate>
    break;
     9ba:	b7e9                	j	984 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9bc:	6508                	ld	a0,8(a0)
     9be:	00000097          	auipc	ra,0x0
     9c2:	f72080e7          	jalr	-142(ra) # 930 <nulterminate>
    break;
     9c6:	bf7d                	j	984 <nulterminate+0x54>

00000000000009c8 <parsecmd>:
{
     9c8:	7179                	addi	sp,sp,-48
     9ca:	f406                	sd	ra,40(sp)
     9cc:	f022                	sd	s0,32(sp)
     9ce:	ec26                	sd	s1,24(sp)
     9d0:	e84a                	sd	s2,16(sp)
     9d2:	1800                	addi	s0,sp,48
     9d4:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     9d8:	84aa                	mv	s1,a0
     9da:	00000097          	auipc	ra,0x0
     9de:	1ae080e7          	jalr	430(ra) # b88 <strlen>
     9e2:	1502                	slli	a0,a0,0x20
     9e4:	9101                	srli	a0,a0,0x20
     9e6:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     9e8:	85a6                	mv	a1,s1
     9ea:	fd840513          	addi	a0,s0,-40
     9ee:	00000097          	auipc	ra,0x0
     9f2:	df6080e7          	jalr	-522(ra) # 7e4 <parseline>
     9f6:	892a                	mv	s2,a0
  peek(&s, es, "");
     9f8:	00001617          	auipc	a2,0x1
     9fc:	95860613          	addi	a2,a2,-1704 # 1350 <malloc+0x1cc>
     a00:	85a6                	mv	a1,s1
     a02:	fd840513          	addi	a0,s0,-40
     a06:	00000097          	auipc	ra,0x0
     a0a:	b02080e7          	jalr	-1278(ra) # 508 <peek>
  if(s != es){
     a0e:	fd843603          	ld	a2,-40(s0)
     a12:	00961e63          	bne	a2,s1,a2e <parsecmd+0x66>
  nulterminate(cmd);
     a16:	854a                	mv	a0,s2
     a18:	00000097          	auipc	ra,0x0
     a1c:	f18080e7          	jalr	-232(ra) # 930 <nulterminate>
}
     a20:	854a                	mv	a0,s2
     a22:	70a2                	ld	ra,40(sp)
     a24:	7402                	ld	s0,32(sp)
     a26:	64e2                	ld	s1,24(sp)
     a28:	6942                	ld	s2,16(sp)
     a2a:	6145                	addi	sp,sp,48
     a2c:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a2e:	00001597          	auipc	a1,0x1
     a32:	92a58593          	addi	a1,a1,-1750 # 1358 <malloc+0x1d4>
     a36:	4509                	li	a0,2
     a38:	00000097          	auipc	ra,0x0
     a3c:	660080e7          	jalr	1632(ra) # 1098 <fprintf>
    panic("syntax");
     a40:	00001517          	auipc	a0,0x1
     a44:	8a850513          	addi	a0,a0,-1880 # 12e8 <malloc+0x164>
     a48:	fffff097          	auipc	ra,0xfffff
     a4c:	60c080e7          	jalr	1548(ra) # 54 <panic>

0000000000000a50 <main>:
{
     a50:	7139                	addi	sp,sp,-64
     a52:	fc06                	sd	ra,56(sp)
     a54:	f822                	sd	s0,48(sp)
     a56:	f426                	sd	s1,40(sp)
     a58:	f04a                	sd	s2,32(sp)
     a5a:	ec4e                	sd	s3,24(sp)
     a5c:	e852                	sd	s4,16(sp)
     a5e:	e456                	sd	s5,8(sp)
     a60:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     a62:	00001497          	auipc	s1,0x1
     a66:	90648493          	addi	s1,s1,-1786 # 1368 <malloc+0x1e4>
     a6a:	4589                	li	a1,2
     a6c:	8526                	mv	a0,s1
     a6e:	00000097          	auipc	ra,0x0
     a72:	300080e7          	jalr	768(ra) # d6e <open>
     a76:	00054963          	bltz	a0,a88 <main+0x38>
    if(fd >= 3){
     a7a:	4789                	li	a5,2
     a7c:	fea7d7e3          	bge	a5,a0,a6a <main+0x1a>
      close(fd);
     a80:	00000097          	auipc	ra,0x0
     a84:	2d6080e7          	jalr	726(ra) # d56 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     a88:	00001497          	auipc	s1,0x1
     a8c:	96048493          	addi	s1,s1,-1696 # 13e8 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     a90:	06300913          	li	s2,99
     a94:	02000993          	li	s3,32
      if(chdir(buf+3) < 0)
     a98:	00001a17          	auipc	s4,0x1
     a9c:	953a0a13          	addi	s4,s4,-1709 # 13eb <buf.0+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     aa0:	00001a97          	auipc	s5,0x1
     aa4:	8d0a8a93          	addi	s5,s5,-1840 # 1370 <malloc+0x1ec>
     aa8:	a811                	j	abc <main+0x6c>
    if(fork1() == 0)
     aaa:	fffff097          	auipc	ra,0xfffff
     aae:	5ce080e7          	jalr	1486(ra) # 78 <fork1>
     ab2:	c53d                	beqz	a0,b20 <main+0xd0>
    wait();
     ab4:	00000097          	auipc	ra,0x0
     ab8:	282080e7          	jalr	642(ra) # d36 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     abc:	06400593          	li	a1,100
     ac0:	8526                	mv	a0,s1
     ac2:	fffff097          	auipc	ra,0xfffff
     ac6:	53e080e7          	jalr	1342(ra) # 0 <getcmd>
     aca:	06054763          	bltz	a0,b38 <main+0xe8>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ace:	0004c783          	lbu	a5,0(s1)
     ad2:	fd279ce3          	bne	a5,s2,aaa <main+0x5a>
     ad6:	0014c703          	lbu	a4,1(s1)
     ada:	06400793          	li	a5,100
     ade:	fcf716e3          	bne	a4,a5,aaa <main+0x5a>
     ae2:	0024c783          	lbu	a5,2(s1)
     ae6:	fd3792e3          	bne	a5,s3,aaa <main+0x5a>
      buf[strlen(buf)-1] = 0;  // chop \n
     aea:	8526                	mv	a0,s1
     aec:	00000097          	auipc	ra,0x0
     af0:	09c080e7          	jalr	156(ra) # b88 <strlen>
     af4:	fff5079b          	addiw	a5,a0,-1
     af8:	1782                	slli	a5,a5,0x20
     afa:	9381                	srli	a5,a5,0x20
     afc:	97a6                	add	a5,a5,s1
     afe:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     b02:	8552                	mv	a0,s4
     b04:	00000097          	auipc	ra,0x0
     b08:	29a080e7          	jalr	666(ra) # d9e <chdir>
     b0c:	fa0558e3          	bgez	a0,abc <main+0x6c>
        fprintf(2, "cannot cd %s\n", buf+3);
     b10:	8652                	mv	a2,s4
     b12:	85d6                	mv	a1,s5
     b14:	4509                	li	a0,2
     b16:	00000097          	auipc	ra,0x0
     b1a:	582080e7          	jalr	1410(ra) # 1098 <fprintf>
     b1e:	bf79                	j	abc <main+0x6c>
      runcmd(parsecmd(buf));
     b20:	00001517          	auipc	a0,0x1
     b24:	8c850513          	addi	a0,a0,-1848 # 13e8 <buf.0>
     b28:	00000097          	auipc	ra,0x0
     b2c:	ea0080e7          	jalr	-352(ra) # 9c8 <parsecmd>
     b30:	fffff097          	auipc	ra,0xfffff
     b34:	576080e7          	jalr	1398(ra) # a6 <runcmd>
  exit();
     b38:	00000097          	auipc	ra,0x0
     b3c:	1f6080e7          	jalr	502(ra) # d2e <exit>

0000000000000b40 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     b40:	1141                	addi	sp,sp,-16
     b42:	e422                	sd	s0,8(sp)
     b44:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b46:	87aa                	mv	a5,a0
     b48:	0585                	addi	a1,a1,1
     b4a:	0785                	addi	a5,a5,1
     b4c:	fff5c703          	lbu	a4,-1(a1)
     b50:	fee78fa3          	sb	a4,-1(a5)
     b54:	fb75                	bnez	a4,b48 <strcpy+0x8>
    ;
  return os;
}
     b56:	6422                	ld	s0,8(sp)
     b58:	0141                	addi	sp,sp,16
     b5a:	8082                	ret

0000000000000b5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b5c:	1141                	addi	sp,sp,-16
     b5e:	e422                	sd	s0,8(sp)
     b60:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     b62:	00054783          	lbu	a5,0(a0)
     b66:	cb91                	beqz	a5,b7a <strcmp+0x1e>
     b68:	0005c703          	lbu	a4,0(a1)
     b6c:	00f71763          	bne	a4,a5,b7a <strcmp+0x1e>
    p++, q++;
     b70:	0505                	addi	a0,a0,1
     b72:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     b74:	00054783          	lbu	a5,0(a0)
     b78:	fbe5                	bnez	a5,b68 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     b7a:	0005c503          	lbu	a0,0(a1)
}
     b7e:	40a7853b          	subw	a0,a5,a0
     b82:	6422                	ld	s0,8(sp)
     b84:	0141                	addi	sp,sp,16
     b86:	8082                	ret

0000000000000b88 <strlen>:

uint
strlen(const char *s)
{
     b88:	1141                	addi	sp,sp,-16
     b8a:	e422                	sd	s0,8(sp)
     b8c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     b8e:	00054783          	lbu	a5,0(a0)
     b92:	cf91                	beqz	a5,bae <strlen+0x26>
     b94:	0505                	addi	a0,a0,1
     b96:	87aa                	mv	a5,a0
     b98:	4685                	li	a3,1
     b9a:	9e89                	subw	a3,a3,a0
     b9c:	00f6853b          	addw	a0,a3,a5
     ba0:	0785                	addi	a5,a5,1
     ba2:	fff7c703          	lbu	a4,-1(a5)
     ba6:	fb7d                	bnez	a4,b9c <strlen+0x14>
    ;
  return n;
}
     ba8:	6422                	ld	s0,8(sp)
     baa:	0141                	addi	sp,sp,16
     bac:	8082                	ret
  for(n = 0; s[n]; n++)
     bae:	4501                	li	a0,0
     bb0:	bfe5                	j	ba8 <strlen+0x20>

0000000000000bb2 <memset>:

void*
memset(void *dst, int c, uint n)
{
     bb2:	1141                	addi	sp,sp,-16
     bb4:	e422                	sd	s0,8(sp)
     bb6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     bb8:	ca19                	beqz	a2,bce <memset+0x1c>
     bba:	87aa                	mv	a5,a0
     bbc:	1602                	slli	a2,a2,0x20
     bbe:	9201                	srli	a2,a2,0x20
     bc0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     bc4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     bc8:	0785                	addi	a5,a5,1
     bca:	fee79de3          	bne	a5,a4,bc4 <memset+0x12>
  }
  return dst;
}
     bce:	6422                	ld	s0,8(sp)
     bd0:	0141                	addi	sp,sp,16
     bd2:	8082                	ret

0000000000000bd4 <strchr>:

char*
strchr(const char *s, char c)
{
     bd4:	1141                	addi	sp,sp,-16
     bd6:	e422                	sd	s0,8(sp)
     bd8:	0800                	addi	s0,sp,16
  for(; *s; s++)
     bda:	00054783          	lbu	a5,0(a0)
     bde:	cb99                	beqz	a5,bf4 <strchr+0x20>
    if(*s == c)
     be0:	00f58763          	beq	a1,a5,bee <strchr+0x1a>
  for(; *s; s++)
     be4:	0505                	addi	a0,a0,1
     be6:	00054783          	lbu	a5,0(a0)
     bea:	fbfd                	bnez	a5,be0 <strchr+0xc>
      return (char*)s;
  return 0;
     bec:	4501                	li	a0,0
}
     bee:	6422                	ld	s0,8(sp)
     bf0:	0141                	addi	sp,sp,16
     bf2:	8082                	ret
  return 0;
     bf4:	4501                	li	a0,0
     bf6:	bfe5                	j	bee <strchr+0x1a>

0000000000000bf8 <gets>:

char*
gets(char *buf, int max)
{
     bf8:	711d                	addi	sp,sp,-96
     bfa:	ec86                	sd	ra,88(sp)
     bfc:	e8a2                	sd	s0,80(sp)
     bfe:	e4a6                	sd	s1,72(sp)
     c00:	e0ca                	sd	s2,64(sp)
     c02:	fc4e                	sd	s3,56(sp)
     c04:	f852                	sd	s4,48(sp)
     c06:	f456                	sd	s5,40(sp)
     c08:	f05a                	sd	s6,32(sp)
     c0a:	ec5e                	sd	s7,24(sp)
     c0c:	1080                	addi	s0,sp,96
     c0e:	8baa                	mv	s7,a0
     c10:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c12:	892a                	mv	s2,a0
     c14:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c16:	4aa9                	li	s5,10
     c18:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c1a:	89a6                	mv	s3,s1
     c1c:	2485                	addiw	s1,s1,1
     c1e:	0344d863          	bge	s1,s4,c4e <gets+0x56>
    cc = read(0, &c, 1);
     c22:	4605                	li	a2,1
     c24:	faf40593          	addi	a1,s0,-81
     c28:	4501                	li	a0,0
     c2a:	00000097          	auipc	ra,0x0
     c2e:	11c080e7          	jalr	284(ra) # d46 <read>
    if(cc < 1)
     c32:	00a05e63          	blez	a0,c4e <gets+0x56>
    buf[i++] = c;
     c36:	faf44783          	lbu	a5,-81(s0)
     c3a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c3e:	01578763          	beq	a5,s5,c4c <gets+0x54>
     c42:	0905                	addi	s2,s2,1
     c44:	fd679be3          	bne	a5,s6,c1a <gets+0x22>
  for(i=0; i+1 < max; ){
     c48:	89a6                	mv	s3,s1
     c4a:	a011                	j	c4e <gets+0x56>
     c4c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c4e:	99de                	add	s3,s3,s7
     c50:	00098023          	sb	zero,0(s3)
  return buf;
}
     c54:	855e                	mv	a0,s7
     c56:	60e6                	ld	ra,88(sp)
     c58:	6446                	ld	s0,80(sp)
     c5a:	64a6                	ld	s1,72(sp)
     c5c:	6906                	ld	s2,64(sp)
     c5e:	79e2                	ld	s3,56(sp)
     c60:	7a42                	ld	s4,48(sp)
     c62:	7aa2                	ld	s5,40(sp)
     c64:	7b02                	ld	s6,32(sp)
     c66:	6be2                	ld	s7,24(sp)
     c68:	6125                	addi	sp,sp,96
     c6a:	8082                	ret

0000000000000c6c <stat>:

int
stat(const char *n, struct stat *st)
{
     c6c:	1101                	addi	sp,sp,-32
     c6e:	ec06                	sd	ra,24(sp)
     c70:	e822                	sd	s0,16(sp)
     c72:	e426                	sd	s1,8(sp)
     c74:	e04a                	sd	s2,0(sp)
     c76:	1000                	addi	s0,sp,32
     c78:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c7a:	4581                	li	a1,0
     c7c:	00000097          	auipc	ra,0x0
     c80:	0f2080e7          	jalr	242(ra) # d6e <open>
  if(fd < 0)
     c84:	02054563          	bltz	a0,cae <stat+0x42>
     c88:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     c8a:	85ca                	mv	a1,s2
     c8c:	00000097          	auipc	ra,0x0
     c90:	0fa080e7          	jalr	250(ra) # d86 <fstat>
     c94:	892a                	mv	s2,a0
  close(fd);
     c96:	8526                	mv	a0,s1
     c98:	00000097          	auipc	ra,0x0
     c9c:	0be080e7          	jalr	190(ra) # d56 <close>
  return r;
}
     ca0:	854a                	mv	a0,s2
     ca2:	60e2                	ld	ra,24(sp)
     ca4:	6442                	ld	s0,16(sp)
     ca6:	64a2                	ld	s1,8(sp)
     ca8:	6902                	ld	s2,0(sp)
     caa:	6105                	addi	sp,sp,32
     cac:	8082                	ret
    return -1;
     cae:	597d                	li	s2,-1
     cb0:	bfc5                	j	ca0 <stat+0x34>

0000000000000cb2 <atoi>:

int
atoi(const char *s)
{
     cb2:	1141                	addi	sp,sp,-16
     cb4:	e422                	sd	s0,8(sp)
     cb6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     cb8:	00054603          	lbu	a2,0(a0)
     cbc:	fd06079b          	addiw	a5,a2,-48
     cc0:	0ff7f793          	andi	a5,a5,255
     cc4:	4725                	li	a4,9
     cc6:	02f76963          	bltu	a4,a5,cf8 <atoi+0x46>
     cca:	86aa                	mv	a3,a0
  n = 0;
     ccc:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     cce:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     cd0:	0685                	addi	a3,a3,1
     cd2:	0025179b          	slliw	a5,a0,0x2
     cd6:	9fa9                	addw	a5,a5,a0
     cd8:	0017979b          	slliw	a5,a5,0x1
     cdc:	9fb1                	addw	a5,a5,a2
     cde:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     ce2:	0006c603          	lbu	a2,0(a3)
     ce6:	fd06071b          	addiw	a4,a2,-48
     cea:	0ff77713          	andi	a4,a4,255
     cee:	fee5f1e3          	bgeu	a1,a4,cd0 <atoi+0x1e>
  return n;
}
     cf2:	6422                	ld	s0,8(sp)
     cf4:	0141                	addi	sp,sp,16
     cf6:	8082                	ret
  n = 0;
     cf8:	4501                	li	a0,0
     cfa:	bfe5                	j	cf2 <atoi+0x40>

0000000000000cfc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     cfc:	1141                	addi	sp,sp,-16
     cfe:	e422                	sd	s0,8(sp)
     d00:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d02:	00c05f63          	blez	a2,d20 <memmove+0x24>
     d06:	1602                	slli	a2,a2,0x20
     d08:	9201                	srli	a2,a2,0x20
     d0a:	00c506b3          	add	a3,a0,a2
  dst = vdst;
     d0e:	87aa                	mv	a5,a0
    *dst++ = *src++;
     d10:	0585                	addi	a1,a1,1
     d12:	0785                	addi	a5,a5,1
     d14:	fff5c703          	lbu	a4,-1(a1)
     d18:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
     d1c:	fed79ae3          	bne	a5,a3,d10 <memmove+0x14>
  return vdst;
}
     d20:	6422                	ld	s0,8(sp)
     d22:	0141                	addi	sp,sp,16
     d24:	8082                	ret

0000000000000d26 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     d26:	4885                	li	a7,1
 ecall
     d28:	00000073          	ecall
 ret
     d2c:	8082                	ret

0000000000000d2e <exit>:
.global exit
exit:
 li a7, SYS_exit
     d2e:	4889                	li	a7,2
 ecall
     d30:	00000073          	ecall
 ret
     d34:	8082                	ret

0000000000000d36 <wait>:
.global wait
wait:
 li a7, SYS_wait
     d36:	488d                	li	a7,3
 ecall
     d38:	00000073          	ecall
 ret
     d3c:	8082                	ret

0000000000000d3e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     d3e:	4891                	li	a7,4
 ecall
     d40:	00000073          	ecall
 ret
     d44:	8082                	ret

0000000000000d46 <read>:
.global read
read:
 li a7, SYS_read
     d46:	4895                	li	a7,5
 ecall
     d48:	00000073          	ecall
 ret
     d4c:	8082                	ret

0000000000000d4e <write>:
.global write
write:
 li a7, SYS_write
     d4e:	48c1                	li	a7,16
 ecall
     d50:	00000073          	ecall
 ret
     d54:	8082                	ret

0000000000000d56 <close>:
.global close
close:
 li a7, SYS_close
     d56:	48d5                	li	a7,21
 ecall
     d58:	00000073          	ecall
 ret
     d5c:	8082                	ret

0000000000000d5e <kill>:
.global kill
kill:
 li a7, SYS_kill
     d5e:	4899                	li	a7,6
 ecall
     d60:	00000073          	ecall
 ret
     d64:	8082                	ret

0000000000000d66 <exec>:
.global exec
exec:
 li a7, SYS_exec
     d66:	489d                	li	a7,7
 ecall
     d68:	00000073          	ecall
 ret
     d6c:	8082                	ret

0000000000000d6e <open>:
.global open
open:
 li a7, SYS_open
     d6e:	48bd                	li	a7,15
 ecall
     d70:	00000073          	ecall
 ret
     d74:	8082                	ret

0000000000000d76 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     d76:	48c5                	li	a7,17
 ecall
     d78:	00000073          	ecall
 ret
     d7c:	8082                	ret

0000000000000d7e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     d7e:	48c9                	li	a7,18
 ecall
     d80:	00000073          	ecall
 ret
     d84:	8082                	ret

0000000000000d86 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     d86:	48a1                	li	a7,8
 ecall
     d88:	00000073          	ecall
 ret
     d8c:	8082                	ret

0000000000000d8e <link>:
.global link
link:
 li a7, SYS_link
     d8e:	48cd                	li	a7,19
 ecall
     d90:	00000073          	ecall
 ret
     d94:	8082                	ret

0000000000000d96 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     d96:	48d1                	li	a7,20
 ecall
     d98:	00000073          	ecall
 ret
     d9c:	8082                	ret

0000000000000d9e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     d9e:	48a5                	li	a7,9
 ecall
     da0:	00000073          	ecall
 ret
     da4:	8082                	ret

0000000000000da6 <dup>:
.global dup
dup:
 li a7, SYS_dup
     da6:	48a9                	li	a7,10
 ecall
     da8:	00000073          	ecall
 ret
     dac:	8082                	ret

0000000000000dae <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     dae:	48ad                	li	a7,11
 ecall
     db0:	00000073          	ecall
 ret
     db4:	8082                	ret

0000000000000db6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     db6:	48b1                	li	a7,12
 ecall
     db8:	00000073          	ecall
 ret
     dbc:	8082                	ret

0000000000000dbe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     dbe:	48b5                	li	a7,13
 ecall
     dc0:	00000073          	ecall
 ret
     dc4:	8082                	ret

0000000000000dc6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     dc6:	48b9                	li	a7,14
 ecall
     dc8:	00000073          	ecall
 ret
     dcc:	8082                	ret

0000000000000dce <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
     dce:	48d9                	li	a7,22
 ecall
     dd0:	00000073          	ecall
 ret
     dd4:	8082                	ret

0000000000000dd6 <crash>:
.global crash
crash:
 li a7, SYS_crash
     dd6:	48dd                	li	a7,23
 ecall
     dd8:	00000073          	ecall
 ret
     ddc:	8082                	ret

0000000000000dde <mount>:
.global mount
mount:
 li a7, SYS_mount
     dde:	48e1                	li	a7,24
 ecall
     de0:	00000073          	ecall
 ret
     de4:	8082                	ret

0000000000000de6 <umount>:
.global umount
umount:
 li a7, SYS_umount
     de6:	48e5                	li	a7,25
 ecall
     de8:	00000073          	ecall
 ret
     dec:	8082                	ret

0000000000000dee <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     dee:	1101                	addi	sp,sp,-32
     df0:	ec06                	sd	ra,24(sp)
     df2:	e822                	sd	s0,16(sp)
     df4:	1000                	addi	s0,sp,32
     df6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     dfa:	4605                	li	a2,1
     dfc:	fef40593          	addi	a1,s0,-17
     e00:	00000097          	auipc	ra,0x0
     e04:	f4e080e7          	jalr	-178(ra) # d4e <write>
}
     e08:	60e2                	ld	ra,24(sp)
     e0a:	6442                	ld	s0,16(sp)
     e0c:	6105                	addi	sp,sp,32
     e0e:	8082                	ret

0000000000000e10 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e10:	7139                	addi	sp,sp,-64
     e12:	fc06                	sd	ra,56(sp)
     e14:	f822                	sd	s0,48(sp)
     e16:	f426                	sd	s1,40(sp)
     e18:	f04a                	sd	s2,32(sp)
     e1a:	ec4e                	sd	s3,24(sp)
     e1c:	0080                	addi	s0,sp,64
     e1e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e20:	c299                	beqz	a3,e26 <printint+0x16>
     e22:	0805c863          	bltz	a1,eb2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     e26:	2581                	sext.w	a1,a1
  neg = 0;
     e28:	4881                	li	a7,0
     e2a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     e2e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     e30:	2601                	sext.w	a2,a2
     e32:	00000517          	auipc	a0,0x0
     e36:	58650513          	addi	a0,a0,1414 # 13b8 <digits>
     e3a:	883a                	mv	a6,a4
     e3c:	2705                	addiw	a4,a4,1
     e3e:	02c5f7bb          	remuw	a5,a1,a2
     e42:	1782                	slli	a5,a5,0x20
     e44:	9381                	srli	a5,a5,0x20
     e46:	97aa                	add	a5,a5,a0
     e48:	0007c783          	lbu	a5,0(a5)
     e4c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     e50:	0005879b          	sext.w	a5,a1
     e54:	02c5d5bb          	divuw	a1,a1,a2
     e58:	0685                	addi	a3,a3,1
     e5a:	fec7f0e3          	bgeu	a5,a2,e3a <printint+0x2a>
  if(neg)
     e5e:	00088b63          	beqz	a7,e74 <printint+0x64>
    buf[i++] = '-';
     e62:	fd040793          	addi	a5,s0,-48
     e66:	973e                	add	a4,a4,a5
     e68:	02d00793          	li	a5,45
     e6c:	fef70823          	sb	a5,-16(a4)
     e70:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     e74:	02e05863          	blez	a4,ea4 <printint+0x94>
     e78:	fc040793          	addi	a5,s0,-64
     e7c:	00e78933          	add	s2,a5,a4
     e80:	fff78993          	addi	s3,a5,-1
     e84:	99ba                	add	s3,s3,a4
     e86:	377d                	addiw	a4,a4,-1
     e88:	1702                	slli	a4,a4,0x20
     e8a:	9301                	srli	a4,a4,0x20
     e8c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     e90:	fff94583          	lbu	a1,-1(s2)
     e94:	8526                	mv	a0,s1
     e96:	00000097          	auipc	ra,0x0
     e9a:	f58080e7          	jalr	-168(ra) # dee <putc>
  while(--i >= 0)
     e9e:	197d                	addi	s2,s2,-1
     ea0:	ff3918e3          	bne	s2,s3,e90 <printint+0x80>
}
     ea4:	70e2                	ld	ra,56(sp)
     ea6:	7442                	ld	s0,48(sp)
     ea8:	74a2                	ld	s1,40(sp)
     eaa:	7902                	ld	s2,32(sp)
     eac:	69e2                	ld	s3,24(sp)
     eae:	6121                	addi	sp,sp,64
     eb0:	8082                	ret
    x = -xx;
     eb2:	40b005bb          	negw	a1,a1
    neg = 1;
     eb6:	4885                	li	a7,1
    x = -xx;
     eb8:	bf8d                	j	e2a <printint+0x1a>

0000000000000eba <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     eba:	7119                	addi	sp,sp,-128
     ebc:	fc86                	sd	ra,120(sp)
     ebe:	f8a2                	sd	s0,112(sp)
     ec0:	f4a6                	sd	s1,104(sp)
     ec2:	f0ca                	sd	s2,96(sp)
     ec4:	ecce                	sd	s3,88(sp)
     ec6:	e8d2                	sd	s4,80(sp)
     ec8:	e4d6                	sd	s5,72(sp)
     eca:	e0da                	sd	s6,64(sp)
     ecc:	fc5e                	sd	s7,56(sp)
     ece:	f862                	sd	s8,48(sp)
     ed0:	f466                	sd	s9,40(sp)
     ed2:	f06a                	sd	s10,32(sp)
     ed4:	ec6e                	sd	s11,24(sp)
     ed6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     ed8:	0005c903          	lbu	s2,0(a1)
     edc:	18090f63          	beqz	s2,107a <vprintf+0x1c0>
     ee0:	8aaa                	mv	s5,a0
     ee2:	8b32                	mv	s6,a2
     ee4:	00158493          	addi	s1,a1,1
  state = 0;
     ee8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     eea:	02500a13          	li	s4,37
      if(c == 'd'){
     eee:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     ef2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     ef6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     efa:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     efe:	00000b97          	auipc	s7,0x0
     f02:	4bab8b93          	addi	s7,s7,1210 # 13b8 <digits>
     f06:	a839                	j	f24 <vprintf+0x6a>
        putc(fd, c);
     f08:	85ca                	mv	a1,s2
     f0a:	8556                	mv	a0,s5
     f0c:	00000097          	auipc	ra,0x0
     f10:	ee2080e7          	jalr	-286(ra) # dee <putc>
     f14:	a019                	j	f1a <vprintf+0x60>
    } else if(state == '%'){
     f16:	01498f63          	beq	s3,s4,f34 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     f1a:	0485                	addi	s1,s1,1
     f1c:	fff4c903          	lbu	s2,-1(s1)
     f20:	14090d63          	beqz	s2,107a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     f24:	0009079b          	sext.w	a5,s2
    if(state == 0){
     f28:	fe0997e3          	bnez	s3,f16 <vprintf+0x5c>
      if(c == '%'){
     f2c:	fd479ee3          	bne	a5,s4,f08 <vprintf+0x4e>
        state = '%';
     f30:	89be                	mv	s3,a5
     f32:	b7e5                	j	f1a <vprintf+0x60>
      if(c == 'd'){
     f34:	05878063          	beq	a5,s8,f74 <vprintf+0xba>
      } else if(c == 'l') {
     f38:	05978c63          	beq	a5,s9,f90 <vprintf+0xd6>
      } else if(c == 'x') {
     f3c:	07a78863          	beq	a5,s10,fac <vprintf+0xf2>
      } else if(c == 'p') {
     f40:	09b78463          	beq	a5,s11,fc8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     f44:	07300713          	li	a4,115
     f48:	0ce78663          	beq	a5,a4,1014 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     f4c:	06300713          	li	a4,99
     f50:	0ee78e63          	beq	a5,a4,104c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     f54:	11478863          	beq	a5,s4,1064 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     f58:	85d2                	mv	a1,s4
     f5a:	8556                	mv	a0,s5
     f5c:	00000097          	auipc	ra,0x0
     f60:	e92080e7          	jalr	-366(ra) # dee <putc>
        putc(fd, c);
     f64:	85ca                	mv	a1,s2
     f66:	8556                	mv	a0,s5
     f68:	00000097          	auipc	ra,0x0
     f6c:	e86080e7          	jalr	-378(ra) # dee <putc>
      }
      state = 0;
     f70:	4981                	li	s3,0
     f72:	b765                	j	f1a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     f74:	008b0913          	addi	s2,s6,8
     f78:	4685                	li	a3,1
     f7a:	4629                	li	a2,10
     f7c:	000b2583          	lw	a1,0(s6)
     f80:	8556                	mv	a0,s5
     f82:	00000097          	auipc	ra,0x0
     f86:	e8e080e7          	jalr	-370(ra) # e10 <printint>
     f8a:	8b4a                	mv	s6,s2
      state = 0;
     f8c:	4981                	li	s3,0
     f8e:	b771                	j	f1a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f90:	008b0913          	addi	s2,s6,8
     f94:	4681                	li	a3,0
     f96:	4629                	li	a2,10
     f98:	000b2583          	lw	a1,0(s6)
     f9c:	8556                	mv	a0,s5
     f9e:	00000097          	auipc	ra,0x0
     fa2:	e72080e7          	jalr	-398(ra) # e10 <printint>
     fa6:	8b4a                	mv	s6,s2
      state = 0;
     fa8:	4981                	li	s3,0
     faa:	bf85                	j	f1a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     fac:	008b0913          	addi	s2,s6,8
     fb0:	4681                	li	a3,0
     fb2:	4641                	li	a2,16
     fb4:	000b2583          	lw	a1,0(s6)
     fb8:	8556                	mv	a0,s5
     fba:	00000097          	auipc	ra,0x0
     fbe:	e56080e7          	jalr	-426(ra) # e10 <printint>
     fc2:	8b4a                	mv	s6,s2
      state = 0;
     fc4:	4981                	li	s3,0
     fc6:	bf91                	j	f1a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     fc8:	008b0793          	addi	a5,s6,8
     fcc:	f8f43423          	sd	a5,-120(s0)
     fd0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     fd4:	03000593          	li	a1,48
     fd8:	8556                	mv	a0,s5
     fda:	00000097          	auipc	ra,0x0
     fde:	e14080e7          	jalr	-492(ra) # dee <putc>
  putc(fd, 'x');
     fe2:	85ea                	mv	a1,s10
     fe4:	8556                	mv	a0,s5
     fe6:	00000097          	auipc	ra,0x0
     fea:	e08080e7          	jalr	-504(ra) # dee <putc>
     fee:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     ff0:	03c9d793          	srli	a5,s3,0x3c
     ff4:	97de                	add	a5,a5,s7
     ff6:	0007c583          	lbu	a1,0(a5)
     ffa:	8556                	mv	a0,s5
     ffc:	00000097          	auipc	ra,0x0
    1000:	df2080e7          	jalr	-526(ra) # dee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1004:	0992                	slli	s3,s3,0x4
    1006:	397d                	addiw	s2,s2,-1
    1008:	fe0914e3          	bnez	s2,ff0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    100c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1010:	4981                	li	s3,0
    1012:	b721                	j	f1a <vprintf+0x60>
        s = va_arg(ap, char*);
    1014:	008b0993          	addi	s3,s6,8
    1018:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    101c:	02090163          	beqz	s2,103e <vprintf+0x184>
        while(*s != 0){
    1020:	00094583          	lbu	a1,0(s2)
    1024:	c9a1                	beqz	a1,1074 <vprintf+0x1ba>
          putc(fd, *s);
    1026:	8556                	mv	a0,s5
    1028:	00000097          	auipc	ra,0x0
    102c:	dc6080e7          	jalr	-570(ra) # dee <putc>
          s++;
    1030:	0905                	addi	s2,s2,1
        while(*s != 0){
    1032:	00094583          	lbu	a1,0(s2)
    1036:	f9e5                	bnez	a1,1026 <vprintf+0x16c>
        s = va_arg(ap, char*);
    1038:	8b4e                	mv	s6,s3
      state = 0;
    103a:	4981                	li	s3,0
    103c:	bdf9                	j	f1a <vprintf+0x60>
          s = "(null)";
    103e:	00000917          	auipc	s2,0x0
    1042:	37290913          	addi	s2,s2,882 # 13b0 <malloc+0x22c>
        while(*s != 0){
    1046:	02800593          	li	a1,40
    104a:	bff1                	j	1026 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    104c:	008b0913          	addi	s2,s6,8
    1050:	000b4583          	lbu	a1,0(s6)
    1054:	8556                	mv	a0,s5
    1056:	00000097          	auipc	ra,0x0
    105a:	d98080e7          	jalr	-616(ra) # dee <putc>
    105e:	8b4a                	mv	s6,s2
      state = 0;
    1060:	4981                	li	s3,0
    1062:	bd65                	j	f1a <vprintf+0x60>
        putc(fd, c);
    1064:	85d2                	mv	a1,s4
    1066:	8556                	mv	a0,s5
    1068:	00000097          	auipc	ra,0x0
    106c:	d86080e7          	jalr	-634(ra) # dee <putc>
      state = 0;
    1070:	4981                	li	s3,0
    1072:	b565                	j	f1a <vprintf+0x60>
        s = va_arg(ap, char*);
    1074:	8b4e                	mv	s6,s3
      state = 0;
    1076:	4981                	li	s3,0
    1078:	b54d                	j	f1a <vprintf+0x60>
    }
  }
}
    107a:	70e6                	ld	ra,120(sp)
    107c:	7446                	ld	s0,112(sp)
    107e:	74a6                	ld	s1,104(sp)
    1080:	7906                	ld	s2,96(sp)
    1082:	69e6                	ld	s3,88(sp)
    1084:	6a46                	ld	s4,80(sp)
    1086:	6aa6                	ld	s5,72(sp)
    1088:	6b06                	ld	s6,64(sp)
    108a:	7be2                	ld	s7,56(sp)
    108c:	7c42                	ld	s8,48(sp)
    108e:	7ca2                	ld	s9,40(sp)
    1090:	7d02                	ld	s10,32(sp)
    1092:	6de2                	ld	s11,24(sp)
    1094:	6109                	addi	sp,sp,128
    1096:	8082                	ret

0000000000001098 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1098:	715d                	addi	sp,sp,-80
    109a:	ec06                	sd	ra,24(sp)
    109c:	e822                	sd	s0,16(sp)
    109e:	1000                	addi	s0,sp,32
    10a0:	e010                	sd	a2,0(s0)
    10a2:	e414                	sd	a3,8(s0)
    10a4:	e818                	sd	a4,16(s0)
    10a6:	ec1c                	sd	a5,24(s0)
    10a8:	03043023          	sd	a6,32(s0)
    10ac:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    10b0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    10b4:	8622                	mv	a2,s0
    10b6:	00000097          	auipc	ra,0x0
    10ba:	e04080e7          	jalr	-508(ra) # eba <vprintf>
}
    10be:	60e2                	ld	ra,24(sp)
    10c0:	6442                	ld	s0,16(sp)
    10c2:	6161                	addi	sp,sp,80
    10c4:	8082                	ret

00000000000010c6 <printf>:

void
printf(const char *fmt, ...)
{
    10c6:	711d                	addi	sp,sp,-96
    10c8:	ec06                	sd	ra,24(sp)
    10ca:	e822                	sd	s0,16(sp)
    10cc:	1000                	addi	s0,sp,32
    10ce:	e40c                	sd	a1,8(s0)
    10d0:	e810                	sd	a2,16(s0)
    10d2:	ec14                	sd	a3,24(s0)
    10d4:	f018                	sd	a4,32(s0)
    10d6:	f41c                	sd	a5,40(s0)
    10d8:	03043823          	sd	a6,48(s0)
    10dc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10e0:	00840613          	addi	a2,s0,8
    10e4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10e8:	85aa                	mv	a1,a0
    10ea:	4505                	li	a0,1
    10ec:	00000097          	auipc	ra,0x0
    10f0:	dce080e7          	jalr	-562(ra) # eba <vprintf>
}
    10f4:	60e2                	ld	ra,24(sp)
    10f6:	6442                	ld	s0,16(sp)
    10f8:	6125                	addi	sp,sp,96
    10fa:	8082                	ret

00000000000010fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10fc:	1141                	addi	sp,sp,-16
    10fe:	e422                	sd	s0,8(sp)
    1100:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1102:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1106:	00000797          	auipc	a5,0x0
    110a:	2da7b783          	ld	a5,730(a5) # 13e0 <freep>
    110e:	a805                	j	113e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1110:	4618                	lw	a4,8(a2)
    1112:	9db9                	addw	a1,a1,a4
    1114:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1118:	6398                	ld	a4,0(a5)
    111a:	6318                	ld	a4,0(a4)
    111c:	fee53823          	sd	a4,-16(a0)
    1120:	a091                	j	1164 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1122:	ff852703          	lw	a4,-8(a0)
    1126:	9e39                	addw	a2,a2,a4
    1128:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    112a:	ff053703          	ld	a4,-16(a0)
    112e:	e398                	sd	a4,0(a5)
    1130:	a099                	j	1176 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1132:	6398                	ld	a4,0(a5)
    1134:	00e7e463          	bltu	a5,a4,113c <free+0x40>
    1138:	00e6ea63          	bltu	a3,a4,114c <free+0x50>
{
    113c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    113e:	fed7fae3          	bgeu	a5,a3,1132 <free+0x36>
    1142:	6398                	ld	a4,0(a5)
    1144:	00e6e463          	bltu	a3,a4,114c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1148:	fee7eae3          	bltu	a5,a4,113c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    114c:	ff852583          	lw	a1,-8(a0)
    1150:	6390                	ld	a2,0(a5)
    1152:	02059813          	slli	a6,a1,0x20
    1156:	01c85713          	srli	a4,a6,0x1c
    115a:	9736                	add	a4,a4,a3
    115c:	fae60ae3          	beq	a2,a4,1110 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1160:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1164:	4790                	lw	a2,8(a5)
    1166:	02061593          	slli	a1,a2,0x20
    116a:	01c5d713          	srli	a4,a1,0x1c
    116e:	973e                	add	a4,a4,a5
    1170:	fae689e3          	beq	a3,a4,1122 <free+0x26>
  } else
    p->s.ptr = bp;
    1174:	e394                	sd	a3,0(a5)
  freep = p;
    1176:	00000717          	auipc	a4,0x0
    117a:	26f73523          	sd	a5,618(a4) # 13e0 <freep>
}
    117e:	6422                	ld	s0,8(sp)
    1180:	0141                	addi	sp,sp,16
    1182:	8082                	ret

0000000000001184 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1184:	7139                	addi	sp,sp,-64
    1186:	fc06                	sd	ra,56(sp)
    1188:	f822                	sd	s0,48(sp)
    118a:	f426                	sd	s1,40(sp)
    118c:	f04a                	sd	s2,32(sp)
    118e:	ec4e                	sd	s3,24(sp)
    1190:	e852                	sd	s4,16(sp)
    1192:	e456                	sd	s5,8(sp)
    1194:	e05a                	sd	s6,0(sp)
    1196:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1198:	02051493          	slli	s1,a0,0x20
    119c:	9081                	srli	s1,s1,0x20
    119e:	04bd                	addi	s1,s1,15
    11a0:	8091                	srli	s1,s1,0x4
    11a2:	0014899b          	addiw	s3,s1,1
    11a6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    11a8:	00000517          	auipc	a0,0x0
    11ac:	23853503          	ld	a0,568(a0) # 13e0 <freep>
    11b0:	c515                	beqz	a0,11dc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11b4:	4798                	lw	a4,8(a5)
    11b6:	02977f63          	bgeu	a4,s1,11f4 <malloc+0x70>
    11ba:	8a4e                	mv	s4,s3
    11bc:	0009871b          	sext.w	a4,s3
    11c0:	6685                	lui	a3,0x1
    11c2:	00d77363          	bgeu	a4,a3,11c8 <malloc+0x44>
    11c6:	6a05                	lui	s4,0x1
    11c8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    11cc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11d0:	00000917          	auipc	s2,0x0
    11d4:	21090913          	addi	s2,s2,528 # 13e0 <freep>
  if(p == (char*)-1)
    11d8:	5afd                	li	s5,-1
    11da:	a895                	j	124e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    11dc:	00000797          	auipc	a5,0x0
    11e0:	27478793          	addi	a5,a5,628 # 1450 <base>
    11e4:	00000717          	auipc	a4,0x0
    11e8:	1ef73e23          	sd	a5,508(a4) # 13e0 <freep>
    11ec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11ee:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    11f2:	b7e1                	j	11ba <malloc+0x36>
      if(p->s.size == nunits)
    11f4:	02e48c63          	beq	s1,a4,122c <malloc+0xa8>
        p->s.size -= nunits;
    11f8:	4137073b          	subw	a4,a4,s3
    11fc:	c798                	sw	a4,8(a5)
        p += p->s.size;
    11fe:	02071693          	slli	a3,a4,0x20
    1202:	01c6d713          	srli	a4,a3,0x1c
    1206:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1208:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    120c:	00000717          	auipc	a4,0x0
    1210:	1ca73a23          	sd	a0,468(a4) # 13e0 <freep>
      return (void*)(p + 1);
    1214:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1218:	70e2                	ld	ra,56(sp)
    121a:	7442                	ld	s0,48(sp)
    121c:	74a2                	ld	s1,40(sp)
    121e:	7902                	ld	s2,32(sp)
    1220:	69e2                	ld	s3,24(sp)
    1222:	6a42                	ld	s4,16(sp)
    1224:	6aa2                	ld	s5,8(sp)
    1226:	6b02                	ld	s6,0(sp)
    1228:	6121                	addi	sp,sp,64
    122a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    122c:	6398                	ld	a4,0(a5)
    122e:	e118                	sd	a4,0(a0)
    1230:	bff1                	j	120c <malloc+0x88>
  hp->s.size = nu;
    1232:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1236:	0541                	addi	a0,a0,16
    1238:	00000097          	auipc	ra,0x0
    123c:	ec4080e7          	jalr	-316(ra) # 10fc <free>
  return freep;
    1240:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1244:	d971                	beqz	a0,1218 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1246:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1248:	4798                	lw	a4,8(a5)
    124a:	fa9775e3          	bgeu	a4,s1,11f4 <malloc+0x70>
    if(p == freep)
    124e:	00093703          	ld	a4,0(s2)
    1252:	853e                	mv	a0,a5
    1254:	fef719e3          	bne	a4,a5,1246 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    1258:	8552                	mv	a0,s4
    125a:	00000097          	auipc	ra,0x0
    125e:	b5c080e7          	jalr	-1188(ra) # db6 <sbrk>
  if(p == (char*)-1)
    1262:	fd5518e3          	bne	a0,s5,1232 <malloc+0xae>
        return 0;
    1266:	4501                	li	a0,0
    1268:	bf45                	j	1218 <malloc+0x94>
