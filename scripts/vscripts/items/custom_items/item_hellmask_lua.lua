LinkLuaModifier("modifier_hellmask_lua", "items/custom_items/item_hellmask_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hellmask_lua_aura_positive", "items/custom_items/item_hellmask_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hellmask_lua_aura_positive_effect", "items/custom_items/item_hellmask_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hellmask_lua_aura_negative", "items/custom_items/item_hellmask_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hellmask_lua_aura_negative_effect", "items/custom_items/item_hellmask_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hellmask_lua_active", "items/custom_items/item_hellmask_lua", LUA_MODIFIER_MOTION_NONE)

item_hellmask_lua_1 = item_hellmask_lua_1 or class({})
item_hellmask_lua_2 = item_hellmask_lua_1 or class({})
item_hellmask_lua_3 = item_hellmask_lua_1 or class({})

function item_hellmask_lua_1:GetIntrinsicModifierName()
	return "modifier_hellmask_lua"
end

function item_hellmask_lua_1:OnSpellStart()
	self:GetCaster():Purge(false, true, false, false, false)
	EmitSoundOn("DOTA_Item.Satanic.Activate", self:GetCaster())
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_hellmask_lua_active", {duration = self:GetSpecialValueFor("unholy_duration")})
end

---------------------------------------------------
modifier_hellmask_lua_active = class({})

function modifier_hellmask_lua_active:IsPurgable() return false end

function modifier_hellmask_lua_active:GetEffectName()
	return "particles/items2_fx/satanic_buff.vpcf"
end

function modifier_hellmask_lua_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

---------------------------------------------------

modifier_hellmask_lua = class({})

function modifier_hellmask_lua:IsHidden()		return true end
function modifier_hellmask_lua:IsPurgable()		return false end
function modifier_hellmask_lua:RemoveOnDeath()	return false end
function modifier_hellmask_lua:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_hellmask_lua:OnCreated()
	self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_percent")
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	if not IsServer() then return end
	
	if not self:GetCaster():HasModifier("modifier_hellmask_lua_aura_positive") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hellmask_lua_aura_positive", {})
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hellmask_lua_aura_negative", {})
	end
end

function modifier_hellmask_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end


function modifier_hellmask_lua:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end


function modifier_hellmask_lua:OnAttackLanded( params )
	if IsServer() then
	local attacker = self:GetParent()	
	if attacker ~= params.attacker then
		return
	end
		if attacker:HasModifier("modifier_hellmask_lua_active") then
			heal = params.damage * 2
		else
			heal = params.damage * self.lifesteal_aura/100
		end
		self:GetParent():Heal( heal, self:GetAbility() )
		self:PlayEffects( self:GetParent() )
	end
end

function modifier_hellmask_lua:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_hellmask_lua:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_strength")
	end
end

function modifier_hellmask_lua:GetModifierAttackSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end
end

function modifier_hellmask_lua:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end
end

function modifier_hellmask_lua:OnDestroy()
	if IsServer() then
		if not self:GetCaster():HasModifier("modifier_hellmask_lua") then
			self:GetCaster():RemoveModifierByName("modifier_hellmask_lua_aura_positive")
			self:GetCaster():RemoveModifierByName("modifier_hellmask_lua_aura_negative")
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------

modifier_hellmask_lua_aura_positive = class({})

function modifier_hellmask_lua_aura_positive:IsDebuff() return false end
function modifier_hellmask_lua_aura_positive:AllowIllusionDuplicate() return true end
function modifier_hellmask_lua_aura_positive:IsHidden() return true end
function modifier_hellmask_lua_aura_positive:IsPurgable() return false end

function modifier_hellmask_lua_aura_positive:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end

function modifier_hellmask_lua_aura_positive:GetAuraEntityReject(target)
	return false
end

function modifier_hellmask_lua_aura_positive:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_hellmask_lua_aura_positive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_hellmask_lua_aura_positive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_hellmask_lua_aura_positive:GetModifierAura()
	return "modifier_hellmask_lua_aura_positive_effect"
end

function modifier_hellmask_lua_aura_positive:IsAura()
	return true
end

---------------------------------------------------------------------------------------------------------------------------------------

modifier_hellmask_lua_aura_positive_effect = class({})

function modifier_hellmask_lua_aura_positive_effect:OnCreated()
	if not self:GetAbility() then
		if IsServer() then
			self:Destroy()
		end

		return
	end

	self.aura_as_ally = self:GetAbility():GetSpecialValueFor("aura_attack_speed")
	self.aura_armor_ally = self:GetAbility():GetSpecialValueFor("aura_positive_armor")
end

function modifier_hellmask_lua_aura_positive_effect:IsHidden() return false end
function modifier_hellmask_lua_aura_positive_effect:IsPurgable() return false end
function modifier_hellmask_lua_aura_positive_effect:IsDebuff() return false end

function modifier_hellmask_lua_aura_positive_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_hellmask_lua_aura_positive_effect:GetModifierAttackSpeedBonus_Constant()
	return self.aura_as_ally
end

function modifier_hellmask_lua_aura_positive_effect:GetModifierPhysicalArmorBonus()
	return self.aura_armor_ally
end

-------------------------------------------------------------------------------------------------------------------------------------

modifier_hellmask_lua_aura_negative = class({})

function modifier_hellmask_lua_aura_negative:IsDebuff() return false end
function modifier_hellmask_lua_aura_negative:AllowIllusionDuplicate() return true end
function modifier_hellmask_lua_aura_negative:IsHidden() return true end
function modifier_hellmask_lua_aura_negative:IsPurgable() return false end

function modifier_hellmask_lua_aura_negative:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end

function modifier_hellmask_lua_aura_negative:GetAuraEntityReject(target)
	return false
end

function modifier_hellmask_lua_aura_negative:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_hellmask_lua_aura_negative:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_hellmask_lua_aura_negative:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_hellmask_lua_aura_negative:GetModifierAura()
	return "modifier_hellmask_lua_aura_negative_effect"
end

function modifier_hellmask_lua_aura_negative:IsAura()
	return true
end

------------------------------------------------------------------------------------------------------------------------------------------

modifier_hellmask_lua_aura_negative_effect = class({})

function modifier_hellmask_lua_aura_negative_effect:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.aura_armor_reduction_enemy = self:GetAbility():GetSpecialValueFor("aura_negative_armor") * (-1)
end

function modifier_hellmask_lua_aura_negative_effect:IsHidden() return false end
function modifier_hellmask_lua_aura_negative_effect:IsPurgable() return false end
function modifier_hellmask_lua_aura_negative_effect:IsDebuff() return true end

function modifier_hellmask_lua_aura_negative_effect:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_hellmask_lua_aura_negative_effect:GetModifierPhysicalArmorBonus()
	return self.aura_armor_reduction_enemy
end
