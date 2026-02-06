LinkLuaModifier("modifier_fatal_bonds", "abilities/fatal_bonds", LUA_MODIFIER_MOTION_NONE)

fatal_bonds = class({})

function fatal_bonds:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_warlock/warlock_fatal_bonds_icon.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_warlock/warlock_fatal_bonds_pulse.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_warlock/warlock_fatal_bonds_hit.vpcf", context)
end

function fatal_bonds:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:EmitSound("Hero_Warlock.FatalBonds")

	local nearbyUnits = FindUnitsInRadius(
		caster:GetTeamNumber(),
		target:GetAbsOrigin(),
		nil,
		self:GetSpecialValueFor("search_aoe"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NO_INVIS,
		FIND_ANY_ORDER,
		false
	)

	local duration = self:GetSpecialValueFor("duration")

	for i = 1, #nearbyUnits do
		local unit = nearbyUnits[i]

		unit.__fatalBondsTargets = nearbyUnits
		local modifier = unit:AddNewModifier(caster, self, "modifier_fatal_bonds", {
			duration = duration,
		})

		for _i = 1, #nearbyUnits do
			local _unit = nearbyUnits[i]

			local particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_fatal_bonds_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControlEnt(particleId, 1, _unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
			Timers:CreateTimer(0.4, function()
				ParticleManager:DestroyParticle(particleId, true)
				ParticleManager:ReleaseParticleIndex(particleId)
			end)
		end
	end
end

modifier_fatal_bonds = class({})

function modifier_fatal_bonds:GetTexture() return "warlock_fatal_bonds" end

function modifier_fatal_bonds:IsHidden() return false end
function modifier_fatal_bonds:IsPurgable() return true end
function modifier_fatal_bonds:RemoveOnDeath() return true end

function modifier_fatal_bonds:GetEffectName()
	return "particles/units/heroes/hero_warlock/warlock_fatal_bonds_icon.vpcf"
end

function modifier_fatal_bonds:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_fatal_bonds:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_fatal_bonds:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_fatal_bonds:OnCreated(keys)
	if IsClient() then
		self.damageSharePct = self:GetAbility():GetSpecialValueFor("damage_share_pct")
	end

	if IsServer() then
		self.ability = self:GetAbility()
		self.caster = self.ability:GetCaster()

		local parent = self:GetParent()

		parent.__fatalBondsAccumulatedDamageNextTime = parent.__fatalBondsAccumulatedDamageNextTime or 0

		self.targets = parent.__fatalBondsTargets
		parent.__fatalBondsTargets = nil

		parent.__fatalBondsTargetsDamage = parent.__fatalBondsTargetsDamage or {}

		for i = 1, #self.targets do
			local unit = self.targets[i]

			parent.__fatalBondsTargetsDamage[unit] = parent.__fatalBondsTargetsDamage[unit] or 0
		end
		
		self.damageShare = self.ability:GetSpecialValueFor("damage_share_pct") / 100

		self.accumulateDamageTimeMin = self.ability:GetSpecialValueFor("accumulate_damage_time_min")
		self.accumulateDamageTimeMax = self.ability:GetSpecialValueFor("accumulate_damage_time_max")
	end
end

if IsServer() then
	function modifier_fatal_bonds:OnDeath(keys)
		local target = self:GetParent()
		if target ~= keys.unit then return end

		for i = 1, #self.targets do
			if self.targets[i] == target then
				table.remove(self.targets, i)
				break
			end
		end
	end

	function modifier_fatal_bonds:OnDestroy()
		local parent = self:GetParent()

		if parent:HasModifier("modifier_fatal_bonds") then return end

		parent.__fatalBondsAccumulatedDamageNextTime = nil
		parent.__fatalBondsTargetsDamage = nil
	end

	function modifier_fatal_bonds:OnTakeDamage(keys)
		local parent = self:GetParent()
		if parent ~= keys.unit then return end
		
		if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

		local damage = keys.damage * self.damageShare

		local curTime = GameRules:GetGameTime()

		if curTime < parent.__fatalBondsAccumulatedDamageNextTime then
			for i = 1, #self.targets do
				local unit = self.targets[i]
				if IsValidEntity(unit) and unit ~= parent then
					parent.__fatalBondsTargetsDamage[unit] = parent.__fatalBondsTargetsDamage[unit] + damage
				end
			end
		else
			parent:EmitSound("Hero_Warlock.FatalBondsDamage")

			parent.__fatalBondsAccumulatedDamageNextTime = curTime + RandomFloat(self.accumulateDamageTimeMin, self.accumulateDamageTimeMax)
			
			for i = 1, #self.targets do
				local unit = self.targets[i]
				if IsValidEntity(unit) and unit ~= parent then
					local particleId = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_fatal_bonds_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
					ParticleManager:SetParticleControlEnt(particleId, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
					Timers:CreateTimer(0.4, function()
						ParticleManager:DestroyParticle(particleId, true)
						ParticleManager:ReleaseParticleIndex(particleId)
					end)
					
					unit:EmitSound("Hero_Warlock.FatalBondsDamage")

					ApplyDamage({
						victim = unit,
						attacker = self.caster,
						damage = parent.__fatalBondsTargetsDamage[unit] + damage,
						damage_type = DAMAGE_TYPE_PURE,
						damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
						ability = self.ability,
					})

					parent.__fatalBondsTargetsDamage[unit] = 0
				end
			end
		end
	end
end

if IsClient() then
	function modifier_fatal_bonds:OnTooltip()
		return self.damageSharePct
	end
end
