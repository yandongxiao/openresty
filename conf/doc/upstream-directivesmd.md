# upstream指令

## 支持多次转发错误请求

1. upstream支持多次转发错误请求到其它的后端服务器；
2. 多次转发的错误请求的定义？这是由调用upstream的模块决定的，例如http\_proxy\_module模块可以在proxy\_pass中使用upstream模块。该模块的proxy\_next\_upstream指令就定义了何谓错误的请求。默认值为如下：与后端服务器建立连接失败或超时；发送请求到后端服务器失败或超时；读取后端服务器的响应头部时失败或超时。
3. 注意，proxy\_pass模块采用的缓存行为也会影响upstream的多次转发功能。例如，如果proxy\_request\_buffering设置为off。
4. 如果**所有**的后端服务器都返回错误，那么Nginx将最后一个后端服务器的响应返回给用户。

# Server指令

该指令的核心功能是指定后端服务器，所以该指令可以在upstream上下文中出现多次。该指令是控制后端服务器的指令。

1. 该server的权重，默认值为1。weight=number： 修改server的权值，默认的错误请求转发策略是加权轮询的方式；可以通过ip\_hash，hash或least\_conn指令来调整转发策略。
2. Upstream指令不只是可用在HTTP通信当中，在http\_proxy\_pass模块中，Nginx与后端server之间默认是以HTTP 1.0协议进行通信，即使可以通过proxy\_http\_version来使得Nginx与Server之间采用HTTP 1.1通信，相信，连接的管理也是交由HTTP通信库来做的。也就是说，http\_proxy\_pass并不管理与后端的连接。
3. Upstream模块管理与后端服务器的连接。
  a. 并发的active连接数。max\_conns选项，指定的是并发的active连接数。如果worker之间没有共享内存来传递active并发数，那么max\_conns就是对每一个worker的限制。参见zone命令，max\_conns的含义就变成了限制所有worker到某个后端服务器的active并发连接数。
  b. idle连接数目。keepalive指令指定了最大的idle连接的数目。

  **注意：max\_conns, zone 和 keepalive共同决定了Nginx与后端服务器之间的连接个数。**

4. 服务返回“错误”和服务不可用。我们知道Http\_Proxy\_Module的proxy\_next\_upstream指令指定了unsuccessful attempt的情况，当某Server在一段时间内多次返回“错误”，那么认为该服务在未来一段时间是不可用的。**一段时间通过**fail\_timeout指定，**多次**通过max\_fails指定。fail\_timeout有两个含义：服务可用时，如果在fail\_timeout时间段内有max\_fails次不可用，那么Nginx将在未来的fail\_timeout时间段内停止向它转发请求。

5. backup选项指定备用的后端服务器。

6. down。使该服务永远下线。


# 以域名指定Server

server example.com 
这样的一条指令，如果example被解析出来三个IP地址，那么相当于：
server aaa;
server bbb;
server ccc;

但是当后端服务器的IP地址改变了，Nginx又该如何处理呢？

resolve选项。

它会检测域名&lt;--&gt;IP列表的映射关系，一旦有修改，Nginx会自动更新upstream--&gt;server的配置。

但是有以下限制：

1. 在http上下文中指定DNS服务器的位置；

2. 因为涉及到upstream--&gt;server的更新，所以要求所有的worker之间能够通信。所以需要在upstream上下文中定义zone.


# 后端健康检查

这属于Nginx的高级功能。

它的原理也很简单。1. Nginx持续不断的发送某个请求到它的后端服务器当中；2. 如果后端服务器连续N次返回失败，那么就认为该后端服务器不健康，将不再给它转发请求；3.如果后端服务器连续N次返回成功，那么就认为该服务器健康；4. 通过match可以让Nginx检查后端服务器返回的响应，包括状态码、头部、body等信息；5.可以开启多个健康检查，比如每个检查一个方面。

注意：健康检查结果是共享给所有的worker的，所以需要zone指令的支持。

