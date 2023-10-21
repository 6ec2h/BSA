modifier_item_spell_pet = class({})

function modifier_item_spell_pet:IsHidden()
	return true
end

function modifier_item_spell_pet:IsPurgable()
	return false
end

function modifier_item_spell_pet:RemoveOnDeath()
	return false
end

function modifier_item_spell_pet:OnCreated()
	if IsServer() then
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("spell_pet", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			for i = 1, 5 do
				self.pet:AddItemByName("item_slot_block")
			end				
		end
	end
end

function modifier_item_spell_pet:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifier_item_spell_pet:GetModifierSpellAmplify_Percentage( params )
	return self:GetCaster():GetLevel() * 0.8
end