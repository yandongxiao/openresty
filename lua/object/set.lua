local table_insert = table.insert
local string_format = string.format

local meta = {}

meta.__add = function(set1, set2)
    local set = {}
    for k, v in ipairs(set1) do
        set[v] = true
    end

    for k, v in ipairs(set2) do
        set[v] = true
    end

    local result = {}
    for k, v in pairs(set) do
        table_insert(result, k)
    end

    setmetatable(result, meta)
    return result
end

meta.__tostring = function(set)
    local str = ""
    for _, v in pairs(set) do
        str = string_format("%s %s",str, v)
    end
    srt = string_format("%s\n", str)
    return str
end

local _M = {}

function _M.new(t)
    return setmetatable(t, meta)
end

return _M
