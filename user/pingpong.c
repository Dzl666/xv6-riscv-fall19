#include "kernel/types.h"
#include "user/user.h"

int 
main(int argc,int *argv[]){
    int parent_fd[2],child_fd[2];
    pipe(parent_fd);
    pipe(child_fd);
    char buffer[] = {'A'};
    int len = sizeof(buffer);
    //函数调用成功返回r/w两个文件描述符,fd[0]读端,fd[1]写端
    //pipe无需open，但需手动close。读写数据其实是在读写内核缓冲区
    if(fork()==0){
        close(parent_fd[1]); //close write,open read
        close(child_fd[0]);  //close read,open write
        if(read(parent_fd[0], buffer, len) != len){
            printf("pingpong: son read error\n");
            exit();
        }
        printf("%d: received ping\n",getpid());
        if(write(child_fd[1], buffer, len) != len){
            printf("pingpong: son write error\n");
            exit();
        }
        close(parent_fd[0]);
        close(child_fd[1]);
        exit();
    }
    close(parent_fd[0]); //close read,open write
    close(child_fd[1]);  //close write,open read
    
    if(write(parent_fd[1], buffer, 1) != 1){
        printf("pingpong: parent write error\n");
        exit();
    }
    if(read(child_fd[0], buffer, 1) != 1){
        printf("pingpong: parent read error\n");
        exit();
    }
    fprintf(2,"%d: received pong\n",getpid());
    close(parent_fd[1]);
    close(child_fd[0]);
    wait();
    exit();
}