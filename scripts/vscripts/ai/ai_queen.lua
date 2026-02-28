function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end
    if thisEntity == nil then
        return
    end

    PointAbility = thisEntity:FindAbilityByName( "arc_warden_spark_wraith" )
	NoTargetAbility = thisEntity:FindAbilityByName( "crystal_maiden_freezing_field" )
	NoTargetAbility2 = thisEntity:FindAbilityByName( "queen_field" )

    thisEntity:SetContextThink( "QueenThink", QueenThink, 0.5 )
end

function QueenThink()
    if (not thisEntity:IsAlive()) then
        return -1  
    end
   
    if GameRules:IsGamePaused() == true then
        return 1  
    end
	
	if thisEntity:IsChanneling() then
        return 0.5  
    end

    local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		if #enemies > 0 then
			for _,unit in pairs(enemies) do
				if unit then	
					if PointAbility ~= nil and PointAbility:IsFullyCastable() then
						PointAbilityCast(unit)
						return 0.5
					end	
			
					if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable() then
						NoTargetAbilityCast()
						return 0.5
					end	
					
					if NoTargetAbility2 ~= nil and NoTargetAbility2:IsFullyCastable() then
						NoTargetAbilityCast2()
						return 0.5
					end	
				end
			end
		end		
	return 0.5 
end

---------------------------------------------------------

function PointAbilityCast(unit)
	if unit:IsMoving() then
		local vLeadingOffset = thisEntity:GetForwardVector() * 400
		vTargetPos = unit:GetOrigin() + vLeadingOffset
	else
		local vLeadingOffset = thisEntity:GetForwardVector() * 200
		vTargetPos = unit:GetOrigin() + vLeadingOffset
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = PointAbility:entindex(),
		Queue = false,
	})
    return 0.5
end

function NoTargetAbilityCast()	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = NoTargetAbility:entindex(),
		Queue = false,
	})
	return 0.5
end

function NoTargetAbilityCast2()	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = NoTargetAbility2:entindex(),
		Queue = false,
	})
	return 0.5
end