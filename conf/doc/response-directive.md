# tcp\_nodelay

Nagle’s Algorithm 是为了提高带宽利用率设计的算法，其做法是合并小的TCP 包为一个，避免了过多的小报文的 TCP 头所浪费的带宽。如果开启了这个算法 （默认），则协议栈会累积数据直到以下两个条件之一满足的时候才真正发送出去。

1. 累计的数据量到达最大的 TCP Segment Size
2. 等到200ms的时间
3. 收到了一个 Ack

tcp\_nodeplay的默认值是on，说明它禁止了Nagle算法。

不使用Nagle算法的一个需求：请求的文件大小正好是 TCP Segment Size的整数倍，那么当Server发送完毕这个文件以后，client端仍然要多等待0.2s的时间。[参考地址](https://t37.net/nginx-optimization-understanding-sendfile-tcp_nodelay-and-tcp_nopush.html)

# tcp\_nopush

`tcp_nopush` must be activated with `sendfile`

nopush也是与发送有关系的，一直会等到载荷满了以后，才会发送该packet。

# postpone\_output

如果tcp\_nopush和tcp\_nodelay都设置为on以后，是否也应该讲postpone\_output设置为0呢？

它的默认值是1460，建议维持不动。提高传输效率。

也可以理解为，提高传输效率的任务交由应用层来做。

# default\_type

Defines the default MIME type of a response

虽然简单，但是也是Nginx配置必须的指令

使用例子可参见chunked\_transfer\_encoding字段

# types

定义响应头content\_type的值与文件名后缀之间的映射关系

使用例子可参见chunked\_transfer\_encoding字段

# hash\_bucket\_size 和 hash\_max\_size

Nginx在很多地方使用了HASH表结构，当KEY的hash值相等时，用一个bucket来存放这些hash值相等的KEY，一个bucket可以存放的KEY的数量是有个数限制的，不超过hash\_bucket\_size。

一个hash表的总大小是由hash\_max\_size来设置的，它指定了bucket的个数，相信Nginx也是拿hash\_max\_size的值来取模的。当要存放的元素内容过多，某个bucket存放的KEY的数量就会超过hash\_bucket\_size。此时nginx就会警告说，需要扩大hash\_bucket\_size或hash\_max\_size。

注意：**优先考虑扩大hash\_max\_size的大小**

使用HASH表结构的有：

types指令，对应有type\_hash\_bucket\_size和types\_hash\_max\_size。

servername指令，对应有server\_name\_hash\_bucket\_size和server\_name\_hash\_max\_size

# ETag

默认值是on

etag值并非是MD5

# **if\_modified\_since**

Nginx对于响应头Last\_Modified和请求头if\_modified\_since之间的比较方式，默认采用的是精确匹配的方式。不过一般应该选择before才对。

修改时间 &gt; if\_modified\_since, 返回200

修改时间 &lt; if\_modified\_since, 返回304

# 

# 

