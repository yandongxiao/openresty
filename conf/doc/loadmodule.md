# debug\_connection

与一般的DEBUG调试不同的，debug\_connection允许用户指令client地址，只有从这些地址发送的请求，才会打印它们的详细信息。

* 编译时需要--enable-debug选项
* 在error.log中显示DEBUG信息

* 拥有关键字**\[debug\]**

* 包括信息有URI、HTTP Header以及Nginx的各个处理阶段


对写Nginx模块应该很有帮助，一般情况下我们使用不到这个指令。

# ENV

* 默认情况下，Nginx不会从父进程继承任何环境变量，TZ除外。
* Nginx允许继承父进程的环境变量，env PATH. 注意并非是Nginx的一个变量，而且继承下来的环境变量。在content\_by\_lua模块下可以通过os.getenv获取该环境变量
* Nginx允许设置环境变量，env FOO="helloworld"

一般情况下，会将环境变量的值存储到变量当中，进行后续的处理。

# include

在Nginx配置中，针对每一个不同的应用或服务，一定会存在相关的配置。将这些配置放在单独的文件内可方便维护。

* file可以采取绝对路径或者相对路径。相对路径是以“prefix”为准
* include指令可以应用在任意（any）上下文。这给配置文件的组织带来了极大的灵活性
* 允许include vhost\/\*.conf指令，一次性包含所有的配置文件，简化配置代码

# master\_process

Nginx中存在master process和worker process两类进程， master process在启动worker process以后，后面的主要工作是管理worker process。比如发送各种信号，reload的实现等。worker process负责listen、accept、handle等所有操作。处理client连接的操作是在worker process当中完成的。

通过设置master\_process off，可以阻止创建worker process，即连接的处理在master process中完成。

worker\_processes指令可以指定创建的worker process的数量，但是只有在master\_process on时生效

# events

* 配置events上下文
* 它的上一级上下文是main
* 有且只有一个events上下文，即使为空也必须要有

## lock\_file

Linux下是文件锁实现进程间通信的，包括accept\_mutex和共享内存的实现.

默认配置是lock\_file  logs\/nginx.lock

## pid

pid指令用于生成nginx.pid，一般情况下我们不需要设置，也会在logs\/nginx.pid生成

## pcre\_jit

PCRE支持JIT compile，利用JIT技术，可以大大提高Nginx处理正则表达式的速度。而正则表达式又是Nginx经常使用的，例如判断location时就需要进行正则表达式匹配。

* 编译PCRE库时指定支持JIT技术，--enable-jit
* 把PCRE编译到Nginx当中--with-pcre=，--with-pcre-jit

## timer\_resolution

gettimeofday\(\) is called each time a kernel event is received

reducing the number of gettimeofday\(\) system calls made

two request will have the same access time in access.log

建议设置为100ms

## worker\_priority

定义worker进程的优先级，在-20到20之间。

默认值是0

## worker\_processes

worker进程的个数

默认值是1

可以设置为auto

## **working\_directory**

定义worker在崩溃时将core文件放在何处

## **worker\_rlimit\_core**

限制core文件的大小

# worker\_connections

Nginx通过事件机制处理请求，所以一个worker处理成千上万的连接是不成问题的。所以该值可以设置的很大。但是要注意以下几点：

1. 操作系统总共只有65535个端口，能用的端口可能在6万个左右；
2. 默认情况下，一个进程可以打开的文件描述符最多是1024个。可以通过ulimit -n查看；
3. 通过worker\_rlimit\_nofile将上面的值调大一些。

