require('rules')

modifier_item_set_boots_str_set_2 = class({})

function modifier_item_set_boots_str_set_2:IsHidden()
	return true
end

function modifier_item_set_boots_str_set_2:IsPurgable()
	return false
end

function modifier_item_set_boots_str_set_2:RemoveOnDeath()
	return false
end

function modifier_item_set_boots_str_set_2:OnCreated( kv )
	self.result = {
		["bonus_speed"] = 0,
		["bonus_armor"] = 0,
		["bonus_hp"] = 0,
	}
	item_name = self:GetAbility():GetName()
	rules:GetItemValues(item_name, self)
end

function modifier_item_set_boots_str_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
	return funcs
end

function modifier_item_set_boots_str_set_2:GetModifierMoveSpeedBonus_Constant( params )
	return self.result["bonus_speed"]
end

function modifier_item_set_boots_str_set_2:GetModifierPhysicalArmorBonus( params )
	return self.result["bonus_armor"]
end

function modifier_item_set_boots_str_set_2:GetModifierHealthBonus( params )
	return self.result["bonus_hp"]
end