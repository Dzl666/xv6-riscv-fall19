#include "kernel/types.h"
#include "user/user.h"

int 
main(int argc, char *argv[])
{
    int i,j = 0,cmd_cnt = 0,cmd_len;
    char cmd_xargs[50],buf[50];
    char *p,*argv_exec[100];
    p = buf;
    if(argc < 2){
        printf("Usage: xargs <cmd> ...\n");
        exit();
    }
    for(i = 1;i < argc;i++){
        argv_exec[i-1] = argv[i];
        cmd_cnt++;
    }
    while((cmd_len = read(0, cmd_xargs, sizeof(cmd_xargs))) > 0){
        for(i = 0;i < cmd_len;i++){     //逐个字符处理
            if(cmd_xargs[i] == '\n' || cmd_xargs[i] == ' '){
                buf[j++] = 0;
                argv_exec[cmd_cnt++] = p;
                if(cmd_xargs[i] == '\n'){
                    j = 0;
                    argv_exec[cmd_cnt] = 0;
                    cmd_cnt = argc - 1;
                    if(fork() == 0){
                        exec(argv[1], argv_exec);
                        exit();
                    }
                }
                p = buf + j;    //pointer reset
            }
            else{
                buf[j++] = cmd_xargs[i];
            }
        }
    }
    wait();
    exit();
}