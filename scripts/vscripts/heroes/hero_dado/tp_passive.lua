LinkLuaModifier( "modifier_tp_passive", "heroes/hero_dado/tp_passive", LUA_MODIFIER_MOTION_NONE )

dado_tp_passive = class({})

function dado_tp_passive:GetIntrinsicModifierName()
	return "modifier_tp_passive"
end

-------------------------------------------------------------------------------

modifier_tp_passive = class({})

function modifier_tp_passive:IsHidden()
	return false
end

function modifier_tp_passive:IsPurgable()
    return false
end

function modifier_tp_passive:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = false,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ROOTED]	= true,
		[MODIFIER_STATE_DISARMED] = true,	
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
	return state
end

function modifier_tp_passive:OnCreated( kv )
	local target = self:GetParent()
	if target:GetUnitName() ~= 'tp_out' then
		self.particle_name = "particles/portal_in.vpcf"
	else
		self.particle_name = "particles/portal_out.vpcf"
	end
	self.particle_willful_fx = ParticleManager:CreateParticle(self.particle_name, PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(self.particle_willful_fx, 0, Vector(0, 2, 400))
	ParticleManager:SetParticleControlEnt(self.particle_willful_fx, 3, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(self.particle_willful_fx)
end

function modifier_tp_passive:OnRemoved()
if IsServer() then
    ParticleManager:DestroyParticle(self.particle_willful_fx, false)
	ParticleManager:ReleaseParticleIndex(self.particle_willful_fx)
	end
end