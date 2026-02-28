modifier_effect_25 = class({})

function modifier_effect_25:IsHidden()
	return true
end

function modifier_effect_25:IsPurgable()
	return false
end

function modifier_effect_25:IsPermanent()
	return true
end

function modifier_effect_25:OnCreated( kv )
	self.caster = self:GetCaster()
	self.particleLeader = ParticleManager:CreateParticle( "particles/econ/events/summer_2021/summer_2021_emblem_effect.vpcf", PATTACH_POINT_FOLLOW, self.caster )
	ParticleManager:SetParticleControlEnt( self.particleLeader, PATTACH_OVERHEAD_FOLLOW, self.caster, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", self.caster:GetAbsOrigin(), true )
end

function modifier_effect_25:OnDestroy( kv )
	ParticleManager:DestroyParticle(self.particleLeader, true)
    ParticleManager:ReleaseParticleIndex(self.particleLeader)
end
