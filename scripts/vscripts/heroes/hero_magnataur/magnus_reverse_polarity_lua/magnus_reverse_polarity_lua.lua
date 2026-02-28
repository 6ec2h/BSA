magnus_reverse_polarity_lua = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function magnus_reverse_polarity_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf", context )
end

function magnus_reverse_polarity_lua:OnAbilityPhaseStart()
	self:PlayEffects1()

	return true
end

function magnus_reverse_polarity_lua:OnAbilityPhaseInterrupted()
	self:StopEffects( true )
end

function magnus_reverse_polarity_lua:GetCooldown( level )
	if self:GetCaster():FindAbilityByName("special_bonus_magnus_agi4")~=nil then
		if self:GetCaster():FindAbilityByName("special_bonus_magnus_agi4"):GetLevel() > 0 then 
			return self.BaseClass.GetCooldown( self, level ) - 60
		end
	end
	return self.BaseClass.GetCooldown( self, level )
end


--------------------------------------------------------------------------------
-- Ability Start
function magnus_reverse_polarity_lua:OnSpellStart()
	self:StopEffects( false )

	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor( "pull_radius" )
	local damage = self:GetSpecialValueFor( "polarity_damage" )
	local duration = self:GetSpecialValueFor( "hero_stun_duration" )
	local range = 10

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	-- ApplyDamage(damageTable)

	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- move to front
		local origin = enemy:GetOrigin()
		local pos = caster:GetOrigin() + caster:GetForwardVector() * range
		FindClearSpaceForUnit( enemy, pos, true )

		-- stun
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = duration } -- kv
		)

		-- damage
		damageTable.victim = enemy
		ApplyDamage( damageTable )

		-- play effects
		self:PlayEffects2( enemy, origin )
	end

	-- play effects
	local sound_cast = "Hero_Magnataur.ReversePolarity.Cast"
	EmitSoundOn( sound_cast, caster )
end

--------------------------------------------------------------------------------
-- Effects
function magnus_reverse_polarity_lua:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf"
	local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"

	-- Get data
	local radius = self:GetSpecialValueFor( "pull_radius" )
	local castpoint = self:GetCastPoint()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( castpoint, 0, 0 ) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		self:GetCaster(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 3, self:GetCaster():GetForwardVector() )

	self.effect_cast = effect_cast

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function magnus_reverse_polarity_lua:StopEffects( interrupted )
	-- stop particle
	ParticleManager:DestroyParticle( self.effect_cast, interrupted )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- stop sound
	local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"
	StopSoundOn( sound_cast, self:GetCaster() )
end

function magnus_reverse_polarity_lua:PlayEffects2( target, origin )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf"
	local sound_cast = "Hero_Magnataur.ReversePolarity.Stun"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, origin )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end