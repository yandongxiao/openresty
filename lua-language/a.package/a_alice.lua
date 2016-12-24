alice = {}

-- 1. alice这个名字以后如果要换的话，需要需要很多行代码
function alice.age ()   -- public
    return 10
end

function alice.money()
    -- 2. alice模块内部的调用也采用alice.age方法，不符合习惯
    return alice.age() * 10
end

local function myprivate()  -- private
end

return alice    -- package名称注意与lua文件名称保持一致
