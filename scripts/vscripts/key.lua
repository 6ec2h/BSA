require('essentials')

function OnTouch( trigger )
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_prison_cell_key" )
		if Key ~= nil then
			UTIL_Remove(Key)
			local hRelay = Entities:FindByName( nil, "traplogic1" )
			if hRelay == nil then
			return
		end
		hRelay:Trigger(nil, nil)
		hActivatorHero:EmitSound("DOTA_Item.Bloodstone.Cast")
		end
	end
end

---------------------------------------------------------------------------------------------------ROSHAN

function roshan1(trigger)
	local unit = trigger.activator
	local Key = unit:FindItemInInventory("item_ticket2") or unit:FindItemInInventory("item_ticket")
	if Key ~= nil then
		local count = Key:GetCurrentCharges()
		
		if count > 1 then
			Key:SetCurrentCharges(Key:GetCurrentCharges() - 1)
		else
			UTIL_Remove(Key)
		end
	
		local point = Vector(-9609,2248,555)
		unit:SetAbsOrigin( point )
		FindClearSpaceForUnit(unit, point, false)
		unit:Stop() 
		ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, unit)
		unit:EmitSound("DOTA_Item.BlinkDagger.Activate") 
		
		PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), unit)
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), nil)
			return nil
		end)
	else
		Notifications:Top(unit, {text="#ROSH_need", duration = 5})	
	end
end
---------------------------------------------------------------------------------------------------D OPEN

function open_d_gate(trigger)
	Notifications:TopToAll({text="#d_gate", duration = 5})
end	
	
function d_spawn_gold(trigger)
	local hero = trigger.activator	
	local Key = hero:FindItemInInventory("item_golden_skull")
	local egg = hero:FindItemInInventory( "item_egg" )
	if Key ~= nil and egg ~= nil then
		local count = Key:GetCurrentCharges()
		if count > 1 then
			Key:SetCurrentCharges(Key:GetCurrentCharges() - 1)
		else
			UTIL_Remove(Key)
		end
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerID()),"spawn_golden_event",{})
	else
		Notifications:TopToAll({text="#d_gate_need", duration = 5})	
	end
end
