require('rules')

modifier_item_set_armor_str_set_1 = class({})

function modifier_item_set_armor_str_set_1:IsHidden()
	return true
end

function modifier_item_set_armor_str_set_1:IsPurgable()
	return false
end

function modifier_item_set_armor_str_set_1:RemoveOnDeath()
	return false
end

function modifier_item_set_armor_str_set_1:OnCreated( kv )
	self.result = {
		["bonus_hp_reg"] = 0,
		["bonus_armor"] = 0,
		["bonus_str"] = 0,
	}
	item_name = self:GetAbility():GetName()
	rules:GetItemValues(item_name, self)
end

function modifier_item_set_armor_str_set_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifier_item_set_armor_str_set_1:GetModifierHealthRegenPercentage( params )
	return self.result["bonus_hp_reg"]
end

function modifier_item_set_armor_str_set_1:GetModifierPhysicalArmorBonus( params )
	return self.result["bonus_armor"]
end

function modifier_item_set_armor_str_set_1:GetModifierBonusStats_Strength( params )
	return self.result["bonus_str"]
end