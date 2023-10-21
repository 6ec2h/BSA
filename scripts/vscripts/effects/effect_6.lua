modifier_effect_6 = class({})

function modifier_effect_6:IsHidden()
	return true
end

function modifier_effect_6:IsPurgable()
	return false
end

function modifier_effect_6:IsPermanent()
	return true
end

function modifier_effect_6:OnCreated( kv )
	self.caster = self:GetCaster()
	self.particleLeader = ParticleManager:CreateParticle( "particles/frostivus_versus.vpcf", PATTACH_POINT_FOLLOW, self.caster )
	ParticleManager:SetParticleControlEnt( self.particleLeader, PATTACH_OVERHEAD_FOLLOW, self.caster, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", self.caster:GetAbsOrigin(), true )
end

function modifier_effect_6:OnDestroy( kv )
	ParticleManager:DestroyParticle(self.particleLeader, true)
    ParticleManager:ReleaseParticleIndex(self.particleLeader)
end
