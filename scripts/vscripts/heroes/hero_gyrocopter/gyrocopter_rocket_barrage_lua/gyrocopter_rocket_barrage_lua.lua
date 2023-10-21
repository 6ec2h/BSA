LinkLuaModifier("modifier_gyrocopter_rocket_barrage_lua", "heroes/hero_gyrocopter/gyrocopter_rocket_barrage_lua/gyrocopter_rocket_barrage_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gyrocopter_rocket_barrage_lua_ballistic_suppression", "heroes/hero_gyrocopter/gyrocopter_rocket_barrage_lua/gyrocopter_rocket_barrage_lua", LUA_MODIFIER_MOTION_NONE)

gyrocopter_rocket_barrage_lua = gyrocopter_rocket_barrage_lua or class({})
modifier_gyrocopter_rocket_barrage_lua = modifier_gyrocopter_rocket_barrage_lua or class({})
modifier_gyrocopter_rocket_barrage_lua_ballistic_suppression = modifier_gyrocopter_rocket_barrage_lua_ballistic_suppression or class({})

function gyrocopter_rocket_barrage_lua:OnSpellStart()
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
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_gyrocopter_rocket_barrage_lua", {duration = self:GetDuration()})
end

function gyrocopter_rocket_barrage_lua:OnProjectileHit(target, location)
	if target then
		target:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Impact")
	
		if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_agi1")~=nil then
			if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_agi1"):GetLevel() > 0 then 
				target:AddNewModifier(self:GetCaster(), self, "modifier_gyrocopter_rocket_barrage_lua_ballistic_suppression", {duration = self:GetSpecialValueFor("ballistic_duration") * (1 - target:GetStatusResistance())})
			end
		end
		
		ApplyDamage({
			victim 			= target,
			damage 			= self:GetSpecialValueFor("rocket_damage"),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		})
		
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

function modifier_gyrocopter_rocket_barrage_lua:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.radius	= self:GetAbility():GetSpecialValueFor("radius")
	self.rockets_per_second	= self:GetAbility():GetSpecialValueFor("rockets_per_second")
	self.ballistic_duration	= self:GetAbility():GetSpecialValueFor("ballistic_duration")
	self.sniping_speed		= self:GetAbility():GetSpecialValueFor("sniping_speed")
	self.sniping_distance	= self:GetAbility():GetSpecialValueFor("sniping_distance")
	
	if not IsServer() then return end
	
	self.rocket_damage	= self:GetAbility():GetSpecialValueFor("rocket_damage")
	self.damage_type	= self:GetAbility():GetAbilityDamageType()
	
	self.weapons		= {"attach_attack1", "attach_attack2"}
	
	self:StartIntervalThink(1 / self.rockets_per_second)
end

function modifier_gyrocopter_rocket_barrage_lua:OnRefresh()
	self:OnCreated()
end

function modifier_gyrocopter_rocket_barrage_lua:OnIntervalThink()
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
					
					if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_agi1"):GetLevel() > 0 then 
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_gyrocopter_rocket_barrage_lua_ballistic_suppression", {duration = self.ballistic_duration * (1 - enemy:GetStatusResistance())})
					end
					
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
			else
				ProjectileManager:CreateLinearProjectile({
					EffectName	= "particles/base_attacks/ranged_tower_bad_linear.vpcf",
					Ability		= self:GetAbility(),
					Source		= self:GetCaster(),
					vSpawnOrigin	= self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_hitloc")),
					vVelocity	= self:GetParent():GetForwardVector() * self.sniping_speed * Vector(1, 1, 0),
					vAcceleration	= nil, --hmm...
					fMaxSpeed	= nil, -- What's the default on this thing?
					fDistance	= self.sniping_distance,
					fStartRadius	= 25,
					fEndRadius		= 25,
					fExpireTime		= nil,
					iUnitTargetTeam	= DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					bIgnoreSource		= true,
					bHasFrontalCone		= false,
					bDrawsOnMinimap		= false,
					bVisibleToEnemies	= true,
					bProvidesVision		= false,
					iVisionRadius		= nil,
					iVisionTeamNumber	= nil,
					ExtraData			= {}
				})
		end
	end
end

function modifier_gyrocopter_rocket_barrage_lua:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_gyrocopter_rocket_barrage_lua:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_1
end

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

function modifier_gyrocopter_rocket_barrage_lua_ballistic_suppression:OnCreated()
	if not IsServer() then return end
	self:IncrementStackCount()
end

function modifier_gyrocopter_rocket_barrage_lua_ballistic_suppression:OnRefresh()
	self:OnCreated()
end

function modifier_gyrocopter_rocket_barrage_lua_ballistic_suppression:DeclareFunctions()
	return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end

function modifier_gyrocopter_rocket_barrage_lua_ballistic_suppression:GetModifierMagicalResistanceBonus()
	return self:GetStackCount() * (-1)
end
