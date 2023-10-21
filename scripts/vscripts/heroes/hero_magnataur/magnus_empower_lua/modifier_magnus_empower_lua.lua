modifier_magnus_empower_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_magnus_empower_lua:IsHidden()
	return false
end

function modifier_magnus_empower_lua:IsDebuff()
	return false
end

function modifier_magnus_empower_lua:IsPurgable()
	return true
end

function modifier_magnus_empower_lua:OnCreated( kv )
	self.ability = self:GetAbility()

	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
	self.cleave = self:GetAbility():GetSpecialValueFor( "cleave_damage_pct" )
	self.mult = self:GetAbility():GetSpecialValueFor( "self_multiplier" )

	self.radius_start = self:GetAbility():GetSpecialValueFor( "cleave_starting_width" )
	self.radius_end = self:GetAbility():GetSpecialValueFor( "cleave_ending_width" )
	self.radius_dist = self:GetAbility():GetSpecialValueFor( "cleave_distance" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_magnus_agi3")
	if abil ~= nil and abil:GetLevel() > 0 then 
		self.cleave = self.cleave + 20
	end

	if self:GetParent()==self:GetCaster() then
		self.damage = self.damage*self.mult
		self.cleave = self.cleave*self.mult
	end
end

function modifier_magnus_empower_lua:OnRefresh( kv )
	self.ability = self:GetAbility()
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
	self.cleave = self:GetAbility():GetSpecialValueFor( "cleave_damage_pct" )
	self.mult = self:GetAbility():GetSpecialValueFor( "self_multiplier" )

	self.radius_start = self:GetAbility():GetSpecialValueFor( "cleave_starting_width" )
	self.radius_end = self:GetAbility():GetSpecialValueFor( "cleave_ending_width" )
	self.radius_dist = self:GetAbility():GetSpecialValueFor( "cleave_distance" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_magnus_agi3")
	if abil ~= nil and abil:GetLevel() > 0 then 
		self.cleave = self.cleave + 20
	end

	if self:GetParent()==self:GetCaster() then
		self.damage = self.damage*self.mult
		self.cleave = self.cleave*self.mult
	end
end

function modifier_magnus_empower_lua:OnRemoved()
end

function modifier_magnus_empower_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_magnus_empower_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifier_magnus_empower_lua:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if params.attacker:GetAttackCapability()~=DOTA_UNIT_CAP_MELEE_ATTACK then return end

	DoCleaveAttack(
		params.attacker,
		params.target,
		self.ability,
		params.damage*self.cleave/100,
		self.radius_start,
		self.radius_end,
		self.radius_dist,
		"particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf"
	)
end

function modifier_magnus_empower_lua:GetModifierDamageOutgoing_Percentage()
	return self.damage
end

function modifier_magnus_empower_lua:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_empower.vpcf"
end

function modifier_magnus_empower_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end