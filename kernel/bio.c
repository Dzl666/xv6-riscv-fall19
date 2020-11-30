// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define NBUCKETS 13

/*
Spinlock
1)  在短时间内进行轻量级加锁；                          
2)  获取过程一直进行忙循环—旋转—等待锁重新可用（占用CPU时间长）；
3)  xv6要求在持有spinlock期间，中断不允许发生。

sleep-lock
1)  适合长时间持有；
2)  获取锁期间可以让出CPU；
3)  持有Sleep-lock期间允许中断发生，但不允许在中断程序中使用。
*/

struct {
  struct spinlock lock[NBUCKETS];
  struct buf buf[NBUF];

  // Linked list of all buffers, through prev/next.
  // head.next is most recently used.
  //struct buf head;
  struct buf hashbucket[NBUCKETS];  //按块号分为13组
} bcache;

void
binit(void)
{
  int i;
  struct buf *b;

  for(i = 0;i < NBUCKETS;i++){
    initlock(&bcache.lock[i], "bcache");
    // Create linked list of buffers
    bcache.hashbucket[i].prev = &bcache.hashbucket[i];
    bcache.hashbucket[i].next = &bcache.hashbucket[i];
  }
  //构建双向链表,init时blockno全为0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.hashbucket[0].next;
    b->prev = &bcache.hashbucket[0];
    initsleeplock(&b->lock, "buffer");
    bcache.hashbucket[0].next->prev = b;
    bcache.hashbucket[0].next = b;
  }
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  int hash = blockno%NBUCKETS,hash1;
  struct buf *b;

  acquire(&bcache.lock[hash]);

  // Is the block already cached? Search in related bucket
  for(b = bcache.hashbucket[hash].next; b != &bcache.hashbucket[hash]; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.lock[hash]);
      acquiresleep(&b->lock);
      return b;
    }
  }

  // Not cached; Search in another bucket
  hash1 = (hash + 1)%NBUCKETS;
  while(hash1 != hash){
    acquire(&bcache.lock[hash1]);     //对当前backet上锁
    for(b = bcache.hashbucket[hash1].prev; b != &bcache.hashbucket[hash1]; b = b->prev){
      if(b->refcnt == 0){    //找到未被使用的缓存块
        b->dev = dev;
        b->blockno = blockno;
        b->valid = 0;
        b->refcnt = 1;

        b->next->prev = b->prev;
        b->prev->next = b->next;
        release(&bcache.lock[hash1]);

        b->next = bcache.hashbucket[hash].next;
        b->prev = &bcache.hashbucket[hash];
        bcache.hashbucket[hash].next->prev = b;
        bcache.hashbucket[hash].next = b;
        release(&bcache.lock[hash]);
        acquiresleep(&b->lock);
        return b;
      }
    }
    release(&bcache.lock[hash1]);
    hash1 = (hash1 + 1)%NBUCKETS;
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);   //检查磁盘块是否在buf中
  if(!b->valid) {
    virtio_disk_rw(b->dev, b, 0); //加载磁盘块
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b->dev, b, 1);
}

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  int hash = (b->blockno)%NBUCKETS;

  acquire(&bcache.lock[hash]);
  b->refcnt--;
  if (b->refcnt == 0) {
    //从双向链表中取下b并放在链表头
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.hashbucket[hash].next;
    b->prev = &bcache.hashbucket[hash];
    bcache.hashbucket[hash].next->prev = b;
    bcache.hashbucket[hash].next = b;
  }
  release(&bcache.lock[hash]);
}

void
bpin(struct buf *b) {
  int hash = (b->blockno)%NBUCKETS;
  acquire(&bcache.lock[hash]);
  b->refcnt++;
  release(&bcache.lock[hash]);
}

void
bunpin(struct buf *b) {
  int hash = (b->blockno)%NBUCKETS;
  acquire(&bcache.lock[hash]);
  b->refcnt--;
  release(&bcache.lock[hash]);
}


