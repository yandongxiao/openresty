--[[
--
-- 引用传递的类型有:
--      table
--      function
--]]

function myfunc(val)
    val.name = "jack"
end

tom = {name="tom"}
myfunc(tom)
assert(tom.name=="jack")
