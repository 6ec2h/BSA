boss_lich_frost_blast_lua = class({})
LinkLuaModifier( "modifier_boss_lich_frost_blast_lua", "abilities/bosses/lich/boss_lich_frost_blast_lua", LUA_MODIFIER_MOTION_NONE )

function boss_lich_frost_blast_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function boss_lich_frost_blast_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb( self ) then
		self:PlayEffects()
		return
	end

	local duration = self:GetDuration()
	local damage_aoe = self:GetSpecialValueFor("aoe_damage")
	local radius = self:GetSpecialValueFor("radius")

	-- get enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = target:GetMaxHealth()*0.20,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		damageTable.damage = enemy:GetMaxHealth()*0.1
		ApplyDamage( damageTable )
		
		-- debuff
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_boss_lich_frost_blast_lua", -- modifier name
			{ duration = duration } -- kv
		)
	end

	self:PlayEffects( target, radius )
end

function boss_lich_frost_blast_lua:PlayEffects( target, radius )
	local particle_cast = "particles/units/heroes/hero_lich/lich_frost_nova.vpcf"
	local sound_target = "Ability.FrostNova"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_target, target )
end


----------------------------------------------------------------------------------------

modifier_boss_lich_frost_blast_lua = class({})

function modifier_boss_lich_frost_blast_lua:IsHidden()
	return false
end

function modifier_boss_lich_frost_blast_lua:IsDebuff()
	return true
end

function modifier_boss_lich_frost_blast_lua:IsPurgable()
	return true
end

function modifier_boss_lich_frost_blast_lua:OnCreated( kv )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "slow_attack_speed" ) -- special value
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" ) -- special value
end

function modifier_boss_lich_frost_blast_lua:OnRefresh( kv )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "slow_attack_speed" ) -- special value
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" ) -- special value
end

function modifier_boss_lich_frost_blast_lua:OnDestroy( kv )

end

function modifier_boss_lich_frost_blast_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end
function modifier_boss_lich_frost_blast_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end
function modifier_boss_lich_frost_blast_lua:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow
end

function modifier_boss_lich_frost_blast_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end