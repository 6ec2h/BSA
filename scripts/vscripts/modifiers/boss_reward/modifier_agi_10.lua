modifier_agi_10 = class({})

function modifier_agi_10:IsHidden()
	return true
end

function modifier_agi_10:IsPurgable()
	return false
end

function modifier_agi_10:RemoveOnDeath()
	return false
end

function modifier_agi_10:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_agi_10:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifier_agi_10:GetModifierBonusStats_Agility()
	return 10
end