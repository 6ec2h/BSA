require('essentials')
require("data")

function start_quest(data)
	local activator = data.activator
	local messageID = "#9_zone"
	local zone_name = "#zone9"	
	local description = "#zone9_des"
	data.activator:EmitSound("Item.TomeOfKnowledge")
	CustomGameEventManager:Send_ServerToAllClients("QuestMsgPanel_create_new_message", {messageName = zone_name, messageText = messageID})			
	CustomGameEventManager:Send_ServerToAllClients("quest_create_quest", {name = zone_name, desc = description, max = 5, id =21})
	CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 5, current=0, id =21})
end

function creep_spawn()
random_ability = passive[RandomInt(1,#passive)]	
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 30 then
			count = count + 1
			local point = Entities:FindByName( nil, "venom"..count):GetAbsOrigin()
				if count % 4 == 0 then
					for i = 1, 4 do
						if i == 1 then 
							local unit = CreateUnitByName("pudge", point + RandomVector( RandomInt( 250, 250 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						elseif i == 2 or i == 3 then
							local unit = CreateUnitByName("npc_dota_spider_sack", point + RandomVector( RandomInt( 250, 250 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						else
							local unit = CreateUnitByName("npc_venom_creep", point + RandomVector( RandomInt( 250, 250 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)	
						end	
					end	
				else
					for i = 1, 4 do
						if i == 1 then 
							local unit = CreateUnitByName("demon", point + RandomVector( RandomInt( 250, 250 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						elseif i == 2 or i == 3 then
							local unit = CreateUnitByName("npc_dota_spider_sack", point + RandomVector( RandomInt( 250, 250 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						else
							local unit = CreateUnitByName("npc_venom_creep", point + RandomVector( RandomInt( 250, 250 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
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
		for i = 1, 30 do
			local point = Entities:FindByName( nil, "venom"..i)
			if point then
				UTIL_Remove( point )
			end
		end	
	end)
end