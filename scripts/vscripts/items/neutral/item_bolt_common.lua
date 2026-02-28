function Bolt(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local target_count = ability:GetSpecialValueFor("target_count")
	local radius = ability:GetSpecialValueFor("radius")
	local unit_max_mana = caster:GetMaxMana()
	local unit_damage_pct = ability:GetSpecialValueFor("lightnihg_damage_pct")
	local final_damage = math.ceil(unit_max_mana*unit_damage_pct/100)
		StartSoundEvent("Hero_Zuus.ArcLightning.Cast", caster)
		print(final_damage)
	for i=1, target_count do
	local AllEnemies = FindUnitsInRadius(DOTA_UNIT_TARGET_TEAM_ENEMY, target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
--	for i=1, #AllEnemies do
		ApplyDamage({victim = AllEnemies[i], attacker = caster, damage = final_damage, damage_type = DAMAGE_TYPE_MAGICAL})
				ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, AllEnemies[i]) 
	end
end

function Bolt_leg(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local target_count = ability:GetSpecialValueFor("target_count")
	local radius = ability:GetSpecialValueFor("radius")
	local unit_max_mana = caster:GetMaxMana()
	local unit_damage_pct = ability:GetSpecialValueFor("lightnihg_damage_pct")
	local final_damage = math.ceil(unit_max_mana*unit_damage_pct/100)
		StartSoundEvent("Hero_Zuus.ArcLightning.Cast", caster)

	local AllEnemies = FindUnitsInRadius(DOTA_UNIT_TARGET_TEAM_ENEMY, target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for i=1, #AllEnemies do
		ApplyDamage({victim = AllEnemies[i], attacker = caster, damage = final_damage, damage_type = DAMAGE_TYPE_MAGICAL})
				ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, AllEnemies[i]) 
	end
end