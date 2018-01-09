--[[
-- NOTICE: 一定不要轻易的定义全局变量或者是全局函数
--]]
name = "jack"
age = 10
count = 100

function setname(newname)
    name = newname
end

function getname(newname)
    return name
end

return name
