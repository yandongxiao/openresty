local function capture()
    -- 注意别忘了写return，capture返回的是一个table。
    -- res.body返回的是子请求的body
    return ngx.location.capture("/capture")
end

return capture      -- 不但可以返回table，还可以返回一个函数
