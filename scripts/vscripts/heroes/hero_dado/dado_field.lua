LinkLuaModifier("modifier_dado_field", "heroes/hero_dado/dado_field", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dado_field_debuff", "heroes/hero_dado/dado_field", LUA_MODIFIER_MOTION_NONE)

dado_field = class({})

function dado_field:IsStealable() return true end
function dado_field:IsHiddenWhenStolen() return false end
function dado_field:GetAOERadius()
	local rand = RandomInt(1,350)
	return self:GetSpecialValueFor("radius") + rand
end

function dado_field:GetManaCost(iLevel)
	local talent = self:GetCaster():FindAbilityByName("special_bonus_dado_tal2")
	if talent ~= nil and talent:GetLevel() > 0 then 
		return self:GetCaster():GetMaxMana() * 15 * 0.01
	end
	return self:GetCaster():GetMaxMana() * 33 * 0.01
end

function dado_field:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	CreateModifierThinker(caster, self, "modifier_dado_field", {duration = duration}, point, caster:GetTeamNumber(), false)
    EmitSoundOn("Hero_Enigma.Midnight_Pulse", caster)
end

---------------------------------------------------------------------------------------------------------------------

modifier_dado_field = class({})

function modifier_dado_field:IsHidden() return true end
function modifier_dado_field:IsDebuff() return false end
function modifier_dado_field:IsPurgable() return false end
function modifier_dado_field:IsPurgeException() return false end
function modifier_dado_field:RemoveOnDeath() return true end
function modifier_dado_field:IsAura() return true end
function modifier_dado_field:IsAuraActiveOnDeath() return false end

function modifier_dado_field:GetAuraEntityReject(hEntity)
    if IsServer() then
    end
end

function modifier_dado_field:GetAuraRadius()
    return self.radius
end

function modifier_dado_field:GetAuraSearchFlags()
    return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_dado_field:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_dado_field:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end

function modifier_dado_field:GetModifierAura()
    return "modifier_dado_field_debuff"
end

function modifier_dado_field:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.radius = self:GetAbility():GetAOERadius()
    _G.dadoult_radius = self.radius
    if IsServer() then
		self.particle_time = ParticleManager:CreateParticle("particles/dado_chronosphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
							ParticleManager:SetParticleControl(self.particle_time, 0, self.parent:GetAbsOrigin())
							ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))

        self:AddParticle(self.particle_time, false, false, -1, false, false)
    end
end

---------------------------------------------------------------------------------------------------------------------

modifier_dado_field_debuff = class({})

function modifier_dado_field_debuff:IsHidden() return true end
function modifier_dado_field_debuff:IsDebuff() return true end
function modifier_dado_field_debuff:IsPurgable() return true end
function modifier_dado_field_debuff:IsPurgeException() return true end
function modifier_dado_field_debuff:RemoveOnDeath() return true end

function modifier_dado_field_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_dado_field_debuff:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.radius = (_G.dadoult_radius - 50)/350
	if IsServer() then
		self.dot_damage_min = self.ability:GetSpecialValueFor("dot_damage") + self:GetCaster():ExtraIntelligenceDamage() * self.ability:GetSpecialValueFor("ExtraIntelligenceDamage") 
		self.dot_damage_max = self.ability:GetSpecialValueFor("dot_damage_max") + self:GetCaster():ExtraIntelligenceDamage() * self.ability:GetSpecialValueFor("ExtraIntelligenceDamage") 
		self.dot_interval = self.ability:GetSpecialValueFor("dot_interval")
		
		local talent = self:GetCaster():FindAbilityByName("special_bonus_dado_tal4")
		if talent ~= nil and talent:GetLevel() > 0 then 
			self.dot_damage_min = self.dot_damage_min + 60
			self.dot_damage_max = self.dot_damage_max + 180
		end
		
		local damageRange = self.dot_damage_max - self.dot_damage_min
		self.damage = self.dot_damage_max - (damageRange * self.radius)

		
		self:StartIntervalThink(self.dot_interval)
	end
end

function modifier_dado_field_debuff:OnIntervalThink()
	if IsServer() then
        local damage_table = {  victim = self.parent,
                                attacker = self.caster,
                                damage = self.damage,
                                damage_type = self.ability:GetAbilityDamageType(),
                                ability = self.ability }
        ApplyDamage(damage_table)
        EmitSoundOn("Ability.PlasmaFieldImpact", self.parent)
    end
end
