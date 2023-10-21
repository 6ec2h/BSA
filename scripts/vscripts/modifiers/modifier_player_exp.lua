modifier_player_exp = class({})

function modifier_player_exp:IsHidden()
	return false
end

function modifier_player_exp:IsPurgable()
	return false
end

function modifier_player_exp:RemoveOnDeath()
	return false
end

function modifier_player_exp:GetTexture()
	return "playerexp"
end

function modifier_player_exp:OnCreated()
end

function modifier_player_exp:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
		MODIFIER_PROPERTY_TOOLTIP
		}
	return funcs
end

function modifier_player_exp:GetModifierPercentageExpRateBoost()
	return -(100 - self:GetStackCount())
end

function modifier_player_exp:OnTooltip()
	return self:GetStackCount()
end
