--[[
-- 支持break语法
-- bash 和 python 都支持break语法
--]]

for i=1, 10 do
    if (i==7) then
        print("do something else")
        break
    end
    print(i)
end
