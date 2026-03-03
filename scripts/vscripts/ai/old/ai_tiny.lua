boss_tiny_skills = {"custom_earth_splitter","gavnina", "custom_shifting_quake2", "custom_stone_spire"}

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
	local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies > 0 then
		local item_change = RandomInt(1,3)
		if item_change == 1 then
			if thisEntity.Dagon and thisEntity.Dagon:IsFullyCastable() then
				UseDagon(enemies[RandomInt(1, #enemies)])	
			end
		elseif item_change == 2 then
			if thisEntity.Shivas and thisEntity.Shivas:IsFullyCastable() then
				UseShivas()
			end
		else
			if thisEntity.Mjolnir and thisEntity.Mjolnir:IsFullyCastable() then
				UseMjolnir(thisEntity)
			end
			return 1
		end	
		enemy = enemies[ RandomInt( 1, #enemies ) ]
		local random_skill = boss_tiny_skills[RandomInt(1, #boss_tiny_skills)]
		local Spell = thisEntity:FindAbilityByName(random_skill)
			if Spell then
				local Behavior = Spell:GetBehaviorInt()
				if bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET ) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
					Spell.Behavior = "target"
					Cast( Spell, enemy )
				elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET ) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
					Spell.Behavior = "no_target"
					if Spell:GetSpecialValueFor("radius") == 0 then
						Cast( Spell, enemy )
					elseif ( enemy:GetOrigin()- thisEntity:GetOrigin() ):Length2D() < Spell:GetSpecialValueFor("radius") then
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
		end
	return 0.3
end

--------------------------------------------------------------------------------

function SearchForItems()
	for i = 0, 5 do
		local item = thisEntity:GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == "item_shivas_guard_lua1" then
				thisEntity.Shivas = item
			end
			if item:GetAbilityName() == "item_mjollnir_lua1" then
				thisEntity.Mjolnir = item
			end
			if item:GetAbilityName() == "item_dagon_lua_5" then
				thisEntity.Dagon = item
			end
		end
	end
end

function UseDagon(enemy)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        AbilityIndex = thisEntity.Dagon:entindex(),
        TargetIndex = enemy:entindex(),
        Queue = false,
    })
    return 0.3
end

function UseMjolnir(enemy)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        AbilityIndex = thisEntity.Mjolnir:entindex(),
        TargetIndex = enemy:entindex(),
        Queue = false,
    })
    return 0.3
end

function UseShivas()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.Shivas:entindex(),
		Queue = false,
	})
	return 0.3
end

function Cast( Spell , enemy )
	local order_type
	local vTargetPos = enemy:GetOrigin()
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
		TargetIndex = enemy:entindex(),  
		AbilityIndex = Spell:entindex(),
		Queue = false,
	})
end