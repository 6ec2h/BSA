disruptor_teleport = class({})
LinkLuaModifier( "modifier_disruptor_teleport", "heroes/hero_disruptor/disruptor_teleport/disruptor_teleport", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disruptor_aura", "heroes/hero_disruptor/disruptor_teleport/disruptor_teleport", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disruptor_aura_effect", "heroes/hero_disruptor/disruptor_teleport/disruptor_teleport", LUA_MODIFIER_MOTION_NONE )


function disruptor_teleport:GetIntrinsicModifierName()
	return "modifier_disruptor_aura"
end


function disruptor_teleport:GetAOERadius()
	if self:GetCaster():FindAbilityByName("special_bonus_disruptor_agi4")~=nil then
		if self:GetCaster():FindAbilityByName("special_bonus_disruptor_agi4"):GetLevel() > 0 then 
			return self:GetSpecialValueFor("radius")
		end
	end
	return 0
end

function disruptor_teleport:GetBehavior()
	if self:GetCaster():FindAbilityByName("special_bonus_disruptor_agi4")~=nil then
		if self:GetCaster():FindAbilityByName("special_bonus_disruptor_agi4"):GetLevel() > 0 then 
			return  DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
		end
	end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function disruptor_teleport:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local target_point = self:GetCursorPosition()
	self.delay = self:GetSpecialValueFor("delay")
	
	local special_bonus_disruptor_agi4 = self:GetCaster():FindAbilityByName("special_bonus_disruptor_agi4")

	if special_bonus_disruptor_agi4 and special_bonus_disruptor_agi4:GetLevel() > 0 then 
		local radius = self:GetSpecialValueFor("radius")
		
		local units = FindUnitsInRadius(caster:GetTeamNumber(),
		target_point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

		for _,unit in pairs(units) do
			if unit == caster then return end
			unit:AddNewModifier(caster, self, "modifier_disruptor_teleport", {duration = self.delay})
			local sound_cast = "Hero_Disruptor.ThunderStrike.Cast"
			EmitSoundOn( sound_cast, caster )
		end
	else
		if caster ~= target then
			target:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_disruptor_teleport", -- modifier name
				{duration  = self.delay} -- kv
			)

			-- play effects
			local sound_cast = "Hero_Disruptor.ThunderStrike.Cast"
			EmitSoundOn( sound_cast, caster )
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

modifier_disruptor_teleport = class({})

function modifier_disruptor_teleport:GetEffectName()
	return "particles/units/heroes/hero_chen/chen_teleport.vpcf"
end

function modifier_disruptor_teleport:OnCreated()
	self.distance = 100
	
	if not IsServer() then return end
	self:GetParent():EmitSound("Hero_Chen.TeleportLoop")
end

function modifier_disruptor_teleport:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_Chen.TeleportLoop")
	
	-- The full duration has passed, and the teleport has succeeded
	if self:GetRemainingTime() <= 0 then
		local caster_position	= self:GetCaster():GetAbsOrigin()
		
		if self:GetAbility() and self:GetCaster() and self:GetCaster():IsAlive() then
			
			-- If the initial teleport vector for the ability hasn't been set yet, do so now (starts East)
			if not self:GetAbility().teleport_vector then
				self:GetAbility().teleport_vector = Vector(self.distance, 0, 0)
			end
			
			EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Chen.TeleportOut", self:GetCaster())
			
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_POINT, self:GetParent())
			ParticleManager:ReleaseParticleIndex(particle)
			
			local hRelay = Entities:FindByName( nil, "tp_off" )
			if hRelay == nil then return end
			hRelay:Trigger(nil,nil)
	
			-- Teleport the parent to the caster's position + the teleport vector
			--self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin() + self:GetAbility().teleport_vector)
			FindClearSpaceForUnit(self:GetParent(), self:GetCaster():GetAbsOrigin() + self:GetAbility().teleport_vector, true)
			
			EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Chen.TeleportIn", self:GetCaster())
			
			local parent = self:GetParent()
			
			Timers:CreateTimer(FrameTime(), function()
				if parent then
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_POINT, parent)
					ParticleManager:ReleaseParticleIndex(particle)
				end
			end)
			
			-- Send a stop command
			self:GetParent():Stop()
			
			-- Rotate the teleport vector 90 degrees counterclockwise to use for the next unit that gets ported
			self:GetAbility().teleport_vector = RotatePosition(Vector(0, 0, 0), QAngle(0, 90, 0), self:GetAbility().teleport_vector)
		end
	end
end

function modifier_disruptor_teleport:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return decFuncs
end

-- "Damage greater than 0 (before reductions) from any player (including allies, excluding self) or Roshan dispels the effect."
function modifier_disruptor_teleport:OnTakeDamage(keys)
	if not IsServer() then return end
	if keys.unit == self:GetParent() and keys.attacker ~= self:GetParent() and keys.original_damage > 0 then
		self:Destroy()
	end
end


-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


modifier_disruptor_aura = class({})

function modifier_disruptor_aura:IsHidden()
	return true
end

function modifier_disruptor_aura:IsDebuff()
	return false
end

function modifier_disruptor_aura:IsPurgable()
	return false
end

function modifier_disruptor_aura:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_disruptor_aura:GetModifierAura()
	return "modifier_disruptor_aura_effect"
end

function modifier_disruptor_aura:GetAuraRadius()
	return 700
end

function modifier_disruptor_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_disruptor_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

-------------------------------------------------------------------------------------------------------

modifier_disruptor_aura_effect = class({})

function modifier_disruptor_aura_effect:IsHidden()
	return false
end

function modifier_disruptor_aura_effect:IsDebuff()
	return false
end

function modifier_disruptor_aura_effect:IsPurgable()
	return false
end

function modifier_disruptor_aura_effect:OnCreated( kv )
	self.ampl = self:GetAbility():GetSpecialValueFor( "ampl" )
end

function modifier_disruptor_aura_effect:OnRefresh( kv )
	self.ampl = self:GetAbility():GetSpecialValueFor( "ampl" )
end

function modifier_disruptor_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
	return funcs
end

function modifier_disruptor_aura_effect:GetModifierSpellAmplify_Percentage()
	return self.ampl
endturn self.ampl
end