modifier_item_str_3_set_1 = class({})

function modifier_item_str_3_set_1:IsHidden()
	return true
end

function modifier_item_str_3_set_1:IsPurgable()
	return false
end

function modifier_item_str_3_set_1:RemoveOnDeath()
	return false
end

function modifier_item_str_3_set_1:OnCreated( kv )
end

function modifier_item_str_3_set_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

function modifier_item_str_3_set_1:GetModifierBonusStats_Strength( params )
	return self:GetCaster():GetLevel() * 2
end

function modifier_item_str_3_set_1:GetModifierBonusStats_Agility( params )
	return self:GetCaster():GetLevel() * 2
end

function modifier_item_str_3_set_1:GetModifierBonusStats_Intellect( params )
	return self:GetCaster():GetLevel() * 2
end