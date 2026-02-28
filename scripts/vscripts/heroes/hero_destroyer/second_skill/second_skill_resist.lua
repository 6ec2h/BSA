LinkLuaModifier("modifier_hero_destroyer_second_skill_resist", "heroes/hero_destroyer/second_skill/second_skill_resist", LUA_MODIFIER_MOTION_NONE)

hero_destroyer_second_skill_resist = class({})

function hero_destroyer_second_skill_resist:GetIntrinsicModifierName()
	return "modifier_hero_destroyer_second_skill_resist"
end

function hero_destroyer_second_skill_resist:OnSpellStart()
	self.level = self:GetLevel()
	self:GetCaster():AddAbility("hero_destroyer_second_skill_hp"):SetLevel(self.level)
	self:GetCaster():SwapAbilities("hero_destroyer_second_skill_resist", "hero_destroyer_second_skill_hp", true, true)
	self:GetCaster():RemoveAbility("hero_destroyer_second_skill_resist")
end

-------------------------------------------------------------------------------------------

modifier_hero_destroyer_second_skill_resist = class({})

function modifier_hero_destroyer_second_skill_resist:IsHidden()
	return false
end

function modifier_hero_destroyer_second_skill_resist:IsPurgable()
	return false
end

function modifier_hero_destroyer_second_skill_resist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
	return funcs
end

function modifier_hero_destroyer_second_skill_resist:GetModifierMagicalResistanceBonus()
	if not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("resist")
	end
end

function modifier_hero_destroyer_second_skill_resist:GetModifierSpellAmplify_Percentage()
	if not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("spell_amp")
	end
end