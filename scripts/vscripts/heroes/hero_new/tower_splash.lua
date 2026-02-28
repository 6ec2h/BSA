function DoCleaveDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local cleave_radius = ability:GetSpecialValueFor("cleave_radius")
	local cleave_damage_pct = ability:GetSpecialValueFor("cleave_damage")
	local caster_damage = caster:GetBaseDamageMin()
	local cleave_damage = math.ceil(caster_damage*cleave_damage_pct/100)
	local AllEnemies = FindUnitsInRadius(DOTA_UNIT_TARGET_TEAM_ENEMY, target:GetAbsOrigin(), nil, cleave_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for i=1, #AllEnemies do
		ApplyDamage({victim = AllEnemies[i], attacker = caster, damage = cleave_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
	end
end