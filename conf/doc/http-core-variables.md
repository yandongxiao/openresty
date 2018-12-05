# Request

1. remote\_user
2. remote\_addr
3. remote\_port
4. server\_name
5. server\_addr
6. server\_port
7. scheme
8. server\_protocol
9. request\_length
10. request
11. request\_method
12. request\_uri
13. document\_uri
14. document\_root
15. realpath\_root
16. uri
17. is\_args
18. args
19. query\_string
20. arg\_name
21. http\_name
22. content-length
23. content-type
24. host
25. **request\_body**
26. **request\_body\_file**

# Response

1. nginx\_version
2. status
3. time\_local
4. request\_filename。文件不一定要存在
5. request\_time
6. bytes\_sent
7. body\_bytes\_sent
8. limie\_rate
9. pid
10. connection
11. connection\_requests

# 注意

1. bytes\_sent 一个HTTP包的大小
2. body\_bytes\_sent 一个HTTP包的Body的大小。
3. 注意以上两个字段是不能直接echo给客户端的，它的值将会是0；在Log阶段该值才会有意义
4. connection Nginx会为每一个connection分配一个递增的ID号（从零开始），注意它并非作为Nginx并发连接数的值，也不是Nginx服务client的总次数（keep-alive使得一个连接可以发送多个请求）。
5. connection\_requests 统计一个connection总共发送了多少次的请求。

