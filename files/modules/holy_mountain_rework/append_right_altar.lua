--ad2e00 spear statue

RegisterSpawnFunction(0xffad2e00, "hardmod_spawn_spear_statue")
RegisterSpawnFunction(0xffda304b, "hardmod_spawn_collapse_crystal")
RegisterSpawnFunction(0xff04d1a3, "hardmod_spawn_area_checks")

function hardmod_spawn_spear_statue(x, y)
	EntityLoad("data/entities/props/temple_statue_01.xml", x, y)
end

function hardmod_spawn_area_checks(x, y)
	local mat_check_manager = EntityLoad("", x, y)

	local function place_mat_checker(x, y, w, h, material1, material2)
		EntityAddComponent2(mat_check_manager, "MaterialAreaCheckerComponent", {
			["area_aabb.min_x"] = x,
			["area_aabb.min_y"] = y,
			["area_aabb.max_x"] = x+w,
			["area_aabb.max_y"] = y+h,
			material = "templebrick_noedge_static",
			material2 = "templebrick_static",
			kill_after_message = true,
		})
	end

end