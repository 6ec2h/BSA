require('essentials')
require("data")

function start_quest(data)
	local activator = data.activator
	local messageID = "#6_5_zone"
	local zone_name = "#zone6_5"
	local description = "#zone6_5_des"
	data.activator:EmitSound("Item.TomeOfKnowledge")
	
	CustomGameEventManager:Send_ServerToAllClients("QuestMsgPanel_create_new_message", {messageName = zone_name, messageText = messageID})		
	CustomGameEventManager:Send_ServerToAllClients("quest_create_quest", {name = zone_name, desc = description, max = 201, id = 931})
	CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 201, current=0, id = 931})
end

function spawn_creeps()
	random_ability = passive[RandomInt(1,#passive)]
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 27 then
			count = count + 1
			if count % 2 == 1 then
				local point = Entities:FindByName( nil, "jungle"..count):GetAbsOrigin()  
				for i = 1, 3 do
					if i == 1 then 
						local unit = CreateUnitByName("npc_zone_jungle_1", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					elseif i == 2 then 
						local unit = CreateUnitByName("npc_zone_jungle_2", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					elseif i == 3 then 
						local unit = CreateUnitByName("npc_zone_jungle_4", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)	
					end
				end
			else	
				local point = Entities:FindByName( nil, "jungle"..count):GetAbsOrigin()  
				for i = 1, 3 do
					if i == 1 then 
						local unit = CreateUnitByName("npc_zone_jungle_1", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					elseif i == 2 then 
						local unit = CreateUnitByName("npc_shaker", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					elseif i == 3 then 
						local unit = CreateUnitByName("npc_zone_jungle_3", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
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
	
	clear()
end


function clear()
	Timers:CreateTimer(5, function()
		for i = 1, 27 do
			local point = Entities:FindByName( nil, "jungle"..i)
			if point then
				UTIL_Remove( point )
			end
		end	
	end)
end
