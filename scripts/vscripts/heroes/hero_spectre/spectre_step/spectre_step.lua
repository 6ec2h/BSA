LinkLuaModifier("modifier_step", "heroes/hero_spectre/spectre_step/spectre_step.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spectre_step_buff", "heroes/hero_spectre/spectre_step/spectre_step.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spectre_step_debuff", "heroes/hero_spectre/spectre_step/spectre_step.lua", LUA_MODIFIER_MOTION_NONE)

spectre_step = class({})

function spectre_step:OnSpellStart()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb(self) then return end
	self:GetCaster():EmitSound("Hero_Visage.GraveChill.Cast")
	target:EmitSound("Hero_Visage.GraveChill.Target")
	
	self:GetCaster():AddNewModifier(target, self, "modifier_spectre_step_buff", {duration = self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance())})
	
	target:AddNewModifier(self:GetCaster(), self, "modifier_spectre_step_debuff", {duration = self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance())})
end

-------------------------------

modifier_spectre_step_buff = class({})

function modifier_spectre_step_buff:IsDebuff()	return false end

function modifier_spectre_step_buff:OnCreated()
	self.attackspeed_bonus = self:GetAbility():GetSpecialValueFor("attackspeed_bonus")
end

function modifier_spectre_step_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_spectre_step_buff:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed_bonus
end

---------------------------------

modifier_spectre_step_debuff = class({})

function modifier_spectre_step_debuff:GetStatusEffectName()
	return "particles/units/heroes/hero_visage/status_effect_visage_chill_slow.vpcf"
end

function modifier_spectre_step_debuff:OnCreated()
	self.attackspeed_bonus = self:GetAbility():GetSpecialValueFor("attackspeed_bonus")
	local talent = self:GetCaster():FindAbilityByName("special_bonus_spectre_tal3")
	if talent ~= nil and talent:GetLevel() > 0 then
		self.attackspeed_bonus = self.attackspeed_bonus + 40
	end
end

function modifier_spectre_step_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_spectre_step_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed_bonus * (-1)
end)
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_spectre_step_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed_bonus * (-1)
end