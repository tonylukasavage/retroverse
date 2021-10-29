import os
from romgen.generator import generate
from romgen.utils import mkdirp

# have to use 2.5.2, but I can't remember why, something was broken in a later version
BIZHAWK_VERSION = "2.5.2"
ROM_DEFAULT = "cv2-retroverse.nes"

# define key paths
cwd = os.getcwd()
tmp_dir = os.path.join(cwd, "tmp")
rom = os.path.join(tmp_dir, ROM_DEFAULT)
bin = os.path.join(cwd, "tools", "bizhawk", BIZHAWK_VERSION, "Emuhawk.exe")

# create dist (tmp) directory and generate the rom(s)
mkdirp(tmp_dir)
generate(['cv2', 'metroid'])

# launch bizhawk with roms and retroverse lua scriptingg
script = "--lua=" + os.path.join(cwd, "emulator", "retroverse.lua")
cmd = " ".join([bin, rom, script])
os.system(cmd)
