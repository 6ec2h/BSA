tidehunter_ravage_lua = class({})
LinkLuaModifier( "modifier_generic_arc_lua", "heroes/generic/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_ring_lua", "heroes/generic/modifier_generic_ring_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

function tidehunter_ravage_lua:GetCooldown( level )
	local talent = self:GetCaster():FindAbilityByName("special_bonus_tidehunter_3")
	if talent and talent:GetLevel() > 0 then
		return self.BaseClass.GetCooldown( self, level ) / 2
	end
	return self.BaseClass.GetCooldown( self, level )
end


function tidehunter_ravage_lua:OnSpellStart()
	local caster = self:GetCaster()
	local damage = self:GetAbilityDamage()
	local damage_type = self:GetAbilityDamageType()
	local radius = self:GetSpecialValueFor( "radius" )
	local speed = self:GetSpecialValueFor( "speed" )
	local duration = self:GetSpecialValueFor( "duration" )
	local width = 250
	local height = 350
	local knock_duration = 0.5

	local damageTable = {
		attacker = caster,
		damage = damage,
		damage_type = damage_type,
		ability = self, --Optional.
	}

	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_generic_ring_lua", -- modifier name
		{
			start_radius = width,
			end_radius = radius,
			speed = speed,
			width = width,
			target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}, -- kv
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
	ring = thinker:FindModifierByName( "modifier_generic_ring_lua" )

	ring:SetCallback( function( enemy )
		local knockback = enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_arc_lua", -- modifier name
			{
				duration = knock_duration,
				height = height,
			} -- kv
		)
		knockback:SetEndCallback( function()
			damageTable.victim = enemy
			ApplyDamage( damageTable )
			EmitSoundOn( "Hero_Tidehunter.RavageDamage", enemy )
		end)

		enemy:AddNewModifier(caster, self, "modifier_generic_stunned_lua", { duration = duration })
		self:PlayEffects2( enemy )
	end)
	self:PlayEffects1( caster:GetOrigin(), radius, speed )
end

function tidehunter_ravage_lua:PlayEffects1( center, radius, speed )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, center )
	for i=1,5 do
		local pos = radius/5*i
		ParticleManager:SetParticleControl( effect_cast, i, Vector( pos, 1, 1 ) )
	end
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( center, "Ability.Ravage", self:GetCaster() )
end

function tidehunter_ravage_lua:PlayEffects2( enemy )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end