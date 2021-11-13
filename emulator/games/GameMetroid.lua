local GameBase = require "GameBase"
local GameMetroid = GameBase:new()

function GameMetroid:new(o, id, next_id, session)
    o = o or GameBase:new(o)
    setmetatable(o, self)
    self.__index = self

    self.id = id
    self.next_id = next_id
    self.name = "metroid"
    self.full_name = "Metroid"
    self.item_check_loc = 0x7FF0
    self.items = {}

    local gear = {
        { "Bombs", 0x01 },
        { "High Jump Boots", 0x02 },
        { "Long Beam", 0x04 },
        { "Screw Attack", 0x08 },
        { "Morph Ball", 0x10 },
        { "Varia Suit", 0x20 },
        { "Wave Beam", 0x40 },
        { "Ice Beam", 0x80 }
    }
    for i,w in pairs(gear) do
        local item =  {
            id=i,
            name=w[1],
            loc=0x6878,
            val=w[2],
            is_owned=false,
            update_func="or"
        }
        self:create_item_from_session(session, item)
    end

    return o
end

function GameMetroid.warp_check()
    return memory.readbyte(0x4F) == 0x0E
        and memory.readbyte(0x50) == 0x01
        and memory.readbyte(0x52) >= 0xDD
        and memory.readbyte(0x51) < 0x50
end

function GameMetroid.pre_save()
    -- set state to samus intro
    memory.writebyte(0x1E, 0x00)

    -- advance 4 frames so that the samus intro kicks in before the combo checks
    emu.frameadvance()
    emu.frameadvance()
    emu.frameadvance()
    emu.frameadvance()
end

return GameMetroid