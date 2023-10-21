modifier_cd_5 = class({})

function modifier_cd_5:IsHidden()
	return true
end

function modifier_cd_5:IsPurgable()
	return false
end

function modifier_cd_5:RemoveOnDeath()
	return false
end

function modifier_cd_5:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_cd_5:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end

function modifier_cd_5:GetModifierPercentageCooldown()
	return 5
end