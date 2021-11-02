local config = require "config"
local json = require "json"
local utils = require "utils"
local session = {}

function session.dir()
    return config.tmp_dir .. "\\" .. session.data.session_id
end

function session.load_session(games)
    local data = json.decode(utils.readfile(config.session_file))
    if data.current_game == nil then
        data.current_game = games[1]
        data.games = games
        session.save_session()
    end
    session.data = data
    print(session.data)
end

function session.save_session()
    utils.writefile(config.session_file, json.encode(session.data))
end

function session.save_state()
    -- run any game-specifc pre save code
    require("games." .. session.data.current_game).pre_save()

    -- save the bizhawk state
    local save_file = session.dir() .. "\\states\\" .. session.data.current_game .. "-retroverse.State"
    savestate.save(save_file)
    print("state saved at " .. save_file)
end

function session.load_game(new_game)
    session.save_state()
    session.data.current_game = new_game
    session.save_session()

    -- load the rom for the new game
    local rom_path = session.dir() .. "\\roms\\" .. new_game .. "-retroverse.nes"
    print("opening rom " .. rom_path)
    client.openrom(rom_path);
    client.displaymessages(false);

    -- load the last state for the newly loaded game
    local save_file = session.dir() .. "\\states\\" .. new_game .. "-retroverse.State"
    if utils.file_exists(save_file) then
        print("loading savefile " .. save_file)
        savestate.load(save_file)
    end
    print("loaded rom " .. rom_path)
end

function session.next_game()
    local new_index = utils.indexOf(session.data.games, session.data.current_game) + 1
    if new_index > #session.data.games then
        new_index = 1
    end
    return session.data.games[new_index]
end

return session