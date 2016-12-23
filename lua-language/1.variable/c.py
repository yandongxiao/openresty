#!/usr/bin/env python
# encoding: utf-8

# python
# python 的变量存在三种状态：未定义的，未初始化的，已赋值
# 未定义的：直接使用未定义的变量会导致进程出错
# 未初始化的：None
# 已赋值: 不解释

# 1. 定义未初始化的变量
num = None  # 直接引用未定义的变量会导致程序报错
assert(num==None)

# 2. 删除变量
num = 10
assert(num==10)
del num
# 使用删除的变量相当于使用未定义的变量
# assert(num==None)

# 3. 多重赋值
name = "json"
age = 10
# python要求多重赋值时，等号两边的KV个数相等
# name, age = "xml"

# 4. 作为条件测试对象
val = None
if not val:
    assert(val==None)
else:
    assert(1==2)
