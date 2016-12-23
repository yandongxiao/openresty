#!/usr/bin/env python
# encoding: utf-8

# python的默认形参功能丰富

def add (num1=0, num2=0):
    return num1 + num2

assert(add(1, 2) == 3)
assert(add(1) == 1)
assert(add(num2=1) == 1)    # 支持具名赋值
