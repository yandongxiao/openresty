Name
====

关于agentzh-tutorial系列文章的学习笔记。

Nginx将请求分为了11个的处理阶段，每个阶段也称为一个handler。

- 在server上下文

    1. post-read: 在server上下文，一般对请求头做统一的修改操作.
    2. server-rewrite: 调整location的匹配
    3. find-config: 匹配location的过程，不允许在该阶段进行注册

- 在location上下文

    4. rewrite: 调整uri，重新匹配location
    5. post-rewrite: 完成内部跳转工作，不允许注册
    6. pre-access: 至此，不允许进行跳转location, 不过可以发起子请求。
    7. access: 主要完成访问控制
    8. post-acess: 不允许注册
    9. try-files: 专门用于实现try_files指令，不接受注册
    10. content: 处理请求体的主要位置
    11. log: 做一些统计类工作

> Nginx还有filter的概念，主要用于处理响应头和响应请体.
