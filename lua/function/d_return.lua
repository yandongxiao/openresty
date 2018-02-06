#! /usr/local/bin/lua
--[[
-- 默认返回值：
--      LUA: nil
--      python: None
--      Bash: ""
--]]

function return_now()
    -- return语句只能出现在block的末尾，如果希望有多个return语句
    -- 使用do/end进行封装
    do
        -- return val: 后面不能有任何语句
        return 10    -- 中间返回的方法
    end
    return "hello"
end

function return_now2()
    -- return: 后面可以添加语句，该语句的执行结果作为return的返回结果。
    --         return 后面只能有一条语句（其实相当于合并为一行）
    return
    -- "world" or "hello"
    -- print("hello")
end

assert(return_now() == 10)
assert(return_now2() == nil)
-- assert(return_now2() == "world")    -- output: world
