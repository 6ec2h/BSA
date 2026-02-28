function Spawn(entityKeyValues)
    if not IsServer() or thisEntity == nil then return end
    thisEntity:SetContextThink("NecroLordThink", NecroLordThink, 0.1)
end

function NecroLordThink()
    if not thisEntity:IsAlive() then return nil end
    if GameRules:IsGamePaused() then return 1 end

    local enemies = FindUnitsInRadius(
        thisEntity:GetTeamNumber(),
        thisEntity:GetAbsOrigin(),
        nil,
        1000,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 
        FIND_CLOSEST, 
        false
    )

    if #enemies > 0 then
        return Approach(enemies[1])
    end
    return 0.5 
end

function Approach( unit )
    local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
    vToEnemy = vToEnemy:Normalized()
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
    })
    return 0.5
endпоиска
                        DOTA_UNIT_TARGET_TEAM_ENEMY,    -- юнитов чьей команды ищем вражеской/дружественной
                        DOTA_UNIT_TARGET_ALL,    --юнитов какого типа ищем
                        DOTA_UNIT_TARGET_FLAG_NONE,    --поиск по флагам
                        FIND_CLOSEST,    --сортировка от ближнего к дальнему или от дальнего к ближнему
                        false )
				if #enemies > 0 then    -- если количество найденных юнитов больше нуля
					local enemy = enemies[1]
					if enemy ~= nil then
						return Approach( enemy )
					end
		end
	return 0.5 
end

function Approach( unit )
	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})
	return 0.5
end