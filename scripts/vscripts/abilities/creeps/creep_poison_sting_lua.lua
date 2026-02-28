LinkLuaModifier( "modifier_creep_poison_sting_lua", "abilities/creeps/creep_poison_sting_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creep_poison_sting_lua_debuff", "abilities/creeps/creep_poison_sting_lua", LUA_MODIFIER_MOTION_NONE )

creep_poison_sting_lua = class({})

function creep_poison_sting_lua:GetIntrinsicModifierName()
	return "modifier_creep_poison_sting_lua"
end

--------------------------------------------------------------------------------------------------

modifier_creep_poison_sting_lua = class({})

function modifier_creep_poison_sting_lua:IsHidden()
	return true
end

function modifier_creep_poison_sting_lua:IsDebuff()
	return false
end

function modifier_creep_poison_sting_lua:IsStunDebuff()
	return false
end

function modifier_creep_poison_sting_lua:IsPurgable()
	return false
end

function modifier_creep_poison_sting_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.team = self:GetCaster():GetTeamNumber()

	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )

	if not IsServer() then return end
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
	self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()
end

function modifier_creep_poison_sting_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_creep_poison_sting_lua:OnRemoved()
end

function modifier_creep_poison_sting_lua:OnDestroy()
end

function modifier_creep_poison_sting_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end

function modifier_creep_poison_sting_lua:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if self.caster:PassivesDisabled() then return end

	local filter = UnitFilter(
		params.target,
		self.abilityTargetTeam,
		self.abilityTargetType,
		self.abilityTargetFlags,
		self.team
	)
	if not filter==UF_SUCCESS then return end

	params.target:AddNewModifier(
		self.caster, -- player source
		self.ability, -- ability source
		"modifier_creep_poison_sting_lua_debuff", -- modifier name
		{ duration = self.duration } -- kv
	)
end

--------------------------------------------------------------------

modifier_creep_poison_sting_lua_debuff = class({})

function modifier_creep_poison_sting_lua_debuff:IsHidden()
	return false
end

function modifier_creep_poison_sting_lua_debuff:IsDebuff()
	return true
end

function modifier_creep_poison_sting_lua_debuff:IsStunDebuff()
	return false
end

function modifier_creep_poison_sting_lua_debuff:IsPurgable()
	return true
end

function modifier_creep_poison_sting_lua_debuff:OnCreated( kv )
	self.parent = self:GetParent()
	self.caster = self:GetCaster()

	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.slow = self:GetAbility():GetSpecialValueFor( "movement_speed" )

	if not IsServer() then return end

	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, --Optional.
	}
	self:StartIntervalThink( 1 )
	self:OnIntervalThink()
end

function modifier_creep_poison_sting_lua_debuff:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_creep_poison_sting_lua_debuff:OnRemoved()
end

function modifier_creep_poison_sting_lua_debuff:OnDestroy()
end

function modifier_creep_poison_sting_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_creep_poison_sting_lua_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_creep_poison_sting_lua_debuff:OnIntervalThink()
	ApplyDamage( self.damageTable )
	SendOverheadEventMessage(
		nil,
		OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
		self.parent,
		self.damageTable.damage,
		self.caster)
end

function modifier_creep_poison_sting_lua_debuff:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf"
end

function modifier_creep_poison_sting_lua_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end