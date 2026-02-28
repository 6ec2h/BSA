lord_active = {"custom_doom","custom_pit","creature_fire_breath","custom_solar_flare"}

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	thisEntity:SetContextThink( "CreepThink", CreepThink, 0.5 )
end

--------------------------------------------------------------------------------

function CreepThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if thisEntity:IsChanneling() then  
        return 1 
    end
	
	if thisEntity:HasModifier("modifier_custom_doom") then
		thisEntity:RemoveModifierByName("modifier_custom_doom")
	end

	if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = Vector(11617,14992,256)
		thisEntity.bInitialized = true
	end

	if ( not thisEntity.bAcqRangeModified ) and thisEntity:GetAggroTarget() then
		thisEntity:SetAcquisitionRange( 750 )
		thisEntity.bAcqRangeModified = true
	end

	if thisEntity:GetAggroTarget() then
		thisEntity.fTimeWeLostAggro = nil
	end

	if thisEntity:GetAggroTarget() and ( thisEntity.fTimeAggroStarted == nil ) then
		thisEntity.fTimeAggroStarted = GameRules:GetGameTime()
	end

	if ( not thisEntity:GetAggroTarget() ) and ( thisEntity.fTimeAggroStarted ~= nil ) then
		thisEntity.fTimeWeLostAggro = GameRules:GetGameTime()
		thisEntity.fTimeAggroStarted = nil
	end

	if ( not thisEntity:GetAggroTarget() ) then
		if thisEntity.fTimeWeLostAggro and ( GameRules:GetGameTime() > ( thisEntity.fTimeWeLostAggro + 1.0 ) ) then
			return RetreatHome()
		end
	end

	local search_radius = thisEntity:GetAcquisitionRange()
	local hp = thisEntity:GetHealthPercent()
	local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies > 0 then
		enemy = enemies[ RandomInt( 1, #enemies ) ]
		local random_skill = lord_active[RandomInt(1, #lord_active)]
		local Spell = thisEntity:FindAbilityByName(random_skill)
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
	return 0.3
end

--------------------------------------------------------------------------------

function Cast( Spell , enemy )
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