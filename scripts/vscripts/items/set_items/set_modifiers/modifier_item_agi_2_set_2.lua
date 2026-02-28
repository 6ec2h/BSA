modifier_item_agi_2_set_2 = class({})

function modifier_item_agi_2_set_2:IsHidden()
	return true
end

function modifier_item_agi_2_set_2:IsPurgable()
	return false
end

function modifier_item_agi_2_set_2:RemoveOnDeath( kv )
	return false
end

function modifier_item_agi_2_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_item_agi_2_set_2:GetModifierConstantHealthRegen( params )
	return self:GetCaster():GetLevel() * 3
end	