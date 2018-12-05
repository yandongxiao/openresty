# error\_log

该指令几乎在所有的Nginx配置中都会被使用。**注意access.log是通过access\_log配置的**。

## 日志级别

一般情况下，Nginx的后端有各种各样的服务或应用，Nginx有责任为不同的服务或应用打印不同的日志。

* 该指令可以在多个上下文中进行设置，包括main，stream，server，location等。
* 不同上下文之间的error\_log指令有优先级区别，比如location &gt; server &gt; http &gt; main.
* 优先级高的上下文中，error\_log指令会使得**所有优先级**低的上下文中的**所有error\_log**指令无效

## 日志级别

Nginx提供了以下日志级别，debug，info，notice，warn，error，critical，alert，emerge。**注意alert的级别是要比error级别更高的。**

## 默认值

error\_log  logs\/error.log  error

**注意access.log是通过access\_log配置的，因为access级别的日志量很大，需要缓存和压缩**

## 其它

* error\_log可以调用多次，即不但可以在不同的上下文分别设置，而且可以在同一上下文执行多次
* 在同一上下文之间的指令不会存在覆盖的行为，而是同时生效
* 如果同一上下文中，设置的两条error\_log指令使用了同一个日志文件名称，那么LOG LEVEL较低的生效。

