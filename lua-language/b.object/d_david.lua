Account = {
    balance = 0
}

-- metatable 是实现class系统的重要基础
function Account:new (o)
    setmetatable(o, self)   -- self表示Account表
    self.__index = self     -- Account作为metatable
    return o
end

-- 冒号的方式就是一个语法糖
function Account:withdraw (v)           -- 定义对象的快捷方式
     self.balance = self.balance - v    -- 避免使用全局变量
end

account1 = Account:new{
    balance = 3000      -- 必须初始化
}
account1:withdraw(1000)
assert(account1.balance == 2000)

account2 = Account:new{
    balance = 300      -- 必须初始化
}
account2:withdraw(100)
assert(account2.balance == 200)

acc1 = Account:new{}
acc1:withdraw(100)
-- self.balance = self.balance - v
-- 第二个self.balance会导致取Account.balance的值
-- 由于__newindex并没有被劫持，所以acc1的表内会增加域balance
assert(acc1.balance == -100)

acc2 = Account:new{}
acc2:withdraw(100)
assert(acc2.balance == -100)    -- not -200
