event_name = V1
payload = V2

if event_name == "display_input" then
  output(event_name, 1)
  output(payload, 2)
elseif event_name == "network_write" then
    output(event_name, 3)
    output(payload, 4)
end