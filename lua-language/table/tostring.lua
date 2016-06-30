--
-- tostring
--
t = {}

t.mt = {}

t.mt.__tostring = function (self, ...)
    return "tostring"
end

setmetatable(t, t.mt)

print(t)
