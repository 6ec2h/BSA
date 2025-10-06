LinkLuaModifier("modifier_undying_flesh_golem_lua", "heroes/hero_undying/undying_flesh_golem_lua/undying_flesh_golem_lua", LUA_MODIFIER_MOTION_NONE)

undying_flesh_golem_lua = class({})

function undying_flesh_golem_lua:OnSpellStart()
self:GetCaster():EmitSound("Hero_Undying.FleshGolem.Cast")
	self.mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_undying_flesh_golem_lua", {duration = self:GetSpecialValueFor("duration")})
end

----------------------------------------------------

modifier_undying_flesh_golem_lua = class({})

function modifier_undying_flesh_golem_lua:IsHidden()
    return false
end

function modifier_undying_flesh_golem_lua:IsDebuff()
    return false
end

function modifier_undying_flesh_golem_lua:IsPurgable()
    return false
end

function modifier_undying_flesh_golem_lua:IsPurgeException()
    return false
end

function modifier_undying_flesh_golem_lua:OnCreated()
    if not IsServer() then
        return
    end
    self:GetParent():StartGesture(ACT_DOTA_SPAWN)
end

function modifier_undying_flesh_golem_lua:OnRefresh()
    self:OnCreated()
end

function modifier_undying_flesh_golem_lua:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_undying_flesh_golem_lua:GetModifierBonusStats_Strength()
    if self:GetParent().calc_str then
        return 0 
    end
	self:GetParent().calc_str = true
	
	self.str = self:GetAbility():GetSpecialValueFor("str_percentage")
	local ability = self:GetCaster():FindAbilityByName("special_bonus_undying_2")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.str = self.str + 15
	end
	
    local s = self:GetCaster():GetStrength() * self.str / 100
	self:GetParent().calc_str = false
    return s
end

function modifier_undying_flesh_golem_lua:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_undying_flesh_golem_lua:GetModifierTotalDamageOutgoing_Percentage()
	self.damage_increace = self:GetAbility():GetSpecialValueFor("damage_increace")
	local ability = self:GetCaster():FindAbilityByName("special_bonus_undying_5")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.damage_increace = self.damage_increace + 10
	end
	
    return self.damage_increace
end

function modifier_undying_flesh_golem_lua:GetModifierModelChange()
    return "models/heroes/undying/undying_flesh_golem.vmdl"
end
