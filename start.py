from os import getcwd, system
from os.path import join
from romgen.generator import generate
from romgen.utils import mkdirp

# have to use 2.5.2, but I can't remember why, something was broken in a later version
BIZHAWK_VERSION = "2.5.2"
ROM_DEFAULT = "cv2-retroverse.nes"

# define key paths
cwd = getcwd()
bin = join(cwd, "tools", "bizhawk", BIZHAWK_VERSION, "Emuhawk.exe")

# create dist (tmp) directory and generate the rom(s)
rom_dir = join(cwd, 'roms')
session_id = generate(['cv2', 'metroid'], rom_dir, {"clean": True})

# launch bizhawk with roms and retroverse lua scriptingg
session_dir = join(cwd, "tmp")
rom = join(session_dir, 'roms', ROM_DEFAULT)
script = "--lua=" + join(cwd, "emulator", "retroverse.lua")
cmd = " ".join([bin, rom, script])
print(cmd)
system(cmd)
