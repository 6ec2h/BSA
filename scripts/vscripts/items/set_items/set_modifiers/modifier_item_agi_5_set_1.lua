modifier_item_agi_5_set_1 = class({})

function modifier_item_agi_5_set_1:IsHidden()
	return true
end

function modifier_item_agi_5_set_1:IsPurgable()
	return false
end

function modifier_item_agi_5_set_1:RemoveOnDeath()
	return false
end

function modifier_item_agi_5_set_1:OnCreated( kv )
end

function modifier_item_agi_5_set_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
	return funcs
end

function modifier_item_agi_5_set_1:GetModifierPreAttack_CriticalStrike( params )
	if RandomInt(0,100) <= self:GetCaster():GetLevel() then
		return 200
	end
	return 0
end