function parseReferer()
    local referer = "http://baidu.com.a.b.c/dsa"
    if referer then
        return referer:match("http://(.*)")
    else
        return nil
    end
end

print(parseReferer())
