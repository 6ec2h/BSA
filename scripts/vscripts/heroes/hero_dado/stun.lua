modifier_generic_stunned_lua = class({})

--------------------------------------------------------------------------------

function modifier_generic_stunned_lua:IsDebuff()
	return true
end

function modifier_generic_stunned_lua:IsRooted()
	return true
end

--------------------------------------------------------------------------------

function modifier_generic_stunned_lua:CheckState()
	local state = {
	[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_generic_stunned_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_generic_stunned_lua:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_generic_stunned_lua:GetEffectName()
	return "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_purge_root_ribbon.vpcf"
end

function modifier_generic_stunned_lua:GetEffectAttachType()
	return PATTACH_WORLDORIGIN
end