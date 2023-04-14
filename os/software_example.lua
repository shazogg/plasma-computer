--!soft§!

--SOFTWARE_NAME!soft_data§!
function FUNCTION_NAME()
  
end


-- Test software

--!soft§!
--test!soft_data§!
function test(data)
  print(data)
end

softwares["test"] = {
  ["version"] = "1.0",
  ["author"] = "shazogg",
  ["description"] = "test description",
  ["events"] = {
    {
      ["event"] = "KEYBOARD_INPUT",
      ["function"] = test
    }
  }
}