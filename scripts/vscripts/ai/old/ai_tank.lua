omni_skills = {"omniknight_purification","omniknight_hammer_of_purity"}

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	thisEntity:SetContextThink( "CreepThink", CreepThink, 0.5 )
end

--------------------------------------------------------------------------------

function CreepThink()
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
	local allies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, search_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #allies > 0 then
		if hp < 80 then
			if thisEntity.Pipe and thisEntity.Pipe:IsFullyCastable() then
				UsePipe()
				return 1
			end	
		end	
		if hp < 30 then
			if thisEntity.GG and thisEntity.GG:IsFullyCastable() then
				UseGG()
				return 1
			end	
		end	
		ally = allies[1]
		if ally:GetHealthPercent() < 50 then
			for _, T in ipairs(omni_skills) do
				local Spell = thisEntity:FindAbilityByName(T)
				if Spell then
					local Behavior = Spell:GetBehaviorInt()
					if bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET ) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
						Spell.Behavior = "target"
						Cast( Spell, ally )
					elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET ) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
						Spell.Behavior = "no_target"
						Cast( Spell, ally )
					elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_POINT ) == DOTA_ABILITY_BEHAVIOR_POINT then
						Spell.Behavior = "point"
						Cast( Spell, ally )
					elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_TOGGLE ) == DOTA_ABILITY_BEHAVIOR_POINT then
						Spell.Behavior = "toggle"
						if not Spell:GetToggleState() then 
							Spell:ToggleAbility()
						end
					elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_PASSIVE ) == DOTA_ABILITY_BEHAVIOR_PASSIVE then
						Spell.Behavior = "passive"
					end
				end
			end	
		end
	end	
	return 0.5
end

--------------------------------------------------------------------------------

function SearchForItems()
	for i = 0, 5 do
		local item = thisEntity:GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == "item_pipe_lua2" then
				thisEntity.Pipe = item
			end
			if item:GetAbilityName() == "item_guardian_greaves_lua1" then
				thisEntity.GG = item
			end
		end
	end
end

function UsePipe( unit )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.Pipe:entindex(),
		Queue = false,
	})
	return 0.5
end

function UseGG( unit )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.GG:entindex(),
		Queue = false,
	})
	return 0.5
end

function Cast( Spell , ally )
	local order_type
	local vTargetPos = ally:GetOrigin()
    if Spell.Behavior == "target" then
        order_type = DOTA_UNIT_ORDER_CAST_TARGET
    elseif Spell.Behavior == "no_target" then
        order_type = DOTA_UNIT_ORDER_CAST_NO_TARGET
    elseif Spell.Behavior == "point" then
        order_type = DOTA_UNIT_ORDER_CAST_POSITION
    elseif Spell.Behavior == "passive" then
        return
    end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = order_type,
		Position = vTargetPos,
		TargetIndex = ally:entindex(),  
		AbilityIndex = Spell:entindex(),
		Queue = false,
	})
end