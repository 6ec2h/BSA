bristleback_passive = class({})
LinkLuaModifier( "modifier_bristleback_passive", "heroes/hero_bristleback/bristleback_passive/bristleback_passive.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bristleback_passive_armor", "heroes/hero_bristleback/bristleback_passive/bristleback_passive.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
function bristleback_passive:GetIntrinsicModifierName()
	return "modifier_bristleback_passive"
end

modifier_bristleback_passive = class({})

--------------------------------------------------------------------------------
function modifier_bristleback_passive:IsHidden()
	return true
end

function modifier_bristleback_passive:IsPurgable()
	return false
end

function modifier_bristleback_passive:OnCreated( kv )
	self.caster = self:GetCaster()
	self.bonus_hp = self:GetAbility():GetSpecialValueFor( "bonus_hp" )
	self.bonus_hpr = self:GetAbility():GetSpecialValueFor( "bonus_hpr" )
	self:SetStackCount(self.caster:GetStrength())
	self:StartIntervalThink(1)
end

function modifier_bristleback_passive:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.bonus_hp = self:GetAbility():GetSpecialValueFor( "bonus_hp" )
	self.bonus_hpr = self:GetAbility():GetSpecialValueFor( "bonus_hpr" )	
	self:SetStackCount(self.caster:GetStrength())
end

function modifier_bristleback_passive:OnIntervalThink()
self:OnRefresh()
end

--------------------------------------------------------------------------------
function modifier_bristleback_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	}
	return funcs
end

function modifier_bristleback_passive:GetModifierConstantHealthRegen()
	if not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor( "bonus_hpr" ) * self:GetStackCount()
	end
end

function modifier_bristleback_passive:GetModifierExtraHealthBonus()
	if not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor( "bonus_hp" ) * self:GetStackCount()
	end
end