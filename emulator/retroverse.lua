local utils = require "utils"
local session = require "session"

-- TODO: pick the games from some bizhawk interface
local game_names = { "cv2", "metroid" }

-- load the session or create a new one
local isNew = session.load_session(game_names)

-- store game-specific modules
local modules = {}
for i,v in pairs(game_names) do
    modules[v] = require("games." .. v)

    -- load game-specific data into session
    local mod = modules[v]
    mod.init()

    -- if this is the first load, create the default values from the module to populate the session
    if isNew then
        print("Creating new game-specific session data for " .. v)
        table.insert(session.data.games, {
            name=v,
            items=utils.map(mod.data.items, function(item) return {
                id=item.id,
                name=item.name,
                isOwned=item.isOwned
            } end)
        })
    end
end

print(utils.inspect(session.data))

while true do
    -- see if warp conditions are met for current game
    if modules[session.data.current_game].warp_check(session) then
        session.load_game(session.next_game())
    end

    -- continue emulation
	emu.frameadvance();
end
