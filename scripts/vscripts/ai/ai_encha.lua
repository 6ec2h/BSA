function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end
    if thisEntity == nil then
        return
    end

	TargetAbility = thisEntity:FindAbilityByName( "enchantress_enchant_creep" )

    thisEntity:SetContextThink( "EnchaThink", EnchaThink, 0.5 )
end

function EnchaThink()
    if (not thisEntity:IsAlive()) then
        return -1  
    end
   
    if GameRules:IsGamePaused() == true then
        return 1  
    end

    local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		if #enemies > 0 then
			for _,unit in pairs(enemies) do
				if unit then	
					if TargetAbility ~= nil and TargetAbility:IsFullyCastable()  then
						local  enemy = enemies[RandomInt(1, #enemies)] 
						if not enemy:HasModifier("modifier_item_lotus_orb_active") then
							TargetAbilityCast(enemy)
						end
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