-- Global variables
EVENT_SEPARATOR = "!event§!"

-- Split a string into a table of substrings
function split(str, separator, occurrences)
  local tmp = str:gsub(separator, "\0", occurrences)
  local segments = {}
  for segment in tmp:gmatch("[^%z]+") do
      table.insert(segments, segment)
  end
  return segments
end

-- Variable
data = split(V1, EVENT_SEPARATOR, 1)
routes = {}

-- Add routes
routes["READ_DISK"] = 1
routes["WRITE_DISK"] = 2
routes["UPDATE_OS"] = 3
routes["SET_KEYBOARD_INDICATOR_COLOR"] = 4
routes["SET_KEYBOARD_COLOR"] = 5

-- Output
output(data[2], routes[data[1]])
