modifier_item_armor_pet3 = class({})

function modifier_item_armor_pet3:IsHidden()
	return true
end

function modifier_item_armor_pet3:IsPurgable()
	return false
end

function modifier_item_armor_pet3:RemoveOnDeath()
	return false
end

function modifier_item_armor_pet3:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("armor_pet3", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			for i = 1, 3 do
				self.pet:AddItemByName("item_slot_block")
			end	
		end
	end
end

function modifier_item_armor_pet3:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_item_armor_pet3:GetModifierPhysicalArmorBonus( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_armor_pet3:GetModifierMoveSpeedBonus_Constant( params )
	return self:GetCaster():GetLevel() * 2
end

function modifier_item_armor_pet3:GetModifierPreAttack_BonusDamage( params )
	return self:GetCaster():GetLevel() * 10
end