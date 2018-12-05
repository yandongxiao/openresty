# Test::Nginx 编程

## Test::Nginx 的工作流程 
Test::Nginx的基本组成单位是test block, 在test block当中包括nginx.conf配置（例如config section），发送的请求(例如request section)，响应的验证（例如response section）。所以Test::Nginx的执行流程如下：
1. 根据config，http_config等配置项动态生成nginx.conf文件。改配置文件在t/serverroot/conf/nginx.conf；
2. Test::Nginx启动Nginx，所以需要确保PATH路径包含nginx
3. 根据request，pipelined_requests等请求section，向Nginx发送请求
4. Test::Nginx将输出section和Nginx会返回的response进行比较，确认该case是否能通过；
5. 打印Test summary。
本届剩余的内容就是来学习，Test::Nginx为我们提供的这些section。
> 注意：一定要将xxx.t文件放在t目录下面，因为此时执行prove t/xxx.t命令后，会产生conf/nginx, logs等关键信息。 每次执行新的test block时，conf/nginx,logs等内容会重新生成**


## 与配置文件相关
|section | configuration |
|--------|---------------|
| main_config | top-level scope|
| http_config | http{}   |
| config | server{}      |

从上面的配置来看，只能配置一个http和一个server，但是如果要配置多个location, 也可以在config section下面完成。

### 与请求相关
|section | configuration |
|--------|---------------|
|request | 请求首部(默认使用HTTP1.1协议) |
| more_headers | 指定请求头 |
| pipelined_requests | 以piplined的方式发送请求，于eval搭配使用|

### 与响应有关
|section | configuration |
|--------|---------------|
| response_body | 指定期望的响应体,全匹配 |
| response_body_like| 指定期望的响应体，正则匹配（Perl正则）|
| response_headers |  指定期望的响应头，可以指定多个 |
| error_log | error.log中出现指定的字符串，测试通过 |
| no_error_log | error.log 中不出现指定的字符串，测试通过 |
| grep_error_log | grep语法进行比较，与grep_error_log_out配合使用 |
| grep_no_error_log | grep语法进行比较 |
| wait | 延迟读error.log的时间，以秒为单位 |

#### response section
response_body会与http response body做完全字符串匹配，如果匹配失败，Test::Nginx会在Test summary中以非常友好的方式显示它们的差异行。用户还可以调用Perl的两个函数来改变此行为：
1. no_long_string() 以diff的方式显示它们的差异性
2. no_diff() 完全输出expect string和actual string的内容
注意这两个函数的调用必须放置在run_test函数之前

如果使用多行section格式，请记住Test:Nginx会在section value的末尾添加一个换行符，如果不需要此换行符，请使用chomp filter.

#### response_body_like section
对http response body进行正则匹配，有两种方式：section value直接就是正则表达式，或则利用eval filter书写Perl正则。后者会更具有表达力。

#### error_log
```
-- error_log
hello world
```
1. 在error.log中查找关键字***hello world***，**注意不包括换行**。
2. 可以指定多行value，Test::Nginx将拿每一行的值在error.log中进行查找。**注意这两行值在error.log中没有先后顺序**。
3. 通过eval filter 可以指定正则表达式

#### grep_error_log

error_log存在两个缺陷：
1. 无法指定section value出现的次数；
2. 无法指定section value的每一行在error.log中的先后顺序。于是有了grep_error_log, 它于grep_error_log_output配合起来使用。

grep_error_log的工作流程如下：首先检查error.log的内容，将匹配的字符串收集到一起，注意只是收集匹配的字符串（非字符串所在的行），其次每次匹配的字符串以换行符进行分割；将收集的字符串于grep_error_log_output的section value进行全匹配。

#### wait

nginx响应请求以后会立即写日志，但是可能会出现Test::Nginx 过早的去检查文件内容，以至于测试case失败。解决办法就是添加wait control section。

### Testing Erroneous Cases
本节介绍如何利用Test::Nginx来模拟异常情况，例如Nginx启动失败，发送畸形的请求或响应，模拟各种timeout等情况。

|section | configuration |
|--------|---------------|
|must_die|期望Nginx会启动失败|
|ignore_response|期望Test::Nginx放弃sanity checks|
|raw_request|HTTP请求的每一个字节都完全由自己控制，可以模拟恶意客户端|
|timeout + abort| 模拟客户端异常终止的情况|

1. 虽然Test::Nginx启动失败时会向error.log中记录日志，但是单凭error_log section是无法通过测试的。因为Test::Nginx认为Nginx启动成功是正常行为，必须额外添加must_dir section。
2. 默认情况下，Test::Nginx会对response做 sanity checks检查，如果是非法的响应消息，Test::Nginx会将它丢弃。那么对输出的检查就无法执行。需要通过ignore_response section，让Test::Nginx放弃sanity checks。
3. **注意：Test::Nginx的客户端永远不会主动关闭连接，直到timeout。Test::Nginx会报告错误，这有可能是Nginx没有释放socket导致的。所以可能会有资源耗尽的错误**


## 6. 模拟连接、读、写超时

模拟连接超时：可以利用iptable将SYN包丢弃掉，模拟连接超时。春哥的<agentzh.org,12345>也提供了连接超时的模拟。

模拟读超时：可以利用nginx-stream-nodule来模拟一个TCP server，而该server只是sleep即可。

模拟写超时：最难模拟的一个，理论上将需要将nginx core buffer, sender socket buffer, receiver socket buffer 都填满字节，同时接收端的上层应用不接收数据的情况下，才会出现写超时。春哥提供了一个[mockeagain](https://github.com/openresty/mockeagain)工具，该工具通过截获写请求，来达到欺骗上层应用的目的。
