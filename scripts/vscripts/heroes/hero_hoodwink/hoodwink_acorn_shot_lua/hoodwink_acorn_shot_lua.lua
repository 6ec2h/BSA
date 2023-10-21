hoodwink_acorn_shot_lua = class({})
LinkLuaModifier( "modifier_hoodwink_acorn_shot_lua", "heroes/hero_hoodwink/hoodwink_acorn_shot_lua/hoodwink_acorn_shot_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_acorn_shot_lua_thinker", "heroes/hero_hoodwink/hoodwink_acorn_shot_lua/hoodwink_acorn_shot_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_acorn_shot_lua_debuff", "heroes/hero_hoodwink/hoodwink_acorn_shot_lua/hoodwink_acorn_shot_lua", LUA_MODIFIER_MOTION_NONE )

function hoodwink_acorn_shot_lua:GetCastRange( vLocation, hTarget )
	return self:GetCaster():Script_GetAttackRange() + self:GetSpecialValueFor( "bonus_range" )
end

function hoodwink_acorn_shot_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	self.tree_duration = 20
	self.tree_vision = 300

	local thinker = CreateModifierThinker(caster, self, "modifier_hoodwink_acorn_shot_lua_thinker", { }, caster:GetOrigin(), caster:GetTeamNumber(), false)
	local mod = thinker:FindModifierByName( "modifier_hoodwink_acorn_shot_lua_thinker" )

	if not target then
		target = thinker
		thinker:SetOrigin( point )
	end
	mod.source = caster
	mod.target = target

	local sound_cast = "Hero_Hoodwink.AcornShot.Cast"
	EmitSoundOn( sound_cast, caster )
end

function hoodwink_acorn_shot_lua:OnProjectileHit_ExtraData( target, location, ExtraData )
	local caster = self:GetCaster()
	local thinker = EntIndexToHScript( ExtraData.thinker )
	local mod = thinker:FindModifierByName( "modifier_hoodwink_acorn_shot_lua_thinker" )
	if not mod then return end

	thinker:SetOrigin( location )
	mod:Bounce()

	if ExtraData.first==1 then
		if target==thinker then
			self:CreateTree( location )
			return
		end
		if not target then
			self:CreateTree( location )
			mod.target = thinker
			return
		end
	
		if target:TriggerSpellAbsorb( self ) then
			mod:Destroy()
			return
		end
	end

	if not target then
		mod:Destroy()
		return
	end

	local duration = self:GetSpecialValueFor( "debuff_duration" )

	local mod = caster:AddNewModifier(caster, self, "modifier_hoodwink_acorn_shot_lua", {})
	caster:PerformAttack(target, true, true, true, true, false, false, true)
	mod:Destroy()

	if not target:IsMagicImmune() then
		target:AddNewModifier(caster, self, "modifier_hoodwink_acorn_shot_lua_debuff", { duration = duration })
		local sound_slow = "Hero_Hoodwink.AcornShot.Slow"
		EmitSoundOn( sound_slow, target )
	end
	local sound_target = "Hero_Hoodwink.AcornShot.Target"
	EmitSoundOn( sound_target, target )
end

function hoodwink_acorn_shot_lua:CreateTree( location )
	AddFOWViewer( self:GetCaster():GetTeamNumber(), location, self.tree_vision, self.tree_duration, false )
	local tree = CreateTempTreeWithModel( location, self.tree_duration, "models/heroes/hoodwink/hoodwink_tree_model.vmdl" )
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, 100, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	for _,unit in pairs(units) do
		FindClearSpaceForUnit( unit, unit:GetOrigin(), true )
	end
	self:PlayEffects1( tree, location )
	self:PlayEffects2( tree, location )
end


function hoodwink_acorn_shot_lua:PlayEffects1( tree, location )
	local particle_cast = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tree.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, tree )
	ParticleManager:SetParticleControl( effect_cast, 0, tree:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 1, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function hoodwink_acorn_shot_lua:PlayEffects2( tree, location )
	local particle_cast = "particles/tree_fx/tree_simple_explosion.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, tree:GetOrigin()+Vector(1,0,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

-----------------------------------------------------------------

modifier_hoodwink_acorn_shot_lua = class({})

function modifier_hoodwink_acorn_shot_lua:IsHidden()
	return true
end

function modifier_hoodwink_acorn_shot_lua:IsPurgable()
	return false
end

function modifier_hoodwink_acorn_shot_lua:OnCreated( kv )
	if not IsServer() then return end
	self.bonus = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_hoodwink_1")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.bonus = self.bonus + 50
	end
end

function modifier_hoodwink_acorn_shot_lua:OnRefresh( kv )
	self:OnCreated()
end

function modifier_hoodwink_acorn_shot_lua:OnRemoved()
end

function modifier_hoodwink_acorn_shot_lua:OnDestroy()
end

function modifier_hoodwink_acorn_shot_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_hoodwink_acorn_shot_lua:GetModifierPreAttack_BonusDamage()
	return self.bonus
end

function modifier_hoodwink_acorn_shot_lua:GetModifierProcAttack_Feedback( params )
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, params.target, params.damage, self:GetCaster():GetPlayerOwner())
end

--------------------------------------------------------------------------------

modifier_hoodwink_acorn_shot_lua_debuff = class({})

function modifier_hoodwink_acorn_shot_lua_debuff:IsHidden()
	return false
end

function modifier_hoodwink_acorn_shot_lua_debuff:IsDebuff()
	return true
end

function modifier_hoodwink_acorn_shot_lua_debuff:IsStunDebuff()
	return false
end

function modifier_hoodwink_acorn_shot_lua_debuff:IsPurgable()
	return true
end

function modifier_hoodwink_acorn_shot_lua_debuff:OnCreated( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "slow" )
	if not IsServer() then return end
end

function modifier_hoodwink_acorn_shot_lua_debuff:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_hoodwink_acorn_shot_lua_debuff:OnRemoved()
end

function modifier_hoodwink_acorn_shot_lua_debuff:OnDestroy()
end

function modifier_hoodwink_acorn_shot_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_hoodwink_acorn_shot_lua_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_hoodwink_acorn_shot_lua_debuff:GetEffectName()
	return "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_slow.vpcf"
end

function modifier_hoodwink_acorn_shot_lua_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

modifier_hoodwink_acorn_shot_lua_thinker = class({})


function modifier_hoodwink_acorn_shot_lua_thinker:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.projectile_name = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf"

	self.projectile_speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
	self.bounces = self:GetAbility():GetSpecialValueFor( "bounce_count" )+1
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.delay = self:GetAbility():GetSpecialValueFor( "bounce_delay" )
	self.range = self:GetAbility():GetSpecialValueFor( "bounce_range" )
	
	
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_hoodwink_3")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.bounces = self.bounces + 2
	end


	if not IsServer() then return end
	-- ability properties
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
	self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()

	-- precache projectile
	self.info = {
		-- Target = self.target,
		-- Source = self.parent,
		Ability = self.ability,	
		
		EffectName = self.projectile_name,
		iMoveSpeed = self.projectile_speed,
		bDodgeable = true,                           -- Optional
	
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,

		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = 400,                              -- Optional
		iVisionTeamNumber = self.caster:GetTeamNumber(),        -- Optional
		ExtraData = {
			thinker = self.parent:entindex()
		}
	}
	self:StartIntervalThink( 0 )
end

function modifier_hoodwink_acorn_shot_lua_thinker:OnRefresh( kv )
	
end

function modifier_hoodwink_acorn_shot_lua_thinker:OnRemoved()
end

function modifier_hoodwink_acorn_shot_lua_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_hoodwink_acorn_shot_lua_thinker:OnIntervalThink()
	self.bounces = self.bounces-1
	if self.bounces<0 then
		self:Destroy()
		return
	end

	self:StartIntervalThink(-1)

	local first = 0
	if not self.first then
		self.first = true
		first = 1
		self.info.iMoveSpeed = self.projectile_speed
	else
		self.source = self.target

		-- Find enemies
		local enemies = FindUnitsInRadius(
			self.caster:GetTeamNumber(),	-- int, your team number
			self.target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		if #enemies<1 then
			self:Destroy()
			return
		end

		local next_target
		for _,enemy in pairs(enemies) do
			if enemy~=self.target then
				next_target = enemy
				break
			end
		end
		if not next_target then
			self:Destroy()
			return
		end
		self.target = next_target

		self.info.iMoveSpeed = self.caster:GetProjectileSpeed()
	end

	self.info.Source = self.source
	self.info.Target = self.target
	self.info.ExtraData.first = first
	ProjectileManager:CreateTrackingProjectile( self.info )

	local sound_cast = "Hero_Hoodwink.AcornShot.Bounce"
	EmitSoundOn( sound_cast, self.source )
end

function modifier_hoodwink_acorn_shot_lua_thinker:Bounce()
	self:StartIntervalThink( self.delay )
end