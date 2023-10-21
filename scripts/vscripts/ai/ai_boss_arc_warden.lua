function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end
    if thisEntity == nil then
        return
    end

    PointAbility = thisEntity:FindAbilityByName( "boss_arc_hide" )
	NoTargetAbility1 = thisEntity:FindAbilityByName( "boss_arc_magnetic_field" )
	NoTargetAbility2 = thisEntity:FindAbilityByName( "boss_arc_flux" )
	NoTargetAbility3 = thisEntity:FindAbilityByName( "boss_arc_spark_wraith" )

    thisEntity:SetContextThink( "ArcThink", ArcThink, 0.5 )
end

function ArcThink()
    if (not thisEntity:IsAlive()) then
        return -1  
    end
   
    if GameRules:IsGamePaused() == true then
        return 1  
    end

    local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		if #enemies > 0 then
			for _,unit in pairs(enemies) do
				if unit then	
					if PointAbility ~= nil and PointAbility:IsFullyCastable() and not thisEntity:HasModifier("modifier_boss_arc_magnetic_field_evasion") then
						PointAbilityCast(unit)
						return 0.5
					end	
					
					if NoTargetAbility2 ~= nil and NoTargetAbility2:IsFullyCastable() then
						NoTargetAbilityCast2()
						return 1.5
					end	
						
					if NoTargetAbility3 ~= nil and NoTargetAbility3:IsFullyCastable() then
							NoTargetAbilityCast3()
						return 2.5
					end	
			
					if NoTargetAbility1 ~= nil and NoTargetAbility1:IsFullyCastable() then
						NoTargetAbilityCast1()
						return 2.5
					end	
				end
			end
		end		
	return 0.5 
end

---------------------------------------------------------

function PointAbilityCast(unit)
	local vLeadingOffset = thisEntity:GetForwardVector() * 100
	vTargetPos = unit:GetOrigin() + vLeadingOffset

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = PointAbility:entindex(),
		Queue = false,
	})
    return 0.5
end

function NoTargetAbilityCast1()	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = NoTargetAbility1:entindex(),
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

function NoTargetAbilityCast3()	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = NoTargetAbility3:entindex(),
		Queue = false,
	})
	return 0.5
end