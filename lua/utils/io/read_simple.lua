--[[
--简单模型
--]]

--[[
-- 修改输入输出
-- 操作的默认输入文件是标准输入，默认输出文件是标准输出
io.input("/tmp/input")
data = io.read("*all")
print(data)
--]]

-- 读取一整行, 函数的默认值
--[[
data = io.read("*line")    
print(data)
]]

-- 读取一个数字
data = io.read("*number")
if data == nil then
    print("please input a number")
end
print(data)

-- 读取整个文件的内容
--[[
for line in io.lines() do
    print(line)
end
]]
