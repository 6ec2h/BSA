require('tp')

modifier_tp_nix_thinker = class({})

function modifier_tp_nix_thinker:IsAura()
    return true
end

function modifier_tp_nix_thinker:GetAuraRadius()
    return 150
end

function modifier_tp_nix_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_tp_nix_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_tp_nix_thinker:GetModifierAura()
    return "modifier_tp_nix_thinker_aura"
end
LinkLuaModifier("modifier_tp_nix_thinker_aura", "modifiers/modifier_fix_teleport", LUA_MODIFIER_MOTION_NONE)
modifier_tp_nix_thinker_aura = class({})

function modifier_tp_nix_thinker_aura:OnCreated(keys)
    if not IsServer() then return end
    nyxoff()
    nyxoff2()
    teleportnyx({activator = self:GetParent()})
end

modifier_tp_necrolyte_thinker = class({})

function modifier_tp_necrolyte_thinker:IsAura()
    return true
end

function modifier_tp_necrolyte_thinker:GetAuraRadius()
    return 150
end

function modifier_tp_necrolyte_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_tp_necrolyte_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_tp_necrolyte_thinker:GetModifierAura()
    return "modifier_tp_necrolyte_thinker_aura"
end

LinkLuaModifier("modifier_tp_necrolyte_thinker_aura", "modifiers/modifier_fix_teleport", LUA_MODIFIER_MOTION_NONE)
modifier_tp_necrolyte_thinker_aura = class({})

function modifier_tp_necrolyte_thinker_aura:OnCreated(keys)
    if not IsServer() then return end
    tp_necrolyte({activator = self:GetParent()})
end