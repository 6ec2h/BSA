crystal_maiden_arcane_aura_lua = class({})
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_lua", "heroes/hero_crystal_maiden/crystal_maiden_arcane_aura_lua/modifier_crystal_maiden_arcane_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_lua_effect", "heroes/hero_crystal_maiden/crystal_maiden_arcane_aura_lua/modifier_crystal_maiden_arcane_aura_lua_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function crystal_maiden_arcane_aura_lua:GetIntrinsicModifierName()
	return "modifier_crystal_maiden_arcane_aura_lua"
end