--[[
-- LUA 原生是不支持contiue的
--]]

sum = 0
for i = 1, 10, 1 do
    repeat
        if i == 5 then
            break
        end
        sum = sum + 1
    until true
end

assert(sum==9)

