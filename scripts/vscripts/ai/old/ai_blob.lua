function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	PointAbility = thisEntity:FindAbilityByName( "acid_blob_jump" )

	thisEntity:SetContextThink( "MorphThink", MorphThink, 1 )
end

--------------------------------------------------------------------------------

function MorphThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
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

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )	
	if PointAbility ~= nil and PointAbility:IsFullyCastable() then
		for _,unit in pairs(enemies) do
			if unit then
				PointAbilityCast(unit)
				end
			end
		end
	return 0.5
end

function RetreatHome()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = thisEntity.vInitialSpawnPos,
	})

	return 0.5
end


function PointAbilityCast(unit)
local vTargetPos = unit:GetOrigin()
ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos + RandomVector( RandomFloat( 150, 150 )),
		AbilityIndex = PointAbility:entindex(),
		Queue = false,
	})
    return 1.5
end