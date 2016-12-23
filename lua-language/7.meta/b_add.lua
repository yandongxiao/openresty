-- [[
-- NOTICE：定义metatable的范式
-- ]]
Set = {}    -- no data

-- meta table，为了避免污染全局命名空间
Set.mt = {
    -- 注意这会儿Set.union == nil
    -- 但是若将 Set.mt 下移，会导致setmetatable(set, Set.mt) <==> setmetatable(set, nil)
    __add = Set.union
}

function Set.new (t)    -- method defined
    local set = {}
    -- 如果不是下面的调用，Set.new实际上返回的就是一个table，没有任何特殊性
    setmetatable(set, Set.mt)
    for _, l in ipairs(t) do set[l] = true end
        return set
end

function Set.union (a,b)
    local res = Set.new{}
    for k in pairs(a) do res[k] = true end
    for k in pairs(b) do res[k] = true end
    return res
end

function Set.intersection (a,b)
    local res = Set.new{}
    for k in pairs(a) do
        res[k] = b[k]
    end
    return res
end

function Set.tostring (set)
    local s = "{"
    local sep = ""
    for e in pairs(set) do
        s = s .. sep .. e
        sep = ", "
    end
    return s .. "}"
end

function Set.print (s)
    print(Set.tostring(s))
end

Set.mt.__add = Set.union    -- 这句还真省不了
Set.mt.__tostring = Set.tostring
s1 = Set.new{10, 20, 30, 50}
s2 = Set.new{30, 1}
s3 = s1 + s2        -- 所有Set.new出来的table，它们都共享同一个metatable，所以上一句的操作起作用了
print(s3)
assert(#s3 == 1)      -- 之所以==1，是因为s3[2] == nil
