--[[
-- 当key值不在table中时，默认行为是在table中创建该(key, value)对。
-- __newindex metamethod 可以截获该行为，即如果被设置，LUA转而去执行__newindex函数。
-- NOTICE: __newindex 如果被设置，行为全权由它来负责
--]]

Window = {}
Window.mt = {}

-- 初始状态并没有任何值
Window.prototype = {
}

-- 为表设置meta table
-- 此时，当索引的元素不存在时就会执行Window.mt.__index
function Window.new (o)
    return setmetatable(o, Window.mt)
end

-- __newindex的值可以是函数，也可以是table
-- 如果是table的话，行为编程在该table中创建或修改(key, val)对
Window.mt.__newindex = Window.prototype
Window.mt.__index = Window.prototype

-- 下面的示例演示了如何更新父表
-- 1. 初始状态
t1 = Window.new {
    x = 100
}
assert(t1.x == 100)
assert(t1.y == nil)
assert(t1.width  == nil)
assert(t1.height == nil)

-- 2. 更新Window表
t1.y = 0
t1.width = 100
t1.height =100

-- 3. 创建新的表
t2 = Window.new{}
assert(t2.x == nil)     -- NOTICE： nil
assert(t2.y == 0)
assert(t2.width  == 100)
assert(t2.height == 100)






