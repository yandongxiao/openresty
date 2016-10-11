function call_variable()
    -- 即便是同一个block内也可以定义变量多次
    local num = 100
    local num = 10
    print(num)
end

call_variable()
