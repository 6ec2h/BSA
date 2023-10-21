function vpravo(data)
	local unit = data.activator
	print(unit:GetName())
	unit:SetPhysicalArmorBaseValue(3000)
end

function vlevo(data)
	local unit = data.activator
	print(unit:GetName())
	unit:SetPhysicalArmorBaseValue(1500)
end

-----------------------------------------------------

function traps_enabled(event)
	thisEntity:SetContextThink( "move_1", move_1, 0.5 ) 
	thisEntity:SetContextThink( "move_2", move_2, 1.0 ) 
	thisEntity:SetContextThink( "move_3", move_3, 1.2 ) 
	thisEntity:SetContextThink( "shotright_5", shotright_5, 0.5 )
	thisEntity:SetContextThink( "shotright_6", shotright_6, 0.5 )
	thisEntity:SetContextThink( "shotright_7", shotright_7, 1.0 )

	thisEntity:SetContextThink( "shotright_1", shotright_1, 1.0 )
	thisEntity:SetContextThink( "shotright_2", shotright_2, 1.0 )
	thisEntity:SetContextThink( "shotright_3", shotright_3, 1.0 )
	thisEntity:SetContextThink( "shotright_4", shotright_4, 1.0 )
	
	thisEntity:SetContextThink( "venom_shotright_1", venom_shotright_1, 1.0 )
	thisEntity:SetContextThink( "venom_shotright_2", venom_shotright_2, 1.0 )
	thisEntity:SetContextThink( "venom_shotright_3", venom_shotright_3, 1.0 )
	thisEntity:SetContextThink( "venom_shotright_4", venom_shotright_4, 1.0 )
	thisEntity:SetContextThink( "venom_shotright_5", venom_shotright_5, 1.0 )
	thisEntity:SetContextThink( "venom_shotright_6", venom_shotright_6, 1.0 )
	thisEntity:SetContextThink( "venom_shotright_7", venom_shotright_7, 1.0 )
	thisEntity:SetContextThink( "venom_shotright_8", venom_shotright_8, 1.0 )
	thisEntity:SetContextThink( "venom_shotright_9", venom_shotright_9, 1.0 )
	thisEntity:SetContextThink( "venom_shotright_10", venom_shotright_10, 1.0 )
	spawn_circle()
end

---------------------------------------------------------------------------------------

function spawn_circle()
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 10 then
			count = count + 1
			local point = Entities:FindByName( nil, "last_zone_circle_trap_"..count):GetAbsOrigin()
			local unit = CreateUnitByName("circle_trap_last_zone", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
			return 0.1
		else
			return nil
		end
	end)
	clear()	
end

function clear()
	Timers:CreateTimer(5, function()
		for i = 1, 10 do
			local point = Entities:FindByName( nil, "last_zone_circle_trap_"..i)
			if point then
				UTIL_Remove( point )
			end
		end	
	end)
end

---------------------------------------------------------------------------------------

_G.last_zone_traps_active = true
_G.last_zone_circle_traps_active = true

function move_1()
    	local unit = Entities:FindByName( nil, "6_venom_trap_oneshot_npc")
    	local unit2 = Entities:FindByName( nil, "6_venom_trap_oneshot_model")
		if unit:GetPhysicalArmorBaseValue() > 2500 then
			local origin = unit:GetAbsOrigin()
			local point = Vector(origin.x-11, origin.y, origin.z)
			unit:SetAbsOrigin( point)
			unit2:SetAbsOrigin( point)
		else
			local origin = unit:GetAbsOrigin()
			local point = Vector(origin.x+11, origin.y, origin.z)
			unit:SetAbsOrigin( point)
			unit2:SetAbsOrigin( point)
		end
	return 0.03
end

function move_2()
    	local unit = Entities:FindByName( nil, "7_venom_trap_oneshot_npc")
    	local unit2 = Entities:FindByName( nil, "7_venom_trap_oneshot_model")
		if unit:GetPhysicalArmorBaseValue() > 2500 then
			local origin = unit:GetAbsOrigin()
			local point = Vector(origin.x-10, origin.y, origin.z)
			unit:SetAbsOrigin( point)
			unit2:SetAbsOrigin( point)
		else
			local origin = unit:GetAbsOrigin()
			local point = Vector(origin.x+10, origin.y, origin.z)
			unit:SetAbsOrigin( point)
			unit2:SetAbsOrigin( point)
		end
	return 0.03
end

function move_3()
    	local unit = Entities:FindByName( nil, "5_venom_trap_oneshot_npc")
    	local unit2 = Entities:FindByName( nil, "5_venom_trap_oneshot_model")
		if unit:GetPhysicalArmorBaseValue() > 2500 then
			local origin = unit:GetAbsOrigin()
			local point = Vector(origin.x-12, origin.y, origin.z)
			unit:SetAbsOrigin( point)
			unit2:SetAbsOrigin( point)
		else
			local origin = unit:GetAbsOrigin()
			local point = Vector(origin.x+12, origin.y, origin.z)
			unit:SetAbsOrigin( point)
			unit2:SetAbsOrigin( point)
		end
	return 0.03
end

function shotright_5()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "5_venom_trap_oneshot_npc" )
		local target = Entities:FindByName( nil, "5_venom_trap_oneshot_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_oneshot")
		local model = "5_venom_trap_oneshot_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "bark_attack", 0.4, self, self )
	end	
	return 2.0
end

function shotright_6()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1.5
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "6_venom_trap_oneshot_npc" )
		local target = Entities:FindByName( nil, "6_venom_trap_oneshot_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_oneshot")
		local model = "6_venom_trap_oneshot_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "bark_attack", 0.4, self, self )
	end	
	return 2.5
end

function shotright_7()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1.5
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "7_venom_trap_oneshot_npc" )
		local target = Entities:FindByName( nil, "7_venom_trap_oneshot_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_oneshot")
		local model = "7_venom_trap_oneshot_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "bark_attack", 0.4, self, self )
	end	
	return 2.0
end

----------------------------------------------------------------

function shotright_1()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1.5
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "1_venom_trap_oneshot_npc" )
		local target = Entities:FindByName( nil, "1_venom_trap_oneshot_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_oneshot")
		local model = "1_venom_trap_oneshot_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "bark_attack", 0.4, self, self )
	end	
	return 2
end

function shotright_2()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1.5
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "2_venom_trap_oneshot_npc" )
		local target = Entities:FindByName( nil, "2_venom_trap_oneshot_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_oneshot")
		local model = "2_venom_trap_oneshot_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "bark_attack", 0.4, self, self )
	end	
	return 3
end

function shotright_3()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1.5
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "3_venom_trap_oneshot_npc" )
		local target = Entities:FindByName( nil, "3_venom_trap_oneshot_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_oneshot")
		local model = "3_venom_trap_oneshot_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "bark_attack", 0.4, self, self )
	end	
	return 1
end

function shotright_4()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1.5
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "4_venom_trap_oneshot_npc" )
		local target = Entities:FindByName( nil, "4_venom_trap_oneshot_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_oneshot")
		local model = "4_venom_trap_oneshot_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "bark_attack", 0.4, self, self )
	end	
	return 2
end

---------------------------------------------------------------------------------

function venom_shotright_1()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "1_final_venom_trap_npc" )
		local target = Entities:FindByName( nil, "1_final_venom_trap_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_final")
		local model = "1_final_venom_trap_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "fang_attack", 0.4, self, self )
	end	
	return 3
end

function venom_shotright_2()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "2_final_venom_trap_npc" )
		local target = Entities:FindByName( nil, "2_final_venom_trap_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_final")
		local model = "2_final_venom_trap_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "fang_attack", 0.4, self, self )
	end	
	return 1
end

function venom_shotright_3()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "3_final_venom_trap_npc" )
		local target = Entities:FindByName( nil, "3_final_venom_trap_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_final")
		local model = "3_final_venom_trap_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "fang_attack", 0.4, self, self )
	end	
	return 1
end

function venom_shotright_4()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "4_final_venom_trap_npc" )
		local target = Entities:FindByName( nil, "4_final_venom_trap_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_final")
		local model = "4_final_venom_trap_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "fang_attack", 0.4, self, self )
	end	
	return 2
end

function venom_shotright_5()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "5_final_venom_trap_npc" )
		local target = Entities:FindByName( nil, "5_final_venom_trap_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_final")
		local model = "5_final_venom_trap_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "fang_attack", 0.4, self, self )
	end	
	return 3
end

function venom_shotright_6()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "6_final_venom_trap_npc" )
		local target = Entities:FindByName( nil, "6_final_venom_trap_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_final")
		local model = "6_final_venom_trap_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "fang_attack", 0.4, self, self )
	end	
	return 2
end

function venom_shotright_7()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "7_final_venom_trap_npc" )
		local target = Entities:FindByName( nil, "7_final_venom_trap_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_final")
		local model = "7_final_venom_trap_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "fang_attack", 0.4, self, self )
	end	
	return 2
end

function venom_shotright_8()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "8_final_venom_trap_npc" )
		local target = Entities:FindByName( nil, "8_final_venom_trap_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_final")
		local model = "8_final_venom_trap_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "fang_attack", 0.4, self, self )
	end	
	return 1
end

function venom_shotright_9()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "9_final_venom_trap_npc" )
		local target = Entities:FindByName( nil, "9_final_venom_trap_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_final")
		local model = "9_final_venom_trap_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "fang_attack", 0.4, self, self )
	end	
	return 3
end

function venom_shotright_10()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if not _G.last_zone_traps_active then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "10_final_venom_trap_npc" )
		local target = Entities:FindByName( nil, "10_final_venom_trap_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_final")
		local model = "10_final_venom_trap_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "fang_attack", 0.4, self, self )
	end	
	return 2
end