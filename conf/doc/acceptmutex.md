# accept\_mutex和reuseport

## 背景

参见：使用[SO\_REUSEPORT提高服务器端性能](http://xiaorui.cc/2015/12/02/%E4%BD%BF%E7%94%A8socket-so_reuseport%E6%8F%90%E9%AB%98%E6%9C%8D%E5%8A%A1%E7%AB%AF%E6%80%A7%E8%83%BD/)文章。

* SO\_REUSEADDR的工作方式
* 1. 方式一。主线程创建Listen Socket 同时accept新的连接，然后主线程将新的连接分发给其它线程或者子进程。但是，主线程在处理海量连接时会成为性能上的瓶颈。
  2. 方式二。主线程创建Listen Socket --&gt; 多线程同时accept该套接字 或 多进程同时accept该套接字（FD是可以被继承的）。它们**复用**了同一个listen socket，但此种方式存在[Thundering herd problem](https://en.wikipedia.org/wiki/Thundering_herd_problem)。
  3. 方式二改良版。通过进程间互斥锁机制，**同一时间段**只允许一个进程accept新的连接。未抢到互斥锁的进程可以选择睡眠或者处理其它事件，直到下一轮抢锁。当频繁进行抢锁，且accept进程较多时，锁竞争问题将会变得严重。而且抢锁频率并非是程序员可以不断调整的，比如在线上。
  4. 现实中worker的数量只是与CPU核数相等或者是核数的二倍，thunder herd problem并没有想象的那么可怕。反而，锁竞争需要花费更多的资源。佐证之一是[提升Nginx性能9倍](https://www.nginx.com/blog/thread-pools-boost-performance-9x/)的方法，他在进行benchmark测试时，设置accept\_mutex off.


由于上面存在的种种问题，Linux 3.9支持了SO\_REUSEPORT选项。

* SO\_REUSEPORT的工作方式
  1. 在Bind之前，对监听在同一个端口的套接字设置SO\_REUSEPORT；
  2. 在内核层面实现负载均衡；
  3. 开发者只需要开发单进程程序，然后启动多个示例，就可以充分利用多核的优势。


## 使用

Nginx默认采用SO\_REUSEADDR的第二种工作方式，针对SO\_REUSEADDR的第三种工作方式，她提供了[accept\_mutex指令](http://nginx.org/en/docs/ngx_core_module.html#accept_mutex)；针对SO\_REUSEPORT的工作方式，她提供了[listen指令](http://nginx.org/en/docs/http/ngx_http_core_module.html#listen)的reuseport选项。目前Redhat7版本采用的内核已经高于linux 3.9了，所以推荐使用SO\_REUSEPORT的工作方式。

## 相关指令

* accept\_mutex\_delay就指定了所谓的**时间段**。
* 与accept\_mutext on一起工作，worker的默认工作方式是：accept one connection--&gt;handle--&gt;accept another connection。在SO\_REUSEADD的改良版中，我们的目的是让Nginx接受更多的连接，multi\_accept允许一次接收多个连接，即 accept some connection --&gt; handle --&gt; accept some connection。此时需要将accept\_mutex\_delay的值设置的小一些。
* multi\_accept不只是可以与accept\_mutext on一起工作；一次从内核获取多个事件是有好处的，至少应该可以减少内核与用户空间的上下文切换吧？

## 其它

有人对Nginx提供的三种工作方式进行了[比较](http://my.oschina.net/fqing/blog/420822)，这三种方式分别是：

* accept\_mutex off
* accept\_mutex on;
* listen 80 reuseport

从结果中可以得出如下结论：

* reuseport显著提升性能
* accept\_mutex on的性能不一定比accept\_mutex的性能好。因为Nginx worker数量有限，thunder herd不是很大的问题。

## WRK

他们在测试过程中主要用到了WRK这个HTTP性能分析工具，简单易用。WRK的输出项含义，参见[这里](http://www.jianshu.com/p/cf0853226dc6)。这里再重复一遍。
\| **项目名称说明** \| -- \| -- \|
\| --- \| --- \| --- \|
\| Avg \| 平均值 \| 每次测试的平均值 \|
\| Stdev \| 标准偏差 \| 结果的离散程度，越高说明越不稳定 \|
\| Max \| 最大值 \| 最大的一次结果 \|
\| +\/- Stdev \| 正负一个标准差占比 \| 结果的离散程度，越大越不稳定 \|

Latency: 可以理解为响应时间

Req\/Sec: 每个线程每秒钟的完成的请求数

一般我们来说我们主要关注平均值和最大值.

标准差如果太大说明样本本身离散程度比较高. 有可能系统性能波动很大

## nginx-systemtap-toolkit

[nginx-systemtap-toolkit](https://github.com/openresty/nginx-systemtap-toolkit#table-of-contents)是基于systemtap工具而开发的Nginx诊断工具包，比如可以测试Nginx的每个worker处理的请求数目，是Nginx调优和调试的有力工具

