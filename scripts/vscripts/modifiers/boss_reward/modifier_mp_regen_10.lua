modifier_mp_regen_10 = class({})

function modifier_mp_regen_10:IsHidden()
	return true
end

function modifier_mp_regen_10:IsPurgable()
	return false
end

function modifier_mp_regen_10:RemoveOnDeath()
	return false
end

function modifier_mp_regen_10:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_mp_regen_10:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_mp_regen_10:GetModifierConstantManaRegen()
	return 10
end