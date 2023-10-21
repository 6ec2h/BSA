modifier_item_int_6_set_2 = class({})

function modifier_item_int_6_set_2:IsHidden()
	return true
end

function modifier_item_int_6_set_2:IsPurgable()
	return false
end

function modifier_item_int_6_set_2:RemoveOnDeath()
	return false
end

function modifier_item_int_6_set_2:OnCreated( kv )
end

function modifier_item_int_6_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifier_item_int_6_set_2:GetModifierSpellAmplify_Percentage( params )
	return self:GetCaster():GetIntellect() * 0.2
end