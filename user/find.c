#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fs.h"
#include "user/user.h"

char*
fmtname(char *path)   //找出路径中的文件名
{
    static char buf[DIRSIZ+1];
    char *p;

    // Find first character after last slash.
    for(p=path+strlen(path); p >= path && *p != '/'; p--)
        ;
    p++;
    memset(buf, '\0', sizeof(buf)); //clean
    // Return blank-padded name.
    memmove(buf, p, strlen(p));
    return buf;
}

void 
find(char* path, char* filename)
{
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if((fd = open(path, 0)) < 0){
        fprintf(2, "ls: cannot open %s\n", path);
        return;
    }

    if(fstat(fd, &st) < 0){
        fprintf(2, "ls: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch(st.type){
    case T_FILE:
        if(strcmp(fmtname(path),filename) == 0){
            printf("%s\n",path);
        }
        break;
    case T_DIR:
        if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
            printf("find: path too long\n");
            break;
        }
        strcpy(buf, path);
        p = buf+strlen(buf);
        *p++ = '/';
        while(read(fd, &de, sizeof(de)) == sizeof(de)){
            if(de.inum == 0||de.inum == 1||strcmp(de.name,".") == 0||strcmp(de.name,"..") == 0)
                continue;
            //在当前展开path下加上子文件夹name并递归
            memmove(p, de.name, sizeof(de.name));
            p[sizeof(de.name)] = 0;     //修饰符
            if(stat(buf, &st) < 0){
                printf("find: cannot stat %s\n", buf);
                continue;
            }
            //printf("%s\n", buf);
            find(buf, filename);
        }
        break;
    }
    close(fd);
    return;
}

int 
main(int argc, char *argv[])
{
    if(argc < 3){
        printf("Usage: find <path> <filename>\n");
        exit();
    }
    find(argv[1], argv[2]);
    exit();
}
