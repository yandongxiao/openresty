#! /usr/local/bin/lua
function foo (str)
    if type(str) ~= "string" then
        -- 错误支持错误级别
        -- 当前函数出错，则默认设置为1
        -- 当设置为2时，error message指示的是调用foo函数的位置
        error("string expected", 2)
    end
end

foo{}
