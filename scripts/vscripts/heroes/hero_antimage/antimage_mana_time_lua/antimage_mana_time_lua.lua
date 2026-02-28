antimage_mana_time_lua = class({})
LinkLuaModifier( "modifier_sleep_time", "heroes/hero_antimage/antimage_mana_time_lua/antimage_mana_time_lua", LUA_MODIFIER_MOTION_NONE )

function antimage_mana_time_lua:OnSpellStart()
	local damage = self:GetSpecialValueFor("damage")
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor( "duration" )
	
	local talent_ability = self:GetCaster():FindAbilityByName("special_bonus_antimage_int4")
	if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		duration = self:GetSpecialValueFor( "duration" ) + 1
	end
	
		local damageTable = {
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		enemy:AddNewModifier(self:GetCaster(),self,"modifier_sleep_time", { duration = duration })
	end

	self:PlayEffects2( self:GetCaster(), radius )
end

function antimage_mana_time_lua:PlayEffects2( target, radius )
	local particle_target = "particles/units/heroes/hero_antimage/antimage_manavoid.vpcf"
	local sound_target = "Hero_Antimage.ManaVoid"

	local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_target, 1, Vector( radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_target )

	EmitSoundOn( sound_target, target )
end
-------------------------------------------------------------------------------------------------------------------------------

modifier_sleep_time = class({})

function modifier_sleep_time:IsHidden()
	return false
end

function modifier_sleep_time:IsDebuff()
	return true
end

function modifier_sleep_time:IsStunDebuff()
	return false
end

function modifier_sleep_time:IsPurgable()
	return false
end

function modifier_sleep_time:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_sleep_time:OnCreated( kv )
	if not IsServer() then return end
end

function modifier_sleep_time:OnRefresh( kv )
end

function modifier_sleep_time:OnRemoved()
end

function modifier_sleep_time:OnDestroy()
end

function modifier_sleep_time:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end

function modifier_sleep_time:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_sleep_time:GetOverrideAnimationRate()
	return 0.55
end

function modifier_sleep_time:CheckState()
	local state = {
		[MODIFIER_STATE_NIGHTMARED] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_sleep_time:GetEffectName()
	return "particles/units/heroes/hero_siren/naga_siren_song_debuff.vpcf"
end

function modifier_sleep_time:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_sleep_time:GetStatusEffectName()
	return "particles/status_fx/status_effect_siren_song.vpcf"
end

function modifier_sleep_time:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end