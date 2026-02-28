LinkLuaModifier("modifier_meepo_king_lua", "heroes/hero_meepo/meepo_king_lua/meepo_king_lua", LUA_MODIFIER_MOTION_NONE)
----------------------------------------------------------------------------

meepo_king_lua = class({})
local ability_class = meepo_king_lua

function ability_class:GetIntrinsicModifierName()
	return "modifier_meepo_king_lua"
end


modifier_meepo_king_lua = class({})

function modifier_meepo_king_lua:IsHidden()
	return true
end

function modifier_meepo_king_lua:IsDebuff()
	return false
end

function modifier_meepo_king_lua:IsPurgable()
	return false
end

function modifier_meepo_king_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	self.expa = self:GetAbility():GetSpecialValueFor('bonus_exp')
	self.dmg = self:GetAbility():GetSpecialValueFor('bonus_dmg')
	self.all = self:GetAbility():GetSpecialValueFor('bonus_all')
	self:StartIntervalThink(1)
end


function modifier_meepo_king_lua:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.expa = self:GetAbility():GetSpecialValueFor('bonus_exp')
	self.dmg = self:GetAbility():GetSpecialValueFor('bonus_dmg')
	self.all = self:GetAbility():GetSpecialValueFor('bonus_all')
	
	local talent_ability = self:GetCaster():FindAbilityByName("special_bonus_meepo_int4")
	if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		self.dmg = self:GetAbility():GetSpecialValueFor('bonus_dmg') + 15
		self.all = self:GetAbility():GetSpecialValueFor('bonus_all') + 15
	end
end


function modifier_meepo_king_lua:OnIntervalThink()
self:OnRefresh()
end


function modifier_meepo_king_lua:DeclareFunctions()
  local funcs = {
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE,
    }
	return funcs
end

----------------------------------------------------------------------------

function modifier_meepo_king_lua:GetModifierPercentageExpRateBoost( params )
	 return self:GetAbility():GetSpecialValueFor('bonus_exp')
end 

function modifier_meepo_king_lua:GetModifierBaseAttack_BonusDamage( params )
if not IsServer() then return end
	if self:GetCaster()==self:GetParent() then
		if self.lock2 then return end
		self.lock2 = true
		local dmg = self:GetCaster():GetBaseDamageMin()
		self.lock2 = false
		local bonusdmg = self.dmg*dmg/100
		return bonusdmg
	else
		local dmg = self:GetCaster():GetBaseDamageMin()
		dmg = 100/(100+self.dmg)*dmg
		local bonusdmg = self.dmg*dmg/100
		return bonusdmg
	end
end 

function modifier_meepo_king_lua:GetModifierBonusStats_Strength( params )
if not IsServer() then return end
	if self:GetCaster()==self:GetParent() then
		if self.lock1 then return end
		self.lock1 = true
		local str = self:GetCaster():GetStrength()
		self.lock1 = false
		local bonusstr = self.all*str/100
		return bonusstr
	else
		local str = self:GetCaster():GetStrength()
		str = 100/(100+self.all)*str
		local bonusstr = self.all*str/100
		return bonusstr
	end
end 

function modifier_meepo_king_lua:GetModifierBonusStats_Agility( params )
if not IsServer() then return end
	if self:GetCaster()==self:GetParent() then
		if self.lock1 then return end
		self.lock1 = true
		local agi = self:GetCaster():GetAgility()
		self.lock1 = false
		local bonusagi = self.all*agi/100
		return bonusagi
	else
		local agi = self:GetCaster():GetAgility()
		agi = 100/(100+self.all)*agi
		local bonusagi = self.all*agi/100
		return bonusagi
	end
end 

function modifier_meepo_king_lua:GetModifierBonusStats_Intellect( params )
	if not IsServer() then return end
	if self:GetCaster()==self:GetParent() then
		if self.lock1 then return end
		self.lock1 = true
		local int = self:GetCaster():GetIntellect(true)
		self.lock1 = false
		local bonusint = self.all*int/100
		return bonusint
	else
		local int = self:GetCaster():GetIntellect(true)
		int = 100/(100+self.all)*int
		local bonusint = self.all*int/100
		return bonusint
	end
end 

function modifier_meepo_king_lua:GetModifierModelScale()
    return self:GetAbility():GetSpecialValueFor('model_multiplier')
end