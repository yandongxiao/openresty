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

local http = require "resty.http"
local httpc = http:new()
--local res, err = httpc:request_uri("http://127.0.0.1:8001/do_md5", {body=data})	-- 这里如何如何才能写域名呢?
local res, err = httpc:request_uri("http://localhost:8001/do_md5", {body=data})	-- 这里如何如何才能写域名呢?

if res == nil then do_exit(ngx.HTTP_INTERNAL_SERVER_ERROR, err) end
if res.status ~= ngx.HTTP_OK or res.body ~= key then do_exit(res.status, res.body) end

ngx.say("helloworld")
ngx.exit(ngx.HTTP_OK)
