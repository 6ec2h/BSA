modifier_item_str_2_set_2 = class({})

function modifier_item_str_2_set_2:IsHidden()
	return false
end

function modifier_item_str_2_set_2:IsPurgable()
	return false
end

function modifier_item_str_2_set_2:RemoveOnDeath()
	return false
end

function modifier_item_str_2_set_2:OnCreated( kv )
end

function modifier_item_str_2_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_item_str_2_set_2:GetModifierPhysicalArmorBonus( params )
	return self:GetCaster():GetLevel()
end