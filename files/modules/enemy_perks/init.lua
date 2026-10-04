local hooks = {}
local _g = GLOBAL_DATA

local curr_path = "mods/noita.hardmod/files/modules/enemy_perks/"

ModLuaFileAppend("data/scripts/perks/perk_reflect.lua", curr_path.."add_perks_to_progress.lua")


local enemy_perks = {}
local enemy_perks_indexed = {}
hooks.mod_post_init = function() --run later in case of appends
	enemy_perks = dofile_once(curr_path.."enemy_perks_list.lua")
	for _,perk in ipairs(enemy_perks) do
		enemy_perks_indexed[perk.id] = perk
	end
end

hooks.world_init = function()
	SetRandomSeed(1337, -6967)
end

local function give_enemy_perk(entity_id)
	local x,y = EntityGetTransform(entity_id)
	local enemy_perks_handler
	for _,child in ipairs(EntityGetAllChildren(entity_id) or {}) do
		if EntityGetName == "hardmod.enemy_perks" then enemy_perks_handler = child break end
	end
	if not enemy_perks_handler then
		enemy_perks_handler = EntityLoad("mods/noita.hardmod/files/modules/enemy_perks/handler.xml", x, y)
		EntityAddChild(entity_id, enemy_perks_handler)
	end

	local enemy_perk_data
	for _,varcomp in ipairs(EntityGetComponent(enemy_perks_handler, "VariableStorageComponent") or {}) do
		if ComponentGetValue2(varcomp, "name") == "enemy_perk_data" then enemy_perk_data = varcomp break end
	end
	if not enemy_perk_data then
		enemy_perk_data = EntityAddComponent2(enemy_perks_handler, "VariableStorageComponent", {name = "enemy_perk_data"})
	end

	local data = {
		player = _g.player,
		player_poly_identity = _g.player_poly_identity
	}
	local perk = ConditionalRandomFromTable(enemy_perks, data)
	if not perk then return end
	perk:func(entity_id)


	local held_perks = ComponentGetValue2(enemy_perk_data, "value_string")
	if #held_perks == 0 then held_perks = perk.id else held_perks = held_perks..","..perk.id end
	ComponentSetValue2(enemy_perk_data, "value_string", held_perks)

	if not EntityHasTag(entity_id, "hardmod_blessed") then
		EntityAddTag(entity_id, "hardmod_blessed")
	end
end


hooks.new_eid = function(entity_id)
	if EntityHasTag(entity_id, "enemy") and not EntityHasTag(entity_id, "hardmod_blessed") then
		give_enemy_perk(entity_id)
	end
end



local gui = GuiCreate()

local _id = 0
local function new_id()
	_id = _id + 1
	return _id
end

local virt_x, virt_y, screen_width, screen_height, scale_x, scale_y, cx, cy
local function world_to_screen_coordinates(x, y)
	return (x - cx) / scale_x + screen_width / 2 + 1.5, (y - cy) / scale_y + screen_height / 2
end

--[[
function hooks.pre_update(frame)
	virt_x = MagicNumbersGetValue("VIRTUAL_RESOLUTION_X")
	virt_y = MagicNumbersGetValue("VIRTUAL_RESOLUTION_Y")
	screen_width, screen_height = GuiGetScreenDimensions(gui)
	scale_x = virt_x / screen_width
	scale_y = virt_y / screen_height
	cx, cy = GameGetCameraPos()

	GuiStartFrame(gui)
	for _,entity_id in ipairs(EntityGetWithTag("hardmod_blessed")) do
		local enemy_perk_data
		for _,varcomp in ipairs(EntityGetComponent(entity_id, "VariableStorageComponent") or {}) do
			if ComponentGetValue2(varcomp, "name") == "hardmod.enemy_perks" then enemy_perk_data = varcomp break end
		end
		if not enemy_perk_data then return end

		local perks = {}
		local x,y = EntityGetTransform(entity_id)
		for perk_id in ComponentGetValue2(enemy_perk_data, "value_string"):gmatch("([^,]+)") do
			perks[#perks+1] = perk_id
		end

		local sx, sy = world_to_screen_coordinates(x,y)
		for i,perk in ipairs(perks) do
			--GameCreateSpriteForXFrames(enemy_perks_indexed[perk].icon, x-8, y-20, false, 0, 0, 1, true)
			GuiImage(gui, new_id(), sx+((i-1)*30)-12, sy-44, "mods/noita.hardmod/files/modules/enemy_perks/expand.png", 1, 3/2)
		end
	end
end--]]

return hooks