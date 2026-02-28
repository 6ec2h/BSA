pet_ability = {"pet_dagon", "pet_block_aura", "pet_magic_block_aura", "pet_orchid", "pet_health_bag", "pet_medallion_of_courage"}

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	thisEntity:SetContextThink( "PetThink", PetThink, 0.5 )
end

function PetThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end
	
	thisEntity.owner = thisEntity:GetOwner()
	
	local creatures = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #creatures > 0 then
		for _, creature in pairs( creatures ) do
			if creature ~= nil and creature:IsAlive() then
				local flDist = ( creature:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
				if flDist < 600 then
					check_can_use(thisEntity, creature)
				end
				if creature == thisEntity.owner then
					if flDist >= 400 and flDist < 1000 then
						return Approach(creature)
					end
					if flDist > 1200 then
						return blink(creature)
					end
				end
			end
		end
	end
	return 1
end

function check_can_use(thisEntity, target)
	for _, T in ipairs(pet_ability) do
		local Spell = thisEntity:FindAbilityByName(T)
		if Spell then
			local Behavior = Spell:GetBehaviorInt()
			if bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET ) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
				Spell.Behavior = "target"
				if bit.band( Spell:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_TEAM_ENEMY ) == DOTA_UNIT_TARGET_TEAM_ENEMY then
					Spell.Behavior = "target"
					Cast( Spell, target )
				elseif bit.band( Spell:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_TEAM_FRIENDLY ) == DOTA_UNIT_TARGET_TEAM_FRIENDLY then	
					if Spell:GetName() == "pet_health_bag" and target:GetHealthPercent() < 50 then
						Cast( Spell, target )
					end
				end	
			elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET ) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
				if thisEntity:GetTeamNumber() == target:GetTeamNumber() and target:GetHealthPercent() < 80 then
					Spell.Behavior = "no_target"
					if Spell:GetSpecialValueFor("radius") == 0 then
						Cast( Spell, target )
					elseif ( target:GetOrigin()- thisEntity:GetOrigin() ):Length2D() < Spell:GetSpecialValueFor("radius") then
						Cast( Spell, target )
					end
				end
			elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_POINT ) == DOTA_ABILITY_BEHAVIOR_POINT then
				Spell.Behavior = "point"
				Cast( Spell, target )
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


function blink(unit)
	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		thisEntity:SetAbsOrigin( unit:GetOrigin() + RandomVector( RandomFloat(50, 50 )))
		})
	FindClearSpaceForUnit(thisEntity, unit:GetOrigin()+ RandomVector( RandomFloat(50, 50 )), true)
	return 1
end

function Approach(unit)
	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})
	return 1
endd