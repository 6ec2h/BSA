vkl = 0

function shotON ()
vkl = vkl + 1;
end

function shotOFF ()
	
vkl = vkl -1;
end

function Spawn()
if vkl > 0 then
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	thisEntity:SetContextThink( "shot", shot, 0.5 )
	thisEntity:SetContextThink( "shot2", shot2, 0.5 )
	thisEntity:SetContextThink( "shot3", shot3, 0.5 )
	thisEntity:SetContextThink( "shot4", shot4, 0.5 )
	thisEntity:SetContextThink( "shot5", shot5, 0.5 )
end
if vkl == 0 then
return
end
return 0.3
end


function shot()
if vkl > 0 then
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1.5
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "726_venom_trap_npc" )
		local target = Entities:FindByName( nil, "726_venom_trap_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_room")
		local model = "726_venom_trap_model"
		DoEntFire( model, "SetAnimation", "fang_attack", .4, self, self )
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
	
	end
	
local R5 = RandomInt(5,25)
	return R5
	end
	return 0.1
end

function shot2()
if vkl > 0 then
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1.5
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "725_venom_trap_npc" )
		local target = Entities:FindByName( nil, "725_venom_trap_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_room")
	local model = "725_venom_trap_model"
	DoEntFire( model, "SetAnimation", "fang_attack", .4, self, self )
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		
	end
	
local R5 = RandomInt(5, 25)
	return R5
	end
		return 0.1
end
	
function shot3()
	if vkl > 0 then
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1.5
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "724_venom_trap_npc" )
		local target = Entities:FindByName( nil, "724_venom_trap_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_room")
	local model = "724_venom_trap_model"
	DoEntFire( model, "SetAnimation", "fang_attack", .4, self, self )
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		
	end
	
	local R5 = RandomInt(5, 25)
	return R5
	end
		return 0.1
end
	
function shot4()
	if vkl > 0 then
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1.5
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "723_venom_trap_npc" )
		local target = Entities:FindByName( nil, "723_venom_trap_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_room")
	local model = "723_venom_trap_model"
	DoEntFire( model, "SetAnimation", "fang_attack", .4, self, self )
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		
	end
	
	local R5 = RandomInt(5, 25)
	return R5
	end
		return 0.1
	end
	
	function shot5()
	if vkl > 0 then
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1.5
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
		local npc = Entities:FindByName( nil, "722_venom_trap_npc" )
		local target = Entities:FindByName( nil, "722_venom_trap_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison_room")
	local model = "722_venom_trap_model"
	DoEntFire( model, "SetAnimation", "fang_attack", .4, self, self )
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		
	end
	
	local R5 = RandomInt(5, 25)	
	return R5
	end
		return 0.1
end