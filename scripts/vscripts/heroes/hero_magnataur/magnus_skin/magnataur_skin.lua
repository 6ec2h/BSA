magnataur_skin = class({})
LinkLuaModifier( "modifier_magnataur_skin", "heroes/hero_magnataur/magnus_skin/magnataur_skin", LUA_MODIFIER_MOTION_NONE )


function magnataur_skin:GetIntrinsicModifierName()
	return "modifier_magnataur_skin"
end

modifier_magnataur_skin = class({})

function modifier_magnataur_skin:IsHidden()
	if self:GetParent():PassivesDisabled() then return true end
	return false
end

function modifier_magnataur_skin:IsPurgable()
	return false
end


function modifier_magnataur_skin:IsDebuff()
	return false
end


function modifier_magnataur_skin:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.bonus_resist = self:GetAbility():GetSpecialValueFor( "bonus_resist" )
	self:StartIntervalThink(1)
end

function modifier_magnataur_skin:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.bonus_resist = self:GetAbility():GetSpecialValueFor( "bonus_resist" )
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_magnus_agi1")~=nil then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_magnus_agi1"):GetLevel() > 0 then 
			self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" ) * 2
			self.bonus_resist = self:GetAbility():GetSpecialValueFor( "bonus_resist" ) * 2
		end
	end
end

function modifier_magnataur_skin:OnIntervalThink()
self:OnRefresh()
end

function modifier_magnataur_skin:OnRemoved()
end

function modifier_magnataur_skin:OnDestroy()
end

function modifier_magnataur_skin:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

function modifier_magnataur_skin:GetModifierPhysicalArmorBonus()
	if self:GetParent():PassivesDisabled() then return 0 end
	return self.bonus_armor 
end

function modifier_magnataur_skin:GetModifierMagicalResistanceBonus()
	if self:GetParent():PassivesDisabled() then return 0 end
	return self.bonus_resist 
end
	
--------------------------------------------------------------------------------
function modifier_magnataur_skin:IsAura()
	return self:GetParent()==self:GetCaster()
end

function modifier_magnataur_skin:GetModifierAura()
	return "modifier_magnataur_skin"
end

function modifier_magnataur_skin:GetAuraRadius()
	if self:GetParent():PassivesDisabled() then return 0 end
	return self.radius
end

function modifier_magnataur_skin:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_magnataur_skin:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end