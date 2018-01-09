--[[
-- 1. loadfile 的执行过程是，加载并编译LUA模块，抽象成***函数***，返回函数对象。
-- 与load区别：
--      1. 文件不存在时返回nil
--      2. 多次调用f()时，返回独立的对象，但是对LUA代码只进行了一次编译
--]]
local name="jack"   -- 如果添加了local，p.lua就看不到该变量了，此时输出为nil
f = loadfile("p.lua")
f2 = loadfile("p.lua")
assert(f ~= f2)
print("hello")      -- NOTE：p.lua文件没有执行，它们的print在hello之后

assert(type(f) == "function")
nt = f()    -- 如果f在某个函数内调用，那么嵌套的函数会就地展开，外部是无法访问的
nt.add()
nt.add()
assert(nt.val() == 3)

-- NOTE: 又生成了一个全新的table
nt2 = f()
assert(nt ~= nt2)

-- 1. 失败时返回nil + error msg
f, msg = loadfile("pp.lua")
assert(f == nil)
print(msg)

local i = 0     -- local的作用是只在该文件内可见
-- loadstring 总是在全局环境中编译它的字符串
-- f = loadstring("i = i + 1")     -- 使用的是全局变量i, 所以被调用时出错。
-- f()

g = function () i = i + 1 end   -- 使用的是局部变量i
g()
