arc_flux_lua = class({})
LinkLuaModifier( "modifier_arc_flux_lua", "heroes/hero_arc/arc_flux//modifier_arc_flux_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_flux_lua_debuff", "heroes/hero_arc/arc_flux//modifier_arc_flux_lua_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_flux_lua_scepter", "heroes/hero_arc/arc_flux//modifier_arc_flux_lua_scepter", LUA_MODIFIER_MOTION_NONE )


function arc_flux_lua:OnSpellStart()

	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor( "duration" )

	-- create aura
	local modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_arc_flux_lua", -- modifier name
		{ duration = duration } -- kv
	)
end

