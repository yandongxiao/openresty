--[[
-- LUA不支持具名函数调用, 但是用户可以借助unpack函数，向用户传递一个数组
-- NOTICE: 是数组，传递table是没有用的
-- NOTICE: 如果传递的参数过多，还是应该采用table的方式
--]]

function myfunc(name, age)
    assert(type(name) == "string")
    assert(type(age) == "number")
end

-- 正确的方法
myfunc("terry", 10)
myfunc(unpack({        -- 这是一种方法，限制在于只能传递unpack数组，而非关联性数组
    "lilei",
    10
}))

-- 错误的方法
-- print(name="lilei", age=10)      -- 不支持，语法上有错误
print {     -- name接受了table， age是nil
    name="lilei",
    age=10
}
