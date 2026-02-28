function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	PointAbility = thisEntity:FindAbilityByName( "elder_titan_ancestral_spirit" )
	NoTargetAbility = thisEntity:FindAbilityByName( "elder_titan_echo_stomp" )
	PointAbility2 = thisEntity:FindAbilityByName( "mars_spear" )

	thisEntity:SetContextThink( "BanditArcherThink", BanditArcherThink, 0.5 )
end

--------------------------------------------------------------------------------

function BanditArcherThink()
	if not IsServer() then
		return
	end
	
	if not thisEntity.bSearchedForItems then
		SearchForItems()
		thisEntity.bSearchedForItems = true
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end
	
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies > 0 then
		if PointAbility ~= nil and PointAbility:IsFullyCastable() then
			for _,unit in pairs(enemies) do
				if unit then
					PointAbilityCast(unit)
				end
			end
			return 1
		end
		
		if PointAbility2 ~= nil and PointAbility2:IsFullyCastable() then
			for _,unit in pairs(enemies) do
				if unit then
					PointAbilityCast2(unit)
				end
			end
			return 0.5
		end
		
		if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable() then 
			for _,unit in pairs(enemies) do
				if unit then
					NoTargetAbilityCast(unit)
				end
			end
			return 1
		end

		for _,unit in pairs(enemies) do
			if unit:HasModifier("modifier_elder_titan_echo_stomp") then
				Approach(unit)
			end
		end

		if Blademail and  Blademail:IsFullyCastable() and thisEntity:GetHealthPercent() < 90 then
			return UseBlademail()
		end
	end
	return 1
end

function PointAbilityCast(unit)
	local vTargetPos = unit:GetOrigin()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = PointAbility:entindex(),
		Queue = false,
	})
    return 1.5
end

function PointAbilityCast2(unit)
	local vTargetPos = unit:GetOrigin()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = PointAbility2:entindex(),
		Queue = false,
	})
    return 1.5
end

function NoTargetAbilityCast(unit)
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = NoTargetAbility:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end

function Approach(unit)

	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = unit:entindex()
	})
	return 1
end

function SearchForItems()
	for i = 0, 5 do
		local item = thisEntity:GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == "item_blade_mail" then
				Blademail = item
			end
		end
	end
end

function UseBlademail()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = Blademail:entindex(),
		Queue = false,
	})
	return 2
end