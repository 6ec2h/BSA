function start_quest(data)
	quest_system:StartQuest('main', 12)
	
	local orb_quest = _G.players_quest_progress["additional"][110]
	if orb_quest and orb_quest.completed then
		quest_system:StartQuest('additional', 107)
	end
end

function spawn_creeps()
    local random_ability = passive[RandomInt(1, #passive)]
	local count = 0

	Timers:CreateTimer(0, function()
		if count < 27 then
			count = count + 1
			local point = Entities:FindByName(nil, "jungle" .. count):GetAbsOrigin()  
			
			if table.contains({15, 12, 5, 23, 11}, count) then
				local unit = CreateUnitByName("npc_mini_monkey", point + RandomVector(RandomInt(0, 200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
				rules:aura_dif(unit, random_ability)
			end
			
			 if count % 2 == 1 then
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
				for i = 1, 3 do
					if i == 1 then 
						local unit = CreateUnitByName("npc_zone_jungle_1", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					elseif i == 2 then 
						local unit = CreateUnitByName("npc_zone_jungle_4", point + RandomVector( RandomInt( 200, 200 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
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
	
	if _G.Game_Difficulty >= 12 then
		Timers:CreateTimer(3, function()
			Notifications:TopToAll({text="#usilenie", duration=3})
			Notifications:TopToAll({text="#DOTA_Tooltip_ability_" .. random_ability, duration=3})
		end)
	end

    rules:clear_zone('jungle', 27)
end
