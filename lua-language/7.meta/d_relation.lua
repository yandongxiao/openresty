--[[
-- LUA 支持以下关系操作符的重载
-- __eq  __lt  __le
--  ==    <     <=
--
-- 不等于： not (a == b)j
-- a > b  可转换为  b < a
-- a >= b 可转换为 b <= a
--
-- 所以六个操作符其实是都支持的
-- NOTICE: 关系型操作符的两个操作数，必须是相同类型
-- 对于 __lt 和 __le，LUA直接出错
-- 对于 __eq，如果两个操作数的metatable不想等，直接返回false
--]]

-- NOTICE: 只有在运算操作时，才会进行类型转换
if "1" == 1 then    -- 没有可比性，直接返回false
    assert(1==2)
else
    assert(1==1)
end
