meepo_poof_lua = class({})

function meepo_poof_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local origin_caster = caster:GetOrigin()
	local origin_target = target:GetOrigin()
	
	
	local sound_cast = "Hero_Meepo.Poof.Channel"
	EmitSoundOnLocationForAllies( caster:GetOrigin(), sound_cast, caster )
end

function meepo_poof_lua:OnChannelFinish( bInterrupted )
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local origin_caster = caster:GetOrigin()
	local origin_target = target:GetOrigin()
	local radius = self:GetSpecialValueFor("damage_radius")
	local damage = self:GetSpecialValueFor("damage")
	
	local talent_ability = self:GetCaster():FindAbilityByName("npc_dota_hero_meepo_int2")
	if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		damage = self:GetSpecialValueFor("damage") + 80
	end
	
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
		for i,unit in ipairs(units) do
			ApplyDamage({ victim = unit, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE })
		end 
	
	if bInterrupted then return end

    caster:EmitSound("Hero_Meepo.Poof.End00")
	caster:SetAbsOrigin( origin_target )
	FindClearSpaceForUnit(caster, origin_target, false)
	caster:Stop() 
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
        for i,unit in ipairs(units) do
            ApplyDamage({ victim = unit, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE })
        end 
	Timers:CreateTimer({
    endTime = 0.1, 
    callback = function()
	ProjectileManager:ProjectileDodge(caster) 
    ParticleManager:CreateParticle("particles/units/heroes/hero_meepo/meepo_poof_end.vpcf", PATTACH_ABSORIGIN, caster) 	
    end})	
end