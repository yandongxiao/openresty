--[[
-- 变量的作用范围:
--
-- 不要按照C类的语言去理解脚本语言
-- 在脚本语言中，脚本的执行顺序定义了变量的作用范围。与变量在脚本中定义的位置是有出入的
-- 脚本类的语言都有这个特性，参见var.py和var1.sh定义
--]]

-- num = 100 -- output: 100
function read_num()
    print(num)
end
-- num = 100 -- output: 100
read_num()
-- num = 100 -- output: nil
