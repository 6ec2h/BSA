modifier_silent = class({})

function modifier_silent:IsHidden()
    return true
end

function modifier_silent:IsPurgable()
    return false
end
function modifier_silent:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
	}
	return state
end

