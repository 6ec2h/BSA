function sunstrike_interval(event)
	local caster = event.caster
	local caster_pos = caster:GetAbsOrigin()
	local ability = event.ability
	local ability_level = ability:GetLevel() -1
	local range = ability:GetLevelSpecialValueFor("range", ability_level)
	local delay = ability:GetLevelSpecialValueFor("delay", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local damage_radius = ability:GetLevelSpecialValueFor("damage_radius", ability_level)
	local particle_pre = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf"
	local particle = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf"
	
	local angle = RandomInt(0, 360)
	local variance = RandomInt(-range, range)
	local dy = math.sin(angle) * variance
	local dx = math.cos(angle) * variance
	local target_pos = Vector(caster_pos.x + dx, caster_pos.y + dy, caster_pos.z)
	local dummy = CreateUnitByName("npc_dummy_unit", target_pos, false, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_dummy", {})
	local particleIndexPre = ParticleManager:CreateParticle(particle_pre, PATTACH_ABSORIGIN, dummy)
	--ParticleManager:SetParticleControl(particleIndexPre, 0, dummy)
	
	Timers:CreateTimer(delay, function()
			caster:EmitSound("Hero_Invoker.SunStrike.Charge")
			ParticleManager:DestroyParticle( particleIndexPre, false )
			local particleIndex = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, dummy)
			--ParticleManager:SetParticleControl(particleIndex, 0, dummy)
			local units = FindUnitsInRadius(caster:GetTeam(), target_pos, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
			for k, unit in ipairs(units) do
				local damage_table = {
										attacker = caster,
										victim = unit,
										ability = ability,
										damage_type = ability:GetAbilityDamageType(),
										damage = damage
									}
				ApplyDamage(damage_table)
			end
			return nil
		end
	)
end