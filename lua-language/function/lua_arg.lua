-- arg是一个特殊的全局变量，类型为table
-- 以下方式获取了传递给LUA的参数，注意paris还可以返回arg[-1]=lua, arg[0]=filename
for i, val in ipairs(arg) do
    print(i, val)
end

-- 返回参数的个数，注意不包括LUA和文件名称
print(#arg)

-- 获取LUA文件的名称
print(arg[0])   --根据用户的输入可能还会有-1, -2, -3

-- input: lua -e "print(1)" lua_arg.lua a s d)"
for key, val in pairs(arg) do
    print(key, val)
end
--[[
---1    print(1)
---3    lua
---2    -e
-- 0 lua_arg.lua
--]]
