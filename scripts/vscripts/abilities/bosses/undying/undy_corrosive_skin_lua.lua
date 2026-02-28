undy_corrosive_skin_lua = class({})
LinkLuaModifier( "modifier_undy_corrosive_skin_lua", "abilities/bosses/undying/undy_corrosive_skin_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_undy_corrosive_skin_lua_debuff", "abilities/bosses/undying/undy_corrosive_skin_lua", LUA_MODIFIER_MOTION_NONE )


function undy_corrosive_skin_lua:GetIntrinsicModifierName()
	return "modifier_undy_corrosive_skin_lua"
end

------------------------------------------------------------

modifier_undy_corrosive_skin_lua = class({})

function modifier_undy_corrosive_skin_lua:IsHidden()
	return true
end

function modifier_undy_corrosive_skin_lua:IsPurgable()
	return false
end

function modifier_undy_corrosive_skin_lua:OnCreated( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.max_range = self:GetAbility():GetSpecialValueFor( "max_range_tooltip" )
end

function modifier_undy_corrosive_skin_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_undy_corrosive_skin_lua:OnTakeDamage( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if params.attacker:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end
	local distance = (params.attacker:GetOrigin()-params.unit:GetOrigin()):Length2D()
	if distance>self.max_range then return end

	params.attacker:AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_undy_corrosive_skin_lua_debuff", -- modifier name
		{ duration = self.duration } -- kv
	)
	local sound_cast = "hero_viper.CorrosiveSkin"
	EmitSoundOn( sound_cast, params.attacker )
end

------------------------------------------------------------

modifier_undy_corrosive_skin_lua_debuff = class({})

function modifier_undy_corrosive_skin_lua_debuff:IsHidden()
	return false
end

function modifier_undy_corrosive_skin_lua_debuff:IsDebuff()
	return true
end

function modifier_undy_corrosive_skin_lua_debuff:IsStunDebuff()
	return false
end

function modifier_undy_corrosive_skin_lua_debuff:IsPurgable()
	return true
end

function modifier_undy_corrosive_skin_lua_debuff:OnCreated( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self:GetParent():GetMaxHealth()/100*damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
	}
	self:StartIntervalThink( 1 )
end

function modifier_undy_corrosive_skin_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_undy_corrosive_skin_lua_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.slow
end

function modifier_undy_corrosive_skin_lua_debuff:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

function modifier_undy_corrosive_skin_lua_debuff:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_corrosive_debuff.vpcf"
end

function modifier_undy_corrosive_skin_lua_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end