if drop == nil then
	_G.drop = class({})
end

item_drop = {
	{items = {"item_xdes_heart"}, chance = 100, duration = 15, units = {"npc_xdes"}},
	{items = {"item_ticket", "item_book_of_strength", "item_book_of_agility", "item_book_of_intelligence"}, chance = 10,  duration = 30, units = {"satyr_soulstealer","satyr_hellcaller","npc_dota_creature_hellbear","npc_dota_creature_small_hellbear","npc_dota_creature_dire_hound","npc_dota_creature_dire_hound_boss","forest_zombie","skeleton","npc_creep_crystal","apparat","tusk","icespider","white_walker","mirana","npc_dota_creature_large_ogre_seal","guard","npc_trap_visage","tank","undying","morf", "npc_blob","npc_slardar_unit","npc_zone_jungle_1","npc_zone_jungle_2","npc_zone_jungle_3","npc_zone_jungle_4","npc_keeper_of_the_light","miner","small_hellbear","encha","treant","npc_lifestealer","batr","warlock","pudge","npc_venom_creep","demon","npc_gyro","npc_enigma","npc_sniper","npc_disruptor","cher"}},	
	{items = {"item_cheese_lua"}, chance = 70, duration = 20, units = {"roshan_npc"}},
	{items = {"item_aegis_lua"}, chance = 100, duration = 20, units = {"roshan_npc"}},
	{items = {"item_lapa_ursa"}, chance = 100, limit = 1, units = {"npc_dota_creature_big_bear"}},
	{items = {"item_undying_skin"}, chance = 100, limit = 1, units = {"boss_undying"}},
	{items = {"item_lich_heart"}, chance = 100, limit = 1, units = {"lich"}},
	{items = {"item_tiny_buff"}, chance = 100, limit = 1, units = {"npc_dota_creature_storegga"}},
	{items = {"item_speed_", "item_boots_speed_", "item_crit_", "item_bolt_", "item_bash_"}, rares = true, chance = 100, duration = 30, units = {"npc_dota_creature_snow", "npc_dota_creature_gaven_the_brute"}},
}

function drop:init()
	ListenToGameEvent('entity_killed', Dynamic_Wrap(drop, 'OnEntityKilled'), self)
end

function drop:OnEntityKilled(keys)
	local killedUnit = EntIndexToHScript(keys.entindex_killed)
	local killer = EntIndexToHScript(keys.entindex_attacker)
	
	if killedUnit and not killedUnit:IsRealHero() then
		RollItemDrop(killedUnit)
	end
end

function RollItemDrop(unit)
	if not IsServer() then return end
	local unit_name = unit:GetUnitName()
	for _, drop in ipairs(item_drop) do
		if IsUnitInDropList(unit_name, drop.units) then
			drop_item(drop, unit)
		end
	end	
end

function IsUnitInDropList(unit_name, units)
	if units then
		for _, current_name in pairs(units) do
			if current_name == unit_name then
				return true
			end
		end
	end
	return false
end

function drop_item(drop, unit)
	local roll_chance = RandomInt(1, 100)
	if roll_chance <= drop.chance and (drop.limit == nil or drop.limit > 0) then
		
		if drop.limit then
			drop.limit = drop.limit - 1
		end
		
		local item_name = drop.items[1]
		if #drop.items > 1 then
			item_name = drop.items[RandomInt(1, #drop.items)]
		end
		
		if drop.rares then
			local rare_roll = RandomInt(1, 100)
			if rare_roll <= 15 then
				item_name = item_name .. "legendary"
			elseif rare_roll <= 45 then
				item_name = item_name .. "rare"
			else
				item_name = item_name .. "common"
			end
		end
		
		local spawnPoint = unit:GetAbsOrigin()	
		local newItem = CreateItem(item_name, nil, nil)
		local itemDrop = CreateItemOnPositionForLaunch(spawnPoint, newItem)
		local dropRadius = RandomInt(50, 100)

		newItem:LaunchLootInitialHeight(false, 0, 150, 0.5, spawnPoint + RandomVector(dropRadius))
		if drop.duration then
			newItem:SetContextThink("KillLoot", function() return KillLoot(newItem, itemDrop) end, drop.duration)
		end
	end
end

function KillLoot(item, drop)
	if drop:IsNull() then
		return
	end

	local nFXIndex = ParticleManager:CreateParticle("particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, drop)
	ParticleManager:SetParticleControl(nFXIndex, 0, drop:GetOrigin())
	ParticleManager:SetParticleControl(nFXIndex, 1, Vector(35, 35, 25))
	ParticleManager:ReleaseParticleIndex(nFXIndex)

	UTIL_Remove(item)
	UTIL_Remove(drop)
end

drop:init()
