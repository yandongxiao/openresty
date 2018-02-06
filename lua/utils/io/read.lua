f, err = io.open("/tmp/input", "r")
if f == nil then
    print("err: ", err)
else
    data = f:read("*all")
    print(data)
end
