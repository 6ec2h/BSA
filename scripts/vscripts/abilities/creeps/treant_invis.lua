treant_invis = class({})

LinkLuaModifier("modifier_treant_invis", "abilities/creeps/treant_invis", LUA_MODIFIER_MOTION_VERTICAL)

function treant_invis:GetIntrinsicModifierName()
	return "modifier_treant_invis"
end

------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_treant_invis = class({})

function modifier_treant_invis:IsHidden()	return false end
function modifier_treant_invis:IsDebuff()	return false end
function modifier_treant_invis:IsPurgable() return false end

function modifier_treant_invis:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = true,
	}
end

function modifier_treant_invis:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_treant_invis:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_treant_invis:GetModifierInvisibilityLevel()
	return 1
end

function modifier_treant_invis:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() then
		self:SetDuration(math.min(0.1, self:GetRemainingTime()), true)
	end
end
