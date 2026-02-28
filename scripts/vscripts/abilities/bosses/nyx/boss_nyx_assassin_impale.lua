boss_nyx_assassin_impale = class({})
LinkLuaModifier("modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_nyx_assassin_passive", "abilities/bosses/nyx/boss_nyx_assassin_impale.lua"	, LUA_MODIFIER_MOTION_NONE)

function boss_nyx_assassin_impale:GetIntrinsicModifierName()
	return "modifier_boss_nyx_assassin_passive"
end

function boss_nyx_assassin_impale:OnSpellStart()
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local sound_cast = "Hero_NyxAssassin.Impale"
	local particle_projectile = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_impale.vpcf"

	local width = ability:GetSpecialValueFor("width")
	local duration = ability:GetSpecialValueFor("duration")
	local length = ability:GetSpecialValueFor("length")
	local speed = ability:GetSpecialValueFor("speed")

	EmitSoundOn(sound_cast, caster)

	local direction = (target_point - caster:GetAbsOrigin()):Normalized()

	local spikes_projectile = { Ability = ability,
		EffectName = particle_projectile,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = length,
		fStartRadius = width,
		fEndRadius = width,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = false,
		vVelocity = direction * speed * Vector(1, 1, 0),
		bProvidesVision = false,
		ExtraData = { }
	}

	ProjectileManager:CreateLinearProjectile(spikes_projectile)
end

function boss_nyx_assassin_impale:OnProjectileHit_ExtraData(target, location, ExtraData)
	if not target then
		return nil
	end

	if target:IsMagicImmune() then
		return nil
	end

	local caster = self:GetCaster()
	local ability = self
	local sound_impact = "Hero_NyxAssassin.Impale.Target"
	local sound_land = "Hero_NyxAssassin.Impale.TargetLand"
	local particle_impact = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_impale_hit.vpcf"


	duration = ability:GetSpecialValueFor("duration")
	air_time = ability:GetSpecialValueFor("air_time")
	air_height = ability:GetSpecialValueFor("air_height")

	EmitSoundOn(sound_impact, target)

	local particle_impact_fx = ParticleManager:CreateParticle(particle_impact, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle_impact_fx, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_impact_fx)

	target:AddNewModifier(caster, ability, "modifier_generic_stunned_lua", {duration = duration * (1 - target:GetStatusResistance())})

	local knockbackProperties =
		{
			duration = air_time * (1 - target:GetStatusResistance()),
			knockback_duration = air_time * (1 - target:GetStatusResistance()),
			knockback_distance = 0,
			knockback_height = air_height
		}

	target:RemoveModifierByName("modifier_knockback")
	target:AddNewModifier(target, nil, "modifier_knockback", knockbackProperties)

	Timers:CreateTimer(0.5, function()
		target:RemoveGesture(ACT_DOTA_FLAIL)
		
	end)

	Timers:CreateTimer(air_time, function()

			EmitSoundOn(sound_land, target)

				damageTable = {
				victim = target,
				attacker = caster,
				damage = target:GetMaxHealth() * ability:GetSpecialValueFor("damage")*0.01,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability
			}
			ApplyDamage(damageTable)
	end)
end


--------------------------------------------------------------------------------

modifier_boss_nyx_assassin_passive = class({})

function modifier_boss_nyx_assassin_passive:IsHidden()
	return true
end

function modifier_boss_nyx_assassin_passive:IsPurgable()
	return false
end

function modifier_boss_nyx_assassin_passive:OnCreated( kv )
	if self:GetParent():GetUnitName() == "NYX" then
		self:PlayEffects2()
		self.phis = 1
		self.mag = 0
	end
	if self:GetParent():GetUnitName() == "NYX_2" then
		self:PlayEffects()
		self.phis = 0
		self.mag = 1
	end
end

function modifier_boss_nyx_assassin_passive:OnRefresh( kv )
end

function modifier_boss_nyx_assassin_passive:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	}
	return funcs
end

function modifier_boss_nyx_assassin_passive:GetAbsoluteNoDamagePhysical()
  return self.phis
end

function modifier_boss_nyx_assassin_passive:GetAbsoluteNoDamageMagical()
  return self.mag
end

function modifier_boss_nyx_assassin_passive:PlayEffects()
	local particle = ParticleManager:CreateParticle("particles/nyx_phisical.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle, 1, Vector(150, 150, 150)) -- Arbitrary
	self:AddParticle(particle, false, false, -1, false, false)
end

function modifier_boss_nyx_assassin_passive:PlayEffects2()
	local particle = ParticleManager:CreateParticle("particles/nyx_magical.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle, 1, Vector(150, 150, 150)) -- Arbitrary
	self:AddParticle(particle, false, false, -1, false, false)
end