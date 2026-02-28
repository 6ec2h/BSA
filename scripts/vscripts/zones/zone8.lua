function start_quest(data)
	quest_system:StartQuest('main', 14)
end

function spawn_creeps()
	random_ability = passive[RandomInt(1,#passive)]
	
	local count = 0
	local forest_waves = {
		odd = {
			"npc_dota_zone_8_unit_5",
			"npc_dota_zone_8_unit_3",
			"npc_dota_zone_8_unit_4", 
			"npc_dota_zone_8_unit_4",
			"npc_dota_zone_8_unit_2",
			"npc_dota_zone_8_unit_6"
		},
		even = {
			"npc_dota_zone_8_unit_5",
			"npc_dota_zone_8_unit_4",
			"npc_dota_zone_8_unit_3",
			"npc_dota_zone_8_unit_2",
			"npc_dota_zone_8_unit_2",
			"npc_dota_zone_8_unit_6"
		}
	}

	Timers:CreateTimer(0, function()
		count = count + 1
		if count > 25 then return nil end
		
		local point = Entities:FindByName(nil, "for" .. count):GetAbsOrigin()

		local current_wave = (count % 2 == 1) and forest_waves.odd or forest_waves.even

		for _, unit_name in ipairs(current_wave) do
			local unit = CreateUnitByName(unit_name, point + RandomVector(200), true, nil, nil, DOTA_TEAM_NEUTRALS)
			rules:aura_dif(unit, random_ability)
		end

		return 0.1
	end)
					
	if _G.Game_Difficulty >= 12 then
		Timers:CreateTimer(3, function()
			Notifications:TopToAll({text="#usilenie", duration=3})
			Notifications:TopToAll({text="#DOTA_Tooltip_ability_"..random_ability, duration=3})
			rules:updateExtraAbility("creeps", random_ability)
		end)
	end
	
	rules:clear_zone('for', 1, 25)
endrue, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					elseif i == 3 then
						local unit = CreateUnitByName("npc_lifestealer", point + RandomVector( RandomInt( 250, 250 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					else
						local unit = CreateUnitByName("batr", point + RandomVector( RandomInt( 250, 250 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
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
	
	rules:clear_zone('doom', 30)
end

-- //////////////////////////

lord_traps_shot = true

function traps_off()
	print(_G.Open_xdes, "_G.Open_xdes")
	_G.Open_xdes = _G.Open_xdes + 1
	if _G.Open_xdes == 2 then
		local hRelay = Entities:FindByName( nil, "xdes_move_logic" )
		hRelay:Trigger(nil,nil)		
	end	
	
	lord_traps_shot = false	
	for _, ent in pairs(Entities:FindAllByName("lordfire_particle")) do
		UTIL_Remove( ent )
	end
	for _, ent in pairs(Entities:FindAllByName("lordfire")) do
		UTIL_Remove( ent )
	end
end

function Spawn()
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	thisEntity:SetContextThink( "shot", shot, 0.5 )
	thisEntity:SetContextThink( "shot2", shot2, 0.5 )
	thisEntity:SetContextThink( "shot3", shot3, 0.5 )
end


function shot()
	if not IsServer() then
		return
	end
	
	if ( not thisEntity:IsAlive() ) then
		return -1.5
	end
	
	if lord_traps_shot == false then
		thisEntity:ForceKill(false)
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	local npc = Entities:FindByName( nil, "2_trap_oneshot_npc" )	
	local target = Entities:FindByName( nil, "2_trap_oneshot_target" )
	
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_lord")
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
	end
	
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_up", 0.5, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_idle", 0.6, self, self )
	return 5
end
	
function shot2()
	if not IsServer() then
		return
	end
	
	if ( not thisEntity:IsAlive() ) then
		return -1.5
	end
	
	if lord_traps_shot == false then
		thisEntity:ForceKill(false)
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	local npc = Entities:FindByName( nil, "3_trap_oneshot_npc" )	
	local target = Entities:FindByName( nil, "3_trap_oneshot_target" )
	
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_lord")
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
	end
	
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_up", 0.5, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_idle", 0.6, self, self )
	return 4
end

function shot3()
	if not IsServer() then
		return
	end
	
	if ( not thisEntity:IsAlive() ) then
		return -1.5
	end
	
	if lord_traps_shot == false then
		thisEntity:ForceKill(false)
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	local npc = Entities:FindByName( nil, "4_trap_oneshot_npc" )	
	local target = Entities:FindByName( nil, "4_trap_oneshot_target" )
	
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_lord")
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
	end
	
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_up", 0.5, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_idle", 0.6, self, self )
	return 3
end
