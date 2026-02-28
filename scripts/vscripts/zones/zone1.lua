function quest_start(data)
	quest_system:StartQuest('main', 1)
end

function creeps_spawn()		
	random_ability = passive[RandomInt(1,#passive)]	
	
	local count_first = 0
	local count_second = 0
	
	Timers:CreateTimer(0, function()
	if count_first < 15 then
		count_first = count_first + 1
		local point = Entities:FindByName( nil, "wolf"..count_first):GetAbsOrigin()
		for i =1, 5 do
			if i == 5 then
				local unit = CreateUnitByName("npc_dota_creature_dire_hound_boss", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
				rules:aura_dif(unit,random_ability)
			else
				local unit = CreateUnitByName("npc_dota_creature_dire_hound", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
				rules:aura_dif(unit,random_ability)
			end
		end
		return 0.1
	else
		return nil
		end
	end)
	
	Timers:CreateTimer(0, function()
	if count_second < 13 then
		count_second = count_second + 1
		local point = Entities:FindByName( nil, "ursa"..count_second):GetAbsOrigin()
		if count_second == 1 or count_second == 3 or count_second == 5 or count_second == 6 or count_second == 7 or count_second == 8 or count_second == 10 or count_second == 12 then  
			for i = 1, 4 do
				if i == 4 then
					local unit = CreateUnitByName("npc_dota_creature_hellbear", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
					rules:aura_dif(unit,random_ability)
				else
					local unit = CreateUnitByName("npc_dota_creature_small_hellbear", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
					rules:aura_dif(unit,random_ability)
				end
			end
		else
			for i = 1, 4 do
				if i == 4 then
					local unit = CreateUnitByName("satyr_hellcaller", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
					rules:aura_dif(unit,random_ability)
				else
					local unit = CreateUnitByName("satyr_soulstealer", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
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
	
	if _G.Game_Difficulty >= 16 then
		local point = Entities:FindByName( nil, "easy_target"):GetAbsOrigin()
		local hUnit = CreateUnitByName("ultra", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
	end
	
	rules:clear_zone('wolf', 15)
	rules:clear_zone('ursa', 13)
end