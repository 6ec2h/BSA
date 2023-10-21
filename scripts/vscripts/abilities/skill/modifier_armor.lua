modifier_armor = class({})

function modifier_armor:IsHidden()
	return true
end

function modifier_armor:IsPurgable()
	return false
end

function modifier_armor:RemoveOnDeath()
	return false
end

function modifier_armor:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_armor:GetModifierPhysicalArmorBonus()
	return math.floor(0.5 * self:GetStackCount())
end