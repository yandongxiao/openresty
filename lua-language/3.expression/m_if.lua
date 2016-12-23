--[[
-- 注意 if/elseif/else/end 的风格, LUA是不使用大括号的
--]]

num = 2
if num == 1 then
    print("one")
elseif num == 2 then    -- 注意elseif之间没有空格
    print("two")
else
    print("three")
end

--[[
--
-- 如果没有elseif语言，且语句简单的情况下，可以将它们写在同一行
--]]
if num==1 then print("one"); print("ONE") else print("three"); print("THREE") end
