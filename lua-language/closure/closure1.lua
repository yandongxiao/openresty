function sum()
    sum = 0
    function add(num)
        num = num or 0
        sum = sum + num
        return sum
    end

    return add
end

fn = sum()
print(fn())
print(fn(1))
print(fn(2))
