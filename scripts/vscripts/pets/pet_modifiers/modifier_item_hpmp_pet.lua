modifier_item_hpmp_pet = class({})

function modifier_item_hpmp_pet:IsHidden()
	return true
end

function modifier_item_hpmp_pet:IsPurgable()
	return false
end

function modifier_item_hpmp_pet:RemoveOnDeath()
	return false
end

function modifier_item_hpmp_pet:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("hpmp_pet", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			for i = 1, 5 do
				self.pet:AddItemByName("item_slot_block")
			end	
		end
	end
end

function modifier_item_hpmp_pet:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
	}
	return funcs
end

function modifier_item_hpmp_pet:GetModifierHealthBonus( params )
	return self:GetCaster():GetLevel() * 40
end

function modifier_item_hpmp_pet:GetModifierManaBonus( params )
	return self:GetCaster():GetLevel() * 40
end