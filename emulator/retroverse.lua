local config = require "config"
local utils = require "utils"
local session = require "session"

-- load the session or create a new one
session.load_session()
print(utils.inspect(session.data))

-- store and initialize game-specific modules
local modules = {}
for i,v in pairs(config.games) do
    local name = v.name
    local id = v.id

    -- set id of next game in combo for transitioning purposes
    local next_id = id + 1
    if next_id > #config.games then
        next_id = 1
    end

    -- load and instantiate the game module
    modules[name] = (require("games.Game" .. utils.first_to_upper(name))):new(nil, id, next_id, session)
end

-- update in-game items by writing them to RAM
local current_game = modules[session.data.current_game_name]
local next_game_name = utils.find(config.games, function(g) return g.id == current_game.next_id end).name
current_game:update_inventory()

while true do
    -- see if warp conditions are met for current game
    if current_game.warp_check() then
        session.load_game(next_game_name, modules)
    end

    -- see if there's items to update
    local target_game_id, target_item_id, target_value = unpack(current_game:item_check())
    if target_game_id ~= 0 then
        local target_game_name = utils.find(config.games, function(g) return g.id == target_game_id end).name
        local target_mod = modules[target_game_name]
        local target_item = target_mod:get_item_by_id(target_item_id)
        if target_item ~= nil then
            target_item.is_owned = target_value > 0
            if target_game_name == current_game.name then
                target_mod:update_item_in_game(target_item)
            end
            print("updated " .. target_game_name .. " " .. target_item.name .. " to " .. tostring(target_item.is_owned))
        end
        current_game:item_uncheck()
    end

    -- continue emulation
	emu.frameadvance()
end
