local Game = require "Game"
local Session = {}

Session.new = function(games)
	local self = {}

	self.games = {}
	for i,g in pairs(games) do
		table.insert(self.games, Game.new(g))
	end

	function self.start()
		self.games[0].load(true)
	end

	return self
end

return Session