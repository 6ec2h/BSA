function Spawn( entityKeyValues )    -- вызывается когда юнит появляется
    if not IsServer() then        -- если сервер не отвечает
        return
    end
    if thisEntity == nil then    -- если данного юнита не существует
        return
    end

    PointAbility = thisEntity:FindAbilityByName( "techies_land_mines" )
   -- NoTargetAbility = thisEntity:FindAbilityByName( "custom_soul_release" )
	PointAbility2 = thisEntity:FindAbilityByName( "techies_stasis_trap" )
	PointAbility3 = thisEntity:FindAbilityByName( "techies_suicide" )

    thisEntity:SetContextThink( "NecroLordThink", NecroLordThink, 0.5 )    -- поведение юнита каждую секунду
end

function NecroLordThink()
    if ( not thisEntity:IsAlive() ) then        --если юнит мертв
        return -1  
    end
   
    if GameRules:IsGamePaused() == true then    --если игра приостановлена
        return 1  
    end


    local enemies = FindUnitsInRadius(
                        thisEntity:GetTeamNumber(),    --команда юнита
                        thisEntity:GetOrigin(),        --местоположение юнита
                        nil,    --айди юнита (необязательно)
                        1000,    --радиус поиска
                        DOTA_UNIT_TARGET_TEAM_ENEMY,    -- юнитов чьей команды ищем вражеской/дружественной
                        DOTA_UNIT_TARGET_HERO,    --юнитов какого типа ищем
                        DOTA_UNIT_TARGET_FLAG_NONE,    --поиск по флагам
                        FIND_CLOSEST,    --сортировка от ближнего к дальнему или от дальнего к ближнему
                        false )
	
	for _, unit in pairs( enemies ) do
		if unit ~= nil and unit:IsAlive() then --and hEnemy:GetUnitName() ~= "npc_dota_friendly_bristleback_son" 
			local flDist = ( unit:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 200 then
					return Retreat( unit )
				end
			end
			end
						
    if #enemies > 0     then    -- если количество найденных юнитов больше нуля
           if PointAbility ~= nil and PointAbility:IsFullyCastable()  then    --если абилка существует и её можно использовать
            for _,unit in pairs(enemies) do
				if unit then -- Тут все твои проверки на хп и прочее.
				PointAbilityCast(unit)
        end
		end
		return 1
		end
		
	if #enemies > 0     then    -- если количество найденных юнитов больше нуля
           if PointAbility2 ~= nil and PointAbility2:IsFullyCastable()  then    --если абилка существует и её можно использовать
            for _,unit in pairs(enemies) do
				if unit then -- Тут все твои проверки на хп и прочее.
				PointAbility2Cast(unit)
        end
		end
		return 1
		end		
	
	if #enemies > 0     then    -- если количество найденных юнитов больше нуля
           if PointAbility3 ~= nil and PointAbility3:IsFullyCastable() and thisEntity:GetHealthPercent() < 25 then    --если абилка существует и её можно использовать
            for _,unit in pairs(enemies) do
				if unit then -- Тут все твои проверки на хп и прочее.
				PointAbility3Cast(unit)
        end
		end
		return 1
		end			
		
	end
	end
	end
	return 0.5 

end


function PointAbilityCast(unit)
local vTargetPos = unit:GetOrigin()
ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = PointAbility:entindex(),
		Queue = false,
	})
    return 1.5
end

function PointAbility2Cast(unit)
local vTargetPos = unit:GetOrigin()
ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = PointAbility2:entindex(),
		Queue = false,
	})
    return 1.5
end

function PointAbility3Cast(unit)
local vTargetPos = unit:GetOrigin()
ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = PointAbility3:entindex(),
		Queue = false,
	})
    return 1.5
end



function Retreat(unit)
	--print( "ai_bandit_archer - Retreat" )

	local vAwayFromEnemy = thisEntity:GetOrigin() - unit:GetOrigin()
	vAwayFromEnemy = vAwayFromEnemy:Normalized()
	local vMoveToPos = thisEntity:GetOrigin() + vAwayFromEnemy * thisEntity:GetIdealSpeed()

	-- if away from enemy is an unpathable area, find a new direction to run to
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
