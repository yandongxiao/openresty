--[[
-- 以下巧妙的使用闭包技术，达到了隐藏数据的目的。可带来的副作用也不少
-- 1. 无法继承；2. 嵌套函数无法被JIT编译器编译
--]]

function newAccount(initialBalance)
    local self = {balance=initialBalance}

    -- 闭包的高级用法
    local withdraw = function (v)
        self.balance = self.balance - v
    end

    local deposit = function (v)
        self.balance = self.balance + v
    end

    local getBalance = function () return self.balance end

    return {
        withdraw = withdraw,
        deposit = deposit,
        getBalance = getBalance
    }
end

c1 = newAccount(100)
c1.withdraw(10)
print(c1.getBalance())
