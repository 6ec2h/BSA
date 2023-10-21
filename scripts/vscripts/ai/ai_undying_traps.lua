function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end
    if thisEntity == nil then
        return
    end

    Pulse = thisEntity:FindAbilityByName( "necrolyte_death_pulse" )
    Scythe = thisEntity:FindAbilityByName( "necrolyte_reapers_scythe" )

    thisEntity:SetContextThink( "NecroLordThink", NecroLordThink, 0.5 )
end

function NecroLordThink()
    if ( not thisEntity:IsAlive() ) then
        return -1  
    end
   
    if GameRules:IsGamePaused() == true then
        return 1  
    end

    local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies > 0 then
		for _,unit in pairs(enemies) do
			if unit then
			
				if Pulse ~= nil and Pulse:IsFullyCastable() then
					PulseCast(unit)
				end
				
				if unit:HasModifier("modifier_elder_titan_echo_stomp") then
					Approach(unit)
				end
				
				if unit:GetHealthPercent() < 20 then
					CastScythe(unit)
				end
			end
		end
	end		
	return 0.2
end

----------------------------------------------------------------------------

function CastScythe(enemy)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        AbilityIndex = Scythe:entindex(),
        TargetIndex = enemy:entindex(),
        Queue = false,
    })
    return 0.2
end

function PulseCast(unit)
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET, 
            AbilityIndex = Pulse:entindex(),
            Queue = false,
        })
    return 0.2
end

function Approach(unit)
	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = unit:entindex()
	})
	return 0.2
end