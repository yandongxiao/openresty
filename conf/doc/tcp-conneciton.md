# 连接过程

1. LISTEN。server端的listen socket处于的状态
2. SYN\_SENT。client 连接时发送的第一个packet，也是三次握手的第一步，client就进入了SYNC\_SENDT状态
3. SYN\_RECEIVED。三次握手中的第二步，表示server端已经接受到syn包，并发送ack\/syn包。
4. ESTABLISHED。表示连接已经建立，可以传递数据。

# 结束过程

1. FIN\_WAIT\_1。主动关闭连接的一方会发送FIN，此时主动关闭一方的状态变成FIN\_WAIT\_1。对端一般会立即发送ACK请求，所以该状态一般很难见到
2. FIN\_WAIT\_2。主动关闭连接的一方在收到ACK以后，就会进入该状态。接下来仍然会等待对端发送SYN包。如果对端同时发送了ACK\/FIN包，那么主动关闭连接的一方直接进入TIME\_WAIT状态。
3. TIME\_WAIT。主动关闭连接的一方在收到ACK\/SYN包以后，会发送ACK请求，，并等待一段时间，，让client端能够收到ACK。
4. CLOSE\_WAIT。被动关闭连接的一方，在收到FIN请求并发送ACK以后，处于的状态。此时被动关闭连接的一方可以继续发送数据，但是无法读取数据。
5. LAST\_ACK。被动关闭连接的一方在发送了FIN包以后，由CLOSE\_WAIT状态变成last\_wait
6. CLOSED。主动和被动方都变成该状态

[参考连接](http://www.cnblogs.com/fczjuever/archive/2013/04/05/3000680.html)

