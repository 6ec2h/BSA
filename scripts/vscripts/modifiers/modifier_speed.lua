modifier_speed = class({})

function modifier_speed:IsHidden()
    return true
end

function modifier_speed:IsPurgable()
    return false
end

function modifier_speed:RemoveOnDeath()
    return false
end

function modifier_speed:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE

    }
    return funcs
end

function modifier_speed:GetModifierMoveSpeedOverride()
	return 1000
end

function modifier_speed:GetModifierMoveSpeed_Limit()
	return 1000
end

function modifier_speed:GetModifierMoveSpeed_Max()
	return 1000
end

function modifier_speed:GetModifierMoveSpeed_Absolute()
	return 1000
end

function modifier_speed:GetModifierSpellAmplify_Percentage()
	return 1000
end