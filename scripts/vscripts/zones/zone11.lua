function start_quest(data)
	quest_system:StartQuest('main', 23)
end

function off_traps()
	_G.last_zone_traps_active = false
end

function spawn_last_zone_creeps()
	local random_ability = passive[RandomInt(1,#passive)]
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 20 then
			count = count + 1
			local point = Entities:FindByName( nil, "zone_12_"..count):GetAbsOrigin()
				if count == 1 or count == 4 or count == 8 or count == 11 or count == 13 or count == 16 or count == 20 then 
					for i = 1, 5 do
						if i == 1 then 
							local unit = CreateUnitByName("npc_invoker_creep", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						elseif i == 2 then
							local unit = CreateUnitByName("npc_mars_creep", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						else 
							local unit = CreateUnitByName("legion_creep_"..RandomInt(1,3), point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)	
						end	
					end

				elseif count == 2 or count == 7 or count == 10 or count == 12 or count == 15 or count == 19 then 
					for i = 1, 5 do
						if i == 1 then 
							local unit = CreateUnitByName("npc_invoker_creep", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						elseif i == 2 then
							local unit = CreateUnitByName("npc_phoenix_creep", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						else 
							local unit = CreateUnitByName("legion_creep_"..RandomInt(1,3), point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)	
						end	
					end
				else
					for i = 1, 5 do
						if i == 1 then 
							local unit = CreateUnitByName("npc_phoenix_creep", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						elseif i == 2 then
							local unit = CreateUnitByName("npc_mars_creep", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						elseif i == 3 then
							local unit = CreateUnitByName("npc_invoker_creep", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
							rules:aura_dif(unit,random_ability)
						else
							local unit = CreateUnitByName("legion_creep_"..RandomInt(1,3), point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
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
	rules:clear_zone('zone_12_', 20)
end
