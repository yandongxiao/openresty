--[[
-- 注意：不支持continue语法
-- 注意  bash 和 python 都支持continue语法
--]]

for i=1, 10 do
    if (i==10) then
        -- continue
        print("do something else")
    end
    print(i)
end
