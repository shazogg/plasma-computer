--!soft§!
--example!soft_data§!
function example(data)

end

SOFTWARES["example"] = {
  ["version"] = "1.0.0",
  ["author"] = "shazogg",
  ["description"] = "Description",
  ["events"] = {
    {
      ["event"] = "KEYBOARD_INPUT",
      ["function"] = example
    }
  }
}

SOFTWARES_HELP_PAGES["test"] = {
  {
    "- example: to test this"
  },
  {
    "- example2: to test this too"
  }
}