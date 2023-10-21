modifier_item_int_5_set_2 = class({})

function modifier_item_int_5_set_2:IsHidden()
	return true
end

function modifier_item_int_5_set_2:IsPurgable()
	return false
end

function modifier_item_int_5_set_2:RemoveOnDeath()
	return false
end

function modifier_item_int_5_set_2:OnCreated( kv )
end

function modifier_item_int_5_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end

function modifier_item_int_5_set_2:GetModifierPercentageCooldown( params )
	return self:GetCaster():GetLevel()
end