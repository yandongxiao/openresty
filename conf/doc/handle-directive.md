# server

server上下文

# server\_name

根据用户请求的HOST字段选择合适的server。
可以指定不止一个server\_name指令
同时server\_name指令可以有不止一个值，其中第一个值称为主server name

server\_name example.org www.example.org;
\#server\_name \*.example.org;
server\_name mail.\*;
server\_name ~^\(?&lt;user&gt;.+\).example.net$;
server\_name "~^\(?&lt;name&gt;\w\d{1,3}+\).example.net$";

## 优先级次序

1. exact macth
2. wildcard names
  2.1 只能使用\*通配符，而且通配符只能出现在开始和结束的位置，而且必须以.作为分隔符
  2.2 \*.xxx 如果匹配多个的话，xxx的长度越高，优先级越高
  2.3 xxx.\* 如果匹配多个的话，xxx的长度越高，优先级越高
  2.4 .example.org 代表了example.org和\*.example.org两个。点号**不能**放在尾端，表示example.org和example.org.\*
3. regular expression
  3.1 是以～为正则的标志, 需要^$作为起始标志。正则不需要一定有^$

# listen

该指令有非常多的关于套接字的选项，目前熟悉的有reuseport。

listen指令只能在server上下文中指定

可以有多个listen指令，监听不同的address:port

所有server的所有Listener都需要指定不同的address:port，否则报重复监听的错误。

## default server

我们知道在server\_name指令中可以指定default server，但是这并不意味着，整个nginx.conf中只有一个default server。

不同的address:port都有自己的default server。如果同一个address:port有多个server（它们的server name不同），且没有指定default\_server 的情况下，第一个作为default server。

# location

在选择了server以后，Nginx会对URL进行一些调整，解码编码的字符，merge slash，去掉 .或者..；接下来就应该选择location了。

location \/ {} 如果不存在的话，会默认添加。

有两种语法指定location：prefix string，regular expression。以下也是location匹配的顺序

## prefix string

语法：prefix string肯定是以斜杠开始的

一个server可以有多个location，多个location可能都会匹配该请求。那么记录下**最长匹配**的location。

注意找到最长匹配厚，并不会立即执行该location，根据优先级规则，接下来会去匹配正则表达式的location。

## regular expression

既然regular expression的优先级比prefix string的高，那么为什么不优先匹配regular expression呢？

个人估计原因有：

1. 正则表达式匹配的非常耗时的，而prefix string匹配的代价相当小；
2. prefix string才是最经常使用的匹配方式；
3. prefix string可以通过=或者^~的方式，提升优先级。

**语法**：是以~或者~\*开头的字符串，可以进行捕获操作。

regular string 按照regular在配置文件中的顺序匹配，一旦匹配成功，立刻执行该location

## 提升prefix string的优先级

1. 在prefix string之前添加=，表示exact匹配；
2. 在prefix string之前添加^~，表示一旦有^~的location匹配成功，那么不在进行regular expression的匹配。直接执行该location。 
3. 在字符串前加@：说明该location不能直接被用户请求，处理的是内部请求.

注意@location与internal之间的区别。
注意：如果prefix string的末尾存在\/，但是用户请求URI的末尾没有加\/。作为WebServer，如果存在该目录，返回301错误（注意如果用户请求的URI末尾添加了\/，那么走的是index逻辑）；作为反向代理服务器，, 此时返回301永久重定向。

你也可以定义两个字符串，一个以\/结尾，一个不以\/结尾。

# limit\_except

对Method进行限制，语法是limit\_except  GET {}.

**注意：限制是针对非GET方法的，GET方法不受任何限制。**

limit\_except指令可以和http\_access\_module, http\_auth\_basic\_module的指令结合使用。

比如只允许超级用户才能进行PUT，POST操作。

# internal

在location的一开始，通过该关键字声明它是一个内部请求。

该location不止可以接受内部请求，也可以匹配外部请求；根据internal指令会对于外部请求返回404。

如果想让外部请求不匹配internal，可在internal当中添加特殊字符，更加可取的方法是在location前面添加@。

以@开头的location有以下特点：

1. 不接受外部请求，，即不与URI进行匹配
2. URI在该location当中的值与父location的值一样。

## 内部请求

可以发起内部请求的指令有：error\_page, index, random\_index, try\_files; upstream服务器返回的重定向响应中包含X-Accel-Redirect头部；rewrite指令

# root 和 alias

与root一样都是用来定位请求的资源。

语法：alias path or path\/to\/file

语义：将location的value替换为alias的值。再加上URL请求的tail，形成一个完整的本地PATH

* 如果location当中含有正则表达式？

  * location的正则表达式需要有capture行为，\(\)；
  * alias需要有引用capture的行为，$1；

* alias支持变量插值


# satisfy指令

satisfy指令属于Http-core-functionality模块当中，它与http-access-module, http-auth-basic-module, http-auth-request-module, http-auth-jwt-module当中的指令一起使用，完成认证。

satisfy any\/all

默认为all

## http-access-module

allow address

deny address

## http-auth-basic-module

auth\_basic "提示语";

auth\_basic\_user\_file \/tmp\/passwd.conf;

## http-auth-request-module

auth\_request

auth\_request\_set

# disable\_symlinks

这是关于如何使用软连接的设置。

默认值是off，即可以使用软连接；设置为on以后，则直接拒绝使用软连接。

* disable\_symlinks if\_not\_owner;

如果用户发送curl localhost\/dir1\/dir2\/data，那么检查dir1， dir2，是否是连接文件；如果是则拒绝访问，同时检查nginx进程和目标文件是否是同一个owner; 如果不是则拒绝访问；

* disable\_symlinks if\_not\_owner from=$document\_root\/aaa;

只有当被检查的PATH符合From前缀时，从aaa目录后开始检查软连接，规则由前一个选项指定，如if\_not\_owner；如果没有匹配到FROM前缀，则规则由前一个选项指定，如if\_not\_owner.

# Index

接下来的几个模块都是为了处理，URI是以斜杠结尾的情况。

## http\_index\_module

index index.html

仅此一个指令

value可以有多个，每个可以进行变量插值

该指令会发起一个内部重定向

# try\_files

Nginx作为WebServer使用时，如果查找的文件不存在，直接返回404。

那么如何让Nginx去文件系统的多个位置进行查找，而且多个位置都不存在的情况下，也可以有多种选择，不只是404。

以上的问题正是try\_files要解决的问题。

try\_files支持变量插值

try\_files  的最后一个参数默认是发送**内部重定向**请求；也可以设置=404，直接返回给用户404。

首先我们需要清楚WebServer的默认访问规则：1.被访问的文件存在，则直接返回200；2. 被访问的文件不存在，则返回404；3. 如果被访问的文件不存在，而存在名称的目录，则返回301错误；URI以斜杠结尾，那Nginx会依据http-index-module, http-autoindex-module模块指令，查找相应的文件。

try\_files有以下几处不同：1. try\_file后面的文件只要有一个存在，则立刻返回200；2. 如果除最后一个参数外，所有位置的文件都不存在，则可以返回404或者内部重定向；3. 忽略同名称的目录情况；4. 如果某个值以斜杠结尾，那么Nginx会去查该目录是否存在。

注意try\_files的第二点，可以重定向到它自身。所以有可能发生循环发送内部重定向请求，导致Nginx发送500。

# error\_page

当发生指定的错误时，返回某个特定的页面。

语法：**error\_page** code ... \[=\[response\]\] uri;

例如：error\_page 404 \/404.html;

特点：

* 可以在多个上下文进行设置，如http，server，location等；优先级是location &gt; server &gt; http；如果更高级别没有设置error\_page，那么它将继承上一级别上下文的设置。
* ... 表示多个，error\_page 500 501 502 \/50x.html 合法
* error\_page 404 = \/404.php; 如果作为反向代理服务器，error page的设置应该多一个=，即保留了反向代理服务器的状态吗，但是response body被404.php替代。
* error\_page 404 =200 \/empty.gif; 改变状态码；
* uri部分可以指定一个相对于“prefix”的“绝对路径”
* uri部分还可以是一个URL地址，属于外部跳转，nginx默认返回302.
* 如果是@fallback的内部跳转，nginx直接跳转到内部请求去执行。
* uri部分允许变量插值。

# 注意

index，try\_file，和error\_page都是发送了内部重定向的请求。以try\_files为例，千万不要以为Nginx将try\_files的最后一个参数直接返回了。而是发送了一个内部重定向的请求。

# open\_file\_cache

**open\_file\_cache** `max`=`N` \[`inactive`=`time`\]

指定Cache的大小，和一个cache的有效时间。（类似于client\_header\_timeout那种）

# open\_file\_cache\_valid

指定cache主动检查文件描述符有效性的时间间隔。根据网上的配置，这个值要稍微大一些（相比于inactive）。

其实open\_file\_cache\*这些指令可以不打开，因为操作系统也会缓存这些内容在内核。就是省去了用户态和内核态的切换时间。

# open\_file\_cache\_errors

查找失败时，是否也缓存该信息

# open\_file\_cache\_min\_uses

只有在inactive时间段内，有这么多个访问文件描述符的情况下，才会继续在cache中存在。

# lingering\_close, lingering\_time 和 lingering\_timeout

从ESTABLISH状态开始，主动链接和被动连接之间的状态是

主动链接：ESTABLISH--FIN--&gt;FIN\_STAT\_1-------------&gt;FIN\_STAT\_2--------------------ACK----&gt;TIME\_WAIT---&gt;CLOSED

被动连接：ESTABLISH-------------------------ACK--&gt;CLOSE\_WAIT--FIN--&gt;LAST\_ACK---------------------------&gt;CLOSED

作为主动关闭连接的一方，TIME\_WAIT默认等待的时间会长一些，那么在下面的场景就会有问题：

大量的client发送大量的短连接，而且client很“不负责任”，不关闭连接。当达到了keep-alive指定的时间后，server端主动关闭了该连接。此时server端的很多socket就会处于TIME\_WAIT状态。

lingering\_close on: 等待一段时间，直到lingering\_time或者lingering\_timeout指定的时间。

lingering\_close alwayse：按照TCP\/IP协议走

lingering\_close off; 连接会立即断开，注意，**should not be used under normal circumstances**。

# **reset\_timedout\_connection**

结论是设置为on

在lingering\*的中，当client被服务关闭后，“不负责任”地不关闭连接；但是也会出现另外一种情况，即timeout的情况，即连接中断。该怎么办？

默认情况下，Nginx会主动关闭该连接，然后长时间的处于FIN\_STAT\_1状态，直到系统默认时间或者lingering\_time（假如指定了该时间）。reset\_timedout\_connection就是专门为了解决timeout情况。

过程如下：设置socket SO\_LINGER选项，并使得lingering\_time = 0；此时一旦close socket，socket所占用的资源就会立即被回收

注意：reset\_timedout\_connection与lingering\*指令之间没有任何关系。

