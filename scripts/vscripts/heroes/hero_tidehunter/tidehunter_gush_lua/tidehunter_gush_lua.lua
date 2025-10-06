tidehunter_gush_lua = class({})
LinkLuaModifier( "modifier_tidehunter_gush_lua", "heroes/hero_tidehunter/tidehunter_gush_lua/tidehunter_gush_lua", LUA_MODIFIER_MOTION_NONE )

function tidehunter_gush_lua:GetBehavior()
	local ability = self:GetCaster():FindAbilityByName("special_bonus_tidehunter_2")
	if ability ~= nil and ability:GetLevel() > 0 then 
		return DOTA_ABILITY_BEHAVIOR_POINT
	end

	return self.BaseClass.GetBehavior( self )
end

--------------------------------------------------------------------------------
-- Ability Start
function tidehunter_gush_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	local ability = self:GetCaster():FindAbilityByName("special_bonus_tidehunter_2")
	if ability ~= nil and ability:GetLevel() > 0 then 
		if target then point = target:GetOrigin() end

		local name = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf"
		local speed = self:GetSpecialValueFor("talent_speed")
		local radius = self:GetSpecialValueFor("talent_aoe")
		local range = self:GetCastRange( point, target )
		local direction = point-caster:GetOrigin()
		direction.z = 0
		direction = direction:Normalized()

		-- create linear projectile
		local info = {
			Source = caster,
			Ability = self,
			vSpawnOrigin = caster:GetAbsOrigin(),
		
			bDeleteOnHit = false,
		
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		
			EffectName = name,
			fDistance = range,
			fStartRadius = radius,
			fEndRadius = radius,
			vVelocity = direction * speed,
			ExtraData = {
				talent = 1,
			}
		}
		ProjectileManager:CreateLinearProjectile( info )
	else

		local name = "particles/units/heroes/hero_tidehunter/tidehunter_gush.vpcf"
		local speed = self:GetSpecialValueFor("projectile_speed")

		local info = {
			Target = target,
			Source = caster,
			Ability = self,	
			
			EffectName = name,
			iMoveSpeed = speed,
			bDodgeable = true,                           -- Optional
			ExtraData = {
				talent = 0,
			}
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end

	local sound_cast = "Ability.GushCast"
	EmitSoundOn( sound_cast, self:GetCaster() )
end


function tidehunter_gush_lua:OnProjectileHit_ExtraData( target, location, data )
	if not target then return end

	if data.talent==0 and target:TriggerSpellAbsorb( self ) then return end

	if data.talent==1 then
		local vision = 200
		local duration = 2

		AddFOWViewer( self:GetCaster():GetTeamNumber(), target:GetOrigin(), vision, duration, true )
	end

	local damage = self:GetSpecialValueFor("gush_damage")
	local duration = self:GetDuration()

	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_tidehunter_gush_lua", -- modifier name
		{ duration = duration } -- kv
	)

	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- effects
	if data.talent==0 then
		self:PlayEffects( target )

	end

	local sound_cast = "Ability.GushImpact"
	EmitSoundOn( sound_cast, target )

	return false
end

function tidehunter_gush_lua:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_tidehunter/tidehunter_gush_splash.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

-------------------------------------------------------------------------------

modifier_tidehunter_gush_lua = class({})

function modifier_tidehunter_gush_lua:IsHidden()
	return false
end

function modifier_tidehunter_gush_lua:IsDebuff()
	return true
end

function modifier_tidehunter_gush_lua:IsStunDebuff()
	return false
end

function modifier_tidehunter_gush_lua:IsPurgable()
	return true
end

function modifier_tidehunter_gush_lua:OnCreated( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "movement_speed" ) -- special value
	self.armor = -self:GetAbility():GetSpecialValueFor( "negative_armor" ) -- special value
end

function modifier_tidehunter_gush_lua:OnRefresh( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "movement_speed" ) -- special value
	self.armor = -self:GetAbility():GetSpecialValueFor( "negative_armor" ) -- special value	
end

function modifier_tidehunter_gush_lua:OnDestroy( kv )

end

function modifier_tidehunter_gush_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_tidehunter_gush_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end
function modifier_tidehunter_gush_lua:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_tidehunter_gush_lua:GetEffectName()
	return "particles/units/heroes/hero_tidehunter/tidehunter_gush_slow.vpcf"
end

function modifier_tidehunter_gush_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end