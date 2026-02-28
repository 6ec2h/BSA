modifier_item_agi_6_set_2 = class({})

function modifier_item_agi_6_set_2:IsHidden()
	return true
end

function modifier_item_agi_6_set_2:IsPurgable()
	return false
end

function modifier_item_agi_6_set_2:RemoveOnDeath()
	return false
end

function modifier_item_agi_6_set_2:OnCreated( kv )
end

function modifier_item_agi_6_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
	return funcs
end

function modifier_item_agi_6_set_2:GetModifierPreAttack_CriticalStrike( params )
	if RandomInt(0,100) <= 15 then
		return 10 * (10 + self:GetCaster():GetLevel())
	end
	return 0
end