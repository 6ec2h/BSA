require('rules')

modifier_item_set_boots_agi_set_2 = class({})

function modifier_item_set_boots_agi_set_2:IsHidden()
	return true
end

function modifier_item_set_boots_agi_set_2:IsPurgable()
	return false
end

function modifier_item_set_boots_agi_set_2:RemoveOnDeath()
	return false
end

function modifier_item_set_boots_agi_set_2:OnCreated( kv )
	self.result = {
		["bonus_speed"] = 0,
		["bonus_eva"] = 0,
		["bonus_agi"] = 0,
	}
	item_name = self:GetAbility():GetName()
	rules:GetItemValues(item_name, self)
end

function modifier_item_set_boots_agi_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifier_item_set_boots_agi_set_2:GetModifierMoveSpeedBonus_Percentage( params )
	return self.result["bonus_speed"]
end

function modifier_item_set_boots_agi_set_2:GetModifierEvasion_Constant( params )
	return self.result["bonus_eva"]
end

function modifier_item_set_boots_agi_set_2:GetModifierBonusStats_Agility( params )
	return self.result["bonus_agi"]
end