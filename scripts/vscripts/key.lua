require('essentials')
----------------------------------------------------------------------------------------- TINY

function tinigatetrig( trigger )
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_prison_cell_key" )
		if Key ~= nil then
			hActivatorHero:RemoveItem(Key)
			local hRelay = Entities:FindByName( nil, "open" )
			hRelay:Trigger(nil, nil)
			CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id =16})
			rules:boss_invulnerable("npc_dota_creature_storegga")
			for i = 0, PlayerResource:GetPlayerCount() - 1 do
            local gold = 500
            local player = PlayerResource:GetSelectedHeroEntity(i)
                player:ModifyGold( gold, true, 0 )
                SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player, gold, nil)
				player:EmitSound("Item.LotusOrb.Activate")
			end	
		end
	end
end

----------------------------------------------------------------------------------------- TRAP
function OnTouch( trigger )
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_prison_cell_key" )
		if Key ~= nil then
			hActivatorHero:RemoveItem(Key)
			local hRelay = Entities:FindByName( nil, "opentraplog" )
			local hRelay = Entities:FindByName( nil, "traplogic1" )
			if hRelay == nil then
			return
		end
		hRelay:Trigger(nil, nil)
		hActivatorHero:EmitSound("DOTA_Item.Bloodstone.Cast")
		end
	end
end

qwet = 0;

function traps1()
	qwet = qwet + 1;
	if qwet >= 1 then
		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			local gold = 1000
			local player = PlayerResource:GetSelectedHeroEntity(i)
			player:ModifyGold( gold, true, 0 )
			SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player, gold, nil)
			player:EmitSound("Item.LotusOrb.Activate")
		end
		qwet = 0;
			CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id =311})
		else
			CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 201, current=qwet, id =311})
	end
end
----------------------------------------------------------------------------------------- SLARDAR
function slarkey ( trigger )
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_prison_cell_key" )
		if Key ~= nil then
			hActivatorHero:RemoveItem(Key)
			hActivatorHero:EmitSound("tutorial_gate_open_metal")
			local hRelay = Entities:FindByName( nil, "slar_log" )
			if hRelay == nil then
			return
		end
		hRelay:Trigger(nil, nil)
		end
	end
end
----------------------------------------------------------------------------------------- SLARDAR DOOR
function bridge ( trigger )
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_naga_stone" )
		if Key ~= nil and Key:GetCurrentCharges() >= 30 then
			Notifications:TopToAll({text="#nag", duration=5})	
			hActivatorHero:RemoveItem(Key)
			hActivatorHero:EmitSound("Item.DropGemWorld")
			local hRelay = Entities:FindByName( nil, "bridge_log" )
			if hRelay == nil then
			return
		end
			hRelay:Trigger(nil, nil)
		else
			Notifications:TopToAll({text="#nagneed", duration=5})	
		end
	end
end

function brid_spawn()
    local spawnPoint = Entities:FindByName( nil, "bridgespawn"):GetAbsOrigin()
    local newItem = CreateItem( "item_prison_cell_key", nil, nil )
    local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
   
end
---------------------------------------------------------------------------------------------------ROSHAN
function roshan1 ( trigger )
	local hActivatorHero = trigger.activator
	local Key = hActivatorHero:FindItemInInventory("item_ticket2") or hActivatorHero:FindItemInInventory("item_ticket")
		if Key ~= nil then
			Notifications:TopToAll({text="#ROSH", duration = 5})
			local count = Key:GetCurrentCharges()
				if count > 1 then
					Key:SetCurrentCharges(Key:GetCurrentCharges() - 1)
				else
					hActivatorHero:RemoveItem(Key)
				end
				hActivatorHero:EmitSound("tutorial_gate_open_metal")
				local hRelay = Entities:FindByName( nil, "roshan_log" )
				if hRelay == nil then
				return
			end
			hRelay:Trigger(nil, nil)
		else
			Notifications:TopToAll({text="#ROSH_need", duration = 5})	
		return
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
			hero:RemoveItem(Key)
		end
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerID()),"spawn_golden_event",{})
	else
		Notifications:TopToAll({text="#d_gate_need", duration = 5})	
	end
end

---------------------------------------------------------------------------------------------------DOOM ZONE
function lordon1 ( trigger )
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_candy1" )
		if Key ~= nil then
			hActivatorHero:RemoveItem(Key)
			local hRelay = Entities:FindByName( nil, "openlord1" )
			if hRelay == nil then

			return
		end
		hRelay:Trigger(nil, nil)
		end
	end
end

function lordon2 ( trigger )
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_candy2" )
		if Key ~= nil then
			hActivatorHero:RemoveItem(Key)
			local hRelay = Entities:FindByName( nil, "openlord2" )
			if hRelay == nil then

			return
		end
		hRelay:Trigger(nil, nil)
		end
	end
end

function lordon3 ( trigger )
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_candy3" )
		if Key ~= nil then
			hActivatorHero:RemoveItem(Key)
			local hRelay = Entities:FindByName( nil, "openlord3" )
			if hRelay == nil then
		
			return
		end
		hRelay:Trigger(nil, nil)
		end
	end
end

function lordon4 ( trigger )
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_candy4" )
		if Key ~= nil then
			hActivatorHero:RemoveItem(Key)
			local hRelay = Entities:FindByName( nil, "openlord4" )
			if hRelay == nil then
		
			return
		end
		hRelay:Trigger(nil, nil)
		end
	end
end

 qwe = 0;
 qwr = 0;
 qwt = 0;
 qwtq = 0;
  
function tomb1()
 qwe = qwe + 1;
    if qwe == 1 then

        for i = 0, PlayerResource:GetPlayerCount() - 1 do
            local gold = 500 -- кол-во голды
            local player = PlayerResource:GetSelectedHeroEntity(i)
                player:ModifyGold( gold, true, 0 )
                SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player, gold, nil)
				player:EmitSound("Item.LotusOrb.Activate")
        end
	qwe = 0;
    CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id =17})
    else
    CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 201, current=qwe, id =17})

end
end

function tomb2()
 qwr = qwr + 1;

    if qwr == 1 then
        for i = 0, PlayerResource:GetPlayerCount() - 1 do
            local gold = 500 -- кол-во голды
            local player = PlayerResource:GetSelectedHeroEntity(i)
                player:ModifyGold( gold, true, 0 )
                SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player, gold, nil)
				player:EmitSound("Item.LotusOrb.Activate")
        end
   qwr = 0;
    CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id =18})
    else
    CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 201, current=qwr, id =18})

end
end

function tomb3()
 qwt = qwt + 1;

    if qwt == 1 then
        for i = 0, PlayerResource:GetPlayerCount() - 1 do
            local gold = 500 -- кол-во голды
            local player = PlayerResource:GetSelectedHeroEntity(i)
                player:ModifyGold( gold, true, 0 )
                SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player, gold, nil)
				player:EmitSound("Item.LotusOrb.Activate")
        end
   qwt = 0;
    CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id =19})
    else
    CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 201, current=qwt, id =19})
    
end

end

function tomb4()
 qwtq = qwtq + 1;

    if qwtq == 1 then
        for i = 0, PlayerResource:GetPlayerCount() - 1 do
            local gold = 500 -- кол-во голды
            local player = PlayerResource:GetSelectedHeroEntity(i)
                player:ModifyGold( gold, true, 0 )
                SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player, gold, nil)
				player:EmitSound("Item.LotusOrb.Activate")
        end
   qwtq = 0;
    CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id =191})
    else
    CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 201, current=qwtq, id =191})
  
end
end
------------------------------------------------------------------------------------------------------------------------------

function lordopen ( trigger )
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_Lord_heart" )
		if Key ~= nil then
			hActivatorHero:RemoveItem(Key)
			local hRelay = Entities:FindByName( nil, "Lordopenrelay" )
			if hRelay == nil then
		
			return
		end
		hRelay:Trigger(nil, nil)
		end
	end
end

function medusaopen ( trigger )
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_Medusa_heart" )
		if Key ~= nil then
			hActivatorHero:RemoveItem(Key)
			local hRelay = Entities:FindByName( nil, "medusaopenrelay" )
			if hRelay == nil then
			return
		end
		hRelay:Trigger(nil, nil)
		end
	end
end

function lastroomsound ( trigger )
	local hActivatorHero = trigger.activator
	hActivatorHero:EmitSound("tutorial_gate_open_metal")
end
