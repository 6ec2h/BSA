function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end
    if thisEntity == nil then
        return
    end

    thisEntity.illuminate = thisEntity:FindAbilityByName( "keeper_of_the_light_illuminate" )

    thisEntity:SetContextThink( "KeeperThink", KeeperThink, 0.5 )
end

function KeeperThink()
    if (not thisEntity:IsAlive()) then
        return -1  
    end
   
    if GameRules:IsGamePaused() == true then
        return 1  
    end
	
	if thisEntity:IsChanneling() then  
        return 1 
    end

    local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		if #enemies > 0 then
			for _,unit in pairs(enemies) do
				if unit then	
					if thisEntity.illuminate ~= nil and thisEntity.illuminate:IsFullyCastable() then
						PointAbilityCast(unit)
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
		AbilityIndex = thisEntity.illuminate:entindex(),
		Queue = false,
	})
    return 0.5
end