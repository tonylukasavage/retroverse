local json = require "json"
local utils = {}

function utils.readfile(path)
	local file = open(path, "r")
	if not file then return nil end
	local content = file:read "*a"
	file:close()
	return content
end

function utils.decodeJsonFile(path)
	local content = utils.readfile(path)
	return json.decode(content)
end