function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	PudgeHook = thisEntity:FindAbilityByName( "creep_meat_hook" )
	PudgeUlt = thisEntity:FindAbilityByName( "creep_dismember" )

	thisEntity:SetContextThink( "BanditArcherThink", BanditArcherThink, 0.5 )
end

--------------------------------------------------------------------------------

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
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() then
			target = hEnemy
			local flDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 500 then
				PudgeUltCast(hEnemy)
			end
		end
	end

	if target ~= nil and PudgeHook ~= nil and PudgeHook:IsFullyCastable()then
		CastHook(target)
		return 0.5
	end

	if target then
		thisEntity:FaceTowards( target:GetOrigin() )
		return 1.0
	end
	return 1
end

--------------------------------------------------------------------------------

function CastHook( hEnemy )		
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
		AbilityIndex = PudgeHook:entindex(),
		Queue = false,
	})
	return 0.5
end

function PudgeUltCast(enemy)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),    --индекс кастера
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,    -- тип приказа
        AbilityIndex = PudgeUlt:entindex(), -- индекс способности
        TargetIndex = enemy:entindex(),
        Queue = false,
    })
    return 1.5
end