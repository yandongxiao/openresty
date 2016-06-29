-- 以下两种初始化table的方式等价
person1 = {name="terry", age=20}
person2 = {["name"]="lilei", age=30}
person3 = {10, 20, 30}

-- 以下两种初始化的方式等价
print(person1.name, person1.age)
print(person2["name"], person2["age"])
print(person3[1])
-- print(person3.2)    -- 这种方式不支持
