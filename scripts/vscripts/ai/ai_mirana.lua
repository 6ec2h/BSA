function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	MiranaArrow = thisEntity:FindAbilityByName( "mirana_arrow" )

	thisEntity:SetContextThink( "BanditArcherThink", BanditArcherThink, 0.5 )
end

--------------------------------------------------------------------------------
mirana_shot = 0

function BanditArcherThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end
	
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	local target = nil
	local hApproachTarget = nil
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() then
			local flDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 400 then
				if ( thisEntity.fTimeOfLastRetreat and ( GameRules:GetGameTime() < thisEntity.fTimeOfLastRetreat + 3 ) ) then
					target = hEnemy
				else
					return Retreat( hEnemy )
				end
			end
			if flDist <= 1000 then
				target = hEnemy
			end
			if flDist > 1000 then
				hApproachTarget = hEnemy
			end
		end
	end

	if target == nil and hApproachTarget ~= nil then
		return Approach( hApproachTarget )
	end
	
	if target ~= nil and MiranaArrow ~= nil and MiranaArrow:IsFullyCastable() and mirana_shot < 3 then
		mirana_shot = mirana_shot + 1
			CastArrow(target)
			Timers:CreateTimer({endTime = 0.2, callback = function()
				MiranaArrow:EndCooldown()
			end})
		return 0.5
	end
		if mirana_shot == 3 then 
			mirana_shot = 0
			MiranaArrow:StartCooldown(MiranaArrow:GetCooldown(1))
		end	
	
	if target then
		thisEntity:FaceTowards( target:GetOrigin() )
		return 1.0
	end
	return 1
end

--------------------------------------------------------------------------------

function CastArrow( hEnemy )		
	local fDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	local vTargetPos = hEnemy:GetOrigin()

	if ( fDist > 400 ) and hEnemy and hEnemy:IsMoving() then
		local vLeadingOffset = hEnemy:GetForwardVector() * RandomInt( 200, 400 )
		vTargetPos = hEnemy:GetOrigin() + vLeadingOffset
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = MiranaArrow:entindex(),
		Queue = false,
	})
	return 0.5
end

--------------------------------------------------------------------------------

function Approach(target)
	local vToEnemy = target:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})
	return 1
end

--------------------------------------------------------------------------------

function Retreat(target)
	local vAwayFromEnemy = thisEntity:GetOrigin() - target:GetOrigin()
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

	return 1.25
end