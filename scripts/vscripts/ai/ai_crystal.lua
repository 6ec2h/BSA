function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	Nova = thisEntity:FindAbilityByName( "crystal_maiden_crystal_nova" )
	Field = thisEntity:FindAbilityByName( "crystal_maiden_freezing_field_lua" )

	thisEntity:SetContextThink( "CrystalThink", CrystalThink, 0.5 )
end

--------------------------------------------------------------------------------

function CrystalThink()
	if not IsServer() then
		return
	end
	
	if not thisEntity.bSearchedForItems then
		SearchForItems()
		thisEntity.bSearchedForItems = true
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if thisEntity:IsChanneling() then  
        return 1 
    end
	
	if thisEntity:IsInvisible() then  
        return Retreat()
    end
	
	local all_units = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	local hAttackTarget = nil
	local hApproachTarget = nil
	for _, unit in pairs( all_units ) do
		if thisEntity:GetTeamNumber() ~= unit:GetTeamNumber() and unit ~= nil and unit:IsAlive() then
			local flDist = ( unit:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 400 then
				if ( thisEntity.fTimeOfLastRetreat and ( GameRules:GetGameTime() < thisEntity.fTimeOfLastRetreat + 3 ) ) then
					hAttackTarget = unit
				else
					return Retreat(unit)
				end
			end
			if flDist <= 1000 then
				hAttackTarget = unit
			end
			if flDist > 1000 then
				hApproachTarget = unit
			end
		end
		if thisEntity:GetTeamNumber() == unit:GetTeamNumber() and unit:IsAlive() and unit:GetHealthPercent() < 20 then 
			if thisEntity.Glimmer and thisEntity.Glimmer:IsFullyCastable() then
				return UseGlimmer(unit)	
			end	
		end
	end
	
	if thisEntity:GetHealthPercent() < 20 then
		return CastField()
	end

	if hAttackTarget == nil and hApproachTarget ~= nil then
		return Approach( hApproachTarget )
	end

	if hAttackTarget and Nova ~= nil and Nova:IsFullyCastable() then
		return CastNova( hAttackTarget )
	end

	if hAttackTarget then
		thisEntity:FaceTowards( hAttackTarget:GetOrigin() )
		return 1.0
	end
	return 0.5
end



--------------------------------------------------------------------------------

function SearchForItems()
	for i = 0, 5 do
		local item = thisEntity:GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == "item_glimmer_cape" then
				thisEntity.Glimmer = item
			end
		end
	end
end

function UseGlimmer(unit)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        AbilityIndex = thisEntity.Glimmer:entindex(),
        TargetIndex = unit:entindex(),
        Queue = false,
    })
    return 0.5
end

function CastField()	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = Field:entindex(),
		Queue = false,
	})
	return 0.5
end

function CastNova( unit )
	local fDist = ( unit:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	local vTargetPos = unit:GetOrigin()

	if ( fDist > 400 ) and unit and unit:IsMoving() then
		local vLeadingOffset = unit:GetForwardVector() * RandomInt( 200, 380 )
		vTargetPos = unit:GetOrigin() + vLeadingOffset
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = Nova:entindex(),
		Queue = false,
	})
	return 1
end

function Approach(unit)
	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})
	return 1
end

function Retreat(unit)
	if unit then
		vAwayFromEnemy = thisEntity:GetOrigin() - unit:GetOrigin()
	else
		local vLeadingOffset = thisEntity:GetForwardVector() * 200
		vAwayFromEnemy = thisEntity:GetOrigin() + vLeadingOffset
	end
	
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