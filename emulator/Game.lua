local utils = require "utils"
local open = io.open
local Game = {}

Game.new = function(name)
	local self = {}

	self.name = name
	self.isPlaying = false
	self.state = utils.decodeJsonFile(".\\games\\" .. self.name .. ".json")
	self.stateFile = ".\\games\\" .. self.name .. ".State"

	function self.load(isStart=false)
		-- load rom
		client.openrom(".\\roms\\" .. self.name .. ".nes")
		client.displaymessages(false);

		-- load return state
		if not isStart and self.stateFile ~= nil then
			savestate.load(self.stateFile)
		end

		-- update inventory
		for key, value in pairs(self.state.inventory) do
			memory.writebyte(tonumber(key, 16), value)
		end
	end

	function self.unload()
		-- save inventiry
	end

	function self.udpateItem(name,

	return self
end

return Game