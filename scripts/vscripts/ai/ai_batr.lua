function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end
    if thisEntity == nil then
        return
    end


	TargetAbility = thisEntity:FindAbilityByName( "batrider_flaming_lasso" )

    thisEntity:SetContextThink( "BatrThink", BatrThink, 0.5 )
end

function BatrThink()
    if (not thisEntity:IsAlive()) then
        return -1  
    end
   
    if GameRules:IsGamePaused() == true then
        return 1  
    end
	
	if not thisEntity.bSearchedForItems then
		SearchForItems()
		thisEntity.bSearchedForItems = true
	end

    local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		if #enemies > 0 then
			for _,unit in pairs(enemies) do
				if unit then	
					if thisEntity.Blink and thisEntity.Blink:IsFullyCastable() then
						UseBlink( unit )	
						return 0.5
					end	
					
					if TargetAbility ~= nil and TargetAbility:IsFullyCastable()  then
						TargetAbilityCast( enemies[ RandomInt( 1, #enemies ) ] )
						return 0.5
					end		
				end
				
				if unit and unit:HasModifier("modifier_batrider_flaming_lasso") then
					Retreat(unit)
				end
			end
		end		
	return 0.5 
end

---------------------------------------------------------

function SearchForItems()
	for i = 0, 5 do
		local item = thisEntity:GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == "item_blink" then
				thisEntity.Blink = item
			end
		end
	end
end

function UseBlink( unit )
	vTargetPos = unit:GetOrigin()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = thisEntity.Blink:entindex(),
		Queue = false,
	})
	return 1
end

function TargetAbilityCast(enemy)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        AbilityIndex = TargetAbility:entindex(),
        TargetIndex = enemy:entindex(),
        Queue = false,
    })
    return 0.5
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
	return 1.5
end