-- Main function
function main()
  local adress = V1
  if adress ~= nil and adress ~= 0 then
    -- Get sub adress
    local sub_adress = adress % 10
    local new_adress = math.floor(adress / 10)

    -- Set new adress
    output(new_adress, 1)

    if sub_adress == 1 then
      output(V2, 2)
    elseif sub_adress == 2 then
      output(V2, 3)
    elseif sub_adress == 3 then
      output(V2, 4)
    elseif sub_adress == 4 then
      output(V2, 5)
    elseif sub_adress == 5 then
      output(V2, 6)
    elseif sub_adress == 6 then
      output(V2, 7)
    elseif sub_adress == 7 then
      output(V2, 8)
    end
  end
end

-- Call main function
main()