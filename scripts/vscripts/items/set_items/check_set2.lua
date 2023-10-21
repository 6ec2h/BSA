check_set = class({})
LinkLuaModifier( "modifier_check_set", "items/set_items/check_set", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_item_str_2", "items/set_items/modifiers/str/modifier_item_str_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_str_3", "items/set_items/modifiers/str/modifier_item_str_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_str_4", "items/set_items/modifiers/str/modifier_item_str_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_str_5", "items/set_items/modifiers/str/modifier_item_str_5", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_str_6", "items/set_items/modifiers/str/modifier_item_str_6", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_item_agi_2", "items/set_items/modifiers/agi/modifier_item_agi_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_agi_3", "items/set_items/modifiers/agi/modifier_item_agi_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_agi_4", "items/set_items/modifiers/agi/modifier_item_agi_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_agi_5", "items/set_items/modifiers/agi/modifier_item_agi_5", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_agi_6", "items/set_items/modifiers/agi/modifier_item_agi_6", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_item_int_2", "items/set_items/modifiers/int/modifier_item_int_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_int_3", "items/set_items/modifiers/int/modifier_item_int_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_int_4", "items/set_items/modifiers/int/modifier_item_int_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_int_5", "items/set_items/modifiers/int/modifier_item_int_5", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_int_6", "items/set_items/modifiers/int/modifier_item_int_6", LUA_MODIFIER_MOTION_NONE )

local STR_SET_ITEMS = {
    "modifier_item_set_boots_str",
    "modifier_item_set_head_str",
    "modifier_item_set_glov_str",
    "modifier_item_set_armor_str",
    "modifier_item_set_shield_str",
    "modifier_item_set_weapon_str",
}
local AGI_SET_ITEMS = {
    "modifier_item_set_boots_agi",
    "modifier_item_set_head_agi",
    "modifier_item_set_glov_agi",
    "modifier_item_set_armor_agi",
    "modifier_item_set_shield_agi",
    "modifier_item_set_weapon_agi",
}
local INT_SET_ITEMS = {
    "modifier_item_set_boots_int",
    "modifier_item_set_head_int",
    "modifier_item_set_glov_int",
    "modifier_item_set_armor_int",
    "modifier_item_set_shield_int",
    "modifier_item_set_weapon_int",
}

-- local STR_SET_ITEMS = {
	-- set_1 = {
		-- "modifier_item_set_boots_str_set_1",
		-- "modifier_item_set_head_str_set_1",
		-- "modifier_item_set_glov_str_set_1",
		-- "modifier_item_set_armor_str_set_1",
		-- "modifier_item_set_shield_str_set_1",
		-- "modifier_item_set_weapon_str_set_1",
	-- },
	-- set_2 = {
		-- "modifier_item_set_boots_str_set_2",
		-- "modifier_item_set_head_str_set_2",
		-- "modifier_item_set_glov_str_set_2",
		-- "modifier_item_set_armor_str_set_2",
		-- "modifier_item_set_shield_str_set_2",
		-- "modifier_item_set_weapon_str_set_2",
	-- }	
-- }
-- local AGI_SET_ITEMS = {
	-- set_1 = {
		-- "modifier_item_set_boots_agi_set_1",
		-- "modifier_item_set_head_agi_set_1",
		-- "modifier_item_set_glov_agi_set_1",
		-- "modifier_item_set_armor_agi_set_1",
		-- "modifier_item_set_shield_agi_set_1",
		-- "modifier_item_set_weapon_agi_set_1",
	-- },
	-- set_2 = {
		-- "modifier_item_set_boots_agi_set_2",
		-- "modifier_item_set_head_agi_set_2",
		-- "modifier_item_set_glov_agi_set_2",
		-- "modifier_item_set_armor_agi_set_2",
		-- "modifier_item_set_shield_agi_set_2",
		-- "modifier_item_set_weapon_agi_set_2",
	-- }	
-- }
-- local INT_SET_ITEMS = {
	-- set_1 = {
		-- "modifier_item_set_boots_int_set_1",
		-- "modifier_item_set_head_int_set_1",
		-- "modifier_item_set_glov_int_set_1",
		-- "modifier_item_set_armor_int_set_1",
		-- "modifier_item_set_shield_int_set_1",
		-- "modifier_item_set_weapon_int_set_1",
	-- },
	-- set_2 = {
		-- "modifier_item_set_boots_int_set_2",
		-- "modifier_item_set_head_int_set_2",
		-- "modifier_item_set_glov_int_set_2",
		-- "modifier_item_set_armor_int_set_2",
		-- "modifier_item_set_shield_int_set_2",
		-- "modifier_item_set_weapon_int_set_2",
	-- }	
-- }

function check_set:GetIntrinsicModifierName()
    return "modifier_check_set"
end

-----------------------------------------------------

modifier_check_set = class({})

function modifier_check_set:IsHidden()
    return true
end

function modifier_check_set:IsPurgable()
    return false
end

function modifier_check_set:RemoveOnDeath()
    return false
end

function modifier_check_set:OnCreated(kv)
    if IsServer() then
        self.caster = self:GetCaster()
        self:StartIntervalThink(0.2)
    end
end

function modifier_check_set:OnIntervalThink()
    if IsServer() then
        local attribute = self.caster:GetPrimaryAttribute()
        if attribute == DOTA_ATTRIBUTE_AGILITY then
            setItems = AGI_SET_ITEMS
			modifierPrefix = "modifier_item_agi_"
			self:ClearOther("modifier_item_str_", "modifier_item_int_")
        elseif attribute == DOTA_ATTRIBUTE_STRENGTH then
			setItems = STR_SET_ITEMS
            modifierPrefix = "modifier_item_str_"
			self:ClearOther("modifier_item_agi_", "modifier_item_int_")
        elseif attribute == DOTA_ATTRIBUTE_INTELLECT then
			setItems = INT_SET_ITEMS
            modifierPrefix = "modifier_item_int_"
			self:ClearOther("modifier_item_agi_", "modifier_item_str_")
        end
        self:CountPassiveSetItems(setItems, modifierPrefix)
    end
end

function modifier_check_set:CountPassiveSetItems(setItems, modifierPrefix)
	self.count = 0
    for _, item in ipairs(setItems) do
        local mod = self.caster:FindModifierByName(item)
        if mod then
			self.count = self.count + 1
        end
    end
    self:SetSetBonuses(self.count, modifierPrefix)
end

-- function modifier_check_set:CountPassiveSetItems(setItems, modifierPrefix)
	-- self.count = 0
	-- for _, set in pairs(setItems) do
		-- for _, item in ipairs(set) do
			-- local mod = self.caster:FindModifierByName(item)
			-- if mod then
				-- self.count = self.count + 1
			-- end
		-- end
	-- end
    -- self:SetSetBonuses(self.count, modifierPrefix)
-- end

function modifier_check_set:SetSetBonuses(passiveCount, modifierPrefix)
    local setModifiers = {}
    local parent = self:GetParent()
	if passiveCount >= 2 then
		parent:AddNewModifier(parent, nil, modifierPrefix..passiveCount, {})
	end	
		
	for i = 0, parent:GetModifierCount() - 1 do
		local name = parent:GetModifierNameByIndex(i)
		if string.find(name, modifierPrefix) then
			table.insert(setModifiers, name)
		end
	end
	for _, modifier in pairs(setModifiers) do
		local bonusCount = tonumber(string.sub(modifier, -1))
		if passiveCount >= bonusCount then
			parent:AddNewModifier(parent, nil, modifier, {})
		else
			parent:RemoveModifierByName(modifier)
		end
	end
end

-- function modifier_check_set:SetSetBonuses(passiveCount, modifierPrefix)
    -- local setModifiers = {}
    -- local parent = self:GetParent()
	-- if passiveCount >= 2 then
		-- parent:AddNewModifier(parent, nil, modifierPrefix..passiveCount, {})
	-- end	
		
	-- for i = 0, parent:GetModifierCount() - 1 do
	-- local name = parent:GetModifierNameByIndex(i)
		-- if string.sub(name, 1, #modifierPrefix) == modifierPrefix then
			-- table.insert(setModifiers, name)
		-- end
	-- end

	-- for _, modifier in pairs(setModifiers) do
	-- local bonusCount = tonumber(string.sub(modifier, -2, -2))
		-- if passiveCount >= bonusCount then
			-- parent:AddNewModifier(parent, nil, modifier, {})
		-- else
			-- parent:RemoveModifierByName(modifier)
		-- end
	-- end
-- end

function modifier_check_set:ClearOther(pref_1, pref_2)
    local parent = self:GetParent()
	for i = 0, parent:GetModifierCount() - 1 do
		local name = parent:GetModifierNameByIndex(i)
		if string.find(name, pref_1) or string.find(name, pref_2) then
			parent:RemoveModifierByName(name)
		end
	end
end

-- function modifier_check_set:ClearOther(pref_1, pref_2)
    -- local parent = self:GetParent()
	-- for i = 0, parent:GetModifierCount() - 1 do
		-- local name = parent:GetModifierNameByIndex(i)
		-- if string.find(name, pref_1) or string.find(name, pref_2) then
			-- parent:RemoveModifierByName(name)
		-- end
	-- end
-- end


