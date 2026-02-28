modifier_item_armor_pet2 = class({})

function modifier_item_armor_pet2:IsHidden()
	return true
end

function modifier_item_armor_pet2:IsPurgable()
	return false
end

function modifier_item_armor_pet2:RemoveOnDeath()
	return false
end

function modifier_item_armor_pet2:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("armor_pet2", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			for i = 1, 4 do
				self.pet:AddItemByName("item_slot_block")
			end	
		end
	end
end

function modifier_item_armor_pet2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_armor_pet2:GetModifierPhysicalArmorBonus( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_armor_pet2:GetModifierMoveSpeedBonus_Constant( params )
	return self:GetCaster():GetLevel() * 2
end