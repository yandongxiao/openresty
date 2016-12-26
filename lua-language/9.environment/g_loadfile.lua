--[[
-- 1. loadfile 的执行过程是，加载并编译LUA模块，抽象成函数，返回函数对象。
-- 2. NOTICE：函数之间是可以进行嵌套的，无论是具名函数还是匿名函数。
-- 与load区别：
--      1. 文件不存在时返回nil
--      2. 多次调用f()时，对LUA代码只进行了一次编译
--]]
f = loadfile("p.lua")
assert(type(f) == "function")
nt = f()    -- 如果f在某个函数内调用，那么嵌套的函数会就地展开，外部是无法访问的
nt.add()
nt.add()
assert(nt.val() == 3)

-- 1. 失败时返回nil + error msg
f, msg = loadfile("pp.lua")
assert(f == nil)
print(msg)

local i = 0
-- loadstring 总是在全局环境中编译它的字符串
f = loadstring("i = i + 1")     -- 使用的是全局变量i, 所以被调用时出错。
g = function () i = i + 1 end   -- 使用的是局部变量i
f()
g()
