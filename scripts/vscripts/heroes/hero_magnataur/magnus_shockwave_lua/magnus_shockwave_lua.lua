magnus_shockwave_lua = class({})

function magnus_shockwave_lua:RequiemLineEffect(position, velocity, duration)
	local caster = self:GetCaster()
	local effect = ParticleManager:CreateParticle("particles/juger_line.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(effect, 0, position)
	ParticleManager:SetParticleControl(effect, 1, velocity)
	ParticleManager:SetParticleControl(effect, 2, Vector(0, duration, 0))
	ParticleManager:ReleaseParticleIndex(effect)
end


function magnus_shockwave_lua:LaunchRequiemLine(start_pos, travel_distance, start_radius, end_radius, velocity, travel_time, isScepter)
	ProjectileManager:CreateLinearProjectile({
		Ability = self,
		EffectName = nil,
		vSpawnOrigin = start_pos,
		fDistance = travel_distance,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = self:GetCaster(),
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = false,
		vVelocity = velocity,
		bProvidesVision = false,
		ExtraData = {is_scepter = isScepter}
	})
	self:RequiemLineEffect(start_pos, velocity, travel_time)
end

function magnus_shockwave_lua:CreateRequiemLine(caster_pos, end_pos)
	local caster = self:GetCaster()
	local velocity = (end_pos - caster_pos):Normalized() * self.lines_travel_speed
	self:LaunchRequiemLine(caster_pos, self.travel_distance, self.lines_starting_width, self.lines_end_width, velocity, self.travel_time, false)
end
	
function magnus_shockwave_lua:OnSpellStart()
	local caster = self:GetCaster()
	local line = self:GetSpecialValueFor("line")
	self.damage = self:GetSpecialValueFor("damage")
	caster:EmitSound("Hero_Magnataur.ShockWave.Particle")
	self.lines_end_width = self:GetSpecialValueFor("lines_end_width")
	self.lines_starting_width = self:GetSpecialValueFor("lines_starting_width")
	self.lines_travel_speed = self:GetSpecialValueFor("lines_travel_speed")
	self.travel_distance = self:GetSpecialValueFor("travel_distance")
	self.travel_time = self.travel_distance / self.lines_travel_speed
		
	local effect = ParticleManager:CreateParticle("particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil_hit.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:ReleaseParticleIndex(effect)
		
	if self:GetCaster():FindAbilityByName("special_bonus_magnus_agi2")~=nil then
		if self:GetCaster():FindAbilityByName("special_bonus_magnus_agi2"):GetLevel() > 0 then 
			line = line + 2
		end	
	end

	local line_count = line
	local caster_pos = caster:GetAbsOrigin()
	local line_pos = caster_pos + caster:GetForwardVector() * self.travel_distance
	local rotation_rate = 360 / line_count  -- spaced around all circle.
		
	self:CreateRequiemLine(caster_pos, line_pos)
	for i = 1, line_count - 1 do
		line_pos = RotatePosition(caster_pos, QAngle(0, rotation_rate, 0), line_pos)
		self:CreateRequiemLine(caster_pos, line_pos)
	end
end


function magnus_shockwave_lua:OnProjectileHit_ExtraData(target, location, extra)
	if target then
		local caster = self:GetCaster()
		local damage = self.damage
			
		ApplyDamage({
			ability = self,
			attacker = caster,
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			victim = target
		})
	end
end