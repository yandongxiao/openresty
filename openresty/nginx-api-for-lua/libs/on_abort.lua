local function my_cleanup()
    ngx.log(ngx.INFO, "client close connection")
    ngx.exit(ngx.OK)
 end

 local ok, err = ngx.on_abort(my_cleanup)
 if not ok then
     ngx.log(ngx.ERR, "failed to register the on_abort callback: ", err)
     ngx.exit(500)
 end

 ngx.sleep(10)
 ngx.say("hello")
