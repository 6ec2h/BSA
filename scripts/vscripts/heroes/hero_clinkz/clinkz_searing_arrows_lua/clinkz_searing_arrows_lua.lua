LinkLuaModifier( "modifier_generic_orb_effect_lua", "heroes/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_clinkz_searing_arrows_lua", "heroes/hero_clinkz/clinkz_searing_arrows_lua/clinkz_searing_arrows_lua", LUA_MODIFIER_MOTION_NONE )

clinkz_searing_arrows_lua = class({})

function clinkz_searing_arrows_lua:GetIntrinsicModifierName()
	return "modifier_clinkz_searing_arrows_lua"
end

function clinkz_searing_arrows_lua:GetProjectileName()
	return "particles/clinkz_custom.vpcf"
end

function clinkz_searing_arrows_lua:OnOrbFire( params )
	local sound_cast = "Hero_Clinkz.SearingArrows"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function clinkz_searing_arrows_lua:OnOrbImpact( params )
	local caster = self:GetCaster()

	local damage = self:GetSpecialValueFor( "bonus_damage" )
	
	local talent = self:GetCaster():FindAbilityByName("npc_dota_hero_clinkz_tal2")
	if talent ~= nil and talent:GetLevel() > 0 then
		damage = self:GetSpecialValueFor( "bonus_damage" ) + 50
	end

	local damageTable = {
		victim = params.target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self,
	}
	ApplyDamage(damageTable)
	local sound_cast = "Hero_Clinkz.SearingArrows.Impact"
	EmitSoundOn( sound_cast, params.target )
end

----------------------------------------------------------

modifier_clinkz_searing_arrows_lua = class({})

function modifier_clinkz_searing_arrows_lua:IsHidden()
	return true
end

function modifier_clinkz_searing_arrows_lua:IsDebuff()
	return false
end

function modifier_clinkz_searing_arrows_lua:IsPurgable()
	return false
end

function modifier_clinkz_searing_arrows_lua:OnCreated( kv )
	if not IsServer() then return end

	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_orb_effect_lua", -- modifier name
		{  } -- kv
	)
end