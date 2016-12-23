--[[
-- __newindex 和 __index metamethod确实给LUA带来了很大的魔力，但是也掩盖了
-- table本身数据的真实情况
-- rawget：LUA只会去table中尝试获取数据，如果不存在，立即返回nil.
-- rawset: LUA直接向table中设置key,val)对。
-- NOTICE: rawget和rawset直接绕过了__index和__newindex来带的副作用
--]]

foo = {}
foo.meta = {}

function foo.new(t)
    return setmetatable(t, foo.meta)
end

-- 注意函数形参个数
-- NOTICE: t 是指table表，不是metatable表
foo.meta.__newindex = function(t, key, value)
    if (key == "name") then
        -- rawset 在此处还是必须的
        rawset(t, key, "terry") -- NOTICE: 否则程序陷入死循环
        return
    end
    rawset(t, key, value)
end

t1 = foo.new{}

-- 被劫持篡改
t1.name = "alice"
assert(t1.name == "terry")

-- 如何防止被劫持
rawset(foo, "name", "bob")
assert(foo.name == "bob")
