modifier_item_int_3_set_2 = class({})

function modifier_item_int_3_set_2:IsHidden()
	return true
end

function modifier_item_int_3_set_2:IsPurgable()
	return false
end

function modifier_item_int_3_set_2:RemoveOnDeath()
	return false
end

function modifier_item_int_3_set_2:OnCreated( kv )
end


function modifier_item_int_3_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_item_int_3_set_2:GetModifierConstantManaRegen( params )
	return self:GetCaster():GetLevel() * 3
end

function modifier_item_int_3_set_2:GetModifierConstantHealthRegen( params )
	return self:GetCaster():GetLevel() * 3
end	