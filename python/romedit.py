import os

banks = [
    # bank 0
    {
        'ram':  {
            'start':  0xB848,
            'end':  0xBFCF
        },
        'rom':  {
            'start':  0x3858,
            'end':  0x3FDF
        },
        'offset':  0
    },

    # bank 1
    {
        'ram':  {
            'start':  0xB8CC,
            'end':  0xBFCF
        },
        'rom':  {
            'start':  0x78DC,
            'end':  0x7FDF
        },
        'offset':  0
    },

    # bank 2
    {
        'ram':  {
            'start':  0xBEE3,
            'end':  0xBFCE
        },
        'rom':  {
            'start':  0xBEF3,
            'end':  0xBFDE
        },
        'offset':  0
    },

    # bank 3
    {
        'ram':  {
            'start':  0x9CF6,
            'end':  0xBFCF
        },
        'rom':  {
            'start':  0xDD06,
            'end':  0xFFDF
        },
        'offset':  0
    },

    # bank 4
    {
        'ram':  {
            'start':  0xBAE4,
            'end':  0xBFF8
        },
        'rom':  {
            'start':  0x13AF4,
            'end':  0x14008
        },
        'offset':  0
    },

    # bank 5
    {},

    # bank 6
    {},

    # bank 7
    {
        'ram':  {
            'start':  0xFF94,
            'end':  0xFFCE
        },
        'rom':  {
            'start':  0x1FFA4,
            'end':  0x1FFDE
        },
        'offset':  0
    },

    # a few extra bytes on bank 7, indexed at 8
    {
        'ram':  {
            'start':  0xFEE2,
            'end':  0xFF33
        },
        'rom':  {
            'start':  0x1FEF2,
            'end':  0x1FF43
        },
        'offset':  0
    },

    # a few more bytes on bank 7, indexed at 9
    {
        'ram':  {
            'start':  0xFBD2,
            'end':  0xFBFE
        },
        'rom':  {
            'start':  0x1FBE2,
            'end':  0x1FC0E
        },
        'offset':  0
    }
]

file_in = open(".\\roms\\cv2.nes", "rb")
data = file_in.read()
file_in.close()


def insertFunction(file, loc, bank, bytes, padding):
    count = len(bytes)
    offset = banks[bank]['offset']
    funcRomLoc = banks[bank]['rom']['start'] + offset
    funcRamLoc = banks[bank]['ram']['start'] + offset
    banks[bank]['offset'] += count

    # ensure we have space
    if banks[bank]['offset'] + banks[bank]['rom']['start'] > banks[bank]['rom']['end']:
        # TODO: switch to another bank
        raise Exception("Out of space on bank " + str(bank))

    # replace existing code to point to new jsr
    locLow = funcRamLoc & 0x00FF
    locHigh = (funcRamLoc & 0xFF00) >> 8
    jsrCode = bytearray([0x20, locLow, locHigh])
    file.seek(loc)
    file.write(jsrCode)

    # write new jsr to bank free space
    file.seek(funcRomLoc)
    file.write(bytearray(bytes))


with open(".\\tmp\\cv2-edit.nes", "wb") as file_out:
    file_out.write(data)

    # z's in the title
    file_out.seek(0x0101A2)
    file_out.write(
        bytearray([0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A]))

    # stop door entry
    insertFunction(file_out, 0xC80E, 3, [0x68, 0x68, 0x4C, 0x4A, 0x87], 0)
    # file_out.seek(0xC80E)
    # file_out.write(bytearray([0x4C, 0x4A, 0x87]))

# LDA *$54
# BNE BACK
# LDA *$53
# CMP  # $30
# BCS BACK

# LDA $50
# ASL
# RTS

# BACK:
# PLA
# PLA
# LDA  # $01
# STA $6000
# JMP $874A

    # stop door entry
    # file_out.seek(0xC7AF)
    # file_out.write(bytearray([0x4C, 0x4A, 0x87]))

    file_out.close()
