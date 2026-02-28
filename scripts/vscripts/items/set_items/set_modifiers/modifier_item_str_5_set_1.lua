modifier_item_str_5_set_1 = class({})

function modifier_item_str_5_set_1:IsHidden()
	return true
end

function modifier_item_str_5_set_1:IsPurgable()
	return false
end

function modifier_item_str_5_set_1:RemoveOnDeath()
	return false
end

function modifier_item_str_5_set_1:OnCreated( kv )
end

function modifier_item_str_5_set_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}
	return funcs
end

function modifier_item_str_5_set_1:GetModifierTotal_ConstantBlock( params )
	if RandomInt(0,100) <= self:GetCaster():GetLevel() * 0.5 then
		return 50
	end
	return 0
end