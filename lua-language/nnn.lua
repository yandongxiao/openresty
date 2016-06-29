function parse_query(query)
    local parsed = {}
    local pos = 1

    local function ginsert(qstr)
        local first, last = string.find(qstr, "/")
        if first then
            parsed[string.sub(qstr, 0, first-1)] = string.sub(qstr, first+1)
        end
    end

    local q1, q2 = nil, nil
    local q2 = "[^ \/]*/[^ \/]*/"
    if string.find(string.lower(query), "vframe") or
       string.find(string.lower(query), "vinfo") or
       string.find(string.lower(query), "audiotrans") or
       string.find(string.lower(query), "watermark") or
       string.find(string.lower(query), "imageinfo") or
       string.find(string.lower(query), "exif") or
       string.find(string.lower(query), "imageview") or
       string.find(string.lower(query), "gifgen")  then
      q1 = "[^ \/]*/"
      print("-------")
    end
    local qs = q1 or q2
    print(qs)
    while true do
        local first, last = string.find(query, qs, pos)
        if first then
            print(pos, first, last)
            print(string.sub(query, pos, last-1))
            ginsert(string.sub(query, pos, last-1));
            pos = last+1
        else
            print(pos, first, last)
            ginsert(string.sub(query, pos));
            break;
        end
        qs = q2
    end

    for x,y in pairs(parsed) do
        print(x,y)
    end
    return parsed
end

parse_query("audioTrans/format/amr/ar/8000/ab/32000")
