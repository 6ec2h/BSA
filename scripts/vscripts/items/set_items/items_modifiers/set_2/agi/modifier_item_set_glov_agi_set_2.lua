require('rules')

modifier_item_set_glov_agi_set_2 = class({})

function modifier_item_set_glov_agi_set_2:IsHidden()
	return true
end

function modifier_item_set_glov_agi_set_2:IsPurgable()
	return false
end

function modifier_item_set_glov_agi_set_2:RemoveOnDeath()
	return false
end

function modifier_item_set_glov_agi_set_2:OnCreated( kv )
	self.result = {
		["bonus_attack_speed"] = 0,
		["bonus_armor"] = 0,
		["bonus_agi"] = 0,
	}
	item_name = self:GetAbility():GetName()
	rules:GetItemValues(item_name, self)
end

function modifier_item_set_glov_agi_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifier_item_set_glov_agi_set_2:GetModifierAttackSpeedBonus_Constant( params )
	return self.result["bonus_attack_speed"]
end

function modifier_item_set_glov_agi_set_2:GetModifierPhysicalArmorBonus( params )
	return self.result["bonus_armor"]
end

function modifier_item_set_glov_agi_set_2:GetModifierBonusStats_Agility( params )
	return self.result["bonus_agi"]
end