--[[
--
-- LUA不支持具名函数调用, 但是用户可以借助unpack函数，向用户传递一个数组
-- 注意是数组。传递table是没有用的
--]]

function print_person(name, age)
    print(name, age)
end

print("terry", 10)
-- print(name="lilei", age=10)      -- 不支持，语法上有错误
print({name="lilei", age=10})       -- name接受了table， age是nil
print(unpack({"lilei", 10}))        -- 这是一种方法，限制在于只能传递unpack数组，而非关联性数组
