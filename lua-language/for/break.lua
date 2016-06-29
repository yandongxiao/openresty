--[[
-- 
--]]

for i=1, 10 do
    if (i==10) then
        break   --事实证明break的使用，并没有像return那样受限制
        print("do something else")
    end
    print(i)
end
