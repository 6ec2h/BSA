marci_dispose_lua = class({})

function marci_dispose_lua:OnSpellStart()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor( "impact_damage" )
	stun_duration = self:GetSpecialValueFor("stun_duration")
	
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_marci_1")
	if ability ~= nil and ability:GetLevel() > 0 then 
		damage = damage + 220
	end
	
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	local damageTable = {
		victim = nil,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = stun_duration } )
	end
	self:PlayEffects()
end

function marci_dispose_lua:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf"
	local radius = self:GetSpecialValueFor("radius")
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hoof_L",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hoof_R",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_Marci.Grapple.Stun", self:GetCaster() )
end