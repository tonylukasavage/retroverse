local game = {}

game.data = {
    name="metroid",
    items={
        {
            name="Morph Ball",
            isOwned=false,
            loc=0x6878,
            val=0x01,
            func="bit_update"
        }
    }
}

function game.init()

end

-- function game.init()
--     game.inventory = {
--         morph_ball=false,
--         missiles=0,
--         missile_max=0,
--         long_beam=false,
--         energy_tanks=0,
--         bomb=false,
--         ice_beam=false,
--         high_jump_boots=false,
--         screw_attack=false,
--         wave_beam=false,
--         varia_suit=false
--     }
-- end

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