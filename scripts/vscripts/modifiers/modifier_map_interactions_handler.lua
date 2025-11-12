require("tp")
require("triggers")

local modifierNamePrefix = "modifier_map_interactions_handler_"
local modifierAuraNamePostfix = "_aura"

local function createFastTriggerModifier(name, callback)
	local modifierName = modifierNamePrefix .. name
	local modifierAuraName = modifierNamePrefix .. name .. modifierAuraNamePostfix

	local modifier = class({})

	function modifier:IsAura()
		return true
	end

	function modifier:GetAuraRadius()
		return 150
	end

	function modifier:GetAuraSearchTeam()
		return DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end

	function modifier:GetAuraSearchType()
		return DOTA_UNIT_TARGET_HERO
	end

	function modifier:GetModifierAura()
		return modifierAuraName
	end

	modifierAura = class({})

	function modifierAura:OnCreated(keys)
		if not IsServer() then return end

		if callback then callback(self, keys) end
	end

	_G[modifierName] = modifier
	_G[modifierAuraName] = modifierAura

	LinkLuaModifier(modifierAuraName, "modifiers/modifier_map_interactions_handler", LUA_MODIFIER_MOTION_NONE)
end

local function destroyFastTriggerByName(name)
	local thinkers = Entities:FindAllByName("npc_dota_thinker")

	for i = 1, #thinkers do
		local thinker = thinkers[i]

		local mkMod = thinker:FindModifierByName(modifierNamePrefix .. name)
		if mkMod then
			UTIL_Remove(thinker)
		end
	end
end

createFastTriggerModifier("nyx", function(self, keys)
    nyxoff()
    nyxoff2()
    teleportnyx({activator = self:GetParent()})
end)

createFastTriggerModifier("necrolyte", function(self, keys)
    tp_necrolyte({activator = self:GetParent()})
end)

createFastTriggerModifier("quest109_plate_1", function(self, keys)
    quest_9({activator = self:GetParent()})
	destroyFastTriggerByName("quest109_plate_1")
end)
createFastTriggerModifier("quest109_plate_2", function(self, keys)
    quest_9({activator = self:GetParent()})
	destroyFastTriggerByName("quest109_plate_2")
end)
createFastTriggerModifier("quest109_plate_3", function(self, keys)
    quest_9({activator = self:GetParent()})
	destroyFastTriggerByName("quest109_plate_3")
end)

createFastTriggerModifier("quest111", function(self, keys)
    hiddenquest()
	destroyFastTriggerByName("quest111")
end)

local function lord_quest_custom(hActivatorHero, triggerName)
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory("item_"..triggerName)
		if Key ~= nil then
			UTIL_Remove(Key)
			local hRelay = Entities:FindByName( nil, "relay_"..triggerName )
			hRelay:Trigger(nil, nil)
			
			local quest16 = _G.players_quest_progress["main"][16]
			if quest16 and not quest16.completed then
				quest16.kill_count = (quest16.kill_count or 0) + 1
				quest_system:UpdateQuest("main", 16, quest16.kill_count)
				if quest16.kill_count >= _G.quest_data["main"][16].goal then
					quest16.completed = true
					quest_system:RemoveQuest("main", 16, "success")
				end
			end
			return true
		end
	end
end

createFastTriggerModifier("quest16_gate_plate_1", function(self, keys)
    if not lord_quest_custom(self:GetParent(), "candy1") then return end
	destroyFastTriggerByName("quest16_gate_plate_1")
end)
createFastTriggerModifier("quest16_gate_plate_2", function(self, keys)
    if not lord_quest_custom(self:GetParent(), "candy2") then return end
	destroyFastTriggerByName("quest16_gate_plate_2")
end)
createFastTriggerModifier("quest16_gate_plate_3", function(self, keys)
    if not lord_quest_custom(self:GetParent(), "candy3") then return end
	destroyFastTriggerByName("quest16_gate_plate_3")
end)
createFastTriggerModifier("quest16_gate_plate_4", function(self, keys)
    if not lord_quest_custom(self:GetParent(), "candy4") then return end
	destroyFastTriggerByName("quest16_gate_plate_4")
end)

createFastTriggerModifier("quest114_plate", function(self, keys)
    quest_114({activator = self:GetParent()})
	destroyFastTriggerByName("quest114_plate")
end)

local xDesZoneIsReady = false
local function xdes_zone_spawn_custom()
	if xDesZoneIsReady then return end
	xDesZoneIsReady = true

	Timers:CreateTimer(5, function()
		for i = 1, 10 do
			local point = Entities:FindByName( nil, "xdes_zone_"..i)
			if point then
				UTIL_Remove( point )
			end
		end	
	end)
	
	local creeps_xdes_zone = {"pudge", "npc_venom_creep", "npc_enigma", "npc_gyro", "npc_sniper", "npc_invoker_creep", "npc_mars_creep", "npc_phoenix_creep", "warlock", "npc_lifestealer", "batr", "miner", "small_hellbear", "npc_keeper_of_the_light", "treant"}

	local bResult = xpcall(function()
	
		-----------------------------------------------------------------------
		
		random_ability = passive[RandomInt(1,#passive)]	
		local count = 0
		Timers:CreateTimer(0, function()
			if count < 10 then
				count = count + 1
					local point = Entities:FindByName( nil, "xdes_zone_"..count):GetAbsOrigin()
					for i = 1, 5 do
						local unit = CreateUnitByName(creeps_xdes_zone[RandomInt(1,#creeps_xdes_zone)], point + RandomVector( RandomInt( 250, 250 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
						rules:aura_dif(unit,random_ability)
					end		
				return 0.1
			else
				return nil
			end
		end)
		if _G.Game_Difficulty > 5 then
			Timers:CreateTimer(3, function()
				Notifications:TopToAll({text="#usilenie", duration=3})
				Notifications:TopToAll({text="#DOTA_Tooltip_ability_"..random_ability, duration=3})
			end)
		end	
		
		local point = Entities:FindByName( nil, "point_panda"):GetAbsOrigin()
		local unit = CreateUnitByName("npc_xdes", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
		rules:aura_dif(unit,random_ability)
	end,
	function(e)
		print("-------------Error-------------")
		print(e)
		print("-------------Error-------------")
	end)  
	if bResult then
		print("all ok")
	else
		print("error")
	end	
end

createFastTriggerModifier("last_location_circle_traps", function(self, keys)
	_G.last_zone_circle_traps_active = false
	destroyFastTriggerByName("last_location_circle_traps")
end)
