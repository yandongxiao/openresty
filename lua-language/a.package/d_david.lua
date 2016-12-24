-- _REQUIREDNAME 不支持
args = {...}
local P = {}
-- 假如两个pckage的名称一样，也可以通过简单的修改文件名称，来完成
-- import操作
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

P = {
    age = age,
    money = money
}

return P
