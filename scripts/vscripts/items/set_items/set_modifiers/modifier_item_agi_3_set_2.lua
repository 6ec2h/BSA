modifier_item_agi_3_set_2 = class({})

function modifier_item_agi_3_set_2:IsHidden()
	return true
end

function modifier_item_agi_3_set_2:IsPurgable()
	return false
end

function modifier_item_agi_3_set_2:RemoveOnDeath()
	return false
end

function modifier_item_agi_3_set_2:OnCreated( kv )
end

function modifier_item_agi_3_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return funcs
end

function modifier_item_agi_3_set_2:GetModifierEvasion_Constant( params )
	return self:GetCaster():GetLevel()
end	