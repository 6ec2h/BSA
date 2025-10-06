LinkLuaModifier( "modifier_drow_ranger_aura", "heroes/hero_drow_ranger/drow_ranger_aura/drow_ranger_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_aura_effect", "heroes/hero_drow_ranger/drow_ranger_aura/drow_ranger_aura", LUA_MODIFIER_MOTION_NONE )

drow_ranger_aura = class({})

function drow_ranger_aura:GetIntrinsicModifierName()
	return "modifier_drow_ranger_aura"
end

--------------------------------------------

modifier_drow_ranger_aura = class({})

function modifier_drow_ranger_aura:IsHidden()
	return true
end

function modifier_drow_ranger_aura:IsDebuff()
	return false
end

function modifier_drow_ranger_aura:IsPurgable()
	return false
end

function modifier_drow_ranger_aura:OnCreated()
	if self:GetCaster():IsIllusion() then return end
end

function modifier_drow_ranger_aura:IsAura()
	return (not self:GetCaster():PassivesDisabled() and self:GetAbility():GetLevel() > 0)
end

function modifier_drow_ranger_aura:GetModifierAura()
	return "modifier_drow_ranger_aura_effect"
end

function modifier_drow_ranger_aura:GetAuraRadius()
	return 700
end

function modifier_drow_ranger_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_drow_ranger_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------

modifier_drow_ranger_aura_effect = class({})

function modifier_drow_ranger_aura_effect:IsHidden()
	return false
end

function modifier_drow_ranger_aura_effect:IsDebuff()
	return false
end

function modifier_drow_ranger_aura_effect:IsPurgable()
	return false
end

function modifier_drow_ranger_aura_effect:OnCreated( kv )
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
end

function modifier_drow_ranger_aura_effect:OnRefresh( kv )
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
end

function modifier_drow_ranger_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_drow_ranger_aura_effect:GetModifierAttackSpeedBonus_Constant()

	return self:GetCaster():GetAgility() / 100 * self.speed
end