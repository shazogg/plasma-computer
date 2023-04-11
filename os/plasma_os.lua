--OS!disk§!
-- Global variables
BACKGROUND_COLOR = {0, 0, 0}
TEXT_COLOR = {255, 255, 255}
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

-- Convert a table of RGB values to a hex color
function rgbToHex(rgb)
  local hex = ""
  for i = 1, #rgb do
    local hexValue = string.format("%02X", rgb[i])
    hex = hex .. hexValue
  end
  return hex
end

-- Colorize a string
function colorizeText(text, color)
  return "<color=#" .. color .. ">" .. text .. "</color>"
end

-- Separate a string at a specific position and add text at that position
function separateString(str, position, char)
  local str1 = string.sub(str, 1, position - 1)
  local str2 = string.sub(str, position)
  local separatedStr = str1 .. char .. str2
  return separatedStr
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

function textEditor()
  if blink then
    return separateString(current_editor_text, 6, "<color=#FFFFFF>|</color>")
  else
    return separateString(current_editor_text, 6, "<color=#" .. rgbToHex(BACKGROUND_COLOR) .. ">|</color>")
  end
end

-- Setup
function setup()
  start_check = true
  count = 0
  blink = false

  current_editor_text = "hello world"
end

-- Loop
function loop()
  -- Check if the start_check variable is not nil or false
  if start_check then
    count = count + 1

    if count >= 15 then
      count = 0
      blink = not blink
    end

    output(textEditor(), 1)
  end
end