function New(t)
  p = {}
  p.__index = t
  p.__newindex = function(t, k, v) print(k, "new-indexed is called") end
  setmetatable(p, p)
  return p
end

t = {1, 2, 3}
t = New(t)
print(t[1])
t[4] = 4
