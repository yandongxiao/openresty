-- 返回多个返回值
function return_multi_params()
    return {name="terry", age=10}, "something elese", true
end
person, str, go = return_multi_params()
print(person["name"], "=", person["age"])
print(str, go)

-- 函数A调用结果作为表达式的一部分, 且函数A调用处在表达式的最后
-- 可以自适应
function parrent1(a, b, c)
    return a + b + c
end

function parrent2(a, b)
    return a + b
end

function parrent3(a)
    return a
end

function child()
    return 1, 2
end

sum = parrent1(10, child()) -- 返回两个值
print("sum = ", sum)

sum = parrent2(10, child()) -- 返回一个值
print("sum = ", sum)

sum = parrent3(10, child()) -- 竟然返回0个值
print("sum = ", sum)

sum = 10 + child()  -- 返回一个值
print("sum = ", sum)

-- 函数A调用结果作为表达式的一部分，但是并非处在表达式的最后
sum = parrent1(child(), 10, 20) -- 只会使用函数返回的第一个结果
print(sum)

-- 在函数A调用周围添加上括号，就是强制只使用函数返回的第一个结果
a, b = (child())
print(a, b)

-- 函数的多个返回值直接作为了table的元素
-- 注意如果child不是｛｝当中的最后一个表达式，那么只取child的
-- 第一个返回值
mt = {child()}
for i, j in pairs(mt) do
    print(i, j)
end
print(mt[1], mt[2])
