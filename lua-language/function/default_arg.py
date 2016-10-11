#!/usr/bin/env python
# encoding: utf-8

# python的默认形参功能丰富

def add (num1=0, num2=0):
    return num1 + num2

print(add(1, 2))
print(add(1))
print(add(num1=1))

