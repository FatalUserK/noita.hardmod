dofile_once("mods/noita.hardmod/lib/utilities.lua")
local img = dofile_once("mods/noita.hardmod/lib/image_utils.lua")

local hooks = {}


local visual_references = {
	"data/scripts/biomes/temple_altar_right_empty.lua",
	"data/scripts/biomes/temple_altar_right_snowcastle_empty.lua",
	"data/scripts/biomes/temple_altar_right_snowcastle.lua",
	"data/scripts/biomes/temple_altar_right_snowcave_empty.lua",
	"data/scripts/biomes/temple_altar_right_snowcave.lua",
	"data/scripts/biomes/temple_altar_right.lua",
}
for _,file in ipairs(visual_references) do
    modifile(file, [[data/biome_impl/temple/altar_right_visual.png]], [[mods/noita.hardmod/files/modules/holy_mountain_rework/images/right_altar_visual.png]])
end
img.ImageOverlay("data/biome_impl/temple/altar_right.png", "mods/noita.hardmod/files/modules/holy_mountain_rework/images/right_altar_materials.png", 0, 0)



return nil