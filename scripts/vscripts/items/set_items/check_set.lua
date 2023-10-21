check_set = class({})
LinkLuaModifier( "modifier_check_set", "items/set_items/check_set", LUA_MODIFIER_MOTION_NONE )

local STR_SET_ITEMS = {
	set_1 = {
		"modifier_item_set_boots_str_set_1",
		"modifier_item_set_head_str_set_1",
		"modifier_item_set_glov_str_set_1",
		"modifier_item_set_armor_str_set_1",
		"modifier_item_set_shield_str_set_1",
		"modifier_item_set_weapon_str_set_1",
	},
	set_2 = {
		"modifier_item_set_boots_str_set_2",
		"modifier_item_set_head_str_set_2",
		"modifier_item_set_glov_str_set_2",
		"modifier_item_set_armor_str_set_2",
		"modifier_item_set_shield_str_set_2",
		"modifier_item_set_weapon_str_set_2",
	}	
}
local AGI_SET_ITEMS = {
	set_1 = {
		"modifier_item_set_boots_agi_set_1",
		"modifier_item_set_head_agi_set_1",
		"modifier_item_set_glov_agi_set_1",
		"modifier_item_set_armor_agi_set_1",
		"modifier_item_set_shield_agi_set_1",
		"modifier_item_set_weapon_agi_set_1",
	},
	set_2 = {
		"modifier_item_set_boots_agi_set_2",
		"modifier_item_set_head_agi_set_2",
		"modifier_item_set_glov_agi_set_2",
		"modifier_item_set_armor_agi_set_2",
		"modifier_item_set_shield_agi_set_2",
		"modifier_item_set_weapon_agi_set_2",
	}	
}
local INT_SET_ITEMS = {
	set_1 = {
		"modifier_item_set_boots_int_set_1",
		"modifier_item_set_head_int_set_1",
		"modifier_item_set_glov_int_set_1",
		"modifier_item_set_armor_int_set_1",
		"modifier_item_set_shield_int_set_1",
		"modifier_item_set_weapon_int_set_1",
	},
	set_2 = {
		"modifier_item_set_boots_int_set_2",
		"modifier_item_set_head_int_set_2",
		"modifier_item_set_glov_int_set_2",
		"modifier_item_set_armor_int_set_2",
		"modifier_item_set_shield_int_set_2",
		"modifier_item_set_weapon_int_set_2",
	}	
}

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

function modifier_check_set:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION
    }
    return funcs
end

function modifier_check_set:GetModifierMagicalResistanceDirectModification()
	return -0.1 * self:GetParent():GetIntellect()
end

function modifier_check_set:OnIntervalThink()
    if IsServer() then
        local attribute = self.caster:GetPrimaryAttribute()
		if attribute == 3 then
			self:CountPassiveSetItems(AGI_SET_ITEMS, 'modifier_item_agi_')
			self:CountPassiveSetItems(STR_SET_ITEMS, 'modifier_item_str_')
			self:CountPassiveSetItems(INT_SET_ITEMS, 'modifier_item_int_')
			return
        elseif attribute == DOTA_ATTRIBUTE_AGILITY then
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
	for k, set in pairs(setItems) do
		count = 0
		for _, item in ipairs(set) do
			local mod = self.caster:FindModifierByName(item)
			if mod then
				count = count + 1
			end
		end
		self:SetSetBonuses(count, modifierPrefix, k)
	end
end

function modifier_check_set:SetSetBonuses(passiveCount, modifierPrefix, k)
    local setModifiers = {}
    local parent = self:GetParent()
	if passiveCount >= 2 then
		LinkLuaModifier(modifierPrefix..passiveCount.."_"..k, "items/set_items/set_modifiers/"..modifierPrefix..passiveCount.."_"..k, LUA_MODIFIER_MOTION_NONE )
		for i=2, passiveCount do
			parent:AddNewModifier(parent, nil, modifierPrefix..passiveCount.."_"..k, {})
		end
		for i=passiveCount+1, 7 do
			if parent:HasModifier(modifierPrefix..i.."_"..k) then
				parent:RemoveModifierByName(modifierPrefix..i.."_"..k)
			end
		end
	else
		for i=2, 6 do
			if parent:HasModifier(modifierPrefix..i.."_"..k) then
				parent:RemoveModifierByName(modifierPrefix..i.."_"..k)
			end
		end
	end
end

function modifier_check_set:ClearOther(pref_1, pref_2)
    local parent = self:GetParent()
	for i = 0, parent:GetModifierCount() - 1 do
		local name = parent:GetModifierNameByIndex(i)
		if string.find(name, pref_1) or string.find(name, pref_2) then
			parent:RemoveModifierByName(name)
		end
	end
end