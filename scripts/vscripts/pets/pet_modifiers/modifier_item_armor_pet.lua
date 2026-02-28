modifier_item_armor_pet = class({})

function modifier_item_armor_pet:IsHidden()
	return true
end

function modifier_item_armor_pet:IsPurgable()
	return false
end

function modifier_item_armor_pet:RemoveOnDeath()
	return false
end

function modifier_item_armor_pet:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("armor_pet", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			for i = 1, 5 do
				self.pet:AddItemByName("item_slot_block")
			end	
		end
	end
end

function modifier_item_armor_pet:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_item_armor_pet:GetModifierPhysicalArmorBonus( params )
	return self:GetCaster():GetLevel()
end