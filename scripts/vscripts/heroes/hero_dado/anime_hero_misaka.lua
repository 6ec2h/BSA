--AnimeCreateEmptyTalents("misaka")

LinkLuaModifier("modifier_misaka_field", "heroes/hero_dado/anime_hero_misaka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_misaka_field_debuff", "heroes/hero_dado/anime_hero_misaka", LUA_MODIFIER_MOTION_NONE)

misaka_field = class({})

function misaka_field:IsStealable() return true end
function misaka_field:IsHiddenWhenStolen() return false end
function misaka_field:GetAOERadius()
randomradius = RandomInt(1,350)
	return self:GetSpecialValueFor("radius") + randomradius
end

function misaka_field:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dado_tal2") ~= nil then 
		if self:GetCaster():FindAbilityByName("npc_dota_hero_dado_tal2"):GetLevel() > 0 then 
			return self:GetCaster():GetMaxMana() * 15 * 0.01
		end
	end
	return self:GetCaster():GetMaxMana() * 33 * 0.01
end

function misaka_field:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")

	CreateModifierThinker(caster, self, "modifier_misaka_field", {duration = duration}, point, caster:GetTeamNumber(), false)

    EmitSoundOn("Hero_Enigma.Midnight_Pulse", caster)
end
---------------------------------------------------------------------------------------------------------------------
modifier_misaka_field = class({})
function modifier_misaka_field:IsHidden() return true end
function modifier_misaka_field:IsDebuff() return false end
function modifier_misaka_field:IsPurgable() return false end
function modifier_misaka_field:IsPurgeException() return false end
function modifier_misaka_field:RemoveOnDeath() return true end
function modifier_misaka_field:IsAura() return true end
function modifier_misaka_field:IsAuraActiveOnDeath() return false end
function modifier_misaka_field:GetAuraEntityReject(hEntity)
    if IsServer() then
    end
end
function modifier_misaka_field:GetAuraRadius()
    return self.radius
end
function modifier_misaka_field:GetAuraSearchFlags()
    return self:GetAbility():GetAbilityTargetFlags()
end
function modifier_misaka_field:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end
function modifier_misaka_field:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end
function modifier_misaka_field:GetModifierAura()
    return "modifier_misaka_field_debuff"
end
function modifier_misaka_field:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.radius = self:GetAbility():GetAOERadius()
    
    if IsServer() then
        self.particle_time =    ParticleManager:CreateParticle("particles/dado_chronosphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                ParticleManager:SetParticleControl(self.particle_time, 0, self.parent:GetAbsOrigin())
                                ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))

        self:AddParticle(self.particle_time, false, false, -1, false, false)

        --self:StartIntervalThink(FrameTime())
    end
end
function modifier_misaka_field:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_misaka_field:OnIntervalThink()
    if IsServer() then

    end
end
---------------------------------------------------------------------------------------------------------------------
modifier_misaka_field_debuff = class({})
function modifier_misaka_field_debuff:IsHidden() return true end
function modifier_misaka_field_debuff:IsDebuff() return true end
function modifier_misaka_field_debuff:IsPurgable() return true end
function modifier_misaka_field_debuff:IsPurgeException() return true end
function modifier_misaka_field_debuff:RemoveOnDeath() return true end
function modifier_misaka_field_debuff:DeclareFunctions()
	local func = {
					MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, }
	return func
end

function modifier_misaka_field_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow_stack * self:GetStackCount() * (-1)
end
function modifier_misaka_field_debuff:OnCreated(table)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.dot_interval 	= self.ability:GetSpecialValueFor("dot_interval")
	self.dot_damage 	= self.ability:GetSpecialValueFor("dot_damage") + ((350 - randomradius)/4)
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dado_tal4") ~= nil then 
		if self:GetCaster():FindAbilityByName("npc_dota_hero_dado_tal4"):GetLevel() > 0 then 
			self.dot_damage = self.dot_damage * 2
		end
	end

	self.slow_stack = self.ability:GetSpecialValueFor("slow_stack")

	if IsServer() then
		self:IncrementStackCount()

		local field_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		self:AddParticle(field_fx, false, false, -1, true, true)

		self:StartIntervalThink(self.dot_interval)
	end
end
function modifier_misaka_field_debuff:OnRefresh(table)
	--if IsServer() then
		self:OnCreated(table)
	--end
end
function modifier_misaka_field_debuff:OnIntervalThink()
	if IsServer() then
        local damage_table = {  victim = self.parent,
                                attacker = self.caster,
                                damage = self.dot_damage,
                                damage_type = self.ability:GetAbilityDamageType(),
                                ability = self.ability }

        ApplyDamage(damage_table)

        self:IncrementStackCount()

        EmitSoundOn("Ability.PlasmaFieldImpact", self.parent)
    end
end
