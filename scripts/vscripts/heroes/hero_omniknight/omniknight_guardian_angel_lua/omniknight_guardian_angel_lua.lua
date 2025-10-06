omniknight_guardian_angel_lua = class({})
LinkLuaModifier( "modifier_omniknight_guardian_angel_lua", "heroes/hero_omniknight/omniknight_guardian_angel_lua/modifier_omniknight_guardian_angel_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function omniknight_guardian_angel_lua:OnSpellStart()
	local caster = self:GetCaster()

	local buffDuration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")


	local allies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,ally in pairs(allies) do
		ally:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_omniknight_guardian_angel_lua", -- modifier name
			{ duration = buffDuration } -- kv
		)
		
		if self:GetCaster():FindAbilityByName("special_bonus_omniknight_int4")~=nil then
		if self:GetCaster():FindAbilityByName("special_bonus_omniknight_int4"):GetLevel() > 0 then
			ability_heal = self:GetCaster():FindAbilityByName("omniknight_purification_lua")
				if ability_heal:GetLevel() > 0 then
					
				local heal = ability_heal:GetSpecialValueFor("heal")
				local radius = ability_heal:GetSpecialValueFor("radius")
				
				if self:GetCaster():FindAbilityByName("special_bonus_omniknight_int1")~=nil then
					if self:GetCaster():FindAbilityByName("special_bonus_omniknight_int1"):GetLevel() > 0 then
						heal = ability_heal:GetSpecialValueFor("heal") * 2
					end
				end

				-- heal
				ally:Heal( heal, self )

				-- Find Units in Radius
				local enemies = FindUnitsInRadius(
					self:GetCaster():GetTeamNumber(),	-- int, your team number
					ally:GetOrigin(),	-- point, center point
					nil,	-- handle, cacheUnit. (not known)
					radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
					DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
					0,	-- int, flag filter
					0,	-- int, order filter
					false	-- bool, can grow cache
				)

				-- Apply Damage	 
				local damageTable = {
					attacker = caster,
					damage = heal,
					damage_type = DAMAGE_TYPE_PURE,
					ability = self, --Optional.
				}
				for _,enemy in pairs(enemies) do
					damageTable.victim = enemy
					ApplyDamage(damageTable)
					self:PlayEffects2( ally, enemy )
				end

				self:PlayEffects1( ally, radius )
					
				end
			end
		end	
	end

	-- Play Effects
	local sound_cast = "Hero_Omniknight.GuardianAngel.Cast"
	EmitSoundOn( sound_cast, caster )
end

-----------------------------------------------------------------------------------------------------------

function omniknight_guardian_angel_lua:PlayEffects1( target, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
	local particle_target = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
	local sound_target = "Hero_Omniknight.Purification"

	-- Create Target Effects
	local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_target, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_target )
	EmitSoundOn( sound_target, target )

	-- Create Caster Effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function omniknight_guardian_angel_lua:PlayEffects2( origin, target )
	local particle_target = "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf"
	local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_target,
		0,
		origin,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		origin:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_target,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_target )
end