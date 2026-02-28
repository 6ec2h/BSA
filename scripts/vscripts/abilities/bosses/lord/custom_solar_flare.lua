LinkLuaModifier("modifier_custom_solar_flare", "abilities/bosses/lord/custom_solar_flare", LUA_MODIFIER_MOTION_VERTICAL)

custom_solar_flare = class({})

function custom_solar_flare:OnSpellStart()    
if not IsServer() then return end
	local particle_start = "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf"
	local particle_end = "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
	local damage = self:GetSpecialValueFor("damage")
	local delay = self:GetSpecialValueFor("delay")-0.3
	local damage_radius = self:GetSpecialValueFor("damage_radius")
	local range = self:GetSpecialValueFor("range")
	local damage_table = {
						attacker = self:GetCaster(),
						damage_type = self:GetAbilityDamageType(),
						damage = damage
						}
	
	local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #hEnemies > 0 then
		for _, target in ipairs(hEnemies) do
			local point = target:GetAbsOrigin()
			local startFX = ParticleManager:CreateParticle(particle_start, PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControl(startFX, 0, point)
			ParticleManager:SetParticleControl(startFX, 1, Vector(damage_radius, 0, 0))
			EmitSoundOn("Hero_Invoker.SunStrike.Charge", target)
			Timers:CreateTimer(delay, function()
				ParticleManager:DestroyParticle(startFX, false)
				local endFX = ParticleManager:CreateParticle(particle_end, PATTACH_ABSORIGIN, target)
				ParticleManager:SetParticleControl(endFX, 0, point)
				ParticleManager:SetParticleControl(endFX, 1, Vector(damage_radius, 0, 0))
				EmitSoundOn("Hero_Invoker.SunStrike.Ignite", target)
				local units = FindUnitsInRadius(DOTA_TEAM_BADGUYS, point, nil, damage_radius,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
				for _, unit in ipairs(units) do
					damage_table.victim = unit
					ApplyDamage(damage_table)
				end
			end)
		end
	end
end
