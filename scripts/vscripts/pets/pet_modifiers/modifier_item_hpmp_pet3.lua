modifier_item_hpmp_pet3 = class({})

function modifier_item_hpmp_pet3:IsHidden()
	return true
end

function modifier_item_hpmp_pet3:IsPurgable()
	return false
end

function modifier_item_hpmp_pet3:RemoveOnDeath()
	return false
end

function modifier_item_hpmp_pet3:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("hpmp_pet3", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			for i = 1, 3 do
				self.pet:AddItemByName("item_slot_block")
			end				
		end
	end
end

function modifier_item_hpmp_pet3:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_item_hpmp_pet3:GetModifierHealthBonus( params )
	return self:GetCaster():GetLevel() * 40
end

function modifier_item_hpmp_pet3:GetModifierManaBonus( params )
	return self:GetCaster():GetLevel() * 40
end

function modifier_item_hpmp_pet3:GetModifierPercentageCooldown( params )
	return self:GetCaster():GetLevel() * 0.8
end

function modifier_item_hpmp_pet3:GetModifierMagicalResistanceBonus( params )
	return self:GetCaster():GetLevel()
end
