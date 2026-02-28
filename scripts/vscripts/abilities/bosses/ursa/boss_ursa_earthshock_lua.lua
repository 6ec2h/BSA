boss_ursa_earthshock_lua = class({})
LinkLuaModifier( "modifier_boss_ursa_earthshock_lua", "abilities/bosses/ursa/boss_ursa_earthshock_lua.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_ursa_earthshock_lua:OnSpellStart()
	local slow_radius = self:GetSpecialValueFor("shock_radius")
	local slow_duration = self:GetDuration()


	local enemies = FindUnitsInRadius (
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetOrigin(),
		nil,
		slow_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	for _,enemy in pairs(enemies) do
		
		ability_damage = enemy:GetMaxHealth()*self:GetSpecialValueFor("damage")/100
		
		local damage = {
			victim = enemy,
			attacker = self:GetCaster(),
			damage = ability_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}
		ApplyDamage( damage )

		enemy:AddNewModifier(
			self:GetCaster(),
			self,
			"modifier_boss_ursa_earthshock_lua",
			{ duration = slow_duration }
		)
	end

	self:PlayEffects()
end

function boss_ursa_earthshock_lua:PlayEffects()
	-- get resources
	local sound_cast = "Hero_Ursa.Earthshock"
	local particle_cast = "particles/units/heroes/hero_ursa/ursa_earthshock.vpcf"

	-- get data
	local slow_radius = self:GetSpecialValueFor("shock_radius")

	-- play particles
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self:GetCaster():GetForwardVector() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(slow_radius/2, slow_radius/2, slow_radius/2) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sounds
	EmitSoundOn( sound_cast, self:GetCaster() )
end


--------------------------------------------------------------------------------

modifier_boss_ursa_earthshock_lua = class({})

--------------------------------------------------------------------------------

function modifier_boss_ursa_earthshock_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_ursa_earthshock_lua:OnCreated( kv )
	self.slow = self:GetAbility():GetSpecialValueFor("movement_slow")
end

function modifier_boss_ursa_earthshock_lua:OnRefresh( kv )
	self.slow = self:GetAbility():GetSpecialValueFor("movement_slow")
end
--------------------------------------------------------------------------------

function modifier_boss_ursa_earthshock_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_ursa_earthshock_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_boss_ursa_earthshock_lua:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_earthshock_modifier.vpcf"
end

function modifier_boss_ursa_earthshock_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end