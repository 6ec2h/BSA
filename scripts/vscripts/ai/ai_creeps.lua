local THINK_INTERVAL = 0.25
local RETREAT_DISTANCE = 1500
local SEARCH_DISTANCE = 2000
local non_100_pct_cast = {
    "item_guardian_greaves",
    "item_satanic",
    "item_bloodstone",
    "item_crimson_guard",
    "item_pipe",
    "item_glimmer_cape"
}
local CAST_HP_PCT = 80


function Spawn(entityKeyValues)
    if not IsServer() or not thisEntity then return end
    thisEntity.refresh = 0
    thisEntity.spells = {}
    thisEntity.items = {}
    thisEntity.bInitialized = false
    thisEntity.fTimeOfLastRetreat = 0
    thisEntity:SetContextThink("NeutralThink", function() return NeutralThink() end, THINK_INTERVAL)
end

function UpdateAbilitiesAndItems()
    thisEntity.spells = {}

    local abilityCount = thisEntity:GetAbilityCount()
    for i = 0, abilityCount - 1 do
        local ability = thisEntity:GetAbilityByIndex(i)
        if ability and not ability:IsAttributeBonus() and not ability:IsHidden() and not ability:IsPassive() then
            table.insert(thisEntity.spells, ability)
        end
    end

    thisEntity.items = {}
    for i = 0, 5 do
        local item = thisEntity:GetItemInSlot(i)
        if item then
            table.insert(thisEntity.items, item)
        end
    end
end

function NeutralThink()
    if not thisEntity:IsAlive() then return -1 end

    if thisEntity:IsStunned() or thisEntity:IsSilenced() or GameRules:IsGamePaused() then
        return THINK_INTERVAL
    end

    if not thisEntity.bInitializedSpells then
        UpdateAbilitiesAndItems()
        thisEntity.bInitializedSpells = true
    end

    if not thisEntity.bInitialized then
        thisEntity.vInitialSpawnPos = thisEntity:GetAbsOrigin()
        thisEntity.bInitialized = true
    end

    local aggroTarget = thisEntity:GetAggroTarget()
    local curTime = GameRules:GetGameTime()

    if aggroTarget then
        thisEntity.fTimeWeLostAggro = nil
    elseif not thisEntity.fTimeWeLostAggro then
        thisEntity.fTimeWeLostAggro = curTime
    end

    local enemies = FindUnitsInRadius(
        thisEntity:GetTeamNumber(), 
        thisEntity:GetOrigin(), 
        nil, 
        SEARCH_DISTANCE, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_ALL, 
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
        FIND_CLOSEST, 
        false
    )

    local filteredEnemies = {}
    local filteredEnemiesForCast = {}

    local retreat = false
    local retreat_enemy = nil

    for _, enemy in pairs(enemies) do
        local unitName = enemy:GetUnitName()
        local unitTeam = enemy:GetTeamNumber()

        if unitTeam == DOTA_TEAM_GOODGUYS or unitName == 'npc_dota_observer_wards' then
            table.insert(filteredEnemies, enemy)
        end

        if unitTeam == DOTA_TEAM_GOODGUYS and unitName ~= 'npc_dota_observer_wards' then
            table.insert(filteredEnemiesForCast, enemy)
        end

        if thisEntity:IsRangedAttacker() then
            local flDist = (enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
            if flDist < 400 then
                if (thisEntity.fTimeOfLastRetreat and ( GameRules:GetGameTime() > thisEntity.fTimeOfLastRetreat + 4)) then
                    retreat = true
                    retreat_enemy = enemy
                end
            end
        end
    end

    if #filteredEnemies == 0 then
        if not thisEntity:HasModifier('modifier_creep_antilag') then
            thisEntity:AddNewModifier(thisEntity, nil, 'modifier_creep_antilag', {})
        end
    else
        thisEntity:RemoveModifierByName('modifier_creep_antilag')
    end

    local distFromHome = (thisEntity:GetAbsOrigin() - thisEntity.vInitialSpawnPos):Length2D()
    local bTooFar = distFromHome > RETREAT_DISTANCE
    local bLostAggro = thisEntity.fTimeWeLostAggro and (curTime - thisEntity.fTimeWeLostAggro > 2.0)


    thisEntity.castables = {}

    if #filteredEnemiesForCast > 0 then
   
        thisEntity.target = filteredEnemiesForCast[RandomInt(1, #filteredEnemiesForCast)]

        for _, ability in ipairs(thisEntity.spells) do
            if ability:IsFullyCastable() and not ability:IsPassive() then
        
                local castRange = ability:GetCastRange(thisEntity:GetAbsOrigin(), thisEntity.target)
                local castRangeBonus = thisEntity:GetCastRangeBonus()
                local totalRange = castRange + castRangeBonus
                
                if totalRange <= 0 then
                    totalRange = thisEntity:GetAcquisitionRange()
                end

                local dist = (thisEntity.target:GetAbsOrigin() - thisEntity:GetAbsOrigin()):Length2D()
                local behavior = ability:GetBehaviorInt()
                
                local needsRangeCheck = bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET or 
                                        bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT or
                                        bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET

                if needsRangeCheck then
                    if dist <= totalRange - 100 then
                        table.insert(thisEntity.castables, ability)
                    end
                else
                    table.insert(thisEntity.castables, ability)
                end
            end
        end

        for _, item in ipairs(thisEntity.items) do
            if item and not item:IsNull() and item:IsFullyCastable() then
                local itemName = item:GetName()
                local castRange = item:GetCastRange(thisEntity:GetAbsOrigin(), thisEntity.target)
                
                if castRange <= 0 then
                    castRange = thisEntity:GetAcquisitionRange()
                end
                
                local dist = (thisEntity.target:GetAbsOrigin() - thisEntity:GetAbsOrigin()):Length2D()
                
                if dist <= castRange then
                    local isLimited = false
                    for _, subString in ipairs(non_100_pct_cast) do
                        if string.find(itemName, subString) then
                            isLimited = true
                            break
                        end
                    end

                    local canCast = true
                    
                    if isLimited then
                        if thisEntity:GetHealthPercent() >= CAST_HP_PCT then
                            canCast = false
                        end
                    end

                    if string.find(itemName, "item_octarine_core") and thisEntity.refresh < 5 then
                        canCast = false
                    end

                    if canCast then
                        table.insert(thisEntity.castables, item)
                    end
                end
            end
        end
    end

    if retreat and retreat_enemy then
        return Retreat(retreat_enemy)
    end

    if #thisEntity.castables > 0 and thisEntity.target then
        local spell = thisEntity.castables[RandomInt(1, #thisEntity.castables)]
        if spell:IsCooldownReady() then
            ExecuteSmartCast(spell, thisEntity.target)
            return THINK_INTERVAL
        end
    end

    if distFromHome >= 100 and bTooFar then
        return RetreatHome()
    end

    if distFromHome >= 100 and bLostAggro then
        return RetreatHome()
    end

    return THINK_INTERVAL
end

function ExecuteSmartCast(ability, target)
    if not ability or ability:IsNull() or not target or target:IsNull() then return end

    local behavior = ability:GetBehaviorInt()
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    
    if target:IsUnselectable() or target:IsInvulnerable() or target:IsOther() then 
        return 
    end

    local order = {
        UnitIndex = thisEntity:entindex(),
        AbilityIndex = ability:entindex(),
        Queue = false
    }

    if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
        
        local finalTarget = target

        if bit.band(targetTeam, DOTA_UNIT_TARGET_TEAM_FRIENDLY) ~= 0 then
            local castRange = ability:GetCastRange(thisEntity:GetAbsOrigin(), nil) + thisEntity:GetCastRangeBonus()
            
            local friendlies = FindUnitsInRadius(
                thisEntity:GetTeamNumber(),
                thisEntity:GetAbsOrigin(),
                nil,
                castRange,
                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                targetType,
                DOTA_UNIT_TARGET_FLAG_NONE,
                FIND_ANY_ORDER,
                false
            )

            local weakestFriendly = nil
            local lowestHealthPct = 1.1

            for _, friend in pairs(friendlies) do
                if friend and not friend:IsNull() and friend:IsAlive() and not friend:IsInvulnerable() then
                    local healthPct = friend:GetHealth() / friend:GetMaxHealth()
                    if healthPct < lowestHealthPct then
                        lowestHealthPct = healthPct
                        weakestFriendly = friend
                    end
                end
            end

            if weakestFriendly then
                finalTarget = weakestFriendly
            else
                return
            end
        end

        local isTargetHero = finalTarget:IsHero()
        local allowsHeroes = bit.band(targetType, DOTA_UNIT_TARGET_HERO) ~= 0
        local allowsBasic = bit.band(targetType, DOTA_UNIT_TARGET_BASIC) ~= 0

        if isTargetHero and not allowsHeroes then return end
        if not isTargetHero and not allowsBasic then return end

        order.OrderType = DOTA_UNIT_ORDER_CAST_TARGET
        order.TargetIndex = finalTarget:entindex()

    elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT then
        order.OrderType = DOTA_UNIT_ORDER_CAST_POSITION
        order.Position = target:GetAbsOrigin()

        local fDist = (target:GetOrigin() - thisEntity:GetOrigin()):Length2D()
        if fDist > 400 and target:IsMoving() then
            local vLeadingOffset = target:GetForwardVector() * RandomInt(200, 400)
            order.Position = target:GetOrigin() + vLeadingOffset
        end

    elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
        order.OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET

    elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_TOGGLE) == DOTA_ABILITY_BEHAVIOR_TOGGLE then
        if not ability:GetToggleState() then 
            ability:ToggleAbility() 
        end
        return
    else
        return 
    end

    if string.find(ability:GetName(), "item_octarine_core") then
        thisEntity.refresh = 0
    else
        thisEntity.refresh = thisEntity.refresh + 1
    end

    if order.OrderType then
        ExecuteOrderFromTable(order)
    end
end

function RetreatHome()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = thisEntity.vInitialSpawnPos,
	})
	return THINK_INTERVAL
end

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

	return THINK_INTERVAL * 4
end