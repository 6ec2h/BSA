if modifier_difficult == nil then
	modifier_difficult = class({})
end

function modifier_difficult:IsHidden()
	return false
end

function modifier_difficult:IsPurgable()
	return false
end

function modifier_difficult:RemoveOnDeath()
	return false
end

function modifier_difficult:OnCreated()
	if not IsServer() then return end
	local unit = self:GetParent()
	local start_health = unit:GetMaxHealth()
	if unit:GetUnitName() == "NYX" then
		print(0.4 + (_G.Game_Difficulty * 2) / 10)
		print((0.4 + (_G.Game_Difficulty * 2) / 10) * 100)
		print(((0.4 + (_G.Game_Difficulty * 2) / 10) * 100)-100)
		print((start_health * (((0.4 + (_G.Game_Difficulty * 2) / 10) * 100)-100)) / 100)
		print(start_health + (start_health * (((0.4 + (_G.Game_Difficulty * 2) / 10) * 100)-100)) / 100)
	end
	local set_health = start_health + (start_health * (((0.4 + (_G.Game_Difficulty * 2) / 10) * 100)-100)) / 100
	unit:SetMaxHealth(set_health)
	unit:SetBaseMaxHealth(set_health)
	unit:SetHealth(set_health)	
end

function modifier_difficult:GetTexture()
    return "difficult"
end

function modifier_difficult:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		-- MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
    return funcs
end

function modifier_difficult:GetModifierDamageOutgoing_Percentage()	 		
	return ((0.4 + (self:GetStackCount() * 2) / 10) * 100) - 100  
end

function modifier_difficult:GetModifierIncomingDamage_Percentage()	 		
	return ((1.6 - self:GetStackCount()/10) * 100) - 100
end

-- function modifier_difficult:GetModifierExtraHealthPercentage()
	-- return ((0.4 + (self:GetStackCount() * 2) / 10) * 100) - 100
-- end

function modifier_difficult:GetModifierPercentageCooldown()
	return 100 - ((1.25 - self:GetStackCount() / 20) * 100)
end

function modifier_difficult:GetModifierAttackSpeedBonus_Constant()	
	return self:GetStackCount() * 5
end