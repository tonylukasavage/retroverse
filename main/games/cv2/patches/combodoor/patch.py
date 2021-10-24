from injector import injectFunction
from assembler import assemble
from os.path import abspath, dirname, join
from games.cv2.banks import banks


def execute(rom):
    # change the first door to be an open door for combo travel
    rom[0x84CB] = 0x14
    rom[0x84D3] = 0x28

    # read the asm for this patch
    dirpath = dirname(abspath(__file__))
    asmpath = join(dirpath, 'door.asm')
    file_in = open(asmpath, "r")
    door_data = assemble(file_in.read())
    file_in.close()

    # inject the door handling code
    injectFunction(rom, 0xC80E, banks, 3, door_data)


patch = {
    'name': 'combodoor',
    'desc': 'Defines behavior for combo world door',
    'deps': [],
    'execute': execute
}
