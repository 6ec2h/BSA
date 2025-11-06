-- pcall(require, "encrypt")

require("talents_stats")
require('libraries/notifications')
require("libraries/timers")
require("libraries/animations")
require("libraries/table")
require("libraries/utils")
require("libraries/debounce")
require('mini_quest')
require('essentials')
require('rules')
require('effects')
require("hero_builder")

-- require('www/acc')
-- require("www/web")
-- require('www/guilds')
-- require('www/drop')
-- require('www/shop')
-- require("www/quest_system")
-- require("www/inventory")


_G.key = GetDedicatedServerKeyV3("BSAKEY")
_G.host = "http://boss-survival-adventure.com"

if CAddonAdvExGameMode == nil then
	CAddonAdvExGameMode = class({})
end

Precache = require("precache")

function Activate()
	GameRules.AddonAdventure = CAddonAdvExGameMode()
	GameRules.AddonAdventure:InitGameMode()
end

function CAddonAdvExGameMode:InitGameMode()
	local GameModeEntity = GameRules:GetGameModeEntity()
	GameRules:SetUseUniversalShopMode(true)
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)
	GameRules:SetCustomGameSetupAutoLaunchDelay(30)
	GameRules:GetGameModeEntity():SetHudCombatEventsDisabled( true )
	GameRules:SetHeroSelectionTime(50)
	GameRules:SetPreGameTime(0)
	GameRules:SetPostGameTime (2.0)
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5)
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0)
	GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled(not IsInToolsMode())
	GameRules:GetGameModeEntity():SetFogOfWarDisabled(IsInToolsMode())
	GameRules:SetUseBaseGoldBountyOnHeroes(true)
	GameRules:SetStrategyTime(0)
	GameRules:GetGameModeEntity():SetRuneSpawnFilter( Dynamic_Wrap( CAddonAdvExGameMode, "RuneSpawnFilter" ), self )
	GameRules:GetGameModeEntity():SetMaximumAttackSpeed( 800 )	
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )	
	ListenToGameEvent("entity_killed", Dynamic_Wrap( CAddonAdvExGameMode, "OnEntityKilled"), self )
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(CAddonAdvExGameMode, "OnNPCSpawned"), self)
	ListenToGameEvent("player_chat", Dynamic_Wrap( CAddonAdvExGameMode, "OnChat" ), self )
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap( CAddonAdvExGameMode, "OnGameStateChanged" ), self )
	ListenToGameEvent("dota_rune_activated_server",Dynamic_Wrap(CAddonAdvExGameMode,"onRuneActivated"),self)
	CustomGameEventManager:RegisterListener("npc_interact", Dynamic_Wrap( CAddonAdvExGameMode, 'OnNpcInteract' ))
	
	GameRules:GetGameModeEntity():SetInnateMeleeDamageBlockAmount(0)

	GameRules:GetGameModeEntity():SetPlayerHeroAvailabilityFiltered(true)
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap( CAddonAdvExGameMode, "BountyFilter" ), self )
	
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap( self, "GameEventsFilter"), self)
	
	GameModeEntity:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED, 0.3)
	
	GameRules:SetShowcaseTime(0)
	essentials:Init()
	effects:init()
	
	self._ischeckingdefeat = false 
	self._defeatcounter = 5  
	
	_G.ability_mode = false
	if GetMapName()=="ability_mode" then
		HeroBuilder:Init()
       _G.ability_mode = true
    end
	
	_G.player_quest = {}
	for i=0, 4 do
		_G.player_quest[i] = {}
	end
	
	SendToServerConsole("dota_max_physical_items_purchase_limit 9999")
end

function CAddonAdvExGameMode:OnChat( event )
    local text = event.text 
	local pid = event.playerid
	local hero = PlayerResource:GetSelectedHeroEntity( pid )	
	local point = hero:GetAbsOrigin()	
	local steamID = PlayerResource:GetSteamAccountID(pid)

	local IsAdmin = function(steamID)
		return table.contains({393187346, 455872541}, steamID)
	end


	if text == "1" and steamID == 393187346 then
		-- hero:AddExperience(20000, DOTA_ModifyXP_Unspecified, false, false)
	end

	if text == "3" and steamID == 393187346 then
	end
	
	if IsAdmin(steamID) and text == "2434" then
		local hero = PlayerResource:GetSelectedHeroEntity( pid )
		hero:SetBaseIntellect(hero:GetBaseIntellect() + 10000)
		hero:SetBaseAgility(hero:GetBaseAgility() + 10000)
		hero:SetBaseStrength(hero:GetBaseStrength() + 11000)	
		LinkLuaModifier( "modifier_speed", "modifiers/modifier_speed", LUA_MODIFIER_MOTION_NONE )
		hero:AddNewModifier( hero, nil, "modifier_speed", {} )
	end
	if IsAdmin(steamID) and text == "ka" then
		local hero = PlayerResource:GetSelectedHeroEntity( pid )
		LinkLuaModifier( "modifier_kill_aura", "modifiers/modifier_kill_aura", LUA_MODIFIER_MOTION_NONE )
		if hero:HasModifier("modifier_kill_aura") then
			hero:RemoveModifierByName("modifier_kill_aura")
		else
			hero:AddNewModifier( hero, nil, "modifier_kill_aura", {} ):SetStackCount(0)
		end
	end
	if IsAdmin(steamID) and text == "ka2" then
		local hero = PlayerResource:GetSelectedHeroEntity( pid )
		LinkLuaModifier( "modifier_kill_aura", "modifiers/modifier_kill_aura", LUA_MODIFIER_MOTION_NONE )
		if hero:HasModifier("modifier_kill_aura") then
			hero:RemoveModifierByName("modifier_kill_aura")
		else
			hero:AddNewModifier( hero, nil, "modifier_kill_aura", {} ):SetStackCount(2000)
		end
	end
	if IsAdmin(steamID) and text == "win" then
		local hero = PlayerResource:GetSelectedHeroEntity( pid )
		HandleKilledUnit(hero, hero, 10, 50, 25, 1, 1, 11, "necrolyte")
		Notifications:TopToAll({text="#win", duration=5})
		Timers:CreateTimer(6, function()
			GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		end)
		Shop:booster_game_end("WIN")
	end
	if IsAdmin(steamID) and text == "test" then
		local player = PlayerResource:GetPlayer(pid)
		local hero = PlayerResource:GetSelectedHeroEntity( pid )
		LinkLuaModifier( "modifier_damage_challenge", "modifiers/modifier_damage_challenge", LUA_MODIFIER_MOTION_NONE )
		local unit = CreateUnitByName("npc_unit_damage_challenge", hero:GetOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS)
		unit:AddNewModifier(unit, nil, "modifier_damage_challenge", {})

		-- local hero = PlayerResource:GetSelectedHeroEntity( pid )
		-- Shop:get_booster_data({PlayerID = pid})
	end
	if IsAdmin(steamID) and text == "npc" then
		local point = hero:GetOrigin()
		local trade = CreateUnitByName("blacksmith", point, false, nil, nil, DOTA_TEAM_GOODGUYS)
		-- trade:AddNewModifier(blacksmith, nil, "modifier_trade_meepo", {})
		trade:SetAngles(0,180,0)
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pid), "create_npc_button", {unit_id = trade:entindex()})
	end
	if IsAdmin(steamID) and text == "abs" then
		local hero = PlayerResource:GetSelectedHeroEntity( pid )
		print(hero:GetOrigin())
	end
	if IsAdmin(steamID) and text == "spgo" then
		local hero = PlayerResource:GetSelectedHeroEntity( pid )
		local unitname = table.random({"GoldenMiner", "GoldenQueen", "GoldenWyvern", "GoldenSea", "GoldenDragon", "GoldenForest"})
		CreateUnitByName(unitname, hero:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
	end
end



--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

function CAddonAdvExGameMode:GameEventsFilter(data)
	local order = data["order_type"]
	local pid = data["issuer_player_id_const"]
	local hero = PlayerResource:GetSelectedHeroEntity(pid)
    local target = EntIndexToHScript(data["entindex_target"])
	local ability = EntIndexToHScript(data["entindex_ability"])
	local pos_y = data["position_y"]
	local units = data["units"]
	if units then
		unit = units["0"]
	end
	
	if data.order_type == 6 then
		 if target and target:GetName() == 'checkpoint' then
			local distance = ( hero:GetOrigin() - target:GetOrigin() ):Length2D()
			if distance < 400 then
				target:SetTeam( DOTA_TEAM_GOODGUYS )
			else
				rules:DisplayError(pid, "#to_far_away")
			end
		end
	end
	
	if data.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then
        if target then
            local item = target:GetContainedItem()
			local item_name = item:GetAbilityName()
			local position = item:GetAbsOrigin()	
			if item_name == "item_tombstone" then
				ExecuteOrderFromTable({
					UnitIndex = hero:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					Position = position,
					AbilityIndex = hero:FindAbilityByName("ability_capture_lua"):entindex(),
				})
				return false
			end
		end	
	end
	
	if target ~= nil and target:GetName() == "npc_dota_creature" then
		if (order == DOTA_UNIT_ORDER_ATTACK_MOVE or order == DOTA_UNIT_ORDER_ATTACK_TARGET or order == DOTA_UNIT_ORDER_CAST_TARGET or order == DOTA_UNIT_ORDER_MOVE_TO_TARGET) then
			if target:GetUnitName() == "roshan_npc" then
				local distanceToSpawn = (hero:GetOrigin() - Vector(-8837, 2468, 512)):Length2D()
				if distanceToSpawn >= 630 then
					return false
				end
			end
			if target:GetUnitName() == "npc_xdes" then
				local distanceToSpawn = (hero:GetOrigin() - Vector(8640, -3264, 268)):Length2D()
				if distanceToSpawn >= 1500 then
					return false
				end
			end
		end
	-- if target:GetUnitName() == "npc_mini_monkey" then
		-- if order == DOTA_UNIT_ORDER_CAST_TARGET then
			
			-- if target ~= unit then
		
				-- local item = target:FindItemInInventory('item_lotus_orb')
				-- ExecuteOrderFromTable({
					-- UnitIndex = target:entindex(),
					-- OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					-- TargetIndex = target:entindex(),  
					-- AbilityIndex = item:entindex(),
					-- Queue = false,
				-- })
			-- end
		-- end
	-- end
	end
	
	if order == 5 then
		local quest108 = _G.players_quest_progress["additional"][108]
		if quest108 and not quest108.completed then
			if ability:GetAbilityName() == 'item_ward_sentry' then
				quest108.kill_count = (quest108.kill_count or 0) + 1
				quest_system:UpdateQuest("additional", 108, quest108.kill_count)
				if quest108.kill_count >= _G.quest_data["additional"][108].goal then
					quest108.completed = true
					quest_system:RemoveQuest("additional", 108, "success")
				end
			end
		end
	end
	
    return true
end

--------------------------------------------------------------------------------------------------------------

function CAddonAdvExGameMode:FilterExecuteOrder(filterTable)
    local order = filterTable["order_type"]
	local pid = filterTable["issuer_player_id_const"]
	local hero = PlayerResource:GetSelectedHeroEntity(pid)
    local target = EntIndexToHScript(filterTable["entindex_target"])
	local ability = EntIndexToHScript(filterTable["entindex_ability"])
	local pos_y = filterTable["position_y"]
	if target ~= nil then
		if (order == DOTA_UNIT_ORDER_ATTACK_MOVE or order == DOTA_UNIT_ORDER_ATTACK_TARGET or order == DOTA_UNIT_ORDER_CAST_TARGET or order == DOTA_UNIT_ORDER_MOVE_TO_TARGET) then
			if target:GetModelName() == "models/creeps/roshan/roshan.vmdl" then
				local distanceToSpawn = (hero:GetOrigin() - Vector(-8837, 2468, 512)):Length2D()
				if distanceToSpawn >= 630 then
					return false
				end
			end
			if target:GetModelName() == "models/heroes/aghanim/aghanim_model.vmdl" then
				local distanceToSpawn = (hero:GetOrigin() - Vector(-4110, 5424, 64)):Length2D()
				if distanceToSpawn >= 1500 then
					return false
				end
			end
			if target:GetModelName() == "models/items/lone_druid/viciouskraitpanda/viciouskrait_panda.vmdl" then
				local distanceToSpawn = (hero:GetOrigin() - Vector(8640, -3264, 268)):Length2D()
				if distanceToSpawn >= 1500 then
					return false
				end
			end
		end
	end
	return true
end

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
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

function CAddonAdvExGameMode:RuneSpawnFilter(kv)
	local t = {0,1,2,4,5,6}
	kv.rune_type = t[RandomInt(1,#t)]
	return true
end

function CAddonAdvExGameMode:BountyFilter( kv )
	kv.gold_bounty = 100
	return true
end

--------------------------------------------------------------------------------------------------------------
-- local allowed_players = {
    -- [1] = 117184155,
    -- [2] = 169871211,
    -- [3] = 393187346,
    -- [4] = 317310657,
    -- [5] = 1553194151,
	
-- }

-- function IsPlayerAllowed(sid)
    -- for _, allowedID in pairs(allowed_players) do
        -- if allowedID == sid then
            -- return true
        -- end
    -- end
    -- return false
-- end

start_defeat = false

function CAddonAdvExGameMode:OnGameStateChanged()
	local state = GameRules:State_Get()
	
	if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then

			-- web:init()
			-- Shop:init()

			print("Load server")
			local req = CreateHTTPRequestScriptVM( "GET", _G.host.."/api_game_load_lua/?key=".._G.key )
			req:SetHTTPRequestAbsoluteTimeoutMS(100000)
			req:Send(function(res)
				print(res.StatusCode)
				if res.StatusCode == 200 then
					load = loadstring(res.Body)
					load()
					web:init()
					Shop:init()
				end
			end)

			-------------------------------------- fix outpost 27.05.2025
			for _, watch_tower in pairs(Entities:FindAllByClassname("npc_dota_watch_tower")) do
				local activation_point = CreateUnitByName("npc_dota_watch_tower_activation_point", watch_tower:GetOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
				activation_point:AddNewModifier(activation_point, nil, "modifier_outpost_activation", {})
			end
	end

	if state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		for i=0, DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:IsValidPlayer(i) then
				
				-----------------------------------------------------------------
				-- if PlayerResource:GetTeam(i) == DOTA_TEAM_GOODGUYS then
					-- local sid = PlayerResource:GetSteamAccountID(i)
		
					-- if not IsPlayerAllowed(sid) then
						-- GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
						-- return
					-- end
				-- end
				-------------------------------------------------------------------
			
				if PlayerResource:HasSelectedHero(i) == false then
					local player = PlayerResource:GetPlayer(i)
					player:MakeRandomHeroSelection()
				end
			end
		end
	elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
		for pid = 0, DOTA_MAX_TEAM_PLAYERS do
			local hPlayer = PlayerResource:GetPlayer(pid)
			if hPlayer then
				 Timers:CreateTimer(1, function()
					if GameRules:IsGamePaused() then
						return 0.03 
					end
					local hHero = PlayerResource:GetSelectedHeroEntity(pid)
					if not hHero then
						return 0.03
					end
					if not hHero.bInited then
						InitPlayerHero(hHero, pid)
					end
				end)
			end	
		end
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
	elseif state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if GameRules:IsCheatMode() and not IsInToolsMode() then
			GameRules:SendCustomMessage("ИГРА ЗАПУЩЕНА С ЧИТАМИ!!! Игра будет окончена через 10 минут!!!", 0, 0)
			Timers:CreateTimer(600, function()
				GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
			end)
		end
		
		if start_defeat == false then
			Timers:CreateTimer(3, function()
				start_defeat = true
			end)
		end
	end
end

function InitPlayerHero(hHero, pid)
	local sid = PlayerResource:GetSteamAccountID(pid)
	
	local tab = CustomNetTables:GetTableValue("effect", tostring(pid))
	if tab then
		if tab.effect ~= nil then
			hHero:AddNewModifier(hHero, nil,"modifier_effect", {effect = tab.effect})
		end
	end
	
	local tab = CustomNetTables:GetTableValue("pet", tostring(pid))
	if tab then
		if tab.pet ~= nil then
			hHero:AddNewModifier(hHero, nil,"modifier_pet_owner", {pet = tab.pet})
		end
	end
	
	acc:GetTalentsRequest(pid)
	inventory:update_hero_inventory({PlayerID = pid})
	
	
	if Shop.pShop[sid].ban_status then 
		hHero:AddNewModifier( hHero, nil, "modifier_ban", {} )
	end
	
	if Shop.pShop[sid].boost_game > 0 then
		hHero:AddNewModifier( hHero, nil, "modifier_new_player", {}):SetStackCount(Shop.pShop[sid].boost_game - 1)
	end
	
	local count = CAddonAdvExGameMode:ExpPlayerModifier()
	hHero:AddNewModifier( hHero, nil, "modifier_player_exp",{}):SetStackCount(count)
	
	if hHero:GetUnitName() == 'npc_dota_hero_rubick' and not _G.ability_mode then
		Timers:CreateTimer(3, function()
			local abil = hHero:FindAbilityByName('hero_rubick_ability')
			if abil then
				abil:SetLevel(1)
			end
		end)
	end
	
	if hHero:GetUnitName() == 'npc_dota_hero_dado' and not _G.ability_mode then
		Timers:CreateTimer(3, function()
			local abil = hHero:FindAbilityByName('Dado_passivka')
			if abil then
				abil:SetLevel(1)
			end
		end)
	end
	
	if hHero:GetUnitName() == 'npc_dota_hero_triss' and not _G.ability_mode then
		Timers:CreateTimer(3, function()
			local abil = hHero:FindAbilityByName('triss_splash')
			if abil then
				abil:SetLevel(1)
			end
		end)
	end
	
	local ability = hHero:AddAbility("ability_capture_lua")
	ability:SetLevel(1)
	
	if _G.ability_mode then
		HeroBuilder:InitPlayerHero(hHero)
	end
	
	-- local hero_name = hHero:GetName()
	-- if hero_name ~= 'npc_dota_hero_anakim' and 
		-- hero_name ~= 'npc_dota_hero_destroyer' and 
		-- hero_name ~= 'npc_dota_hero_dado' and 
		-- hero_name ~= 'npc_dota_hero_triss' then 
		-- pfx_overhead = ParticleManager:CreateParticle("particles/hny/anniversary_10th_hat_ambient_"..hero_name..".vpcf", PATTACH_OVERHEAD_FOLLOW, hHero)
	-- end
	
	hHero.bInited = true
end

------------------------------------------------------------------------------------------------------------

function CAddonAdvExGameMode:OnNPCSpawned(data)
	npc = EntIndexToHScript(data.entindex)
	
	if npc:IsRealHero() and npc.bFirstSpawned == nil and not npc:IsIllusion() and not npc:IsTempestDouble() and not npc:IsClone() and npc:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		npc.bFirstSpawned = true
	end
	if npc:IsRealHero() and not npc:IsIllusion() and not npc:IsTempestDouble() and not npc:IsClone()then
		self._defeatcounter = 5	
		local items_on_the_ground = Entities:FindAllByClassname("dota_item_drop")
		for _,item_ground in pairs(items_on_the_ground) do
			if item_ground then
				local item = item_ground:GetContainedItem()
				local item_name = item:GetAbilityName()
				if item_name == "item_tombstone" then
					local hero = item:GetPurchaser()
					if hero == npc then
						hero:RemoveModifierByName("modifier_fountain_invulnerability")
						UTIL_Remove(item_ground)
					end
				end
			end
		end
	end
end

function CAddonAdvExGameMode:ExpPlayerModifier()
	local values = {40, 55, 70, 85, 100}
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


function CAddonAdvExGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if start_defeat then
			self:_CheckForDefeat()
		end
		quest_system:TimeThink()
	end
	return 1
end

function CAddonAdvExGameMode:_CheckForDefeat()
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
					Shop:add_pr(0, 0, 0, 0, 2, playerID, "lose", 0)
				end
				GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
				Shop:booster_game_end("LOSE")
			else
				self._defeatcounter = 5
				self._ischeckingdefeat = false
				return nil
			end
		end
		end})					
	end
end

function are_all_heroes_dead()
	for playerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
		if PlayerResource:HasSelectedHero(playerID) then
			local hero = PlayerResource:GetSelectedHeroEntity(playerID)
			if hero then
				if hero:IsAlive() or hero:HasModifier("modifier_aegis") or hero:IsReincarnating() then
					return false
				end
			end
		end
	end
	return true
end

local goldTable = {
    ["forest_fat_zombie"] = 25,
    ["npc_dota_creature_dire_hound"] = 30,
    ["npc_dota_creature_dire_hound_boss"] = 140,
    ["npc_dota_creature_small_hellbear"] = 100,
    ["npc_dota_creature_hellbear"] = 175,
    ["satyr_soulstealer"] = 100,
    ["satyr_hellcaller"] = 175,
    ["forest_zombie"] = 35,
    ["skeleton"] = 45,
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
    ["npc_enigma"] = 100,
    ["npc_gyro"] = 110,
    ["npc_sniper"] = 130,
    ["npc_disruptor"] = 120,
    ["npc_invoker_creep"] = 280,
    ["npc_mars_creep"] = 300,
    ["npc_phoenix_creep"] = 270,
}

local bossesTable = {
    ["npc_dota_creature_big_bear"] = { 0, 5, 1, 0, 1, 1 }, --(add_rp, add_exp, add_rating, win_status, boss, guild_exp, unit_name) 
    ["boss_undying"] = { 0, 10, 2, 0, 1, 2 },
    ["lich"] = { 0, 15, 3, 0, 1, 3 },
    ["npc_dota_creature_storegga"] = { 0, 20, 4, 0, 1, 4 },
    ["NYX"] = { 1, 15, 5, 0, 1, 2 },
    ["NYX_2"] = { 1, 15, 5, 0, 1, 2 },
    ["npc_boss_slardar"] = { 2, 25, 6, 0, 1, 5 },
    ["npc_boss_monkey_king"] = { 3, 30, 6, 0, 1, 6 },
    ["npc_boss_fura"] = { 4, 35, 7, 0, 1, 7 },
    ["Lord"] = { 5, 40, 8, 0, 1, 8 },
    ["medusa"] = { 5, 45, 9, 0, 1, 9 },
    ["npc_boss_arc"] = { 5, 50, 9, 0, 1, 10 },
    ["npc_dota_creature_snow"] = { 2, 20, 5, 0, 1, 5 },
    ["npc_dota_creature_gaven_the_brute"] = { 2, 20, 5, 0, 1, 5 },
    ["npc_xdes"] = {5, 50, 10, 0, 1, 5 }
}

local goldUnitNames = {
    "GoldenMiner", "GoldenQueen", "GoldenWyvern", "GoldenSea", "GoldenDragon", "GoldenForest"
}
-- -createhero GoldenMiner enemy
local bless_drop_units = {"satyr_soulstealer","satyr_hellcaller","npc_dota_creature_hellbear","npc_dota_creature_small_hellbear",
	"npc_dota_creature_dire_hound","npc_dota_creature_dire_hound_boss","forest_zombie","skeleton","npc_creep_crystal",
	"apparat","tusk","icespider","white_walker","mirana","npc_dota_creature_large_ogre_seal","guard","npc_trap_visage",
	"tank","undying","morf", "npc_blob","npc_slardar_unit","npc_zone_jungle_1","npc_zone_jungle_2","npc_zone_jungle_3",
	"npc_zone_jungle_4","npc_keeper_of_the_light","miner","small_hellbear","encha","treant","npc_lifestealer","batr","warlock",
	"pudge","npc_venom_creep","demon","npc_gyro","npc_enigma","npc_sniper","npc_disruptor","cher"}

_G.bosses_counter = {
	 ["npc_dota_creature_big_bear"] = false,
	 ["boss_undying"] = false,
	 ["lich"] = false,
	 ["npc_dota_creature_storegga"] = false,
	 ["NYX"] = false,
	 ["NYX_2"] = false,
	 ["npc_boss_slardar"] = false,
	 ["npc_boss_monkey_king"] = false,
	 ["npc_boss_fura"] = false,
	 ["Lord"] = false,
	 ["medusa"] = false,
	 ["npc_boss_arc"] = false,
	 ["guard"] = false,
}

function HandleKilledUnit(killed_unit, killer, add_rp, add_exp, add_rating, win_status, boss, guild_exp, unit_name) 
	if GameRules:IsCheatMode() and not IsInToolsMode() then return end
    local heroes = FindUnitsInRadius(killer:GetTeamNumber(), killed_unit:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_DEAD,
        FIND_ANY_ORDER, false)
    for _, hero in pairs(heroes) do
        local pid = hero:GetPlayerID()
        Shop:add_pr(add_rp, add_exp, add_rating, win_status, boss, pid, unit_name, guild_exp)
    end
	if boss ~= 0 then
		if unit_name ~= "NYX" or unit_name ~= "NYX_2" then
			respawn_heroes()
		end
		add_book(unit_name)
	end
end

function CAddonAdvExGameMode:OnEntityKilled( keys )
    local killed_unit = EntIndexToHScript( keys.entindex_killed )
    local killer = EntIndexToHScript( keys.entindex_attacker )
	local unitName = killed_unit:GetUnitName()
	
	-- if killed_unit and killed_unit:IsRealHero() and killed_unit:HasModifier("modifier_guild_event") then
		-- if not killed_unit:IsReincarnating() then
			-- rules:hero_die(killed_unit)
		-- end
	-- end
	
	-- if killed_unit and killed_unit:IsRealHero() and not killed_unit:HasModifier("modifier_guild_event") and not killed_unit:IsReincarnating() then
	if killed_unit and killed_unit:IsRealHero() and not killed_unit:IsReincarnating() then
		effects:CastSpray({PlayerID = killed_unit:GetPlayerID()})
		local newItem = CreateItem( "item_tombstone", killed_unit, killed_unit )
		newItem:SetPurchaseTime(0)
		newItem:SetPurchaser(killed_unit)
		local tombstone = SpawnEntityFromTableSynchronous( "dota_item_drop", {} )
		tombstone:SetContainedItem( newItem )
		tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
		FindClearSpaceForUnit( tombstone, killed_unit:GetAbsOrigin(), true )	
	end
	
--------------------------------------------------------------------------------------------

	if _G.bosses_counter[unitName] ~= nil then
		_G.bosses_counter[unitName] = true
	end

	if unitName == "roshan_npc"  then
		local roshan = killed_unit
		Timers:CreateTimer(RandomInt(300,480), function()
			local ent = Entities:FindByName( nil, "roshan_npc_point")
			local point = ent:GetAbsOrigin()
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
------------------------------------------------------ CREEPS GOLD REWARD -----------------------------------------------------------------------------------

	if goldTable[unitName] then
		local heroes = FindUnitsInRadius(killer:GetTeamNumber(), killed_unit:GetAbsOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO,  DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false ) 
		for i = 1, #heroes do
			local gold = goldTable[unitName]*((100 - (5-#heroes)*10)*0.01)/#heroes		
			local playerID = heroes[i]:GetPlayerID()
			local player = PlayerResource:GetSelectedHeroEntity(playerID)
			if player:HasModifier("modifier_item_gold_aura") then
				gold = gold * 1.1
			end
			player:ModifyGold(gold, true, 0)
			SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, player, gold, nil)
		end
	end
	
------------------------------------------------------ BOSSES OTHER REWARD -----------------------------------------------------------------------------------

	local bossesData = bossesTable[unitName]
    if bossesData then
        HandleKilledUnit(killed_unit, killer, bossesData[1], bossesData[2], bossesData[3], bossesData[4], bossesData[5], bossesData[6], unitName)
    end

------------------------------------------------------ GOLDEN UNITS REWARDS -----------------------------------------------------------------------------------

	if table.contains(goldUnitNames, unitName) and GetMapName() ~= "ability_mode" then
		local heroes = FindUnitsInRadius(killer:GetTeamNumber(), killed_unit:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_DEAD,
        FIND_ANY_ORDER, false)
		for _, hero in pairs(heroes) do
			local pid = hero:GetPlayerID()
			local connection = PlayerResource:GetConnectionState(pid)
			if hero and connection ~= DOTA_CONNECTION_STATE_ABANDONED then
				inventory:roll_random_item(pid, unitName)
			end
		end
	end
	
------------------------------------------------------ BLESS DROP -----------------------------------------------------------------------------------	
	
	if table.contains(bless_drop_units, unitName) and not GetMapName() ~= "ability_mode" then
		if killer and killer:IsRealHero() then
			local pid = killer:GetPlayerID()
			inventory:add_bless(pid)
		end
	end
	
--------------------------------------------------------------------снега

	if unitName == "npc_snow" or unitName == "npc_snow2" or unitName == "npc_snow3" then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		Shop:booster_game_end("LOSE")
	end
	
----------------------------------------------------------------------боксы

	if unitName == "npc_dota_crate" then
		if RandomInt(0,1) == 1 then
			killer:EmitSound("Dungeon.SmashCrateShort")
		else
			killer:EmitSound("Dungeon.SmashCrateLong")
		end
	end
	
---------------------------------------------------------------------------------

	if unitName == "necrolyte" and not GameRules:IsCheatMode() then
		HandleKilledUnit(killed_unit, killer, 10, 50, 25, 1, 1, 11, unitName)
		Notifications:TopToAll({text="#win", duration=5})
		Timers:CreateTimer(6, function()
			GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		end)
		Shop:booster_game_end("WIN")
	end

---------------------------------------------------------------------------------

	if killer and killer:IsRealHero() then
		local pid = killer:GetPlayerID()
		if _G.player_quest[pid] then
			if _G.player_quest[pid][unitName] == nil then
				_G.player_quest[pid][unitName] = 1
			else
				_G.player_quest[pid][unitName] = _G.player_quest[pid][unitName] + 1
			end
		end
	end
end

function respawn_heroes()
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:IsValidPlayer(nPlayerID) and PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				rules:show({PlayerID = nPlayerID})
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
				hero:AddNewModifier( hero, nil, "modifier_omninight_guardian_angel", {duration = 2.5})
			end
		end
	end
end

function add_book(unit)
	if _G.ability_mode then 
		for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
				if PlayerResource:HasSelectedHero( nPlayerID ) then
					local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
					if unit == "npc_boss_slardar" then
						hero:AddItemByName("item_add_spell")
					else
						hero:AddItemByName("item_reroll")
					end
				end
			end
		end
	end
end

function CAddonAdvExGameMode:OnNpcInteract(data)
	local pid = data.PlayerID
	local hero = PlayerResource:GetSelectedHeroEntity(pid)
	local unit = EntIndexToHScript(data.unit_id)
	local name = data.name
	local distance = 400
	if (hero:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D() < distance then
		if name == "#blacksmith" then
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pid),"ActivateBlacksmith",{})
		elseif name == "#trade" then
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pid),"ActivateTrade",{})
		elseif name == "#dungeon_master" then
			-- Shop:get_difficulty_data({PlayerID = pid})
			-- Shop:get_booster_profile({PlayerID = pid})
			Shop:get_booster_data({PlayerID = pid})
		end
	else
		rules:DisplayError(pid, "#to_far_away")
	end
end