viper_corrosive_skin_lua = class({})
LinkLuaModifier( "modifier_viper_corrosive_skin_lua", "heroes/hero_viper/viper_corrosive_skin_lua/modifier_viper_corrosive_skin_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_viper_corrosive_skin_lua_debuff", "heroes/hero_viper/viper_corrosive_skin_lua/modifier_viper_corrosive_skin_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function viper_corrosive_skin_lua:GetIntrinsicModifierName()
	return "modifier_viper_corrosive_skin_lua"
end