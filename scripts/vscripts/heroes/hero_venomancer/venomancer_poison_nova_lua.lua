venomancer_poison_nova_lua = class({})
LinkLuaModifier( "modifier_venomancer_poison_nova_lua", "heroes/hero_venomancer/venomancer_poison_nova_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_ring_lua", "heroes/generic/modifier_generic_ring_lua", LUA_MODIFIER_MOTION_NONE )

function venomancer_poison_nova_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_poison_venomancer.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf", context )
end

function venomancer_poison_nova_lua:Spawn()
	if not IsServer() then return end
end

function venomancer_poison_nova_lua:GetCastRange( pos, target )
	return self:GetSpecialValueFor( "radius" )
end

function venomancer_poison_nova_lua:GetCooldown( level )
	local talent = self:GetCaster():FindAbilityByName("npc_dota_hero_venomancer_4")
	if talent ~= nil and talent:GetLevel() > 0 then
		return self.BaseClass.GetCooldown( self, level ) - 40
	end

	return self.BaseClass.GetCooldown( self, level )
end

function venomancer_poison_nova_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )
	local speed = self:GetSpecialValueFor( "speed" )
	local start_radius = self:GetSpecialValueFor( "start_radius" )
	local end_radius = self:GetSpecialValueFor( "radius" )

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
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_venomancer_poison_nova_lua", -- modifier name
			{ duration = duration } -- kv
		)
		EmitSoundOn(  "Hero_Venomancer.PoisonNovaImpact", enemy )
	end)
	self:PlayEffects( ring, speed )
end

function venomancer_poison_nova_lua:PlayEffects( modifier, speed )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( speed, 1, speed ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Venomancer.PoisonNova", self:GetCaster() )
end

-------------------------------------------------

modifier_venomancer_poison_nova_lua = class({})

function modifier_venomancer_poison_nova_lua:IsHidden()
	return false
end

function modifier_venomancer_poison_nova_lua:IsDebuff()
	return true
end

function modifier_venomancer_poison_nova_lua:IsStunDebuff()
	return false
end

function modifier_venomancer_poison_nova_lua:IsPurgable()
	return false
end

function modifier_venomancer_poison_nova_lua:OnCreated( kv )
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

function modifier_venomancer_poison_nova_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_venomancer_poison_nova_lua:OnIntervalThink()
	if self.parent:IsMagicImmune() then return end
	ApplyDamage( self.damageTable )
end

function modifier_venomancer_poison_nova_lua:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf"
end

function modifier_venomancer_poison_nova_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_venomancer_poison_nova_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_poison_venomancer.vpcf"
end

function modifier_venomancer_poison_nova_lua:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end