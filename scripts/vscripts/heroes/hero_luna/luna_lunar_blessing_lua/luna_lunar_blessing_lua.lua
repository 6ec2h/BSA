LinkLuaModifier( "modifier_luna_lunar_blessing_lua", "heroes/hero_luna/luna_lunar_blessing_lua/luna_lunar_blessing_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_luna_lunar_blessing_lua_effect", "heroes/hero_luna/luna_lunar_blessing_lua/luna_lunar_blessing_lua", LUA_MODIFIER_MOTION_NONE )

luna_lunar_blessing_lua = class({})

function luna_lunar_blessing_lua:GetIntrinsicModifierName()
	return "modifier_luna_lunar_blessing_lua"
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
	return (not self:GetCaster():PassivesDisabled() and self:GetAbility():GetLevel() > 0)
end

function modifier_luna_lunar_blessing_lua:GetModifierAura()
	return "modifier_luna_lunar_blessing_lua_effect"
end

function modifier_luna_lunar_blessing_lua:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_luna_lunar_blessing_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_luna_lunar_blessing_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_luna_lunar_blessing_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

-------------------------------------------------------------------------------

modifier_luna_lunar_blessing_lua_effect = class({})

function modifier_luna_lunar_blessing_lua_effect:IsHidden()
	return false
end

function modifier_luna_lunar_blessing_lua_effect:IsDebuff()
	return false
end

function modifier_luna_lunar_blessing_lua_effect:IsPurgable()
	return false
end

function modifier_luna_lunar_blessing_lua_effect:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end


function modifier_luna_lunar_blessing_lua_effect:OnCreated( kv )
	self.bonus_night_vision = self:GetAbility():GetSpecialValueFor( "bonus_night_vision" )
	self:StartIntervalThink(0.1)
end

function modifier_luna_lunar_blessing_lua_effect:OnRefresh( kv )
	self.bonus_night_vision = self:GetAbility():GetSpecialValueFor( "bonus_night_vision" )
end

function modifier_luna_lunar_blessing_lua_effect:OnIntervalThink()
    if not IsServer() then return end
		local primary = self:GetParent():GetPrimaryAttribute()
		if primary==DOTA_ATTRIBUTE_STRENGTH then
			self.strength = 1
			self.agility = 0
			self.intelligence = 0
		elseif primary==DOTA_ATTRIBUTE_AGILITY then
			self.strength = 0
			self.agility = 1
			self.intelligence = 0
		elseif primary==DOTA_ATTRIBUTE_INTELLECT then
			self.strength = 0
			self.agility = 0
			self.intelligence = 1
		else
			self.strength = 0.5
			self.agility = 0.5
			self.intelligence = 0.5
		end
	 
	bonus = 0
	local talent = self:GetCaster():FindAbilityByName("npc_dota_hero_luna_str10")
	if talent ~= nil and talent:GetLevel() > 0 then 
		bonus = 18
	end

	self.agi = ((self:GetCaster():GetBaseIntellect() +  self:GetCaster():GetBaseStrength()) / 4) * self.agility
	self.int = ((self:GetCaster():GetBaseAgility() +  self:GetCaster():GetBaseStrength()) / 4) * self.intelligence
	self.str = ((self:GetCaster():GetBaseAgility() +  self:GetCaster():GetBaseIntellect()) / 4) * self.strength

	self.primary_attribute_bonus = (self:GetAbility():GetSpecialValueFor( "primary_attribute" ) + bonus ) / 100
	
	self.agi_parent = self:GetParent():GetBaseAgility() * self.primary_attribute_bonus * self.agility
	self.int_parent = self:GetParent():GetBaseIntellect() * self.primary_attribute_bonus * self.intelligence
	self.str_parent = self:GetParent():GetBaseStrength() * self.primary_attribute_bonus * self.strength
	
	self:GetParent():CalculateStatBonus(true)
end

function modifier_luna_lunar_blessing_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifier_luna_lunar_blessing_lua_effect:GetBonusNightVision()
	return self.bonus_night_vision
end

if IsServer() then
	function modifier_luna_lunar_blessing_lua_effect:GetModifierBonusStats_Agility()
		if self:GetParent():PassivesDisabled() then return 0 end
		if self:GetParent()==self:GetCaster() then return self.agi end
		if self:GetParent()~=self:GetCaster() then return self.agi_parent end
	end
	
	function modifier_luna_lunar_blessing_lua_effect:GetModifierBonusStats_Intellect()
		if self:GetParent():PassivesDisabled() then return 0 end
		if  self:GetParent()==self:GetCaster() then return self.int end
		if  self:GetParent()~=self:GetCaster() then return self.int_parent end
	end
	
	function modifier_luna_lunar_blessing_lua_effect:GetModifierBonusStats_Strength()
		if self:GetParent():PassivesDisabled() then return 0 end
		if self:GetParent()==self:GetCaster() then return self.str end
		if self:GetParent()~=self:GetCaster() then return self.str_parent end
	end
end

