modifier_item_agi_4_set_1 = class({})

function modifier_item_agi_4_set_1:IsHidden()
	return true
end

function modifier_item_agi_4_set_1:IsPurgable()
	return false
end

function modifier_item_agi_4_set_1:RemoveOnDeath()
	return false
end

function modifier_item_agi_4_set_1:OnCreated( kv )
end

function modifier_item_agi_4_set_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_agi_4_set_1:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetCaster():GetLevel() * 3
end	