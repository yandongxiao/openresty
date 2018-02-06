--[[
--
-- nil是Lua语言的一种特殊类型，该类型只有一个值，nil。nil类型的存在使得Lua拥有了丰富的特性:
--
-- LUA 变量有两种状态
-- nil的出现使得变量存在两种状态：未初始化；已赋值.
--   1. 未定义。未定义的变量只是一个概念，在LUA中只要被引用，如果没有定义，则立即将该变量设置为nil
--   2. 未初始化。即变量的值为nil
--   3. 已赋值。不解释
--
-- LUA可以删除一个变量
--   比如name变量已赋值，此时执行name=nil，就可以删除该变量。实际上更准确的表达是将该变量变为未初始化状态
--
-- 未初始化变量作为条件测试对象，与false一致
--
-- 注意：多重赋值时，变量个数大于值的个数的情况下，无论多余变量之前是否被赋值, 多余变量的值将为nil
--]]

-- 1. 定义未初始化的变量
assert(num==nil)

-- 2. 删除变量
name = "hello"
name = nil
assert(name==nil)

-- 3. 多重赋值
name = "json"
age = 10
name, age = "xml"
assert(name=="xml")
assert(age==nil)

-- 4. 作为条件测试对象
val=nil -- 多余，但是为了防止上面测试case使用该值
if not val  then
    assert(val==nil)
else
    assert(1==3)
end
