function string2table(query, sp)
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
        else
            parsed[qstr] = ""
        end
    end

   while true do
        local first, last = string.find(query, sp, pos)
        print(first, last)
        if first then
            ginsert(string.sub(query, pos, first-1));
            pos = last+1
        else
            ginsert(string.sub(query, pos));
            break;
        end
    end
    for x, y in pairs(parsed) do
      print(x, y);
    end
    return parsed
end

string2table("name1=value1&name2=value2", "&")
print()
string2table("name1=value1|name2=value2", "|")
