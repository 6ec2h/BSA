lina_fiery_soul_lua = class({})
LinkLuaModifier( "modifier_lina_fiery_soul_lua", "heroes/hero_lina/lina_fiery_soul_lua/modifier_lina_fiery_soul_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function lina_fiery_soul_lua:GetIntrinsicModifierName()
	return "modifier_lina_fiery_soul_lua"
end