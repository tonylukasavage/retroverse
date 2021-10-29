from importlib import import_module
from os import getcwd, listdir, makedirs
from os.path import isfile, join, dirname, abspath
from datetime import datetime
from utils import mkdirp


def generate(games=[]):
    cwd = getcwd()
    rom_dir = join(cwd, 'roms')
    tmp_dir = join(cwd, 'tmp')
    session_id = datetime.now().strftime("%Y%m%d_%H%M%S")

    # make sure we have games
    if len(games) == 0:
        print("must provide a list of games")
        raise SystemExit

    # create session directory
    session_dir = join(tmp_dir, session_id)
    mkdirp(session_dir)

    # process patches for each game in the combo
    for game in games:
        # load the rom into memory
        rom_file = join(rom_dir, game + '.nes')
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

        # write the modified in-memory rom data to a new rom file in session directory
        session_roms_dir = join(session_id, game, 'roms')
        mkdirp(session_roms_dir)
        with open(join(session_roms_dir, game + "-retroverse.nes"), "wb") as file_out:
            file_out.write(data)
            file_out.close()

        # copy initial states into session directory
        session_states_dir = join(session_id, game, 'states')
        mkdirp(session_states_dir)
