local person = require "libs/person"

ngx.say("person name: ", person.name)
ngx.say("person age: ",  person.age)
ngx.say("package.path: ", package.path)
