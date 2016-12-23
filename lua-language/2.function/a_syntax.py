#!/usr/bin/env python
# encoding: utf-8

# 主流的函数模型

def myfunc(num1=1, num2=2):
    return

# 1. 实参和形参的个数必须相等
# 但python支持默认形参，所以在语法上实参和形参不一定相等
myfunc(10)
myfunc(10, 20)
myfunc(num2=20)



