-- Split a string into a table of substrings
function split(str, separator, occurrences)
  local tmp = str:gsub(separator, "\0", occurrences)
  local segments = {}
  for segment in tmp:gmatch("[^%z]+") do
      table.insert(segments, segment)
  end
  return segments
end