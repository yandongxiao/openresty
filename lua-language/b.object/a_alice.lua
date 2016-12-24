Account = {         -- 对象名称
    balance = 0     -- 对象状态
}

function Account.withdraw (v)       -- 对象方法
    -- 1. 方法withdraw是公用的，但是在方法内部使用了全局变量Account
     Account.balance = Account.balance - v
end

a = Account; Account = nil
a.withdraw(100.00)  -- withdraw是公用的
