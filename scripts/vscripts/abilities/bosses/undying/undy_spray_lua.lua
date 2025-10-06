undy_spray_lua = class({})
LinkLuaModifier( "modifier_undy_spray_lua", "abilities/bosses/undying/undy_spray_lua", LUA_MODIFIER_MOTION_NONE )

function undy_spray_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function undy_spray_lua:OnSpellStart()
	local point = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor( "duration" )

	CreateModifierThinker(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_undy_spray_lua", -- modifier name
		{ duration = duration }, -- kv
		point,
		self:GetCaster():GetTeamNumber(),
		false
	)
end


------------------------------------------------------------------------------------------------

modifier_undy_spray_lua = class({})

function modifier_undy_spray_lua:IsHidden()
	return false
end

function modifier_undy_spray_lua:IsDebuff()
	return true
end

function modifier_undy_spray_lua:IsStunDebuff()
	return false
end

function modifier_undy_spray_lua:IsPurgable()
	return false
end

function modifier_undy_spray_lua:OnCreated( kv )
	local interval = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.armor = -self:GetAbility():GetSpecialValueFor( "armor_reduction" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	self.thinker = kv.isProvidedByAura~=1

	if not IsServer() then return end
	if not self.thinker then return end


	self.damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(),
	}

	self:StartIntervalThink( interval )

	self.sound_cast = "Hero_Alchemist.AcidSpray.Damage"
	self:PlayEffects()
end

function modifier_undy_spray_lua:OnRefresh( kv )
	
end

function modifier_undy_spray_lua:OnRemoved()
end

function modifier_undy_spray_lua:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end

	UTIL_Remove( self:GetParent() )
end

function modifier_undy_spray_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_undy_spray_lua:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_undy_spray_lua:OnIntervalThink()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0,	0, false)
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		self.damageTable.damage = enemy:GetMaxHealth()/100*self.damage
		ApplyDamage( self.damageTable )
		EmitSoundOn( self.sound_cast, enemy )
	end
end

function modifier_undy_spray_lua:IsAura()
	return self.thinker
end

function modifier_undy_spray_lua:GetModifierAura()
	return "modifier_undy_spray_lua"
end

function modifier_undy_spray_lua:GetAuraRadius()
	return self.radius
end

function modifier_undy_spray_lua:GetAuraDuration()
	return 0.5
end

function modifier_undy_spray_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_undy_spray_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_undy_spray_lua:GetAuraSearchFlags()
	return 0
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_undy_spray_lua:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

function modifier_undy_spray_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_undy_spray_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf"
	local sound_cast = "Hero_Alchemist.AcidSpray"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end