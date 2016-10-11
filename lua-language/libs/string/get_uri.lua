function get_uri()
    local url = 'cos-cn-hangzhou.chinac.com/aaa/bbb/ccc'
    return url:match('cos\\-cn\\-hangzhou\\.chinac.com')
end

print(get_uri())
