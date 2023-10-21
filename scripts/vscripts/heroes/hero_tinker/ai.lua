function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	SmashAbility = nil
	
	thisEntity:SetContextThink( "HellbearThink", HellbearThink, 1 )
end


function HellbearThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	SmashAbility = thisEntity:FindAbilityByName( "tinker_heat_seeking_missile_lua" )

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 0.5
	end
	
	local point = thisEntity:GetAbsOrigin()
	local point_2 = thisEntity:GetOwner():GetAbsOrigin()
					
	local flDist = (point - point_2):Length2D()
	if flDist >= 500 then return 0.5 end
		if SmashAbility ~= nil and SmashAbility:IsCooldownReady() then
			return Smash()
		end
	return 1
end

function Smash()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = SmashAbility:entindex(),
		Queue = false,
	})
	thisEntity:FindAbilityByName( "tinker_heat_seeking_missile_lua" ):EndCooldown()
	return 1
end

