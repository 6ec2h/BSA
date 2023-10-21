function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end
    if thisEntity == nil then
        return
    end


	NoTargetAbility = thisEntity:FindAbilityByName( "creep_nova_lua" )
	PointAbility = thisEntity:FindAbilityByName( "creep_gale_lua" )

    thisEntity:SetContextThink( "VenomThink", VenomThink, 0.5 )
end

function VenomThink()
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
					
					if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable()  then
						NoTargetAbilityCast( enemies[ RandomInt( 1, #enemies ) ] )
						return 0.5
					end		
					
					if PointAbility ~= nil and PointAbility:IsFullyCastable()  then
						PointAbilityCast( enemies[ RandomInt( 1, #enemies ) ] )
						return 0.5
					end	
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

function NoTargetAbilityCast()	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = NoTargetAbility:entindex(),
		Queue = false,
	})
	return 0.5
end


function PointAbilityCast( hEnemy )
	local fDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	local vTargetPos = hEnemy:GetOrigin()

	if ( fDist > 400 ) and hEnemy and hEnemy:IsMoving() then
		local vLeadingOffset = hEnemy:GetForwardVector() * RandomInt( 200, 380 )
		vTargetPos = hEnemy:GetOrigin() + vLeadingOffset
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = PointAbility:entindex(),
		Queue = false,
	})
	return 1
end