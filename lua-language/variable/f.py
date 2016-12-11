#!/usr/bin/env python
# encoding: utf-8

# python
# python 也分为全局变量和局部变量
# NOTICE:
#   1. 根据变量位置自动分析变量是局部变量还是全局变量；
#   2. 由于闭包的存在，函数调用完毕后，局部变量仍可继续存在；

# 1.全局变量是动态生成
def myfunc1():
    global gvar
    gvar = 10
# assert(gvar == None)  # gvar is not defined
myfunc1()
assert(gvar == 10)

# 2.在函数内部定义全局变量和局部变量
del gvar
def myfunc2():
    global gvar
    gvar = 20
    lvar = 20
    assert(gvar==20)
    assert(lvar==20)
myfunc2()
assert(gvar==20)
#assert(lvar==20)    # lvar is not defined

# 3.局部变量和全局变量名称相同
var = 10
def myfunc3():
    var = 20
    assert(var==20)
myfunc3()
assert(var==10)
del var

# 4.局部变量可以定义在if内
# python 并没有local这样的关键字，用于声明一个本地变量
# 所以在if内部aa = 10，其实是一个赋值操作，并没有创建新的变量
