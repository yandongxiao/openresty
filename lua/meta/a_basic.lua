--[[
-- metatable是表展现自己魅力的地方
--]]

foo = {
    "hello"
}

-- 1. table的默认metatable为nil
assert(getmetatable(foo) == nil)

-- 2. table的metatable也可以是它本身
setmetatable(foo, foo)
assert(getmetatable(foo) == foo)
setmetatable(foo, nil)

-- 3. NOTE: metatable本身也是一个table, 而且可以是任意table
meta = {}
rt = setmetatable(foo, meta)    -- NOTE: 返回第一个参数
assert(rt == foo)
setmetatable(foo, nil)

-- 4. 可多次修改metatable的值
setmetatable(foo, foo)

-- 5. NOTE: 多个table可共享同一个metatable
bar = {
    "hello"
}
setmetatable(foo, meta)
setmetatable(bar, meta)

-- NOTICE: setmetatable函数调用并不会失败，当传递的参数不是table类型时，程序出错退出
-- NOTICE: setmetatable的两个参数都必须是table类型
-- setmetatable(bar, 3)
-- setmetatable(3, bar)
print("helloworld")
