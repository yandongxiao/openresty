do
    -- _f 是迭代函数
    -- _s 是状态常量
    -- _var 是控制变量
    -- explist是表达式列表
    local _f, _s, _var = explist
    while ture do
        var1, var2, varn = _f(_s, _var) -- for 和 in 之间定义的变量
        _var = var1 -- 只有var1才是真正的控制变量
        if _var == nil then break end
        do
            -- 此处就是for block的内容
        end
    end
end
