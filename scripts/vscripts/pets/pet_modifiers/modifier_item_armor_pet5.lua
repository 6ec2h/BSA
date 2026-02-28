modifier_item_armor_pet5 = class({})

function modifier_item_armor_pet5:IsHidden()
	return true
end

function modifier_item_armor_pet5:IsPurgable()
	return false
end

function modifier_item_armor_pet5:RemoveOnDeath()
	return false
end

function modifier_item_armor_pet5:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("armor_pet5", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			self.pet:AddItemByName("item_slot_block")
		end
	end
end

function modifier_item_armor_pet5:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_item_armor_pet5:GetModifierPhysicalArmorBonus( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_armor_pet5:GetModifierMoveSpeedBonus_Constant( params )
	return self:GetCaster():GetLevel() * 2
end

function modifier_item_armor_pet5:GetModifierPreAttack_BonusDamage( params )
	return self:GetCaster():GetLevel() * 10
end

function modifier_item_armor_pet5:GetModifierConstantHealthRegen( params )
	return self:GetCaster():GetLevel() * 3.3
end