function roverRearCamera(data)
  local data_array = {"RCAM", ROVER_SEPARATOR}

  if data ~= nil then
    for _, val in ipairs(data) do
      table.insert(data_array, val)
    end
  end

  local data_string = mergeArrayToString(data_array)
  output(data_string, 7)
end