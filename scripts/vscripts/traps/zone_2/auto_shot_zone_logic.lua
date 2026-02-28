LinkLuaModifier( "modifier_no_heal", "modifiers/modifier_no_heal", LUA_MODIFIER_MOTION_NONE )

function start_shot()
	thisEntity:SetContextThink( "shot_1", shot_1, 0.5 )
	thisEntity:SetContextThink( "shot_2", shot_2, 1.5 )
	thisEntity:SetContextThink( "shot_3", shot_3, 2.5 )
	thisEntity:SetContextThink( "shot_4", shot_4, 2.5 )
	thisEntity:SetContextThink( "shot_5", shot_5, 0.5 )
	thisEntity:SetContextThink( "shot_6", shot_6, 0.5 )
	thisEntity:SetContextThink( "shot_7", shot_7, 0.5 )
	thisEntity:SetContextThink( "shot_8", shot_8, 0.5 )
	thisEntity:SetContextThink( "shot_9", shot_9, 0.5 )
	thisEntity:SetContextThink( "shot_10", shot_10, 1.0 )
	
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if not hero:IsAlive() then
					local point = hero:GetAbsOrigin()
					local hRelay = Entities:FindByName( nil, "logic_teleport" )
					hRelay:Trigger(nil,nil)	
					hero:RespawnHero(false, false)
					hero:SetAbsOrigin( point )
					FindClearSpaceForUnit(hero, point, false) 
					hero:Stop() 
				end
				if not hero:HasModifier("modifier_no_heal") then
					hero:SetHealth( hero:GetMaxHealth() )
					hero:SetMana( hero:GetMaxMana() )
					hero:AddNewModifier( hero, nil, "modifier_no_heal", {} )
				end
			end
		end
	end
	
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 3 then
			count = count + 1
			local point = Entities:FindByName( nil, "trap_2_circle_"..count):GetAbsOrigin()
			local unit = CreateUnitByName("circle_trap_zone_2", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
			return 0.1
		else
			return nil
		end
	end)
	clear()	
end

function clear()
	Timers:CreateTimer(5, function()
		for i = 1, 3 do
			local point = Entities:FindByName( nil, "trap_2_circle_"..i)
			if point then
				UTIL_Remove( point )
			end
		end	
	end)
end

trap_1_shots = 3
trap_2_shots = 2
trap_3_shots = 3
trap_4_shots = 3
trap_5_shots = 1
trap_6_shots = 1
trap_7_shots = 4
trap_8_shots = 1
trap_9_shots = 4
trap_10_shots = 3



_G.Fast_shot = true
_G.All_traps_zone_2 = true



function DisableAllTrap()
	_G.All_traps_zone_2 = false
	
	if not _G.players_quest_progress['additional'][103].completed then
		_G.players_quest_progress['additional'][103].completed = true
		quest_system:RemoveQuest('additional', 103, 'success')
	end
	
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				hero:RemoveModifierByName("modifier_no_heal")
			end
		end
	end
end

function DisableFastTrap()
	_G.Fast_shot = false
	local triggerName = thisEntity:GetName()
	local button = triggerName .. "_button"
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
end



function shot_1()
	if not IsServer() then
		return
	end
	
	if All_traps_zone_2 == false then
		
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if trap_1_shots > 0 then
		trap_1_shots = trap_1_shots - 1
		local npc = Entities:FindByName( nil, "zone_2_trap_1" )
		local target = Entities:FindByName( nil, "zone_2_target_1" )
		if npc ~= nil then
			local venomTrap = npc:FindAbilityByName("auto_shot_zone_2")
			local model = "zone_2_trap_model_1"
			DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
			npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		end
		return 0.4
	else
	trap_1_shots = 3
		return 1
	end	
end



function shot_2()
	if not IsServer() then
		return
	end
	
	if All_traps_zone_2 == false then
	
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if trap_2_shots > 0 then
		trap_2_shots = trap_2_shots - 1
		local npc = Entities:FindByName( nil, "zone_2_trap_2" )
		local target = Entities:FindByName( nil, "zone_2_target_2" )
		if npc ~= nil then
			local venomTrap = npc:FindAbilityByName("auto_shot_zone_2")
			local model = "zone_2_trap_model_2"
			DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
			npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		end
		return 0.4
	else
	trap_2_shots = 2
		return 2
	end	
end



function shot_3()
	if not IsServer() then
		return
	end
	
	if All_traps_zone_2 == false then
	
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if trap_3_shots > 0 then
		trap_3_shots = trap_3_shots - 1
		local npc = Entities:FindByName( nil, "zone_2_trap_3" )
		local target = Entities:FindByName( nil, "zone_2_target_3" )
		if npc ~= nil then
			local venomTrap = npc:FindAbilityByName("auto_shot_zone_2")
			local model = "zone_2_trap_model_3"
			DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
			npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		end
		return 0.6
	else
	trap_3_shots = 3
		return 2
	end	
end



function shot_4()
	if not IsServer() then
		return
	end
	
	if All_traps_zone_2 == false then
	
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if trap_4_shots > 0 then
		trap_4_shots = trap_4_shots - 1
		local npc = Entities:FindByName( nil, "zone_2_trap_4" )
		local target = Entities:FindByName( nil, "zone_2_target_4" )
		if npc ~= nil then
			local venomTrap = npc:FindAbilityByName("auto_shot_zone_2")
			local model = "zone_2_trap_model_4"
			DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
			npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		end
		return 0.4
	else
	trap_4_shots = 3
		return 1.5
	end	
end



function shot_5()
	if not IsServer() then
		return
	end
	
	if All_traps_zone_2 == false then
	
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if trap_5_shots > 0 then
		trap_5_shots = trap_5_shots - 1
		local npc = Entities:FindByName( nil, "zone_2_trap_5" )
		local target = Entities:FindByName( nil, "zone_2_target_5" )
		if npc ~= nil then
			local venomTrap = npc:FindAbilityByName("auto_shot_zone_2_kill_arrow")
			local model = "zone_2_trap_model_5"
			DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
			npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		end
		return 1.5
	else
	trap_5_shots = 1
		return 1.5
	end	
end



function shot_6()
	if not IsServer() then
		return
	end
	
	if All_traps_zone_2 == false then
	
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if trap_6_shots > 0 then
		trap_6_shots = trap_6_shots - 1
		local npc = Entities:FindByName( nil, "zone_2_trap_6" )
		local target = Entities:FindByName( nil, "zone_2_target_6" )
		if npc ~= nil then
			local venomTrap = npc:FindAbilityByName("auto_shot_zone_2_kill_arrow")
			local model = "zone_2_trap_model_6"
			DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
			npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		end
		return 2
	else
	trap_6_shots = 1
		return 2
	end	
end



function shot_7()
	if not IsServer() then
		return
	end
	
	if All_traps_zone_2 == false then
	
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if trap_7_shots > 0 then
		trap_7_shots = trap_7_shots - 1
		local npc = Entities:FindByName( nil, "zone_2_trap_7" )
		local target = Entities:FindByName( nil, "zone_2_target_7" )
		if npc ~= nil then
			local venomTrap = npc:FindAbilityByName("auto_shot_zone_2")
			local model = "zone_2_trap_model_7"
			DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
			npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		end
		return 0.4
	else
	trap_7_shots = 4
		return 1
	end	
end



function shot_8()
	if not IsServer() then
		return
	end
	
	if Fast_shot == false then
		return -1
	end
	
	if All_traps_zone_2 == false then
	
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if trap_8_shots > 0 then
		trap_8_shots = trap_8_shots - 1
		local npc = Entities:FindByName( nil, "zone_2_trap_8" )
		local target = Entities:FindByName( nil, "zone_2_target_8" )
		if npc ~= nil then
			local venomTrap = npc:FindAbilityByName("auto_shot_zone_2_kill_arrow")
			local model = "zone_2_trap_model_8"
			DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
			npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		end
		return 0.2
	else
	trap_8_shots = 1
		return 0.2
	end	
end


function shot_9()
	if not IsServer() then
		return
	end
	
	if All_traps_zone_2 == false then
	
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if trap_9_shots > 0 then
		trap_9_shots = trap_9_shots - 1
		local npc = Entities:FindByName( nil, "zone_2_trap_9" )
		local target = Entities:FindByName( nil, "zone_2_target_9" )
		if npc ~= nil then
			local venomTrap = npc:FindAbilityByName("auto_shot_zone_2")
			local model = "zone_2_trap_model_9"
			DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
			npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		end
		return 0.3
	else
	trap_9_shots = 4
		return 1.4
	end	
end


function shot_10()
	if not IsServer() then
		return
	end
	
	if All_traps_zone_2 == false then
	
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if trap_10_shots > 0 then
		trap_10_shots = trap_10_shots - 1
		local npc = Entities:FindByName( nil, "zone_2_trap_10" )
		local target = Entities:FindByName( nil, "zone_2_target_10" )
		if npc ~= nil then
			local venomTrap = npc:FindAbilityByName("auto_shot_zone_2")
			local model = "zone_2_trap_model_10"
			DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
			npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		end
		return 0.4
	else
	trap_10_shots = 3
		return 1.0
	end	
end


_G.buttons = {
    trigger_box_1 = {state = false, entity = nil},
    trigger_box_2 = {state = false, entity = nil},
    trigger_box_3 = {state = false, entity = nil},
    trigger_box_4 = {state = false, entity = nil},
}

function CheckAllButtonsPressed()
    for _, button in pairs(buttons) do
        if not button.state then
            return false
        end
    end
    return true
end

function OnButton(trigger)
    local triggerName = thisEntity:GetName()
    local entity = trigger.activator
    
    if not entity:IsIllusion() and buttons[triggerName].state == false then
        local button = triggerName .. "_button"
        DoEntFire(button, "SetAnimation", "ancient_trigger001_down", 0, self, self)
        DoEntFire(button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self)
		local npc = Entities:FindByName( nil, button)
		npc:SetSkin(1)
		
        buttons[triggerName].state = true
        buttons[triggerName].entity = entity

        if CheckAllButtonsPressed() then
            local hRelay = Entities:FindByName(nil, "trap_2_logic")
            hRelay:Trigger(nil, nil)
        end
    end
end

function OffButton(trigger)
    local triggerName = thisEntity:GetName()
    local entity = trigger.activator
    
    if not entity:IsIllusion() and buttons[triggerName].state == true and buttons[triggerName].entity == entity then
        local button = triggerName .. "_button"
        DoEntFire(button, "SetAnimation", "ancient_trigger001_up", 0.5, self, self)
        DoEntFire(button, "SetAnimation", "ancient_trigger001_idle", 0.6, self, self)
		local npc = Entities:FindByName( nil, button)
		npc:SetSkin(2)
		
        buttons[triggerName].state = false
        buttons[triggerName].entity = nil
    end
end

local triggerActive = true

function OnStartTouch(trigger)
	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	local level = trigger.activator:GetLevel()
	if not triggerActive then
		return
	end
	
	triggerActive = false
	local button = triggerName .. "_button"

	local model = "zone_2_trap_model_11"
	local npc = Entities:FindByName( nil, "zone_2_trap_11")
	local target = Entities:FindByName( nil, "zone_2_target_11" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("auto_shot_zone_2")
		npc:SetContextThink( "ResetButtonModel", function() ResetButtonModel() end, 0.5 )
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
	end

	DoEntFire( button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_up", 0.5, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_idle", 0.6, self, self )

	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
	npc.KillerToCredit = heroHandle
end

function OnEndTouch(trigger)
	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
end

function ResetButtonModel()
	triggerActive = true
end