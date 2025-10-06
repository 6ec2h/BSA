modifier_spell_10 = class({})

function modifier_spell_10:IsHidden()
	return true
end

function modifier_spell_10:IsPurgable()
	return false
end

function modifier_spell_10:RemoveOnDeath()
	return false
end

function modifier_spell_10:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_spell_10:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifier_spell_10:GetModifierSpellAmplify_Percentage()
	return 4
end