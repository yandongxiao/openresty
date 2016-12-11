--[[
-- 定义和使用变量的方法比较:
-- bash:   $name
--    define: name=test,  重点是等号两边没有空格
--    use: echo $name，重点是$符号
--
-- pyhton 和 lua 是一样的
--]]

name = "test"
assert(name=="test")
