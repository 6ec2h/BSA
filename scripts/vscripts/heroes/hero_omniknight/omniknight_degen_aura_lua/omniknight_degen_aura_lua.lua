omniknight_degen_aura_lua = class({})
LinkLuaModifier( "modifier_omniknight_degen_aura_lua", "heroes/hero_omniknight/omniknight_degen_aura_lua/modifier_omniknight_degen_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_omniknight_degen_aura_lua_effect", "heroes/hero_omniknight/omniknight_degen_aura_lua/modifier_omniknight_degen_aura_lua_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function omniknight_degen_aura_lua:GetIntrinsicModifierName()
	return "modifier_omniknight_degen_aura_lua"
end