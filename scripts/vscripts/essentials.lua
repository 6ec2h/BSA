if essentials == nil then
	essentials = class({})
end

function essentials:Init()
	local m = GameRules:GetGameModeEntity()
	-- ListenToGameEvent(string EventName,Dynamic_Wrap(MyCustomGameMode, 'OnEntityKilled'), self)
	CustomGameEventManager:RegisterListener("startreq", Dynamic_Wrap(self, 'StartReq'))
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(essentials, 'OnEntityHurt'), self)
	ListenToGameEvent('entity_hurt', Dynamic_Wrap(self, 'OnEntityHurt'), self)
	essentials.currentHpBar = false
	essentials.dmgtable = {}
	m:SetThink( "OnThink", self, "dmgTableEssentialTick", 0.1 )
end

function essentials:OnThink()
	local list = HeroList:GetAllHeroes()
	for k,v in pairs(list) do 
		if not v:IsClone() and v:IsRealHero() and v:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			essentials.dmgtable[v:entindex()] = essentials.dmgtable[v:entindex()] or {}
			essentials.dmgtable[v:entindex()]['heal'] = PlayerResource:GetHealing(v:GetPlayerID())
		end
	end
	CustomGameEventManager:Send_ServerToAllClients("dmgtable", essentials.dmgtable)
	return 1
end

function essentials:ShowNewLoc(name,name2,image,time)
	CustomGameEventManager:Send_ServerToAllClients("showLoc", {name=name,name2=name2,image=image,time=time})
end

function essentials:OnEntityHurt(t)
	local attacker_index = t.entindex_attacker_const
	local victim_index = t.entindex_victim_const
	if attacker_index and victim_index then
		local attacker = EntIndexToHScript(attacker_index)
		local victim = EntIndexToHScript(victim_index)
		if attacker and victim then
			if attacker.GetPlayerOwnerID then
				local attackerPlayerId = attacker:GetPlayerOwnerID()
				if victim and victim:GetDayTimeVisionRange() ~= 1337 then
					if attackerPlayerId and attackerPlayerId >= 0 then
                        local hp = victim:GetHealth()
                        local dmg
						if attacker:IsAlive() then
							if not attacker:IsRealHero() and attacker:IsControllableByAnyPlayer() then
								t.entindex_attacker = PlayerResource:GetSelectedHeroEntity(attacker:GetMainControllingPlayer()):entindex()
							else
								t.entindex_attacker = PlayerResource:GetSelectedHeroEntity(attacker:GetPlayerID()):entindex()
							end
							 if t.damagetype_const == 2 then	
								essentials.dmgtable[t.entindex_attacker] = essentials.dmgtable[t.entindex_attacker] or {}
								dmg = t.damage - victim:GetBaseMagicalResistanceValue()/100 * t.damage
								if dmg > hp then
									dmg = hp	
								end
								essentials.dmgtable[t.entindex_attacker]['mag'] = essentials.dmgtable[t.entindex_attacker]['mag'] or 0
								essentials.dmgtable[t.entindex_attacker]['mag'] = essentials.dmgtable[t.entindex_attacker]['mag'] + dmg
							elseif t.damagetype_const == 1 then
								essentials.dmgtable[t.entindex_attacker] = essentials.dmgtable[t.entindex_attacker] or {}
								local armor = victim:GetPhysicalArmorValue(false)
								local factor = 1 - ((0.06 * armor) / (1 + 0.06 * math.abs(armor)))
								dmg = t.damage * factor
								if dmg > hp then
									dmg = hp
								end
								essentials.dmgtable[t.entindex_attacker]['dmg'] = essentials.dmgtable[t.entindex_attacker]['dmg'] or 0
								essentials.dmgtable[t.entindex_attacker]['dmg'] = essentials.dmgtable[t.entindex_attacker]['dmg'] + dmg
						   elseif t.damagetype_const == 4 then
								essentials.dmgtable[t.entindex_attacker] = essentials.dmgtable[t.entindex_attacker] or {}
								dmg = t.damage
								if dmg > hp then
									dmg = hp
								end
								if victim ~= attacker then
									essentials.dmgtable[t.entindex_attacker]['pure'] = essentials.dmgtable[t.entindex_attacker]['pure'] or 0
									essentials.dmgtable[t.entindex_attacker]['pure'] = essentials.dmgtable[t.entindex_attacker]['pure'] + dmg
								end
							end
						end
					end	
				end
				if victim and not victim:IsNull() and victim:IsRealHero() then
					local hp = victim:GetHealth()
					local dmg
					t.entindex_killed = PlayerResource:GetSelectedHeroEntity(victim:GetPlayerID()):entindex()
						if t.damagetype_const == 2 then	
							essentials.dmgtable[t.entindex_killed] = essentials.dmgtable[t.entindex_killed] or {}
                            dmg = t.damage - victim:GetBaseMagicalResistanceValue()/100 * t.damage
                            if dmg > hp then
                                dmg = hp	
                            end
							essentials.dmgtable[t.entindex_killed]['tank'] = essentials.dmgtable[t.entindex_killed]['tank'] or 0
							essentials.dmgtable[t.entindex_killed]['tank'] = essentials.dmgtable[t.entindex_killed]['tank'] + dmg
                        elseif t.damagetype_const == 1 then
							essentials.dmgtable[t.entindex_killed] = essentials.dmgtable[t.entindex_killed] or {}
                            local armor = victim:GetPhysicalArmorValue(false)
                            local factor = 1 - ((0.06 * armor) / (1 + 0.06 * math.abs(armor)))
                            dmg = t.damage * factor
                            if dmg > hp then
                                dmg = hp
                            end
							essentials.dmgtable[t.entindex_killed]['tank'] = essentials.dmgtable[t.entindex_killed]['tank'] or 0
							essentials.dmgtable[t.entindex_killed]['tank'] = essentials.dmgtable[t.entindex_killed]['tank'] + dmg
                       elseif t.damagetype_const == 4 then
							essentials.dmgtable[t.entindex_killed] = essentials.dmgtable[t.entindex_killed] or {}
                            dmg = t.damage
                            if dmg > hp then
                                dmg = hp
                            end
							essentials.dmgtable[t.entindex_killed]['tank'] = essentials.dmgtable[t.entindex_killed]['tank'] or 0
							essentials.dmgtable[t.entindex_killed]['tank'] = essentials.dmgtable[t.entindex_killed]['tank'] + dmg
                        end	
					end
				end
			end
		end
		
	return true
end

function essentials:createCustomHpBarFor(unit)
	if unit and not unit:IsNull() and unit:IsAlive() then
		essentials.currentHpBar=unit
		CustomGameEventManager:Send_ServerToAllClients("showHpBar", {unit=unit:entindex()})
	end
end

function essentials:StartReq(t)
	local p = t.PlayerID
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(p),"showHpBar", {unit=essentials.currentHpBar})
end