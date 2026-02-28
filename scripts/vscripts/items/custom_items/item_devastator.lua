LinkLuaModifier("modifier_item_devastator", "items/custom_items/item_devastator.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_devastator_debuff", "items/custom_items/item_devastator.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

local ItemBaseClassBuff = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return true end,
    IsDebuff = function(self) return false end,
    IsStackable = function(self) return false end,
}

local ItemBaseClassDebuff = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsDebuff = function(self) return true end,
    IsStackable = function(self) return true end,
}

item_devastator = class(ItemBaseClass)
item_devastator_2 = item_devastator
item_devastator_3 = item_devastator
modifier_item_devastator = class(item_devastator)
modifier_item_devastator_debuff = class(ItemBaseClassDebuff)
-------------
function item_devastator:GetIntrinsicModifierName()
    return "modifier_item_devastator"
end

function modifier_item_devastator:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, --GetModifierPreAttack_BonusDamage
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, --GetModifierBonusStats_Strength
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_item_devastator:OnAttackLanded(event)
    if not IsServer() then return end
    local attacker = event.attacker
    if self:GetParent() ~= attacker then
        return
    end
    local lifestealAmount = self:GetAbility():GetSpecialValueFor("lifesteal")

    if not attacker:IsAlive() or attacker:GetHealth() < 1 or event.target:IsOther() or event.target:IsBuilding() or attacker:IsIllusion() then return end

    local heal = event.damage * (lifestealAmount/100)

    attacker:Heal(heal, nil)
    local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
    ParticleManager:ReleaseParticleIndex(particle)
end

function modifier_item_devastator:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_devastator:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_item_devastator:OnRemoved()
    if not IsServer() then return end
end

function modifier_item_devastator:OnCreated()
    if not IsServer() then return end

    local parent = self:GetParent()
    local ability = self:GetAbility()

    self.woundedStackDuration = ability:GetSpecialValueFor("wounded_stack_duration")
    self.woundedDamageIncreasePerStack = ability:GetSpecialValueFor("wounded_stack_damage_increase")
    self.woundedMaxStacks = ability:GetSpecialValueFor("wounded_max_stacks")
end

function modifier_item_devastator:GetModifierProcAttack_BonusDamage_Physical(params)
    if IsServer() then
        local target = params.target if target==nil then target = params.unit end
        if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
            return 0
        end

        if not self:GetAbility():IsCooldownReady() then return 0 end
        local stack = 0
        local modifier = target:FindModifierByNameAndCaster("modifier_item_devastator_debuff", self:GetAbility():GetCaster())

        if modifier==nil then
            if not self:GetParent():IsMuted() then
                local _mod = target:AddNewModifier(
                    self:GetAbility():GetCaster(),
                    self:GetAbility(),
                    "modifier_item_devastator_debuff",
                    { duration = self.woundedStackDuration }
                )

                _mod:IncrementStackCount()
                stack = 1
            end
        else
            modifier:IncrementStackCount()
            modifier:ForceRefresh()
            stack = modifier:GetStackCount()
            if modifier:GetStackCount() > self.woundedMaxStacks then
                self:GetAbility():UseResources(false, false, false, true)
                modifier:Destroy()
            end
        end
        local total = params.damage * ((self.woundedDamageIncreasePerStack * stack)/100)
        return total
    end
end

------------

function modifier_item_devastator_debuff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_devastator_debuff:GetTexture()
    return "item_devastator"
end

function modifier_item_devastator_debuff:OnRemoved()
    if not IsServer() then return end

    if self:GetAbility():IsCooldownReady() then
        self:GetAbility():UseResources(false, false, false, true)
    end
end