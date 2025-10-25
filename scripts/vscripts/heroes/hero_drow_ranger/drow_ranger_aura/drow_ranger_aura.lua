LinkLuaModifier("modifier_drow_ranger_aura", "heroes/hero_drow_ranger/drow_ranger_aura/drow_ranger_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_ranger_aura_buff", "heroes/hero_drow_ranger/drow_ranger_aura/drow_ranger_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_ranger_aura_debuff", "heroes/hero_drow_ranger/drow_ranger_aura/drow_ranger_aura", LUA_MODIFIER_MOTION_NONE)

drow_ranger_aura = class({})

function drow_ranger_aura:GetIntrinsicModifierName()
    return "modifier_drow_ranger_aura"
end

function drow_ranger_aura:OnUpgrade()
	if not IsServer() then return end

	local caster = self:GetCaster()

	local auraModifier = caster:FindModifierByName("modifier_drow_ranger_aura")

	if auraModifier then
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			auraModifier:GetAuraRadius() + 50,
			DOTA_UNIT_TARGET_TEAM_BOTH,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		for i = 1, #units do
			local unit = units[i]

			local auraBuffModifier = unit:FindModifierByName("modifier_drow_ranger_aura_buff")
			if auraBuffModifier then
				auraBuffModifier:OnRefresh()
			end

			local auraDebuffModifier = unit:FindModifierByName("modifier_drow_ranger_aura_debuff")
			if auraDebuffModifier then
				auraDebuffModifier:OnRefresh()
			end
		end
	end
end

modifier_drow_ranger_aura = class({})

function modifier_drow_ranger_aura:IsHidden() return true end
function modifier_drow_ranger_aura:IsPurgable() return false end
function modifier_drow_ranger_aura:IsAura() return true end
function modifier_drow_ranger_aura:GetModifierAura()
	return self.auraModifierName
end
function modifier_drow_ranger_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end
function modifier_drow_ranger_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end
function modifier_drow_ranger_aura:GetAuraRadius()
	return self.radius
end
function modifier_drow_ranger_aura:GetAuraEntityReject(target)
	return false
end
function modifier_drow_ranger_aura:GetAuraEntityReject(target)
    if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
        self.auraModifierName = "modifier_drow_ranger_aura_buff"
    else
        self.auraModifierName = "modifier_drow_ranger_aura_debuff"
    end
    return false
end
function modifier_drow_ranger_aura:IsAura()
	local caster = self:GetCaster()

	return not caster:PassivesDisabled() and not caster:IsIllusion()
end
function modifier_drow_ranger_aura:OnCreated()
	local ability = self:GetAbility()

	self.radius = ability:GetSpecialValueFor("AbilityCastRange")
end

modifier_drow_ranger_aura_buff = class({})

function modifier_drow_ranger_aura_buff:IsHidden() return false end
function modifier_drow_ranger_aura_buff:IsPurgable() return false end
function modifier_drow_ranger_aura_buff:IsDebuff() return false end
function modifier_drow_ranger_aura_buff:GetTexture() return "speedaura2" end
function modifier_drow_ranger_aura_buff:OnCreated()
	local ability = self:GetAbility()

	self.move_speed_buff = ability:GetSpecialValueFor("move_speed_buff") or 0
	self.attack_speed_pct_buff = ability:GetSpecialValueFor("attack_speed_pct_buff") or 0
end
function modifier_drow_ranger_aura_buff:OnRefresh()
	self:OnCreated()
end
function modifier_drow_ranger_aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end
function modifier_drow_ranger_aura_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed_buff
end
function modifier_drow_ranger_aura_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetCaster():GetAgility() / 100 * self.attack_speed_pct_buff
end
function modifier_drow_ranger_aura_buff:GetModifierPreAttack_BonusDamage(params)
	local caster = self:GetCaster()

	local agilityToDamageTalent = caster:FindAbilityByName("special_bonus_unique_drow_ranger_1")

	if not agilityToDamageTalent or agilityToDamageTalent:GetLevel() < 1 then return end

    return caster:GetAgility() / 100 * self.attack_speed_pct_buff
end

modifier_drow_ranger_aura_debuff = class({})

function modifier_drow_ranger_aura_debuff:IsHidden() return false end
function modifier_drow_ranger_aura_debuff:IsPurgable() return false end
function modifier_drow_ranger_aura_debuff:IsDebuff() return true end
function modifier_drow_ranger_aura_debuff:GetTexture() return "speedaura2" end
function modifier_drow_ranger_aura_debuff:OnCreated()
	local ability = self:GetAbility()

	self.attack_speed_debuff = ability:GetSpecialValueFor("attack_speed_debuff") or 0
end
function modifier_drow_ranger_aura_debuff:OnRefresh()
	self:OnCreated()
end
function modifier_drow_ranger_aura_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_drow_ranger_aura_debuff:GetModifierAttackSpeedBonus_Constant()
	return -self.attack_speed_debuff
end






























-- --------------------------------------------

-- modifier_drow_ranger_aura = class({})

-- function modifier_drow_ranger_aura:IsHidden()
-- 	return true
-- end

-- function modifier_drow_ranger_aura:IsDebuff()
-- 	return false
-- end

-- function modifier_drow_ranger_aura:IsPurgable()
-- 	return false
-- end

-- function modifier_drow_ranger_aura:OnCreated()
-- 	if self:GetCaster():IsIllusion() then return end
-- end

-- function modifier_drow_ranger_aura:IsAura()
-- 	return (not self:GetCaster():PassivesDisabled() and self:GetAbility():GetLevel() > 0)
-- end

-- function modifier_drow_ranger_aura:GetModifierAura()
-- 	return "modifier_drow_ranger_aura_effect"
-- end

-- function modifier_drow_ranger_aura:GetAuraRadius()
-- 	return 700
-- end

-- function modifier_drow_ranger_aura:GetAuraSearchTeam()
-- 	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
-- end

-- function modifier_drow_ranger_aura:GetAuraSearchType()
-- 	return DOTA_UNIT_TARGET_HERO
-- end

-- --------------------------------------

-- modifier_drow_ranger_positive_aura = class({})

-- function modifier_drow_ranger_positive_aura:IsHidden()
-- 	return false
-- end

-- function modifier_drow_ranger_positive_aura:IsDebuff()
-- 	return false
-- end

-- function modifier_drow_ranger_positive_aura:IsPurgable()
-- 	return false
-- end

-- function modifier_drow_ranger_positive_aura:OnCreated( kv )
-- 	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
-- end

-- function modifier_drow_ranger_positive_aura:OnRefresh( kv )
-- 	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
-- end

-- function modifier_drow_ranger_positive_aura:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
-- 		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
-- 	}
-- 	return funcs
-- end

-- function modifier_drow_ranger_positive_aura:GetModifierAttackSpeedBonus_Constant()
-- 	return self:GetCaster():GetAgility() / 100 * self.speed
-- end

-- modifier_drow_ranger_negative_aura = class({})

-- function modifier_drow_ranger_negative_aura:IsHidden()
-- 	return false
-- end

-- function modifier_drow_ranger_negative_aura:IsDebuff()
-- 	return true
-- end

-- function modifier_drow_ranger_negative_aura:IsPurgable()
-- 	return false
-- end

-- function modifier_drow_ranger_negative_aura:OnCreated( kv )
-- 	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
-- end

-- function modifier_drow_ranger_negative_aura:OnRefresh( kv )
-- 	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
-- end

-- function modifier_drow_ranger_negative_aura:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
-- 		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
-- 	}
-- 	return funcs
-- end

-- function modifier_drow_ranger_negative_aura:GetModifierAttackSpeedBonus_Constant()
-- 	return self:GetCaster():GetAgility() / 100 * self.speed
-- end