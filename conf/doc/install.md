# 安装openresty+Test::Nginx

通过源代码安装openresty本不需要这么复杂，某天突然想把openresty源码中的测试代码(```*.t```文件)跑起来，于是才又了下面的一顿折腾。

## 安装openresty

版本：openresty-1.9.7.5

### 编译

- 注意，以下编译选项并没有把所有的扩展功能都加进来

我为了方便快速，只是把所有```--with-xxx```选项收集了起来，而且还剔除了那些需要指定路径的选项。以后需要测试某选项，再对下面的选项进行补充。

```
./configure --with-openssl=/opt/openssl-1.0.2g --with-debug --with-dtrace-probes --with-no-pool-patch --with-http_iconv_module --with-http_drizzle_module --with-http_postgres_module --with-lua51 --with-luajit  --with-select_module --with-poll_module --with-threads --with-file-aio --with-ipv6 --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-mail --with-mail_ssl_module --with-google_perftools_module --with-cpp_test_module --with-pcre --with-pcre-jit --with-md5-asm --with-sha1-asm  --with-libatomic
--with-openssl=/opt/openssl-1.0.2g
gmake
gmake install
```
> 注意
>- --with-openssl=/opt/openssl-1.0.2g 指定的是openssl的源代码位置
>- 这么长的编译指令，紧接着就是在configure的过程中报告各种找不到库的问题

### 安装libdrizzle库

Centos7默认没有这个安装包，需要自己下载并安装。参照[drizzle-nginx-module](http://github.com/openresty/drizzle-nginx-module)的方法进行安装

```
  wget http://agentzh.org/misc/nginx/drizzle7-2011.07.21.tar.gz
  tar -xvf drizzle7-2011.07.21.tar.gz
  cd drizzle7-2011.07.21
  ./configure --without-server
  make libdrizzle-1.0
  make install-libdrizzle-1.0
```

### 其它安装包

```
  yum install libpqxx-devel
  yum install libxslt-devel
  yum install gd-devel gd
  yum install GeoIP-devel
  yum install gperftools-devel
  yum install libatomic_ops-devel
```

至此，编译Openresty就告一段落。

## 安装Test::Nginx

参考如下[链接](http://justcodeit.info/blog/how-to-test-openresty.html)

## 搭建服务

搭建服务，包括mysql, memcached, redis等，Nginx的扩展模块会与它们进行通信，以测试模块。

### mysql

- 安装
```
yum install mysql mysql-server mysql-devel
yum install mariadb-server mariadb
```

- 启动服务
```
systemctl restart mariadb.service
```

- 客户端连接
```
# root密码默认为空
mysql -u root -p
```

- 添加数据
  1. 创建用户：名称和密码都是ngx_test
  2. 为用户设置合理的权限
  3. 创建数据库：ngx_test

### memcached

- 安装
```
yum install memcached.x86_64
```
- 启动
```
systemctl start memcached.service
```
- 客户端连接

```
telnet 127.0.0.1 11211
接着输入以下指令
set dsa 0 0 5
12345
输出：
STORED
```

## 测试

接着可以测试```*.t文件```，具体如何测试，请参考[这里](test-nginx.md)。 附上自己的测试脚本，它将测试通过和未通过的t文件，分开放置。

```
#!/usr/bin/env bash

export PATH=/usr/local/openresty-1.9.7.5/nginx/sbin:$PATH
for i in $@; do
    output=`prove "$i"`
    echo $output | grep "All tests successful" &>/dev/null
    if [[ $? -eq 0 ]]; then
        mv $i tested
    else
        mv $i totest
    fi
done
```