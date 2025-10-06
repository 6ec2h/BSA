LinkLuaModifier( "modifier_brute_split_earth", "abilities/creeps/brute_split_earth", LUA_MODIFIER_MOTION_NONE )

brute_split_earth = class({})

function brute_split_earth:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", context )
end

function brute_split_earth:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local delay = self:GetSpecialValueFor("delay")

	CreateModifierThinker(caster, self, "modifier_brute_split_earth", { duration = delay }, point, caster:GetTeamNumber(), false)
end

----------------------------------------------

modifier_brute_split_earth = class({})

function modifier_brute_split_earth:IsHidden()
	return true
end

function modifier_brute_split_earth:IsPurgable()
	return false
end

function modifier_brute_split_earth:OnCreated( kv )
	if not IsServer() then return end
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(),
	}
end

function modifier_brute_split_earth:OnDestroy()
	if not IsServer() then return end
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.duration * (1 - enemy:GetStatusResistance()) } -- kv
		)
		self.damageTable.victim = enemy
		self.damageTable.damage = enemy:GetMaxHealth() / 100 * self.damage
		ApplyDamage( self.damageTable )
	end

	self:PlayEffects()
	UTIL_Remove( self:GetParent() )
end

function modifier_brute_split_earth:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
	local sound_cast = "Hero_Leshrac.Split_Earth"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end