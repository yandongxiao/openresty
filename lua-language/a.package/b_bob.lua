P = {}
bob = P

function P.age ()   -- public
    return 10
end

function P.money()
    -- 2. 模块内部的调用采用P.age方法，不符合习惯
    return P.age() * 10
end

local function myprivate()  -- private
end

return bob
