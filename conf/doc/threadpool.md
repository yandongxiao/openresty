# thread\_pool

## 背景

Nginx采用非阻塞的事件驱动模型来处理请求，但是第三方模块的开发者往往会在不经意间使用阻塞式的函数，严重影响Nginx的性能。以下是参考[利用thread\_poll提升Nginx性能十倍文章](https://www.nginx.com/blog/thread-pools-boost-performance-9x/)。

Nginx的工作方式是单进程，所以在处理任何事件时，如果被block住，那么所有其它的connection都将会受到影响。比如当用户希望GET一个文件时，worker现从文件中READ数据。

## 系统级别的支持

操作系统一般提供了同步和异步读取文件的接口，Nginx当然应该采用异步接口来防止阻塞。但是Linux提供的异步接口对上层应用不是那么的方便和友好，最致命的问题是：调用异步接口时需要给FD设置O\_DIRECT属性，它每次读取文件时都会绕过缓存，而直接从磁盘读取。

所以，Linux系统下，异步读取文件的接口存在的最大问题是，它绕过了缓存。

thread\_pool就是为了解决这一问题

## 原理

thead pool的每个线程就相当于快递员，它们从TASK QUEUE中获取任务，处理，然后再将结果递交给worker进行处理。那么有一个问题，worker是如何辨别该event是否是阻塞的，即是否应该交给thread pool中的线程去处理？

目前，针对三个IO操作的event会被认为是阻塞的。1. read；2.sendfile；3.aio\_write.

## 什么时候采用AIO

只要**aio threads（注意并非是aio on）**即可享受thread pool带来的好处，但是什么时候使用AIO呢？只有当内存容量相比于数据总量很小的情况下，才应该使用thread pool机制。

```
thread_pool default threads=32 max_queue=65536;
```

这是thread\_pool的默认值。如果向QUEUE中添加新的task的速度高于threads处理请求的速度，那么QUEUE终究是会满的，这是会出现如下错误：

```
thread pool "NAME" queue overflow: N tasks waiting
```

这代表你的硬件确实该升级了。

AIO指令可以应用在http，server或者是location级别，也就是说，可以单独为某一个location配置一个thread pool。一般情况下，如果有N块独立的磁盘，那么会定义N个独立的thread pool，好处是并发访问磁盘，且互不影响。如何配置？主要是通过请求--&gt;变量--&gt;thread pool的name--&gt;aio，参见[这里 ， ](https://www.nginx.com/blog/thread-pools-boost-performance-9x/)也就是说，**我们可以根据每一个请求，来选择使用哪一个thread pool**。

## 相关指令

worker\_aio\_requests  num。当aio on时，设置每一个worker最多可以调用异步IO的次数。它的默认值和thread\_pool中线程数的默认值是相等的。一个问题是我们有没有必要将该值设置的大一些？目前感觉没有必要。我们只需要保证两者相等即可。

## 实验

### 环境准备

**access\_log off**

**accept\_mutex  off，注意**

**sendfile on，采用内核拷贝，减少用户态和内核态之间的切换和拷贝**

**sendfile\_max\_truck 如果没有设置，sendfile会阻塞直到该文件发送完毕；512K表示每次发送512k字节就返回。**

以上指令是为了提高Nginx性能而设置的

10Gbps的带宽

### 测试方法

### 未设置thead pool

1. 未设置thread Pool：随机请求文件，很大概率上该文件不在内存中，即没有命中；200并发

2. 未设置Thead Pool：多次请求一个文件，文件命中；50并发

3. 以上两个client同时开跑


**通过ifstat -bi eth2查看网卡的IO情况，通过Top查看进程状态，通过wrk查看请求的延时情况。**

1. 网卡输出流量是1Gbps；
2. 同时发现worker进程处于D状态，也就是进程长时间忙于读磁盘；
3. 多次请求一个文件的client的WRK结果也不是很让人满意；它的请求被情况一的请求block了

### 设置thread pool

1. 设置方法很简单，aio on即可；
2. thread pool的默认值即可生效

**通过ifstat -bi eth2查看网卡的IO情况，通过Top查看进程状态，通过wrk查看请求的延时情况**
1. 网卡的输出流量是9.5Gbps
2. 发现worker进程处于S状态，也就是忙于接受新的连接

