通过http-proxy-module，Nginx实现了反向代理的功能。它的本质是Nginx作为客户端，向后端服务器转发请求。通过tcpdump指令可以看到Nginx发往后端Server的请求。以下指令是以修改Header--&gt;修改body --&gt; 发送请求为顺序，介绍指令。

## proxy\_bind

绑定反向代理服务器的出口IP，注意如果绑定的IP地址无法到达后端服务器，反向代理服务器会返回502错误。

## proxy\_connect\_timeout

与后端服务器建立连接的超时时间

# proxy\_method

**修改向后端服务器发送的HTTP Method。**

注意：Nginx会忽略client请求的Method。

# proxy\_set\_header

向后端发送请求时，用户可通过该指令修改、添加或者删除header。

比较特殊的Header是Host，Nginx默认会执行以下两条指令：

proxy\_set\_header  Host  $proxy\_host

proxy\_set\_header  Connection close

client发送的Host字段自然是Nginx所在节点的域名，但是Nginx转发该请求时，将它修改成了后端服务器的域名。当然你也可以通过proxy\_set\_header Host $http\_host指令，保持Nginx不修改Host字段。

Connection是管理client\/server之间的连接的，HTTP 1.0 默认采用的是close，HTTP1.1默认采用的是keep-alive。同时，也印证了Nginx与后端服务器之间采用HTTP 1.0的通信协议。

注意：proxy\_set\_header  content\_type ""，Nginx将过滤掉content\_type头部。

Nginx也可以作为一个缓存服务器（只要配置了相关的cache指令），此时，cache相关的指令，例如，if-modified-since，if-match等，将会被Nginx过滤掉。

## proxy\_set\_body

赋予了反向代理服务器修改client body的机会

还记得Nginx作为Web Server时，我们希望执行echo ${request\_body}，但是结果总是为空吗？注意，即使把该变量放在log\_format当中，也无效。

set $data $request\_body

proxy\_set\_body  ${data}

上面的代码也是无效的，通过Tcpdump指令发现，request body的内容为空。

所以，request\_body变量只能使用在类似proxy\_set\_body的指令上。

## proxy\_request\_buffering

设置Nginx是否缓存request body。如果不缓存，那么Nginx直接将该HTTP请求流式地传递给后端服务器。

由于Nginx没有缓存body，后端服务器处理失败的情况下，无法将该请求转发到另一台后端服务器上。

# proxy\_pass

proxy\_pass指令需要URL作为参数，URL包含三部分，HTTP\/HTTPS，IP或domain:\[prot\]，URI。其中前两个是必须的。

除了可以指定IP:\[PORT\] 或 DOMAIN:\[PORT\] 两种情况以外，proxy\_pass还允许指定一个server group，即利用upstream指令将所有的后端服务器指定为一个组，Nginx可以采用多种策略（round-robin，weight）转发给后端，由upstream指令控制。

proxy\_pass的URI部分如果不存在，则直接将client请求的$uri转发给后端服务器。如果存在URI部分，按照以下规则处理：

## location的参数是Prefix方式

此时Client请求可以分为两部分prefix+tail ,prefix部分当然与location的prefix部分是相等的。所以Nginx转发的URI是：proxy\_pass的URI + tail。

## location的参数是正则表达式

此时Nginx在语法上不允许proxy\_pass指令携带URI部分，否则就会报告以下错误：

"proxy\_pass" cannot have URI part in location given by regular expression,

or inside named location

or inside "if" statement

or inside "limit\_except" block

## 注意

1. 如果client的请求被内部重定向到其它location了，那么以$uri为替换对象。也就是当前的URI为替换对象

2. 如果希望在修改$uri的值，但是又不希望进行内部重定向，该怎么办？ rewrite \/name\/\(\[^\/\]+\) \/users?name=$1 break; 即考虑使用rewrite指令

3. $args部分也是允许代理服务器进行修改的。在proxy\_uri的URI的后面可以添加request parameter，也可以修改。


