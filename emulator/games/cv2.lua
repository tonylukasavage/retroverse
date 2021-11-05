-- local utils = require "utils"
local game = {}

game.data = {
    name="cv2",
    items={
        {
            id=1,
            name="Holy Water",
            isOwned=false,
            loc=0x4A,
            val=0x08,
            func="bit_update"
        }
    }
}

function game.bit_update(loc, val)
    return function(self)
        local byte = memory.readbyte(loc)
        memory.writebyte(loc, self.isOwned and bit.bor(byte, val) or bit.band(bit.bnot(val), byte))
    end
end

-- function game.serialize()
--     return utils.map(game.item_data, function(i) return { name=i.name, isOwned=i.isOwned } end)
-- end

function game.init()

end

-- game.inventory = nil

-- function game.init()
--     game.inventory = {
--         whip="leather_whip",
--         crystal="none",
--         nail=false,
--         eyeball=false,
--         rib=false,
--         ring=false,
--         heart=false,
--         dagger=false,
--         silver_knife=false,
--         golden_knifeL=false,
--         oak_stake=false,
--         sacred_flame=false,
--         magic_cross=false,
--         diamond=false,
--         garlic=0,
--         silk_bag=false,
--         holy_water=false,
--         laurels=0
--     }
-- end

-- function game.session_data()
--     return {
--         name="cv2",
--         inventory={
--             whip="leather_whip",
--             crystal="none",
--             nail=false,
--             eyeball=false,
--             rib=false,
--             ring=false,
--             heart=false,
--             dagger=false,
--             silver_knife=false,
--             golden_knifeL=false,
--             oak_stake=false,
--             sacred_flame=false,
--             magic_cross=false,
--             diamond=false,
--             garlic=0,
--             silk_bag=false,
--             holy_water=false,
--             laurels=0
--         }
--     }
-- end

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