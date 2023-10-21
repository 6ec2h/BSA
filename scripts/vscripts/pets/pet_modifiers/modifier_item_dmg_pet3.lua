modifier_item_dmg_pet3 = class({})

function modifier_item_dmg_pet3:IsHidden()
	return true
end

function modifier_item_dmg_pet3:IsPurgable()
	return false
end

function modifier_item_dmg_pet3:RemoveOnDeath()
	return false
end

function modifier_item_dmg_pet3:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("dmg_pet3", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			for i = 1, 3 do
				self.pet:AddItemByName("item_slot_block")
			end	
		end
	end
end

function modifier_item_dmg_pet3:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
	return funcs
end

function modifier_item_dmg_pet3:GetModifierPreAttack_BonusDamage( params )
	return self:GetCaster():GetLevel() * 10
end

function modifier_item_dmg_pet3:GetModifierConstantHealthRegen( params )
	return self:GetCaster():GetLevel() * 3.3
end

function modifier_item_dmg_pet3:GetModifierEvasion_Constant( params )
	return self:GetCaster():GetLevel()
end
