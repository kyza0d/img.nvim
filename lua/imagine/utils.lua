local utils = {}

utils.concat = function(tab, seperator)
	if seperator == nil then
		return table.concat(tab)
	end
	local buffer = {}
	for i, v in ipairs(tab) do
		buffer[#buffer + 1] = v
		if i < #tab then
			buffer[#buffer + 1] = seperator
		end
	end
	return table.concat(buffer)
end

return utils
