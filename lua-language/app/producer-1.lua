function producer ()
  while true do
    x = io.read()
    send(x)
  end
end

producer()
