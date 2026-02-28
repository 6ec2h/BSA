shaker_abil = {"earthshaker_enchant_totem", "earthshaker_aftershock", "earthshaker_echo_slam"}


function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end

    if thisEntity == nil then
        return
    end
	
    thisEntity:SetContextThink( "NeutralThink2", NeutralThink2, 1 )
    thisEntity:SetContextThink( "NeutralThink3", NeutralThink3, 1 )
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
	
	if thisEntity:IsChanneling() then  
        return 1 
    end
	
	local search_radius = thisEntity:GetAcquisitionRange()
	local hp = thisEntity:GetHealthPercent()

	local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #enemies > 0 then
	
			for i = 1, 6, 1 do
			local Item = thisEntity.ItemAbillaty[i]
			if thisEntity.ItemAbillaty[i] and thisEntity.ItemAbillaty[i]:IsFullyCastable() then
				local Behavior = Item:GetBehaviorInt()
				if bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET ) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
					Item.Behavior = "target"
					if bit.band( Item:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_TEAM_ENEMY ) == DOTA_UNIT_TARGET_TEAM_ENEMY then
							UseItem(thisEntity.ItemAbillaty[i], enemies[ math.random( 1, #enemies ) ])
						elseif bit.band( Item:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_TEAM_FRIENDLY ) == DOTA_UNIT_TARGET_TEAM_FRIENDLY then
							
						end
				elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET ) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
					Item.Behavior = "no_target"
					if Item:GetAbilityName() == "item_guardian_greaves" or Item:GetAbilityName() == "item_mekansm" then
						if hp < 65 then
							UseItem(thisEntity.ItemAbillaty[i], enemies[ math.random( 1, #enemies ) ])
						end
					elseif Item:GetAbilityName() == "item_blade_mail" then
						if hp < 90 then
							UseItem(thisEntity.ItemAbillaty[i], enemies[ math.random( 1, #enemies ) ])
						end
					elseif Item:GetAbilityName() == "item_shivas_guard_lua2" then
						if hp < 70 then
							UseItem(thisEntity.ItemAbillaty[i], enemies[ math.random( 1, #enemies ) ])
						end
					else
						UseItem(thisEntity.ItemAbillaty[i], enemies[ math.random( 1, #enemies ) ])
					end
				elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_POINT ) == DOTA_ABILITY_BEHAVIOR_POINT then
					Item.Behavior = "point"
					UseItem(thisEntity.ItemAbillaty[i], enemies[ math.random( 1, #enemies ) ])
				end
			end
		end
		end
		return 0.1
		end
		
function NeutralThink3()
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

	local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #enemies > 0 then
			
	enemy = enemies[ RandomInt( 1, #enemies ) ]
		for _, T in ipairs(shaker_abil) do
						Timers:CreateTimer(0.1, function()		
			local Spell = thisEntity:FindAbilityByName(T)
			if Spell then
				enemy = enemies[ RandomInt( 1, #enemies ) ]
					local Behavior = Spell:GetBehavior()
				if bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET ) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
					Spell.Behavior = "target"
					Cast( Spell, enemy )
				
				elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET ) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
					Spell.Behavior = "no_target"
					if Spell:GetAbilityName() == "abaddon_borrowed_time" or Spell:GetAbilityName() == "omniknight_guardian_angel" then 
						if hp < 50 then
							Cast( Spell, enemy )
						end
					else
						Cast( Spell, enemy )
					end
					
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
return 0.1
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



