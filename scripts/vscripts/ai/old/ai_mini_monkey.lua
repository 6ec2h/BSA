function Spawn(entityKeyValues)
    if not IsServer() then
        return
    end

    if thisEntity == nil then
        return
    end

    thisEntity:SetContextThink("CrystalThink", CrystalThink, 0.5)
end

--------------------------------------------------------------------------------

function CrystalThink()
    if not IsServer() then
        return
    end

    if not thisEntity:IsAlive() then
        return -1
    end

    if GameRules:IsGamePaused() == true then
        return 1
    end
	
	if not spawnPoint then
		spawnPoint = thisEntity:GetAbsOrigin()
	end

    local units = FindUnitsInRadius(
        thisEntity:GetTeamNumber(),
        thisEntity:GetOrigin(),
        nil,
        800,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
        FIND_CLOSEST,
        false
    )
    
    local hAttackTarget = nil
    local hApproachTarget = nil

    for _, unit in pairs(units) do
        local flDist = (unit:GetOrigin() - thisEntity:GetOrigin()):Length2D()
        if flDist < 700 then
            return Retreat(spawnPoint, unit)
        end

        if thisEntity:GetHealthPercent() < 25 then 
            local ability = thisEntity:FindItemInInventory('item_glimmer_cape')
            if ability then
                UseGlimmer()
            end
        end
    end

    return 1.5
end

-----------------------------------------------------------------------------------------

function UseGlimmer()
    local ability = thisEntity:FindItemInInventory('item_glimmer_cape')
    if ability then
        ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
            AbilityIndex = ability:entindex(),
            TargetIndex = thisEntity:entindex(),
            Queue = false,
        })
    end
    return 0.1
end

function Retreat(spawnPoint, unit)
    local vLeadingOffset = thisEntity:GetForwardVector() * 600
    local vAwayFromEnemy = thisEntity:GetOrigin() + vLeadingOffset

    vAwayFromEnemy = vAwayFromEnemy:Normalized()
    local vMoveToPos = thisEntity:GetOrigin() + vAwayFromEnemy * thisEntity:GetIdealSpeed()

    if (vMoveToPos - spawnPoint):Length2D() > 5000 then
        vMoveToPos = spawnPoint + (vMoveToPos - spawnPoint):Normalized() * 5000
    end

    local nAttempts = 0
    while (not GridNav:CanFindPath(thisEntity:GetOrigin(), vMoveToPos) and nAttempts < 5) do
        vMoveToPos = thisEntity:GetOrigin() + RandomVector(thisEntity:GetIdealSpeed())
        nAttempts = nAttempts + 1
    end

    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        Position = vMoveToPos,
    })
    return 0.5
end
