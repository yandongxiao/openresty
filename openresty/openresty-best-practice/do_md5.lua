-- curl -i 'localhost:8000?key=89ea672444bd7001e4f0fd67aed921fd&data=hello'

-- read data from query paramter
-- 这也是一个需要改进的地方
local data = ngx.var.arg_data
local key = ngx.var.arg_key

-- calculate the md5 value of data
if data == nil then
    -- ngx.say("please give me the data parameter")
    -- 不能与ngx.say or ngx.print混用，否则永远返回200
    -- 那么，如何才能返回400的同时，返回body呢？
    -- ngx.exit(ngx.HTTP_BAD_REQUEST)  -- not return

    ngx.status = ngx.HTTP_BAD_REQUEST
    ngx.say("please give me the data parameter")
    ngx.exit(ngx.HTTP_OK)
end

local res = ngx.location.capture("/do_md5", {body=data})
if res.status ~= ngx.HTTP_OK then
    ngx.status = res.status
    ngx.say(res.body)
    ngx.exit(ngx.HTTP_OK)
elseif res.body ~= key then
    ngx.status = ngx.HTTP_FORBIDDEN
    ngx.say("access denied, server's md5 is", res.body)
    ngx.exit(ngx.HTTP_OK)
end

ngx.say("helloworld")
ngx.exit(ngx.HTTP_OK)
