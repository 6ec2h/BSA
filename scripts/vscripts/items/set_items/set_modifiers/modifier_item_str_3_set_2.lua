modifier_item_str_3_set_2 = class({})

function modifier_item_str_3_set_2:IsHidden()
	return true
end

function modifier_item_str_3_set_2:IsPurgable()
	return false
end

function modifier_item_str_3_set_2:RemoveOnDeath( kv )
	return false
end

function modifier_item_str_3_set_2:OnCreated( kv )
end

function modifier_item_str_3_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifier_item_str_3_set_2:GetModifierBonusStats_Strength( params )
	return self:GetCaster():GetLevel() * 3
end