function define_global()
    name="foo"
end

print(name) -- nil
define_global()
print(name) -- foo
