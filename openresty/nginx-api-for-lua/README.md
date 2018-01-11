# Nginx API for Lua

nginx-api-for-lua 提供了两个包：ngx 和 ndk. 开发者无需require即可直接使用。 nginx-api-for-lua将网络IO操作与Nginx的事件模型结合在一起，使得开发者可以开发同步非阻塞的高并发应用程序。所以，

1. Network I/O operations in user code should only be done through the Nginx Lua API.
2. Disk operations with relatively small amount of data can be done using the standard Lua io library.
3. Delegating all network and disk I/O operations to Nginx's subrequests (via the ngx.location.capture method)

> 注意，第三点**并非是**说阻塞式的耗时操作只要放到Nginx的自请求里面即可。
