local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)

local max_offset = 0
for _,hitbox in ipairs(EntityGetComponent(root, "HitboxComponent") or {}) do
	max_offset = math.max(max_offset, -ComponentGetValue2(hitbox, "aabb_min_y"))
end

local spr_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent")
if not spr_comp then return end

ComponentSetValue2(spr_comp, "offset_y", max_offset + 14)