modifier_guild = class({})

function modifier_guild:IsHidden()
    return true
end

function modifier_guild:IsPurgable()
    return false
end

function modifier_guild:RemoveOnDeath()
    return false
end

function modifier_guild:SetupRewards(kv)
    self.reward_1 = kv.reward_1 or 0
    self.reward_2 = kv.reward_2 or 0
    self.reward_3 = kv.reward_3 or 0
    self.reward_4 = kv.reward_4 or 0
    self.reward_5 = kv.reward_5 or 0
    self.reward_6 = kv.reward_6 or 0
    self.perm_reward_1 = kv.perm_reward_1 or 0
    self.perm_reward_2 = kv.perm_reward_2 or 0
end

function modifier_guild:OnCreated(kv)
    if not IsServer() then return end
    self:SetupRewards(kv)
    self:StartIntervalThink(1)
end

function modifier_guild:OnRefresh(kv)
    if not IsServer() then return end
    self:SetupRewards(kv)
end

function modifier_guild:Spawn_bonus()
	if not IsServer() then return end
	self:GetParent():ModifyGold( 50 * self.reward_1, true, 0)
	if self.perm_reward_1 == 1 then
		local hModifierAegis = self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_aegis", {})
        hModifierAegis:SetStackCount(1)
	end
end

function modifier_guild:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

if IsServer() then 
	function modifier_guild:GetModifierIncomingDamage_Percentage()
		return -0.25*self.reward_2
	end

	function modifier_guild:GetModifierPercentageExpRateBoost()
		return 0.5 * self.reward_3
	end

	function modifier_guild:GetModifierDamageOutgoing_Percentage()
		return 0.25*self.reward_5
	end

	function modifier_guild:GetModifierBonusStats_Agility()
		return self.reward_6 * 0.2 * self:GetCaster():GetLevel()
	end

	function modifier_guild:GetModifierBonusStats_Strength()
		return self.reward_6 * 0.2 * self:GetCaster():GetLevel()
	end

	function modifier_guild:GetModifierBonusStats_Intellect()
		return self.reward_6 * 0.2 * self:GetCaster():GetLevel()
	end
end