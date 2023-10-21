require('essentials')

----------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------HUDDEN-------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
button_count = 0

function add_button_count()
	if button_count < 3 then 
		button_count = button_count + 1
		if button_count == 3 then
			local hRelay = Entities:FindByName( nil, "hidden_room_logic" )
			hRelay:Trigger(nil,nil)	
		end	
	end	
end


----------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------- QUEST 1 ---------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------

minicount = 0

quest_1_items = {"item_mekansm","item_vladmir_lua1","item_up_stone","item_pers","item_demon_edge","item_ultimate_orb"}

function start_mini_quest_1(trigger)
	local hActivatorHero = trigger.activator
	if minicount == 0 then 
		minicount = RandomInt(1, 6)
	end	
	Notifications:TopToAll({text="#mini"..minicount, duration=5})	
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( quest_1_items[minicount])
		if Key ~= nil then
			local hRelay = Entities:FindByName( nil, "mini_1_log" )
			hRelay:Trigger(nil,nil)
		end
	end
end

function spawn_box(trigger)
	local point = Entities:FindByName( nil, "quest_1_box_point"):GetAbsOrigin() 
	local hUnit = CreateUnitByName("small_box", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	hUnit:EmitSound("Item.DropGemWorld")
end

function spawn_2_quest(trigger)
	local point = Entities:FindByName( nil, "snowpntmodel"):GetAbsOrigin() 
	local hUnit = CreateUnitByName("npc_man", point, true, nil, nil, DOTA_TEAM_BADGUYS)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------- QUEST 2 ----------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------

function minisnowactiv ( trigger )
	Notifications:TopToAll({text="#mini_snow", duration=5})	
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_cheese_lua" )
		if Key ~= nil then
			hActivatorHero:RemoveItem(Key)
			local hRelay = Entities:FindByName( nil, "mini_snow_log" )
			hRelay:Trigger(nil,nil)
		end
	end
end

function minisnowspawn(trigger)
	local point = Entities:FindByName( nil, "minisnowpnt"):GetAbsOrigin() 
	local hUnit = CreateUnitByName("big_box", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	hUnit:EmitSound("Item.DropGemWorld")
end

function minispawnmodelsnow(trigger)
	local point = Entities:FindByName( nil, "trappntmodel"):GetAbsOrigin() 
	local hUnit = CreateUnitByName("npc_man", point, true, nil, nil, DOTA_TEAM_BADGUYS)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------

function miniactiv2 ( trigger )
	Notifications:TopToAll({text="#mini_2", duration=5})	
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_orb" )
		if Key ~= nil then
			hActivatorHero:RemoveItem(Key)
			local hRelay = Entities:FindByName( nil, "mini_2_log" )
			hRelay:Trigger(nil,nil)
		end
	end
end

function minispawn2(trigger)
	local point = Entities:FindByName( nil, "mini123_2"):GetAbsOrigin() 
	local hUnit = CreateUnitByName("middle_box", point + RandomVector( RandomInt( 0, 20 )), true, nil, nil, DOTA_TEAM_BADGUYS)
	hUnit:EmitSound("Item.DropGemWorld")
	randomspawnshovel()
	local unit = Entities:FindByName( nil, "lighter3")
	unit:SetDayTimeVisionRange( 1500 )
	unit:SetNightTimeVisionRange( 1500 )
	local particleLeader = ParticleManager:CreateParticle( "particles/dire_fx/fire_barracks.vpcf", PATTACH_OVERHEAD_FOLLOW, unit ) 
	ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, unit, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", unit:GetAbsOrigin(), true )
	unit:Attribute_SetIntValue( "particleID", particleLeader )
end

function randomspawnshovel()
    local item = CreateItem("item_shovel", nil, nil)
    local pos = Entities:FindByName( nil, "shov"..RandomInt(1, 6)):GetAbsOrigin() 
    local drop = CreateItemOnPositionSync( pos, item )
    local pos_launch = pos+RandomVector(RandomInt(10,10))
    item:LaunchLoot(false, 20, 0.75, pos_launch)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier( "modifier_teleport_event", "modifiers/modifier_teleport_event", LUA_MODIFIER_MOTION_NONE )

_G.shovel_event = false

function mine_room_quest(trigger)
local hero = trigger.activator
	if hero ~= nil then
	local Key = hero:FindItemInInventory( "item_shovel" )
		if Key ~= nil then
			hero:RemoveItem(Key)
			mine_spawn()
			start_event()
		else
			Notifications:TopToAll({text="#mine_quest", duration=5})		
		end
	end
end

function mine_spawn()
	local random_mine_box = RandomInt(1,7)
	local units = {"middle_box","small_box","ultra_box"}
	for i = 1, 7 do
		local point = Entities:FindByName( nil, "mine"..i):GetAbsOrigin() 
		if i % 2 ~= 0 then
			for i = 1, 2 do
				local unit = CreateUnitByName("npc_treasure_chest", point + RandomVector( RandomInt( 30, 30 )), true, nil, nil, DOTA_TEAM_BADGUYS)	
			end
		end
		if i == random_mine_box then
			local unit = CreateUnitByName("minebox", point + RandomVector( RandomInt( 30, 30 )), true, nil, nil, DOTA_TEAM_BADGUYS)	
		else
			local unit = CreateUnitByName(units[RandomInt(1,#units)], point + RandomVector( RandomInt( 30, 30 )), true, nil, nil, DOTA_TEAM_BADGUYS)
		end
	end
end

function start_event()
	_G.shovel_event = true
	local first_show = true
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local unit = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				unit:AddNewModifier(unit, nil, "modifier_teleport_event", {})
				unit:EmitSound("Portal.Loop_Appear")
				
				Timers:CreateTimer(3, function()
					local point = Entities:FindByName( nil, "minepnt"):GetAbsOrigin()
					unit:SetAbsOrigin( point )
					FindClearSpaceForUnit(unit, point, false)
					unit:Stop()
					unit:StopSound("Portal.Loop_Appear")
					unit:RemoveModifierByName("modifier_teleport_event")
		
					PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), unit)
					
					EmitGlobalSound("tutorial_rockslide")			
					Timers:CreateTimer(0.1, function()
						PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), nil)
					return nil
					end)
				end)
			end
		end
	end
	
	local duration_event = 10
	Timers:CreateTimer(3, function()
		if first_show then
			first_show = false
			Notifications:TopToAll({text="#mine_quest2", duration=3})
		end
		duration_event = duration_event - 1
			if duration_event > 0 then
				Notifications:TopToAll({text="#mine"..duration_event, duration=1})	
			return 1
		else
			mine_tp_out()
			return nil
		end
	end)
end	

function mine_tp_out()
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local unit = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				unit:AddNewModifier(unit, nil, "modifier_teleport_event", {})
				unit:EmitSound("Portal.Loop_Appear")
				Timers:CreateTimer(3, function()
					_G.shovel_event = false
					local ent = Entities:FindByName( nil, "pnt5")
					local point = ent:GetAbsOrigin()
					unit:SetAbsOrigin( point )
					FindClearSpaceForUnit(unit, point, false)
					unit:Stop()
					unit:StopSound("Portal.Loop_Appear")
					unit:RemoveModifierByName("modifier_teleport_event")
										
					PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), unit)
					Timers:CreateTimer(0.1, function()
						PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), nil)
					return nil
					end)
				end)	
			
				Timers:CreateTimer("timer_tp_out_mines", { useGameTime = false, endTime = 1, callback = function()
					local hRelay = Entities:FindByName( nil, "mine_tpout" )
						if hRelay == nil then
							return
						end
						hRelay:Trigger(nil,nil)
					return 0.2
				end})
			end
		end
	end
end

function tp_out_mines(event)
	if _G.shovel_event == false then
		local unit = event.activator
		local ent = Entities:FindByName( nil, "pnt5")
		local point = ent:GetAbsOrigin()
		unit:SetAbsOrigin( point )
		FindClearSpaceForUnit(unit, point, false)
		unit:Stop()
		PlayerResource:SetCameraTarget(event.activator:GetPlayerOwnerID(), event.activator)
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(event.activator:GetPlayerOwnerID(), nil)
			return nil
		end)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

function hiddenquest()
	Notifications:TopToAll({text="#minihidden", duration=5})	
end
 
function sound ( trigger )
	local hActivatorHero = trigger.activator
	hActivatorHero:EmitSound("tutorial_gate_open_metal")
end
 
function reward()
	local rewardPoint = Entities:FindByName(nil, "reward_point")
	local point = rewardPoint:GetAbsOrigin()
	local rewards = {"middle_box", "small_box", "small_box"}
	local rewardIndex = RandomInt(1, #rewards)
	local hUnit = CreateUnitByName(rewards[rewardIndex], point + RandomVector(RandomInt(0, 0)), true, nil, nil, DOTA_TEAM_BADGUYS)
	local unit = Entities:FindByName(nil, "lighter2")
	unit:SetDayTimeVisionRange(1500)
	unit:SetNightTimeVisionRange(1500)
	local particleLeader = ParticleManager:CreateParticle("particles/dire_fx/fire_barracks.vpcf", PATTACH_OVERHEAD_FOLLOW, unit)
	ParticleManager:SetParticleControlEnt(particleLeader, PATTACH_OVERHEAD_FOLLOW, unit, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", unit:GetAbsOrigin(), true)
end

------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------

function prt(t)
	GameRules:SendCustomMessage(''..t,0,0)
end

zone = 0

function invasion()
	zone = zone + 1
	if zone == 1 then 
		R5 = RandomInt(250,280) 
		Timers:CreateTimer(R5, function()
			creep1(R5)
		return R5
		end)
	end	

	if zone == 2 then 
		R6 = RandomInt(250,280)
		Timers:CreateTimer(R6, function()
			creep2(R6)
		return R6
		end)
	end	

	if zone == 3 then 
		R7 = RandomInt(250,280)
		Timers:CreateTimer(R7, function()
			creep3(R7)
		return R7
		end)
	end	
	
	if zone == 4 then 
		R8 = RandomInt(250,280)
		Timers:CreateTimer(R8, function()
			creep4(R8)
		return R8
		end)
	end	
	
	if zone == 5 then 
		R9 = RandomInt(250,280)
		Timers:CreateTimer(R9, function()
			creep5(R9)
		return R9
		end)
	end	
	
	if zone == 6 then 
		R10 = RandomInt(250,280)
		Timers:CreateTimer(R10, function()
			creep6(R10)
		return R10
		end)
	end	
end

function golden_end(unit)
	unit:AddNewModifier(unit, nil, "modifier_teleport_event", {})
	unit:EmitSound("Portal.Loop_Appear")
	local teleport_particle = ParticleManager:CreateParticle( "particles/econ/items/tinker/boots_of_travel/teleport_start_bots.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	Timers:CreateTimer(3, function()
		unit:StopSound("Portal.Loop_Appear")
		unit:RemoveModifierByName("modifier_teleport_event")
		ParticleManager:DestroyParticle( teleport_particle, false)
		PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), unit)
		UTIL_Remove(unit)
	end)
end

function creep1()
	local t = {"1_golden_1","1_golden_2","1_golden_3","1_golden_4","1_golden_5"}
	local array = t[math.random(#t)]
	Notifications:TopToAll({text="#golden_dragon1", duration=3})
	prt('#golden_dragon1')		
	local point = Entities:FindByName( nil, array):GetAbsOrigin()
	local unit = CreateUnitByName("GoldenMiner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
	Timers:CreateTimer({endTime = 240, callback = function()
		golden_end(unit)
	end})
end

function creep2()
	local t = {"2_golden_1","2_golden_2","2_golden_3"}
	local array = t[math.random(#t)]
	Notifications:TopToAll({text="#golden_dragon2", duration=3})
	prt('#golden_dragon2')		
	local point = Entities:FindByName( nil, array):GetAbsOrigin()
	local unit = CreateUnitByName("GoldenQueen", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
	Timers:CreateTimer({endTime = 240, callback = function()
		golden_end(unit)
	end})
end

function creep3()
	local t = {"3_golden_1","3_golden_2","3_golden_3"}
	local array = t[math.random(#t)]
	Notifications:TopToAll({text="#golden_dragon3", duration=3})
	prt('#golden_dragon3')		
	local point = Entities:FindByName( nil, array):GetAbsOrigin()
	local unit = CreateUnitByName("GoldenWyvern", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
	Timers:CreateTimer({endTime = 240, callback = function()
		golden_end(unit)
	end})
end

function creep4()
	local t = {"4_golden_1","4_golden_2","4_golden_3"}
	local array = t[math.random(#t)]
	Notifications:TopToAll({text="#golden_dragon4", duration=3})
	prt('#golden_dragon4')
	local point = Entities:FindByName( nil, array):GetAbsOrigin()
	local unit = CreateUnitByName("GoldenSea", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
	Timers:CreateTimer({endTime = 240, callback = function()
		golden_end(unit)
	end})
end

function creep5()
	local t = {"5_golden_1","5_golden_2","5_golden_3"}
	local array = t[math.random(#t)]
	Notifications:TopToAll({text="#golden_dragon5", duration=3})
	prt('#golden_dragon5')		
	local point = Entities:FindByName( nil, array):GetAbsOrigin()
	local unit = CreateUnitByName("GoldenDragon", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
	Timers:CreateTimer({endTime = 240, callback = function()
		golden_end(unit)
	end})
end

function creep6()
	local t = {"6_golden_1","6_golden_2","6_golden_3"}
	local array = t[math.random(#t)]
	Notifications:TopToAll({text="#golden_dragon6", duration=3})
	prt('#golden_dragon6')		
	local point = Entities:FindByName( nil, array):GetAbsOrigin()
	local unit = CreateUnitByName("GoldenForest", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
	Timers:CreateTimer({endTime = 240, callback = function()
		golden_end(unit)
	end})
end


function sborka_egg (trigger)
	local triggerName = thisEntity:GetName() -- 'gold_egg2' 
	local boss = Entities:FindByName( nil, "boss_undying" )
	if boss ~= nil and boss:IsAlive() then 
		Notifications:TopToAll({text="#kill_undy", duration=3})
	else
		local hActivatorHero = trigger.activator
		if hActivatorHero ~= nil then
			Notifications:TopToAll({text="#egg", duration=3})
			local Key = hActivatorHero:FindItemInInventory( "item_bones" )
			if Key ~= nil then
				egg_charges = Key:GetCurrentCharges()
				local total = egg_charges/5
				local true_total =  math.floor(total)
				local ostatok = egg_charges - (true_total*5)
				if true_total >= 1 then
					for i = 1, true_total do
						hActivatorHero:RemoveItem(Key)
						hActivatorHero:EmitSound("Item.DropGemWorld")   
						egg_spawn(triggerName)
					end
					if ostatok >= 1 then 
						hActivatorHero:AddItemByName("item_bones")
						local Key_ostatok = hActivatorHero:FindItemInInventory( "item_bones" )
						Key_ostatok:SetCurrentCharges(ostatok)
					end
				end
			end
		end
	end
end

function egg_spawn(triggerName)
	if triggerName == "gold_egg" then
		local spawnPoint = Entities:FindByName( nil, "eggspawn"):GetAbsOrigin()
		local newItem = CreateItem( "item_egg", nil, nil )
		local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	else
		local spawnPoint = Entities:FindByName( nil, "eggspawn2"):GetAbsOrigin()
		local newItem = CreateItem( "item_egg", nil, nil )
		local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	end
end