local function do_exit(status, errmsg)
    ngx.status = status
    ngx.say(errmsg)
    ngx.exit(ngx.HTTP_OK)
end

ngx.req.read_body()
local post_args = ngx.req.get_post_args()
local data = ngx.var.arg_data or (post_args and post_args["data"])
local key = ngx.var.arg_key or (post_args and post_args["key"])
ngx.log(ngx.ERR, "data == ", data)
ngx.log(ngx.ERR, "key == ", key)
if data == nil or key == nil then do_exit(ngx.HTTP_BAD_REQUEST, "parameter missing") end

-- 这个地方有一点不妥，location do_md5是在conf文件中定义的，但是调用位置却是在.lua文件中
-- 而且proxy_pass还只能存在于conf文件中.
local res = ngx.location.capture("/do_md5", {body=data})
local http = require "resty.http"
local httpc = http.new()
res, err = httpc.request_uri("http://localhost:8001/do_md5", {body=data})

if res ~= nil then do_exit(ngx.HTTP_INTERNAL_SERVER_ERROR, err) end
if res.status ~= ngx.HTTP_OK or res.body ~= key then do_exit(res.status, res.body) end

ngx.say("helloworld")
ngx.exit(ngx.HTTP_OK)
