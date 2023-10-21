LinkLuaModifier( "modifier_custom_forest", "abilities/bosses/fura/custom_forest", LUA_MODIFIER_MOTION_NONE )

custom_forest = class({})

function custom_forest:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_forest", { duration = duration } )
end

--------------------------------------------------------------------------

modifier_custom_forest = class({})

function modifier_custom_forest:IsHidden()
	return true
end

function modifier_custom_forest:IsPurgable()
	return false
end

function modifier_custom_forest:OnCreated( kv )
	local delay = self:GetAbility():GetSpecialValueFor("delay")
	self:StartIntervalThink(delay)
end

function modifier_custom_forest:OnIntervalThink()
	if not IsServer() then return end
	EmitSoundOn( "Hero_Leshrac.Split_Earth", self:GetCaster() )
	local range = self:GetAbility():GetSpecialValueFor("range")
	local delay = self:GetAbility():GetSpecialValueFor("delay")
	local damage = self:GetAbility():GetSpecialValueFor("damage")
	local damage_radius = self:GetAbility():GetSpecialValueFor("damage_radius")
	local particle_pre = "particles/econ/events/ti10/mekanism_ti10_ground_dark.vpcf"
	local particle = "particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_cast.vpcf"
	local angle = RandomInt(0, 360)
	local variance = RandomInt(-range, range)
	local dy = math.sin(angle) * variance
	local dx = math.cos(angle) * variance
	local target_pos = Vector(self:GetCaster():GetAbsOrigin().x + dx, self:GetCaster():GetAbsOrigin().y + dy, self:GetCaster():GetAbsOrigin().z)
	local dummy = CreateUnitByName("npc_dummy_unit", target_pos, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	dummy:AddNewModifier(self:GetCaster(), nil, "modifier_kill", { duration = 0.03 } )
	local particleIndexPre = ParticleManager:CreateParticle(particle_pre, PATTACH_ABSORIGIN, dummy)
	Timers:CreateTimer(delay, function()
		ParticleManager:DestroyParticle( particleIndexPre, false )
		local particleIndex = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, dummy)
		local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, target_pos, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
			for k, unit in ipairs(units) do
				local damage_table = {
										attacker = self:GetCaster(),
										victim = unit,
										ability = self:GetAbility(),
										damage_type = self:GetAbility():GetAbilityDamageType(),
										damage = damage
									}
				ApplyDamage(damage_table)
			end
		return nil
	end)
end