treant_overgrowth = treant_overgrowth or class({})
modifier_treant_overgrowth = modifier_treant_overgrowth or class({})

LinkLuaModifier("modifier_treant_overgrowth", "abilities/creeps/creep_overgrowth", LUA_MODIFIER_MOTION_NONE)

function treant_overgrowth:GetCastRange(location, target)
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

function treant_overgrowth:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Treant.Overgrowth.CastAnim")
	return true
end

function treant_overgrowth:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Treant.Overgrowth.Cast")

	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(cast_particle)
	
	local overgrowth_primary_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)

	for _, enemy in pairs(overgrowth_primary_enemies) do
		enemy:Stop()
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_treant_overgrowth", {duration = self:GetSpecialValueFor("duration") * (1 - enemy:GetStatusResistance())})
	end
end

-------------------------------------
function modifier_treant_overgrowth:GetEffectName()
	return "particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf"
end

function modifier_treant_overgrowth:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.damage	= self:GetAbility():GetSpecialValueFor("damage")
	
	if not IsServer() then return end
	
	self.damage_type	= self:GetAbility():GetAbilityDamageType()
	
	self:StartIntervalThink(1 - self:GetParent():GetStatusResistance())
end

function modifier_treant_overgrowth:OnIntervalThink()
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.damage,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
end

function modifier_treant_overgrowth:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVISIBLE] = false
	}
end