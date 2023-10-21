item_str_50 = class({})

function item_str_50:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

function item_str_50:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false  then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

function item_str_50:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end

	return self.BaseClass.IsMuted( self )
end

function item_str_50:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hPlayer =  hCaster:GetPlayerOwner()
		if hCaster and hCaster:IsRealHero() and not hCaster:IsTempestDouble() then          
	       if hPlayer then        
			  
			  	if hCaster:GetPrimaryAttribute() == 0 then
				hCaster:SetBaseStrength(hCaster:GetBaseStrength() + 50)
				else
				local atribute = hCaster:GetPrimaryAttribute()
					if atribute == 1 then
					hCaster:SetBaseStrength(hCaster:GetBaseStrength() + 30)
					end
					if atribute == 2 then
					hCaster:SetBaseStrength(hCaster:GetBaseStrength() + 30)
					end
				end	
		
		       self:SpendCharge()    
		       local nPlayerID = hPlayer:GetPlayerID()
	           EmitSoundOnClient("Item.TomeOfKnowledge",hPlayer)
	       end
		end
	end
end
