from romgen.games.metroid.banks import banks
from romgen.injector import applyDiff, injectFunction
from romgen.assembler import assemble
from os.path import abspath, dirname, join


def execute(rom_data):

    dirpath = dirname(abspath(__file__))

    # create new door to left of morph ball for combo travel
    applyDiff(rom_data, join(dirpath, 'door.diff.json'))

    # RAM location to start game
    # 7:C0BE

    # new map section
    # 0x4F == 0x0E
    # 0x50 == 0x01

    # # read the asm for this patch
    # file_in = open(join(dirpath, 'door.asm'), "r")
    # door_data = assemble(file_in.read())
    # file_in.close()

    # # inject the door handling code
    # injectFunction(rom_data, 0xC80E, banks, 3, door_data)


patch = {
    'name': 'combodoor',
    'desc': 'Defines behavior for combo world door',
    'deps': [],
    'execute': execute
}
