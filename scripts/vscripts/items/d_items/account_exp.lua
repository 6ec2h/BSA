item_account_exp = class({})

function item_account_exp:OnSpellStart()
if GameRules:IsCheatMode() then return end
	if IsServer() then
		self.caster = self:GetCaster()	
			local playerID = self:GetCaster():GetPlayerID()
			self.caster:EmitSound("Item.TomeOfKnowledge")
			Shop:add_account_exp(250, playerID)
			self:SpendCharge()
			local new_charges = self:GetCurrentCharges()
			if new_charges <= 0 then
			self.caster:RemoveItem(self)
		end
	end
end