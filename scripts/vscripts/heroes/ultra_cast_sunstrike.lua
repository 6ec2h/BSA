ultra_cast_sunstrike = class({})

function ultra_cast_sunstrike:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	
	local targetUnits = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for _, sunstrikeTargetUnit in ipairs(targetUnits) do 
		local point = sunstrikeTargetUnit:GetAbsOrigin()
			
		local preParticleHandle = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(preParticleHandle, 0, point)
		ParticleManager:SetParticleControl(preParticleHandle, 1, Vector(200, 0, 0))

		EmitSoundOn("Hero_Invoker.SunStrike.Charge", sunstrikeTargetUnit)
			
		Timers:CreateTimer(1.7, function()
			ParticleManager:DestroyParticle(preParticleHandle, false)

			local postParticleHandle = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(postParticleHandle, 0, point)
			ParticleManager:SetParticleControl(postParticleHandle, 1, Vector(200, 0, 0))

			Timers:CreateTimer(6, function()
				ParticleManager:DestroyParticle(postParticleHandle, true)
			end)

			EmitSoundOn("Hero_Invoker.SunStrike.Ignite", sunstrikeTargetUnit)

			local unitsUnderSunstrike = FindUnitsInRadius(caster:GetTeam(), point, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

			for _, unit in ipairs(unitsUnderSunstrike) do
				if not enemy:IsQuestSheep() then
					ApplyDamage({
						attacker = caster,
						victim = unit,
						ability = self,
						damage_type = DAMAGE_TYPE_PURE,
						damage = unit:GetMaxHealth() * 2,
					})
				end
			end		
		end)
	end	
end