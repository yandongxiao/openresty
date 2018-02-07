#! /usr/local/bin/lua
args = {...}

-- 只有一个元素: 1:emmy
-- for k, v in pairs(args) do
--     print(k, v)
-- end

local P = {}
P.pairs = _G.pairs
P.print = _G.print
_G[args[1]] = P -- args[1] == emmy. 所以向全局命令空间添加元素emmy

-- 使得package拥有了自己独立的空间
-- NOTE: setfenv重新设置自己的全局变量表
setfenv(1, P)
-- _G, assert, print这些函数统统不可用了，因为P此时为空

for k, v in pairs(P) do
    print(k, v)
end

function age ()
    return 10
end

function money()
    return age() * 10
end

local function myprivate()
end

return P
