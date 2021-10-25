import os
from main.generator import generate

BIZHAWK_VERSION = "2.5.2"
ROM_DEFAULT = "cv2-retroverse.nes"

cwd = os.getcwd()

generate(['cv2', 'metroid'])

bin = os.path.join(cwd, "bizhawk", BIZHAWK_VERSION, "Emuhawk.exe")
rom = os.path.join(cwd, "tmp", ROM_DEFAULT)
script = "--lua=" + os.path.join(cwd, "emulator", "retroverse.lua")
cmd = " ".join([bin, rom, script])
print(cmd)
os.system(cmd)
