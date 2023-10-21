AI = {}

AI.Init = function( thisEntity )
	thisEntity.aiState = {
		hAggroTarget = nil,
		flShoutRange = 100,
		nWalkingMoveSpeed = 280,
		nAggroMoveSpeed = 380,
		flAcquisitionRange = 1000,
		vTargetWaypoint = nil,
		isAttacking = false,
	}
	thisEntity:SetContextThink( "init_think", function() 
		thisEntity.HellbearThink = HellbearThink
		thisEntity.CheckIfHasAggro = CheckIfHasAggro
		thisEntity.RoamBetweenWaypoints = RoamBetweenWaypoints
		thisEntity:SetAcquisitionRange( thisEntity.aiState.flAcquisitionRange )
		thisEntity.bIsRoaring = false
		
		local tWaypoints = {}
		local nWaypointsPerRoamNode = 3
		local nMinWaypointSearchDistance = 0
		local nMaxWaypointSearchDistance = 1048

		while #tWaypoints < nWaypointsPerRoamNode do
			local vWaypoint = thisEntity:GetAbsOrigin() + RandomVector( RandomFloat( nMinWaypointSearchDistance, nMaxWaypointSearchDistance ) )
			if GridNav:CanFindPath( thisEntity:GetAbsOrigin(), vWaypoint ) then
				table.insert( tWaypoints, vWaypoint )
			end
		end
		thisEntity.aiState.tWaypoints = tWaypoints
		
		thisEntity.leshrac_pulse_nova = thisEntity:FindAbilityByName( "leshrac_pulse_nova" )
		
		thisEntity:SetContextThink( "ai_base_creature.HellbearThink", Dynamic_Wrap( thisEntity, "HellbearThink" ), 0 )
	end, 0 )
end

--------------------------------------------------------------------------------

function HellbearThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if thisEntity:IsChanneling() then
        return 1 
    end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies > 0 then
			
			if thisEntity.leshrac_pulse_nova ~= nil and thisEntity.leshrac_pulse_nova:IsFullyCastable() then
			if not thisEntity.leshrac_pulse_nova:GetToggleState() then 
					thisEntity.leshrac_pulse_nova:ToggleAbility()
					end
			--	return CastNova( hAttackTarget )
			end
			
		end
	local agro = thisEntity:CheckIfHasAggro()
	if agro then
		return agro
	end
	return thisEntity:RoamBetweenWaypoints()
end

--------------------------------------------------------------------------------

function CastNova( hEnemy )
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET, 
            AbilityIndex = thisEntity.leshrac_pulse_nova:entindex(),
            Queue = false,
        })
    return 1
end

------------------------------------------------------------------------------
function CheckIfHasAggro( thisEntity )
	if thisEntity:GetAggroTarget() ~= nil then
		thisEntity:SetBaseMoveSpeed( thisEntity.aiState.nAggroMoveSpeed )
		if thisEntity:GetAggroTarget() ~= thisEntity.aiState.hAggroTarget then
			thisEntity.aiState.hAggroTarget = thisEntity:GetAggroTarget()
		end
		 
		if not thisEntity.aiState.isAttacking then
			thisEntity.aiState.ChasingStartPos = thisEntity:GetAbsOrigin()
	 		thisEntity.aiState.isAttacking = true
	 	else
	 		local distance = (thisEntity:GetAbsOrigin() - thisEntity.aiState.ChasingStartPos):Length2D()
	 		if distance > 2000 then
	 			thisEntity:MoveToPosition(thisEntity.aiState.ChasingStartPos)
	 			return distance / 200
	 		end
		end

	 	return 1
	else

		thisEntity:SetBaseMoveSpeed( thisEntity.aiState.nWalkingMoveSpeed )
		thisEntity.bIsRoaring = false
		return nil
	end
end


function RoamBetweenWaypoints( thisEntity )
	local gameTime = GameRules:GetGameTime()
	local aiState = thisEntity.aiState
	if aiState.vWaypoint ~= nil then
		local flRoamTimeLeft = aiState.flNextWaypointTime - gameTime
		if flRoamTimeLeft <= 0 then
			aiState.vWaypoint = nil
		end
	end
	if aiState.vWaypoint == nil then
	 aiState.vWaypoint = aiState.tWaypoints[ RandomInt( 1, #aiState.tWaypoints ) ]
	 aiState.flNextWaypointTime = gameTime + RandomFloat( 2, 4 )
		thisEntity:MoveToPositionAggressive( aiState.vWaypoint )
	end
	return 1
end

function Spawn( entityKeyValues )
    AI.Init( thisEntity )
end
