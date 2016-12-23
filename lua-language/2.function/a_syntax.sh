#!/bin/bash

#
# BASH
#   1. function的声明那一行没有形参，直接在函数内以$1 和 $2的形式访问形参
#   2. return不是返回值，而是表明该函数是否执行成功了。
#   3. function通过向标准输出写内容来传递给调用者
#   4. 调用的方法是 add 1 2

function add()
{
    val=$(echo $1 + $2 | bc)
    echo $val
}

sum=$(add 1 2)
echo $sum
