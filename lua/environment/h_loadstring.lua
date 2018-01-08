--[[
-- loadstring中指定的lua代码是不允许使用当前文件中的local变量的
-- 另一个在另一个文件中，可见返回只能是全局变量
--]]

print "enter your expression:"
l = io.read()
func = loadstring("return l")   -- 这里的l就是上一行定义的全局变量
print("the value of your expression is " .. func())
