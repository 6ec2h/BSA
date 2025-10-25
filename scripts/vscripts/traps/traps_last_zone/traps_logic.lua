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

local cache = {}

local function getVenomTrapNPCAndModel(num)
	num = tostring(num)

	local npcName = num .. "_venom_trap_oneshot_npc"
	local modelName = num .. "_venom_trap_oneshot_model"

	if not cache[npcName] then
		cache[npcName] = Entities:FindByName(nil, npcName)
	end
	if not cache[modelName] then
		cache[modelName] = Entities:FindByName(nil, modelName)
	end

	return cache[npcName], cache[modelName]
end

local function getVenomTrapNPCAndTarget(num)
	num = tostring(num)

	local npcName = num .. "_venom_trap_oneshot_npc"
	local targetName = num .. "_venom_trap_oneshot_target"

	if not cache[npcName] then
		cache[npcName] = Entities:FindByName(nil, npcName)
	end
	if not cache[targetName] then
		cache[targetName] = Entities:FindByName(nil, targetName)
	end

	return cache[npcName], cache[targetName]
end

function move_1()
	local unit, unit2 = getVenomTrapNPCAndModel(6)

    local origin = unit:GetAbsOrigin()
    
	if not direction then
		direction = 1
	end
	if origin.x > 14912 then
		direction = -1
	elseif origin.x < 13500 then
		direction = 1
	end

	local point = Vector(origin.x + (11 * direction), origin.y, 448)
	unit:SetAbsOrigin(point)
	unit2:SetAbsOrigin(point)

    return 0.03
end

function move_2()
	local unit, unit2 = getVenomTrapNPCAndModel(7)

	local origin = unit:GetAbsOrigin()
	
	if not direction then
		direction = -1
	end
	if origin.x > 14912 then
		direction = -1
	elseif origin.x < 13500 then
		direction = 1
	end

	local point = Vector(origin.x + (10 * direction), origin.y, 448)
	unit:SetAbsOrigin(point)
	unit2:SetAbsOrigin(point)

    return 0.03
end

function move_3()
	local unit, unit2 = getVenomTrapNPCAndModel(5)

	local origin = unit:GetAbsOrigin()
	
	if not direction then
		direction = 1
	end
	if origin.x > 14912 then
		direction = -1
	elseif origin.x < 13500 then
		direction = 1
	end

	local point = Vector(origin.x + (12 * direction), origin.y, 448)
	unit:SetAbsOrigin(point)
	unit2:SetAbsOrigin(point)

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

	local npc, target = getVenomTrapNPCAndTarget(5)

	if npc then
		local venomTrap = npc:FindAbilityByName("breathe_poison_oneshot")
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( "5_venom_trap_oneshot_model", "SetAnimation", "bark_attack", 0.4, self, self )
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

	local npc, target = getVenomTrapNPCAndTarget(6)

	if npc then
		local venomTrap = npc:FindAbilityByName("breathe_poison_oneshot")
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( "6_venom_trap_oneshot_model", "SetAnimation", "bark_attack", 0.4, self, self )
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
	local npc, target = getVenomTrapNPCAndTarget(7)

	if npc then
		local venomTrap = npc:FindAbilityByName("breathe_poison_oneshot")
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( "7_venom_trap_oneshot_model", "SetAnimation", "bark_attack", 0.4, self, self )
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

	local npc, target = getVenomTrapNPCAndTarget(1)

	if npc then
		local venomTrap = npc:FindAbilityByName("breathe_poison_oneshot")
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( "1_venom_trap_oneshot_model", "SetAnimation", "bark_attack", 0.4, self, self )
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

	local npc, target = getVenomTrapNPCAndTarget(2)

	if npc then
		local venomTrap = npc:FindAbilityByName("breathe_poison_oneshot")
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( "2_venom_trap_oneshot_model", "SetAnimation", "bark_attack", 0.4, self, self )
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

	local npc, target = getVenomTrapNPCAndTarget(3)

	if npc then
		local venomTrap = npc:FindAbilityByName("breathe_poison_oneshot")
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( "3_venom_trap_oneshot_model", "SetAnimation", "bark_attack", 0.4, self, self )
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

	local npc, target = getVenomTrapNPCAndTarget(4)

	if npc then
		local venomTrap = npc:FindAbilityByName("breathe_poison_oneshot")
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( "4_venom_trap_oneshot_model", "SetAnimation", "bark_attack", 0.4, self, self )
	end

	return 2
endocal venomTrap = npc:FindAbilityByName("breathe_poison_oneshot")
		local model = "4_venom_trap_oneshot_model"
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "bark_attack", 0.4, self, self )
	end	
	return 2
end