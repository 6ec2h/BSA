if inventory == nil then
    _G.inventory = class({})
end

local hero_inv = {
    [0] = {head = {},armor = {},glovers={},weapon={},pants={},boots={}},
    [1] = {head = {},armor = {},glovers={},weapon={},pants={},boots={}},
    [2] = {head = {},armor = {},glovers={},weapon={},pants={},boots={}},
    [3] = {head = {},armor = {},glovers={},weapon={},pants={},boots={}},
    [4] = {head = {},armor = {},glovers={},weapon={},pants={},boots={}},
}

local can_use_items = {
	head = {"item_set_head_str_1_set_1","item_set_head_str_2_set_1","item_set_head_str_3_set_1","item_set_head_str_4_set_1","item_set_head_str_5_set_1",
			"item_set_head_agi_1_set_1","item_set_head_agi_2_set_1","item_set_head_agi_3_set_1","item_set_head_agi_4_set_1","item_set_head_agi_5_set_1",
			"item_set_head_int_1_set_1","item_set_head_int_2_set_1","item_set_head_int_3_set_1","item_set_head_int_4_set_1","item_set_head_int_5_set_1",
			"item_set_head_str_1_set_2","item_set_head_str_2_set_2","item_set_head_str_3_set_2","item_set_head_str_4_set_2","item_set_head_str_5_set_2",
			"item_set_head_agi_1_set_2","item_set_head_agi_2_set_2","item_set_head_agi_3_set_2","item_set_head_agi_4_set_2","item_set_head_agi_5_set_2",
			"item_set_head_int_1_set_2","item_set_head_int_2_set_2","item_set_head_int_3_set_2","item_set_head_int_4_set_2","item_set_head_int_5_set_2",
			},
		
	armor = {"item_set_armor_str_1_set_1","item_set_armor_str_2_set_1","item_set_armor_str_3_set_1","item_set_armor_str_4_set_1","item_set_armor_str_5_set_1",
			"item_set_armor_agi_1_set_1","item_set_armor_agi_2_set_1","item_set_armor_agi_3_set_1","item_set_armor_agi_4_set_1","item_set_armor_agi_5_set_1",
			"item_set_armor_int_1_set_1","item_set_armor_int_2_set_1","item_set_armor_int_3_set_1","item_set_armor_int_4_set_1","item_set_armor_int_5_set_1",
			"item_set_armor_str_1_set_2","item_set_armor_str_2_set_2","item_set_armor_str_3_set_2","item_set_armor_str_4_set_2","item_set_armor_str_5_set_2",
			"item_set_armor_agi_1_set_2","item_set_armor_agi_2_set_2","item_set_armor_agi_3_set_2","item_set_armor_agi_4_set_2","item_set_armor_agi_5_set_2",
			"item_set_armor_int_1_set_2","item_set_armor_int_2_set_2","item_set_armor_int_3_set_2","item_set_armor_int_4_set_2","item_set_armor_int_5_set_2",},
		
	glovers = {"item_set_glov_str_1_set_1","item_set_glov_str_2_set_1","item_set_glov_str_3_set_1","item_set_glov_str_4_set_1","item_set_glov_str_5_set_1",
			"item_set_glov_agi_1_set_1","item_set_glov_agi_2_set_1","item_set_glov_agi_3_set_1","item_set_glov_agi_4_set_1","item_set_glov_agi_5_set_1",
            "item_set_glov_int_1_set_1","item_set_glov_int_2_set_1","item_set_glov_int_3_set_1","item_set_glov_int_4_set_1","item_set_glov_int_5_set_1",
			"item_set_glov_str_1_set_2","item_set_glov_str_2_set_2","item_set_glov_str_3_set_2","item_set_glov_str_4_set_2","item_set_glov_str_5_set_2",
			"item_set_glov_agi_1_set_2","item_set_glov_agi_2_set_2","item_set_glov_agi_3_set_2","item_set_glov_agi_4_set_2","item_set_glov_agi_5_set_2",
            "item_set_glov_int_1_set_2","item_set_glov_int_2_set_2","item_set_glov_int_3_set_2","item_set_glov_int_4_set_2","item_set_glov_int_5_set_2",},
		
	weapon = {"item_set_weapon_str_1_set_1","item_set_weapon_str_2_set_1","item_set_weapon_str_3_set_1","item_set_weapon_str_4_set_1","item_set_weapon_str_5_set_1",
            "item_set_weapon_agi_1_set_1","item_set_weapon_agi_2_set_1","item_set_weapon_agi_3_set_1","item_set_weapon_agi_4_set_1","item_set_weapon_agi_5_set_1",
            "item_set_weapon_int_1_set_1","item_set_weapon_int_2_set_1","item_set_weapon_int_3_set_1","item_set_weapon_int_4_set_1","item_set_weapon_int_5_set_1",
			"item_set_weapon_str_1_set_2","item_set_weapon_str_2_set_2","item_set_weapon_str_3_set_2","item_set_weapon_str_4_set_2","item_set_weapon_str_5_set_2",
            "item_set_weapon_agi_1_set_2","item_set_weapon_agi_2_set_2","item_set_weapon_agi_3_set_2","item_set_weapon_agi_4_set_2","item_set_weapon_agi_5_set_2",
            "item_set_weapon_int_1_set_2","item_set_weapon_int_2_set_2","item_set_weapon_int_3_set_2","item_set_weapon_int_4_set_2","item_set_weapon_int_5_set_2",},
		
	pants = {"item_set_shield_str_1_set_1", "item_set_shield_str_2_set_1", "item_set_shield_str_3_set_1", "item_set_shield_str_4_set_1", "item_set_shield_str_5_set_1",
			"item_set_shield_agi_1_set_1", "item_set_shield_agi_2_set_1", "item_set_shield_agi_3_set_1", "item_set_shield_agi_4_set_1", "item_set_shield_agi_5_set_1",
			"item_set_shield_int_1_set_1", "item_set_shield_int_2_set_1", "item_set_shield_int_3_set_1", "item_set_shield_int_4_set_1", "item_set_shield_int_5_set_1",
			"item_set_shield_str_1_set_2", "item_set_shield_str_2_set_2", "item_set_shield_str_3_set_2", "item_set_shield_str_4_set_2", "item_set_shield_str_5_set_2",
			"item_set_shield_agi_1_set_2", "item_set_shield_agi_2_set_2", "item_set_shield_agi_3_set_2", "item_set_shield_agi_4_set_2", "item_set_shield_agi_5_set_2",
			"item_set_shield_int_1_set_2", "item_set_shield_int_2_set_2", "item_set_shield_int_3_set_2", "item_set_shield_int_4_set_2", "item_set_shield_int_5_set_2",},

	boots = {"item_set_boots_str_1_set_1", "item_set_boots_str_2_set_1", "item_set_boots_str_3_set_1", "item_set_boots_str_4_set_1", "item_set_boots_str_5_set_1",
			"item_set_boots_agi_1_set_1", "item_set_boots_agi_2_set_1", "item_set_boots_agi_3_set_1", "item_set_boots_agi_4_set_1", "item_set_boots_agi_5_set_1",
			"item_set_boots_int_1_set_1", "item_set_boots_int_2_set_1", "item_set_boots_int_3_set_1", "item_set_boots_int_4_set_1", "item_set_boots_int_5_set_1",
			"item_set_boots_str_1_set_2", "item_set_boots_str_2_set_2", "item_set_boots_str_3_set_2", "item_set_boots_str_4_set_2", "item_set_boots_str_5_set_2",
			"item_set_boots_agi_1_set_2", "item_set_boots_agi_2_set_2", "item_set_boots_agi_3_set_2", "item_set_boots_agi_4_set_2", "item_set_boots_agi_5_set_2",
			"item_set_boots_int_1_set_2", "item_set_boots_int_2_set_2", "item_set_boots_int_3_set_2", "item_set_boots_int_4_set_2", "item_set_boots_int_5_set_2",}
}			

function inventory:init()
    CustomGameEventManager:RegisterListener("up_item_level", Dynamic_Wrap( inventory, 'up_item_level' ))
    CustomGameEventManager:RegisterListener("put_item_lua", Dynamic_Wrap( inventory, 'put_item_lua' ))
    CustomGameEventManager:RegisterListener("return_item_lua", Dynamic_Wrap( inventory, 'return_item_lua' ))
	ListenToGameEvent("player_reconnected", Dynamic_Wrap( inventory, 'OnPlayerReconnected' ), self)
	ListenToGameEvent("player_chat", Dynamic_Wrap( inventory, "OnChat" ), self )
end

function inventory:OnChat( event )
    local text = event.text 
	local pid = event.playerid
end

function inventory:OnPlayerReconnected(t)
    local state = GameRules:State_Get()
    if state >= DOTA_GAMERULES_STATE_PRE_GAME then
        Timers:CreateTimer(2, function()
            CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "update_hero_inv",  {})
		end)
    end
end

function inventory:put_item_lua(t)
    local slot = t.slot
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    if hero then
        local current_item = hero:GetItemInSlot(slot)
        if current_item then
            local item_name = current_item:GetName()
            local item_level = current_item:GetLevel()
            if hero:GetName() ~= current_item:GetPurchaser():GetName() or slot > 8 then return end
            if t.type == nil then
                t.item_name = item_name
                return
            end
			if searchElement(can_use_items[t.type], item_name) then
				local event = {
					item_name = item_name,
					item_level = item_level,
					item_keys = inventory:GetItemKey(item_name),
					slot = t.type,
				}

				hero_inv[t.PlayerID][t.type]['item'] = item_name
				hero_inv[t.PlayerID][t.type]['level'] = item_level
				
				CustomNetTables:SetTableValue("item_hero_set","item_hero_set"..t.PlayerID, hero_inv);

				add_mod(hero, item_name, current_item)
				hero:RemoveItem(current_item)
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "put_item_js", event )
			end
        end
    end
end

function inventory:GetItemKey(item_name)
	local keys = {}
	local kv = LoadKeyValues("scripts/npc/npc_items_sets.txt")[item_name]
	for k, v in pairs(kv.AbilitySpecial) do
		for key, value in pairs(v) do
			if key ~= "var_type" then
				table.insert(keys, key)
			end
		end
	end
	return keys
end

_G.ItemsKV = LoadKeyValues("scripts/npc/npc_items_sets.txt")

function add_mod(hero, item, current_item)
	for k,v in pairs(ItemsKV) do
		if k == item then
			mod = string.sub(item, 1, -9) -- item_set_head_str
			set = string.sub(item, -5)  -- set_1
			folder = string.sub(mod, -3) -- str
			LinkLuaModifier("modifier_"..mod.."_"..set, "items/set_items/items_modifiers/"..set.."/"..folder.."/modifier_"..mod.."_"..set, LUA_MODIFIER_MOTION_NONE) -- modifier_item_set_armor_agi_set_1
			hero:AddNewModifier( hero, current_item, "modifier_"..mod.."_"..set, {})
		end
	end
end

function searchElement(array, element)
	for i, value in ipairs(array) do
		if value == element then
			return true
		end
	end
	return false
end

function inventory:return_item_lua(t)
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
	if t.item then
		local return_item = hero:AddItemByName(t.item)
        if return_item then
			return_item:SetPurchaseTime(0)
			return_item:SetLevel(hero_inv[t.PlayerID][t.type]['level'])
		end
		local event = {
			item_name = item_name,	
			slot = t.type,
		}
		mod = string.sub(t.item, 1, -9)
		set = string.sub(t.item, -5)

		hero_inv[t.PlayerID][t.type]['item'] = ''
		hero_inv[t.PlayerID][t.type]['level'] = ''

		CustomNetTables:SetTableValue("item_hero_set","item_hero_set"..t.PlayerID, hero_inv);
		hero:RemoveModifierByName('modifier_'..mod.."_"..set)
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "return_item_js", event)	
	end
end

-- ===========================================================

function inventory:up_item_level(t)
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
	if t.item then
		local item1_found = false
		local item2_found = false
		
		local target_item = nil
		local target_kamen = nil

		for i=0,5 do
			local item = hero:GetItemInSlot(i)
			if item and item:GetAbilityName() == t.item then
				item1_found = true
				target_item = item
				break
			end
		end

		for i=0,5 do
			local item = hero:GetItemInSlot(i)
			if item and item:GetAbilityName() == 'item_kamen_boga' then
				item2_found = true
				target_kamen = item
				break
			end
		end

		if item1_found and item2_found then
			local item_level = target_item:GetLevel()
			local kamen_charges = target_kamen:GetCurrentCharges()
			
			if item_level == 13 then 
				return
			end
			
			if item_level <= 4 then
				chance = 100
			else
				chance = 100 - ((4-item_level)*(-10))
			end
			
			if RandomInt(1,100) <= chance then
				target_item:SetLevel(item_level + 1)
				EmitSoundOn( 'compendium_levelup', hero)
				-- compendium_levelup
			else
				EmitSoundOn( 'ui.inv_equip_gun', hero)
				--			
			end
			if kamen_charges > 1 then
				target_kamen:SetCurrentCharges(kamen_charges - 1)
			else
				UTIL_Remove( target_kamen )
			end
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.PlayerID),"Upgrade_activate", SearchForItems(hero))
		end
	end
end

function SearchForItems(hero)
	hero_items = {}
	hero_items['set'] = {}
	hero_items['kamen'] = {}
	for i = 0, 5 do
		local item = hero:GetItemInSlot(i)
		if item then
			if string.find(item:GetAbilityName(), "_set_") then --or item:GetAbilityName() == 'item_kamen_boga' then
				hero_items['set'][item:GetAbilityName()] = item:GetLevel()
			end
			if item:GetAbilityName() == 'item_kamen_boga' then
				hero_items['kamen'][item:GetAbilityName()] = item:GetCurrentCharges()
			end
		end
	end
	return hero_items
end