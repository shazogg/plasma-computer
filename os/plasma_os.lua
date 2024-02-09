--OS!disk§!
--#region Global variables

-- Version
VERSION = "2.5.0"

-- Colors
BACKGROUND_COLOR = {0, 0, 0}
TEXT_COLOR = {255, 255, 255}
INFO_COLOR = {0, 71, 171}
SUCCESS_COLOR = {0, 255, 0}
ERROR_COLOR = {255, 0, 0}
COMMAND_SYMBOL_COLOR = {80, 200, 120}
BLINK_COLOR = {255, 255, 255}


-- Display
MAX_LINE_DISPLAY_LENGTH = 30
MAX_LINE_NUMBER = 11

-- Softwares events
SOFTWARES = {}
KEYBOARD_INPUT_EVENTS = {}
NETWORK_INPUT_EVENTS = {}
MODULE_INPUT_EVENTS = {}
READ_DISK_INPUT_EVENTS = {}
SETUP_EVENTS = {}
LOOP_EVENTS = {}
SOFTWARES_COMMANDS = {}
SOFTWARES_HELP_PAGES = {}

-- Separators
SEPARATOR = "!§!"
SOFTWARES_SEPARATOR = "!soft§!"
SOFTWARES_DATA_SEPARATOR = "!soft_data§!"
OS_DISK_SEPARATOR = "--OS!disk§!"

-- Help pages
HELP_PAGES = {
  {
    "- help [page_number]: for help",
  },
  {
    "- restart : restart the computer",
    "- clear : clear the screen",
    "- version : display the version of Plasma OS",
    "- send [data]: Send message on network",
    "- override: Override screen display",
    "- save: To save current OS on a disk"
  },
  {
    "- software list: List softwares",
    "- software install:",
    " To install a software from a disk",
    "- software update:",
    " To update a software from a disk",
    "- software uninstall:",
    " To uninstall a software"
  }
}

--#endregion

--#region Utils

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

-- Slice an array
function slice(array, start_index, end_index)
  local sliced_array = {}
  local array_length = #array

  -- Handling negative indices
  if start_index < 0 then
      start_index = array_length + start_index + 1
  end

  if end_index == nil or end_index > array_length then
      end_index = array_length
  elseif end_index < 0 then
      end_index = array_length + end_index + 1
  end

  -- Slicing the array
  for i = start_index, end_index do
      table.insert(sliced_array, array[i])
  end

  return sliced_array
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

  if size < 2 then
    return {}, array[1]
  end

  local value = array[1]
  for i = 1, size - 1 do
    array[i] = array[i + 1]
  end

  array[size] = nil

  return array, value
end

-- Merge an array into a string
function mergeArrayToString(array, separator)
  local result = ""
  local sep = separator or ""
  for i, value in ipairs(array) do
    if value ~= nil then
      if i > 1 then
        result = result .. sep
      end
      result = result .. value
    end
  end
  return result
end

--#endregion

--#region Input events

-- Keyboard event
function keyboardEvent()
  if type(V1) == "string" then
    local splited_data = split(V1, SEPARATOR)

    -- If the command is not disabled
    if not disable_commands then
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
        elseif splited_data[1] == "AUP" then
          goHistoryUp()
        elseif splited_data[1] == "ADOWN" then
          goHistoryDown()
        end
      end
    end

    -- Softwares events
    for software_name, software_function in pairs(KEYBOARD_INPUT_EVENTS) do
      software_function(splited_data)
    end
  end
end

-- Network event
function networkEvent()
  if type(V2) == "string" then
    -- Softwares events
    for software_name, software_function in pairs(NETWORK_INPUT_EVENTS) do
      software_function(V2)
    end
  end
end

-- Module input event
function moduleInputEvent()
  if type(V4) == "string" then
    -- Softwares events
    for software_name, software_function in pairs(MODULE_INPUT_EVENTS) do
      software_function(V4)
    end
  end
end

-- Read disk event
function readDiskEvent()
  if type(V3) == "string" then
    -- Software install mode
    if software_install_mode then
      installSoftware(V3)
      software_install_mode = false
    end

    -- Software update mode
    if software_update_mode then
      updateSoftware(V3)
      software_update_mode = false
    end

    -- Softwares events
    if not software_install_mode and not software_update_mode and not software_uninstall_mode then
      for software_name, software_function in pairs(READ_DISK_INPUT_EVENTS) do
        software_function(V3)
      end
    end
  end
end
--#endregion

--#region Editor

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

-- Go history down
function goHistoryDown()
  if commands_history_index <= #commands_history then
    commands_history_index = commands_history_index + 1

    if commands_history_index == #commands_history + 1 then
      current_editor_text = ""
      current_cursor_position = 1
    else
      current_editor_text = commands_history[commands_history_index]
      current_cursor_position = string.len(current_editor_text) + 1
    end

    blink = true
  end
end

-- Go history up
function goHistoryUp()
  if commands_history_index > 1 then
    commands_history_index = commands_history_index - 1
    current_editor_text = commands_history[commands_history_index]
    current_cursor_position = string.len(current_editor_text) + 1
    blink = true
  end
end

-- Blink cursor Loop
function blinkLoop()
  if blink_timer >= 15 then
    blink_timer = 0
    blink = not blink
  else
    blink_timer = blink_timer + 1
  end
end

function textEditor()
  local displayed_text =  command_symbol .. current_editor_text

  if current_cursor_position > MAX_LINE_DISPLAY_LENGTH then
    displayed_text = separateStringEnd(displayed_text, (string.len(command_symbol) + current_cursor_position) - MAX_LINE_DISPLAY_LENGTH)
    displayed_text = separateString(displayed_text, MAX_LINE_DISPLAY_LENGTH + 1 + string.len(command_symbol), colorizeText("|", rgbToHex(blink and BLINK_COLOR or BACKGROUND_COLOR)))
  else
    displayed_text = separateString(displayed_text, current_cursor_position + string.len(command_symbol), colorizeText("|", rgbToHex(blink and BLINK_COLOR or BACKGROUND_COLOR)))
  end

  return displayed_text
end

-- Display lines
function displayLines()
  local lines_text = ""

  -- If editor is disabled
  if disable_editor then
    if #lines > MAX_LINE_NUMBER then
      ShiftBackwardsArray(lines)
    end

    for i = 1, #lines do
      lines_text = lines_text .. SEPARATOR .. lines[i]
    end

    return lines_text
  else
    if #lines > MAX_LINE_NUMBER - 1 then
      ShiftBackwardsArray(lines)
    end

    for i = 1, #lines do
      lines_text = lines_text .. SEPARATOR .. lines[i]
    end

    return lines_text .. SEPARATOR .. textEditor()
  end
end

-- Add line
function addLine(line)
  table.insert(lines, line)
end

--#endregion

--#region Commands

-- Submit command
function submitCommand()
  table.insert(commands_history, current_editor_text)
  commands_history_index = #commands_history + 1
  executeCommand(current_editor_text)
  deleteEditorText()
end

-- Execute command
function executeCommand(command_text)
  -- Split to args
  local args = split(command_text, " ")

  if #args > 0 then
    if args[1] == "help" then
      helpCommand(ShiftBackwardsArray(args))
    elseif args[1] == "restart" then
      -- Update os
      output(16, 1) -- Update os adress
    elseif args[1] == "clear" then
      clearCommand()
    elseif args[1] == "version"  then
      versionCommand()
    elseif args[1] == "send"  then
      sendCommand(args)
    elseif args[1] == "override" then
      overrideScreenSwitch()
    elseif args[1] == "software"  then
      softwareCommand(args)
    elseif args[1] == "save"  then
      saveOSCommand()
    elseif SOFTWARES_COMMANDS[args[1]] ~= nil then
      local software_command = args[1]

      -- Remove software command
      ShiftBackwardsArray(args)
      SOFTWARES_COMMANDS[software_command](args)
    else
      addLine(colorizeText("Command not found", rgbToHex(ERROR_COLOR)))
    end
  end
end

-- Clear command
function clearCommand()
  lines = {}
end

--#region Help command
function helpCommand(args)
  -- Get the number of help pages
  pages_number = #HELP_PAGES

  current_global_page = tonumber(args[1])

  -- Global help pages
  if current_global_page ~= nil then
    -- Page found
    if current_global_page >= 0 and current_global_page < pages_number then
      displayHelpPage(HELP_PAGES[current_global_page+1], current_global_page, pages_number)
    -- Page not found
    else
      addLine(colorizeText("Help page not found", rgbToHex({255, 0, 0})))
    end
  -- Software help pages
  elseif SOFTWARES_HELP_PAGES[args[1]] ~= nil then
    current_software_help_pages = SOFTWARES_HELP_PAGES[args[1]]

    -- Software pages found
    if current_software_help_pages ~= nil then
      current_software_pages_number = #current_software_help_pages
      current_software_page = tonumber(args[2])
      if current_software_page ~= nil then
        -- Software pages found
        if current_software_page >= 0 and current_software_page < current_software_pages_number then
          displayHelpPage(current_software_help_pages[current_software_page+1], current_software_page, current_software_pages_number)
        else
          -- Software pages not found
          addLine(colorizeText("Help page not found", rgbToHex({255, 0, 0})))
        end
      elseif current_software_pages_number > 0 then
        displayHelpPage(current_software_help_pages[1], 0, current_software_pages_number)
      else
        -- Software pages not found
        addLine(colorizeText("Help page not found", rgbToHex({255, 0, 0})))
      end
    else
      -- Software pages not found
      addLine(colorizeText("Help page not found", rgbToHex({255, 0, 0})))
    end
  elseif #args > 0 then
    -- Software pages not found
    addLine(colorizeText("Help page not found", rgbToHex({255, 0, 0})))
  else
    displayHelpPage(HELP_PAGES[1], 0, pages_number)
  end
end

-- Display help page
function displayHelpPage(help_lines, current_page, pages_number)
  addLine(tostring(current_page) .. "/" .. tostring(pages_number-1))

  for index, line in pairs(help_lines) do
    addLine(line)
  end
end

--#endregion

-- Version command
function versionCommand()
  addLine("Plasma OS v" .. VERSION)
end

-- Send command
function sendCommand(args)
  -- Concatenate args
  local args_text = ""
  for i = 2, #args do
    if i >= #args then
      args_text = args_text .. args[i]
    else
      args_text = args_text .. args[i] .. " "
    end
  end

  output(24, 1) -- Network write adress
  output(args_text, 2)
end

-- Override screen
function overrideScreenSwitch()
  override_screen = not override_screen
  write_var(override_screen, "override")

  if override_screen then
    addLine(colorizeText("Override screen activated", rgbToHex({0, 255, 0})))
  else
    addLine(colorizeText("Override screen deactivated", rgbToHex({0, 255, 0})))
  end
end

-- Software command
function softwareCommand(args)
  if #args > 1 then
    if args[2] == "list" then
      addLine("List of softwares:")
      for name, data in pairs(SOFTWARES) do
        addLine(name .. " v" .. data["version"])
      end
    elseif args[2] == "install" then
      software_install_mode = true
      output(13, 1) -- Read disk adress
    elseif args[2] == "update" then
      software_update_mode = true
      output(13, 1) -- Read disk adress
    elseif args[2] == "uninstall" then
      if #args >= 3 then
        uninstallSoftware(args[3])
      else
        addLine(colorizeText("Missing argument", rgbToHex(ERROR_COLOR)))
      end
    else
      addLine(colorizeText("Command not found", rgbToHex(ERROR_COLOR)))
    end
  end
end

-- Save OS command
function saveOSCommand()
  output(23, 1) -- Write disk adress
  output(OS_DISK_SEPARATOR .. read_var("os"), 2)
end

--#endregion

--#region Softwares

-- Load softwares
function loadSoftwares()
  for software_name, data in pairs(SOFTWARES) do
    -- Add software events
    if data["events"] ~= nil then
      local events = data["events"]

      for index, event in pairs(events) do
        addSoftwareEvent(software_name, event)
      end
    end

    -- Add software commands
    if data["commands"] ~= nil then
      local commands = data["commands"]


      for index, command in pairs(commands) do
        SOFTWARES_COMMANDS[command["command"]] = command["function"]
      end
    end
  end
end

-- Add software event
function addSoftwareEvent(software_name, event)
  if event["event"] == "KEYBOARD_INPUT" then
    KEYBOARD_INPUT_EVENTS[software_name] = event["function"]
  elseif event["event"] == "NETWORK_INPUT" then
    NETWORK_INPUT_EVENTS[software_name] = event["function"]
  elseif event["event"] == "MODULE_INPUT" then
    MODULE_INPUT_EVENTS[software_name] = event["function"]
  elseif event["event"] == "DISK_INPUT" then
    DISK_INPUT_EVENTS[software_name] = event["function"]
  elseif event["event"] == "SETUP" then
    SETUP_EVENTS[software_name] = event["function"]
  elseif event["event"] == "LOOP" then
    LOOP_EVENTS[software_name] = event["function"]
  end
end

-- Install software
function installSoftware(data)
  local software_name,software_data = stringToSoftwareData(data)

  if software_name ~= nil and software_data ~= nil then
    local current_os = read_var("os")
    local os_parts =  split(current_os, SOFTWARES_SEPARATOR)
    local os_array, os_part1 = ShiftBackwardsArray(os_parts)
    local softwares_array, os_part2 = ShiftBackwardsArray(os_array)
    local final_os = {os_part1 .. SOFTWARES_SEPARATOR .. os_part2}

    -- Check if there is no software on the computer
    if #softwares_array == 0 then
      table.insert(final_os, data)

      write_var(table.concat(final_os, "--" .. SOFTWARES_SEPARATOR), "os")

      -- Update os
      output(16, 1) -- Update os adress
    else
      -- Check if the software is already installed
      local software_already_installed = false

      for index, part in pairs(softwares_array) do
        local current_software_name, current_software_data = cleanedToSoftwareData(part)

        if current_software_name ~= nil and current_software_data ~= nil  then
          if  current_software_name == software_name then
            software_already_installed = true
          else
            table.insert(final_os, part)
          end
        end
      end

      if not software_already_installed then
        table.insert(final_os, data)

        write_var(table.concat(final_os, "--" .. SOFTWARES_SEPARATOR), "os")

        -- Update os
        output(16, 1) -- Update os adress
      else
        addLine(colorizeText("The software is already installed", rgbToHex(INFO_COLOR)))
      end
    end
  else
    addLine(colorizeText("The software is invalid", rgbToHex(ERROR_COLOR)))
  end
end

-- Update software
function updateSoftware(data)
  local software_name,software_data = stringToSoftwareData(data)

  if software_name ~= nil and software_data ~= nil then
    local current_os = read_var("os")
    local os_parts =  split(current_os, SOFTWARES_SEPARATOR)
    local os_array, os_part1 = ShiftBackwardsArray(os_parts)
    local softwares_array, os_part2 = ShiftBackwardsArray(os_array)
    local final_os = {os_part1 .. SOFTWARES_SEPARATOR .. os_part2}

    -- Check if there is no software on the computer
    if #softwares_array == 0 then
      addLine(colorizeText("The software is not installed", rgbToHex(INFO_COLOR)))
    else
      -- Check if the software is already installed
      local software_index = -1

      for index, part in pairs(softwares_array) do
        local current_software_name, current_software_data = cleanedToSoftwareData(part)

        if current_software_name ~= nil and current_software_data ~= nil and current_software_name == software_name then
          software_index = index
        end
      end

      if software_index ~= -1 then
        softwares_array[software_index] = data

        -- Add all softwares to the final os
        for index, part in pairs(softwares_array) do
          table.insert(final_os, part)
        end

        write_var(table.concat(final_os, "--" .. SOFTWARES_SEPARATOR), "os")

        -- Update os
        output(16, 1) -- Update os adress
      else
        addLine(colorizeText("The software is not installed", rgbToHex(INFO_COLOR)))
      end
    end
  else
    addLine(colorizeText("The software is invalid", rgbToHex(ERROR_COLOR)))
  end
end

-- Uninstall software
function uninstallSoftware(software_name)
  local current_os = read_var("os")
  local os_parts =  split(current_os, SOFTWARES_SEPARATOR)
  local os_array, os_part1 = ShiftBackwardsArray(os_parts)
  local softwares_array, os_part2 = ShiftBackwardsArray(os_array)
  local final_os = {os_part1 .. SOFTWARES_SEPARATOR .. os_part2}

  -- Check if the software is already installed
  local software_index = -1

  for index, part in pairs(softwares_array) do
    local current_software_name, current_software_data = cleanedToSoftwareData(part)

    if current_software_name ~= nil and current_software_data ~= nil and current_software_name == software_name then
      software_index = index
    end
  end

  if software_index ~= -1 then
    softwares_array[software_index] = nil

    -- Remove nil values
    removeArrayNils(softwares_array)

    -- Add all softwares to the final os
    for index, part in pairs(softwares_array) do
      table.insert(final_os, part)
    end

    write_var(table.concat(final_os, "--" .. SOFTWARES_SEPARATOR), "os")

    -- Update os
    output(16, 1) -- Update os adress
  else
    addLine(colorizeText("The software is not installed", rgbToHex(INFO_COLOR)))
  end
end

-- String to software data
function stringToSoftwareData(data)
  local cleaned_data = split(data, SOFTWARES_SEPARATOR, 1)
  
  if #cleaned_data == 2 then
    return cleanedToSoftwareData(cleaned_data[2])
  end
end

-- Cleaned to software data
function cleanedToSoftwareData(data)
  local software_data = split(data, SOFTWARES_DATA_SEPARATOR, 1)

  if #software_data == 2 then
    local software_name = software_data[1]:gsub("-", "")
    software_name = software_name:gsub("%s+", "")
    return software_name, software_data[2]
  end
end

--#endregion

--#region Setup
function setup()
  -- Utility variable
  start_check = true
  override_screen = read_var("override")
  refresh_tick = 0

  -- Lines variables
  lines = {}

  -- Blink cursor variables
  blink = false
  blink_timer = 0

  -- Start infos display
  addLine(colorizeText("Plasma OS v" .. VERSION, rgbToHex(INFO_COLOR)))

  -- Text editor variables
  disable_editor = false
  command_symbol =  colorizeText("$", rgbToHex(COMMAND_SYMBOL_COLOR)) .. " "
  current_editor_text = ""
  current_cursor_position = 1
  current_text_offset = 1

  -- Commands variables
  commands_history = {}
  commands_history_index = 0
  disable_commands = false

  -- Softwares variables
  software_install_mode = false
  software_update_mode = false

  -- Load softwares
  loadSoftwares()

  -- Softwares events
  for software_name, software_function in pairs(SETUP_EVENTS) do
    software_function(splited_data)
  end
end
--#endregion

--#region Loop
function loop()
  -- Check if the start_check variable is not nil or false
  if start_check then
    -- Softwares events
    for software_name, software_function in pairs(LOOP_EVENTS) do
      software_function(splited_data)
    end

    if not override_screen then
      blinkLoop()

      if refresh_tick == 0 then
        output(12, 1) -- Display lines bus adress
        output(displayLines(), 2)
      end

      refresh_tick = refresh_tick + 1

      if refresh_tick >= 2 then
        refresh_tick = 0
      end
    end
  end
end
--#endregion

--#region Default softwares

--#endregion