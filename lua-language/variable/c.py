#!/usr/bin/env python
# encoding: utf-8

#
# 我们只关心None是否拥有与Lua的Nil相似的三个功能
# None可能还有别的功能
#

# None作为未初始化的变量
num = None
print(num)

# 定义未初始化的变量
num = None
print(num)

# 删除变量
name = "hello"
name = None
print(name)

# 作为条件测试对象
val = None
if not val:
    print(val)
