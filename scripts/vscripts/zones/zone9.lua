function start_quest(data)
	quest_system:StartQuest('main', 18)
end

function creep_spawn()
	local random_ability = passive[RandomInt(1,#passive)]	
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
	
	if _G.Game_Difficulty >= 12 then
		Timers:CreateTimer(3, function()
			Notifications:TopToAll({text="#usilenie", duration=3})
			Notifications:TopToAll({text="#DOTA_Tooltip_ability_"..random_ability, duration=3})
		end)
	end
	
	rules:clear_zone('venom', 30)
end