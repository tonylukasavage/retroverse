local GameBase = require "GameBase"
local GameCv2 = GameBase:new()

function GameCv2:new(o, id, next_id, session)
    o = o or GameBase:new(o)
    setmetatable(o, self)
    self.__index = self

    self.id = id
    self.next_id = next_id
    self.name = "cv2"
    self.full_name = "Castlevania II: Simon's Quest"
    self.item_check_loc = 0x7000
    self.items = {}

    local weapons = {
        { "Dagger", 0x01 },
        { "Silver Knife", 0x02 },
        { "Golden Knife", 0x04 },
        { "Holy Water", 0x08 },
        { "Diamond", 0x10 },
        { "Sacred Flame", 0x20 },
        { "Oak Stake", 0x40 }
    }
    for i,w in pairs(weapons) do
        local item =  {
            id=i,
            name=w[1],
            loc=0x4A,
            val=w[2],
            is_owned=false,
            update_func="or"
        }
        self:create_item_from_session(session, item)
    end

    return o
end

function GameCv2.warp_check()
    if memory.readbyte(0x6000) == 1 then
		memory.writebyte(0x6000, 0)
		return true
    end
    return false
end

return GameCv2