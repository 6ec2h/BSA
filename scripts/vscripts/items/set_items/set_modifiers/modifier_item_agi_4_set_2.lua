modifier_item_agi_4_set_2 = class({})

function modifier_item_agi_4_set_2:IsHidden()
	return true
end

function modifier_item_agi_4_set_2:IsPurgable()
	return false
end

function modifier_item_agi_4_set_2:RemoveOnDeath( kv )
	return false
end

function modifier_item_agi_4_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

function modifier_item_agi_4_set_2:GetModifierBonusStats_Strength( params )
	return self:GetCaster():GetLevel() * 2
end

function modifier_item_agi_4_set_2:GetModifierBonusStats_Agility( params )
	return self:GetCaster():GetLevel() * 2
end

function modifier_item_agi_4_set_2:GetModifierBonusStats_Intellect( params )
	return self:GetCaster():GetLevel() * 2
end
