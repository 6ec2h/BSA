require('rules')

modifier_item_set_armor_int_set_1 = class({})

function modifier_item_set_armor_int_set_1:IsHidden()
	return true
end

function modifier_item_set_armor_int_set_1:IsPurgable()
	return false
end

function modifier_item_set_armor_int_set_1:RemoveOnDeath()
	return false
end

function modifier_item_set_armor_int_set_1:OnCreated( kv )
	self.result = {
		["bonus_hp_reg"] = 0,
		["bonus_armor"] = 0,
		["bonus_int"] = 0,
		["bonus_mp_reg"] = 0,
		["bonus_hp"] = 0,
	}
	item_name = self:GetAbility():GetName()
	rules:GetItemValues(item_name, self)
end

function modifier_item_set_armor_int_set_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifier_item_set_armor_int_set_1:GetModifierHealthRegenPercentage( params )
	return self.result["bonus_hp_reg"]
end

function modifier_item_set_armor_int_set_1:GetModifierPhysicalArmorBonus( params )
	return self.result["bonus_armor"]
end

function modifier_item_set_armor_int_set_1:GetModifierBonusStats_Intellect( params )
	return self.result["bonus_int"]
end

function modifier_item_set_armor_int_set_1:GetModifierTotalPercentageManaRegen( params )
	return self.result["bonus_mp_reg"]
end

function modifier_item_set_armor_int_set_1:GetModifierHPRegenAmplify_Percentage( params )
	return self.result["bonus_hp"]
end