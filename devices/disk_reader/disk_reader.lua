-- Global variables
SEPARATOR = "!disk§!"

-- Split a string into a table of substrings
function split(str, separator, occurrences)
  local tmp = str:gsub(separator, "\0", occurrences)
  local segments = {}
  for segment in tmp:gmatch("[^%z]+") do
      table.insert(segments, segment)
  end
  return segments
end

-- Create variables
os_load = false

-- Load OS
function loadOSEvent()
  os_load = true
  output(nil, 1)
end

-- Read data
function readDataEvent()
  output(nil, 1)
end

-- Write data
function writeDataEvent()
  if V2 ~= nil then
    output(V2, 2)
    output(false, 3)
  else
    output(true, 3)
  end
end

-- Data readed event
function readedEvent()
  if V1 ~= nil then
    splited_data = split(V1, SEPARATOR, 1)

    if #splited_data == 2 then
      -- Check data type
      data_type = splited_data[1]:gsub("-", "")
      if data_type == "OS" then
        -- If data need to be loaded
        if os_load then
          output(splited_data[2], 4)
          output(false, 3)
          os_load = false
        else
          output(splited_data[2], 5)
          output(false, 3)
        end
      elseif data_type == "FILE" then
        output(splited_data[2], 5)
        output(false, 3)
      else
        output(true, 3)
      end
    else
      output(true, 3)
    end
  else
    output(true, 3)
  end
end