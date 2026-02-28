terrorblade_reflection_lua = class({})
LinkLuaModifier( "modifier_terrorblade_reflection_lua", "heroes/hero_terror/terrorblade_reflection_lua/modifier_terrorblade_reflection_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_terrorblade_reflection_lua_illusion", "heroes/hero_terror/terrorblade_reflection_lua/modifier_terrorblade_reflection_lua_illusion", LUA_MODIFIER_MOTION_NONE )

function terrorblade_reflection_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf", context )
end

function terrorblade_reflection_lua:GetAOERadius()
	return self:GetSpecialValueFor( "range" )
end

function terrorblade_reflection_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = caster:GetAbsOrigin()

	local radius = self:GetSpecialValueFor( "range" )
	local duration = self:GetSpecialValueFor( "illusion_duration" )

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_CREEP,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
	if not enemy:HasModifier("modifier_terrorblade_reflection_lua") then
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_terrorblade_reflection_lua", -- modifier name
			{ duration = duration } -- kv
		)
	end
	end
end