LinkLuaModifier("modifier_undying_decay_lua_buff", "heroes/hero_undying/undying_decay_lua/undying_decay_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_undying_decay_lua_buff_counter", "heroes/hero_undying/undying_decay_lua/undying_decay_lua", LUA_MODIFIER_MOTION_NONE)

undying_decay_lua = class({}) 

function undying_decay_lua:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_undying/undying_decay.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_undying/undying_decay_strength_xfer.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_undying/undying_decay_strength_buff.vpcf", context )
end

function undying_decay_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function undying_decay_lua:OnSpellStart()
    self:DecayCast(self:GetCursorPosition())
end

function undying_decay_lua:DecayCast(point)
    local count = 1
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("decay_damage")
	local duration = self:GetSpecialValueFor("decay_duration")
	
	local ability = self:GetCaster():FindAbilityByName("special_bonus_undying_7")
	if ability ~= nil and ability:GetLevel() > 0 then 
		duration = duration + 10
	end
	
	local ability = self:GetCaster():FindAbilityByName("special_bonus_undying_1")
	if ability ~= nil and ability:GetLevel() > 0 then 
		damage = damage + 80
	end
		
	local ability = self:GetCaster():FindAbilityByName("special_bonus_undying_8")
	if ability ~= nil and ability:GetLevel() > 0 then 
		count = 2
	end
	
    for i=1,count do
        self:GetCaster():EmitSound("Hero_Undying.Decay.Cast")
        local decay_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
        ParticleManager:SetParticleControl(decay_particle, 0, point)
        ParticleManager:SetParticleControl(decay_particle, 1, Vector(radius, 0, 0))
        ParticleManager:SetParticleControl(decay_particle, 2, self:GetCaster():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(decay_particle)
        for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
            enemy:EmitSound("Hero_Undying.Decay.Target")
            self:GetCaster():EmitSound("Hero_Undying.Decay.Transfer")
            local strength_transfer_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay_strength_xfer.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
            ParticleManager:SetParticleControlEnt(strength_transfer_particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(strength_transfer_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
            ParticleManager:ReleaseParticleIndex(strength_transfer_particle)
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_undying_decay_lua_buff_counter", {duration = duration })
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_undying_decay_lua_buff", {duration = duration })
            self:GetCaster():CalculateStatBonus(true)
            ApplyDamage({ victim = enemy, damage = damage, damage_type = self:GetAbilityDamageType(), damage_flags = DOTA_DAMAGE_FLAG_NONE, attacker = self:GetCaster(), ability = self})
        end
    end
end

------------------------------------------------------------------------

modifier_undying_decay_lua_buff = class({})

function modifier_undying_decay_lua_buff:IsHidden() 
    return true 
end

function modifier_undying_decay_lua_buff:IsPurgable() 
    return false 
end

function modifier_undying_decay_lua_buff:GetAttributes() 
    return MODIFIER_ATTRIBUTE_MULTIPLE 
end

------------------------------------------------------------------------------

modifier_undying_decay_lua_buff_counter = class({})

function modifier_undying_decay_lua_buff_counter:OnCreated()
    if not IsServer() then return end
    self:SetStackCount(1)
    self:StartIntervalThink(FrameTime())
end

function modifier_undying_decay_lua_buff_counter:OnIntervalThink()
    local stack = self:GetParent():FindAllModifiersByName("modifier_undying_decay_lua_buff")
    local str_steal = self:GetAbility():GetSpecialValueFor("str_steal")
	
	local ability = self:GetCaster():FindAbilityByName("special_bonus_undying_4")
	if ability ~= nil and ability:GetLevel() > 0 then 
		str_steal = 2
	end
	
    self:SetStackCount(#stack * str_steal)
end

function modifier_undying_decay_lua_buff_counter:IsPurgable()  
    return false 
end

function modifier_undying_decay_lua_buff_counter:GetEffectName()
    return "particles/units/heroes/hero_undying/undying_decay_strength_buff.vpcf"
end

function modifier_undying_decay_lua_buff_counter:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }
end

function modifier_undying_decay_lua_buff_counter:GetModifierBonusStats_Strength()
    return self:GetStackCount()
end