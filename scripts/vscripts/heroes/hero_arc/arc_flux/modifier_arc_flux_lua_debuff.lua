modifier_arc_flux_lua_debuff = class({})


function modifier_arc_flux_lua_debuff:IsHidden()
	return false
end

function modifier_arc_flux_lua_debuff:IsDebuff()
	return true
end

function modifier_arc_flux_lua_debuff:IsStunDebuff()
	return false
end

function modifier_arc_flux_lua_debuff:IsPurgable()
	return false
end

function modifier_arc_flux_lua_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end


function modifier_arc_flux_lua_debuff:OnCreated( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" ) * (-1)
	self.attackspeed = self:GetAbility():GetSpecialValueFor( "attackspeed" ) * (-1)
	
	local abil = self:GetCaster():FindAbilityByName("special_bonus_arc_warden_str8")
	if abil ~= nil and abil:IsTrained() then
	self.movespeed = self.movespeed*3
	self.attackspeed = self.attackspeed*3
	end

	if not IsServer() then return end
end


function modifier_arc_flux_lua_debuff:OnRefresh( kv )	
end

function modifier_arc_flux_lua_debuff:OnRemoved()
end

function modifier_arc_flux_lua_debuff:OnDestroy()
end

function modifier_arc_flux_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_arc_flux_lua_debuff:GetModifierMoveSpeedBonus_Constant()
	return self.movespeed
end

function modifier_arc_flux_lua_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end