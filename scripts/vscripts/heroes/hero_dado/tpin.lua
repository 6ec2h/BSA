function Spawn( entityKeyValues )    -- вызывается когда юнит появляется
	if not IsServer() then        -- если сервер не отвечает
        return
    end
    if thisEntity == nil then    -- если данного юнита не существует
        return
    end
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
                        100,    --радиус поиска
                        DOTA_UNIT_TARGET_TEAM_FRIENDLY,    -- юнитов чьей команды ищем вражеской/дружественной
                        DOTA_UNIT_TARGET_HERO,    --юнитов какого типа ищем
                        DOTA_UNIT_TARGET_FLAG_NONE,    --поиск по флагам
                        FIND_CLOSEST,    --сортировка от ближнего к дальнему или от дальнего к ближнему
                        false )

    if #enemies > 0 then
            for _,unit in pairs(enemies) do
			if unit:IsHero() then
				blink(unit)
       end
		return 0.5
		end
		end
	return 0.1
end

function blink(unit)
	local friendlies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		for _,friendly in pairs ( friendlies ) do
			if friendly ~= nil then	
				if friendly:GetUnitName() == "tp_out" then
					local fDist = friendly:GetOrigin()
				if unit:IsHero() then
			unit:AddNewModifier( unit, nil, "modifier_invulnerable", { duration = 0.1 } )	
			unit:SetAbsOrigin( fDist + RandomVector( RandomFloat(50, 50 ))  )
			unit:EmitSound("DOTA_Item.BlinkDagger.Activate") --Emit sound for the blink
		FindClearSpaceForUnit(unit, fDist, false)
		unit:Stop()
	return 1
end
end
end
end
end