args = {...}

local sqrt = math.sqrt -- 需要将事先使用的函数、变量等收集起来
local io = io

local P = {}
_G[args[1]] = P
setfenv(1, P)   -- 使得package拥有了自己独立的空间

function age ()
    return 10
end

function money()
    return age() * 10
end

local function myprivate()
end

return P
