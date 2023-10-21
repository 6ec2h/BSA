modifier_item_stats_pet6 = class({})

function modifier_item_stats_pet6:IsHidden()
	return true
end

function modifier_item_stats_pet6:IsPurgable()
	return false
end

function modifier_item_stats_pet6:RemoveOnDeath()
	return false
end

function modifier_item_stats_pet6:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("stats_pet6", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
		end
	end
end

function modifier_item_stats_pet6:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
	return funcs
end

function modifier_item_stats_pet6:GetModifierBonusStats_Strength( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_stats_pet6:GetModifierBonusStats_Agility( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_stats_pet6:GetModifierBonusStats_Intellect( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_stats_pet6:GetModifierMagicalResistanceBonus( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_stats_pet6:GetModifierPercentageCooldown( params )
	return self:GetCaster():GetLevel() * 0.8
end

function modifier_item_stats_pet6:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetCaster():GetLevel() * 3
end

function modifier_item_stats_pet6:GetModifierPreAttack_CriticalStrike( params )
	if RandomInt(0,100) <= (self:GetCaster():GetLevel() * 2) / 3 then
		return self:GetCaster():GetLevel() * 7
	else 
		return 0
	end
end