--[[
--
-- 函数本身是一个变量
-- BASH，PYTHON，GO都有这样的属性
--]]

-- 1. 函数名称本质上就是一个变量
function myfunc()
end
myfunc=10
assert(myfunc==10)

-- 2. 匿名函数
-- 定义函数的另外一种方法
myfunc = function ()
end
assert(type(myfunc) == "function")
