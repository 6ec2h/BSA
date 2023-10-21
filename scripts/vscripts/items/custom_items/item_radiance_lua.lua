item_radiance_lua1 = item_radiance_lua1 or class({})
item_radiance_lua2 = item_radiance_lua1 or class({})
item_radiance_lua3 = item_radiance_lua1 or class({})

LinkLuaModifier("modifier_item_radiance_lua", 'items/custom_items/item_radiance_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_radiance_aura_lua", 'items/custom_items/item_radiance_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_radiance_burn_lua", 'items/custom_items/item_radiance_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_radiance_lua1:GetIntrinsicModifierName()
	return "modifier_item_radiance_lua"
end

function item_radiance_lua1:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_item_radiance_aura_lua") then
		if self:GetAbilityName() == 'item_radiance_lua1' then
			return "radiance_lua1"
		elseif self:GetAbilityName() == 'item_radiance_lua2' then
			return "radiance_lua2"
		elseif self:GetAbilityName() == 'item_radiance_lua3' then
			return "radiance_lua3"
		end
	else
		return "radiance_off"
	end
end

function item_radiance_lua1:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_radiance_aura_lua", {})
	else
		self:GetCaster():RemoveModifierByName("modifier_item_radiance_aura_lua")
	end
end

------------------------------------------------------------------------------------------------

modifier_item_radiance_lua = class({})

function modifier_item_radiance_lua:IsHidden()		
	return true 
end
function modifier_item_radiance_lua:IsPurgable()		
	return false 
end
function modifier_item_radiance_lua:GetAttributes()	
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_item_radiance_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_radiance_lua:OnCreated()
	if not IsServer() then return end
	if not self:GetCaster():HasModifier("modifier_item_radiance_aura_lua") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_radiance_aura_lua", {})
	end
end

function modifier_item_radiance_lua:OnDestroy()
	if not IsServer() then return end
	if not self:GetCaster():HasModifier("modifier_item_radiance_lua") then
		self:GetCaster():RemoveModifierByName("modifier_item_radiance_aura_lua")
	end
end

function modifier_item_radiance_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_item_radiance_lua:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

-------------------------------------------------------------------

modifier_item_radiance_aura_lua = class({})

function modifier_item_radiance_aura_lua:IsAura()
	return true
end

function modifier_item_radiance_aura_lua:GetAuraRadius()
	return 700
end

function modifier_item_radiance_aura_lua:OnCreated()
end

function modifier_item_radiance_aura_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_radiance_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_radiance_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_radiance_aura_lua:GetModifierAura()
	return "modifier_item_radiance_burn_lua"
end

-----------------------------------------------------------

modifier_item_radiance_burn_lua = class({})

function modifier_item_radiance_burn_lua:OnCreated()
if not self:GetAbility() then self:Destroy() return end
	self.damage = self:GetAbility():GetSpecialValueFor("aura_damage")
	self.bonus_damage = 0
	
	if self:GetCaster():IsRealHero() then
		local attribute = self:GetCaster():GetPrimaryAttribute()
		if attribute == 3 then
			self.bonus_damage = (self:GetCaster():GetAgility() + self:GetCaster():GetIntellect() + self:GetCaster():GetStrength()) / 30
		elseif attribute == DOTA_ATTRIBUTE_AGILITY then
			self.bonus_damage = self:GetCaster():GetAgility() / 10
		elseif attribute == DOTA_ATTRIBUTE_STRENGTH then
			self.bonus_damage = self:GetCaster():GetStrength() / 10
		elseif attribute == DOTA_ATTRIBUTE_INTELLECT then
			self.bonus_damage = self:GetCaster():GetIntellect() / 10
		end
	end
	
	self.blind = self:GetAbility():GetSpecialValueFor("blind_pct")
	if self.particle == nil and self:GetCaster():IsRealHero() then
		self.particle = ParticleManager:CreateParticle("particles/items2_fx/radiance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
	self:StartIntervalThink(1)
end

function modifier_item_radiance_burn_lua:OnDestroy()
	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end	
end

function modifier_item_radiance_burn_lua:OnIntervalThink()
	if IsServer() then
		ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), damage = self.damage + self.bonus_damage, ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL})
	end
end

function modifier_item_radiance_burn_lua:DeclareFunctions()
	return {MODIFIER_PROPERTY_MISS_PERCENTAGE}
end

function modifier_item_radiance_burn_lua:GetModifierMiss_Percentage()
	return self.blind
end