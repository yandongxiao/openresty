print(string.gsub("hello world", "(%w+)", "%1 %1")) -- 分组信息
print(string.gsub("hello Lua", "(%w+)%s*(%w+)", "%2 %1"))

string.gsub("hello world", "%w+", print)    -- 只要匹配成功，立即执行print函数

lookupTable = {["hello"] = "hola", ["world"] = "mundo"}
print(string.gsub("hello world", "(%w+)", lookupTable))
