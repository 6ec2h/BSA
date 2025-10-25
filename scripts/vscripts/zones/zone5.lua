function quest_start(data)
	quest_system:StartQuest('main', 9)
end

function crate ( trigger )
	for i = 41, 51 do 
		local point = Entities:FindByName( nil, "crate"..i):GetAbsOrigin()
		 for i =1,RandomInt(3,4) do
			local unit = CreateUnitByName("npc_dota_crate", point + RandomVector( RandomInt( 50, 50 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
		end
	end
end

function trapsspawn(trapspawn)
	random_ability = passive[RandomInt(1,#passive)]	
	
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 15 then
			count = count + 1
			local point = Entities:FindByName( nil, "trapspawn"..count):GetAbsOrigin()
			for i = 1, 6 do
				if i == 1 then 
					local unit = CreateUnitByName("tank", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
					rules:aura_dif(unit,random_ability)
				elseif i == 2 or i == 3 or i == 4 then
					local unit = CreateUnitByName("npc_trap_visage", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
					rules:aura_dif(unit,random_ability)
				else 
					local unit = CreateUnitByName("undying", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
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
	
	rules:clear_zone('trapspawn', 15)
end 

-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

function teleport_room(event)
	local unit = event.activator
	local triggerName = thisEntity:GetName()
	
	local hRelay = Entities:FindByName( nil, "tp_off" )
	if hRelay == nil then return end
	hRelay:Trigger(nil,nil)
	
	Timers:CreateTimer(0.3, function()
		local ent = Entities:FindByName( nil, triggerName .. "_point") 
		local point = ent:GetAbsOrigin()
		unit:SetAbsOrigin( point )
		FindClearSpaceForUnit(unit, point, true)
		unit:Stop() 
		ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, unit)
		unit:EmitSound("DOTA_Item.BlinkDagger.Activate") 
		
		PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), unit)
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), nil)
			return nil
		end)
	end)
end

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

function teleport_iz_centra(event)
	local unit = event.activator
	local triggerName = thisEntity:GetName()
	
	local hRelay = Entities:FindByName( nil, "tp_off" )
	if hRelay == nil then return end
	hRelay:Trigger(nil,nil)
	
	Timers:CreateTimer(0.3, function()
		local ent = Entities:FindByName( nil, "trap_" .. triggerName) 
		local point = ent:GetAbsOrigin()
		unit:SetAbsOrigin( point )
		FindClearSpaceForUnit(unit, point, true)
		unit:Stop() 
		ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, unit)
		unit:EmitSound("DOTA_Item.BlinkDagger.Activate") 
		PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), unit)
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), nil)
			return nil
		end)
	end)
end

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

function guard_activate()
	local unit = Entities:FindAllByName("guard")
	for _, key in pairs(unit) do
		key:RemoveModifierByName("modifier_invulnerable")
		key:RemoveModifierByName("modifier_medusa_stone_gaze_stone")
		key:RemoveModifierByName("modifier_magic_immune")
	end	
end

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

function create_item_key()
	local item = CreateItem("item_prison_cell_key", nil, nil)
	local pos = Entities:FindByName( nil, "guard_room_activate"):GetAbsOrigin()
	local drop = CreateItemOnPositionSync( pos, item )
	item:LaunchLoot(false, 20, 0.75, pos)
end
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

function lastroomsound ( trigger )
	local hActivatorHero = trigger.activator
	hActivatorHero:EmitSound("tutorial_gate_open_metal")
end		

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

function sbtp1(event)
	local unit = event.activator
    ProjectileManager:ProjectileDodge(unit)
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, unit)
    unit:EmitSound("DOTA_Item.BlinkDagger.Activate")
	local wws= "sb1pnt"
	local ent = Entities:FindByName( nil, wws)
	local point = ent:GetAbsOrigin()
	event.activator:SetAbsOrigin( point )
	FindClearSpaceForUnit(event.activator, point, true)
	event.activator:Stop()
	
	local quest_9 = _G.players_quest_progress["additional"][106]
	if quest_9 and not quest_9.completed then
		quest_9.kill_count = (quest_9.kill_count or 0) + 1
		quest_system:UpdateQuest("additional", 106, quest_9.kill_count)
		if quest_9.kill_count >= _G.quest_data["additional"][106].goal then
			quest_9.completed = true
			quest_system:RemoveQuest("additional", 106, "success")
		end
	end
	
end

function sbtp2(event)
	local unit = event.activator
	ProjectileManager:ProjectileDodge(unit)
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, unit)
    unit:EmitSound("DOTA_Item.BlinkDagger.Activate")
	local wws= "trap_pnt_vxod"
	local ent = Entities:FindByName( nil, wws)
	local point = ent:GetAbsOrigin()
	event.activator:SetAbsOrigin( point )
	FindClearSpaceForUnit(event.activator, point, true)
	event.activator:Stop()
end

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_silent", "modifiers/modifier_silent", LUA_MODIFIER_MOTION_NONE )

function tainikon(event)
   local unit = event.activator
   unit:AddNewModifier( unit, self, "modifier_silent", {} )  
   unit:AddNewModifier( unit, self, "modifier_ice_blast", {} )
end

function tainikoff(event)
   local unit = event.activator
   unit:RemoveModifierByName("modifier_silent")  
   unit:RemoveModifierByName("modifier_ice_blast")  
end
end