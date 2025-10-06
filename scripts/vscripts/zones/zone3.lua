function quest_start(data)
	quest_system:StartQuest('main', 5)
	
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

	if _G.Game_Difficulty >= 12 then
		Timers:CreateTimer(3, function()
			Notifications:TopToAll({text="#usilenie", duration=3})
			Notifications:TopToAll({text="#DOTA_Tooltip_ability_"..random_ability, duration=3})
		end)
	end
	
	rules:clear_zone('snows', 23)
end

function crate()
	for i = 19, 28 do 
		local point = Entities:FindByName( nil, "crate"..i):GetAbsOrigin()
		 for i =1,RandomInt(3,4) do
			local unit = CreateUnitByName("npc_dota_crate", point + RandomVector( RandomInt( 50, 50 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
		end
	end	
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
	local data = _G.players_quest_progress['main'][5]
	data.kill_count = (data.kill_count or 0) + 1
	quest_system:UpdateQuest('main', 5, data.kill_count)

	if data.kill_count >= _G.quest_data['main'][5].goal then
		data.completed = true
		quest_system:RemoveQuest('main', 5, 'success')
	end
end