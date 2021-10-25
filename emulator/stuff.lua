
-- rom_path = "D:\\NESroms\\Castlevania II - Simon's Quest (USA)\\Castlevania II - Simon's Quest (USA).nes";
-- -- rom_path = ".\\roms\\zelda1.nes"

-- if userdata.get("last_openrom_path") == rom_path then
-- 	userdata.remove("last_openrom_path");
-- else
-- 	userdata.set("last_openrom_path", rom_path);
-- 	client.openrom(rom_path);
-- 	client.displaymessages(false);
-- 	savestate.load("D:\\test.State")
-- end

-- function switchGame()
-- 	gui.text(50, 50, 'Hello World!')
-- end

-- event.onmemorywrite(switchGame)

-- local Item = require "Item"

-- game_inventory = {
-- 	cv2 = {
-- 		-- whips
-- 		leather_whip = Item.new("leather whip", 0x434, 0x0, "w"),
-- 		thorn_whip = Item.new("thorn whip", 0x434, 0x1, "w"),
-- 		chain_whip = Item.new("chain whip", 0x434, 0x2, "w"),
-- 		morning_star = Item.new("morning star", 0x434, 0x3, "w"),
-- 		flame_whip = Item.new("flame whip", 0x434, 0x4, "w"),

-- 		--weapons
-- 		dagger = Item.new("dagger", 0x4A, 0x01, "o"),
-- 		silver_knife = Item.new("silver knife", 0x4A, 0x02, "o"),
-- 		gloden_knife = Item.new("golder_knife", 0x4A, 0x04, "o"),
-- 		holy_water = Item.new("holy water", 0x4A, 0x08, "o"),
-- 		diamond = Item.new("diamond", 0x4A, 0x10, "o"),
-- 		sacred_flame = Item.new("sacred flame", 0x4A, 0x20, "o"),
-- 		oak_stake = Item.new("oak stake", 0x4A, 0x40, "o"),

-- 		-- parts & crystals
-- 		rib = Item.new("rib", 0x91, 0x01, "o"),
-- 		heart = Item.new("heart", 0x91, 0x02, "o"),
-- 		eye = Item.new("eye", 0x91, 0x04, "o"),
-- 		nail = Item.new("nail", 0x91, 0x08, "o"),
-- 		ring = Item.new("ring", 0x91, 0x10, "o"),
-- 		white_crystal = Item.new("white crystal", 0x91, 0x20, "o"),
-- 		blue_crystal = Item.new("blue crystal", 0x91, 0x40, "o"),
-- 		red_crystal = Item.new("red crystal", 0x91, 0x60, "o"),

-- 		-- carry items
-- 		silk_bag = Item.new("silk bag", 0x92, 0x01, "o"),
-- 		magic_cross = Item.new("magic cross", 0x92, 0x02, "o"),
-- 		laurels = Item.new("laurels", 0x92, 0x04, "o"),
-- 		garlic = Item.new("garlic", 0x92, 0x08, "o")
-- 	}
-- }

-- current_inventory = {
-- 	cv2 = { 0x434, 0x4A, 0x4C, 0x4D, 0x91, 0x92 }
-- }

-- inventory.cv2.whip.update(0x03)
-- print(inventory.cv2.whip.read())

-- function getWhips() {
-- 	return [
-- 		// { name: 'leather whip', value: 0x00, icon: 0x5B },
-- 		{ name: 'thorn whip', type: 'whip', value: 0x01, icon: 0x5B, bankCode: [] },
-- 		{ name: 'chain whip', type: 'whip', value: 0x02, icon: 0x5B, bankCode: [] },
-- 		{ name: 'morning star', type: 'whip', value: 0x03, icon: 0x5B, bankCode: [] },
-- 		{ name: 'flame whip', type: 'whip', value: 0x04, icon: 0x5B, bankCode: [] }
-- 	];
-- }

-- function getWeapons() {
-- 	return [
-- 		{ name: 'dagger', type: 'weapon', value: 0x01, icon: 0x54, price: 50 },
-- 		{ name: 'silver knife', type: 'weapon', value: 0x02, icon: 0x55, price: 50 },
-- 		{ name: 'golden knife', type: 'weapon', value: 0x04, icon: 0x6F, price: 125 },
-- 		{ name: 'holy water', type: 'weapon', value: 0x08, icon: 0x57, price: 50 },
-- 		{ name: 'diamond', type: 'weapon', value: 0x10, icon: 0x70, price: 50 },
-- 		{ name: 'sacred flame', type: 'weapon', value: 0x20, icon: 0x69, price: 75 },
-- 		{ name: 'oak stake', type: 'weapon', value: 0x40, icon: 0x59, price: 50, count: 5 }
-- 	];
-- }

-- function getInventory() {
-- 	return [
-- 		{ name: 'rib', type: 'inventory', value: 0x01, icon: 0x4E, dracPart: true },
-- 		{ name: 'heart', type: 'inventory', value: 0x02, icon: 0x4F, dracPart: true },
-- 		{ name: 'eyeball', type: 'inventory', value: 0x04, icon: 0x50, dracPart: true },
-- 		{ name: 'nail', type: 'inventory', value: 0x08, icon: 0x51, dracPart: true },
-- 		{ name: 'ring', type: 'inventory', value: 0x10, icon: 0x52, dracPart: true },
-- 		{ name: 'white crystal', type: 'inventory', value: 0x20, icon: 0x5E, crystal: true, bankCode: [] },
-- 		{ name: 'blue crystal', type: 'inventory', value: 0x40, icon: 0x6E, crystal: true, bankCode: [] },
-- 		{ name: 'red crystal', type: 'inventory', value: 0x60, icon: 0x5F, crystal: true, bankCode: [] }
-- 	];
-- }

-- function getCarry() {
-- 	return [
-- 		{ name: 'silk bag', type: 'carry', value: 0x01, icon: 0x5C, price: 100 },
-- 		{ name: 'magic cross', type: 'carry', value: 0x02, icon: 0x5A, price: 100 },
-- 		{ name: 'laurels', type: 'carry', value: 0x04, icon: 0x58, price: 50, count: 5, bankCode: [] },
-- 		{ name: 'garlic', type: 'carry', value: 0x08, icon: 0x6D, price: 50, count: 2, bankCode: [] }
-- 	];
-- }