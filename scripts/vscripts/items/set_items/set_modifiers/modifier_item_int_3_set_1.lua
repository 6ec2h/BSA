modifier_item_int_3_set_1 = class({})

function modifier_item_int_3_set_1:IsHidden()
	return true
end

function modifier_item_int_3_set_1:IsPurgable()
	return false
end

function modifier_item_int_3_set_1:RemoveOnDeath()
	return false
end

function modifier_item_int_3_set_1:OnCreated( kv )
end

function modifier_item_int_3_set_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
	return funcs
end

function modifier_item_int_3_set_1:GetModifierPercentageManacost( params )
	return self:GetCaster():GetLevel() * 1.5
end