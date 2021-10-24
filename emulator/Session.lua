local Game = require "Game"
local Session = {}

Session.new = function(games)
	local self = {}

	self.games = {}
	for g in games do
		self.games.insert(Game.new(g))
	end

	function self.start()
		self.games[0].load(true)
	end

	return self
end

return Session