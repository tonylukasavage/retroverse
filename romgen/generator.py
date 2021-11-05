from importlib import import_module
from os import getcwd, listdir
from os.path import isfile, join, dirname, abspath, exists
from shutil import copyfile, rmtree
from datetime import datetime
from romgen.utils import mkdirp

# import now so they are available in modules
import romgen
from romgen import injector, assembler, utils, games
from romgen.utils import writeFile


def generate(games, rom_dir, opts={}):
    cwd = getcwd()
    session_dir = join(cwd, 'tmp')
    rg_dir = dirname(abspath(__file__))
    session_id = datetime.now().strftime("%Y%m%d_%H%M%S")

    # make sure we have games
    if len(games) == 0:
        print("must provide a list of games")
        raise SystemExit

    # clean tmp directory
    print(opts)
    if "clean" in opts and opts.get("clean") and exists(session_dir):
        rmtree(session_dir)
    mkdirp(session_dir)
    # if "clean" in opts and opts.get("clean") and exists(tmp_dir):
    #     rmtree(tmp_dir)
    # mkdirp(tmp_dir)

    # create session directory
    # session_dir = join(tmp_dir, session_id)
    session_roms_dir = join(session_dir, 'roms')
    session_states_dir = join(session_dir, 'states')
    mkdirp(session_roms_dir)
    mkdirp(session_states_dir)

    # process patches for each game in the combo
    for game in games:
        # load the rom into memory
        rom_file = join(rom_dir, game + '.nes')
        print('loading rom ' + rom_file)
        file_in = open(rom_file, "rb")
        data = bytearray(file_in.read())
        file_in.close()

        # get a list of all patches
        patch_dir = join(rg_dir, 'games', game, 'patches')
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
            mod_path = 'romgen.games.' + game + '.patches.' + \
                (p + '.patch' if isPatchDir else p)
            print("executing patch '" + mod_path + "'")
            mod = import_module(mod_path)
            mod.execute(data)

        # write the modified in-memory rom data to a new rom file in session directory
        writeFile(join(session_roms_dir, game + "-retroverse.nes"), data)

        # copy initial states into session directory
        copyfile(join(rg_dir, 'games', game, game +
                 '.base.State'), join(session_states_dir, game + '-retroverse.State'))

    # write session id to file to be read by bizhawk lua
    writeFile(join(session_dir, 'session.json'),
              '{"session_id":"' + session_id + '"}', "w")

    return session_id
