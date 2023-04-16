-- Global variables
SCREEN_HEIGHT = 512
TEXT_WIDTH = 672
TEXT_HEIGHT = 45
TEXT_X_OFFSET = 8
TEXT_Y_OFFSET = 10
FONT_SIZE = 30
DATA_SEPARATOR = "!display§!"
LINE_SEPARATOR = "!§!"

-- Split a string into a table of substrings
function split(str, sep)
  local tmp = str:gsub(sep, "\0")
  local segments = {}
  for segment in tmp:gmatch("[^%z]+") do
      table.insert(segments, segment)
  end
  return segments
end

-- Encode a table to JSON
function encodeJson(objet)
  local jsonText = "{"
  local firstKey = true
  for key, value in pairs(objet) do
    if not firstKey then
      jsonText = jsonText .. ","
    else
      firstKey = false
    end

    jsonText = jsonText .. '"' .. key .. '":'

    if type(value) == "string" then
      jsonText = jsonText .. '"' .. value .. '"'
    elseif type(value) == "number" then
      jsonText = jsonText .. value
    elseif type(value) == "table" then
      jsonText = jsonText .. encodeJson(value)
    end
  end

  jsonText = jsonText .. "}"

  return jsonText
end

-- Generate a UI text
function generateUiText(text, id, y)
  return {
    text = text,
    fontSize = FONT_SIZE,
    horizontalAlignment = 0,
    type = 1,
    id = id,
    x = TEXT_X_OFFSET,
    y = y,
    width = TEXT_WIDTH,
    height = TEXT_HEIGHT,
    colorR = 1.0,
    colorG = 1.0,
    colorB = 1.0
  }
end

-- Create variables
input_text = V1
final_json = ""
current_line_number = 0

-- Split the string
if input_text ~= nil then
  splited_data = split(input_text, DATA_SEPARATOR)
  splited_text = {}

  if #splited_data > 1 then
    splited_text = split(splited_data[2], LINE_SEPARATOR)

    splited_color = split(splited_data[1], ",")

    if #splited_color == 3 then
      output(color(tonumber(splited_color[1]), tonumber(splited_color[2]), tonumber(splited_color[3])), 2)
    else
      error("Color badly formated", 1)
    end
  else
    splited_text = split(splited_data[1], LINE_SEPARATOR)
  end

  if #splited_text > 0 then
    for i, value in pairs(splited_text) do
      final_json = final_json .. encodeJson(generateUiText(value, current_line_number, (SCREEN_HEIGHT - TEXT_Y_OFFSET) - (current_line_number + 1) * TEXT_HEIGHT)) .. ","
      current_line_number = current_line_number + 1
    end
  else
    error("data badly formated", 1)
  end

  -- Outupt the JSON
  final_json = "[" .. final_json .. "]"
  output(final_json, 1)
end