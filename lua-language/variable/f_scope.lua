--[[
--
--  变量分为全局变量和局部变量，默认是全局变量，通过关键字local设置局部变量。
--
--  NOTICE:
--  1. 通过关键字来判断变量的作用范围，这也是bash的用法。 但现在高级语言都摒弃了这种做法，转而变量位置的上下文，来自动设置变量的作用范围.
--  2. 不像C语言，在程序刚开始运行时，就为所有全局变量分配内存；lua、python、bash都是变运行边定义变量的，包括全局变量。
--  3. 在最外层使用local关键字，该变量也可认为是全局变量。
--  4. 在函数内部定义变量，未使用关键字local，则定义的是全局变量。
--
--  lua 的函数仅仅是为了代码的复用而存放在一块，解释器在执行时将函数调用展开。
--  函数可以重定义更加证明了我们的猜测
--]]

-- 1. 全局变量是动态生成
function myfunc()
    gvar = 10
end
assert(gvar == nil)

-- 2. 在函数内部定义全局变量和局部变量
gvar = nil
function myfunc()   -- 注意函数可以重定义
    gvar = 10
    local lvar = 10
end
myfunc()
assert(gvar == 10)
assert(lvar == nil)

-- 3.局部变量和全局变量名称相同
var = 10
function myfunc()
    local var = 20
    assert(var==20)
end
assert(var==10)

-- 4. 变量可以被嵌套定义
-- NOTICE: Python和BASH都不支持嵌套定义变量
num = 1
function fn()
    local num = 2
    if true then
        local num = 3
        assert(num==3)
    end
    assert(num==2)
end
fn()
assert(num==1)
