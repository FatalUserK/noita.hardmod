dofile_once("mods/noita.hardmod/lib/utilities.lua")
local img = dofile_once("mods/noita.hardmod/lib/image_utils.lua")

local hooks = {}
local path = "mods/noita.hardmod/files/modules/holy_mountain_rework/"
ModMaterialsFileAdd(path.."materials.xml")


local visual_references = {
	"data/scripts/biomes/temple_altar_right_empty.lua",
	"data/scripts/biomes/temple_altar_right_snowcastle_empty.lua",
	"data/scripts/biomes/temple_altar_right_snowcastle.lua",
	"data/scripts/biomes/temple_altar_right_snowcave_empty.lua",
	"data/scripts/biomes/temple_altar_right_snowcave.lua",
	"data/scripts/biomes/temple_altar_right.lua",
}
for _,file in ipairs(visual_references) do
	modifile(file, [[data/biome_impl/temple/altar_right_visual.png]], path..[[images/visual.png]])
	modifile(file, [[data/biome_impl/temple/altar_right_background.png]], path..[[images/background.png]])
	ModLuaFileAppend(file, path.."append_right_altar.lua")
end
img.ImageOverlay("data/biome_impl/temple/altar_right.png", path.."images/material.png", 0, 0)

modifile("data/scripts/perks/perk.lua",
	[[if( Random( 1, 100 ) <= perk_destroy_chance ) then]],
	[[if( Random( 1, 100 ) <= perk_destroy_chance ) then dofile("mods/noita.hardmod/files/modules/holy_mountain_rework/collapse_mountain_check")(pos_x, pos_y);]]
)


return hooks