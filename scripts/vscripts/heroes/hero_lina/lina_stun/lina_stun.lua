function shifting_quake_damage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() -1))
	local damage_table = {
							attacker = caster,
							victim = target,
							ability = ability,
							damage_type = DAMAGE_TYPE_MAGICAL,
							damage = damage
						}
	ApplyDamage(damage_table)
end

function shifting_quake(keys)
	local caster = keys.caster
	local caster_pos = caster:GetAbsOrigin()
	local target = keys.target_points[1]
	local ability = keys.ability
	local particle = "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf"
	local direction = (target - caster_pos):Normalized()
	local distance = ability:GetLevelSpecialValueFor("distance", (ability:GetLevel() -1))
	local points = ability:GetLevelSpecialValueFor("points", (ability:GetLevel() -1))
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() -1))
	local delay = ability:GetLevelSpecialValueFor("delay", (ability:GetLevel() -1))

	if caster:FindAbilityByName("npc_dota_hero_luna_2")~=nil then
		if caster:FindAbilityByName("npc_dota_hero_luna_2"):GetLevel() > 0 then 
			points = points + 2
		end
	end
	
	local spacing = distance / points
	local range = 0
	
	Timers:CreateTimer(function()
			range = range + spacing
			point_loc = caster_pos + direction * range
			local dummy = CreateUnitByName("npc_dummy_unit", point_loc, false, caster, caster, caster:GetTeamNumber())
			dummy:ForceKill(false)
			--ability:ApplyDataDrivenModifier(caster, dummy, "modifier_dummy", {})
			EmitSoundOn("Ability.PreLightStrikeArray", dummy)
			local particleIndex = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, dummy)
			local units = FindUnitsInRadius(caster:GetTeam(), point_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
			for k, unit in ipairs(units) do
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_stun_lina", {})
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_dmg_lina", {})
			end
			points = points - 1
			if points > 0 then
				return delay
			else
				return nil
			end
		end
	)
end