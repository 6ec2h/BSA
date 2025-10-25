function quest_start(data)
	quest_system:StartQuest('main', 3)
end

function creep_spawn()
	random_ability = passive[RandomInt(1,#passive)]
	local units = Entities:FindAllByName("forest_zombie")
	for _,unit in pairs(units) do
		rules:aura_dif(unit,random_ability)
		unit:RemoveModifierByName( "modifier_invulnerable")
		unit:RemoveModifierByName("modifier_medusa_stone_gaze_stone")
		unit:RemoveModifierByName("modifier_magic_immune")
	end
	
	local units = Entities:FindAllByName("skeleton")
	for _,unit in pairs(units) do
		rules:aura_dif(unit,random_ability)
		unit:RemoveModifierByName( "modifier_invulnerable")
		unit:RemoveModifierByName("modifier_medusa_stone_gaze_stone")
		unit:RemoveModifierByName("modifier_magic_immune")
	end

	if _G.Game_Difficulty >= 12 then
		Timers:CreateTimer(3, function()
			Notifications:TopToAll({text="#usilenie", duration=3})
			Notifications:TopToAll({text="#DOTA_Tooltip_ability_"..random_ability, duration=3})
		end)
	end
	
	for i = 9, 18 do 
		local point = Entities:FindByName( nil, "crate"..i):GetAbsOrigin()
		 for i =1,4 do
			local unit = CreateUnitByName("npc_dota_crate", point + RandomVector( RandomInt( 50, 50 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
		end
	end	
end

-------------------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_badvision", "zones/zone2.lua", LUA_MODIFIER_MOTION_NONE)

modifier_badvision = class({})

function modifier_badvision:IsHidden()
	return false
end

function modifier_badvision:IsDebuff()
	return true
end

function modifier_badvision:IsPurgable()
	return false
end

function modifier_badvision:GetTexture()
    return "darkness"
end

function visions(trigger)
    local ent = trigger.activator
    if not ent then
		return
	end
    if ent:IsAlive() and ent:GetLevel() < 20 then
		ent:AddNewModifier( ent, nil, "modifier_badvision", {} )
		ent:SetDayTimeVisionRange( 450 )
		ent:SetNightTimeVisionRange	( 450 )
        return
    end
	if ent:IsAlive() and ent:GetLevel() > 20 then
		ent:AddNewModifier( ent, nil, "modifier_badvision", {} )
		ent:SetDayTimeVisionRange( 350 )
		ent:SetNightTimeVisionRange	( 350 )
        return
    end
	return 1
end

function visionsoff(trigger)
    local ent = trigger.activator
    if not ent then return end
    if ent:IsAlive() then
		ent:RemoveModifierByName("modifier_badvision")
		ent:SetDayTimeVisionRange( 1100 )
		ent:SetNightTimeVisionRange	( 1100 )
        return
    end
end