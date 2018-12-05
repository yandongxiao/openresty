# merge\_slashes

用户发送的URI中如果存在连续的slash，那么很有可能是用户拼接URL出现错误，merge\_slashes on即可容忍这种错误。

merge\_slashes off：利用URI在匹配location的时候会受到影响，一般不会匹配到希望的location。

注意，base64 encoding编码中有编码字符slash，所以如果Nginx支持这种编码格式，那么merge\_slashes就应该置为off。建议on。

注意，如果Nginx作为Web服务器，从本地取文件时，大部分文件系统是可以容忍这种路径的，\/tmp\/\/\/\/data。所以merge\_slashes off时还能够正常工作。如果Nginx作为反向代理服务器，那么后端服务器收到的URL是**没有**merge slashes的。

# ignore\_invalid\_header

Header合法的名称由以下字符组成：English letters, digits, hyphens（横杠）。 underscores\_in\_headers和ignore\_invalid\_headers一般应该在HTTP上下文中设置。 ignore\_invalid\_headersr如果被设置了，那么这些非法header是无法再Nginx配置中使用的。

注意：即使ignore\_invalid\_header off被设置了，header也不一定可以被访问。变量插值对变量名称也是有一定要求的

# underscores\_in\_headers

如果underscores\_in\_headers设置为on，那么合法的字符还包括下划线。

# **client\_header\_buffer\_size**

存放request header的缓存

默认大小为1K

# **large\_client\_header\_buffers**

适用于request header头部超过1K

语法：large\_client\_header\_buffers num size

默认值是4 8k

一个request line或者request header的长度，都不应该超过8k。若request line超过，返回414\(Request-URI Too Large\)；若request header超过，返回400（Bad Request）。

# **client\_header\_timeout**

连续超过Ns钟接收不到cient发送Header数据，就返回请求超时（408 Request Timeout）

# client\_body\_buffer\_size

指定接受body的缓冲区的大小，当然，缓冲区一般不会设置的过大，毕竟Nginx会为每一个request分配这么一块缓存。

默认值是page的两倍，x86\_64系统下应该是16k

# **client\_body\_timeout**

连续超过Ns钟接收不到cient发送的Body数据，就返回请求超时（408 Request Timeout）

# **client\_max\_body\_size**

设置用户的request body的最大值，超过该值时，返回413（Request Entity Too Large）

默认值是1m

可设置为0，表示不限制

# client\_body\_temp\_path

当用户上传的文件内容需要持久化，或上传的数据大于client\_body\_buffer\_size的大小，Nginx都会生成临时文件。

该指令指定临时文件存放的目录

默认值：在"prefix"目录下会创建**client\_body\_temp**目录

如果需要持久化，那么Nginx会将该临时文件move过去

这也说明了临时目录和上传的位置在同一个文件系统下的重要性

注意：临时文件会被清除

# **client\_body\_in\_single\_buffer**

将整个请求体放到一块buffer当中，有两个好处：

1. 方便使用request\_body指令

2. 避免了内存\/系统缓存\/磁盘之间数据的来回拷贝


当然，采用这种方式的最根本原因是，我们希望在Nginx的配置内处理body数据。

**注意，如果用户上传的文件，我们不关心，应该就不需要设置该指令，它太耗费内存了，对吗？**

# **client\_body**总结

以上指令最有可能需要调整的是：client\_max\_body\_size，例如在COS当中该值就应该设置为100m；其次是client\_body\_temp\_path的值与用户最终上传的位置，处于同一个文件系统；最后就是client\_body\_in\_single\_buffer，if not set，当请求体大于client\_body\_buffer\_size的大小以后，需要**手动**去临时文件内读取。

# max-ranges

在HTTP响应中server可以通过accept-range: bytes，告知client端接受range请求；accept-range: none，告知client不接受range请求。

client在知道可以发送range请求后，即可通过range header发送range请求，例如， Range: bytes=-3000, 5000-7000，这种range请求称之为多重范围请求

max-ranges指令即可限制range请求中，最多可以指定N个范围；如果指定为0表示不限制；如果请求的range范围个数 &gt; N，那么Nginx将会忽略range header，返回整个文件.

# limit\_rate 和 limit\_rate\_after

限制每一个request的响应速率，0表示不限制。

更有价值的的是同名的变量$limite\_rate，将它放在条件变量里面，即可实现很多功能限制。比如会员和非会员。

proxied server也可以通过A-Accel-Limite-Rate头部来进行限速，这样的话，就可以实现更加细腻的限制。

limit\_rate\_after确保：当用户请求小文件时可以快速返回，体验好

