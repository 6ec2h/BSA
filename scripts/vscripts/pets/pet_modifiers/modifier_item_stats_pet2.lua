modifier_item_stats_pet2 = class({})

function modifier_item_stats_pet2:IsHidden()
	return true
end

function modifier_item_stats_pet2:IsPurgable()
	return false
end

function modifier_item_stats_pet2:RemoveOnDeath()
	return false
end

function modifier_item_stats_pet2:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("stats_pet2", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			for i = 1, 4 do
				self.pet:AddItemByName("item_slot_block")
			end				
		end
	end
end

function modifier_item_stats_pet2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_item_stats_pet2:GetModifierBonusStats_Strength( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_stats_pet2:GetModifierBonusStats_Agility( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_stats_pet2:GetModifierBonusStats_Intellect( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_stats_pet2:GetModifierMagicalResistanceBonus( params )
	return self:GetCaster():GetLevel()
end