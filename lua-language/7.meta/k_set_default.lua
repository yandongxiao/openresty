--[[
--
-- __index 应用：指定tab.xxx的默认返回值
--               支持为不同的table设置不同默认值
--]]

-- 方法1
-- NOTICE：每次函数调用都创建了一个独立的metatable，这是与前面例子的最大不同
-- 也正式这样，才有可能为不同的table设置不同默认值
function setDefault (t, d)
    local mt = {__index = function () return d end} -- 其实这个函数的形式不合规，应该是function(t, key)
    setmetatable(t, mt)
end

tab = {x=10, y=20}
assert(tab.x == 10)
assert(tab.z == nil)
setDefault(tab, 0)
assert(tab.x == 10)
assert(tab.z == 0)

-- NOTICE: 这相当于完全初始化了一个新的表，新的表的名称也为tab，旧的表就无法再被引用到
tab = {x=10, y=20}
assert(tab.z == nil)

-- 方法2
-- 借助t中的特殊field来保存默认值
-- NOTICE: 这样的一个确实是污染了table的命名空间
local mt = {__index = function (t) return t.___ end}
function setDefault (t, d)
    t.___ = d
    setmetatable(t, mt)
end
tab = {x=10, y=20}
assert(tab.x == 10)
assert(tab.z == nil)
setDefault(tab, 0)
assert(tab.x == 10)
assert(tab.z == 0)

-- 方法3
-- 在原先table上添加一个元素，只是这个元素比较特殊，是table类型
local key = {}  -- 要求key只能指向这个table
local mt = {
    __index = function (t) return t[key] end
}

function setDefault (t, d)
    t[key] = d
    setmetatable(t, mt)
end
