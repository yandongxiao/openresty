# Nginx缓存服务器

配置一台Nginx缓存服务器，需要解决以下问题：

1. 缓存文件定位
2. 缓存内容
3. 缓存文件过期
4. 缓存文件清理

## 缓存文件定位

1. client发送请求--&gt; 定位到location --&gt; 定位到proxy\_pass
2. 在代理服务器转发请求之前，会通过**proxy\_cache\_key**指令，组装出来一个CacheKey
3. 对该CacheKey进行MD5值的计算。如何将MD5值映射为代理服务器上的一个文件呢？
4. 这就涉及到了两个重要的指令proxy\_cache\_path和proxy\_cache。

### proxy\_cache\_key

它的作用我们在缓存定位文件中已经讲过了，这里只说明它的默认值

```
proxy_cache_key $scheme$proxy_host$uri$is_args$args;
```

proxy\_host是后端服务器。

### proxy\_cache\_path

proxy\_cache\_path path \[levels=levels\] \[use\_temp\_path=on\|off\] keys\_zone=name:size\[inactive=time\] \[max\_size=size\] \[loader\_files=number\] \[loader\_sleep=time\] \[loader\_threshold=time\] \[purger=on\|off\] \[purger\_files=number\] \[purger\_sleep=time\] \[purger\_threshold=time\];

path : 指定缓存文件存放的位置

levels：指定了MD5值的切割方式，levels=1:2表示将MD5值的第一个字符作为第一级目录，后面两个字符作为二级目录，剩余字符串作为文件名称。之所以没有将MD5值直接作为文件名称，是因为文件系统可能不允许一个目录下存放过多的文件，导致性能地下。

use\_temp\_path: Nginx先是将文件下载到"临时目录"下，然后rename到"缓存目录"。use\_temp\_path如果为on，那么Nginx将会使用Proxy\_temp\_path指定的目录作为临时目录；如果为off，那么Nginx将把临时文件直接创建在“缓存目录”。

keys\_zone: 为了避免每个请求到来，都要执行MD5计算，同时查看文件系统中该文件是否存在。Nginx将缓存文件的元信息保存在内存当中。name就是这块内存的名称，size是这块内存的大小。注意1M的内存就可以存放8000个KEY。

inactive：默认值是10minutes，在10分钟内如果没有被访问，就删除该条目。**那么问题来了，会删除缓存文件吗**？会

max\_size：指定缓存文件占用的文件系统的总大小，进程cache manager会监控它的大小，一旦超过，那么它就会删除最少被使用的文件。

loader\_..：当Nginx比如重启时，缓存文件元信息的重建工作就交由了cache loader来完成，个人感觉保持默认即可。注意proxy\_cache\_path指定的目录是存放的“MD5值”，所以cache loader的重建工作不是由该目录结构来构造的。

### proxy\_cache

该指令的值就是来自于proxy\_cache\_path的keys\_zone选项的值。

## 缓存内容

后端服务器返回的内容有对有错，Nginx默认情况下，不对任何内容进行缓存。

Nginx根据后端服务器的响应码，同时借助proxy\_cache\_valid指令，完成内容的缓存。例如：proxy\_cache\_valid 200 302 10m; 这里的时间值和proxy\_cache\_path的时间值得区别。proxy\_cache\_path指定的时间值到达以后，被缓存的文件就会被删除；proxy\_cahce\_valid指定的缓存时间过了以后，缓存应该只是失效。 **经过验证**。

失效的但是没有被删除的缓存文件，，当client再次访问时，Nginx会从后端服务器再次取出该数据，并将是小的缓存文件替换掉。

```
proxy_cache_valid any      1m;
```

```
proxy_cache_valid 5m;    #200， 301， 302
```

默认不缓存的内容

### proxy\_cache\_methods

添加缓存文件的限制条件，只有当请求的方法在该指令的方位内，才缓存。

### **proxy\_no\_cache**

添加缓存文件的限制条件，当response的某个header值或者arg的值不为空，那么就不缓存。

## proxy\_cache\_min\_uses

添加缓存文件的限制条件，当请求该URI达到一定次数以后，才会被缓存。

## proxy\_cache\_convert\_head

当缓存服务器收到HEAD请求时，缓存服务器向后端发送GET请求。以此来缓存数据。

如果为off，那么在cache key中就要包含`$request_method`.

## proxy\_cache\_lock

当并发的请求URI相同时，而且当前cache server又不存在该文件时，lock行为只允许一个请求被转发到后端。

其它请求等待直到proxy\_cache\_lock\_timeout或者cache server中存在该缓存文件时。

## proxy\_cache\_lock\_age

当在proxy\_cache\_lock\_age指定的时间范围内，cache server没有从后端服务器中成功取得文件，则从其它请求中选择一个，转发到后端。

## proxy\_cache\_lock\_timeout

当在proxy\_cache\_lock\_timeout指定的时间范围内，cache server没有从后端服务器中成功取得文件，该请求将会被转发到后端服务器。

proxy\_cache\_lock\_age和proxy\_cache\_lock\_timeout的区别：proxy\_cache\_lock\_age是站在Nginx的角度，每隔一段时间，转发一个request到后端；proxy\_cache\_lock\_timeout则是站在每一个request的角度，即每个请求最多等待N秒钟，如果缓存文件还没有生成，则请求直接转发给后端。这种情况下，数据不会被缓存。

## proxy\_cache\_purge

相当于给client暴露了可以删除缓存文件和cache key的方法。而且还可以一次性删除一批文件。

## proxy\_cache\_revalidate

这样的话，过期的文件还可以重新利用起来。

不过实验的时候发现，每次后端还是返回了200.

## proxy\_cache\_use\_stale

http:\/\/ju.outofmemory.cn\/entry\/1094

## 

