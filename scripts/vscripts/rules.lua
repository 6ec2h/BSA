require('essentials')
require("data")

if rules == nil then
    _G.rules = class({})
end

function rules:init()
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( rules, 'OnGameStateChanged' ), self )
	CustomGameEventManager:RegisterListener("golden_spawn", Dynamic_Wrap( rules, 'golden_spawn' ))	
end

function rules:DisplayError(playerID, message)
	local player = PlayerResource:GetPlayer(playerID)
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message=message})
	end
end

function rules:OnGameStateChanged()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		checkpoint()
		box_spawn()
		create_box_traps()
		dummy_spawn()
		rules:bosses_upgrade()
	end
end

function rules:golden_spawn(t)
    local place = t.type
	local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
	local Key = hero:FindItemInInventory( "item_egg" )
	if Key ~= nil then
		hero:RemoveItem(Key)
		hero:EmitSound("Aegis.Timer")
		local point = Entities:FindByName( nil, 'golden_point'):GetAbsOrigin()
		local unit = CreateUnitByName(t.type, point, true, nil, nil, DOTA_TEAM_NEUTRALS)		
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "spawned", { successfully = true } )
    else
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "spawned", { successfully = false } )
    end
end

function create_box_traps()
	CreateRune(Vector(-4252,14776,256), DOTA_RUNE_ILLUSION)
	count = 0
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
		if PlayerResource:HasSelectedHero( nPlayerID ) then
		count = count + 1
			end
		end
	end
	for i = 1, 5 - count do
		local point = Entities:FindByName( nil, "box_"..i):GetAbsOrigin()
		if point ~= nil then
			local hUnit = CreateUnitByName("npc_dota_crate2", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
		end
	end
end

creeps_other = {"forest_fat_zombie","forest_zombie","skeleton","npc_dota_creature_big_bear","boss_undying","lich","npc_dota_creature_storegga","guard","NYX","NYX_2","npc_boss_slardar","npc_boss_monkey_king","npc_boss_fura","Lord","medusa","npc_boss_arc","necrolyte","troll_high_priest","npc_dota_creature_gaven_the_brute","npc_dota_creature_snow","big_bear","npc_dota_roshan","zombieTomb1"}

big_units = {"npc_dota_creature_dire_hound_boss", "npc_dota_creature_hellbear", "satyr_hellcaller", "skeleton", "tusk", "npc_dota_creature_large_ogre_seal", "tank", "npc_slardar_unit", "npc_shaker", "treant", "warlock", "pudge", "npc_sniper", "npc_mars_creep"}

function rules:aura_dif(unit,random_ability)
	unit:AddNewModifier(unit, nil, "modifier_difficult", {}):SetStackCount(_G.Game_Difficulty)
	local unit_name = unit:GetUnitName()
	if random_ability then
		if _G.Game_Difficulty > 5 and _G.Game_Difficulty < 9 then -- 6 7 8
			if table.contains(big_units, unit_name) then
				unit:AddAbility(random_ability):SetLevel(2)
			end
		end	
		if _G.Game_Difficulty >= 9 and _G.Game_Difficulty < 11 then -- 9 10
			if table.contains(big_units, unit_name) then
				unit:AddAbility(random_ability):SetLevel(2)
				random_ability2 = passive[RandomInt(1,#passive)]
				unit:AddAbility(random_ability2):SetLevel(2)
			end	
		end	
		if  _G.Game_Difficulty >= 11 then-- 11 12
			if table.contains(big_units, unit_name) then
				unit:AddAbility(random_ability):SetLevel(4)
				random_ability2 = passive[RandomInt(1,#passive)]
				unit:AddAbility(random_ability2):SetLevel(4)
			end
		end
	end
end

-----------------------------------------------------------------------------------------------
function dummy_spawn()
	if not IsServer() then return end
	
	LinkLuaModifier( "modifier_custom_blacksmith", "modifiers/modifier_custom_blacksmith", LUA_MODIFIER_MOTION_NONE )
	local blacksmith = CreateUnitByName("blacksmith", Vector(-5445,-14329,384), false, nil, nil, DOTA_TEAM_GOODGUYS)
	blacksmith:AddNewModifier(blacksmith, nil, "modifier_custom_blacksmith", {})
	blacksmith:SetModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith:SetOriginalModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith:StartGesture(ACT_DOTA_IDLE)
	blacksmith:SetAngles(0,-90,0)
	
	local unit = CreateUnitByName( "npc_ua_statue", Vector(-6914,-15738,270), false, nil, nil, DOTA_TEAM_NEUTRALS)
	unit:StartGesture(ACT_DOTA_ATTACK)
	unit:AddNewModifier( unit, nil, "modifier_invulnerable", {} )
	unit:AddNewModifier( unit, nil, "modifier_statue", {} )
	unit:AddNewModifier( unit, nil, "modifier_magic_immune", {} )
	set_angle(unit, 90)

	local unit = CreateUnitByName( "npc_dota_hero_target_dummy", Vector(-4823,-14482,256), false, nil, nil, DOTA_TEAM_NEUTRALS)
	set_angle(unit, 240)
	unit:SetAbilityPoints( 0 )
	unit:Hold()
	unit:SetIdleAcquire( false )
	unit:SetAcquisitionRange( 0 )
	
	LinkLuaModifier( "modifier_statue", "modifiers/modifier_statue", LUA_MODIFIER_MOTION_NONE )
	
	local unit = CreateUnitByName( "npc_dota_hero_dado_statue", Vector(-4736,-15744,256), false, nil, nil, DOTA_TEAM_NEUTRALS)
	set_angle(unit, 120)
	unit:AddNewModifier( unit, nil, "modifier_statue", {} )
	
	local unit = CreateUnitByName( "npc_dota_hero_triss_statue", Vector(-4992,-15933,256), false, nil, nil, DOTA_TEAM_NEUTRALS)
	set_angle(unit, 100)
	unit:AddNewModifier( unit, nil, "modifier_statue", {} )

	local unit = CreateUnitByName( "npc_dota_hero_destroyer_statue", Vector(-5301,-15933,256), false, nil, nil, DOTA_TEAM_NEUTRALS)
	set_angle(unit, 100)
	unit:AddNewModifier( unit, nil, "modifier_statue", {} )
	
	local unit = CreateUnitByName( "npc_dota_hero_anakim_statue", Vector(-5632,-15933,256), false, nil, nil, DOTA_TEAM_NEUTRALS)
	set_angle(unit, 100)
	unit:AddNewModifier( unit, nil, "modifier_statue", {} )
end	

function set_angle(unit, ang)
	local angle = unit:GetAngles()
	local new_angle = RotateOrientation(angle, QAngle(0,ang,0))
	unit:SetAngles(new_angle[1], new_angle[2], new_angle[3])
end
-----------------------------------------------------------------------------------------------

function checkpoint()
	local hBuilding = Entities:FindByName( nil, "checkpoint00_building" )
	hBuilding:SetTeam( DOTA_TEAM_GOODGUYS )
	EmitGlobalSound( "DOTA_Item.Refresher.Activate" ) 
end

-----------------------------------------------------------------------------------------------

function rules:bosses_upgrade()	
	random_ability = passive[RandomInt(1,#passive)]	
	local enemies = FindUnitsInRadius(DOTA_TEAM_NEUTRALS,  Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE,  DOTA_UNIT_TARGET_TEAM_BOTH,  DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	 for _,unit in pairs(enemies) do
		for _,t in ipairs(creeps_other) do
			if t and t == unit:GetUnitName() then 
				rules:aura_dif(unit,random_ability)
			end
		end			
	end	
	invulnerable()
end

-----------------------------------------------------------------------------------------------

function box_spawn()
	local Point = Entities:FindByName( nil, "invis_box_zone_1_"..RandomInt(1, 2)):GetAbsOrigin()
	local hUnit = CreateUnitByName("invis_box", Point, true, nil, nil, DOTA_TEAM_NEUTRALS)

	local Point = Entities:FindByName( nil, "zone_1_point_"..RandomInt(1,5)):GetAbsOrigin()
	local hUnit = CreateUnitByName("small_box", Point, true, nil, nil, DOTA_TEAM_NEUTRALS)

	local Point = Entities:FindByName( nil, "zone_1_point_"..RandomInt(1,3)):GetAbsOrigin()
	local hUnit = CreateUnitByName("wand_box", Point, true, nil, nil, DOTA_TEAM_NEUTRALS)

	local Point = Entities:FindByName( nil, "zone_3_point_"..RandomInt(1,3)):GetAbsOrigin()
	local hUnit = CreateUnitByName("invis_box", Point, true, nil, nil, DOTA_TEAM_NEUTRALS)

	local Point = Entities:FindByName( nil, "zone_ice_point_"..RandomInt(1,3)):GetAbsOrigin()
	local hUnit = CreateUnitByName("invis_box", Point, true, nil, nil, DOTA_TEAM_NEUTRALS)
	
	for i = 1, 8 do
		local Point = Entities:FindByName( nil, "crate"..i):GetAbsOrigin()
		for i = 1, 3 do
			local hUnit = CreateUnitByName("npc_dota_crate",Point + RandomVector( RandomInt( 50, 50 )), true, nil, nil, DOTA_TEAM_NEUTRALS)	
		end
	end
end

-----------------------------------------------------------------------------------------------

function ursa()
	rules:boss_invulnerable("npc_dota_creature_big_bear")
end

function lich_off()
	rules:boss_invulnerable("lich")
end

function slardar()
	rules:boss_invulnerable("npc_boss_slardar")
end

function monkey()
	rules:boss_invulnerable("npc_boss_monkey_king")
end

function fura()
	rules:boss_invulnerable("npc_boss_fura")
end

function lord_off()
	rules:boss_invulnerable("Lord")
end

function medusa_off()
	rules:boss_invulnerable("medusa")
end

bosses_invu = {"guard","npc_dota_creature_big_bear","boss_undying","lich","npc_dota_creature_storegga","NYX","NYX_2","npc_boss_slardar","npc_boss_monkey_king","npc_boss_fura","Lord","medusa","npc_boss_arc", "storegga", "lich2", "undy", "necrolyte"}

function invulnerable()
	local enemies = FindUnitsInRadius(DOTA_TEAM_NEUTRALS,  Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	 for _,unit in pairs(enemies) do
		for _,key in ipairs(bosses_invu) do
			if key and key == unit:GetUnitName() then 
				unit:AddNewModifier( unit, nil, "modifier_invulnerable", {} )
				unit:AddNewModifier( unit, nil, "modifier_medusa_stone_gaze_stone", {} )
				unit:AddNewModifier( unit, nil, "modifier_magic_immune", {} )
			end
		end			
	end		
end

function rules:boss_invulnerable(t)
	local unit = Entities:FindByName( nil, t)
	unit:RemoveModifierByName( "modifier_invulnerable")
	unit:RemoveModifierByName("modifier_medusa_stone_gaze_stone")
	unit:RemoveModifierByName("modifier_magic_immune")
	essentials:createCustomHpBarFor(unit)
end

-- function rules:GetItemValues(item_name, modifier)
	-- local kv = LoadKeyValues("scripts/npc/npc_items_sets.txt")[item_name]
	-- for k, v in pairs(kv.AbilitySpecial) do
		-- for key, value in pairs(v) do
			-- if modifier.result[key] then
				-- modifier.result[key]= tonumber(value)
			-- end
		-- end
	-- end
-- end

function rules:GetItemValues(item_name, modifier, level)
	level = modifier:GetAbility():GetLevel()
    local kv = LoadKeyValues("scripts/npc/npc_items_sets.txt")[item_name]
    for k, v in pairs(kv.AbilitySpecial) do
        for key, value in pairs(v) do
            if modifier.result[key] then
                local values = {}
                for val in string.gmatch(value, "%S+") do
                    table.insert(values, tonumber(val))
                end
                modifier.result[key] = values[level] or modifier.result[key]
            end
        end
    end
end
