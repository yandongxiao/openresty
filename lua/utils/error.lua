function tt()
  print "enter a number:"
  n = io.read("*number")
  print(type(n))
  if not n then error("---invalid input") end
end

tt()
