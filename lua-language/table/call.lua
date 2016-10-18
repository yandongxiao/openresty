--
-- 让table表现出了可以调用的特性
--
t = {}
t.mt = {}
t.mt.__call = function (self, ...)
    args = {...}
    print(args[2])
end

setmetatable(t, t.mt)

t(1,2,3)
