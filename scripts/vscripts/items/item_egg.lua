require("data")

function spawn(keys)
	local new_charges = keys.ability:GetCurrentCharges() - 1
	if new_charges <= 0 then
		UTIL_Remove(keys.ability)
		Ran = RandomInt(1,6)
		keys.caster:EmitSound("Aegis.Timer") 
		
		if Ran == 1 then 
			local t = {"1_golden_1","1_golden_2","1_golden_3","1_golden_4","1_golden_5"}
			local array = t[math.random(#t)]
			Notifications:TopToAll({text="#golden_dragon1", duration=3})
			prt('#golden_dragon1')		
			local vPoint1 = Entities:FindByName( nil, array):GetAbsOrigin()
			local unit = CreateUnitByName("GoldenMiner1", vPoint1 + RandomVector( RandomFloat( 50, 50 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
			random_ability = passive[RandomInt(1,#passive)]	
			rules:aura_dif(unit, random_ability)
		end
	
		if Ran == 2 then	
			local t = {"2_golden_1","2_golden_2","2_golden_3"}
			local array = t[math.random(#t)]
			Notifications:TopToAll({text="#golden_dragon2", duration=3})
			prt('#golden_dragon2')		
			local vPoint1 = Entities:FindByName( nil, array):GetAbsOrigin()
			local unit = CreateUnitByName("GoldenQueen1", vPoint1 + RandomVector( RandomFloat( 50, 50 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
			random_ability = passive[RandomInt(1,#passive)]	
			rules:aura_dif(unit, random_ability)
		end
		
		if Ran == 3 then	
			local t = {"3_golden_1","3_golden_2","3_golden_3"}
			local array = t[math.random(#t)]
			Notifications:TopToAll({text="#golden_dragon3", duration=3})
			prt('#golden_dragon3')		
			local vPoint1 = Entities:FindByName( nil, array):GetAbsOrigin()
			local unit = CreateUnitByName("GoldenWyvern1", vPoint1 + RandomVector( RandomFloat( 50, 50 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
			random_ability = passive[RandomInt(1,#passive)]	
			rules:aura_dif(unit, random_ability)
		end
		
		if Ran == 4 then	
			local t = {"4_golden_1","4_golden_2","4_golden_3"}
			local array = t[math.random(#t)]
			Notifications:TopToAll({text="#golden_dragon4", duration=3})
			prt('#golden_dragon4')
			local vPoint1 = Entities:FindByName( nil, array):GetAbsOrigin()
			local unit = CreateUnitByName("GoldenSea1", vPoint1 + RandomVector( RandomFloat( 50, 50 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
			random_ability = passive[RandomInt(1,#passive)]	
			rules:aura_dif(unit, random_ability)
		end
		
		if Ran == 5 then 	
			local t = {"5_golden_1","5_golden_2","5_golden_3"}
			local array = t[math.random(#t)]
			Notifications:TopToAll({text="#golden_dragon5", duration=3})
			prt('#golden_dragon5')		
			local vPoint1 = Entities:FindByName( nil, array):GetAbsOrigin()
			local unit = CreateUnitByName("GoldenDragon1", vPoint1 + RandomVector( RandomFloat( 50, 50 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
			random_ability = passive[RandomInt(1,#passive)]	
			rules:aura_dif(unit, random_ability)
		end		
		
		if Ran == 6 then	
			local t = {"6_golden_1","6_golden_2","6_golden_3"}
			local array = t[math.random(#t)]
			Notifications:TopToAll({text="#golden_dragon6", duration=3})
			prt('#golden_dragon6')		
			local vPoint1 = Entities:FindByName( nil, array):GetAbsOrigin()
			local unit = CreateUnitByName("GoldenForest1", vPoint1 + RandomVector( RandomFloat( 50, 50 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
			random_ability = passive[RandomInt(1,#passive)]	
			rules:aura_dif(unit, random_ability)
		end
	end
end