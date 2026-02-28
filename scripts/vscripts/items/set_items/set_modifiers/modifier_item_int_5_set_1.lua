modifier_item_int_5_set_1 = class({})

function modifier_item_int_5_set_1:IsHidden()
	return true
end

function modifier_item_int_5_set_1:IsPurgable()
	return false
end

function modifier_item_int_5_set_1:RemoveOnDeath()
	return false
end

function modifier_item_int_5_set_1:OnCreated( kv )
end

function modifier_item_int_5_set_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end

function modifier_item_int_5_set_1:GetModifierPercentageCooldown( params )
	return (40 / 30) * self:GetCaster():GetLevel()
end