LinkLuaModifier("modifier_cast_keeper", "abilities/creeps/cast_keeper", LUA_MODIFIER_MOTION_NONE)

cast_keeper = cast_keeper or class({})


function cast_keeper:Precache( context )
	PrecacheResource( "particle", "particles/items2_fx/veil_of_discord.vpcf", context )
	PrecacheResource( "particle", "particles/nyx_phisical.vpcf", context )
	PrecacheResource( "particle", "particles/nyx_magical.vpcf", context )
end

function cast_keeper:OnSpellStart()
	local caster = self:GetCaster()
	local target_loc = self:GetCursorPosition()
	caster:EmitSound("DOTA_Item.VeilofDiscord.Activate")

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_cast_keeper", {duration = 6})
	end
end

----------------------------------------------------------------------------------------------------------------------------------

modifier_cast_keeper = class({})

function modifier_cast_keeper:IsHidden()
    return true
end

function modifier_cast_keeper:OnCreated()
	self.phis = 0
	self.mag = 1
	self:StartIntervalThink(2)
end


function modifier_cast_keeper:OnIntervalThink()
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

function modifier_cast_keeper:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	}
	return funcs
end

function modifier_cast_keeper:GetAbsoluteNoDamagePhysical()
  return self.phis
end

function modifier_cast_keeper:GetAbsoluteNoDamageMagical()
  return self.mag
end

function modifier_cast_keeper:PlayEffects()
	self.particle1 = ParticleManager:CreateParticle("particles/nyx_phisical.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle1, 1, Vector(150, 150, 150)) -- Arbitrary
	self:AddParticle(self.particle1, false, false, -1, false, false)
end

function modifier_cast_keeper:PlayEffects2()
	self.particle2 = ParticleManager:CreateParticle("particles/nyx_magical.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle2, 1, Vector(150, 150, 150)) -- Arbitrary
	self:AddParticle(self.particle2, false, false, -1, false, false)
end