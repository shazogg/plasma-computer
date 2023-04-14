--!soft§!
--test!soft_data§!
function test(data)

end

SOFTWARES["test"] = {
  ["version"] = "1.5",
  ["author"] = "shazogg",
  ["description"] = "test description",
  ["events"] = {
    {
      ["event"] = "KEYBOARD_INPUT",
      ["function"] = test
    }
  },
  ["help"] = {
    "1"
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