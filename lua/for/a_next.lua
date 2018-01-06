-- 遍历数组
t = { 10, 20, 30 }
for i, v in ipairs(t) do
    print(i, v)
end

-- 遍历表
t = {
    name = "jack",
    age = 10,
    key = "JACK"
}
for k, v in pairs(t) do
    print(k, v)
end

-- 在调用next对table进行遍历期间，添加元素是未定义行为，可以修改或者**删除**元素
-- k的变化过程：nil, keys, nil, keys
t = {
    name = "jack",
    age = 10,
    key = "JACK"
}

k = nil
k, v = next(t, k)
print(k, v)

k, v = next(t, k)
print(k, v)

k, v = next(t, k)
print(k, v)

k, v = next(t, k)
print(k, v)
assert(k == nil)

-- 又重新开始遍历
-- k == nil，nil不能作为table的索引
-- t[k] = nil
k, v = next(t, k)
print(k, v)

-- 遍历的另一种方法
k = nil
repeat
    k, v = next(t, k)
    print(k, v)
until (k == nil)
