LinkLuaModifier("modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)

gyrocopter_homing_missile_lua = class({})

function gyrocopter_homing_missile_lua:OnSpellStart()
	local caster = self:GetCaster()
	
	local sound_target = "Hero_Gyrocopter.HomingMissile.Enemy"
	StartSoundEvent( sound_target, self:GetCaster() )
	

	local search_radius = self:GetSpecialValueFor( "launch_radius" )
	
	local projectile_name = "particles/econ/items/clockwerk/clockwerk_paraflare/clockwerk_para_rocket_flare.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "speed" )
	local projectile_vision = self:GetSpecialValueFor( "shot_vision" )
	

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		search_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)
	-- prioritize hero, then creep
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

	-- if no one found, it's dud
	if not target then
	--	self:PlayEffects2()
		return
	end

	-- create projectile
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

	-- play effects
--	self:PlayEffects1( target )

	if self:GetCaster():FindAbilityByName("special_bonus_gyrocopter_agi2")~=nil then
		if self:GetCaster():FindAbilityByName("special_bonus_gyrocopter_agi2"):GetLevel() > 0 then 
			local scepter_radius = self:GetSpecialValueFor( "scepter_radius" )
			
			-- find nearby enemies
			local enemies = FindUnitsInRadius(
				caster:GetTeamNumber(),	-- int, your team number
				target:GetOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				scepter_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
				0,	-- int, order filter
				false	-- bool, can grow cache
			)

			local target_2 = nil
			-- prioritize hero
			for _,enemy in pairs(enemies) do
				if enemy~=target and enemy:IsHero() then
					target_2 = enemy
					break
				end
			end

			-- no secondary hero found, find creep
			if not target_2 then
				-- 'enemies' will only have at max 1 hero (others are creeps), which would be 'target'
				target_2 = enemies[1]		-- could be nil
				if target_2==target then
					target_2 = enemies[2]	-- could be nil
				end
			end

			if target_2 and (not target_2:IsMagicImmune()) then
				-- launch projectile
				info.Target = target_2
				ProjectileManager:CreateTrackingProjectile(info)
				--self:PlayEffects1( target_2 )
			end
		end
	end
end
--------------------------------------------------------------------------------
-- Projectile
function gyrocopter_homing_missile_lua:OnProjectileHit( target, location, damage )
	if not target then return end

	-- get data
	local radius = self:GetSpecialValueFor( "slow_radius" )
	local damage = self:GetSpecialValueFor( "damage" )
	local duration = self:GetSpecialValueFor( "stun_duration" )
	local vision = self:GetSpecialValueFor( "shot_vision" )
	local vision_duration = self:GetSpecialValueFor( "vision_duration" )

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		-- damage = 500,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	-- ApplyDamage(damageTable)

	-- find units nearby
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		damageTable.damage = damage
		if enemy:IsCreep() then
			damageTable.damage = damage
		end
		ApplyDamage( damageTable )

		-- slow
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
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