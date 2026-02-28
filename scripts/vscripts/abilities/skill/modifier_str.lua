modifier_str = class({})

function modifier_str:IsHidden()
	return true
end

function modifier_str:IsPurgable()
	return false
end

function modifier_str:RemoveOnDeath()
	return false
end

function modifier_str:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_str:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifier_str:GetModifierBonusStats_Strength()
	return self:GetStackCount()
end