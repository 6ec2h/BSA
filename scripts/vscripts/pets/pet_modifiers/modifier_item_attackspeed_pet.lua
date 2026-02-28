modifier_item_attackspeed_pet = class({})

function modifier_item_attackspeed_pet:IsHidden()
	return true
end

function modifier_item_attackspeed_pet:IsPurgable()
	return false
end

function modifier_item_attackspeed_pet:RemoveOnDeath()
	return false
end

function modifier_item_attackspeed_pet:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("attackspeed_pet", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			for i = 1, 5 do
				self.pet:AddItemByName("item_slot_block")
			end	
		end
	end
end

function modifier_item_attackspeed_pet:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_attackspeed_pet:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetCaster():GetLevel() * 3
end