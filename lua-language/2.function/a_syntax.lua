--[[
--
-- 函数定义：由关键字，函数名称，参数值和block分隔符组成
-- 函数定义、函数调用、函数返回都采用主流的函数模型
--
--]]

function myfunc(num1, num2)
    return
end

-- 1. 实参和形参的个数不一定相等
-- 跟LUA支持的多重赋值有关系
myfunc(1,2,3,4)
myfunc()

-- 2. LUA特殊方式调用
-- 一个函数若只有一个参数，并且此参数是常量的字符串或者表，那么圆括号便可以省略掉
-- NOTICE: 必须是常量
-- string
print "Hello World"
print [[a multi-line
          message]]

-- table
function myfunc(t)
    print(t.name)
end

myfunc {
    name = "dxyan"
}

-- 3. 利用unpack函数传递参数
-- 参见：i_variable_agrs.lua
