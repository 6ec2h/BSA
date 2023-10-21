LinkLuaModifier("modifier_golden_sun", "abilities/creeps/golden_sun", LUA_MODIFIER_MOTION_VERTICAL)

golden_sun = class({})

function golden_sun:OnSpellStart()
	if IsServer() then        
	local duration = self:GetSpecialValueFor("duration")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_golden_sun", {duration = duration})
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_golden_sun = class({})

function modifier_golden_sun:IsHidden()
	return true
end

function modifier_golden_sun:IsPurgable()
	return false
end

function modifier_golden_sun:OnCreated( kv )
	self:StartIntervalThink(0.7)
end

function modifier_golden_sun:OnIntervalThink()
if not IsServer() then return end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local particle_start = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf"
	local particle_end = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf"
	local damage = self:GetAbility():GetSpecialValueFor("damage")
	local delay = self:GetAbility():GetSpecialValueFor("delay")
	local damage_radius = self:GetAbility():GetSpecialValueFor("damage_radius")
	local range = self:GetAbility():GetSpecialValueFor("range")
	local hEnemies = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
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
				local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, damage_radius,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
				for _, unit in ipairs(units) do
					ApplyDamage({attacker = caster, victim = unit, ability = ability, damage_type = ability:GetAbilityDamageType(), damage = damage})
				end
			end)
		end
	end
end
