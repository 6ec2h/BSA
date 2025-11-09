ultra_cast_spawn_dado = class({})

function ultra_cast_spawn_dado:Precache(context)
	PrecacheResource("soundfile", "soundevents/game_sounds_ultra_dado.vsndevts", context)
end

function ultra_cast_spawn_dado:OnSpellStart()
	if not IsServer() then return end

	local x, y

	if RandomInt(1, 2) == 1 then
		if RandomInt(1, 2) == 1 then
			x = GetWorldMinX()
		else
			x = GetWorldMaxX()
		end

		y = RandomInt(GetWorldMinY(), GetWorldMaxY())
	else
		if RandomInt(1, 2) == 1 then
			y = GetWorldMinY()
		else
			y = GetWorldMaxY()
		end

		x = RandomInt(GetWorldMinX(), GetWorldMaxX())
	end

	CreateUnitByName("ultra_dado_one_shoot", Vector(x, y, 0), true, nil, nil, DOTA_TEAM_NEUTRALS)
end