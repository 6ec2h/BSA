Ability_active = {"polar_furbolg_ursa_warrior_thunder_clap","satyr_hellcaller_shockwave","satyr_soulstealer_mana_burn","meepo_earthbind","shadow_shaman_ether_shock","lycan_howl","boss_ursa_earthshock_lua","boss_ursa_overpower_lua","ursa_enrage",
"kunkka_torrent","slardar_slithereen_crush","morphling_waveform","morph_heal","acid_blob_jump"}

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	thisEntity:SetContextThink( "CreepThink", CreepThink, 0.5 )
end

function CreepThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() or thisEntity:IsChanneling() then
		return 1
	end
	
	if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = thisEntity:GetOrigin()
		thisEntity.bInitialized = true
	end

	if ( not thisEntity.bAcqRangeModified ) and thisEntity:GetAggroTarget() then
		thisEntity:SetAcquisitionRange( 750 )
		thisEntity.bAcqRangeModified = true
	end

	local aggroTarget = thisEntity:GetAggroTarget()
	if aggroTarget then
		hasRetreated = false
		thisEntity.fTimeWeLostAggro = nil
		if not thisEntity.fTimeAggroStarted then
			thisEntity.fTimeAggroStarted = GameRules:GetGameTime()
		end
	else
		if thisEntity.fTimeAggroStarted then
			thisEntity.fTimeWeLostAggro = GameRules:GetGameTime()
			thisEntity.fTimeAggroStarted = nil
		end
		if thisEntity.fTimeWeLostAggro and not hasRetreated and GameRules:GetGameTime() > (thisEntity.fTimeWeLostAggro + 1.0) then
            hasRetreated = true
            return RetreatHome()
        end
	end
	
	local search_radius = 2000
	local cast_radius = 750

	local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
	local enemyTeam = DOTA_TEAM_GOODGUYS
    local filteredEnemies = {}
    
    for _, enemy in pairs(enemies) do
        if (enemy:GetTeamNumber() == enemyTeam) or enemy:GetUnitName() == 'npc_dota_observer_wards' then
            table.insert(filteredEnemies, enemy)
        end
    end
	
	if #filteredEnemies == 0 then
		thisEntity:AddNewModifier(thisEntity, nil, 'modifier_creep_antilag', {})
	else
		thisEntity:RemoveModifierByName('modifier_creep_antilag')
		local enemy = filteredEnemies[1]
		local distanceToenemy = (enemy:GetOrigin() - thisEntity:GetOrigin()):Length2D()
		if distanceToenemy < cast_radius and not enemy:IsInvisible() then
			for _, T in ipairs(Ability_active) do
				local Spell = thisEntity:FindAbilityByName(T)
				if Spell then
					local Behavior = Spell:GetBehaviorInt()
					if bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET ) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
						Spell.Behavior = "target"
						Cast( Spell, enemy )
					elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET ) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
						Spell.Behavior = "no_target"
						if Spell:GetSpecialValueFor("radius") == 0 then
							Cast( Spell, enemy )
						elseif ( enemy:GetOrigin()- thisEntity:GetOrigin() ):Length2D() < Spell:GetSpecialValueFor("radius") then
							Cast( Spell, enemy )
						end
					elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_POINT ) == DOTA_ABILITY_BEHAVIOR_POINT then
						Spell.Behavior = "point"
						Cast( Spell, enemy )
					elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_TOGGLE ) == DOTA_ABILITY_BEHAVIOR_POINT then
						Spell.Behavior = "toggle"
						if not Spell:GetToggleState() then 
							Spell:ToggleAbility()
						end
					elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_PASSIVE ) == DOTA_ABILITY_BEHAVIOR_PASSIVE then
						Spell.Behavior = "passive"
					end
				end
			end	
		end
	end
	return 0.2
end

--------------------------------------------------------------------------------

function Cast(Spell , enemy )
	local order_type
	local vTargetPos = enemy:GetOrigin()
    if Spell.Behavior == "target" then
        order_type = DOTA_UNIT_ORDER_CAST_TARGET
    elseif Spell.Behavior == "no_target" then
        order_type = DOTA_UNIT_ORDER_CAST_NO_TARGET
    elseif Spell.Behavior == "point" then
        order_type = DOTA_UNIT_ORDER_CAST_POSITION
    elseif Spell.Behavior == "passive" then
        return
    end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = order_type,
		Position = vTargetPos,
		TargetIndex = enemy:entindex(),  
		AbilityIndex = Spell:entindex(),
		Queue = false,
	})
end

--------------------------------------------------------------------------------

function RetreatHome()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = thisEntity.vInitialSpawnPos,
	})
	return 0.5
end