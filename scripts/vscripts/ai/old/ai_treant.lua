
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	TargetAbility = thisEntity:FindAbilityByName( "treant_seed" )
	NoTargetAbility = thisEntity:FindAbilityByName( "treant_overgrowth" )

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
	
	 local enemies = FindUnitsInRadius(
                        thisEntity:GetTeamNumber(),    --команда юнита
                        thisEntity:GetOrigin(),        --местоположение юнита
                        nil,    --айди юнита (необязательно)
                        600,    --радиус поиска
                        DOTA_UNIT_TARGET_TEAM_ENEMY,    -- юнитов чьей команды ищем вражеской/дружественной
                        DOTA_UNIT_TARGET_ALL,    --юнитов какого типа ищем
                         DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,    --поиск по флагам
                        FIND_CLOSEST,    --сортировка от ближнего к дальнему или от дальнего к ближнему
                        false )
						
	
	  if #enemies > 0     then    -- если количество найденных юнитов больше нуля
           if TargetAbility ~= nil and TargetAbility:IsFullyCastable()  then    --если абилка существует и её можно использовать
            for _,unit in pairs(enemies) do
				if unit then -- Тут все твои проверки на хп и прочее.
				TargetAbilityCast(unit)
        end
		end
		return 0.5
		end

	if #enemies > 0    then
        if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable() then    --если абилка существует и её можно использовать
            for _,unit in pairs(enemies) do
				if unit then -- Тут все твои проверки на хп и прочее.
				NoTargetAbilityCast(unit)
        end
		end
		return 0.5
		end
		
	if #enemies > 0    then
            for _,unit in pairs(enemies) do
				if unit then -- Тут все твои проверки на хп и прочее.
					Approach(unit)
				end
				return 0.5
			end
end
end
end

	return 0.5
end


function TargetAbilityCast(enemy)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),    --индекс кастера
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,    -- тип приказа
        AbilityIndex = TargetAbility:entindex(), -- индекс способности
        TargetIndex = enemy:entindex(),
        Queue = false,
    })
   
    return 1.5
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

function NoTargetAbilityCast(unit)
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = NoTargetAbility:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end

function Approach(unit)
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = unit:entindex()
	})
	return 1
end


