--!soft§!
--SOFTWARE_NAME!soft_data§!

SOFTWARES["SOFTWARE_NAME"] = {
  ["version"] = "1.0.0",
  ["author"] = "shazogg",
  ["description"] = "Description",
  ["events"] = {
    {
      ["event"] = "KEYBOARD_INPUT",
      ["function"] = example1
    },
    {
      ["event"] = "NETWORK_INPUT",
      ["function"] = example2
    },
  }
}

SOFTWARES_HELP_PAGES["SOFTWARE_NAME"] = {
  {
    "example software, page 1",
    "- example2: to test this too, page 1"
  },
  {
    "example software, page 2",
    "- example2: to test this too"
  }
}

-- Example functions
function example1(data)
  print(data)
end

function example2(data)
  print(data)
end

