--[[
-- metatable是表展现自己魅力的地方
-- NOTICE: setmetatable函数调用并不会失败，当传递的参数不是table类型时，程序出错退出
-- 一定程度也表明了setmetatable的第二个参数只要是table即可
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

-- 3. metatable本身也是一个table, 而且可以是任意table
meta = {}
rt = setmetatable(foo, meta)
assert(rt == foo)   -- 返回第一个参数
setmetatable(foo, nil)

-- 4. 可多次修改metatable的值
setmetatable(foo, foo)

-- 5. 多个table可共享同一个metatable
bar = {
    "hello"
}
setmetatable(foo, meta)
setmetatable(bar, meta)
