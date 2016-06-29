--[[
-- 展示了LUA脚本的一个特性，也是大多数脚本类语言拥有的一个特性
-- 即：变量的值只有在真正用到的时候，才会去evaluate.
--]]

--num = 100 -- output: 100
function read_num()
    print(num)
end
--num = 100 -- output: 100
read_num()
--num = 100 -- output: nil
