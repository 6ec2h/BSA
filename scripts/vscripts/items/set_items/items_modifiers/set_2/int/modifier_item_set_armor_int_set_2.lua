require('rules')

modifier_item_set_armor_int_set_2 = class({})

function modifier_item_set_armor_int_set_2:IsHidden()
	return true
end

function modifier_item_set_armor_int_set_2:IsPurgable()
	return false
end

function modifier_item_set_armor_int_set_2:RemoveOnDeath()
	return false
end

function modifier_item_set_armor_int_set_2:OnCreated( kv )
	self.result = {
		["bonus_armor"] = 0,
		["bonus_int"] = 0,
		["bonus_mp_reg"] = 0,
		["bonus_mp"] = 0,
	}
	item_name = self:GetAbility():GetName()
	rules:GetItemValues(item_name, self)
end

function modifier_item_set_armor_int_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_BONUS,
	}
	return funcs
end

function modifier_item_set_armor_int_set_2:GetModifierPhysicalArmorBonus( params )
	return self.result["bonus_armor"]
end

function modifier_item_set_armor_int_set_2:GetModifierBonusStats_Intellect( params )
	return self.result["bonus_int"]
end

function modifier_item_set_armor_int_set_2:GetModifierTotalPercentageManaRegen( params )
	return self.result["bonus_mp_reg"]
end

function modifier_item_set_armor_int_set_2:GetModifierManaBonus( params )
	return self.result["bonus_mp"]
end