modifier_item_hpmp_pet6 = class({})

function modifier_item_hpmp_pet6:IsHidden()
	return true
end

function modifier_item_hpmp_pet6:IsPurgable()
	return false
end

function modifier_item_hpmp_pet6:RemoveOnDeath()
	return false
end

function modifier_item_hpmp_pet6:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("hpmp_pet6", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
		end
	end
end

function modifier_item_hpmp_pet6:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
	return funcs
end

function modifier_item_hpmp_pet6:GetModifierHealthBonus( params )
	return self:GetCaster():GetLevel() * 40
end

function modifier_item_hpmp_pet6:GetModifierManaBonus( params )
	return self:GetCaster():GetLevel() * 40
end

function modifier_item_hpmp_pet6:GetModifierPercentageCooldown( params )
	return self:GetCaster():GetLevel() * 0.8
end

function modifier_item_hpmp_pet6:GetModifierMagicalResistanceBonus( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_hpmp_pet6:GetModifierEvasion_Constant( params )
	return self:GetCaster():GetLevel() * 0.8
end

function modifier_item_hpmp_pet6:GetModifierPreAttack_CriticalStrike( params )
	if RandomInt(0,100) <= (self:GetCaster():GetLevel() * 2) / 3 then
		return self:GetCaster():GetLevel() * 7
	else 
		return 0
	end
end

