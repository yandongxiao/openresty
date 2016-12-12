#!/usr/bin/env python
# encoding: utf-8

# 1. 函数名称本质上就是一个变量
def myfunc():
    pass
myfunc = 10
assert(myfunc==10)

# python 通过lambda支持匿名函数
f = lambda x: x * x
assert(f(2) == 4)
