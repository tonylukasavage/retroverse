from main.injector import injectFunction
from main.assembler import assemble
from os.path import abspath, dirname, join
from main.games.cv2.banks import banks
from main.utils import applyDiff


def execute(rom_data):
    dirpath = dirname(abspath(__file__))

    # change the first door to be an open door for combo travel
    applyDiff(rom_data, join(dirpath, 'door.diff.json'))

    # read the asm for this patch
    file_in = open(join(dirpath, 'door.asm'), "r")
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
