--[[
-- LUA 语言支持可变参数，可变参数的每一个值的类型是字符串
--]]

-- 遍历可变参数
function call_variable_args(...)
    -- ... 的数据类型是字符串, {...} 变成了字符串数组
    -- 但是你用普通的字符串aa="name value", {aa} 却并不能得到想要的结果
    for i, val in ipairs({...}) do  
        print(i, val)
    end
end
call_variable_args(10, 20, 30, 40)

-- 将函数A中的可变参数，传递给函数B
function parrent(...)
    print("in parrent")
    return call_variable_args(...)
end
parrent(10, 20, 30)

-- 利用unpack函数，传递一个table
-- 注意不存在pack函数
-- unpack操作的是table
mt = {100, 200, 300}
parrent(unpack(mt))
