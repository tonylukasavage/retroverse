local json = require "json"
local utils = require "utils"

local tmp_dir = "..\\tmp"
local session_id
local session_dir
local session

function loadSession(game)
	userdata.set("started", true)
	if userdata.get("session") == nil then
		session = {
			id=session_id,
			currentGame=game,
			games={
				cv2={
					name="cv2",
					inventory={}
				},
				metroid={
					name="metroid",
					inventory={}
				}
			}
		}
	else
		session = json.decode(userdata.get("session"))
		if game ~= nil then
			session.currentGame = game
		end
	end

	saveSession(session.currentGame, false)
	print(utils.inspect(session))
end

function saveSession(game, doSaveState)
	if game ~= nill then
		session.currentGame = game
	end
	userdata.set("session", json.encode(session))

	if doSaveState then
		save_file = session_dir .. "\\states\\" .. session.currentGame .. "-retroverse.State"
		if session.currentGame == "metroid" then
			-- set state to samus intro
			memory.writebyte(0x1E, 0x00)

			-- advance 4 frames so that the samus intro kicks in before the combo checks
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
		end
		savestate.save(save_file)
		print("state saved at " .. save_file)
	end
end

function loadGame(new_game)
		saveSession(session.currentGame, true)

		local rom_path = session_dir .. "\\roms\\" .. new_game .. "-retroverse.nes"
		print("opening rom " .. rom_path)
		client.openrom(rom_path);
		client.displaymessages(false);

		save_file = session_dir .. "\\states\\" .. new_game .. "-retroverse.State"
		if utils.file_exists(save_file) then
			print("loading savefile " .. save_file)
			savestate.load(save_file)
		end

		print("loaded rom " .. rom_path)
end

-- load session id
session_file = tmp_dir .. "\\" .. ".retroverse_session"
session_id = string.gsub(utils.readfile(session_file), "%s+", "")
session_dir = tmp_dir .. "\\" .. session_id

-- load the session or create a new one
if userdata.get("started") == nil then
	loadSession("cv2")
else
	loadSession()
end

while true do
	if session.currentGame == "cv2" and memory.readbyte(0x6000) == 1 then
		memory.writebyte(0x6000, 0)
		userdata.set("metroid_first", 1)
		loadGame("metroid")
	end

	if session.currentGame == "metroid"
		and memory.readbyte(0x4F) == 0x0E
		and memory.readbyte(0x50) == 0x01
		and memory.readbyte(0x52) >= 0xDD
		and memory.readbyte(0x51) < 0x50 then
			loadGame("cv2")
	end

	emu.frameadvance();
end
