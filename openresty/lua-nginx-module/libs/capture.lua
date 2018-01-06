--local ngx = require "ngx"   -- 不需要引入

-- 不应该暴露在文件的最顶层
ngx.location.capture("/capture")
