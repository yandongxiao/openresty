--[[
-- table 是对象也是类
--]]
Account = {
    balance = 0
}

function Account:new (o)
    setmetatable(o, self)   -- self表示Account表
    self.__index = self     -- Account作为metatable
    return o
end

-- 冒号的方式就是一个语法糖
function Account:withdraw (v)           -- 定义对象的快捷方式
     self.balance = self.balance - v    -- 避免使用全局变量
end

SpecialAccount = Account:new{}  -- 这里语法上是创建了class Account的实例

function SpecialAccount:withdraw (v)    -- 重写父类的方法
    self.balance = self.balance - 2*v
end


s = SpecialAccount:new{limit=1000.00}   -- 结合下面的语法，那么SpecialAccount升级为子类，此处是创建子类的对象
s:withdraw(100.00)   -- 实际上是调用了父类的方法
assert(s.balance == -200)
