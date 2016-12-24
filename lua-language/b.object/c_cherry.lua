--[[
-- 尚未解决：
--      如何利用LUA语法构造class系统，包括继承和隐藏
--]]
Account = {         -- 对象名称
    balance = 0     -- 对象状态
}

-- 冒号的方式就是一个语法糖
function Account:withdraw (v)           -- 定义对象的快捷方式
     self.balance = self.balance - v    -- 避免使用全局变量
end

a = Account; Account = nil
a:withdraw(100.00)      -- 调用和声明都是用这种方式
