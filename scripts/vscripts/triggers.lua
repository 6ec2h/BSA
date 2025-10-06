LinkLuaModifier( "modifier_fire_points", "modifiers/modifier_fire_points", LUA_MODIFIER_MOTION_NONE )

function OnLavaEnter(trigger)
    local ent = trigger.activator
    if not ent then return end
    if ent:IsAlive() then
		ent:AddNewModifier( ent, self, "modifier_fire_points", {} )
        return
    end
end

function OnLavaExit(trigger)
    local ent = trigger.activator
    if not ent then return end
    if ent:IsAlive() then
		ent:RemoveModifierByName("modifier_fire_points") 
        return
    end
end

--------------------------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_acid_damage", "modifiers/modifier_acid_damage", LUA_MODIFIER_MOTION_NONE )

function OnSlowEnter(trigger)
    local ent = trigger.activator
    if not ent then return end
    if ent:IsAlive() then
		ent:AddNewModifier( ent, self, "modifier_acid_damage", {} )
        return
    end
end

function OnSlowExit(trigger)
    local ent = trigger.activator
    if not ent then return end
    if ent:IsAlive() then
		ent:RemoveModifierByName("modifier_acid_damage") 
        return
    end
end

----------------------------------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_acid", "modifiers/modifier_acid", LUA_MODIFIER_MOTION_NONE )

function OnSlowEnter2(trigger)
    local ent = trigger.activator
    if not ent then return end
    if ent:IsAlive() then
		ent:AddNewModifier( ent, self, "modifier_acid", {} )
        return
    end
end

function OnSlowExit2(trigger)
    local ent = trigger.activator
    if not ent then return end
    if ent:IsAlive() then
		ent:RemoveModifierByName("modifier_acid") 
        return
    end
end

--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------


function add_quest_1(trigger)
	local hActivatorHero = trigger.activator
	
	if not _G.players_quest_progress["additional"][102] then
		local data = _G.quest_data["additional"][102].target
		quest_system:StartQuest("additional", 102, data[RandomInt(1, 6)])
		return
	end
	
	if hActivatorHero and not _G.players_quest_progress["additional"][102].completed then
		local Key = hActivatorHero:FindItemInInventory(_G.players_quest_progress["additional"][102].target)
		if Key then
			_G.players_quest_progress["additional"][102].completed = true
			quest_system:RemoveQuest("additional", 102, "success")
		end
	end
end

function add_quest_2(trigger)
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
		local hero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
		if hero and hero:GetTeam() == DOTA_TEAM_GOODGUYS then
			hero:SetHealth(hero:GetMaxHealth())
			hero:SetMana(hero:GetMaxMana())
			hero:Purge(false, true, false, true, false)
		end	
	end	
	quest_system:StartQuest("additional", 103)
end

function add_quest_3(trigger)
	local hActivatorHero = trigger.activator

	if not _G.players_quest_progress["additional"][104] then
		quest_system:StartQuest("additional", 104, _G.quest_data["additional"][104].target[1])
		return
	end
	
	if hActivatorHero and not _G.players_quest_progress["additional"][104].completed then
		local Key = hActivatorHero:FindItemInInventory(_G.quest_data["additional"][104].target[1])
		if Key then
			UTIL_Remove(Key)
			_G.players_quest_progress["additional"][104].completed = true
			quest_system:RemoveQuest("additional", 104, "success")
		end
	end
end

function quest_9(trigger)
	local hActivatorHero = trigger.activator
	hActivatorHero:EmitSound("tutorial_gate_open_metal")
	local quest_9 = _G.players_quest_progress["additional"][109]
	if quest_9 and not quest_9.completed then
		quest_9.kill_count = (quest_9.kill_count or 0) + 1
		quest_system:UpdateQuest("additional", 109, quest_9.kill_count)
		if quest_9.kill_count >= _G.quest_data["additional"][109].goal then
			quest_9.completed = true
			quest_system:RemoveQuest("additional", 109, "success")
		end
	end
end

function hiddenquest()
	Notifications:TopToAll({text="#minihidden", duration=5})
	local quest_111 = _G.players_quest_progress["additional"][111]
	if quest_111 and not quest_111.completed then
		quest_111.kill_count = (quest_111.kill_count or 0) + 1
		quest_system:UpdateQuest("additional", 111, quest_111.kill_count)
		if quest_111.kill_count >= _G.quest_data["additional"][111].goal then
			quest_111.completed = true
			quest_system:RemoveQuest("additional", 111, "success")
		end
	end
end

function quest_114(trigger)
	local hActivatorHero = trigger.activator
	hActivatorHero:EmitSound("tutorial_gate_open_metal")
	local quest_114 = _G.players_quest_progress["additional"][114]
	if quest_114 and not quest_114.completed then
		quest_114.kill_count = (quest_114.kill_count or 0) + 1
		quest_system:UpdateQuest("additional", 114, quest_114.kill_count)
		if quest_114.kill_count >= _G.quest_data["additional"][114].goal then
			quest_114.completed = true
			quest_system:RemoveQuest("additional", 114, "success")
		end
	end
end

function reward()
	local rewardPoint = Entities:FindByName(nil, "reward_point")
	local point = rewardPoint:GetAbsOrigin()
	local rewards = {"middle_box", "small_box", "small_box"}
	local rewardIndex = RandomInt(1, #rewards)
	local hUnit = CreateUnitByName(rewards[rewardIndex], point + RandomVector(RandomInt(0, 0)), true, nil, nil, DOTA_TEAM_BADGUYS)
	local unit = Entities:FindByName(nil, "lighter2")
	unit:SetDayTimeVisionRange(1500)
	unit:SetNightTimeVisionRange(1500)
	local particleLeader = ParticleManager:CreateParticle("particles/dire_fx/fire_barracks.vpcf", PATTACH_OVERHEAD_FOLLOW, unit)
	ParticleManager:SetParticleControlEnt(particleLeader, PATTACH_OVERHEAD_FOLLOW, unit, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", unit:GetAbsOrigin(), true)
	
	quest_system:StartQuest("additional", 112)
end

function orb(trigger)
	local hActivatorHero = trigger.activator
	
	local main_quest = _G.players_quest_progress["main"][11]
	if main_quest and main_quest.completed then
		return
	end

	local orb_quest = _G.players_quest_progress["additional"][110]
	if not orb_quest then
		quest_system:StartQuest('additional', 110, 'item_orb')
		return
	end

	if orb_quest and not orb_quest.completed then
		local Key = hActivatorHero:FindItemInInventory( "item_orb" )
		if Key ~= nil then
			UTIL_Remove(Key)
			hActivatorHero:EmitSound("Item.DropGemWorld")
			
			orb_quest.completed = true
			quest_system:RemoveQuest("additional", 110, "success")
			
			local point = Entities:FindByName( nil, "drop_point_orb_quest"):GetAbsOrigin() 
			local hUnit = CreateUnitByName("middle_box", point + RandomVector( RandomInt( 0, 20 )), true, nil, nil, DOTA_TEAM_BADGUYS)
			hUnit:EmitSound("Item.DropGemWorld")
			
			randomspawnshovel()
			
			local unit = Entities:FindByName( nil, "lighter3")
			unit:SetDayTimeVisionRange( 1500 )
			unit:SetNightTimeVisionRange( 1500 )
			local particleLeader = ParticleManager:CreateParticle( "particles/dire_fx/fire_barracks.vpcf", PATTACH_OVERHEAD_FOLLOW, unit ) 
			ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, unit, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", unit:GetAbsOrigin(), true )
			unit:Attribute_SetIntValue( "particleID", particleLeader )
		end
	end
end

function naga_head(trigger)
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_naga_stone" )
		if Key ~= nil and Key:GetCurrentCharges() >= 30 then
			UTIL_Remove(Key)
			local quest10 = _G.players_quest_progress["main"][10]
			if quest10 and not quest10.completed then
				quest10.completed = true
				quest_system:RemoveQuest("main", 10, "success")
				hActivatorHero:EmitSound("tutorial_gate_open_metal")
			end
		end
	end
end

function lord_quest(trigger)
	local triggerName = thisEntity:GetName()
	local hActivatorHero = trigger.activator
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
		end
	end
end

function tiny_quest(trigger)
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_prison_cell_key" )
		if Key ~= nil then
			UTIL_Remove(Key)
			local hRelay = Entities:FindByName( nil, "open_tiny_gate" )
			hRelay:Trigger(nil,nil)
			-- local quest7 = _G.players_quest_progress["main"][7]
			-- if quest7 and not quest7.completed then
				-- quest7.completed = true
				-- quest_system:RemoveQuest("main", 7, "success")
				-- hActivatorHero:EmitSound("tutorial_gate_open_metal")
			-- end
		end
	end
end

function last_room_gate(trigger)
    local hActivatorHero = trigger.activator
	local triggerName = thisEntity:GetName()
    hActivatorHero:EmitSound("tutorial_gate_open_metal")

    local quest_22 = _G.players_quest_progress["main"][22]

    local key = hActivatorHero:FindItemInInventory("item_"..triggerName)
	if key ~= nil and quest_22 and not quest_22.completed then
		UTIL_Remove(key)
		quest_22.kill_count = (quest_22.kill_count or 0) + 1
		quest_system:UpdateQuest("main", 22, quest_22.kill_count)
		if quest_22.kill_count >= _G.quest_data["main"][22].goal then
			quest_22.completed = true
			quest_system:RemoveQuest("main", 22, "success")
			hActivatorHero:EmitSound("tutorial_gate_open_metal")
		end
	end
end

function invasion()
	quest_system:invasion()
end

function randomspawnshovel()
    local item = CreateItem("item_shovel", nil, nil)
	local pos_int = RandomInt(1, 6)
    local pos = Entities:FindByName( nil, "shov"..pos_int):GetAbsOrigin() 
    local drop = CreateItemOnPositionSync(pos, item)
    item:LaunchLoot(false, 0, 150, 0.5, pos)
end

