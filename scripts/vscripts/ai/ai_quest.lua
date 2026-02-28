function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end

    if thisEntity == nil then
        return
    end
    thisEntity:SetContextThink( "NeutralThink", NeutralThink, 1 )
end

function NeutralThink()
    if ( not thisEntity:IsAlive() ) then
        return -1 
    end
  
    if GameRules:IsGamePaused() == true then
        return 1 
    end
	
    local enemies = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, thisEntity:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	if #enemies > 0 then
		local enemy = enemies[1]
        local away_vector = (thisEntity:GetOrigin() - enemy:GetOrigin()):Normalized()
        local angle_offset = -70 
        local final_direction = RotatePosition(Vector(0,0,0), QAngle(0, angle_offset, 0), away_vector)
        thisEntity:SetForwardVector(final_direction)
        end
	return 0.3
end
ntity:FaceTowards(point)
	end
	return 1
	
end

function AttackMove( unit, enemy )
    if enemy == nil then
        return
    end
    ExecuteOrderFromTable({
        UnitIndex = unit:entindex(),       
        OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,   
        Position = enemy:GetOrigin(),         
        Queue = false,
    })

    return 0.3
end