--[[
--程序出现异常以后一般有两种处理方法：
--  1. 返回错误；2. 抛出错误。
--指导原则如下：如果调用者很容易避免此类错误，那么就抛出错误。
--这样，调用者的代码就会很优雅
--
-- 如果返回错误，一般是返回nil + error mssage。NOTICE: 在LUA中返回nil表示出错，正好与go相反
--]]

-- NOTICE: assert接收第二个参数，表示error message。
-- assert、error都会抛出异常
-- error message 也可能是table类型
file = assert(io.open("no-file", "r"))      -- 在调用层，将返回错误转化为抛出错误
