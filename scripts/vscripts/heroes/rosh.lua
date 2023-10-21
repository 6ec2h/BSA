function solar_flare_start(event)
	local caster = event.caster
	local caster_pos = caster:GetAbsOrigin()
	local ability = event.ability

	local targets = FindUnitsInRadius(caster:GetTeam(), caster_pos, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false)
	for _, target in ipairs(targets) do
		local point = target:GetAbsOrigin()
		local dummy = CreateUnitByName("npc_treasure_chest2", point + RandomVector( RandomFloat( 150, 150 )), false, caster, caster, caster:GetTeamNumber())
		Timers:CreateTimer(10, function()
		dummy:ForceKill(false)
		end)
	end
end