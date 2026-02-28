LinkLuaModifier( "modifier_scatterblast_lua_debuff", "heroes/hero_lion/lion_soul_collector/lion_soul_collector", LUA_MODIFIER_MOTION_NONE)

scatterblast_lua = class({})

function scatterblast_lua:OnAbilityPhaseStart()
	local sound_cast = "Hero_Snapfire.Shotgun.Load"
	EmitSoundOn( sound_cast, self:GetCaster() )
	return true 
end

function scatterblast_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()

	local projectile_name = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun.vpcf"
	local projectile_distance = self:GetCastRange( point, nil )
	local projectile_start_radius = self:GetSpecialValueFor( "blast_width_initial" )/2
	local projectile_end_radius = self:GetSpecialValueFor( "blast_width_end" )/2
	local projectile_speed = self:GetSpecialValueFor( "blast_speed" )
	local projectile_direction = point-origin
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()	

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = self:GetAbilityTargetTeam(),
	    iUnitTargetFlags = self:GetAbilityTargetFlags(),
	    iUnitTargetType = self:GetAbilityTargetType(),
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bProvidesVision = false,
		ExtraData = {
			pos_x = origin.x,
			pos_y = origin.y,
		}
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- play sound
	local sound_cast = "Hero_Snapfire.Shotgun.Fire"
	EmitSoundOn( sound_cast, caster )
end
--------------------------------------------------------------------------------
-- Projectile
function scatterblast_lua:OnProjectileHit_ExtraData( target, location, extraData )
	if not target then return end

	-- load data
	local caster = self:GetCaster()
	local location = target:GetOrigin()
	local point_blank_range = self:GetSpecialValueFor( "point_blank_range" )
	local damage = self:GetSpecialValueFor( "damage" )

	-- check position
	local origin = Vector( extraData.pos_x, extraData.pos_y, 0 )
	local length = (location-origin):Length2D()

	if self:GetCaster():FindAbilityByName("npc_dota_hero_triss_tal1") ~= nil then 
		if self:GetCaster():FindAbilityByName("npc_dota_hero_triss_tal1"):GetLevel() > 0 then 
			damage = damage + self:GetCaster():GetAgility()/2
		end
	end

	local point_blank = (length<=point_blank_range)
	if point_blank then damage = damage end

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	target:AddNewModifier( self:GetCaster(), self, "modifier_scatterblast_lua_debuff", { duration = self:GetSpecialValueFor( "duration" ) } )
	
			
	if self:GetCaster():FindAbilityByName("npc_dota_hero_triss_tal2") ~= nil then 
		if self:GetCaster():FindAbilityByName("npc_dota_hero_triss_tal2"):GetLevel() > 0 then 	
			target:AddNewModifier( target, nil, "modifier_generic_stunned_lua", { duration = 2} )
		end
	end

	self:PlayEffects( target, point_blank )
end

--------------------------------------------------------------------------------
function scatterblast_lua:PlayEffects( target, point_blank )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_impact.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_snapfire/hero_snapfire_shells_impact.vpcf"
	local particle_cast3 = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_pointblank_impact_sparks.vpcf"
	local sound_target = "Hero_Snapfire.Shotgun.Target"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if point_blank then
		local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_POINT_FOLLOW, target )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			3,
			target,
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
		ParticleManager:ReleaseParticleIndex( effect_cast )

		local effect_cast = ParticleManager:CreateParticle( particle_cast3, PATTACH_POINT_FOLLOW, target )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			4,
			target,
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end

	-- Create Sound
	EmitSoundOn( sound_target, target )
end

LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

modifier_scatterblast_lua_debuff = class({})
function modifier_scatterblast_lua_debuff:IsHidden() return false end
function modifier_scatterblast_lua_debuff:IsDebuff() return true end
function modifier_scatterblast_lua_debuff:IsPurgable() return true end

function modifier_scatterblast_lua_debuff:OnCreated()
	self.armor_reduction = (-1) * ability:GetSpecialValueFor("debuff")
end

function modifier_scatterblast_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_scatterblast_lua_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction
end