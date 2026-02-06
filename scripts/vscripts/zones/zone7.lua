function start_quest(data)
	quest_system:StartQuest('main', 14)
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
				
	if _G.Game_Difficulty >= 12 then
		Timers:CreateTimer(3, function()
			Notifications:TopToAll({text="#usilenie", duration=3})
			Notifications:TopToAll({text="#DOTA_Tooltip_ability_"..random_ability, duration=3})
			rules:updateExtraAbility("creeps", random_ability)
		end)
	end
	
	rules:clear_zone('for', 25)
end