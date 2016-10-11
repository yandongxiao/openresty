function list_iter(t)
    local i = 0
    local count = #t
    return function()
        i = i + 1
        return t[i]
    end
end

t = {10, 20, 30}

-- 遍历的方法一
iter = list_iter(t)
while true do
    local element = iter()
    if element == nil then break end
    print(element)
end

-- 遍历方法二
-- 一般情况下，状态常量都被设置为了nil
iter = list_iter(t)
for element in iter do  -- element是控制变量
    print(element)
end
