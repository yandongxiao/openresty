#! /usr/local/bin/lua
-- NOTE: 模块需要确保自己没有定义全局变量

bob = require "bob"
print(bob.age())
print(bob.money())

-- cherry = require "cherry"
-- print(cherry.age())
-- print(cherry.money())

-- require "david"
-- print(david.age())
-- print(david.money())
-- print(emmy.myprivate())

-- require "emmy"
-- print(emmy.age())
-- print(emmy.money())
-- print(emmy.myprivate())

