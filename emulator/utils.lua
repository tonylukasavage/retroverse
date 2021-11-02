local json = require "json"
local inspect = require "inspect"
local utils = {}

function utils.readfile(path)
	local file = io.open(path, "r")
	if not file then return nil end
	local content = file:read "*a"
	file:close()
	return content
end

function utils.decodeJsonFile(path)
	local content = utils.readfile(path)
	return json.decode(content)
end

function utils.inspect(o)
    return inspect(o)
end

function utils.file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function utils.current_dir()
    return io.popen"cd":read'*l'
end

function utils.trim(str)
    return string.gsub(str, "%s+", "")
end

function utils.indexOf(array, value)
    for i, v in pairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

return utils