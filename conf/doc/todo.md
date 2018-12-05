# 1. 搭建lua-nginx-module的测试环境

参考如下链接：[http://justcodeit.info/blog/how-to-test-openresty.html](http://justcodeit.info/blog/how-to-test-openresty.html)

# 2. 重新编译openresty

# 2.1 编译指令

```
--with-openssl=/opt/openssl-1.0.2g --with-debug --with-dtrace-probes --with-no-pool-patch --with-http_iconv_module --with-http_drizzle_module --with-http_postgres_module --with-lua51 --with-luajit  --with-select_module --with-poll_module --with-threads --with-file-aio --with-ipv6 --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-mail --with-mail_ssl_module --with-google_perftools_module --with-cpp_test_module --with-pcre --with-pcre-jit --with-md5-asm --with-sha1-asm  --with-libatomic--with-openssl=/opt/openssl-1.0.2g 指定的是源代码的位置

```

这么长的编译指令，紧接着就是在configure的过程中报告各种找不到库的问题

# 2.2 安装libdrizzle库

Centos7默认没有这个安装包，需要自己下载并安装。参照[drizzle-nginx-module](https://www.notion.so/://github.com/openresty/drizzle-nginx-module)的方法进行安装

```
wget http://agentzh.org/misc/nginx/drizzle7-2011.07.21.tar.gztar -xvf drizzle7-2011.07.21.tar.gzcd drizzle7-2011.07.21./configure --without-servermake libdrizzle-1.0make install-libdrizzle-1.0

```

# 2.3 其它安装包

```
yum install libpqxx-develyum install libxslt-develyum install gd-devel gdyum install GeoIP-develyum install gperftools-develyum install libatomic_ops-devel

```

# 3. 搭建mysql, memcached, redis 等服务

# 3.1 搭建mysql

## 3.1.1 安装

```
yum install mysql mysql-server mysql-develyum install mariadb-server mariadb

```

## 3.1.2 初始化

1. 创建用户：名称和密码都是ngx\_test.
2. 为用户设置权限
3. 创建数据库：ngx\_test

# 3.2 搭建其它模块

```
yum install memcached.x86_64systemctl start memcached.service

```

# 4. 测试脚本

最后附上自己的测试脚本，将测试通过和未通过的文件，分开放置

    #!/usr/bin/env bashexport PATH=/usr/local/openresty-1.9.7.5
    ginx/sbin:$PATH# exec prove $@for i in $@; do    output=`prove 
    "
    $i
    "
    `    echo $output | grep 
    "
    All tests successful
    "
    &
    >
    /dev/null    if [[ $? -eq 0 ]]; then        mv $i tested    else        mv $i totest    fidone


# description: 介绍openresty测试框架Test::Nginx

openresty 的作者春哥正在写一本书叫《programming-openresty》，开篇即介绍openresty的自动化测试框架Test::Nginx. 点击[这里](https://www.gitbook.com/book/openresty/programming-openresty/details)看书，以下是自己浅显的总结

# 1. Test::Nginx框架简介

Openresty在github下面有自己的[主页](https://github.com/openresty)，主页上的项目几乎都采用该框架进行自动化测试。作为一名想深入学习Openresty的童鞋来说，自然是必不可少的技能。一来它能保证代码的质量，二来你也可以通过阅读模块的测试代码，深入理解模块的测试指令;

接下来就看看Test::Nginx都有哪些特点: a. 它是Perl语言写的，继承了Test::Base测试框架。对于初学者Perl和Test::Base都不必过多涉及，可以认为Test::Nginx创造了一门新的测试语言，它具有\*\*\*specification-like\*\*\*特点。简而言之就是易读、易写; b. Openresty作为高性能的Web应用框架，处理请求时又分为了11阶段，又有子请求、内部请求、重定向等等一系列的功能，Test::Nginx是如何做到对这些特性的测试的。通过看大牛的测试代码来指导自己; c. Test::Nginx是可扩展的，注意是\*\*\*语言\*\*\*可扩展; d. Test::Nginx的核心模块是Test::Nginx::Socket。

# 2. Test::Nginx 框架安装

网上的这篇教程不错，点击[链接](http://justcodeit.info/blog/how-to-test-openresty.html)。

# 3. 测试代码组织结构

* 根目录下创建一个t目录，该目录下的测试文件以.t结尾
* 重要的特性是每一个测试文件都是可以单独进行测试的
* 启动测试的方法: prove t/\*.t 或 prove t/xxx.t

# 4. 代码内容的组织结构

测试文件内容分为两部分。第一部分是Perl语言代码，主要是设置环境变量，设置共享变量等；第二部分是Test::Nginx语言内容。两部分内容通过\*\*\***DATA**\*\*\*分割. 不过的测试文件变化最大的在于Test::Nginx语言部分，Perl语 言部分变化不大。

# 5. Test:Nginx语言结构

测试文件内容由一个或多个\*\*\*test block\*\*\*,下面就是一个test block，代表一个测试case。

```
=== TEST 1: hello, world        # 指定title, 关键字是===, 顶行写This is just a simple demonstration of theecho directive provided by ngx_http_echo_module. # 一段描述, 可选# 以下为一个或多个***data section***, 每个secotion都有section name和section value。# section的分隔符是---, 也是关键字.--- config              # config 称之为section namelocation = /t {         # seciton value， 有多行    echo 
"
hello, world!
"
;}--- requestGET /t--- response_bodyhello, world!--- error_code: 200     # section value 只能有一行---                     # undefined section--- ttt                 # sectio name == ttt, value=
"
"
```

其中request和config是输入section，response\_body, error\_code是输出section. 看来section name是有特殊含义的，不能乱起名字。

还有一种类型的setion，不是输入类型也不是输出类型，它是用来控制test blocks如何运行的，例如只运行某一个block:ONLY, 跳过某个block的运行:SKIP等。我们称之为control section

Test filter 用来调整section value的值，它的位置在name和value之间，一般形式如下:

```
--- error_code chomp  # 其中chomp就是一个filter200

```

与下面的data section 等价

```
--- error_code: 200

```

注意于下面的section的区别

```
--- error_code200

```

# 6 启动测试

最简单的启动方式是：prove t/xxx.t，但是标准做法是：

```
#!/usr/bin/env bashexport PATH=/usr/local/openresty
ginx/sbin:$PATHexec prove 
"
$@
"
```

作者给出的一个原因是放置污染环境变量

# 6.1 测试脚本

```
use Test::Nginx::Socket 'no_plan';run_tests();__DATA__=== TEST 1: hello, worldThis is just a simple demonstration of theecho directive provided by ngx_http_echo_module.--- configlocation = /t {    echo 
"
hello, world!
"
;}--- requestGET /t--- response_bodyhello, world!--- error_code: 200     # 该配置项目总是存在，默认值200

```

# 6.2 输出结果

```
main.t .. okAll tests successful.Files=1, Tests=2,  0 wallclock secs ( 0.01 usr  0.01 sys +  0.11 cusr  0.05 csys =  0.18 CPU)Result: PASS

```

注意：虽然只有一个test block, 但是实际上执行了两次test，test plan以后者为准.

# 6.3 高级用法

* prove -v t/foo.t 输出详细信息
* prove -r t/
* 多个测试文件一起运行时：按照文件名称的字母顺序，其次是顺序执行（没有并行执行测试文件）
* 一个文件内block的执行顺序：shuffles，也就是乱序。 可以通过Perl指令no\_shuffle\(\)来禁止

# description: 介绍openresty测试框架Test::Nginx

# Test::Nginx 编程

# 1. Test::Nginx 的工作流程

Test::Nginx的基本组成单位是test block, 在test block当中包括nginx.conf配置（例如config section），发送的请求\(例如request section\)，响应的验证（例如response section）。所以Test::Nginx的执行流程如下： 1. 根据config，http\_config等配置项动态生成nginx.conf文件。改配置文件在t/serverroot/conf/nginx.conf； 2. Test::Nginx启动Nginx，所以需要确保PATH路径包含nginx 3. 根据request，pipelined\_requests等请求section，向Nginx发送请求 4. Test::Nginx将输出section和Nginx会返回的response进行比较，确认该case是否能通过； 5. 打印Test summary。 本届剩余的内容就是来学习，Test::Nginx为我们提供的这些section。 **注意：一定要将xxx.t文件放在t目录下面，因为此时执行prove t/xxx.t命令后，会产生conf/nginx, logs等关键信息。 每次执行新的test block时，conf/nginx,logs等内容会重新生成**

# 2. 与配置文件相关

**sectionconfiguration**main\_configtop-level scopehttp\_confighttp{}configserver{}

从上面的配置来看，只能配置一个http和一个server。如果要配置location, 可以在config section下面完成。

# 3. 与请求相关

**sectionconfiguration**request请求首部\(默认使用HTTP1.1协议\)more\_headers指定请求头pipelined\_requests以piplined的方式发送请求，于eval搭配使用

# 4. 与响应有关

**sectionconfiguration**response\_body指定期望的响应体,全匹配response\_body\_like指定期望的响应体，正则匹配（Perl正则）response\_headers指定期望的响应头，可以指定多个error\_logerror.log中出现指定的字符串，测试通过no\_error\_logerror.log 中不出现指定的字符串，测试通过grep\_error\_loggrep语法进行比较，与grep\_error\_log\_out配合使用grep\_no\_error\_loggrep语法进行比较wait延迟读error.log的时间，以秒为单位

## 4.1 response section

response\_body会与http response body做完全字符串匹配，如果匹配失败，Test::Nginx会在Test summary中以非常友好的方式显示它们的差异行。用户还可以调用Perl的两个函数来改变此行为： 1. no\_long\_string\(\) 以diff的方式显示它们的差异性 2. no\_diff\(\) 完全输出expect string和actual string的内容 注意这两个函数的调用必须放置在run\_test函数之前

如果使用多行section格式，请记住Test:Nginx会在section value的末尾添加一个换行符，如果不需要此换行符，请使用chomp filter.

## 4.2 response\_body\_like section

对http response body进行正则匹配，有两种方式：section value直接就是正则表达式，或则利用eval filter书写Perl正则。后者会更具有表达力。

## 4.3 error\_log

```
-- error_loghello world

```

1. 在error.log中查找关键字\*\*\*hello world\*\*\*，
   **注意不包括换行**
   。
2. 可以指定多行value，Test::Nginx将拿每一行的值在error.log中进行查找。
   **注意这两行值在error.log中没有先后顺序**
   。
3. 通过eval filter 可以指定正则表达式

## 4.4 grep\_error\_log

error\_log存在两个缺陷：1.无法指定section value出现的次数；2. 无法指定section value的每一行在error.log中的先后顺序。于是有了grep\_error\_log, 它于grep\_error\_log\_output配合起来使用。

grep\_error\_log的工作流程如下：首先检查error.log的内容，将匹配的字符串收集到一起，注意只是收集匹配的字符串（非字符串所在的行），其次每次匹配的字符串以换行符进行分割；将收集的字符串于grep\_error\_log\_output的section value进行全匹配。

## 4.5 wait

nginx响应请求以后会立即写日志，但是可能会出现Test::Nginx 过早的去检查文件内容，以至于测试case失败。解决办法就是添加wait control section。

# 5. Testing Erroneous Cases

本节介绍如何利用Test::Nginx来模拟异常情况，例如Nginx启动失败，发送畸形的请求或响应，模拟各种timeout等情况。

**sectionconfiguration**must\_die期望Nginx会启动失败ignore\_response期望Test::Nginx放弃sanity checksraw\_requestHTTP请求的每一个字节都完全由自己控制，可以模拟恶意客户端timeout + abort模拟客户端异常终止的情况

1. 虽然Test::Nginx启动失败时会向error.log中记录日志，但是单凭error\_log section是无法通过测试的。因为Test::Nginx认为Nginx启动成功是正常行为，必须额外添加must\_dir section。 2. 默认情况下，Test::Nginx会对response做 sanity checks检查，如果是非法的响应消息，Test::Nginx会将它丢弃。那么对输出的检查就无法执行。需要通过ignore\_response section，让Test::Nginx放弃sanity checks。 3. 
   **注意：Test::Nginx的客户端永远不会主动关闭连接，直到timeout。Test::Nginx会报告错误，这有可能是Nginx没有释放socket导致的。所以可能会有资源耗尽的错误**

# 6. 模拟连接、读、写超时

模拟连接超时：可以利用iptable将SYN包丢弃掉，模拟连接超时。春哥的

# description:

通过官方文档和测试代码,查看[文档](https://github.com/openresty/lua-nginx-module#set_by_lua).

# 内容简介

* 该指令可以接受参数
  `set_by_lua $res `
  `<`
  `lua-script-str`
  `>`
  ` [$arg1 $arg2 ...]`
  ，注意参数的位置是在最后;
* 可以调用大部分的
  [Nginx API](https://github.com/openresty/lua-nginx-module#nginx-api-for-lua)
  ，即以ngx.xxx开头的接口，如ngx.var.num;
* set\_by\_lua指定的code并没有在自己的coroutine当中运行，而是在主线程中运行，所以并不适合调用网络IO操作，也不适合执行耗时的操作;
* 可以其它rewrite阶段的指令糅合在一起运行，执行顺序是配置文件书写的顺序;
* 可以直接使用$符号.

# 测试文件内容简介

* set\_by\_lua arg\_a res html/a.lua arg\_b; 这是set\_by\_lua\_file接收参数的方法，file也可以使用变量

  res"returnngx.arg\[1\]+ngx.arg\[2\]"

  argb;注意set是如何引用参数的。−setbyluafile

  arga

* 传递给set\_by\_lua的参数类型是字符串，不过如果a+b都是数字，LUA会自动进行类型转换

## 与其它rewrite阶段的指令混用

```
set $b 
"
"
;                                                                                   │set_by_lua $a 
"
ngx.var.b = 32; return 7
"
;

```

* 如果把set指令注释掉，则程序执行崩溃。
* ngx.var.arg\_foo = 
  "
  world
  "
  ; 如果用户没有传递foo变量，那么该指令也会引起500错误。
* Get操作是合法的， 例如return ngx.var.arg\_foo.

## 调用IO相关的API

```
set_by_lua $res 
"
ngx.print(32) return 1
"
;

```

* 返回500， 并在日志中打印“API disabled in the context of set\_by\_lua”
* 不能调用ngx.location.capture, ngx.exita, ngx.redirect, ngx.exec, ngx.req.set\_uri\(uri, true\), ngx.req.read\_body, socket函数相关
* 所有跟网络IO相关的函数调用

## 可见范围

* EST 37: globals get cleared for every single request: 在set\_by\_lua中定义的全局变量，只是针对这个请求；
* TEST 39: server scope \(inline\): 在server{}中可以使用set\_by\_lua函数，应该是每一个请求执行一次.
* TEST 40: server if scope \(inline\): 可以于if指令一起使用

## 练习

在server{}之间通过set\_by\_lua指令，设置的全局变量或这局部变量的生命周期是什么?

```
=== TEST 301: server scope (file)--- config    location /foo {        set_by_lua_block $ret{            if ngx.var.val then                ngx.var.val = ngx.var.val + 1                return ngx.var.val            end            return 
"
foo
"
        }        content_by_lua 'ngx.print(ngx.var.ret)';    }    location /bar {        set_by_lua_block $ret {            if ngx.var.val then                ngx.var.val = ngx.var.val + 1                return ngx.var.val            end            return 
"
bar
"
        }        content_by_lua 'ngx.print(ngx.var.ret)';    }    set_by_lua_file $val html/a.lua;--- user_files
>
>
>
 a.luareturn 1+1--- pipelined_requests eval[
"
GET /foo
"
, 
"
GET /bar
"
]--- response_body eval[3, 3]--- no_error_log[error]
```



