require('essentials')
require("data")

function start_quest(data)
	local activator = data.activator
	local messageID = "#7_zone"
	local zone_name = "#zone7"	
	local description = "#zone7_des"
	data.activator:EmitSound("Item.TomeOfKnowledge")
	CustomGameEventManager:Send_ServerToAllClients("QuestMsgPanel_create_new_message", {messageName = zone_name, messageText = messageID})			
	CustomGameEventManager:Send_ServerToAllClients("quest_create_quest", {name = zone_name, desc = description, max = 900, id =999})
	CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 900, current=0, id =999})
end

function spawn_creeps()
	random_ability = passive[RandomInt(1,#passive)]
	
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 25 then
			count = count + 1
			local point = Entities:FindByName( nil, "for"..count):GetAbsOrigin()  
			if count % 2 == 1 then
				for i = 1, 6 do
					if i == 1 then 
						local unit = CreateUnitByName("npc_keeper_of_the_light", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					elseif i == 2 then 
						local unit = CreateUnitByName("miner", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					elseif i == 3 or i == 4 then 
						local unit = CreateUnitByName("small_hellbear", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					elseif i == 5 then 
						local unit = CreateUnitByName("encha", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)				
					else
						local unit = CreateUnitByName("treant", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					end		
				end	
			else
				for i = 1, 7 do
					if i == 1 then 
						local unit = CreateUnitByName("npc_keeper_of_the_light", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					elseif i == 2 then 
						local unit = CreateUnitByName("small_hellbear", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					elseif i == 3 or i == 4 then 
						local unit = CreateUnitByName("miner", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					elseif i == 5 then 
						local unit = CreateUnitByName("encha", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)				
					else
						local unit = CreateUnitByName("treant", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					end		
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
	mineraueststart()
	clear()
end

function mineraueststart()
	local timeElapsed = 0;
	Timers:CreateTimer(0, function()
		timeElapsed = timeElapsed + 1;
		if timeElapsed >= 900 then
			local miner = Entities:FindByName( nil, "npc_forest")
			if miner ~= nil then
				GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
				miner:EmitSound("Hero_Techies.Suicide")
			end
		else
			if _G.golf < 3 then
				CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 900, current = timeElapsed, id =999})
				return 1
			else
				return nil
			end	
		end
	end)
end

function clear()
	Timers:CreateTimer(5, function()
		for i = 1, 25 do
			local point = Entities:FindByName( nil, "for"..i)
			if point then
				UTIL_Remove( point )
			end
		end	
	end)
end
