#! /usr/local/bin/lua
local function age ()
    return 10
end

local function money()
    return age() * 10
end

local function myprivate()
end

local cherry = {
    age = age,
    money = money
}

return cherry
