---
layout: post
title: vLLM 
---

## vLLM
vLLM is a high-performance library for serving large language models (LLMs).

Where is it used?
 LLM inference (generating model outputs from inputs).

In what ways?
 Faster response times.
 Lower GPU memory usage.

So what?
 Enables quick AI assistant responses and faster data processing.
 Reduces GPU costs compared to running the model directly without vLLM.

Who is it for?
 Teams running large-scale data processing with LLMs.
 Applications needing low-latency responses from language models.

What does vLLM do?
It uses something called paged attention.

![Skeptical Fry from Futurama](https://media1.tenor.com/m/s1wnF2DiWA0AAAAC/skeptical-futurama.gif)

“Paged” is a word you’d hear in Operating Systems class – more precisely “Paging”.

## Paging in OS
- Large programs and files often exceed the size of your computer’s RAM. 
- Without a smart system to handle this, you’d be locked out of anything too big to fit entirely in memory. 
- Operating systems solved this decades ago with a technique called paging. 

- vLLM borrows the same core idea for AI models.

### Intuition
- Imagine you’ve stumbled across a giant PDF — every Harry Potter book combined. 
- 3,623 pages. 
- 16.5 MB in size. 
- You device has 5 MB of RAM. 
- The whole thing can’t possibly fit.
- But you can still read it. 
- Why? 
- Because the OS doesn’t try to load the entire book at once. 
- It treats your RAM like a tiny desk and your disk like a huge bookshelf, bringing pages over only when you’re about to read them.

- A page table maps virtual addresses (what your program sees) to physical addresses (where data actually lives).
- Demand paging delays loading until the data is touched, reducing unnecessary I/O.
- Replacement policies (like Least Recently Used) decide which page to evict when RAM is full.

You can run programs much larger than physical RAM.
The illusion of continuous memory is preserved for each process.
Disk speed becomes the limiting factor — slow storage makes page faults noticeable.


Paging is a foundational abstraction: 
it hides hardware limits, reduces fragmentation, and enables multitasking. 
The same pattern — break data into fixed chunks, load only what’s needed, and recycle space — shows up in GPUs, databases, and even AI systems like vLLM’s paged attention. 
It’s a principle that turns scarcity into abundance through clever indirection.


## Fragmentation
Fragmentation is when free memory is broken into many small pieces instead of one large continuous block.

![Internal vs External Fragmentation](images/2025-08-10-vLLM-Paging.md)

Two main types:
External fragmentation
Free memory exists but is scattered in chunks between allocated blocks.
A request for a large block fails even though total free memory is enough.
Common in systems that allocate variable-sized blocks.
Internal fragmentation
Memory inside an allocated block is wasted because the block is bigger than what’s actually needed.
Happens when allocation is in fixed-size units (like pages or sectors).



Paging helps solve external fragmentation by using fixed-size pages, so any free page can be used anywhere. 


![But meme...](https://media.tenor.com/mZAlwlgoSh0AAAAM/but-wait-nope.gif)


### Without paging
- You have 30 customers chatting at once
- Some chats end quickly (asking "Where's my order?"), others run long (comparing multiple items)
- Each conversation's KV cache is one contiguous block in GPU memory
- When short chats end, their blocks free up but leave gaps between longer chats
- New large conversations (e.g., a long multi-turn product comparison) need a big contiguous block
- Even though total free memory is enough, you can't fit them because the free space is fragmented

Result:
- Some customers get dropped or queued
- Latency spikes because GPU can't accept the request immediately


![Mr bean meme](https://i.pinimg.com/originals/aa/57/46/aa574640b0f3e2c22a4798233212e35d.gif)


### With paged attention
- KV cache for each conversation is split into small, fixed-size pages.
- When a short chat ends, its pages are returned to a shared pool.
- New conversations just take pages from anywhere in GPU memory — no need for them to be side-by-side.
- This means:
    - No “can’t fit” problem due to fragmentation.
    - You can serve more concurrent customers without GPU OOM errors.
    - Latency stays low because allocation is instant.

![Fast Typing...](https://media4.giphy.com/media/v1.Y2lkPTZjMDliOTUyZHVucmM4aDhtZmV2ODRoYTRseGRqY3oxaGhjcm1qcW41bDZuYXJiMiZlcD12MV9naWZzX3NlYXJjaCZjdD1n/toXKzaJP3WIgM/source.gif)