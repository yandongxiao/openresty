function string2table(query, sp)                            
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
        else
            parsed[qstr] = ""
        end
    end

    local q1, q2 = nil, nil
    if sp == "|" then
      q1 = sp
      q2 = sp
    else
      q2 = "[^ \/]*/[^ \/]*/"
      if string.find(string.lower(query), "vframe") or
        string.find(string.lower(query), "vinfo") or
        string.find(string.lower(query), "audiotrans") or
        string.find(string.lower(query), "watermark") or
        string.find(string.lower(query), "imageinfo") or
        string.find(string.lower(query), "exif") or
        string.find(string.lower(query), "imageview") or
        string.find(string.lower(query), "gifgen")  then
        q1 = "[^ \/]*/"
      end
    end

    qs = q1 or q2
    while true do
        local first, last = string.find(query, sp, pos)
        print(pos, first, last)
        if first then
            ginsert(string.sub(query, pos, last-1));
            pos = last+1
        else
            ginsert(string.sub(query, pos));
            break;
        end
        qs = q2 
    end

    for x, y in pairs(parsed) do
      print(x, y)
    end

    return parsed
end

string2table("name1/value1/name2/value2", "/")
print()
string2table("exif/value1|imageview/value2", "|")
