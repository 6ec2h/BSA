LinkLuaModifier("modifier_necrolyte_heartstopper_aura_lua",  "abilities/bosses/final/necrolyte_heartstopper_aura_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_necrolyte_heartstopper_aura_lua_damage",  "abilities/bosses/final/necrolyte_heartstopper_aura_lua", LUA_MODIFIER_MOTION_NONE)

necrolyte_heartstopper_aura_lua = necrolyte_heartstopper_aura_lua or class({})

function necrolyte_heartstopper_aura_lua:GetIntrinsicModifierName()
	return "modifier_necrolyte_heartstopper_aura_lua"
end

--------------------------------------------------------------------

modifier_necrolyte_heartstopper_aura_lua = class({})

function modifier_necrolyte_heartstopper_aura_lua:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_necrolyte_heartstopper_aura_lua:GetAuraEntityReject(target)
	return false
end

function modifier_necrolyte_heartstopper_aura_lua:GetAuraRadius()
	return self.radius
end

function modifier_necrolyte_heartstopper_aura_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_necrolyte_heartstopper_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_necrolyte_heartstopper_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_necrolyte_heartstopper_aura_lua:GetModifierAura()
	return "modifier_necrolyte_heartstopper_aura_lua_damage"
end

function modifier_necrolyte_heartstopper_aura_lua:IsAura()
	if self:GetCaster():PassivesDisabled() then
		return false
	end
	return true
end

function modifier_necrolyte_heartstopper_aura_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_necrolyte_heartstopper_aura_lua:IsHidden()
	return false
end

function modifier_necrolyte_heartstopper_aura_lua:GetEffectName()
	return "particles/auras/aura_heartstopper.vpcf"
end

function modifier_necrolyte_heartstopper_aura_lua:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

----------------------------------------------------------------------

modifier_necrolyte_heartstopper_aura_lua_damage = modifier_necrolyte_heartstopper_aura_lua_damage or class({})


function modifier_necrolyte_heartstopper_aura_lua_damage:IsHidden()
	return false
end

function modifier_necrolyte_heartstopper_aura_lua_damage:IsDebuff()
	return true
end

function modifier_necrolyte_heartstopper_aura_lua_damage:IsPurgable()
	return false
end

function modifier_necrolyte_heartstopper_aura_lua_damage:OnCreated()
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.damage_pct = self:GetAbility():GetSpecialValueFor("damage")
		self:StartIntervalThink(0.1)
	end
end

function modifier_necrolyte_heartstopper_aura_lua_damage:OnIntervalThink()
	if IsServer() then
		if not self:GetCaster():PassivesDisabled() then
			local damage = (self:GetParent():GetMaxHealth() * self.damage_pct * 0.001)
			ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
		end
	end
end

function modifier_necrolyte_heartstopper_aura_lua_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE
	}
end

function modifier_necrolyte_heartstopper_aura_lua_damage:GetModifierHPRegenAmplify_Percentage()
	if self:GetAbility() ~= nil then
		return self:GetAbility():GetSpecialValueFor("heal_reduce_pct") * (-1)
	end
end