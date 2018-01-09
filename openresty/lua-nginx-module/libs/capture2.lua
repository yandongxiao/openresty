local function capture()
    -- 注意别忘了写return，capture返回的是一个table。
    -- res.body返回的是子请求的body
    return ngx.location.capture("/capture")
end

return capture
