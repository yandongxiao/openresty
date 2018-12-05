# 学习Test::Nginx

openresty的作者春哥正在写一本书叫[《programming-openresty》](https://www.gitbook.com/book/openresty/programming-openresty/details)，开篇即介绍openresty的自动化测试框架Test::Nginx。 

以下是自己浅显的总结

## Test::Nginx框架简介

Openresty在github下面有自己的[主页](https://github.com/openresty)，主页上的项目几乎都采用该框架进行自动化测试。作为一名想深入学习Openresty的童鞋来说，自然是必不可少的技能。一来它能保证代码的质量，二来你也可以通过阅读模块的测试代码，深入理解模块的测试指令。

接下来就看看Test::Nginx都有哪些特点:
1. 它是Perl语言写的，继承了Test::Base测试框架。对于初学者Perl和Test::Base都不必过多涉及，可以认为Test::Nginx创造了一门新的测试语言，它具有***specification-like***特点。简而言之就是易读、易写;
2. Openresty作为高性能的Web应用框架，处理请求时又分为了11阶段，又有子请求、内部请求、重定向等等一系列的功能，Test::Nginx是如何做到对这些特性的测试的。通过看大牛的测试代码来指导自己;
3. Test::Nginx是可扩展的，注意是***语言***可扩展;
4. Test::Nginx的核心模块是Test::Nginx::Socket。

## Test::Nginx 框架安装

网上的这篇教程不错，点击[链接](http://justcodeit.info/blog/how-to-test-openresty.html)。

## 测试代码组织结构

- 根目录下创建一个t目录，该目录下的测试文件以.t结尾
- 重要的特性是每一个测试文件都是可以单独进行测试的
- 启动测试的方法: prove t/*.t 或 prove t/xxx.t

> 注意
>- 不要使用prove xxx.t的方法来执行测试，虽然这样也是允许的。但是它不会生成nginx.conf, error.log等文件，不利于调试。 

## 代码内容的组织结构

测试文件内容分为两部分。第一部分是Perl语言代码，主要是设置环境变量，设置共享变量等；第二部分是Test::Nginx语言内容。两部分内容通过***__DATA__***分割. 不过的测试文件变化最大的在于Test::Nginx语言部分，Perl语言部分变化不大。

## Perl语言指令

－ repeat_each(2)： 每隔请求执行两次
- use Test::Nginx::Socket::Lua "no_plan";  no_plan在调试时很重要
- use Test::Nginx::Socket::Lua; plan tests => repeat_each() * (blocks() * 2 + 19); 指定要测试的case的总数，如果最终测试的case与它不相等，该测试文件不通过。

## Test:Nginx语言结构

测试文件内容由一个或多个***test block***, 下面就是一个test block，代表一个测试case。

```
  === TEST 1: hello, world        # 指定title, 关键字是===, 顶行写
  This is just a simple demonstration of the
  echo directive provided by ngx_http_echo_module. # 一段描述, 可选

  # 以下为一个或多个***data section***, 每个secotion都有section name和section value。
  # section的分隔符是---, 也是关键字.

  --- config              # config 称之为section name
  location = /t {         # seciton value， 有多行
      echo "hello, world!";
  }
  --- request
  GET /t
  --- response_body
  hello, world!
  --- error_code: 200     # section value 只能有一行
  ---                     # undefined section
  --- ttt                 # sectio name == ttt, value=""
```
其中request和config是输入section，response_body, error_code是输出section. 看来section name是有特殊含义的，不能乱起名字。

还有一种类型的setion，不是输入类型也不是输出类型，它是用来控制test blocks如何运行的，例如只运行某一个block:ONLY, 跳过某个block的运行:SKIP等。我们称之为control section

Test filter 用来调整section value的值，它的位置在name和value之间，一般形式如下:
```
--- error_code chomp  # 其中chomp就是一个filter
200
```

与下面的data section 等价
```
--- error_code: 200
```

注意于下面的section的区别
```
--- error_code
200
```

## 测试

最简单的启动方式是：prove t/xxx.t，但是标准做法是：
```
#!/usr/bin/env bash
export PATH=/usr/local/openresty/nginx/sbin:$PATH
exec prove "$@"
```
作者给出的一个原因是放置污染环境变量

### 测试脚本
```
use Test::Nginx::Socket 'no_plan';

run_tests();

__DATA__

=== TEST 1: hello, world
This is just a simple demonstration of the
echo directive provided by ngx_http_echo_module.
--- config
location = /t {
    echo "hello, world!";
}
--- request
GET /t
--- response_body
hello, world!
--- error_code: 200     # 该配置项目总是存在，默认值200
```

### 输出结果
```
main.t .. ok
All tests successful.
Files=1, Tests=2,  0 wallclock secs ( 0.01 usr  0.01 sys +  0.11 cusr  0.05 csys =  0.18 CPU)
Result: PASS
```
注意：虽然只有一个test block, 但是实际上执行了两次test，test plan以后者为准.

## 高级用法
- prove -v t/foo.t  输出详细信息
- prove -r t/
- 多个测试文件一起运行时：按照文件名称的字母顺序，其次是顺序执行（没有并行执行测试文件）
- 一个文件内block的执行顺序：shuffles，也就是乱序。 可以通过Perl指令no_shuffle()来禁止
