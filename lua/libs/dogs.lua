local dogs = ngx.shared.dogs
if (not dogs:get("Tom")) then
    dogs:set("Tom", 56)
end
