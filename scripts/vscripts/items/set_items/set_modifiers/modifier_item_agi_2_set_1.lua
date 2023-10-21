modifier_item_agi_2_set_1 = class({})

function modifier_item_agi_2_set_1:IsHidden()
	return true
end

function modifier_item_agi_2_set_1:IsPurgable()
	return false
end

function modifier_item_agi_2_set_1:RemoveOnDeath( kv )
	return false
end

function modifier_item_agi_2_set_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_item_agi_2_set_1:GetModifierConstantManaRegen( params )
	return self:GetCaster():GetLevel() * 2
end

function modifier_item_agi_2_set_1:GetModifierConstantHealthRegen( params )
	return self:GetCaster():GetLevel() * 2
end	