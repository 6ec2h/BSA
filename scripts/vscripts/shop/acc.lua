if acc == nil then
    _G.acc = class({})
end

function acc:RegisterHudListener( event_name, function_name )
	CustomGameEventManager:RegisterListener( event_name, function( _, kv ) 
		self[ function_name ]( self, kv )
	end )
end

function acc:init()
	_G.acc.arr = {}	
	self:RegisterHudListener( "add_point_skill", "add_skill_point" )
end

function acc:CreateAcc()
	for i = 0, PlayerResource:GetPlayerCount() -1  do
		if PlayerResource:IsValidPlayer(i) then
			local sid = PlayerResource:GetSteamAccountID(i)
			CustomNetTables:SetTableValue("statistic","HeroList_"..sid, {_G.Account_stats[sid]});
		end	
	end
end				

function acc:add_skill_point(t)
	local sid = PlayerResource:GetSteamAccountID(t.PlayerID)	
	local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
	if _G.Account_stats[sid][t.type] < 25 and _G.Account_stats[sid].skill_points > 0 then
		_G.Account_stats[sid][t.type] = _G.Account_stats[sid][t.type] + 1
		_G.Account_stats[sid].skill_points = _G.Account_stats[sid].skill_points - 1
		CustomNetTables:SetTableValue("statistic","HeroList_"..sid, {_G.Account_stats[sid]})
		for skill, key in pairs(Account_stats[sid]) do
			if skill == t.type then
				local mod = hero:FindModifierByName("modifier_"..skill)
				mod:SetStackCount(mod:GetStackCount() + 1)	
			end
		end
		EmitSoundOnEntityForPlayer("HeroBadgeLevelUpReward.ShowReward", hero, hero:GetPlayerOwnerID())
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.PlayerID), "initaccount", _G.Account_stats[sid] )
				
		local arr = {
			sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
			name = t.type,
		}
		arr = json.encode(arr)
		local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_add_point/?key=".._G.key )
		req:SetHTTPRequestGetOrPostParameter('arr',arr)
		req:SetHTTPRequestAbsoluteTimeoutMS(100000)
		req:Send(function(res)
			if res.StatusCode == 200 then
				
				print(res.Body)
			else 
				print(res.StatusCode)
			end
		end)
	end
end

acc:init()

