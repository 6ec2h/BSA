LinkLuaModifier("modifier_custom_torrential_waters", "abilities/bosses/custom_torrential_waters", LUA_MODIFIER_MOTION_VERTICAL)

custom_torrential_waters = class({})

function custom_torrential_waters:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_guided_missile_target.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", context )
end

function custom_torrential_waters:OnSpellStart()    
	local duration = self:GetSpecialValueFor("duration") 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_torrential_waters", {duration = duration})
end

------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_custom_torrential_waters = class({})

function modifier_custom_torrential_waters:IsHidden()
	return false
end

function modifier_custom_torrential_waters:IsPurgable()
	return false
end

function modifier_custom_torrential_waters:OnCreated( kv )
	self:StartIntervalThink(0.4)
end


function modifier_custom_torrential_waters:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	  }
	return state
end

function modifier_custom_torrential_waters:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_custom_torrential_waters:GetOverrideAnimation()
	return ACT_DOTA_TELEPORT
end

function modifier_custom_torrential_waters:OnIntervalThink()	
if not IsServer() then return end	
	local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local ability = self:GetAbility()
	local range = self:GetAbility():GetSpecialValueFor("range")
	local delay = self:GetAbility():GetSpecialValueFor("delay")
	local damage = self:GetAbility():GetSpecialValueFor("damage")
	local damage_radius = self:GetAbility():GetSpecialValueFor("damage_radius")
	
	local angle = RandomInt(0, 360)
	local variance = RandomInt(-range, range)
	local dy = math.sin(angle) * variance
	local dx = math.cos(angle) * variance
	local target_pos = Vector(caster_pos.x + dx, caster_pos.y + dy, caster_pos.z)

	local particle_blast_fx = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_blast_fx, 0, target_pos)
	ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(damage_radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_blast_fx)
	caster:EmitSound("Ability.Torrent")
	
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		for k, unit in ipairs(units) do
		local damage_table = {
								attacker = caster,
								victim = unit,
								ability = ability,
								damage_type = DAMAGE_TYPE_MAGICAL,
								damage = damage,
							}
		ApplyDamage(damage_table)
	end	
end