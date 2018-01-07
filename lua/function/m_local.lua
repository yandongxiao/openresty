--[[
-- 是用local关键字，定义局部变量
-- 函数定义、函数调用、函数返回都采用主流的函数模型
--]]

function myfunc(num1, num2)
    local function foo()
        return "helloworld"
    end
    return foo
end

bar = myfunc()
assert(bar() == "helloworld")
assert(foo == nil)
