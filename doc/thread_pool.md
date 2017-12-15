# thread_pool

以下内容是对《 [利用thread_poll提升Nginx性能十倍文章](https://www.nginx.com/blog/thread-pools-boost-performance-9x/) 》的个人解读。结论：It is most useful where the volume of frequently requested content doesn’t fit into the operating system’s VM cache. This might be the case with, for instance, a heavily loaded NGINX‑based streaming media server. This is the situation we’ve simulated in our benchmark。

## **背景**

Nginx采用 **非阻塞** 的 **事件驱动** 模型来处理请求，但是第三方模块的开发者往往会在不经意间使用阻塞式的函数。Nginx的worker进程如果被block住，那么 **整个worker进程将会被block** ，所有其它的connection都将会受到影响。比如当用户希望GET一个文件时，worker现从文件中READ数据。

![](https://static.notion-static.com/e838d5a8-4c4a-4468-8ff8-a5ca7ccfb9ba/Untitled)

## **系统级别的支持**

操作系统一般向开发者提供了同步和异步读取文件的接口，模块开发者当然应该采用异步接口来防止阻塞。但Linux提供的异步接口存在致命的问题：调用异步接口时需要给FD设置O_DIRECT属性，当系统读取文件时会绕过系统缓存，而直接从磁盘读取。

> 操作系统会将异步调用的结果，以事件通知的方式告知上层应用

注意，绕过系统缓存读取数据是非常不可取的，这将会导致所有的IO请求压力都给到了磁盘。所以Linux的异步IO接口对Nginx来说是不可用的。

## **原理（aio threads）**

![](https://static.notion-static.com/b10d86ad-06ae-417f-ab29-07e50ab63dd8/Untitled)

1. Nginx在内部创建了一个队列服务；
1. 对于 **耗时请求** ，nginx worker进程会给队列服务下发任务去完成用户请求；
1. 完成后，队列服务通知worker process。

那么Nginx是如何识别出耗时任务的呢？

1. 模块开发者可以继续使用阻塞式函数；
1. 模块开发者应该使用Nginx封装后的函数，这样Nginx worker就可以截获到该文件描述符；
1. Nginx封装的函数有：1. read；2.sendfile；3.aio_write。

> 队列服务可以以阻塞或非阻塞方式来读取数据，反正对于worker进程来说都是非阻塞的。使用阻塞方式，还可以最大限度的使用系统缓存

## 异步IO指令

对于读操作，建议使用阻塞的方式读取；对于写操作呢？我们需要清楚，数据的一般流向是磁盘—>内存—>网卡，所以如果内存足够大，性能的瓶颈可能就在网卡了。

我们先来认识一下与异步IO相关的指令。

- aio on

  允许使用异步IO操作，与directio size指令一起使用，完成异步读取操作。

- directio size

  当读取的文件大小大于 size 时，open函数打开O_DIRECT选项，开启异步读取。但是该选项将绕过缓存。所以如果该文件经常被读时，每次都会从磁盘读取。size大小是有讲究的，一般是512的倍数。

  可以做到大文件异步读取，不缓存；小文件阻塞式读取，缓存到操作系统。

  它必须与aio on指令一起使用。

- sendfile on

  只有当请求的文件大小小于directio size指定的大小，或者directio关闭的情况下，才会使用sendfile。sendfile可以在内核级别完成读取文件并发送给某套接字的功能，“零拷贝”功能使得sendfile更加高效。

   **sendfile on 是提供性能的必备指令。而且应该关闭directio指令，这样既实现了零拷贝，也实现了缓存数据到操作系统。** 

> Nginx一般有三种用途：静态资源网站、反向代理，缓存服务器。异步IO指令的使用，虽然提高了第一次IO响应的能力，但操作系统却失去了缓存该数据的机会。

综上:

1.  **aio threads 指令的使用场景是内存容量无法缓存常用数据总容量的情况。** 如果内存容量足够的话，用户在读取一次该文件后，数据将会被缓存在内存中；
1. 保持sendfile on打开。同时，设置aio off 和 direct off指令；

## sendfile_max_chunk 和 output_buffers

- worker process直接阻塞式调用read函数，这样会阻塞worker进程，文件越大，下一个请求被阻塞的时间越长？ **NO**
  1. Nginx不是一次读取文件所有内容，太占用内存，而是使用 **output_buffers** 指令，申请固定的内存块来存储文件。文件大小 > 内存块，所以Nginx是分批次读取。
  1. Nginx不是连续读取同一个文件的内容。流程如下：disk —> memory block —> write to socket —> wait for event. 等待的事件就是操作系统完成数据发送。所以，write to socket操作之后，很有可能去处理别的事件了。
- sendfile on时，文件数据不会被读取到用户态，这时如何设置？sendfile_max_chunk

## 性能测试

> 测试结果也表明，磁盘IO能力远小于网络IO

测试目的：阻塞式操作会严重影响Nginx的性能，降低系统吞吐量，增加延时。

测试方法：同时向Nginx发送阻塞式（200个并发连接）和非阻塞请求（50个并发连接），利用wrk工具，检测性能指标。

影响因子：操作系统的缓存；Nginx额外的文件操作，影响Nginx并发性的其它操作。

验证手段：

1. 吞吐量（throughput）（ifstat -bi eth2）；
1. 检测worker进程状态（D表示睡眠且不可终端；S表示可中断睡眠，往往表示在监听事件）；
1. 利用wrk检测对非阻塞请求的响应指标，包括RPS、延时。

    # 以下配置主要是为了提高Nginx的吞吐量。
    # 因为阻塞式操作是影响性能的关键，是瓶颈。为防止出现，即使使用了线程池，但由于其它影响并发性的配置存在，导致使用了线程池后，吞吐量也没有明显提升。
    worker_processes 16;
    events {
     accept_mutex off;
    }
    http {
     include mime.types;
     default_type application/octet-stream;
     access_log off;
     sendfile on;
     sendfile_max_chunk 512k;
     server {
     listen 8000;
     location / {
     root /storage;
     }
     }
    }

以下是测试环境，256GB的资源 >> 48GB的内存。这会导致随机请求的资源没有被缓存命中，从而变成一个阻塞操作。

![](https://static.notion-static.com/716efa50-aca0-4d84-8fd5-30ae9b15bc2c/Untitled)

## **什么时候使用aio threads，怎么使用？**

最佳场景是：如果请求的资源被系统缓存，worker进程直接响应该请求；否则，下发读取文件任务到队列服务（队列服务）。因为文件被缓存的情况下，派发任务给队列服务是有性能损耗的。

目前Linux还不支持上面的操作，只能是预估未来常用资源的总量，然后与内存总量进行比较。

1. 编译Niginx时，指定—with-threads选项；
1. 只要添加 **aio threads指令（注意并非是aio on指令）** 即可享受线程池带来的好处。

    thread_pool default threads=32 max_queue=65536;
    aio threads=default;

这是thread_pool的默认值；

 3. 如果向QUEUE中添加新的task的速度高于threads处理请求的速度，那么QUEUE终究是会满的，这时会出现如下错误：

    thread pool "NAME" queue overflow: N tasks waiting

这代表你的硬件确实该升级了（换个SSSD）；

 4. 多线程池

    # We assume that each of the hard drives is mounted on one of these directories:
    # /mnt/disk1, /mnt/disk2, or /mnt/disk3# in the 'main' context
    thread_pool pool_1 threads=16;
    thread_pool pool_2 threads=16;
    thread_pool pool_3 threads=16;
    http {
     proxy_cache_path /mnt/disk1 levels=1:2 keys_zone=cache_1:256m max_size=1024G use_temp_path=off;
     proxy_cache_path /mnt/disk2 levels=1:2 keys_zone=cache_2:256m max_size=1024G use_temp_path=off;
     proxy_cache_path /mnt/disk3 levels=1:2 keys_zone=cache_3:256m max_size=1024G use_temp_path=off;
    
    		split_clients $request_uri $disk {
     33.3% 1;
     33.3% 2;
     * 3;
     }
    
     server {
     # ...
     location / {
     proxy_pass http://backend;
     proxy_cache_key $request_uri;
     proxy_cache cache_$disk; # !!可以动态选择缓存位置!!
     aio threads=pool_$disk; # !!可以动态选择线程池!!
     sendfile on;
     }
     }
    }