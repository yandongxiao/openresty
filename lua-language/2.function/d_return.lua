--[[
-- return val: 后面不能有任何语句
-- return: 后面可以添加语句，如果return没有采用block包围的trick，那么这条语句无效
--         结果：继续从print语句执行
--
-- 默认返回值：
--      LUA: nil
--      python: None
--      Bash: ""
--]]

function return_now()
    do
        return 10    -- 中间返回的方法
    end
    return "hello"
end

function return_now2()
    return
    print "world"
end

assert(return_now() == 10)
assert(return_now2() == nil)    -- output: world
