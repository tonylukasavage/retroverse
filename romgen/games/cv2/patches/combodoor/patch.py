from romgen.games.cv2.banks import banks
from romgen.injector import applyDiff, injectFunction
from romgen.assembler import assemble
from os.path import abspath, dirname, join


def execute(rom_data):
    # establish patch paths
    dirpath = dirname(abspath(__file__))
    doorDiffFile = join(dirpath, 'door.diff.json')
    doorAsmFile = join(dirpath, 'door.asm')

    # change the first door to be an open door for combo travel
    applyDiff(rom_data, doorDiffFile)

    # read the asm for this patch
    file_in = open(doorAsmFile, "r")
    door_data = assemble(file_in.read())
    file_in.close()

    # inject the door handling code
    injectFunction(rom_data, 0xC80E, banks, 3, door_data)


patch = {
    'name': 'combodoor',
    'desc': 'Defines behavior for combo world door',
    'deps': [],
    'execute': execute
}
