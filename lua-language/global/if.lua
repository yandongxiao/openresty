x = 10

for i = 1, 5 do
    if x == 10 then
        local x = 20  -- 只有此处使用的是局部变量
    else
        print(x)    -- 看不见then block中定义的局部变量
    end
end
