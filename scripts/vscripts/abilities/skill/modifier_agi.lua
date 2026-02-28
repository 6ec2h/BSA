modifier_agi = class({})

function modifier_agi:IsHidden()
	return true
end

function modifier_agi:IsPurgable()
	return false
end

function modifier_agi:RemoveOnDeath()
	return false
end

function modifier_agi:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_agi:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifier_agi:GetModifierBonusStats_Agility()
	return self:GetStackCount()
end