LinkLuaModifier( "modifier_hoodwink_scurry_lua_buff", "heroes/hero_hoodwink/hoodwink_scurry_lua/hoodwink_scurry_lua", LUA_MODIFIER_MOTION_NONE )

hoodwink_scurry_lua = class({})

function hoodwink_scurry_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )
	caster:AddNewModifier(caster, self, "modifier_hoodwink_scurry_lua_buff", {duration = duration})
end

---------------------------------------------------------

modifier_hoodwink_scurry_lua_buff = class({})

function modifier_hoodwink_scurry_lua_buff:IsHidden()
	return false
end

function modifier_hoodwink_scurry_lua_buff:IsPurgable()
	return false
end

function modifier_hoodwink_scurry_lua_buff:OnCreated( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movement_speed_pct" )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
	
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_hoodwink_2")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.evasion = self.evasion + 16
	end
	
	if not IsServer() then return end
	EmitSoundOn( "Hero_Hoodwink.Scurry.Cast", self:GetParent() )
end

function modifier_hoodwink_scurry_lua_buff:OnRefresh( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movement_speed_pct" )	
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_hoodwink_2")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.evasion = self.evasion + 16
	end
end

function modifier_hoodwink_scurry_lua_buff:OnRemoved()
end

function modifier_hoodwink_scurry_lua_buff:OnDestroy()
	if not IsServer() then return end
	EmitSoundOn( "Hero_Hoodwink.Scurry.End", self:GetParent() )
end

function modifier_hoodwink_scurry_lua_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return funcs
end

function modifier_hoodwink_scurry_lua_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end

function modifier_hoodwink_scurry_lua_buff:GetModifierEvasion_Constant()
	return self.evasion
end

function modifier_hoodwink_scurry_lua_buff:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
	}
	return state
end

function modifier_hoodwink_scurry_lua_buff:GetEffectName()
	return "particles/units/heroes/hero_hoodwink/hoodwink_scurry_aura.vpcf"
end

function modifier_hoodwink_scurry_lua_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end