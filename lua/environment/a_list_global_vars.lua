--[[
-- 所有全局变量被组织在一张“_G”表内
--]]

var1 = "foo"
local found = false

for k, v in pairs(_G) do
    if k == "var1"  then found=true end
end

assert(found==true)
