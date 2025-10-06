LinkLuaModifier( "modifier_ancient_apparition_ice_blast_lua", "heroes/hero_ancient_apparition/ancient_apparition_ice_blast_lua/ancient_apparition_ice_blast_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ancient_apparition_ice_blast_lua_slow", "heroes/hero_ancient_apparition/ancient_apparition_ice_blast_lua/ancient_apparition_ice_blast_lua.lua", LUA_MODIFIER_MOTION_NONE )

ancient_apparition_ice_blast_lua = class({})

function ancient_apparition_ice_blast_lua:GetIntrinsicModifierName()
	return "modifier_ancient_apparition_ice_blast_lua"
end

-------------------------------------------------------------------------------

modifier_ancient_apparition_ice_blast_lua = class({})

function modifier_ancient_apparition_ice_blast_lua:IsHidden()
	return true
end

function modifier_ancient_apparition_ice_blast_lua:IsPurgable()
	return false
end

function modifier_ancient_apparition_ice_blast_lua:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_ancient_apparition_ice_blast_lua:OnAttackLanded( params )
	local caster = self:GetCaster()
	local target = params.target
	if params.attacker ~= self:GetParent() then return end
	
	target:AddNewModifier(caster, self:GetAbility(), "modifier_ancient_apparition_ice_blast_lua_slow", {duration = self:GetAbility():GetSpecialValueFor( "duration" )})
end

-----------------------------------------------------------------------------------

modifier_ancient_apparition_ice_blast_lua_slow = class({})

function modifier_ancient_apparition_ice_blast_lua_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_ancient_apparition_ice_blast_lua_slow:OnCreated()
	self.move_speed_slow = self:GetAbility():GetSpecialValueFor("slow") * (-1)
	self.damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():ExtraIntelligenceDamage() * self:GetAbility():GetSpecialValueFor("ExtraIntelligenceDamage")

	self:StartIntervalThink(0.5)
end

function modifier_ancient_apparition_ice_blast_lua_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}
end

function modifier_ancient_apparition_ice_blast_lua_slow:OnIntervalThink()
	if not IsServer() then return end
	ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
end

function modifier_ancient_apparition_ice_blast_lua_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed_slow
end

function modifier_ancient_apparition_ice_blast_lua_slow:GetDisableHealing()
	return 1
end

