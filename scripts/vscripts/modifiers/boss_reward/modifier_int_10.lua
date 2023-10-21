modifier_int_10 = class({})

function modifier_int_10:IsHidden()
	return true
end

function modifier_int_10:IsPurgable()
	return false
end

function modifier_int_10:RemoveOnDeath()
	return false
end

function modifier_int_10:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_int_10:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

function modifier_int_10:GetModifierBonusStats_Intellect()
	return 10
end