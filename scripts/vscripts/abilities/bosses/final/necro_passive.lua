LinkLuaModifier("modifier_necro_passive", "abilities/bosses/final/necro_passive.lua", LUA_MODIFIER_MOTION_NONE)

necro_passive = class({})

function necro_passive:GetIntrinsicModifierName()
	return "modifier_necro_passive"
end

----------------------------------------------------------------------------------

modifier_necro_passive = class({})

function modifier_necro_passive:IsHidden()
    return true
end

function modifier_necro_passive:OnCreated()
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.phis = 0
	self.mag = 1
	self:StartIntervalThink(self.interval)
end


function modifier_necro_passive:OnIntervalThink()
if not IsServer() then return end
	self:GetCaster():EmitSound("Hero_Necrolyte.SpiritForm.Cast")
	if self.mag == 1 then
		self.mag = 0
		self.phis = 1
		self:PlayEffects()
		if self.particle2 then
			ParticleManager:DestroyParticle(self.particle2, true)
			ParticleManager:ReleaseParticleIndex(self.particle2)	
		end
	else	
		self.mag = 1
		self.phis = 0
		self:PlayEffects2()
		if self.particle1 then
			ParticleManager:DestroyParticle(self.particle1, true)
			ParticleManager:ReleaseParticleIndex(self.particle1)	
		end
	end
end

function modifier_necro_passive:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	}
	return funcs
end

function modifier_necro_passive:GetAbsoluteNoDamagePhysical()
  return self.phis
end

function modifier_necro_passive:GetAbsoluteNoDamageMagical()
  return self.mag
end

function modifier_necro_passive:PlayEffects()
	self.particle1 = ParticleManager:CreateParticle("particles/nyx_phisical.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle1, 1, Vector(150, 150, 150)) -- Arbitrary
	self:AddParticle(self.particle1, false, false, -1, false, false)
end

function modifier_necro_passive:PlayEffects2()
	self.particle2 = ParticleManager:CreateParticle("particles/nyx_magical.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle2, 1, Vector(150, 150, 150)) -- Arbitrary
	self:AddParticle(self.particle2, false, false, -1, false, false)
end