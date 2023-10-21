enchantress_enchant_creep = class({})
LinkLuaModifier( "modifier_enchantress_enchant_creep_slow", "abilities/creeps/enchantress_enchant_creep", LUA_MODIFIER_MOTION_NONE )

function enchantress_enchant_creep:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if target:IsRealHero() then
		local duration = self:GetDuration()

		target:AddNewModifier(caster, self, "modifier_enchantress_enchant_creep_slow",  { duration = duration })
		target:Purge( true, false, false, false, false )

		local sound_cast = "Hero_Enchantress.EnchantHero"
		EmitSoundOn( sound_cast, target )
	end
	local sound_cast = "Hero_Enchantress.EnchantCast"
	EmitSoundOn( sound_cast, caster )
end

------------------------------------------------

modifier_enchantress_enchant_creep_slow = class({})

function modifier_enchantress_enchant_creep_slow:IsHidden()
	return false
end

function modifier_enchantress_enchant_creep_slow:IsDebuff()
	return true
end

function modifier_enchantress_enchant_creep_slow:IsPurgable()
	return true
end

function modifier_enchantress_enchant_creep_slow:OnCreated( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" ) -- special value
end

function modifier_enchantress_enchant_creep_slow:OnRefresh( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" ) -- special value
end

function modifier_enchantress_enchant_creep_slow:OnDestroy( kv )

end

function modifier_enchantress_enchant_creep_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end
function modifier_enchantress_enchant_creep_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_enchantress_enchant_creep_slow:GetEffectName()
	return "particles/units/heroes/hero_enchantress/enchantress_enchant_slow.vpcf"
end

function modifier_enchantress_enchant_creep_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end