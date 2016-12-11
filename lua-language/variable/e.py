#!/usr/bin/env python
# encoding: utf-8

import types

#[[
#
# python对应的变量类型有：
#   None
#   boolean
#   number
#   string
#   nil
#   table
#   userdata
#   functioned
#]]

# 1. None
data = None
assert(type(data) is types.NoneType)

# 2. boolean
f = False   # 注意大小写
t = True
assert(type(t) is types.BooleanType)

# 3. number
# 整型和浮点型分为了两种类型
a = 1
b = -2
c = 1.1
assert(type(a) is types.IntType)
assert(type(b) is types.IntType)
assert(type(c) is types.FloatType)


# 4. string
x = "x\n"   # 转义字符有效
assert(type(x)==types.StringType)
print(x)

y = 'y\n'   # 转义字符有效
assert(type(y)==types.StringType)
print(y)

# 注释无效
# 转义字符无效
# 下面的换行符有效
z = """
#hello
world\n
"""
# 上面的换行符有效
assert(type(z)==types.StringType)
print(z)

# 5. table
t = {}
t["name"]  = "hello"
t["value"] = "world"
assert(type(t) == types.DictType)
assert(t["name"] == "hello")
assert(t["value"] == "world")

# 6. function
def df (num1, num2):
    return num1+num2
f = df
assert(type(f) == types.FunctionType)
assert(f(1,2) == 3)

