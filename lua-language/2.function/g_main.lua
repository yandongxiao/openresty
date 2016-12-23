-- [[
-- LUA不存在main函数，那么LUA如何接收用户传递的参数？
-- arg是一个特殊的全局变量，类型为table
--   arg[-1]=lua
--   arg[0]=filename
--   arg[i] 用户传递的第i个参数，注意LUA数组的下标是从1开始的
--   #arg 返回参数的个数
-- ]]

-- run: lua g_main.lua 1 2 3
assert(arg[-1] == "lua")
assert(arg[0] == "g_main.lua")
assert(arg[1] == "1")
assert(arg[2] == "2")
assert(arg[3] == "3")
assert(#arg == 3)

-- 只会遍历数组部分
for i, val in ipairs(arg) do
    print(i, val)
end

-- 遍历表中所有的key
for key, val in pairs(arg) do
    print(key, val)
end
