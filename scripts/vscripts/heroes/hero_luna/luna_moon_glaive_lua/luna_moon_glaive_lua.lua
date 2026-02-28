luna_moon_glaive_lua = class({})
LinkLuaModifier( "modifier_luna_moon_glaive_lua", "heroes/hero_luna/luna_moon_glaive_lua/modifier_luna_moon_glaive_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_luna_moon_glaive_lua_thinker", "heroes/hero_luna/luna_moon_glaive_lua/modifier_luna_moon_glaive_lua_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function luna_moon_glaive_lua:GetIntrinsicModifierName()
	return "modifier_luna_moon_glaive_lua"
end

function luna_moon_glaive_lua:OnUpgrade()
	self.OnUpgrade = function() end

	if not IsServer() then return end

	self:ToggleAutoCast()
end