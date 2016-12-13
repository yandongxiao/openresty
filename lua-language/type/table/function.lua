function add(a, b)
    return a+b
end

mt={["+"]=add}
print(mt["+"](1,2)) --应该存在更加简便的调用方式
