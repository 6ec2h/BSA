dis_abil = {"disruptor_thunder_strike","disruptor_glimpse","disruptor_static_storm"}

function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end

    if thisEntity == nil then
        return
    end
	
    thisEntity:SetContextThink( "NeutralThink2", NeutralThink2, 1 )
end


function NeutralThink2()
    if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if not thisEntity.bSearchedForItems then
		SearchForItems()
		thisEntity.bSearchedForItems = true
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	local search_radius = thisEntity:GetAcquisitionRange()
	local hp = thisEntity:GetHealthPercent()

	local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #enemies > 0 then
	enemy = enemies[ RandomInt( 1, #enemies ) ]
		for _, T in ipairs(dis_abil) do
			Timers:CreateTimer(0.1, function()		
			local Spell = thisEntity:FindAbilityByName(T)
			if Spell then
				enemy = enemies[ RandomInt( 1, #enemies ) ]
					local Behavior = Spell:GetBehaviorInt()
				if bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET ) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
					Spell.Behavior = "target"
					if Spell:GetAbilityName() == "disruptor_glimpse" and not (enemy:HasModifier("modifier_enigma_black_hole_pull") or enemy:HasModifier("modifier_disruptor_static_storm")) then
						Cast( Spell, enemy )
					end
				elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET ) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
					Spell.Behavior = "no_target"
						Cast( Spell, enemy )
				
					
				elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_POINT ) == DOTA_ABILITY_BEHAVIOR_POINT then
					Spell.Behavior = "point"
						Cast( Spell, enemy )
				elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_TOGGLE ) == DOTA_ABILITY_BEHAVIOR_POINT then
					Spell.Behavior = "toggle"
				
					if not Spell:GetToggleState() then 
					Spell:ToggleAbility()
					end
				elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_PASSIVE ) == DOTA_ABILITY_BEHAVIOR_PASSIVE then
					Spell.Behavior = "passive"			
				end
			end
		end)
	end	
	end
return 1
end

function SearchForItems()
		thisEntity.ItemAbillaty = {nil, nil, nil, nil, nil, nil}
		for i = 0, 5 do
			local item = thisEntity:GetItemInSlot( i )
			if item then
			for _, T in ipairs(AutoCastItem) do
				if item:GetAbilityName() == T then
					if not thisEntity.ItemAbillaty[1] then
						thisEntity.ItemAbillaty[1] = item
					elseif not thisEntity.ItemAbillaty[2] then
						thisEntity.ItemAbillaty[2] = item
					elseif not thisEntity.ItemAbillaty[3] then
						thisEntity.ItemAbillaty[3] = item
					elseif not thisEntity.ItemAbillaty[4] then
						thisEntity.ItemAbillaty[4] = item
					elseif not thisEntity.ItemAbillaty[5] then
						thisEntity.ItemAbillaty[5] = item
					elseif not thisEntity.ItemAbillaty[6] then
						thisEntity.ItemAbillaty[6] = item
					end
				end
			end
		end
	end
end


function UseItem(item , enemy)

	local order_type
	local vTargetPos = enemy:GetOrigin()
	
	if item.Behavior == "target" then
        order_type = DOTA_UNIT_ORDER_CAST_TARGET    -- на цель
    elseif item.Behavior == "no_target" then
        order_type = DOTA_UNIT_ORDER_CAST_NO_TARGET    -- без цели
    elseif item.Behavior == "point" then
        order_type = DOTA_UNIT_ORDER_CAST_POSITION    -- на точку
    elseif item.Behavior == "passive" then
        return
    end
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = order_type,
		Position = vTargetPos,
		TargetIndex = enemy:entindex(),  
		AbilityIndex = item:entindex(),
		Queue = false,
	})
	return 0.1
end

function Cast( Spell , enemy )
	
	local order_type
	local vTargetPos = enemy:GetOrigin()
	
    if Spell.Behavior == "target" then
        order_type = DOTA_UNIT_ORDER_CAST_TARGET    -- на цель
    elseif Spell.Behavior == "no_target" then
        order_type = DOTA_UNIT_ORDER_CAST_NO_TARGET    -- без цели
    elseif Spell.Behavior == "point" then
        order_type = DOTA_UNIT_ORDER_CAST_POSITION    -- на точку
    elseif Spell.Behavior == "passive" then
        return
    end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = order_type,
		Position = vTargetPos,
		TargetIndex = enemy:entindex(),  
		AbilityIndex = Spell:entindex(),
		Queue = false,
	})
	return 1
end



