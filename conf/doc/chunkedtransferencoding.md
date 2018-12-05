# chunked_transfer_encoding

```
http {

 # 根据文件的后缀名为content-type设置相应的值.types {text/html html htm shtml; ...}
 include mime.types;
 default_type application/octet-stream;

 # the default value is off
 # 客户端应该包含Accept-Encoding:gzip头, content-type的值属于gzip_type指令指定的值
 # 这是触发对response body进行gzip压缩行为
 gzip on;
 gzip_types text/html text/plain

 # server端对文件进行压缩，然后传输给客户端，curl命令此时得到一个压缩文件
 # 注意实际上是边压缩边传输，即server不会立刻知道压缩后文件的大小
 # 那么Conetnt-Length的值如何确定？http 1.1 中引入了新的头Transfer-Encoding
 #
 # Transfer-Encoding
 # 定义了一种新型的数据传输方法，适用于一开始不知大文件大小的情况下

 #
 # curl -I 返回的响应头中不包括Transfer-Encoding: chunked
 # 但实际传输这个文件的时候，server是返回了这个头部的
 chunked_transfer_encoding on;       # 默认值也是on


 server {

 listen 80;

 location / {

 proxy_pass http://localhost:8080;

 }

 }

 server {

 listen 8080;

 location / {

 }

 }

}
```

