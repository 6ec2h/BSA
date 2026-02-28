LinkLuaModifier("modifier_time_walk_lua", "heroes/hero_faceless_void/time_walk_lua/time_walk_lua", LUA_MODIFIER_MOTION_NONE)

time_walk_lua = class({})

function time_walk_lua:GetIntrinsicModifierName()
	return "modifier_time_walk_lua"
end

function time_walk_lua:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_FacelessVoid.TimeWalk")
	self:remove_damage()
	
	
	local talent = caster:FindAbilityByName("special_bonus_faceless_void_3")
	local ability = caster:FindAbilityByName("time_lock_lua")
	if talent and talent:GetLevel() > 0 then
		 local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
		 for _, enemy in pairs(enemies) do
			if enemy and not enemy:IsNull() and not enemy:IsMagicImmune() and not enemy:IsAttackImmune() and not enemy:IsInvulnerable() and not caster:IsDisarmed() then
				self.c = 0
				time_walk_lua:ApplyTimeLock(ability, enemy, caster)
			end
		end
	end
end

function time_walk_lua:ApplyTimeLock(ability, target, caster)
	if not target then return end
	local duration = ability:GetSpecialValueFor("duration")

	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = duration})
	target:EmitSound("Hero_FacelessVoid.TimeLockImpact")
	
	local damage = ability:GetSpecialValueFor("damage")

	local talent = caster:FindAbilityByName("special_bonus_faceless_void_1")
	if talent and talent:GetLevel() > 0 then
		damage = damage + 40
	end

	local damage_table = {}
	damage_table.attacker = caster
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.damage = damage
	damage_table.victim = target

	ApplyDamage(damage_table)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin() )
	ParticleManager:SetParticleControlEnt(particle, 2, caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)

	Timers:CreateTimer(0.3, function()
		if target:IsAlive() and not target:IsNull() and self.c == 0 then
			caster:PerformAttack(target, false, true, true, false, false, false, false)
			target:EmitSound("Hero_FacelessVoid.TimeLockImpact")
			self.c = 1
		end
	end)
end

function time_walk_lua:remove_damage(keys)
	local caster = self:GetCaster()
	local ability = self
	local damage_sum = 0
	local caster_index = 0
	
	while ability.caster_damage do
		if ability.caster_damage[caster_index] == nil then
		break
		elseif Time() - ability.caster_damage[caster_index+1] <= 2 then
			damage_sum = damage_sum + ability.caster_damage[caster_index]
		end
		caster_index = caster_index + 2
	end
	
	caster:SetHealth(caster:GetHealth() + damage_sum)
end

-------------------------------------------------------------------------

modifier_time_walk_lua = class({})

function modifier_time_walk_lua:OnCreated()
end

function modifier_time_walk_lua:IsHidden()
	return true
end

function modifier_time_walk_lua:IsPurgable()
	return false
end

function modifier_time_walk_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_time_walk_lua:OnTakeDamage(keys)
	if keys.unit == self:GetParent() then
	local temp = {}
	local temp_index = 0
	local caster_index = 0
	local ability = self:GetAbility()
	if ability.caster_damage == nil then
		ability.caster_damage = {}
	end
	
	while ability.caster_damage do
		if ability.caster_damage[caster_index] == nil then
		break
		elseif Time() - ability.caster_damage[caster_index+1] <= 2 then
			temp[temp_index] = ability.caster_damage[caster_index]
			temp[temp_index+1] = ability.caster_damage[caster_index+1]
			temp_index = temp_index + 2
		end
		caster_index = caster_index + 2
	end
	
	temp[temp_index] = keys.damage
	temp[temp_index+1] = Time()
	
	ability.caster_damage = temp
	end
end