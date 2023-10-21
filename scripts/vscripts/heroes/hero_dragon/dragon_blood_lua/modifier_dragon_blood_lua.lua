modifier_dragon_blood_lua = class({})

function modifier_dragon_blood_lua:IsHidden()
	return true
end

function modifier_dragon_blood_lua:IsDebuff()
	return false
end

function modifier_dragon_blood_lua:IsPurgable()
	return false
end

function modifier_dragon_blood_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	local level = self.caster:GetLevel()
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" ) * level
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" ) * level
	self:StartIntervalThink(0.5)
end

function modifier_dragon_blood_lua:OnRefresh( kv )
	self.caster = self:GetCaster()
	local level = self.caster:GetLevel()
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" ) * level
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" ) * level
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_str11")~=nil then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_str11"):GetLevel() > 0 then 
			self.regen = self.regen * 2
			self.armor = self.armor * 2
		end
	end
end

function modifier_dragon_blood_lua:OnIntervalThink()
self:OnRefresh()
end


function modifier_dragon_blood_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_dragon_blood_lua:GetModifierConstantHealthRegen()
	if not self:GetParent():PassivesDisabled() then
		return self.regen
	end
end

function modifier_dragon_blood_lua:GetModifierPhysicalArmorBonus()
	if not self:GetParent():PassivesDisabled() then
		return self.armor
	end
end


-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------