function parse_query(query)
    local parsed = {}
    local pos = 0

    query = string.gsub(query, "&amp;", "&")
    query = string.gsub(query, "&lt;", "<")
    query = string.gsub(query, "&gt;", ">")
    query = string.gsub(query, " ", "")

    local function ginsert(qstr)
        local first, last = string.find(qstr, "=")
        if first then
            parsed[string.sub(qstr, 0, first-1)] = string.sub(qstr, first+1)
        end
    end

    while true do
        local first, last = string.find(query, "&", pos)
        print(pos, first, last)
        if first then
            ginsert(string.sub(query, pos, first-1));
            pos = last+1
        else
            ginsert(string.sub(query, pos));
            break;
        end
    end

    if parsed["x"] == nil then parsed["x"] = 0 end
    if parsed["y"] == nil then parsed["y"] = 0 end
    return parsed
end

t = parse_query("imageView&thumbnail=-100y200")
for x,y in pairs(t) do
  print(x, y)
end


function parse_query_2(query)
    local parsed = {}
    local pos = 0

    query = string.gsub(query, "&amp;", "&")
    query = string.gsub(query, "&lt;", "<")
    query = string.gsub(query, "&gt;", ">")
    query = string.gsub(query, " ", "")

    local function ginsert(qstr)
        local first, last = string.find(qstr, "/")
        if first then
            parsed[string.sub(qstr, 0, first-1)] = string.sub(qstr, first+1)
        end
    end

    q1 = "[^ \/]*/"
    q2 = "[^ \/]*/[^ \/]*/"
    while true do
        local first, last = string.find(query, q1, pos)
        if first then
            print(pos, first, last)
            ginsert(string.sub(query, pos, last-1));
            pos = last+1
        else
            ginsert(string.sub(query, pos));
            break;
        end
        q1 = q2
    end

  if parsed["x"] == nil then parsed["x"] = 0 end
  if parsed["y"] == nil then parsed["y"] = 0 end
  return parsed
 end

print("") 
--t = parse_query_2("vframe/offset/1/type/jpg")
t = parse_query_2("imageView/thumbnail/-100y200")
for x,y in pairs(t) do
  print(x, y)
end


