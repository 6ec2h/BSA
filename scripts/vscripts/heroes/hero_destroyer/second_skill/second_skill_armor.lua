LinkLuaModifier("modifier_hero_destroyer_second_skill_armor", "heroes/hero_destroyer/second_skill/second_skill_armor", LUA_MODIFIER_MOTION_NONE)

hero_destroyer_second_skill_armor = class({})

function hero_destroyer_second_skill_armor:GetIntrinsicModifierName()
	return "modifier_hero_destroyer_second_skill_armor"
end

function hero_destroyer_second_skill_armor:OnSpellStart()
	self.level = self:GetLevel()
	self:GetCaster():AddAbility("hero_destroyer_second_skill_resist"):SetLevel(self.level)
	self:GetCaster():SwapAbilities("hero_destroyer_second_skill_armor", "hero_destroyer_second_skill_resist", true, true)
	self:GetCaster():RemoveAbility("hero_destroyer_second_skill_armor")
end

-------------------------------------------------------------------------------------------

modifier_hero_destroyer_second_skill_armor = class({})

function modifier_hero_destroyer_second_skill_armor:IsHidden()
	return false
end

function modifier_hero_destroyer_second_skill_armor:IsPurgable()
	return false
end

function modifier_hero_destroyer_second_skill_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_hero_destroyer_second_skill_armor:GetModifierPhysicalArmorBonus()
	if not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("armor")
	end
end

function modifier_hero_destroyer_second_skill_armor:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if RandomInt(0, 100) < self:GetAbility():GetSpecialValueFor("crit_chance") then
			self.record = params.record
			return self:GetAbility():GetSpecialValueFor("crit_damage")
		end
	end
end

function modifier_hero_destroyer_second_skill_armor:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record and self.record == params.record then
			self.record = nil
		end
	end
end
