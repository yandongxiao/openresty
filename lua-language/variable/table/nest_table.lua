t = {1, {"a", "b", "c"}, 3} -- 嵌套表
--t[4] = t    -- 这会导致以下代码死循环

function print_table(t, n)
    n = n or 0

    for k, v in pairs(t) do
        if (type(v)=="table") then
            print_table(v, n+1)
        else
            local sep = ""
            for i=1, n do
                sep = sep .. "--"    -- 这样拼凑字符串，效率不高
            end
            data = string.format("%s: %s %s\n", sep, k, v)
            print(data)
        end
    end
end

print_table(t)