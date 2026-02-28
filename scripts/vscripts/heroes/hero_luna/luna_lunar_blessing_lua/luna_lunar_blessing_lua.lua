LinkLuaModifier( "modifier_luna_lunar_blessing_lua", "heroes/hero_luna/luna_lunar_blessing_lua/luna_lunar_blessing_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_luna_lunar_blessing_lua_effect", "heroes/hero_luna/luna_lunar_blessing_lua/luna_lunar_blessing_lua", LUA_MODIFIER_MOTION_NONE )

luna_lunar_blessing_lua = class({})

function luna_lunar_blessing_lua:GetIntrinsicModifierName()
	return "modifier_luna_lunar_blessing_lua"
end

function luna_lunar_blessing_lua:GetCastRange()
	if not IsClient() then return end
	
	return self:GetCaster():FindAbilityByName("special_bonus_unique_luna_1"):GetLevel() > 0 and self:GetSpecialValueFor("radius")
end

---------------------------------------------------------------------

modifier_luna_lunar_blessing_lua = class({})

function modifier_luna_lunar_blessing_lua:IsHidden()
	return true 
end

function modifier_luna_lunar_blessing_lua:IsDebuff()
	return false
end

function modifier_luna_lunar_blessing_lua:IsPurgable()
	return false
end

function modifier_luna_lunar_blessing_lua:IsAura()
	local caster = self:GetCaster()

	return not caster:PassivesDisabled() and not caster:IsIllusion()
end

function modifier_luna_lunar_blessing_lua:GetModifierAura()
	return "modifier_luna_lunar_blessing_lua_effect"
end

function modifier_luna_lunar_blessing_lua:GetAuraRadius()
	return self.radius
end

function modifier_luna_lunar_blessing_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_luna_lunar_blessing_lua:GetAuraEntityReject(unit)
	if unit == self:GetCaster() then
		return false
	end

	return self.auraTalent:GetLevel() < 1
end

function modifier_luna_lunar_blessing_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_luna_lunar_blessing_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_luna_lunar_blessing_lua:OnCreated()
	self.auraTalent = self:GetCaster():FindAbilityByName("special_bonus_unique_luna_1")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

-------------------------------------------------------------------------------

modifier_luna_lunar_blessing_lua_effect = class({})

function modifier_luna_lunar_blessing_lua_effect:IsHidden() return false end
function modifier_luna_lunar_blessing_lua_effect:IsDebuff()	return false end
function modifier_luna_lunar_blessing_lua_effect:IsPurgable() return false end
function modifier_luna_lunar_blessing_lua_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_luna_lunar_blessing_lua_effect:OnCreated()
    if not IsServer() then return end

	self.bonusNightVision = self:GetAbility():GetSpecialValueFor("bonus_night_vision")
	self.attributesMult = self:GetAbility():GetSpecialValueFor("attributes_pct") / 100

    self:SetHasCustomTransmitterData(true)

	self:StartIntervalThink(0.1)
end
function modifier_luna_lunar_blessing_lua_effect:OnRefresh()
	self:OnCreated()
end

local attributesMap = {
	[DOTA_ATTRIBUTE_STRENGTH] = function(self, hero)
		self.strengthBonus = (hero:GetAgility() + hero:GetIntellect(true)) * self.attributesMult
		self.agilityBonus = 0
		self.intelligenceBonus = 0
	end,
	[DOTA_ATTRIBUTE_AGILITY] = function(self, hero)
		self.strengthBonus = 0
		self.agilityBonus = (hero:GetStrength() + hero:GetIntellect(true)) * self.attributesMult
		self.intelligenceBonus = 0
	end,
	[DOTA_ATTRIBUTE_INTELLECT] = function(self, hero)
		self.strengthBonus = 0
		self.agilityBonus = 0
		self.intelligenceBonus = (hero:GetStrength() + hero:GetAgility()) * self.attributesMult
	end,
	[-1] = function(self, hero)
		local strngth, agility, intelligence = hero:GetStrength(), hero:GetAgility(), hero:GetIntellect(true)

		self.strengthBonus = (agility + intelligence) * self.attributesMult * .5
		self.agilityBonus = (strngth + intelligence) * self.attributesMult * .5
		self.intelligenceBonus = (strngth + agility) * self.attributesMult * .5
	end,
}

function modifier_luna_lunar_blessing_lua_effect:OnIntervalThink()
    if not IsServer() then return end

	local parent = self:GetParent()

	local primary = parent:GetPrimaryAttribute()

	self.statsLock = true
	;(attributesMap[primary] or attributesMap[-1])(self, parent)
	self.statsLock = nil

    self:SendBuffRefreshToClients()
end

function modifier_luna_lunar_blessing_lua_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_luna_lunar_blessing_lua_effect:GetBonusNightVision()
	return self.bonusNightVision
end

function modifier_luna_lunar_blessing_lua_effect:AddCustomTransmitterData()
    return {
        strengthBonus = self.strengthBonus,
        agilityBonus = self.agilityBonus,
        intelligenceBonus = self.intelligenceBonus,
    }
end

function modifier_luna_lunar_blessing_lua_effect:HandleCustomTransmitterData( data )
    self.strengthBonus = data.strengthBonus
    self.agilityBonus = data.agilityBonus
	self.intelligenceBonus = data.intelligenceBonus
end

function modifier_luna_lunar_blessing_lua_effect:GetModifierBonusStats_Strength()
	return not self.statsLock and self.strengthBonus
end
function modifier_luna_lunar_blessing_lua_effect:GetModifierBonusStats_Agility()
	return not self.statsLock and self.agilityBonus
end
function modifier_luna_lunar_blessing_lua_effect:GetModifierBonusStats_Intellect()
	return not self.statsLock and self.intelligenceBonus
end
