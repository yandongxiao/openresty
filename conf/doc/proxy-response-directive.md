## proxy\_http\_version

指定Nginx与后端服务器之间采用的HTTP协议版本号，默认是1.0

## proxy\_pass\_header和proxy\_hide\_header

默认情况下，代理服务器是不会将后端服务器的“date”，“server”, "X-Accl"等头部转发给client。

你也可以通过proxy\_hide\_header指令，让Nginx过滤更多的头部。

同理，你也可以通过proxy\_pass\_header指令，指定某些头部免于被过滤。

# 缓冲响应的内容

当反向代理服务器将请求转发给后端服务器以后，数据流向是：后端服务器--&gt;Nginx--&gt;Client。Nginx可以有两种处理方式：1. 最多接受proxy\_buffer\_size的数据，然后立即转发给client；2. 将后端服务器的数据先暂存到proxy\_buffers当中，只有当响应读取完毕或者proxy\_buffers满了以后，才会转发给client。

第二种方法的两个好处：1. TCP的载荷尽可能的大，节省带宽；2. Nginx在转发数据给client的同时可以接受后端服务器的数据，做到了边发送边接收。

# proxy\_buffer\_size

首先，该指令与缓冲区是否打开没有关系。无论Nginx如何转发后端的response，Nginx至少一块内存用来接收数据。

默认情况下，该值是一个内存页。

## proxy\_buffering

开关，表示是否打开反向代理的缓存功能，注意不是cache功能。

关。那么Nginx就会以第一种方式工作，这种方式也称之为同步方式。

开。Nginx将采取异步的工作方式进行，即边转发到client，同时边接收后端的数据。在内存级别，可以借助proxy\_buffer\_size和proxy\_buffers指令申请的内存，用于读取后端的数据。

那么存在两个问题：发送缓存区在哪里？ 如果数据堆积在Nginx的大小超过了申请的内存？

默认值是on

### 发送缓冲区在哪里

Nginx并没有申请单独的内存用于发送，既然数据已经读取到了proxy\_buffer\_size 和 proxy\_buffers当中，那么就直接拿这些读取过数据发送出去就行。proxy\_busy\_buffers\_size 就指定了Nginx可以用于发送数据的内存大小。其它内存可以继续读取数据，，甚至读取到磁盘上。

### 数据堆积在Nginx的大小超过了申请的内存大小

将数据暂存到磁盘上。那么就面临以下问题：

1. proxy\_temp\_path。指定数据暂存的位置。

2. proxy\_max\_temp\_file\_size。指定临时文件的最大大小。如果后端服务器和Nginx之间是内网，带宽足够大，那么数据很快就会被读取到Nginx。之后就是client和Nginx之间进行数据交换了。如果后端响应的数据量超级大，超过了proxy\_max\_temp\_file\_size 的大小，怎么办？Nginx会暂停读取，等到Nginx发送数据工作一阵，从磁盘上取出数据，再继续读取后端服务器的数据。

3. proxy\_temp\_file\_write\_size.一次向临时文件写的数据内容的大小。


注意：代理服务器是否缓存响应，不但可以由proxy\_buffering指令控制，也可以由后端服务器控制。通过X-Accel-Buffering头部。

## proxy\_buffers

为每一个连接分配的缓存大小。

默认是8个内存页面。

## proxy\_busy\_buffers\_size

在proxy\_buffers中一旦有k个页面读取成功，那么就会驱动Nginx向client返回数据。这里的k就是proxy\_busy\_buffers\_size的值。

默认值一般是两个内存页面。

## proxy\_limit\_rate

我们知道Nginx和Client之间的限速指令是http-core-module模块内limit\_rate指令。那这里的proxy\_limit\_rate限制的是Nginx从后端服务器读取数据的速率。

## proxy\_ignore\_client\_abort

当数据正在proxied server--&gt;Nginx--&gt;client 之间进行传输，此时client关闭了连接。此时Nginx与proxied server之间的连接该怎么办？默认值是off，也就是会关闭该连接。

但是，，如果Nginx作为一个cache server的话，将proxied server的数据完整的读取到Nginx中，也不失为一种好的选择。

## proxy\_ignore\_headers

Nginx会处理后端服务器中某些特殊的Header，大部分是以X-Accel-\*开头。例如X-Accel-Redirect，X-Accel-Expires等。

“X-Accel-Expires”, “Expires”, “Cache-Control”, “Set-Cookie”, and “Vary” 指令与cache有关系

“X-Accel-Redirect” 执行内部重定向。注意无论该Header的值是什么，Nginx都会尝试做**内部重定向**，注意不是执行外部重定向。

“X-Accel-Limit-Rate” 执行rate limie限制

“X-Accel-Buffering” 执行buffering

“X-Accel-Charset”设置charset的头部，该头部与http-charset头部有关系。

## Cookie

cookie的主要作用是服务器对用户的识别以及用户状态的识别。Cookie并不是HTTP1.1的标准化产物，同时Cookie也不适合用来传递机密性的信息。

该[网址](http://bubkoo.com/2014/04/21/http-cookies-explained/)详细介绍了Cookie。主要涉及了两个头部信息，Set-Cookie和Cookie。服务器返回Set-Cookie头部，包含name，expires，path，domain。

name是该cookie的名称，Client向Nginx发送Cookie头部时，只会发送name字段，其它字段是不会发送的；

expires：指定了该cookie的过期时间，到期以后，浏览器会删除该cookie

domain：当浏览器访问的网址的后缀是domain时，浏览器就会发送该cookie

path：与domain的功能类似，只是又加了一个发送cookie的限制条件，只有当URI是以PATH为前缀时，浏览器才会发送该cookie。

### proxy\_cookie\_path 和 **proxy\_cookie\_domain**

这两个头部其实是修改后端服务器的Set-Cookie的值，当然也不难理解。Nginx作为反向代理，是需要的。

## proxy\_store 和 proxy\_store\_access

反向代理服务器在从后端服务器抓取数据时，可以在Nginx本地存一份。所以这两个指令有cache的行为，但是又没有过期清理的功能。感觉有点鸡肋。

## proxy\_redirect

这个指令也是用来修改proxed server返回的response头部的。

当proxed\_server返回301或302时，存在HTTP Response Header --&gt; Location。proxy\_redirect指令就提供了修改Location字段的功能。

## proxy\_force\_ranges

忽略proxied server返回的HTTP 头部accept-range头部

## proxy\_intercept\_errors

对于proxied server返回的大于或等于300的错误，Nginx作何处理，有两种方式：直接将proxied server返回的状态码返回给client端，这也是默认的方式；另外一种方式就是Nginx截获该错误，转而执行error\_page 的逻辑。

## proxy\_next\_upstream

之所以放在了request指令部分，是因为在Nginx如果收到了后端服务器返回的错误，那么它会将请求转转发到另一台后端服务器上。

通常的错误有：error与timeout，与后端服务器建立连接时出现错误；http\_500,http\_502； http\_404，http\_403等；

注意：upstream模块会记录每一个后端服务器未能成功处理请求的次数，当达到某阈值后，Nginx就会停止向该后端服务器转发请求。具体到http-upstream-module模块，进行详细理解。

