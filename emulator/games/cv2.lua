local game = {}

game.inventory = {}

function game.session_data()
    return {
        name="cv2",
        inventory={
            whip="leather_whip",
            crystal="none",
            nail=false,
            eyeball=false,
            rib=false,
            ring=false,
            heart=false,
            dagger=false,
            silver_knife=false,
            golden_knifeL=false,
            oak_stake=false,
            sacred_flame=false,
            magic_cross=false,
            diamond=false,
            garlic=0,
            silk_bag=false,
            holy_water=false,
            laurels=0
        }
    }
end

function game.warp_check()
    if memory.readbyte(0x6000) == 1 then
		memory.writebyte(0x6000, 0)
		return true
    end
    return false
end

function game.pre_save()
    -- do nothing
end

return game