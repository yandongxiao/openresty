--[[
--  nil和false是唯一判断条件为假的依据
--]]

num=0
if num then print("num==0") end

num=""
if num then print('num=""') end

num = false
if num then print('num=false') end

num = nil
if num then print('num=nil') end
