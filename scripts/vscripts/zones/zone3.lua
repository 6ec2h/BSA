require('essentials')
require("data")

function quest_start(data)
	local activator = data.activator		
	local messageID = "#3_zone"
	local zone_name = "#zone3"
	local description = "#zone3_des"
			
	data.activator:EmitSound("Item.TomeOfKnowledge")
	CustomGameEventManager:Send_ServerToAllClients("QuestMsgPanel_create_new_message", {messageName = zone_name, messageText = messageID})				
	CustomGameEventManager:Send_ServerToAllClients("quest_create_quest", {name = zone_name, desc = description, max = 201, id =13})
	CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 201, current=0, id =13})
	CustomGameEventManager:Send_ServerToAllClients("quest_create_quest", {name = zone_name, desc = description, max = 1, id =14})
	CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 201, current=0, id =14})
	CustomGameEventManager:Send_ServerToAllClients("quest_create_quest", {name = zone_name, desc = description, max = 1, id =15})
	CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 201, current=0, id =15})
	
	local unit2 = Entities:FindByName( nil, "npc_snow")
	unit2:AddNewModifier( unit2, nil, "modifier_invulnerable", {} )
	local unit3 = Entities:FindByName( nil, "npc_snow2")
	unit3:AddNewModifier( unit3, nil, "modifier_invulnerable", {} )
	local unit4 = Entities:FindByName( nil, "npc_snow3")
	unit4:AddNewModifier( unit4, nil, "modifier_invulnerable", {} )
end

function snowspawn(snow)
	random_ability = passive[RandomInt(1,#passive)]	
	
	local count = 0
	Timers:CreateTimer(0, function()
	if count < 23 then
		count = count + 1
		local point = Entities:FindByName( nil, "snows"..count):GetAbsOrigin()
			for i =1, 5 do
				if i == 3 or i == 4 then 
					local unit = CreateUnitByName("apparat", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
					rules:aura_dif(unit,random_ability)
				elseif i == 5 then
					local unit = CreateUnitByName("tusk", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
					rules:aura_dif(unit,random_ability)
				else
					local unit = CreateUnitByName("npc_creep_crystal", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
					rules:aura_dif(unit,random_ability)
				end	
			end
		return 0.1
	else
		return nil
		end
	end)

	if _G.Game_Difficulty > 5 then
		Timers:CreateTimer(3, function()
			Notifications:TopToAll({text="#usilenie", duration=3})
			Notifications:TopToAll({text="#DOTA_Tooltip_ability_"..random_ability, duration=3})
		end)
	end	
	clear()
end

function crate ()
	for i = 19, 28 do 
		local point = Entities:FindByName( nil, "crate"..i):GetAbsOrigin()
		 for i =1,RandomInt(3,4) do
			local unit = CreateUnitByName("npc_dota_crate", point + RandomVector( RandomInt( 50, 50 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
		end
	end	
end

function clear()
	Timers:CreateTimer(5, function()
		for i = 1, 23 do
			local point = Entities:FindByName( nil, "snows"..i)
			if point then
				UTIL_Remove( point )
			end
		end	
	end)
end

----------------------------------------------------------------------------------------------------------

function sheepoff(event)
	local unit = Entities:FindByName( nil, "npc_snow")
	unit:SetTeam(DOTA_TEAM_GOODGUYS)
	unit:RemoveModifierByName("modifier_invulnerable")
end

function sheepoff2(event)
	local unit = Entities:FindByName( nil, "npc_snow2")
	unit:SetTeam(DOTA_TEAM_GOODGUYS)
	unit:RemoveModifierByName("modifier_invulnerable")
end

function sheepoff3(event)
	local unit = Entities:FindByName( nil, "npc_snow3")
	unit:SetTeam(DOTA_TEAM_GOODGUYS)
	unit:RemoveModifierByName("modifier_invulnerable")
end

-------------------------------------------------------------------------------------------------------------------

function snowsheep(trigger)
	trigger.activator:AddNewModifier( trigger.activator, nil, "modifier_invulnerable", {} )
	for i = 0, PlayerResource:GetPlayerCount() - 1 do
		local gold = 200
		local player = PlayerResource:GetSelectedHeroEntity(i)
			player:ModifyGold( gold, true, 0 )
			SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player, gold, nil)
			player:EmitSound("Item.LotusOrb.Activate")
		end
	CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id =13})
end

function snowsheep2(trigger)
	trigger.activator:AddNewModifier( trigger.activator, nil, "modifier_invulnerable", {} )
	for i = 0, PlayerResource:GetPlayerCount() - 1 do
		local gold = 200
		local player = PlayerResource:GetSelectedHeroEntity(i)
			player:ModifyGold( gold, true, 0 )
			SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player, gold, nil)
			player:EmitSound("Item.LotusOrb.Activate")
		end
	CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id =14})
end

function snowsheep3(trigger)
	trigger.activator:AddNewModifier( trigger.activator, nil, "modifier_invulnerable", {} )
	for i = 0, PlayerResource:GetPlayerCount() - 1 do
		local gold = 200
		local player = PlayerResource:GetSelectedHeroEntity(i)
			player:ModifyGold( gold, true, 0 )
			SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player, gold, nil)
			player:EmitSound("Item.LotusOrb.Activate")
		end
	CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id =15})
end