// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct kmem{
  struct spinlock lock;
  struct run *freelist;
};

struct kmem kmems[NCPU];

void
kinit()
{
  int i;
  for(i = 0;i < NCPU;i++)
    initlock(&kmems[i].lock, "kmem");
  freerange(end, (void*)PHYSTOP);   //把空闲内存加到链表里
}

/*
 *将end~PHYSTOP之间的地址空间按照页面大小4KB切分,
 *并调用kfree()将页面从头部插入到链表kmem.freelist中进行管理
 */
void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  //int id;
  int cpu_id;
  struct run *r;

  push_off();
  cpu_id = cpuid();
  pop_off();

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  //id = (uint64)pa / ((PHYSTOP - (uint64)end) / NCPU);
  acquire(&kmems[cpu_id].lock);
  r->next = kmems[cpu_id].freelist;
  kmems[cpu_id].freelist = r;
  release(&kmems[cpu_id].lock);
}

void *
ksteal(int cpu_id)
{
  int id;
  struct run *r = 0;

  for(id = 0;id < NCPU;id++){
    if(holding(&kmems[id].lock))    //找到未锁上的list
      continue;
    
    acquire(&kmems[id].lock);
    if(kmems[id].freelist){       //list还有剩余空间
      r = kmems[id].freelist;
      kmems[id].freelist = r->next;
      release(&kmems[id].lock);
      return (void*)r;
    }
    release(&kmems[id].lock);
  }
  return (void*)r;
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  int cpu_id;
  struct run *r;

  push_off();
  cpu_id = cpuid();
  pop_off();

  acquire(&kmems[cpu_id].lock);
  r = kmems[cpu_id].freelist;
  if(r)       //当前list仍有空间
    kmems[cpu_id].freelist = r->next;
  release(&kmems[cpu_id].lock);

  if(!r)      //当前list已满，要窃取空间
    r = ksteal(cpu_id);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
