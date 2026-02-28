modifier_item_str_4_set_2 = class({})

function modifier_item_str_4_set_2:IsHidden()
	return true
end

function modifier_item_str_4_set_2:IsPurgable()
	return false
end

function modifier_item_str_4_set_2:RemoveOnDeath()
	return false
end

function modifier_item_str_4_set_2:OnCreated( kv )
end

function modifier_item_str_4_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end

function modifier_item_str_4_set_2:GetModifierHealthRegenPercentage()
	return 3
end