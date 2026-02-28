function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end
    if thisEntity == nil then
        return
    end
    Snowball = thisEntity:FindAbilityByName( "tusk_snowball" )
    Shards = thisEntity:FindAbilityByName( "ice_shards_lua" )

    thisEntity:SetContextThink( "WhiteWalkerThink", WhiteWalkerThink, 0.5 )
end

function WhiteWalkerThink()
    if ( not thisEntity:IsAlive() ) then
        return -1  
    end
   
    if GameRules:IsGamePaused() == true then
        return 1  
    end

    local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		if #enemies > 0 then
			if Snowball ~= nil and Snowball:IsFullyCastable() then
				for _,unit in pairs(enemies) do
					if unit and not unit:HasModifier("modifier_item_lotus_orb_active")  and not unit:HasModifier("modifier_item_sphere_target") then
						SnowballCast(unit)
					end
				end
			return 1	
			end
			if Shards ~= nil and Shards:IsFullyCastable() and not Snowball:IsFullyCastable() then
				ShardsCast(unit)
			end
		end
	return 1
end

function SnowballCast(enemy)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        AbilityIndex = Snowball:entindex(),
        TargetIndex = enemy:entindex(),
        Queue = false,
    })
    return 1.5
end

function ShardsCast()	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = Shards:entindex(),
		Queue = false,
	})
	return 0.5
end