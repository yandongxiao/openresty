lmap = require "lmap"
assert(type(lmap) == "table")

function double(num)
    return num*2
end

t = {1,2,3}
lmap.map(t, double)

for _, v in ipairs(t) do
    print(v)
end
