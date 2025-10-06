LinkLuaModifier("modifier_legion_ult", "heroes/hero_legion/legion_ult/legion_ult", LUA_MODIFIER_MOTION_NONE)

legion_ult = class({})

function legion_ult:GetIntrinsicModifierName()
	return "modifier_legion_ult"
end

function legion_ult:GetCooldown( level )
	return self.BaseClass.GetCooldown( self, level )
end

function legion_ult:IsRefreshable()
	return false 
end

----------------------------------------------------------------------------

modifier_legion_ult = class({})

function modifier_legion_ult:IsHidden()
	return true
end

function modifier_legion_ult:IsPurgable()
	return false
end

function modifier_legion_ult:RemoveOnDeath()
	return false
end

function modifier_legion_ult:GetTexture()
    return "legion_commander_duel"
end

function modifier_legion_ult:OnCreated( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self:StartIntervalThink(0.1)
end

function modifier_legion_ult:OnRefresh( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
end

function modifier_legion_ult:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() then
	if self:GetAbility():IsCooldownReady() then
	
		local talent_ability = self:GetCaster():FindAbilityByName("special_bonus_legion_commander_agi6")
		if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
			self.bonus_damage = 2
		end
	
		self:GetAbility():UseResources( false,false, false, true )
		self:GetCaster():SetModifierStackCount("modifier_legion_ult", self:GetCaster(), self:GetStackCount() + self.bonus_damage)
		end
	end
end

function modifier_legion_ult:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_legion_ult:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end