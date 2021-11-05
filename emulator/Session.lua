local config = require "config"
local json = require "deps.json"
local utils = require "utils"
local session = {}

function session.load_session(game_names)
    -- load the session from the session file
    local data = json.decode(utils.readfile(config.session_file))
    if data.current_game == nil then
        data.current_game = game_names[1]
        data.games = {}
        session.save_session()
    end
    session.data = data

    return table.getn(session.data.games) == 0
end

function session.save_session()
    utils.writefile(config.session_file, json.encode(session.data))
end

function session.save_state()
    -- run any game-specifc pre save code
    require("games." .. session.data.current_game).pre_save()

    -- save the bizhawk state
    local save_file = config.session_dir .. "\\states\\" .. session.data.current_game .. "-retroverse.State"
    savestate.save(save_file)
    print("state saved at " .. save_file)
end

function session.load_game(new_game)
    session.save_state()
    session.data.current_game = new_game
    session.save_session()

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

function session.next_game()
    local new_index = session.getGameIndex(session.data.current_game) + 1
    if new_index > #session.data.games then
        new_index = 1
    end
    return session.data.games[new_index].name
end

-- HELPERS --
function session.getGameData(name)
    for i,o in pairs(session.data.games) do
        if o.name == name then
            return o
        end
    end
    return nil
end

function session.getGameIndex(name)
    local index = 1
    for i,v in pairs(session.data.games) do
        if v.name == name then
            return index
        else
            index = index + 1
        end
    end
    return nil
end

return session