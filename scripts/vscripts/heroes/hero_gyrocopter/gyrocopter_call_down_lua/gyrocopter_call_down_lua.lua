LinkLuaModifier("modifier_gyrocopter_call_down_lua_thinker", "heroes/hero_gyrocopter/gyrocopter_call_down_lua/gyrocopter_call_down_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gyrocopter_call_down_lua_slow", "heroes/hero_gyrocopter/gyrocopter_call_down_lua/gyrocopter_call_down_lua", LUA_MODIFIER_MOTION_NONE)

gyrocopter_call_down_lua							= gyrocopter_call_down_lua or class({})
modifier_gyrocopter_call_down_lua_thinker			= modifier_gyrocopter_call_down_lua_thinker or class({})
modifier_gyrocopter_call_down_lua_slow				= modifier_gyrocopter_call_down_lua_slow or class({})

function gyrocopter_call_down_lua:GetCastRange(location, target)
	if IsClient() then
		return self.BaseClass.GetCastRange(self, location, target)
	end
end

function gyrocopter_call_down_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("special_bonus_gyrocopter_agi4")~=nil then
		if self:GetCaster():FindAbilityByName("special_bonus_gyrocopter_agi4"):GetLevel() > 0 then 
			return self.BaseClass.GetCooldown(self, level) - 30
		end
	end
	return self.BaseClass.GetCooldown(self, level)
end

function gyrocopter_call_down_lua:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function gyrocopter_call_down_lua:OnAbilityPhaseStart()
	self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
	
	return true
end

function gyrocopter_call_down_lua:OnAbilityPhaseInterrupted()
	self:GetCaster():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
end

function gyrocopter_call_down_lua:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Gyrocopter.CallDown.Fire")
	-- self:GetCaster():EmitSound("Hero_Gyrocopter.CallDown.Fire.Self") -- This one has a volume_falloff_max so IDK which one to use

	if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" then
		if not self.responses then
			self.responses = 
			{
				"gyrocopter_gyro_call_down_03",
				"gyrocopter_gyro_call_down_04",
				"gyrocopter_gyro_call_down_05",
				"gyrocopter_gyro_call_down_06",
				"gyrocopter_gyro_call_down_09"
			}
		end
		
		EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
	end

	CreateModifierThinker(self:GetCaster(), self, "modifier_gyrocopter_call_down_lua_thinker", {duration = self:GetSpecialValueFor("missile_delay_tooltip") * 2}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
end

------------------------------------------------
-- MODIFIER_gyrocopter_call_down_lua_THINKER --
------------------------------------------------

function modifier_gyrocopter_call_down_lua_thinker:OnCreated()
	self.slow_duration_first	= self:GetAbility():GetSpecialValueFor("slow_duration_first")
	self.slow_duration_second	= self:GetAbility():GetSpecialValueFor("slow_duration_second")
	self.damage_first			= self:GetAbility():GetSpecialValueFor("damage_first")
	self.damage_second			= self:GetAbility():GetSpecialValueFor("damage_second")
	self.slow_first				= self:GetAbility():GetSpecialValueFor("slow_first")
	self.slow_second			= self:GetAbility():GetSpecialValueFor("slow_second")
	self.radius					= self:GetAbility():GetSpecialValueFor("radius")
	self.missile_delay_tooltip	= self:GetAbility():GetSpecialValueFor("missile_delay_tooltip")
	self.cast_range_standard	= self:GetAbility():GetSpecialValueFor("cast_range_standard")
	
	if not IsServer() then return end
	
	self.damage_type			= self:GetAbility():GetAbilityDamageType()
	
	self.first_missile_impact	= false
	self.second_missile_impact	= false
	
	if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= self.cast_range_standard or self:GetCaster():GetLevel() >= 25 then
		self.marker_particle		= ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber())
	else
		self.marker_particle		= ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.marker_particle, 0, self:GetParent():GetAbsOrigin())
	end
	
	-- if self:GetCaster():HasAbility("imba_gyrocopter_homing_missile") and self:GetCaster():FindAbilityByName("imba_gyrocopter_homing_missile").lock_on_modifier and
	-- (self:GetCaster():FindAbilityByName("imba_gyrocopter_homing_missile").lock_on_modifier:GetParent():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self.radius then
		-- self.radius	= self.radius * 2
	-- end
	
	ParticleManager:SetParticleControl(self.marker_particle, 1, Vector(self.radius, 1, self.radius * (-1)))
	self:AddParticle(self.marker_particle, false, false, -1, false, false)
	
	local calldown_first_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_first.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(calldown_first_particle, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket1")))
	ParticleManager:SetParticleControl(calldown_first_particle, 1, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(calldown_first_particle, 5, Vector(self.radius, self.radius, self.radius))
	ParticleManager:ReleaseParticleIndex(calldown_first_particle)
	
	local calldown_second_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_second.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(calldown_second_particle, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket2")))
	ParticleManager:SetParticleControl(calldown_second_particle, 1, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(calldown_second_particle, 5, Vector(self.radius, self.radius, self.radius))
	ParticleManager:ReleaseParticleIndex(calldown_second_particle)
	
	self:StartIntervalThink(self.missile_delay_tooltip)
end

function modifier_gyrocopter_call_down_lua_thinker:OnIntervalThink()
	EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Gyrocopter.CallDown.Damage", self:GetCaster())
	
	if not self.first_missile_impact then
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_gyrocopter_call_down_lua_slow", {duration = self.slow_duration_first * (1 - enemy:GetStatusResistance()), slow = self.slow_first})
			
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.damage_first,
				damage_type		= self.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
			
			if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" and (enemy:IsRealHero() or enemy:IsClone()) and not enemy:IsAlive() then
				EmitSoundOnClient("gyrocopter_gyro_call_down_1"..RandomInt(1, 2), self:GetCaster():GetPlayerOwner())
			end
		end
		
		self.first_missile_impact = true
	elseif not self.second_missile_impact then
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_gyrocopter_call_down_lua_slow", {duration = self.slow_duration_second * (1 - enemy:GetStatusResistance()), slow = self.slow_second})
			
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.damage_second,
				damage_type		= self.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
			
			if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" and (enemy:IsRealHero() or enemy:IsClone()) and not enemy:IsAlive() then
				EmitSoundOnClient("gyrocopter_gyro_call_down_1"..RandomInt(1, 2), self:GetCaster():GetPlayerOwner())
			end
		end
	
		self.second_missile_impact = true
	end
end

---------------------------------------------
-- MODIFIER_gyrocopter_call_down_lua_SLOW --
---------------------------------------------

function modifier_gyrocopter_call_down_lua_slow:OnCreated(keys)
	if keys and keys.slow then
		self:SetStackCount(keys.slow * (-1))
	end
end

function modifier_gyrocopter_call_down_lua_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_gyrocopter_call_down_lua_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end