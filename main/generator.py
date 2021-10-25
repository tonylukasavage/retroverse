from importlib import import_module
from os import listdir
from os.path import isfile, join, dirname, abspath


def generate(games=[]):
    # make sure we have games
    if len(games) == 0:
        print("must provide a list of games")
        raise SystemExit

    # process patches for each game in the combo
    for game in games:
        # load the rom into memory
        rom_file = ".\\roms\\" + game + ".nes"
        print('loading rom ' + rom_file)
        file_in = open(rom_file, "rb")
        data = bytearray(file_in.read())
        file_in.close()

        # get a list of all patches
        patch_dir = join(dirname(abspath(__file__)), 'games', game, 'patches')
        patch_files = list(map(lambda x: x.replace('.py', ''), [
            f for f in listdir(patch_dir)]))

        # execute each patch in order
        for p in patch_files:
            # See if we're loading a mod file or directory
            isPatchFile = isfile(join(patch_dir, p + '.py'))
            isPatchDir = isfile(join(patch_dir, p, 'patch.py'))

            # skip non-patch files/dirs
            if not (isPatchFile or isPatchDir):
                continue

            # Load the module and execute the patch
            mod_path = 'main.games.' + game + '.patches.' + \
                (p + '.patch' if isPatchDir else p)
            print("executing patch '" + mod_path + "'")
            mod = import_module(mod_path)
            mod.execute(data)

        # write the modified in-memory rom data to a new rom file
        with open(".\\tmp\\" + game + "-retroverse.nes", "wb") as file_out:
            file_out.write(data)
            file_out.close()
