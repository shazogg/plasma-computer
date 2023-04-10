-- Send a signal when the world is loaded
function setup()
	start_check = true
end

function loop()
	if start_check == nil then
		output(nil, 1)
	end
end