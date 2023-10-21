modifier_item_agi_6_set_1 = class({})

function modifier_item_agi_6_set_1:IsHidden()
	return true
end

function modifier_item_agi_6_set_1:IsPurgable()
	return false
end

function modifier_item_agi_6_set_1:RemoveOnDeath()
	return false
end

function modifier_item_agi_6_set_1:OnCreated( kv )
end

function modifier_item_agi_6_set_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
	return funcs
end

function modifier_item_agi_6_set_1:GetModifierBaseAttack_BonusDamage( params )
	return self:GetCaster():GetLevel() * 20
end	