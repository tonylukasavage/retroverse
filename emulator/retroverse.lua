local session = require "session"

-- TODO: pick the games from some bizhawk interface

-- load the session or create a new one
local games = { "cv2", "metroid" }
session.load_session(games)

-- store game-specific modules
local modules = {}
for i,v in pairs(games) do
    modules[v] = require("games." .. v)
end

while true do
    -- see if warp conditions are met for current game
    if modules[session.data.current_game].warp_check(session) then
        session.load_game(session.next_game())
    end

    -- continue emulation
	emu.frameadvance();
end
