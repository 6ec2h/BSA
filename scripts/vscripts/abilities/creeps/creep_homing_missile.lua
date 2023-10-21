creep_homing_missile = class({})

function creep_homing_missile:OnSpellStart()
	local caster = self:GetCaster()
	
	local sound_target = "Hero_Gyrocopter.HomingMissile.Enemy"
	StartSoundEvent( sound_target, self:GetCaster() )
	

	local search_radius = self:GetSpecialValueFor( "launch_radius" )
	
	local projectile_name = "particles/econ/items/clockwerk/clockwerk_paraflare/clockwerk_para_rocket_flare.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "speed" )
	local projectile_vision = self:GetSpecialValueFor( "shot_vision" )
	

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false	)
	local target = nil
	for _,enemy in pairs(enemies) do
		if enemy:IsHero() then
			target = enemy
			break
		end
	end
	if not target then
		target = enemies[1]
	end

	if not target then
		return
	end

	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional
	
		bVisibleToEnemies = true,                         -- Optional

		bProvidesVision = true,                           -- Optional
		iVisionRadius = 400,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)	
end

function creep_homing_missile:OnProjectileHit( target, location, damage )
	if not target then return end
	local radius = self:GetSpecialValueFor( "slow_radius" )
	local damage = self:GetSpecialValueFor( "damage" )
	local duration = self:GetSpecialValueFor( "stun_duration" )
	local vision = self:GetSpecialValueFor( "shot_vision" )
	local vision_duration = self:GetSpecialValueFor( "vision_duration" )

	local damageTable = {
		attacker = self:GetCaster(),
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),	 target:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		damageTable.damage = damage
		if enemy:IsCreep() then
			damageTable.damage = damage
		end
		ApplyDamage( damageTable )

		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = duration } -- kv
		)
	end
	
	local sound_target = "Hero_Gyrocopter.HomingMissile.Destroy"
	EmitSoundOn( sound_target, self:GetCaster() )
	
	local sound_target = "Hero_Gyrocopter.HomingMissile.Enemy"
	StopSoundEvent( sound_target, self:GetCaster() )

	-- vision
	AddFOWViewer(
		self:GetCaster():GetTeamNumber(), --nTeamID
		target:GetOrigin(), --vLocation
		vision, --flRadius
		vision_duration, --flDuration
		false --bObstructedVision
	)
end