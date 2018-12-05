# AIO

aio on只是开启异步读取文件的功能，读取文件的操作还是由Nginx worker完成；aio threads才是真正的开启的thread pool, 利用专有线程来负责读取IO。

## aio on

由Nginx Worker来负责读取文件

通常与directio，sendfile指令一起使用

目的：大文件异步读取，小文件还是阻塞式读取

### directio指令

形式: directio size

当大于或者等于 size 的文件在读取时，open函数打开O\_DIRECT选项，开启异步读取。

但是该选项将绕过缓存。所以如果该文件经常被读时，每次都会从磁盘读取。

size大小是有讲究的，一般是512的倍数。

那么小于size大小的文件如何读取？一般只能通过阻塞函数read或sendfile。sendfile可以在内核级别完成读取文件并发送给某套接字的功能，“零拷贝”功能使得sendfile更加高效。

### sendfile指令

形式：sendfile on

只有当请求的文件大小小于directio size指定的大小时，才会使用sendfile。

### 缺点

1. 在读取小文件时，Nginx Worker还是有可能会被阻塞；
2. directio在读取文件时，会绕过操作系统提供的缓存层，同一个文件被读取多次时，就会存在性能瓶颈了。

# aio threads

core-functionality的thread\_pool指令和aio指令是结合起来使用的；

当aio threads设置了以后，nginx会将读取文件的操作，放置到thread pool中完成。解决了Nginx Worker被阻塞的问题。

那么在线程中如何读取文件呢？可以采用sendfile方式；或者sendfile+directioio的方式。

**注意：aio被使用的场景是内存容量相比数据容量很小的情况。如果内存容量足够的话，根本就不需要aio指令；用户在读取一次该文件后，将会缓存在内存中。**

## 线程如何读取文件

sendfile的使用场景我们已经在[提升Nginx性能十倍](https://www.nginx.com/blog/thread-pools-boost-performance-9x/)的文章中，介绍过了。考虑下面的一种情况：

* 默认情况下，直接调用read函数，但是这样会阻塞线程。文件越大，被阻塞的时间越长；
* 若client请求的文件都很大，比如Nginx提供在线视频服务，那么线程池中的线程瞬间就变得不可用；
* 在线视频的特点是：请求文件大，下载速度适中，服务时长长；
* 所以，我们希望一块磁盘可以有N个读取操作并发执行，确保磁盘IO速率\/N &gt; 视频顺畅观看的速度即可。

说一下以上分析的几个错误：

* 线程池中的线程是有可能全部被阻塞住，但是并非是在读取所有的文件内容以后，阻塞才消失；sendfile\_max\_chunk指令指定了一次读取的字节数的大小。
* output\_buffers指定了一次读取的数据量大小，自由当缓存中的数据发送完毕以后，才会重新读取数据；
* 所以在作业队列当中的其它请求也会立刻得到相应，而且如果它们请求的是同一块数据，可以缓存命中；

根据上面的分析，我们断定directio将不再被需要，同时内存缓存的文件总是最新的，且访问频率最高的视频，提升了用户的体验度。

# 其它相关指令

* aio\_write，thread\_pool 支持的三大指令之一，所以应该设置为on；
* aio threads=thread$num，通过该功能用户就可以将不同的请求放到不同的thread pool当中。
* 编译时需要--with-threads选项的支持

