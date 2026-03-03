silencer_glaives_of_wisdom_lua = class({})
LinkLuaModifier( "modifier_generic_orb_effect_lua", "heroes/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silencer_glaives_of_wisdom_lua", "heroes/hero_silencer/silencer_glaives_of_wisdom_lua/modifier_silencer_glaives_of_wisdom_lua", LUA_MODIFIER_MOTION_NONE )

function silencer_glaives_of_wisdom_lua:GetIntrinsicModifierName()
	return "modifier_silencer_glaives_of_wisdom_lua"
end

function silencer_glaives_of_wisdom_lua:GetProjectileName()
	return "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf"
end

function silencer_glaives_of_wisdom_lua:OnOrbFire( params )
	local sound_cast = "Hero_Silencer.GlaivesOfWisdom"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function silencer_glaives_of_wisdom_lua:OnOrbImpact( params )
	local caster = self:GetCaster()

	local int_mult = self:GetSpecialValueFor( "intellect_damage_pct" )
	local damage = caster:GetIntellect(true) * int_mult/100


	local damageTable = {
		victim = params.target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	SendOverheadEventMessage(
		nil,
		OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
		params.target,
		damage,
		nil
	)

	local sound_cast = "Hero_Silencer.GlaivesOfWisdom.Damage"
	EmitSoundOn( sound_cast, params.target )
end