muerta_dead_shot_lua = class({})
LinkLuaModifier( "modifier_muerta_dead_shot_lua", "heroes/hero_muerta/muerta_dead_shot_lua/muerta_dead_shot_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muerta_dead_shot_lua_slow", "heroes/hero_muerta/muerta_dead_shot_lua/muerta_dead_shot_lua", LUA_MODIFIER_MOTION_NONE )

function muerta_dead_shot_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local speed = self:GetSpecialValueFor( "speed" )

	local projectile_name = "particles/units/heroes/hero_muerta/muerta_deadshot_linear.vpcf"

	local projectile_speed = self:GetSpecialValueFor( "speed" )
	local projectile_distance = 800
	local projectile_radius = self:GetSpecialValueFor( "radius" )
	local projectile_direction = point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius = projectile_radius,
		vVelocity = projectile_direction * projectile_speed,
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)
	EmitSoundOn( "Hero_Muerta.DeadShot.Cast", caster )
	EmitSoundOn( "Hero_Muerta.DeadShot.Layer", caster )
end

function muerta_dead_shot_lua:OnProjectileHitHandle( target, location, handle )
	if target then
		local damage = self:GetSpecialValueFor( "damage" )
		
		local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_muerta_1")
		if ability ~= nil and ability:GetLevel() > 0 then 
			damage = damage + 100
		end
	
		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)

		target:AddNewModifier(self:GetCaster(), self, "modifier_muerta_dead_shot_lua_slow", {duration = self:GetSpecialValueFor( "duration" )})
		EmitSoundOn( "Hero_Muerta.DeadShot.Slow", target )
	end
end

-----------------------------------------------------------

modifier_muerta_dead_shot_lua_slow = class({})

function modifier_muerta_dead_shot_lua_slow:IsHidden()
	return false
end

function modifier_muerta_dead_shot_lua_slow:IsDebuff()
	return true
end

function modifier_muerta_dead_shot_lua_slow:IsPurgable()
	return true
end

function modifier_muerta_dead_shot_lua_slow:OnCreated( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow" )
	if not IsServer() then return end
end

function modifier_muerta_dead_shot_lua_slow:OnRefresh( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow" )
end

function modifier_muerta_dead_shot_lua_slow:OnRemoved()
end

function modifier_muerta_dead_shot_lua_slow:OnDestroy()
end

function modifier_muerta_dead_shot_lua_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_muerta_dead_shot_lua_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_muerta_dead_shot_lua_slow:GetEffectName()
	return "particles/units/heroes/hero_muerta/muerta_deadshot_debuff_slow.vpcf"
end

function modifier_muerta_dead_shot_lua_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end