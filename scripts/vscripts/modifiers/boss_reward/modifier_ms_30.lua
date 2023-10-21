modifier_ms_30 = class({})

function modifier_ms_30:IsHidden()
	return true
end

function modifier_ms_30:IsPurgable()
	return false
end

function modifier_ms_30:RemoveOnDeath()
	return false
end

function modifier_ms_30:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_ms_30:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_ms_30:GetModifierMoveSpeedBonus_Constant()
	return 30
end