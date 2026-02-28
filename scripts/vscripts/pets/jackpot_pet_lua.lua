LinkLuaModifier("modifier_pet_passive_logic", "pets/jackpot_pet_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pet_stats_sync", "pets/jackpot_pet_lua", LUA_MODIFIER_MOTION_NONE)

jackpot_pet_lua = class({})

function jackpot_pet_lua:GetIntrinsicModifierName()
    return "modifier_pet_passive_logic"
end

--------------------------------------------------------------------------------

modifier_pet_passive_logic = class({})

function modifier_pet_passive_logic:IsHidden() return true end

function modifier_pet_passive_logic:OnCreated()
    if not IsServer() then return end
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pet_stats_sync", {})
    self:GetParent():SetAcquisitionRange(0)
    self:StartIntervalThink(1)
end

function modifier_pet_passive_logic:OnIntervalThink()
    if not IsServer() then return end
    
    local pet = self:GetParent()
    local owner = pet:GetOwner()
    if not owner or not owner:IsRealHero() or not owner:IsAlive() then
        pet:Stop()
        pet:SetAggroTarget(nil)
        return
    end

    pet:SetMaxMana(owner:GetMaxMana())

    local exceptions = {
        [self:GetAbility():GetAbilityName()] = true,
        ["attribute_bonus"] = true,
        ["ability_capture_lua"] = true,
        ["terrorblade_reflection_lua"] = true,
        ["terrorblade_sunder_lua"] = true,
        ["terrorblade_conjure_image_lua"] = true,
        ["alchemist_greevils_greed_lua"] = true,
        ["legion_ult"] = true,
        ["ogre_magi_bloodlust_lua"] = true,
        ["lion_soul_collector"] = true,
        ["silencer_infinite_int_lua"] = true,
        ["techies_remote_mines_lua"] = true,
        ["wraith_king_sceleton"] = true,
        ["lua_abyssal_underlord_atrophy_aura"] = true,
        ["anakim_wisp"] = true,
        ["axe_blood_lua"] = true,
        ["bloodseeker_thirst_lua"] = true,
        ["broodmother_ult"] = true,
        ["mars_atrophy_aura_lua"] = true,
        ["shadow_fiend_necromastery_lua"] = true,
        ["hero_destroyer_second_skill_armor"] = true,
        ["hero_destroyer_second_skill_resist"] = true,
        ["hero_destroyer_second_skill_hp"] = true,
        ["dado_tp_in"] = true,
        ["dado_tp_out"] = true,
        ["dado_ampl"] = true,
        ["hero_fiddlesticks_armor"] = true,
    }

    local abilityCount = owner:GetAbilityCount()
    for i = 0, abilityCount - 1 do
        local ability = owner:GetAbilityByIndex(i)
        if ability then
            local ability_name = ability:GetAbilityName()
            if not exceptions[ability_name] then
                local pet_ability = pet:FindAbilityByName(ability_name)
                if not pet_ability then
                    pet_ability = pet:AddAbility(ability_name)
                end
                if pet_ability and pet_ability:GetLevel() ~= ability:GetLevel() then
                    pet_ability:SetLevel(ability:GetLevel())
                end
            end
        end
    end

    local dist = (owner:GetOrigin() - pet:GetOrigin()):Length2D()

    if dist > 1200 then
        self:BlinkToOwner(pet, owner)
        return
    end

    local owner_target = owner:GetAggroTarget()
 
    if not owner_target or not owner_target:IsAlive() then
        pet:SetAcquisitionRange(0)
        if pet:GetAggroTarget() then
            pet:Stop()
            pet:SetAggroTarget(nil)
        end
        if dist > 400 then
            local target_pos = owner:GetAbsOrigin() - owner:GetForwardVector() * 150
            pet:MoveToPosition(target_pos)
        end
    else
        if pet:GetAggroTarget() ~= owner_target then
            pet:SetAcquisitionRange(500)
            pet:MoveToTargetToAttack(owner_target)
        end
    end
end

function modifier_pet_passive_logic:BlinkToOwner(pet, owner)
    local blink_pos = owner:GetOrigin() + RandomVector(RandomFloat(100, 150))
    pet:SetAbsOrigin(blink_pos)
    FindClearSpaceForUnit(pet, blink_pos, true)
    pet:Stop()
    local pfx = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, pet)
    ParticleManager:ReleaseParticleIndex(pfx)
end

function modifier_pet_passive_logic:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
    }
end

function modifier_pet_passive_logic:GetModifierPercentageManacostStacking()
    return 100
end

function modifier_pet_passive_logic:OnAbilityFullyCast(params)
    local owner = self:GetParent():GetOwner()
    if not owner or params.unit ~= owner or params.ability:IsItem() then return end
    
    local pet = self:GetParent()
    local hAbility = params.ability
    local ability_name = hAbility:GetAbilityName()
    
    if ability_name == self:GetAbility():GetAbilityName() then return end

    local pet_ability = pet:FindAbilityByName(ability_name)
    if pet_ability then
        pet_ability:EndCooldown()
        
        local behavior = hAbility:GetBehaviorInt()
        local target = params.target
        local point = owner:GetCursorPosition()

        if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 and target then
            pet:CastAbilityOnTarget(target, pet_ability, -1)
        elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 then
            pet:CastAbilityOnPosition(point, pet_ability, -1)
        elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0 then
            pet:CastAbilityNoTarget(pet_ability, -1)
        end
    end
end

--------------------------------------------------------------------------------

modifier_pet_stats_sync = class({})

function modifier_pet_stats_sync:IsHidden()
    return false
end

function modifier_pet_stats_sync:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }
end

function modifier_pet_stats_sync:GetModifierSpellAmplify_Percentage()
    if not IsServer() then return end  
    local owner = self:GetParent():GetOwner()
    
    if owner then
        local ampl = owner:GetSpellAmplification(false) * 100
        return ampl
    end
    return 0
end

function modifier_pet_stats_sync:GetModifierPreAttack_BonusDamage()
    if not IsServer() then return end  
    local owner = self:GetParent():GetOwner()
    
    if owner then
        local damage = owner:GetAverageTrueAttackDamage(nil)
        return damage --* 0.5
    end
    return 0
end

function modifier_pet_stats_sync:GetModifierAttackSpeedBonus_Constant()
    if not IsServer() then return end  
    local owner = self:GetParent():GetOwner()
    
    if owner then
        local current_as = owner:GetAttackSpeed(false) * 100
        return (current_as - 100) --* 0.5
    end
    return 0
end