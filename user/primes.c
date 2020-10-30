#include "kernel/types.h"
#include "user/user.h"

void 
isPrime()
{
    int len,prime,num;
    int fd[2];
    if((len = read(0, &prime, sizeof(prime))) <= 0){
        close(0);
        close(1);
        exit();     //没有数据了直接退出
    }
    printf("prime %d\n",prime);

    pipe(fd);       //建立当前进程与子进程的pipe
    if(fork() == 0){
        close(0);
        dup(fd[0]);
        close(fd[0]);
        close(fd[1]);   
        isPrime();
    }
    close(1);
    dup(fd[1]);
    close(fd[0]);
    close(fd[1]);
    while((len = read(0, &num, sizeof(num))) > 0){
        if(num % prime != 0){
            write(1, &num, sizeof(num));
        }
    }
    close(1);
    wait();
    exit();
}

int 
main(int argc, char *argv[])
{
    int i;
    int fd[2];
    pipe(fd);       //建立当前进程与子进程的pipe
    if(fork() == 0){
        close(0);
        dup(fd[0]);
        close(fd[0]);
        close(fd[1]);
        isPrime();
    }
    close(1);
    dup(fd[1]);     //fd[0]读端,fd[1]写端
    close(fd[0]);
    close(fd[1]);
    //写入初始数据
    for(i = 2;i < 36;i++){
        write(1, &i, sizeof(i));
    }
    close(1);
    wait();
    exit();
}