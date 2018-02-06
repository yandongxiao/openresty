function report_error(var)
    if var then
        return var
    else
        error("~o such file")   -- 参数不一定就是字符串，也可以是table
    end
end

status, data = pcall(report_error)
if status then
    print(data)
else
    local err = data
    print(err)
end
