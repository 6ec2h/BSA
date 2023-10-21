LinkLuaModifier( "modifier_necro_firestorm", "abilities/bosses/final/necro_firestorm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_necro_firestorm_thinker", "abilities/bosses/final/necro_firestorm", LUA_MODIFIER_MOTION_NONE )

necro_firestorm = class({})

function necro_firestorm:OnSpellStart()
	CreateModifierThinker( self:GetCaster(), self, "modifier_necro_firestorm_thinker",  {}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )
end

-----------------------------------------------------------------------------------------------------

modifier_necro_firestorm = class({})

function modifier_necro_firestorm:IsHidden()
	return false
end

function modifier_necro_firestorm:IsDebuff()
	return true
end

function modifier_necro_firestorm:IsStunDebuff()
	return false
end

function modifier_necro_firestorm:IsPurgable()
	return true
end

function modifier_necro_firestorm:OnCreated( kv )
	if not IsServer() then return end
	local interval = kv.interval
	self.damage_pct = kv.damage/100

	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	self:StartIntervalThink( interval )
end

function modifier_necro_firestorm:OnRefresh( kv )
	if not IsServer() then return end
	self.damage_pct = kv.damage/100
end

function modifier_necro_firestorm:OnRemoved()
end

function modifier_necro_firestorm:OnDestroy()
end


function modifier_necro_firestorm:OnIntervalThink()
	local damage = self:GetParent():GetMaxHealth() * self.damage_pct
	self.damageTable.damage = damage
	ApplyDamage( self.damageTable )
end

function modifier_necro_firestorm:GetEffectName()
	return "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf"
end

function modifier_necro_firestorm:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

------------------------------------------------------------------------

modifier_necro_firestorm_thinker = class({})

function modifier_necro_firestorm_thinker:IsHidden()
	return true
end

function modifier_necro_firestorm_thinker:IsPurgable()
	return false
end

function modifier_necro_firestorm_thinker:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local damage = self.ability:GetSpecialValueFor( "wave_damage" )
	local delay = self.ability:GetSpecialValueFor( "first_wave_delay" )
	self.radius = self.ability:GetSpecialValueFor( "radius" )
	self.count = self.ability:GetSpecialValueFor( "wave_count" )
	self.interval = self.ability:GetSpecialValueFor( "wave_interval" )

	self.burn_duration = self.ability:GetSpecialValueFor( "burn_duration" )
	self.burn_interval = self.ability:GetSpecialValueFor( "burn_interval" )
	self.burn_damage = self.ability:GetSpecialValueFor( "burn_damage" )

	if not IsServer() then return end

	self.wave = 0
	self.damageTable = {
		attacker = self.caster,
		damage = damage,
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability
		}
	self:StartIntervalThink(delay)
end

function modifier_necro_firestorm_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_necro_firestorm_thinker:OnIntervalThink()
	if not self.delayed then
		self.delayed = true
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()
		return
	end

	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		enemy:AddNewModifier(self.caster, self.ability, "modifier_necro_firestorm",
			{
				duration = self.burn_duration,
				interval = self.burn_interval,
				damage = self.burn_damage,
			}
		)
	end
	self:PlayEffects()
	self.wave = self.wave + 1
	if self.wave>=self.count then
		self:Destroy()
	end
end

function modifier_necro_firestorm_thinker:PlayEffects()
	local particle_cast = "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf"
	local sound_cast = "Hero_AbyssalUnderlord.Firestorm"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 4, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, self.parent )
end