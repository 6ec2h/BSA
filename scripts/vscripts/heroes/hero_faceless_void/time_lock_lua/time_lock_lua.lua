LinkLuaModifier("modifier_time_lock_lua", "heroes/hero_faceless_void/time_lock_lua/time_lock_lua", LUA_MODIFIER_MOTION_NONE)

time_lock_lua = class({})

function time_lock_lua:GetIntrinsicModifierName()
	return "modifier_time_lock_lua"
end

-------------------------------------------------------------------------

modifier_time_lock_lua = class({})

function modifier_time_lock_lua:IsHidden()
	return true
end

function modifier_time_lock_lua:IsPurgable()
	return false
end

function modifier_time_lock_lua:RemoveOnDeath()
	return false
end

function modifier_time_lock_lua:OnCreated( kv )
	self.caster = self:GetCaster()
end

function modifier_time_lock_lua:OnRefresh( kv )
end

function modifier_time_lock_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_time_lock_lua:OnAttackLanded(event)
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local attacker = event.attacker
	local target = event.target

	if not attacker or attacker:IsNull() then return end
	if attacker ~= parent then return end
	if parent:PassivesDisabled() or parent:IsIllusion() then return end
	if not target or target:IsNull() then return end
	if target:IsTower() or target:IsBarracks() or target:IsBuilding() or target:IsOther() or target:IsInvulnerable() then return end

	local chance = ability:GetSpecialValueFor("chance")
	
	local talent = parent:FindAbilityByName("special_bonus_faceless_void_1")
	if talent and talent:GetLevel() > 0 then
		chance = chance + 15
	end

	if RandomInt(1, 100) <= chance then
		self:ApplyTimeLock(ability, target)
		self.c = 0
	end	
end


function modifier_time_lock_lua:ApplyTimeLock(ability, target)
	if not ability then ability = self:GetAbility() end
	if not target then return end
	local parent = self:GetParent()
	local duration = ability:GetSpecialValueFor("duration")

	target:AddNewModifier(parent, ability, "modifier_stunned", {duration = duration})
	target:EmitSound("Hero_FacelessVoid.TimeLockImpact")
	
	local damage = ability:GetSpecialValueFor("damage")

	local damage_table = {}
	damage_table.attacker = parent
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.damage = damage
	damage_table.victim = target

	ApplyDamage(damage_table)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin() )
	ParticleManager:SetParticleControlEnt(particle, 2, parent, PATTACH_CUSTOMORIGIN, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)

	Timers:CreateTimer(0.3, function()
		if target:IsAlive() and not target:IsNull() and self.c == 0 then
			parent:PerformAttack(target, false, true, true, false, false, false, false)
			target:EmitSound("Hero_FacelessVoid.TimeLockImpact")
			self.c = 1
		end
	end)
end