local utils = require "utils"

local Game = {
    id = nil,
    next_id = nil,
    name = nil,
    full_name = nil,
    item_check_loc = nil,
    items = {}
}

function Game:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Game:get_item_by_id(id)
    for i,item in pairs(self.items) do
        if item.id == id then
            return item
        end
    end
    return nil
end

function Game:create_item_from_session(session, item)
    if session.data.games ~= nil then
        local session_game = session.data.games[self.name]
        if session_game ~= nil then
            local session_item = utils.find(session_game.items, function(i) return i.id == item.id end)
            if session_item ~= nil then
                item.is_owned = session_item.is_owned
            end
        end
    end
    table.insert(self.items, item)
end

function Game:update_inventory()
    for i,item in pairs(self.items) do
        self:update_item_in_game(item)
    end
end

function Game:update_item_in_game(item)
    if item.update_func == "or" then
        print(item.name .. ": " .. tostring(item.is_owned))
        utils.write_or(item)
    else
        error("invalid update_func '" .. item.update_func .. "' for " .. item.name .. " in " .. self.name)
    end
end

function Game:item_check()
    local loc = self.item_check_loc
    return {
        memory.readbyte(loc),
        memory.readbyte(loc + 1),
        memory.readbyte(loc + 2)
    }
end

function Game:item_uncheck()
    local loc = self.item_check_loc
    memory.writebyte(loc, 0)
    memory.writebyte(loc + 1, 0)
    memory.writebyte(loc + 2, 0)
end

function Game.warp_check()
    return false
end

function Game.pre_save()
    -- do nothing
end

return Game