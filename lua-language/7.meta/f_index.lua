--[[
-- __index metamethod 在继承中的使用非常常见
--]]

Window = {}
Window.mt = {}

Window.prototype = {
    x=0,
    y=0,
    width=100,
    height=100
}

-- 为表设置meta table
-- 此时，当索引的元素不存在时就会执行Window.mt.__index
function Window.new (o)
    return setmetatable(o, Window.mt)
end

Window.mt.__index = function (table, key)
    return Window.prototype[key]
end

-- NOTICE: 通过__index metamethod，Window.new创建的表都主动继承
-- 了x，y，width，height的默认值
t1 = Window.new {
    x = 100
}
assert(t1.x == 100)
assert(t1.y == 0)
assert(t1.width  == 100)
assert(t1.height == 100)
