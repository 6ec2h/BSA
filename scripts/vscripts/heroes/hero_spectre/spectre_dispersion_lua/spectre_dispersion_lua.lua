LinkLuaModifier( "modifier_spectre_dispersion_lua", "heroes/hero_spectre/spectre_dispersion_lua/spectre_dispersion_lua" ,LUA_MODIFIER_MOTION_NONE )

spectre_dispersion_lua = class({})

function spectre_dispersion_lua:GetIntrinsicModifierName()
	return "modifier_spectre_dispersion_lua"
end

--------------------------------------------------------------------

modifier_spectre_dispersion_lua = class({})

function modifier_spectre_dispersion_lua:IsHidden()
	return self:GetStackCount() == 0
end

function modifier_spectre_dispersion_lua:IsDebuff()
	return false
end

function modifier_spectre_dispersion_lua:IsPurgable()
	return false
end

function modifier_spectre_dispersion_lua:AllowIllusionDuplicate()
	return true
end

function modifier_spectre_dispersion_lua:OnCreated()
	local ability = self:GetAbility()
	if ability then
		self.parent = self:GetParent()
		self.damageBlockPct = ability:GetSpecialValueFor("damage_reflection_pct")
		
		if IsServer() and not self.inited then
			self.inited = true
			self:OnIntervalThink()
			self:StartIntervalThink(ability:GetSpecialValueFor("damage_release_interval"))
		end
	end
end

function modifier_spectre_dispersion_lua:OnRefresh()
	self:OnCreated()
end

function modifier_spectre_dispersion_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_spectre_dispersion_lua:GetModifierIncomingDamage_Percentage()
	return -self.damageBlockPct
end

function modifier_spectre_dispersion_lua:OnTakeDamage(params)
	if not IsServer() then return end
	if params.unit ~= self.parent then return end
	if self.parent:PassivesDisabled() then return end
	if params.damage < 1 then return end
	local damage = params.damage
	local damageWithoutReduction = damage / (1 - self.damageBlockPct / 100)
	local addedDamage = damageWithoutReduction * self.damageBlockPct / 100
	self:SetStackCount(self:GetStackCount() + addedDamage)
end

function modifier_spectre_dispersion_lua:OnIntervalThink()
	if self:GetStackCount() < 1 then return end

	self:ReleaseDamage()
end

function modifier_spectre_dispersion_lua:ReleaseDamage()
	local nearEnemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("AbilityCastRange"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
	
	for i = 1, #nearEnemies do
		local enemy = nearEnemies[i]

		ApplyDamage({
			victim = enemy,
			attacker = self:GetCaster(),
			damage = self:GetStackCount(),
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		})
	end

	self:SetStackCount(0)
end(),
			damage = self.purge,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		}
		ApplyDamage(damageTable)
	end
end