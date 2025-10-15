require('essentials')

function tp_xdes_start(event)
	local unit = event.activator  	
	ProjectileManager:ProjectileDodge(unit) 
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, unit) 
    unit:EmitSound("DOTA_Item.BlinkDagger.Activate")
	local point = Entities:FindByName( nil, "point_tp_xdes" ):GetAbsOrigin() 
	event.activator:SetAbsOrigin( point )
	FindClearSpaceForUnit(event.activator, point, false)
	event.activator:Stop() 
end

function tp_xdes_back(event)
	local unit = event.activator  	
	ProjectileManager:ProjectileDodge(unit) 
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, unit) 
    unit:EmitSound("DOTA_Item.BlinkDagger.Activate")
	local point = Vector(-5521, -15122, 256)
	event.activator:SetAbsOrigin( point )
	FindClearSpaceForUnit(event.activator, point, false)
	event.activator:Stop() 
end

function teleport_roshan(event)
	local unit = event.activator  	
	ProjectileManager:ProjectileDodge(unit) 
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, unit) 
    unit:EmitSound("DOTA_Item.BlinkDagger.Activate")
	local point = Entities:FindByName( nil, "pnt5" ):GetAbsOrigin() 
	event.activator:SetAbsOrigin( point )
	FindClearSpaceForUnit(event.activator, point, false)
	event.activator:Stop() 
end

function tp_necrolyte(event)
	if GameRules:IsCheatMode() then return end
	local unit = event.activator
	ProjectileManager:ProjectileDodge(unit)
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, unit)
	unit:EmitSound("DOTA_Item.BlinkDagger.Activate")
	local point = Entities:FindByName( nil, "point_final_boss"):GetAbsOrigin()
	
	FindClearSpaceForUnit(event.activator, point, false)
	event.activator:Stop()
	
	for boss, status in pairs(_G.bosses_counter) do
		if status == false then
			Shop:ban()
			break
		end
	end	
	
	Notifications:TopToAll({text = "sandgo", duration=5})

	Timers:CreateTimer(5.5, function()
		rules:boss_invulnerable("necrolyte")
	end)
end

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

function tpearth(event)
	local unit = Entities:FindByName( nil, "npc_dota_creature_gaven_the_brute")
	unit:RemoveModifierByName("modifier_invulnerable")
	unit:RemoveModifierByName("modifier_medusa_stone_gaze_stone")
	unit:RemoveModifierByName("modifier_magic_immune")
	essentials:createCustomHpBarFor(unit)
end

function tpsnow(event)
	local unit = Entities:FindByName( nil, "npc_dota_creature_snow")
	unit:RemoveModifierByName("modifier_invulnerable")
	unit:RemoveModifierByName("modifier_medusa_stone_gaze_stone")
	unit:RemoveModifierByName("modifier_magic_immune")
	essentials:createCustomHpBarFor(unit)
end


function tpmedusa(event)
   local unit = Entities:FindByName( nil, "medusa")
   local wws= "pntmedusa"
   local ent = Entities:FindByName( nil, wws)
   local point = ent:GetAbsOrigin()
   unit:SetAbsOrigin( point )
   FindClearSpaceForUnit(unit, point, false)
   unit:Stop()
   essentials:createCustomHpBarFor(unit)
end

function nyxhp(event)
	local unit = Entities:FindByName( nil, "NYX")
	essentials:createCustomHpBarFor(unit)
end

function teleportnyx(trigger)
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local R5 = RandomInt(1, 5)	
		ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hActivatorHero)
		hActivatorHero:EmitSound("DOTA_Item.BlinkDagger.Activate")
		local point = Entities:FindByName( nil, "tpnyx"..R5):GetAbsOrigin()
		PlayerResource:SetCameraTarget(trigger.activator:GetPlayerOwnerID(), trigger.activator)
		trigger.activator:SetAbsOrigin( point )
		FindClearSpaceForUnit(trigger.activator, point, false)
		trigger.activator:Stop()
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(trigger.activator:GetPlayerOwnerID(), nil)
		end)
	end
end

function skback(event)
   local unit = Entities:FindByName( nil, "necrolyte")
   local wws= "pntsand"
   local ent = Entities:FindByName( nil, wws)
   local point = ent:GetAbsOrigin()
   unit:SetAbsOrigin( point )
   FindClearSpaceForUnit(unit, point, false)
   unit:Stop()
end

function tpvod(event)  -- в конец ловушек
   local unit = event.activator
    ProjectileManager:ProjectileDodge(unit)
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, unit)
    unit:EmitSound("DOTA_Item.BlinkDagger.Activate")
   local wws= "pntvod"
   local ent = Entities:FindByName( nil, wws)
   local point = ent:GetAbsOrigin()
   event.activator:SetAbsOrigin( point )
   FindClearSpaceForUnit(event.activator, point, false)
   event.activator:Stop()
end

---------------------------------------------------------------

function nyxoff()
	local unit = Entities:FindByName( nil, "NYX")
	unit:RemoveModifierByName("modifier_invulnerable")
	unit:RemoveModifierByName("modifier_medusa_stone_gaze_stone")
	unit:RemoveModifierByName("modifier_magic_immune")
end

function nyxoff2()
	local unit = Entities:FindByName( nil, "NYX_2")
	unit:RemoveModifierByName("modifier_invulnerable")
	unit:RemoveModifierByName("modifier_medusa_stone_gaze_stone")
	unit:RemoveModifierByName("modifier_magic_immune")
end
end