Account = {         -- 对象名称
    balance = 0     -- 对象状态
}

function Account.withdraw (self, v)     -- 对象方法
     self.balance = self.balance - v    -- 避免使用全局变量
end

a = Account; Account = nil
a.withdraw(a, 100.00)  -- withdraw是公用的
