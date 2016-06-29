--[[
-- LUA一般不处理错误，由调用LUA模块的应用（其他语言）负责处理
--]]

function report_error(var)
    if var then
        return var
    else
        error("~o such file")
    end
end

status, data = pcall(report_error)
if status then
    print(data)
else
    local err = data
    print(err)
end
