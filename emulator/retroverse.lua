local json = require "json"
local utils = require "utils"

local session
function loadSession(game)
	userdata.set("started", true)
	if userdata.get("session") == nil then
		session = {
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
	saveSession()
	-- print(utils.dump(session))
end

function saveSession(game)
	if game ~= nill then
		session.currentGame = game
	end
	userdata.set("session", json.encode(session))
	savestate.save("..\\tmp\\" .. session.currentGame .. ".State")
end

function loadGame(game)
		saveSession(game)

		local rom_path = "..\\tmp\\" .. game .. "-retroverse.nes"
		print("opening rom " .. rom_path)
		client.openrom(rom_path);
		client.displaymessages(false);

		save_file = "..\\tmp\\" .. game .. ".State"
		default_save_file = ".\\games\\"  .. game .. ".base.State"
		if utils.file_exists(save_file) then
			print("loading savefile " .. save_file)
			savestate.load(save_file)
		else
			print("loading savefile " .. default_save_file)
			savestate.load(default_save_file)
		end
		print("loaded rom " .. rom_path)
end

if userdata.get("started") == nil then
	loadSession("cv2")
else
	loadSession()
end

while true do
	if session.currentGame == "cv2" and memory.readbyte(0x6000) == 1 then
		memory.writebyte(0x6000, 0)
		loadGame("metroid")
	end
	emu.frameadvance();
end
