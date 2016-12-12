-- [[
-- LUA不存在main函数，那么LUA如何接收用户传递的参数？
-- arg是一个特殊的全局变量，类型为table
--   arg[-1]=lua
--   arg[0]=filename
--   arg[i] 用户传递的第i个参数，注意LUA数组的下标是从1开始的
--   #arg 返回参数的个数
-- ]]

for i, val in ipairs(arg) do
    print(i, val)
end

-- 返回参数的个数，注意不包括LUA和文件名称
print(#arg)

-- 获取LUA文件的名称
print(arg[0])   --根据用户的输入可能还会有-1, -2, -3

for key, val in pairs(arg) do
    print(key, val)
end
