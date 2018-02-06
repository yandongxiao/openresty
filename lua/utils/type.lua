print(type(1))
print(type("name"))
print(type({1,2,3}))
print(type({name="terry"}))
print(type(true))
print(type(print))

function myroutine()
end

rt = coroutine.create(myroutine)
print(type(rt)) -- thread数据类型
