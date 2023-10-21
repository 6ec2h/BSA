modifier_item_armor_pet6 = class({})

function modifier_item_armor_pet6:IsHidden()
	return true
end

function modifier_item_armor_pet6:IsPurgable()
	return false
end

function modifier_item_armor_pet6:RemoveOnDeath()
	return false
end

function modifier_item_armor_pet6:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("armor_pet6", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
		end
	end
end

function modifier_item_armor_pet6:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
	return funcs
end

function modifier_item_armor_pet6:GetModifierPhysicalArmorBonus( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_armor_pet6:GetModifierMoveSpeedBonus_Constant( params )
	return self:GetCaster():GetLevel() * 2
end

function modifier_item_armor_pet6:GetModifierPreAttack_BonusDamage( params )
	return self:GetCaster():GetLevel() * 10
end

function modifier_item_armor_pet6:GetModifierConstantHealthRegen( params )
	return self:GetCaster():GetLevel() * 3.3
end

function modifier_item_armor_pet6:GetModifierPreAttack_CriticalStrike( params )
	if RandomInt(0,100) <= (self:GetCaster():GetLevel() * 2) / 3 then
		return self:GetCaster():GetLevel() * 7
	else 
		return 0
	end
end