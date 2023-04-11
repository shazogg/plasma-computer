--OS!disk§!
-- Global variables
BACKGROUND_COLOR = {0, 0, 0}
TEXT_COLOR = {255, 255, 255}
MAX_LINE_DISPLAY_LENGTH = 30
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

-- Remove a character from a string at a specific position
function removeChar(str, position)
  local str1 = string.sub(str, 1, position - 1)
  local str2 = string.sub(str, position + 1)
  local removedStr = str1 .. str2
  return removedStr
end

-- Separate a string at a specific position and kee pthe end of the string
function separateStringEnd(str, position)
  return string.sub(str, position)
end

-- Keyboard event
function keyboardEvent()
  if V1 ~= nil then
    splited_data = split(V1, SEPARATOR)

    -- Character pressed
    if #splited_data == 2 then
      if splited_data[1] == "CHAR" then
        addEditorCharacter(splited_data[2])
      end
    -- Key pressed
    elseif #splited_data == 1 then
      if splited_data[1] == "BACKSPACE" then
        print("BACKSPACE")
        removeEditorCharacter()
      elseif splited_data[1] == "DELETE" then
        deleteEditorText()
      elseif splited_data[1] == "ALEFT" then
        moveCursorLeft()
      elseif splited_data[1] == "ARIGHT" then
        moveCursorRight()
      end
    end
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

-- Add editor character
function addEditorCharacter(char)
  current_editor_text = separateString(current_editor_text, current_cursor_position, char)
  moveCursorRight()
end

-- Remove editor character
function removeEditorCharacter()
  current_editor_text = removeChar(current_editor_text, current_cursor_position - 1)
  moveCursorLeft()
end

-- Delete editor text
function deleteEditorText()
  current_editor_text = ""
  current_cursor_position = 1
end

-- Move cursor left
function moveCursorLeft()
  if current_cursor_position > 1 then
    current_cursor_position = current_cursor_position - 1
    blink = true
  end
end

-- Move cursor right
function moveCursorRight()
  if current_cursor_position < string.len(current_editor_text) + 1 then
    current_cursor_position = current_cursor_position + 1
    blink = true
  end
end

function textEditor()
  displayed_text = current_editor_text

  print(current_cursor_position)

  if current_cursor_position > MAX_LINE_DISPLAY_LENGTH then
    displayed_text = separateStringEnd(displayed_text, current_cursor_position - MAX_LINE_DISPLAY_LENGTH)
    displayed_text = separateString(displayed_text, MAX_LINE_DISPLAY_LENGTH + 1, colorizeText("|", rgbToHex(blink and TEXT_COLOR or BACKGROUND_COLOR)))
  else
    displayed_text = separateString(displayed_text, current_cursor_position, colorizeText("|", rgbToHex(blink and TEXT_COLOR or BACKGROUND_COLOR)))
  end

  --print(string.len(displayed_text) .. "/" .. string.len(current_editor_text))

  return displayed_text
end

-- Setup
function setup()
  -- Utility variable
  start_check = true

  -- Blink cursor variables
  count = 0
  blink = false

  -- Text editor variables
  current_editor_text = ""
  current_cursor_position = 1
  current_text_offset = 1
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