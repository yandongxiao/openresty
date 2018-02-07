# 语法

1. 逻辑操作符(and, or)返回的并非是true或false，而是逻辑运算过程中最后一个对象.
2. table, function, userdata是引用比较，其它类型是值比较
3. 遍历的几种方式：

    ```
    for i=0, 10, 1 do ... end
    for i,v in ipairs(t) do ... end
    for k, v in pairs(t) do ... end
    repeat ... until
    while ... do ... end
    next(tab, key)函数: 相当于迭代器，不但返回值，还返回下一个要迭代的key.
    ```
>
- lua采用闭包来实现next函数

4. lua不支持continue关键字, do ... end 组成了一个block
5. 非nil 和 false的值都是true
