#include "kernel/types.h"
#include "user/user.h"

int 
main(int argc, char *argv[])
{
    if(argc != 2){
        printf("Usage: sleep <ticks>\n");
        exit();
    }

    int i = atoi(argv[1]);

    sleep(i);
    
    exit();
}