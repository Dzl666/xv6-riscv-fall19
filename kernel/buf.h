/*
 *缓存块由三个部分组成:
 *data字段标示了它的内容
 *指针字段（*prev，*next）用于组成链表
 *数值字段用于标示它的属性
 *
 *valid:缓存区包含了一个块的复制（即该buffer包含对应磁盘块的数据）
 *disk:缓存区的内容已经被提交到了磁盘
 *dev:设备号  字段blockno:缓存数据块号
 *refcnt:被引用次数  lock:睡眠锁
 */
struct buf {
  int valid;   // has data been read from disk?
  int disk;    // does disk "own" buf?
  uint dev;
  uint blockno;
  struct sleeplock lock;
  uint refcnt;
  struct buf *prev; // LRU cache list
  struct buf *next;
  uchar data[BSIZE];
};

