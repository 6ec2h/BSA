LinkLuaModifier("modifier_morph_heal", "abilities/creeps/morph_heal", LUA_MODIFIER_MOTION_VERTICAL)

morph_heal = class({})

function morph_heal:GetIntrinsicModifierName()
	return "modifier_morph_heal"
end

modifier_morph_heal = class({})

function modifier_morph_heal:IsHidden()
	return true
end

function modifier_morph_heal:IsPurgable()
	return false
end

function modifier_morph_heal:OnCreated( kv )
	self:StartIntervalThink(0.2)
end

function modifier_morph_heal:OnIntervalThink()
	if self:GetParent():GetHealthPercent() < 90 then
		self:SetStackCount(self:GetStackCount() + 1)
	else
		self:SetStackCount(0)
	end
end

function modifier_morph_heal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE		
	}
	return funcs
end

function modifier_morph_heal:GetModifierHealthRegenPercentage()
	return 0.3 * self:GetStackCount()
end

function modifier_morph_heal:GetModifierAttackSpeedBonus_Constant()
	return 1 * self:GetStackCount()
end

function modifier_morph_heal:GetModifierModelScale()
	if self:GetParent():GetModelScale() < 2.2 then 
		return 3 * self:GetStackCount()
	end
	return 
end