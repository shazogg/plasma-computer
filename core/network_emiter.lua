-- Global variables
OUTPUT_NUMBER = 2
SEPARATOR = "!net§!"

-- Create variables
input_data = V1
data_output = nil
data = ""

-- Split the input data
splited_data = input_data:split(SEPARATOR)

-- Check if the data is valid
if #splited_data == 2 then
  data_output = tonumber(splited_data[1])
  data = splited_data[2]

  -- Output data
  if data_output ~= nil then
    if data_output > 0 and data_output <= OUTPUT_NUMBER then
      output(data, data_output)
    else
      error("data output wrong id", 1)
    end
  else
    error("data output invalid", 1)
  end

else
  error('data badly formated', 1)
end