modifier_item_dmg_pet = class({})

function modifier_item_dmg_pet:IsHidden()
	return true
end

function modifier_item_dmg_pet:IsPurgable()
	return false
end

function modifier_item_dmg_pet:RemoveOnDeath()
	return false
end

function modifier_item_dmg_pet:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("dmg_pet", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			for i = 1, 5 do
				self.pet:AddItemByName("item_slot_block")
			end	
		end
	end
end

function modifier_item_dmg_pet:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_item_dmg_pet:GetModifierPreAttack_BonusDamage( params )
	return self:GetCaster():GetLevel() * 10
end