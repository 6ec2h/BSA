function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	OgreFlop = thisEntity:FindAbilityByName( "ogreseal_flop_by" )

	thisEntity:SetContextThink( "OgreSealThink", OgreSealThink, 0.5 )
end


function OgreSealThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if not thisEntity.bSearchedForItems then
		SearchForItems()
		thisEntity.bSearchedForItems = true
	end
	
	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() then
			local flDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 300 then
				if thisEntity.shivas and thisEntity.shivas:IsFullyCastable() then
					UseShivas()
				end
			end
			
			if OgreFlop ~= nil and OgreFlop:IsFullyCastable() then
				return CastBellyFlop(hEnemy)
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
			if item:GetAbilityName() == "item_shivas_guard_lua1" then
				thisEntity.shivas = item
			end
		end
	end
end

function UseShivas()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.shivas:entindex(),
		Queue = false,
	})
	return 2
end

function CastBellyFlop( enemy )
	local vToTarget = enemy:GetOrigin() - thisEntity:GetOrigin()
	vToTarget = vToTarget:Normalized()
	local vTargetPos = thisEntity:GetOrigin() + vToTarget * 50

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = OgreFlop:entindex(),
		Position = vTargetPos,
		Queue = false,
	})
	return 1
end
