
LinkLuaModifier( "modifier_naga_siren_song_of_the_siren_lua", "heroes/hero_naga/naga_siren_song_of_the_siren_lua/naga_siren_song_of_the_siren_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_naga_siren_song_of_the_siren_lua_buff", "heroes/hero_naga/naga_siren_song_of_the_siren_lua/naga_siren_song_of_the_siren_lua", LUA_MODIFIER_MOTION_NONE )

naga_siren_song_of_the_siren_lua = {}

function naga_siren_song_of_the_siren_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )
	local modifier = caster:AddNewModifier(
		caster,
		self,
		"modifier_naga_siren_song_of_the_siren_lua",
		{ duration = duration }
	)

	-- local ability = caster:FindAbilityByName( "naga_siren_song_of_the_siren_cancel_lua" )

	-- if not ability then
	-- 	ability = caster:AddAbility( "naga_siren_song_of_the_siren_cancel_lua" )
	-- 	ability:SetStolen( true )
	-- end

	-- ability:SetLevel( 1 )

	-- ability.modifier = modifier

	-- caster:SwapAbilities(
	-- 	self:GetAbilityName(),
	-- 	ability:GetAbilityName(),
	-- 	false,
	-- 	true
	-- )

	-- ability:StartCooldown( ability:GetCooldown( 1 ) )
end

function naga_siren_song_of_the_siren_lua:GetCooldown( level )
	local t = self:GetCaster():FindAbilityByName("npc_dota_hero_naga_siren_3")
	if t and t:GetLevel() > 0 then
		return self.BaseClass.GetCooldown( self, level ) + t:GetSpecialValueFor("value")
	end
	return self.BaseClass.GetCooldown( self, level )
end

modifier_naga_siren_song_of_the_siren_lua = {}

function modifier_naga_siren_song_of_the_siren_lua:IsHidden()
	return false
end

function modifier_naga_siren_song_of_the_siren_lua:IsDebuff()
	return false
end

function modifier_naga_siren_song_of_the_siren_lua:IsPurgable()
	return false
end

function modifier_naga_siren_song_of_the_siren_lua:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if not IsServer() then return end
	local caster = self:GetCaster()

	local caster = self:GetCaster()

	local effect_cast = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_siren/naga_siren_siren_song_cast.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		caster
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	effect_cast = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_siren/naga_siren_song_aura.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		caster
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(),
		true
	)

	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	EmitSoundOn( "Hero_NagaSiren.SongOfTheSiren", caster )
end

function modifier_naga_siren_song_of_the_siren_lua:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )	
end

function modifier_naga_siren_song_of_the_siren_lua:OnDestroy()
	if not IsServer() then return end

	if self.scepter and not self.scepter:IsNull() then
		self.scepter:Destroy()
	end

	local ability = self:GetCaster():FindAbilityByName( "naga_siren_song_of_the_siren_cancel_lua" )
	if not ability then return end

	self:GetCaster():SwapAbilities(
		self:GetAbility():GetAbilityName(),
		ability:GetAbilityName(),
		true,
		false
	)
end

function modifier_naga_siren_song_of_the_siren_lua:End()
	StopSoundOn( "Hero_NagaSiren.SongOfTheSiren", self:GetCaster() )
	EmitSoundOn( "Hero_NagaSiren.SongOfTheSiren.Cancel", self:GetCaster() )

	self:Destroy()
end

function modifier_naga_siren_song_of_the_siren_lua:IsAura()
	return true
end

function modifier_naga_siren_song_of_the_siren_lua:GetModifierAura()
	return "modifier_naga_siren_song_of_the_siren_lua_buff"
end

function modifier_naga_siren_song_of_the_siren_lua:GetAuraRadius()
	return self.radius
end

function modifier_naga_siren_song_of_the_siren_lua:GetAuraDuration()
	return 0.4
end

function modifier_naga_siren_song_of_the_siren_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_naga_siren_song_of_the_siren_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_naga_siren_song_of_the_siren_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_naga_siren_song_of_the_siren_lua:GetAuraEntityReject( hEntity )
	return false
end

modifier_naga_siren_song_of_the_siren_lua_buff = {}

function modifier_naga_siren_song_of_the_siren_lua_buff:OnCreated()
    if not IsServer() then return end
    self:GetParent():Purge( false, true, false, false, false )
end

function modifier_naga_siren_song_of_the_siren_lua_buff:IsHidden()
	return false
end

function modifier_naga_siren_song_of_the_siren_lua_buff:IsDebuff()
	return false
end

function modifier_naga_siren_song_of_the_siren_lua_buff:IsStunDebuff()
	return false
end

function modifier_naga_siren_song_of_the_siren_lua_buff:IsPurgable()
	return false
end

function modifier_naga_siren_song_of_the_siren_lua_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_naga_siren_song_of_the_siren_lua_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE_UNIQUE,
	}
end
function modifier_naga_siren_song_of_the_siren_lua_buff:GetModifierMagicalResistanceBonus()
    return self:GetAbility():GetSpecialValueFor("magic_resistance")
end

function modifier_naga_siren_song_of_the_siren_lua_buff:GetModifierHealthRegenPercentageUnique()
    return self:GetAbility():GetSpecialValueFor("hp_regeneration")
end

function modifier_naga_siren_song_of_the_siren_lua_buff:CheckState()
	return {
		
	}
end

function modifier_naga_siren_song_of_the_siren_lua_buff:GetEffectName()
	return "particles/units/heroes/hero_siren/naga_siren_song_debuff.vpcf"
end

function modifier_naga_siren_song_of_the_siren_lua_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_naga_siren_song_of_the_siren_lua_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_siren_song.vpcf"
end

function modifier_naga_siren_song_of_the_siren_lua_buff:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end