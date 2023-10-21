modifier_item_str_6_set_1 = class({})

function modifier_item_str_6_set_1:IsHidden()
	return true
end

function modifier_item_str_6_set_1:IsPurgable()
	return false
end

function modifier_item_str_6_set_1:RemoveOnDeath()
	return false
end

function modifier_item_str_6_set_1:OnCreated( kv )
end

function modifier_item_str_6_set_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function modifier_item_str_6_set_1:GetModifierIncomingDamage_Percentage( params )
	return -25
end	