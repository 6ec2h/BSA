require('essentials')
require("data")

creeps_xdes_zone = {"pudge", "npc_venom_creep", "npc_enigma", "npc_gyro", "npc_sniper", "npc_invoker_creep", "npc_mars_creep", "npc_phoenix_creep", "warlock", "npc_lifestealer", "batr", "miner", "small_hellbear", "npc_keeper_of_the_light", "treant"}

function creep_spawn()
	local bResult = xpcall(function()
	
		-----------------------------------------------------------------------
		
		random_ability = passive[RandomInt(1,#passive)]	
		local count = 0
		Timers:CreateTimer(0, function()
			if count < 10 then
				count = count + 1
					local point = Entities:FindByName( nil, "xdes_zone_"..count):GetAbsOrigin()
					for i = 1, 5 do
						local unit = CreateUnitByName(creeps_xdes_zone[RandomInt(1,#creeps_xdes_zone)], point + RandomVector( RandomInt( 250, 250 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
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
		
		local point = Entities:FindByName( nil, "point_panda"):GetAbsOrigin()
		local unit = CreateUnitByName("npc_xdes", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
		rules:aura_dif(unit,random_ability)
		
		clear()
		
		-----------------------------------------------------------------------
		
	end,
	function(e)
		print("-------------Error-------------")
		print(e)
		print("-------------Error-------------")
	end)  
	if bResult then
		print("all ok")
	else
		print("error")
	end			
end

function clear()
	Timers:CreateTimer(5, function()
		for i = 1, 10 do
			local point = Entities:FindByName( nil, "xdes_zone_"..i)
			if point then
				UTIL_Remove( point )
			end
		end	
	end)
end