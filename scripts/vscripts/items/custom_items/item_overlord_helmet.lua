LinkLuaModifier("modifier_item_overlord_helmet", "items/custom_items/item_overlord_helmet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_overlord_helmet_aura", "items/custom_items/item_overlord_helmet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_overlord_helmet_aura_friendly", "items/custom_items/item_overlord_helmet", LUA_MODIFIER_MOTION_NONE)

item_overlord_helmet = item_overlord_helmet or class({})
item_overlord_helmet2 = item_overlord_helmet or class({})
item_overlord_helmet3 = item_overlord_helmet or class({})

function item_overlord_helmet:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function item_overlord_helmet:GetIntrinsicModifierName()
    return "modifier_item_overlord_helmet"
end

-----------------------------------------------------------------------------------------------------------

modifier_item_overlord_helmet = class({})

function modifier_item_overlord_helmet:IsHidden()
	return true
end

function modifier_item_overlord_helmet:IsPurgable()
	return false
end

function modifier_item_overlord_helmet:RemoveOnDeath()
	return false
end

function modifier_item_overlord_helmet:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, --GetModifierBonusStats_Strength
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, --GetModifierBonusStats_Agility
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS, --GetModifierBonusStats_Intellect
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, --GetModifierPhysicalArmorBonus
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, --GetModifierConstantHealthRegen
    }
    return funcs
end

function modifier_item_overlord_helmet:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_overlord_helmet:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_overlord_helmet:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_overlord_helmet:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_overlord_helmet:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor("bonus_hp_regen")
end

function modifier_item_overlord_helmet:IsAura()
	if self:GetCaster():IsIllusion() then 
		return false
	end
	return true
end

function modifier_item_overlord_helmet:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_item_overlord_helmet:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_item_overlord_helmet:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_item_overlord_helmet:GetModifierAura()
	return self.aura_modifier_name
end

function modifier_item_overlord_helmet:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_item_overlord_helmet:GetAuraEntityReject(target)
    if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
        self.aura_modifier_name = "modifier_item_overlord_helmet_aura_friendly"
    else
        self.aura_modifier_name = "modifier_item_overlord_helmet_aura"
    end
    return false
end

------------------------------------------------------------------------------------------

modifier_item_overlord_helmet_aura = class({})

function modifier_item_overlord_helmet_aura:IsHidden()
	return false
end

function modifier_item_overlord_helmet_aura:IsPurgable()
	return false
end

function modifier_item_overlord_helmet_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    }
    return funcs
end

function modifier_item_overlord_helmet_aura:GetModifierStatusResistanceStacking()
    return self:GetAbility():GetSpecialValueFor("status_resistance")
end

------------------------------------------------------------------------------------------

modifier_item_overlord_helmet_aura_friendly = class({})

function modifier_item_overlord_helmet_aura_friendly:IsHidden()
	return false
end

function modifier_item_overlord_helmet_aura_friendly:IsPurgable()
	return false
end

function modifier_item_overlord_helmet_aura_friendly:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(0.1)
end

function modifier_item_overlord_helmet_aura_friendly:OnIntervalThink()
    if not IsServer() then return end
    local damage = self:GetAbility():GetSpecialValueFor("damage_share_pct")

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"),DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)
	
    local baseDamage = self:GetCaster():GetAttackDamage()
    self.damage = ((baseDamage * (damage/100))/#enemies)

    self:SetStackCount(self.damage)
end

function modifier_item_overlord_helmet_aura_friendly:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
    return funcs
end

function modifier_item_overlord_helmet_aura_friendly:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end