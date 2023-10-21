modifier_item_dmg_pet4 = class({})

function modifier_item_dmg_pet4:IsHidden()
	return true
end

function modifier_item_dmg_pet4:IsPurgable()
	return false
end

function modifier_item_dmg_pet4:RemoveOnDeath()
	return false
end

function modifier_item_dmg_pet4:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("dmg_pet4", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			for i = 1, 2 do
				self.pet:AddItemByName("item_slot_block")
			end				
		end
	end
end

function modifier_item_dmg_pet4:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_item_dmg_pet4:GetModifierPreAttack_BonusDamage( params )
	return self:GetCaster():GetLevel() * 10
end

function modifier_item_dmg_pet4:GetModifierConstantHealthRegen( params )
	return self:GetCaster():GetLevel() * 3.3
end

function modifier_item_dmg_pet4:GetModifierEvasion_Constant( params )
	return self:GetCaster():GetLevel()
end

function modifier_item_dmg_pet4:GetModifierMagicalResistanceBonus( params )
	return self:GetCaster():GetLevel()
end