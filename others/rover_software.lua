--FILE!disk§!
--!soft§!
--rover!soft_data§!

-- Separators
ROVER_SEPARATOR = "!§!"

-- Functions
function roverModuleInData(data)
  if data ~= nil then
    -- Split data
    local splited_data = split(data, ROVER_SEPARATOR)

    -- Remove nil values
    splited_data = removeArrayNils(splited_data)

    if getDictionarySize(splited_data) >= 1 and splited_data[1] == "CAMOFF" then
      roverOffCamera()
    end
  end
end

-- Commands
function roverFrontCamera(data)
  local data_array = {"CAMF"}
  local data_string = mergeArrayToString(data_array)

  -- Override screen
  override_screen = true
  write_var(override_screen, "override")

  -- Output
  output(data_string, 7)
end

function roverRearCamera(data)
  local data_array = {"CAMR"}
  local data_string = mergeArrayToString(data_array)

  -- Override screen
  override_screen = true
  write_var(override_screen, "override")

  -- Output
  output(data_string, 7)
end

function roverOffCamera(data)
  local data_array = {"CAMOFF"}
  local data_string = mergeArrayToString(data_array)

  -- Override screen
  override_screen = false
  write_var(override_screen, "override")

  -- Output
  output(data_string, 7)
end

function roverGlassOpacity(data)
  local data_array = {"GLASSOPA", ROVER_SEPARATOR}

  if data ~= nil then
    for _, val in ipairs(data) do
      table.insert(data_array, val)
    end
  end

  local data_string = mergeArrayToString(data_array)
  output(data_string, 7)
end

function roverMotd(data)
  local data_array = {"BACKMOTD", ROVER_SEPARATOR}

  if data ~= nil then
    for _, val in ipairs(data) do
      table.insert(data_array, val)
    end
  end

  local data_string = mergeArrayToString(slice(data_array, 1, 2)) .. mergeArrayToString(slice(data_array, 3, -1), " ")
  output(data_string, 7)
end

PACKAGES["rover"] = {
  ["version"] = "1.2.0",
  ["author"] = "shazogg",
  ["description"] = "The rover package",
  ["events"] = {
    {
      ["event"] = "MODULE_INPUT",
      ["function"] = roverModuleInData
    },
  },
  ["commands"] = {
    {
      ["command"] = "camf",
      ["function"] = roverFrontCamera
    },
    {
      ["command"] = "camr",
      ["function"] = roverRearCamera
    },
    {
      ["command"] = "camoff",
      ["function"] = roverOffCamera
    },
    {
      ["command"] = "glass",
      ["function"] = roverGlassOpacity
    },
    {
      ["command"] = "motd",
      ["function"] = roverMotd
    },
  }
}

PACKAGES_HELP_PAGES["rover"] = {
  {
    "example package, page 1"
  }
}