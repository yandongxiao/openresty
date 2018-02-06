#! /usr/local/bin/lua

-- 参见emmy
args = {...}
local P = {}
_G[args[1]] = P

-- 1. 要求所有的变量、函数都要声明为local的；开发者有可能漏掉
local function age ()
    return 10
end

local function money()
    return age() * 10
end

local function myprivate()  -- private
end

P.age = age
P.money = money

return P
