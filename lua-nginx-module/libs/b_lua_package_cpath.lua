local sum = require "sum"

ngx.say("package.cpath: ", package.cpath)
ngx.say("sum: ", sum.sum(1, 100))
