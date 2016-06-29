--[[
-- return 和 break只能出现在block的最后
--]]
function return_now()
    do
        -- 如果return没有采用block包围的trick，那么这条语句无效
        -- 结果：继续从print语句执行
        return
    end
    print "nihao"
end

return_now()
