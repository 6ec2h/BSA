undying_soul_rip_lua = class({})

function undying_soul_rip_lua:OnAbilityPhaseStart()
	EmitSoundOn("Hero_Undying.SoulRip.Cast", self:GetCaster() )
	return true
end

function undying_soul_rip_lua:OnAbilityPhaseInterrupted()
	StopSoundOn("Hero_Undying.SoulRip.Cast", self:GetCaster() )
end

function undying_soul_rip_lua:OnSpellStart()
    self:OnSpellStart_target(self:GetCursorTarget())
end

function undying_soul_rip_lua:OnSpellStart_target(target)
	local radius = self:GetSpecialValueFor("radius")
	local damage_per_unit = self:GetSpecialValueFor("damage_per_unit")
	
	
	local ability = self:GetCaster():FindAbilityByName("special_bonus_undying_3")
	if ability ~= nil and ability:GetLevel() > 0 then 
		damage_per_unit = damage_per_unit + 16
	end
	
	local max_units = self:GetSpecialValueFor("max_units")
	local counter = 0
    local total_damage = 0

	EmitSoundOn("Hero_Undying.SoulRip.Enemy", target)
	local pcf = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(pcf, 0, self:GetCaster():GetOrigin())
	ParticleManager:SetParticleControl(pcf, 1, target:GetOrigin())
	ParticleManager:SetParticleControl(pcf, 2, self:GetCaster():GetOrigin())
    ParticleManager:ReleaseParticleIndex(pcf)

	local flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_REFLECTION
	local totalValue = 0
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _, unit in ipairs( units ) do
        if maxUnits == counter then
            break
        end
        total_damage = total_damage + ApplyDamage({
            victim = unit,
            attacker = self:GetCaster(),
            damage = damage_per_unit,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = flags,
            ability = self
        })
		counter = counter + 1
	end
	SendOverheadEventMessage( self:GetCaster():GetPlayerOwner(), OVERHEAD_ALERT_HEAL , self:GetCaster(), total_damage, nil )
    self:GetCaster():HealWithParams(math.min(math.abs(total_damage), 2^30), self, false, false, self:GetCaster(), false)
    if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
        ApplyDamage({
            victim = self:GetCursorTarget(),
            attacker = self:GetCaster(),
            damage = counter * damage_per_unit,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = 0,
            ability = self
        })
    end
end