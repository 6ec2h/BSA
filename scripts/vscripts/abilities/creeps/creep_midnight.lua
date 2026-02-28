LinkLuaModifier( "modifier_creep_midnight_thinker", "abilities/creeps/creep_midnight", LUA_MODIFIER_MOTION_NONE )

creep_midnight = class({})

function creep_midnight:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")

	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_creep_midnight_thinker", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end

----------------------------------------------------------------------------

modifier_creep_midnight_thinker = class({})

function modifier_creep_midnight_thinker:IsHidden()
	return true
end

function modifier_creep_midnight_thinker:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage_percent" )
	local interval = 1

	if IsServer() then
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.radius, true )

		self.damageTable = {
			attacker = self:GetCaster(),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = self:GetAbility(), --Optional.
		}
		self:StartIntervalThink( interval )
		self:PlayEffects()
	end
end

function modifier_creep_midnight_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

function modifier_creep_midnight_thinker:OnIntervalThink()
	local enemies = FindUnitsInRadius(
		DOTA_TEAM_NEUTRALS,	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		self.damageTable.damage = enemy:GetMaxHealth()*self.damage/100
		ApplyDamage( self.damageTable )
	end
end

function modifier_creep_midnight_thinker:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	EmitSoundOn( "Hero_Enigma.Midnight_Pulse", self:GetParent() )
end