local game = {}

game.inventory = {}

function game.warp_check()
    return memory.readbyte(0x4F) == 0x0E
        and memory.readbyte(0x50) == 0x01
        and memory.readbyte(0x52) >= 0xDD
        and memory.readbyte(0x51) < 0x50
end

function game.pre_save()
    -- set state to samus intro
    memory.writebyte(0x1E, 0x00)

    -- advance 4 frames so that the samus intro kicks in before the combo checks
    emu.frameadvance()
    emu.frameadvance()
    emu.frameadvance()
    emu.frameadvance()
end

return game