if guilds == nil then
    _G.guilds = class({})
end

function guilds:RegisterHudListener( event_name, function_name )
	CustomGameEventManager:RegisterListener( event_name, function( _, kv ) 
		self[ function_name ]( self, kv )
	end )
end

function guilds:init()
	self:RegisterHudListener( "get_game_guilds", "get_game_guilds" )
	self:RegisterHudListener( "create_game_guilds", "create_game_guilds" )
	self:RegisterHudListener( "add_member", "add_member" )
	self:RegisterHudListener( "remove_member", "remove_member" )
	self:RegisterHudListener( "add_reward_point", "add_reward_point" )
	self:RegisterHudListener( "send_message", "send_message" )
	self:RegisterHudListener( "update_chat_message", "update_chat_message" )
	self:RegisterHudListener( "buy_permanent_reward", "buy_permanent_reward" )
	self:RegisterHudListener( "buy_slot", "buy_slot" )
end

function guilds:add_member(t)
	-- print("CALL ADD MEMBER")
	arr = {
		sid = tostring(PlayerResource:GetSteamID(t.PlayerID)),
		guild_id = t.guild_id
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_guilds_add_member/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			-- print("MEMBER ADDED")
			print(res.Body)
			-- print("MEMBER ADDED")
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "update", {})
		else
			-- print("ERROR MEMBER ADDED")
			print(res.StatusCode)
			-- print("ERROR MEMBER ADDED")
		end
	end)
end

function guilds:remove_member(t)
	-- print("CALL REMOVE MEMBER")
	arr = {sid = t.sid}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_guilds_remove_member/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			-- print("MEMBER REMOVED")
			print(res.Body)
			-- print("MEMBER REMOVED")
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "update", {})
		else
			-- print("ERROR MEMBER REMOVED")
			print(res.StatusCode)
			-- print("ERROR MEMBER REMOVED")
		end
	end)
end

-- /////////////////////////////////////////////////////////////////////////////////

function guilds:add_reward_point(t)
	-- print("CALL ADD POINTS")
	arr = {
		sid = tostring(PlayerResource:GetSteamID(t.PlayerID)),
		reward = t.reward_id
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_guilds_add_reward_point/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			-- print("GUILD POINT ADDED")
			print(res.Body)
			-- print("GUILD POINT ADDED")
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "point_feedback", {})
		else
			-- print("ERROR GUILD POINT ADDED")
			print(res.StatusCode)
			-- print("ERROR GUILD POINT ADDED")
		end
	end)
end

function guilds:add_guild_exp(pid, experience)
	-- print("CALL ADD EXP")
	local hero = PlayerResource:GetSelectedHeroEntity(pid)
	if not hero:HasModifier("modifier_guild") then return end
	
	arr = {
		sid = tostring(PlayerResource:GetSteamID(pid)),
		exp = math.ceil(experience * _G.Game_Difficulty / 10)
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_guilds_add_guild_exp/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			-- print("GUILD EXP ADDED")
			print(res.Body)
			-- print("GUILD EXP ADDED")
			-- CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "point_feedback", {})
		else
			-- print("ERROR GUILD EXP ADDED")
			print(res.StatusCode)
			-- print("ERROR GUILD EXP ADDED")
		end
	end)
end

function guilds:buy_permanent_reward(t)
	-- print("BUY REWARD")
	local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
		if tonumber(Shop.pShop[sid].coins) >= 25 then
			Shop.pShop[sid].coins = Shop.pShop[sid].coins - 25
		arr = {
			sid = tostring(PlayerResource:GetSteamID(t.PlayerID)),
			permanent_reward = t.reward_name
		}
		arr = json.encode(arr)
		local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_buy_permanent_reward/?key=".._G.key )
		req:SetHTTPRequestGetOrPostParameter('arr',arr)
		req:SetHTTPRequestAbsoluteTimeoutMS(100000)
		req:Send(function(res)
			if res.StatusCode == 200 and res.Body ~= nil then
				-- print("BUY REWARD ADDED")
				print(res.Body)
				-- print("BUY REWARD ADDED")
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "update", {})
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "updatecoins", {Shop.pShop[sid].coins} )
			else
				-- print("ERROR BUY REWARD")
				print(res.StatusCode)
				-- print("ERROR BUY REWARD")
			end
		end)
	else
		print("xyi")
	end
end

function guilds:buy_slot(t)
	local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
	if tonumber(Shop.pShop[sid].coins) >= 20 then
			Shop.pShop[sid].coins = Shop.pShop[sid].coins - 20
		arr = {
			sid = tostring(PlayerResource:GetSteamID(t.PlayerID)),
		}
		arr = json.encode(arr)
		local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_buy_slot/?key=".._G.key )
		req:SetHTTPRequestGetOrPostParameter('arr',arr)
		req:SetHTTPRequestAbsoluteTimeoutMS(100000)
		req:Send(function(res)
			if res.StatusCode == 200 and res.Body ~= nil then
				-- print("BUY REWARD ADDED")
				print(res.Body)
				-- print("BUY REWARD ADDED")
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "update", {})
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "updatecoins", {Shop.pShop[sid].coins} )
			else
				-- print("ERROR BUY REWARD")
				print(res.StatusCode)
				-- print("ERROR BUY REWARD")
			end
		end)
	else
		print("xyi")
	end
end

-- /////////////////////////////////////////////////////////////////////////////////

function guilds:create_game_guilds(t)
	-- print("CALL CREATE GUILD")
	local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
	if tonumber(Shop.pShop[sid].coins) >= 200 then
		Shop.pShop[sid].coins = Shop.pShop[sid].coins - 200		
		arr = {
			sid = tostring(PlayerResource:GetSteamID(t.PlayerID)),
			guild_name = t.name,
			guild_image = t.image
		}
		arr = json.encode(arr)
		local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_guilds_game_create/?key=".._G.key )
		req:SetHTTPRequestGetOrPostParameter('arr',arr)
		req:SetHTTPRequestAbsoluteTimeoutMS(100000)
		req:Send(function(res)
			if res.StatusCode == 200 and res.Body ~= nil then
				-- print("CREATED GUILD")
				-- print(res.Body)
				-- print("CREATED GUILD")
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "update", {})
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "updatecoins", {Shop.pShop[sid].coins} )
			else
				-- print("ERROR GET GUILD GAME")
				print(res.StatusCode)
				-- print("ERROR GET GUILD GAME")
			end
		end)
	else
		rules:DisplayError(t.PlayerID, "#need_more_gems")
	end
end

function guilds:get_game_guilds(t)
	-- print("CALL GET GUILDS")
	arr = {tostring(PlayerResource:GetSteamID(t.PlayerID))}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "GET", "http://91.240.87.224/api_guilds_game/")
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			local guild = json.decode(res.Body)
			if guild.has_guild == true then
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "guild_window", guild)
				guilds:update_modifiers(true, guild, t.PlayerID, false)
			else
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "guild_list", guild)
				guilds:update_modifiers(false, guild, t.PlayerID, false)
			end
		else
			-- print("ERROR GET GUILD GAME")
			print(res.StatusCode)
			-- print("ERROR GET GUILD GAME")
		end
	end)
end


function guilds:get_start_game_guilds(pid)
	-- print("START GAME GET GUILDS")
	print(pid)
	arr = {tostring(PlayerResource:GetSteamID(pid))}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "GET", "http://91.240.87.224/api_guilds_game/")
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			local guild = json.decode(res.Body)
			if guild.has_guild == true then
				guilds:update_modifiers(true, guild, pid, true)
			else
				guilds:update_modifiers(false, guild, pid, true)
			end
		else
			-- print("ERROR GET GUILD GAME")
			print(res.StatusCode)
			-- print("ERROR GET GUILD GAME")
		end
	end)
end


function guilds:send_message(t)
	-- print("SEND GUILD MESSAGE")
	arr = {
		sid = tostring(PlayerResource:GetSteamID(t.PlayerID)),
		text = t.text,
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_guilds_add_message/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			-- print("SEND GUILD MESSAGE OK")
			print(res.Body)
			local chat = json.decode(res.Body)
			print(chat)
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "update_chat", chat)
			-- print("SEND GUILD MESSAGE OK")
		else
			-- print("ERROR SEND GUILD MESSAGE")
			print(res.StatusCode)
			-- print("ERROR SEND GUILD MESSAGE")
		end
	end)
end


function guilds:update_chat_message(t)
	-- print("UPDATE GUILD MESSAGE")
	arr = {
		sid = tostring(PlayerResource:GetSteamID(t.PlayerID)),
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_guilds_update_chat_message/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			-- print("UPDATE GUILD MESSAGE OK")
			local chat = json.decode(res.Body)
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "update_chat", chat)
			-- print("UPDATE GUILD MESSAGE OK")
		else
			-- print("ERROR UPDATE GUILD MESSAGE")
			print(res.StatusCode)
			-- print("ERROR UPDATE GUILD MESSAGE")
		end
	end)
end

-- /////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////// MODIFIERS ////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////////

function guilds:update_modifiers(status, data, pid, first_spawn)
	-- print("CALL UPDATE MODIFIER MEMBERS")
	local hero = PlayerResource:GetSelectedHeroEntity( pid )
	print(hero)

	-- table.print(data)
	-- if hero then
		if status == true then
			local newData = {
				["reward_1"] = data["rewards"]["reward_1"],
				["reward_2"] = data["rewards"]["reward_2"],
				["reward_3"] = data["rewards"]["reward_3"],
				["reward_4"] = data["rewards"]["reward_4"],
				["reward_5"] = data["rewards"]["reward_5"],
				["reward_6"] = data["rewards"]["reward_6"],
				["perm_reward_1"] = data["perm_reward_1"],
				["perm_reward_2"] = data["perm_reward_2"],
			}
			local mod = hero:AddNewModifier(hero, nil, "modifier_guild", newData )
			if first_spawn and mod then
				mod:Spawn_bonus()
			end
		else
			if hero:HasModifier("modifier_guild") then
				hero:RemoveModifierByName("modifier_guild")
			end
		end
	-- end
end

guilds:init()

