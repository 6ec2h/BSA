LinkLuaModifier("modifier_item_devastator_lua", "items/custom_items/item_devastator_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_devastator_lua_debuff", "items/custom_items/item_devastator_lua.lua", LUA_MODIFIER_MOTION_NONE)

item_devastator_1 = item_devastator_1 or class({})
item_devastator_2 = item_devastator_1 or class({})
item_devastator_3 = item_devastator_1 or class({})


function item_devastator_1:GetIntrinsicModifierName()
    return "modifier_item_devastator_lua"
end

---------------------------------------------------

modifier_item_devastator_lua = class({})

function modifier_item_devastator_lua:IsHidden()
	return true
end

function modifier_item_devastator_lua:IsPurgable()
	return false
end

function modifier_item_devastator_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_devastator_lua:OnCreated()
    -- if not IsServer() then return end
	
    self.woundedStackDuration = self:GetAbility():GetSpecialValueFor("wounded_stack_duration")
    self.woundedDamageIncreasePerStack = self:GetAbility():GetSpecialValueFor("wounded_stack_damage_increase")
    self.woundedMaxStacks = self:GetAbility():GetSpecialValueFor("wounded_max_stacks")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal")
	
	print(self.bonus_damage, self.bonus_strength, self.lifesteal)
end

function modifier_item_devastator_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, --GetModifierPreAttack_BonusDamage
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, --GetModifierBonusStats_Strength
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_item_devastator_lua:OnAttackLanded(event)
    if not IsServer() then return end
    local attacker = event.attacker
    if self:GetParent() ~= attacker then
        return
    end
    if not attacker:IsAlive() or attacker:GetHealth() < 1 or event.target:IsOther() or event.target:IsBuilding() or attacker:IsIllusion() then return end
    local heal = event.damage * (self.lifesteal/100)
    attacker:Heal(heal, nil)
    local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
    ParticleManager:ReleaseParticleIndex(particle)
end

function modifier_item_devastator_lua:GetModifierPreAttack_BonusDamage()
    return self.bonus_damage
end

function modifier_item_devastator_lua:GetModifierBonusStats_Strength()
    return self.bonus_strength
end

function modifier_item_devastator_lua:GetModifierProcAttack_BonusDamage_Physical(params)
    if IsServer() then
        local target = params.target if target==nil then target = params.unit end
        if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
            return 0
        end

        if not self:GetAbility():IsCooldownReady() then return 0 end
        local stack = 0
        local modifier = target:FindModifierByNameAndCaster("modifier_item_devastator_lua_debuff", self:GetAbility():GetCaster())

        if modifier==nil then
            if not self:GetParent():IsMuted() then
                local _mod = target:AddNewModifier(
                    self:GetAbility():GetCaster(),
                    self:GetAbility(),
                    "modifier_item_devastator_lua_debuff",
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

modifier_item_devastator_lua_debuff = class({})

function modifier_item_devastator_lua_debuff:IsHidden()
	return false
end

function modifier_item_devastator_lua_debuff:IsPurgable()
	return false
end

function modifier_item_devastator_lua_debuff:RemoveOnDeath()	
	return false 
end

function modifier_item_devastator_lua_debuff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_devastator_lua_debuff:GetTexture()
    return "item_devastator"
end

function modifier_item_devastator_lua_debuff:OnRemoved()
    if not IsServer() then return end

    if self:GetAbility():IsCooldownReady() then
        self:GetAbility():UseResources(false, false, false, true)
    end
end