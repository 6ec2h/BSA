LinkLuaModifier("modifier_creep_rocket_barrage", "abilities/creeps/creep_rocket_barrage", LUA_MODIFIER_MOTION_NONE)

creep_rocket_barrage = class({})

function creep_rocket_barrage:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Gyrocopter.Rocket_Barrage")
	if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" and RollPercentage(75) then
		if not self.responses then
			self.responses = 
			{
				"gyrocopter_gyro_rocket_barrage_01",
				"gyrocopter_gyro_rocket_barrage_02",
				"gyrocopter_gyro_rocket_barrage_04",
			}
		end
		EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
	end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creep_rocket_barrage", {duration = self:GetDuration()})
end

-------------------------------------------------------------------------------------------------------------------------------

modifier_creep_rocket_barrage = class({})

function modifier_creep_rocket_barrage:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.radius	= self:GetAbility():GetSpecialValueFor("radius")
	self.rockets_per_second	= self:GetAbility():GetSpecialValueFor("rockets_per_second")
	self.ballistic_duration	= self:GetAbility():GetSpecialValueFor("ballistic_duration")
	self.sniping_speed		= self:GetAbility():GetSpecialValueFor("sniping_speed")
	self.sniping_distance	= self:GetAbility():GetSpecialValueFor("sniping_distance")
	
	if not IsServer() then return end
	
	self.rocket_damage	= self:GetAbility():GetSpecialValueFor("rocket_damage")
	self.damage_type	= self:GetAbility():GetAbilityDamageType()
	
	self.weapons = {"attach_attack1", "attach_attack2"}
	
	self:StartIntervalThink(1 / self.rockets_per_second)
end

function modifier_creep_rocket_barrage:OnRefresh()
	self:OnCreated()
end

function modifier_creep_rocket_barrage:OnIntervalThink()
	if not self:GetParent():IsOutOfGame() then
		self:GetParent():EmitSound("Hero_Gyrocopter.Rocket_Barrage.Launch")
		self.enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		if #self.enemies >= 1 then
			for _, enemy in pairs(self.enemies) do
				enemy:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Impact")
				
				self.barrage_particle	= ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_rocket_barrage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
				ParticleManager:SetParticleControlEnt(self.barrage_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, self.weapons[RandomInt(1, #self.weapons)], self:GetParent():GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.barrage_particle, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(self.barrage_particle)
				
				ApplyDamage({
					victim 			= enemy,
					damage 			= self.rocket_damage,
					damage_type		= self.damage_type,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetCaster(),
					ability 		= self:GetAbility()
				})
				break
			end
		end
	end
end

function modifier_creep_rocket_barrage:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_creep_rocket_barrage:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_1
end