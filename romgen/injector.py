import json


def injectFunction(rom, loc, banks, bankNum, bytes, padding=0):
    count = len(bytes)
    offset = banks[bankNum]['offset']
    funcRomLoc = banks[bankNum]['rom']['start'] + offset
    funcRamLoc = banks[bankNum]['ram']['start'] + offset
    banks[bankNum]['offset'] += count

    # ensure we have space
    if banks[bankNum]['offset'] + banks[bankNum]['rom']['start'] > banks[bankNum]['rom']['end']:
        # TODO: switch to another bank
        raise Exception("Out of space on bank " + str(bankNum))

    # replace existing code to point to new jsr
    locLow = funcRamLoc & 0x00FF
    locHigh = (funcRamLoc & 0xFF00) >> 8
    jsrCode = bytearray([0x20, locLow, locHigh])

    # add additional NOP padding if necessary
    if padding > 0:
        jsrCode.extend([0xEA] * padding)

    # replace the existing code with our new functiion
    rom[loc: loc + len(jsrCode)] = jsrCode

    # write new jsr to bank free space
    rom[funcRomLoc: funcRomLoc + len(bytes)] = bytearray(bytes)


def applyDiff(rom_data, diff_json_file):
    file = open(diff_json_file, "r")
    diff_json_text = file.read()
    diff_json = json.loads(diff_json_text)
    file.close()

    for diff in diff_json:
        loc, val = diff
        while len(rom_data) < loc + 1:
            rom_data.append(0xFF)
        rom_data[loc] = val
