// Dzl's Shell

#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"


char whitespace[] = " \t\r\n\v";

void runcmd(char *argv[],int argc);

void
pipecmd(char *argv[],int argc, int largc)
{
    int rargc = argc - largc -1;

    int fd[2];
    pipe(fd);   //fd[0]读端 fd[1]写端

    //将左边进程的输出作为右边进程的输入
    if(fork() == 0){    //exec left cmd of pipe
        close(1);   //close stdout
        dup(fd[1]);
        close(fd[0]);
        close(fd[1]);
        runcmd(argv, largc);
    }
    else{       //exec right cmd of pipe
        close(0);   //close stdin
        dup(fd[0]);
        close(fd[0]);
        close(fd[1]);
        runcmd(argv+largc+1, rargc);
    }
    wait(0);
    exit(0);
}

// Execute cmd.  Never returns.
void
runcmd(char *argv[],int argc)
{
    int i;
    for(i = 1;i < argc;i++){
        if(strcmp(argv[i], "|") == 0){    //output redir
            argv[i] = '\0';
            pipecmd(argv, argc, i);
            break;
        }
    }

    for(i = 1;i < argc;i++){
        if(strcmp(argv[i], "<") == 0){    //input redir
            if(i == argc-1){
                fprintf(2,"Usage: cmd < filenme.\n");
            }
            close(0);
            open(argv[i+1], O_RDONLY);
            argv[i] = '\0';
        }
        if(strcmp(argv[i], ">") == 0){    //output redir
            if(i == argc-1){
                fprintf(2,"Usage: cmd > filenme.\n");
            }
            close(1);
            open(argv[i+1], O_CREATE|O_WRONLY);
            argv[i] = '\0';
        }
    }
    exec(argv[0], argv);
}

int
getcmd(char *buf, int nbuf)
{
  fprintf(2, "@ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}

void 
parsecmd(char buf[],char *argv[],int *argc)
{
    int j = 0;
    char *p;
    p = buf;

    while(buf[j] != '\n'){
        if(strchr(whitespace,buf[j])){
            buf[j] = '\0';
            argv[++(*argc)] = p;
            p = buf + j + 1;
        }
        j++;
    }
    buf[j] = '\0';
    argv[++(*argc)] = p;
    argv[++(*argc) + 1] = '\0';
}

int
main(void)
{
    static char buf[100];
    int fd;

    // Ensure that three file descriptors are open.
    while((fd = open("console", O_RDWR)) >= 0){
        if(fd >= 3){
            close(fd);
            break;
        }
    }

    // Read and run input commands.
    while(getcmd(buf, sizeof(buf)) >= 0){
        if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
            // Chdir must be called by the parent, not the child.
            buf[strlen(buf)-1] = 0;  // chop \n
            if(chdir(buf+3) < 0)
                fprintf(2, "cannot cd %s\n", buf+3);
            continue;
        }
        if(fork() == 0){
            char *argv[100];
            int argc = -1;
            parsecmd(buf, argv, &argc);
            runcmd(argv, argc);
            exit(0);
        }
        wait(0);
    }
    exit(0);
}