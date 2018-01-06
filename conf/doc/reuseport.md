# reuseport

参见文章： [SO_REUSEPORT提高服务器端性能](http://xiaorui.cc/2015/12/02/%E4%BD%BF%E7%94%A8socket-so_reuseport%E6%8F%90%E9%AB%98%E6%9C%8D%E5%8A%A1%E7%AB%AF%E6%80%A7%E8%83%BD/) 

## Linux下接收请求的方式

- 方式一

  主线程创建Listen Socket 同时accept新的连接，然后主线程将新的连接分发给其它线程或者子进程。但是，主线程在处理海量连接时会成为性能上的瓶颈。

- 方式二（Nginx默认方式）

  主线程创建监听套接字（Listen Socket）—>多线程同时accept该套接字 或 多子进程同时accept该套接字（FD是可以被继承的）。但此种方式可能存在 [Thundering herd problem](https://en.wikipedia.org/wiki/Thundering_herd_problem) （对于Linux而言，不存在这个问题）。

- 方式二改良版（accept_mutex on）

  通过进程间互斥锁机制， **同一时间段** 只允许一个进程accept新的连接。未抢到互斥锁的进程可以选择睡眠或者处理其它事件（accept_mutex_delay就指定了所谓的 **时间段** ），直到下一轮抢锁。改良版不一定适用于Nginx, 文章 [提升Nginx性能9倍](https://www.nginx.com/blog/thread-pools-boost-performance-9x/) 中将accept_mutex置为off，来提高吞吐量。

- 方式三(listen port reuseport)

  创建监听套接字时指定SO_REUSEPORT（Linux 3.9+）选项，所有子进程监听该套接字。操作系统在内核层面实现负载均衡，同时完全避免了 [Thundering herd problem](https://en.wikipedia.org/wiki/Thundering_herd_problem) 。