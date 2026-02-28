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