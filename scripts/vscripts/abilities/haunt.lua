function HauntCast(keys)

	local caster = keys.caster
	local target = keys.target
	local unit = "npc_dota_creature_snow_ullusion"

	local sound = keys.sound
	EmitSoundOn(sound, target)

	local ability = keys.ability
	local origin = target:GetAbsOrigin() + RandomVector(100)
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local attackDelay = ability:GetLevelSpecialValueFor( "attack_delay", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "illusion_outgoing_damage", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor( "illusion_incoming_damage", ability:GetLevel() - 1 )

	local illusion = CreateUnitByName(unit, origin, true, caster, nil, caster:GetTeamNumber())

	illusion:SetForwardVector(target:GetAbsOrigin() - illusion:GetAbsOrigin())

	Timers:CreateTimer(0.1, function()
			for i = 0, illusion:GetAbilityCount() - 1 do
			local ability = illusion:GetAbilityByIndex(i)
				if ability and not ability:IsNull() and not ability:IsAttributeBonus() then
				illusion:RemoveAbility(ability:GetName())
				end
			end
		end) 



	-- Set the unit as an illusion
	illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
	
	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()

	--Apply the modifier for illusion: 400 movespeed and flying pathing
	ability:ApplyDataDrivenModifier(caster, illusion, "modifier_spectre_haunt_illusion_buff", {duration = duration})

	--Apply the modifier for illusion: No attack for the first second
	ability:ApplyDataDrivenModifier(caster, illusion, "modifier_spectre_haunt_illusion_debuff", {duration = attackDelay})

	illusion:MoveToNPC(target)

	-- 10 second delayed, run once using gametime (respect pauses)
	Timers:CreateTimer({
		endTime = attackDelay, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		callback = function()
			-- Force Illusion to attack Target
			illusion:SetForceAttackTarget(target)
		end
	})

	caster.haunting = true

	-- 10 second delayed, run once using gametime (respect pauses)
	Timers:CreateTimer({
		endTime = duration, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		callback = function()
			caster.haunting = false
		end
	})
	
	Timers:CreateTimer({
		endTime = 2, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		callback = function()
			caster.haunting = false
			
			local hEnemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 2500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
			if #hEnemies > 0 then

		end
		hEnemy = hEnemies[ RandomInt( 1, #hEnemies ) ]
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() and hEnemy:GetUnitName() == "npc_dota_creature_snow_ullusion" then --проверить
		local vPoint = hEnemy:GetOrigin()
	
			
			local caster_forward_vector = caster:GetForwardVector()
			local target_forward_vector = hEnemy:GetForwardVector()

			caster:SetForwardVector(target_forward_vector)
			hEnemy:SetForwardVector(caster_forward_vector)

			local caster_current_position = caster:GetAbsOrigin()
			local target_current_position = hEnemy:GetAbsOrigin()
	
			hEnemy:SetAbsOrigin(caster_current_position)	
			caster:SetAbsOrigin(target_current_position)

			FindClearSpaceForUnit( caster, target_current_position, true )

			EmitSoundOn("Hero_Spectre.Reality", caster)

			end
		end	
	end})
end



