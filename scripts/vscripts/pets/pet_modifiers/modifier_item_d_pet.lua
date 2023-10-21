modifier_item_d_pet = class({})

function modifier_item_d_pet:IsHidden()
	return true
end

function modifier_item_d_pet:IsPurgable()
	return false
end

function modifier_item_d_pet:RemoveOnDeath()
	return false
end

function modifier_item_d_pet:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("d_pet", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
		end
	end
end

function modifier_item_d_pet:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
	return funcs
end

function modifier_item_d_pet:GetModifierPhysicalArmorBonus( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_d_pet:GetModifierMoveSpeedBonus_Constant( params )
	return self:GetCaster():GetLevel() * 2
end

function modifier_item_d_pet:GetModifierPreAttack_BonusDamage( params )
	return self:GetCaster():GetLevel() * 10
end

function modifier_item_d_pet:GetModifierConstantHealthRegen( params )
	return self:GetCaster():GetLevel() * 3.3
end

function modifier_item_d_pet:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetCaster():GetLevel() * 3
end

function modifier_item_d_pet:GetModifierBonusStats_Strength( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_d_pet:GetModifierBonusStats_Agility( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_d_pet:GetModifierBonusStats_Intellect( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_d_pet:GetModifierSpellAmplify_Percentage( params )
	return self:GetCaster():GetLevel() * 0.8
end

function modifier_item_d_pet:GetModifierMagicalResistanceBonus( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_d_pet:GetModifierEvasion_Constant( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_d_pet:GetModifierHealthBonus( params )
	return self:GetCaster():GetLevel() * 40
end

function modifier_item_d_pet:GetModifierManaBonus( params )
	return self:GetCaster():GetLevel() * 40
end

function modifier_item_d_pet:GetModifierPercentageCooldown( params )
	return self:GetCaster():GetLevel() * 0.8
end

function modifier_item_d_pet:GetModifierPreAttack_CriticalStrike( params )
	if RandomInt(0,100) <= (self:GetCaster():GetLevel() * 2) / 3 then
		return self:GetCaster():GetLevel() * 7
	else 
		return 0
	end
end