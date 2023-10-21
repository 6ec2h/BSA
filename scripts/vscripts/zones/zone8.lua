require('essentials')
require("data")

function start_quest(data)
	local activator = data.activator
	local messageID = "#8_zone"
	local zone_name = "#zone8"	
	local description = "#zone8_des"
	data.activator:EmitSound("Item.TomeOfKnowledge")
	CustomGameEventManager:Send_ServerToAllClients("QuestMsgPanel_create_new_message", {messageName = zone_name, messageText = messageID})			
	CustomGameEventManager:Send_ServerToAllClients("quest_create_quest", {name = zone_name, desc = description, max = 201, id =17})
	CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 201, current=0, id =17})
	CustomGameEventManager:Send_ServerToAllClients("quest_create_quest", {name = zone_name, desc = description, max = 201, id =18})
	CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 201, current=0, id =18})
	CustomGameEventManager:Send_ServerToAllClients("quest_create_quest", {name = name, desc = description, max = 201, id =19})
	CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = zone_name, current=0, id =19})
	CustomGameEventManager:Send_ServerToAllClients("quest_create_quest", {name = zone_name, desc = description, max = 201, id =191})
	CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 201, current=0, id =191})
end

function xdes_open()

end

function creep_spawn()
	for i = 1, 4 do
		local point = Entities:FindByName( nil, "tomb_spawn_"..i):GetAbsOrigin()
		local unit = CreateUnitByName("lordTomb_"..i, point, true, nil, nil, DOTA_TEAM_NEUTRALS)
	end
	
	random_ability = passive[RandomInt(1,#passive)]	
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 30 then
			count = count + 1
			if count % 2 == 1 then
				local point = Entities:FindByName( nil, "doom"..count):GetAbsOrigin()
				for i = 1, 5 do
					if i == 1 then 
						local unit = CreateUnitByName("warlock", point + RandomVector( RandomInt( 250, 250 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					elseif i == 2 or i == 3 then
						local unit = CreateUnitByName("npc_lifestealer", point + RandomVector( RandomInt( 250, 250 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					else
						local unit = CreateUnitByName("batr", point + RandomVector( RandomInt( 250, 250 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)	
					end	
				end
			else
				local point = Entities:FindByName( nil, "doom"..count):GetAbsOrigin()
				for i = 1, 5 do
					if i == 1 or i == 2 then 
						local unit = CreateUnitByName("warlock", point + RandomVector( RandomInt( 250, 250 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
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
			local point = Entities:FindByName( nil, "doom"..i)
			if point then
				UTIL_Remove( point )
			end
		end	
	end)
end



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
