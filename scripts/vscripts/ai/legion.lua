function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.custom_last_stand = thisEntity:FindAbilityByName( "custom_last_stand" )
	thisEntity.custom_overwhelming_odds = thisEntity:FindAbilityByName( "custom_overwhelming_odds" )
	
	thisEntity:SetContextThink( "HellbearThink", HellbearThink, 1 )
end

--------------------------------------------------------------------------------

function HellbearThink()
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
	
	if thisEntity:IsInvulnerable() then
        return 1 
    end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1750, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #enemies > 0 then		
		if thisEntity.custom_last_stand ~= nil and thisEntity.custom_last_stand:IsFullyCastable() then
			return CastSpell()
		end
			
		if thisEntity.custom_overwhelming_odds ~= nil and thisEntity.custom_overwhelming_odds:IsFullyCastable() then
			for _,unit in pairs(enemies) do
				if unit then
				return CastODS(unit)
				end
				end
			end
		end
	return 3
end

--------------------------------------------------------------------------------

function SearchForItems()
	for i = 0, 5 do
		local item = thisEntity:GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == "item_blink" then
				thisEntity.hBlink = item
			end
		end
	end
end

function CastODS(unit)
local vTargetPos = unit:GetOrigin()
ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = thisEntity.custom_overwhelming_odds:entindex(),
		Queue = false,
	})
    return 1.5
end

function CastSpell( hEnemy )
	ProjectileManager:ProjectileDodge(thisEntity) 
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, thisEntity) 
    thisEntity:EmitSound("DOTA_Item.BlinkDagger.Activate")
	local ent = Entities:FindByName( nil, "legion_point")
	local point = ent:GetAbsOrigin() 
	thisEntity:SetAbsOrigin( point )
	FindClearSpaceForUnit(thisEntity, point, false)
	thisEntity:Stop() 
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = thisEntity.custom_last_stand:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end
