modifier_item_str_2_set_1 = class({})

function modifier_item_str_2_set_1:IsHidden()
	return false
end

function modifier_item_str_2_set_1:IsPurgable()
	return false
end

function modifier_item_str_2_set_1:RemoveOnDeath()
	return false
end

function modifier_item_str_2_set_1:OnCreated( kv )
end

function modifier_item_str_2_set_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
	return funcs
end

function modifier_item_str_2_set_1:GetModifierHealthBonus( params )
	return self:GetCaster():GetLevel() * 100
end