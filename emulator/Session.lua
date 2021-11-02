local config = require "config"
local json = require "json"
local utils = require "utils"
local session = {}

function session.id()
	if userdata.containskey("session_id") then
        return userdata.get("session_id")
    else
        local session_id = utils.trim(utils.readfile(config.session_file))
        userdata.set("session_id", session_id)
        return session_id
    end
end

function session.dir()
    return config.tmp_dir .. "\\" .. session.id()
end

function session.game()
    return session._data.currentGame
end

session._data = nil
function session.data()
    if session._data == nil then
        session.load_session()
    end
    return session._data
end

function session.load_session(games)
    print("session_staarted: " .. (userdata.get("session_started") or "nil"))
    userdata.set("session_started", true)
	if userdata.get("session_data") == nil then
        print("creating new session")
        session._data = {
            id=session.id(),
            currentGame=games[1],
            games=games
        }
        session.save_session()
    else
        print("retrieving session from userdata")
        session._data = json.decode(userdata.get("session_data"))
    end

	-- print(utils.inspect(session._data))
end

function session.save_session()
    userdata.set("session_data", json.encode(session._data))
    print(utils.inspect(userdata.get("session_data")))
    print("session saved to userdata")
end

function session.save_state()
    -- run any game-specifc pre save code
    require("games." .. session.game()).pre_save()

    -- save the bizhawk state
    local save_file = session.dir() .. "\\states\\" .. session.game() .. "-retroverse.State"
    savestate.save(save_file)
    print("state saved at " .. save_file)
end

function session.load_game(new_game)
    session.save_state()
    session._data.currentGame = new_game
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
    local new_index = utils.indexOf(session._data.games, session.game()) + 1
    if new_index > #session._data.games then
        new_index = 1
    end
    return session._data.games[new_index]
end

return session