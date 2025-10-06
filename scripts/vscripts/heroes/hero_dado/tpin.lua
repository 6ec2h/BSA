function Spawn( entityKeyValues )
	if not IsServer() then
        return
    end
    if thisEntity == nil then
        return
    end
    thisEntity:SetContextThink( "NecroLordThink", NecroLordThink, 0.5 )
end

function NecroLordThink()
	if ( not thisEntity:IsAlive() ) then
		return -1  
	end

	if GameRules:IsGamePaused() == true then
		return 1  
	end

	local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 100, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #enemies > 0 then
		for _,unit in pairs(enemies) do
			if unit:IsHero() then
				blink(unit)
			end
		end
	end
	return 0.5
end

function blink(unit)
	local friendlies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	for _,friendly in pairs ( friendlies ) do
		if friendly ~= nil then	
			if friendly:GetUnitName() == "tp_out" then
				local fDist = friendly:GetOrigin()
				if unit:IsHero() then
					local hRelay = Entities:FindByName( nil, "tp_off" )
					if hRelay == nil then return end
					hRelay:Trigger(nil,nil)
					unit:AddNewModifier( unit, nil, "modifier_invulnerable", { duration = 0.1 } )	
					unit:SetAbsOrigin( fDist + RandomVector( RandomFloat(50, 50 ))  )
					unit:EmitSound("DOTA_Item.BlinkDagger.Activate") --Emit sound for the blink
					FindClearSpaceForUnit(unit, fDist, false)
					unit:Stop()
					return 1
				end
			end
		end
	end
end