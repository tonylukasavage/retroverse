import os

BIZHAWK_VERSION = "2.5.2"
ROM_DEFAULT = "cv2.nes"

cwd = os.getcwd()
bin = os.path.join(cwd, "bizhawk", BIZHAWK_VERSION, "Emuhawk.exe")
rom = os.path.join(cwd, "roms", ROM_DEFAULT)
script = "--lua=" + os.path.join(cwd, "lua", "retroverse.lua")
cmd = " ".join([bin, rom, script])
print(cmd)
os.system(cmd)
