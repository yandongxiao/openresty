local _M = {}

local data = {
    dog = 3,
    cat = 4,
    tigger=5,
}

function _M.get_age(name)
    return data[name]
end

return _M
