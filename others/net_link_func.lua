-- Separators
NET_SEPARATOR = "!§!"

-- Get the size of a dictionary
function getDictionarySize(dict)
  local count = 0
  for _ in pairs(dict) do
    count = count + 1
  end
  return count
end

-- Split a string into a table of substrings
function split(str, separator, occurrences)
  local tmp = str:gsub(separator, "\0", occurrences)
  local segments = {}
  for segment in tmp:gmatch("[^%z]+") do
      table.insert(segments, segment)
  end
  return segments
end

-- Remove nil values from an array
function removeArrayNils(array)
  for i = #array, 1, -1 do
    if array[i] == nil then
      table.remove(array, i)
    end
  end

  return array
end

-- Convert a string to a boolean
function toBoolean(str)
  return str == "true" and true or false
end

-- Main function
function main()
  local data_string = V1
  if data_string ~= nil then
    -- Split data
    local splited_data = split(data_string, NET_SEPARATOR)

    -- Remove nil values
    splited_data = removeArrayNils(splited_data)

    if getDictionarySize(splited_data) >= 2 and splited_data[1] == "GET" then
      output(splited_data[2], 1)
    elseif getDictionarySize(splited_data) >= 1 and splited_data[1] == "CAMR" then
      output(false, 1)
      output(true, 2)
    end
  end
end

-- Call main function
main()