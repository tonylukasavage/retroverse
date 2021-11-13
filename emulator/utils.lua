local inspect = require "deps.inspect"
local json = require "deps.json"
local utils = {}

function utils.readfile(path)
	local file = io.open(path, "r")
	if not file then return nil end
	local content = file:read "*a"
	file:close()
	return content
end

function utils.writefile(path, content)
    local file = io.open(path, "w" )
    file:write(content)
    file:close()
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

function utils.map(tbl, f)
    local t = {}
    for k,v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end

function utils.find(tbl, func)
    for i,v in pairs(tbl) do
        if func(v) then
            return v
        end
    end
    return nil
end

function utils.first_to_upper(str)
    return (str:gsub("^%l", string.upper))
end

function utils.write_or(item)
    local loc = item.loc
    local val = item.val
    local byte = memory.readbyte(loc)
    memory.writebyte(loc, item.is_owned and bit.bor(byte, val) or bit.band(bit.bnot(val), byte))
end

return utils