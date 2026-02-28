lifestealer_feast_lua = class({})
LinkLuaModifier( "modifier_lifestealer_feast_lua", "heroes/hero_lifestealer/lifestealer_feast_lua/modifier_lifestealer_feast_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function lifestealer_feast_lua:GetIntrinsicModifierName()
	return "modifier_lifestealer_feast_lua"
end