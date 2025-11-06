function Spawn( entityKeyValues )
    if not IsServer() then return end
    if not thisEntity then return end

    DadoOneShoot = thisEntity:FindAbilityByName("dado_one_shoot")
	DadoOneShoot:SetLevel(2)

    thisEntity:SetContextThink("DadoOneShoot", DadoOneShootThink, 0.5)
end

function DadoOneShootThink()
    if (not thisEntity:IsAlive()) then
        return -1  
    end
   
    if GameRules:IsGamePaused() == true then
        return 1
    end

	if RemoveTimerStarted then
		return -1
	end

	local target = GetTarget()

	if not target then
		UTIL_Remove(thisEntity)
		return -1
	end

	if not target:IsAlive() then
		if not RemoveTimerStarted then
			RemoveTimerStarted = true

			Timers:CreateTimer(5, function()
    			ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, thisEntity) 
				UTIL_Remove(thisEntity)
			end)
		end

		return GoAway()
	end

	if (target:GetOrigin() - thisEntity:GetOrigin()):Length2D() > 2000 then
		return TeleportCloserToTarget()
	end
	
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        AbilityIndex = DadoOneShoot:entindex(),
        TargetIndex = target:entindex(),
        Queue = false,
    })

	return 0.5 
end

function GetTarget()
	if Target then return Target end

	local aliveHeroes = {}
	
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hero = PlayerResource:GetSelectedHeroEntity(nPlayerID)

			if hero and hero:IsAlive() then
				table.insert(aliveHeroes, hero)
			end
		end
	end

	if #aliveHeroes == 0 then
		return
	end

	Target = aliveHeroes[RandomInt(1, #aliveHeroes)]

	return Target
end

function TeleportCloserToTarget()
	local toTarget = Target:GetOrigin() - thisEntity:GetOrigin()
	toTarget = toTarget:Normalized() * 1500

	local teleportPos = Target:GetOrigin() - toTarget

	thisEntity:SetAbsOrigin(teleportPos)
	FindClearSpaceForUnit(thisEntity, teleportPos, true) 
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, thisEntity) 
	
	return 0.5
end

function IsInMapBounds(pos)
	local x, y = pos.x, pos.y

	return GetWorldMinX() <= x and x <= GetWorldMaxX() and GetWorldMinY() <= y and y <= GetWorldMaxY()
end

function GoAway()
	local away = (thisEntity:GetOrigin() - Target:GetOrigin())
    away.z = 0
    away = away:Normalized()
	
    local movePos = thisEntity:GetOrigin() + away * thisEntity:GetIdealSpeed() * 5

	if not IsInMapBounds(movePos) then
		movePos = thisEntity:GetOrigin() - away * thisEntity:GetIdealSpeed() * 5
	end

	ExecuteOrderFromTable({
        UnitIndex   = thisEntity:entindex(),
        OrderType   = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        Position    = movePos,
        Queue       = false,
    })

	return 6
end