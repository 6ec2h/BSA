LinkLuaModifier( "modifier_shadow_fiend_shadowraze_lua", "heroes/hero_nevermore/shadow_fiend_shadowraze_lua/modifier_shadow_fiend_shadowraze_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
shadow_fiend_shadowraze_a_lua = class({})
shadow_fiend_shadowraze_b_lua = class({})
shadow_fiend_shadowraze_c_lua = class({})

function shadow_fiend_shadowraze_a_lua:OnSpellStart()
	shadowraze.OnSpellStart( self )
end

function shadow_fiend_shadowraze_b_lua:OnSpellStart()
	shadowraze.OnSpellStart( self )        
end

function shadow_fiend_shadowraze_c_lua:OnSpellStart()
	shadowraze.OnSpellStart( self )	
end

if shadowraze==nil then
	shadowraze = {}
end

-----------------------------------------------------------------------------

function shadowraze.ProcessRaze(self, target_pos, target_radius, base_damage, stack_damage, stack_duration)
    local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target_pos, nil, target_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _, enemy in pairs(enemies) do
        local modifier = enemy:FindModifierByNameAndCaster("modifier_shadow_fiend_shadowraze_lua", self:GetCaster())
        local stack = 0
        if modifier ~= nil then
            stack = modifier:GetStackCount()
        end

        local damageTable = {
            victim = enemy,
            attacker = self:GetCaster(),
            damage = base_damage + stack * stack_damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self,
        }
        ApplyDamage(damageTable)
        if modifier == nil then
            enemy:AddNewModifier(
                self:GetCaster(),
                self,
                "modifier_shadow_fiend_shadowraze_lua",
                { duration = stack_duration }
            )
        else
            modifier:IncrementStackCount()
            modifier:ForceRefresh()
        end
    end
    shadowraze.PlayEffects(self, target_pos, target_radius)
end

function shadowraze.OnSpellStart(self)
    local caster = self:GetCaster()
    local distance = self:GetSpecialValueFor("shadowraze_range")
    local front = self:GetCaster():GetForwardVector():Normalized()
    local target_pos = self:GetCaster():GetOrigin() + front * distance
    local target_radius = self:GetSpecialValueFor("shadowraze_radius")
    local base_damage = self:GetSpecialValueFor("shadowraze_damage")
    local stack_damage = self:GetSpecialValueFor("stack_bonus_damage")
    local stack_duration = self:GetSpecialValueFor("duration")


    local talent = self:GetCaster():FindAbilityByName("special_bonus_nevermore_int6")
    if talent ~= nil and talent:GetLevel() > 0 then
        local modifier = caster:FindModifierByNameAndCaster("modifier_shadow_fiend_necromastery_lua", caster)
        if modifier ~= nil then
            base_damage = base_damage + modifier:GetStackCount() * 2
        end
    end

    local talent = self:GetCaster():FindAbilityByName("special_bonus_nevermore_int10")
    if talent ~= nil and talent:GetLevel() > 0 then
        if self:GetName() == "shadow_fiend_shadowraze_a_lua" or self:GetName() == "shadow_fiend_shadowraze_b_lua" or self:GetName() == "shadow_fiend_shadowraze_c_lua" then
            local target_pos1 = self:GetCaster():GetOrigin() + front * 200
            local target_pos2 = self:GetCaster():GetOrigin() + front * 450
            local target_pos3 = self:GetCaster():GetOrigin() + front * 700
            shadowraze.ProcessRaze(self, target_pos1, target_radius, base_damage, stack_damage, stack_duration)
            shadowraze.ProcessRaze(self, target_pos2, target_radius, base_damage, stack_damage, stack_duration)
            shadowraze.ProcessRaze(self, target_pos3, target_radius, base_damage, stack_damage, stack_duration)
        end
    else
        if self:GetName() == "shadow_fiend_shadowraze_a_lua" then
            local position = self:GetCaster():GetOrigin() + front * 200
            shadowraze.ProcessRaze(self, position, target_radius, base_damage, stack_damage, stack_duration)
        elseif self:GetName() == "shadow_fiend_shadowraze_b_lua" then
            local position = self:GetCaster():GetOrigin() + front * 450
            shadowraze.ProcessRaze(self, position, target_radius, base_damage, stack_damage, stack_duration)
        elseif self:GetName() == "shadow_fiend_shadowraze_c_lua" then
            local position = self:GetCaster():GetOrigin() + front * 700
            shadowraze.ProcessRaze(self, position, target_radius, base_damage, stack_damage, stack_duration)
		end
    end
end


function shadowraze.PlayEffects( self, position, radius )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, position )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( position, "Hero_Nevermore.Shadowraze", self:GetCaster() )
end