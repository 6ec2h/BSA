require('essentials')
require("data")

function start_quest(data)
	local activator = data.activator
	local messageID = "#10_zone"
	local zone_name = "#zone10"	
	local description = "#zone10_des"
	data.activator:EmitSound("Item.TomeOfKnowledge")
	CustomGameEventManager:Send_ServerToAllClients("QuestMsgPanel_create_new_message", {messageName = zone_name, messageText = messageID})			
	CustomGameEventManager:Send_ServerToAllClients("quest_create_quest", {name = zone_name, desc = description, max = 104, id =7721})
	CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 104, current = 0, id =7721})
end

function creep_spawn()
	local random_ability = passive[RandomInt(1,#passive)]
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 26 then
			count = count + 1
			local point = Entities:FindByName( nil, "zone_11_"..count):GetAbsOrigin()
				if count == 1 or count == 4 or count == 7 or count == 10 or count == 13 or count == 16 or count == 19 or count == 22 then 
					for i = 1, 4 do
						if i == 1 then 
							local unit = CreateUnitByName("npc_enigma", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						elseif i == 2 or i == 3 then
							local unit = CreateUnitByName("npc_gyro", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						else 
							local unit = CreateUnitByName("npc_sniper", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)	
						end	
					end

				elseif count == 2 or count == 5 or count == 8 or count == 11 or count == 14 or count == 17 or count == 20 or count == 23 then 
					for i = 1, 4 do
						if i == 1 then 
							local unit = CreateUnitByName("npc_enigma", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						elseif i == 2 or i == 3 then
							local unit = CreateUnitByName("npc_disruptor", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						else 
							local unit = CreateUnitByName("npc_sniper", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)	
						end	
					end
				else
					for i = 1, 4 do
						if i == 1 then 
							local unit = CreateUnitByName("npc_gyro", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						elseif i == 2 or i == 3 then
							local unit = CreateUnitByName("npc_sniper", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						else 
							local unit = CreateUnitByName("npc_enigma", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
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
		for i = 1, 26 do
			local point = Entities:FindByName( nil, "zone_11_"..i)
			if point then
				UTIL_Remove( point )
			end
		end	
	end)
end