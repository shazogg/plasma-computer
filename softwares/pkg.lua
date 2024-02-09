--FILE!disk§!
--!soft§!
--pkg!soft_data§!

--#region Global variables

-- Separators
PACKAGES_SEPARATOR = "--!" .. "soft§!"         -- Concatenation avoid self split
PACKAGES_DATA_SEPARATOR = "!soft_" .. "data§!" -- Concatenation avoid self split

-- Packages variables
package_install_mode = false
package_update_mode = false

--#endregion


--#region Utils

-- String to package data
function stringToPackageData(data)
  local cleaned_data = split(data, PACKAGES_SEPARATOR, 1)

  if #cleaned_data == 2 then
    return cleanedToPackageData(cleaned_data[2])
  end
end

-- Cleaned to package data
function cleanedToPackageData(data)
  local package_data = split(data, PACKAGES_DATA_SEPARATOR, 1)

  if #package_data == 2 then
    local package_name = package_data[1]:gsub("-", "")
    package_name = package_name:gsub("%s+", "")
    return package_name, package_data[2]
  end
end

-- Pkg command
function pkgCommand(args)
  if #args > 0 then
    if args[1] == "list" then
      addLine("List of packages:")
      for name, data in pairs(PACKAGES) do
        addLine(name .. " v" .. data["version"])
      end
    elseif args[1] == "install" then
      package_install_mode = true
      output(13, 1) -- Read disk adress
    elseif args[1] == "update" then
      package_update_mode = true
      output(13, 1) -- Read disk adress
    elseif args[1] == "uninstall" then
      if #args >= 2 then
        uninstallPackage(args[2])
      else
        addLine(colorizeText("Missing argument", rgbToHex(ERROR_COLOR)))
      end
    else
      addLine(colorizeText("Command not found", rgbToHex(ERROR_COLOR)))
    end
  end
end

--#endregion

--#region Package functions

-- Install package
function installPackage(data)
  local package_name, package_data = stringToPackageData(data)

  if package_name ~= nil and package_data ~= nil then
    local packages_array = split(read_var("packages"), PACKAGES_SEPARATOR)
    local final_packages_array = {}

    -- Check if there is no package on the computer
    if #packages_array == 0 then
      -- Add package to the packages array
      table.insert(final_packages_array, data)

      -- Write the packages array to packages memory
      write_var(table.concat(final_packages_array, PACKAGES_SEPARATOR), "packages")

      -- Reboot the computer
      output(16, 1) -- Reboot computer adress
    else
      -- Check if the package is already installed
      local package_already_installed = false

      -- Check if the package is already installed
      for index, part in pairs(packages_array) do
        local current_package_name, current_package_data = cleanedToPackageData(part)

        if current_package_name ~= nil and current_package_data ~= nil then
          if current_package_name == package_name then
            package_already_installed = true
          else
            table.insert(final_packages_array, part)
          end
        end
      end

      if not package_already_installed then
        -- Add package to the packages array
        table.insert(final_packages_array, data)

        -- Write the packages array to packages memory
        write_var(table.concat(final_packages_array, PACKAGES_SEPARATOR), "packages")

        -- Reboot the computer
        output(16, 1) -- Reboot computer adress
      else
        addLine(colorizeText("The package is already installed", rgbToHex(INFO_COLOR)))
      end
    end
  else
    addLine(colorizeText("The package is invalid", rgbToHex(ERROR_COLOR)))
  end
end

-- Update package
function updatePackage(data)
  local package_name, package_data = stringToPackageData(data)

  if package_name ~= nil and package_data ~= nil then
    local packages_array = split(read_var("packages"), PACKAGES_SEPARATOR)
    local final_packages_array = {}

    -- Check if there is no package on the computer
    if #packages_array == 0 then
      addLine(colorizeText("The package is not installed", rgbToHex(INFO_COLOR)))
    else
      -- Check if the package is already installed
      local package_index = -1

      for index, part in pairs(packages_array) do
        local current_package_name, current_package_data = cleanedToPackageData(part)

        if current_package_name ~= nil and current_package_data ~= nil and current_package_name == package_name then
          package_index = index
        end
      end

      if package_index ~= -1 then
        packages_array[package_index] = data

        -- Add all packages to the final os
        for index, part in pairs(packages_array) do
          table.insert(final_packages_array, part)
        end

        write_var(table.concat(final_packages_array, PACKAGES_SEPARATOR), "packages")

        -- Reboot the computer
        output(16, 1) -- Reboot computer adress
      else
        addLine(colorizeText("The package is not installed", rgbToHex(INFO_COLOR)))
      end
    end
  else
    addLine(colorizeText("The package is invalid", rgbToHex(ERROR_COLOR)))
  end
end

-- Uninstall package
function uninstallPackage(package_name)
  local packages_array = split(read_var("packages"), PACKAGES_SEPARATOR)
  local final_packages_array = {}

  -- Check if the package is already installed
  local package_index = -1

  for index, part in pairs(packages_array) do
    local current_package_name, current_package_data = cleanedToPackageData(part)
    if current_package_name ~= nil and current_package_data ~= nil and current_package_name == package_name then
      package_index = index
    end
  end

  if package_index ~= -1 then
    packages_array[package_index] = nil

    -- Remove nil values
    removeArrayNils(packages_array)

    -- Add all packages to the final os
    for index, part in pairs(packages_array) do
      table.insert(final_packages_array, part)
    end

    write_var(table.concat(final_packages_array, PACKAGES_SEPARATOR), "packages")

    -- Update os
    output(16, 1) -- Update os adress
  else
    addLine(colorizeText("The package is not installed", rgbToHex(INFO_COLOR)))
  end
end

-- Pkg disk event
function pkgDiskEvent(data)
  -- Package install mode
  if package_install_mode then
    installPackage(data)
    package_install_mode = false
  end

  -- Package update mode
  if package_update_mode then
    updatePackage(data)
    package_update_mode = false
  end
end

--#endregion

--#region Package data

PACKAGES["pkg"] = {
  ["version"] = "1.0.0",
  ["author"] = "shazogg",
  ["description"] = "Description",
  ["events"] = {
    {
      ["event"] = "DISK_INPUT",
      ["function"] = pkgDiskEvent
    },
  },
  ["commands"] = {
    {
      ["command"] = "pkg",
      ["function"] = pkgCommand
    },
  }
}

PACKAGES_HELP_PAGES["pkg"] = {
  {
    "example package, page 1",
    "- example2: to test this too, page 1"
  },
}

--#endregion
