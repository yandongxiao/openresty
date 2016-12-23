--[[
-- LUA 语言支持可变参数，但是要求可变参数的每一个值的类型是字符串
--]]

-- 1. 遍历可变参数
function call_variable_args(...)
    -- 但是你用普通的字符串aa="name value", {aa} 却并不能得到想要的结果
    assert(type(...) == "number")
    for i, val in ipairs({...}) do
        if i == 4 then
            assert(type(val) == "string")
        else
            assert(type(val) == "number")
        end
    end
end
call_variable_args(10, 20, 30, "nihao")

-- 2. 将函数A中的可变参数，传递给函数B
function parrent(...)
    return call_variable_args(...)
end
parrent(10, 20, 30, "nihao")

-- 3. 利用unpack函数，传递一个table
-- NOTICE: 不存在pack函数
-- unpack操作的是table
mt = {100, 200, 300, "nihao"}
parrent(unpack(mt))
