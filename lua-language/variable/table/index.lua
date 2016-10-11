local meta = {}
meta.__index = {name="terry"}


foo = {1, 2, 3}
setmetatable(foo, meta)
print(foo.name)
