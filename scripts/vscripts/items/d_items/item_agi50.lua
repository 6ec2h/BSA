item_agi_50 = class({})

function item_agi_50:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

function item_agi_50:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false  then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

function item_agi_50:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end

	return self.BaseClass.IsMuted( self )
end
-----------------------------------------------------------------------------------------------------------
function item_agi_50:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hPlayer =  hCaster:GetPlayerOwner()
		if hCaster and hCaster:IsRealHero() and not hCaster:IsTempestDouble() then          
	       if hPlayer then        
			  	
				if hCaster:GetPrimaryAttribute() == 1 then
				hCaster:SetBaseAgility(hCaster:GetBaseAgility() + 50)
				else
				local atribute = hCaster:GetPrimaryAttribute()
					if atribute == 0 then
					hCaster:SetBaseAgility(hCaster:GetBaseAgility() + 30)
					end
					if atribute == 2 then
					hCaster:SetBaseAgility(hCaster:GetBaseAgility() + 30)
					end
				end	
				
		       self:SpendCharge(0)    
		       local nPlayerID = hPlayer:GetPlayerID()
	           EmitSoundOnClient("Item.TomeOfKnowledge",hPlayer)
	       end
		end
	end
end