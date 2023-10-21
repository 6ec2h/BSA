modifier_item_dmg_pet2 = class({})

function modifier_item_dmg_pet2:IsHidden()
	return true
end

function modifier_item_dmg_pet2:IsPurgable()
	return false
end

function modifier_item_dmg_pet2:RemoveOnDeath()
	return false
end

function modifier_item_dmg_pet2:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("dmg_pet2", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			for i = 1, 4 do
				self.pet:AddItemByName("item_slot_block")
			end	
		end
	end
end

function modifier_item_dmg_pet2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
	return funcs
end

function modifier_item_dmg_pet2:GetModifierPreAttack_BonusDamage( params )
	return self:GetCaster():GetLevel() * 10
end

function modifier_item_dmg_pet2:GetModifierConstantHealthRegen( params )
	return self:GetCaster():GetLevel() * 3.3
end