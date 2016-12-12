-- 1. numberic for loop
-- [0, 10]
sum = 0
for i=0, 10, 1 do
    sum = sum + 1
end
-- NOTICE: 是11
assert(sum==11)

-- 2. ipair for loop
t = {1, 2, 3, name="jack", 4}
sum = 0
for i,v in ipairs(t) do
   sum = sum + 1
end
assert(sum == 4)

-- 3. pair for loop

t = {1, 2, 3, name="jack", 4}
sum = 0
for k, v in pairs(t) do
   sum = sum + 1
end
assert(sum == 5)
