local hooks = {}
local _g = GLOBAL_DATA

local curr_path = "mods/noita.hardmod/files/modules/enemy_perks/"

ModLuaFileAppend("data/scripts/perks/perk_reflect.lua", curr_path.."add_perks_to_progress.lua")


local enemy_perks = {}
hooks.mod_post_init = function() --run later in case of appends
    enemy_perks = dofile_once(curr_path.."enemy_perks_list.lua")
end

local function give_enemy_perk(entity_id)
    local data = {
        player = _g.player,
        player_poly_identity = _g.player_poly_identity
    }
    local perk = ConditionalRandomFromTable(enemy_perks, data)
end


hooks.new_eid = function(entity_id)
    if EntityHasTag(entity_id, "enemy") then
        give_enemy_perk(entity_id)
    end
end