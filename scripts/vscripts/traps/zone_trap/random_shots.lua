function start_shot()
	thisEntity:SetContextThink( "shot_room_1", shot_room_1, 0.4 )
	thisEntity:SetContextThink( "shot_room_2", shot_room_2, 0.3 )
	thisEntity:SetContextThink( "shot_room_3", shot_room_3, 0.6 )
end

_G.Zone_trap_1_room = true
--------------------------------------------------------------------------------------------------------------

trap_set_1 = {1,4,8,11,14,17}
trap_set_2 = {2,7,9,12,15,18}
trap_set_3 = {3,5,6,10,13,16}

trap_room_set_count_1 = 3
trap_room_set_count_2 = 2
trap_room_set_count_3 = 4

function DisableTrap()
	_G.Zone_trap_1_room = false
end

function shot_room_1()
	if not IsServer() then
		return
	end
	
	if Zone_trap_1_room == false then
	
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if trap_room_set_count_1 > 0 then			
		trap_room_set_count_1 = trap_room_set_count_1 - 1
		for k, v in pairs(trap_set_1) do
			local npc = Entities:FindByName( nil, v.."_trap_npc" )
			local target = Entities:FindByName( nil, v.."_trap_target" )
			if npc ~= nil then
				local venomTrap = npc:FindAbilityByName("auto_shot_zone_3000")
				local model = v.."_trap_model"
				DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
				npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
			end
		end	
			return 0.8
		else
			trap_room_set_count_1 = 3
		return 1.6
	end	
end

function shot_room_2()
	if not IsServer() then
		return
	end
	
	if Zone_trap_1_room == false then
	
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if trap_room_set_count_1 > 0 then			
		trap_room_set_count_1 = trap_room_set_count_1 - 1
		for k, v in pairs(trap_set_2) do
			local npc = Entities:FindByName( nil, v.."_trap_npc" )
			local target = Entities:FindByName( nil, v.."_trap_target" )
			if npc ~= nil then
				local venomTrap = npc:FindAbilityByName("auto_shot_zone_3000")
				local model = v.."_trap_model"
				DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
				npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
			end
		end	
			return 1
		else
			trap_room_set_count_1 = 2
		return 2
	end	
end

function shot_room_3()
	if not IsServer() then
		return
	end
	
	if Zone_trap_1_room == false then
	
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if trap_room_set_count_1 > 0 then			
		trap_room_set_count_1 = trap_room_set_count_1 - 1
		for k, v in pairs(trap_set_3) do
			local npc = Entities:FindByName( nil, v.."_trap_npc" )
			local target = Entities:FindByName( nil, v.."_trap_target" )
			if npc ~= nil then
				local venomTrap = npc:FindAbilityByName("auto_shot_zone_3000")
				local model = v.."_trap_model"
				DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
				npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
			end
		end	
			return 1.2
		else
			trap_room_set_count_1 = 4
		return 2.4
	end	
end