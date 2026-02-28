modifier_crystal_maiden_arcane_aura_lua_effect = class({})

function modifier_crystal_maiden_arcane_aura_lua_effect:IsHidden()
	return false
end

function modifier_crystal_maiden_arcane_aura_lua_effect:IsDebuff()
	return false
end

function modifier_crystal_maiden_arcane_aura_lua_effect:IsPurgable()
	return false
end

function modifier_crystal_maiden_arcane_aura_lua_effect:OnCreated( kv )
	self.regen_self = self:GetAbility():GetSpecialValueFor( "mana_regen_self" ) -- special value
	self.regen_ally = self:GetAbility():GetSpecialValueFor( "mana_regen" ) -- special value
end

function modifier_crystal_maiden_arcane_aura_lua_effect:OnRefresh( kv )
	self.regen_self = self:GetAbility():GetSpecialValueFor( "mana_regen_self" ) -- special value
	self.regen_ally = self:GetAbility():GetSpecialValueFor( "mana_regen" ) -- special value
end

function modifier_crystal_maiden_arcane_aura_lua_effect:OnDestroy( kv )

end

function modifier_crystal_maiden_arcane_aura_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}

	return funcs
end

function modifier_crystal_maiden_arcane_aura_lua_effect:GetModifierConstantManaRegen()
	if self:GetParent()==self:GetCaster() then return self.regen_self end
	return self.regen_ally
end

function modifier_crystal_maiden_arcane_aura_lua_effect:GetModifierSpellAmplify_Percentage()
	if self:GetParent()==self:GetCaster() then return self:GetCaster():GetLevel() * self:GetAbility():GetSpecialValueFor( "ampl" ) end
	return self:GetCaster():GetLevel() * self:GetAbility():GetSpecialValueFor( "ampl" ) / 2
end
