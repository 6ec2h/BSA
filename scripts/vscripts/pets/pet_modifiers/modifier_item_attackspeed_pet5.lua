modifier_item_attackspeed_pet5 = class({})

function modifier_item_attackspeed_pet5:IsHidden()
	return true
end

function modifier_item_attackspeed_pet5:IsPurgable()
	return false
end

function modifier_item_attackspeed_pet5:RemoveOnDeath()
	return false
end

function modifier_item_attackspeed_pet5:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("attackspeed_pet5", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			self.pet:AddItemByName("item_slot_block")
		end
	end
end

function modifier_item_attackspeed_pet5:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_item_attackspeed_pet5:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetCaster():GetLevel() * 3
end

function modifier_item_attackspeed_pet5:GetModifierSpellAmplify_Percentage( params )
	return self:GetCaster():GetLevel() * 0.8
end

function modifier_item_attackspeed_pet5:GetModifierBonusStats_Agility( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_attackspeed_pet5:GetModifierBonusStats_Intellect( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_attackspeed_pet5:GetModifierSpellAmplify_Percentage( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_attackspeed_pet5:GetModifierMagicalResistanceBonus( params )
	return self:GetCaster():GetLevel()
end