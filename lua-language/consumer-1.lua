
function consumer ()
  while true do
    local x = receive() -- receive from producer
    io.write(x, "\n") -- consume new value
    end
end

consumer()
