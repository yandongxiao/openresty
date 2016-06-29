function print_person(name, age)
    print(name, age)
end

print("terry", 10)
-- print(name="lilei", age=10)      -- 不支持，语法上有错误
-- print({name="lilei", age=10})    -- name接受了table， age是nil
print(unpack({"lilei", 10}))        -- 这是一种方法，限制在于只能传递unpack数组，而非关联性数组
