function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end
    if thisEntity == nil then
        return
    end

    TargetAbility = thisEntity:FindAbilityByName( "golden_splinter_blast" )
    TargetAbility2 = thisEntity:FindAbilityByName( "winters_curse" )

    thisEntity:SetContextThink( "WyvernThink", WyvernThink, 0.5 )
end

function WyvernThink()
    if (not thisEntity:IsAlive()) then
        return -1  
    end
   
    if GameRules:IsGamePaused() == true then
        return 1  
    end
	
	if thisEntity:IsChanneling() then
        return 0.5  
    end

    local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false )
		if #enemies > 0 then
			for _,unit in pairs(enemies) do
				if unit then	
					if TargetAbility ~= nil and TargetAbility:IsFullyCastable()  then
						TargetAbilityCast( enemies[ RandomInt( 1, #enemies ) ] )
						return 0.5
					end
					
					if TargetAbility2 ~= nil and TargetAbility2:IsFullyCastable() and not unit:HasModifier("modifier_silence") then
						TargetAbilityCast2( enemies[ RandomInt( 1, #enemies ) ] )
						return 0.5
					end
				end
			end
		end		
	return 0.5 
end

---------------------------------------------------------
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

function TargetAbilityCast2(enemy)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        AbilityIndex = TargetAbility2:entindex(),
        TargetIndex = enemy:entindex(),
        Queue = false,
    })
   
    return 0.5
end