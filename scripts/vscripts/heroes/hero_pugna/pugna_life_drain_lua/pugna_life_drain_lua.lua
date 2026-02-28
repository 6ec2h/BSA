pugna_life_drain_lua = class({})
LinkLuaModifier("modifier_pugna_life_drain_lua", "heroes/hero_pugna/pugna_life_drain_lua/pugna_life_drain_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pugna_life_drain_lua_self", "heroes/hero_pugna/pugna_life_drain_lua/pugna_life_drain_lua", LUA_MODIFIER_MOTION_NONE)

function pugna_life_drain_lua:GetAbilityTextureName()
	return "pugna_life_drain"
end

function pugna_life_drain_lua:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function pugna_life_drain_lua:IsHiddenWhenStolen()
	return false
end

function pugna_life_drain_lua:GetAssociatedPrimaryAbilities()
	return "pugna_life_drain_lua_end"
end

function pugna_life_drain_lua:OnChannelFinish( bInterrupted )
	self:GetCaster():RemoveModifierByName("modifier_pugna_life_drain_lua_self")
end

function pugna_life_drain_lua:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local sound_cast = "Hero_Pugna.LifeDrain.Cast"
	self.modifier_lifedrain = "modifier_pugna_life_drain_lua"

	EmitSoundOn(sound_cast, caster)

	if caster:GetTeamNumber() ~= target:GetTeamNumber() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	caster:AddNewModifier(caster, ability, "modifier_pugna_life_drain_lua_self", {})
	target:AddNewModifier(caster, ability, self.modifier_lifedrain, {})
end

------------------------------------------------------------------

modifier_pugna_life_drain_lua_self = class({})

function modifier_pugna_life_drain_lua_self:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_pugna_life_drain_lua_self:IsHidden()
	return true
end

function modifier_pugna_life_drain_lua_self:IsPurgable()
	return false
end

-----------------------------------------------------------------

modifier_pugna_life_drain_lua = class({})

function modifier_pugna_life_drain_lua:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_pugna_life_drain_lua:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_target = "Hero_Pugna.LifeDrain.Target"
	self.sound_loop = "Hero_Pugna.LifeDrain.Loop"
	self.particle_drain = "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf"
	self.particle_give = "particles/units/heroes/hero_pugna/pugna_life_give.vpcf"

	self.health_drain = self.ability:GetSpecialValueFor("health_drain")
	self.base_slow_pct = self.ability:GetSpecialValueFor("base_slow_pct")
	self.tick_rate = self.ability:GetSpecialValueFor("tick_rate")
	self.break_distance_extend = self.ability:GetSpecialValueFor("break_distance_extend")

	if self.parent:GetTeamNumber() == self.caster:GetTeamNumber() then
		self.is_ally = true
	else
		self.is_ally = false
	end

	if IsServer() then
		EmitSoundOn(self.sound_target, self.parent)

		StopSoundOn(self.sound_loop, self.parent)
		EmitSoundOn(self.sound_loop, self.parent)
	
		if self.is_ally then
			self.particle_drain_fx = ParticleManager:CreateParticle(self.particle_give, PATTACH_ABSORIGIN, self.caster)
			ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		else
			self.particle_drain_fx = ParticleManager:CreateParticle(self.particle_drain, PATTACH_ABSORIGIN, self.caster)
			ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		end

		Timers:CreateTimer(self.tick_rate, function()
			self:StartIntervalThink(self.tick_rate)
		end)
	else
		self:StartIntervalThink(self.tick_rate)
	end
end

function modifier_pugna_life_drain_lua:OnIntervalThink()
if self.caster:HasModifier("modifier_pugna_life_drain_lua_self") then

	if IsServer() then
		if self.parent:IsIllusion() and self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber() and not Custom_bIsStrongIllusion(self.parent) then
			self.parent:Kill(self.ability, self.caster)
			return nil
		end

		if self.caster:IsStunned() or self.caster:IsSilenced() then
			self:Destroy()
		end

		if self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber() and self.parent:IsInvisible() then
			self:Destroy()
		end

		if not self.caster:CanEntityBeSeenByMyTeam(self.parent) or self.parent:IsInvulnerable() or self.parent:IsMagicImmune() then
			self:Destroy()
		end

		local cast_range = self.ability:GetCastRange(self.caster:GetAbsOrigin(), self.parent)
		local distance = (self.parent:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()

	
		if distance > (cast_range + self.break_distance_extend) then
			self:Destroy()
		end
	
		if not self.caster:IsAlive() then
			self:Destroy()
		end

		local damage = self.health_drain * self.tick_rate

		if self.is_ally then
			local damageTable = {victim = self.caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				attacker = self.caster,
				ability = self.ability
			}

			local actual_damage = ApplyDamage(damageTable)

			local missing_health = self.parent:GetMaxHealth() - self.parent:GetHealth()

			self.parent:Heal(actual_damage, self.caster)

			if missing_health < actual_damage then
				local recover_mana = actual_damage - missing_health
				self.parent:GiveMana(recover_mana)
			end
		else
			local damageTable = {victim = self.parent,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				attacker = self.caster,
				ability = self.ability
			}

			local actual_damage = ApplyDamage(damageTable)

			local missing_health = self.caster:GetMaxHealth() - self.caster:GetHealth()
			
			self.caster:Heal(actual_damage, self.caster)

			if missing_health < actual_damage then
				local recover_mana = actual_damage - missing_health
				self.caster:GiveMana(recover_mana)
			end
		end
	end

	if not self.is_ally then
		self.base_slow_pct = self.base_slow_pct
	end
	else
	self:Destroy()
	end
end

function modifier_pugna_life_drain_lua:CheckState()
	if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		return {
			[MODIFIER_STATE_PROVIDES_VISION]	= true,
			[MODIFIER_STATE_INVISIBLE]			= false
		}
	end
end

function modifier_pugna_life_drain_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end


function modifier_pugna_life_drain_lua:GetModifierMoveSpeedBonus_Percentage()
	if self.is_ally then
		return nil
	end

	return self.base_slow_pct * (-1)
end

function modifier_pugna_life_drain_lua:IsHidden() return true end
function modifier_pugna_life_drain_lua:IsPurgable() return false end
function modifier_pugna_life_drain_lua:IsDebuff()
	if self.is_ally then
		return false
	else
		return true
	end
end

function modifier_pugna_life_drain_lua:OnDestroy()
	if not IsServer() then return end
	self.caster:RemoveModifierByName("modifier_pugna_life_drain_lua_self")
	
	
	ParticleManager:DestroyParticle(self.particle_drain_fx, false)
	ParticleManager:ReleaseParticleIndex(self.particle_drain_fx)

	StopSoundOn(self.sound_target, self.parent)
	StopSoundOn(self.sound_loop, self.parent)
end