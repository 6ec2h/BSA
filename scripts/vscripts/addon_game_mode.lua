require('libraries/notifications')
require("libraries/timers")
require("libraries/animations")
require("libraries/table")
require('mini_quest')
require('essentials')
require('shop/acc')
require('shop/guilds')
require('drop')
require('shop/boss_shop')
require('boss_reward')
require('rules')
require('inventory')
require('effects')

if CAddonAdvExGameMode == nil then
	CAddonAdvExGameMode = class({})
end

Precache = require("precache")

function Activate()
	GameRules.AddonAdventure = CAddonAdvExGameMode()
	GameRules.AddonAdventure:InitGameMode()
end

function CAddonAdvExGameMode:InitGameMode()
	GameRules:SetUseUniversalShopMode(true)
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)
	GameRules:SetCustomGameSetupAutoLaunchDelay(30)
	GameRules:GetGameModeEntity():SetHudCombatEventsDisabled( true )
	GameRules:SetHeroSelectionTime(50)
	GameRules:SetPreGameTime(5.0)
	GameRules:SetPostGameTime (2.0)
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5)
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0)
	GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled( true )
	GameRules:SetUseBaseGoldBountyOnHeroes(true)
	GameRules:SetStrategyTime(0)
	GameRules:GetGameModeEntity():SetRuneSpawnFilter( Dynamic_Wrap( CAddonAdvExGameMode, "RuneSpawnFilter" ), self )
	GameRules:GetGameModeEntity():SetMaximumAttackSpeed( 800 )	
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )	
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CAddonAdvExGameMode, 'OnEntityKilled' ), self )
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(CAddonAdvExGameMode, 'OnNPCSpawned'), self)		
	ListenToGameEvent('dota_inventory_player_got_item', Dynamic_Wrap(CAddonAdvExGameMode, 'OnItemAdded'), self)
	ListenToGameEvent( "player_chat", Dynamic_Wrap( CAddonAdvExGameMode, "OnChat" ), self )
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CAddonAdvExGameMode, 'OnGameStateChanged' ), self )
	ListenToGameEvent("dota_rune_activated_server",Dynamic_Wrap(CAddonAdvExGameMode,'onRuneActivated'),self)
	
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap( CAddonAdvExGameMode, "BountyFilter" ), self )
	
	GameRules:SetShowcaseTime(0)
	essentials:Init()
	inventory:init()
	effects:init()

	-- towershop:FillingNetTables()	
	self._ischeckingdefeat = false 
	self._defeatcounter = 5  
end

LinkLuaModifier( "modifier_difficult", "abilities/difficult/modifier_difficult", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_guild", "modifiers/modifier_guild", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aegis", "items/item_aegis_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creep_antilag", "modifiers/modifier_creep_antilag", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------

function CAddonAdvExGameMode:onRuneActivated(keys)
	local playerID = keys.PlayerID
	local team = PlayerResource:GetTeam(playerID)
	local rune_type = tostring(keys.rune)
	local runeOwner = PlayerResource:GetSelectedHeroEntity( playerID )

	local guild_mod = runeOwner:FindModifierByName("modifier_guild")
	if guild_mod ~= nil then
		if guild_mod.perm_reward_2 == 1 then
			for i = 1, PlayerResource:GetPlayerCountForTeam(team) do
				local playerId = PlayerResource:GetNthPlayerIDOnTeam(team, i)
					if PlayerResource:IsValidTeamPlayerID(playerId) then
						if playerId ~= keys.PlayerID then 
						local hero = PlayerResource:GetSelectedHeroEntity( playerId )
						if hero:IsRealHero() then
							local buffList = {
								"modifier_rune_arcane",
								"modifier_rune_doubledamage",
								"modifier_rune_haste",
								"modifier_rune_invis",
								"modifier_rune_regen"
								}	
							hero:AddNewModifier(hero, nil, buffList[RandomInt(1, #buffList)], {duration = 30})
						end
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------------
function CAddonAdvExGameMode:OnChat( event )
    local text = event.text 
	local pid = event.playerid
	local hero = PlayerResource:GetSelectedHeroEntity( pid )	
	local point = hero:GetAbsOrigin()	
	steamID = PlayerResource:GetSteamAccountID(pid)
	
	if text == "1" and steamID == 393187346 then

	end

	if text == "2432" and steamID == 393187346 then
		for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
					if not hero:IsAlive() then
						hero:RespawnHero(false, false)
					end
				hero:SetHealth( hero:GetMaxHealth() )
				hero:SetMana( hero:GetMaxMana() )
				hero:EmitSound("Hero_Omniknight.GuardianAngel.cast")
			end
		end
	elseif text == "2433" and steamID == 393187346 then
		for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				hero:SetAbsOrigin( point )
				ProjectileManager:ProjectileDodge(hero) 
				ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hero)
				hero:EmitSound("DOTA_Item.BlinkDagger.Activate") 
				FindClearSpaceForUnit(hero, point, false)
				hero:Stop()
			end
		end
	elseif text == "2434" and steamID == 393187346 then
		local hero = PlayerResource:GetSelectedHeroEntity( pid )
		-- FindClearSpaceForUnit(hero, Vector(1690, -7394, 235), false)
		hero:SetBaseIntellect(hero:GetBaseIntellect() + 10000)
		hero:SetBaseAgility(hero:GetBaseAgility() + 10000)
		hero:SetBaseStrength(hero:GetBaseStrength() + 10000)	
		LinkLuaModifier( "modifier_speed", "modifiers/modifier_speed", LUA_MODIFIER_MOTION_NONE )
		hero:AddNewModifier( hero, nil, "modifier_speed", {} )
	end
end

quest = 0	

--------------------------------------------------------------------------------------------------------------

function CAddonAdvExGameMode:OnItemAdded(keys)
	local itemlist = {"item_polarized_plate", "item_preserved_skull", "item_health_bag_2","item_gravel_foot","item_plague_staff","item_winter_embrace","item_unhallowed_icon","item_sign_of_the_arachnid","item_carapace_of_qaldin","item_paw_of_lucius","item_creed_of_omniscience","item_pelt_of_the_old_wolf","item_longclaws_amulet","item_bogduggs_baldric","item_custom_rapier","item_ticket2","item_epx_aura","item_krest","item_mp_bag","item_willful_resonance","item_dmg_aura","item_str","item_agi","item_int","item_random_stat","item_talisman_of_ambition","item_life_catcher","item_magic_plate","item_allfour","item_paw","item_avernos_mist","item_sboots","item_chest_d","item_armor_pet","item_armor_pet2","item_armor_pet3","item_armor_pet4","item_armor_pet5","item_armor_pet6","item_attackspeed_pet","item_attackspeed_pet2","item_attackspeed_pet3","item_attackspeed_pet4","item_attackspeed_pet5","item_attackspeed_pet6","item_spell_pet","item_spell_pet2","item_spell_pet3","item_spell_pet4","item_spell_pet5","item_spell_pet6","item_hpmp_pet","item_hpmp_pet2","item_hpmp_pet3","item_hpmp_pet4","item_hpmp_pet5","item_hpmp_pet6","item_stats_pet","item_stats_pet2","item_stats_pet3","item_stats_pet4","item_stats_pet5","item_stats_pet6","item_dmg_pet","item_dmg_pet2","item_dmg_pet3","item_dmg_pet4","item_dmg_pet5","item_dmg_pet6","item_str_50","item_int_50","item_agi_50","item_asdasdasdsa"}
	for _, items in pairs(itemlist) do 
		if keys.itemname == items then
			quest = quest + 1
		end
	end
end

--------------------------------------------------------------------------------------------------------------

function CAddonAdvExGameMode:RuneSpawnFilter(kv)
	t = {0,1,2,4,5,6}
	kv.rune_type = t[RandomInt(1,#t)]
	return true
end

function CAddonAdvExGameMode:BountyFilter( kv )
	local hero = PlayerResource:GetSelectedHeroEntity(kv.player_id_const)
	kv.gold_bounty = 100
	return true
end

--------------------------------------------------------------------------------------------------------------

function CAddonAdvExGameMode:OnGameStateChanged()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		for i=0, DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:IsValidPlayer(i) then
				if PlayerResource:HasSelectedHero(i) == false then
					local player = PlayerResource:GetPlayer(i)
					player:MakeRandomHeroSelection()
				end
			end
		end
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		
	_G.ItemsKV = LoadKeyValues("scripts/npc/npc_items_sets.txt")
	local result = {}
	for itemName, itemValues in pairs(_G.ItemsKV) do
		if itemValues.AbilitySpecial then
			local itemResult = {}
			for _, values in pairs(itemValues.AbilitySpecial) do
				for key, value in pairs(values) do
					if key ~= "var_type" then
				
						if itemResult[key] == nil  then
							itemResult[key] = {}
						end
						table.insert(itemResult[key], value)
					end
				end
			end
			result[itemName] = itemResult
		end
	end
	CustomNetTables:SetTableValue("items_sets", "items", { json = json.encode(result)})
		
	rules:init()
		Timers:CreateTimer(60, function()
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
				if PlayerResource:HasSelectedHero( nPlayerID ) then
					local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
					hero:AddExperience(1, DOTA_ModifyXP_Unspecified, false, false)
					end
				end
			return 60
		end)
	end
end

--------------------------------------------------------------------------------------------------

function prt(t)
	GameRules:SendCustomMessage(''..t,0,0)
end

--------------------------------------------------------------------------------------------------------------

function CheckCheatMode()
	if IsInToolsMode() then
		return 
	end
	if GameRules:IsCheatMode() then
		if steamID == 393187346 then
			GameRules:SendCustomMessage("This Match is in <font color='#FF0000'>Admin Mode</font>!", 0, 0)
		else 
			GameRules:SendCustomMessage("This Match is in <font color='#FF0000'>Cheat Mode! END GAME!</font>", 0, 0)
			-- GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		end
	end
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_check_set", "items/set_items/check_set", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_player_exp", "modifiers/modifier_player_exp", LUA_MODIFIER_MOTION_NONE )
all_skills = {"str","agi","int","hpr","mpr","movespeed","armor","mresist","exp","cooldown","damage","attack_speed","evasion","spellamp"}

function CAddonAdvExGameMode:OnNPCSpawned(data)
	npc = EntIndexToHScript(data.entindex)
	if npc:IsRealHero() and npc.bFirstSpawned == nil and not npc:IsIllusion() and not npc:IsTempestDouble() and not npc:IsClone() and npc:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		npc.bFirstSpawned = true
		-- CheckCheatMode()
		SendToServerConsole("dota_max_physical_items_purchase_limit " .. 9999)	
		
		local playerID = npc:GetPlayerID()
		local sid = PlayerResource:GetSteamAccountID(playerID)
		print(sid)
		print(sid)
		
		npc:AddNewModifier(npc, nil, "modifier_check_set", {} )
		for _, items in pairs(Shop.pShop[sid][4]) do
			if items.type == "effect" and items.active then
				local modifierName = "modifier_" .. items.itemname
				LinkLuaModifier(modifierName, "effects/" .. items.itemname, LUA_MODIFIER_MOTION_NONE)
				npc:AddNewModifier(npc, nil, modifierName, {})
				items.status = 'takeoff'
			end
		end
		for skill, key in pairs(Account_stats[sid]) do
			for _, items in pairs(all_skills) do 
				if skill == items then
					LinkLuaModifier( "modifier_"..skill, "abilities/skill/modifier_"..skill, LUA_MODIFIER_MOTION_NONE )
					npc:AddNewModifier( npc, nil, "modifier_"..skill, {} ):SetStackCount(key)
				end
			end
		end	
		if Shop.pShop[sid].ban_status then 
			LinkLuaModifier( "modifier_ban", "modifiers/modifier_ban", LUA_MODIFIER_MOTION_NONE )
			npc:AddNewModifier( npc, nil, "modifier_ban", {} )
		end
		local count = CAddonAdvExGameMode:ExpPlayerModifier()
		print(count)
		print(type(count))
		npc:AddNewModifier( npc, nil, "modifier_player_exp",{}):SetStackCount(count)
		
		if npc:GetUnitName() == 'npc_dota_hero_rubick' then
			local abil = npc:FindAbilityByName('hero_rubick_ability')
			if abil then
				Timers:CreateTimer(3, function()
					print(abil:GetLevel(), 'level')
					abil:SetLevel(1)
				end)
			end
		end
	end
	if npc:IsRealHero() and not npc:IsIllusion() and not npc:IsTempestDouble() and not npc:IsClone()then
		self._defeatcounter = 5
	end
end


function CAddonAdvExGameMode:ExpPlayerModifier()
	local values = {60, 70, 80, 90, 100}
	count = 0
	for nPlayerID = 0, DOTA_MAX_PLAYERS - 1 do
		if PlayerResource:IsValidPlayer(nPlayerID) then
		local connectState = PlayerResource:GetConnectionState(nPlayerID)	
			if bot(nPlayerID) or connectState == DOTA_CONNECTION_STATE_ABANDONED or connectState == DOTA_CONNECTION_STATE_FAILED or connectState == DOTA_CONNECTION_STATE_UNKNOWN then print("player leave") else
				count = count + 1
			end
		end
	end
	return values[count]
end

-- function custom_ability_game(hero)
	-- for i = 0, hero:GetAbilityCount() - 1 do
		-- local ability = hero:GetAbilityByIndex(i)
		-- if ability and not ability:IsNull() then
			-- local name_ability = ability:GetName()
			-- if not ability:IsAttributeBonus() then
				-- hero:RemoveAbilityByHandle(ability)
			-- end
		-- end
	-- end
	-- hero:AddAbility("ability_slot_1")
	-- hero:AddAbility("ability_slot_2")
	-- hero:AddAbility("ability_slot_3")
	-- hero:AddAbility("ability_slot_4")
	-- hero:AddAbility("generic_hidden")
	-- hero:AddAbility("ability_slot_5")
	-- hero:AddItemByName("item_ability_1")
	-- hero:AddItemByName("item_ability_1")
	-- hero:AddItemByName("item_ability_1")
	-- hero:AddItemByName("item_ability_ult")
	-- hero:SetAbilityPoints(1)
-- end

function CAddonAdvExGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	
	self:_CheckForDefeat()
	
	local itemlist = {"item_polarized_plate", "item_preserved_skull", "item_health_bag_2","item_gravel_foot","item_plague_staff","item_winter_embrace","item_unhallowed_icon",
	"item_sign_of_the_arachnid","item_carapace_of_qaldin","item_paw_of_lucius","item_creed_of_omniscience","item_pelt_of_the_old_wolf","item_longclaws_amulet","item_bogduggs_baldric",
	"item_custom_rapier","item_ticket2","item_epx_aura","item_krest","item_mp_bag","item_willful_resonance","item_dmg_aura","item_str","item_agi","item_int","item_random_stat",
	"item_talisman_of_ambition","item_life_catcher","item_magic_plate","item_allfour","item_paw","item_avernos_mist","item_sboots","item_chest_d","item_armor_pet",
	"item_armor_pet2","item_armor_pet3","item_armor_pet4","item_armor_pet5","item_armor_pet6","item_attackspeed_pet","item_attackspeed_pet2","item_attackspeed_pet3",
	"item_attackspeed_pet4","item_attackspeed_pet5","item_attackspeed_pet6","item_spell_pet","item_spell_pet2","item_spell_pet3","item_spell_pet4","item_spell_pet5",
	"item_spell_pet6","item_hpmp_pet","item_hpmp_pet2","item_hpmp_pet3","item_hpmp_pet4","item_hpmp_pet5","item_hpmp_pet6","item_stats_pet","item_stats_pet2","item_stats_pet3",
	"item_stats_pet4","item_stats_pet5","item_stats_pet6","item_dmg_pet","item_dmg_pet2","item_dmg_pet3","item_dmg_pet4","item_dmg_pet5","item_dmg_pet6","item_str_50","item_int_50","item_agi_50","item_asdasdasdsa"}
	
		for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
				if PlayerResource:HasSelectedHero( nPlayerID ) then
					local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
					for _, items in pairs(itemlist) do 
						local Key = hero:FindItemInInventory( items )
						if Key ~= nil then
							quest = quest + 1
						end 
					end
				end
			end
		end
	end
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_TEAM_SHOWCASE then
        for i = 0, DOTA_MAX_PLAYERS-1 do
            local hPlayer = PlayerResource:GetPlayer(i)
            if PlayerResource:IsValidPlayerID(i) and hPlayer and not PlayerResource:HasSelectedHero(i) then
                hPlayer:MakeRandomHeroSelection()
            end
        end
    end
	return 1
end

function CAddonAdvExGameMode:_CheckForDefeat()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if are_all_heroes_dead() and not self._ischeckingdefeat then
			Timers:RemoveTimer("defeat")
            Timers:CreateTimer("defeat", {
            useGameTime = true,
            endTime = 0.5,
            callback = function()
			self._ischeckingdefeat = true
			if self._defeatcounter > 0 then
				if are_all_heroes_dead() then
					Notifications:TopToAll({text=self._defeatcounter,style={color="red",["font-size"]="70px"}, duration=1})
				end
				self._defeatcounter = self._defeatcounter - 1
				return 1
			else 
				if are_all_heroes_dead() then
					for playerID = 0, 4 do
						Shop:add_pr(0,0,0,0,2,playerID, "lose")
					end
					GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
				else
					self._defeatcounter = 5
					self._ischeckingdefeat = false
					return nil
				end
			end
			end})					
		end
	end
end

function are_all_heroes_dead()
	for playerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
		if PlayerResource:HasSelectedHero(playerID) then
			local hero = PlayerResource:GetSelectedHeroEntity(playerID)
			if hero and hero:IsAlive() or hero:HasModifier("modifier_aegis") or hero:IsReincarnating() then
				return false
			end
		end
	end
	return true
end

golz = 0;
gol = 0;
zom = 0;
_G.golf = 0;
necr = 0;
zone_10_units = 0

local goldTable = {
    ["forest_fat_zombie"] = 25,
    ["npc_dota_creature_dire_hound"] = 30,
    ["npc_dota_creature_dire_hound_boss"] = 140,
    ["npc_dota_creature_small_hellbear"] = 100,
    ["npc_dota_creature_hellbear"] = 175,
    ["satyr_soulstealer"] = 100,
    ["satyr_hellcaller"] = 175,
    ["tusk"] = 110,
    ["npc_creep_crystal"] = 215,
    ["apparat"] = 160,
    ["npc_dota_creature_large_ogre_seal"] = 280,
    ["mirana"] = 180,
    ["white_walker"] = 160,
    ["icespider"] = 170,
    ["undying"] = 190,
    ["tank"] = 150,
    ["npc_trap_visage"] = 130,
    ["npc_slardar_unit"] = 140,
    ["npc_blob"] = 120,
    ["morf"] = 80,
    ["npc_shaker"] = 130,
    ["npc_zone_jungle_1"] = 120,
    ["npc_zone_jungle_2"] = 100,
    ["npc_zone_jungle_3"] = 80,
    ["npc_zone_jungle_4"] = 100,
    ["small_hellbear"] = 145,
    ["miner"] = 120,
    ["npc_keeper_of_the_light"] = 135,
    ["treant"] = 140,
    ["encha"] = 125,
    ["npc_lifestealer"] = 175,
    ["batr"] = 175,
    ["warlock"] = 155,
    ["demon"] = 115,
    ["npc_venom_creep"] = 115,
    ["pudge"] = 135,
    ["npc_dota_creature_spider_small"] = 30,
    ["npc_invoker_creep"] = 280,
    ["npc_mars_creep"] = 300,
    ["npc_phoenix_creep"] = 270,
}

local goldUnitNames = {
    "GoldenMiner", "GoldenQueen", "GoldenWyvern", "GoldenSea", "GoldenDragon", "GoldenForest",
    "GoldenMiner1", "GoldenQueen1", "GoldenWyvern1", "GoldenSea1", "GoldenDragon1", "GoldenForest1"
}

function HandleKilledUnit(killed_unit, killer, add_rp, add_exp, add_rating, win_status, boss, guild_exp, unit_name)
if GameRules:IsCheatMode() then return end
    local heroes = FindUnitsInRadius(killer:GetTeamNumber(), killed_unit:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_DEAD,
        FIND_ANY_ORDER, false)
    for _, hero in pairs(heroes) do
        local pid = hero:GetPlayerID()
		
		guilds:add_guild_exp(pid, guild_exp)
        Shop:add_pr(add_rp, add_exp, add_rating, win_status, boss, pid, unit_name)
    end
	if boss ~= 0 then
		respawn_heroes()
	end
end

function CAddonAdvExGameMode:OnEntityKilled( keys )
    local killed_unit = EntIndexToHScript( keys.entindex_killed )
    local killer = EntIndexToHScript( keys.entindex_attacker )
	if killed_unit and killed_unit:IsRealHero() then
		local newItem = CreateItem( "item_tombstone", killed_unit, killed_unit )
		newItem:SetPurchaseTime(0)
		newItem:SetPurchaser(killed_unit)
		local tombstone = SpawnEntityFromTableSynchronous( "dota_item_tombstone_drop", {} )
		tombstone:SetContainedItem( newItem )
		tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
		FindClearSpaceForUnit( tombstone, killed_unit:GetAbsOrigin(), true )	
	end
--------------------------------------------------------------------------------------------
if killed_unit:GetUnitName() == "roshan_npc"  then
	local roshan = killed_unit
	Timers:CreateTimer(RandomInt(300,480), function()
		local ent = Entities:FindByName( nil, "roshan_npc_point")
		local point = ent:GetAbsOrigin()
		roshan:SetAbsOrigin( point )
		FindClearSpaceForUnit(roshan, point, false)
		roshan:Stop()
		roshan:RespawnUnit()			
		roshan:SetBaseDamageMin(roshan:GetBaseDamageMin() * 1.6)
		roshan:SetBaseDamageMax(roshan:GetBaseDamageMax() * 1.6)
		roshan:SetPhysicalArmorBaseValue(roshan:GetPhysicalArmorBaseValue() * 1.6)
		roshan:SetBaseMagicalResistanceValue(roshan:GetBaseMagicalResistanceValue() * 1.3)
		roshan:SetMaxHealth(roshan:GetMaxHealth() * 1.6)
		roshan:SetBaseMaxHealth(roshan:GetBaseMaxHealth() * 1.6)
		roshan:SetHealth(roshan:GetMaxHealth()* 1.6)		
			
		if roshan:GetBaseMagicalResistanceValue() >= 99 then
			roshan:SetBaseMagicalResistanceValue(99)
		end
	end)
end	

-------------------------------------------------------------------------------------------
				
if killed_unit:GetUnitName() == "troll_high_priest" then
	gol = gol + 1;
	if gol >= 11 then
		CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id =11})
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
				if PlayerResource:HasSelectedHero( nPlayerID ) then
					local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
					local gold = 200 
					hero:ModifyGold( gold, true, 0 )
					SendOverheadEventMessage(hero, OVERHEAD_ALERT_GOLD, hero, gold, nil)
					hero:EmitSound("Item.LotusOrb.Activate")
				end
			end
		end
    else
		CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 11, current=gol, id =11})
	end
end
	
---------------------------------------------------------------------------мелкий зомби
if killed_unit:GetUnitName() == "forest_zombie" or killed_unit:GetUnitName() == "skeleton" then
	zom = zom + 1;
	local gold_reward = 35
	if killed_unit:GetUnitName() == "forest_zombie" then
		gold_reward = 45
	end
	local heroes = FindUnitsInRadius(killer:GetTeamNumber(), killed_unit:GetAbsOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO,  DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false ) 
		for i = 1, #heroes do
            local gold = gold_reward * ((100 - (5-#heroes)*10)*0.01)/#heroes		
            local playerID = heroes[i]:GetPlayerID()
            local player = PlayerResource:GetSelectedHeroEntity(playerID )
            player:ModifyGold( gold, true, 0 )
            SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player, gold, nil)
        end
	if zom >= 150 then
		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			if PlayerResource:HasSelectedHero(i) then
				local gold = 350 
				local player = PlayerResource:GetSelectedHeroEntity(i)
				player:ModifyGold( gold, true, 0 )
				SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player, gold, nil) 
				local hRelay = Entities:FindByName( nil, "zombielogic" )
				hRelay:Trigger(nil,nil)
				player:EmitSound("Item.LotusOrb.Activate")
			end
		end
		zom = 0;
		rules:boss_invulnerable("boss_undying")
		CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id =12})	
	else
		CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 150, current=zom, id =12})
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
local unitName = killed_unit:GetUnitName()
if goldTable[unitName] then
	local heroes = FindUnitsInRadius(killer:GetTeamNumber(), killed_unit:GetAbsOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO,  DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + 		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false ) 
	for i = 1, #heroes do
		local gold = goldTable[unitName]*((100 - (5-#heroes)*10)*0.01)/#heroes		
		local playerID = heroes[i]:GetPlayerID()
		local player = PlayerResource:GetSelectedHeroEntity(playerID )
		player:ModifyGold( gold, true, 0 )
		SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player, gold, nil)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------		
if killed_unit:GetUnitName() == "npc_gyro" or killed_unit:GetUnitName() == "npc_enigma" or killed_unit:GetUnitName() == "npc_sniper" or killed_unit:GetUnitName() == "npc_disruptor" then
	zone_10_units = zone_10_units + 1 
	local heroes = FindUnitsInRadius(killer:GetTeamNumber(), killed_unit:GetAbsOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false ) 
	for i = 1, #heroes do
		local gold = 200*((100 - (5-#heroes)*10)*0.01)/#heroes		
		local playerID = heroes[i]:GetPlayerID()
		local player = PlayerResource:GetSelectedHeroEntity(playerID )
		player:ModifyGold( gold, true, 0 )
		SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player, gold, nil)
	end
	if zone_10_units >= 104 then
		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			if PlayerResource:HasSelectedHero(i) then
				local gold = 500 
				local player = PlayerResource:GetSelectedHeroEntity(i)
				player:ModifyGold( gold, true, 0 )
				SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player, gold, nil) 
				local hRelay = Entities:FindByName( nil, "arc_logic" )
				hRelay:Trigger(nil,nil)
				player:EmitSound("Item.LotusOrb.Activate")
			end
		end
		zone_10_units = 0;
		CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id =7721})
		rules:boss_invulnerable("npc_boss_arc")
	else
		CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 104, current = zone_10_units, id =7721})
	end
end
-------------------------------------------------------------------miner
if killed_unit:GetUnitName() == "npc_forest" then
	golf = golf + 1;
	if golf >= 3 then
		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			if PlayerResource:HasSelectedHero(i) then
				local hero = PlayerResource:GetSelectedHeroEntity(i)
				local gold = 400 
				hero:ModifyGold( gold, true, 0 )		
				SendOverheadEventMessage(hero, OVERHEAD_ALERT_GOLD, hero, gold, nil)      
				hero:EmitSound("Item.LotusOrb.Activate")
			end
		end
		CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id = 999})
	end
end
---------------------------------------------------------------------------GOLDEN
if table.contains(goldUnitNames, killed_unit:GetUnitName()) then
    HandleKilledUnit(killed_unit, killer, 0, 0, 0, 0, 0, 0, killed_unit:GetUnitName())
end
---------------------------------------------------------------------------URSA    
if killed_unit:GetUnitName() == "npc_dota_creature_big_bear"  then
	HandleKilledUnit(killed_unit, killer, 0, 5, 1, 0, 1, 1, killed_unit:GetUnitName())
end
 -------------------------------------------------------------------zombie
if killed_unit:GetUnitName() == "boss_undying" then
	HandleKilledUnit(killed_unit, killer, 0, 10, 2, 0, 1, 2, killed_unit:GetUnitName())
end
 --------------------------------------------------------------------lich
if killed_unit:GetUnitName() == "lich" then
	HandleKilledUnit(killed_unit, killer, 0, 15, 3, 0, 1, 3, killed_unit:GetUnitName())
end
 ----------------------------------------------------------------tiny
if killed_unit:GetUnitName() == "npc_dota_creature_storegga" then
	HandleKilledUnit(killed_unit, killer, 0, 20, 4, 0, 1, 4, killed_unit:GetUnitName())
end
 ---------------------------------------------------------------------nyx
if (killed_unit:GetUnitName() == "NYX" or killed_unit:GetUnitName() == "NYX_2") then 
	HandleKilledUnit(killed_unit, killer, 2, 15, 5, 0, 1, 2, killed_unit:GetUnitName())
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if not hero:IsAlive() then
						local point = hero:GetAbsOrigin()
						local hRelay = Entities:FindByName( nil, "logic_teleport" )
						hRelay:Trigger(nil,nil)	
						hero:RespawnHero(false, false)
						hero:SetAbsOrigin( point )
						FindClearSpaceForUnit(hero, point, false) 
						hero:Stop() 
				end
				hero:SetHealth( hero:GetMaxHealth() )
				hero:SetMana( hero:GetMaxMana() )
				hero:EmitSound("Hero_Omniknight.GuardianAngel.cast")
				hero:AddNewModifier( hero, nil, "modifier_omninight_guardian_angel", { duration = 2.5 } )
			end
		end
	end
end
-------------------------------------------------------------------slardar
if killed_unit:GetUnitName() == "npc_boss_slardar" then
	HandleKilledUnit(killed_unit, killer, 3, 25, 6, 0, 1, 5, killed_unit:GetUnitName())
	CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id = 31})
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then		 		
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				hero:EmitSound("Item.LotusOrb.Activate")
				local gold = 400 
				hero:ModifyGold( gold, true, 0 )
				SendOverheadEventMessage(hero, OVERHEAD_ALERT_GOLD, hero, gold, nil)
				if not hero:IsAlive() then
					local point = hero:GetAbsOrigin()
					local hRelay = Entities:FindByName( nil, "logic_teleport" )
					hRelay:Trigger(nil,nil)	
					hero:RespawnHero(false, false)
					hero:SetAbsOrigin( point )
					FindClearSpaceForUnit(hero, point, false) 
					hero:Stop() 
				end
			end
		end
	end
end
 -------------------------------------------------------------------monkey
if killed_unit:GetUnitName() == "npc_boss_monkey_king" then
	HandleKilledUnit(killed_unit, killer, 4, 30, 6, 0, 1, 6, killed_unit:GetUnitName())
	CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id = 931})
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then		 		
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				hero:EmitSound("Item.LotusOrb.Activate")
				local gold = 400 
				hero:ModifyGold( gold, true, 0 )
				SendOverheadEventMessage(hero, OVERHEAD_ALERT_GOLD, hero, gold, nil)
				if not hero:IsAlive() then
					local point = hero:GetAbsOrigin()
					local hRelay = Entities:FindByName( nil, "logic_teleport" )
					hRelay:Trigger(nil,nil)	
					hero:RespawnHero(false, false)
					hero:SetAbsOrigin( point )
					FindClearSpaceForUnit(hero, point, false) 
					hero:Stop() 
				end
			end
		end
	end
end

---------------------------------------------------------------furion
if killed_unit:GetUnitName() == "npc_boss_fura" then
	HandleKilledUnit(killed_unit, killer, 5, 35, 7, 0, 1, 7, killed_unit:GetUnitName())
end
 -----------------------------------------------------------doom
if killed_unit:GetUnitName() == "Lord" then
	HandleKilledUnit(killed_unit, killer, 6, 40, 8, 0, 1, 8, killed_unit:GetUnitName())
end
 -----------------------------------------------------------medusa
if killed_unit:GetUnitName() == "medusa" then
	HandleKilledUnit(killed_unit, killer, 7, 45, 9, 0, 1, 9, killed_unit:GetUnitName())
end

---------------------------------------------------------------arc
if killed_unit:GetUnitName() == "npc_boss_arc" then
	HandleKilledUnit(killed_unit, killer, 8, 50, 9, 0, 1, 10, killed_unit:GetUnitName())
end
--------------------------------------------------------------------снега
if killed_unit:GetUnitName() == "npc_snow" or killed_unit:GetUnitName() == "npc_snow2" or killed_unit:GetUnitName() == "npc_snow3" then
	GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
end
----------------------------------------------------------------------боссы
if killed_unit:GetUnitName() == "npc_dota_creature_snow" then
	HandleKilledUnit(killed_unit, killer, 3, 20, 5, 0, 1, 5, killed_unit:GetUnitName())
end

if killed_unit:GetUnitName() == "npc_dota_creature_gaven_the_brute" then
	HandleKilledUnit(killed_unit, killer, 3, 20, 5, 0, 1, 5, killed_unit:GetUnitName())
end

if killed_unit:GetUnitName() == "npc_xdes" and not GameRules:IsCheatMode() then
	HandleKilledUnit(killed_unit, killer, 5, 50, 10, 0, 1, 5, killed_unit:GetUnitName())
end
----------------------------------------------------------------------боксы
if killed_unit:GetUnitName() == "npc_dota_crate" then
	if RandomInt(0, 1) == 1 then
		killer:EmitSound( "Dungeon.SmashCrateShort")
	else
		killer:EmitSound( "Dungeon.SmashCrateLong")
	end
end
---------------------------------------------------------------------------------
if killed_unit:GetUnitName() == "necrolyte" and not GameRules:IsCheatMode() then
	HandleKilledUnit(killed_unit, killer, 10, 50, 25, 1, 1, 11, killed_unit:GetUnitName())
	if quest == 0 then
		prt('#check2')
	end		
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if not hero:IsAlive() then
					local point = hero:GetAbsOrigin()
					local hRelay = Entities:FindByName( nil, "logic_teleport" )
					hRelay:Trigger(nil,nil)	
					hero:RespawnHero(false, false)
					hero:SetAbsOrigin( point )
					FindClearSpaceForUnit(hero, point, false) 
					hero:Stop() 
				end
				hero:AddNewModifier( hero, nil, "modifier_stunned", {})
				hero:AddNewModifier( hero, nil, "modifier_invulnerable", {})
				EmitGlobalSound("tutorial_rockslide")
			end
		end
	end	
	Notifications:TopToAll({text="#win", duration=5})
	Timers:CreateTimer(6, function()
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end)
end

if killed_unit:GetUnitName() == "obelisk" then
	golz = golz + 1;
	if golz >= 5 then
		CustomGameEventManager:Send_ServerToAllClients("quest_remove_quest", {id =21})
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
				if PlayerResource:HasSelectedHero( nPlayerID ) then
					local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
					local gold = 1000 
					hero:ModifyGold( gold, true, 0 )
					SendOverheadEventMessage(hero, OVERHEAD_ALERT_GOLD, hero, gold, nil)
					hero:EmitSound("Item.LotusOrb.Activate")
				end
			end
		end
    else
		CustomGameEventManager:Send_ServerToAllClients("quest_update_quest", { max = 5, current=golz, id =21})
	end
end
end

function respawn_heroes()
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				boss_reward:show({PlayerID = nPlayerID})
				if not hero:IsAlive() then
					local point = hero:GetAbsOrigin()
					local hRelay = Entities:FindByName( nil, "logic_teleport" )
					hRelay:Trigger(nil,nil)	
					hero:RespawnHero(false, false)
					hero:SetAbsOrigin( point )
					FindClearSpaceForUnit(hero, point, false) 
					hero:Stop() 
				end
				hero:SetHealth( hero:GetMaxHealth() )
				hero:SetMana( hero:GetMaxMana() )
				hero:EmitSound("Hero_Omniknight.GuardianAngel.cast")
				hero:AddNewModifier( hero, nil, "modifier_omninight_guardian_angel", { duration = 2.5 } )
			end
		end
	end
end