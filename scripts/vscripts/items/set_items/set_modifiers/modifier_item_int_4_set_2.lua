modifier_item_int_4_set_2 = class({})

function modifier_item_int_4_set_2:IsHidden()
	return true
end

function modifier_item_int_4_set_2:IsPurgable()
	return false
end

function modifier_item_int_4_set_2:RemoveOnDeath( kv )
	return false
end

function modifier_item_int_4_set_2:OnCreated( kv )
end


function modifier_item_int_4_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
	return funcs
end

function modifier_item_int_4_set_2:GetModifierPercentageManacost( params )
	return 25
end