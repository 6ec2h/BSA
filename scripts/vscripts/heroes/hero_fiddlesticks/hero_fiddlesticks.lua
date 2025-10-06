LinkLuaModifier("modifier_hero_fiddlesticks_harvest", "heroes/hero_fiddlesticks/hero_fiddlesticks", LUA_MODIFIER_MOTION_NONE)

hero_fiddlesticks_harvest = class({})

function hero_fiddlesticks_harvest:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf", context )
end

function hero_fiddlesticks_harvest:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_3
end

function hero_fiddlesticks_harvest:OnSpellStart()
	local damage = self:GetSpecialValueFor( "damage" )
	local splash_radius = self:GetSpecialValueFor( "splash_radius" )
	local duration = self:GetSpecialValueFor( "duration" )
	local bonus_damage = self:GetSpecialValueFor( "bonus_damage" )
	local front = self:GetCaster():GetForwardVector():Normalized()
	local target_pos = self:GetCaster():GetOrigin() + front * splash_radius

	local direction = target_pos-self:GetCaster():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	local range = self:GetCaster():GetOrigin() + direction * splash_radius/2-120
	
	local enemies = FindUnitsInCone( self:GetCaster():GetTeamNumber(), target_pos, self:GetCaster():GetOrigin(), range, 150, 360, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	
	local damageTable = {
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
	}
	
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end
	
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_hero_fiddlesticks_harvest", {duration = duration}):SetStackCount(#enemies * bonus_damage)
	
	self:PlayEffects( direction )
	EmitSoundOn( "Hero_Centaur.DoubleEdge", self:GetCaster() )
end

function FindUnitsInCone( nTeamNumber, vCenterPos, vStartPos, vEndPos, fStartRadius, fEndRadius, hCacheUnit, nTeamFilter, nTypeFilter, nFlagFilter, nOrderFilter, bCanGrowCache )
	local direction = vEndPos-vStartPos
	direction.z = 0

	local distance = direction:Length2D()
	direction = direction:Normalized()

	local big_radius = distance + math.max(fStartRadius, fEndRadius)

	local units = FindUnitsInRadius(
		nTeamNumber,	-- int, your team number
		vCenterPos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		big_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		nTeamFilter,	-- int, team filter
		nTypeFilter,	-- int, type filter
		nFlagFilter,	-- int, flag filter
		nOrderFilter,	-- int, order filter
		bCanGrowCache	-- bool, can grow cache
	)

	local targets = {}
	for _,unit in pairs(units) do
		local vUnitPos = unit:GetOrigin()-vStartPos
		local fProjection = vUnitPos.x*direction.x + vUnitPos.y*direction.y + vUnitPos.z*direction.z
		fProjection = math.max(math.min(fProjection,distance),0)
		local vProjection = direction*fProjection
		local fUnitRadius = (vUnitPos - vProjection):Length2D()
		local fInterpRadius = (fProjection/distance)*(fEndRadius-fStartRadius) + fStartRadius
		if fUnitRadius<=fInterpRadius then
			table.insert( targets, unit )
		end
	end
	return targets
end

function hero_fiddlesticks_harvest:PlayEffects(direction )
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

-----------------------------------------------------------------

modifier_hero_fiddlesticks_harvest = class({})

function modifier_hero_fiddlesticks_harvest:IsHidden()
    return false
end

function modifier_hero_fiddlesticks_harvest:IsPurgable()
    return false 
end

function modifier_hero_fiddlesticks_harvest:RemoveOnDeath()
    return true
end

function modifier_hero_fiddlesticks_harvest:GetTexture()
    return "fiddlesticks_harvest"
end

function modifier_hero_fiddlesticks_harvest:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end

function modifier_hero_fiddlesticks_harvest:GetModifierBaseAttack_BonusDamage()
    return self:GetStackCount()
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

LinkLuaModifier("modifier_hero_fiddlesticks_rise", "heroes/hero_fiddlesticks/hero_fiddlesticks", LUA_MODIFIER_MOTION_NONE)

hero_fiddlesticks_rise = class({})

function hero_fiddlesticks_rise:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf", context )
end

function hero_fiddlesticks_rise:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end

function hero_fiddlesticks_rise:OnSpellStart()
	local count = self:GetSpecialValueFor( "count" )
	local damage = self:GetSpecialValueFor( "damage" )
	local duration = self:GetSpecialValueFor( "duration" )
	local position = self:GetCaster():GetOrigin()
	local bounds_max = position + Vector(200, 200, 0)
    local bounds_min = position + Vector(-200, -200, 0)

	Timers:CreateTimer(0, function()
		if count > 0 then
			count = count - 1
			
			local random_position = GetRandomPositionSquare(bounds_min, bounds_max)
			local unit = CreateUnitByName("npc_hero_fiddlesticks_rise_unit", random_position, true, nil, nil, self:GetCaster():GetTeamNumber())
			unit:AddNewModifier(self:GetCaster(), self, "modifier_hero_fiddlesticks_rise", {duration = duration})
			unit:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = duration})
			unit:SetBaseDamageMin(self:GetCaster():GetBaseDamageMin() * damage / 100)
			unit:SetBaseDamageMax(self:GetCaster():GetBaseDamageMax() * damage / 100)
			EmitSoundOn("Undying_Zombie.Spawn", self:GetCaster())
			
			return 0.1
		else
			return nil
		end
	end)
end

function GetRandomPositionSquare(v1, v2)
	return Vector(RandomFloat(v1.x, v2.x), RandomFloat(v1.y, v2.y), RandomFloat(v1.z, v2.z))
end

---------------------------------------------------------------

modifier_hero_fiddlesticks_rise = class({})

function modifier_hero_fiddlesticks_rise:IsHidden()
    return false
end

function modifier_hero_fiddlesticks_rise:IsPurgable()
    return false 
end

function modifier_hero_fiddlesticks_rise:RemoveOnDeath()
    return true
end

function modifier_hero_fiddlesticks_rise:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
	return state
end


function modifier_hero_fiddlesticks_rise:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_hero_fiddlesticks_rise:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor( "attack_speed" )
end


------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

LinkLuaModifier("modifier_hero_fiddlesticks_chains", "heroes/hero_fiddlesticks/hero_fiddlesticks", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_fiddlesticks_chains_effect", "heroes/hero_fiddlesticks/hero_fiddlesticks", LUA_MODIFIER_MOTION_NONE)

hero_fiddlesticks_chains = class({})

function hero_fiddlesticks_chains:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf", context )
end

function hero_fiddlesticks_chains:GetCastAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_2
end

function hero_fiddlesticks_chains:OnSpellStart()
    local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()    
	EmitSoundOn("Hero_ShadowDemon.ShadowPoison.Cast" , caster)
	self:FireShadowPoisonProjectile(caster:GetAbsOrigin(), target_point, false)
end
	
function hero_fiddlesticks_chains:FireShadowPoisonProjectile(origin_point, target_point, grudges)
	local caster = self:GetCaster()  
	local projectile_sound = "Hero_ShadowDemon.ShadowPoison"
	local particle_poison = "particles/hero_fiddlesticks_chains.vpcf"    

	local radius = 225
	local speed = 600

	EmitSoundOnLocationWithCaster(origin_point, projectile_sound, caster)
	local direction = (target_point - origin_point):Normalized()
	
	local shadow_projectile = {
		Ability = self,
		EffectName = particle_poison,
		vSpawnOrigin = origin_point,
		fDistance = self:GetCastRange(target_point, nil),
		fStartRadius = radius,
		fEndRadius = radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bDeleteOnHit = false,
		vVelocity = direction * speed * Vector(1, 1, 0),
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bProvidesVision = true,
		iVisionRadius = radius,
		iVisionTeamNumber = caster:GetTeamNumber(),        
	}

	local projectileID = ProjectileManager:CreateLinearProjectile(shadow_projectile)
end	

function hero_fiddlesticks_chains:OnProjectileHitHandle(target, location)	
	if target then
		self:GetCaster():EmitSound("Hero_Necrolyte.ProjectileImpact")
		ApplyDamage({
			victim = target,
			attacker = self:GetCaster(),
			damage = self:GetSpecialValueFor("damage"),
			damage_type = DAMAGE_TYPE_PURE,
			ability = self,
		})
		target:AddNewModifier(self:GetCaster(), self, "modifier_hero_fiddlesticks_chains", { duration = self:GetSpecialValueFor("duration") })
		target:AddNewModifier(self:GetCaster(), self, "modifier_hero_fiddlesticks_chains_effect", { duration = self:GetSpecialValueFor("duration_disarm") })
	end
end

---------------------------------------------------------------

modifier_hero_fiddlesticks_chains_effect = class({})

function modifier_hero_fiddlesticks_chains_effect:IsHidden()
	return true
end

function modifier_hero_fiddlesticks_chains_effect:IsPurgable()
	return false
end

function modifier_hero_fiddlesticks_chains_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_hero_fiddlesticks_chains_effect:GetModifierPhysicalArmorBonus()
	return -(self:GetParent():GetPhysicalArmorBaseValue() / 100 * self:GetAbility():GetSpecialValueFor( "disarm" ))
end

---------------------------------------------------------------

modifier_hero_fiddlesticks_chains = class({})

function modifier_hero_fiddlesticks_chains:IsHidden()
    return false
end

function modifier_hero_fiddlesticks_chains:IsPurgable()
    return false 
end

function modifier_hero_fiddlesticks_chains:RemoveOnDeath()
    return true
end

function modifier_hero_fiddlesticks_chains:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end

function modifier_hero_fiddlesticks_chains:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf"
end

function modifier_hero_fiddlesticks_chains:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_hero_fiddlesticks_chains:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_hero_fiddlesticks_chains:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------

LinkLuaModifier("modifier_hero_fiddlesticks_scythe", "heroes/hero_fiddlesticks/hero_fiddlesticks", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_fiddlesticks_scythe_effect", "heroes/hero_fiddlesticks/hero_fiddlesticks", LUA_MODIFIER_MOTION_NONE)

hero_fiddlesticks_scythe = class({})

function hero_fiddlesticks_scythe:Precache( context )
	PrecacheResource( "particle", "particles/hero_fiddlesticks_scythe.vpcf", context )
end


function hero_fiddlesticks_scythe:GetIntrinsicModifierName()
	return "modifier_hero_fiddlesticks_scythe"
end

------------------------------------------------

modifier_hero_fiddlesticks_scythe = class({})

function modifier_hero_fiddlesticks_scythe:IsHidden()
	return true
end

function modifier_hero_fiddlesticks_scythe:IsPurgable()
	return false
end

function modifier_hero_fiddlesticks_scythe:OnCreated( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
end

function modifier_hero_fiddlesticks_scythe:OnRefresh( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
end

function modifier_hero_fiddlesticks_scythe:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_hero_fiddlesticks_scythe:OnAttackLanded(params)
	if IsServer() then

		if not params.attacker:IsRealHero() then
			return nil
		end

		if params.attacker:PassivesDisabled() then
			return nil
		end

		if params.attacker == self:GetCaster() and RandomInt(1,100) <= self.chance then
			params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_hero_fiddlesticks_scythe_effect", {duration = 0.03})
		end
	end
end

----------------------------------------------

modifier_hero_fiddlesticks_scythe_effect = class({})

function modifier_hero_fiddlesticks_scythe_effect:IgnoreTenacity()
	return true
end

function modifier_hero_fiddlesticks_scythe_effect:IsPurgable()
	return false
end

function modifier_hero_fiddlesticks_scythe_effect:IsPurgeException() 
	return false
end

function modifier_hero_fiddlesticks_scythe_effect:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local scythe_fx = ParticleManager:CreateParticle("particles/hero_fiddlesticks_scythe.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(scythe_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(scythe_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(scythe_fx)
	end
end

function modifier_hero_fiddlesticks_scythe_effect:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf"
end

function modifier_hero_fiddlesticks_scythe_effect:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_hero_fiddlesticks_scythe_effect:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_hero_fiddlesticks_scythe_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_hero_fiddlesticks_scythe_effect:OnRemoved()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local damage = caster:GetBaseDamageMin() + self:GetAbility():GetSpecialValueFor("damage")
		
		local heal = damage / 100 * self:GetAbility():GetSpecialValueFor( "lifesteal" )
		
		if target:IsAlive() and self:GetAbility() then
			caster:Heal(heal, caster)
			local actually_dmg = ApplyDamage({attacker = caster, victim = target, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, heal, nil)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, actually_dmg, nil)
		end
	end
end
