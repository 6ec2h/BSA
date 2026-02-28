LinkLuaModifier( "modifier_luna_starfall", "heroes/hero_luna/luna_starfall/luna_starfall", LUA_MODIFIER_MOTION_NONE )

luna_starfall = class({})

function luna_starfall:GetIntrinsicModifierName()
	return "modifier_luna_starfall"
end

--------------------------------------------------------------------------------

modifier_luna_starfall = class({})

function modifier_luna_starfall:IsHidden()
	return true
end

function modifier_luna_starfall:IsPurgable()
	return false
end

function modifier_luna_starfall:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self:StartIntervalThink(0.1)
end

function modifier_luna_starfall:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )	
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )	
end

function modifier_luna_starfall:OnIntervalThink()
	if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() then
		if self:GetAbility():IsCooldownReady() then
			local enemy = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			if #enemy > 0 then
				target_enemy = enemy[RandomInt(1,#enemy)]
				self:GetCaster():EmitSound("Hero_Luna.LucentBeam.Cast")
				target_enemy:EmitSound("Hero_Luna.LucentBeam.Target")
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_lucent_beam.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
				ParticleManager:SetParticleControl(particle, 1, target_enemy:GetAbsOrigin())
				ParticleManager:SetParticleControlEnt(particle,	5, target_enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", target_enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(particle,	6, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(particle)
				local damageTable = {
					victim 			= target_enemy,
					damage 			= self.damage,
					damage_type		= DAMAGE_TYPE_MAGICAL,
					attacker 		= self:GetCaster(),
					ability 		= self:GetAbility()
				}
				ApplyDamage(damageTable)	
			end	
			self:GetAbility():UseResources( false,false, false, true )
		end
	end
end