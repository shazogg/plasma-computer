--OS!disk§!
-- Global variables
SEPARATOR = "!§!"

-- Split a string into a table of substrings
function split(str, sep)
  local tmp = str:gsub(sep, "\0")
  local segments = {}
  for segment in tmp:gmatch("[^%z]+") do
      table.insert(segments, segment)
  end
  return segments
end

-- Keyboard event
function keyboardEvent()
  if V1 ~= nil then
    print(V1)
  end
end

-- Network event
function networkEvent()
  if V2 ~= nil then
    print(V2)
  end
end

-- Read disk event
function readDiskEvent()
  if V3 ~= nil then
    output(V3, 1)
  end
end

-- Read memory event
function readMemoryEvent()
  if V4 ~= nil then
    output(V4, 1)
  end
end

-- Setup
function setup()
  start_check = true
end

-- Loop
function loop()
  -- Check if the start_check variable is not nil or false
  if start_check then
  end
end