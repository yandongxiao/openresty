--[[
-- 匿名函数应用之一
--]]
names = {"Peter", "Paul", "Mary"}
grades = {Mary = 10, Paul = 7, Peter = 8}

table.sort(names, function (n1, n2)
    return grades[n1] > grades[n2] -- compare the grades
end)

for k,v in pairs(names) do
  print(v) 
end

--[[
-- 匿名应用之二
--]]
myfunc = function()
    print("helloworld")
end
myfunc()
