LinkLuaModifier( "modifier_brewmaster_ult", "heroes/hero_brewmaster/brewmaster_ult", LUA_MODIFIER_MOTION_NONE )

brewmaster_ult = class({})

function brewmaster_ult:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_brewmaster_4")
	if ability ~= nil and ability:GetLevel() > 0 then 
		duration = duration + 8
	end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_brewmaster_ult", {duration =  duration} )
	self:PlayEffects()
end

function brewmaster_ult:PlayEffects()
	self:GetCaster():EmitSound('Hero_Brewmaster.PrimalSplit.Spawn')
end

------------------------------------------------------------------------

modifier_brewmaster_ult = class({})

function modifier_brewmaster_ult:IsHidden()
	return false
end

function modifier_brewmaster_ult:IsPurgable()
	return false
end

function modifier_brewmaster_ult:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

function modifier_brewmaster_ult:GetModifierModelScale()
	return 40
end

function modifier_brewmaster_ult:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_brewmaster_ult:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_brewmaster_ult:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
