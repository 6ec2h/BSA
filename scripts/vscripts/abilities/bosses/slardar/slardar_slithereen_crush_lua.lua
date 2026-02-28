slardar_slithereen_crush_lua = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "abilities/bosses/slardar/slardar_slithereen_crush_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slardar_slithereen_crush_lua_slow", "abilities/bosses/slardar/slardar_slithereen_crush_lua", LUA_MODIFIER_MOTION_NONE )

function slardar_slithereen_crush_lua:OnSpellStart()
	local radius = self:GetSpecialValueFor("crush_radius")
	local damage = self:GetAbilityDamage()
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local slow_duration = self:GetSpecialValueFor("crush_extra_slow_duration")

	-- find affected units
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	-- Prepare damage table
	local damageTable = {
		victim = nil,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self, --Optional.
	}

	-- for each caught enemies
	for _,enemy in pairs(enemies) do
		-- Apply Damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = stun_duration } )
		enemy:AddNewModifier( self:GetCaster(), self, "modifier_slardar_slithereen_crush_lua_slow", { duration = stun_duration + slow_duration } )
	end

	self:PlayEffects()
end

function slardar_slithereen_crush_lua:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_slardar/slardar_crush.vpcf"
	local sound_cast = "Hero_Slardar.Slithereen_Crush"

	local radius = self:GetSpecialValueFor("crush_radius")


	local nFXIndex = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, radius, radius) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

-------------------------------------------------------

modifier_slardar_slithereen_crush_lua_slow = class({})

function modifier_slardar_slithereen_crush_lua_slow:IsDebuff()
	return true
end

function modifier_slardar_slithereen_crush_lua_slow:OnCreated( kv )
	self.ms_slow = self:GetAbility():GetSpecialValueFor("crush_extra_slow")
	self.as_slow = self:GetAbility():GetSpecialValueFor("crush_attack_slow_tooltip")
end

function modifier_slardar_slithereen_crush_lua_slow:OnRefresh( kv )
	self.ms_slow = self:GetAbility():GetSpecialValueFor("crush_extra_slow")
	self.as_slow = self:GetAbility():GetSpecialValueFor("crush_attack_slow_tooltip")
end

function modifier_slardar_slithereen_crush_lua_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_slardar_slithereen_crush_lua_slow:GetModifierMoveSpeedBonus_Percentage( params )
	return self.ms_slow
end


function modifier_slardar_slithereen_crush_lua_slow:GetModifierAttackSpeedBonus_Constant( params )
	return self.as_slow
end