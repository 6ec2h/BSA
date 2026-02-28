creep_shadow_blur = class({})

LinkLuaModifier("modifier_creep_shadow_blur_smoke", "abilities/creeps/creep_shadow_blur", LUA_MODIFIER_MOTION_VERTICAL)

function creep_shadow_blur:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creep_shadow_blur_smoke", { duration = self:GetSpecialValueFor("duration")})
		self:GetCaster():Purge(false, true, false, false, false)
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_creep_shadow_blur_smoke = class({})

function modifier_creep_shadow_blur_smoke:IsHidden()	return false end
function modifier_creep_shadow_blur_smoke:IsDebuff()	return false end
function modifier_creep_shadow_blur_smoke:IsPurgable() return false end

function modifier_creep_shadow_blur_smoke:GetEffectName()
	return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_blur.vpcf"
end

function modifier_creep_shadow_blur_smoke:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creep_shadow_blur_smoke:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = true,
	--	[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true
	}
end

function modifier_creep_shadow_blur_smoke:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_creep_shadow_blur_smoke:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
end

function modifier_creep_shadow_blur_smoke:GetModifierInvisibilityLevel()
	return 1
end

function modifier_creep_shadow_blur_smoke:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor("evasion")
end

function modifier_creep_shadow_blur_smoke:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() then
		self:SetDuration(math.min(self.fade_duration, self:GetRemainingTime()), true)
	end
end
