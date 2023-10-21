if GameMode == nil then
	_G.GameMode = class({})
end

item_drop = {
		{items = {"item_xdes_heart"}, chance = 100,  duration = 15, units = {"npc_xdes"}},	

		-- {items = {"item_gold_1000"}, chance = 100,  duration = 15, units = {"GoldenMiner","GoldenMiner1"}},	
		{items = {"item_set_boots_str_1_set_1","item_set_boots_agi_1_set_1","item_set_boots_int_1_set_1"}, chance = 100,  duration = 15, units = {"GoldenMiner","GoldenMiner1"}, prev_item = ""},	
		{items = {"item_set_boots_str_1_set_2","item_set_boots_agi_1_set_2","item_set_boots_int_1_set_2"}, chance = 100,  duration = 15, units = {"GoldenMiner","GoldenMiner1"}, prev_item = ""},	

		-- {items = {"item_gold_1500"}, chance = 100,  duration = 15, units = {"GoldenQueen","GoldenQueen1"}},	
		{items = {"item_set_head_str_1_set_1","item_set_head_agi_1_set_1","item_set_head_int_1_set_1"}, chance = 100,  duration = 15, units = {"GoldenQueen","GoldenQueen1"}, prev_item = ""},	
		{items = {"item_set_head_str_1_set_2","item_set_head_agi_1_set_2","item_set_head_int_1_set_2"}, chance = 100,  duration = 15, units = {"GoldenQueen","GoldenQueen1"}, prev_item = ""},	
		
		-- {items = {"item_gold_2000"}, chance = 100,  duration = 15, units = {"GoldenWyvern","GoldenWyvern1"}},	
		{items = {"item_set_glov_str_1_set_1","item_set_glov_agi_1_set_1","item_set_glov_int_1_set_1"}, chance = 100,  duration = 15, units = {"GoldenWyvern","GoldenWyvern1"}, prev_item = ""},
		{items = {"item_set_glov_str_1_set_2","item_set_glov_agi_1_set_2","item_set_glov_int_1_set_2"}, chance = 100,  duration = 15, units = {"GoldenWyvern","GoldenWyvern1"}, prev_item = ""},
		
		-- {items = {"item_gold_2500"}, chance = 100,  duration = 15, units = {"GoldenSea","GoldenSea1"}},	
		{items = {"item_set_weapon_str_1_set_1","item_set_shield_agi_1_set_1","item_set_shield_int_1_set_1"}, chance = 100,  duration = 15, units = {"GoldenSea","GoldenSea1"}, prev_item = ""},
		{items = {"item_set_weapon_str_1_set_2","item_set_shield_agi_1_set_2","item_set_shield_int_1_set_2"}, chance = 100,  duration = 15, units = {"GoldenSea","GoldenSea1"}, prev_item = ""},
					
		-- {items = {"item_gold_3000"}, chance = 100,  duration = 15, units = {"GoldenDragon","GoldenDragon1"}},	
		{items = {"item_set_shield_str_1_set_1","item_set_armor_agi_1_set_1","item_set_armor_int_1_set_1"}, chance = 100,  duration = 15, units = {"GoldenDragon","GoldenDragon1"}, prev_item = ""},	
		{items = {"item_set_shield_str_1_set_2","item_set_armor_agi_1_set_2","item_set_armor_int_1_set_2"}, chance = 100,  duration = 15, units = {"GoldenDragon","GoldenDragon1"}, prev_item = ""},	
					
		-- {items = {"item_gold_3500"}, chance = 100,  duration = 15, units = {"GoldenForest","GoldenForest1"}},	
		{items = {"item_set_armor_str_1_set_1","item_set_weapon_agi_1_set_1","item_set_weapon_int_1_set_1"}, chance = 100,  duration = 15, units = {"GoldenForest","GoldenForest1"}, prev_item = ""},	
		{items = {"item_set_armor_str_1_set_2","item_set_weapon_agi_1_set_2","item_set_weapon_int_1_set_2"}, chance = 100,  duration = 15, units = {"GoldenForest","GoldenForest1"}, prev_item = ""},	
		
	
		{items = {"item_ticket"}, chance = 3,  duration = 30, units = {"satyr_soulstealer","satyr_hellcaller","npc_dota_creature_hellbear","npc_dota_creature_small_hellbear","npc_dota_creature_dire_hound","npc_dota_creature_dire_hound_boss","forest_zombie","skeleton","npc_creep_crystal","apparat","tusk","icespider","white_walker","mirana","npc_dota_creature_large_ogre_seal","guard","npc_trap_visage","tank","undying","morf", "npc_blob","npc_slardar_unit","npc_shaker","npc_zone_jungle_1","npc_zone_jungle_2","npc_zone_jungle_3","npc_zone_jungle_4","npc_keeper_of_the_light","miner","small_hellbear","encha","treant","npc_lifestealer","batr","warlock","pudge","npc_venom_creep","demon","npc_gyro","npc_enigma","npc_sniper","npc_disruptor","cher"}},		
			
		{items = {"item_bones"}, chance = 7,  duration = 30, units = {"satyr_soulstealer","satyr_hellcaller","npc_dota_creature_hellbear","npc_dota_creature_small_hellbear","npc_dota_creature_dire_hound","npc_dota_creature_dire_hound_boss","forest_zombie","skeleton","npc_creep_crystal","apparat","tusk","icespider","white_walker","mirana","npc_dota_creature_large_ogre_seal","guard","npc_trap_visage","tank","undying","morf", "npc_blob","npc_slardar_unit","npc_shaker","npc_zone_jungle_1","npc_zone_jungle_2","npc_zone_jungle_3","npc_zone_jungle_4","npc_keeper_of_the_light","miner","small_hellbear","encha","treant","npc_lifestealer","batr","warlock","pudge","npc_venom_creep","demon","npc_gyro","npc_enigma","npc_sniper","npc_disruptor","cher"}},	
		
		{items = {"item_book_of_strength","item_book_of_agility","item_book_of_intelligence"}, chance = 5,  duration = 30, units = {"satyr_soulstealer","satyr_hellcaller","npc_dota_creature_hellbear","npc_dota_creature_small_hellbear","npc_dota_creature_dire_hound","npc_dota_creature_dire_hound_boss","forest_zombie","skeleton","npc_creep_crystal","apparat","tusk","icespider","white_walker","mirana","npc_dota_creature_large_ogre_seal","guard","npc_trap_visage","tank","undying","morf", "npc_blob","npc_slardar_unit","npc_shaker","npc_zone_jungle_1","npc_zone_jungle_2","npc_zone_jungle_3","npc_zone_jungle_4","npc_keeper_of_the_light","miner","small_hellbear","encha","treant","npc_lifestealer","batr","warlock","pudge","npc_venom_creep","demon","npc_gyro","npc_enigma","npc_sniper","npc_disruptor","cher"}},	
		
		{items = {"item_cheese_lua"}, chance = 75,  duration = 20, units = {"roshan_npc"}},
		{items = {"item_aegis_lua"}, chance = 100,  duration = 20, units = {"roshan_npc"}},
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

item_drop_common_neutral = {
		{items = {"item_speed_common","item_boots_speed_common","item_crit_common","item_bolt_common","item_bash_common"}, chance = 100, duration = 30},
		{items = {"item_gold_1500"}, chance = 100,  duration = 15},
}
item_drop_rare_neutral = {
		{items = {"item_speed_rare","item_boots_speed_rare","item_crit_rare","item_bolt_rare","item_bash_rare"}, chance = 100, duration = 30},
		{items = {"item_gold_2500"}, chance = 100,  duration = 15},
}
item_drop_legendary_neutral = {
		{items = {"item_speed_legendary","item_boots_speed_legendary","item_crit_legendary","item_bolt_legendary","item_bash_legendary"}, chance = 100, duration = 30},
		{items = {"item_gold_3500"}, chance = 100,  duration = 15},
}

function GameMode:InitGameMode()
	ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
end

function GameMode:OnEntityKilled( keys )
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local killer = EntIndexToHScript( keys.entindex_attacker )
	local name = killedUnit:GetUnitName()
	
	if killedUnit and not killedUnit:IsRealHero() then
		RollItemDrop(killedUnit)
		if name == "npc_dota_creature_snow" or name == "npc_dota_creature_gaven_the_brute" then
			RollItemDropNeutral(killedUnit, killer)
		end
	end
end

function RollItemDrop(unit)
	local unit_name = unit:GetUnitName()
	for _,drop in ipairs(item_drop) do
		local items = drop.items or nil
		local items_num = #items
		local units = drop.units or nil 
		local chance = drop.chance or 100 
		local loot_duration = drop.duration or nil
		local limit = drop.limit or nil 
		local prev_item = drop.prev_item or nil
		local item_name = items[1]
		local roll_chance = RandomFloat(0, 100)
			
		if units then 
			for _,current_name in pairs(units) do
				if current_name == unit_name then
					units = nil
					break
				end
			end
		end

		if units == nil and (limit == nil or limit > 0) and roll_chance < chance then
			
			if limit then
				drop.limit = drop.limit - 1
			end

			if items_num > 1 then
				item_name = items[RandomInt(1, #items)]
			end
			
			if drop.prev_item then
				while drop.prev_item == item_name do
					item_name = items[RandomInt(1, #items)]
				end
				drop.prev_item = item_name
			end

			spawnPoint = unit:GetAbsOrigin()	
			local newItem = CreateItem( item_name, nil, nil )
			local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
			local dropRadius = RandomFloat( 50, 100 )

			newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
			if loot_duration then
				newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, loot_duration )
			end
		end
	end	
end

function RollItemDropNeutral(unit, killer)
	local unit_name = unit:GetUnitName()
	local rarity = RandomInt(1, 100)

	local guild_mod = killer:FindModifierByName("modifier_guild")
	if guild_mod ~= nil then
		rarity = rarity - guild_mod.reward_4 * 1.5
	end

	local function roll_drop(drop_table)
		for _, drop in ipairs(drop_table) do
			local items = drop.items or {}
			local items_num = #items
			local units = drop.units or nil
			local chance = drop.chance or 100
			local loot_duration = drop.duration or nil
			local limit = drop.limit or nil
			local item_name = items[1]
			local roll_chance = RandomFloat(0, 100)

			if units then
				for _, current_name in pairs(units) do
					if current_name == unit_name then
						units = nil
						break
					end
				end
			end

			if units == nil and (limit == nil or limit > 0) and roll_chance < chance then
				if limit then
					drop.limit = drop.limit - 1
				end

				if items_num > 1 then
					item_name = items[RandomInt(1, #items)]
				end

				local spawnPoint = unit:GetAbsOrigin()
				local newItem = CreateItem(item_name, nil, nil)
				local drop = CreateItemOnPositionForLaunch(spawnPoint, newItem)
				local dropRadius = RandomFloat(50, 100)

				newItem:LaunchLootInitialHeight(false, 0, 150, 0.5, spawnPoint + RandomVector(dropRadius))
				if loot_duration then
					newItem:SetContextThink("KillLoot", function() return KillLoot(newItem, drop) end, loot_duration)
				end
			end
		end
	end

	if rarity <= 15 then
		roll_drop(item_drop_legendary_neutral)
	elseif rarity <= 45 then
		roll_drop(item_drop_rare_neutral)
	else
		roll_drop(item_drop_common_neutral)
	end
end


function KillLoot( item, drop )
	if drop:IsNull() then
		return
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, drop )
	ParticleManager:SetParticleControl( nFXIndex, 0, drop:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	UTIL_Remove( item )
	UTIL_Remove( drop )
end

GameMode:InitGameMode()