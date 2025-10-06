if essentials == nil then
	essentials = class({})
end

function essentials:Init()
	local m = GameRules:GetGameModeEntity()
	CustomGameEventManager:RegisterListener("startreq", Dynamic_Wrap(self, 'StartReq'))

	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(essentials, 'OnEntityHurt'), self)
	essentials.dmgtable = {}
	for i=0, 4 do
		essentials.dmgtable[i] = 0
	end

	essentials.currentHpBar = false
end

function essentials:OnEntityHurt(t)
	local attacker_index = t.entindex_attacker_const
	local victim_index = t.entindex_victim_const
	if attacker_index and victim_index then
		local attacker = EntIndexToHScript(attacker_index)
		local victim = EntIndexToHScript(victim_index)
		if attacker and victim then
			if attacker:IsRealHero() then
				local pid = attacker:GetPlayerOwnerID()
				if pid and pid >= 0 then
					local hp = victim:GetHealth()
					local dmg = 0
					if attacker:IsAlive() then
						if t.damagetype_const == 2 then	
							dmg = t.damage - victim:GetBaseMagicalResistanceValue()/100 * t.damage
							if dmg > hp then
								dmg = hp	
							end
							essentials.dmgtable[pid] = essentials.dmgtable[pid] + dmg	
						elseif t.damagetype_const == 1 then
							local armor = victim:GetPhysicalArmorValue(false)
							local factor = 1 - ((0.06 * armor) / (1 + 0.06 * math.abs(armor)))
							dmg = t.damage * factor
							if dmg > hp then
								dmg = hp
							end
							essentials.dmgtable[pid] = essentials.dmgtable[pid] + dmg								
					   elseif t.damagetype_const == 4 then
							dmg = t.damage
							if dmg > hp then
								dmg = hp
							end
							essentials.dmgtable[pid] = essentials.dmgtable[pid] + dmg
						end
					end
					
					if _G.player_quest[pid]['damage_quest'] == nil then
						_G.player_quest[pid]['damage_quest'] = dmg
					else
						_G.player_quest[pid]['damage_quest'] = _G.player_quest[pid]['damage_quest'] + dmg
					end	
				end	
			end
		end
	end
	return true
end


function essentials:ShowNewLoc(name,name2,image,time)
	CustomGameEventManager:Send_ServerToAllClients("showLoc", {name=name,name2=name2,image=image,time=time})
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