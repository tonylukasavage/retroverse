from importlib import import_module
from os import listdir
from os.path import isfile, join, dirname, abspath


def init():
    # load the rom into memory
    file_in = open(".\\roms\\cv2.nes", "rb")
    data = bytearray(file_in.read())
    file_in.close()

    # get a list of all patches
    dirpath = dirname(abspath(__file__))
    modFiles = list(map(lambda x: x.replace('.py', ''), [
        f for f in listdir(join(dirpath, 'patches'))]))

    # execute each patch in order
    for m in modFiles:
        # See if we're loading a mod file or directory
        isModFile = isfile(join(dirpath, 'patches', m + '.py'))
        isModDir = isfile(join(dirpath, 'patches', m, 'patch.py'))
        if not (isModFile or isModDir):
            continue

        # Load the module and execute the patch
        modpath = 'games.cv2.patches.' + (m + '.patch' if isModDir else m)
        mod = import_module(modpath)

        print("executing patch '" + m + "'")
        mod.execute(data)

    # write the modified in-memory rom data to a new rom file
    with open(".\\tmp\\cv2-edit.nes", "wb") as file_out:
        file_out.write(data)
        file_out.close()
