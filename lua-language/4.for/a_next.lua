t = {
    name = "jack",
    age = 10,
    key = "JACK"
}

-- NOTICE: 在调用next对table进行遍历期间，添加元素是未定义行为，可以修改或者删除元素
k = nil
k, v = next(t, k)
print(k, v)
t[k] = nil

k, v = next(t, k)
print(k, v)
t[k] = nil

k, v = next(t, k)
print(k, v)
t[k] = nil

k, v = next(t, k)
print(k, v)
-- t[k] = nil -- k == nil，nil不能作为table的索引
