creep_nova_lua = class({})
LinkLuaModifier( "modifier_creep_nova_lua", "abilities/creeps/creep_nova_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_ring_lua", "heroes/generic/modifier_generic_ring_lua", LUA_MODIFIER_MOTION_NONE )


function creep_nova_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )
	local speed = self:GetSpecialValueFor( "speed" )
	local start_radius = self:GetSpecialValueFor( "start_radius" )
	local end_radius = self:GetSpecialValueFor( "radius" )

	-- create ring
	local ring = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_ring_lua", -- modifier name
		{
			start_radius = start_radius,
			end_radius = end_radius,
			speed = speed,
			target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			IsCircle = 0,
		} -- kv
	)
	ring:SetCallback( function( enemy )
		-- add modifier
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_creep_nova_lua", -- modifier name
			{ duration = duration } -- kv
		)

		-- play effects
		local sound_cast = "Hero_Venomancer.PoisonNovaImpact"
		EmitSoundOn( sound_cast, enemy )
	end)

	-- play effects
	self:PlayEffects( ring, speed )
end

function creep_nova_lua:PlayEffects( modifier, speed )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf"
	local sound_cast = "Hero_Venomancer.PoisonNova"

	-- get data
	local duration = 1

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( speed, duration, speed ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
modifier_creep_nova_lua = class({})

function modifier_creep_nova_lua:IsHidden()
	return false
end

function modifier_creep_nova_lua:IsDebuff()
	return true
end

function modifier_creep_nova_lua:IsStunDebuff()
	return false
end

function modifier_creep_nova_lua:IsPurgable()
	return false
end

function modifier_creep_nova_lua:OnCreated( kv )
	self.parent = self:GetParent()

	local damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end

	local interval = 1

	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL, --Optional.
	}
	self:StartIntervalThink( interval )
	self:OnIntervalThink()
end

function modifier_creep_nova_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_creep_nova_lua:OnRemoved()
end

function modifier_creep_nova_lua:OnDestroy()
end

function modifier_creep_nova_lua:OnIntervalThink()
	if self.parent:IsMagicImmune() then return end

	ApplyDamage( self.damageTable )
end

function modifier_creep_nova_lua:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf"
end

function modifier_creep_nova_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creep_nova_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_poison_venomancer.vpcf"
end

function modifier_creep_nova_lua:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end