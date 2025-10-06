venomancer_venomous_gale_lua = class({})
LinkLuaModifier( "modifier_venomancer_venomous_gale_lua", "heroes/hero_venomancer/venomancer_venomous_gale_lua", LUA_MODIFIER_MOTION_NONE )

function venomancer_venomous_gale_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf", context )
end

function venomancer_venomous_gale_lua:Spawn()
	self.particles = {
		"particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
		"particles/units/heroes/hero_venomancer/venomancer_venomous_gale_impact.vpcf",
		"particles/units/heroes/hero_venomancer/venomancer_gale_poison_debuff.vpcf",
	}

	self.sounds = {
		"Hero_Venomancer.VenomousGale",
		"Hero_Venomancer.VenomousGaleImpact",
	}
	if not IsServer() then return end
end

function venomancer_venomous_gale_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function venomancer_venomous_gale_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	local radius = self:GetSpecialValueFor( "radius" )
	local speed = self:GetSpecialValueFor( "speed" )
	local range = self:GetCastRange( point, target )
	local vision = 280

	local direction = point-caster:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),

		bDeleteOnHit = false,

		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,

		EffectName = self.particles[1],
		fDistance = range,
		fStartRadius = radius,
		fEndRadius = radius,
		vVelocity = direction * speed,

		bProvidesVision = true,
		iVisionRadius = vision,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	ProjectileManager:CreateLinearProjectile(info)
	EmitSoundOn( self.sounds[1], caster  )
end

function venomancer_venomous_gale_lua:OnProjectileHit( target, location )
	if not target then return end
	local duration = self:GetSpecialValueFor( "duration" )

	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_venomancer_venomous_gale_lua", -- modifier name
		{ duration = duration } -- kv
	)
	self:PlayEffects( target )
end

function venomancer_venomous_gale_lua:PlayEffects( target )
	local effect_cast = ParticleManager:CreateParticle( self.particles[2], PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( self.sounds[2], target )
end

---------------------------------------------------------------------

modifier_venomancer_venomous_gale_lua = class({})

function modifier_venomancer_venomous_gale_lua:IsHidden()
	return false
end

function modifier_venomancer_venomous_gale_lua:IsDebuff()
	return true
end

function modifier_venomancer_venomous_gale_lua:IsStunDebuff()
	return false
end

function modifier_venomancer_venomous_gale_lua:IsPurgable()
	return true
end

function modifier_venomancer_venomous_gale_lua:OnCreated( kv )
	self.particles = self:GetAbility().particles
	self.sounds = self:GetAbility().sounds
	
	self.tick_interval = self:GetAbility():GetSpecialValueFor( "tick_interval" )
	self.tick_damage = self:GetAbility():GetSpecialValueFor( "tick_damage" )
	self.init_damage = self:GetAbility():GetSpecialValueFor( "strike_damage" )
	self.slow = self:GetAbility():GetSpecialValueFor( "movement_slow" )
	self.slow_tick = 0.3
	
	local ability = self:GetCaster():FindAbilityByName("special_bonus_venomancer_1")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.init_damage = self.init_damage + 100
		self.tick_damage = self.tick_damage + 100
	end

	if not IsServer() then return end
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.init_damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}

	ApplyDamage( self.damageTable )

	self.damageTable.damage = self.tick_damage
	self:StartIntervalThink( self.tick_interval )
end

function modifier_venomancer_venomous_gale_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_venomancer_venomous_gale_lua:OnRemoved()
end

function modifier_venomancer_venomous_gale_lua:OnDestroy()
end

function modifier_venomancer_venomous_gale_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_venomancer_venomous_gale_lua:GetModifierMoveSpeedBonus_Percentage()
	local time = (GameRules:GetGameTime()-self:GetLastAppliedTime())
	local slow = math.min( 0, self.slow + time/self.slow_tick )
	return slow
end

function modifier_venomancer_venomous_gale_lua:CheckState()
	local state = {
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = self:GetParent():GetHealthPercent()<25,
	}

	return state
end

function modifier_venomancer_venomous_gale_lua:OnIntervalThink()
	ApplyDamage( self.damageTable )

	SendOverheadEventMessage(
		nil,
		OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
		self:GetParent(),
		self.damageTable.damage,
		self:GetCaster():GetPlayerOwner()
	)
end

function modifier_venomancer_venomous_gale_lua:GetEffectName()
	return self.particles[3]
end

function modifier_venomancer_venomous_gale_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end