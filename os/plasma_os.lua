--OS!disk§!
-- Global variables
VERSION = "1.0.0"

BACKGROUND_COLOR = {0, 0, 0}
TEXT_COLOR = {255, 255, 255}
COMMAND_SYMBOL_COLOR = {80, 200, 120}
START_INFOS_COLOR = {0, 71, 171}

MAX_LINE_DISPLAY_LENGTH = 30
MAX_LINE_NUMBER = 11

HELP_PAGE_NUMBER = 2

SEPARATOR = "!§!"
EVENT_SEPARATOR = "!event§!"

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

-- Check if a character is ASCII
function isASCII(char)
  local value = string.byte(char)
  return value >= 0 and value <= 127
end

-- Shift an array backwards
function ShiftBackwardsArray(array)
  local size = #array
  local value = array[1]
  for i = 1, size - 1 do
    array[i] = array[i + 1]
  end

  array[size] = nil

  return array, value
end

-- Input event
function inputEvent()
  if V1 ~= nil and type(V1) == "string" then
    data = split(V1, EVENT_SEPARATOR)

    if #data == 2 then
      if data[1] == "KEYBOARD" then
        keyboardEvent(data[2])
      elseif data[1] == "NETWORK" then
        networkEvent(data[2])
      elseif data[1] == "READ_DISK" then
        readDiskEvent(data[2])
      elseif data[1] == "READ_MEMORY" then
        readMemoryEvent(data[2])
      elseif data[1] == "READ_OS" then
        readOsEvent(data[2])
      end
    else
      error("Invalid event data")
    end
  end
end

-- Emit event
function emitEvent(event_name, payload)
  if event_name == "DISPLAY_OUTPUT" then
    output(payload, 1)
  elseif event_name == "NETWORK_OUTPUT" then
    output(payload, 2)
  else
    output(payload, 3)
  end
end


-- Keyboard event
function keyboardEvent(data)
  splited_data = split(data, SEPARATOR)

  -- Character pressed
  if #splited_data == 2 then
    if splited_data[1] == "CHAR" and isASCII(splited_data[2]) then
      addEditorCharacter(splited_data[2])
    end
  -- Key pressed
  elseif #splited_data == 1 then
    if splited_data[1] == "BACKSPACE" then
      removeEditorCharacter()
    elseif splited_data[1] == "DELETE" then
      deleteEditorText()
    elseif splited_data[1] == "ALEFT" then
      moveCursorLeft()
    elseif splited_data[1] == "ARIGHT" then
      moveCursorRight()
    elseif splited_data[1] == "ENTER" then
      submitCommand()
    end
  end
end

-- Network event
function networkEvent(data)
  print(data)
end

-- Read disk event
function readDiskEvent(data)
  print(data)
end

-- Read memory event
function readMemoryEvent(data)
  print(data)
end

-- Read os event
function readOsEvent(data)
  print(data)
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
  displayed_text =  command_symbol .. current_editor_text

  if current_cursor_position > MAX_LINE_DISPLAY_LENGTH then
    displayed_text = separateStringEnd(displayed_text, (string.len(command_symbol) + current_cursor_position) - MAX_LINE_DISPLAY_LENGTH)
    displayed_text = separateString(displayed_text, MAX_LINE_DISPLAY_LENGTH + 1 + string.len(command_symbol), colorizeText("|", rgbToHex(blink and TEXT_COLOR or BACKGROUND_COLOR)))
  else
    displayed_text = separateString(displayed_text, current_cursor_position + string.len(command_symbol), colorizeText("|", rgbToHex(blink and TEXT_COLOR or BACKGROUND_COLOR)))
  end

  return displayed_text
end

-- Display lines
function displayLines()
  local lines_text = ""

  if #lines > MAX_LINE_NUMBER - 1 then
    ShiftBackwardsArray(lines)
  end

  for i = 1, #lines do
    lines_text = lines_text .. SEPARATOR .. lines[i]
  end

  return lines_text .. SEPARATOR .. textEditor()
end

-- Submit command
function submitCommand()
  executeCommand(current_editor_text)
  deleteEditorText()
end

-- Execute command
function executeCommand(command_text)
  -- Split to args
  local args = split(command_text, " ")

  if #args > 0 then
    if args[1] == "clear" then
      clearCommand()
    elseif args[1] == "help" then
      helpCommand(args)
    elseif args[1] == "version"  then
      versionCommand()
    elseif args[1] == "send"  then
      sendCommand(args)
    elseif args[1] == "update" then
      emitEvent("read_os", nil)
    end
    -- Add your commands here
  end
end

-- Commands

-- Clear command
function clearCommand()
  lines = {}
end

-- Help command
function helpCommand(args)
  if #args > 1 then
    page = tonumber(args[2])

    if page == 1 then
      table.insert(lines, tostring(page).. "/" .. tostring(HELP_PAGE_NUMBER))
      table.insert(lines, "- clear : clear the screen")
      table.insert(lines, "- version : display the version of Plasma OS")
    elseif page == 2 then
      table.insert(lines, tostring(page).. "/" .. tostring(HELP_PAGE_NUMBER))
      table.insert(lines, "- send [text] : Send text over the network")
    else
      table.insert(lines, "0/" .. tostring(HELP_PAGE_NUMBER))
      table.insert(lines, "- help [page_number]: for help")
    end
  else
    table.insert(lines, "0/" .. tostring(HELP_PAGE_NUMBER))
    table.insert(lines, "- help page_number: for help")
  end
end

-- Version command
function versionCommand()
  table.insert(lines, "Plasma OS v" .. VERSION)
end

-- Send command
function sendCommand(args)
  -- Concatenate args
  local args_text = ""
  for i = 2, #args do
    args_text = args_text .. args[i] .. " "
  end

  emitEvent("NETWORK_OUTPUT", args_text)
end

-- Setup
function setup()
  -- Utility variable
  start_check = true

  -- Lines variables
  lines = {}

  -- Blink cursor variables
  blink = false
  blink_timer = 0

  -- Start infos display
  table.insert(lines, colorizeText("Plasma OS v" .. VERSION, rgbToHex(START_INFOS_COLOR)))

  -- Text editor variables
  command_symbol =  colorizeText("$", rgbToHex(COMMAND_SYMBOL_COLOR)) .. " "
  current_editor_text = ""
  current_cursor_position = 1
  current_text_offset = 1

  -- Events
  event_index = 0
  events = {}
  count = 0
end

-- Loop
function loop()
  count = count + 1
  event_index = event_index + 1
  -- Check if the start_check variable is not nil or false
  if start_check then
    if blink_timer >= 15 then
      blink_timer = 0
      blink = not blink
    else
      blink_timer = blink_timer + 1
    end

    if event_index == 1 then
      emitEvent("DISPLAY_OUTPUT", displayLines())
    elseif event_index == 2 then
      sendCommand({"", tostring(count)})
      event_index = 0
    end
  end
end