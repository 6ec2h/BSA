function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end
    if thisEntity == nil then
        return
    end

    PointAbility = thisEntity:FindAbilityByName( "tusk_ice_shards" )
	TargetAbility = thisEntity:FindAbilityByName( "tusk_walrus_punch" )
	NoTargetAbility = thisEntity:FindAbilityByName( "tusk_tag_team" )

    thisEntity:SetContextThink( "TuskThink", TuskThink, 0.5 )
end

function TuskThink()
    if (not thisEntity:IsAlive()) then
        return -1  
    end
   
    if GameRules:IsGamePaused() == true then
        return 1  
    end
	
	if thisEntity:IsInvisible() then  
        return Retreat()
    end

    local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		if #enemies > 0 then
			for _,unit in pairs(enemies) do
				if unit then	
					if PointAbility ~= nil and PointAbility:IsFullyCastable() then
						PointAbilityCast(unit)
						return 0.5
					end	
			
					if TargetAbility ~= nil and TargetAbility:IsFullyCastable()  then
						TargetAbilityCast( enemies[ RandomInt( 1, #enemies ) ] )
						return 0.5
					end
			
					local Dist = ( unit:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
					if Dist < 350 then
						if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable() then
							NoTargetAbilityCast()
							return 0.5
						end	
					end
				end
			end
		end		
	return 0.5 
end

---------------------------------------------------------

function PointAbilityCast(unit)
	if unit:IsMoving() then
		local vLeadingOffset = thisEntity:GetForwardVector() * 400
		vTargetPos = unit:GetOrigin() + vLeadingOffset
	else
		local vLeadingOffset = thisEntity:GetForwardVector() * 200
		vTargetPos = unit:GetOrigin() + vLeadingOffset
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = PointAbility:entindex(),
		Queue = false,
	})
    return 0.5
end

function TargetAbilityCast(enemy)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        AbilityIndex = TargetAbility:entindex(),
        TargetIndex = enemy:entindex(),
        Queue = false,
    })
   
    return 0.5
end

function NoTargetAbilityCast()	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = NoTargetAbility:entindex(),
		Queue = false,
	})
	return 0.5
end

function Retreat()
	local vLeadingOffset = thisEntity:GetForwardVector() * 200
	vAwayFromEnemy = thisEntity:GetOrigin() + vLeadingOffset
	
	vAwayFromEnemy = vAwayFromEnemy:Normalized()
	local vMoveToPos = thisEntity:GetOrigin() + vAwayFromEnemy * thisEntity:GetIdealSpeed()

	local nAttempts = 0
	while ( ( not GridNav:CanFindPath( thisEntity:GetOrigin(), vMoveToPos ) ) and ( nAttempts < 5 ) ) do
		vMoveToPos = thisEntity:GetOrigin() + RandomVector( thisEntity:GetIdealSpeed() )
		nAttempts = nAttempts + 1
	end

	thisEntity.fTimeOfLastRetreat = GameRules:GetGameTime()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vMoveToPos,
	})

	return 3
end