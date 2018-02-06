query="vFrame"
 if string.find(string.lower(query), "vframe") or
       string.find(string.lower(query), "vinfo") or
       string.find(string.lower(query), "audiotrans") or
       string.find(string.lower(query), "watermark") or
       string.find(string.lower(query), "imageinfo") or
       string.find(string.lower(query), "exif") or
       string.find(string.lower(query), "imageview") or
       string.find(string.lower(query), "gifgen")  then
  print("dsa")
end

q2 = "ddd"
q1=11
qs = q1 or q2
print(qs)
