modifier_item_stats_pet = class({})

function modifier_item_stats_pet:IsHidden()
	return true
end

function modifier_item_stats_pet:IsPurgable()
	return false
end

function modifier_item_stats_pet:RemoveOnDeath()
	return false
end

function modifier_item_stats_pet:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("stats_pet", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			for i = 1, 5 do
				self.pet:AddItemByName("item_slot_block")
			end				
		end
	end
end

function modifier_item_stats_pet:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

function modifier_item_stats_pet:GetModifierBonusStats_Strength( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_stats_pet:GetModifierBonusStats_Agility( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_stats_pet:GetModifierBonusStats_Intellect( params )
	return self:GetCaster():GetLevel()
end