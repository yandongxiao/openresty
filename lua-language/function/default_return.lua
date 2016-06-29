function return_nothing()
end

ret=return_nothing()

if (ret) then
    print("ret:", ret)
else
    print("ret is nil") -- 默认返回值是nil
end
