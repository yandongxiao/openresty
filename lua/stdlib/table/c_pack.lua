function print_args(...)
    args = table.pack(...)
    for i in ipairs(args) do
        print(args[i])
    end
end

print_args(1,2,3,4)
print_args({}, function ()end)
assert(#table.pack("a", "b", "c", "d") == 4)    -- 也可以这样使用
