LinkLuaModifier('modifier_abaddon_borrowed_time_lua_active', "heroes/hero_abaddon/abaddon_borrowed_time_lua/abaddon_borrowed_time_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_abaddon_borrowed_time_lua_passive', "heroes/hero_abaddon/abaddon_borrowed_time_lua/abaddon_borrowed_time_lua", LUA_MODIFIER_MOTION_NONE)

abaddon_borrowed_time_lua = class({})

function abaddon_borrowed_time_lua:GetIntrinsicModifierName()
    return 'modifier_abaddon_borrowed_time_lua_passive'
end

function abaddon_borrowed_time_lua:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, 'modifier_abaddon_borrowed_time_lua_active', {duration = self:GetSpecialValueFor('duration')})
    self:GetCaster():EmitSound('Hero_Abaddon.BorrowedTime')
end

------------------------------------------------------------------------

modifier_abaddon_borrowed_time_lua_passive = class({})

function modifier_abaddon_borrowed_time_lua_passive:IsHidden()
	return true
end

function modifier_abaddon_borrowed_time_lua_passive:IsPurgable()
	return false
end

function modifier_abaddon_borrowed_time_lua_passive:IsPermanent()
	return true
end

function modifier_abaddon_borrowed_time_lua_passive:OnCreated()
	self.hp_threshold = self:GetAbility():GetSpecialValueFor('hp_threshold')
end

function modifier_abaddon_borrowed_time_lua_passive:DeclareFunctions()
	return {
            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
        }
end

function modifier_abaddon_borrowed_time_lua_passive:GetModifierIncomingDamage_Percentage(data)
    if self:GetParent():GetHealth() - data.damage <= self.hp_threshold and self:GetAbility():IsCooldownReady() and not self:GetParent():HasModifier("modifier_abaddon_aphotic_shield_lua") then 
		self:GetAbility():OnSpellStart()
		self:GetAbility():UseResources(false, false, false, true)
        return -100
    end
    return 0
end

---------------------------------------------------------------------------

modifier_abaddon_borrowed_time_lua_active = class({})

function modifier_abaddon_borrowed_time_lua_active:IsHidden()
	return false
end	

function modifier_abaddon_borrowed_time_lua_active:IsPurgable()
	return false
end

function modifier_abaddon_borrowed_time_lua_active:GetStatusEffectName()
	return 'particles/status_fx/status_effect_abaddon_borrowed_time.vpcf'
end

function modifier_abaddon_borrowed_time_lua_active:GetEffectName()
	return 'particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf'
end

function modifier_abaddon_borrowed_time_lua_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_abaddon_borrowed_time_lua_active:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_abaddon_borrowed_time_lua_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		-- MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_abaddon_borrowed_time_lua_active:GetModifierIncomingDamage_Percentage(data)
	if not IsServer() then return end
    self.parent:Heal(data.damage, self.parent)
    return -100
end

function modifier_abaddon_borrowed_time_lua_active:OnCreated()
    if not IsServer() then return end
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.caster:Purge(false, true, true, true, false)
end

