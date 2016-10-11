function parse(query)
    local parsed = {}
    local pos = 1
    local index = 1

    local function kvparse(qstr)
        local kv = {}
        local first, last =  string.find(qstr, "/")
        if first then
            str_key = string.sub(qstr, 0, first - 1)
            str_value = string.sub(qstr, first + 1)
        end

        if str_key then
          kv[str_key] = string.lower(str_value)
        end

        return kv
    end

    local q1 = "[^ \/]*/"
    local q2 = "[^ \/]*/[^ \/]*/"
    while true do
        local first, last = string.find(query, q1, pos)
        if first then
            parsed[index] = kvparse(string.sub(query, pos, last-1))
            pos = last + 1
            index =  index + 1
        else
            parsed[index] = kvparse(string.sub(query, pos))
            break
        end
        q1 = q2
    end

for x, y in pairs(parsed) do
  for m, n in pairs(y) do
    print(m, n)
  end
  print()
end
    return parsed
end

t = parse("imageView/thumbnail/-100y200")
