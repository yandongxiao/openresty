#!/usr/bin/env python
# encoding: utf-8

#
# python 定义一个局部变量时并不需要关键字local，它的定义规则如下：
#   如果变量第一次出现在等号右边，那么优先使用局部变量，然后使用全局变量
#   如果变量第一次出现子等号左边，那么认为该语句为定义一个局部变量
#
# 注意：Python不允许嵌套定义局部变量.
#   我想这是因为定义局部变量时没有指定什么关键字，在if中的num=3最好应该是理解为赋值操作
#

num = 1

def fn():
    # 如果要禁止定义局部变量， 则在 global 关键字声明要使用num全局变量
    num = 2
    if True:
        num = 3
        print(num)  # 3
    print(num)  # 3

fn()
print(num)  # 1
