modifier_crystal_maiden_crystal_nova_lua = class({})

function modifier_crystal_maiden_crystal_nova_lua:IsHidden()
	return false
end

function modifier_crystal_maiden_crystal_nova_lua:IsDebuff()
	return true
end

function modifier_crystal_maiden_crystal_nova_lua:IsPurgable()
	return true
end

function modifier_crystal_maiden_crystal_nova_lua:OnCreated( kv )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "attackspeed_slow" ) -- special value
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" ) -- special value
end

function modifier_crystal_maiden_crystal_nova_lua:OnRefresh( kv )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "attackspeed_slow" ) -- special value
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" ) -- special value	
end

function modifier_crystal_maiden_crystal_nova_lua:OnDestroy( kv )
end

function modifier_crystal_maiden_crystal_nova_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return funcs
end

function modifier_crystal_maiden_crystal_nova_lua:GetModifierMagicalResistanceBonus()
	if self:GetCaster():FindAbilityByName("npc_crystal_maiden_1")~=nil then
		if self:GetCaster():FindAbilityByName("npc_crystal_maiden_1"):GetLevel() > 0 then 
			return -15
		end
	end	
	return 0
end

function modifier_crystal_maiden_crystal_nova_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_crystal_maiden_crystal_nova_lua:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow
end

function modifier_crystal_maiden_crystal_nova_lua:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_crystal_maiden_crystal_nova_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end