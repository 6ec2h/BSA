modifier_item_agi_5_set_2 = class({})

function modifier_item_agi_5_set_2:IsHidden()
	return true
end

function modifier_item_agi_5_set_2:IsPurgable()
	return false
end

function modifier_item_agi_5_set_2:RemoveOnDeath()
	return false
end

function modifier_item_agi_5_set_2:OnCreated( kv )
end

function modifier_item_agi_5_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
	return funcs
end

function modifier_item_agi_5_set_2:GetModifierBaseAttack_BonusDamage( params )
	return self:GetCaster():GetLevel() * 10
end	