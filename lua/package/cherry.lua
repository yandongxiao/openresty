local function age ()
    return 10
end

local function money()
    return age() * 10
end

local function myprivate()  -- private
end

local cherry = {
    age = age,
    money = money
}

return cherry
