creep_freezing_field = class({})
LinkLuaModifier( "modifier_creep_freezing_field", "abilities/creeps/creep_freezing_field", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creep_freezing_field_effect", "abilities/creeps/creep_freezing_field", LUA_MODIFIER_MOTION_NONE )

function creep_freezing_field:OnSpellStart()
	local caster = self:GetCaster()
	self.modifier = caster:AddNewModifier(caster, self, "modifier_creep_freezing_field", { duration = self:GetChannelTime() })
end

function creep_freezing_field:OnChannelFinish( bInterrupted )
	return
	-- local talent = self:GetCaster():FindAbilityByName("special_bonus_unique_crystal_8")
	-- if talent and talent:GetLevel() > 0 then return else
		-- if self.modifier then
			-- self.modifier:Destroy()
			-- self.modifier = nil
		-- end
	-- end
end

-----------------------------------------------------

modifier_creep_freezing_field = class({})

function modifier_creep_freezing_field:IsHidden()
	return true
end

function modifier_creep_freezing_field:IsDebuff()
	return false
end

function modifier_creep_freezing_field:IsPurgable()
	return false
end

function modifier_creep_freezing_field:IsAura()
	return true
end

function modifier_creep_freezing_field:GetModifierAura()
	return "modifier_creep_freezing_field_effect"
end

function modifier_creep_freezing_field:GetAuraRadius()
	return self.slow_radius
end

function modifier_creep_freezing_field:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_creep_freezing_field:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_creep_freezing_field:GetAuraDuration()
	return self.slow_duration
end

function modifier_creep_freezing_field:OnCreated( kv )
	self.slow_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
	self.explosion_radius = self:GetAbility():GetSpecialValueFor( "explosion_radius" )
	self.explosion_interval = self:GetAbility():GetSpecialValueFor( "explosion_interval" )
	self.explosion_min_dist = self:GetAbility():GetSpecialValueFor( "explosion_min_dist" )
	self.explosion_max_dist = self:GetAbility():GetSpecialValueFor( "explosion_max_dist" )
	self.explosion_damage = self:GetAbility():GetSpecialValueFor( "damage" )
	
	if not IsServer() then return end

	self.try_damage = self.explosion_damage
	
	self.quartal = -1

	if IsServer() then
		self.damageTable = {
			attacker = self:GetCaster(),
			damage = self.try_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self,
		}

		self:StartIntervalThink( self.explosion_interval )
		self:OnIntervalThink()
		self:PlayEffects1()
	end
end

function modifier_creep_freezing_field:OnDestroy( kv )
	if IsServer() then
		self:StartIntervalThink( -1 )
		self:StopEffects1()
	end
end

function modifier_creep_freezing_field:OnIntervalThink()
	self.quartal = self.quartal+1
	if self.quartal>3 then self.quartal = 0 end
	local a = RandomInt(0,90) + self.quartal*90
	local r = RandomInt(self.explosion_min_dist,self.explosion_max_dist)
	local point = Vector( math.cos(a), math.sin(a), 0 ):Normalized() * r

	point = self:GetCaster():GetOrigin() + point
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.explosion_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )	
	end
	self:PlayEffects2( point )
end

function modifier_creep_freezing_field:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf"
	self.sound_cast = "hero_Crystal.freezingField.wind"

	-- Create Particle
	 self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.slow_radius, self.slow_radius, 1 ) )
	self:AddParticle(
		self.effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
	EmitSoundOn( self.sound_cast, self:GetCaster() )
end

function modifier_creep_freezing_field:PlayEffects2( point )
	local particle_cast = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	local sound_cast = "hero_Crystal.freezingField.explosion"
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

function modifier_creep_freezing_field:StopEffects1()
	StopSoundOn( self.sound_cast, self:GetCaster() )
end

----------------------------------------------------------

modifier_creep_freezing_field_effect = class({})

function modifier_creep_freezing_field_effect:IsHidden()
	return false
end

function modifier_creep_freezing_field_effect:IsDebuff()
	return true
end

function modifier_creep_freezing_field_effect:IsPurgable()
	return true
end

function modifier_creep_freezing_field_effect:OnCreated( kv )
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )
end

function modifier_creep_freezing_field_effect:OnRefresh( kv )
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )	
end

function modifier_creep_freezing_field_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_creep_freezing_field_effect:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_creep_freezing_field_effect:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow
end

function modifier_creep_freezing_field_effect:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_creep_freezing_field_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end