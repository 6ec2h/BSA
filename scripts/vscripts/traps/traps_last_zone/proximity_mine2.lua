LinkLuaModifier("modifier_proximity_mine2", "traps/traps_last_zone/proximity_mine2.lua", LUA_MODIFIER_MOTION_NONE)

proximity_mine2 = class({})

function proximity_mine2:GetIntrinsicModifierName()
    return "modifier_proximity_mine2"
end

-------------------------------------------------------------------------

modifier_proximity_mine2 = class({})

function modifier_proximity_mine2:OnCreated()
    local caster = self:GetCaster()
    local ability = self
    local particle = "particles/units/heroes/hero_techies/techies_land_mine.vpcf"
    local particle_mine_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle_mine_fx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_mine_fx, 3, caster:GetAbsOrigin())
    self:AddParticle(particle_mine_fx, false, false, -1, false, false)

    self:StartIntervalThink(1)
end

function modifier_proximity_mine2:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local sound = "Hero_Techies.LandMine.Detonate"
        local center = caster:GetAbsOrigin()

        if not caster:IsAlive() then
            self:Destroy()
        end

        local activation_radius = ability:GetSpecialValueFor("activation_radius")
        local damage_radius = ability:GetSpecialValueFor("damage_radius")

        local nearbyEnemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                                caster:GetAbsOrigin(),
                                                nil,
                                                activation_radius,
                                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                                DOTA_UNIT_TARGET_HERO,
                                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                                FIND_ANY_ORDER,
                                                false)

        if #nearbyEnemies > 0 then
            EmitSoundOn(sound, caster)

            local particle_explosion = "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf"
            local particle_explosion_fx = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, caster)
            ParticleManager:SetParticleControl(particle_explosion_fx, 0, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_explosion_fx, 1, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_explosion_fx, 2, Vector(damage_radius, 1, 1))
            ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

            local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                          caster:GetAbsOrigin(),
                                          nil,
                                          damage_radius,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                          FIND_ANY_ORDER,
                                          false)

            for _,enemy in pairs(enemies) do 
                local damageTable = {victim = enemy,
                                     attacker = caster, 
                                     damage = enemy:GetMaxHealth()/2,
                                     damage_type = DAMAGE_TYPE_PURE,
                                     ability = self.ability
                }

                ApplyDamage(damageTable)
            end

            caster:ForceKill(false)
            self:Destroy()
        end
    end    
end

function modifier_proximity_mine2:CheckState()
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
    return state
end