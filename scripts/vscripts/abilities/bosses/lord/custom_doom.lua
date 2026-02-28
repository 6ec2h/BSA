LinkLuaModifier( "modifier_custom_doom", "abilities/bosses/lord/custom_doom", LUA_MODIFIER_MOTION_NONE )

custom_doom = class({})

function custom_doom:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor( "duration" )
	target:AddNewModifier(caster, self, "modifier_custom_doom", { duration = duration })
end

------------------------------------------------------------

modifier_custom_doom = class({})

function modifier_custom_doom:IsHidden()
	return false
end

function modifier_custom_doom:IsDebuff()
	return true
end

function modifier_custom_doom:IsStunDebuff()
	return false
end

function modifier_custom_doom:IsPurgable()
	return false
end

function modifier_custom_doom:GetTexture()
	return "doom"
end

function modifier_custom_doom:OnCreated( kv )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.interval = 1
	self.check_radius = 900
	if not IsServer() then return end
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage( self.damageTable )

	self:StartIntervalThink( self.interval )
	self:PlayEffects()
end

function modifier_custom_doom:OnRefresh( kv )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	if not IsServer() then return end
	self.damageTable.damage = damage
	EmitSoundOn( "Hero_DoomBringer.Doom", self:GetParent() )
end

function modifier_custom_doom:OnRemoved()
end

function modifier_custom_doom:OnDestroy()
	if not IsServer() then return end
	StopSoundOn( "Hero_DoomBringer.Doom", self:GetParent() )
end

function modifier_custom_doom:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
	return state
end

function modifier_custom_doom:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

function modifier_custom_doom:GetStatusEffectName()
	return "particles/status_fx/status_effect_doom.vpcf"
end

function modifier_custom_doom:StatusEffectPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_custom_doom:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(effect_cast, false, false, MODIFIER_PRIORITY_SUPER_ULTRA, false, false)
	EmitSoundOn( "Hero_DoomBringer.Doom", self:GetParent() )
end