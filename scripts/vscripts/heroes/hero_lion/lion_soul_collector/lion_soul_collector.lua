LinkLuaModifier("modifier_lion_soul_collector", "heroes/hero_lion/lion_soul_collector/lion_soul_collector", LUA_MODIFIER_MOTION_NONE)

lion_soul_collector = class({})

function lion_soul_collector:GetIntrinsicModifierName()
	return "modifier_lion_soul_collector"
end
-------------------
modifier_lion_soul_collector  = class({})

function modifier_lion_soul_collector:IsHidden()
	if self:GetStackCount() >= 1 then 
		return false
	else
		return true
	end
end

function modifier_lion_soul_collector:IsPurgable()
    return false
end
 
function modifier_lion_soul_collector:RemoveOnDeath()
    return false
end

function modifier_lion_soul_collector:OnCreated(kv)
end



function modifier_lion_soul_collector:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,			
    }
end

function modifier_lion_soul_collector:OnDeath(params)
	count = 1
	local abil = self:GetParent():FindAbilityByName("npc_dota_hero_lion_int10")	
	if abil ~= nil and abil:GetLevel() > 0 then 
	count = 2
	end
	for i = 1, count do					
		local parent = self:GetParent()
		if IsMyKilledBadGuys(parent, params) then
			self:IncrementStackCount()
			parent:CalculateStatBonus(true)
			--parent:Heal(10, nil)
			end
		end
end

creeps_add = {"satyr_soulstealer","satyr_hellcaller","npc_dota_creature_hellbear","npc_dota_creature_small_hellbear","npc_dota_creature_dire_hound","npc_dota_creature_dire_hound_boss",
"forest_zombie","skeleton","npc_creep_crystal","apparat","tusk","icespider","white_walker","mirana","npc_dota_creature_large_ogre_seal","guard","npc_trap_visage","tank","undying","morf",
"npc_blob","npc_slardar_unit","npc_shaker","npc_zone_jungle_1","npc_zone_jungle_2","npc_zone_jungle_3","npc_zone_jungle_4","npc_keeper_of_the_light","miner","small_hellbear","encha","treant",
"npc_lifestealer","batr","warlock","pudge","npc_venom_creep","demon","npc_gyro","npc_enigma","npc_sniper","npc_disruptor","cher"}

function IsMyKilledBadGuys(hero, params)
    if params.unit:GetTeamNumber() ~= DOTA_TEAM_NEUTRALS then
        return false
    end

	local attacker = params.attacker
	local unit_name = params.unit:GetUnitName()
		for _,current_name in pairs(creeps_add) do
			if current_name == unit_name and hero == attacker then

				return true
			end
		end
end