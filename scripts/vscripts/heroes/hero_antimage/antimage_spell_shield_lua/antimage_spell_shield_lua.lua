antimage_spell_shield_lua = class({})
LinkLuaModifier( "modifier_antimage_spell_shield_lua", "heroes/hero_antimage/antimage_spell_shield_lua/antimage_spell_shield_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_spell_shield_lua_effect", "heroes/hero_antimage/antimage_spell_shield_lua/antimage_spell_shield_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function antimage_spell_shield_lua:GetIntrinsicModifierName()
	return "modifier_antimage_spell_shield_lua"
end

--------------------------------------------------------------------------------
modifier_antimage_spell_shield_lua = class({})

function modifier_antimage_spell_shield_lua:IsHidden()
	return true
end

function modifier_antimage_spell_shield_lua:IsDebuff()
	return false
end

function modifier_antimage_spell_shield_lua:IsPurgable()
	return false
end

function modifier_antimage_spell_shield_lua:OnCreated( kv )
	self.bonus = self:GetAbility():GetSpecialValueFor("bonus_resist_pct")
	self:StartIntervalThink(1)
end

function modifier_antimage_spell_shield_lua:OnRefresh( kv )
	self.bonus = self:GetAbility():GetSpecialValueFor("bonus_resist_pct")
	local talent_ability = self:GetCaster():FindAbilityByName("npc_dota_hero_antimage_int3")
	if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		self.bonus = self:GetAbility():GetSpecialValueFor("bonus_resist_pct") * 1.5
	end
end

function modifier_antimage_spell_shield_lua:OnIntervalThink()
self:OnRefresh()
end

function modifier_antimage_spell_shield_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_ABSORB_SPELL,
	}
	return funcs
end

function modifier_antimage_spell_shield_lua:GetModifierMagicalResistanceBonus( params )
	if not self:GetParent():PassivesDisabled() then
		return self.bonus
	end
end

function modifier_antimage_spell_shield_lua:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_antimage_spell_shield_lua:GetModifierAura()
	return "modifier_antimage_spell_shield_lua_effect"
end

function modifier_antimage_spell_shield_lua:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_antimage_spell_shield_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_antimage_spell_shield_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

----------------------------------------------------------------------------------------
modifier_antimage_spell_shield_lua_effect = class({})

function modifier_antimage_spell_shield_lua_effect:IsHidden()
	return false
end

function modifier_antimage_spell_shield_lua_effect:IsDebuff()
	return false
end

function modifier_antimage_spell_shield_lua_effect:IsPurgable()
	return false
end

function modifier_antimage_spell_shield_lua_effect:OnCreated( kv )
	self.bonus_resist_pct_enemy = self:GetAbility():GetSpecialValueFor( "bonus_resist_pct_enemy" )
	self:StartIntervalThink(1)
end

function modifier_antimage_spell_shield_lua_effect:OnRefresh( kv )
	self.bonus_resist_pct_enemy = self:GetAbility():GetSpecialValueFor( "bonus_resist_pct_enemy" )
	local talent_ability = self:GetCaster():FindAbilityByName("npc_dota_hero_antimage_int3")
	if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		self.bonus_resist_pct_enemy = self:GetAbility():GetSpecialValueFor("bonus_resist_pct_enemy") * 1.5
	end
end

function modifier_antimage_spell_shield_lua_effect:OnIntervalThink()
self:OnRefresh()
end

function modifier_antimage_spell_shield_lua_effect:OnDestroy( kv )

end

function modifier_antimage_spell_shield_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

function modifier_antimage_spell_shield_lua_effect:GetModifierMagicalResistanceBonus( params )
	if not self:GetParent():PassivesDisabled() then
		return self.bonus_resist_pct_enemy
	end
end