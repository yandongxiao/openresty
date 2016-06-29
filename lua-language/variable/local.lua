--[[
-- local作用域的真正大小是一个block
-- 一个block:
--      do...end
--      function...end
--      for...end
--]]

function local_var()
    do
        local name = "foo"
        print(name) --foo
    end
    print(name) --nil
end

local_var()
