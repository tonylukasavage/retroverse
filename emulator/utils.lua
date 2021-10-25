local json = require "json"
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

function utils.dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
                if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s .. '['..k..'] = ' .. utils.dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function utils.file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

return utils