t = {name="terry", age=20, 1, 2, 3,}

key, val = next(t)
if val == nil then
    print("the table is empty")
else
    while key do
        --注意在遍历的过程中，你可以修改现存KEY的值，甚至可以删除KEY的值
        --但是绝对不允许add新的key，val对
        print(key, val)
        key, val = next(t, key)
    end
end

-- 以上代码等价于下面的内容，同时也揭示了pairs是如何实现的
function mypairs(t)
    return next, t, nil
end

for key, val in mypairs(t) do
    t[key] = nil
end
if next(t) == nil then print "table is empty now" end
