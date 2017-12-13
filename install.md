# 安装openresty

为了测试的完整性，我采用了源代码安装的方式安装openresty。这样就可以实验一些默认安装不支持的指令。版本：openresty-1.9.7.5

## **安装libdrizzle库**

Centos7默认没有这个安装包，需要自己下载并安装。参照 [drizzle-nginx-module](http://github.com/openresty/drizzle-nginx-module) 的方法进行安装

	wget http://agentzh.org/misc/nginx/drizzle7-2011.07.21.tar.gz
   	tar -xvf drizzle7-2011.07.21.tar.gz
   	cd drizzle7-2011.07.21
   	./configure --without-server
   	make libdrizzle-1.0
  	make install-libdrizzle-1.0

## **其它安装包**

     yum install libpqxx-devel
     yum install libxslt-devel
     yum install gd-devel gd
     yum install GeoIP-devel
     yum install gperftools-devel
     yum install libatomic_ops-devel
     yum -y install perl-devel perl-ExtUtils-Embed

## **编译**

- 注意，以下编译选项并没有把所有的扩展功能都加进来

我为了方便快速，只是把所有 `--with-xxx` 选项收集了起来，而且还剔除了那些需要指定路径的选项。以后需要测试某选项，再对下面的选项进行补充。

    ./configure --with-openssl=/opt/openssl-1.0.2g --with-debug --with-dtrace-probes --with-no-pool-patch --with-http_iconv_module --with-http_drizzle_module --with-http_postgres_module --with-lua51 --with-luajit --with-select_module --with-poll_module --with-threads --with-file-aio --with-ipv6 --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-mail --with-mail_ssl_module --with-google_perftools_module --with-cpp_test_module --with-pcre --with-pcre-jit --with-md5-asm --with-sha1-asm --with-libatomic
    gmake
    gmake install

> 注意--with-openssl=/opt/openssl-1.0.2g 指定的是openssl的源代码位置

至此，编译Openresty就告一段落。
