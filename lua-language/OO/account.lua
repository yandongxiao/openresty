local _M = {}

function _M:deposit(v)
    self.balance = self.balance + v
end

function _M:withdraw(v)
    if (self.balance >= v ) then
        self.balance = self.balance - v
    else
        error("no enough money")
    end
end

_M.__index = _M

function _M.new(balance)
    balance = balance or 0
    return setmetatable({balance=balance}, _M)
end

return _M
