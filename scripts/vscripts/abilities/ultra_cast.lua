ultra_cast = class({})

LinkLuaModifier( "modifier_ultra_cast", "abilities/ultra_cast", LUA_MODIFIER_MOTION_NONE )

function ultra_cast:GetIntrinsicModifierName()
	return "modifier_ultra_cast"
end
----------------------------------------------------------------------------------------------------------------

modifier_ultra_cast = class({})

function modifier_ultra_cast:IsHidden()
	return true
end

function modifier_ultra_cast:OnCreated( kv )
	self:StartIntervalThink(self:GetRandomInterval())
end

function modifier_ultra_cast:IsPurgable()
	return false
end

function modifier_ultra_cast:GetRandomInterval()
	return RandomInt(60, 120)
end

function modifier_ultra_cast:OnIntervalThink() 
	if not IsServer() then return end
	local caster = self:GetCaster()
	local abilityNames = {
		"silencer_global_silence",
		"custom_solar_flare2",
		"thundergods_wrath_datadriven",
		"custom_statick",
		"custom_mine",
		"custom_rosh",
		"custom_stun"
	}

	local ability = caster:FindAbilityByName(abilityNames[RandomInt(1, #abilityNames)])
	if ability then
		ability:OnSpellStart()
	end
	
	self:StartIntervalThink(-1)
	self:StartIntervalThink(self:GetRandomInterval())
end

function modifier_ultra_cast:IsPurgable()
    return false
end

function modifier_ultra_cast:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
	}
	return state
end