gloval_upvalue = 10
gloval_upvalue1 = 20
local local_upvalue = 100
local local_upvalue2 = 25

function l_counter()
    return function ()
        local_upvalue = local_upvalue + 1
        local_upvalue2 = local_upvalue2 + 1
        return local_upvalue
    end
end

function g_counter()
    return function ()
        gloval_upvalue = gloval_upvalue + 1
        return gloval_upvalue,gloval_upvalue1
    end
end

g_testf = g_counter()
l_testf = l_counter()

function gtest()
    print(g_testf())
end

function ltest()
    print(l_testf())
end

upvalue_test(1,2,3)
upvalue_test(4,5,6)
