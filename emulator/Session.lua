local config = require "config"
local json = require "deps.json"
local utils = require "utils"
local session = {}

function session.load_session()
    -- load the session from the session file
    local data = json.decode(utils.readfile(config.session_file))

    -- if there is no previous session, create a skeleton one
    if data.current_game_name == nil then
        data.current_game_name = config.start_game
    end
    session.data = data
end

function session.save_session(modules)
    -- put all serializable data from each game into the session data
    session.data.games = {}
    for i,mod in pairs(modules) do
        local game_data = {
            name = mod.name,
            items = {}
        }
        for j,item in pairs(mod.items) do
            table.insert(game_data.items, {
                id = item.id,
                name = item.name,
                is_owned = item.is_owned
            })
        end
        table.insert(session.data.games, game_data)
    end

    print(utils.inspect(session.data))

    -- write all session data to JSON file to persist between loads
    utils.writefile(config.session_file, json.encode(session.data))
end

function session.save_state(mod)
    -- run any game-specifc pre save code
    mod.pre_save()

    -- save the bizhawk state
    local save_file = config.session_dir .. "\\states\\" .. session.data.current_game_name .. "-retroverse.State"
    savestate.save(save_file)
    print("state saved at " .. save_file)
end

function session.load_game(new_game, modules)
    session.save_state(modules[session.data.current_game_name])
    session.data.current_game_name = new_game
    session.save_session(modules)

    -- load the rom for the new game
    local rom_path = config.session_dir .. "\\roms\\" .. new_game .. "-retroverse.nes"
    print("opening rom " .. rom_path)
    client.openrom(rom_path);
    client.displaymessages(false);

    -- load the last state for the newly loaded game
    local save_file = config.session_dir .. "\\states\\" .. new_game .. "-retroverse.State"
    if utils.file_exists(save_file) then
        print("loading savefile " .. save_file)
        savestate.load(save_file)
    end
    print("loaded rom " .. rom_path)
end

return session