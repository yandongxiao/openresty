function foo (str)
    if type(str) ~= "string" then
        -- 错误支持错误级别
        -- 当前函数出错，则设置为1
        error("string expected", 2)
    end
end

foo{}
