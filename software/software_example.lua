--FILE!disk§!
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
  },
  ["commands"] = {
    {
      ["command"] = "example1",
      ["function"] = example1
    },
    {
      ["command"] = "example2",
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








--FILE!disk§!
--!soft§!
--whatElse!soft_data§!
function test(data)
  print(data)
  table.insert(lines, "what the !")
end

SOFTWARES["test"] = {
  ["version"] = "1.5",
  ["author"] = "shazogg",
  ["description"] = "test description",
  ["events"] = {
    {
      ["event"] = "NETWORK_INPUT",
      ["function"] = test
    }
  },
  ["commands"] = {
    {
      ["command"] = "what",
      ["function"] = test
    },
  }
}

SOFTWARES_HELP_PAGES["test"] = {
  {
    "- test: to test this"
  },
  {
    "- test2: to test this too"
  }
}
