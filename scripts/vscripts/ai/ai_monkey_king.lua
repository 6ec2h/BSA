function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hBoundlessStrike = thisEntity:FindAbilityByName( "monkey_king_boundless_strike" )
	thisEntity.hTreeDance = thisEntity:FindAbilityByName( "monkey_king_tree_dance" )
	thisEntity.hPrimalSpring = thisEntity:FindAbilityByName( "monkey_king_primal_spring" )
	thisEntity.command = thisEntity:FindAbilityByName( "monkey_king_wukongs_command_custom" )

	thisEntity.fSearchRadius = 600
	thisEntity.bIsOnTree = false
	thisEntity.flTreeDanceTime = 0
	thisEntity.bInitialized = false

	thisEntity:SetContextThink( "MonkeyKingThink", MonkeyKingThink, 1 )
end

--------------------------------------------------------------------------------

function MonkeyKingThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity.hTreeDance ~= nil and thisEntity.hTreeDance:IsChanneling() then
		return 1
	end
	
	if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = Vector(960,-1920,640)
		thisEntity.bInitialized = true
	end
	
	if ( not thisEntity.bAcqRangeModified ) and thisEntity:GetAggroTarget() then
		thisEntity:SetAcquisitionRange( 800 )
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
		if thisEntity.fTimeWeLostAggro and (GameRules:GetGameTime() > (thisEntity.fTimeWeLostAggro + 1.0)) then
			return RetreatHome()
		end
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.fSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 1
	end

	if thisEntity.command ~= nil and thisEntity.command:IsFullyCastable() then
		return CastCommand()
	end
	
	if thisEntity.hBoundlessStrike ~= nil and thisEntity.hBoundlessStrike:IsFullyCastable() then
		return CastBoundlessStrike( hEnemies[ RandomInt( 1, #hEnemies ) ] )
	end
	
	if thisEntity.hPrimalSpring ~= nil and thisEntity.hPrimalSpring:IsFullyCastable() then
		if thisEntity.hTreeDance ~= nil and thisEntity.hTreeDance:IsFullyCastable() then
			return CastTreeDance()
		else
			return CastPrimalSpring( hEnemies[ RandomInt( 1, #hEnemies ) ] )
		end
	end	
	return 1
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

--------------------------------------------------------------------------------

function CastCommand()	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.command:entindex(),
		Queue = false,
	})
	return 0.5
end

function CastBoundlessStrike( hEnemy )
	local fDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	local vTargetPos = hEnemy:GetOrigin()

	if ( fDist > 400 ) and hEnemy and hEnemy:IsMoving() then
		local vLeadingOffset = hEnemy:GetForwardVector() * RandomInt( 200, 380 )
		vTargetPos = hEnemy:GetOrigin() + vLeadingOffset
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = thisEntity.hBoundlessStrike:entindex(),
		Queue = false,
	})
	return 1
end

function CastPrimalSpring( hEnemy )
	thisEntity.flTreeDanceTime = GameRules:GetGameTime() + 15
	local fDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	local vTargetPos = hEnemy:GetOrigin()

	if ( fDist > 400 ) and hEnemy and hEnemy:IsMoving() then
		local vLeadingOffset = hEnemy:GetForwardVector() * RandomInt( 200, 380 )
		vTargetPos = hEnemy:GetOrigin() + vLeadingOffset
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = thisEntity.hPrimalSpring:entindex(),
		Queue = false,
	})
	return 1
end
--------------------------------------------------------------------------------

function CastTreeDance()
	local hTrees = GridNav:GetAllTreesAroundPoint( thisEntity:GetOrigin(), thisEntity.fSearchRadius, true )
	local hTree = nil
	if #hTrees > 0 then
		hTree = hTrees[RandomInt( 1, #hTrees )]
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET_TREE,
			AbilityIndex = thisEntity.hTreeDance:entindex(),
			TargetIndex = GetTreeIdForEntityIndex( hTree:entindex() ),
			Queue = false,
		})
		end
	return 1
end