modifier_skywrath_mage_mystic_flare_lua_thinker = class({})

function modifier_skywrath_mage_mystic_flare_lua_thinker:OnCreated( kv )
	local interval = self:GetAbility():GetSpecialValueFor( "damage_interval" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if IsServer() then
		self.damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():GetIntellect(true) * self:GetAbility():GetSpecialValueFor("ExtraIntelligenceDamage") 
		self.damage = self.damage * interval / kv.duration
		self.damageTable = {
			attacker = self:GetCaster(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(),
		}

		self:StartIntervalThink(interval)
		self:OnIntervalThink()
		self:PlayEffects( self.radius, kv.duration, interval )
	end
end

function modifier_skywrath_mage_mystic_flare_lua_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end


function modifier_skywrath_mage_mystic_flare_lua_thinker:OnIntervalThink()
	local heroes = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY,	DOTA_UNIT_TARGET_ALL, 0, 0, false)
	if #heroes<1 then return end
	for _,hero in pairs(heroes) do
		self.damageTable.victim = hero
		self.damageTable.damage = self.damage
		ApplyDamage( self.damageTable )
	end
end

function modifier_skywrath_mage_mystic_flare_lua_thinker:PlayEffects( radius, duration, interval )
	local particle_cast = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient.vpcf"
	local sound_cast = "Hero_SkywrathMage.MysticFlare"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, interval ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, self:GetParent() )
end