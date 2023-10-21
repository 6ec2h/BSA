function start_quest(data)
	local activator = data.activator
	local messageID = "#11_zone"
	local zone_name = "#zone11"	
	local description = "#zone11_des"
	data.activator:EmitSound("Item.TomeOfKnowledge")
	CustomGameEventManager:Send_ServerToAllClients("QuestMsgPanel_create_new_message", {messageName = zone_name, messageText = messageID})			
	CustomGameEventManager:Send_ServerToAllClients("quest_create_quest", {name = zone_name, desc = description, max = 6, id =21})
	CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 6, current=0, id =21})
	spawn_last_zone_creeps()
end

zone_12_count = 0

function update()
zone_12_count = zone_12_count + 1
	if zone_12_count < 6 then
		CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 6, current = zone_12_count, id =21})
	else
		local hRelay = Entities:FindByName( nil, "last_zone_logic_2" )
		hRelay:Trigger(nil, nil)
		zone_12_count = 0
		CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id = 21})
		for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
				if PlayerResource:HasSelectedHero( nPlayerID ) then		 		
					local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
					hero:EmitSound("Item.LotusOrb.Activate")
					boss_reward:show({PlayerID = nPlayerID})
					local gold = 500 
					hero:ModifyGold( gold, true, 0 )
					SendOverheadEventMessage(hero, OVERHEAD_ALERT_GOLD, hero, gold, nil)
					if not hero:IsAlive() then
						local point = hero:GetAbsOrigin()
						local hRelay = Entities:FindByName( nil, "logic_teleport" )
						hRelay:Trigger(nil,nil)	
						hero:RespawnHero(false, false)
						hero:SetAbsOrigin( point )
						FindClearSpaceForUnit(hero, point, false) 
						hero:Stop() 
					end
				end
			end
		end
	end
end

function off_traps()
	_G.last_zone_traps_active = false
end

function spawn_last_zone_creeps()
	local random_ability = passive[RandomInt(1,#passive)]
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 23 then
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

				elseif count == 2 or count == 7 or count == 10 or count == 12 or count == 15 or count == 19 or count == 22 then 
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
			local point = Entities:FindByName( nil, "zone_12_"..i)
			if point then
				UTIL_Remove( point )
			end
		end	
	end)
end