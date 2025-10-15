require('essentials')
require("data")

if rules == nil then
    _G.rules = class({})
end

-- Таблица для хранения событий, которые нужно отправить при реконнекте
_G.reconnect_events = {}

function rules:init()
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( rules, 'OnGameStateChanged' ), self )
	ListenToGameEvent( "player_connect", Dynamic_Wrap( rules, 'OnPlayerConnect' ), self )
	-- CustomGameEventManager:RegisterListener("golden_spawn", Dynamic_Wrap( rules, 'golden_spawn' ))
	CustomGameEventManager:RegisterListener("TryStartEvent", Dynamic_Wrap( rules, 'TryStartEvent' ))
	CustomGameEventManager:RegisterListener("select_skill_lua", Dynamic_Wrap( rules, 'select_skill_lua'))
end

------------------------------------------------------ BOSS REWARDS -------------------------------------------------

boss_reward_modifiers = {
	"modifier_agi_10","modifier_armor_5","modifier_as_30",
	"modifier_attack_range_50","modifier_cd_5","modifier_damage_40",
	"modifier_evasion_10","modifier_exp_3","modifier_hp_regen_10",
	"modifier_int_10","modifier_mg_resist_5","modifier_mp_regen_10",
	"modifier_ms_30","modifier_spell_10","modifier_str_10"
}

function rules:skillsPreparation(t)
    local result  = {}
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    while #result < 3 do
        local skill = boss_reward_modifiers[RandomInt(1,#boss_reward_modifiers)]
        for i = 1, #result do
		    if result[i] == skill then
                break
            end
            if i == #result then
                table.insert(result, skill)
            end
        end
        if #result == 0 then
            table.insert(result, skill)
        end
    end
    return result
end

function rules:getPlayerSkills(t)
    local result  = {}
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    for _,plArr in pairs(HeroList.arr) do
        for _,plAbi in pairs(plArr.skill_list) do
            for _,abiName in pairs(plAbi) do
                if hero:FindAbilityByName(abiName) then
                    table.insert(result, plAbi)
                    break
                end
            end
        end
    end
    return result
end

function rules:show(t)
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "show_skills_js",  self:skillsPreparation(t))
end

function rules:select_skill_lua(t)
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    for _, ability_name in pairs(t) do
		if string.sub(ability_name, 0,8) == "modifier" then
			LinkLuaModifier( ability_name, "modifiers/boss_reward/"..ability_name, LUA_MODIFIER_MOTION_NONE )
			hero:AddNewModifier(hero, nil, ability_name, {})
			EmitSoundOn( "hud.equip.agh_shard", hero)
		end	
    end
end

------------------------------------------------- CLEAR ZONE POINTS ---------------------------------------------------

function rules:clear_zone(name, count)
	Timers:CreateTimer(5, function()
		for i = 1, count do
			local point = Entities:FindByName( nil, name..i)
			if point then
				UTIL_Remove( point )
			end
		end	
	end)
end

------------------------------------------------- GET PLAYER COUNT ------------------------------------------------------

function rules:GetAllPlayers()
	count = 0
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				count = count + 1
			end
		end
	end
	return count
end

------------------------------------------------- DISPLAY ERROR ------------------------------------------------------

function rules:DisplayError(playerID, message)
	local player = PlayerResource:GetPlayer(playerID)
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message=message})
	end
end

------------------------------------------------- RECONNECT EVENTS ------------------------------------------------------

-- Функция для сохранения события для последующей отправки при реконнекте
function rules:SaveReconnectEvent(eventName, eventData)
	table.insert(_G.reconnect_events, {
		event = eventName,
		data = eventData
	})
end

-- Функция для отправки всех сохраненных событий игроку
function rules:SendReconnectEvents(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	if player then
		for _, eventInfo in pairs(_G.reconnect_events) do
			CustomGameEventManager:Send_ServerToPlayer(player, eventInfo.event, eventInfo.data)
		end
	end
end

-- Обработчик подключения игрока
function rules:OnPlayerConnect(keys)
	local playerID = keys.PlayerID
	if playerID and PlayerResource:IsValidPlayerID(playerID) then
		-- Небольшая задержка, чтобы убедиться, что игрок полностью подключился
		Timers:CreateTimer(1.0, function()
			if PlayerResource:GetPlayer(playerID) then
				rules:SendReconnectEvents(playerID)
			end
		end)
	end
end

-- Функция для очистки всех сохраненных событий (можно вызвать при перезапуске игры)
function rules:ClearReconnectEvents()
	_G.reconnect_events = {}
end

------------------------------------------------- SPAWNS ------------------------------------------------------

function rules:OnGameStateChanged()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
	-- if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		-- Очищаем события реконнекта при начале новой игры
		rules:ClearReconnectEvents()
		checkpoint()
		box_spawn()
		create_box_traps()
		dummy_spawn()
		rules:bosses_upgrade()
	end
end

------------------------------------------------- SPAWNS ------------------------------------------------------

function checkpoint()
	local hBuilding = Entities:FindByName( nil, "checkpoint00_building" )
	hBuilding:SetTeam( DOTA_TEAM_GOODGUYS )
	EmitGlobalSound( "DOTA_Item.Refresher.Activate" ) 
end

function box_spawn()
	local Point = Entities:FindByName( nil, "invis_box_zone_1_"..RandomInt(1, 2)):GetAbsOrigin()
	local hUnit = CreateUnitByName("invis_box", Point, true, nil, nil, DOTA_TEAM_NEUTRALS)

	local Point = Entities:FindByName( nil, "zone_1_point_"..RandomInt(1,2)):GetAbsOrigin()
	local hUnit = CreateUnitByName("small_box", Point, true, nil, nil, DOTA_TEAM_NEUTRALS)

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

function create_box_traps()
	CreateRune(Vector(-4252,14776,256), DOTA_RUNE_ILLUSION)
	count = rules:GetAllPlayers()
	for i = 1, 5 - count do
		local point = Entities:FindByName( nil, "box_"..i):GetAbsOrigin()
		if point ~= nil then
			local hUnit = CreateUnitByName("npc_dota_crate2", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
		end
	end
end

function dummy_spawn()
	if not IsServer() then return end

	local blacksmith = CreateUnitByName("blacksmith", Vector(-5445,-14300, 384), false, nil, nil, DOTA_TEAM_GOODGUYS)
	blacksmith:AddNewModifier(blacksmith, nil, "modifier_blacksmith_meepo", {})
	blacksmith:SetAngles(0,-90,0)
	local blacksmithEvent = {unit_id = blacksmith:entindex(), distance = 400, name = "#blacksmith"}
	CustomGameEventManager:Send_ServerToAllClients("create_npc_button", blacksmithEvent)
	rules:SaveReconnectEvent("create_npc_button", blacksmithEvent)
	
	local trade = CreateUnitByName("blacksmith", Vector(-4800,-15424, 384), false, nil, nil, DOTA_TEAM_GOODGUYS)
	trade:AddNewModifier(blacksmith, nil, "modifier_trade_meepo", {})
	trade:SetAngles(0,180,0)
	local tradeEvent = {unit_id = trade:entindex(), distance = 400, name = "#trade"}
	CustomGameEventManager:Send_ServerToAllClients("create_npc_button", tradeEvent)
	rules:SaveReconnectEvent("create_npc_button", tradeEvent)

	local dungeon_master = CreateUnitByName("blacksmith", Vector(-5557.479980, -15719.900391, 256.000000), false, nil, nil, DOTA_TEAM_GOODGUYS)
	dungeon_master:AddNewModifier(dungeon_master, nil, "modifier_trade_meepo", {})
	dungeon_master:SetAngles(0,90,0)
	local dungeonMasterEvent = {unit_id = dungeon_master:entindex(), distance = 400, name = "#dungeon_master"}
	CustomGameEventManager:Send_ServerToAllClients("create_npc_button", dungeonMasterEvent)
	rules:SaveReconnectEvent("create_npc_button", dungeonMasterEvent)

	local unit = CreateUnitByName( "npc_dota_hero_target_dummy", Vector(-4823,-14482,256), false, nil, nil, DOTA_TEAM_NEUTRALS)
	local angle = unit:GetAngles()
	local new_angle = RotateOrientation(angle, QAngle(0,240,0))
	unit:SetAngles(new_angle[1], new_angle[2], new_angle[3])
	unit:SetAbilityPoints( 0 )
	unit:Hold()
	unit:SetIdleAcquire( false )
	unit:SetAcquisitionRange( 0 )
	
	_G.npc_creeps_passives = CreateUnitByName("npc_creeps_passives",Vector(-4823,-14380, 384), false, nil, nil, DOTA_TEAM_NEUTRALS)
	npc_creeps_passives:AddNewModifier(npc_creeps_passives, nil, "modifier_dummy", {})
end	

--------------------------------------------------- 

creeps_other = {
	"forest_fat_zombie","forest_zombie","skeleton","npc_dota_creature_big_bear","boss_undying","lich",
	"npc_dota_creature_storegga","guard","NYX","NYX_2","npc_boss_slardar","npc_boss_monkey_king","npc_boss_fura",
	"Lord","medusa","npc_boss_arc","necrolyte","troll_high_priest","npc_dota_creature_gaven_the_brute",
	"npc_dota_creature_snow","big_bear","npc_dota_roshan","zombieTomb1", "roshan_npc"
	}
	
big_units = {
	"npc_dota_creature_dire_hound_boss", "npc_dota_creature_hellbear", "satyr_hellcaller",
	"skeleton", "tusk", "npc_dota_creature_large_ogre_seal", "tank", "npc_slardar_unit",
	"npc_shaker", "treant", "warlock", "pudge", "npc_sniper", "npc_mars_creep"
}

bosses_invu = {
	"guard","npc_dota_creature_big_bear","boss_undying","lich","npc_dota_creature_storegga",
	"NYX","NYX_2","npc_boss_slardar","npc_boss_monkey_king","npc_boss_fura","Lord","medusa",
	"npc_boss_arc", "storegga", "undy", "necrolyte", "npc_dota_creature_gaven_the_brute",
	"npc_dota_creature_snow", "forest_zombie", "skeleton"
}

function rules:bosses_upgrade()	
	random_ability = passive[RandomInt(1,#passive)]	
	local enemies = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	for _, unit in pairs(enemies) do
		if table.contains(creeps_other, unit:GetUnitName()) then
            rules:aura_dif(unit, random_ability)
        end
    end
	invulnerable(enemies)
end

function invulnerable(enemies)
    for _, unit in pairs(enemies) do
		if table.contains(bosses_invu, unit:GetUnitName()) then
            unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
            unit:AddNewModifier(unit, nil, "modifier_medusa_stone_gaze_stone", {})
            unit:AddNewModifier(unit, nil, "modifier_magic_immune", {})
        end
    end
end

function rules:aura_dif(unit, random_ability)
    unit:AddNewModifier(unit, nil, "modifier_difficult", {}):SetStackCount(_G.Game_Difficulty)
    local abi = _G.npc_creeps_passives:FindAbilityByName(random_ability)
    
    if abi then
        if _G.Game_Difficulty >= 12 then
            unit:AddNewModifier(unit, abi, abi:GetIntrinsicModifierName(), {})
        end
        if _G.Game_Difficulty >= 16 then
            local random_ability2 = passive[RandomInt(1, #passive)]
            local abi2 = _G.npc_creeps_passives:FindAbilityByName(random_ability2)
            if abi2 then
                unit:AddNewModifier(unit, abi2, abi2:GetIntrinsicModifierName(), {})
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




---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

-- _G.can_guild_event = true

-- function show_guild_event(t)
	-- local hero = t.activator
	-- local pid = hero:GetPlayerID()
	-- if _G.can_guild_event then
		-- CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pid), "Guild_event_show", {})
	-- end
-- end

-- function hide_guild_event(t)
	-- local hero = t.activator
	-- local pid = hero:GetPlayerID()
	-- CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pid), "Guild_event_hide", {})
-- end

-- function rules:TryStartEvent(t)
    -- if _G.can_guild_event then
        -- _G.can_guild_event = false
        -- local firstPlayerGuild = nil
		-- if rules:GetAllPlayers() == 1 then
			-- for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
				-- if PlayerResource:GetTeam(nPlayerID) == DOTA_TEAM_GOODGUYS and PlayerResource:HasSelectedHero(nPlayerID) then
					-- local sid = PlayerResource:GetSteamAccountID(nPlayerID)
					-- local guild = Shop.pShop[sid] and Shop.pShop[sid].guild_id
					
					-- if guild == nil then
						-- rules:DisplayError(t.PlayerID, "#need_one_guild")
						-- _G.can_guild_event = true
						-- return false
					-- end

					-- if firstPlayerGuild == nil then
						-- firstPlayerGuild = guild
					-- else
						-- if guild ~= firstPlayerGuild then
							-- rules:DisplayError(t.PlayerID, "#need_one_guild")
							-- _G.can_guild_event = true
							-- return false
						-- end
					-- end
				-- end
			-- end
		-- else
			-- _G.can_guild_event = true
			-- rules:DisplayError(t.PlayerID, "#need_more_players")
			-- return false
		-- end
		-- rules:send_event_request(firstPlayerGuild, t)
		-- return true
	-- end
-- end

-- function rules:send_event_request(guild, t)
	-- arr = {
		-- guild_id = guild,
	-- }
	-- arr = json.encode(arr)
	-- local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_get_guild_event/?key=".._G.key )
	-- req:SetHTTPRequestGetOrPostParameter('arr',arr)
	-- req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	-- req:Send(function(res)
		-- if res.StatusCode == 200 then
			-- rules:StartGuildTeleport(guild)
		-- else
			-- _G.can_guild_event = true
			-- rules:DisplayError(t.PlayerID, "#need_more_tickets")
		-- end
	-- end)
-- end

-- function rules:send_event_request_exp(level, guild)
	-- local valid_players = {}
	-- for i = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		-- if PlayerResource:GetTeam(i) == DOTA_TEAM_GOODGUYS then
			-- if PlayerResource:HasSelectedHero(i) then
				-- local hero = PlayerResource:GetSelectedHeroEntity(i)
				-- if not hero:HasModifier("modifier_wait") then
					-- valid_players[i] = {sid = tostring(PlayerResource:GetSteamID(i))}
				-- end
			-- end
		-- end
	-- end

	-- local arr = {
		-- players = valid_players,
		-- level = level,
		-- guild_id = guild,
	-- }
	-- arr = json.encode(arr)
	-- local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_get_guild_event_exp/?key=".._G.key )
	-- req:SetHTTPRequestGetOrPostParameter('arr',arr)
	-- req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	-- req:Send(function(res)
		-- if res.StatusCode == 200 then
			-- print("ok")
		-- else
			-- print(res.StatusCode)
		-- end
	-- end)
-- end

-- function rules:StartGuildTeleport(guild)
	-- _G.guild_event_alive = 1
	-- for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		-- if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			-- if PlayerResource:HasSelectedHero( nPlayerID ) then
				-- local unit = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				-- unit:AddNewModifier(unit, nil, "modifier_teleport_event", {})
				-- unit:AddNewModifier(unit, nil, "modifier_guild_event", {})
				-- unit:EmitSound("Portal.Loop_Appear")
				-- Timers:CreateTimer(3, function()
					-- Notifications:TopToAll({text="#guild_event", duration=3})
					-- local point = Entities:FindByName( nil, "guild_event_tp"):GetAbsOrigin()
					-- unit:SetAbsOrigin( point )
					-- FindClearSpaceForUnit(unit, point, false)
					-- unit:Stop()
					-- unit:StopSound("Portal.Loop_Appear")
					-- unit:RemoveModifierByName("modifier_teleport_event")
					-- PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), unit)
					-- Timers:CreateTimer(0.1, function()
						-- PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), nil)
					-- return nil
					-- end)
				-- end)
			-- end
		-- end
	-- end
	-- Timers:CreateTimer(13, function()
		-- rules:guild_event_start(guild)
	-- end)
-- end

-- guild_spawn_step = 0
-- guild_spawn_level = 1

-- function rules:guild_event_stop()
	-- print("event stop")
	-- for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		-- if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			-- if PlayerResource:HasSelectedHero( nPlayerID ) then
				-- local unit = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				-- print("!")
				-- unit:RemoveModifierByName("modifier_guild_event")
				-- unit:RemoveModifierByName("modifier_wait")
			-- end
		-- end
	-- end
	-- for _,creep in ipairs(self.guild_creeps_table) do
		-- UTIL_Remove(creep)
	-- end
-- end

-- function rules:GetAllItems(hero)
	-- local tab = {}
    -- if hero:HasInventory() then
		-- for i=0, 5 do
			-- local item = hero:GetItemInSlot(i);
			-- if item ~= nil then
				-- table.insert(tab, item:GetAbilityName())
			-- end
		-- end
	-- end
    -- return tab
-- end

-- function rules:hero_die(hero)
	-- _G.guild_event_alive = _G.guild_event_alive - 1
	-- Timers:CreateTimer(0.1, function()
		-- hero:RespawnHero(false, false)
		-- hero:SetHealth(hero:GetMaxHealth())
		-- hero:SetMana(hero:GetMaxMana())			
		-- hero:AddNewModifier(event_unit, nil, "modifier_wait", {})
		-- if _G.guild_event_alive == 0 then
			-- rules:guild_event_stop()
		-- end
	-- end)
-- end

-- function rules:guild_event_start(guild)
	-- local point = Entities:FindByName( nil, "guild_event_spawner"):GetAbsOrigin()
	-- self.guild_creeps_table = {}
	
	
	-- Timers:CreateTimer(1, function()
		-- if _G.guild_event_alive > 0 then
			-- AddFOWViewer(DOTA_TEAM_GOODGUYS, point, 1500, 3, false)
			-- AddFOWViewer(DOTA_TEAM_NEUTRALS, point, 1500, 3, false)
			
			-- guild_spawn_step = guild_spawn_step + 1
			-- if guild_spawn_step % 20 == 0 then
				-- rules:send_event_request_exp(guild_spawn_level, guild)
				-- guild_spawn_level = guild_spawn_level + 1
				-- Notifications:TopToAll({text="#level", text2=tostring(" "..guild_spawn_level), duration=3})
			-- end
			-- for pid = 0, DOTA_MAX_TEAM_PLAYERS-1 do
				-- if PlayerResource:GetTeam(pid) == DOTA_TEAM_GOODGUYS then
					-- if PlayerResource:HasSelectedHero(pid) then
						-- local hero = PlayerResource:GetSelectedHeroEntity(pid)
						
						-- if (hero:GetOrigin() - point):Length2D() > 2500 then
							-- hero:ForceKill(true)
							-- rules:hero_die(hero)
						-- end
						
						-- local start_damage = hero:GetAverageTrueAttackDamage(nil) --/ 10
						-- local start_health = hero:GetMaxHealth() / 10
						-- local start_health_regen = hero:GetHealthRegen() / 10
						-- local start_mana = hero:GetMaxMana() / 10
						-- local start_mana_regen = hero:GetManaRegen() / 10
						-- local start_armor = hero:GetPhysicalArmorValue(false) / 10
						-- local start_magic_resist = hero:GetBaseMagicalResistanceValue() / 10
						-- local stacks = 0
						-- local mod = hero:FindModifierByName("modifier_guild_event_buff_debuff")
					
						-- if mod then 
							-- stacks = mod:GetStackCount()
						-- end

						-- local unit = CreateUnitByName("guild_creeps", point + RandomVector(RandomInt( 450, 450)), true, nil, nil, DOTA_TEAM_BADGUYS)
						-- table.insert(self.guild_creeps_table, unit)
						-- unit:SetBaseDamageMin(calculate_creep_stats(start_damage))
						-- unit:SetBaseDamageMax(calculate_creep_stats(start_damage))
						-- unit:SetMaxHealth(calculate_creep_stats(start_health))
						-- unit:SetBaseMaxHealth(calculate_creep_stats(start_health))
						-- unit:SetHealth(calculate_creep_stats(start_health))
						-- unit:SetBaseHealthRegen(calculate_creep_stats(start_health_regen))
						-- unit:SetMaxMana(calculate_creep_stats(start_mana))
						-- unit:SetBaseManaRegen(calculate_creep_stats(start_mana_regen))
						-- unit:SetPhysicalArmorBaseValue(calculate_creep_stats(start_armor) + stacks)
						-- unit:SetBaseMagicalResistanceValue(calculate_creep_stats(start_magic_resist) + stacks)
						
						-- unit:AddNewModifier(unit, nil, "modifier_guild_event_buff", {}):SetStackCount(guild_spawn_step)
						
						-- for k,v in pairs(rules:GetAllItems(hero)) do
							-- unit:AddItemByName(v)
						-- end
					-- end
				-- end
			-- end
			-- return 2
		-- else
			-- return nil
		-- end	
	-- end)
-- end

-- function calculate_creep_stats(atr)
	-- return atr * (1 + guild_spawn_step*2)
-- end